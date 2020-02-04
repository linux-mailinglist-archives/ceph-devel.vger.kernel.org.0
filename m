Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2D6E15142F
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2020 03:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgBDC2q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Feb 2020 21:28:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37089 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726561AbgBDC2q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Feb 2020 21:28:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580783324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7RsxogvD+klAePNOhE06UUAlGXGz3GW+VOjoH1rsAnw=;
        b=WcGtNu+LEvcp5yPfmetKqs1uBUAGawCTwXIW4rPJ3jzw0HHDbv3q2pkL4U2TKE/HROq0d/
        NidAodGzBzVFLHISH9J1NaI28LBSX7PUXstON+M9SYQZ80KCN69LnZhwt+q7oe3/hTKzNA
        +gz02wcaLedFxYMWHgXiiOc0iGEZIdk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-g6srfOjCMSGj_wuWmmHf_Q-1; Mon, 03 Feb 2020 21:28:42 -0500
X-MC-Unique: g6srfOjCMSGj_wuWmmHf_Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4160613EA;
        Tue,  4 Feb 2020 02:28:41 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9634989A9A;
        Tue,  4 Feb 2020 02:28:33 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, hch@infradead.org,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [RFC PATCH v2] ceph: do not execute direct write in parallel if O_APPEND is specified
Date:   Mon,  3 Feb 2020 21:28:25 -0500
Message-Id: <20200204022825.26538-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

In O_APPEND & O_DIRECT mode, the data from different writers will
be possiblly overlapping each other with shared lock.

For example, both Writer1 and Writer2 are in O_APPEND and O_DIRECT
mode:

          Writer1                         Writer2

     shared_lock()                   shared_lock()
     getattr(CAP_SIZE)               getattr(CAP_SIZE)
     iocb->ki_pos =3D EOF              iocb->ki_pos =3D EOF
     write(data1)
                                     write(data2)
     shared_unlock()                 shared_unlock()

The data2 will overlap the data1 from the same file offset, the
old EOF.

Switch to exclusive lock instead when O_APPEND is specified.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

Changed in V2:
- fix the commit comment
- add more detail in the commit comment
- s/direct_lock/shared_lock/g

 fs/ceph/file.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index ac7fe8b8081c..e3e67ef215dd 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1475,6 +1475,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, =
struct iov_iter *from)
 	struct ceph_cap_flush *prealloc_cf;
 	ssize_t count, written =3D 0;
 	int err, want, got;
+	bool shared_lock =3D false;
 	loff_t pos;
 	loff_t limit =3D max(i_size_read(inode), fsc->max_file_size);
=20
@@ -1485,8 +1486,11 @@ static ssize_t ceph_write_iter(struct kiocb *iocb,=
 struct iov_iter *from)
 	if (!prealloc_cf)
 		return -ENOMEM;
=20
+	if ((iocb->ki_flags & (IOCB_DIRECT | IOCB_APPEND)) =3D=3D IOCB_DIRECT)
+		shared_lock =3D true;
+
 retry_snap:
-	if (iocb->ki_flags & IOCB_DIRECT)
+	if (shared_lock)
 		ceph_start_io_direct(inode);
 	else
 		ceph_start_io_write(inode);
@@ -1576,14 +1580,15 @@ static ssize_t ceph_write_iter(struct kiocb *iocb=
, struct iov_iter *from)
=20
 		/* we might need to revert back to that point */
 		data =3D *from;
-		if (iocb->ki_flags & IOCB_DIRECT) {
+		if (iocb->ki_flags & IOCB_DIRECT)
 			written =3D ceph_direct_read_write(iocb, &data, snapc,
 							 &prealloc_cf);
-			ceph_end_io_direct(inode);
-		} else {
+		else
 			written =3D ceph_sync_write(iocb, &data, pos, snapc);
+		if (shared_lock)
+			ceph_end_io_direct(inode);
+		else
 			ceph_end_io_write(inode);
-		}
 		if (written > 0)
 			iov_iter_advance(from, written);
 		ceph_put_snap_context(snapc);
@@ -1634,7 +1639,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, =
struct iov_iter *from)
=20
 	goto out_unlocked;
 out:
-	if (iocb->ki_flags & IOCB_DIRECT)
+	if (shared_lock)
 		ceph_end_io_direct(inode);
 	else
 		ceph_end_io_write(inode);
--=20
2.21.0


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B821914ED7F
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2020 14:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgAaNgg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Jan 2020 08:36:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36977 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728614AbgAaNgg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 31 Jan 2020 08:36:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580477795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/F47d0SzVr8o+Ycv4z+t6t4fJRvq2fjyAxFm0REePFs=;
        b=GhDNou90Z7+k1HYYuiLqc6IQb6CH0/58IfB5Zd6MsEPSJFIrjaDUjU6vUDAchnJFJ0blR5
        jqYfCzfTJKZR7ecFQE5zmnc9AbeVq/HU2mwzCpF/S8RN/sFHr691kkO01eVO8dS9LrcXNf
        FWlQqPn3f37bscVml4RpTjF+kxGm8Rg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-qyRP7qmtNkyhSYIc36NWkA-1; Fri, 31 Jan 2020 08:36:30 -0500
X-MC-Unique: qyRP7qmtNkyhSYIc36NWkA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 486EE18FE87F;
        Fri, 31 Jan 2020 13:36:29 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6882C8477C;
        Fri, 31 Jan 2020 13:36:23 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [RFC PATCH] ceph: do not direct write executes in parallel if O_APPEND is set
Date:   Fri, 31 Jan 2020 08:36:19 -0500
Message-Id: <20200131133619.14209-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

In O_APPEND & O_DIRECT mode, the data from different writers will
be possiblly overlapping each other. Just use the exclusive clock
instead in O_APPEND & O_DIRECT mode.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 77f8e58cbb99..1cedba452a66 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1443,6 +1443,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, =
struct iov_iter *from)
 	struct ceph_cap_flush *prealloc_cf;
 	ssize_t count, written =3D 0;
 	int err, want, got;
+	bool direct_lock =3D false;
 	loff_t pos;
 	loff_t limit =3D max(i_size_read(inode), fsc->max_file_size);
=20
@@ -1453,8 +1454,11 @@ static ssize_t ceph_write_iter(struct kiocb *iocb,=
 struct iov_iter *from)
 	if (!prealloc_cf)
 		return -ENOMEM;
=20
+	if ((iocb->ki_flags & (IOCB_DIRECT | IOCB_APPEND)) =3D=3D IOCB_DIRECT)
+		direct_lock =3D true;
+
 retry_snap:
-	if (iocb->ki_flags & IOCB_DIRECT)
+	if (direct_lock)
 		ceph_start_io_direct(inode);
 	else
 		ceph_start_io_write(inode);
@@ -1544,14 +1548,15 @@ static ssize_t ceph_write_iter(struct kiocb *iocb=
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
+		if (direct_lock)
+			ceph_end_io_direct(inode);
+		else
 			ceph_end_io_write(inode);
-		}
 		if (written > 0)
 			iov_iter_advance(from, written);
 		ceph_put_snap_context(snapc);
@@ -1602,7 +1607,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, =
struct iov_iter *from)
=20
 	goto out_unlocked;
 out:
-	if (iocb->ki_flags & IOCB_DIRECT)
+	if (direct_lock)
 		ceph_end_io_direct(inode);
 	else
 		ceph_end_io_write(inode);
--=20
2.21.0


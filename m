Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4874B151412
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2020 02:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgBDBzE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Feb 2020 20:55:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46988 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726369AbgBDBzE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Feb 2020 20:55:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580781303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QS0+Kf438tAtfdozjM63Nrji59szzW6bu4vgTpxcLzM=;
        b=DXmsTlJOM/gNhPC9bur2lCHLYhlaACjByuPL5ehroiBaPF1S3qqYQIWSaBaVnh3XyW/exQ
        MoEzhWYOoJtBfAZtr2QjN8VQsLstfIPOulmg3k1uQS22QEM0xR+aAKZVQ7AaebOaNrK7cF
        NHhmp++FBr+Af6aeyvFr+k8SkO8m1kk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-JmIFHAStMB-TXspKSk4-MQ-1; Mon, 03 Feb 2020 20:55:01 -0500
X-MC-Unique: JmIFHAStMB-TXspKSk4-MQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1610D477;
        Tue,  4 Feb 2020 01:55:00 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF1E090F63;
        Tue,  4 Feb 2020 01:54:54 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [RFC PATCH] ceph: serialize the direct writes when couldn't submit in a single req
Date:   Mon,  3 Feb 2020 20:54:45 -0500
Message-Id: <20200204015445.4435-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

If the direct io couldn't be submit in a single request, for multiple
writers, they may overlap each other.

For example, with the file layout:
ceph.file.layout=3D"stripe_unit=3D4194304 stripe_count=3D1 object_size=3D=
4194304

fd =3D open(, O_DIRECT | O_WRONLY, );

Writer1:
posix_memalign(&buffer, 4194304, SIZE);
memset(buffer, 'T', SIZE);
write(fd, buffer, SIZE);

Writer2:
posix_memalign(&buffer, 4194304, SIZE);
memset(buffer, 'X', SIZE);
write(fd, buffer, SIZE);

From the test result, the data in the file possiblly will be:
TTT...TTT <---> object1
XXX...XXX <---> object2

The expected result should be all "XX.." or "TT.." in both object1
and object2.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c  | 38 +++++++++++++++++++++++++++++++++++---
 fs/ceph/inode.c |  2 ++
 fs/ceph/super.h |  3 +++
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 1cedba452a66..2741070a58a9 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -961,6 +961,8 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov=
_iter *iter,
 	loff_t pos =3D iocb->ki_pos;
 	bool write =3D iov_iter_rw(iter) =3D=3D WRITE;
 	bool should_dirty =3D !write && iter_is_iovec(iter);
+	bool shared_lock =3D false;
+	u64 size;
=20
 	if (write && ceph_snap(file_inode(file)) !=3D CEPH_NOSNAP)
 		return -EROFS;
@@ -977,14 +979,27 @@ ceph_direct_read_write(struct kiocb *iocb, struct i=
ov_iter *iter,
 			dout("invalidate_inode_pages2_range returned %d\n", ret2);
=20
 		flags =3D /* CEPH_OSD_FLAG_ORDERSNAP | */ CEPH_OSD_FLAG_WRITE;
+
+		/*
+		 * If we cannot submit the whole iter in a single request we
+		 * should block all the requests followed to avoid the data
+		 * being overlapped by each other.
+		 *
+		 * But for those which could be submit in an single request
+		 * they could excute in parallel.
+		 *
+		 * Hold the exclusive lock first.
+		 */
+		down_write(&ci->i_direct_rwsem);
 	} else {
 		flags =3D CEPH_OSD_FLAG_READ;
 	}
=20
 	while (iov_iter_count(iter) > 0) {
-		u64 size =3D iov_iter_count(iter);
 		ssize_t len;
=20
+		size =3D iov_iter_count(iter);
+
 		if (write)
 			size =3D min_t(u64, size, fsc->mount_options->wsize);
 		else
@@ -1011,9 +1026,16 @@ ceph_direct_read_write(struct kiocb *iocb, struct =
iov_iter *iter,
 			ret =3D len;
 			break;
 		}
+
 		if (len !=3D size)
 			osd_req_op_extent_update(req, 0, len);
=20
+		if (write && pos =3D=3D iocb->ki_pos && len =3D=3D count) {
+			/* Switch to shared lock */
+			downgrade_write(&ci->i_direct_rwsem);
+			shared_lock =3D true;
+		}
+
 		/*
 		 * To simplify error handling, allow AIO when IO within i_size
 		 * or IO can be satisfied by single OSD request.
@@ -1110,7 +1132,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct i=
ov_iter *iter,
=20
 		if (aio_req->num_reqs =3D=3D 0) {
 			kfree(aio_req);
-			return ret;
+			goto unlock;
 		}
=20
 		ceph_get_cap_refs(ci, write ? CEPH_CAP_FILE_WR :
@@ -1131,13 +1153,23 @@ ceph_direct_read_write(struct kiocb *iocb, struct=
 iov_iter *iter,
 				ceph_aio_complete_req(req);
 			}
 		}
-		return -EIOCBQUEUED;
+		ret =3D -EIOCBQUEUED;
+		goto unlock;
 	}
=20
 	if (ret !=3D -EOLDSNAPC && pos > iocb->ki_pos) {
 		ret =3D pos - iocb->ki_pos;
 		iocb->ki_pos =3D pos;
 	}
+
+unlock:
+	if (write) {
+		if (shared_lock)
+			up_read(&ci->i_direct_rwsem);
+		else
+			up_write(&ci->i_direct_rwsem);
+	}
+
 	return ret;
 }
=20
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index aee7a24bf1bc..e5d634acd273 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -518,6 +518,8 @@ struct inode *ceph_alloc_inode(struct super_block *sb=
)
=20
 	ceph_fscache_inode_init(ci);
=20
+	init_rwsem(&ci->i_direct_rwsem);
+
 	ci->i_meta_err =3D 0;
=20
 	return &ci->vfs_inode;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index ee81920bb1a4..213c11bf41be 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -409,6 +409,9 @@ struct ceph_inode_info {
 	struct fscache_cookie *fscache;
 	u32 i_fscache_gen;
 #endif
+
+	struct rw_semaphore i_direct_rwsem;
+
 	errseq_t i_meta_err;
=20
 	struct inode vfs_inode; /* at end */
--=20
2.21.0


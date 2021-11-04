Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CA8444E8A
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Nov 2021 06:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhKDF43 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Nov 2021 01:56:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41166 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230410AbhKDF4Z (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 Nov 2021 01:56:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636005228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZAzzRKRRwxkB4D9xzhRB2vzaeLtUmnNO03clKL79CVw=;
        b=foqw2lt2t3wDAb6HXCJPYEqs2QgyVQBNkK6Xnv0FWES/RVY/f3Jnq+yMLY8YzLsJsu8WOl
        o444jU0vuFgow6KdXjsCZVHoQSXx4a1IpQbxFdSoCMAlQNPvjyNM9nO9LxHVW1eXwntZbD
        krxQJszjkpm+IJ9GIoh0t37oe4eNes0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-VBlhLYqXPAaEAtw-LwRnAw-1; Thu, 04 Nov 2021 01:53:44 -0400
X-MC-Unique: VBlhLYqXPAaEAtw-LwRnAw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A29FEC1A0;
        Thu,  4 Nov 2021 05:53:43 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0180D2B399;
        Thu,  4 Nov 2021 05:53:40 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v6 8/9] ceph: add object version support for sync read
Date:   Thu,  4 Nov 2021 13:52:47 +0800
Message-Id: <20211104055248.190987-9-xiubli@redhat.com>
In-Reply-To: <20211104055248.190987-1-xiubli@redhat.com>
References: <20211104055248.190987-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The sync read may split the read into several osdc requests, so
for each it may in different Rados objects.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c  | 44 ++++++++++++++++++++++++++++++++++++++++++--
 fs/ceph/super.h | 18 +++++++++++++++++-
 2 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 129f6a642f8e..cedd86a6058d 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -871,7 +871,8 @@ enum {
  * only return a short read to the caller if we hit EOF.
  */
 ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
-			 struct iov_iter *to, int *retry_op)
+			 struct iov_iter *to, int *retry_op,
+			 struct ceph_object_vers *objvers)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
@@ -880,6 +881,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 	u64 off = *ki_pos;
 	u64 len = iov_iter_count(to);
 	u64 i_size;
+	u32 object_count = 8;
 
 	dout("sync_read on inode %p %llu~%u\n", inode, *ki_pos, (unsigned)len);
 
@@ -896,6 +898,15 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 	if (ret < 0)
 		return ret;
 
+	if (objvers) {
+		objvers->count = 0;
+		objvers->objvers = kcalloc(object_count,
+					   sizeof(struct ceph_object_ver),
+					   GFP_KERNEL);
+		if (!objvers->objvers)
+			return -ENOMEM;
+	}
+
 	ret = 0;
 	while ((len = iov_iter_count(to)) > 0) {
 		struct ceph_osd_request *req;
@@ -938,6 +949,30 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 					 req->r_end_latency,
 					 len, ret);
 
+		if (objvers) {
+			u32 ind = objvers->count;
+
+			if (objvers->count >= object_count) {
+				int ov_size;
+
+				object_count *= 2;
+				ov_size = sizeof(struct ceph_object_ver);
+				objvers->objvers = krealloc_array(objvers,
+								  object_count,
+								  ov_size,
+								  GFP_KERNEL);
+				if (!objvers->objvers) {
+					objvers->count = 0;
+					ret = -ENOMEM;
+					break;
+				}
+			}
+
+			objvers->objvers[ind].offset = off;
+			objvers->objvers[ind].length = len;
+			objvers->objvers[ind].objver = req->r_version;
+			objvers->count++;
+		}
 		ceph_osdc_put_request(req);
 
 		i_size = i_size_read(inode);
@@ -995,6 +1030,11 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 	}
 
 	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);
+	if (ret < 0 && objvers) {
+		objvers->count = 0;
+		kfree(objvers->objvers);
+		objvers->objvers = NULL;
+	}
 	return ret;
 }
 
@@ -1008,7 +1048,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 	     (unsigned)iov_iter_count(to),
 	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
 
-	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op);
+	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op, NULL);
 }
 
 struct ceph_aio_request {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 2362d758af97..b347b12e86a9 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -451,6 +451,21 @@ struct ceph_inode_info {
 	struct inode vfs_inode; /* at end */
 };
 
+/*
+ * The version of an object which contains the
+ * file range of [offset, offset + length).
+ */
+struct ceph_object_ver {
+	u64 offset;
+	u64 length;
+	u64 objver;
+};
+
+struct ceph_object_vers {
+	u32 count;
+	struct ceph_object_ver *objvers;
+};
+
 static inline struct ceph_inode_info *
 ceph_inode(const struct inode *inode)
 {
@@ -1254,7 +1269,8 @@ extern int ceph_open(struct inode *inode, struct file *file);
 extern int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 			    struct file *file, unsigned flags, umode_t mode);
 extern ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
-				struct iov_iter *to, int *retry_op);
+				struct iov_iter *to, int *retry_op,
+				struct ceph_object_vers *objvers);
 extern int ceph_release(struct inode *inode, struct file *filp);
 extern void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
 				  char *data, size_t len);
-- 
2.27.0


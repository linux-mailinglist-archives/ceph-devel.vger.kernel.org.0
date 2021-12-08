Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5C446D389
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Dec 2021 13:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbhLHMtX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Dec 2021 07:49:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233631AbhLHMtW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Dec 2021 07:49:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638967549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qFHIeZYHPWHp8k86pjj5tVB25jMRA46x/WxcdlyEstY=;
        b=CDMlYYHMbxv0QhHInWGij2TXI9dfL51NEnaJYqvnjobMtFfkNhe+rFty4ONRb/KyYslawB
        nKb7pOJ1Aifshqkji0BV/rKYGwi20Mxe2+/JUVbS/Qog4n/BjOLFX8K5Yfl74YccLj774d
        7XXaZV7wvtn4Jca69Z8KsyyeNhGo5HE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-603-P3qYhhuQMS2r5sEGnpTV1w-1; Wed, 08 Dec 2021 07:45:46 -0500
X-MC-Unique: P3qYhhuQMS2r5sEGnpTV1w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76B201926DA0;
        Wed,  8 Dec 2021 12:45:45 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A880260C05;
        Wed,  8 Dec 2021 12:45:42 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v7 8/9] ceph: add object version support for sync read
Date:   Wed,  8 Dec 2021 20:45:27 +0800
Message-Id: <20211208124528.679831-2-xiubli@redhat.com>
In-Reply-To: <20211208124528.679831-1-xiubli@redhat.com>
References: <20211208124528.679831-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Always return the last object's version.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c  | 8 ++++++--
 fs/ceph/super.h | 3 ++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index b42158c9aa16..9279b8642add 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -883,7 +883,8 @@ enum {
  * only return a short read to the caller if we hit EOF.
  */
 ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
-			 struct iov_iter *to, int *retry_op)
+			 struct iov_iter *to, int *retry_op,
+			 u64 *last_objver)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
@@ -950,6 +951,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 					 req->r_end_latency,
 					 len, ret);
 
+		if (last_objver)
+			*last_objver = req->r_version;
+
 		ceph_osdc_put_request(req);
 
 		i_size = i_size_read(inode);
@@ -1020,7 +1024,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 	     (unsigned)iov_iter_count(to),
 	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
 
-	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op);
+	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op, NULL);
 }
 
 struct ceph_aio_request {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 84fec46308b0..a7bdb28af595 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1258,7 +1258,8 @@ extern int ceph_open(struct inode *inode, struct file *file);
 extern int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 			    struct file *file, unsigned flags, umode_t mode);
 extern ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
-				struct iov_iter *to, int *retry_op);
+				struct iov_iter *to, int *retry_op,
+				u64 *last_objver);
 extern int ceph_release(struct inode *inode, struct file *filp);
 extern void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
 				  char *data, size_t len);
-- 
2.27.0


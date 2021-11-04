Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F68444E89
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Nov 2021 06:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhKDF41 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Nov 2021 01:56:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38566 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231129AbhKDF4W (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 Nov 2021 01:56:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636005225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PUYbmL6CclEet7vAjscxCDgBYxpZp9y1hVGL8/bxh5c=;
        b=RhS8lPc4U4lox8eMu2SUtgDvND6sp5sWrVeTTkW+Iph27ZdJ303vrKB2cPopja09vcwP8n
        BP+jRb36VKrCQ2C4iwm4gwejM2qvGuBfrA73/nqbebURkymUDR9MTVJCQfjsTe5/Qx9ZYq
        r2qSFETbb1MR34qdjjek7MBS39/o8Eo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-o_VHAMPuPB2DxTcMLpswqg-1; Thu, 04 Nov 2021 01:53:41 -0400
X-MC-Unique: o_VHAMPuPB2DxTcMLpswqg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AB1619200C0;
        Thu,  4 Nov 2021 05:53:40 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FCB21B472;
        Thu,  4 Nov 2021 05:53:37 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v6 7/9] ceph: add __ceph_sync_read helper support
Date:   Thu,  4 Nov 2021 13:52:46 +0800
Message-Id: <20211104055248.190987-8-xiubli@redhat.com>
In-Reply-To: <20211104055248.190987-1-xiubli@redhat.com>
References: <20211104055248.190987-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c  | 34 ++++++++++++++++++++++------------
 fs/ceph/super.h |  2 ++
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 8c0b9ed7f48b..129f6a642f8e 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -870,21 +870,18 @@ enum {
  * If we get a short result from the OSD, check against i_size; we need to
  * only return a short read to the caller if we hit EOF.
  */
-static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
-			      int *retry_op)
+ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
+			 struct iov_iter *to, int *retry_op)
 {
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file_inode(file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_osd_client *osdc = &fsc->client->osdc;
 	ssize_t ret;
-	u64 off = iocb->ki_pos;
+	u64 off = *ki_pos;
 	u64 len = iov_iter_count(to);
 	u64 i_size;
 
-	dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
-	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
+	dout("sync_read on inode %p %llu~%u\n", inode, *ki_pos, (unsigned)len);
 
 	if (!len)
 		return 0;
@@ -986,14 +983,14 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 			break;
 	}
 
-	if (off > iocb->ki_pos) {
+	if (off > *ki_pos) {
 		if (off >= i_size) {
 			*retry_op = CHECK_EOF;
-			ret = i_size - iocb->ki_pos;
-			iocb->ki_pos = i_size;
+			ret = i_size - *ki_pos;
+			*ki_pos = i_size;
 		} else {
-			ret = off - iocb->ki_pos;
-			iocb->ki_pos = off;
+			ret = off - *ki_pos;
+			*ki_pos = off;
 		}
 	}
 
@@ -1001,6 +998,19 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 	return ret;
 }
 
+static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
+			      int *retry_op)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file);
+
+	dout("sync_read on file %p %llu~%u %s\n", file, iocb->ki_pos,
+	     (unsigned)iov_iter_count(to),
+	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
+
+	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op);
+}
+
 struct ceph_aio_request {
 	struct kiocb *iocb;
 	size_t total_len;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 403918a4cdb3..2362d758af97 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1253,6 +1253,8 @@ extern int ceph_renew_caps(struct inode *inode, int fmode);
 extern int ceph_open(struct inode *inode, struct file *file);
 extern int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 			    struct file *file, unsigned flags, umode_t mode);
+extern ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
+				struct iov_iter *to, int *retry_op);
 extern int ceph_release(struct inode *inode, struct file *filp);
 extern void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
 				  char *data, size_t len);
-- 
2.27.0


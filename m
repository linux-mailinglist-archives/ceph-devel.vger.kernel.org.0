Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0E644120C
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Nov 2021 03:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhKACHi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 31 Oct 2021 22:07:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26756 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230451AbhKACHh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 31 Oct 2021 22:07:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635732303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bZW6H4UnsfaQ9RdkVQk0dgyoL+wdF1UpGJoFzfoSvRg=;
        b=P5WMfgCc69U7dGgoq/KGFGQzaH+EnuHgVGJwNNjXIsfPIN4CDdB4Fik1OvFRxb+xWBdsIJ
        Jaz5Y7XcrTPj8xk2+x19SlVeeylESnx68ulxxcF5gCBgWEOzTw6mGtQR7Njw5+m239OC7M
        j4hRJsstwr9quFn8jolFf2w/elwFbEo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-OqSJ1EcnMJSObMUy4XjKfg-1; Sun, 31 Oct 2021 22:05:02 -0400
X-MC-Unique: OqSJ1EcnMJSObMUy4XjKfg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 475C28018AC;
        Mon,  1 Nov 2021 02:05:01 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E03145D6CF;
        Mon,  1 Nov 2021 02:04:58 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 3/4] ceph: add __ceph_sync_read helper support
Date:   Mon,  1 Nov 2021 10:04:46 +0800
Message-Id: <20211101020447.75872-4-xiubli@redhat.com>
In-Reply-To: <20211101020447.75872-1-xiubli@redhat.com>
References: <20211101020447.75872-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c  | 35 +++++++++++++++++++++++------------
 fs/ceph/super.h |  2 ++
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index af58be73ce1c..9ce78c97de9a 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -901,21 +901,18 @@ static inline void fscrypt_adjust_off_and_len(struct inode *inode, u64 *off, u64
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
@@ -1058,14 +1055,14 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
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
 out:
@@ -1073,6 +1070,20 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
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
+
+}
+
 struct ceph_aio_request {
 	struct kiocb *iocb;
 	size_t total_len;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 027d5f579ba0..57bc952c54e1 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1235,6 +1235,8 @@ extern int ceph_renew_caps(struct inode *inode, int fmode);
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


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD51843DD8B
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Oct 2021 11:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhJ1JRa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Oct 2021 05:17:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20210 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230126AbhJ1JR1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 05:17:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635412500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kf8phOVye7nM+NHTRxIT/hREqiW8scqZ5hTj87XZZvA=;
        b=f0z0I4hUnXfbpdl1136WZkqJfotht9w1NVFjD0tbe7FZxKwOuvwcbYMT8SpzixQw8KX/2Q
        tEeEhBqWONLSJPnV7p0qTapgCNhcxEcGFx5TuRmqeOR33VTRNaOKZ2yyIUhdJ7A9epg/yp
        bAHnOtP0d7Mm1DoJ2OCD2HiousW5BqA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-B9Tu_BnsOG2GgL69ZjrVlg-1; Thu, 28 Oct 2021 05:14:57 -0400
X-MC-Unique: B9Tu_BnsOG2GgL69ZjrVlg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C28C1B2C981;
        Thu, 28 Oct 2021 09:14:56 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E95836418A;
        Thu, 28 Oct 2021 09:14:53 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 2/4] ceph: add __ceph_sync_read helper support
Date:   Thu, 28 Oct 2021 17:14:36 +0800
Message-Id: <20211028091438.21402-3-xiubli@redhat.com>
In-Reply-To: <20211028091438.21402-1-xiubli@redhat.com>
References: <20211028091438.21402-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c  | 31 +++++++++++++++++++++----------
 fs/ceph/super.h |  2 ++
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 6e677b40410e..74db403a4c35 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -901,20 +901,17 @@ static inline void fscrypt_adjust_off_and_len(struct inode *inode, u64 *off, u64
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
 
-	dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
-	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
+	dout("sync_read on inode %p %llu~%u\n", inode, *ki_pos, (unsigned)len);
 
 	if (!len)
 		return 0;
@@ -1058,18 +1055,32 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 			break;
 	}
 
-	if (off > iocb->ki_pos) {
+	if (off > *ki_pos) {
 		if (ret >= 0 &&
 		    iov_iter_count(to) > 0 && off >= i_size_read(inode))
 			*retry_op = CHECK_EOF;
-		ret = off - iocb->ki_pos;
-		iocb->ki_pos = off;
+		ret = off - *ki_pos;
+		*ki_pos = off;
 	}
 out:
 	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);
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


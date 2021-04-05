Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A433546C8
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Apr 2021 20:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235036AbhDESir (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Apr 2021 14:38:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:32988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232598AbhDESir (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 14:38:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4789E60FD8;
        Mon,  5 Apr 2021 18:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617647920;
        bh=0BW4dKgtW7yRjnqRROod6RR64heEUKkzivE7Ihl10wQ=;
        h=From:To:Cc:Subject:Date:From;
        b=fv4LAN0d+QF0htMqnJpI4VOSYeBVcCwquJy+SKxTbMrG2G0ML7Y1udz4jx/wjbSy/
         BVXdPEybe2dK/tLgXo0LsiiTh+wyr568ML/K7mSNhkhfXZ7ynX+8ZwAP/VxTI4da+K
         TMY0Uv+/CcLtqBZ+CWUjS1QL3yzjQFQKCkFgGoMElZEAij28qJgzguG8ct8CJ90bPS
         +g5OFcXhvtWghdzRxUsR7RqYYn8p0F7WsQnQF36iv0fh3or4j99TbHHTkzxRMlAf0u
         K9FamoaTk0oeqiZJdNkIzLhVsiryuuDwwVV5CVmRTOG7+1CENzA49vhBLJ7lLOOR4V
         Kq/+lQa+Vqd9g==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH] ceph: drop pinned_page parameter from ceph_get_caps
Date:   Mon,  5 Apr 2021 14:38:38 -0400
Message-Id: <20210405183838.93073-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

All of the existing callers that don't set this to NULL just drop the
page reference at some arbitrary point later in processing. There's no
point in keeping a page reference that we don't use, so just drop the
reference immediately after checking the Uptodate flag.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c  |  9 ++-------
 fs/ceph/caps.c  | 11 +++++------
 fs/ceph/file.c  | 17 +++++------------
 fs/ceph/super.h |  2 +-
 4 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 07cbf21099b8..a49f23edae14 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1356,7 +1356,6 @@ static vm_fault_t ceph_filemap_fault(struct vm_fault *vmf)
 	struct inode *inode = file_inode(vma->vm_file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_file_info *fi = vma->vm_file->private_data;
-	struct page *pinned_page = NULL;
 	loff_t off = (loff_t)vmf->pgoff << PAGE_SHIFT;
 	int want, got, err;
 	sigset_t oldset;
@@ -1372,8 +1371,7 @@ static vm_fault_t ceph_filemap_fault(struct vm_fault *vmf)
 		want = CEPH_CAP_FILE_CACHE;
 
 	got = 0;
-	err = ceph_get_caps(vma->vm_file, CEPH_CAP_FILE_RD, want, -1,
-			    &got, &pinned_page);
+	err = ceph_get_caps(vma->vm_file, CEPH_CAP_FILE_RD, want, -1, &got);
 	if (err < 0)
 		goto out_restore;
 
@@ -1392,8 +1390,6 @@ static vm_fault_t ceph_filemap_fault(struct vm_fault *vmf)
 	} else
 		err = -EAGAIN;
 
-	if (pinned_page)
-		put_page(pinned_page);
 	ceph_put_cap_refs(ci, got);
 
 	if (err != -EAGAIN)
@@ -1487,8 +1483,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 		want = CEPH_CAP_FILE_BUFFER;
 
 	got = 0;
-	err = ceph_get_caps(vma->vm_file, CEPH_CAP_FILE_WR, want, off + len,
-			    &got, NULL);
+	err = ceph_get_caps(vma->vm_file, CEPH_CAP_FILE_WR, want, off + len, &got);
 	if (err < 0)
 		goto out_free;
 
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index aebd0d78ee59..e712826ea3f1 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2855,8 +2855,7 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
  * due to a small max_size, make sure we check_max_size (and possibly
  * ask the mds) so we don't get hung up indefinitely.
  */
-int ceph_get_caps(struct file *filp, int need, int want,
-		  loff_t endoff, int *got, struct page **pinned_page)
+int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got)
 {
 	struct ceph_file_info *fi = filp->private_data;
 	struct inode *inode = file_inode(filp);
@@ -2954,11 +2953,11 @@ int ceph_get_caps(struct file *filp, int need, int want,
 			struct page *page =
 				find_get_page(inode->i_mapping, 0);
 			if (page) {
-				if (PageUptodate(page)) {
-					*pinned_page = page;
-					break;
-				}
+				bool uptodate = PageUptodate(page);
+
 				put_page(page);
+				if (uptodate)
+					break;
 			}
 			/*
 			 * drop cap refs first because getattr while
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 31542eac7e59..77fc037d5beb 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1513,7 +1513,6 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	size_t len = iov_iter_count(to);
 	struct inode *inode = file_inode(filp);
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	struct page *pinned_page = NULL;
 	bool direct_lock = iocb->ki_flags & IOCB_DIRECT;
 	ssize_t ret;
 	int want, got = 0;
@@ -1532,8 +1531,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		want = CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO;
 	else
 		want = CEPH_CAP_FILE_CACHE;
-	ret = ceph_get_caps(filp, CEPH_CAP_FILE_RD, want, -1,
-			    &got, &pinned_page);
+	ret = ceph_get_caps(filp, CEPH_CAP_FILE_RD, want, -1, &got);
 	if (ret < 0) {
 		if (iocb->ki_flags & IOCB_DIRECT)
 			ceph_end_io_direct(inode);
@@ -1574,10 +1572,6 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 	dout("aio_read %p %llx.%llx dropping cap refs on %s = %d\n",
 	     inode, ceph_vinop(inode), ceph_cap_string(got), (int)ret);
-	if (pinned_page) {
-		put_page(pinned_page);
-		pinned_page = NULL;
-	}
 	ceph_put_cap_refs(ci, got);
 
 	if (direct_lock)
@@ -1756,8 +1750,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	else
 		want = CEPH_CAP_FILE_BUFFER;
 	got = 0;
-	err = ceph_get_caps(file, CEPH_CAP_FILE_WR, want, pos + count,
-			    &got, NULL);
+	err = ceph_get_caps(file, CEPH_CAP_FILE_WR, want, pos + count, &got);
 	if (err < 0)
 		goto out;
 
@@ -2086,7 +2079,7 @@ static long ceph_fallocate(struct file *file, int mode,
 	else
 		want = CEPH_CAP_FILE_BUFFER;
 
-	ret = ceph_get_caps(file, CEPH_CAP_FILE_WR, want, endoff, &got, NULL);
+	ret = ceph_get_caps(file, CEPH_CAP_FILE_WR, want, endoff, &got);
 	if (ret < 0)
 		goto unlock;
 
@@ -2124,7 +2117,7 @@ static int get_rd_wr_caps(struct file *src_filp, int *src_got,
 
 retry_caps:
 	ret = ceph_get_caps(dst_filp, CEPH_CAP_FILE_WR, CEPH_CAP_FILE_BUFFER,
-			    dst_endoff, dst_got, NULL);
+			    dst_endoff, dst_got);
 	if (ret < 0)
 		return ret;
 
@@ -2146,7 +2139,7 @@ static int get_rd_wr_caps(struct file *src_filp, int *src_got,
 			return ret;
 		}
 		ret = ceph_get_caps(src_filp, CEPH_CAP_FILE_RD,
-				    CEPH_CAP_FILE_SHARED, -1, src_got, NULL);
+				    CEPH_CAP_FILE_SHARED, -1, src_got);
 		if (ret < 0)
 			return ret;
 		/*... drop src_ci caps too, and retry */
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 1fe4cf385481..4808a1458c9b 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1178,7 +1178,7 @@ extern int ceph_encode_dentry_release(void **p, struct dentry *dn,
 				      int mds, int drop, int unless);
 
 extern int ceph_get_caps(struct file *filp, int need, int want,
-			 loff_t endoff, int *got, struct page **pinned_page);
+			 loff_t endoff, int *got);
 extern int ceph_try_get_caps(struct inode *inode,
 			     int need, int want, bool nonblock, int *got);
 
-- 
2.30.2


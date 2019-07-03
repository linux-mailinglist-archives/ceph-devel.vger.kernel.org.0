Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D27745E42E
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 14:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfGCMpJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 08:45:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51620 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726678AbfGCMpJ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 08:45:09 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C8C35307D871
        for <ceph-devel@vger.kernel.org>; Wed,  3 Jul 2019 12:45:08 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-77.pek2.redhat.com [10.72.12.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80F75834EB;
        Wed,  3 Jul 2019 12:45:01 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 5/9] ceph: pass filp to ceph_get_caps()
Date:   Wed,  3 Jul 2019 20:44:38 +0800
Message-Id: <20190703124442.6614-6-zyan@redhat.com>
In-Reply-To: <20190703124442.6614-1-zyan@redhat.com>
References: <20190703124442.6614-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 03 Jul 2019 12:45:08 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Also change several other functions' arguments, no logical changes.
This is preparetion for later patch that checks filp error.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/addr.c  | 15 +++++++++------
 fs/ceph/caps.c  | 32 +++++++++++++++++---------------
 fs/ceph/file.c  | 35 +++++++++++++++++------------------
 fs/ceph/super.h |  6 +++---
 4 files changed, 46 insertions(+), 42 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e078cc55b989..9f357c5ce84d 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -323,7 +323,8 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
 		/* caller of readpages does not hold buffer and read caps
 		 * (fadvise, madvise and readahead cases) */
 		int want = CEPH_CAP_FILE_CACHE;
-		ret = ceph_try_get_caps(ci, CEPH_CAP_FILE_RD, want, true, &got);
+		ret = ceph_try_get_caps(inode, CEPH_CAP_FILE_RD, want,
+					true, &got);
 		if (ret < 0) {
 			dout("start_read %p, error getting cap\n", inode);
 		} else if (!(got & want)) {
@@ -1451,7 +1452,8 @@ static vm_fault_t ceph_filemap_fault(struct vm_fault *vmf)
 		want = CEPH_CAP_FILE_CACHE;
 
 	got = 0;
-	err = ceph_get_caps(ci, CEPH_CAP_FILE_RD, want, -1, &got, &pinned_page);
+	err = ceph_get_caps(vma->vm_file, CEPH_CAP_FILE_RD, want, -1,
+			    &got, &pinned_page);
 	if (err < 0)
 		goto out_restore;
 
@@ -1567,7 +1569,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 		want = CEPH_CAP_FILE_BUFFER;
 
 	got = 0;
-	err = ceph_get_caps(ci, CEPH_CAP_FILE_WR, want, off + len,
+	err = ceph_get_caps(vma->vm_file, CEPH_CAP_FILE_WR, want, off + len,
 			    &got, NULL);
 	if (err < 0)
 		goto out_free;
@@ -1988,10 +1990,11 @@ static int __ceph_pool_perm_get(struct ceph_inode_info *ci,
 	return err;
 }
 
-int ceph_pool_perm_check(struct ceph_inode_info *ci, int need)
+int ceph_pool_perm_check(struct inode *inode, int need)
 {
-	s64 pool;
+	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_string *pool_ns;
+	s64 pool;
 	int ret, flags;
 
 	if (ci->i_vino.snap != CEPH_NOSNAP) {
@@ -2003,7 +2006,7 @@ int ceph_pool_perm_check(struct ceph_inode_info *ci, int need)
 		return 0;
 	}
 
-	if (ceph_test_mount_opt(ceph_inode_to_client(&ci->vfs_inode),
+	if (ceph_test_mount_opt(ceph_inode_to_client(inode),
 				NOPOOLPERM))
 		return 0;
 
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 345d73f57b80..40443955250c 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2567,10 +2567,10 @@ static void __take_cap_refs(struct ceph_inode_info *ci, int got,
  *
  * FIXME: how does a 0 return differ from -EAGAIN?
  */
-static int try_get_cap_refs(struct ceph_inode_info *ci, int need, int want,
+static int try_get_cap_refs(struct inode *inode, int need, int want,
 			    loff_t endoff, bool nonblock, int *got)
 {
-	struct inode *inode = &ci->vfs_inode;
+	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
 	int ret = 0;
 	int have, implemented;
@@ -2738,18 +2738,18 @@ static void check_max_size(struct inode *inode, loff_t endoff)
 		ceph_check_caps(ci, CHECK_CAPS_AUTHONLY, NULL);
 }
 
-int ceph_try_get_caps(struct ceph_inode_info *ci, int need, int want,
+int ceph_try_get_caps(struct inode *inode, int need, int want,
 		      bool nonblock, int *got)
 {
 	int ret;
 
 	BUG_ON(need & ~CEPH_CAP_FILE_RD);
 	BUG_ON(want & ~(CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO|CEPH_CAP_FILE_SHARED));
-	ret = ceph_pool_perm_check(ci, need);
+	ret = ceph_pool_perm_check(inode, need);
 	if (ret < 0)
 		return ret;
 
-	ret = try_get_cap_refs(ci, need, want, 0, nonblock, got);
+	ret = try_get_cap_refs(inode, need, want, 0, nonblock, got);
 	return ret == -EAGAIN ? 0 : ret;
 }
 
@@ -2758,21 +2758,23 @@ int ceph_try_get_caps(struct ceph_inode_info *ci, int need, int want,
  * due to a small max_size, make sure we check_max_size (and possibly
  * ask the mds) so we don't get hung up indefinitely.
  */
-int ceph_get_caps(struct ceph_inode_info *ci, int need, int want,
+int ceph_get_caps(struct file *filp, int need, int want,
 		  loff_t endoff, int *got, struct page **pinned_page)
 {
+	struct inode *inode = file_inode(filp);
+	struct ceph_inode_info *ci = ceph_inode(inode);
 	int _got, ret;
 
-	ret = ceph_pool_perm_check(ci, need);
+	ret = ceph_pool_perm_check(inode, need);
 	if (ret < 0)
 		return ret;
 
 	while (true) {
 		if (endoff > 0)
-			check_max_size(&ci->vfs_inode, endoff);
+			check_max_size(inode, endoff);
 
 		_got = 0;
-		ret = try_get_cap_refs(ci, need, want, endoff,
+		ret = try_get_cap_refs(inode, need, want, endoff,
 				       false, &_got);
 		if (ret == -EAGAIN)
 			continue;
@@ -2780,8 +2782,8 @@ int ceph_get_caps(struct ceph_inode_info *ci, int need, int want,
 			DEFINE_WAIT_FUNC(wait, woken_wake_function);
 			add_wait_queue(&ci->i_cap_wq, &wait);
 
-			while (!(ret = try_get_cap_refs(ci, need, want, endoff,
-							true, &_got))) {
+			while (!(ret = try_get_cap_refs(inode, need, want,
+							endoff, true, &_got))) {
 				if (signal_pending(current)) {
 					ret = -ERESTARTSYS;
 					break;
@@ -2796,7 +2798,7 @@ int ceph_get_caps(struct ceph_inode_info *ci, int need, int want,
 		if (ret < 0) {
 			if (ret == -ESTALE) {
 				/* session was killed, try renew caps */
-				ret = ceph_renew_caps(&ci->vfs_inode);
+				ret = ceph_renew_caps(inode);
 				if (ret == 0)
 					continue;
 			}
@@ -2805,9 +2807,9 @@ int ceph_get_caps(struct ceph_inode_info *ci, int need, int want,
 
 		if (ci->i_inline_version != CEPH_INLINE_NONE &&
 		    (_got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) &&
-		    i_size_read(&ci->vfs_inode) > 0) {
+		    i_size_read(inode) > 0) {
 			struct page *page =
-				find_get_page(ci->vfs_inode.i_mapping, 0);
+				find_get_page(inode->i_mapping, 0);
 			if (page) {
 				if (PageUptodate(page)) {
 					*pinned_page = page;
@@ -2826,7 +2828,7 @@ int ceph_get_caps(struct ceph_inode_info *ci, int need, int want,
 			 * getattr request will bring inline data into
 			 * page cache
 			 */
-			ret = __ceph_do_getattr(&ci->vfs_inode, NULL,
+			ret = __ceph_do_getattr(inode, NULL,
 						CEPH_STAT_CAP_INLINE_DATA,
 						true);
 			if (ret < 0)
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index deffb3010e6a..b868048211ba 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1262,7 +1262,8 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		want = CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO;
 	else
 		want = CEPH_CAP_FILE_CACHE;
-	ret = ceph_get_caps(ci, CEPH_CAP_FILE_RD, want, -1, &got, &pinned_page);
+	ret = ceph_get_caps(filp, CEPH_CAP_FILE_RD, want, -1,
+			    &got, &pinned_page);
 	if (ret < 0)
 		return ret;
 
@@ -1459,7 +1460,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	else
 		want = CEPH_CAP_FILE_BUFFER;
 	got = 0;
-	err = ceph_get_caps(ci, CEPH_CAP_FILE_WR, want, pos + count,
+	err = ceph_get_caps(file, CEPH_CAP_FILE_WR, want, pos + count,
 			    &got, NULL);
 	if (err < 0)
 		goto out;
@@ -1783,7 +1784,7 @@ static long ceph_fallocate(struct file *file, int mode,
 	else
 		want = CEPH_CAP_FILE_BUFFER;
 
-	ret = ceph_get_caps(ci, CEPH_CAP_FILE_WR, want, endoff, &got, NULL);
+	ret = ceph_get_caps(file, CEPH_CAP_FILE_WR, want, endoff, &got, NULL);
 	if (ret < 0)
 		goto unlock;
 
@@ -1812,16 +1813,15 @@ static long ceph_fallocate(struct file *file, int mode,
  * src_ci.  Two attempts are made to obtain both caps, and an error is return if
  * this fails; zero is returned on success.
  */
-static int get_rd_wr_caps(struct ceph_inode_info *src_ci,
-			  loff_t src_endoff, int *src_got,
-			  struct ceph_inode_info *dst_ci,
+static int get_rd_wr_caps(struct file *src_filp, int *src_got,
+			  struct file *dst_filp,
 			  loff_t dst_endoff, int *dst_got)
 {
 	int ret = 0;
 	bool retrying = false;
 
 retry_caps:
-	ret = ceph_get_caps(dst_ci, CEPH_CAP_FILE_WR, CEPH_CAP_FILE_BUFFER,
+	ret = ceph_get_caps(dst_filp, CEPH_CAP_FILE_WR, CEPH_CAP_FILE_BUFFER,
 			    dst_endoff, dst_got, NULL);
 	if (ret < 0)
 		return ret;
@@ -1831,24 +1831,24 @@ static int get_rd_wr_caps(struct ceph_inode_info *src_ci,
 	 * we would risk a deadlock by using ceph_get_caps.  Thus, we'll do some
 	 * retry dance instead to try to get both capabilities.
 	 */
-	ret = ceph_try_get_caps(src_ci, CEPH_CAP_FILE_RD, CEPH_CAP_FILE_SHARED,
+	ret = ceph_try_get_caps(file_inode(src_filp),
+				CEPH_CAP_FILE_RD, CEPH_CAP_FILE_SHARED,
 				false, src_got);
 	if (ret <= 0) {
 		/* Start by dropping dst_ci caps and getting src_ci caps */
-		ceph_put_cap_refs(dst_ci, *dst_got);
+		ceph_put_cap_refs(ceph_inode(file_inode(dst_filp)), *dst_got);
 		if (retrying) {
 			if (!ret)
 				/* ceph_try_get_caps masks EAGAIN */
 				ret = -EAGAIN;
 			return ret;
 		}
-		ret = ceph_get_caps(src_ci, CEPH_CAP_FILE_RD,
-				    CEPH_CAP_FILE_SHARED, src_endoff,
-				    src_got, NULL);
+		ret = ceph_get_caps(src_filp, CEPH_CAP_FILE_RD,
+				    CEPH_CAP_FILE_SHARED, -1, src_got, NULL);
 		if (ret < 0)
 			return ret;
 		/*... drop src_ci caps too, and retry */
-		ceph_put_cap_refs(src_ci, *src_got);
+		ceph_put_cap_refs(ceph_inode(file_inode(src_filp)), *src_got);
 		retrying = true;
 		goto retry_caps;
 	}
@@ -1962,8 +1962,8 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
 	 * clients may have dirty data in their caches.  And OSDs know nothing
 	 * about caps, so they can't safely do the remote object copies.
 	 */
-	err = get_rd_wr_caps(src_ci, (src_off + len), &src_got,
-			     dst_ci, (dst_off + len), &dst_got);
+	err = get_rd_wr_caps(src_file, &src_got,
+			     dst_file, (dst_off + len), &dst_got);
 	if (err < 0) {
 		dout("get_rd_wr_caps returned %d\n", err);
 		ret = -EOPNOTSUPP;
@@ -2020,9 +2020,8 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
 			goto out;
 		}
 		len -= ret;
-		err = get_rd_wr_caps(src_ci, (src_off + len),
-				     &src_got, dst_ci,
-				     (dst_off + len), &dst_got);
+		err = get_rd_wr_caps(src_file, &src_got,
+				     dst_file, (dst_off + len), &dst_got);
 		if (err < 0)
 			goto out;
 		err = is_file_size_ok(src_inode, dst_inode,
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 749326859045..56555d811123 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1063,9 +1063,9 @@ extern int ceph_encode_dentry_release(void **p, struct dentry *dn,
 				      struct inode *dir,
 				      int mds, int drop, int unless);
 
-extern int ceph_get_caps(struct ceph_inode_info *ci, int need, int want,
+extern int ceph_get_caps(struct file *filp, int need, int want,
 			 loff_t endoff, int *got, struct page **pinned_page);
-extern int ceph_try_get_caps(struct ceph_inode_info *ci,
+extern int ceph_try_get_caps(struct inode *inode,
 			     int need, int want, bool nonblock, int *got);
 
 /* for counting open files by mode */
@@ -1076,7 +1076,7 @@ extern void ceph_put_fmode(struct ceph_inode_info *ci, int mode);
 extern const struct address_space_operations ceph_aops;
 extern int ceph_mmap(struct file *file, struct vm_area_struct *vma);
 extern int ceph_uninline_data(struct file *filp, struct page *locked_page);
-extern int ceph_pool_perm_check(struct ceph_inode_info *ci, int need);
+extern int ceph_pool_perm_check(struct inode *inode, int need);
 extern void ceph_pool_perm_destroy(struct ceph_mds_client* mdsc);
 
 /* file.c */
-- 
2.20.1


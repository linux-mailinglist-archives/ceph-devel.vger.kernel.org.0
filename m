Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33ECE65F93
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Jul 2019 20:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbfGKSln (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 11 Jul 2019 14:41:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730244AbfGKSln (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 11 Jul 2019 14:41:43 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 086F6216C8;
        Thu, 11 Jul 2019 18:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562870502;
        bh=S33uDQOj4/Gj0MHccsh2FS7+4zdh4pRlKKNbCcMYNu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xF3EvEohJd2GVdhOgo4Nm/zeO55dVrqMef138eOFOMnL6nXDJCwJt66qwy0yp26Sr
         ULhGGP1RaGiJ3jii4URP0YpvTA27RvLlX0lI6KcO3DXvSxkKX7llfJAnqh54XKsndx
         84DRHDBGDZP+BIs4bTmQH3AkH+hHHQlyssiRXOms=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, idryomov@gmail.com, sage@redhat.com,
        lhenriques@suse.com
Subject: [PATCH v2 3/5] ceph: fix potential races in ceph_uninline_data
Date:   Thu, 11 Jul 2019 14:41:34 -0400
Message-Id: <20190711184136.19779-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190711184136.19779-1-jlayton@kernel.org>
References: <20190711184136.19779-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The current code will do the uninlining but it relies on the callers to
set the i_inline_version appropriately afterward. Multiple tasks can end
up attempting to uninline the data, and overwrite changes that follow
the first uninlining.

Protect against competing uninlining attempts by having the callers take
the i_truncate_mutex and then have ceph_uninline_data update the version
itself before dropping it. This means that we also need to have
ceph_uninline_data mark the caps dirty and pass back I_DIRTY_* flags if
any of them are newly dirty.

We can't mark the caps dirty though unless we actually have them, so
move the uninlining after the point where Fw caps are acquired in all of
the callers.

Finally, since we are doing a lockless check first in all cases, just
move that into ceph_uninline_data as well, and have the callers call it
unconditionally.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 119 +++++++++++++++++++++++++++++++++----------------
 fs/ceph/file.c |  39 +++++++---------
 2 files changed, 97 insertions(+), 61 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 038678963cf9..4606da82da6f 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1531,7 +1531,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 	loff_t off = page_offset(page);
 	loff_t size = i_size_read(inode);
 	size_t len;
-	int want, got, err;
+	int want, got, err, dirty;
 	sigset_t oldset;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 
@@ -1541,12 +1541,6 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 
 	ceph_block_sigs(&oldset);
 
-	if (ci->i_inline_version != CEPH_INLINE_NONE) {
-		err = ceph_uninline_data(inode, off == 0 ? page : NULL);
-		if (err < 0)
-			goto out_free;
-	}
-
 	if (off + PAGE_SIZE <= size)
 		len = PAGE_SIZE;
 	else
@@ -1565,6 +1559,11 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 	if (err < 0)
 		goto out_free;
 
+	err = ceph_uninline_data(inode, off == 0 ? page : NULL);
+	if (err < 0)
+		goto out_put_caps;
+	dirty = err;
+
 	dout("page_mkwrite %p %llu~%zd got cap refs on %s\n",
 	     inode, off, len, ceph_cap_string(got));
 
@@ -1591,11 +1590,9 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 
 	if (ret == VM_FAULT_LOCKED ||
 	    ci->i_inline_version != CEPH_INLINE_NONE) {
-		int dirty;
 		spin_lock(&ci->i_ceph_lock);
-		ci->i_inline_version = CEPH_INLINE_NONE;
-		dirty = __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR,
-					       &prealloc_cf);
+		dirty |= __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR,
+					        &prealloc_cf);
 		spin_unlock(&ci->i_ceph_lock);
 		if (dirty)
 			__mark_inode_dirty(inode, dirty);
@@ -1603,6 +1600,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 
 	dout("page_mkwrite %p %llu~%zd dropping cap refs on %s ret %x\n",
 	     inode, off, len, ceph_cap_string(got), ret);
+out_put_caps:
 	ceph_put_cap_refs(ci, got);
 out_free:
 	ceph_restore_sigs(&oldset);
@@ -1656,27 +1654,60 @@ void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
 	}
 }
 
+/**
+ * ceph_uninline_data - convert an inlined file to uninlined
+ * @inode: inode to be uninlined
+ * @page: optional pointer to first page in file
+ *
+ * Convert a file from inlined to non-inlined. We borrow the i_truncate_mutex
+ * to serialize callers and prevent races. Returns either a negative error code
+ * or a positive set of I_DIRTY_* flags that the caller should apply when
+ * dirtying the inode.
+ */
 int ceph_uninline_data(struct inode *inode, struct page *provided_page)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_osd_request *req;
+	struct ceph_cap_flush *prealloc_cf = NULL;
 	struct page *page = NULL;
 	u64 len, inline_version;
-	int err = 0;
+	int ret = 0;
 	bool from_pagecache = false;
 	bool allocated_page = false;
 
+	/* Do a lockless check first -- paired with i_ceph_lock for changes */
+	inline_version = READ_ONCE(ci->i_inline_version);
+	if (likely(inline_version == CEPH_INLINE_NONE))
+		return 0;
+
+	dout("uninline_data %p %llx.%llx inline_version %llu\n",
+	     inode, ceph_vinop(inode), inline_version);
+
+	mutex_lock(&ci->i_truncate_mutex);
+
+	/* Double check the version after taking mutex */
 	spin_lock(&ci->i_ceph_lock);
 	inline_version = ci->i_inline_version;
 	spin_unlock(&ci->i_ceph_lock);
 
-	dout("uninline_data %p %llx.%llx inline_version %llu\n",
-	     inode, ceph_vinop(inode), inline_version);
+	/* If someone beat us to the uninlining then just return. */
+	if (inline_version == CEPH_INLINE_NONE)
+		goto out;
 
-	if (inline_version == 1 || /* initial version, no data */
-	    inline_version == CEPH_INLINE_NONE)
+	prealloc_cf = ceph_alloc_cap_flush();
+	if (!prealloc_cf) {
+		ret = -ENOMEM;
 		goto out;
+	}
+
+	/*
+	 * Handle the initial version (1) as a a special case: switch the
+	 * version to CEPH_INLINE_NONE, but we don't need to do any uninlining
+	 * in that case since there is no data yet.
+	 */
+	if (inline_version == 1)
+		goto out_set_vers;
 
 	if (provided_page) {
 		page = provided_page;
@@ -1703,20 +1734,20 @@ int ceph_uninline_data(struct inode *inode, struct page *provided_page)
 	} else {
 		page = __page_cache_alloc(GFP_NOFS);
 		if (!page) {
-			err = -ENOMEM;
+			ret = -ENOMEM;
 			goto out;
 		}
 		allocated_page = true;
 		lock_page(page);
-		err = __ceph_do_getattr(inode, page,
+		ret = __ceph_do_getattr(inode, page,
 					CEPH_STAT_CAP_INLINE_DATA, true);
-		if (err < 0) {
+		if (ret < 0) {
 			/* no inline data */
-			if (err == -ENODATA)
-				err = 0;
+			if (ret == -ENODATA)
+				ret = 0;
 			goto out;
 		}
-		len = err;
+		len = ret;
 	}
 
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
@@ -1724,16 +1755,16 @@ int ceph_uninline_data(struct inode *inode, struct page *provided_page)
 				    CEPH_OSD_OP_CREATE, CEPH_OSD_FLAG_WRITE,
 				    NULL, 0, 0, false);
 	if (IS_ERR(req)) {
-		err = PTR_ERR(req);
+		ret = PTR_ERR(req);
 		goto out;
 	}
 
 	req->r_mtime = inode->i_mtime;
-	err = ceph_osdc_start_request(&fsc->client->osdc, req, false);
-	if (!err)
-		err = ceph_osdc_wait_request(&fsc->client->osdc, req);
+	ret = ceph_osdc_start_request(&fsc->client->osdc, req, false);
+	if (!ret)
+		ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
 	ceph_osdc_put_request(req);
-	if (err < 0)
+	if (ret < 0)
 		goto out;
 
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
@@ -1742,7 +1773,7 @@ int ceph_uninline_data(struct inode *inode, struct page *provided_page)
 				    NULL, ci->i_truncate_seq,
 				    ci->i_truncate_size, false);
 	if (IS_ERR(req)) {
-		err = PTR_ERR(req);
+		ret = PTR_ERR(req);
 		goto out;
 	}
 
@@ -1750,12 +1781,12 @@ int ceph_uninline_data(struct inode *inode, struct page *provided_page)
 
 	{
 		__le64 xattr_buf = cpu_to_le64(inline_version);
-		err = osd_req_op_xattr_init(req, 0, CEPH_OSD_OP_CMPXATTR,
+		ret = osd_req_op_xattr_init(req, 0, CEPH_OSD_OP_CMPXATTR,
 					    "inline_version", &xattr_buf,
 					    sizeof(xattr_buf),
 					    CEPH_OSD_CMPXATTR_OP_GT,
 					    CEPH_OSD_CMPXATTR_MODE_U64);
-		if (err)
+		if (ret)
 			goto out_put;
 	}
 
@@ -1763,22 +1794,31 @@ int ceph_uninline_data(struct inode *inode, struct page *provided_page)
 		char xattr_buf[32];
 		int xattr_len = snprintf(xattr_buf, sizeof(xattr_buf),
 					 "%llu", inline_version);
-		err = osd_req_op_xattr_init(req, 2, CEPH_OSD_OP_SETXATTR,
+		ret = osd_req_op_xattr_init(req, 2, CEPH_OSD_OP_SETXATTR,
 					    "inline_version",
 					    xattr_buf, xattr_len, 0, 0);
-		if (err)
+		if (ret)
 			goto out_put;
 	}
 
 	req->r_mtime = inode->i_mtime;
-	err = ceph_osdc_start_request(&fsc->client->osdc, req, false);
-	if (!err)
-		err = ceph_osdc_wait_request(&fsc->client->osdc, req);
+	ret = ceph_osdc_start_request(&fsc->client->osdc, req, false);
+	if (!ret)
+		ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
 out_put:
 	ceph_osdc_put_request(req);
-	if (err == -ECANCELED)
-		err = 0;
+	if (ret == -ECANCELED)
+		ret = 0;
+out_set_vers:
+	if (!ret) {
+		spin_lock(&ci->i_ceph_lock);
+		ci->i_inline_version = CEPH_INLINE_NONE;
+		ret = __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR,
+					     &prealloc_cf);
+		spin_unlock(&ci->i_ceph_lock);
+	}
 out:
+	mutex_unlock(&ci->i_truncate_mutex);
 	if (page) {
 		unlock_page(page);
 		if (from_pagecache)
@@ -1786,10 +1826,11 @@ int ceph_uninline_data(struct inode *inode, struct page *provided_page)
 		else if (allocated_page)
 			__free_pages(page, 0);
 	}
+	ceph_free_cap_flush(prealloc_cf);
 
 	dout("uninline_data %p %llx.%llx inline_version %llu = %d\n",
-	     inode, ceph_vinop(inode), inline_version, err);
-	return err;
+	     inode, ceph_vinop(inode), inline_version, ret);
+	return ret;
 }
 
 static const struct vm_operations_struct ceph_vmops = {
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 7bb090fa99d3..252aac44b8ce 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1387,7 +1387,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_cap_flush *prealloc_cf;
 	ssize_t count, written = 0;
-	int err, want, got;
+	int err, want, got, dirty;
 	loff_t pos;
 	loff_t limit = max(i_size_read(inode), fsc->max_file_size);
 
@@ -1438,12 +1438,6 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	inode_inc_iversion_raw(inode);
 
-	if (ci->i_inline_version != CEPH_INLINE_NONE) {
-		err = ceph_uninline_data(inode, NULL);
-		if (err < 0)
-			goto out;
-	}
-
 	/* FIXME: not complete since it doesn't account for being at quota */
 	if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_FULL)) {
 		err = -ENOSPC;
@@ -1462,6 +1456,11 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (err < 0)
 		goto out;
 
+	err = ceph_uninline_data(inode, NULL);
+	if (err < 0)
+		goto out_put_caps;
+	dirty = err;
+
 	dout("aio_write %p %llx.%llx %llu~%zd got cap refs on %s\n",
 	     inode, ceph_vinop(inode), pos, count, ceph_cap_string(got));
 
@@ -1510,12 +1509,9 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	if (written >= 0) {
-		int dirty;
-
 		spin_lock(&ci->i_ceph_lock);
-		ci->i_inline_version = CEPH_INLINE_NONE;
-		dirty = __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR,
-					       &prealloc_cf);
+		dirty |= __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR,
+					        &prealloc_cf);
 		spin_unlock(&ci->i_ceph_lock);
 		if (dirty)
 			__mark_inode_dirty(inode, dirty);
@@ -1526,6 +1522,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	dout("aio_write %p %llx.%llx %llu~%u  dropping cap refs on %s\n",
 	     inode, ceph_vinop(inode), pos, (unsigned)count,
 	     ceph_cap_string(got));
+out_put_caps:
 	ceph_put_cap_refs(ci, got);
 
 	if (written == -EOLDSNAPC) {
@@ -1762,12 +1759,6 @@ static long ceph_fallocate(struct file *file, int mode,
 		goto unlock;
 	}
 
-	if (ci->i_inline_version != CEPH_INLINE_NONE) {
-		ret = ceph_uninline_data(inode, NULL);
-		if (ret < 0)
-			goto unlock;
-	}
-
 	size = i_size_read(inode);
 
 	/* Are we punching a hole beyond EOF? */
@@ -1785,19 +1776,23 @@ static long ceph_fallocate(struct file *file, int mode,
 	if (ret < 0)
 		goto unlock;
 
+	ret = ceph_uninline_data(inode, NULL);
+	if (ret < 0)
+		goto out_put_caps;
+	dirty = ret;
+
 	ceph_zero_pagecache_range(inode, offset, length);
 	ret = ceph_zero_objects(inode, offset, length);
 
 	if (!ret) {
 		spin_lock(&ci->i_ceph_lock);
-		ci->i_inline_version = CEPH_INLINE_NONE;
-		dirty = __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR,
-					       &prealloc_cf);
+		dirty |= __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR,
+					        &prealloc_cf);
 		spin_unlock(&ci->i_ceph_lock);
 		if (dirty)
 			__mark_inode_dirty(inode, dirty);
 	}
-
+out_put_caps:
 	ceph_put_cap_refs(ci, got);
 unlock:
 	inode_unlock(inode);
-- 
2.21.0


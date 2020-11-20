Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834B52BAEF7
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Nov 2020 16:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgKTPaM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Nov 2020 10:30:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:35102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKTPaL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 10:30:11 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9EE622269;
        Fri, 20 Nov 2020 15:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605886209;
        bh=decVM/vd/vcX6HCf0TlydJ3yJFfwKyJ+mbT2w3y2Zrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjXyhEzUtj5/NYLi61aONtcH0gdL4fRyMbYCxln+6a8pQX7Q6alsDqyrb3XkmYm+I
         P1nz9u4Ck0DfkhQZdCVs6mCghMHwTXIVNtbqpdVGh1IBj93cqaFto4lQFrwu8rcySU
         1xyYgD4QCxwT28lAN0wvP/tQxiZhIXScQmPni4+M=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     linux-cachefs@redhat.com, idryomov@redhat.com, dhowells@redhat.com
Subject: [PATCH 1/5] ceph: conversion to new fscache API
Date:   Fri, 20 Nov 2020 10:30:02 -0500
Message-Id: <20201120153006.304296-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201120153006.304296-1-jlayton@kernel.org>
References: <20201120153006.304296-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Now that the fscache API has been reworked and simplified, start
changing ceph over to use it. Drop functions that are no longer needed
and rework some of the others to conform to the new API.

Change how cookies are managed as well. With the old API, we would only
instantiate a cookie when the file was open for reads. Change it to
instantiate the cookie when the inode is instantiated and call use/unuse
when the file is opened/closed. This will allow us to plumb in write
support in subsequent patches.

For now, just rip most of the code out of the read+write codepaths, as
subsequent patches will rework that code to use new helper functions.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c  |  55 ++++-----
 fs/ceph/cache.c | 295 ++++++++++++++----------------------------------
 fs/ceph/cache.h | 106 +++++++----------
 fs/ceph/caps.c  |  12 +-
 fs/ceph/file.c  |  14 ++-
 fs/ceph/inode.c |  24 +++-
 fs/ceph/super.c |   1 +
 fs/ceph/super.h |   1 -
 8 files changed, 177 insertions(+), 331 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 950552944436..9e657089d56e 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -127,7 +127,7 @@ static int ceph_set_page_dirty(struct page *page)
 	page->private = (unsigned long)snapc;
 	SetPagePrivate(page);
 
-	ret = __set_page_dirty_nobuffers(page);
+	ret = ceph_fscache_set_page_dirty(page);
 	WARN_ON(!PageLocked(page));
 	WARN_ON(!page->mapping);
 
@@ -155,31 +155,34 @@ static void ceph_invalidatepage(struct page *page, unsigned int offset,
 		return;
 	}
 
-	ceph_invalidate_fscache_page(inode, page);
-
 	WARN_ON(!PageLocked(page));
-	if (!PagePrivate(page))
-		return;
+	if (PagePrivate(page)) {
+		dout("%p invalidatepage %p idx %lu full dirty page\n",
+		     inode, page, page->index);
 
-	dout("%p invalidatepage %p idx %lu full dirty page\n",
-	     inode, page, page->index);
+		ceph_put_wrbuffer_cap_refs(ci, 1, snapc);
+		ceph_put_snap_context(snapc);
+		page->private = 0;
+		ClearPagePrivate(page);
+	}
 
-	ceph_put_wrbuffer_cap_refs(ci, 1, snapc);
-	ceph_put_snap_context(snapc);
-	page->private = 0;
-	ClearPagePrivate(page);
+	ceph_wait_on_page_fscache(page);
 }
 
-static int ceph_releasepage(struct page *page, gfp_t g)
+static int ceph_releasepage(struct page *page, gfp_t gfp_flags)
 {
 	dout("%p releasepage %p idx %lu (%sdirty)\n", page->mapping->host,
 	     page, page->index, PageDirty(page) ? "" : "not ");
 
-	/* Can we release the page from the cache? */
-	if (!ceph_release_fscache_page(page, g))
+	if (PagePrivate(page))
 		return 0;
 
-	return !PagePrivate(page);
+	if (PageFsCache(page)) {
+		if (!(gfp_flags & __GFP_DIRECT_RECLAIM) || !(gfp_flags & __GFP_FS))
+			return 0;
+		ceph_wait_on_page_fscache(page);
+	}
+	return 1;
 }
 
 /* read a single page, without unlocking it. */
@@ -213,10 +216,6 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
 		return 0;
 	}
 
-	err = ceph_readpage_from_fscache(inode, page);
-	if (err == 0)
-		return -EINPROGRESS;
-
 	dout("readpage ino %llx.%llx file %p off %llu len %llu page %p index %lu\n",
 	     vino.ino, vino.snap, filp, off, len, page, page->index);
 	req = ceph_osdc_new_request(osdc, &ci->i_layout, vino, off, &len, 0, 1,
@@ -241,7 +240,6 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
 	if (err == -ENOENT)
 		err = 0;
 	if (err < 0) {
-		ceph_fscache_readpage_cancel(inode, page);
 		if (err == -EBLOCKLISTED)
 			fsc->blocklisted = true;
 		goto out;
@@ -253,8 +251,6 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
 		flush_dcache_page(page);
 
 	SetPageUptodate(page);
-	ceph_readpage_to_fscache(inode, page);
-
 out:
 	return err < 0 ? err : 0;
 }
@@ -294,10 +290,8 @@ static void finish_read(struct ceph_osd_request *req)
 	for (i = 0; i < num_pages; i++) {
 		struct page *page = osd_data->pages[i];
 
-		if (rc < 0 && rc != -ENOENT) {
-			ceph_fscache_readpage_cancel(inode, page);
+		if (rc < 0 && rc != -ENOENT)
 			goto unlock;
-		}
 		if (bytes < (int)PAGE_SIZE) {
 			/* zero (remainder of) page */
 			int s = bytes < 0 ? 0 : bytes;
@@ -307,7 +301,6 @@ static void finish_read(struct ceph_osd_request *req)
 		     page->index);
 		flush_dcache_page(page);
 		SetPageUptodate(page);
-		ceph_readpage_to_fscache(inode, page);
 unlock:
 		unlock_page(page);
 		put_page(page);
@@ -408,7 +401,6 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
 		     page->index);
 		if (add_to_page_cache_lru(page, &inode->i_data, page->index,
 					  GFP_KERNEL)) {
-			ceph_fscache_uncache_page(inode, page);
 			put_page(page);
 			dout("start_read %p add_to_page_cache failed %p\n",
 			     inode, page);
@@ -441,7 +433,6 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
 
 out_pages:
 	for (i = 0; i < nr_pages; ++i) {
-		ceph_fscache_readpage_cancel(inode, pages[i]);
 		unlock_page(pages[i]);
 	}
 	ceph_put_page_vector(pages, nr_pages, false);
@@ -471,12 +462,6 @@ static int ceph_readpages(struct file *file, struct address_space *mapping,
 	if (ceph_inode(inode)->i_inline_version != CEPH_INLINE_NONE)
 		return -EINVAL;
 
-	rc = ceph_readpages_from_fscache(mapping->host, mapping, page_list,
-					 &nr_pages);
-
-	if (rc == 0)
-		goto out;
-
 	rw_ctx = ceph_find_rw_context(fi);
 	max = fsc->mount_options->rsize >> PAGE_SHIFT;
 	dout("readpages %p file %p ctx %p nr_pages %d max %d\n",
@@ -487,8 +472,6 @@ static int ceph_readpages(struct file *file, struct address_space *mapping,
 			goto out;
 	}
 out:
-	ceph_fscache_readpages_cancel(inode, page_list);
-
 	dout("readpages %p file %p ret %d\n", inode, file, rc);
 	return rc;
 }
diff --git a/fs/ceph/cache.c b/fs/ceph/cache.c
index 2f5cb6bc78e1..145b53af8814 100644
--- a/fs/ceph/cache.c
+++ b/fs/ceph/cache.c
@@ -35,11 +35,6 @@ struct ceph_fscache_entry {
 	char uniquifier[];
 };
 
-static const struct fscache_cookie_def ceph_fscache_fsid_object_def = {
-	.name		= "CEPH.fsid",
-	.type		= FSCACHE_COOKIE_TYPE_INDEX,
-};
-
 int __init ceph_fscache_register(void)
 {
 	return fscache_register_netfs(&ceph_cache_netfs);
@@ -50,6 +45,51 @@ void ceph_fscache_unregister(void)
 	fscache_unregister_netfs(&ceph_cache_netfs);
 }
 
+void ceph_fscache_use_cookie(struct inode *inode, bool will_modify)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+
+	if (ci->fscache)
+		fscache_use_cookie(ci->fscache, will_modify);
+}
+
+void ceph_fscache_unuse_cookie(struct inode *inode, bool update)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+
+	if (!ci->fscache)
+		return;
+
+	if (update) {
+		struct ceph_aux_inode aux = {
+						.version = ci->i_version,
+						.mtime_sec = inode->i_mtime.tv_sec,
+						.mtime_nsec = inode->i_mtime.tv_nsec,
+					    };
+		loff_t i_size = i_size_read(inode);
+
+		fscache_unuse_cookie(ci->fscache, &aux, &i_size);
+	} else {
+		fscache_unuse_cookie(ci->fscache, NULL, NULL);
+	}
+}
+
+void ceph_fscache_update(struct inode *inode)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_aux_inode aux;
+	loff_t i_size = i_size_read(inode);
+
+	if (!ci->fscache)
+		return;
+
+	aux.version = ci->i_version;
+	aux.mtime_sec = inode->i_mtime.tv_sec;
+	aux.mtime_nsec = inode->i_mtime.tv_nsec;
+
+	fscache_update_cookie(ci->fscache, &aux, &i_size);
+}
+
 int ceph_fscache_register_fs(struct ceph_fs_client* fsc, struct fs_context *fc)
 {
 	const struct ceph_fsid *fsid = &fsc->client->fsid;
@@ -86,225 +126,70 @@ int ceph_fscache_register_fs(struct ceph_fs_client* fsc, struct fs_context *fc)
 	}
 
 	fsc->fscache = fscache_acquire_cookie(ceph_cache_netfs.primary_index,
-					      &ceph_fscache_fsid_object_def,
-					      &ent->fsid, sizeof(ent->fsid) + uniq_len,
-					      NULL, 0,
-					      fsc, 0, true);
-
+					      FSCACHE_COOKIE_TYPE_INDEX,
+					      "CEPH.fsid", 0, NULL, &ent->fsid,
+					      sizeof(ent->fsid) + uniq_len, NULL, 0, 0);
 	if (fsc->fscache) {
 		ent->fscache = fsc->fscache;
 		list_add_tail(&ent->list, &ceph_fscache_list);
 	} else {
+		pr_warn("Unable to set primary index for fscache! Disabling it.\n");
 		kfree(ent);
-		errorfc(fc, "unable to register fscache cookie for fsid %pU",
-		       fsid);
-		/* all other fs ignore this error */
 	}
 out_unlock:
 	mutex_unlock(&ceph_fscache_lock);
 	return err;
 }
 
-static enum fscache_checkaux ceph_fscache_inode_check_aux(
-	void *cookie_netfs_data, const void *data, uint16_t dlen,
-	loff_t object_size)
-{
-	struct ceph_aux_inode aux;
-	struct ceph_inode_info* ci = cookie_netfs_data;
-	struct inode* inode = &ci->vfs_inode;
-
-	if (dlen != sizeof(aux) ||
-	    i_size_read(inode) != object_size)
-		return FSCACHE_CHECKAUX_OBSOLETE;
-
-	memset(&aux, 0, sizeof(aux));
-	aux.version = ci->i_version;
-	aux.mtime_sec = inode->i_mtime.tv_sec;
-	aux.mtime_nsec = inode->i_mtime.tv_nsec;
-
-	if (memcmp(data, &aux, sizeof(aux)) != 0)
-		return FSCACHE_CHECKAUX_OBSOLETE;
-
-	dout("ceph inode 0x%p cached okay\n", ci);
-	return FSCACHE_CHECKAUX_OKAY;
-}
-
-static const struct fscache_cookie_def ceph_fscache_inode_object_def = {
-	.name		= "CEPH.inode",
-	.type		= FSCACHE_COOKIE_TYPE_DATAFILE,
-	.check_aux	= ceph_fscache_inode_check_aux,
-};
-
 void ceph_fscache_register_inode_cookie(struct inode *inode)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_aux_inode aux;
 
+	/* Register only new inodes */
+	if (!(inode->i_state & I_NEW))
+		return;
+
 	/* No caching for filesystem */
 	if (!fsc->fscache)
 		return;
 
-	/* Only cache for regular files that are read only */
-	if (!S_ISREG(inode->i_mode))
-		return;
+	WARN_ON_ONCE(ci->fscache);
 
-	inode_lock_nested(inode, I_MUTEX_CHILD);
-	if (!ci->fscache) {
-		memset(&aux, 0, sizeof(aux));
-		aux.version = ci->i_version;
-		aux.mtime_sec = inode->i_mtime.tv_sec;
-		aux.mtime_nsec = inode->i_mtime.tv_nsec;
-		ci->fscache = fscache_acquire_cookie(fsc->fscache,
-						     &ceph_fscache_inode_object_def,
-						     &ci->i_vino, sizeof(ci->i_vino),
-						     &aux, sizeof(aux),
-						     ci, i_size_read(inode), false);
-	}
-	inode_unlock(inode);
+	memset(&aux, 0, sizeof(aux));
+	aux.version = ci->i_version;
+	aux.mtime_sec = inode->i_mtime.tv_sec;
+	aux.mtime_nsec = inode->i_mtime.tv_nsec;
+	ci->fscache = fscache_acquire_cookie(fsc->fscache,
+					     FSCACHE_COOKIE_TYPE_DATAFILE,
+					     "CEPH.inode", 0, NULL,
+					     &ci->i_vino,
+					     sizeof(ci->i_vino),
+					     &aux, sizeof(aux),
+					     i_size_read(inode));
 }
 
 void ceph_fscache_unregister_inode_cookie(struct ceph_inode_info* ci)
 {
-	struct fscache_cookie* cookie;
-
-	if ((cookie = ci->fscache) == NULL)
-		return;
+	struct fscache_cookie* cookie = xchg(&ci->fscache, NULL);
 
-	ci->fscache = NULL;
-
-	fscache_uncache_all_inode_pages(cookie, &ci->vfs_inode);
-	fscache_relinquish_cookie(cookie, &ci->i_vino, false);
-}
-
-static bool ceph_fscache_can_enable(void *data)
-{
-	struct inode *inode = data;
-	return !inode_is_open_for_write(inode);
-}
-
-void ceph_fscache_file_set_cookie(struct inode *inode, struct file *filp)
-{
-	struct ceph_inode_info *ci = ceph_inode(inode);
-
-	if (!fscache_cookie_valid(ci->fscache))
-		return;
-
-	if (inode_is_open_for_write(inode)) {
-		dout("fscache_file_set_cookie %p %p disabling cache\n",
-		     inode, filp);
-		fscache_disable_cookie(ci->fscache, &ci->i_vino, false);
-		fscache_uncache_all_inode_pages(ci->fscache, inode);
-	} else {
-		fscache_enable_cookie(ci->fscache, &ci->i_vino, i_size_read(inode),
-				      ceph_fscache_can_enable, inode);
-		if (fscache_cookie_enabled(ci->fscache)) {
-			dout("fscache_file_set_cookie %p %p enabling cache\n",
-			     inode, filp);
-		}
-	}
-}
-
-static void ceph_readpage_from_fscache_complete(struct page *page, void *data, int error)
-{
-	if (!error)
-		SetPageUptodate(page);
-
-	unlock_page(page);
-}
-
-static inline bool cache_valid(struct ceph_inode_info *ci)
-{
-	return ci->i_fscache_gen == ci->i_rdcache_gen;
-}
-
-
-/* Atempt to read from the fscache,
- *
- * This function is called from the readpage_nounlock context. DO NOT attempt to
- * unlock the page here (or in the callback).
- */
-int ceph_readpage_from_fscache(struct inode *inode, struct page *page)
-{
-	struct ceph_inode_info *ci = ceph_inode(inode);
-	int ret;
-
-	if (!cache_valid(ci))
-		return -ENOBUFS;
-
-	ret = fscache_read_or_alloc_page(ci->fscache, page,
-					 ceph_readpage_from_fscache_complete, NULL,
-					 GFP_KERNEL);
-
-	switch (ret) {
-		case 0: /* Page found */
-			dout("page read submitted\n");
-			return 0;
-		case -ENOBUFS: /* Pages were not found, and can't be */
-		case -ENODATA: /* Pages were not found */
-			dout("page/inode not in cache\n");
-			return ret;
-		default:
-			dout("%s: unknown error ret = %i\n", __func__, ret);
-			return ret;
-	}
-}
-
-int ceph_readpages_from_fscache(struct inode *inode,
-				  struct address_space *mapping,
-				  struct list_head *pages,
-				  unsigned *nr_pages)
-{
-	struct ceph_inode_info *ci = ceph_inode(inode);
-	int ret;
-
-	if (!cache_valid(ci))
-		return -ENOBUFS;
-
-	ret = fscache_read_or_alloc_pages(ci->fscache, mapping, pages, nr_pages,
-					  ceph_readpage_from_fscache_complete,
-					  NULL, mapping_gfp_mask(mapping));
-
-	switch (ret) {
-		case 0: /* All pages found */
-			dout("all-page read submitted\n");
-			return 0;
-		case -ENOBUFS: /* Some pages were not found, and can't be */
-		case -ENODATA: /* some pages were not found */
-			dout("page/inode not in cache\n");
-			return ret;
-		default:
-			dout("%s: unknown error ret = %i\n", __func__, ret);
-			return ret;
-	}
+	if (cookie)
+		fscache_relinquish_cookie(cookie, false);
 }
 
-void ceph_readpage_to_fscache(struct inode *inode, struct page *page)
+void ceph_fscache_invalidate(struct inode *inode, unsigned int flags)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	int ret;
+	struct ceph_aux_inode aux = { .version		= ci->i_version,
+				      .mtime_sec	= inode->i_mtime.tv_sec,
+				      .mtime_nsec	= inode->i_mtime.tv_nsec };
 
-	if (!PageFsCache(page))
-		return;
-
-	if (!cache_valid(ci))
-		return;
-
-	ret = fscache_write_page(ci->fscache, page, i_size_read(inode),
-				 GFP_KERNEL);
-	if (ret)
-		 fscache_uncache_page(ci->fscache, page);
-}
-
-void ceph_invalidate_fscache_page(struct inode* inode, struct page *page)
-{
-	struct ceph_inode_info *ci = ceph_inode(inode);
-
-	if (!PageFsCache(page))
-		return;
+	aux.version = ci->i_version;
+	aux.mtime_sec = inode->i_mtime.tv_sec;
+	aux.mtime_nsec = inode->i_mtime.tv_nsec;
 
-	fscache_wait_on_page_write(ci->fscache, page);
-	fscache_uncache_page(ci->fscache, page);
+	fscache_invalidate(ceph_inode(inode)->fscache, &aux, i_size_read(inode), flags);
 }
 
 void ceph_fscache_unregister_fs(struct ceph_fs_client* fsc)
@@ -325,28 +210,20 @@ void ceph_fscache_unregister_fs(struct ceph_fs_client* fsc)
 		WARN_ON_ONCE(!found);
 		mutex_unlock(&ceph_fscache_lock);
 
-		__fscache_relinquish_cookie(fsc->fscache, NULL, false);
+		__fscache_relinquish_cookie(fsc->fscache, false);
 	}
 	fsc->fscache = NULL;
 }
 
-/*
- * caller should hold CEPH_CAP_FILE_{RD,CACHE}
- */
-void ceph_fscache_revalidate_cookie(struct ceph_inode_info *ci)
+static struct fscache_cookie *ceph_put_super_get_cookie(struct inode *inode)
 {
-	if (cache_valid(ci))
-		return;
+	return ceph_inode(inode)->fscache;
+}
 
-	/* resue i_truncate_mutex. There should be no pending
-	 * truncate while the caller holds CEPH_CAP_FILE_RD */
-	mutex_lock(&ci->i_truncate_mutex);
-	if (!cache_valid(ci)) {
-		if (fscache_check_consistency(ci->fscache, &ci->i_vino))
-			fscache_invalidate(ci->fscache);
-		spin_lock(&ci->i_ceph_lock);
-		ci->i_fscache_gen = ci->i_rdcache_gen;
-		spin_unlock(&ci->i_ceph_lock);
-	}
-	mutex_unlock(&ci->i_truncate_mutex);
+void ceph_fscache_put_super(struct super_block *sb)
+{
+	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
+
+	if (fsc->fscache)
+		fscache_put_super(sb, ceph_put_super_get_cookie);
 }
diff --git a/fs/ceph/cache.h b/fs/ceph/cache.h
index 89dbdd1eb14a..e8d001ec290c 100644
--- a/fs/ceph/cache.h
+++ b/fs/ceph/cache.h
@@ -21,63 +21,56 @@ void ceph_fscache_unregister_fs(struct ceph_fs_client* fsc);
 
 void ceph_fscache_register_inode_cookie(struct inode *inode);
 void ceph_fscache_unregister_inode_cookie(struct ceph_inode_info* ci);
-void ceph_fscache_file_set_cookie(struct inode *inode, struct file *filp);
-void ceph_fscache_revalidate_cookie(struct ceph_inode_info *ci);
 
-int ceph_readpage_from_fscache(struct inode *inode, struct page *page);
-int ceph_readpages_from_fscache(struct inode *inode,
-				struct address_space *mapping,
-				struct list_head *pages,
-				unsigned *nr_pages);
-void ceph_readpage_to_fscache(struct inode *inode, struct page *page);
-void ceph_invalidate_fscache_page(struct inode* inode, struct page *page);
+void ceph_fscache_use_cookie(struct inode *inode, bool will_modify);
+void ceph_fscache_unuse_cookie(struct inode *inode, bool update);
+
+void ceph_fscache_update(struct inode *inode);
+void ceph_fscache_invalidate(struct inode *inode, unsigned int flags);
 
 static inline void ceph_fscache_inode_init(struct ceph_inode_info *ci)
 {
 	ci->fscache = NULL;
-	ci->i_fscache_gen = 0;
 }
 
-static inline void ceph_fscache_invalidate(struct inode *inode)
+static inline struct fscache_cookie *ceph_fscache_cookie(struct ceph_inode_info *ci)
 {
-	fscache_invalidate(ceph_inode(inode)->fscache);
+	return ci->fscache;
 }
 
-static inline void ceph_fscache_uncache_page(struct inode *inode,
-					     struct page *page)
+static inline void ceph_wait_on_page_fscache(struct page *page)
 {
-	struct ceph_inode_info *ci = ceph_inode(inode);
-	return fscache_uncache_page(ci->fscache, page);
+	wait_on_page_fscache(page);
 }
 
-static inline int ceph_release_fscache_page(struct page *page, gfp_t gfp)
+static inline void ceph_fscache_resize(struct inode *inode)
 {
-	struct inode* inode = page->mapping->host;
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	return fscache_maybe_release_page(ci->fscache, page, gfp);
+	struct fscache_cookie *cookie = ceph_fscache_cookie(ci);
+
+	if (cookie) {
+		ceph_fscache_use_cookie(inode, true);
+		fscache_resize_cookie(cookie, i_size_read(inode));
+		ceph_fscache_unuse_cookie(inode, true);
+	}
 }
 
-static inline void ceph_fscache_readpage_cancel(struct inode *inode,
-						struct page *page)
+void ceph_fscache_put_super(struct super_block *sb);
+
+static inline void ceph_fscache_unpin_writeback(struct inode *inode,
+						struct writeback_control *wbc)
 {
-	struct ceph_inode_info *ci = ceph_inode(inode);
-	if (fscache_cookie_valid(ci->fscache) && PageFsCache(page))
-		__fscache_uncache_page(ci->fscache, page);
+	fscache_unpin_writeback(wbc, ceph_fscache_cookie(ceph_inode(inode)));
 }
 
-static inline void ceph_fscache_readpages_cancel(struct inode *inode,
-						 struct list_head *pages)
+static inline int ceph_fscache_set_page_dirty(struct page *page)
 {
+	struct inode *inode = page->mapping->host;
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	return fscache_readpages_cancel(ci->fscache, pages);
-}
 
-static inline void ceph_disable_fscache_readpage(struct ceph_inode_info *ci)
-{
-	ci->i_fscache_gen = ci->i_rdcache_gen - 1;
+	return fscache_set_page_dirty(page, ceph_fscache_cookie(ci));
 }
-
-#else
+#else /* CONFIG_CEPH_FSCACHE */
 
 static inline int ceph_fscache_register(void)
 {
@@ -110,67 +103,48 @@ static inline void ceph_fscache_unregister_inode_cookie(struct ceph_inode_info*
 {
 }
 
-static inline void ceph_fscache_file_set_cookie(struct inode *inode,
-						struct file *filp)
+static inline void ceph_fscache_use_cookie(struct inode *inode, bool will_modify)
 {
 }
 
-static inline void ceph_fscache_revalidate_cookie(struct ceph_inode_info *ci)
+static inline void ceph_fscache_unuse_cookie(struct inode *inode, bool update)
 {
 }
 
-static inline void ceph_fscache_uncache_page(struct inode *inode,
-					     struct page *pages)
+static inline void ceph_fscache_update(struct inode *inode)
 {
 }
 
-static inline int ceph_readpage_from_fscache(struct inode* inode,
-					     struct page *page)
+static inline void ceph_fscache_invalidate(struct inode *inode, unsigned int flags)
 {
-	return -ENOBUFS;
 }
 
-static inline int ceph_readpages_from_fscache(struct inode *inode,
-					      struct address_space *mapping,
-					      struct list_head *pages,
-					      unsigned *nr_pages)
+static inline struct fscache_cookie *ceph_fscache_cookie(struct ceph_inode_info *ci)
 {
-	return -ENOBUFS;
+	return NULL;
 }
 
-static inline void ceph_readpage_to_fscache(struct inode *inode,
-					    struct page *page)
+static inline void ceph_wait_on_page_fscache(struct page *page)
 {
 }
 
-static inline void ceph_fscache_invalidate(struct inode *inode)
+static inline void ceph_fscache_resize(struct inode *inode)
 {
 }
 
-static inline void ceph_invalidate_fscache_page(struct inode *inode,
-						struct page *page)
+static inline void ceph_fscache_put_super(struct super_block *sb)
 {
 }
 
-static inline int ceph_release_fscache_page(struct page *page, gfp_t gfp)
+static inline void ceph_fscache_unpin_writeback(struct writeback_control *wbc,
+						struct fscache_cookie *cookie)
 {
-	return 1;
 }
 
-static inline void ceph_fscache_readpage_cancel(struct inode *inode,
-						struct page *page)
+static inline int ceph_fscache_set_page_dirty(struct page *page)
 {
+	return __set_page_dirty_nobuffers(page);
 }
-
-static inline void ceph_fscache_readpages_cancel(struct inode *inode,
-						 struct list_head *pages)
-{
-}
-
-static inline void ceph_disable_fscache_readpage(struct ceph_inode_info *ci)
-{
-}
-
-#endif
+#endif /* CONFIG_CEPH_FSCACHE */
 
 #endif
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index e46871e2d9e0..be36c97519bd 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1999,7 +1999,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 	    !(ci->i_wb_ref || ci->i_wrbuffer_ref) &&   /* no dirty pages... */
 	    inode->i_data.nrpages &&		/* have cached pages */
 	    (revoking & (CEPH_CAP_FILE_CACHE|
-			 CEPH_CAP_FILE_LAZYIO)) && /*  or revoking cache */
+			 CEPH_CAP_FILE_LAZYIO)) && /* revoking Fc */
 	    !tried_invalidate) {
 		dout("check_caps trying to invalidate on %p\n", inode);
 		if (try_nonblocking_invalidate(inode) < 0) {
@@ -2387,6 +2387,7 @@ int ceph_write_inode(struct inode *inode, struct writeback_control *wbc)
 	int wait = (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync);
 
 	dout("write_inode %p wait=%d\n", inode, wait);
+	ceph_fscache_unpin_writeback(inode, wbc);
 	if (wait) {
 		dirty = try_flush_caps(inode, &flush_tid);
 		if (dirty)
@@ -2729,10 +2730,6 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 				*got = need | want;
 			else
 				*got = need;
-			if (S_ISREG(inode->i_mode) &&
-			    (need & CEPH_CAP_FILE_RD) &&
-			    !(*got & CEPH_CAP_FILE_CACHE))
-				ceph_disable_fscache_readpage(ci);
 			ceph_take_cap_refs(ci, *got, true);
 			ret = 1;
 		}
@@ -2982,11 +2979,6 @@ int ceph_get_caps(struct file *filp, int need, int want,
 		}
 		break;
 	}
-
-	if (S_ISREG(ci->vfs_inode.i_mode) &&
-	    (_got & CEPH_CAP_FILE_RD) && (_got & CEPH_CAP_FILE_CACHE))
-		ceph_fscache_revalidate_cookie(ci);
-
 	*got = _got;
 	return 0;
 }
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 209535d5b8d3..6aeee45ddefc 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -12,6 +12,7 @@
 #include <linux/falloc.h>
 #include <linux/iversion.h>
 #include <linux/ktime.h>
+#include <linux/fscache.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -249,8 +250,7 @@ static int ceph_init_file(struct inode *inode, struct file *file, int fmode)
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
-		ceph_fscache_register_inode_cookie(inode);
-		ceph_fscache_file_set_cookie(inode, file);
+		ceph_fscache_use_cookie(inode, file->f_mode & FMODE_WRITE);
 		fallthrough;
 	case S_IFDIR:
 		ret = ceph_init_file_info(inode, file, fmode,
@@ -800,6 +800,7 @@ int ceph_release(struct inode *inode, struct file *file)
 		dout("release inode %p regular file %p\n", inode, file);
 		WARN_ON(!list_empty(&fi->rw_contexts));
 
+		ceph_fscache_unuse_cookie(inode, file->f_mode & FMODE_WRITE);
 		ceph_put_fmode(ci, fi->fmode, 1);
 
 		kmem_cache_free(ceph_file_cachep, fi);
@@ -1194,7 +1195,11 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 	     snapc, snapc ? snapc->seq : 0);
 
 	if (write) {
-		int ret2 = invalidate_inode_pages2_range(inode->i_mapping,
+		int ret2;
+
+		ceph_fscache_invalidate(inode, FSCACHE_INVAL_DIO_WRITE);
+
+		ret2 = invalidate_inode_pages2_range(inode->i_mapping,
 					pos >> PAGE_SHIFT,
 					(pos + count - 1) >> PAGE_SHIFT);
 		if (ret2 < 0)
@@ -1405,6 +1410,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 	if (ret < 0)
 		return ret;
 
+	ceph_fscache_invalidate(inode, 0);
 	ret = invalidate_inode_pages2_range(inode->i_mapping,
 					    pos >> PAGE_SHIFT,
 					    (pos + count - 1) >> PAGE_SHIFT);
@@ -2087,6 +2093,7 @@ static long ceph_fallocate(struct file *file, int mode,
 	if (ret < 0)
 		goto unlock;
 
+	ceph_fscache_invalidate(inode, 0);
 	ceph_zero_pagecache_range(inode, offset, length);
 	ret = ceph_zero_objects(inode, offset, length);
 
@@ -2354,6 +2361,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 		goto out_caps;
 
 	/* Drop dst file cached pages */
+	ceph_fscache_invalidate(dst_inode, 0);
 	ret = invalidate_inode_pages2_range(dst_inode->i_mapping,
 					    dst_off >> PAGE_SHIFT,
 					    (dst_off + len) >> PAGE_SHIFT);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 9b85d86d8efb..9ed7ebf2ca8a 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -550,6 +550,8 @@ void ceph_evict_inode(struct inode *inode)
 	percpu_counter_dec(&mdsc->metric.total_inodes);
 
 	truncate_inode_pages_final(&inode->i_data);
+	if (inode->i_state & I_PINNING_FSCACHE_WB)
+		ceph_fscache_unuse_cookie(inode, true);
 	clear_inode(inode);
 
 	ceph_fscache_unregister_inode_cookie(ci);
@@ -616,16 +618,25 @@ int ceph_fill_file_size(struct inode *inode, int issued,
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	int queue_trunc = 0;
+	loff_t oldsize = i_size_read(inode);
 
 	if (ceph_seq_cmp(truncate_seq, ci->i_truncate_seq) > 0 ||
-	    (truncate_seq == ci->i_truncate_seq && size > inode->i_size)) {
-		dout("size %lld -> %llu\n", inode->i_size, size);
+	    (truncate_seq == ci->i_truncate_seq && size > oldsize)) {
+		dout("size %lld -> %llu\n", oldsize, size);
 		if (size > 0 && S_ISDIR(inode->i_mode)) {
 			pr_err("fill_file_size non-zero size for directory\n");
 			size = 0;
 		}
 		i_size_write(inode, size);
 		inode->i_blocks = calc_inode_blocks(size);
+		/*
+		 * If we're truncating up, then we should be able to just update
+		 * the existing cookie. Otherwise, we need to invalidate.
+		 */
+		if (size > oldsize)
+			ceph_fscache_update(inode);
+		else
+			ceph_fscache_invalidate(inode, 0);
 		ci->i_reported_size = size;
 		if (truncate_seq != ci->i_truncate_seq) {
 			dout("truncate_seq %u -> %u\n",
@@ -658,10 +669,6 @@ int ceph_fill_file_size(struct inode *inode, int issued,
 		     truncate_size);
 		ci->i_truncate_size = truncate_size;
 	}
-
-	if (queue_trunc)
-		ceph_fscache_invalidate(inode);
-
 	return queue_trunc;
 }
 
@@ -930,6 +937,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 		inode->i_op = &ceph_file_iops;
 		break;
 	case S_IFREG:
+		ceph_fscache_register_inode_cookie(inode);
 		inode->i_op = &ceph_file_iops;
 		inode->i_fop = &ceph_file_fops;
 		break;
@@ -1790,11 +1798,13 @@ bool ceph_inode_set_size(struct inode *inode, loff_t size)
 	spin_lock(&ci->i_ceph_lock);
 	dout("set_size %p %llu -> %llu\n", inode, inode->i_size, size);
 	i_size_write(inode, size);
+	ceph_fscache_update(inode);
 	inode->i_blocks = calc_inode_blocks(size);
 
 	ret = __ceph_should_report_size(ci);
 
 	spin_unlock(&ci->i_ceph_lock);
+
 	return ret;
 }
 
@@ -1870,6 +1880,7 @@ void ceph_queue_vmtruncate(struct inode *inode)
 	set_bit(CEPH_I_WORK_VMTRUNCATE, &ci->i_work_mask);
 
 	ihold(inode);
+	ceph_fscache_invalidate(inode, 0);
 	if (queue_inode_work(inode)) {
 		dout("ceph_queue_vmtruncate %p\n", inode);
 	} else {
@@ -2139,6 +2150,7 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr)
 		if ((issued & CEPH_CAP_FILE_EXCL) &&
 		    attr->ia_size > inode->i_size) {
 			i_size_write(inode, attr->ia_size);
+			ceph_fscache_resize(inode);
 			inode->i_blocks = calc_inode_blocks(attr->ia_size);
 			ci->i_reported_size = attr->ia_size;
 			dirtied |= CEPH_CAP_FILE_EXCL;
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 9b1b7f4cfdd4..b42f24628e35 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -45,6 +45,7 @@ static void ceph_put_super(struct super_block *s)
 
 	dout("put_super\n");
 	ceph_mdsc_close_sessions(fsc->mdsc);
+	ceph_fscache_put_super(s);
 }
 
 static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index b62d8fee3b86..84c43ed739f6 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -427,7 +427,6 @@ struct ceph_inode_info {
 
 #ifdef CONFIG_CEPH_FSCACHE
 	struct fscache_cookie *fscache;
-	u32 i_fscache_gen;
 #endif
 	errseq_t i_meta_err;
 
-- 
2.28.0


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7028C2296B3
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jul 2020 12:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgGVKzV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Jul 2020 06:55:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbgGVKzS (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 22 Jul 2020 06:55:18 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04D472084D;
        Wed, 22 Jul 2020 10:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595415317;
        bh=ILwvv7D8aPbVkAtC7pW4DcnkIOFxq5HM7UElueitgc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDiU+Sb6aCrr3luXxsy9oIGt29AYFqmrp+Rm0aalAC/MxbyVWrB5FIxkd4Ms59oTC
         R5xMQcgcAcY6CyhvyY9d/dEK4AGZS1RQ6BUx2wbiDFMSV2XpUrJWL5vMIolsclJ8XX
         3uWW07jOKx4l/H7lHIzXB6o+vFUoeLCZmOHTCyP0=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     dhowells@redhat.com, dwysocha@redhat.com, smfrench@gmail.com
Subject: [RFC PATCH 06/11] ceph: conversion to new fscache API
Date:   Wed, 22 Jul 2020 06:55:06 -0400
Message-Id: <20200722105511.11187-7-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200722105511.11187-1-jlayton@kernel.org>
References: <20200722105511.11187-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
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
 fs/ceph/addr.c  |  47 +++-----
 fs/ceph/cache.c | 290 +++++++++++++-----------------------------------
 fs/ceph/cache.h | 106 ++++--------------
 fs/ceph/caps.c  |  11 +-
 fs/ceph/file.c  |  13 ++-
 fs/ceph/inode.c |  14 ++-
 fs/ceph/super.h |   1 -
 7 files changed, 135 insertions(+), 347 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index b43431c0c95c..1dbc4adbfc72 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -155,19 +155,18 @@ static void ceph_invalidatepage(struct page *page, unsigned int offset,
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
 
 static int ceph_releasepage(struct page *page, gfp_t g)
@@ -175,11 +174,12 @@ static int ceph_releasepage(struct page *page, gfp_t g)
 	dout("%p releasepage %p idx %lu (%sdirty)\n", page->mapping->host,
 	     page, page->index, PageDirty(page) ? "" : "not ");
 
-	/* Can we release the page from the cache? */
-	if (!ceph_release_fscache_page(page, g))
+	if (PagePrivate(page))
 		return 0;
 
-	return !PagePrivate(page);
+	ceph_wait_on_page_fscache(page);
+
+	return 1;
 }
 
 /* read a single page, without unlocking it. */
@@ -213,10 +213,6 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
 		return 0;
 	}
 
-	err = ceph_readpage_from_fscache(inode, page);
-	if (err == 0)
-		return -EINPROGRESS;
-
 	dout("readpage ino %llx.%llx file %p off %llu len %llu page %p index %lu\n",
 	     vino.ino, vino.snap, filp, off, len, page, page->index);
 	req = ceph_osdc_new_request(osdc, &ci->i_layout, vino, off, &len, 0, 1,
@@ -242,7 +238,6 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
 		err = 0;
 	if (err < 0) {
 		SetPageError(page);
-		ceph_fscache_readpage_cancel(inode, page);
 		if (err == -EBLACKLISTED)
 			fsc->blacklisted = true;
 		goto out;
@@ -254,7 +249,6 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
 		flush_dcache_page(page);
 
 	SetPageUptodate(page);
-	ceph_readpage_to_fscache(inode, page);
 out:
 	return err < 0 ? err : 0;
 }
@@ -294,10 +288,8 @@ static void finish_read(struct ceph_osd_request *req)
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
@@ -307,7 +299,6 @@ static void finish_read(struct ceph_osd_request *req)
 		     page->index);
 		flush_dcache_page(page);
 		SetPageUptodate(page);
-		ceph_readpage_to_fscache(inode, page);
 unlock:
 		unlock_page(page);
 		put_page(page);
@@ -408,7 +399,6 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
 		     page->index);
 		if (add_to_page_cache_lru(page, &inode->i_data, page->index,
 					  GFP_KERNEL)) {
-			ceph_fscache_uncache_page(inode, page);
 			put_page(page);
 			dout("start_read %p add_to_page_cache failed %p\n",
 			     inode, page);
@@ -441,7 +431,6 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
 
 out_pages:
 	for (i = 0; i < nr_pages; ++i) {
-		ceph_fscache_readpage_cancel(inode, pages[i]);
 		unlock_page(pages[i]);
 	}
 	ceph_put_page_vector(pages, nr_pages, false);
@@ -471,12 +460,6 @@ static int ceph_readpages(struct file *file, struct address_space *mapping,
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
@@ -487,8 +470,6 @@ static int ceph_readpages(struct file *file, struct address_space *mapping,
 			goto out;
 	}
 out:
-	ceph_fscache_readpages_cancel(inode, page_list);
-
 	dout("readpages %p file %p ret %d\n", inode, file, rc);
 	return rc;
 }
diff --git a/fs/ceph/cache.c b/fs/ceph/cache.c
index 2f5cb6bc78e1..67f1dad09c19 100644
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
+void ceph_fscache_update_cookie(struct inode *inode)
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
-
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
+	struct fscache_cookie* cookie = xchg(&ci->fscache, NULL);
 
-	unlock_page(page);
-}
-
-static inline bool cache_valid(struct ceph_inode_info *ci)
-{
-	return ci->i_fscache_gen == ci->i_rdcache_gen;
+	if (cookie)
+		fscache_relinquish_cookie(cookie, false);
 }
 
-
-/* Atempt to read from the fscache,
- *
- * This function is called from the readpage_nounlock context. DO NOT attempt to
- * unlock the page here (or in the callback).
- */
-int ceph_readpage_from_fscache(struct inode *inode, struct page *page)
+void ceph_fscache_invalidate(struct inode *inode, unsigned int flags)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
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
+	struct ceph_aux_inode aux = { .version		= ci->i_version,
+				      .mtime_sec	= inode->i_mtime.tv_sec,
+				      .mtime_nsec	= inode->i_mtime.tv_nsec };
 
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
-}
-
-void ceph_readpage_to_fscache(struct inode *inode, struct page *page)
-{
-	struct ceph_inode_info *ci = ceph_inode(inode);
-	int ret;
-
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
@@ -325,28 +210,7 @@ void ceph_fscache_unregister_fs(struct ceph_fs_client* fsc)
 		WARN_ON_ONCE(!found);
 		mutex_unlock(&ceph_fscache_lock);
 
-		__fscache_relinquish_cookie(fsc->fscache, NULL, false);
+		__fscache_relinquish_cookie(fsc->fscache, false);
 	}
 	fsc->fscache = NULL;
 }
-
-/*
- * caller should hold CEPH_CAP_FILE_{RD,CACHE}
- */
-void ceph_fscache_revalidate_cookie(struct ceph_inode_info *ci)
-{
-	if (cache_valid(ci))
-		return;
-
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
-}
diff --git a/fs/ceph/cache.h b/fs/ceph/cache.h
index 89dbdd1eb14a..4d5777cdf86f 100644
--- a/fs/ceph/cache.h
+++ b/fs/ceph/cache.h
@@ -21,63 +21,36 @@ void ceph_fscache_unregister_fs(struct ceph_fs_client* fsc);
 
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
+void ceph_fscache_update_cookie(struct inode *inode);
+void ceph_fscache_invalidate(struct inode *inode, unsigned int flags);
 
 static inline void ceph_fscache_inode_init(struct ceph_inode_info *ci)
 {
 	ci->fscache = NULL;
-	ci->i_fscache_gen = 0;
-}
-
-static inline void ceph_fscache_invalidate(struct inode *inode)
-{
-	fscache_invalidate(ceph_inode(inode)->fscache);
-}
-
-static inline void ceph_fscache_uncache_page(struct inode *inode,
-					     struct page *page)
-{
-	struct ceph_inode_info *ci = ceph_inode(inode);
-	return fscache_uncache_page(ci->fscache, page);
 }
 
-static inline int ceph_release_fscache_page(struct page *page, gfp_t gfp)
+static inline struct fscache_cookie *ceph_fscache_cookie(struct ceph_inode_info *ci)
 {
-	struct inode* inode = page->mapping->host;
-	struct ceph_inode_info *ci = ceph_inode(inode);
-	return fscache_maybe_release_page(ci->fscache, page, gfp);
+	return ci->fscache;
 }
 
-static inline void ceph_fscache_readpage_cancel(struct inode *inode,
-						struct page *page)
+static inline void ceph_wait_on_page_fscache(struct page *page)
 {
-	struct ceph_inode_info *ci = ceph_inode(inode);
-	if (fscache_cookie_valid(ci->fscache) && PageFsCache(page))
-		__fscache_uncache_page(ci->fscache, page);
+	wait_on_page_fscache(page);
 }
 
-static inline void ceph_fscache_readpages_cancel(struct inode *inode,
-						 struct list_head *pages)
+static inline void ceph_fscache_resize_cookie(struct ceph_inode_info *ci, loff_t new_size)
 {
-	struct ceph_inode_info *ci = ceph_inode(inode);
-	return fscache_readpages_cancel(ci->fscache, pages);
-}
+	struct fscache_cookie *cookie = ceph_fscache_cookie(ci);
 
-static inline void ceph_disable_fscache_readpage(struct ceph_inode_info *ci)
-{
-	ci->i_fscache_gen = ci->i_rdcache_gen - 1;
+	if (cookie)
+		fscache_resize_cookie(cookie, new_size);
 }
-
-#else
+#else /* CONFIG_CEPH_FSCACHE */
 
 static inline int ceph_fscache_register(void)
 {
@@ -110,67 +83,34 @@ static inline void ceph_fscache_unregister_inode_cookie(struct ceph_inode_info*
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
+static inline void ceph_fscache_update_cookie(struct inode *inode)
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
+static inline void ceph_fscache_resize_cookie(struct ceph_inode_info *ci, loff_t new_size)
 {
 }
-
-static inline void ceph_invalidate_fscache_page(struct inode *inode,
-						struct page *page)
-{
-}
-
-static inline int ceph_release_fscache_page(struct page *page, gfp_t gfp)
-{
-	return 1;
-}
-
-static inline void ceph_fscache_readpage_cancel(struct inode *inode,
-						struct page *page)
-{
-}
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
index f8d0ee19f01d..a4428a40c67c 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1984,7 +1984,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 	    !(ci->i_wb_ref || ci->i_wrbuffer_ref) &&   /* no dirty pages... */
 	    inode->i_data.nrpages &&		/* have cached pages */
 	    (revoking & (CEPH_CAP_FILE_CACHE|
-			 CEPH_CAP_FILE_LAZYIO)) && /*  or revoking cache */
+			 CEPH_CAP_FILE_LAZYIO)) && /* revoking Fc */
 	    !tried_invalidate) {
 		dout("check_caps trying to invalidate on %p\n", inode);
 		if (try_nonblocking_invalidate(inode) < 0) {
@@ -2722,10 +2722,6 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
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
@@ -2975,11 +2971,6 @@ int ceph_get_caps(struct file *filp, int need, int want,
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
index d51c3f2fdca0..de5dc8cbcd4d 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -250,8 +250,7 @@ static int ceph_init_file(struct inode *inode, struct file *file, int fmode)
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
-		ceph_fscache_register_inode_cookie(inode);
-		ceph_fscache_file_set_cookie(inode, file);
+		ceph_fscache_use_cookie(inode, file->f_mode & FMODE_WRITE);
 		/* fall through */
 	case S_IFDIR:
 		ret = ceph_init_file_info(inode, file, fmode,
@@ -803,6 +802,7 @@ int ceph_release(struct inode *inode, struct file *file)
 		dout("release inode %p regular file %p\n", inode, file);
 		WARN_ON(!list_empty(&fi->rw_contexts));
 
+		ceph_fscache_unuse_cookie(inode, file->f_mode & FMODE_WRITE);
 		ceph_put_fmode(ci, fi->fmode, 1);
 
 		kmem_cache_free(ceph_file_cachep, fi);
@@ -1221,7 +1221,11 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
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
@@ -1432,6 +1436,8 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 	if (ret < 0)
 		return ret;
 
+	/* FIXME: write to cache instead? */
+	ceph_fscache_invalidate(inode, 0);
 	ret = invalidate_inode_pages2_range(inode->i_mapping,
 					    pos >> PAGE_SHIFT,
 					    (pos + count - 1) >> PAGE_SHIFT);
@@ -2381,6 +2387,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 		goto out_caps;
 
 	/* Drop dst file cached pages */
+	ceph_fscache_invalidate(dst_inode, 0);
 	ret = invalidate_inode_pages2_range(dst_inode->i_mapping,
 					    dst_off >> PAGE_SHIFT,
 					    (dst_off + len) >> PAGE_SHIFT);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 357c937699d5..c98830a5be6f 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -623,6 +623,7 @@ int ceph_fill_file_size(struct inode *inode, int issued,
 		}
 		i_size_write(inode, size);
 		inode->i_blocks = calc_inode_blocks(size);
+		ceph_fscache_update_cookie(inode);
 		ci->i_reported_size = size;
 		if (truncate_seq != ci->i_truncate_seq) {
 			dout("truncate_seq %u -> %u\n",
@@ -655,10 +656,6 @@ int ceph_fill_file_size(struct inode *inode, int issued,
 		     truncate_size);
 		ci->i_truncate_size = truncate_size;
 	}
-
-	if (queue_trunc)
-		ceph_fscache_invalidate(inode);
-
 	return queue_trunc;
 }
 
@@ -927,6 +924,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 		inode->i_op = &ceph_file_iops;
 		break;
 	case S_IFREG:
+		ceph_fscache_register_inode_cookie(inode);
 		inode->i_op = &ceph_file_iops;
 		inode->i_fop = &ceph_file_fops;
 		break;
@@ -1790,11 +1788,13 @@ bool ceph_inode_set_size(struct inode *inode, loff_t size)
 	spin_lock(&ci->i_ceph_lock);
 	dout("set_size %p %llu -> %llu\n", inode, inode->i_size, size);
 	i_size_write(inode, size);
+	ceph_fscache_update_cookie(inode);
 	inode->i_blocks = calc_inode_blocks(size);
 
 	ret = __ceph_should_report_size(ci);
 
 	spin_unlock(&ci->i_ceph_lock);
+
 	return ret;
 }
 
@@ -1866,6 +1866,7 @@ void ceph_queue_vmtruncate(struct inode *inode)
 	set_bit(CEPH_I_WORK_VMTRUNCATE, &ci->i_work_mask);
 
 	ihold(inode);
+	ceph_fscache_invalidate(inode, 0);
 	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
 		       &ci->i_work)) {
 		dout("ceph_queue_vmtruncate %p\n", inode);
@@ -1975,6 +1976,10 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
 	spin_unlock(&ci->i_ceph_lock);
 
 	truncate_pagecache(inode, to);
+	ceph_fscache_use_cookie(inode, true);
+	ceph_fscache_resize_cookie(ci, to);
+	ceph_fscache_unuse_cookie(inode, true);
+
 
 	spin_lock(&ci->i_ceph_lock);
 	if (to == ci->i_truncate_size) {
@@ -2136,6 +2141,7 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr)
 		if ((issued & CEPH_CAP_FILE_EXCL) &&
 		    attr->ia_size > inode->i_size) {
 			i_size_write(inode, attr->ia_size);
+			ceph_fscache_update_cookie(inode);
 			inode->i_blocks = calc_inode_blocks(attr->ia_size);
 			ci->i_reported_size = attr->ia_size;
 			dirtied |= CEPH_CAP_FILE_EXCL;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 65981a73ff2a..0e69770bcfc2 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -429,7 +429,6 @@ struct ceph_inode_info {
 
 #ifdef CONFIG_CEPH_FSCACHE
 	struct fscache_cookie *fscache;
-	u32 i_fscache_gen;
 #endif
 	errseq_t i_meta_err;
 
-- 
2.26.2


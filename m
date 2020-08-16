Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCBD2459CE
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Aug 2020 00:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgHPWNh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Aug 2020 18:13:37 -0400
Received: from smtprelay0072.hostedemail.com ([216.40.44.72]:60182 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729424AbgHPWNh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 16 Aug 2020 18:13:37 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave03.hostedemail.com (Postfix) with ESMTP id 60A9A181CAC59
        for <ceph-devel@vger.kernel.org>; Sun, 16 Aug 2020 22:05:19 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 2EE2D1801CCE4;
        Sun, 16 Aug 2020 22:05:13 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:69:327:355:379:541:617:960:966:968:973:981:988:989:1260:1311:1314:1345:1359:1437:1461:1515:1605:1730:1747:1777:1792:2194:2196:2198:2199:2200:2201:2393:2559:2562:2689:2898:2904:3138:3139:3140:3141:3142:3865:3866:3867:3868:3871:3872:4321:4385:4605:5007:6261:7875:7903:7904:8603:8957:9389:10004:10848:11026:11914:12043:12291:12296:12297:12438:12555:12679:12683:12895:12986:13894:13972:14110:14394:21080:21324:21325:21433:21451:21611:21627:21740:21987:21990:30012:30029:30030:30045:30054:30056:30062:30070,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: milk99_00004c127011
X-Filterd-Recvd-Size: 45146
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Sun, 16 Aug 2020 22:05:11 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ceph: Remove embedded function names from pr_debug uses
Date:   Sun, 16 Aug 2020 15:04:53 -0700
Message-Id: <7613a06f646d1f843b6e3b76d23612f29a1e6be5.1597615399.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1597615399.git.joe@perches.com>
References: <cover.1597615399.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Use "%s: " ..., __func__ so function renaming changes the logging too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ceph/addr.c       | 57 +++++++++++++-------------
 fs/ceph/caps.c       | 92 ++++++++++++++++++++++--------------------
 fs/ceph/debugfs.c    |  2 +-
 fs/ceph/dir.c        | 16 ++++----
 fs/ceph/file.c       |  6 +--
 fs/ceph/inode.c      | 18 ++++-----
 fs/ceph/locks.c      | 15 ++++---
 fs/ceph/mds_client.c | 95 ++++++++++++++++++++++----------------------
 fs/ceph/snap.c       | 22 +++++-----
 fs/ceph/super.c      | 10 ++---
 fs/ceph/xattr.c      | 25 ++++++------
 11 files changed, 182 insertions(+), 176 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 12ae6f7874fb..4f0f177428c7 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -311,8 +311,8 @@ static void finish_read(struct ceph_osd_request *req)
 	int num_pages;
 	int i;
 
-	pr_debug("finish_read %p req %p rc %d bytes %d\n",
-		 inode, req, rc, bytes);
+	pr_debug("%s: %p req %p rc %d bytes %d\n",
+		 __func__, inode, req, rc, bytes);
 	if (rc == -EBLACKLISTED)
 		ceph_inode_to_client(inode)->blacklisted = true;
 
@@ -333,8 +333,8 @@ static void finish_read(struct ceph_osd_request *req)
 			int s = bytes < 0 ? 0 : bytes;
 			zero_user_segment(page, s, PAGE_SIZE);
 		}
-		pr_debug("finish_read %p uptodate %p idx %lu\n",
-			 inode, page, page->index);
+		pr_debug("%s: %p uptodate %p idx %lu\n",
+			 __func__, inode, page, page->index);
 		flush_dcache_page(page);
 		SetPageUptodate(page);
 		ceph_readpage_to_fscache(inode, page);
@@ -379,9 +379,10 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
 		ret = ceph_try_get_caps(inode, CEPH_CAP_FILE_RD, want,
 					true, &got);
 		if (ret < 0) {
-			pr_debug("start_read %p, error getting cap\n", inode);
+			pr_debug("%s: %p, error getting cap\n",
+				 __func__, inode);
 		} else if (!(got & want)) {
-			pr_debug("start_read %p, no cache cap\n", inode);
+			pr_debug("%s: %p, no cache cap\n", __func__, inode);
 			ret = 0;
 		}
 		if (ret <= 0) {
@@ -409,8 +410,8 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
 			break;
 	}
 	len = nr_pages << PAGE_SHIFT;
-	pr_debug("start_read %p nr_pages %d is %lld~%lld\n",
-		 inode, nr_pages, off, len);
+	pr_debug("%s: %p nr_pages %d is %lld~%lld\n",
+		 __func__, inode, nr_pages, off, len);
 	vino = ceph_vino(inode);
 	req = ceph_osdc_new_request(osdc, &ci->i_layout, vino, off, &len,
 				    0, 1, CEPH_OSD_OP_READ,
@@ -434,14 +435,14 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
 		BUG_ON(PageLocked(page));
 		list_del(&page->lru);
 
-		pr_debug("start_read %p adding %p idx %lu\n",
-			 inode, page, page->index);
+		pr_debug("%s: %p adding %p idx %lu\n",
+			 __func__, inode, page, page->index);
 		if (add_to_page_cache_lru(page, &inode->i_data, page->index,
 					  GFP_KERNEL)) {
 			ceph_fscache_uncache_page(inode, page);
 			put_page(page);
-			pr_debug("start_read %p add_to_page_cache failed %p\n",
-				 inode, page);
+			pr_debug("%s: %p add_to_page_cache failed %p\n",
+				 __func__, inode, page);
 			nr_pages = i;
 			if (nr_pages > 0) {
 				len = nr_pages << PAGE_SHIFT;
@@ -456,7 +457,8 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
 	req->r_callback = finish_read;
 	req->r_inode = inode;
 
-	pr_debug("start_read %p starting %p %lld~%lld\n", inode, req, off, len);
+	pr_debug("%s: %p starting %p %lld~%lld\n",
+		 __func__, inode, req, off, len);
 	ret = ceph_osdc_start_request(osdc, req, false);
 	if (ret < 0)
 		goto out_pages;
@@ -798,7 +800,7 @@ static void writepages_finish(struct ceph_osd_request *req)
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	bool remove_page;
 
-	pr_debug("writepages_finish %p rc %d\n", inode, rc);
+	pr_debug("%s: %p rc %d\n", __func__, inode, rc);
 	if (rc < 0) {
 		mapping_set_error(mapping, rc);
 		ceph_set_error_write(ci);
@@ -853,8 +855,9 @@ static void writepages_finish(struct ceph_osd_request *req)
 
 			unlock_page(page);
 		}
-		pr_debug("writepages_finish %p wrote %llu bytes cleaned %d pages\n",
-			 inode, osd_data->length, rc >= 0 ? num_pages : 0);
+		pr_debug("%s: %p wrote %llu bytes cleaned %d pages\n",
+			 __func__, inode, osd_data->length,
+			 rc >= 0 ? num_pages : 0);
 
 		release_pages(osd_data->pages, num_pages);
 	}
@@ -1952,11 +1955,10 @@ static int __ceph_pool_perm_get(struct ceph_inode_info *ci,
 		goto out;
 
 	if (pool_ns)
-		pr_debug("__ceph_pool_perm_get pool %lld ns %.*s no perm cached\n",
-			 pool, (int)pool_ns->len, pool_ns->str);
+		pr_debug("%s: %lld ns %.*s no perm cached\n",
+			 __func__, pool, (int)pool_ns->len, pool_ns->str);
 	else
-		pr_debug("__ceph_pool_perm_get pool %lld no perm cached\n",
-			 pool);
+		pr_debug("%s: %lld no perm cached\n", __func__, pool);
 
 	down_write(&mdsc->pool_perm_rwsem);
 	p = &mdsc->pool_perm_tree.rb_node;
@@ -2083,11 +2085,10 @@ static int __ceph_pool_perm_get(struct ceph_inode_info *ci,
 	if (!err)
 		err = have;
 	if (pool_ns)
-		pr_debug("__ceph_pool_perm_get pool %lld ns %.*s result = %d\n",
-			 pool, (int)pool_ns->len, pool_ns->str, err);
+		pr_debug("%s: pool %lld ns %.*s result = %d\n",
+			 __func__, pool, (int)pool_ns->len, pool_ns->str, err);
 	else
-		pr_debug("__ceph_pool_perm_get pool %lld result = %d\n",
-			 pool, err);
+		pr_debug("%s: pool %lld result = %d\n", __func__, pool, err);
 	return err;
 }
 
@@ -2118,13 +2119,13 @@ int ceph_pool_perm_check(struct inode *inode, int need)
 check:
 	if (flags & CEPH_I_POOL_PERM) {
 		if ((need & CEPH_CAP_FILE_RD) && !(flags & CEPH_I_POOL_RD)) {
-			pr_debug("ceph_pool_perm_check pool %lld no read perm\n",
-				 pool);
+			pr_debug("%s: pool %lld no read perm\n",
+				 __func__, pool);
 			return -EPERM;
 		}
 		if ((need & CEPH_CAP_FILE_WR) && !(flags & CEPH_I_POOL_WR)) {
-			pr_debug("ceph_pool_perm_check pool %lld no write perm\n",
-				 pool);
+			pr_debug("%s: pool %lld no write perm\n",
+				 __func__, pool);
 			return -EPERM;
 		}
 		return 0;
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 727b71b0ba1e..9f378c546e4d 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -492,8 +492,8 @@ static void __cap_set_timeouts(struct ceph_mds_client *mdsc,
 	struct ceph_mount_options *opt = mdsc->fsc->mount_options;
 	ci->i_hold_caps_max = round_jiffies(jiffies +
 					    opt->caps_wanted_delay_max * HZ);
-	pr_debug("__cap_set_timeouts %p %lu\n",
-		 &ci->vfs_inode, ci->i_hold_caps_max - jiffies);
+	pr_debug("%s: %p %lu\n",
+		 __func__, &ci->vfs_inode, ci->i_hold_caps_max - jiffies);
 }
 
 /*
@@ -791,8 +791,8 @@ static int __cap_is_valid(struct ceph_cap *cap)
 	spin_unlock(&cap->session->s_gen_ttl_lock);
 
 	if (cap->cap_gen < gen || time_after_eq(jiffies, ttl)) {
-		pr_debug("__cap_is_valid %p cap %p issued %s but STALE (gen %u vs %u)\n",
-			 &cap->ci->vfs_inode,
+		pr_debug("%s: %p cap %p issued %s but STALE (gen %u vs %u)\n",
+			 __func__, &cap->ci->vfs_inode,
 			 cap, ceph_cap_string(cap->issued), cap->cap_gen, gen);
 		return 0;
 	}
@@ -817,8 +817,9 @@ int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented)
 		cap = rb_entry(p, struct ceph_cap, ci_node);
 		if (!__cap_is_valid(cap))
 			continue;
-		pr_debug("__ceph_caps_issued %p cap %p issued %s\n",
-			 &ci->vfs_inode, cap, ceph_cap_string(cap->issued));
+		pr_debug("%s: %p cap %p issued %s\n",
+			 __func__, &ci->vfs_inode, cap,
+			 ceph_cap_string(cap->issued));
 		have |= cap->issued;
 		if (implemented)
 			*implemented |= cap->implemented;
@@ -865,12 +866,12 @@ static void __touch_cap(struct ceph_cap *cap)
 
 	spin_lock(&s->s_cap_lock);
 	if (!s->s_cap_iterator) {
-		pr_debug("__touch_cap %p cap %p mds%d\n",
-			 &cap->ci->vfs_inode, cap, s->s_mds);
+		pr_debug("%s: %p cap %p mds%d\n",
+			 __func__, &cap->ci->vfs_inode, cap, s->s_mds);
 		list_move_tail(&cap->session_caps, &s->s_caps);
 	} else {
-		pr_debug("__touch_cap %p cap %p mds%d NOP, iterating over caps\n",
-			 &cap->ci->vfs_inode, cap, s->s_mds);
+		pr_debug("%s: %p cap %p mds%d NOP, iterating over caps\n",
+			 __func__, &cap->ci->vfs_inode, cap, s->s_mds);
 	}
 	spin_unlock(&s->s_cap_lock);
 }
@@ -887,8 +888,8 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
 	int have = ci->i_snap_caps;
 
 	if ((have & mask) == mask) {
-		pr_debug("__ceph_caps_issued_mask ino 0x%lx snap issued %s (mask %s)\n",
-			 ci->vfs_inode.i_ino,
+		pr_debug("%s: ino 0x%lx snap issued %s (mask %s)\n",
+			 __func__, ci->vfs_inode.i_ino,
 			 ceph_cap_string(have),
 			 ceph_cap_string(mask));
 		return 1;
@@ -899,8 +900,8 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
 		if (!__cap_is_valid(cap))
 			continue;
 		if ((cap->issued & mask) == mask) {
-			pr_debug("__ceph_caps_issued_mask ino 0x%lx cap %p issued %s (mask %s)\n",
-				 ci->vfs_inode.i_ino, cap,
+			pr_debug("%s: ino 0x%lx cap %p issued %s (mask %s)\n",
+				 __func__, ci->vfs_inode.i_ino, cap,
 				 ceph_cap_string(cap->issued),
 				 ceph_cap_string(mask));
 			if (touch)
@@ -911,8 +912,8 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
 		/* does a combination of caps satisfy mask? */
 		have |= cap->issued;
 		if ((have & mask) == mask) {
-			pr_debug("__ceph_caps_issued_mask ino 0x%lx combo issued %s (mask %s)\n",
-				 ci->vfs_inode.i_ino,
+			pr_debug("%s: ino 0x%lx combo issued %s (mask %s)\n",
+				 __func__, ci->vfs_inode.i_ino,
 				 ceph_cap_string(cap->issued),
 				 ceph_cap_string(mask));
 			if (touch) {
@@ -977,8 +978,8 @@ int ceph_caps_revoking(struct ceph_inode_info *ci, int mask)
 	spin_lock(&ci->i_ceph_lock);
 	ret = __ceph_caps_revoking_other(ci, NULL, mask);
 	spin_unlock(&ci->i_ceph_lock);
-	pr_debug("ceph_caps_revoking %p %s = %d\n",
-		 inode, ceph_cap_string(mask), ret);
+	pr_debug("%s: %p %s = %d\n",
+		 __func__, inode, ceph_cap_string(mask), ret);
 	return ret;
 }
 
@@ -1144,7 +1145,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 		ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
 	int removed = 0;
 
-	pr_debug("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
+	pr_debug("%s: %p from %p\n", __func__, cap, &ci->vfs_inode);
 
 	/* remove from inode's cap rbtree, and clear auth cap */
 	rb_erase(&cap->ci_node, &ci->i_caps);
@@ -1157,8 +1158,8 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 	spin_lock(&session->s_cap_lock);
 	if (session->s_cap_iterator == cap) {
 		/* not yet, we are iterating over this very cap */
-		pr_debug("__ceph_remove_cap  delaying %p removal from session %p\n",
-			 cap, cap->session);
+		pr_debug("%s: delaying %p removal from session %p\n",
+			 __func__, cap, cap->session);
 	} else {
 		list_del_init(&cap->session_caps);
 		session->s_nr_caps--;
@@ -1234,8 +1235,8 @@ static int send_cap_msg(struct cap_msg_args *arg)
 	size_t extra_len;
 	struct ceph_osd_client *osdc = &arg->session->s_mdsc->fsc->client->osdc;
 
-	pr_debug("send_cap_msg %s %llx %llx caps %s wanted %s dirty %s seq %u/%u tid %llu/%llu mseq %u follows %lld size %llu/%llu xattr_ver %llu xattr_len %d\n",
-		 ceph_cap_op_name(arg->op),
+	pr_debug("%s: %s %llx %llx caps %s wanted %s dirty %s seq %u/%u tid %llu/%llu mseq %u follows %lld size %llu/%llu xattr_ver %llu xattr_len %d\n",
+		 __func__, ceph_cap_op_name(arg->op),
 		 arg->cid, arg->ino, ceph_cap_string(arg->caps),
 		 ceph_cap_string(arg->wanted), ceph_cap_string(arg->dirty),
 		 arg->seq, arg->issue_seq, arg->flush_tid, arg->oldest_flush_tid,
@@ -1636,7 +1637,7 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
 	struct ceph_mds_session *session = NULL;
 	int mds;
 
-	pr_debug("ceph_flush_snaps %p\n", inode);
+	pr_debug("%s: %p\n", __func__, inode);
 	if (psession)
 		session = *psession;
 retry:
@@ -1827,8 +1828,8 @@ static u64 __mark_caps_flushing(struct inode *inode,
 	BUG_ON(!ci->i_prealloc_cap_flush);
 
 	flushing = ci->i_dirty_caps;
-	pr_debug("__mark_caps_flushing flushing %s, flushing_caps %s -> %s\n",
-		 ceph_cap_string(flushing),
+	pr_debug("%s: flushing %s, flushing_caps %s -> %s\n",
+		 __func__, ceph_cap_string(flushing),
 		 ceph_cap_string(ci->i_flushing_caps),
 		 ceph_cap_string(ci->i_flushing_caps | flushing));
 	ci->i_flushing_caps |= flushing;
@@ -1872,12 +1873,12 @@ static int try_nonblocking_invalidate(struct inode *inode)
 	if (inode->i_data.nrpages == 0 &&
 	    invalidating_gen == ci->i_rdcache_gen) {
 		/* success. */
-		pr_debug("try_nonblocking_invalidate %p success\n", inode);
+		pr_debug("%s: %p success\n", __func__, inode);
 		/* save any racing async invalidate some trouble */
 		ci->i_rdcache_revoking = ci->i_rdcache_gen - 1;
 		return 0;
 	}
-	pr_debug("try_nonblocking_invalidate %p failed\n", inode);
+	pr_debug("%s: %p failed\n", __func__, inode);
 	return -1;
 }
 
@@ -2288,8 +2289,10 @@ static int unsafe_request_wait(struct inode *inode)
 	}
 	spin_unlock(&ci->i_unsafe_lock);
 
-	pr_debug("unsafe_request_wait %p wait on tid %llu %llu\n",
-		 inode, req1 ? req1->r_tid : 0ULL, req2 ? req2->r_tid : 0ULL);
+	pr_debug("%s: %p wait on tid %llu %llu\n",
+		 __func__, inode,
+		 req1 ? req1->r_tid : 0ULL,
+		 req2 ? req2->r_tid : 0ULL);
 	if (req1) {
 		ret = !wait_for_completion_timeout(&req1->r_safe_completion,
 					ceph_timeout_jiffies(req1->r_timeout));
@@ -2644,7 +2647,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 
 	if ((flags & CHECK_FILELOCK) &&
 	    (ci->i_ceph_flags & CEPH_I_ERROR_FILELOCK)) {
-		pr_debug("try_get_cap_refs %p error filelock\n", inode);
+		pr_debug("%s: %p error filelock\n", __func__, inode);
 		ret = -EIO;
 		goto out_unlock;
 	}
@@ -3192,7 +3195,7 @@ static void invalidate_aliases(struct inode *inode)
 {
 	struct dentry *dn, *prev = NULL;
 
-	pr_debug("invalidate_aliases inode %p\n", inode);
+	pr_debug("%s: inode %p\n", __func__, inode);
 	d_prune_aliases(inode);
 	/*
 	 * For non-directory inode, d_find_alias() only returns
@@ -3263,8 +3266,9 @@ static void handle_cap_grant(struct inode *inode,
 	bool deleted_inode = false;
 	bool fill_inline = false;
 
-	pr_debug("handle_cap_grant inode %p cap %p mds%d seq %d %s\n",
-		 inode, cap, session->s_mds, seq, ceph_cap_string(newcaps));
+	pr_debug("%s: inode %p cap %p mds%d seq %d %s\n",
+		 __func__, inode, cap, session->s_mds, seq,
+		 ceph_cap_string(newcaps));
 	pr_debug("size %llu max_size %llu, i_size %llu\n",
 		 size, max_size, inode->i_size);
 
@@ -3574,8 +3578,8 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
 		}
 	}
 
-	pr_debug("handle_cap_flush_ack inode %p mds%d seq %d on %s cleaned %s, flushing %s -> %s\n",
-		 inode, session->s_mds, seq, ceph_cap_string(dirty),
+	pr_debug("%s: inode %p mds%d seq %d on %s cleaned %s, flushing %s -> %s\n",
+		 __func__, inode, session->s_mds, seq, ceph_cap_string(dirty),
 		 ceph_cap_string(cleaned), ceph_cap_string(ci->i_flushing_caps),
 		 ceph_cap_string(ci->i_flushing_caps & ~cleaned));
 
@@ -3655,8 +3659,8 @@ static void handle_cap_flushsnap_ack(struct inode *inode, u64 flush_tid,
 	bool wake_ci = false;
 	bool wake_mdsc = false;
 
-	pr_debug("handle_cap_flushsnap_ack inode %p ci %p mds%d follows %lld\n",
-		 inode, ci, session->s_mds, follows);
+	pr_debug("%s: inode %p ci %p mds%d follows %lld\n",
+		 __func__, inode, ci, session->s_mds, follows);
 
 	spin_lock(&ci->i_ceph_lock);
 	list_for_each_entry(capsnap, &ci->i_cap_snaps, ci_item) {
@@ -3726,8 +3730,8 @@ static bool handle_cap_trunc(struct inode *inode,
 
 	issued |= implemented | dirty;
 
-	pr_debug("handle_cap_trunc inode %p mds%d seq %d to %lld seq %d\n",
-		 inode, mds, seq, truncate_size, truncate_seq);
+	pr_debug("%s: %p mds%d seq %d to %lld seq %d\n",
+		 __func__, inode, mds, seq, truncate_size, truncate_seq);
 	queue_trunc = ceph_fill_file_size(inode, issued,
 					  truncate_seq, truncate_size, size);
 	return queue_trunc;
@@ -3765,8 +3769,8 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 		target = -1;
 	}
 
-	pr_debug("handle_cap_export inode %p ci %p mds%d mseq %d target %d\n",
-		 inode, ci, mds, mseq, target);
+	pr_debug("%s: inode %p ci %p mds%d mseq %d target %d\n",
+		 __func__, inode, ci, mds, mseq, target);
 retry:
 	spin_lock(&ci->i_ceph_lock);
 	cap = __get_cap_for_mds(ci, mds);
@@ -3898,8 +3902,8 @@ static void handle_cap_import(struct ceph_mds_client *mdsc,
 		peer = -1;
 	}
 
-	pr_debug("handle_cap_import inode %p ci %p mds%d mseq %d peer %d\n",
-		 inode, ci, mds, mseq, peer);
+	pr_debug("%s: inode %p ci %p mds%d mseq %d peer %d\n",
+		 __func__, inode, ci, mds, mseq, peer);
 retry:
 	cap = __get_cap_for_mds(ci, mds);
 	if (!cap) {
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 244428de3c4b..298b0df741cc 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -338,7 +338,7 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 {
 	char name[100];
 
-	pr_debug("ceph_fs_debugfs_init\n");
+	pr_debug("%s\n", __func__);
 	fsc->debugfs_congestion_kb =
 		debugfs_create_file("writeback_congestion_kb",
 				    0600,
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 911b905cc181..9178b19f93f9 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -120,7 +120,7 @@ static int note_last_dentry(struct ceph_dir_file_info *dfi, const char *name,
 	memcpy(dfi->last_name, name, len);
 	dfi->last_name[len] = 0;
 	dfi->next_offset = next_offset;
-	pr_debug("note_last_dentry '%s'\n", dfi->last_name);
+	pr_debug("%s: '%s'\n", __func__, dfi->last_name);
 	return 0;
 }
 
@@ -191,8 +191,8 @@ static int __dcache_readdir(struct file *file,  struct dir_context *ctx,
 	u64 idx = 0;
 	int err = 0;
 
-	pr_debug("__dcache_readdir %p v%u at %llx\n",
-		 dir, (unsigned int)shared_gen, ctx->pos);
+	pr_debug("%s: %p v%u at %llx\n",
+		 __func__, dir, (unsigned int)shared_gen, ctx->pos);
 
 	/* search start position */
 	if (ctx->pos > 2) {
@@ -222,7 +222,7 @@ static int __dcache_readdir(struct file *file,  struct dir_context *ctx,
 			dput(dentry);
 		}
 
-		pr_debug("__dcache_readdir %p cache idx %llu\n", dir, idx);
+		pr_debug("%s: %p cache idx %llu\n", __func__, dir, idx);
 	}
 
 
@@ -1597,7 +1597,7 @@ static int dentry_lease_is_valid(struct dentry *dentry, unsigned int flags)
 					 CEPH_MDS_LEASE_RENEW, seq);
 		ceph_put_mds_session(session);
 	}
-	pr_debug("dentry_lease_is_valid - dentry %p = %d\n", dentry, valid);
+	pr_debug("%s: dentry %p = %d\n", __func__, dentry, valid);
 	return valid;
 }
 
@@ -1661,8 +1661,8 @@ static int dir_lease_is_valid(struct inode *dir, struct dentry *dentry,
 			valid = 0;
 		spin_unlock(&dentry->d_lock);
 	}
-	pr_debug("dir_lease_is_valid dir %p v%u dentry %p = %d\n",
-		 dir, (unsigned int)atomic_read(&ci->i_shared_gen),
+	pr_debug("%s: dir %p v%u dentry %p = %d\n",
+		 __func__, dir, (unsigned int)atomic_read(&ci->i_shared_gen),
 		 dentry, valid);
 	return valid;
 }
@@ -1825,7 +1825,7 @@ static void ceph_d_prune(struct dentry *dentry)
 	struct ceph_inode_info *dir_ci;
 	struct ceph_dentry_info *di;
 
-	pr_debug("ceph_d_prune %pd %p\n", dentry, dentry);
+	pr_debug("%s: %pd %p\n", __func__, dentry, dentry);
 
 	/* do we have a valid parent? */
 	if (IS_ROOT(dentry))
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 7d7644f8862c..d75b466780ca 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1020,7 +1020,7 @@ static void ceph_aio_complete(struct inode *inode,
 	if (!ret)
 		ret = aio_req->total_len;
 
-	pr_debug("ceph_aio_complete %p rc %d\n", inode, ret);
+	pr_debug("%s: %p rc %d\n", __func__, inode, ret);
 
 	if (ret >= 0 && aio_req->write) {
 		int dirty;
@@ -1062,8 +1062,8 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_BVECS);
 	BUG_ON(!osd_data->num_bvecs);
 
-	pr_debug("ceph_aio_complete_req %p rc %d bytes %u\n",
-		 inode, rc, osd_data->bvec_pos.iter.bi_size);
+	pr_debug("%s: %p rc %d bytes %u\n",
+		 __func__, inode, rc, osd_data->bvec_pos.iter.bi_size);
 
 	/* r_start_latency == 0 means the request was not submitted */
 	if (req->r_start_latency) {
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index b2ff9f03a46e..8658070c59ee 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1832,10 +1832,10 @@ void ceph_queue_writeback(struct inode *inode)
 	ihold(inode);
 	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
 		       &ci->i_work)) {
-		pr_debug("ceph_queue_writeback %p\n", inode);
+		pr_debug("%s: %p\n", __func__, inode);
 	} else {
-		pr_debug("ceph_queue_writeback %p already queued, mask=%lx\n",
-			 inode, ci->i_work_mask);
+		pr_debug("%s: %p already queued, mask=%lx\n",
+			 __func__, inode, ci->i_work_mask);
 		iput(inode);
 	}
 }
@@ -1851,10 +1851,10 @@ void ceph_queue_invalidate(struct inode *inode)
 	ihold(inode);
 	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
 		       &ceph_inode(inode)->i_work)) {
-		pr_debug("ceph_queue_invalidate %p\n", inode);
+		pr_debug("%s: %p\n", __func__, inode);
 	} else {
-		pr_debug("ceph_queue_invalidate %p already queued, mask=%lx\n",
-			 inode, ci->i_work_mask);
+		pr_debug("%s: %p already queued, mask=%lx\n",
+			 __func__, inode, ci->i_work_mask);
 		iput(inode);
 	}
 }
@@ -1871,10 +1871,10 @@ void ceph_queue_vmtruncate(struct inode *inode)
 	ihold(inode);
 	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
 		       &ci->i_work)) {
-		pr_debug("ceph_queue_vmtruncate %p\n", inode);
+		pr_debug("%s: %p\n", __func__, inode);
 	} else {
-		pr_debug("ceph_queue_vmtruncate %p already queued, mask=%lx\n",
-			 inode, ci->i_work_mask);
+		pr_debug("%s: %p already queued, mask=%lx\n",
+			 __func__, inode, ci->i_work_mask);
 		iput(inode);
 	}
 }
diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index 8f6819d2dc99..a414b8d51c3d 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -98,8 +98,8 @@ static int ceph_lock_message(u8 lock_type, u16 operation, struct inode *inode,
 
 	owner = secure_addr(fl->fl_owner);
 
-	pr_debug("ceph_lock_message: rule: %d, op: %d, owner: %llx, pid: %llu, start: %llu, length: %llu, wait: %d, type: %d\n",
-		 (int)lock_type,
+	pr_debug("%s: rule: %d, op: %d, owner: %llx, pid: %llu, start: %llu, length: %llu, wait: %d, type: %d\n",
+		 __func__, (int)lock_type,
 		 (int)operation, owner, (u64)fl->fl_pid, fl->fl_start, length,
 		 wait, fl->fl_type);
 
@@ -134,8 +134,8 @@ static int ceph_lock_message(u8 lock_type, u16 operation, struct inode *inode,
 
 	}
 	ceph_mdsc_put_request(req);
-	pr_debug("ceph_lock_message: rule: %d, op: %d, pid: %llu, start: %llu, length: %llu, wait: %d, type: %d, err code %d\n",
-		 (int)lock_type,
+	pr_debug("%s: rule: %d, op: %d, pid: %llu, start: %llu, length: %llu, wait: %d, type: %d, err code %d\n",
+		 __func__, (int)lock_type,
 		 (int)operation, (u64)fl->fl_pid, fl->fl_start,
 		 length, wait, fl->fl_type, err);
 	return err;
@@ -161,8 +161,7 @@ static int ceph_lock_wait_for_completion(struct ceph_mds_client *mdsc,
 	if (!err)
 		return 0;
 
-	pr_debug("ceph_lock_wait_for_completion: request %llu was interrupted\n",
-		 req->r_tid);
+	pr_debug("%s: request %llu was interrupted\n", __func__, req->r_tid);
 
 	mutex_lock(&mdsc->mutex);
 	if (test_bit(CEPH_MDS_R_GOT_RESULT, &req->r_req_flags)) {
@@ -244,7 +243,7 @@ int ceph_lock(struct file *file, int cmd, struct file_lock *fl)
 	if (__mandatory_lock(file->f_mapping->host) && fl->fl_type != F_UNLCK)
 		return -ENOLCK;
 
-	pr_debug("ceph_lock, fl_owner: %p\n", fl->fl_owner);
+	pr_debug("%s: fl_owner: %p\n", __func__, fl->fl_owner);
 
 	/* set wait bit as appropriate, then make command as Ceph expects it*/
 	if (IS_GETLK(cmd))
@@ -309,7 +308,7 @@ int ceph_flock(struct file *file, int cmd, struct file_lock *fl)
 	if (fl->fl_type & LOCK_MAND)
 		return -EOPNOTSUPP;
 
-	pr_debug("ceph_flock, fl_file: %p\n", fl->fl_file);
+	pr_debug("%s: fl_file: %p\n", __func__, fl->fl_file);
 
 	spin_lock(&ci->i_ceph_lock);
 	if (ci->i_ceph_flags & CEPH_I_ERROR_FILELOCK) {
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 1e1c51e396bd..658c24b7c119 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -890,7 +890,7 @@ static void __register_request(struct ceph_mds_client *mdsc,
 			return;
 		}
 	}
-	pr_debug("__register_request %p tid %lld\n", req, req->r_tid);
+	pr_debug("%s: %p tid %lld\n", __func__, req, req->r_tid);
 	ceph_mdsc_get_request(req);
 	insert_request(&mdsc->request_tree, req);
 
@@ -1478,7 +1478,7 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
 	struct rb_node *p;
 	struct ceph_inode_info *ci;
 
-	pr_debug("cleanup_session_requests mds%d\n", session->s_mds);
+	pr_debug("%s: mds%d\n", __func__, session->s_mds);
 	mutex_lock(&mdsc->mutex);
 	while (!list_empty(&session->s_unsafe)) {
 		req = list_first_entry(&session->s_unsafe,
@@ -1688,7 +1688,7 @@ static void remove_session_caps(struct ceph_mds_session *session)
 	struct super_block *sb = fsc->sb;
 	LIST_HEAD(dispose);
 
-	pr_debug("remove_session_caps on %p\n", session);
+	pr_debug("%s: on %p\n", __func__, session);
 	ceph_iterate_session_caps(session, remove_session_caps_cb, fsc);
 
 	wake_up_all(&fsc->mdsc->cap_flushing_wq);
@@ -1795,13 +1795,13 @@ static int send_renew_caps(struct ceph_mds_client *mdsc,
 	 * with its clients. */
 	state = ceph_mdsmap_get_state(mdsc->mdsmap, session->s_mds);
 	if (state < CEPH_MDS_STATE_RECONNECT) {
-		pr_debug("send_renew_caps ignoring mds%d (%s)\n",
-			 session->s_mds, ceph_mds_state_name(state));
+		pr_debug("%s: ignoring mds%d (%s)\n",
+			 __func__, session->s_mds, ceph_mds_state_name(state));
 		return 0;
 	}
 
-	pr_debug("send_renew_caps to mds%d (%s)\n",
-		 session->s_mds, ceph_mds_state_name(state));
+	pr_debug("%s: to mds%d (%s)\n",
+		 __func__, session->s_mds, ceph_mds_state_name(state));
 	msg = create_session_msg(CEPH_SESSION_REQUEST_RENEWCAPS,
 				 ++session->s_renew_seq);
 	if (!msg)
@@ -1815,8 +1815,8 @@ static int send_flushmsg_ack(struct ceph_mds_client *mdsc,
 {
 	struct ceph_msg *msg;
 
-	pr_debug("send_flushmsg_ack to mds%d (%s)s seq %lld\n",
-		 session->s_mds,
+	pr_debug("%s: to mds%d (%s)s seq %lld\n",
+		 __func__, session->s_mds,
 		 ceph_session_state_name(session->s_state), seq);
 	msg = create_session_msg(CEPH_SESSION_FLUSHMSG_ACK, seq);
 	if (!msg)
@@ -1851,8 +1851,8 @@ static void renewed_caps(struct ceph_mds_client *mdsc,
 			pr_info("mds%d caps still stale\n", session->s_mds);
 		}
 	}
-	pr_debug("renewed_caps mds%d ttl now %lu, was %s, now %s\n",
-		 session->s_mds, session->s_cap_ttl,
+	pr_debug("%s: mds%d ttl now %lu, was %s, now %s\n",
+		 __func__, session->s_mds, session->s_cap_ttl,
 		 was_stale ? "stale" : "fresh",
 		 time_before(jiffies, session->s_cap_ttl) ? "stale" : "fresh");
 	spin_unlock(&session->s_cap_lock);
@@ -1868,9 +1868,9 @@ static int request_close_session(struct ceph_mds_session *session)
 {
 	struct ceph_msg *msg;
 
-	pr_debug("request_close_session mds%d state %s seq %lld\n",
-		 session->s_mds, ceph_session_state_name(session->s_state),
-		 session->s_seq);
+	pr_debug("%s: mds%d state %s seq %lld\n",
+		 __func__, session->s_mds,
+		 ceph_session_state_name(session->s_state), session->s_seq);
 	msg = create_session_msg(CEPH_SESSION_REQUEST_CLOSE, session->s_seq);
 	if (!msg)
 		return -ENOMEM;
@@ -1938,8 +1938,9 @@ static int trim_caps_cb(struct inode *inode, struct ceph_cap *cap, void *arg)
 	wanted = __ceph_caps_file_wanted(ci);
 	oissued = __ceph_caps_issued_other(ci, cap);
 
-	pr_debug("trim_caps_cb %p cap %p mine %s oissued %s used %s wanted %s\n",
-		 inode, cap, ceph_cap_string(mine), ceph_cap_string(oissued),
+	pr_debug("%s: %p cap %p mine %s oissued %s used %s wanted %s\n",
+		 __func__, inode, cap,
+		 ceph_cap_string(mine), ceph_cap_string(oissued),
 		 ceph_cap_string(used), ceph_cap_string(wanted));
 	if (cap == ci->i_auth_cap) {
 		if (ci->i_dirty_caps || ci->i_flushing_caps ||
@@ -1980,8 +1981,8 @@ static int trim_caps_cb(struct inode *inode, struct ceph_cap *cap, void *arg)
 			count = atomic_read(&inode->i_count);
 			if (count == 1)
 				(*remaining)--;
-			pr_debug("trim_caps_cb %p cap %p pruned, count now %d\n",
-				 inode, cap, count);
+			pr_debug("%s: %p cap %p pruned, count now %d\n",
+				 __func__, inode, cap, count);
 		} else {
 			dput(dentry);
 		}
@@ -2028,8 +2029,8 @@ static int check_caps_flush(struct ceph_mds_client *mdsc,
 			list_first_entry(&mdsc->cap_flush_list,
 					 struct ceph_cap_flush, g_list);
 		if (cf->tid <= want_flush_tid) {
-			pr_debug("check_caps_flush still flushing tid %llu <= %llu\n",
-				 cf->tid, want_flush_tid);
+			pr_debug("%s: still flushing tid %llu <= %llu\n",
+				 __func__, cf->tid, want_flush_tid);
 			ret = 0;
 		}
 	}
@@ -2045,12 +2046,12 @@ static int check_caps_flush(struct ceph_mds_client *mdsc,
 static void wait_caps_flush(struct ceph_mds_client *mdsc,
 			    u64 want_flush_tid)
 {
-	pr_debug("check_caps_flush want %llu\n", want_flush_tid);
+	pr_debug("%s: want %llu\n", __func__, want_flush_tid);
 
 	wait_event(mdsc->cap_flushing_wq,
 		   check_caps_flush(mdsc, want_flush_tid));
 
-	pr_debug("check_caps_flush ok, flushed thru %llu\n", want_flush_tid);
+	pr_debug("%s: ok, flushed thru %llu\n", __func__, want_flush_tid);
 }
 
 /*
@@ -2863,7 +2864,7 @@ static void __do_request(struct ceph_mds_client *mdsc,
 	ceph_put_mds_session(session);
 finish:
 	if (err) {
-		pr_debug("__do_request early error %d\n", err);
+		pr_debug("%s: early error %d\n", __func__, err);
 		req->r_err = err;
 		complete_request(mdsc, req);
 		__unregister_request(mdsc, req);
@@ -2900,7 +2901,7 @@ static void kick_requests(struct ceph_mds_client *mdsc, int mds)
 	struct ceph_mds_request *req;
 	struct rb_node *p = rb_first(&mdsc->request_tree);
 
-	pr_debug("kick_requests mds%d\n", mds);
+	pr_debug("%s: mds%d\n", __func__, mds);
 	while (p) {
 		req = rb_entry(p, struct ceph_mds_request, r_node);
 		p = rb_next(p);
@@ -3086,11 +3087,11 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 	mutex_lock(&mdsc->mutex);
 	req = lookup_get_request(mdsc, tid);
 	if (!req) {
-		pr_debug("handle_reply on unknown tid %llu\n", tid);
+		pr_debug("%s: on unknown tid %llu\n", __func__, tid);
 		mutex_unlock(&mdsc->mutex);
 		return;
 	}
-	pr_debug("handle_reply %p\n", req);
+	pr_debug("%s: %p\n", __func__, req);
 
 	/* correct session? */
 	if (req->r_session != session) {
@@ -3173,7 +3174,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 		list_add_tail(&req->r_unsafe_item, &req->r_session->s_unsafe);
 	}
 
-	pr_debug("handle_reply tid %lld result %d\n", tid, result);
+	pr_debug("%s: tid %lld result %d\n", __func__, tid, result);
 	rinfo = &req->r_reply_info;
 	if (test_bit(CEPHFS_FEATURE_REPLY_ENCODING, &session->s_features))
 		err = parse_reply_info(session, msg, rinfo, (u64)-1);
@@ -3385,8 +3386,8 @@ static void handle_session(struct ceph_mds_session *session,
 
 	mutex_lock(&session->s_mutex);
 
-	pr_debug("handle_session mds%d %s %p state %s seq %llu\n",
-		 mds, ceph_session_op_name(op), session,
+	pr_debug("%s: mds%d %s %p state %s seq %llu\n",
+		 __func__, mds, ceph_session_op_name(op), session,
 		 ceph_session_state_name(session->s_state), seq);
 
 	if (session->s_state == CEPH_MDS_SESSION_HUNG) {
@@ -3516,7 +3517,7 @@ static void replay_unsafe_requests(struct ceph_mds_client *mdsc,
 	struct ceph_mds_request *req, *nreq;
 	struct rb_node *p;
 
-	pr_debug("replay_unsafe_requests mds%d\n", session->s_mds);
+	pr_debug("%s: mds%d\n", __func__, session->s_mds);
 
 	mutex_lock(&mdsc->mutex);
 	list_for_each_entry_safe(req, nreq, &session->s_unsafe, r_unsafe_item)
@@ -4058,8 +4059,8 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 	int oldstate, newstate;
 	struct ceph_mds_session *s;
 
-	pr_debug("check_new_map new %u old %u\n",
-		 newmap->m_epoch, oldmap->m_epoch);
+	pr_debug("%s: new %u old %u\n",
+		 __func__, newmap->m_epoch, oldmap->m_epoch);
 
 	for (i = 0; i < oldmap->possible_max_rank && i < mdsc->max_sessions; i++) {
 		if (!mdsc->sessions[i])
@@ -4068,8 +4069,8 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 		oldstate = ceph_mdsmap_get_state(oldmap, i);
 		newstate = ceph_mdsmap_get_state(newmap, i);
 
-		pr_debug("check_new_map mds%d state %s%s -> %s%s (session %s)\n",
-			 i, ceph_mds_state_name(oldstate),
+		pr_debug("%s: mds%d state %s%s -> %s%s (session %s)\n",
+			 __func__, i, ceph_mds_state_name(oldstate),
 			 ceph_mdsmap_is_laggy(oldmap, i) ? " (laggy)" : "",
 			 ceph_mds_state_name(newstate),
 			 ceph_mdsmap_is_laggy(newmap, i) ? " (laggy)" : "",
@@ -4184,7 +4185,7 @@ static void handle_lease(struct ceph_mds_client *mdsc,
 	struct qstr dname;
 	int release = 0;
 
-	pr_debug("handle_lease from mds%d\n", mds);
+	pr_debug("%s: from mds%d\n", __func__, mds);
 
 	/* decode */
 	if (msg->front.iov_len < sizeof(*h) + sizeof(u32))
@@ -4199,15 +4200,15 @@ static void handle_lease(struct ceph_mds_client *mdsc,
 
 	/* lookup inode */
 	inode = ceph_find_inode(sb, vino);
-	pr_debug("handle_lease %s, ino %llx %p %.*s\n",
-		 ceph_lease_op_name(h->action), vino.ino, inode,
+	pr_debug("%s: %s, ino %llx %p %.*s\n",
+		 __func__, ceph_lease_op_name(h->action), vino.ino, inode,
 		 dname.len, dname.name);
 
 	mutex_lock(&session->s_mutex);
 	session->s_seq++;
 
 	if (!inode) {
-		pr_debug("handle_lease no inode %llx\n", vino.ino);
+		pr_debug("%s: no inode %llx\n", __func__, vino.ino);
 		goto release;
 	}
 
@@ -4398,7 +4399,7 @@ static void delayed_work(struct work_struct *work)
 	int renew_interval;
 	int renew_caps;
 
-	pr_debug("mdsc delayed_work\n");
+	pr_debug("%s: mdsc\n", __func__);
 
 	if (mdsc->stopping)
 		return;
@@ -4542,21 +4543,21 @@ static void wait_requests(struct ceph_mds_client *mdsc)
 	if (__get_oldest_req(mdsc)) {
 		mutex_unlock(&mdsc->mutex);
 
-		pr_debug("wait_requests waiting for requests\n");
+		pr_debug("%s: waiting for requests\n", __func__);
 		wait_for_completion_timeout(&mdsc->safe_umount_waiters,
 				    ceph_timeout_jiffies(opts->mount_timeout));
 
 		/* tear down remaining requests */
 		mutex_lock(&mdsc->mutex);
 		while ((req = __get_oldest_req(mdsc))) {
-			pr_debug("wait_requests timed out on tid %llu\n",
-				 req->r_tid);
+			pr_debug("%s: timed out on tid %llu\n",
+				 __func__, req->r_tid);
 			list_del_init(&req->r_wait);
 			__unregister_request(mdsc, req);
 		}
 	}
 	mutex_unlock(&mdsc->mutex);
-	pr_debug("wait_requests done\n");
+	pr_debug("%s: done\n", __func__);
 }
 
 /*
@@ -4590,7 +4591,7 @@ static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
 	struct rb_node *n;
 
 	mutex_lock(&mdsc->mutex);
-	pr_debug("wait_unsafe_requests want %lld\n", want_tid);
+	pr_debug("%s: want %lld\n", __func__, want_tid);
 restart:
 	req = __get_oldest_req(mdsc);
 	while (req && req->r_tid <= want_tid) {
@@ -4607,8 +4608,8 @@ static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
 			if (nextreq)
 				ceph_mdsc_get_request(nextreq);
 			mutex_unlock(&mdsc->mutex);
-			pr_debug("wait_unsafe_requests  wait on %llu (want %llu)\n",
-				 req->r_tid, want_tid);
+			pr_debug("%s: wait on %llu (want %llu)\n",
+				 __func__, req->r_tid, want_tid);
 			wait_for_completion(&req->r_safe_completion);
 			mutex_lock(&mdsc->mutex);
 			ceph_mdsc_put_request(req);
@@ -4624,7 +4625,7 @@ static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
 		req = nextreq;
 	}
 	mutex_unlock(&mdsc->mutex);
-	pr_debug("wait_unsafe_requests done\n");
+	pr_debug("%s: done\n", __func__);
 }
 
 void ceph_mdsc_sync(struct ceph_mds_client *mdsc)
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 73ccfd4172ac..5f22df095acd 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -281,8 +281,8 @@ static int adjust_snap_realm_parent(struct ceph_mds_client *mdsc,
 		if (IS_ERR(parent))
 			return PTR_ERR(parent);
 	}
-	pr_debug("adjust_snap_realm_parent %llx %p: %llx %p -> %llx %p\n",
-		 realm->ino, realm, realm->parent_ino, realm->parent,
+	pr_debug("%s: %llx %p: %llx %p -> %llx %p\n",
+		 __func__, realm->ino, realm, realm->parent_ino, realm->parent,
 		 parentino, parent);
 	if (realm->parent) {
 		list_del_init(&realm->child_item);
@@ -338,8 +338,8 @@ static int build_snap_context(struct ceph_snap_realm *realm,
 	    realm->cached_context->seq == realm->seq &&
 	    (!parent ||
 	     realm->cached_context->seq >= parent->cached_context->seq)) {
-		pr_debug("build_snap_context %llx %p: %p seq %lld (%u snaps) (unchanged)\n",
-			 realm->ino, realm, realm->cached_context,
+		pr_debug("%s: %llx %p: %p seq %lld (%u snaps) (unchanged)\n",
+			 __func__, realm->ino, realm, realm->cached_context,
 			 realm->cached_context->seq,
 			 (unsigned int)realm->cached_context->num_snaps);
 		return 0;
@@ -378,8 +378,8 @@ static int build_snap_context(struct ceph_snap_realm *realm,
 
 	sort(snapc->snaps, num, sizeof(u64), cmpu64_rev, NULL);
 	snapc->num_snaps = num;
-	pr_debug("build_snap_context %llx %p: %p seq %lld (%u snaps)\n",
-		 realm->ino, realm, snapc, snapc->seq,
+	pr_debug("%s: %llx %p: %p seq %lld (%u snaps)\n",
+		 __func__, realm->ino, realm, snapc, snapc->seq,
 		 (unsigned int)snapc->num_snaps);
 
 	ceph_put_snap_context(realm->cached_context);
@@ -410,7 +410,7 @@ static void rebuild_snap_realms(struct ceph_snap_realm *realm,
 {
 	struct ceph_snap_realm *child;
 
-	pr_debug("rebuild_snap_realms %llx %p\n", realm->ino, realm);
+	pr_debug("%s: %llx %p\n", __func__, realm->ino, realm);
 	build_snap_context(realm, dirty_realms);
 
 	list_for_each_entry(child, &realm->children, child_item)
@@ -646,7 +646,7 @@ static void queue_realm_cap_snaps(struct ceph_snap_realm *realm)
 	struct ceph_inode_info *ci;
 	struct inode *lastinode = NULL;
 
-	pr_debug("queue_realm_cap_snaps %p %llx inodes\n", realm, realm->ino);
+	pr_debug("%s: %p %llx inodes\n", __func__, realm, realm->ino);
 
 	spin_lock(&realm->inodes_with_caps_lock);
 	list_for_each_entry(ci, &realm->inodes_with_caps, i_snap_realm_item) {
@@ -664,7 +664,7 @@ static void queue_realm_cap_snaps(struct ceph_snap_realm *realm)
 	spin_unlock(&realm->inodes_with_caps_lock);
 	ceph_async_iput(lastinode);
 
-	pr_debug("queue_realm_cap_snaps %p %llx done\n", realm, realm->ino);
+	pr_debug("%s: %p %llx done\n", __func__, realm, realm->ino);
 }
 
 /*
@@ -805,7 +805,7 @@ static void flush_snaps(struct ceph_mds_client *mdsc)
 	struct inode *inode;
 	struct ceph_mds_session *session = NULL;
 
-	pr_debug("flush_snaps\n");
+	pr_debug("%s\n", __func__);
 	spin_lock(&mdsc->snap_flush_lock);
 	while (!list_empty(&mdsc->snap_flush_list)) {
 		ci = list_first_entry(&mdsc->snap_flush_list,
@@ -825,7 +825,7 @@ static void flush_snaps(struct ceph_mds_client *mdsc)
 		mutex_unlock(&session->s_mutex);
 		ceph_put_mds_session(session);
 	}
-	pr_debug("flush_snaps done\n");
+	pr_debug("%s done\n", __func__);
 }
 
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 08dc6052d2b6..e7f079ebfbc4 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -726,7 +726,7 @@ static void destroy_fs_client(struct ceph_fs_client *fsc)
 	ceph_destroy_client(fsc->client);
 
 	kfree(fsc);
-	pr_debug("destroy_fs_client %p done\n", fsc);
+	pr_debug("%s: %p done\n", __func__, fsc);
 }
 
 /*
@@ -841,7 +841,7 @@ static void ceph_umount_begin(struct super_block *sb)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
 
-	pr_debug("ceph_umount_begin - starting forced umount\n");
+	pr_debug("%s: starting forced umount\n", __func__);
 	if (!fsc)
 		return;
 	fsc->mount_state = CEPH_MOUNT_SHUTDOWN;
@@ -1001,7 +1001,7 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
 	struct ceph_options *opt = new->client->options;
 	struct ceph_fs_client *other = ceph_sb_to_client(sb);
 
-	pr_debug("ceph_compare_super %p\n", sb);
+	pr_debug("%s: %p\n", __func__, sb);
 
 	if (compare_mount_options(fsopt, opt, other)) {
 		pr_debug("monitor(s)/mount options don't match\n");
@@ -1052,7 +1052,7 @@ static int ceph_get_tree(struct fs_context *fc)
 		ceph_compare_super;
 	int err;
 
-	pr_debug("ceph_get_tree\n");
+	pr_debug("%s\n", __func__);
 
 	if (!fc->source)
 		return invalfc(fc, "No source");
@@ -1115,7 +1115,7 @@ static int ceph_get_tree(struct fs_context *fc)
 out:
 	destroy_fs_client(fsc);
 out_final:
-	pr_debug("ceph_get_tree fail %d\n", err);
+	pr_debug("%s: fail %d\n", __func__, err);
 	return err;
 }
 
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 503d1edeb28d..6cdf6866c745 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -68,7 +68,7 @@ static ssize_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
 
 	pool_ns = ceph_try_get_string(ci->i_layout.pool_ns);
 
-	pr_debug("ceph_vxattrcb_layout %p\n", &ci->vfs_inode);
+	pr_debug("%s: %p\n", __func__, &ci->vfs_inode);
 	down_read(&osdc->lock);
 	pool_name = ceph_pg_pool_name_by_id(osdc->osdmap, pool);
 	if (pool_name) {
@@ -492,7 +492,7 @@ static int __set_xattr(struct ceph_inode_info *ci,
 		xattr->should_free_name = update_xattr;
 
 		ci->i_xattrs.count++;
-		pr_debug("__set_xattr count=%d\n", ci->i_xattrs.count);
+		pr_debug("%s: count=%d\n", __func__, ci->i_xattrs.count);
 	} else {
 		kfree(*newxattr);
 		*newxattr = NULL;
@@ -551,13 +551,13 @@ static struct ceph_inode_xattr *__get_xattr(struct ceph_inode_info *ci,
 		else if (c > 0)
 			p = &(*p)->rb_right;
 		else {
-			pr_debug("__get_xattr %s: found %.*s\n",
-				 name, xattr->val_len, xattr->val);
+			pr_debug("%s: %s: found %.*s\n",
+				 __func__, name, xattr->val_len, xattr->val);
 			return xattr;
 		}
 	}
 
-	pr_debug("__get_xattr %s: not found\n", name);
+	pr_debug("%s: %s: not found\n", __func__, name);
 
 	return NULL;
 }
@@ -602,7 +602,7 @@ static char *__copy_xattr_names(struct ceph_inode_info *ci,
 	struct ceph_inode_xattr *xattr = NULL;
 
 	p = rb_first(&ci->i_xattrs.index);
-	pr_debug("__copy_xattr_names count=%d\n", ci->i_xattrs.count);
+	pr_debug("%s: count=%d\n", __func__, ci->i_xattrs.count);
 
 	while (p) {
 		xattr = rb_entry(p, struct ceph_inode_xattr, node);
@@ -627,14 +627,14 @@ void __ceph_destroy_xattrs(struct ceph_inode_info *ci)
 
 	p = rb_first(&ci->i_xattrs.index);
 
-	pr_debug("__ceph_destroy_xattrs p=%p\n", p);
+	pr_debug("%s: p=%p\n", __func__, p);
 
 	while (p) {
 		xattr = rb_entry(p, struct ceph_inode_xattr, node);
 		tmp = p;
 		p = rb_next(tmp);
-		pr_debug("__ceph_destroy_xattrs next p=%p (%.*s)\n",
-			 p, xattr->name_len, xattr->name);
+		pr_debug("%s: next p=%p (%.*s)\n",
+			 __func__, p, xattr->name_len, xattr->name);
 		rb_erase(tmp, &ci->i_xattrs.index);
 
 		__free_xattr(xattr);
@@ -662,7 +662,8 @@ static int __build_xattrs(struct inode *inode)
 	int err = 0;
 	int i;
 
-	pr_debug("__build_xattrs() len=%d\n",
+	pr_debug("%s: len=%d\n",
+		 __func__,
 		 ci->i_xattrs.blob ? (int)ci->i_xattrs.blob->vec.iov_len : 0);
 
 	if (ci->i_xattrs.index_version >= ci->i_xattrs.version)
@@ -745,8 +746,8 @@ static int __get_required_blob_size(struct ceph_inode_info *ci, int name_size,
 	int size = 4 + ci->i_xattrs.count*(4 + 4) +
 			     ci->i_xattrs.names_size +
 			     ci->i_xattrs.vals_size;
-	pr_debug("__get_required_blob_size c=%d names.size=%d vals.size=%d\n",
-		 ci->i_xattrs.count, ci->i_xattrs.names_size,
+	pr_debug("%s: c=%d names.size=%d vals.size=%d\n",
+		 __func__, ci->i_xattrs.count, ci->i_xattrs.names_size,
 		 ci->i_xattrs.vals_size);
 
 	if (name_size)
-- 
2.26.0


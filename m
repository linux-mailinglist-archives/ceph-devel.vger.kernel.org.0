Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B29811314E8
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jan 2020 16:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgAFPf2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jan 2020 10:35:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:39416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbgAFPf1 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 10:35:27 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 656C7222D9;
        Mon,  6 Jan 2020 15:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578324925;
        bh=DRFdd61PjNwMgk8vForIi1i0/ynTH/pdz+mg/oSJNVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQMKhLxA67wrfx4lD9azLQ6WIRBLWVaploLQgVay0GH7smwwEDELQBBAEbJTFGSGU
         Kzc12hbeyS+a0TM1RjXUzj6Bh6o668JJYL+Eh1o0TMYBzDzBKX01cmfHxjICnLpkAb
         9HToLnsDVqSHRlIRW1SOjY7j0wUeA/NYMR3L3rKQ=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH 5/6] ceph: check inode type for CEPH_CAP_FILE_{CACHE,RD,REXTEND,LAZYIO}
Date:   Mon,  6 Jan 2020 10:35:19 -0500
Message-Id: <20200106153520.307523-6-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200106153520.307523-1-jlayton@kernel.org>
References: <20200106153520.307523-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: "Yan, Zheng" <zyan@redhat.com>

These bits will have new meaning for directory inodes.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/caps.c       | 44 ++++++++++++++++++++++++++++++++------------
 fs/ceph/mds_client.c |  3 ++-
 fs/ceph/super.h      | 12 +-----------
 3 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 1a17f19fd8ad..d05717397c2a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -573,7 +573,8 @@ static void __check_cap_issue(struct ceph_inode_info *ci, struct ceph_cap *cap,
 	 * Each time we receive FILE_CACHE anew, we increment
 	 * i_rdcache_gen.
 	 */
-	if ((issued & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) &&
+	if (S_ISREG(ci->vfs_inode.i_mode) &&
+	    (issued & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) &&
 	    (had & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0) {
 		ci->i_rdcache_gen++;
 	}
@@ -958,7 +959,7 @@ int __ceph_caps_used(struct ceph_inode_info *ci)
 	if (ci->i_rd_ref)
 		used |= CEPH_CAP_FILE_RD;
 	if (ci->i_rdcache_ref ||
-	    (!S_ISDIR(ci->vfs_inode.i_mode) && /* ignore readdir cache */
+	    (S_ISREG(ci->vfs_inode.i_mode) &&
 	     ci->vfs_inode.i_data.nrpages))
 		used |= CEPH_CAP_FILE_CACHE;
 	if (ci->i_wr_ref)
@@ -985,6 +986,20 @@ int __ceph_caps_file_wanted(struct ceph_inode_info *ci)
 	return ceph_caps_for_mode(bits >> 1);
 }
 
+/*
+ * wanted, by virtue of open file modes AND cap refs (buffered/cached data)
+ */
+int __ceph_caps_wanted(struct ceph_inode_info *ci)
+{
+	int w = __ceph_caps_file_wanted(ci) | __ceph_caps_used(ci);
+	if (!S_ISDIR(ci->vfs_inode.i_mode)) {
+		/* we want EXCL if dirty data */
+		if (w & CEPH_CAP_FILE_BUFFER)
+			w |= CEPH_CAP_FILE_EXCL;
+	}
+	return w;
+}
+
 /*
  * Return caps we have registered with the MDS(s) as 'wanted'.
  */
@@ -1903,7 +1918,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 	 * If we fail, it's because pages are locked.... try again later.
 	 */
 	if ((!no_delay || mdsc->stopping) &&
-	    !S_ISDIR(inode->i_mode) &&		/* ignore readdir cache */
+	    S_ISREG(inode->i_mode) &&
 	    !(ci->i_wb_ref || ci->i_wrbuffer_ref) &&   /* no dirty pages... */
 	    inode->i_data.nrpages &&		/* have cached pages */
 	    (revoking & (CEPH_CAP_FILE_CACHE|
@@ -2635,7 +2650,8 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 				snap_rwsem_locked = true;
 			}
 			*got = need | (have & want);
-			if ((need & CEPH_CAP_FILE_RD) &&
+			if (S_ISREG(inode->i_mode) &&
+			    (need & CEPH_CAP_FILE_RD) &&
 			    !(*got & CEPH_CAP_FILE_CACHE))
 				ceph_disable_fscache_readpage(ci);
 			__take_cap_refs(ci, *got, true);
@@ -2643,7 +2659,8 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 		}
 	} else {
 		int session_readonly = false;
-		if ((need & CEPH_CAP_FILE_WR) && ci->i_auth_cap) {
+		if (ci->i_auth_cap &&
+		    (need & (CEPH_CAP_FILE_WR | CEPH_CAP_FILE_EXCL))) {
 			struct ceph_mds_session *s = ci->i_auth_cap->session;
 			spin_lock(&s->s_cap_lock);
 			session_readonly = s->s_readonly;
@@ -2817,7 +2834,8 @@ int ceph_get_caps(struct file *filp, int need, int want,
 			return ret;
 		}
 
-		if (ci->i_inline_version != CEPH_INLINE_NONE &&
+		if (S_ISREG(ci->vfs_inode.i_mode) &&
+		    ci->i_inline_version != CEPH_INLINE_NONE &&
 		    (_got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) &&
 		    i_size_read(inode) > 0) {
 			struct page *page =
@@ -2850,7 +2868,8 @@ int ceph_get_caps(struct file *filp, int need, int want,
 		break;
 	}
 
-	if ((_got & CEPH_CAP_FILE_RD) && (_got & CEPH_CAP_FILE_CACHE))
+	if (S_ISREG(ci->vfs_inode.i_mode) &&
+	    (_got & CEPH_CAP_FILE_RD) && (_got & CEPH_CAP_FILE_CACHE))
 		ceph_fscache_revalidate_cookie(ci);
 
 	*got = _got;
@@ -3140,7 +3159,7 @@ static void handle_cap_grant(struct inode *inode,
 	 * try to invalidate (once).  (If there are dirty buffers, we
 	 * will invalidate _after_ writeback.)
 	 */
-	if (!S_ISDIR(inode->i_mode) && /* don't invalidate readdir cache */
+	if (S_ISREG(inode->i_mode) && /* don't invalidate readdir cache */
 	    ((cap->issued & ~newcaps) & CEPH_CAP_FILE_CACHE) &&
 	    (newcaps & CEPH_CAP_FILE_LAZYIO) == 0 &&
 	    !(ci->i_wrbuffer_ref || ci->i_wb_ref)) {
@@ -3304,11 +3323,12 @@ static void handle_cap_grant(struct inode *inode,
 		     ceph_cap_string(cap->issued),
 		     ceph_cap_string(newcaps),
 		     ceph_cap_string(revoking));
-		if (revoking & used & CEPH_CAP_FILE_BUFFER)
+		if (S_ISREG(inode->i_mode) &&
+		    (revoking & used & CEPH_CAP_FILE_BUFFER))
 			writeback = true;  /* initiate writeback; will delay ack */
-		else if (revoking == CEPH_CAP_FILE_CACHE &&
-			 (newcaps & CEPH_CAP_FILE_LAZYIO) == 0 &&
-			 queue_invalidate)
+		else if (queue_invalidate &&
+			 revoking == CEPH_CAP_FILE_CACHE &&
+			 (newcaps & CEPH_CAP_FILE_LAZYIO) == 0)
 			; /* do nothing yet, invalidation will be queued */
 		else if (cap == ci->i_auth_cap)
 			check_caps = 1; /* check auth cap only */
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d334bbf7a4f9..9a2264250615 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1768,7 +1768,8 @@ static int trim_caps_cb(struct inode *inode, struct ceph_cap *cap, void *arg)
 	}
 	/* The inode has cached pages, but it's no longer used.
 	 * we can safely drop it */
-	if (wanted == 0 && used == CEPH_CAP_FILE_CACHE &&
+	if (S_ISREG(inode->i_mode) &&
+	    wanted == 0 && used == CEPH_CAP_FILE_CACHE &&
 	    !(oissued & CEPH_CAP_FILE_CACHE)) {
 	  used = 0;
 	  oissued = 0;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 5934261f37e4..4b53f32b9324 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -673,17 +673,7 @@ extern int ceph_caps_revoking(struct ceph_inode_info *ci, int mask);
 extern int __ceph_caps_used(struct ceph_inode_info *ci);
 
 extern int __ceph_caps_file_wanted(struct ceph_inode_info *ci);
-
-/*
- * wanted, by virtue of open file modes AND cap refs (buffered/cached data)
- */
-static inline int __ceph_caps_wanted(struct ceph_inode_info *ci)
-{
-	int w = __ceph_caps_file_wanted(ci) | __ceph_caps_used(ci);
-	if (w & CEPH_CAP_FILE_BUFFER)
-		w |= CEPH_CAP_FILE_EXCL;  /* we want EXCL if dirty data */
-	return w;
-}
+extern int __ceph_caps_wanted(struct ceph_inode_info *ci);
 
 /* what the mds thinks we want */
 extern int __ceph_caps_mds_wanted(struct ceph_inode_info *ci, bool check);
-- 
2.24.1


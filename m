Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4902E19FE36
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Apr 2020 21:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgDFTmd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Apr 2020 15:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726225AbgDFTmd (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 6 Apr 2020 15:42:33 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D406D2072A;
        Mon,  6 Apr 2020 19:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586202152;
        bh=r0tu5B/rwsLYsjx1ORTpmaFKlbUU4jgShxGh3tN0hvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXc82AHIuKLuL0MgbnUPGSod7RHVmRLnA0bBvrt6H5GLHheijYTWsPsEANDMkDC2P
         KFbkqKMvfJ/rddiTxXy8dPP0YucspHbKiv48FDlKU2UHaRhGbt1+Kq8rhMnKLoLx4F
         7iHRxgBkX7sfSa6ySfi4pGQv/uGRNDLZ9W1SQkP8=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com,
        jfajerski@suse.com, lhenriques@suse.com, gfarnum@redhat.com
Subject: [PATCH v3 1/2] ceph: convert mdsc->cap_dirty to a per-session list
Date:   Mon,  6 Apr 2020 15:42:27 -0400
Message-Id: <20200406194228.52418-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200406194228.52418-1-jlayton@kernel.org>
References: <20200406194228.52418-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is a per-sb list now, but that makes it difficult to tell when
the cap is the last dirty one associated with the session. Switch
this to be a per-session list, but continue using the
mdsc->cap_dirty_lock to protect the lists.

This list is only ever walked in ceph_flush_dirty_caps, so change that
to walk the sessions array and then flush the caps for inodes on each
session's list.

If the auth cap ever changes while the inode has dirty caps, then
move the inode to the appropriate session for the new auth_cap. Also,
ensure that we never remove an auth cap while the inode is still on the
s_cap_dirty list.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c       | 78 ++++++++++++++++++++++++++++++++++++--------
 fs/ceph/mds_client.c |  2 +-
 fs/ceph/mds_client.h |  5 +--
 fs/ceph/super.h      | 19 +++++++++--
 4 files changed, 85 insertions(+), 19 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 61808793e0c0..b27bca0e9651 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -597,6 +597,27 @@ static void __check_cap_issue(struct ceph_inode_info *ci, struct ceph_cap *cap,
 	}
 }
 
+/**
+ * change_auth_cap_ses - move inode to appropriate lists when auth caps change
+ * @ci: inode to be moved
+ * @session: new auth caps session
+ */
+static void change_auth_cap_ses(struct ceph_inode_info *ci,
+				struct ceph_mds_session *session)
+{
+	lockdep_assert_held(&ci->i_ceph_lock);
+
+	if (list_empty(&ci->i_dirty_item) && list_empty(&ci->i_flushing_item))
+		return;
+
+	spin_lock(&session->s_mdsc->cap_dirty_lock);
+	if (!list_empty(&ci->i_dirty_item))
+		list_move(&ci->i_dirty_item, &session->s_cap_dirty);
+	if (!list_empty(&ci->i_flushing_item))
+		list_move_tail(&ci->i_flushing_item, &session->s_cap_flushing);
+	spin_unlock(&session->s_mdsc->cap_dirty_lock);
+}
+
 /*
  * Add a capability under the given MDS session.
  *
@@ -727,6 +748,9 @@ void ceph_add_cap(struct inode *inode,
 	if (flags & CEPH_CAP_FLAG_AUTH) {
 		if (!ci->i_auth_cap ||
 		    ceph_seq_cmp(ci->i_auth_cap->mseq, mseq) < 0) {
+			if (ci->i_auth_cap &&
+			    ci->i_auth_cap->session != cap->session)
+				change_auth_cap_ses(ci, cap->session);
 			ci->i_auth_cap = cap;
 			cap->mds_wanted = wanted;
 		}
@@ -1123,8 +1147,10 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 
 	/* remove from inode's cap rbtree, and clear auth cap */
 	rb_erase(&cap->ci_node, &ci->i_caps);
-	if (ci->i_auth_cap == cap)
+	if (ci->i_auth_cap == cap) {
+		WARN_ON_ONCE(!list_empty(&ci->i_dirty_item));
 		ci->i_auth_cap = NULL;
+	}
 
 	/* remove from session list */
 	spin_lock(&session->s_cap_lock);
@@ -1690,6 +1716,8 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
 	     ceph_cap_string(was | mask));
 	ci->i_dirty_caps |= mask;
 	if (was == 0) {
+		struct ceph_mds_session *session = ci->i_auth_cap->session;
+
 		WARN_ON_ONCE(ci->i_prealloc_cap_flush);
 		swap(ci->i_prealloc_cap_flush, *pcf);
 
@@ -1702,7 +1730,7 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
 		     &ci->vfs_inode, ci->i_head_snapc, ci->i_auth_cap);
 		BUG_ON(!list_empty(&ci->i_dirty_item));
 		spin_lock(&mdsc->cap_dirty_lock);
-		list_add(&ci->i_dirty_item, &mdsc->cap_dirty);
+		list_add(&ci->i_dirty_item, &session->s_cap_dirty);
 		spin_unlock(&mdsc->cap_dirty_lock);
 		if (ci->i_flushing_caps == 0) {
 			ihold(inode);
@@ -3750,15 +3778,9 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 			tcap->issue_seq = t_seq - 1;
 			tcap->issued |= issued;
 			tcap->implemented |= issued;
-			if (cap == ci->i_auth_cap)
+			if (cap == ci->i_auth_cap) {
 				ci->i_auth_cap = tcap;
-
-			if (!list_empty(&ci->i_cap_flush_list) &&
-			    ci->i_auth_cap == tcap) {
-				spin_lock(&mdsc->cap_dirty_lock);
-				list_move_tail(&ci->i_flushing_item,
-					       &tcap->session->s_cap_flushing);
-				spin_unlock(&mdsc->cap_dirty_lock);
+				change_auth_cap_ses(ci, tcap->session);
 			}
 		}
 		__ceph_remove_cap(cap, false);
@@ -4176,15 +4198,16 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 /*
  * Flush all dirty caps to the mds
  */
-void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc)
+static void flush_dirty_session_caps(struct ceph_mds_session *s)
 {
+	struct ceph_mds_client *mdsc = s->s_mdsc;
 	struct ceph_inode_info *ci;
 	struct inode *inode;
 
 	dout("flush_dirty_caps\n");
 	spin_lock(&mdsc->cap_dirty_lock);
-	while (!list_empty(&mdsc->cap_dirty)) {
-		ci = list_first_entry(&mdsc->cap_dirty, struct ceph_inode_info,
+	while (!list_empty(&s->s_cap_dirty)) {
+		ci = list_first_entry(&s->s_cap_dirty, struct ceph_inode_info,
 				      i_dirty_item);
 		inode = &ci->vfs_inode;
 		ihold(inode);
@@ -4198,6 +4221,35 @@ void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc)
 	dout("flush_dirty_caps done\n");
 }
 
+static void iterate_sessions(struct ceph_mds_client *mdsc,
+			     void (*cb)(struct ceph_mds_session *))
+{
+	int mds;
+
+	mutex_lock(&mdsc->mutex);
+	for (mds = 0; mds < mdsc->max_sessions; ++mds) {
+		struct ceph_mds_session *s;
+
+		if (!mdsc->sessions[mds])
+			continue;
+
+		s = ceph_get_mds_session(mdsc->sessions[mds]);
+		if (!s)
+			continue;
+
+		mutex_unlock(&mdsc->mutex);
+		cb(s);
+		ceph_put_mds_session(s);
+		mutex_lock(&mdsc->mutex);
+	};
+	mutex_unlock(&mdsc->mutex);
+}
+
+void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc)
+{
+	iterate_sessions(mdsc, flush_dirty_session_caps);
+}
+
 void __ceph_touch_fmode(struct ceph_inode_info *ci,
 			struct ceph_mds_client *mdsc, int fmode)
 {
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 9a8e7013aca1..be4ad7d28e3a 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -755,6 +755,7 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 	INIT_LIST_HEAD(&s->s_cap_releases);
 	INIT_WORK(&s->s_cap_release_work, ceph_cap_release_work);
 
+	INIT_LIST_HEAD(&s->s_cap_dirty);
 	INIT_LIST_HEAD(&s->s_cap_flushing);
 
 	mdsc->sessions[mds] = s;
@@ -4375,7 +4376,6 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	spin_lock_init(&mdsc->snap_flush_lock);
 	mdsc->last_cap_flush_tid = 1;
 	INIT_LIST_HEAD(&mdsc->cap_flush_list);
-	INIT_LIST_HEAD(&mdsc->cap_dirty);
 	INIT_LIST_HEAD(&mdsc->cap_dirty_migrating);
 	mdsc->num_cap_flushing = 0;
 	spin_lock_init(&mdsc->cap_dirty_lock);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 8065863321fc..bd20257fb4c2 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -199,8 +199,10 @@ struct ceph_mds_session {
 	struct list_head  s_cap_releases; /* waiting cap_release messages */
 	struct work_struct s_cap_release_work;
 
-	/* protected by mutex */
+	/* both protected by s_mdsc->cap_dirty_lock */
+	struct list_head  s_cap_dirty;	      /* inodes w/ dirty caps */
 	struct list_head  s_cap_flushing;     /* inodes w/ flushing caps */
+
 	unsigned long     s_renew_requested; /* last time we sent a renew req */
 	u64               s_renew_seq;
 
@@ -424,7 +426,6 @@ struct ceph_mds_client {
 
 	u64               last_cap_flush_tid;
 	struct list_head  cap_flush_list;
-	struct list_head  cap_dirty;        /* inodes with dirty caps */
 	struct list_head  cap_dirty_migrating; /* ...that are migration... */
 	int               num_cap_flushing; /* # caps we are flushing */
 	spinlock_t        cap_dirty_lock;   /* protects above items */
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index bb372859c0ad..3a95395a4217 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -351,9 +351,22 @@ struct ceph_inode_info {
 	struct rb_root i_caps;           /* cap list */
 	struct ceph_cap *i_auth_cap;     /* authoritative cap, if any */
 	unsigned i_dirty_caps, i_flushing_caps;     /* mask of dirtied fields */
-	struct list_head i_dirty_item, i_flushing_item; /* protected by
-							 * mdsc->cap_dirty_lock
-							 */
+
+	/*
+	 * Link to the the auth cap's session's s_cap_dirty list. s_cap_dirty
+	 * is protected by the mdsc->cap_dirty_lock, but each individual item
+	 * is also protected by the inode's i_ceph_lock. Walking s_cap_dirty
+	 * requires the mdsc->cap_dirty_lock. List presence for an item can
+	 * be tested under the i_ceph_lock. Changing anything requires both.
+	 */
+	struct list_head i_dirty_item;
+
+	/*
+	 * Link to session's s_cap_flushing list. Protected by
+	 * mdsc->cap_dirty_lock.
+	 */
+	struct list_head i_flushing_item;
+
 	/* we need to track cap writeback on a per-cap-bit basis, to allow
 	 * overlapping, pipelined cap flushes to the mds.  we can probably
 	 * reduce the tid to 8 bits if we're concerned about inode size. */
-- 
2.25.1


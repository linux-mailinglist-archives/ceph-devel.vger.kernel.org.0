Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F829192A94
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Mar 2020 14:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbgCYN6D (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Mar 2020 09:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbgCYN6C (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 25 Mar 2020 09:58:02 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 970A520663;
        Wed, 25 Mar 2020 13:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585144682;
        bh=aGWXu2zWaDAOzxxvXRs4zveQIUHxABveeKkQ7ndQ3X0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iq/vvMXXTd+CPuZEIZvRB/xhfwopUPw+jDTzOr4SlbsBylgLnzlqyywuRXCHuyrmv
         QjVG+08UJzGk23OxYl/cgB+sK2e94kzN0UDZ8GYTWKLliiHYUNEafmg5q7U8j+vuvD
         oVv7VTmwtaG7fty3TfFKHJ6XHV22t1zXVvuCgWHE=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com
Subject: [PATCH v2] ceph: reorganize __send_cap for less spinlock abuse
Date:   Wed, 25 Mar 2020 09:57:59 -0400
Message-Id: <20200325135759.25655-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323160708.104152-2-jlayton@kernel.org>
References: <20200323160708.104152-2-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Get rid of the __releases annotation by breaking it up into two
functions: __prep_cap which is done under the spinlock and __send_cap
that is done outside it. Add new fields to cap_msg_args for the wake
boolean and old_xattr_buf pointer.

Nothing checks the return value from __send_cap, so make it void
return.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 164 ++++++++++++++++++++++++++-----------------------
 1 file changed, 86 insertions(+), 78 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 779433847f20..2146433a1850 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1181,6 +1181,7 @@ struct cap_msg_args {
 	u64			xattr_version;
 	u64			change_attr;
 	struct ceph_buffer	*xattr_buf;
+	struct ceph_buffer	*old_xattr_buf;
 	struct timespec64	atime, mtime, ctime, btime;
 	int			op, caps, wanted, dirty;
 	u32			seq, issue_seq, mseq, time_warp_seq;
@@ -1189,6 +1190,7 @@ struct cap_msg_args {
 	kgid_t			gid;
 	umode_t			mode;
 	bool			inline_data;
+	bool			wake;
 };
 
 /*
@@ -1318,44 +1320,29 @@ void __ceph_remove_caps(struct ceph_inode_info *ci)
 }
 
 /*
- * Send a cap msg on the given inode.  Update our caps state, then
- * drop i_ceph_lock and send the message.
+ * Prepare to send a cap message to an MDS. Update the cap state, and populate
+ * the arg struct with the parameters that will need to be sent. This should
+ * be done under the i_ceph_lock to guard against changes to cap state.
  *
  * Make note of max_size reported/requested from mds, revoked caps
  * that have now been implemented.
- *
- * Return non-zero if delayed release, or we experienced an error
- * such that the caller should requeue + retry later.
- *
- * called with i_ceph_lock, then drops it.
- * caller should hold snap_rwsem (read), s_mutex.
  */
-static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
-		      int op, int flags, int used, int want, int retain,
-		      int flushing, u64 flush_tid, u64 oldest_flush_tid)
-	__releases(cap->ci->i_ceph_lock)
+static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
+		       int op, int flags, int used, int want, int retain,
+		       int flushing, u64 flush_tid, u64 oldest_flush_tid)
 {
 	struct ceph_inode_info *ci = cap->ci;
 	struct inode *inode = &ci->vfs_inode;
-	struct ceph_buffer *old_blob = NULL;
-	struct cap_msg_args arg;
 	int held, revoking;
-	int wake = 0;
-	int ret;
 
-	/* Don't send anything if it's still being created. Return delayed */
-	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
-		spin_unlock(&ci->i_ceph_lock);
-		dout("%s async create in flight for %p\n", __func__, inode);
-		return 1;
-	}
+	lockdep_assert_held(&ci->i_ceph_lock);
 
 	held = cap->issued | cap->implemented;
 	revoking = cap->implemented & ~cap->issued;
 	retain &= ~revoking;
 
-	dout("__send_cap %p cap %p session %p %s -> %s (revoking %s)\n",
-	     inode, cap, cap->session,
+	dout("%s %p cap %p session %p %s -> %s (revoking %s)\n",
+	     __func__, inode, cap, cap->session,
 	     ceph_cap_string(held), ceph_cap_string(held & retain),
 	     ceph_cap_string(revoking));
 	BUG_ON((retain & CEPH_CAP_PIN) == 0);
@@ -1363,60 +1350,52 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
 	ci->i_ceph_flags &= ~CEPH_I_FLUSH;
 
 	cap->issued &= retain;  /* drop bits we don't want */
-	if (cap->implemented & ~cap->issued) {
-		/*
-		 * Wake up any waiters on wanted -> needed transition.
-		 * This is due to the weird transition from buffered
-		 * to sync IO... we need to flush dirty pages _before_
-		 * allowing sync writes to avoid reordering.
-		 */
-		wake = 1;
-	}
 	cap->implemented &= cap->issued | used;
 	cap->mds_wanted = want;
 
-	arg.session = cap->session;
-	arg.ino = ceph_vino(inode).ino;
-	arg.cid = cap->cap_id;
-	arg.follows = flushing ? ci->i_head_snapc->seq : 0;
-	arg.flush_tid = flush_tid;
-	arg.oldest_flush_tid = oldest_flush_tid;
+	arg->session = cap->session;
+	arg->ino = ceph_vino(inode).ino;
+	arg->cid = cap->cap_id;
+	arg->follows = flushing ? ci->i_head_snapc->seq : 0;
+	arg->flush_tid = flush_tid;
+	arg->oldest_flush_tid = oldest_flush_tid;
 
-	arg.size = inode->i_size;
-	ci->i_reported_size = arg.size;
-	arg.max_size = ci->i_wanted_max_size;
+	arg->size = inode->i_size;
+	ci->i_reported_size = arg->size;
+	arg->max_size = ci->i_wanted_max_size;
 	if (cap == ci->i_auth_cap)
-		ci->i_requested_max_size = arg.max_size;
+		ci->i_requested_max_size = arg->max_size;
 
 	if (flushing & CEPH_CAP_XATTR_EXCL) {
-		old_blob = __ceph_build_xattrs_blob(ci);
-		arg.xattr_version = ci->i_xattrs.version;
-		arg.xattr_buf = ci->i_xattrs.blob;
+		arg->old_xattr_buf = __ceph_build_xattrs_blob(ci);
+		arg->xattr_version = ci->i_xattrs.version;
+		arg->xattr_buf = ci->i_xattrs.blob;
 	} else {
-		arg.xattr_buf = NULL;
+		arg->xattr_buf = NULL;
+		arg->old_xattr_buf = NULL;
 	}
 
-	arg.mtime = inode->i_mtime;
-	arg.atime = inode->i_atime;
-	arg.ctime = inode->i_ctime;
-	arg.btime = ci->i_btime;
-	arg.change_attr = inode_peek_iversion_raw(inode);
+	arg->mtime = inode->i_mtime;
+	arg->atime = inode->i_atime;
+	arg->ctime = inode->i_ctime;
+	arg->btime = ci->i_btime;
+	arg->change_attr = inode_peek_iversion_raw(inode);
 
-	arg.op = op;
-	arg.caps = cap->implemented;
-	arg.wanted = want;
-	arg.dirty = flushing;
+	arg->op = op;
+	arg->caps = cap->implemented;
+	arg->wanted = want;
+	arg->dirty = flushing;
 
-	arg.seq = cap->seq;
-	arg.issue_seq = cap->issue_seq;
-	arg.mseq = cap->mseq;
-	arg.time_warp_seq = ci->i_time_warp_seq;
+	arg->seq = cap->seq;
+	arg->issue_seq = cap->issue_seq;
+	arg->mseq = cap->mseq;
+	arg->time_warp_seq = ci->i_time_warp_seq;
 
-	arg.uid = inode->i_uid;
-	arg.gid = inode->i_gid;
-	arg.mode = inode->i_mode;
+	arg->uid = inode->i_uid;
+	arg->gid = inode->i_gid;
+	arg->mode = inode->i_mode;
 
-	arg.inline_data = ci->i_inline_version != CEPH_INLINE_NONE;
+	arg->inline_data = ci->i_inline_version != CEPH_INLINE_NONE;
 	if (!(flags & CEPH_CLIENT_CAPS_PENDING_CAPSNAP) &&
 	    !list_empty(&ci->i_cap_snaps)) {
 		struct ceph_cap_snap *capsnap;
@@ -1429,27 +1408,42 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
 			}
 		}
 	}
-	arg.flags = flags;
+	arg->flags = flags;
 
-	spin_unlock(&ci->i_ceph_lock);
+	/*
+	 * Wake up any waiters on wanted -> needed transition. This is due to
+	 * the weird transition from buffered to sync IO... we need to flush
+	 * dirty pages _before_ allowing sync writes to avoid reordering.
+	 */
+	arg->wake = cap->implemented & ~cap->issued;
+}
 
-	ceph_buffer_put(old_blob);
+/*
+ * Send a cap msg on the given inode.
+ *
+ * Caller should hold snap_rwsem (read), s_mutex.
+ */
+static void __send_cap(struct ceph_mds_client *mdsc, struct cap_msg_args *arg,
+		       struct ceph_inode_info *ci)
+{
+	struct inode *inode = &ci->vfs_inode;
+	int ret;
 
-	ret = send_cap_msg(&arg);
+	ret = send_cap_msg(arg);
 	if (ret < 0) {
 		pr_err("error sending cap msg, ino (%llx.%llx) "
 		       "flushing %s tid %llu, requeue\n",
-		       ceph_vinop(inode), ceph_cap_string(flushing),
-		       flush_tid);
+		       ceph_vinop(inode), ceph_cap_string(arg->dirty),
+		       arg->flush_tid);
 		spin_lock(&ci->i_ceph_lock);
 		__cap_delay_requeue(mdsc, ci);
 		spin_unlock(&ci->i_ceph_lock);
 	}
 
-	if (wake)
-		wake_up_all(&ci->i_cap_wq);
+	ceph_buffer_put(arg->old_xattr_buf);
 
-	return ret;
+	if (arg->wake)
+		wake_up_all(&ci->i_cap_wq);
 }
 
 static inline int __send_flush_snap(struct inode *inode,
@@ -1470,6 +1464,7 @@ static inline int __send_flush_snap(struct inode *inode,
 	arg.max_size = 0;
 	arg.xattr_version = capsnap->xattr_version;
 	arg.xattr_buf = capsnap->xattr_blob;
+	arg.old_xattr_buf = NULL;
 
 	arg.atime = capsnap->atime;
 	arg.mtime = capsnap->mtime;
@@ -1493,6 +1488,7 @@ static inline int __send_flush_snap(struct inode *inode,
 
 	arg.inline_data = capsnap->inline_data;
 	arg.flags = 0;
+	arg.wake = false;
 
 	return send_cap_msg(&arg);
 }
@@ -1967,6 +1963,8 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 	}
 
 	for (p = rb_first(&ci->i_caps); p; p = rb_next(p)) {
+		struct cap_msg_args arg;
+
 		cap = rb_entry(p, struct ceph_cap, ci_node);
 
 		/* avoid looping forever */
@@ -2094,9 +2092,12 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 
 		mds = cap->mds;  /* remember mds, so we don't repeat */
 
-		/* __send_cap drops i_ceph_lock */
-		__send_cap(mdsc, cap, CEPH_CAP_OP_UPDATE, 0, cap_used, want,
+		__prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE, 0, cap_used, want,
 			   retain, flushing, flush_tid, oldest_flush_tid);
+		spin_unlock(&ci->i_ceph_lock);
+
+		__send_cap(mdsc, &arg, ci);
+
 		goto retry; /* retake i_ceph_lock and restart our cap scan. */
 	}
 
@@ -2135,6 +2136,7 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
 retry_locked:
 	if (ci->i_dirty_caps && ci->i_auth_cap) {
 		struct ceph_cap *cap = ci->i_auth_cap;
+		struct cap_msg_args arg;
 
 		if (session != cap->session) {
 			spin_unlock(&ci->i_ceph_lock);
@@ -2162,11 +2164,13 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
 		flush_tid = __mark_caps_flushing(inode, session, true,
 						 &oldest_flush_tid);
 
-		/* __send_cap drops i_ceph_lock */
-		__send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH, CEPH_CLIENT_CAPS_SYNC,
+		__prep_cap(&arg, cap, CEPH_CAP_OP_FLUSH, CEPH_CLIENT_CAPS_SYNC,
 			   __ceph_caps_used(ci), __ceph_caps_wanted(ci),
 			   (cap->issued | cap->implemented),
 			   flushing, flush_tid, oldest_flush_tid);
+		spin_unlock(&ci->i_ceph_lock);
+
+		__send_cap(mdsc, &arg, ci);
 	} else {
 		if (!list_empty(&ci->i_cap_flush_list)) {
 			struct ceph_cap_flush *cf =
@@ -2368,15 +2372,19 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
 		first_tid = cf->tid + 1;
 
 		if (cf->caps) {
+			struct cap_msg_args arg;
+
 			dout("kick_flushing_caps %p cap %p tid %llu %s\n",
 			     inode, cap, cf->tid, ceph_cap_string(cf->caps));
-			__send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH,
+			__prep_cap(&arg, cap, CEPH_CAP_OP_FLUSH,
 					 (cf->tid < last_snap_flush ?
 					  CEPH_CLIENT_CAPS_PENDING_CAPSNAP : 0),
 					  __ceph_caps_used(ci),
 					  __ceph_caps_wanted(ci),
 					  (cap->issued | cap->implemented),
 					  cf->caps, cf->tid, oldest_flush_tid);
+			spin_unlock(&ci->i_ceph_lock);
+			__send_cap(mdsc, &arg, ci);
 		} else {
 			struct ceph_cap_snap *capsnap =
 					container_of(cf, struct ceph_cap_snap,
-- 
2.25.1


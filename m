Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193C13A8372
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Jun 2021 16:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhFOO7i (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Jun 2021 10:59:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230463AbhFOO7h (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 15 Jun 2021 10:59:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0FB461581;
        Tue, 15 Jun 2021 14:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623769053;
        bh=G400shQQSTQfqbJXfXThhBkFhUnucaq3nsQZGSLAnMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G69W7oo45mX1sYeVn4ZLuM35bdD6FZXUjrW/XODRt3LBuhmG1mY8ATYO3j7mYkeg+
         sTrs1gGhuWEt48afz16ojkd397DUYEjCT/4ug6aRgI4Po5UGUplfcRmbJ+MQrHp3FQ
         jsnlvNEiqSMuPp1MRmGfTrXZeg6FVpcN78KUB+tdCb8AefaXR7aB0ZW3QCYVxtgn4f
         N6SCf/TKbD0F0swO1X5ZcO+2DaB/ko7LH7PXMMaxcfw8h2RCEesPam8CmwUn7iPqtl
         qq9HH0rkxVBfyvKTi4XGvMaIWiRUDTvr+a2x23yowBDni6vjg2iYP5YxjmVz0Z/Xff
         cQlGRGRXNs8EQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, ukernel@gmail.com, idryomov@gmail.com,
        xiubli@redhat.com
Subject: [RFC PATCH 2/6] ceph: eliminate session->s_gen_ttl_lock
Date:   Tue, 15 Jun 2021 10:57:26 -0400
Message-Id: <20210615145730.21952-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615145730.21952-1-jlayton@kernel.org>
References: <20210615145730.21952-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Turn s_cap_gen field into an atomic_t, and just rely on the fact that we
hold the s_mutex when changing the s_cap_ttl field.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c       | 15 ++++++---------
 fs/ceph/dir.c        |  4 +---
 fs/ceph/inode.c      |  4 ++--
 fs/ceph/mds_client.c | 17 ++++++-----------
 fs/ceph/mds_client.h |  6 ++----
 5 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index a5e93b185515..919eada97a1f 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -645,9 +645,7 @@ void ceph_add_cap(struct inode *inode,
 	dout("add_cap %p mds%d cap %llx %s seq %d\n", inode,
 	     session->s_mds, cap_id, ceph_cap_string(issued), seq);
 
-	spin_lock(&session->s_gen_ttl_lock);
-	gen = session->s_cap_gen;
-	spin_unlock(&session->s_gen_ttl_lock);
+	gen = atomic_read(&session->s_cap_gen);
 
 	cap = __get_cap_for_mds(ci, mds);
 	if (!cap) {
@@ -785,10 +783,8 @@ static int __cap_is_valid(struct ceph_cap *cap)
 	unsigned long ttl;
 	u32 gen;
 
-	spin_lock(&cap->session->s_gen_ttl_lock);
-	gen = cap->session->s_cap_gen;
+	gen = atomic_read(&cap->session->s_cap_gen);
 	ttl = cap->session->s_cap_ttl;
-	spin_unlock(&cap->session->s_gen_ttl_lock);
 
 	if (cap->cap_gen < gen || time_after_eq(jiffies, ttl)) {
 		dout("__cap_is_valid %p cap %p issued %s "
@@ -1182,7 +1178,8 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 	 * s_cap_gen while session is in the reconnect state.
 	 */
 	if (queue_release &&
-	    (!session->s_cap_reconnect || cap->cap_gen == session->s_cap_gen)) {
+	    (!session->s_cap_reconnect ||
+	     cap->cap_gen == atomic_read(&session->s_cap_gen))) {
 		cap->queue_release = 1;
 		if (removed) {
 			__ceph_queue_cap_release(session, cap);
@@ -3288,7 +3285,7 @@ static void handle_cap_grant(struct inode *inode,
 	u64 size = le64_to_cpu(grant->size);
 	u64 max_size = le64_to_cpu(grant->max_size);
 	unsigned char check_caps = 0;
-	bool was_stale = cap->cap_gen < session->s_cap_gen;
+	bool was_stale = cap->cap_gen < atomic_read(&session->s_cap_gen);
 	bool wake = false;
 	bool writeback = false;
 	bool queue_trunc = false;
@@ -3340,7 +3337,7 @@ static void handle_cap_grant(struct inode *inode,
 	}
 
 	/* side effects now are allowed */
-	cap->cap_gen = session->s_cap_gen;
+	cap->cap_gen = atomic_read(&session->s_cap_gen);
 	cap->seq = seq;
 
 	__check_cap_issue(ci, cap, newcaps);
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 0dc5f8357f58..bd508b1aeac2 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1541,10 +1541,8 @@ static bool __dentry_lease_is_valid(struct ceph_dentry_info *di)
 		u32 gen;
 		unsigned long ttl;
 
-		spin_lock(&session->s_gen_ttl_lock);
-		gen = session->s_cap_gen;
+		gen = atomic_read(&session->s_cap_gen);
 		ttl = session->s_cap_ttl;
-		spin_unlock(&session->s_gen_ttl_lock);
 
 		if (di->lease_gen == gen &&
 		    time_before(jiffies, ttl) &&
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 6f43542b3344..6034821c9d63 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1124,7 +1124,7 @@ static void __update_dentry_lease(struct inode *dir, struct dentry *dentry,
 		return;
 	}
 
-	if (di->lease_gen == session->s_cap_gen &&
+	if (di->lease_gen == atomic_read(&session->s_cap_gen) &&
 	    time_before(ttl, di->time))
 		return;  /* we already have a newer lease. */
 
@@ -1135,7 +1135,7 @@ static void __update_dentry_lease(struct inode *dir, struct dentry *dentry,
 
 	if (!di->lease_session)
 		di->lease_session = ceph_get_mds_session(session);
-	di->lease_gen = session->s_cap_gen;
+	di->lease_gen = atomic_read(&session->s_cap_gen);
 	di->lease_seq = le32_to_cpu(lease->seq);
 	di->lease_renew_after = half_ttl;
 	di->lease_renew_from = 0;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index ec669634c649..87d3be10af25 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -749,8 +749,7 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 
 	ceph_con_init(&s->s_con, s, &mds_con_ops, &mdsc->fsc->client->msgr);
 
-	spin_lock_init(&s->s_gen_ttl_lock);
-	s->s_cap_gen = 1;
+	atomic_set(&s->s_cap_gen, 1);
 	s->s_cap_ttl = jiffies - 1;
 
 	spin_lock_init(&s->s_cap_lock);
@@ -1763,7 +1762,7 @@ static int wake_up_session_cb(struct inode *inode, struct ceph_cap *cap,
 		ci->i_requested_max_size = 0;
 		spin_unlock(&ci->i_ceph_lock);
 	} else if (ev == RENEWCAPS) {
-		if (cap->cap_gen < cap->session->s_cap_gen) {
+		if (cap->cap_gen < atomic_read(&cap->session->s_cap_gen)) {
 			/* mds did not re-issue stale cap */
 			spin_lock(&ci->i_ceph_lock);
 			cap->issued = cap->implemented = CEPH_CAP_PIN;
@@ -3501,10 +3500,8 @@ static void handle_session(struct ceph_mds_session *session,
 	case CEPH_SESSION_STALE:
 		pr_info("mds%d caps went stale, renewing\n",
 			session->s_mds);
-		spin_lock(&session->s_gen_ttl_lock);
-		session->s_cap_gen++;
+		atomic_inc(&session->s_cap_gen);
 		session->s_cap_ttl = jiffies - 1;
-		spin_unlock(&session->s_gen_ttl_lock);
 		send_renew_caps(mdsc, session);
 		break;
 
@@ -3773,7 +3770,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	cap->seq = 0;        /* reset cap seq */
 	cap->issue_seq = 0;  /* and issue_seq */
 	cap->mseq = 0;       /* and migrate_seq */
-	cap->cap_gen = cap->session->s_cap_gen;
+	cap->cap_gen = atomic_read(&cap->session->s_cap_gen);
 
 	/* These are lost when the session goes away */
 	if (S_ISDIR(inode->i_mode)) {
@@ -4013,9 +4010,7 @@ static void send_mds_reconnect(struct ceph_mds_client *mdsc,
 	dout("session %p state %s\n", session,
 	     ceph_session_state_name(session->s_state));
 
-	spin_lock(&session->s_gen_ttl_lock);
-	session->s_cap_gen++;
-	spin_unlock(&session->s_gen_ttl_lock);
+	atomic_inc(&session->s_cap_gen);
 
 	spin_lock(&session->s_cap_lock);
 	/* don't know if session is readonly */
@@ -4346,7 +4341,7 @@ static void handle_lease(struct ceph_mds_client *mdsc,
 
 	case CEPH_MDS_LEASE_RENEW:
 		if (di->lease_session == session &&
-		    di->lease_gen == session->s_cap_gen &&
+		    di->lease_gen == atomic_read(&session->s_cap_gen) &&
 		    di->lease_renew_from &&
 		    di->lease_renew_after == 0) {
 			unsigned long duration =
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 15c11a0f2caf..20e42d8b66c6 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -186,10 +186,8 @@ struct ceph_mds_session {
 
 	struct ceph_auth_handshake s_auth;
 
-	/* protected by s_gen_ttl_lock */
-	spinlock_t        s_gen_ttl_lock;
-	u32               s_cap_gen;  /* inc each time we get mds stale msg */
-	unsigned long     s_cap_ttl;  /* when session caps expire */
+	atomic_t          s_cap_gen;  /* inc each time we get mds stale msg */
+	unsigned long     s_cap_ttl;  /* when session caps expire. protected by s_mutex */
 
 	/* protected by s_cap_lock */
 	spinlock_t        s_cap_lock;
-- 
2.31.1


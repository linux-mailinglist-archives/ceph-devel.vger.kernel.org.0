Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09343A8371
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Jun 2021 16:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhFOO7i (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Jun 2021 10:59:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230298AbhFOO7g (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 15 Jun 2021 10:59:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04CB761584;
        Tue, 15 Jun 2021 14:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623769052;
        bh=WeGkGoFuxB/K90Y0r5W0csZbjj8cH51PuDrA08JVSY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pYPTSUNnwcHBvRH2Q4EiPM73uqvqLRhh6+jSlgxHvXT2rUzeiwuZ+xNn0Q8dyCPUG
         0dFqPd9E2CJdrxU2erqVDopZ/gjaiXPkmSi+4hwP8oGmurp895VPHfrSryzHJqO36V
         KrLmyzRmt/4MVQBryXJ9FYM2UT6Xrd3QqkxvcF3CuVtGwdhdlDXFnlNcY6+6V7Fxt9
         pgg8aVQsHKA757Llwd3XcXpSb6NxauTOcC8nsRyuxoLopiTiONEa2rKPaHlPru6K/s
         SjR2bD0ZuFFDhaIkJnm9JNXob0uegpnLUlOsFcIxvwFSQHCsh1iqmlpHHNNuG5VZrb
         tiDH+WRbySXAw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, ukernel@gmail.com, idryomov@gmail.com,
        xiubli@redhat.com
Subject: [RFC PATCH 1/6] ceph: allow ceph_put_mds_session to take NULL or ERR_PTR
Date:   Tue, 15 Jun 2021 10:57:25 -0400
Message-Id: <20210615145730.21952-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615145730.21952-1-jlayton@kernel.org>
References: <20210615145730.21952-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

...to simplify some error paths.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c        | 3 +--
 fs/ceph/inode.c      | 6 ++----
 fs/ceph/mds_client.c | 6 ++++--
 fs/ceph/metric.c     | 3 +--
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index ac431246e0c9..0dc5f8357f58 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1802,8 +1802,7 @@ static void ceph_d_release(struct dentry *dentry)
 	dentry->d_fsdata = NULL;
 	spin_unlock(&dentry->d_lock);
 
-	if (di->lease_session)
-		ceph_put_mds_session(di->lease_session);
+	ceph_put_mds_session(di->lease_session);
 	kmem_cache_free(ceph_dentry_cachep, di);
 }
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index df0c8a724609..6f43542b3344 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1154,8 +1154,7 @@ static inline void update_dentry_lease(struct inode *dir, struct dentry *dentry,
 	__update_dentry_lease(dir, dentry, lease, session, from_time,
 			      &old_lease_session);
 	spin_unlock(&dentry->d_lock);
-	if (old_lease_session)
-		ceph_put_mds_session(old_lease_session);
+	ceph_put_mds_session(old_lease_session);
 }
 
 /*
@@ -1200,8 +1199,7 @@ static void update_dentry_lease_careful(struct dentry *dentry,
 			      from_time, &old_lease_session);
 out_unlock:
 	spin_unlock(&dentry->d_lock);
-	if (old_lease_session)
-		ceph_put_mds_session(old_lease_session);
+	ceph_put_mds_session(old_lease_session);
 }
 
 /*
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index e5af591d3bd4..ec669634c649 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -664,6 +664,9 @@ struct ceph_mds_session *ceph_get_mds_session(struct ceph_mds_session *s)
 
 void ceph_put_mds_session(struct ceph_mds_session *s)
 {
+	if (IS_ERR_OR_NULL(s))
+		return;
+
 	dout("mdsc put_session %p %d -> %d\n", s,
 	     refcount_read(&s->s_ref), refcount_read(&s->s_ref)-1);
 	if (refcount_dec_and_test(&s->s_ref)) {
@@ -1438,8 +1441,7 @@ static void __open_export_target_sessions(struct ceph_mds_client *mdsc,
 
 	for (i = 0; i < mi->num_export_targets; i++) {
 		ts = __open_export_target_session(mdsc, mi->export_targets[i]);
-		if (!IS_ERR(ts))
-			ceph_put_mds_session(ts);
+		ceph_put_mds_session(ts);
 	}
 }
 
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 9577c71e645d..5ac151eb0d49 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -311,8 +311,7 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 
 	cancel_delayed_work_sync(&m->delayed_work);
 
-	if (m->session)
-		ceph_put_mds_session(m->session);
+	ceph_put_mds_session(m->session);
 }
 
 #define METRIC_UPDATE_MIN_MAX(min, max, new)	\
-- 
2.31.1


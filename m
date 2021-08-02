Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB843DDF97
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Aug 2021 20:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhHBSvR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Aug 2021 14:51:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhHBSvQ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 14:51:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C950F60F9C;
        Mon,  2 Aug 2021 18:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627930267;
        bh=Z+WjFm2NVUXANVH2yMcwJGs9exLK61afZYmFnrLHDw8=;
        h=From:To:Cc:Subject:Date:From;
        b=uKUUfrEtD/bmLhmpdR7vph7uGsL7/t/REwp/PnMtl5P3V9efg5U2Qf7RL0m4mvFGd
         BNVDgoYJE6r6LCpyzi1niGCZEZjt6CWxta3p1lFegG9KgTr2amxifs76/Zq6/iLxEU
         82uHsWJdECnOEvQZIER0kbeDmuzlNRTasTaBWXHt3fp7/u1Q8wGc6gXy6U6o7h15yS
         QHQ2rarPN4OZBYrcUOep8ecql4oPRtT+cE2WePKiCZjPJxYlC7Hxdkx8DCQ9Us4EQI
         dJSjf7Dn8eJm+l6nyUz8CNeX1lCHomS9CrQsPI3hW2UE/NWCdoO3h5UYGEEz65/pzc
         YSmIOkvG6zgXA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH] ceph: remove redundant initializations from mdsc and session
Date:   Mon,  2 Aug 2021 14:51:05 -0400
Message-Id: <20210802185105.94707-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The ceph_mds_client and ceph_mds_session structures are kzalloc'ed so
there's no need to explicitly initialize either of their fields to 0.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 6027a786a2f6..e49dbeb6c06f 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -743,8 +743,6 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 	s->s_mdsc = mdsc;
 	s->s_mds = mds;
 	s->s_state = CEPH_MDS_SESSION_NEW;
-	s->s_ttl = 0;
-	s->s_seq = 0;
 	mutex_init(&s->s_mutex);
 
 	ceph_con_init(&s->s_con, s, &mds_con_ops, &mdsc->fsc->client->msgr);
@@ -753,17 +751,11 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 	s->s_cap_ttl = jiffies - 1;
 
 	spin_lock_init(&s->s_cap_lock);
-	s->s_renew_requested = 0;
-	s->s_renew_seq = 0;
 	INIT_LIST_HEAD(&s->s_caps);
-	s->s_nr_caps = 0;
 	refcount_set(&s->s_ref, 1);
 	INIT_LIST_HEAD(&s->s_waiting);
 	INIT_LIST_HEAD(&s->s_unsafe);
 	xa_init(&s->s_delegated_inos);
-	s->s_num_cap_releases = 0;
-	s->s_cap_reconnect = 0;
-	s->s_cap_iterator = NULL;
 	INIT_LIST_HEAD(&s->s_cap_releases);
 	INIT_WORK(&s->s_cap_release_work, ceph_cap_release_work);
 
@@ -4627,21 +4619,12 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	init_completion(&mdsc->safe_umount_waiters);
 	init_waitqueue_head(&mdsc->session_close_wq);
 	INIT_LIST_HEAD(&mdsc->waiting_for_map);
-	mdsc->sessions = NULL;
-	atomic_set(&mdsc->num_sessions, 0);
-	mdsc->max_sessions = 0;
-	mdsc->stopping = 0;
-	atomic64_set(&mdsc->quotarealms_count, 0);
 	mdsc->quotarealms_inodes = RB_ROOT;
 	mutex_init(&mdsc->quotarealms_inodes_mutex);
-	mdsc->last_snap_seq = 0;
 	init_rwsem(&mdsc->snap_rwsem);
 	mdsc->snap_realms = RB_ROOT;
 	INIT_LIST_HEAD(&mdsc->snap_empty);
-	mdsc->num_snap_realms = 0;
 	spin_lock_init(&mdsc->snap_empty_lock);
-	mdsc->last_tid = 0;
-	mdsc->oldest_tid = 0;
 	mdsc->request_tree = RB_ROOT;
 	INIT_DELAYED_WORK(&mdsc->delayed_work, delayed_work);
 	mdsc->last_renew_caps = jiffies;
@@ -4653,11 +4636,9 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	mdsc->last_cap_flush_tid = 1;
 	INIT_LIST_HEAD(&mdsc->cap_flush_list);
 	INIT_LIST_HEAD(&mdsc->cap_dirty_migrating);
-	mdsc->num_cap_flushing = 0;
 	spin_lock_init(&mdsc->cap_dirty_lock);
 	init_waitqueue_head(&mdsc->cap_flushing_wq);
 	INIT_WORK(&mdsc->cap_reclaim_work, ceph_cap_reclaim_work);
-	atomic_set(&mdsc->cap_reclaim_pending, 0);
 	err = ceph_metric_init(&mdsc->metric);
 	if (err)
 		goto err_mdsmap;
-- 
2.31.1


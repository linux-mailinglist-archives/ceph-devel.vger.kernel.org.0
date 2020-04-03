Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEFC19DE71
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Apr 2020 21:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgDCTOZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 Apr 2020 15:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728296AbgDCTOZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 3 Apr 2020 15:14:25 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F56120737;
        Fri,  3 Apr 2020 19:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585941264;
        bh=isI2wQq71iH3Q3EVuIqF5xfQJo00eZgYceUdXGQ+Fdc=;
        h=From:To:Cc:Subject:Date:From;
        b=YAEartBSJpfqIORH03gF8zk5gdpQBwFabQsFvPy93R6BK7Kxwg9hmQcGYqLQn2Q+d
         TdKqjWg8USfFzy4A0gOtWWOOKMrsFAi+iH089Oc8uk7c0OoIerqDF56z4uNK9HJOqm
         pC7R3twQBCnrI8TcbePgh1BwrbLRZQk3ZFlBqC/4=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com
Subject: [PATCH] ceph: ceph_kick_flushing_caps needs the s_mutex
Date:   Fri,  3 Apr 2020 15:14:23 -0400
Message-Id: <20200403191423.40938-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The mdsc->cap_dirty_lock is not held while walking the list in
ceph_kick_flushing_caps, which is not safe.

ceph_early_kick_flushing_caps does something similar, but the
s_mutex is held while it's called and I think that guards against
changes to the list.

Ensure we hold the s_mutex when calling ceph_kick_flushing_caps,
and add some clarifying comments.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c       |  2 ++
 fs/ceph/mds_client.c |  2 ++
 fs/ceph/mds_client.h |  4 +++-
 fs/ceph/super.h      | 11 ++++++-----
 4 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index ba6e11810877..f5b37842cdcd 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2508,6 +2508,8 @@ void ceph_kick_flushing_caps(struct ceph_mds_client *mdsc,
 	struct ceph_cap *cap;
 	u64 oldest_flush_tid;
 
+	lockdep_assert_held(session->s_mutex);
+
 	dout("kick_flushing_caps mds%d\n", session->s_mds);
 
 	spin_lock(&mdsc->cap_dirty_lock);
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index be4ad7d28e3a..a8a5b98148ec 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4026,7 +4026,9 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 			    oldstate != CEPH_MDS_STATE_STARTING)
 				pr_info("mds%d recovery completed\n", s->s_mds);
 			kick_requests(mdsc, i);
+			mutex_lock(&s->s_mutex);
 			ceph_kick_flushing_caps(mdsc, s);
+			mutex_unlock(&s->s_mutex);
 			wake_up_session_caps(s, RECONNECT);
 		}
 	}
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index bd20257fb4c2..1b40f30e0a8e 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -199,8 +199,10 @@ struct ceph_mds_session {
 	struct list_head  s_cap_releases; /* waiting cap_release messages */
 	struct work_struct s_cap_release_work;
 
-	/* both protected by s_mdsc->cap_dirty_lock */
+	/* See ceph_inode_info->i_dirty_item. */
 	struct list_head  s_cap_dirty;	      /* inodes w/ dirty caps */
+
+	/* See ceph_inode_info->i_flushing_item. */
 	struct list_head  s_cap_flushing;     /* inodes w/ flushing caps */
 
 	unsigned long     s_renew_requested; /* last time we sent a renew req */
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 3235c7e3bde7..b82f82d8213a 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -361,11 +361,12 @@ struct ceph_inode_info {
 	 */
 	struct list_head i_dirty_item;
 
-	/* Link to session's s_cap_flushing list. Protected by
-	 * mdsc->cap_dirty_lock.
-	 *
-	 * FIXME: this list is sometimes walked without the spinlock being
-	 *	  held. What really protects it?
+	/*
+	 * Link to session's s_cap_flushing list. Protected in a similar
+	 * fashion to i_dirty_item, but also by the s_mutex for changes. The
+	 * s_cap_flushing list can be walked while holding either the s_mutex
+	 * or msdc->cap_dirty_lock. List presence can also be checked while
+	 * holding the i_ceph_lock for this inode.
 	 */
 	struct list_head i_flushing_item;
 
-- 
2.25.1


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE2574CC5
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 13:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403965AbfGYLR6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 07:17:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403888AbfGYLRu (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 07:17:50 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C37522C7D
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564053469;
        bh=dqKXZWkF8WO1jmwhUSu6eqcNZgrpvVzHJL7ECMS9Mk4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=op0HQm3z1Orzbr6uj8votomsmi3pR2VBuNW3cLq7iFOfXrQIRisLRTkyQ9dMR7NP7
         C4tobhrp7z4T3jov8w8+TdzIN+CepwZsU3LlZk7yCfqLDv68dgxWJ/skOwaJbv1Vrj
         LTRx/vutrbDVgX8eMm4WW1tKtayfa+EdyzfitNlI=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 3/8] ceph: eliminate session->s_trim_caps
Date:   Thu, 25 Jul 2019 07:17:41 -0400
Message-Id: <20190725111746.10393-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190725111746.10393-1-jlayton@kernel.org>
References: <20190725111746.10393-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

It's only used to keep count of caps being trimmed, but that requires
that we hold the session->s_mutex to prevent multiple trimming
operations from running concurrently.

We can achieve the same effect using an integer on the stack, which
allows us to (eventually) not need the s_mutex.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 17 ++++++++---------
 fs/ceph/mds_client.h |  2 +-
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 8737c8f85569..a18c7f4fc20b 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -639,7 +639,6 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 	s->s_renew_seq = 0;
 	INIT_LIST_HEAD(&s->s_caps);
 	s->s_nr_caps = 0;
-	s->s_trim_caps = 0;
 	refcount_set(&s->s_ref, 1);
 	INIT_LIST_HEAD(&s->s_waiting);
 	INIT_LIST_HEAD(&s->s_unsafe);
@@ -1722,11 +1721,11 @@ static bool drop_negative_children(struct dentry *dentry)
  */
 static int trim_caps_cb(struct inode *inode, struct ceph_cap *cap, void *arg)
 {
-	struct ceph_mds_session *session = arg;
+	int *remaining = arg;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	int used, wanted, oissued, mine;
 
-	if (session->s_trim_caps <= 0)
+	if (*remaining <= 0)
 		return -1;
 
 	spin_lock(&ci->i_ceph_lock);
@@ -1763,7 +1762,7 @@ static int trim_caps_cb(struct inode *inode, struct ceph_cap *cap, void *arg)
 	if (oissued) {
 		/* we aren't the only cap.. just remove us */
 		__ceph_remove_cap(cap, true);
-		session->s_trim_caps--;
+		(*remaining)--;
 	} else {
 		struct dentry *dentry;
 		/* try dropping referring dentries */
@@ -1775,7 +1774,7 @@ static int trim_caps_cb(struct inode *inode, struct ceph_cap *cap, void *arg)
 			d_prune_aliases(inode);
 			count = atomic_read(&inode->i_count);
 			if (count == 1)
-				session->s_trim_caps--;
+				(*remaining)--;
 			dout("trim_caps_cb %p cap %p pruned, count now %d\n",
 			     inode, cap, count);
 		} else {
@@ -1801,12 +1800,12 @@ int ceph_trim_caps(struct ceph_mds_client *mdsc,
 	dout("trim_caps mds%d start: %d / %d, trim %d\n",
 	     session->s_mds, session->s_nr_caps, max_caps, trim_caps);
 	if (trim_caps > 0) {
-		session->s_trim_caps = trim_caps;
-		ceph_iterate_session_caps(session, trim_caps_cb, session);
+		int remaining = trim_caps;
+
+		ceph_iterate_session_caps(session, trim_caps_cb, &remaining);
 		dout("trim_caps mds%d done: %d / %d, trimmed %d\n",
 		     session->s_mds, session->s_nr_caps, max_caps,
-			trim_caps - session->s_trim_caps);
-		session->s_trim_caps = 0;
+			trim_caps - remaining);
 	}
 
 	ceph_flush_cap_releases(mdsc, session);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 810fd8689dff..5cd131b41d84 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -176,7 +176,7 @@ struct ceph_mds_session {
 	spinlock_t        s_cap_lock;
 	struct list_head  s_caps;     /* all caps issued by this session */
 	struct ceph_cap  *s_cap_iterator;
-	int               s_nr_caps, s_trim_caps;
+	int               s_nr_caps;
 	int               s_num_cap_releases;
 	int		  s_cap_reconnect;
 	int		  s_readonly;
-- 
2.21.0


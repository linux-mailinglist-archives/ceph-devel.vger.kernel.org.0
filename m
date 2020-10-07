Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70080285F28
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Oct 2020 14:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgJGMZz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Oct 2020 08:25:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728174AbgJGMZy (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 7 Oct 2020 08:25:54 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC7E6206D9;
        Wed,  7 Oct 2020 12:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602073554;
        bh=KEsHy5BwcCQukxKrmDmyBbDeDHl2DfRGquXKlmtit70=;
        h=From:To:Cc:Subject:Date:From;
        b=ZslJTmYY/cDZ3kmiHpNWbsxcCqfgAzoloKR2ZW0HBvLYibJg2Z3fZ4Q2yC9tWrmLc
         wDoXH5vlsopGAyZDx4Yh3WVTQvsC2fGU3BKQAUG61911Dm0nKHwBt3wV7WTgkxsdXU
         rblGhq/cRrWuwltfiXkKc9c6Js1Uog2CaBXpFaEw=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com
Subject: [PATCH] ceph: comment cleanups and clarifications
Date:   Wed,  7 Oct 2020 08:25:52 -0400
Message-Id: <20201007122552.13455-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c       | 16 ++++++++++++++++
 fs/ceph/mds_client.h |  2 +-
 fs/ceph/super.h      |  3 ++-
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 6f4adfaf761f..c49dc0a0b5fe 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1925,12 +1925,24 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 retry:
 	spin_lock(&ci->i_ceph_lock);
 retry_locked:
+	/* Caps wanted by virtue of active open files. */
 	file_wanted = __ceph_caps_file_wanted(ci);
+
+	/* Caps which have active references against them */
 	used = __ceph_caps_used(ci);
+
+	/*
+	 * "issued" represents the current caps that the MDS wants us to have.
+	 * "implemented" is the set that we have been granted, and includes the
+	 * ones that have not yet been returned to the MDS (the "revoking" set,
+	 * usually because they have outstanding references).
+	 */
 	issued = __ceph_caps_issued(ci, &implemented);
 	revoking = implemented & ~issued;
 
 	want = file_wanted;
+
+	/* The ones we currently want to retain (may be adjusted below) */
 	retain = file_wanted | used | CEPH_CAP_PIN;
 	if (!mdsc->stopping && inode->i_nlink > 0) {
 		if (file_wanted) {
@@ -2008,6 +2020,10 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 
 		/* NOTE: no side-effects allowed, until we take s_mutex */
 
+		/*
+		 * If we have an auth cap, we don't need to consider any
+		 * overlapping caps as used.
+		 */
 		cap_used = used;
 		if (ci->i_auth_cap && cap != ci->i_auth_cap)
 			cap_used &= ~ci->i_auth_cap->issued;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 658800605bfb..cbf8af437140 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -393,7 +393,7 @@ struct ceph_mds_client {
 
 	struct ceph_mds_session **sessions;    /* NULL for mds if no session */
 	atomic_t		num_sessions;
-	int                     max_sessions;  /* len of s_mds_sessions */
+	int                     max_sessions;  /* len of sessions array */
 	int                     stopping;      /* true if shutting down */
 
 	atomic64_t		quotarealms_count; /* # realms with quota */
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 9ced23b092f5..f097237a5ad3 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -159,7 +159,8 @@ struct ceph_cap {
 			int issued;       /* latest, from the mds */
 			int implemented;  /* implemented superset of
 					     issued (for revocation) */
-			int mds, mds_wanted;
+			int mds;	  /* mds index for this cap */
+			int mds_wanted;   /* caps wanted from this mds */
 		};
 		/* caps to release */
 		struct {
-- 
2.26.2


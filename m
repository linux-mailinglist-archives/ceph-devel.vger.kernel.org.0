Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03E4403A40
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Sep 2021 15:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242632AbhIHNFF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Sep 2021 09:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234910AbhIHNEt (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 8 Sep 2021 09:04:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95A4D61167;
        Wed,  8 Sep 2021 13:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631106219;
        bh=ozscgNaJNSbG3LocIW7iSo6TtLvjnpgqwaKPFp1Bb9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PIlo8/h/93wEbOi1X2WFkGh4cd04DWPGo5gQz3MuqNFVcVWrkVRVxdydwMbnWYgXe
         M/VSbMWXYAgQtPx0p0KmIRMsp6xPjM2o9sG8u8XAU9D3jgAuMS/tFpnnzGBBPfigPE
         fqCMIA3oMTMY8OntPv2o5eUJUhBMRMREUYC02iSsJUjs8mWT7gedlXI3WvLqjiqYn0
         wPnlVB1A+dJ9br+pm7AGXwbhEIoOkAXoV6/edtLTPjfGvGxFBYzU+koQykBVi2GHcc
         KIUrDP3uxvtFFLUkpDR/I5H9ZxTNvG4ZfawdSPxKrbnJzkuuBiUuUs9XF6CSCZOT9+
         Et7S4KMZe/vTA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com
Subject: [PATCH 3/6] ceph: drop private list from remove_session_caps_cb
Date:   Wed,  8 Sep 2021 09:03:33 -0400
Message-Id: <20210908130336.56668-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210908130336.56668-1-jlayton@kernel.org>
References: <20210908130336.56668-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This function does a lot of list-shuffling with cap flushes, all to
avoid possibly freeing a slab allocation under spinlock (which is
totally ok).  Simplify the code by just detaching and freeing the cap
flushes in place.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index b41d62f08c0a..2ff4e6481d09 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1626,7 +1626,6 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	struct ceph_fs_client *fsc = (struct ceph_fs_client *)arg;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	LIST_HEAD(to_remove);
 	bool dirty_dropped = false;
 	bool invalidate = false;
 	int capsnap_release = 0;
@@ -1645,16 +1644,17 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 				mapping_set_error(&inode->i_data, -EIO);
 		}
 
+		spin_lock(&mdsc->cap_dirty_lock);
+
+		/* trash all of the cap flushes for this inode */
 		while (!list_empty(&ci->i_cap_flush_list)) {
 			cf = list_first_entry(&ci->i_cap_flush_list,
 					      struct ceph_cap_flush, i_list);
-			list_move(&cf->i_list, &to_remove);
-		}
-
-		spin_lock(&mdsc->cap_dirty_lock);
-
-		list_for_each_entry(cf, &to_remove, i_list)
 			list_del_init(&cf->g_list);
+			list_del_init(&cf->i_list);
+			if (!cf->is_capsnap)
+				ceph_free_cap_flush(cf);
+		}
 
 		if (!list_empty(&ci->i_dirty_item)) {
 			pr_warn_ratelimited(
@@ -1697,22 +1697,16 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		}
 
 		if (!ci->i_dirty_caps && ci->i_prealloc_cap_flush) {
-			list_add(&ci->i_prealloc_cap_flush->i_list, &to_remove);
+			cf = ci->i_prealloc_cap_flush;
 			ci->i_prealloc_cap_flush = NULL;
+			if (!cf->is_capsnap)
+				ceph_free_cap_flush(cf);
 		}
 
 		if (!list_empty(&ci->i_cap_snaps))
 			capsnap_release = remove_capsnaps(mdsc, inode);
 	}
 	spin_unlock(&ci->i_ceph_lock);
-	while (!list_empty(&to_remove)) {
-		struct ceph_cap_flush *cf;
-		cf = list_first_entry(&to_remove,
-				      struct ceph_cap_flush, i_list);
-		list_del_init(&cf->i_list);
-		if (!cf->is_capsnap)
-			ceph_free_cap_flush(cf);
-	}
 
 	wake_up_all(&ci->i_cap_wq);
 	if (invalidate)
-- 
2.31.1


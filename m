Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8072E3A8374
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Jun 2021 16:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhFOO7j (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Jun 2021 10:59:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231346AbhFOO7j (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 15 Jun 2021 10:59:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FCF161585;
        Tue, 15 Jun 2021 14:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623769054;
        bh=xl5k40Kqo/vr+9qvaBVVZ5c0vdAds5jebNgpa78KCbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZY1WZYr4JPDyGS56ipyq6vquhun36ttifar+QLkzBLyYkJphpN+OkPNQAC0uZGDC
         OYLgnReVhBhqvV4oXEsSZmL+fwWd7zZ56lY7WpR/gbpwT4t6keNQeOUlAKKXJdUpNk
         lgFZQkQL+XIT3N5uIpblvf+s4et+r5/xFL8xVE9lcN7aM1RgjLTwpjcr//ZFFwB5dm
         jqBBB/Kp1QLHv35rUyVkbbtzYYZmp1eROSa8JQyBdLctGHQulB2+Zs/5rZUpJmFl4H
         /+LfHd9/G5qpXiJXkzMsKm6CJSAmVMG13T/wm7brqIAXxUekpzufVRgLw/y7Ik7hGS
         50IzErlZElZeA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, ukernel@gmail.com, idryomov@gmail.com,
        xiubli@redhat.com
Subject: [RFC PATCH 4/6] ceph: don't take s_mutex in try_flush_caps
Date:   Tue, 15 Jun 2021 10:57:28 -0400
Message-Id: <20210615145730.21952-5-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615145730.21952-1-jlayton@kernel.org>
References: <20210615145730.21952-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The s_mutex doesn't protect anything in this codepath.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 825b1e463ad3..d21b1fa36875 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2149,26 +2149,17 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
 {
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	struct ceph_mds_session *session = NULL;
 	int flushing = 0;
 	u64 flush_tid = 0, oldest_flush_tid = 0;
 
-retry:
 	spin_lock(&ci->i_ceph_lock);
 retry_locked:
 	if (ci->i_dirty_caps && ci->i_auth_cap) {
 		struct ceph_cap *cap = ci->i_auth_cap;
 		struct cap_msg_args arg;
+		struct ceph_mds_session *session = cap->session;
 
-		if (session != cap->session) {
-			spin_unlock(&ci->i_ceph_lock);
-			if (session)
-				mutex_unlock(&session->s_mutex);
-			session = cap->session;
-			mutex_lock(&session->s_mutex);
-			goto retry;
-		}
-		if (cap->session->s_state < CEPH_MDS_SESSION_OPEN) {
+		if (session->s_state < CEPH_MDS_SESSION_OPEN) {
 			spin_unlock(&ci->i_ceph_lock);
 			goto out;
 		}
@@ -2205,9 +2196,6 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
 		spin_unlock(&ci->i_ceph_lock);
 	}
 out:
-	if (session)
-		mutex_unlock(&session->s_mutex);
-
 	*ptid = flush_tid;
 	return flushing;
 }
-- 
2.31.1


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 551F418F954
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Mar 2020 17:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbgCWQHN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Mar 2020 12:07:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727298AbgCWQHM (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Mar 2020 12:07:12 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D7292072D;
        Mon, 23 Mar 2020 16:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584979632;
        bh=RbxCfHnGWqhMz/8M+UVv7258xkqokYi+oblpSrurUxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZMUHAfm9vlYPSRIT3VvOTG10MrN1PRx6cur9pyXFjoP89Z03xkbSS/94zesFHo84g
         LBsEsZu4Dy2zBpg5NbjIgHIFq6MdZC6zfREUakI3qgJiLiSUOr80eUma6isvWh8gah
         lHHQyDbFQTR/7YmqbAh3y7qwPbCcDzYL7znJIMWY=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com
Subject: [PATCH 2/8] ceph: split up __finish_cap_flush
Date:   Mon, 23 Mar 2020 12:07:02 -0400
Message-Id: <20200323160708.104152-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323160708.104152-1-jlayton@kernel.org>
References: <20200323160708.104152-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This function takes a mdsc argument or ci argument, but if both are
passed in, it ignores the ci arg. Fortunately, nothing does that, but
there's no good reason to have the same function handle both cases.

Also, get rid of some branches and just use |= to set the wake_* vals.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 60 ++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 31 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 5bdca0da58a4..01877f91b85b 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1745,30 +1745,33 @@ static u64 __get_oldest_flush_tid(struct ceph_mds_client *mdsc)
  * Remove cap_flush from the mdsc's or inode's flushing cap list.
  * Return true if caller needs to wake up flush waiters.
  */
-static bool __finish_cap_flush(struct ceph_mds_client *mdsc,
-			       struct ceph_inode_info *ci,
-			       struct ceph_cap_flush *cf)
+static bool __detach_cap_flush_from_mdsc(struct ceph_mds_client *mdsc,
+					 struct ceph_cap_flush *cf)
 {
 	struct ceph_cap_flush *prev;
 	bool wake = cf->wake;
-	if (mdsc) {
-		/* are there older pending cap flushes? */
-		if (wake && cf->g_list.prev != &mdsc->cap_flush_list) {
-			prev = list_prev_entry(cf, g_list);
-			prev->wake = true;
-			wake = false;
-		}
-		list_del(&cf->g_list);
-	} else if (ci) {
-		if (wake && cf->i_list.prev != &ci->i_cap_flush_list) {
-			prev = list_prev_entry(cf, i_list);
-			prev->wake = true;
-			wake = false;
-		}
-		list_del(&cf->i_list);
-	} else {
-		BUG_ON(1);
+
+	if (wake && cf->g_list.prev != &mdsc->cap_flush_list) {
+		prev = list_prev_entry(cf, g_list);
+		prev->wake = true;
+		wake = false;
 	}
+	list_del(&cf->g_list);
+	return wake;
+}
+
+static bool __detach_cap_flush_from_ci(struct ceph_inode_info *ci,
+				       struct ceph_cap_flush *cf)
+{
+	struct ceph_cap_flush *prev;
+	bool wake = cf->wake;
+
+	if (wake && cf->i_list.prev != &ci->i_cap_flush_list) {
+		prev = list_prev_entry(cf, i_list);
+		prev->wake = true;
+		wake = false;
+	}
+	list_del(&cf->i_list);
 	return wake;
 }
 
@@ -3493,8 +3496,7 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
 		if (cf->caps == 0) /* capsnap */
 			continue;
 		if (cf->tid <= flush_tid) {
-			if (__finish_cap_flush(NULL, ci, cf))
-				wake_ci = true;
+			wake_ci |= __detach_cap_flush_from_ci(ci, cf);
 			list_add_tail(&cf->i_list, &to_remove);
 		} else {
 			cleaned &= ~cf->caps;
@@ -3516,10 +3518,8 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
 
 	spin_lock(&mdsc->cap_dirty_lock);
 
-	list_for_each_entry(cf, &to_remove, i_list) {
-		if (__finish_cap_flush(mdsc, NULL, cf))
-			wake_mdsc = true;
-	}
+	list_for_each_entry(cf, &to_remove, i_list)
+		wake_mdsc |= __detach_cap_flush_from_mdsc(mdsc, cf);
 
 	if (ci->i_flushing_caps == 0) {
 		if (list_empty(&ci->i_cap_flush_list)) {
@@ -3611,17 +3611,15 @@ static void handle_cap_flushsnap_ack(struct inode *inode, u64 flush_tid,
 		dout(" removing %p cap_snap %p follows %lld\n",
 		     inode, capsnap, follows);
 		list_del(&capsnap->ci_item);
-		if (__finish_cap_flush(NULL, ci, &capsnap->cap_flush))
-			wake_ci = true;
+		wake_ci |= __detach_cap_flush_from_ci(ci, &capsnap->cap_flush);
 
 		spin_lock(&mdsc->cap_dirty_lock);
 
 		if (list_empty(&ci->i_cap_flush_list))
 			list_del_init(&ci->i_flushing_item);
 
-		if (__finish_cap_flush(mdsc, NULL, &capsnap->cap_flush))
-			wake_mdsc = true;
-
+		wake_mdsc |= __detach_cap_flush_from_mdsc(mdsc,
+							  &capsnap->cap_flush);
 		spin_unlock(&mdsc->cap_dirty_lock);
 	}
 	spin_unlock(&ci->i_ceph_lock);
-- 
2.25.1


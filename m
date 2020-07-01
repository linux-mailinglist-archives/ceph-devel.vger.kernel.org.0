Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3B3210C57
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Jul 2020 15:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731089AbgGANfD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Jul 2020 09:35:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730408AbgGANfC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 1 Jul 2020 09:35:02 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2683020702
        for <ceph-devel@vger.kernel.org>; Wed,  1 Jul 2020 13:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593610502;
        bh=mxCH07UQ1A7ESog8GLYpJ8Qfe1RLSvNSld9y5mxlAVc=;
        h=From:To:Subject:Date:From;
        b=Aub024yPgfBW2ZEWOgYo2964zmBpb1Ut/Xq0sMB0m+P5QNYCX714FAg5xHlUKVYMx
         bi+U+oxqCyfEMctQztJ7aHrsOofKhUwNQ1K626dSxmQmZCo2+67XxmGG9BOxEoWy8g
         qvfx6rEnvXNq7Rm+eX47VAB1r2fzqvDbDqkUxq5A=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: clean up and optimize ceph_check_delayed_caps
Date:   Wed,  1 Jul 2020 09:35:00 -0400
Message-Id: <20200701133500.26613-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Make this loop look a bit more sane. Also optimize away the spinlock
release/reacquire if we can't get an inode reference.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 5f4894063a73..55ccccf77cea 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4189,10 +4189,8 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 	struct ceph_inode_info *ci;
 
 	dout("check_delayed_caps\n");
-	while (1) {
-		spin_lock(&mdsc->cap_delay_lock);
-		if (list_empty(&mdsc->cap_delay_list))
-			break;
+	spin_lock(&mdsc->cap_delay_lock);
+	while (!list_empty(&mdsc->cap_delay_list)) {
 		ci = list_first_entry(&mdsc->cap_delay_list,
 				      struct ceph_inode_info,
 				      i_cap_delay_list);
@@ -4202,13 +4200,13 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 		list_del_init(&ci->i_cap_delay_list);
 
 		inode = igrab(&ci->vfs_inode);
-		spin_unlock(&mdsc->cap_delay_lock);
-
 		if (inode) {
+			spin_unlock(&mdsc->cap_delay_lock);
 			dout("check_delayed_caps on %p\n", inode);
 			ceph_check_caps(ci, 0, NULL);
 			/* avoid calling iput_final() in tick thread */
 			ceph_async_iput(inode);
+			spin_lock(&mdsc->cap_delay_lock);
 		}
 	}
 	spin_unlock(&mdsc->cap_delay_lock);
-- 
2.26.2


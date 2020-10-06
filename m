Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A29284E58
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Oct 2020 16:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgJFOze (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Oct 2020 10:55:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbgJFOzd (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 6 Oct 2020 10:55:33 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77A90206CB;
        Tue,  6 Oct 2020 14:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601996133;
        bh=sidwf1KhBEvp0V1xv1dd+iN5rzt7H2NoFEk5TAP1Vlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K07HGnfZbazjzxzs4U7jwOMNEOholn/wkiyhGtenpB3O+hJsfDtfs74eiTJ26tHBA
         v1QqSH2OvEmpvcxSH7HZkQukxCg+Cob6ahmQB9uETpO0Zun91Sys3iFF5TSzLA8lOw
         iAAdZ5NSL5CVam3sOHJXSVWb+0mZeQ4NJGPe38HU=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com
Subject: [PATCH v3 4/5] ceph: remove timeout on allowing reconnect after blocklisting
Date:   Tue,  6 Oct 2020 10:55:25 -0400
Message-Id: <20201006145526.313151-5-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201006145526.313151-1-jlayton@kernel.org>
References: <20201006145526.313151-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

30 minutes is a long time to wait, and this makes it difficult to test
the feature by manually blocklisting clients. Remove the timeout
infrastructure and just allow the client to reconnect at will.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 5 -----
 fs/ceph/super.h      | 1 -
 2 files changed, 6 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index cd46f7e40370..1727931248b5 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4374,12 +4374,7 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
 	if (!READ_ONCE(fsc->blocklisted))
 		return;
 
-	if (fsc->last_auto_reconnect &&
-	    time_before(jiffies, fsc->last_auto_reconnect + HZ * 60 * 30))
-		return;
-
 	pr_info("auto reconnect after blocklisted\n");
-	fsc->last_auto_reconnect = jiffies;
 	ceph_force_reconnect(fsc->sb);
 }
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index d0cb6a51c6a4..9ced23b092f5 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -108,7 +108,6 @@ struct ceph_fs_client {
 
 	int mount_state;
 
-	unsigned long last_auto_reconnect;
 	bool blocklisted;
 
 	bool have_copy_from2;
-- 
2.26.2


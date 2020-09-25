Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F33278A6C
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Sep 2020 16:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgIYOI7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 25 Sep 2020 10:08:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728942AbgIYOI4 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 25 Sep 2020 10:08:56 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E02321D42;
        Fri, 25 Sep 2020 14:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601042935;
        bh=dzK5f1+oVyN6ZBey267IGXxdgShC116w1VoBnyfoQSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ntl1GUotfC4Z+yV3SMOVIu8rrHHuY2vaJU57D+BmzxN6Bqw8mwzAzOAxdapPqjrVL
         4sDhfxeIwuuPCUzTYPpC2PfiXLU0hXhIDxSJVOTVgT7UR1ZghIq30QMhLtl8NzpYLD
         7n/V92R/RtVDg36J2GUgike3vTYs7wruADqqdKVw=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com
Subject: [RFC PATCH 3/4] ceph: remove timeout on allowing reconnect after blocklisting
Date:   Fri, 25 Sep 2020 10:08:50 -0400
Message-Id: <20200925140851.320673-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925140851.320673-1-jlayton@kernel.org>
References: <20200925140851.320673-1-jlayton@kernel.org>
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
index 08f1c0c31dc2..fd16db6ecb0a 100644
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
index 582694899130..cb138e218ab4 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -108,7 +108,6 @@ struct ceph_fs_client {
 
 	unsigned long mount_state;
 
-	unsigned long last_auto_reconnect;
 	bool blocklisted;
 
 	bool have_copy_from2;
-- 
2.26.2


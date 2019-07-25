Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB09F74CC3
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 13:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403961AbfGYLR6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 07:17:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403924AbfGYLRu (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 07:17:50 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0520B2238C
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564053470;
        bh=Ns6HDDhryOahPbsqqF4zpyP11SbUO8vw5drWKCPbmmQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=amcC/r61qoQLwKrm9m8HkyppZj3jwbktlObrNpKi3tD8P9xQ8t9KtNpVbDXlCmiPT
         trcRVW03yPZxFXisniNnr4MwVdIHMDHYBILcHujeBuHnHEVOPwa97kEZvK6Q8GHBaN
         JNz5a3qWPLsC2nASrDQLdsg6YOoE9gHBUXKBuOks=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 4/8] ceph: fix comments over ceph_add_cap
Date:   Thu, 25 Jul 2019 07:17:42 -0400
Message-Id: <20190725111746.10393-5-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190725111746.10393-1-jlayton@kernel.org>
References: <20190725111746.10393-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We actually need the ci->i_ceph_lock here. The necessity of the s_mutex
is less clear. Also add a lockdep assertion for the i_ceph_lock.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index bdfec8978479..2563f42445e6 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -597,7 +597,7 @@ static void __check_cap_issue(struct ceph_inode_info *ci, struct ceph_cap *cap,
 /*
  * Add a capability under the given MDS session.
  *
- * Caller should hold session snap_rwsem (read) and s_mutex.
+ * Caller should hold session snap_rwsem (read) and ci->i_ceph_lock
  *
  * @fmode is the open file mode, if we are opening a file, otherwise
  * it is < 0.  (This is so we can atomically add the cap and add an
@@ -616,6 +616,8 @@ void ceph_add_cap(struct inode *inode,
 	int actual_wanted;
 	u32 gen;
 
+	lockdep_assert_held(&ci->i_ceph_lock);
+
 	dout("add_cap %p mds%d cap %llx %s seq %d\n", inode,
 	     session->s_mds, cap_id, ceph_cap_string(issued), seq);
 
-- 
2.21.0


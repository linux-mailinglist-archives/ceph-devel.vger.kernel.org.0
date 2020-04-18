Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147871AF042
	for <lists+ceph-devel@lfdr.de>; Sat, 18 Apr 2020 16:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgDROnh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 18 Apr 2020 10:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728614AbgDROng (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 18 Apr 2020 10:43:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEF4A22244;
        Sat, 18 Apr 2020 14:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587221015;
        bh=xbmExh56ch6cRkQ8mOrEwKDL4r87ABw7JWBB5qt5uZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQEa1vZTQGaVw54ufFxxxPFTahJ6p1AraFbfRNvo8LjLEtBb6bnM0BEFXPjs9/Z6J
         Ppn63EDu4U6ARobdmzG+CyplrqL0CjhT4JfmLzJvcGVIaaPYIpblHI8jrMITykCLZT
         620scDdU3k8NpGHCKEn6TpJFRB7OWzCGxHIlNBsE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Yan, Zheng" <zyan@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 06/28] ceph: don't skip updating wanted caps when cap is stale
Date:   Sat, 18 Apr 2020 10:43:06 -0400
Message-Id: <20200418144328.10265-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144328.10265-1-sashal@kernel.org>
References: <20200418144328.10265-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: "Yan, Zheng" <zyan@redhat.com>

[ Upstream commit 0aa971b6fd3f92afef6afe24ef78d9bb14471519 ]

1. try_get_cap_refs() fails to get caps and finds that mds_wanted
   does not include what it wants. It returns -ESTALE.
2. ceph_get_caps() calls ceph_renew_caps(). ceph_renew_caps() finds
   that inode has cap, so it calls ceph_check_caps().
3. ceph_check_caps() finds that issued caps (without checking if it's
   stale) already includes caps wanted by open file, so it skips
   updating wanted caps.

Above events can cause an infinite loop inside ceph_get_caps().

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c3a3ee74e2d84..1b5a50848b5be 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1863,8 +1863,12 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 		}
 
 		/* want more caps from mds? */
-		if (want & ~(cap->mds_wanted | cap->issued))
-			goto ack;
+		if (want & ~cap->mds_wanted) {
+			if (want & ~(cap->mds_wanted | cap->issued))
+				goto ack;
+			if (!__cap_is_valid(cap))
+				goto ack;
+		}
 
 		/* things we might delay */
 		if ((cap->issued & ~retain) == 0 &&
-- 
2.20.1


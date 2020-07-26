Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501A822DEF7
	for <lists+ceph-devel@lfdr.de>; Sun, 26 Jul 2020 14:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgGZM2G (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Jul 2020 08:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbgGZM2G (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 26 Jul 2020 08:28:06 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA54F206D8
        for <ceph-devel@vger.kernel.org>; Sun, 26 Jul 2020 12:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595766486;
        bh=3pUBaBWGrfcLKWmWWsUPaRO4kpEpnbREmgmSfMgtfSM=;
        h=From:To:Subject:Date:From;
        b=mBF1ryh10UnO+QvrSSWIQanO7x5nafxMTg9PcSF/ueNo5I1pTZgli+1Lezgnrzvee
         NSIOh3sqfir6Buttc28ivZhyrFUzJDX6ulaVVkHKnfyfz1oPqwup+pPynMxGxP/gR4
         q1L7ITC6l18DKkOf6AJEc0nPZF0yXZUDcP8QyAXI=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: fix memory leak when reallocating pages array for writepages
Date:   Sun, 26 Jul 2020 08:28:04 -0400
Message-Id: <20200726122804.16008-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Once we've replaced it, we don't want to keep the old one around
anymore.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 01ad09733ac7..01e167efa104 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1212,6 +1212,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 			       locked_pages * sizeof(*pages));
 			memset(data_pages + i, 0,
 			       locked_pages * sizeof(*pages));
+			kfree(data_pages);
 		} else {
 			BUG_ON(num_ops != req->r_num_ops);
 			index = pages[i - 1]->index + 1;
-- 
2.26.2


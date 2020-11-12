Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192652B089D
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Nov 2020 16:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbgKLPmN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Nov 2020 10:42:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727796AbgKLPmN (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 10:42:13 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EBDB20A8B
        for <ceph-devel@vger.kernel.org>; Thu, 12 Nov 2020 15:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605195732;
        bh=kz4rKXET+unF5UYGNG7Npa9a+cMmSFZ07p68r/4liKU=;
        h=From:To:Subject:Date:From;
        b=SIMR2X0Rc3YlrAsL4HVTaa/j8AkuCGIyv5BprAVWaEHHFLj19RPbARd3h/9KrMQl7
         I80TDAbVMkioS1y0GSxcHbjsLtDCzmH6GJd6jZtu9V0bMzj55OAFfdKmcDFnlHRUB6
         OAd9bZpPLOxEo3OcwWyk6IsB/B3vqg/S4/tWZ6vs=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: fix inode refcount leak when ceph_fill_inode on non-I_NEW inode fails
Date:   Thu, 12 Nov 2020 10:42:10 -0500
Message-Id: <20201112154210.304979-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index ab02966ef0a4..88bbeb05bd27 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1335,6 +1335,8 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 				in, ceph_vinop(in));
 			if (in->i_state & I_NEW)
 				discard_new_inode(in);
+			else
+				iput(in);
 			goto done;
 		}
 		req->r_target_inode = in;
-- 
2.28.0


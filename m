Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9B6B175CB2
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Mar 2020 15:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgCBOOm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Mar 2020 09:14:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:39072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727191AbgCBOOm (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 09:14:42 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 246652187F;
        Mon,  2 Mar 2020 14:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583158481;
        bh=387E2mIL0gf/LNm7cB/wGq7+XtBhYwQAJJlXl+RMHOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06wvDidILz3rsk6hvaZpHOB9bUEcSZkxGikmzXKzVqe1oHFmSWRFv14auGrHJBv3H
         SPH6+RFBPdFHWhvAD9mSlIRm9Yvs4LQqDKR6Z55V918K+isnaSf65JN2tPzE15+Nel
         V71xJdt3oHmPtQAAHhIq3yG6qKinx1EOwHxpuMRQ=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com, zyan@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH v6 07/13] ceph: don't take refs to want mask unless we have all bits
Date:   Mon,  2 Mar 2020 09:14:28 -0500
Message-Id: <20200302141434.59825-8-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302141434.59825-1-jlayton@kernel.org>
References: <20200302141434.59825-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: "Yan, Zheng" <ukernel@gmail.com>

If we don't have all of the cap bits for the want mask in
try_get_cap_refs, then just take refs on the need bits.

Signed-off-by: "Yan, Zheng" <ukernel@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Zheng,

I broke this patch out on its own as I wasn't sure it was still
needed with the latest iteration of the code. We can fold it into
the previous one if we do want it, or just drop it.

Thanks,
Jeff

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 51483ba572b3..c60b28304c50 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2616,7 +2616,10 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 				}
 				snap_rwsem_locked = true;
 			}
-			*got = need | (have & want);
+			if ((have & want) == want)
+				*got = need | want;
+			else
+				*got = need;
 			if (S_ISREG(inode->i_mode) &&
 			    (need & CEPH_CAP_FILE_RD) &&
 			    !(*got & CEPH_CAP_FILE_CACHE))
-- 
2.24.1


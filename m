Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D66416454F
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 14:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgBSNZe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Feb 2020 08:25:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgBSNZd (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 19 Feb 2020 08:25:33 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E38D24656;
        Wed, 19 Feb 2020 13:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582118733;
        bh=oWjNcP18BMllEH++F3AN1g9oS4DoQNpoJGAUDVPd6Us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N9et57J3+AboXCbmkLc323dP7Y1ac8ah2xePv27/9TuKRQ/IdhLxHf2ekRNQeH3TX
         Hfl4USNNiZHLeUqSa8XQE9aRsUJIprEHa3NEW9UJ0bV6+Ock5TJ6VoVwuwzW9DNaPr
         dM4jbrbBVfOYb2HjwCmwMeq2BdDeVSikMZvmD7rY=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com, zyan@redhat.com,
        pdonnell@redhat.com, xiubli@redhat.com
Subject: [PATCH v5 06/12] ceph: don't take refs to want mask unless we have all bits
Date:   Wed, 19 Feb 2020 08:25:20 -0500
Message-Id: <20200219132526.17590-7-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219132526.17590-1-jlayton@kernel.org>
References: <20200219132526.17590-1-jlayton@kernel.org>
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
index d6c5ee33f30f..c96b18407aef 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2667,7 +2667,10 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
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


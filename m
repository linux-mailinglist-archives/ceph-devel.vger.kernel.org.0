Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5DD3E8F5C
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Aug 2021 13:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237300AbhHKLTx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Aug 2021 07:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237293AbhHKLTw (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 07:19:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFBA26056C;
        Wed, 11 Aug 2021 11:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628680769;
        bh=+Ke3Tyx1TQ53pHhs429DvBwJkYm+ksMi/VSaWaTJeFo=;
        h=From:To:Cc:Subject:Date:From;
        b=rTJJI4gVbM0jhq9C+p8cuPEqhRGIoHW7H8A29Dh8WyuF1HFeM1tLBiXgMtfOPqCeo
         9mrDWg7COiUiaPQtBtZgFvojLkx8TsVHgpbmFJhTWsaXGjQT34Q36UdgX1Jg/Jtwri
         v7f4It3miUUOP9hM2hhduuI2psDfUMh7c3+rvKp+lcIyQ04Fr8EXSMCt7y+RRYD3JV
         l/NNFbHeCUmuxZ9HRmZ7SB0jQ1UbzjuXC4be6mku76RwiZU73W/uXzaKnJaLZHAKZ6
         gV2wgCMQOYjUJQ4o2eLxVZQYq9TPyjFtckqtu6IWF+hd4C5AuN1UIFJ/0UicskUc/C
         0CdQi5+p35L5A==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH] ceph: remove dead code in ceph_sync_write
Date:   Wed, 11 Aug 2021 07:19:27 -0400
Message-Id: <20210811111927.8417-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We've already checked these flags near the top of the function and
bailed out if either were set.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index d1755ac1d964..f55ca2c4c7de 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1834,12 +1834,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		goto retry_snap;
 	}
 
-	if (written >= 0) {
-		if ((map_flags & CEPH_OSDMAP_NEARFULL) ||
-		    (pool_flags & CEPH_POOL_FLAG_NEARFULL))
-			iocb->ki_flags |= IOCB_DSYNC;
+	if (written >= 0)
 		written = generic_write_sync(iocb, written);
-	}
 
 	goto out_unlocked;
 out:
-- 
2.31.1


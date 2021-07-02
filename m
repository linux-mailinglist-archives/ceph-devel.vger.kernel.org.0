Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814FD3BA2AE
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jul 2021 17:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbhGBPSG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Jul 2021 11:18:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232340AbhGBPSF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 11:18:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E13861176;
        Fri,  2 Jul 2021 15:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625238933;
        bh=FG6SuZ/WI0+b6Nhd4/vD9HNwE5kjrwbHVQq+PNMJ01I=;
        h=From:To:Cc:Subject:Date:From;
        b=scTjN8RK/YIt+mit44P91yYkzTe6XALKiiPr3alMvUrP/fTL6Mp90IpcAt5KEamaM
         L9X/5IuHXZAERFYGEKyU7Sl04mqcy1JgfcROrvWiP49EcX96TCxMK8YpsI51MRpeXU
         OqA1RSci/Cne3nKX6oIx5k823REaNMGCB4639JYhRSSLXV5pfCqwB51TzJUmZhrSsG
         LB3iwvtm6JjM6MFF8cOdi8tIPoW4s5/3XHlySdX6f5bhL4PCIQqOzwJ5kyJukH1gyB
         nAdzh6RxN6YxZxTyf1IWDjn+i+fJGaxfZd3U10mbOJnNIl6ULSSxyUHVGDcNtZ7ROo
         M95k/dsKqQAtQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH] ceph: fix comment about short copies in ceph_write_end
Date:   Fri,  2 Jul 2021 11:15:32 -0400
Message-Id: <20210702151532.94080-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index a1e2813731d1..6d3f74d46e5b 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1281,8 +1281,8 @@ static int ceph_write_end(struct file *file, struct address_space *mapping,
 	dout("write_end file %p inode %p page %p %d~%d (%d)\n", file,
 	     inode, page, (int)pos, (int)copied, (int)len);
 
-	/* zero the stale part of the page if we did a short copy */
 	if (!PageUptodate(page)) {
+		/* just return that nothing was copied on a short copy */
 		if (copied < len) {
 			copied = 0;
 			goto out;
-- 
2.31.1


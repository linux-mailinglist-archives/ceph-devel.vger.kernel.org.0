Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D9A3DE025
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Aug 2021 21:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhHBTja (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Aug 2021 15:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230290AbhHBTj2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 15:39:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3261260E09;
        Mon,  2 Aug 2021 19:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627933158;
        bh=CXUifFC3x0Y4+paeQGjaCY7zW4fqyzFkOI2V+9JfmoM=;
        h=From:To:Cc:Subject:Date:From;
        b=IvB/1HPwA8s+dv3Z0tVwDZ9qY6pojo2DnBgZjGni/CIpeCQR7gei1cFTMcm3e5Zrh
         FtFKu4jkYeqsY1hBzXlES95xYv7PUNytAqK3K5OCON1E7xWvhWXWEr/QiWboNj4Jxo
         GoOva1H4GETlDKb3/x5dY+hJr5b7fzZivvGIiGMD/y1a/ZJO/gghesvcmCVpkbB4Iv
         vaxtkQ4aBYqllb2LYQjadFP95CLFNz6GzhbGbmlH9xlQ9h2U9x0iiFfi5WxwS7SIgq
         VfgbKax64xXI9flxshi6sM2NCS2iIPC6Qd2oUgjPvRbIi03qzS5cIZxEZQ8QPg2/Xs
         7JnZK/c4w3wXg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Sage Weil <sage@redhat.com>
Subject: [PATCH] ceph: print more information when we can't find snaprealm during ceph_add_cap
Date:   Mon,  2 Aug 2021 15:39:16 -0400
Message-Id: <20210802193916.98176-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Print a bit more information when we can't find the realm during
ceph_add_cap. Show both the inode number and the old realm inode
number.

URL: https://tracker.ceph.com/issues/46419
Suggested-by: Sage Weil <sage@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index cecd4f66a60d..b4c3546def01 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -703,13 +703,12 @@ void ceph_add_cap(struct inode *inode,
 		 */
 		struct ceph_snap_realm *realm = ceph_lookup_snap_realm(mdsc,
 							       realmino);
-		if (realm) {
+		if (realm)
 			ceph_change_snap_realm(inode, realm);
-		} else {
-			pr_err("ceph_add_cap: couldn't find snap realm %llx\n",
-			       realmino);
-			WARN_ON(!realm);
-		}
+		else
+			WARN("ceph_add_cap: couldn't find snap realm 0x%llx (ino 0x%llx oldrealm 0x%llx)\n",
+			     realmino, ci->vino.ino,
+			     ci->i_snap_realm ? ci->i_snap_realm->ino : 0);
 	}
 
 	__check_cap_issue(ci, cap, issued);
-- 
2.31.1


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230FC4842FB
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jan 2022 15:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233986AbiADOEs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jan 2022 09:04:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49716 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbiADOEr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jan 2022 09:04:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 162AC6144A
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jan 2022 14:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE73BC36AEF;
        Tue,  4 Jan 2022 14:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641305086;
        bh=bnpE2OLbiGrXgcKzK+xawh7T4+9jfQRkRWyZlrDa6E8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gr1LI3OE/GN7Ig4hIXy7KUS9fiyb+kNJjkHNxsjaApWslbm+Xc0+PirLVQQlh5miY
         uEjQGmLYnlGf0yCySvzHkXU8+wCyPQ1hdIh0HKCos7TufpL1UvVuH0PK/Ydw7eTJH0
         /7xEY6g0SP/F16LQa9zazKaqHyyDcGiZDCdPA85tjBR3QO45yCIyf1jskRgazrlmju
         Tln0Z+PGGb1w0RxoG1D+O/4gWGgWghQCGCGkRF03i+8HhOoaplYNnF9JeaIyL6vtcR
         DRwLSwJSmtcbBpykrztR/wQqoBmwrX/Rt3d5eF7cSyHMAosR0iHB16nOG7FWi4Sgrh
         j6GrdUka7h5Cw==
From:   Christian Brauner <brauner@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 07/12] ceph: allow idmapped getattr inode op
Date:   Tue,  4 Jan 2022 15:04:09 +0100
Message-Id: <20220104140414.155198-8-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220104140414.155198-1-brauner@kernel.org>
References: <20220104140414.155198-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=787; h=from:subject; bh=MwhNjtywN6dSstNOGp9w0GC8zs5JE/ZTuRy+D4xhwIY=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSReCd5UnvwyLuA6S/BSnzd3NXX44ngivu83mNavbCOurGQa 9PlwRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwESc0xn+17+Qy1V/LvtS57Tk6/uhU2 572xqZ6J7j0bfguV02ze70MUaGjUfr1njPPSh8n/tgUOapjdZf1Mw/zbosPi9PfN2OOp1oRgA=
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Enable ceph_getattr() to handle idmapped mounts. This is just a matter
of passing down the mount's idmapping.

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ceph/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index e3322fcb2e8d..f648aecc5827 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2364,7 +2364,7 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
 			return err;
 	}
 
-	generic_fillattr(&init_user_ns, inode, stat);
+	generic_fillattr(mnt_userns, inode, stat);
 	stat->ino = ceph_present_inode(inode);
 
 	/*
-- 
2.32.0


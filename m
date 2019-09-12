Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49005B0EAA
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Sep 2019 14:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731521AbfILMNv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Sep 2019 08:13:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731508AbfILMNv (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 12 Sep 2019 08:13:51 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF4AE2075C
        for <ceph-devel@vger.kernel.org>; Thu, 12 Sep 2019 12:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568290431;
        bh=CNX8NO0gOb1n7W6oL9VD1GgWn+1I4nqVGcGZIKweK+0=;
        h=From:To:Subject:Date:From;
        b=cFPqQpF9BtlQrwNAtSjqy1RrHkKQ8yNiImK/8iBxHz/8igxF+lbJLgEveRwTPj+bT
         hs9CrjGyv6NzD77U/YJuXTfi6DkLlXepHrslhNnSzh7N0qQWEHSsWtkSjMzVDcrxYM
         v4N+0FblACrWb3ylFFaC0Y9pZvg2DnldbyrJE8R0=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: call ceph_mdsc_destroy from destroy_fs_client
Date:   Thu, 12 Sep 2019 08:13:49 -0400
Message-Id: <20190912121349.16056-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

They're always called in succession.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/super.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Note that this is based on top of the mount API rework patch in testing.

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index cbee5dff3d87..bea6f053f999 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -673,6 +673,7 @@ static void destroy_fs_client(struct ceph_fs_client *fsc)
 {
 	dout("destroy_fs_client %p\n", fsc);
 
+	ceph_mdsc_destroy(fsc);
 	destroy_workqueue(fsc->inode_wq);
 	destroy_workqueue(fsc->cap_wq);
 
@@ -1062,10 +1063,8 @@ static void ceph_free_fc(struct fs_context *fc)
 	struct ceph_config_context *ctx = fc->fs_private;
 	struct ceph_fs_client *fsc = fc->s_fs_info;
 
-	if (fsc) {
-		ceph_mdsc_destroy(fsc);
+	if (fsc)
 		destroy_fs_client(fsc);
-	}
 
 	if (ctx) {
 		destroy_mount_options(ctx->mount_options);
@@ -1148,8 +1147,6 @@ static void ceph_kill_sb(struct super_block *s)
 
 	ceph_fscache_unregister_fs(fsc);
 
-	ceph_mdsc_destroy(fsc);
-
 	destroy_fs_client(fsc);
 	free_anon_bdev(dev);
 }
-- 
2.21.0


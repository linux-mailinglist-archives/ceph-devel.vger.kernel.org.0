Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9495F267964
	for <lists+ceph-devel@lfdr.de>; Sat, 12 Sep 2020 12:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgILKO3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 12 Sep 2020 06:14:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbgILKO1 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 12 Sep 2020 06:14:27 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ACF1214D8;
        Sat, 12 Sep 2020 10:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599905666;
        bh=tGUHCOsqQ70R/bp+rBmmDX7aQMNfyisGukAglsV5esE=;
        h=From:To:Cc:Subject:Date:From;
        b=0iSdCuqiU80Cl2bpECS2JtmBrIfRpmg7MAw+Lw+CC2FxjqM5dl+5NVjhAdwpIE27y
         ytCQtreGaDgcdBTQ6EKhBMkQewjdHLx8O7EoMlH51EfpZYRm4nUVXZetIqQTQ0yO9l
         033GJeScwL93G2E4shsyZsp6597fKmRlt65rjT9E=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH] ceph: use kill_anon_super helper
Date:   Sat, 12 Sep 2020 06:14:24 -0400
Message-Id: <20200912101424.5659-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

ceph open-codes this around some other activity and the rationale
for it isn't clear. There is no need to delay free_anon_bdev until
the end of kill_sb.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/super.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 7ec0e6d03d10..b3fc9bb61afc 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1205,14 +1205,13 @@ static int ceph_init_fs_context(struct fs_context *fc)
 static void ceph_kill_sb(struct super_block *s)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(s);
-	dev_t dev = s->s_dev;
 
 	dout("kill_sb %p\n", s);
 
 	ceph_mdsc_pre_umount(fsc->mdsc);
 	flush_fs_workqueues(fsc);
 
-	generic_shutdown_super(s);
+	kill_anon_super(s);
 
 	fsc->client->extra_mon_dispatch = NULL;
 	ceph_fs_debugfs_cleanup(fsc);
@@ -1220,7 +1219,6 @@ static void ceph_kill_sb(struct super_block *s)
 	ceph_fscache_unregister_fs(fsc);
 
 	destroy_fs_client(fsc);
-	free_anon_bdev(dev);
 }
 
 static struct file_system_type ceph_fs_type = {
-- 
2.26.2


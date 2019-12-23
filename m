Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABA6D12977F
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Dec 2019 15:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfLWOcR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Dec 2019 09:32:17 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8164 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726777AbfLWOcR (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Dec 2019 09:32:17 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2E9D8E26C98A02438037;
        Mon, 23 Dec 2019 22:32:15 +0800 (CST)
Received: from localhost.localdomain (10.90.53.225) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Mon, 23 Dec 2019 22:32:06 +0800
From:   Chen Wandun <chenwandun@huawei.com>
To:     <jlayton@kernel.org>, <sage@redhat.com>, <idryomov@gmail.com>,
        <ceph-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <chenwandun@huawei.com>
Subject: [PATCH next] ceph: Fix debugfs_simple_attr.cocci warnings
Date:   Mon, 23 Dec 2019 22:39:18 +0800
Message-ID: <1577111958-100981-1-git-send-email-chenwandun@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Use DEFINE_DEBUGFS_ATTRIBUTE rather than DEFINE_SIMPLE_ATTRIBUTE
for debugfs files.

Semantic patch information:
Rationale: DEFINE_SIMPLE_ATTRIBUTE + debugfs_create_file()
imposes some significant overhead as compared to
DEFINE_DEBUGFS_ATTRIBUTE + debugfs_create_file_unsafe().

Signed-off-by: Chen Wandun <chenwandun@huawei.com>
---
 fs/ceph/debugfs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index c281f32..60a0f1a 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -243,8 +243,8 @@ static int congestion_kb_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(congestion_kb_fops, congestion_kb_get,
-			congestion_kb_set, "%llu\n");
+DEFINE_DEBUGFS_ATTRIBUTE(congestion_kb_fops, congestion_kb_get,
+			 congestion_kb_set, "%llu\n");
 
 
 void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
@@ -264,11 +264,11 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 
 	dout("ceph_fs_debugfs_init\n");
 	fsc->debugfs_congestion_kb =
-		debugfs_create_file("writeback_congestion_kb",
-				    0600,
-				    fsc->client->debugfs_dir,
-				    fsc,
-				    &congestion_kb_fops);
+		debugfs_create_file_unsafe("writeback_congestion_kb",
+					   0600,
+					   fsc->client->debugfs_dir,
+					   fsc,
+					   &congestion_kb_fops);
 
 	snprintf(name, sizeof(name), "../../bdi/%s",
 		 dev_name(fsc->sb->s_bdi->dev));
-- 
2.7.4


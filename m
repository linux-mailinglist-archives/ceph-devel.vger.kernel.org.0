Return-Path: <ceph-devel+bounces-86-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C3457EB39E
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Nov 2023 16:32:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E2D7B20AED
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Nov 2023 15:32:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E824175A;
	Tue, 14 Nov 2023 15:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8AE41755
	for <ceph-devel@vger.kernel.org>; Tue, 14 Nov 2023 15:31:51 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6C4124;
	Tue, 14 Nov 2023 07:31:49 -0800 (PST)
Received: from kwepemm000012.china.huawei.com (unknown [172.30.72.54])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4SV9J40s8RzvQd3;
	Tue, 14 Nov 2023 23:31:32 +0800 (CST)
Received: from build.huawei.com (10.175.101.6) by
 kwepemm000012.china.huawei.com (7.193.23.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 14 Nov 2023 23:31:47 +0800
From: Wenchao Hao <haowenchao2@huawei.com>
To: Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Jeff
 Layton <jlayton@kernel.org>, <ceph-devel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <louhongxiang@huawei.com>, Wenchao Hao <haowenchao2@huawei.com>
Subject: [PATCH] ceph: quota: Fix invalid pointer access in
Date: Tue, 14 Nov 2023 23:31:08 +0800
Message-ID: <20231114153108.1932884-1-haowenchao2@huawei.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm000012.china.huawei.com (7.193.23.142)
X-CFilter-Loop: Reflected

This issue is reported by smatch, get_quota_realm() might return
ERR_PTR, so we should using IS_ERR_OR_NULL here to check the return
value.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 fs/ceph/quota.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index 9d36c3532de1..c4b2929c6a83 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -495,7 +495,7 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
 	realm = get_quota_realm(mdsc, d_inode(fsc->sb->s_root),
 				QUOTA_GET_MAX_BYTES, true);
 	up_read(&mdsc->snap_rwsem);
-	if (!realm)
+	if (IS_ERR_OR_NULL(realm))
 		return false;
 
 	spin_lock(&realm->inodes_with_caps_lock);
-- 
2.32.0



Return-Path: <ceph-devel+bounces-1659-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C8C4F95132B
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Aug 2024 05:36:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F55F1F23637
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Aug 2024 03:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C74273BBCB;
	Wed, 14 Aug 2024 03:36:48 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A4010953;
	Wed, 14 Aug 2024 03:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723606608; cv=none; b=VhDvj2keBvrQdB1CS8sgxqO2IT6r9vBkEyfk0e24U+X7JWa6Cdhzzzw+RJQvFN4Xi0O/+T/ZHy4Cw7u4d8Ia4ZCiNi7qgLpGEN2Z9671jTYhpX3hgTT8Q5c2MM/VUUftJDvPt3wT7ElwPWXGXWZ0VCzg6TU4uFWzBhti8E+9svw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723606608; c=relaxed/simple;
	bh=6OsNJBQBUVldXwm9OyXQ0qbPsA/7FgEPlE2lfoONoEA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Cui525YmcL24jWoIALF+/kAlqhVNPUy8FGBtPtXFLdW1gEO0KzB0o336fEIRds9E5mg1zVKnmDxU80jA5c0Av+i4FTbHWbzVG6KWt+ZWixMYSyvdv0wizXVX9dh5R2PWDOCpf8+12DQoqAPBqMotVjtS1lHdac3KTbaigZ9gke0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WkDPG5GMsz1HFwv;
	Wed, 14 Aug 2024 11:33:38 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id C1D92140109;
	Wed, 14 Aug 2024 11:36:42 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpemf500002.china.huawei.com
 (7.185.36.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 14 Aug
 2024 11:36:42 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <xiubli@redhat.com>, <idryomov@gmail.com>, <mchangir@redhat.com>,
	<jlayton@kernel.org>
CC: <ceph-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yuehaibing@huawei.com>
Subject: [PATCH -next] ceph: Remove unused declarations
Date: Wed, 14 Aug 2024 11:34:15 +0800
Message-ID: <20240814033415.3800889-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf500002.china.huawei.com (7.185.36.57)

These functions is never implemented and used.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 fs/ceph/mds_client.h            | 3 ---
 fs/ceph/super.h                 | 2 --
 include/linux/ceph/osd_client.h | 2 --
 3 files changed, 7 deletions(-)

diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 9bcc7f181bfe..585ab5a6d87d 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -559,9 +559,6 @@ extern struct ceph_mds_session *
 ceph_get_mds_session(struct ceph_mds_session *s);
 extern void ceph_put_mds_session(struct ceph_mds_session *s);
 
-extern int ceph_send_msg_mds(struct ceph_mds_client *mdsc,
-			     struct ceph_msg *msg, int mds);
-
 extern int ceph_mdsc_init(struct ceph_fs_client *fsc);
 extern void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc);
 extern void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 6e817bf1337c..c88bf53f68e9 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1056,8 +1056,6 @@ extern int ceph_fill_trace(struct super_block *sb,
 extern int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 				    struct ceph_mds_session *session);
 
-extern int ceph_inode_holds_cap(struct inode *inode, int mask);
-
 extern bool ceph_inode_set_size(struct inode *inode, loff_t size);
 extern void __ceph_do_pending_vmtruncate(struct inode *inode);
 
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index f66f6aac74f6..d7941478158c 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -449,8 +449,6 @@ extern int ceph_osdc_init(struct ceph_osd_client *osdc,
 extern void ceph_osdc_stop(struct ceph_osd_client *osdc);
 extern void ceph_osdc_reopen_osds(struct ceph_osd_client *osdc);
 
-extern void ceph_osdc_handle_reply(struct ceph_osd_client *osdc,
-				   struct ceph_msg *msg);
 extern void ceph_osdc_handle_map(struct ceph_osd_client *osdc,
 				 struct ceph_msg *msg);
 void ceph_osdc_update_epoch_barrier(struct ceph_osd_client *osdc, u32 eb);
-- 
2.34.1



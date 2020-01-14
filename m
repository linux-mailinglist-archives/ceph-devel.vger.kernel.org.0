Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16B1413AA85
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jan 2020 14:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgANNSD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Jan 2020 08:18:03 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:42344 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726453AbgANNSD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 08:18:03 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07417;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0TnjLvki_1579007880;
Received: from localhost(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0TnjLvki_1579007880)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 14 Jan 2020 21:18:00 +0800
From:   Alex Shi <alex.shi@linux.alibaba.com>
Cc:     Alex Shi <alex.shi@linux.alibaba.com>,
        Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs/ceph: remove unused variable
Date:   Tue, 14 Jan 2020 21:17:58 +0800
Message-Id: <1579007878-136866-1-git-send-email-alex.shi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
To:     unlisted-recipients:; (no To-header on input)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If we don't care err here, maybe better to remove it.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jeff Layton <jlayton@kernel.org> 
Cc: Sage Weil <sage@redhat.com> 
Cc: Ilya Dryomov <idryomov@gmail.com> 
Cc: ceph-devel@vger.kernel.org 
Cc: linux-kernel@vger.kernel.org 
---
 fs/ceph/export.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index b6bfa94332c3..b7bb41cd1070 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -291,7 +291,6 @@ static struct dentry *__get_parent(struct super_block *sb,
 	struct ceph_mds_request *req;
 	struct inode *inode;
 	int mask;
-	int err;
 
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPPARENT,
 				       USE_ANY_MDS);
@@ -314,7 +313,7 @@ static struct dentry *__get_parent(struct super_block *sb,
 	req->r_args.getattr.mask = cpu_to_le32(mask);
 
 	req->r_num_caps = 1;
-	err = ceph_mdsc_do_request(mdsc, NULL, req);
+	ceph_mdsc_do_request(mdsc, NULL, req);
 	inode = req->r_target_inode;
 	if (inode)
 		ihold(inode);
-- 
1.8.3.1


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5DF30A2E3
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Feb 2021 08:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhBAHxH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Feb 2021 02:53:07 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:46253 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232281AbhBAHxG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Feb 2021 02:53:06 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UNWyeD-_1612165931;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UNWyeD-_1612165931)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 01 Feb 2021 15:52:22 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] ceph: Replace DEFINE_SIMPLE_ATTRIBUTE with DEFINE_DEBUGFS_ATTRIBUTE
Date:   Mon,  1 Feb 2021 15:52:10 +0800
Message-Id: <1612165930-110076-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Fix the following coccicheck warning:

./fs/ceph/debugfs.c:347:0-23: WARNING: congestion_kb_fops should be
defined with DEFINE_DEBUGFS_ATTRIBUTE.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/ceph/debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 66989c8..617327e 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -344,8 +344,8 @@ static int congestion_kb_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(congestion_kb_fops, congestion_kb_get,
-			congestion_kb_set, "%llu\n");
+DEFINE_DEBUGFS_ATTRIBUTE(congestion_kb_fops, congestion_kb_get,
+			  congestion_kb_set, "%llu\n");
 
 
 void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
-- 
1.8.3.1


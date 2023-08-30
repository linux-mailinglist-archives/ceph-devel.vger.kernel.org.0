Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F352D78DC34
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Aug 2023 20:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242693AbjH3SoA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Aug 2023 14:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242527AbjH3I7j (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Aug 2023 04:59:39 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024DCCC9;
        Wed, 30 Aug 2023 01:59:36 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RbJ841cywzVkFF;
        Wed, 30 Aug 2023 16:57:08 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Wed, 30 Aug
 2023 16:59:34 +0800
From:   Jinjie Ruan <ruanjinjie@huawei.com>
To:     <linux-block@vger.kernel.org>, <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Jens Axboe <axboe@kernel.dk>
CC:     <ruanjinjie@huawei.com>
Subject: [PATCH -next] rbd: Use list_for_each_entry() helper
Date:   Wed, 30 Aug 2023 16:59:29 +0800
Message-ID: <20230830085929.527853-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Convert list_for_each() to list_for_each_entry() so that the tmp
list_head pointer and list_entry() call are no longer needed, which
can reduce a few lines of code. No functional changed.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 drivers/block/rbd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 2328cc05be36..3de11f077144 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -7199,7 +7199,6 @@ static void rbd_dev_remove_parent(struct rbd_device *rbd_dev)
 static ssize_t do_rbd_remove(const char *buf, size_t count)
 {
 	struct rbd_device *rbd_dev = NULL;
-	struct list_head *tmp;
 	int dev_id;
 	char opt_buf[6];
 	bool force = false;
@@ -7226,8 +7225,7 @@ static ssize_t do_rbd_remove(const char *buf, size_t count)
 
 	ret = -ENOENT;
 	spin_lock(&rbd_dev_list_lock);
-	list_for_each(tmp, &rbd_dev_list) {
-		rbd_dev = list_entry(tmp, struct rbd_device, node);
+	list_for_each_entry(rbd_dev, &rbd_dev_list, node) {
 		if (rbd_dev->dev_id == dev_id) {
 			ret = 0;
 			break;
-- 
2.34.1


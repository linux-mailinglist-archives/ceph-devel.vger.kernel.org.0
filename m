Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F78160F389
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Oct 2022 11:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235430AbiJ0JUa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Oct 2022 05:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235298AbiJ0JUW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Oct 2022 05:20:22 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415582228C;
        Thu, 27 Oct 2022 02:20:13 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Myg7816n6zJnDr;
        Thu, 27 Oct 2022 17:17:24 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 17:20:11 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 27 Oct
 2022 17:20:11 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <ceph-devel@vger.kernel.org>, <linux-block@vger.kernel.org>
CC:     <idryomov@gmail.com>, <dongsheng.yang@easystack.cn>,
        <axboe@kernel.dk>, <yehuda@hq.newdream.net>,
        <yangyingliang@huawei.com>
Subject: [PATCH] rbd: fix possible memory leak in rbd_sysfs_init()
Date:   Thu, 27 Oct 2022 17:19:18 +0800
Message-ID: <20221027091918.2294132-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If device_register() returns error in rbd_sysfs_init(), name of kobject
which is allocated in dev_set_name() called in device_add() is leaked.

As comment of device_add() says, it should call put_device() to drop
the reference count that was set in device_initialize() when it fails,
so the name can be freed in kobject_cleanup().

Fault injection test can trigger this problem:

unreferenced object 0xffff88810173aa78 (size 8):
  comm "modprobe", pid 247, jiffies 4294714278 (age 31.789s)
  hex dump (first 8 bytes):
    72 62 64 00 81 88 ff ff                          rbd.....
  backtrace:
    [<00000000f58fae56>] __kmalloc_node_track_caller+0x44/0x1b0
    [<00000000bdd44fe7>] kstrdup+0x3a/0x70
    [<00000000f7844d0b>] kstrdup_const+0x63/0x80
    [<000000001b0a0eeb>] kvasprintf_const+0x10b/0x190
    [<00000000a47bd894>] kobject_set_name_vargs+0x56/0x150
    [<00000000d5edbf18>] dev_set_name+0xab/0xe0
    [<00000000f5153e80>] device_add+0x106/0x1f20

Fixes: dfc5606dc513 ("rbd: replace the rbd sysfs interface")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/block/rbd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index f9e39301c4af..04453f4a319c 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -7222,8 +7222,10 @@ static int __init rbd_sysfs_init(void)
 	int ret;
 
 	ret = device_register(&rbd_root_dev);
-	if (ret < 0)
+	if (ret < 0) {
+		put_device(&rbd_root_dev);
 		return ret;
+	}
 
 	ret = bus_register(&rbd_bus_type);
 	if (ret < 0)
-- 
2.25.1


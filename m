Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF9D3D1CCF
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Jul 2021 06:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhGVDXN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 21 Jul 2021 23:23:13 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:11462 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbhGVDWl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 21 Jul 2021 23:22:41 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GVdxz559Jzch9T;
        Thu, 22 Jul 2021 11:59:51 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Jul 2021 12:03:15 +0800
Received: from thunder-town.china.huawei.com (10.174.179.0) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Jul 2021 12:03:14 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Jens Axboe <axboe@kernel.dk>,
        Yehuda Sadeh <yehuda@hq.newdream.net>,
        Sage Weil <sage@newdream.net>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH] rbd: use kref_put_lock() to fix potential UAF
Date:   Thu, 22 Jul 2021 12:02:16 +0800
Message-ID: <20210722040216.4090-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.179.0]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When the refcount is decreased to 0, the rbd_client_release() is called.
Before CPU0 reaches the race point (1), CPU1 may obtain the spinlock
and traverse the linked list to find 'rbdc'. Although CPU1 will call
kref_get() to increase the refcount, it is obviously too late. CPU0 will
release 'rbdc' directly, CPU1 then accesses 'rbdc' and triggers UAF.

Use kref_put_lock() to ensure that both the operations of decrease
refcount to 0 and link deletion are lock protected eliminates this risk.

     CPU0                      CPU1
rbd_client_release():
			    <-------- (1)
spin_lock(&rbd_client_list_lock);
list_del(&rbdc->node);
spin_unlock(&rbd_client_list_lock);

kfree(rbdc);
			    <-------- use-after-free

Fixes: 602adf400201 ("rbd: introduce rados block device (rbd), based on libceph")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/block/rbd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 531d390902dd..3a8989bf8e9c 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -875,11 +875,11 @@ static void rbd_client_release(struct kref *kref)
 {
 	struct rbd_client *rbdc = container_of(kref, struct rbd_client, kref);
 
-	dout("%s: rbdc %p\n", __func__, rbdc);
-	spin_lock(&rbd_client_list_lock);
 	list_del(&rbdc->node);
 	spin_unlock(&rbd_client_list_lock);
 
+	dout("%s: rbdc %p\n", __func__, rbdc);
+
 	ceph_destroy_client(rbdc->client);
 	kfree(rbdc);
 }
@@ -891,7 +891,8 @@ static void rbd_client_release(struct kref *kref)
 static void rbd_put_client(struct rbd_client *rbdc)
 {
 	if (rbdc)
-		kref_put(&rbdc->kref, rbd_client_release);
+		kref_put_lock(&rbdc->kref,
+			      rbd_client_release, &rbd_client_list_lock);
 }
 
 /*
-- 
2.25.1


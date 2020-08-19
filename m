Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E952498D3
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Aug 2020 10:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgHSI4N (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Aug 2020 04:56:13 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:9846 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726931AbgHSIyZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 19 Aug 2020 04:54:25 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 67E7A8AE543F7D26D4D6;
        Wed, 19 Aug 2020 16:54:17 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Wed, 19 Aug 2020
 16:54:09 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <idryomov@gmail.com>, <axboe@kernel.dk>,
        <dongsheng.yang@easystack.cn>
CC:     <ceph-devel@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH] rbd: Convert to use the preferred fallthrough macro
Date:   Wed, 19 Aug 2020 04:53:04 -0400
Message-ID: <20200819085304.43653-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Convert the uses of fallthrough comments to fallthrough macro.

Signed-off-by: Hongxiang Lou <louhongxiang@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 drivers/block/rbd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index d9c0e7d154f9..011539039693 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3293,7 +3293,7 @@ static bool rbd_obj_advance_copyup(struct rbd_obj_request *obj_req, int *result)
 	case __RBD_OBJ_COPYUP_OBJECT_MAPS:
 		if (!pending_result_dec(&obj_req->pending, result))
 			return false;
-		/* fall through */
+		fallthrough;
 	case RBD_OBJ_COPYUP_OBJECT_MAPS:
 		if (*result) {
 			rbd_warn(rbd_dev, "snap object map update failed: %d",
@@ -3312,7 +3312,7 @@ static bool rbd_obj_advance_copyup(struct rbd_obj_request *obj_req, int *result)
 	case __RBD_OBJ_COPYUP_WRITE_OBJECT:
 		if (!pending_result_dec(&obj_req->pending, result))
 			return false;
-		/* fall through */
+		fallthrough;
 	case RBD_OBJ_COPYUP_WRITE_OBJECT:
 		return true;
 	default:
@@ -3399,7 +3399,7 @@ static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, int *result)
 	case __RBD_OBJ_WRITE_COPYUP:
 		if (!rbd_obj_advance_copyup(obj_req, result))
 			return false;
-		/* fall through */
+		fallthrough;
 	case RBD_OBJ_WRITE_COPYUP:
 		if (*result) {
 			rbd_warn(rbd_dev, "copyup failed: %d", *result);
@@ -3592,7 +3592,7 @@ static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
 	case __RBD_IMG_OBJECT_REQUESTS:
 		if (!pending_result_dec(&img_req->pending, result))
 			return false;
-		/* fall through */
+		fallthrough;
 	case RBD_IMG_OBJECT_REQUESTS:
 		return true;
 	default:
-- 
2.19.1


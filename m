Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30771788AC
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2019 11:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbfG2Jnd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Jul 2019 05:43:33 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22661 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbfG2Jnd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Jul 2019 05:43:33 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowADHYpWjvz5djxunAA--.901S12;
        Mon, 29 Jul 2019 17:43:02 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v3 10/15] rbd: introduce completion for each img_request
Date:   Mon, 29 Jul 2019 09:42:52 +0000
Message-Id: <1564393377-28949-11-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowADHYpWjvz5djxunAA--.901S12
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjfULfQRDUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiYwYBeli2kzcd3wAAsW
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When we are going to do a sync IO, we need a way
to wait a img_request to complete. Example, when
we are going to do journal replay, we need to do
a sync replaying, and return after img_request
completed.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 drivers/block/rbd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index d7ed462..4ff46ac 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -349,6 +349,9 @@ struct rbd_img_request {
 	struct pending_result	pending;
 	struct work_struct	work;
 	int			work_result;
+
+	struct completion	completion;
+
 	struct kref		kref;
 };
 
@@ -1750,6 +1753,7 @@ static struct rbd_img_request *rbd_img_request_create(
 		img_request_layered_set(img_request);
 
 	INIT_LIST_HEAD(&img_request->lock_item);
+	init_completion(&img_request->completion);
 	INIT_LIST_HEAD(&img_request->object_extents);
 	mutex_init(&img_request->state_mutex);
 	kref_init(&img_request->kref);
@@ -3725,6 +3729,7 @@ static void rbd_img_handle_request(struct rbd_img_request *img_req, int result)
 	} else {
 		struct request *rq = img_req->rq;
 
+		complete_all(&img_req->completion);
 		rbd_img_request_put(img_req);
 		blk_mq_end_request(rq, errno_to_blk_status(result));
 	}
-- 
1.8.3.1



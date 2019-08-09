Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE01872A5
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Aug 2019 09:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405413AbfHIHFc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Aug 2019 03:05:32 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:41624 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbfHIHFc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 9 Aug 2019 03:05:32 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAAnkUg5G01dDjIEAQ--.1115S2;
        Fri, 09 Aug 2019 15:05:29 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH] rbd: fix response length parameter for rbd_obj_method_sync()
Date:   Fri,  9 Aug 2019 07:05:27 +0000
Message-Id: <1565334327-7454-1-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: u+CowAAnkUg5G01dDjIEAQ--.1115S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjfUBnXoUUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiQxkMelbdG4gJTwAAsy
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Response will be an encoded string, which includes a length.
So we need to allocate more buf of sizeof (__le32) in reply
buffer, and pass the reply buffer size as a parameter in
rbd_obj_method_sync function.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 drivers/block/rbd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 3327192..db55ece 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5661,14 +5661,17 @@ static int rbd_dev_v2_object_prefix(struct rbd_device *rbd_dev)
 	void *reply_buf;
 	int ret;
 	void *p;
+	size_t size;
 
-	reply_buf = kzalloc(RBD_OBJ_PREFIX_LEN_MAX, GFP_KERNEL);
+	/* Response will be an encoded string, which includes a length */
+	size = sizeof (__le32) + RBD_OBJ_PREFIX_LEN_MAX;
+	reply_buf = kzalloc(size, GFP_KERNEL);
 	if (!reply_buf)
 		return -ENOMEM;
 
 	ret = rbd_obj_method_sync(rbd_dev, &rbd_dev->header_oid,
 				  &rbd_dev->header_oloc, "get_object_prefix",
-				  NULL, 0, reply_buf, RBD_OBJ_PREFIX_LEN_MAX);
+				  NULL, 0, reply_buf, size);
 	dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
 	if (ret < 0)
 		goto out;
@@ -6697,7 +6700,7 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
 
 	ret = rbd_obj_method_sync(rbd_dev, &oid, &rbd_dev->header_oloc,
 				  "get_id", NULL, 0,
-				  response, RBD_IMAGE_ID_LEN_MAX);
+				  response, size);
 	dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
 	if (ret == -ENOENT) {
 		image_id = kstrdup("", GFP_KERNEL);
-- 
1.8.3.1



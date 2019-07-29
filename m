Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEFFD788B0
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2019 11:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfG2Jng (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Jul 2019 05:43:36 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22752 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727911AbfG2Jng (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Jul 2019 05:43:36 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowADHYpWjvz5djxunAA--.901S13;
        Mon, 29 Jul 2019 17:43:03 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v3 11/15] rbd: introduce IMG_REQ_NOLOCK flag for image request state
Date:   Mon, 29 Jul 2019 09:42:53 +0000
Message-Id: <1564393377-28949-12-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowADHYpWjvz5djxunAA--.901S13
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjfULfQRDUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiQQcBelbdGyrNSwAAsB
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When we are going to replay an journal event, we don't need
to acquire exclusive_lock, as we are in lock acquiring.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 drivers/block/rbd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 4ff46ac..337a20f 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -318,6 +318,7 @@ struct rbd_obj_request {
 enum img_req_flags {
 	IMG_REQ_CHILD,		/* initiator: block = 0, child image = 1 */
 	IMG_REQ_LAYERED,	/* ENOENT handling: normal = 0, layered = 1 */
+	IMG_REQ_NOLOCK,		/* this img request don't need exclusive lock */
 };
 
 enum rbd_img_state {
@@ -3550,6 +3551,9 @@ static bool need_exclusive_lock(struct rbd_img_request *img_req)
 	if (rbd_dev->spec->snap_id != CEPH_NOSNAP)
 		return false;
 
+	if (test_bit(IMG_REQ_NOLOCK, &img_req->flags))
+		return false;
+
 	rbd_assert(!test_bit(IMG_REQ_CHILD, &img_req->flags));
 	if (rbd_dev->opts->lock_on_read ||
 	    (rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP))
-- 
1.8.3.1



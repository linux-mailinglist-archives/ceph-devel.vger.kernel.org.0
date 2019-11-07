Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6F5F3B88
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Nov 2019 23:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbfKGWgv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Nov 2019 17:36:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45912 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfKGWgv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Nov 2019 17:36:51 -0500
Received: from [82.43.126.140] (helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iSqOV-0005un-8Q; Thu, 07 Nov 2019 22:36:47 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Alex Elder <elder@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        ceph-devel@vger.kernel.org, linux-block@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rdb: fix spelling mistake "requeueing" -> "requeuing"
Date:   Thu,  7 Nov 2019 22:36:46 +0000
Message-Id: <20191107223646.416986-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a debug message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/block/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 39136675dae5..8e1595d09138 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4230,7 +4230,7 @@ static void rbd_acquire_lock(struct work_struct *work)
 		 * lock owner acked, but resend if we don't see them
 		 * release the lock
 		 */
-		dout("%s rbd_dev %p requeueing lock_dwork\n", __func__,
+		dout("%s rbd_dev %p requeuing lock_dwork\n", __func__,
 		     rbd_dev);
 		mod_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork,
 		    msecs_to_jiffies(2 * RBD_NOTIFY_TIMEOUT * MSEC_PER_SEC));
-- 
2.20.1


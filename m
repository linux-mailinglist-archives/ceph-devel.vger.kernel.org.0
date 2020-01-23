Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE13146849
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Jan 2020 13:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgAWMoh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Jan 2020 07:44:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:52714 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbgAWMog (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 23 Jan 2020 07:44:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D889FAD0F;
        Thu, 23 Jan 2020 12:44:34 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     Ilya Dromov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        David Disseldorp <ddiss@suse.com>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH] rbd: set the 'device' link in sysfs
Date:   Thu, 23 Jan 2020 13:44:33 +0100
Message-Id: <20200123124433.121939-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The rbd driver already provides additional information in sysfs
under /sys/bus/rbd, so we should set the 'device' link in the block
device to reference this information.

Cc: David Disseldorp <ddiss@suse.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/block/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 9f1f8689e316..3240b7744aeb 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -6938,7 +6938,7 @@ static ssize_t do_rbd_add(struct bus_type *bus,
 	if (rc)
 		goto err_out_image_lock;
 
-	add_disk(rbd_dev->disk);
+	device_add_disk(&rbd_dev->dev, rbd_dev->disk, NULL);
 	/* see rbd_init_disk() */
 	blk_put_queue(rbd_dev->disk->queue);
 
-- 
2.16.4


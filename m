Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA6714EAC8
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2020 11:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgAaKiR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Jan 2020 05:38:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:55866 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728386AbgAaKiF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 05:38:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 16881B028;
        Fri, 31 Jan 2020 10:38:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, Daniel Disseldorp <ddiss@suse.com>,
        Jens Axboe <axboe@kernel.dk>, ceph-devel@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/15] rbd: switch to blk-mq
Date:   Fri, 31 Jan 2020 11:37:39 +0100
Message-Id: <20200131103739.136098-16-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200131103739.136098-1-hare@suse.de>
References: <20200131103739.136098-1-hare@suse.de>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Allocate one queue per CPU and get a performance boost from
higher parallelism.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index cc3e5116fe58..dc3b44177fea 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5094,7 +5094,7 @@ static int rbd_init_disk(struct rbd_device *rbd_dev)
 	rbd_dev->tag_set.queue_depth = rbd_dev->opts->queue_depth;
 	rbd_dev->tag_set.numa_node = NUMA_NO_NODE;
 	rbd_dev->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
-	rbd_dev->tag_set.nr_hw_queues = 1;
+	rbd_dev->tag_set.nr_hw_queues = num_present_cpus();
 	rbd_dev->tag_set.cmd_size = sizeof(struct rbd_img_request);
 
 	err = blk_mq_alloc_tag_set(&rbd_dev->tag_set);
-- 
2.16.4


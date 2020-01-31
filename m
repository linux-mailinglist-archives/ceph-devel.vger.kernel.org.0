Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA75814EACA
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2020 11:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbgAaKiE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Jan 2020 05:38:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:55782 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728325AbgAaKiD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 05:38:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 89986AF2D;
        Fri, 31 Jan 2020 10:38:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, Daniel Disseldorp <ddiss@suse.com>,
        Jens Axboe <axboe@kernel.dk>, ceph-devel@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/15] rbd: use READ_ONCE() when checking the mapping size
Date:   Fri, 31 Jan 2020 11:37:26 +0100
Message-Id: <20200131103739.136098-3-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200131103739.136098-1-hare@suse.de>
References: <20200131103739.136098-1-hare@suse.de>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The mapping size is changed only very infrequently, so we don't
need to take the header mutex for checking; using READ_ONCE()
is sufficient here. And it avoids having to take a mutex in the
hot path.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/rbd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index db80b964d8ea..792180548e89 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4788,13 +4788,13 @@ static void rbd_queue_workfn(struct work_struct *work)
 
 	blk_mq_start_request(rq);
 
-	down_read(&rbd_dev->header_rwsem);
-	mapping_size = rbd_dev->mapping.size;
+	mapping_size = READ_ONCE(rbd_dev->mapping.size);
 	if (op_type != OBJ_OP_READ) {
+		down_read(&rbd_dev->header_rwsem);
 		snapc = rbd_dev->header.snapc;
 		ceph_get_snap_context(snapc);
+		up_read(&rbd_dev->header_rwsem);
 	}
-	up_read(&rbd_dev->header_rwsem);
 
 	if (offset + length > mapping_size) {
 		rbd_warn(rbd_dev, "beyond EOD (%llu~%llu > %llu)", offset,
@@ -4981,9 +4981,9 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
 	u64 mapping_size;
 	int ret;
 
-	down_write(&rbd_dev->header_rwsem);
-	mapping_size = rbd_dev->mapping.size;
+	mapping_size = READ_ONCE(rbd_dev->mapping.size);
 
+	down_write(&rbd_dev->header_rwsem);
 	ret = rbd_dev_header_info(rbd_dev);
 	if (ret)
 		goto out;
@@ -4999,7 +4999,7 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
 	}
 
 	rbd_assert(!rbd_is_snap(rbd_dev));
-	rbd_dev->mapping.size = rbd_dev->header.image_size;
+	WRITE_ONCE(rbd_dev->mapping.size, rbd_dev->header.image_size);
 
 out:
 	up_write(&rbd_dev->header_rwsem);
-- 
2.16.4


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F21C015CB20
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 20:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgBMTZs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 14:25:48 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41379 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728460AbgBMTZr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Feb 2020 14:25:47 -0500
Received: by mail-wr1-f67.google.com with SMTP id c9so8125509wrw.8
        for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2020 11:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2HRkd5HdwNsGrBM1Iir3PFHXRsqwdBQsOnm/hEO+rGo=;
        b=gtdqLYgpP+eAKgJRERNiRWX/BIm3J80TyMQKhicVZx6frqtiHSY0BPuOGC6fZpXRs9
         INuZOZHIePqVFrR3uVgF7q04BaMo/UFxWicVUTFhqAtbhIeLjFgfOLZBsLmupg22l1Mq
         5uFLSRoKocOooPLuE32MKzK9WVNuUAiUnMERSVUSjWmQYm06OsqZ3USCxJ76GJGB3ejx
         9YdadjSTfTjQ9p/D4P1RUMrpP4tnZowxc5NBJIKK5IrKDV4Ag6gSavmqq7xtavBm6ZwN
         6SmItjUmFqFc2/mveZmqAz/HAEzz6Pkqltsz39FoBPDFglBsILsC4FxowZNLSEe73gBF
         tCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2HRkd5HdwNsGrBM1Iir3PFHXRsqwdBQsOnm/hEO+rGo=;
        b=OoDNeG4IPrld6LLOZkd7/4ZgTyg7uxO/GEDYlpSja5lmDn+QuXt96LZ1u2MTsdNnPi
         Wj9CiOmxrxy239LlYHKMNz6l6He6ffGJNbg2Py0y0Jpm/NSORFAVW6iJsZlwpHdKvP5N
         iQmeFMDiWv35m8MS63C9nFtY3ccmH2MbCQDwf8ybRC9gutt8TdPUxvk9TWDd8xYCo6xG
         JsXOUvM9HEoPrqs2GzgTLJqiOY/06eiOKfWYawXM0YbesNkQaBs7yqt9O7s/GtoLrSz/
         tu834vKpQ7+CmCxGsHxx/IdN2VZaNFWEIpzT5wats+2kbbbCORr/g6L2Op3SOVXjy/t5
         x/nA==
X-Gm-Message-State: APjAAAVoHjd+xh4UlwXi0sqHi2nfEfQYGK8ky8xi2HahGDVd3GaG8qJn
        NSl4wnAC9yXUTGFtxqPtKBAazsnZkVU=
X-Google-Smtp-Source: APXvYqy76K/bv7wGdz43tuii/bm5Clr7ERFbDCfqY9gy+VqQ7RePy7aSBJJy+FaG+REtMhZgL4aLgQ==
X-Received: by 2002:a5d:6802:: with SMTP id w2mr22839548wru.353.1581621945857;
        Thu, 13 Feb 2020 11:25:45 -0800 (PST)
Received: from kwango.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 21sm4326227wmo.8.2020.02.13.11.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 11:25:45 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/5] rbd: enable multiple blk-mq queues
Date:   Thu, 13 Feb 2020 20:26:06 +0100
Message-Id: <20200213192606.31194-6-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200213192606.31194-1-idryomov@gmail.com>
References: <20200213192606.31194-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Allocate one queue per CPU and get a performance boost from
higher parallelism.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 9ff4355fe48a..a4e7b494344c 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4970,7 +4970,7 @@ static int rbd_init_disk(struct rbd_device *rbd_dev)
 	rbd_dev->tag_set.queue_depth = rbd_dev->opts->queue_depth;
 	rbd_dev->tag_set.numa_node = NUMA_NO_NODE;
 	rbd_dev->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
-	rbd_dev->tag_set.nr_hw_queues = 1;
+	rbd_dev->tag_set.nr_hw_queues = num_present_cpus();
 	rbd_dev->tag_set.cmd_size = sizeof(struct rbd_img_request);
 
 	err = blk_mq_alloc_tag_set(&rbd_dev->tag_set);
-- 
2.19.2


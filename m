Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 870D948771
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 17:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbfFQPiD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 11:38:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728368AbfFQPiC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 11:38:02 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97E9221670;
        Mon, 17 Jun 2019 15:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560785882;
        bh=9zYSPCwH1COREnyQ9mwNLnIL8R0j/51AlLUcdGE7do8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2qnYl6DM0MSl0qED8eDYwl4nrdajBYdRAPLfXd/CEjalVISKLfZYJfYytsnNOXfPi
         N2w6IrY2J7iI3dOwkj/2PBKNQcX65UR7NbNX68IxO4I2YHJ84cOBIgrpMZpucvyrw3
         +/Zu58lwwwqlscZz8Ustv12TI9qH//AbkRwwFwNw=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Subject: [PATCH v2 08/18] ceph: fix decode_locker to use ceph_decode_entity_addr
Date:   Mon, 17 Jun 2019 11:37:43 -0400
Message-Id: <20190617153753.3611-9-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617153753.3611-1-jlayton@kernel.org>
References: <20190617153753.3611-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/ceph/cls_lock_client.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ceph/cls_lock_client.c b/net/ceph/cls_lock_client.c
index 4cc28541281b..b1d12bf4b83e 100644
--- a/net/ceph/cls_lock_client.c
+++ b/net/ceph/cls_lock_client.c
@@ -264,8 +264,11 @@ static int decode_locker(void **p, void *end, struct ceph_locker *locker)
 		return ret;
 
 	*p += sizeof(struct ceph_timespec); /* skip expiration */
-	ceph_decode_copy(p, &locker->info.addr, sizeof(locker->info.addr));
-	ceph_decode_addr(&locker->info.addr);
+
+	ret = ceph_decode_entity_addr(p, end, &locker->info.addr);
+	if (ret)
+		return ret;
+
 	len = ceph_decode_32(p);
 	*p += len; /* skip description */
 
-- 
2.21.0


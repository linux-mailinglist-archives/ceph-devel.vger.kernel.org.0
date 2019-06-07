Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6857238F3D
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 17:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbfFGPi1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jun 2019 11:38:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729992AbfFGPi0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 11:38:26 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBCB0214C6;
        Fri,  7 Jun 2019 15:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559921905;
        bh=9zYSPCwH1COREnyQ9mwNLnIL8R0j/51AlLUcdGE7do8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dtr5d8bMYZ1vqilNJJM8l2iCA6beTRKyIOGYYKHJyK0EYGWsk+rR1VjN3rwzyke4T
         btGc0PaaVA1jc2rutnDbOfBxz28htdmHTnKWTO2/x8T0hXPI3zjQNrRRH64dEI/5Iq
         SdzQl6etSX6ywiZNVSDTcg0+6JGirF/BP4XiwQMU=
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Cc:     ceph-devel@vger.kernel.org, dev@ceph.io
Subject: [PATCH 08/16] ceph: fix decode_locker to use ceph_decode_entity_addr
Date:   Fri,  7 Jun 2019 11:38:08 -0400
Message-Id: <20190607153816.12918-9-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153816.12918-1-jlayton@kernel.org>
References: <20190607153816.12918-1-jlayton@kernel.org>
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


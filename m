Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEFB438F44
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 17:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbfFGPiX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jun 2019 11:38:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729868AbfFGPiW (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 11:38:22 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 648802147A;
        Fri,  7 Jun 2019 15:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559921902;
        bh=mYFbO6z0xwV6my6cGOyFNrN4RWuepkjibLLeJYv4iZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQkDFX1a15Y00Q8essrXE3lqQ7WYvb/BntI/HWuQOoirYDyimAfcjCH38mvUPs5Dw
         fTdzWDDZBh1EJ1Q6f8rw4LCaAPXGB3sgTDzZTxM9WdtxGf0Ggb5s7XVV5NBUeP/f8s
         U/JJIjeW6B+sRf1xwg6X9bqhkkmkFfkdRnVMCJL8=
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Cc:     ceph-devel@vger.kernel.org, dev@ceph.io
Subject: [PATCH 04/16] libceph: switch osdmap decoding to use ceph_decode_entity_addr
Date:   Fri,  7 Jun 2019 11:38:04 -0400
Message-Id: <20190607153816.12918-5-jlayton@kernel.org>
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
 net/ceph/osdmap.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 48a31dc9161c..95e98ae59a54 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1489,11 +1489,9 @@ static int osdmap_decode(void **p, void *end, struct ceph_osdmap *map)
 
 	/* osd_state, osd_weight, osd_addrs->client_addr */
 	ceph_decode_need(p, end, 3*sizeof(u32) +
-			 map->max_osd*((struct_v >= 5 ? sizeof(u32) :
-							sizeof(u8)) +
-				       sizeof(*map->osd_weight) +
-				       sizeof(*map->osd_addr)), e_inval);
-
+			 map->max_osd*(struct_v >= 5 ? sizeof(u32) :
+						       sizeof(u8)) +
+				       sizeof(*map->osd_weight), e_inval);
 	if (ceph_decode_32(p) != map->max_osd)
 		goto e_inval;
 
@@ -1514,9 +1512,11 @@ static int osdmap_decode(void **p, void *end, struct ceph_osdmap *map)
 	if (ceph_decode_32(p) != map->max_osd)
 		goto e_inval;
 
-	ceph_decode_copy(p, map->osd_addr, map->max_osd*sizeof(*map->osd_addr));
-	for (i = 0; i < map->max_osd; i++)
-		ceph_decode_addr(&map->osd_addr[i]);
+	for (i = 0; i < map->max_osd; i++) {
+		err = ceph_decode_entity_addr(p, end, &map->osd_addr[i]);
+		if (err)
+			goto bad;
+	}
 
 	/* pg_temp */
 	err = decode_pg_temp(p, end, map);
-- 
2.21.0


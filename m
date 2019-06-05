Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40D0D35D90
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2019 15:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbfFENLK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 09:11:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728009AbfFENLJ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 09:11:09 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39E182089E;
        Wed,  5 Jun 2019 13:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559740268;
        bh=r6OZ5ULp+6V4Rtq5MkU/csIINVDLzaMk0vdOMTcVwU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7NlxjyDvNm18wXDJc/RHmLztwdBaHyzfG4H5bkHc0gON0nDcq6IMZBiSatYf74VK
         vaYJ1/UW9yajMjDBGWQLr5I6C6DA9XiNGXf+jSi0mN+7wC4zaJewARuHCQbbqmnsnX
         Ss+o+LTp4ECclv/DHn+VFxeov5VDeNpJzx2+FvNI=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Subject: [RFC PATCH 6/9] libceph: correctly decode ADDR2 addresses in incremental OSD maps
Date:   Wed,  5 Jun 2019 09:10:59 -0400
Message-Id: <20190605131102.13529-7-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605131102.13529-1-jlayton@kernel.org>
References: <20190605131102.13529-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Given the new format, we have to decode the addresses twice. Once to
skip past the new_up_client field, and a second time to collect the
addresses.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/ceph/osdmap.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 95e98ae59a54..90437906b7bc 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1618,12 +1618,17 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
 	void *new_state;
 	void *new_weight_end;
 	u32 len;
+	int i;
 
 	new_up_client = *p;
 	ceph_decode_32_safe(p, end, len, e_inval);
-	len *= sizeof(u32) + sizeof(struct ceph_entity_addr);
-	ceph_decode_need(p, end, len, e_inval);
-	*p += len;
+	for (i = 0; i < len; ++i) {
+		struct ceph_entity_addr addr;
+
+		ceph_decode_skip_32(p, end, e_inval);
+		if (ceph_decode_entity_addr(p, end, &addr))
+			goto e_inval;
+	}
 
 	new_state = *p;
 	ceph_decode_32_safe(p, end, len, e_inval);
@@ -1699,9 +1704,9 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
 		struct ceph_entity_addr addr;
 
 		osd = ceph_decode_32(p);
-		ceph_decode_copy(p, &addr, sizeof(addr));
-		ceph_decode_addr(&addr);
 		BUG_ON(osd >= map->max_osd);
+		if (ceph_decode_entity_addr(p, end, &addr))
+			goto e_inval;
 		pr_info("osd%d up\n", osd);
 		map->osd_state[osd] |= CEPH_OSD_EXISTS | CEPH_OSD_UP;
 		map->osd_addr[osd] = addr;
-- 
2.21.0


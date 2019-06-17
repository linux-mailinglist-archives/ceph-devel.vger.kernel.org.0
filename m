Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8736A4876F
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 17:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbfFQPiC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 11:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728269AbfFQPiA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 11:38:00 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45D0021530;
        Mon, 17 Jun 2019 15:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560785879;
        bh=VyMGwNHbNW332OuFcFpZGqUXUtoxNFAGNBioKLMK8Mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tv5q7Bb8RHmst0r9od6cKO87zQG2+4ZCLq0W0q0Q1hGAqycObRJPoaAfXW+uXWgNY
         lKUcfhIP6jXxINXr4IS7aNDiLCCswV9Dfjz3WBCLa770Of3/UNtuJAPjvugdrTKxTX
         H1QEXP7cyJGJ+jNH3aIOz6mb0rrNWTiAV42t9uvw=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Subject: [PATCH v2 05/18] libceph: fix watch_item_t decoding to use ceph_decode_entity_addr
Date:   Mon, 17 Jun 2019 11:37:40 -0400
Message-Id: <20190617153753.3611-6-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617153753.3611-1-jlayton@kernel.org>
References: <20190617153753.3611-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

While we're in there, let's also fix up the decoder to do proper
bounds checking.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/ceph/osd_client.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index e6d31e0f0289..f8a4d29ef688 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -4914,20 +4914,26 @@ static int decode_watcher(void **p, void *end, struct ceph_watch_item *item)
 	ret = ceph_start_decoding(p, end, 2, "watch_item_t",
 				  &struct_v, &struct_len);
 	if (ret)
-		return ret;
+		goto bad;
+
+	ret = -EINVAL;
+	ceph_decode_copy_safe(p, end, &item->name, sizeof(item->name), bad);
+	ceph_decode_64_safe(p, end, item->cookie, bad);
+	ceph_decode_skip_32(p, end, bad); /* skip timeout seconds */
 
-	ceph_decode_copy(p, &item->name, sizeof(item->name));
-	item->cookie = ceph_decode_64(p);
-	*p += 4; /* skip timeout_seconds */
 	if (struct_v >= 2) {
-		ceph_decode_copy(p, &item->addr, sizeof(item->addr));
-		ceph_decode_addr(&item->addr);
+		ret = ceph_decode_entity_addr(p, end, &item->addr);
+		if (ret)
+			goto bad;
+	} else {
+		ret = 0;
 	}
 
 	dout("%s %s%llu cookie %llu addr %s\n", __func__,
 	     ENTITY_NAME(item->name), item->cookie,
 	     ceph_pr_addr(&item->addr));
-	return 0;
+bad:
+	return ret;
 }
 
 static int decode_watchers(void **p, void *end,
-- 
2.21.0


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1627238F48
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 17:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730035AbfFGPil (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jun 2019 11:38:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729938AbfFGPiX (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 11:38:23 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44CF1214AE;
        Fri,  7 Jun 2019 15:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559921902;
        bh=VyMGwNHbNW332OuFcFpZGqUXUtoxNFAGNBioKLMK8Mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mh9EQNKRR8V1R27k7KJP75VcUDwxsUxOUbohqfhkMJvozcC3NqkqdJBH3kkerlALs
         F+mLwb0JfVqWCgCC3CnjCgcVdSKOow1xZrcQcdV55CVK5wkCzzwwByQfRSrGq0VLvm
         bBW5xSRUVAeFsTPbmHzRMUC6BFSkbCCJz4FrXDn4=
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Cc:     ceph-devel@vger.kernel.org, dev@ceph.io
Subject: [PATCH 05/16] libceph: fix watch_item_t decoding to use ceph_decode_entity_addr
Date:   Fri,  7 Jun 2019 11:38:05 -0400
Message-Id: <20190607153816.12918-6-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153816.12918-1-jlayton@kernel.org>
References: <20190607153816.12918-1-jlayton@kernel.org>
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


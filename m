Return-Path: <ceph-devel+bounces-3486-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 415F4B39C4C
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Aug 2025 14:09:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D607986FCA
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Aug 2025 12:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87E3E30F95C;
	Thu, 28 Aug 2025 12:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Gr8R7XHl"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5D730F801
	for <ceph-devel@vger.kernel.org>; Thu, 28 Aug 2025 12:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756382904; cv=none; b=f/tMNYLrHvzl0LICXnkJ55Eeo0BVtLCGiVxp9XfHrGcx3yUN6oKAozqKn4BLR0SpwE2anmf5fpi7iVRR6MmXKxAPC6fmZ8gnI2Nux0T3/i5SfgqHHgr0m5YPeFd2kCRcqmuQZnRLsYDuje0ircWWi35Tc6zLxGhSSGRuv/n2pMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756382904; c=relaxed/simple;
	bh=dvFy0GvyED3/N0rdK6Pd8G6BU5DSoCUAM+z9gA8HfzM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fsnE6JhVYbRpO/+SAYslxnTBVZjK2b+ywOazDieCWsy8KMVs9dEqejNjrirnMxGeII5+7ECYx/rZRANuRqsRzW5sDNUkECiQWRoHf0scdLNbP9AU+snLYmiH+moIjI2EyCRBwkwM3gG1rF4DxOLmWXbBAgfuLpCdC6U078x/XEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Gr8R7XHl; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45a20c51c40so7025565e9.3
        for <ceph-devel@vger.kernel.org>; Thu, 28 Aug 2025 05:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756382900; x=1756987700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1KGYCo47M8HnSkDcYvSaLWw6pGEaggMof1VkMNBF1tM=;
        b=Gr8R7XHlAScTlK7jkBoRJGCb2ztYSNVONoneSBIMa9uc+oFMhLn/RwiMd99VPvK6Hs
         WaZta+CZbnWtArlHZuWZYYZU8sRejKHgNNFAIJ50O+3GGoH7J0xYq9zIma2MYSviq/GW
         9M3UQbuyOQzMM3aXCStBcbwZAkxQg47VVJBk5OT8UWHV9SChWQH3BcqsDqzpx6WStIN3
         0ornb2bOrgGk9NCAsf/2bxwo4gzOieMPvDe4+6Nb2+RrzG/M6QYQiGbE8LcLph3WFjrx
         8TETr9Xb9iNQQzd6bf2nSDDJ+absI5Usw4J0xaFQKbSxskNgcp5/8dT+hs7OC8qzPBPD
         fz9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756382900; x=1756987700;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1KGYCo47M8HnSkDcYvSaLWw6pGEaggMof1VkMNBF1tM=;
        b=ocxvVAwIhJUPYp34Bf6tPYQ4RMIxSEU7XurW5Oycpx1PStibIKkGCouObm+cnPmkWm
         uFt1KhxrhqITarppIljT00YBTsFtoUcOCQMwQUxvo31m97xohhwJ+zPT4Y76pzjYNLsC
         z+vPIOAWn4xzT4fqZR6aVRCyMUTzhpqn4RuwSAwfI35bHZB+Cmy9VdjHhcPkeHcKje4t
         4nQmt7UJ32kxdEQaw1YZhs3YXN0LprpmeR30ZJHInMJNrryty7IrYbLndDtEJ7s/VIoV
         Y20PSu4F8Y9v4L+LFWPU+ffoYn1BaV/7xO9QvUj1ebcxRBbnb6C0PG4NyvEoh0/r3UC5
         Oyrw==
X-Forwarded-Encrypted: i=1; AJvYcCXnxklHdZhSyCBjbN1Xuv53QEsD7p1F1jLs89jS28K2Oqehl3LfrW7Nivat0KTpryMmEmDzYf9J1WJM@vger.kernel.org
X-Gm-Message-State: AOJu0Ywq21doQEdogRMXiRCrfKIqnrjFCDL377KqLKGmXjcPq2tVj/oI
	uxgBNs2dwLHl5wSXtQSwSkH48HczupYVuLYSGgrS1RphkBg/27oQTOWb0/bsekWPdGE=
X-Gm-Gg: ASbGncsmSvXUkk8FU4PNLJV64tTAOJ4SXSP1R9oLcCpZ+x1cXm+VrPq8tQIh+UUTyyB
	bEdTZx0FMJjGTqMBZ5c61poFAy7g9ihNglnJMk6cgCkWVvrJE7EggzQdZ+J8779UgmF+rONHBuX
	qrfoI9fratnZG2+W0uc2uJAOLybsZsvtoGnlxMqDiOxBtcvcGhdqgBghHiOBM6sOHlNBJ2Uxx30
	0ZLozCXD7IysapgA5VgABONz0hW/PtqWyvhormErdas7yRLCgSv67bU23ILutICDaACDo9MWFAO
	aK8Wc4HjQm1C4PGlhUpkt1mWVjKB3tMZJ67TJK0mpallFnGhg+bvHkEowJX4+BIOfpM79iMuLYh
	9+5s/Ekf2Eno6oxlxygWUV6klQP4zHzOlkNeBSlyhOxNAjO+bcWCjJmVMnZ7mYEPXXIWXHS6pnS
	9iPPWjE9nAIrE4irpDU+Y83g==
X-Google-Smtp-Source: AGHT+IECbDtWH0zZDMSKQZOU5aAbQreBTJQRG/QRaYxDFV+HkzE+dMQ4ECYxCUIikuFUOY4MkAjhIA==
X-Received: by 2002:a05:600c:1d10:b0:458:b01c:8f with SMTP id 5b1f17b1804b1-45b51798f30mr224386925e9.8.1756382898974;
        Thu, 28 Aug 2025 05:08:18 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b797e5cd5sm30382385e9.22.2025.08.28.05.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 05:08:18 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: Slava.Dubeyko@ibm.com,
	xiubli@redhat.com,
	idryomov@gmail.com,
	amarkuze@redhat.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v2] fs/ceph/addr: convert `op_idx`, `data_pages` back to a local variables
Date: Thu, 28 Aug 2025 14:08:16 +0200
Message-ID: <20250828120816.752278-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These were local variables until commit f08068df4aa4 ("ceph: extend
ceph_writeback_ctl for ceph_writepages_start() refactoring"), but were
moved to the struct ceph_writeback_ctl for no obvious reason.  Having
these in a struct means overhead, so let's move them back.

For the "allocate new pages array for next request" code block,
however I decided to introduce a new local variable `old_pages`
instead, because reusing `data_pages` for reallocation seemed
confusing to me.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
v1 -> v2: now really removed "op_idx" from the struct (d'oh)
---
 fs/ceph/addr.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 8b202d789e93..88dea8887ef7 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -601,7 +601,6 @@ struct ceph_writeback_ctl
 	unsigned int max_pages;
 	unsigned int locked_pages;
 
-	int op_idx;
 	int num_ops;
 	u64 offset;
 	u64 len;
@@ -611,7 +610,6 @@ struct ceph_writeback_ctl
 
 	bool from_pool;
 	struct page **pages;
-	struct page **data_pages;
 };
 
 /*
@@ -1051,7 +1049,6 @@ void ceph_init_writeback_ctl(struct address_space *mapping,
 		ceph_wbc->tag = PAGECACHE_TAG_DIRTY;
 	}
 
-	ceph_wbc->op_idx = -1;
 	ceph_wbc->num_ops = 0;
 	ceph_wbc->offset = 0;
 	ceph_wbc->len = 0;
@@ -1060,7 +1057,6 @@ void ceph_init_writeback_ctl(struct address_space *mapping,
 	ceph_folio_batch_init(ceph_wbc);
 
 	ceph_wbc->pages = NULL;
-	ceph_wbc->data_pages = NULL;
 }
 
 static inline
@@ -1417,10 +1413,12 @@ int ceph_submit_write(struct address_space *mapping,
 	struct ceph_vino vino = ceph_vino(inode);
 	struct ceph_osd_request *req = NULL;
 	struct page *page = NULL;
+	struct page **data_pages;
 	bool caching = ceph_is_cache_enabled(inode);
 	u64 offset;
 	u64 len;
 	unsigned i;
+	int op_idx;
 
 new_request:
 	offset = ceph_fscrypt_page_offset(ceph_wbc->pages[0]);
@@ -1481,8 +1479,8 @@ int ceph_submit_write(struct address_space *mapping,
 
 	/* Format the osd request message and submit the write */
 	len = 0;
-	ceph_wbc->data_pages = ceph_wbc->pages;
-	ceph_wbc->op_idx = 0;
+	data_pages = ceph_wbc->pages;
+	op_idx = 0;
 	for (i = 0; i < ceph_wbc->locked_pages; i++) {
 		u64 cur_offset;
 
@@ -1495,29 +1493,29 @@ int ceph_submit_write(struct address_space *mapping,
 		 */
 		if (offset + len != cur_offset) {
 			/* If it's full, stop here */
-			if (ceph_wbc->op_idx + 1 == req->r_num_ops)
+			if (op_idx + 1 == req->r_num_ops)
 				break;
 
 			/* Kick off an fscache write with what we have so far. */
 			ceph_fscache_write_to_cache(inode, offset, len, caching);
 
 			/* Start a new extent */
-			osd_req_op_extent_dup_last(req, ceph_wbc->op_idx,
+			osd_req_op_extent_dup_last(req, op_idx,
 						   cur_offset - offset);
 
 			doutc(cl, "got pages at %llu~%llu\n", offset, len);
 
-			osd_req_op_extent_osd_data_pages(req, ceph_wbc->op_idx,
-							 ceph_wbc->data_pages,
+			osd_req_op_extent_osd_data_pages(req, op_idx,
+							 data_pages,
 							 len, 0,
 							 ceph_wbc->from_pool,
 							 false);
-			osd_req_op_extent_update(req, ceph_wbc->op_idx, len);
+			osd_req_op_extent_update(req, op_idx, len);
 
 			len = 0;
 			offset = cur_offset;
-			ceph_wbc->data_pages = ceph_wbc->pages + i;
-			ceph_wbc->op_idx++;
+			data_pages = ceph_wbc->pages + i;
+			op_idx++;
 		}
 
 		set_page_writeback(page);
@@ -1555,25 +1553,27 @@ int ceph_submit_write(struct address_space *mapping,
 			offset, len);
 	}
 
-	osd_req_op_extent_osd_data_pages(req, ceph_wbc->op_idx,
-					 ceph_wbc->data_pages, len,
+	osd_req_op_extent_osd_data_pages(req, op_idx,
+					 data_pages, len,
 					 0, ceph_wbc->from_pool, false);
-	osd_req_op_extent_update(req, ceph_wbc->op_idx, len);
+	osd_req_op_extent_update(req, op_idx, len);
 
-	BUG_ON(ceph_wbc->op_idx + 1 != req->r_num_ops);
+	BUG_ON(op_idx + 1 != req->r_num_ops);
 
 	ceph_wbc->from_pool = false;
 	if (i < ceph_wbc->locked_pages) {
+		struct page **old_pages;
+
 		BUG_ON(ceph_wbc->num_ops <= req->r_num_ops);
 		ceph_wbc->num_ops -= req->r_num_ops;
 		ceph_wbc->locked_pages -= i;
 
 		/* allocate new pages array for next request */
-		ceph_wbc->data_pages = ceph_wbc->pages;
+		old_pages = ceph_wbc->pages;
 		__ceph_allocate_page_array(ceph_wbc, ceph_wbc->locked_pages);
-		memcpy(ceph_wbc->pages, ceph_wbc->data_pages + i,
+		memcpy(ceph_wbc->pages, old_pages + i,
 			ceph_wbc->locked_pages * sizeof(*ceph_wbc->pages));
-		memset(ceph_wbc->data_pages + i, 0,
+		memset(old_pages + i, 0,
 			ceph_wbc->locked_pages * sizeof(*ceph_wbc->pages));
 	} else {
 		BUG_ON(ceph_wbc->num_ops != req->r_num_ops);
-- 
2.47.2



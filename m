Return-Path: <ceph-devel+bounces-3485-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2645B39C2F
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Aug 2025 14:06:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D7DE17B0035
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Aug 2025 12:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE59D30F949;
	Thu, 28 Aug 2025 12:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="JlW4VNX6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0A830F818
	for <ceph-devel@vger.kernel.org>; Thu, 28 Aug 2025 12:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756382703; cv=none; b=nGmNIzqbbNZVDBmj6fvwLckXpYUb45buJSTyuT4hqJZz+FTMNqc7wu+8gSsDYqAfP2YqupAFMz6JEE0DqGSDXeJBkzkEtuZpXoPEXYovKp4a1OQbYPdkcwEYR1QsSLQXRLql/VJJf5cKut4toebzGyZavg9ID5quIVEi33kwdMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756382703; c=relaxed/simple;
	bh=LbO1QOgysbdLndSSd76TuWypzxpCmVsAoAlB9MGwu3U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UZ6MqiyDkiwgUyIbGAlTw1mY+Xc/ksCnKAsdFHg/uE7vJnWOfHgGMAuUdZvvfR2FkU43Kj1UoR2DIgQ3AnOd47afZMkr6v4xV9gyMT6qJx2urF91L9Nz+tRhECO8jTxSBZ9th4aV6lKti7qAkGLaEX/8NpeoV47FQsuZAZwk60g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=JlW4VNX6; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3c7ba0f6983so589115f8f.0
        for <ceph-devel@vger.kernel.org>; Thu, 28 Aug 2025 05:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756382699; x=1756987499; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+BOPqGhZLfbIfYuD0MGvXzD0+z188+PonWYLkcs9RNE=;
        b=JlW4VNX6BdqYWS9szkD275BDdXumBiLaRT1RFXj+sRqpD1k5UwVH1LuZvisO1oJp5f
         mFa2YKdBVoP0GaXkrE/kKjKdQYWwjncGfQXPfsqo7IqOhXZF/1tm0ctQw+DkT1W2h+H7
         eE65Qq9Ha8y47q4eWJS0/mM0PuIezOjImV8YL/Xxywyp/gYtbXz8yGFo2qPRdrYUdJ7c
         GmYKZrUnGVEnJSVtdsPtAGT5kkEr9fIQ8QBZeBJ3CgJe2gMKN1O/eqr3vekcboG0HAuh
         6Rq0nfcohKrdlKzVv40HSvg+UGCIAbnhYz0ov703+Pe2nt1gT6waLzhDz/RSdhW1rd51
         eNCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756382699; x=1756987499;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+BOPqGhZLfbIfYuD0MGvXzD0+z188+PonWYLkcs9RNE=;
        b=xUgbK4Na4M5hPz3LmL2XlXE6N5wVsXSHdXGgGG8TWjqyY8TWy0FkCHrJGZ65dWeBV4
         djT07zB5zk9AAV4LqYeZEYuVnH25FjVu+bX3fZWELZAY+vTqdCv3OjHhbMlD/ziSarZX
         XaeBDCCThHtVx+09gnKYe+xxx50qlZJmFH59kmrbqdAuzQkuwteq01va7oNSdImwqB0E
         4vQL+Y5fK6IyybMeQJb+FZ1FHOScm/wsu9xJKSc21/f3QkjG+gyNJJK0VoKVz4P3wCI/
         Tm13q2KHYDmbDYbvaHekHrwDMldd7R7/afcgimlGtCMNKrwWJHnqznZaze4rM8RyxOpB
         l85g==
X-Forwarded-Encrypted: i=1; AJvYcCWzIBSmbx6nw/j7GQYwr/rMit5jVZ9ugn5kLefPHxEAMIbhPcSBiZ8Qu1zlEBUS9J8Qjtc8cB0vQab6@vger.kernel.org
X-Gm-Message-State: AOJu0YytoiO8/DipKArDJYiJ94cKYrLdkZRJGIfBAgJVsxpWixcjWOfN
	OTOfM5ovZh4AenoE0je2FfFe4oHz3fZo6WXcEnSufOEWAEz+K/SsMUGIxL/W1mejvCg=
X-Gm-Gg: ASbGncsS9ixc+26tPul9KCkaOj8tvRS/wxzEokel7NvNbc4OOMdtzVwFmoQBkxU1gnb
	1ZHwBZE4PtfrXLJJXXJ+/6tmNGJ0YUhZCx8kfiW4h0SrKxD7IAo/9fGwiMf976p+5J3sZ0/QSGP
	w6GDDdP31NeVOaN7usHak8glGGqAOcMukrV7XCtNEkMQ+0GWoTy3pZSzOYrils0O87t0t1qDJyj
	J0d0Pc5UuIcpuagHXrA0eHxu+WQ4GqDOab1xlPhzvnzprUukUS/rfFeO7dj4cCpSKUMnbnrj7l/
	0SqtubfP3n74VgA174gjr6YYBZ70iQLuqI6WtaWAZoLoRbZGN5iFQDUe+3sfQHy4pzbv7uuwM27
	0SwhB/Y8h//zguyHLczPJVkIY4orlrwZ1NRQ/3JrM7YyaciWOnEjLyG0zOMUYugDq/EGJBuJzv4
	q5rPbmJMINBJN7ggf/hkNRsA==
X-Google-Smtp-Source: AGHT+IGzoTsypgvoIpQsTCGny5L+jcRoWYZSRf2lTXtYqJtN0aGMGTRo6Dqju9vXNW8/IdhIYpWfbg==
X-Received: by 2002:a5d:4f89:0:b0:3ce:5696:39f1 with SMTP id ffacd0b85a97d-3ce56963e87mr831053f8f.22.1756382699180;
        Thu, 28 Aug 2025 05:04:59 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b797e5cd5sm30266815e9.22.2025.08.28.05.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 05:04:57 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: Slava.Dubeyko@ibm.com,
	xiubli@redhat.com,
	idryomov@gmail.com,
	amarkuze@redhat.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH] fs/ceph/addr: convert `op_idx`, `data_pages` back to a local variables
Date: Thu, 28 Aug 2025 14:04:53 +0200
Message-ID: <20250828120453.748058-1-max.kellermann@ionos.com>
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
 fs/ceph/addr.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 8b202d789e93..fc3192c79072 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -611,7 +611,6 @@ struct ceph_writeback_ctl
 
 	bool from_pool;
 	struct page **pages;
-	struct page **data_pages;
 };
 
 /*
@@ -1051,7 +1050,6 @@ void ceph_init_writeback_ctl(struct address_space *mapping,
 		ceph_wbc->tag = PAGECACHE_TAG_DIRTY;
 	}
 
-	ceph_wbc->op_idx = -1;
 	ceph_wbc->num_ops = 0;
 	ceph_wbc->offset = 0;
 	ceph_wbc->len = 0;
@@ -1060,7 +1058,6 @@ void ceph_init_writeback_ctl(struct address_space *mapping,
 	ceph_folio_batch_init(ceph_wbc);
 
 	ceph_wbc->pages = NULL;
-	ceph_wbc->data_pages = NULL;
 }
 
 static inline
@@ -1417,10 +1414,12 @@ int ceph_submit_write(struct address_space *mapping,
 	struct ceph_vino vino = ceph_vino(inode);
 	struct ceph_osd_request *req = NULL;
 	struct page *page = NULL;
+	struct page **data_pages;
 	bool caching = ceph_is_cache_enabled(inode);
 	u64 offset;
 	u64 len;
 	unsigned i;
+	unsigned op_idx;
 
 new_request:
 	offset = ceph_fscrypt_page_offset(ceph_wbc->pages[0]);
@@ -1481,8 +1480,8 @@ int ceph_submit_write(struct address_space *mapping,
 
 	/* Format the osd request message and submit the write */
 	len = 0;
-	ceph_wbc->data_pages = ceph_wbc->pages;
-	ceph_wbc->op_idx = 0;
+	data_pages = ceph_wbc->pages;
+	op_idx = 0;
 	for (i = 0; i < ceph_wbc->locked_pages; i++) {
 		u64 cur_offset;
 
@@ -1495,29 +1494,29 @@ int ceph_submit_write(struct address_space *mapping,
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
@@ -1555,25 +1554,27 @@ int ceph_submit_write(struct address_space *mapping,
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



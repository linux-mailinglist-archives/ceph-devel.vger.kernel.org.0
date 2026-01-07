Return-Path: <ceph-devel+bounces-4295-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C1C51D0017D
	for <lists+ceph-devel@lfdr.de>; Wed, 07 Jan 2026 22:06:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0E810304EF4B
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jan 2026 21:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 490992D73B9;
	Wed,  7 Jan 2026 21:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dWVABuWR"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D694B2D97BA
	for <ceph-devel@vger.kernel.org>; Wed,  7 Jan 2026 21:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767819736; cv=none; b=WOvDx7QhnyAaQuifXY0kxFHToPgk+wV/i/tRhtWQepq7a7o9ycvNhxO8dV4FI18uQuBdnSGj4fanXgFFW7mCwDd64AKDvJZpCnSUAisDeKWv1icYxzwFFeAyJGkW5c4Upm0bS0JB/z/wY7nLG3x8h584PRWs1VNfUPBUfDuoYlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767819736; c=relaxed/simple;
	bh=M+v5Vw0Jil/rA486zu+DiAOWZxQZQJUjs4l0t3TZ4tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLs9axmLheVX1ZbPcn9NXdgVg/ZtWApa4S1ML6KUeOp1vHx2pnGhxrkrijtlhRVetxa2lCNCro7DuU/em5mL2KqH7GjgbRmE6OINze6ZbWr/RMfYurrOGRJVF+UV9f9ux0lqwhFYWmUOHbvRYX5do0jS5IkAWX0CU9+a/SCFPOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dWVABuWR; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2b04a410f42so1805791eec.0
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jan 2026 13:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767819734; x=1768424534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0iYD+ioNTt6TfLHqUAr1a4Xg5XGaJpAZluY0IKqvlcs=;
        b=dWVABuWR+7O63Lh8EcYuo/R1NAj/wPU8/8jK03w9z4XHU0tXWlWvBgfW3eIXfAJwwi
         6Fzqvifj4oqYmYdoSUXwH9nARwY3kX9oK+bQ++OqoG4zSI4OUjRKRcmQee4c5l7g1JPC
         h5K8e0wBOmUL6deZpS0Sf+Oh3gw7r/iEj9+ONDzaDEKxRT5HzhWVtHapaW9TMgc0w9t5
         U+qZF6KN2GeJDr2bitwh7ytEdQlFxhMFMglHnMn+AUDUbbtdHOlhdNIGGempgG4fEmfz
         lXQFipsdmCD3ZTQ4abntp/K8E0bAIJZjFzyHCXIsr2bS6UJUf2M3bs2d2hdldDIKER+p
         W/oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767819734; x=1768424534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0iYD+ioNTt6TfLHqUAr1a4Xg5XGaJpAZluY0IKqvlcs=;
        b=qwazaLS48fblChi9POGZoNsDSsLqRBAXURnWxrQ98PHp8pc6mLgYMHqrG3SruYYAgx
         D1PBMcCbJIvbhPaj8gWTQ55k+urOplmZFnX7S3LfeI7SExvCN2sDXSKKqbtBDYQ720BP
         VBiZKJuoRiKDTGViUwYXQEDvAj+QI5kzk8y9iUq8fDThAwHpro2ptkVn2qkUkMVKEq6l
         l4lGHo3F5EqZKIg7dbVYacHkB4kZBcacEtkJYuQSXHr8uEjraphhh7h95pQOy4ngPF+n
         AId9WiylhE3qGyznNbRuKe3m3ts5snmIAQi0XFUuISW0rWhGtEkUYQSIx1CuWaeSs6HS
         RkZw==
X-Forwarded-Encrypted: i=1; AJvYcCU8Xekl8B9pUcuaMtV/dRO+XmkANcNOaI+c5pnmuAoP6Jxr45ad91cyohfglICY9IndIm+IQrf0QBje@vger.kernel.org
X-Gm-Message-State: AOJu0YxpTUD/Vo7YcFUhao6y2JLSh+qt2ZmnZEdlB1+0NDWUIILAaVvW
	KjbUxo3+37b2nlpakwMsXBKwZOkFJMJZEC5tqniqPYNIpFLX6vV2DRN5
X-Gm-Gg: AY/fxX6vdj99sIiQX/5BXEUNx6sOtBlJmUKFqdyDj5GiyyI8xn8VlaELFyGheuad3qi
	e7G3yH09Jb1KZb2mwvO5JabvUP8PQ/V9fFg6eA3ZamDipKPGXM0sJ/VJkIir8Ecn6S7LwudOESi
	5UQeLRDz4mng/kcMVEW3W86mpvjBuHJvvJ07NfSNa3EHtPriOE4Hih5koaMyxeRB8uG6NZKsF+Y
	/lhXC6DtZXUThSJ5awZr4HFQCPoWO/T6mL/f9GTS/FeUZU0d3WzVDeOWWxa1hsXyFKUnLzuckyV
	KzfgjcP5TEoPxnP6+U6Vid3Hvop/fMshmKdUcrraxO7k15H1LXoCps8JoxqM9hHrGoWTWqAApdi
	F46+JVdv6V/7GX65w1K2P8MkQvunvLtz0OZioRcmBNcXaDYdiIRL6pUHYZUSNpHMkrx+hZTA9zR
	EW2DDbzZD0FAjBtG+uxfwabYav29YKjZ8qKNcrIotIds+kOEvVrp0xPXOp2nlI
X-Google-Smtp-Source: AGHT+IERp97W8qGccAbwxhXAxSLBpLHQVl7RhoNKnrA6Fsbg0/9438GYXF8rBuCdpX/av5RsA8yPMA==
X-Received: by 2002:a05:7300:2d15:b0:2b0:5bce:2f44 with SMTP id 5a478bee46e88-2b17d25199amr2080567eec.10.1767819733776;
        Wed, 07 Jan 2026 13:02:13 -0800 (PST)
Received: from celestia.turtle.lan (static-23-234-115-121.cust.tzulo.com. [23.234.115.121])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b170673b2esm7730320eec.6.2026.01.07.13.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 13:02:13 -0800 (PST)
From: Sam Edwards <cfsworks@gmail.com>
X-Google-Original-From: Sam Edwards <CFSworks@gmail.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	Milind Changire <mchangir@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sam Edwards <CFSworks@gmail.com>
Subject: [PATCH v2 4/6] ceph: Split out page-array discarding to a function
Date: Wed,  7 Jan 2026 13:01:37 -0800
Message-ID: <20260107210139.40554-5-CFSworks@gmail.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260107210139.40554-1-CFSworks@gmail.com>
References: <20260107210139.40554-1-CFSworks@gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Discarding a page array (i.e. after failure to submit it) is a little
complex:
- Every folio in the batch needs to be redirtied and unlocked.
- Some folios are bounce pages created for fscrypt; the underlying
  plaintext folios also need to be redirtied and unlocked.
- The array itself can come either from the mempool or general kalloc,
  so different free functions need to be used depending on which.

Although currently only ceph_submit_write() does this, this logic is
complex enough to warrant its own function. Move it to a new
ceph_discard_page_array() function that is called by ceph_submit_write()
instead.

Suggested-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Sam Edwards <CFSworks@gmail.com>
---
 fs/ceph/addr.c | 67 ++++++++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 29 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 467aa7242b49..3becb13a09fe 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1222,6 +1222,43 @@ void ceph_allocate_page_array(struct address_space *mapping,
 	ceph_wbc->len = 0;
 }
 
+static inline
+void ceph_discard_page_array(struct writeback_control *wbc,
+			     struct ceph_writeback_ctl *ceph_wbc)
+{
+	int i;
+	struct page *page;
+
+	for (i = 0; i < folio_batch_count(&ceph_wbc->fbatch); i++) {
+		struct folio *folio = ceph_wbc->fbatch.folios[i];
+
+		if (!folio)
+			continue;
+
+		page = &folio->page;
+		redirty_page_for_writepage(wbc, page);
+		unlock_page(page);
+	}
+
+	for (i = 0; i < ceph_wbc->locked_pages; i++) {
+		page = ceph_fscrypt_pagecache_page(ceph_wbc->pages[i]);
+
+		if (!page)
+			continue;
+
+		redirty_page_for_writepage(wbc, page);
+		unlock_page(page);
+	}
+
+	if (ceph_wbc->from_pool) {
+		mempool_free(ceph_wbc->pages, ceph_wb_pagevec_pool);
+		ceph_wbc->from_pool = false;
+	} else
+		kfree(ceph_wbc->pages);
+	ceph_wbc->pages = NULL;
+	ceph_wbc->locked_pages = 0;
+}
+
 static inline
 bool is_folio_index_contiguous(const struct ceph_writeback_ctl *ceph_wbc,
 			      const struct folio *folio)
@@ -1445,35 +1482,7 @@ int ceph_submit_write(struct address_space *mapping,
 	BUG_ON(len < ceph_fscrypt_page_offset(page) + thp_size(page) - offset);
 
 	if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
-		for (i = 0; i < folio_batch_count(&ceph_wbc->fbatch); i++) {
-			struct folio *folio = ceph_wbc->fbatch.folios[i];
-
-			if (!folio)
-				continue;
-
-			page = &folio->page;
-			redirty_page_for_writepage(wbc, page);
-			unlock_page(page);
-		}
-
-		for (i = 0; i < ceph_wbc->locked_pages; i++) {
-			page = ceph_fscrypt_pagecache_page(ceph_wbc->pages[i]);
-
-			if (!page)
-				continue;
-
-			redirty_page_for_writepage(wbc, page);
-			unlock_page(page);
-		}
-
-		if (ceph_wbc->from_pool) {
-			mempool_free(ceph_wbc->pages, ceph_wb_pagevec_pool);
-			ceph_wbc->from_pool = false;
-		} else
-			kfree(ceph_wbc->pages);
-		ceph_wbc->pages = NULL;
-		ceph_wbc->locked_pages = 0;
-
+		ceph_discard_page_array(wbc, ceph_wbc);
 		ceph_osdc_put_request(req);
 		return -EIO;
 	}
-- 
2.51.2



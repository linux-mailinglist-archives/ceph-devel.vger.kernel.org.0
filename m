Return-Path: <ceph-devel+bounces-4235-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DFE6FCEB208
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Dec 2025 03:56:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D1A59301FC0E
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Dec 2025 02:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECE582E8B97;
	Wed, 31 Dec 2025 02:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DvhvGZDI"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C78E2E719C
	for <ceph-devel@vger.kernel.org>; Wed, 31 Dec 2025 02:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767149731; cv=none; b=vA5wKIW13em0bRHq+g/gIYMp99v6vS/+eazEOlwAm0hLS2+Op/Kli+M5WkPYufgxS/yrVP6ZO87+Hm838MLr0CME1I8dIou1QZmtgKjUzNHXwHjFEmH7vkv5cz7NnQ7ijKGnTcqDrGhIsvK/idPuaNet67+4kTwz1fpWX3JIy+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767149731; c=relaxed/simple;
	bh=+OMCjLpYjNGGYfZdJjYQd5xrfdW6cvuAZrYjo1yzsPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MH7J3K/gYVfhJ/4W0/BjXx83ugioW78SPBskF9tUcrVxE5V0/nW7ExNtsLrsDYRVydhcFYhAybvp46iiHz762MCY86gdgPJ/qq9nlGD2PJTYuB+IgM3h+YzAcyDvWqNcuwyVn77lHrkuooqvhh2zpogJJzrRhADbEeuSfbiUYUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DvhvGZDI; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7b9387df58cso16811435b3a.3
        for <ceph-devel@vger.kernel.org>; Tue, 30 Dec 2025 18:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767149729; x=1767754529; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GD9+M0L1TL+nHtGjY77JqppAv2xqxZhHU8cYw4+7xmc=;
        b=DvhvGZDI4/aPVk1jwVhCuXr4IhEhVqsZQX53aCAUkzht95vhJJcEcIDpPWtUeiGS3v
         5pHxJQfUYepLu/16Oezg/5si+fX7QC3iooQNz76+2AEqx4Rb+R+KLsA0+ONovKEGs8m4
         BTjCjhIwxBv7JxYkkaroiPCwKmn9xwDWRlo+99clBdRjdU0ldLrfFrLF6vbu42S8C9u+
         2pLEMMNgAVvGDyaWYSfj42dDwEjTMvkNbRQUM8Ri4wiBgeIXdFsT90JxxPx/nC4XAiBy
         Jbz99TxY1NR5eeN8G0C3tEDLfmA8jKZLEvGbfhL86tjUARFhukQIVmo+djosLTOEm1ke
         kTnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767149729; x=1767754529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GD9+M0L1TL+nHtGjY77JqppAv2xqxZhHU8cYw4+7xmc=;
        b=ouZVZ6+Xf/81hgrR87IFV0PQ8DynjegOqggQ9uRzAbqpc1Ohk5OcvqSOoZfS598DOz
         m9GkJOtMY3tQx5jHbfuwtUmEBFfI59f/yHDqRze7XIJLWRw4lDV1DArtn/Q++ZB5h9df
         kt0V8YPYJqa37LjD10phlVFkd9WksuiDAqUOnfvkbTAfnpOFzzjynnD0UYxEBsYopxPV
         udU/FQOPo66s7Fbg0YPJ/H2rf04+MqeG0AWX815BLndwhI/ZTgDyZ7AH+qsiOPU9CiTh
         z/mZBFWRk3UeU7EcvLF9btv9e9ks3/+Fu2aIwTtvVsRe4otUdO5iuH79TTwZrIBWLf5l
         346A==
X-Forwarded-Encrypted: i=1; AJvYcCUyhuAnly1H5rZHzPpaalILi96fqCzdU99AfqtZ5VRzvFF5p9vzpqOll3BWMoFccvFa1VvYiHICLJQJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4ELBeaeRmgWCwCC/WJ6jneuvtrYf+MDZZ+CY6OttoYpkyrrYi
	O/h6o0Dvkc33aBuq8wgtIFyjYpNIIL8aFvenBNQ7/hkyh6N90U1t+BOD
X-Gm-Gg: AY/fxX5WU0CxMMdbNAuwULWCpIjRlCJkjEQdsGlq1ecbWdQ/a0j3WmHiJ/6NZf4Z9IR
	nnJAwdSmTNFrTMMD/9mX1jXEj1mA4ZdtZDbjonZaNayxC//K+VzWFlEzFDSTd9Ve3Q9kL29/q2K
	KVzoLi5zQ4I8PLJQG5kb46PLiscamz324GO5TufT9hFCzLRR6wJqzgCShJHb3YU3W89cfxhXdXh
	9HTpSQd1X71ALY2icmKnWISZAI74YmNqasQ7Lx7L4aWwE5aFl5U6zUIqFpYZREcl7JngXMBGgaq
	vXOJtU5lst0e/rJ6qKKxZ+EmZo/LgQQoGP+cQ3mEHeqim5xsgHqCrSjLV74dhDRd6VsGpWLTHvD
	F4OJ9Lje1nEN0pk+viIxAivk92IT9+nOgvdniHI/FKWBfNYHknrDKP88M9Ou4CeYkXKPKr/uGEj
	1oxQ==
X-Google-Smtp-Source: AGHT+IHQhHz2NAHmsBdYzxrrHSUZCSsyTkuM4/dUNCL/zI9iHymcmkwSgPqKvYSy6Vi5rp4ER//TRQ==
X-Received: by 2002:a05:6a00:3316:b0:7e8:450c:619c with SMTP id d2e1a72fcca58-7ff66a6a6acmr31156344b3a.51.1767149729370;
        Tue, 30 Dec 2025 18:55:29 -0800 (PST)
Received: from celestia ([69.9.135.12])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e892926sm33623646b3a.66.2025.12.30.18.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 18:55:28 -0800 (PST)
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
Subject: [PATCH 2/5] ceph: Remove error return from ceph_process_folio_batch()
Date: Tue, 30 Dec 2025 18:43:13 -0800
Message-ID: <20251231024316.4643-3-CFSworks@gmail.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251231024316.4643-1-CFSworks@gmail.com>
References: <20251231024316.4643-1-CFSworks@gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Following the previous patch, ceph_process_folio_batch() no longer
returns errors because the writeback loop cannot handle them.

Since this function already indicates failure to lock any pages by
leaving `ceph_wbc.locked_pages == 0`, and the writeback loop has no way
to handle abandonment of a locked batch, change the return type of
ceph_process_folio_batch() to `void` and remove the pathological goto in
the writeback loop. The lack of a return code emphasizes that
ceph_process_folio_batch() is designed to be abort-free: that is, once
it commits a folio for writeback, it will not later abandon it or
propagate an error for that folio.

Signed-off-by: Sam Edwards <CFSworks@gmail.com>
---
 fs/ceph/addr.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 3462df35d245..2b722916fb9b 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1283,16 +1283,16 @@ static inline int move_dirty_folio_in_page_array(struct address_space *mapping,
 }
 
 static
-int ceph_process_folio_batch(struct address_space *mapping,
-			     struct writeback_control *wbc,
-			     struct ceph_writeback_ctl *ceph_wbc)
+void ceph_process_folio_batch(struct address_space *mapping,
+			      struct writeback_control *wbc,
+			      struct ceph_writeback_ctl *ceph_wbc)
 {
 	struct inode *inode = mapping->host;
 	struct ceph_fs_client *fsc = ceph_inode_to_fs_client(inode);
 	struct ceph_client *cl = fsc->client;
 	struct folio *folio = NULL;
 	unsigned i;
-	int rc = 0;
+	int rc;
 
 	for (i = 0; can_next_page_be_processed(ceph_wbc, i); i++) {
 		folio = ceph_wbc->fbatch.folios[i];
@@ -1322,12 +1322,10 @@ int ceph_process_folio_batch(struct address_space *mapping,
 		rc = ceph_check_page_before_write(mapping, wbc,
 						  ceph_wbc, folio);
 		if (rc == -ENODATA) {
-			rc = 0;
 			folio_unlock(folio);
 			ceph_wbc->fbatch.folios[i] = NULL;
 			continue;
 		} else if (rc == -E2BIG) {
-			rc = 0;
 			folio_unlock(folio);
 			ceph_wbc->fbatch.folios[i] = NULL;
 			break;
@@ -1369,7 +1367,6 @@ int ceph_process_folio_batch(struct address_space *mapping,
 		rc = move_dirty_folio_in_page_array(mapping, wbc, ceph_wbc,
 				folio);
 		if (rc) {
-			rc = 0;
 			folio_redirty_for_writepage(wbc, folio);
 			folio_unlock(folio);
 			break;
@@ -1380,8 +1377,6 @@ int ceph_process_folio_batch(struct address_space *mapping,
 	}
 
 	ceph_wbc->processed_in_fbatch = i;
-
-	return rc;
 }
 
 static inline
@@ -1685,10 +1680,8 @@ static int ceph_writepages_start(struct address_space *mapping,
 			break;
 
 process_folio_batch:
-		rc = ceph_process_folio_batch(mapping, wbc, &ceph_wbc);
+		ceph_process_folio_batch(mapping, wbc, &ceph_wbc);
 		ceph_shift_unused_folios_left(&ceph_wbc.fbatch);
-		if (rc)
-			goto release_folios;
 
 		/* did we get anything? */
 		if (!ceph_wbc.locked_pages)
-- 
2.51.2



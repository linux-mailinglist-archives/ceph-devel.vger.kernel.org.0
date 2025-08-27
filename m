Return-Path: <ceph-devel+bounces-3479-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 42422B38962
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Aug 2025 20:17:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1706B7A20E0
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Aug 2025 18:15:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88AC62D9EC8;
	Wed, 27 Aug 2025 18:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="eKZ9EQ9V"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975752D836A
	for <ceph-devel@vger.kernel.org>; Wed, 27 Aug 2025 18:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756318636; cv=none; b=i6LsIXpITSMrPbywZqTx0+Qq1JcEu60N9NLXeJnoN4Yyoa4689Z3eeSChprYi2ccRtCBwn379nwSDa/WdMXnSTMpK8spdQau2jIYKBZyWS6csx8XC1FUTv3BxO6emp1i/3D3hBYMpli82UGmuoLFD49sZ+SYxQxWakUwSK4lrGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756318636; c=relaxed/simple;
	bh=Qgu6/RdKA4nKwsBeRMdnCSK3IDF8FjZbqqOVA6mr5MU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gbrTBNbeu67QmVbaTduiZGTGh6moXno7FQyZQOJ6Kw1WE3bRwocusSSmAIICAfS0xTm0fixidDNL1UI/UPQduUBuS0WOJgOG1b/su4uMuyzera1MCg+gNMfx0m7PAkvlWii8qtnIl/eHgGlsWHE12dEAKuFRqhTQGBDxjZfRExQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=eKZ9EQ9V; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45b6b5ccad6so505135e9.2
        for <ceph-devel@vger.kernel.org>; Wed, 27 Aug 2025 11:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756318631; x=1756923431; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lfiFhb80UdeegfuksVoSRuVkJVqC353CpIpZ8GK/9hE=;
        b=eKZ9EQ9Van4InK0MfGmq2nY/g3UasJFQ4uviwUW0aemsqGN1cqe5fvYjCiyN5+M82O
         l+orjaUnkuTz9zc9S/6uepU1nwq558N6xmcmpfARpzLE4sbODCA/3qyG7s2rmXh5F7/P
         gqNAcTvxUP3cqIXiU97nko92LMB0VtXrrixn2h1Kiq16jDgv8GmCXOLYOnKL87qi1l2n
         /5auYM4wgYW6MAE1G87uOue0r5FHQxXlB/Qslkj80Ge1nISb0AEbsxVdiFmsw9zN9VGU
         r3MeVLnkvc4jw+vRM4/iOdS9Ncxje5bKq9d+gZ0M9AGe0HpqRx+wIrTvi2+mUNwh0fve
         88fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756318631; x=1756923431;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lfiFhb80UdeegfuksVoSRuVkJVqC353CpIpZ8GK/9hE=;
        b=BP8slsZYFl98v/n/v3bYYNc4DX7SR+2w/WKJmjpGRwf6HWANFY3FDIeEg+QAXw5A3a
         i6CkG5UkRz61sQmVHOPDEs6Xw57BX1Yi+Um8hY/+lmz3xoJ4VBsjcCSgL51fs0Le5I//
         KG+AdodZQewvjKdVs+kqoPia8grWblzgUZ0MYBX9TxivpaA81NNVur8b0NlBKGzElVTD
         8Un6ZBJJVNU6oor5I6YxXnYuAAteWFno8fd/1y/wYkYFaX6+35DVM9wVcusHLWnbF1jD
         vMcAb7fnxunUZjVXnWeOKE32+uIAcQP0eV42Sfhxp8KF5PxOooGs/OpMS/7VYaVOsPnD
         /kVg==
X-Forwarded-Encrypted: i=1; AJvYcCUbgl6cYA1eEBRd+P2PgUcKsGjhsRJ6h/2dGifH1QX3J2ltT3YTc2/pRN7iwcH2MTsgyx7ZPTa7K4Gk@vger.kernel.org
X-Gm-Message-State: AOJu0YyjZOWH/jPHU9+P36E6z1ddiSw7Gmya8Z4sylUoh91oOZVtTUPS
	G6lAv7Y5Tu2d1hHn2SSPgt6NFGZ2cDlL3qTLimDod418F5+Ig7zidTOEeD1hMibBqiM=
X-Gm-Gg: ASbGncv2lpNwar5n0JmBaqb0y/UHkDdvq+GBYb5kp1lg+HWY3Xq2VvAgwc8cnxNnazu
	vAmUBdMAjn7IuvUgxin4THGgRKmj//icfZocExslIKfwUbTeLKjHQPb24Ynlb7gqTH7M3KGc3OB
	ccrsuQenHwiH2UKe87Ufv2OPl7ML6+oaB027uduFYBEmi5ZVGgMYMBxTRzAwfMXp6Ljw9o/meh4
	jMA+2Nk39eO2wMJntCQsA0iW67P0JsQ97UIXuenk4QMZ9f5Ese7ZrgWLoe5TXQIIYufAQ6+hEkS
	LAVLgNRWRnLeRS9FIqG2cjD8aP1BGfoBJcWZzgW5cMdCceD60L9Gvt8EFNbPpFt9vnoHc9VXeb8
	i63BW9nZVerDFKnOKavJB3sguDlVFOqfVfba9FYHuXRPMR8k7zyT1KYRWJwfEwTgtq2JpYWDHj1
	bSCfyS6vB1T1a8vk+aANKpOw==
X-Google-Smtp-Source: AGHT+IGqJ/GzQEWFQVd2ZnAV2tc6BCr/NnNnCcxzUwX006UuCMKNuwXKfoncaQGKE/l2cQi85xDhag==
X-Received: by 2002:a05:600c:1c25:b0:45b:7608:3ca1 with SMTP id 5b1f17b1804b1-45b76212044mr6014835e9.23.1756318630791;
        Wed, 27 Aug 2025 11:17:10 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c8bedsm42223905e9.1.2025.08.27.11.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 11:17:10 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: Slava.Dubeyko@ibm.com,
	xiubli@redhat.com,
	idryomov@gmail.com,
	amarkuze@redhat.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>,
	stable@vger.kernel.org
Subject: [PATCH] fs/ceph/addr: always call ceph_shift_unused_folios_left()
Date: Wed, 27 Aug 2025 20:17:08 +0200
Message-ID: <20250827181708.314248-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function ceph_process_folio_batch() sets folio_batch entries to
NULL, which is an illegal state.  Before folio_batch_release() crashes
due to this API violation, the function
ceph_shift_unused_folios_left() is supposed to remove those NULLs from
the array.

However, since commit ce80b76dd327 ("ceph: introduce
ceph_process_folio_batch() method"), this shifting doesn't happen
anymore because the "for" loop got moved to
ceph_process_folio_batch(), and now the `i` variable that remains in
ceph_writepages_start() doesn't get incremented anymore, making the
shifting effectively unreachable much of the time.

Later, commit 1551ec61dc55 ("ceph: introduce ceph_submit_write()
method") added more preconditions for doing the shift, replacing the
`i` check (with something that is still just as broken):

- if ceph_process_folio_batch() fails, shifting never happens

- if ceph_move_dirty_page_in_page_array() was never called (because
  ceph_process_folio_batch() has returned early for some of various
  reasons), shifting never happens

- if `processed_in_fbatch` is zero (because ceph_process_folio_batch()
  has returned early for some of the reasons mentioned above or
  because ceph_move_dirty_page_in_page_array() has failed), shifting
  never happens

Since those two commits, any problem in ceph_process_folio_batch()
could crash the kernel, e.g. this way:

 BUG: kernel NULL pointer dereference, address: 0000000000000034
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 PGD 0 P4D 0
 Oops: Oops: 0002 [#1] SMP NOPTI
 CPU: 172 UID: 0 PID: 2342707 Comm: kworker/u778:8 Not tainted 6.15.10-cm4all1-es #714 NONE
 Hardware name: Dell Inc. PowerEdge R7615/0G9DHV, BIOS 1.6.10 12/08/2023
 Workqueue: writeback wb_workfn (flush-ceph-1)
 RIP: 0010:folios_put_refs+0x85/0x140
 Code: 83 c5 01 39 e8 7e 76 48 63 c5 49 8b 5c c4 08 b8 01 00 00 00 4d 85 ed 74 05 41 8b 44 ad 00 48 8b 15 b0 >
 RSP: 0018:ffffb880af8db778 EFLAGS: 00010207
 RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000003
 RDX: ffffe377cc3b0000 RSI: 0000000000000000 RDI: ffffb880af8db8c0
 RBP: 0000000000000000 R08: 000000000000007d R09: 000000000102b86f
 R10: 0000000000000001 R11: 00000000000000ac R12: ffffb880af8db8c0
 R13: 0000000000000000 R14: 0000000000000000 R15: ffff9bd262c97000
 FS:  0000000000000000(0000) GS:ffff9c8efc303000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000034 CR3: 0000000160958004 CR4: 0000000000770ef0
 PKRU: 55555554
 Call Trace:
  <TASK>
  ceph_writepages_start+0xeb9/0x1410

The crash can be reproduced easily by changing the
ceph_check_page_before_write() return value to `-E2BIG`.

(Interestingly, the crash happens only if `huge_zero_folio` has
already been allocated; without `huge_zero_folio`,
is_huge_zero_folio(NULL) returns true and folios_put_refs() skips NULL
entries instead of dereferencing them.  That makes reproducing the bug
somewhat unreliable.  See
https://lore.kernel.org/20250826231626.218675-1-max.kellermann@ionos.com
for a discussion of this detail.)

My suggestion is to move the ceph_shift_unused_folios_left() to right
after ceph_process_folio_batch() to ensure it always gets called to
fix up the illegal folio_batch state.

Fixes: ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() method")
Link: https://lore.kernel.org/ceph-devel/aK4v548CId5GIKG1@swift.blarg.de/
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 fs/ceph/addr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 8b202d789e93..8bc66b45dade 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1687,6 +1687,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 
 process_folio_batch:
 		rc = ceph_process_folio_batch(mapping, wbc, &ceph_wbc);
+		ceph_shift_unused_folios_left(&ceph_wbc.fbatch);
 		if (rc)
 			goto release_folios;
 
@@ -1695,8 +1696,6 @@ static int ceph_writepages_start(struct address_space *mapping,
 			goto release_folios;
 
 		if (ceph_wbc.processed_in_fbatch) {
-			ceph_shift_unused_folios_left(&ceph_wbc.fbatch);
-
 			if (folio_batch_count(&ceph_wbc.fbatch) == 0 &&
 			    ceph_wbc.locked_pages < ceph_wbc.max_pages) {
 				doutc(cl, "reached end fbatch, trying for more\n");
-- 
2.47.2



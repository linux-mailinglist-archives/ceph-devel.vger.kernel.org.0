Return-Path: <ceph-devel+bounces-4237-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C337ECEB1F0
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Dec 2025 03:55:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B856E301E229
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Dec 2025 02:55:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E4BF2F28FF;
	Wed, 31 Dec 2025 02:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eEe7MnOq"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCA32E4263
	for <ceph-devel@vger.kernel.org>; Wed, 31 Dec 2025 02:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767149734; cv=none; b=oFOhSFH4I3TtC8Lt+1IrlZ526f7X+bqhjdMaQFeSM9cah/uCBI6E5JgffQoDAbQxGySGaod2zD63r9cwiN5CGTHlS36QSHyJGZ0ULV3FjDUt3yvD2Ii45Oi3MCK7dzAnPFGuGbi8Jy+2xvFypbiXQhMBKsNCTwoUUqF9lUDrHuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767149734; c=relaxed/simple;
	bh=7x51uiDaTktolV+LzMU7zA0PjIHxRzwQBudHNGCpDGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJWIsRPFOadbvqGrqdfim2LyZd2XdEkxPddUcELvAYzYT6d9lkMmY2F9yRgDimKs35uxOJIEshMkrD3HZjXwFU5F2bREJ+mPEn2iv1sjt9Cg4+Tw2BLpIJgXLXFnddBe64HNe8IcimguM4J1ImBYxzParyJKO10+ENUG9pCaaAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eEe7MnOq; arc=none smtp.client-ip=209.85.210.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-803474aaa8bso3777205b3a.0
        for <ceph-devel@vger.kernel.org>; Tue, 30 Dec 2025 18:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767149732; x=1767754532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A6vlMYfzzrfVusqphG0GGHNwZxDj4Zq+5OFoT9T7pH0=;
        b=eEe7MnOq6VCPR+jJTNEjh4SyGDDkWRbtjjaHtchvBt0hBh+UAfPA8KiyEdOdzwnt7h
         yQsakuVbZl878/FoDsuSZSpjCkumIWYr2s+ALH4k2oGktfmGv76ErQG5akDa6nWKo18+
         0YwBZ0ya706JZk5H762V2EEiF0hpdl5eqaCfcEAjYD2FSvNN6FH/ae1PYZpE87TOMK3l
         e5/t0qV8zwtihC6wxe1xzQwuRXY7D+TGvFwLrEK1SIiN5CUE9cVOP48ChUGyObF6jfwM
         Uw7hKamidCfyfd45Ztb8KHMk8QKQLWBB3DCrFxQfu5e756MWRKMCC67jt78TPP9P08O7
         TqvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767149732; x=1767754532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A6vlMYfzzrfVusqphG0GGHNwZxDj4Zq+5OFoT9T7pH0=;
        b=DNkyr0TjO//RCcuiLdfXPQi3aKwTZju4IWe7FVDt4VpNqGA69k8OSpip2ddQ2JZyiG
         psVGm0R7VBp5bXjbsNj2HAHuEKvAlJdDdE6KkEIH7ZX8oaWBGvgCdyTxFyJcUWODMtSL
         tS7hrll6n9aTj50xHq4IEcmuHZ6gZZQTfcfGwO06AJ2/b/pFgGIzAwE1es61xr/Oe7jV
         mcsxuKisTW4f98SYAlUnqsV9stVV9A6nJI+aHBazXyWbkt78CtxrQdXPXTBNUmLfvlTC
         RmtzdCkR3/WYiBa9GVPDIbs8Ny+Fkrb6zk+pLPFPMM+gk0EfUanEXTm29KEpr0b7OrGq
         7Mcg==
X-Forwarded-Encrypted: i=1; AJvYcCVi72mIQ7/87ZSdapahtcz9GFdefsv/oPZyhP1czl5N+M2PMsAedK63BMG4lGjIU9vV6kpixSroYJTZ@vger.kernel.org
X-Gm-Message-State: AOJu0YzOuR75SxIxY9u5OHZLNb46Z0JjJpWTlxiwfYUt5mN8AmTEOFxJ
	YM+UHKiaaKuEPCv46t0gdynDeaIWcMI0rMy/qPPjGAUQ6eDkjQ7eE5jtEzyMbFne
X-Gm-Gg: AY/fxX7hv2aamN+ZMN4NtFuQymEu8N0u+AWNdB7kzaruk+d5+590yvZ+9mazylvIEnz
	5NXuTC07SiN721eqxkrpFv93gsa9o2a6X5TBcDVbd4KSB2gjQ0nLmdCs1hV62zELX2iPBVPtydK
	D7i6efGOqmnuH4t8KrocA2MM2BhjVceh/24K5Vp26ofCdGORIs2GccCDEXh/QCSn8qkCkcbOGsD
	Z+h5sg6mqPjHAS4rb849JaQ5uxdBRDoaokSUeLCJFS/PfQwnRqG6LP7Ugn0c3R1tKGUVhuiBE1v
	63x0XgAIeG60YOwq2qffvIdMt06UIcnUeBd32UjLonj+LFw/jlhFK2EcZJB5E99NU6F9HF70krL
	FA1/wQ57YWl8eXKVGeserC/T+LgfrqiufuJH28Xxw6r//y680JHKOYHzDjiBFGpxl0ravodpCMh
	4igg==
X-Google-Smtp-Source: AGHT+IEbU2+Y00aMWNdc38w4hjHwqdRtFca243nmnZxlmhfr5urwXm9ogf2dF3svZ9Qb+AeuG4fIeg==
X-Received: by 2002:a05:6a00:4514:b0:78a:f6be:74f2 with SMTP id d2e1a72fcca58-7ff5284da68mr35782590b3a.5.1767149731611;
        Tue, 30 Dec 2025 18:55:31 -0800 (PST)
Received: from celestia ([69.9.135.12])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e892926sm33623646b3a.66.2025.12.30.18.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 18:55:31 -0800 (PST)
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
Subject: [PATCH 4/5] ceph: Assert writeback loop invariants
Date: Tue, 30 Dec 2025 18:43:15 -0800
Message-ID: <20251231024316.4643-5-CFSworks@gmail.com>
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

If `locked_pages` is zero, the page array must not be allocated:
ceph_process_folio_batch() uses `locked_pages` to decide when to
allocate `pages`, and redundant allocations trigger
ceph_allocate_page_array()'s BUG_ON(), resulting in a worker oops (and
writeback stall) or even a kernel panic. Consequently, the main loop in
ceph_writepages_start() assumes that the lifetime of `pages` is confined
to a single iteration.

This expectation is currently not clear enough, as evidenced by the
previous two patches which fix oopses caused by `pages` persisting into
the next loop iteration.

Use an explicit BUG_ON() at the top of the loop to assert the loop's
preexisting expectation that `pages` is cleaned up by the previous
iteration. Because this is closely tied to `locked_pages`, also make it
the previous iteration's responsibility to guarantee its reset, and
verify with a second new BUG_ON() instead of handling (and masking)
failures to do so.

Signed-off-by: Sam Edwards <CFSworks@gmail.com>
---
 fs/ceph/addr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 91cc43950162..b3569d44d510 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1669,7 +1669,9 @@ static int ceph_writepages_start(struct address_space *mapping,
 		tag_pages_for_writeback(mapping, ceph_wbc.index, ceph_wbc.end);
 
 	while (!has_writeback_done(&ceph_wbc)) {
-		ceph_wbc.locked_pages = 0;
+		BUG_ON(ceph_wbc.locked_pages);
+		BUG_ON(ceph_wbc.pages);
+
 		ceph_wbc.max_pages = ceph_wbc.wsize >> PAGE_SHIFT;
 
 get_more_pages:
@@ -1703,11 +1705,10 @@ static int ceph_writepages_start(struct address_space *mapping,
 		}
 
 		rc = ceph_submit_write(mapping, wbc, &ceph_wbc);
-		if (rc)
-			goto release_folios;
-
 		ceph_wbc.locked_pages = 0;
 		ceph_wbc.strip_unit_end = 0;
+		if (rc)
+			goto release_folios;
 
 		if (folio_batch_count(&ceph_wbc.fbatch) > 0) {
 			ceph_wbc.nr_folios =
-- 
2.51.2



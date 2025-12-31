Return-Path: <ceph-devel+bounces-4236-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AFA3CEB211
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Dec 2025 03:56:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 44619304066D
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Dec 2025 02:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38D4E2EA75E;
	Wed, 31 Dec 2025 02:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xw5O2WZq"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1FC2BCF45
	for <ceph-devel@vger.kernel.org>; Wed, 31 Dec 2025 02:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767149732; cv=none; b=BusMkA9B3nYk4moCFU2bANRYVLNyflrydvGquYva6seTQRJjXkHWVf04tlBQkOMUXtTQkOx1348CStMeXh/Fyj8gFisjaEBstCAQn4mKy6YMQseJifT6dY0MVL52zpYyWLxrSWmx9b32qlGqRDuMrlysutjfY+8+17tgpP3mRoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767149732; c=relaxed/simple;
	bh=2MYN99jAWMQpINhvGeEWth578u35RLmt80tvIG1rBvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QoRliBqGiDziFUeHfZ7GzEdkOZoEz6DyOiFdeaqEQGWMNUCotiCtuHsiB3qusCkKkp8Mkz4Thd7zI9zRZ69YdDqi/9Fsdw5PVgYhJSvIHXwnFSVUojMTgPW3OyK5R+bViQUkJMImeLgOqWVkvRsqmESufdQOQO+eTxmJA9IxdAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xw5O2WZq; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7aab7623f42so11615585b3a.2
        for <ceph-devel@vger.kernel.org>; Tue, 30 Dec 2025 18:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767149730; x=1767754530; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WD8xYCq07j/aj+WegcGPJWer+Tc/bnFPxdD4Wp5XP0Y=;
        b=Xw5O2WZqu+0d8OEAuJi4mL3abvMp2lybFKx4CXtYiBTZtP1EDq2Rnq8qyvcoa+AzDY
         T54bl6tkq+MWXAQFn92cbGBUTu49Fz94EWk9ROgKTXCRhmfboxXnxcG4onOmzlV1S6Yo
         ORjlJamX6xTw6YoiqSRCWwccx3p4I8ejzLoyYQqdvAEqlDVPPG4gVeiWNChPm3SMg5oi
         Xmw+futbmadY39MucZk0QLh4v6gWY5mXXKoInubl8+cI93o6luY41Vh8f2SXB4BIpcP6
         bBe/4Pk93hv6wxcY2d7qE3XxN6n0Bc2KblFDNoJJllWbgLSx5kjin/77PyrlS3+PmcaY
         G5Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767149730; x=1767754530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WD8xYCq07j/aj+WegcGPJWer+Tc/bnFPxdD4Wp5XP0Y=;
        b=fKAVf1Ebze0iXybyVYh6ByINbXUco4VonSc5ITgB60DSKiGbeFCYBZKi5vaCaynk58
         DaXcTJ2WVFi+aTDINLFZyIdyrdx3KYD4WnYMJiQaJpW6oYBVpJLBpy2H6KIKFfemor37
         CQvi7IgYlIq486e3oevj8RFsj4BL73NpHm0dFAwa6vr/XxzxK4jel0Ac4SKkbHeUmTG6
         vKcuxpfm4L6erUuY2ARx3oHO/nJHDCIa2QAVDZa2ZA4X2HD/yQTC6s/AA97veBDUEWDz
         CraoG4WJE0WUwx98UpkmN9EYsRdWW+pLLwA997+k2j0dZmSfM3wr59jWzZor2fKlWpOh
         8W5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWvkVGmVrzeM4f7xFewlBQQnwIBp5oPX3zxFxv6Mdn5PjwHrbCAZ9uIMITdc5JPOMGEMo5lLcHpbvwG@vger.kernel.org
X-Gm-Message-State: AOJu0YwUBWRtwj7vIPsjSFgAlybroQRkD/RghygE3noLoNif3O4+Wu2K
	jv4WmMqQXMihuA/lqp3H+Nv+gUgIOqNY2NbGXsYMs8w2Aiv+wnPUP3Fz
X-Gm-Gg: AY/fxX7vF43mbJ9y7NxhrRpRlEVnkBB1dygte8guBxEztio33ILRAk2TovzRE+n6oLV
	E+Jehertsi8FB36BvgbEN1oAFSgXtoZaBxfkSkWl0EiTeqdgdKRE9xHZ65OzWkAC9Z4WORfhJUS
	3DG2tn6H/H28iLF9cxQe2x5Y57eXHWAiQjzEd1QbQejmJnWCQjQ3BqfuVkTyGMCitKdGinQLDR+
	/cVL7hQojkI2doJCCdLo6xhoTfDYC46+F7RlTgfWe+rnpBASzrv0gHzMET9fma5+ZL+Tl78RoEC
	cOg6pvYgU38XuSixYl4vm9lkQnWQBaCd8Blah2InV7iqLU30m9YZ467GZxH+EZpIMTyjWaFlP/w
	EEIA0mIhP62GIxgcKhZcBRVcgd36PP5GQGHsrwVtKkqxTx9cTI6TROuLeUTk+r3EJ8juLRQTZWy
	lBaA==
X-Google-Smtp-Source: AGHT+IF3Z5kgxOEyZ8TlUQEufDwaKzpJsoPdOR1wRnbEP5UUX7ilO8guI8waAq1O8VB1kpQTu9fn1Q==
X-Received: by 2002:a05:6a00:ab0d:b0:7e8:4433:8fa4 with SMTP id d2e1a72fcca58-7ff6607e208mr29157334b3a.44.1767149730562;
        Tue, 30 Dec 2025 18:55:30 -0800 (PST)
Received: from celestia ([69.9.135.12])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e892926sm33623646b3a.66.2025.12.30.18.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 18:55:30 -0800 (PST)
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
	Sam Edwards <CFSworks@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 3/5] ceph: Free page array when ceph_submit_write fails
Date: Tue, 30 Dec 2025 18:43:14 -0800
Message-ID: <20251231024316.4643-4-CFSworks@gmail.com>
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

The ceph_submit_write() function claims ownership of the page array on
success. But failures only redirty/unlock the pages and fail to free the
array, making the failure case in ceph_submit_write() fatal.

Free the page array in ceph_submit_write()'s error-handling 'if' block
so that the caller's invariant (that the array does not outlive the
iteration) is maintained unconditionally, allowing failures in
ceph_submit_write() to be recoverable as originally intended.

Fixes: 1551ec61dc55 ("ceph: introduce ceph_submit_write() method")
Cc: stable@vger.kernel.org
Signed-off-by: Sam Edwards <CFSworks@gmail.com>
---
 fs/ceph/addr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 2b722916fb9b..91cc43950162 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1466,6 +1466,13 @@ int ceph_submit_write(struct address_space *mapping,
 			unlock_page(page);
 		}
 
+		if (ceph_wbc->from_pool) {
+			mempool_free(ceph_wbc->pages, ceph_wb_pagevec_pool);
+			ceph_wbc->from_pool = false;
+		} else
+			kfree(ceph_wbc->pages);
+		ceph_wbc->pages = NULL;
+
 		ceph_osdc_put_request(req);
 		return -EIO;
 	}
-- 
2.51.2



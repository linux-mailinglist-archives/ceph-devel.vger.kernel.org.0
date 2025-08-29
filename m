Return-Path: <ceph-devel+bounces-3494-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 02400B3C441
	for <lists+ceph-devel@lfdr.de>; Fri, 29 Aug 2025 23:29:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AA0BC4E2604
	for <lists+ceph-devel@lfdr.de>; Fri, 29 Aug 2025 21:29:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9837286435;
	Fri, 29 Aug 2025 21:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="mV1k6mT2"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A7B220F2C
	for <ceph-devel@vger.kernel.org>; Fri, 29 Aug 2025 21:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756502966; cv=none; b=RoMDb/Y5xKlquVDn49dbkW3OGY/ifEt30klKdhLdykpMAtupr4kgd8Qt5rxx6Mr+SdqcmdSZOkAMOKkYdpaM29PZ1lyHO4Px/cLE3xl2NnINq6IM5E4NKjTtAcE/mDuJ6niy/ysLHjkzl1EPxAIZ9YxqOhi/h6Azs/X187Whb/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756502966; c=relaxed/simple;
	bh=hV78b/+JhSlZkaNyoJ0dw59qNlc4TBxbCEcPm5DhfUg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oFkSici/uypVTLz8pJqTp2QBvzoCEpzjoYcKyP9Pk512ZwMsHA2v7TSRouWspAfPMUfmw64GnosDLo0W5BYueABLwPVg2vsDIUQcZGNFSbscXh3WNYCZ66PoYo59SQ9dse2wK8VIski6b9WsJhUp8HHdCKkr0p5ZOB9SSbvmlBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=mV1k6mT2; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-72199d5a30aso15336397b3.3
        for <ceph-devel@vger.kernel.org>; Fri, 29 Aug 2025 14:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1756502963; x=1757107763; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rxWMp4YUoI/SPFDj6FZN1x6cHgl9fGez73Zz5i+2+aU=;
        b=mV1k6mT2kLW4yyUop4sg0oTa7WuYlKJ5udrynsGjwc/ZQ5impSCQFjW3c83Y+pgIIg
         ObjDyqV0e15koW/7QgjsgDI//brx5OIk2DfS/TJ+i2AkuBjoqdHjn6HEdJH0Wat10LaI
         NUWeP4abPsYmmEGoFuhXcDv8W20NpD6M02vfg5DOBdVRKHDnxq5J9H/u9ik9LFGrKQ+6
         N5rfJKdibDeQl1WEhUtjhCWAaVt9oDSdgXQoPdWQFAwoX9f6IpqmzF935EtVuTvDVklQ
         l9Jfn8Jj/CxuriWW6Wrrzj8Sw+n/jEzz/TQg1HIyWR6zyqYpXRTmo3w5wcxBEXdAYkh2
         yLXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756502963; x=1757107763;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rxWMp4YUoI/SPFDj6FZN1x6cHgl9fGez73Zz5i+2+aU=;
        b=b9CRGIElzAilTZRGesL+95W5dsXhnKRh8kIPkYtzAsduGWeS5gd9AL4UVvEWEvvneV
         PiG0EcsxABiAMXJWg9stsvyPp/7CSYRpqlz2ZM6HIorQGADfM3+fvBi56bjRLj3oEizF
         rYN7hdV3U2s/34x8AIMGUm4VYAPBdWblxJ26UVnrnsgc72Qwavs9GKzcovsuKxAADErG
         FbS9EU6eO32O2ztkevwIcF72AwCdOiILfZv9pY5Kht69vR/r3+U2hztrQxBYg0p2TjrD
         TgXdCxGQSvjS+9wQVttHr5INwBIU4bP16WPiJfih0R1R0pBNYkKwbpuLOW8Y7PmCk6Cb
         LZbQ==
X-Gm-Message-State: AOJu0Yxr74lIVovILMWTIMsjjfbYuvrGuj2VmCyjiPjQ16+azGJcY3bb
	fpEWKAWEEwMI1ZEsPeVTgvx5oXMccabUw8Cim0tJ6a5jaIoEhWCZYujqDKKoLtvCmB11u4RSd5U
	PHAA2lig=
X-Gm-Gg: ASbGncsNutzfid8SWC8CNejBxuaK2qxaOjy4MKlH+Pd/dICIwKyHfM41ivt1UI2r220
	u4oPEZYQv8efipldTuBAGP6eJuG1VDfQNbMWUgE9YN5DOlXKA7CUBfitm55z9V4WMMQlVYjElf6
	+vwXlxo6BaTVxhf0896RzAJenDslueZ58VgIOw2K6b5o31y/Lhm1XcKA6wZaDyYRyx//jZl5IZe
	RFDVhuW40PJ67nT7OWAj2NlS5trA3QyEkCjiOa+uDK07bwKTGnFxZ4vn/uQbaEtJtk5j4f6b9Uj
	N9XjcCAOiEbW3sHEt+Ngi3b+2GO/qTSe+eyGIkj3yrjZr+sAq1/26O8I2JjY7adqNVjKb9sq/2t
	EE9vt6ubJhw+DeeOtUHxjkJUlif9OSswEmUk+QaAe
X-Google-Smtp-Source: AGHT+IE02pn+a3WHTvbWPCwPPFbpk7f3pdsrPjHknBBOH1cB2cQAaz5ypmDb+KWYVcf1Nx9T/vSuWA==
X-Received: by 2002:a05:690c:648a:b0:720:c65:eee0 with SMTP id 00721157ae682-722764052b0mr1306607b3.19.1756502962836;
        Fri, 29 Aug 2025 14:29:22 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:ae3e:85f2:13ac:70a5])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-721c634891csm9891787b3.20.2025.08.29.14.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 14:29:22 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	vdubeyko@redhat.com
Subject: [PATCH] ceph: cleanup in ceph_alloc_readdir_reply_buffer()
Date: Fri, 29 Aug 2025 14:29:00 -0700
Message-ID: <20250829212859.93312-2-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

The Coverity Scan service has reported potential issue
in ceph_alloc_readdir_reply_buffer() [1]. If order could
be negative one, then it expects the issue in the logic:

num_entries = (PAGE_SIZE << order) / size;

Technically speaking, this logic [2] should prevent from
making the order variable negative:

if (!rinfo->dir_entries)
    return -ENOMEM;

However, the allocation logic requires some cleanup.
This patch makes sure that calculated bytes count
will never exceed ULONG_MAX before get_order()
calculation. And it adds the checking of order
variable on negative value to guarantee that second
half of the function's code will never operate by
negative value of order variable even if something
will be wrong or to be changed in the first half of
the function's logic.

[1] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIssue=1198252
[2] https://elixir.bootlin.com/linux/v6.17-rc3/source/fs/ceph/mds_client.c#L2553

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Ceph Development <ceph-devel@vger.kernel.org>
---
 fs/ceph/mds_client.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0f497c39ff82..d783326d6183 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2532,6 +2532,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
 	struct ceph_mount_options *opt = req->r_mdsc->fsc->mount_options;
 	size_t size = sizeof(struct ceph_mds_reply_dir_entry);
 	unsigned int num_entries;
+	u64 bytes_count;
 	int order;
 
 	spin_lock(&ci->i_ceph_lock);
@@ -2540,7 +2541,11 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
 	num_entries = max(num_entries, 1U);
 	num_entries = min(num_entries, opt->max_readdir);
 
-	order = get_order(size * num_entries);
+	bytes_count = (u64)size * num_entries;
+	if (bytes_count > ULONG_MAX)
+		bytes_count = ULONG_MAX;
+
+	order = get_order((unsigned long)bytes_count);
 	while (order >= 0) {
 		rinfo->dir_entries = (void*)__get_free_pages(GFP_KERNEL |
 							     __GFP_NOWARN |
@@ -2550,7 +2555,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
 			break;
 		order--;
 	}
-	if (!rinfo->dir_entries)
+	if (!rinfo->dir_entries || order < 0)
 		return -ENOMEM;
 
 	num_entries = (PAGE_SIZE << order) / size;
-- 
2.51.0



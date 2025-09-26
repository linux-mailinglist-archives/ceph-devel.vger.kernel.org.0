Return-Path: <ceph-devel+bounces-3739-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6BB5BA2959
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Sep 2025 08:56:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D287388431
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Sep 2025 06:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E373527E1B1;
	Fri, 26 Sep 2025 06:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="JN7Jyh35"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FDA2AE8D
	for <ceph-devel@vger.kernel.org>; Fri, 26 Sep 2025 06:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758869765; cv=none; b=akDeT4QMaiytDxg/30X98jR8JYhiwV2Y/arDb+zDl2NT4PxdXAHa5tUYITEKohWE90sxdf3Bz6hIopFlGDpO1a3Oh1S5eTmMTilNIFnZF5O/0dFMqW7lunbrEOpcZN20h4ATQwQdNjDLbydoV9o7FRO0UXT2wM4QfMQnAlDN5Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758869765; c=relaxed/simple;
	bh=+4YCN2dmmyfb7+Hl1S6/hlw/+FbPhHYA7RWFcIkHebg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TiBRXZYXQ3sWmt93dVistcgdw21kx1qTraC1DqXOIzMPkLgtSbQGWHV7mBPExxmAZ/9iuOJkIMXLUImGkca3ikwCHPYtVoxr87KHOli0p+UCmpj0qknIiTwZ0u4nNIAe1WEgwe+r9At0zv0og6c/YHmKoc7IT9bDTASg4AeY2mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=JN7Jyh35; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-77716518125so967873b3a.3
        for <ceph-devel@vger.kernel.org>; Thu, 25 Sep 2025 23:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1758869763; x=1759474563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eoUrxrA1gUNwCBEXabdQA4Jiv6vtYFchaTivJjmbSzM=;
        b=JN7Jyh35hvJxqKA0eciejU9HR/AggXWfxW842Us2/elza8ebZl/M6tJUk52hsdIqBW
         W9IS4Xp8Pmwht4WnmsBpoUkWYsIaf9NgkaqfoHv7yzgRQU0alsC7PXfOQEDm6ztWlcLR
         D8hXDXByInnZymjNFQEi7JhMcfOasIcjNRMqgKpPIYweTZlekjs45IDHAjYQCRCRmE6u
         PuM1043istvCMg45FJxoFhOwPscckrfvPXLKoEnw6i43TDTDMjHqJB3oBUGVYJOvqZFF
         zxFY/AC2EuU186MUEDhdxVWbKcgnNyj8dDVeBtg1ZfwxG7gml+pwFKYvbZk8uiKL/fJT
         dqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758869763; x=1759474563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eoUrxrA1gUNwCBEXabdQA4Jiv6vtYFchaTivJjmbSzM=;
        b=oq4pPgq5tCVNE8a7NumU3oR6ZYtPTgDzXnE9OT/jNnIV2ZkZ67U+uCWmCCb0toPDRE
         plsLR7hGCQgYYpEXl4JLaEpHFCmbwObuoiW8mbPdtw4MLqgUwFrzyysw1zhM/n3RsodV
         a0CIF5M/lqYekC8K67y4vlGXYbqa4cHCLJQztlMY+9QBZgJXja6PsIBFvTKC3uLtcQVt
         51C7ZdejP3jj0MnrwaGPxYLKUdbjPIJznE3fNFqAhGdiG8SzmPWOF+exQCkuyvNc9AUB
         s1midytGnFlOKIm4ldSNRXVFf2epYZw0uC+673qqXt/yCM75jb8QW6sNzE2fpvQbwq1R
         4Heg==
X-Forwarded-Encrypted: i=1; AJvYcCWrqRtKHn65fQmiM8mCy9cCnuFkMNkyPsVh0FwLclDhlZj0xV27MSNyfWdwYNPqA5DKJNWiRlIS4OLg@vger.kernel.org
X-Gm-Message-State: AOJu0YwKJyQU4EhkvDfawYdLut1wfho/1geLvjXaix550vqGDz4erO3B
	0oWxWji3Oe7pfy9Es/PoVVlbR0oO1oLwNdmB/Nas+IQsGN8brv/wa6gwo0L7yxT97dY=
X-Gm-Gg: ASbGncupf19IQ8sQCuFf1qI9wGZ5a+Ld6uRtpf2zlD2uM2gOvDr0MJIJ3V7O/htXx2v
	5+2vNYMsRV/6EN7JsjlATgyRDGbChc/2QEYUO0GI+Nhnppc7SgPZ2U/GD/RROp+uuoj0bcHk4dC
	/6BHDpbyZ2k0nQRQkSZsO2vi3O7tdPO+QRVRSS78xQf2Yq6Toq3BhPLKFclrHtB/vEmm4//NPTa
	pRwSsf5jIunJ7cRNEKurItEqLt0zQMqFVrLTO5DQci4kc1iYaOW9/EVIc+WlqqoY5msbkDpEgTh
	6S0jM7i3kmq01OX+M84nBcSzRNykDjdHSIhbJATTSewmQU3VRrq0LNjTqIN3txQcF8s3pCTWqF0
	27RBwA5YKAxURdEpuIZqazZKLBFvJ3NmMCn0/rZ0nlE9VHCQ=
X-Google-Smtp-Source: AGHT+IGYm5AiCHUG81wKjmGsOZM0oMcXTABlIBjc3hApVwgc3SyeCPuiUQVrAgnYuzKJCyjqVgplKg==
X-Received: by 2002:a17:902:d4c8:b0:24c:ed95:2725 with SMTP id d9443c01a7336-27ed4a06ca7mr77835285ad.4.1758869763210;
        Thu, 25 Sep 2025 23:56:03 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:94ad:363a:4161:464c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed672aa0asm45307415ad.62.2025.09.25.23.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 23:56:02 -0700 (PDT)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: 409411716@gms.tku.edu.tw
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	ceph-devel@vger.kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	home7438072@gmail.com,
	idryomov@gmail.com,
	jaegeuk@kernel.org,
	kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	sagi@grimberg.me,
	tytso@mit.edu,
	visitorckw@gmail.com,
	xiubli@redhat.com
Subject: [PATCH v3 2/6] lib/base64: Optimize base64_decode() with reverse lookup tables
Date: Fri, 26 Sep 2025 14:55:56 +0800
Message-Id: <20250926065556.14250-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
References: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kuan-Wei Chiu <visitorckw@gmail.com>

Replace the use of strchr() in base64_decode() with precomputed reverse
lookup tables for each variant. This avoids repeated string scans and
improves performance. Use -1 in the tables to mark invalid characters.

Decode:
  64B   ~1530ns  ->  ~75ns    (~20.4x)
  1KB  ~27726ns  -> ~1165ns   (~23.8x)

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
---
 lib/base64.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 61 insertions(+), 5 deletions(-)

diff --git a/lib/base64.c b/lib/base64.c
index 1af557785..b20fdf168 100644
--- a/lib/base64.c
+++ b/lib/base64.c
@@ -21,6 +21,63 @@ static const char base64_tables[][65] = {
 	[BASE64_IMAP] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,",
 };
 
+static const s8 base64_rev_tables[][256] = {
+	[BASE64_STD] = {
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  -1,  -1,  -1,  63,
+	 52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
+	 15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  -1,
+	 -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
+	 41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	},
+	[BASE64_URLSAFE] = {
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  -1,  -1,
+	 52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
+	 15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  63,
+	 -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
+	 41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	},
+	[BASE64_IMAP] = {
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  63,  -1,  -1,  -1,
+	 52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
+	 15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  -1,
+	 -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
+	 41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
+	},
+};
+
 /**
  * base64_encode() - Base64-encode some binary data
  * @src: the binary data to encode
@@ -82,11 +139,9 @@ int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base6
 	int bits = 0;
 	int i;
 	u8 *bp = dst;
-	const char *base64_table = base64_tables[variant];
+	s8 ch;
 
 	for (i = 0; i < srclen; i++) {
-		const char *p = strchr(base64_table, src[i]);
-
 		if (src[i] == '=') {
 			ac = (ac << 6);
 			bits += 6;
@@ -94,9 +149,10 @@ int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base6
 				bits -= 8;
 			continue;
 		}
-		if (p == NULL || src[i] == 0)
+		ch = base64_rev_tables[variant][(u8)src[i]];
+		if (ch == -1)
 			return -1;
-		ac = (ac << 6) | (p - base64_table);
+		ac = (ac << 6) | ch;
 		bits += 6;
 		if (bits >= 8) {
 			bits -= 8;
-- 
2.34.1



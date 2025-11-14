Return-Path: <ceph-devel+bounces-4063-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8929EC5B728
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Nov 2025 07:01:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6304F3BAD2D
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Nov 2025 06:01:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82D9C2DC762;
	Fri, 14 Nov 2025 06:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="zwYw6QwR"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504432DC77A
	for <ceph-devel@vger.kernel.org>; Fri, 14 Nov 2025 06:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763100102; cv=none; b=aTxbbmSc+b97nBH2cieq2Nseq2pkoyJ9KhSMjl6WYmInTBcDgU5vDWu3AjEx+ZyN20JfC5ldc5xk1X6Rs8oeb/k5KJ8dn/jMKqouNVj4AUe9B/3h8WBO9X4IynaHr4+Hb7U9a2wukpT8nVQ5zjjk6geK7di6qs5v63Eze8GYZjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763100102; c=relaxed/simple;
	bh=iA2hBVRXx0YemEHPsh/s0OtYYJaZyVmkN06w/iID+7o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nrzuWv6sgsdqLhGI1iceh6LUPKWKZEdQj0p8w3VsYp8FCSTtNa49SAXnfuD9fQvy8GblqvGWvU/li79uw5rffUXhthU+we8Qj1wvg71WC7jrGU67zHU7rZe/pS5lV1WKjUvCzyIau1+5nYxMGG9qLGT+L6R8q8BJRe8v5OrQ/Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=zwYw6QwR; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-343774bd9b4so1495584a91.2
        for <ceph-devel@vger.kernel.org>; Thu, 13 Nov 2025 22:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1763100099; x=1763704899; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q1IGQOBRzs6BjZdUR3pYUPttP+jjYEqCfWUHv2cldxw=;
        b=zwYw6QwRYAwXI680XRuJ38OjVjcTMeqnL8auGq2mlbqmeA3/gIizUM33plONkv51Ci
         txAE8GQsG/411x/ag4LqvXqCusUJnw39g2V848xBJd+N0pquhbBV+L59jK3vNSaQzGz2
         TAsv8Nopkd3dyezbxEswK9qJdyGrFQYDC78bCElHYRmDj8aymsXk7ZzvV8ciGptILcDs
         WYt3TIu6j20WnpM/HLh3GvkhLPjBzCxTuN9Apsbl6B6QkmRVVkM4m306SzLrWijnFvTa
         c9JSqXtbsqOp+WSxVpTj+UvdIvhn0bXRy5mQO7IuvUYVhy32QdxCMAx282BhM095yA+U
         35rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763100099; x=1763704899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q1IGQOBRzs6BjZdUR3pYUPttP+jjYEqCfWUHv2cldxw=;
        b=MM3S6zlJezb/zi6WtXjnxmrjzGNjQy220KzU1JkfQLDoZnn0ufgDY60RrrU4rprlsh
         xirkU6LaF7FGG5eCcLJq/z2MKN5pGuHbmfzKqg9sZ7zU+Jj/PaKKnvu4A7omev75vI+v
         dLyhGUQJn6OcXtMTk6WJyzBrYi5U5JKZ+IAKwA9byj5Wyq5cfWRR4sP5BsjMK5EG0/9Y
         3tBlJ9Ad4fg7saYgWPMs0myKl5ohwimqFT50lyC0/wAHx5SuVz/x6nbfNoEOpjQ45sxj
         JocQC57aPy61Ao8uqF2FItWfupPM0JHYBmwis771w5WHhBc19o/qrInd02ARyCrUXckP
         2Feg==
X-Forwarded-Encrypted: i=1; AJvYcCVdwvyfXR136cmMi7JxqWScy6BiagCH8G6MKuZ/OFJan0b6GF/yJ5ohru0TuouCBtf1t3XkMkJTFsva@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb8n9LNwSW/mTvMj7TftV7rTsKn27TTtV84t/w6pjMfB0xcsUA
	v91ntDj53yQLSMhgZQD6uRjUn7/p7HeN6CS6E/cYqdOnQUvVL0oW70o78fSE6MUdvEmKaCcri6d
	ygKuR
X-Gm-Gg: ASbGnctoI5E1oKufdmY16thNj2J3FwPUX4tDkxYul2HudLWt2LA9U0nppnicbrFdOGl
	Gagd1erc0UsNBALIm493p4aP8gApuwkQ3o2u1aII5xs0rbEKhG73kr1nmhV+93m7tYafUhoOg6v
	yU9Y8aMXhpFEksZlBj5YMIMN0J/S44NhcBuHGIpjUZRSykxPaINzYI2/4G0ncz9pkwl4ttsZs0f
	yBHbkVJPkzWXAHCrOsKT8vMjDrJyMPDBmHk9T3V2jk9bxVbuapxykJNFL4a77p6mrZjCPBeUY0V
	sy+TzbfoJZMeMH8GLPjRVpSe4uRRRXem3oC4Ni6yZotpsWmLIHIVmCLyx0wHAbELF0FambkLYac
	ceXkZdq5ZVwR8cFeXoodG2sQFcyeSrAgKQShorrNV335jyxQIAsn18tVrGC+FfgCk8LOuw3KlXY
	LebeK4RgGoIrIUpDUJE/y3Bzjd
X-Google-Smtp-Source: AGHT+IGm/DcFCjii9Cj0HeKdnayirMai9hbtcC7DKvoxz9MTk6adf+dWGrkM2fl+VogccyRz+p4CTA==
X-Received: by 2002:a17:90b:3b4b:b0:343:a631:28a8 with SMTP id 98e67ed59e1d1-343fa754b6emr2387408a91.37.1763100098951;
        Thu, 13 Nov 2025 22:01:38 -0800 (PST)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:22d2:323c:497d:adbd])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-343ed55564dsm4354199a91.13.2025.11.13.22.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 22:01:38 -0800 (PST)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: 409411716@gms.tku.edu.tw
Cc: akpm@linux-foundation.org,
	andriy.shevchenko@intel.com,
	axboe@kernel.dk,
	ceph-devel@vger.kernel.org,
	david.laight.linux@gmail.com,
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
Subject: [PATCH v5 3/6] lib/base64: rework encode/decode for speed and stricter validation
Date: Fri, 14 Nov 2025 14:01:32 +0800
Message-Id: <20251114060132.89279-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251114055829.87814-1-409411716@gms.tku.edu.tw>
References: <20251114055829.87814-1-409411716@gms.tku.edu.tw>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The old base64 implementation relied on a bit-accumulator loop, which was
slow for larger inputs and too permissive in validation. It would accept
extra '=', missing '=', or even '=' appearing in the middle of the input,
allowing malformed strings to pass. This patch reworks the internals to
improve performance and enforce stricter validation.

Changes:
 - Encoder:
   * Process input in 3-byte blocks, mapping 24 bits into four 6-bit
     symbols, avoiding bit-by-bit shifting and reducing loop iterations.
   * Handle the final 1-2 leftover bytes explicitly and emit '=' only when
     requested.
 - Decoder:
   * Based on the reverse lookup tables from the previous patch, decode
     input in 4-character groups.
   * Each group is looked up directly, converted into numeric values, and
     combined into 3 output bytes.
   * Explicitly handle padded and unpadded forms:
      - With padding: input length must be a multiple of 4, and '=' is
        allowed only in the last two positions. Reject stray or early '='.
      - Without padding: validate tail lengths (2 or 3 chars) and require
        unused low bits to be zero.
   * Removed the bit-accumulator style loop to reduce loop iterations.

Performance (x86_64, Intel Core i7-10700 @ 2.90GHz, avg over 1000 runs,
KUnit):

Encode:
  64B   ~90ns   -> ~32ns   (~2.8x)
  1KB  ~1332ns  -> ~510ns  (~2.6x)

Decode:
  64B  ~1530ns  -> ~35ns   (~43.7x)
  1KB ~27726ns  -> ~530ns  (~52.3x)

Co-developed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Co-developed-by: Yu-Sheng Huang <home7438072@gmail.com>
Signed-off-by: Yu-Sheng Huang <home7438072@gmail.com>
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
---
 lib/base64.c | 109 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 68 insertions(+), 41 deletions(-)

diff --git a/lib/base64.c b/lib/base64.c
index 9d1074bb821c..1a6d8fe37eda 100644
--- a/lib/base64.c
+++ b/lib/base64.c
@@ -79,28 +79,38 @@ static const s8 base64_rev_maps[][256] = {
 int base64_encode(const u8 *src, int srclen, char *dst, bool padding, enum base64_variant variant)
 {
 	u32 ac = 0;
-	int bits = 0;
-	int i;
 	char *cp = dst;
 	const char *base64_table = base64_tables[variant];
 
-	for (i = 0; i < srclen; i++) {
-		ac = (ac << 8) | src[i];
-		bits += 8;
-		do {
-			bits -= 6;
-			*cp++ = base64_table[(ac >> bits) & 0x3f];
-		} while (bits >= 6);
-	}
-	if (bits) {
-		*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
-		bits -= 6;
+	while (srclen >= 3) {
+		ac = (u32)src[0] << 16 | (u32)src[1] << 8 | (u32)src[2];
+		*cp++ = base64_table[ac >> 18];
+		*cp++ = base64_table[(ac >> 12) & 0x3f];
+		*cp++ = base64_table[(ac >> 6) & 0x3f];
+		*cp++ = base64_table[ac & 0x3f];
+
+		src += 3;
+		srclen -= 3;
 	}
-	if (padding) {
-		while (bits < 0) {
+
+	switch (srclen) {
+	case 2:
+		ac = (u32)src[0] << 16 | (u32)src[1] << 8;
+		*cp++ = base64_table[ac >> 18];
+		*cp++ = base64_table[(ac >> 12) & 0x3f];
+		*cp++ = base64_table[(ac >> 6) & 0x3f];
+		if (padding)
+			*cp++ = '=';
+		break;
+	case 1:
+		ac = (u32)src[0] << 16;
+		*cp++ = base64_table[ac >> 18];
+		*cp++ = base64_table[(ac >> 12) & 0x3f];
+		if (padding) {
+			*cp++ = '=';
 			*cp++ = '=';
-			bits += 2;
 		}
+		break;
 	}
 	return cp - dst;
 }
@@ -116,41 +126,58 @@ EXPORT_SYMBOL_GPL(base64_encode);
  *
  * Decodes a string using the selected Base64 variant.
  *
- * This implementation hasn't been optimized for performance.
- *
  * Return: the length of the resulting decoded binary data in bytes,
  *	   or -1 if the string isn't a valid Base64 string.
  */
 int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base64_variant variant)
 {
-	u32 ac = 0;
-	int bits = 0;
-	int i;
 	u8 *bp = dst;
-	s8 ch;
+	s8 input[4];
+	s32 val;
+	const u8 *s = (const u8 *)src;
+	const s8 *base64_rev_tables = base64_rev_maps[variant];
 
-	for (i = 0; i < srclen; i++) {
-		if (padding) {
-			if (src[i] == '=') {
-				ac = (ac << 6);
-				bits += 6;
-				if (bits >= 8)
-					bits -= 8;
-				continue;
-			}
-		}
-		ch = base64_rev_maps[variant][(u8)src[i]];
-		if (ch == -1)
-			return -1;
-		ac = (ac << 6) | ch;
-		bits += 6;
-		if (bits >= 8) {
-			bits -= 8;
-			*bp++ = (u8)(ac >> bits);
+	while (srclen >= 4) {
+		input[0] = base64_rev_tables[s[0]];
+		input[1] = base64_rev_tables[s[1]];
+		input[2] = base64_rev_tables[s[2]];
+		input[3] = base64_rev_tables[s[3]];
+
+		val = input[0] << 18 | input[1] << 12 | input[2] << 6 | input[3];
+
+		if (unlikely(val < 0)) {
+			if (!padding || srclen != 4 || s[3] != '=')
+				return -1;
+			padding = 0;
+			srclen = s[2] == '=' ? 2 : 3;
+			break;
 		}
+
+		*bp++ = val >> 16;
+		*bp++ = val >> 8;
+		*bp++ = val;
+
+		s += 4;
+		srclen -= 4;
 	}
-	if (ac & ((1 << bits) - 1))
+
+	if (likely(!srclen))
+		return bp - dst;
+	if (padding || srclen == 1)
 		return -1;
+
+	val = (base64_rev_tables[s[0]] << 12) | (base64_rev_tables[s[1]] << 6);
+	*bp++ = val >> 10;
+
+	if (srclen == 2) {
+		if (val & 0x800003ff)
+			return -1;
+	} else {
+		val |= base64_rev_tables[s[2]];
+		if (val & 0x80000003)
+			return -1;
+		*bp++ = val >> 2;
+	}
 	return bp - dst;
 }
 EXPORT_SYMBOL_GPL(base64_decode);
-- 
2.34.1



Return-Path: <ceph-devel+bounces-3891-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D2F5C19A9A
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Oct 2025 11:22:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E68846290C
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Oct 2025 10:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCD022FD7D2;
	Wed, 29 Oct 2025 10:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="Y7jyWP2w"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D323F2FDC4E
	for <ceph-devel@vger.kernel.org>; Wed, 29 Oct 2025 10:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733269; cv=none; b=Jo23rEslU+CD1+dM7NkbUhETpD6Mk8P8HGfcn85aLulTQ3plWge0IszWawEhfOPkgzOuq6RDwH6ubN48GMk7dDFudvATBYOZKtPlPjq5xddCD1hBZsF2PQtMMuck9rHm6D6AIyF73V6KQB4mBQgvL1ve9n9F9Ry9QnQzf4Z6j70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733269; c=relaxed/simple;
	bh=dY4q8YkbiAgjzKiEsiASrXojI4Al4U1XdOPWUwH7wwg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Sy5OQki7om3yoojHwIIW+xv0evGgF53o9OpMuAGu8SqBUw9QzYc2oRHGCG3SjqySD07O7nwnSIob6RVTplVguOW+d5U6uM2mfkRBPHIcDO2/U2/OeeLhtFfm6R5gWxvdfTVxFm6ogmmXbG+Cz5VW6HHChaZEOwHOCmimMT/7yLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=Y7jyWP2w; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7a23208a0c2so5466102b3a.0
        for <ceph-devel@vger.kernel.org>; Wed, 29 Oct 2025 03:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1761733267; x=1762338067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HbulqRf/JzdfAl/dtv+qftIvyvV8wiDVdKN2RHYy4TQ=;
        b=Y7jyWP2w71F6U7E40iH6TwrqZJ9SpKzBaiTTDR7tz0WgNCy58k6NyUs2mNgWEQH4qD
         q1pnSengwQ+QSnRFJmx5YJ1J1sw8Ur2c1JxvEHxq/8XeclgO/hgsdtu/8jwm5HYa7jT1
         CTHTSGpK3N9jwJWZbzXySdpqKxPvHN5y72i8PMQP9d7UkOkdm8ofpahtrLQH4A8yv/pL
         FUecIMEncs9gs+WDZQVcpZIBT7VZNkxdM8Dqk7jT0xmnlwraNIqNEhUCMluU28ZTYpro
         ilcIoAUR+IE+Ycex3wcdBrccs3q2V00N2Q4qBYp7R4a4PZEERQpfztD0LKxoxGwWdzz8
         2noA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761733267; x=1762338067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HbulqRf/JzdfAl/dtv+qftIvyvV8wiDVdKN2RHYy4TQ=;
        b=u1GnGs3MUCq7/ZBnE6dZAGif9VBgC4gxP2bE9h/lb5DbuL2lOv0fKFBXcDfHDDnc/v
         BG7wsbGsC8h/xqjdkmAb5K40TbYvv7AG/UwBZhLyVoCfNLFZ4EKQCKcPebBh8LrJQGp1
         1BIUnw+mRw37cV/hvjVzvhOMMWHgSF2nC2hKXsBoAWRdfvWLY42P+PouM/jhx9MESVAt
         fKlWPuKSD9cydWZVSWbn9RFuMoo7AxW2wlEF+Fsoj55LvmRL/fAQLKwjXU9O3J+fPfC5
         92rqFxRFzwHKmZV125SBTFFcVYWxCaV2hoOVsdpZ0YZIZ+tamFpRHMYsr71ZhWA00+kX
         ILWg==
X-Forwarded-Encrypted: i=1; AJvYcCXBuSxdjaOTqpZc/BAa4HA08kd8Wtbe4K8MlsHcXuU4zGR3CJdAVpZTFJfDnfQn5cNp38XcJvvWP5H5@vger.kernel.org
X-Gm-Message-State: AOJu0YyHEC+UVFqF7f40j6nILwJWJp8LyA+iuXSefD63luI524YG/YvA
	IioG7QoQV1Qt+h3u2X93lkdqUu3BLUPwCovpsJrW0EqlQuET1aKooPqD1WIoCSeQWtA=
X-Gm-Gg: ASbGnctL6D5bqnSnjB3hA1KZ/rpc7vbVs3dld0AR6mFRT7ZDkexMb5ALPi0aystDGHJ
	rA596DHyMvU0hx302BKbi3rbRFp1oKM6DogOXn/rHU/2/7KizcJEW/+yl6xg+NePN2tNY9S2FfF
	B0/sKdB5eh4AD1P7vw0YO35r7NYjV7xL2Qk7tB19S7oGkshOlHGbqCEzYk2Uzojtirw14v9GdNq
	JsKmE852Dk8dmeCj6jRtxa33TqglIsB5pcKYmdNwTtYHjhC047HetU0hvOmqlq8UyvgNX3cZ7ft
	GB4SWKfElGM4XIVH1QRG65Vo7SpnpSUVP5FQkwfgbVIj0yMJwkc3pRQk8Pr7i6Y08CF2vVk1Cqj
	EHSGmG2WteRQMlgW2bdSv2o0RfuueN6bDcCtnXRK3j+LI1DEvD3bVrlL4aV56Aj7QTSg/5qXKCG
	plm9LQN6jxs/2agisN5krajz+t
X-Google-Smtp-Source: AGHT+IHL0MICP1K9H4r8j+kOSzogqVuiVQjNGs4tt84n15SY6d/K/p8SfQsZ4RZjWKksxhhmDOquvA==
X-Received: by 2002:a05:6a00:2da5:b0:77f:4f3f:bfda with SMTP id d2e1a72fcca58-7a4e53f14dcmr2854006b3a.31.1761733267109;
        Wed, 29 Oct 2025 03:21:07 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:3fc9:8c3c:5030:1b20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a414034661sm14888261b3a.26.2025.10.29.03.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 03:21:06 -0700 (PDT)
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
Subject: [PATCH v4 3/6] lib/base64: rework encode/decode for speed and stricter validation
Date: Wed, 29 Oct 2025 18:21:00 +0800
Message-Id: <20251029102100.543446-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
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
 lib/base64.c | 110 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 69 insertions(+), 41 deletions(-)

diff --git a/lib/base64.c b/lib/base64.c
index 8a0d28908..bcdbd411d 100644
--- a/lib/base64.c
+++ b/lib/base64.c
@@ -51,28 +51,38 @@ static const s8 base64_rev_maps[][256] = {
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
@@ -88,41 +98,59 @@ EXPORT_SYMBOL_GPL(base64_encode);
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
+
-- 
2.34.1



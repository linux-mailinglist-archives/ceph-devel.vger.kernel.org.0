Return-Path: <ceph-devel+bounces-4062-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 28AB0C5B731
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Nov 2025 07:02:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F1C5A4E995D
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Nov 2025 06:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07BF62DAFCA;
	Fri, 14 Nov 2025 06:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="cMVPcvCX"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1691C20F08D
	for <ceph-devel@vger.kernel.org>; Fri, 14 Nov 2025 06:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763100076; cv=none; b=H2hvSwQ7UVCGiKFC9jQEDvHp4GO9vBE5K4Y5G6PBVx2MnrfXNih+SscIYopF0ReZxKWliq3eTkj3O7ULZxRm6F4IgDLj8RQfUpWP/4My1Qty3MVI4/wX/QJICIc4tz87YF1qtdOUzvH9R8uvfuuQJcdtz84xpEiiG8XAdh55VF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763100076; c=relaxed/simple;
	bh=ebfhLZNEl5pO72lYrO9Xn1y4JHTAnC4DTnDbTXJruzM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UCcYwZbgMcbSFCtw8ZlLard17whONxR/XlQ0lcqwW3FrvKa0ZR/AqSY3CTuzvbYf6Ua7q9Eun7Uf2MWE8stALIDdFkrQ1YoNqNiYAzJFDr0v9h1KTVYjU9R5iPQ0glD4d8sOxNqQhI+Ji8kDanfZnW+oSdQBiquoA6oQG3cF/bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=cMVPcvCX; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7a435a3fc57so1620648b3a.1
        for <ceph-devel@vger.kernel.org>; Thu, 13 Nov 2025 22:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1763100074; x=1763704874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lWS11xsgkFrNsAXlptIvYpGHMFNUcuv3AuLz0xI70Ao=;
        b=cMVPcvCXnMM511FrlzdK+cADV1Q9BS4r9uxsnAa1VKlsZ21c/NSk+17XzgOaPoEmy/
         PwWmkqlJ4R5NOGUqUjjgam5heJ3tsMz5JvYrlQDpmVP3tleLwZ1/qa5rx1A04Q8iT4bD
         RbVEt8of6EtSRmz4ZXXtU+BAuBoSYw9GenaPfggwKN7qV/tzknII4JIYRuo6c053WDyn
         IP1/zaIilFE25RErv6XQ9SZh1VOoz11WT5QKXQUjwc4835r/qmSh63+o5FyRaNqAUx6o
         /ZTIElouDRm3r3SNr0ydUGzkqK5Y2L4yj2du4ET5XJVYEfYa3Xdf5xDgXa7t9U8/T/xL
         bUcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763100074; x=1763704874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lWS11xsgkFrNsAXlptIvYpGHMFNUcuv3AuLz0xI70Ao=;
        b=lzQCx1n8nju8KQF5b8p8RbuarIjqrSdgW8fkHBaPmbVK78XWc2yxCrg+vrFhoujAdq
         ZFypLBXfqAVNrV9aJxdVkA+RB9orZrYxI+y16/Sl4XhjVqcuTcBQFBBmXrqqTnNMiqhn
         W9GiHaBF4qmZ83EgpkGNQvH9oIAywHF7liQIhFTtH4OJ8xazFX0eFb6uAAX86zhEtlJS
         U1bpiV1E0uugvWjOPDuJxK/TZ9d/fPCeHCV2vnFSBprdyZA8bippna8WrpIEHHmkUJ+T
         tITcuU8cHlIU2GN7lM56dLWMsTi3OTSxGpRbwK26ze5oWB3zcj2dCdtcoZmq0c8gmg1I
         U7hA==
X-Forwarded-Encrypted: i=1; AJvYcCX0iC5v877gIzOJm54gkaB99wewhGKv+auf48XzJMRF9uJhqVo+r4jSlZjeq+I6y6ZFcynwF1wZsyUK@vger.kernel.org
X-Gm-Message-State: AOJu0YyNH2ldH/PUBtSNOekfqLjD9UHesg+OWVAMCwUMrOJjsBpqV/gG
	1VdgzBvKMonKJ+UAPecHIoxHcwFVTjKNQ4EAd1Ar+YfI1/74TYfROJDpkM16kjEnBoBikZl/5Oe
	ZetN4
X-Gm-Gg: ASbGncuw5JmQ6jR4pkNiOXVpBWmcrHW0fIGiEwXWsgQnEiwTvjBWTClCEXnYNGZ/Y/q
	j86qe0g2LD8kxPO1G6f3IIWuOHXlLz4980VYycXmwVdh1KJdP14NPWPsYmFUqWk89xJ6i1j0OGq
	W9ISd3rxij0W/F5HfX5pGgooLHD4Qt+KHmZV9/UuYSkK+7liQIZTDMWChcNS2YHdqvueogtc1yi
	vsF5v4c5W9VDbCiBQ7Q7H6yc9Y9s2fPOFSOTvHSwBnLHPCh9uD8g2Z6q40Ziq/GCRZTRv66dAMl
	FanbukpgJMjasudWzIKKARbwhhOhVQl4wFSGIJOm0XSrpzkY7O1gFXuNUL4a4HS6b1gsI/L5rQN
	FSUE77axjia0dKNRnRNmmrrf0UnlhxTg2FbiQ/7Km3IPDQPTeKB9/HLQnQ+608/mOAViRR+PomJ
	mYoyDX2QHpgcsX9HMoDjDu9lib6qfOgSeJfYk=
X-Google-Smtp-Source: AGHT+IH5zqaJvOCHGyW2FJR2JlFHMBKlTKF05FN81/22NWKlZaSd+Pgu/afzXFlbWF1Pxh5Ir24tyA==
X-Received: by 2002:a05:6a00:198d:b0:7b8:9d86:6d44 with SMTP id d2e1a72fcca58-7ba3a0be249mr2401481b3a.9.1763100074344;
        Thu, 13 Nov 2025 22:01:14 -0800 (PST)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:22d2:323c:497d:adbd])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b924be368bsm4075198b3a.9.2025.11.13.22.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 22:01:14 -0800 (PST)
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
Subject: [PATCH v5 2/6] lib/base64: Optimize base64_decode() with reverse lookup tables
Date: Fri, 14 Nov 2025 14:01:07 +0800
Message-Id: <20251114060107.89026-1-409411716@gms.tku.edu.tw>
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

From: Kuan-Wei Chiu <visitorckw@gmail.com>

Replace the use of strchr() in base64_decode() with precomputed reverse
lookup tables for each variant. This avoids repeated string scans and
improves performance. Use -1 in the tables to mark invalid characters.

Decode:
  64B   ~1530ns  ->  ~80ns    (~19.1x)
  1KB  ~27726ns  -> ~1239ns   (~22.4x)

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
---
 lib/base64.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 4 deletions(-)

diff --git a/lib/base64.c b/lib/base64.c
index a7c20a8e8e98..9d1074bb821c 100644
--- a/lib/base64.c
+++ b/lib/base64.c
@@ -21,6 +21,49 @@ static const char base64_tables[][65] = {
 	[BASE64_IMAP] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,",
 };
 
+/**
+ * Initialize the base64 reverse mapping for a single character
+ * This macro maps a character to its corresponding base64 value,
+ * returning -1 if the character is invalid.
+ * char 'A'-'Z' maps to 0-25, 'a'-'z' maps to 26-51, '0'-'9' maps to 52-61,
+ * ch_62 maps to 62, ch_63 maps to 63, and other characters return -1
+ */
+#define INIT_1(v, ch_62, ch_63) \
+	[v] = (v) >= 'A' && (v) <= 'Z' ? (v) - 'A' \
+		: (v) >= 'a' && (v) <= 'z' ? (v) - 'a' + 26 \
+		: (v) >= '0' && (v) <= '9' ? (v) - '0' + 52 \
+		: (v) == (ch_62) ? 62 : (v) == (ch_63) ? 63 : -1
+/**
+ * Recursive macros to generate multiple Base64 reverse mapping table entries.
+ * Each macro generates a sequence of entries in the lookup table:
+ * INIT_2 generates 2 entries, INIT_4 generates 4, INIT_8 generates 8, and so on up to INIT_32.
+ */
+#define INIT_2(v, ...) INIT_1(v, __VA_ARGS__), INIT_1((v) + 1, __VA_ARGS__)
+#define INIT_4(v, ...) INIT_2(v, __VA_ARGS__), INIT_2((v) + 2, __VA_ARGS__)
+#define INIT_8(v, ...) INIT_4(v, __VA_ARGS__), INIT_4((v) + 4, __VA_ARGS__)
+#define INIT_16(v, ...) INIT_8(v, __VA_ARGS__), INIT_8((v) + 8, __VA_ARGS__)
+#define INIT_32(v, ...) INIT_16(v, __VA_ARGS__), INIT_16((v) + 16, __VA_ARGS__)
+
+#define BASE64_REV_INIT(ch_62, ch_63) { \
+	[0 ... 0x1f] = -1, \
+	INIT_32(0x20, ch_62, ch_63), \
+	INIT_32(0x40, ch_62, ch_63), \
+	INIT_32(0x60, ch_62, ch_63), \
+	[0x80 ... 0xff] = -1 }
+
+static const s8 base64_rev_maps[][256] = {
+	[BASE64_STD] = BASE64_REV_INIT('+', '/'),
+	[BASE64_URLSAFE] = BASE64_REV_INIT('-', '_'),
+	[BASE64_IMAP] = BASE64_REV_INIT('+', ',')
+};
+
+#undef BASE64_REV_INIT
+#undef INIT_32
+#undef INIT_16
+#undef INIT_8
+#undef INIT_4
+#undef INIT_2
+#undef INIT_1
 /**
  * base64_encode() - Base64-encode some binary data
  * @src: the binary data to encode
@@ -84,10 +127,9 @@ int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base6
 	int bits = 0;
 	int i;
 	u8 *bp = dst;
-	const char *base64_table = base64_tables[variant];
+	s8 ch;
 
 	for (i = 0; i < srclen; i++) {
-		const char *p = strchr(base64_table, src[i]);
 		if (padding) {
 			if (src[i] == '=') {
 				ac = (ac << 6);
@@ -97,9 +139,10 @@ int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base6
 				continue;
 			}
 		}
-		if (p == NULL || src[i] == 0)
+		ch = base64_rev_maps[variant][(u8)src[i]];
+		if (ch == -1)
 			return -1;
-		ac = (ac << 6) | (p - base64_table);
+		ac = (ac << 6) | ch;
 		bits += 6;
 		if (bits >= 8) {
 			bits -= 8;
-- 
2.34.1



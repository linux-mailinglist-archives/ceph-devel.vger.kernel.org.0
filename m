Return-Path: <ceph-devel+bounces-3738-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A964BA294A
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Sep 2025 08:55:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CA661B24AF9
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Sep 2025 06:55:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F1DD27E074;
	Fri, 26 Sep 2025 06:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="ojqeY5vJ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459AB27D784
	for <ceph-devel@vger.kernel.org>; Fri, 26 Sep 2025 06:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758869723; cv=none; b=q5tj/WirTeFWwBs9VWIUrEDwXJ9kA/mXrrg5qF5CeLzWF7dDo/PJTQyI5guxbmklk7dbjLpcnRT3D64gOkNjSwHpdG29v5xPW6yq7pW/151teR1VN4ch0pVHugcOt+U1laoyu7Qz7Vv1WgI5X+uAtJoXQbNWIlZVatKYvniiUC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758869723; c=relaxed/simple;
	bh=aeR0jKC5/gtxKlaD5MnxYFmC8w01kOImtqSZxxRwN6g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JCq0QO/T0dd9CWQqr54CThCrX7+hVpI3aIwkxnJP1jHySzOerwqvGaZzeygPgerSkoUaGbtz3beRVahdtBHXaxTeHHDmKdiMC16LdDquaGCLhyNczZ+xh1hhD2x5S5PbsFsXX420MlPkdcvzITEoX2vAgr3sleNqUgP/VGx48Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=ojqeY5vJ; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b55517e74e3so1875988a12.2
        for <ceph-devel@vger.kernel.org>; Thu, 25 Sep 2025 23:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1758869720; x=1759474520; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vj5UPqG+5RgyX7bCn1GnWx3nhSDF8xeGhtJtpVZ8+PA=;
        b=ojqeY5vJGVrUy2066SXDaV8raKhpMZSwysegw5Yl0pXwi0STOOE574Kgk4r/8OOv0y
         2OosDwp5iGcV1GS58X/KkNfaafyDZoSIQdaRYUBZvHO4yFVCXKlQss33DrOSSlPL3EKb
         zFlNNbct5luuMocyzL+4x7oGGYzOuS+uIrlTCGirmwadB1STmcZk4HCGSgsL2lLlh6+K
         d5S9yq+UTkFwcUk4YiscsPPlbf1PxKwywywEf7wb7R5vWVNwY/Q8unoNP2ugVVt70IX2
         NCdtDKzmdCdM7VgKlKsc7Ljz0LgNElGTj7sqvFECllind2tFL+LEfyxQDS+8Bz1G/iej
         YvcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758869720; x=1759474520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vj5UPqG+5RgyX7bCn1GnWx3nhSDF8xeGhtJtpVZ8+PA=;
        b=i+5yzOnvpSIqSUcXbQTZYfAOQcr5f2K3cb9gxkJktHE971uDmLaU7xvxKWHRkWUS2a
         kqZSbroZmFWkIops3RanQxk/7S+dr1Dgvj87GOvQmGuvqiRAVCmcVMHkCnQ7bGXn5wRe
         W4ht32tKKTnrp+01yhjBqc/Bbnw428k7E4i1Rail8w+7l424HV22IHMmrwrWL1JJ5gdc
         D2f6pyLhs9M57PrJRfnhGm5JKSc9lSK0LIFFF+BedkpxOl6w8m9lXTqUj8HOgS6+ImHZ
         vy0RTTcLREP1LqqMBzCzRwgqlwHwrb98KJPNULCvKCYoPsR61b1BW2qy8/WIpglY5Mze
         LZqA==
X-Forwarded-Encrypted: i=1; AJvYcCXOhZilUeUgD3h0cGT8impaFfsPJ55wAPnXTk0erCYYomxWkfdeWgFTc9WVr8FR9FE+rtBKz1vXbzFP@vger.kernel.org
X-Gm-Message-State: AOJu0YzX3/2G4bANgHCMiVdaWiIhx4LQ8aj5XZJDFso8ctHcYdfYVkD3
	hLaB9TIQ7d2PmSMi40XKUAXj4VFABIrnNiRona6YbEzjjTCeQnxiQRtQxHSeIoxu1c8=
X-Gm-Gg: ASbGncvnpQ7BuO5GAwReDiW6HS8TApEbH5pn/neFa8BdHeueaGx0zTlsV+pGXPxnlD4
	lCUiQSo5qmi2vrIhMixF34nnEauGfErw7znLs38AL3vVIMqhoKeeHYiP+SMUmJAhSucQFDZSp5x
	S1tqhNnKk77xNav+gTtrA7JsDcMJUd/QHB5TGm4LfjFm1O0VQRv8wbkEOwo7y5fHxJQVxWPPKuQ
	XZALEsibkYnOcoYmwcLQdeEO+vuWoK1mch71gchXn4tHDBOP8kyJynw6pEgpjsxzxcFYOEnDyEW
	3LGQqFYijfGX8biY9JEuLHx9U2Z/gzyjmktYR67EUp/Ug75UH3SuYnEpswDo65e/dzRovmSJEPi
	zM/fX57UmeUJG43efctOTzF8L4V2fQU4w7M2hvH7YmO8TRXg=
X-Google-Smtp-Source: AGHT+IEkWnB3Y/bobVLXTDCV7iCFw6lqnV0G3iUe38ErBh+GUhNpr3gTNCP4/CRqqoUyTcF+cvJjXA==
X-Received: by 2002:a17:902:f647:b0:269:a8a8:4029 with SMTP id d9443c01a7336-27ed49df2c1mr81059935ad.5.1758869720526;
        Thu, 25 Sep 2025 23:55:20 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:94ad:363a:4161:464c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6882227sm44681455ad.82.2025.09.25.23.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 23:55:19 -0700 (PDT)
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
Subject: [PATCH v3 1/6] lib/base64: Add support for multiple variants
Date: Fri, 26 Sep 2025 14:55:12 +0800
Message-Id: <20250926065512.13881-1-409411716@gms.tku.edu.tw>
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

Extend the base64 API to support multiple variants (standard, URL-safe,
and IMAP) as defined in RFC 4648 and RFC 3501. The API now takes a
variant parameter and an option to control padding. Update NVMe auth
code to use the new interface with BASE64_STD.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
---
 drivers/nvme/common/auth.c |  4 ++--
 include/linux/base64.h     | 10 ++++++++--
 lib/base64.c               | 39 ++++++++++++++++++++++----------------
 3 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index 91e273b89..5fecb53cb 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -178,7 +178,7 @@ struct nvme_dhchap_key *nvme_auth_extract_key(unsigned char *secret,
 	if (!key)
 		return ERR_PTR(-ENOMEM);
 
-	key_len = base64_decode(secret, allocated_len, key->key);
+	key_len = base64_decode(secret, allocated_len, key->key, true, BASE64_STD);
 	if (key_len < 0) {
 		pr_debug("base64 key decoding error %d\n",
 			 key_len);
@@ -663,7 +663,7 @@ int nvme_auth_generate_digest(u8 hmac_id, u8 *psk, size_t psk_len,
 	if (ret)
 		goto out_free_digest;
 
-	ret = base64_encode(digest, digest_len, enc);
+	ret = base64_encode(digest, digest_len, enc, true, BASE64_STD);
 	if (ret < hmac_len) {
 		ret = -ENOKEY;
 		goto out_free_digest;
diff --git a/include/linux/base64.h b/include/linux/base64.h
index 660d4cb1e..a2c6c9222 100644
--- a/include/linux/base64.h
+++ b/include/linux/base64.h
@@ -8,9 +8,15 @@
 
 #include <linux/types.h>
 
+enum base64_variant {
+	BASE64_STD,       /* RFC 4648 (standard) */
+	BASE64_URLSAFE,   /* RFC 4648 (base64url) */
+	BASE64_IMAP,      /* RFC 3501 */
+};
+
 #define BASE64_CHARS(nbytes)   DIV_ROUND_UP((nbytes) * 4, 3)
 
-int base64_encode(const u8 *src, int len, char *dst);
-int base64_decode(const char *src, int len, u8 *dst);
+int base64_encode(const u8 *src, int len, char *dst, bool padding, enum base64_variant variant);
+int base64_decode(const char *src, int len, u8 *dst, bool padding, enum base64_variant variant);
 
 #endif /* _LINUX_BASE64_H */
diff --git a/lib/base64.c b/lib/base64.c
index b736a7a43..1af557785 100644
--- a/lib/base64.c
+++ b/lib/base64.c
@@ -1,12 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * base64.c - RFC4648-compliant base64 encoding
+ * base64.c - Base64 with support for multiple variants
  *
  * Copyright (c) 2020 Hannes Reinecke, SUSE
  *
  * Based on the base64url routines from fs/crypto/fname.c
- * (which are using the URL-safe base64 encoding),
- * modified to use the standard coding table from RFC4648 section 4.
+ * (which are using the URL-safe Base64 encoding),
+ * modified to support multiple Base64 variants.
  */
 
 #include <linux/kernel.h>
@@ -15,26 +15,31 @@
 #include <linux/string.h>
 #include <linux/base64.h>
 
-static const char base64_table[65] =
-	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
+static const char base64_tables[][65] = {
+	[BASE64_STD] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
+	[BASE64_URLSAFE] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_",
+	[BASE64_IMAP] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,",
+};
 
 /**
- * base64_encode() - base64-encode some binary data
+ * base64_encode() - Base64-encode some binary data
  * @src: the binary data to encode
  * @srclen: the length of @src in bytes
- * @dst: (output) the base64-encoded string.  Not NUL-terminated.
+ * @dst: (output) the Base64-encoded string.  Not NUL-terminated.
+ * @padding: whether to append '=' padding characters
+ * @variant: which base64 variant to use
  *
- * Encodes data using base64 encoding, i.e. the "Base 64 Encoding" specified
- * by RFC 4648, including the  '='-padding.
+ * Encodes data using the selected Base64 variant.
  *
- * Return: the length of the resulting base64-encoded string in bytes.
+ * Return: the length of the resulting Base64-encoded string in bytes.
  */
-int base64_encode(const u8 *src, int srclen, char *dst)
+int base64_encode(const u8 *src, int srclen, char *dst, bool padding, enum base64_variant variant)
 {
 	u32 ac = 0;
 	int bits = 0;
 	int i;
 	char *cp = dst;
+	const char *base64_table = base64_tables[variant];
 
 	for (i = 0; i < srclen; i++) {
 		ac = (ac << 8) | src[i];
@@ -57,25 +62,27 @@ int base64_encode(const u8 *src, int srclen, char *dst)
 EXPORT_SYMBOL_GPL(base64_encode);
 
 /**
- * base64_decode() - base64-decode a string
+ * base64_decode() - Base64-decode a string
  * @src: the string to decode.  Doesn't need to be NUL-terminated.
  * @srclen: the length of @src in bytes
  * @dst: (output) the decoded binary data
+ * @padding: whether to append '=' padding characters
+ * @variant: which base64 variant to use
  *
- * Decodes a string using base64 encoding, i.e. the "Base 64 Encoding"
- * specified by RFC 4648, including the  '='-padding.
+ * Decodes a string using the selected Base64 variant.
  *
  * This implementation hasn't been optimized for performance.
  *
  * Return: the length of the resulting decoded binary data in bytes,
- *	   or -1 if the string isn't a valid base64 string.
+ *	   or -1 if the string isn't a valid Base64 string.
  */
-int base64_decode(const char *src, int srclen, u8 *dst)
+int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base64_variant variant)
 {
 	u32 ac = 0;
 	int bits = 0;
 	int i;
 	u8 *bp = dst;
+	const char *base64_table = base64_tables[variant];
 
 	for (i = 0; i < srclen; i++) {
 		const char *p = strchr(base64_table, src[i]);
-- 
2.34.1



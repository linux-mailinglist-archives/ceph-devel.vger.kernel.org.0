Return-Path: <ceph-devel+bounces-3890-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01743C19A6A
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Oct 2025 11:21:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EE594628D8
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Oct 2025 10:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411762F7AB0;
	Wed, 29 Oct 2025 10:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="AB5iWV8n"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597432FB977
	for <ceph-devel@vger.kernel.org>; Wed, 29 Oct 2025 10:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733245; cv=none; b=XWH38YcJIgxI9YzS1CPjLmZXXnq4DaxcFzPQXAj8/RpViSa59EcJsykRPrRYPm2sPeEDaqtLDL1JFHx2sGjYpOg9UWHT0HPjUu7btoNAfGR+3ig21oufdcldhoPz8quCBggiTQ+Q2sDNP9SZ9QNaKa7VaHLPzEHo3BWHPAOMLPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733245; c=relaxed/simple;
	bh=TIf3na/elRX8csqXIacwGrcO6olD5UumqtY8yMupiVY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UrewnIzDU7HlisJd4Tlqx1aYCemdU6ynGJKkamwXRKO/MSRZfz1DM6A56dvU4gQ0vYlittbYgCjXoqhhDCEfzXcA7s1E9d5x/mQMOC4+U2hb3nc4rESwdqc0KC3Ly6mGx3ouPmlSyom2nfWeYPrbOmRnzlHM6+47HaouwaNjOFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=AB5iWV8n; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-34003f73a05so978786a91.1
        for <ceph-devel@vger.kernel.org>; Wed, 29 Oct 2025 03:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1761733242; x=1762338042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=muPZR2EFB0oSgf5LU8hlA8LwOzFVPmAYEO5+iKyULIY=;
        b=AB5iWV8nKXz1+ifx388tW7elioLcbfE3N9OLL7GPJtzIWYW9Nr3e8AJ8AbQ9TP282Z
         w18u7b3/HCIatZdyLD4F82a2GHOdMT2wPBddmAdD6DU/P+3K9AwxCHbezmLfuxbWQP7a
         gAdwDnF+sLj5pw/SBQ+adMBFOLwPuE5tH6jUwiv0WrM5JQXf30foUb5+TLl0k0/1273w
         I3GUBS/MjY7bj4ucs0e/XhZFShe9F9biOt18MDgt01aahdrcEnjLK3ZvQo+gcK5lPXEY
         Df6eWmNUnUpxdpDLI8GczKLQHngrcAKqVB6jF/02wxmYxNhAFjgkslq0YNJbVmc5fW/B
         1Z7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761733242; x=1762338042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=muPZR2EFB0oSgf5LU8hlA8LwOzFVPmAYEO5+iKyULIY=;
        b=ogPwrGVEpM6+hxs+UcXj8EsuQCeJKAWCltgo3dfPmtk0grlxgUb/3Odt5wIE0pF5Zh
         OinuNTgK19p7i3B5AHn7MBVCNtMrL/8QORj/Z5KTszC2aRrgXRLeIfNgX8yIvc3iG8lP
         ZNRX8oAzGWh1irRAbtWJHZl2YniAssNvU6FlbkvZNrocpEeytvKcywGmzjS8JP0CGgIk
         wMt5YgNypCdSyI4oh/WTI8nS7iNW5GZ1nttbPgy+BMkQUBqFY88plzCfUlVA9S1N044K
         WNRrwzYkW2MWVybqTYIRzZMdD1QPy1MY/d66d3qzoKmt2zczhZbkIJ4Cwuiw4KfsrwOy
         qXnA==
X-Forwarded-Encrypted: i=1; AJvYcCU227OXjBwCyV5orcdbeLXGGJquWo+YddjZLJOBP2Ja+diD2n1QTIbemFGZAxviu4d93qt2sKTlF5CW@vger.kernel.org
X-Gm-Message-State: AOJu0YyonPF2Ru8C4QILjo7Eacl1vaNZ1B1A1/GzhK5wD3ZkG6LdB5LT
	7pxvm1dr13iaUkDeyAx880jkem9+2o6uYbqvMwrANgXjHB//CU2x/u0QvZOwLq6V84Q=
X-Gm-Gg: ASbGncsg/cG84VgZOBBnn2W6yX0nIVj9y6CjMh5530WWiu5a7Eaqf1lsOHih4fXQ0MH
	8cuHvG69dsqnmyii/HCE7Xwc0GslturQoxeB7A435I9d/pNTQ2TENA7ySAJMxfoqHLTDgFQwmpe
	lKuSMQAC/cUD/mwzHHSLPNtJ2uV883YvP93cvb+EGHuBSKuYMnaIYZKSPB75gdekaNz4iLYH/BN
	sqk1TZM+QPQHQGMBicV/ksNHfdVceTT+x6LWZmZ//P0+tGnPaFsft/D5fsp6tlHKWZuoxYmSE2+
	W0zQ+h8bEhdnoFh+UYMdjawsEi17GuRkfvVajk/ne4eg4IRK3QLhbt2AlqtCu825nviqa8N9WjO
	A8Lvi4Gp4WJ7Gj4XAdZolKZI01ZcmdwyD/kYZcUIxeuf8rR69vsHvUysmIb3EOWnxstLJalG6ZN
	n0NEtYrpgkEDM1Va+o5tWNGIrZ
X-Google-Smtp-Source: AGHT+IFrDmoqflAy+Vvmh8+Eo6wG8f+LzM2aUxs5UOYfH1wyy2050pHKCKkM65jstFpCS2r3tIFSzg==
X-Received: by 2002:a17:90a:d448:b0:33b:dff1:5f44 with SMTP id 98e67ed59e1d1-340286bc834mr7455074a91.6.1761733242563;
        Wed, 29 Oct 2025 03:20:42 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:3fc9:8c3c:5030:1b20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed706449sm15024924a91.2.2025.10.29.03.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 03:20:42 -0700 (PDT)
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
Subject: [PATCH v4 2/6] lib/base64: Optimize base64_decode() with reverse lookup tables
Date: Wed, 29 Oct 2025 18:20:36 +0800
Message-Id: <20251029102036.543227-1-409411716@gms.tku.edu.tw>
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
 lib/base64.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/lib/base64.c b/lib/base64.c
index a7c20a8e8..8a0d28908 100644
--- a/lib/base64.c
+++ b/lib/base64.c
@@ -21,6 +21,21 @@ static const char base64_tables[][65] = {
 	[BASE64_IMAP] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,",
 };
 
+#define BASE64_REV_INIT(ch_62, ch_63) { \
+	[0 ... 255] = -1, \
+	['A'] =  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, \
+		13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, \
+	['a'] = 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, \
+		39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, \
+	['0'] = 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
+	[ch_62] = 62, [ch_63] = 63, \
+}
+
+static const s8 base64_rev_maps[][256] = {
+	[BASE64_STD] = BASE64_REV_INIT('+', '/'),
+	[BASE64_URLSAFE] = BASE64_REV_INIT('-', '_'),
+	[BASE64_IMAP] = BASE64_REV_INIT('+', ',')
+};
 /**
  * base64_encode() - Base64-encode some binary data
  * @src: the binary data to encode
@@ -84,10 +99,9 @@ int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base6
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
@@ -97,9 +111,10 @@ int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base6
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



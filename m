Return-Path: <ceph-devel+bounces-3572-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5881B52A00
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Sep 2025 09:32:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DA23A03404
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Sep 2025 07:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F42B26CE39;
	Thu, 11 Sep 2025 07:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="k50nhQrr"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A031D26D4D4
	for <ceph-devel@vger.kernel.org>; Thu, 11 Sep 2025 07:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757575935; cv=none; b=f0H3WSM15W/TXV7/V8A6yfihvZVIFR/KjGr55Fv9cVWmCrFII/SdfSpegSUf+/TzDO3MqazusSQYlLrs+97TQNPLKPtX3Q3nWdoP5vWhTP5AVPvpw3kqAb3nb3eR0ulD4p8YGE2EiCnATt9S2oDh6eLwsxLWRTlfaFJVGEeNWWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757575935; c=relaxed/simple;
	bh=LvP6xvP6ZpqgZqS6HIHSDKtto3Kcjz+TrfwBMvXJT9k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W132hImWZ3TQmroKXFHWtYMDBz07sOAgnXmxdmF8S7Rop8LHqmJTqhPo31qSIA5YiyMWTPs+OqWlwe14OpseAGGd8XTSGBkL+AuOkirKzgHIqrHMWO9PEVJQm5qwgNt/vW3xL22JEK9BDSIEebM+x+Lnzr8sn7AUD5acSwv+BYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=k50nhQrr; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2570bf6058aso5675045ad.0
        for <ceph-devel@vger.kernel.org>; Thu, 11 Sep 2025 00:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1757575932; x=1758180732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GZBzkNSMlmIkXR7v+DqjmX4bPRcIBLEhcOlgv/ZqaSw=;
        b=k50nhQrrVm3DVAFhHz1sT0VyRdwLo7eagqLRFFGU4M4mvA6a9p+1kvYuozO0W8Z/+t
         zTOVKSZwz9o9oLNiG0oVez/Bx2Kl2h/bzZzDmdcKjuTZ48ioBbv8PDfTmfgn5tdc6Y/F
         4ntLthC4L28Ret5KeFpGiXSckQc0buHrK/9ipCppmkxxaG0xpVKpAfWXUPYOg4SjMY3I
         ZoofkrXmaQbFMtGHquAVFJ2t2VrKf4YoqC8lk95+99dtcHYUQcvdToctMDvl/YsON/Iq
         +93Lu0MvHa0a+ozQ8l4HW0/TROz3KLV+kQAcSgiYBX+dY31vsppu/HE+gOIMl7zjzm5J
         tHyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757575932; x=1758180732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GZBzkNSMlmIkXR7v+DqjmX4bPRcIBLEhcOlgv/ZqaSw=;
        b=cvHpaPyDj+zGGYwitzQkfcAuMr7q1wpvZI5I2P2LwVHk9Qoleklp+m/aK8j7oRScwl
         DdY5LiZjvF0fiFtcmAel3bx/H3BRGp1dUNtqovRbg2Mmey49B7iCLQOBXZ/AnTmWiBGa
         HIbeif/Ax7c9fisrGKnAC3CnTfknMummHttwelIM0IjM/aZVQUNo9xHiG2/2T4JXHtwM
         PB5MaFRIIZhs0hOXIO3jMJ4HPAkCMCMD6s6YQUrzgJqSty7F1ayR7gHhtdOxu0zkHyGy
         90LbRRfQ84xnYs+4JjIFAgOwuPl2jvFXDYXLa1+TPoEmu9TKchH+tiydXPoUEE0mE6oc
         mb1A==
X-Forwarded-Encrypted: i=1; AJvYcCUP/mBe6+MhrplP2Id8zHaQkBIgDFrbfJD+EkXhFxDhcrQmCeWbslW2v2ZcoWw4pP4wQJV6RNu+j7yx@vger.kernel.org
X-Gm-Message-State: AOJu0YwRhGuuegA/43toiiGNyd7iEKZjjUY8TQSZju7bbL5s0b6PoDjF
	GwxNfxtEcM0qd8wCPeqodYZPvgHuHeoLxXYoLozHHRrhEVWMSpZ0dJSzrU0mw94F8Kg=
X-Gm-Gg: ASbGncsX/oY2xVAV900gQZWGML/lIACWfFgayu1xiRCOFL31AfsEiQig8jt5BeoNk59
	6yzzLxYMsdq4gYNiML9JUtODzvg4vUc7ZcVuNemif+mLMVhNeRZF9MfwCJZz1TOaHz7SZfrGklE
	ucGpB9yWLMHRdhBg2btzst+vtKKKgV5ToNJ8PuZyWizjq3MOu9wTi6rE3jXil3Q1zmlmAkEPbuv
	8ZyeN/IiESW06corNeCZWU6QErqve83SaQT+MXfJ/u23+AaS9wIniaQHaKXkhVmXCat5hrhb36e
	bJc99v8B7l+4i2+ri/tfzml6gYkJBrQS20wrHiBCn03Ckh9RpbGvh4NN8Uzepo30UIq7rFyGfEk
	YILEKO2TtM6wcKuK1kUKP0j+ADL8FOQHj0PEDBufIkJlMKtE=
X-Google-Smtp-Source: AGHT+IHb3fEzi2I0Xw68tnhgTa5p89puCkcqtSm1frcG1ldvJKNL158VkcHDDriI2alZgWwrHA5Yrw==
X-Received: by 2002:a17:903:990:b0:242:9be2:f67a with SMTP id d9443c01a7336-2516d52cef2mr261971415ad.11.1757575931815;
        Thu, 11 Sep 2025 00:32:11 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:7811:c085:c184:85be])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c3ab4345csm9667835ad.96.2025.09.11.00.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 00:32:10 -0700 (PDT)
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
Subject: [PATCH v2 1/5] lib/base64: Replace strchr() for better performance
Date: Thu, 11 Sep 2025 15:32:04 +0800
Message-Id: <20250911073204.574742-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kuan-Wei Chiu <visitorckw@gmail.com>

The base64 decoder previously relied on strchr() to locate each
character in the base64 table. In the worst case, this requires
scanning all 64 entries, and even with bitwise tricks or word-sized
comparisons, still needs up to 8 checks.

Introduce a small helper function that maps input characters directly
to their position in the base64 table. This reduces the maximum number
of comparisons to 5, improving decoding efficiency while keeping the
logic straightforward.

Benchmarks on x86_64 (Intel Core i7-10700 @ 2.90GHz, averaged
over 1000 runs, tested with KUnit):

Decode:
 - 64B input: avg ~1530ns -> ~126ns (~12x faster)
 - 1KB input: avg ~27726ns -> ~2003ns (~14x faster)

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
---
 lib/base64.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/lib/base64.c b/lib/base64.c
index b736a7a43..9416bded2 100644
--- a/lib/base64.c
+++ b/lib/base64.c
@@ -18,6 +18,21 @@
 static const char base64_table[65] =
 	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
 
+static inline const char *find_chr(const char *base64_table, char ch)
+{
+	if ('A' <= ch && ch <= 'Z')
+		return base64_table + ch - 'A';
+	if ('a' <= ch && ch <= 'z')
+		return base64_table + 26 + ch - 'a';
+	if ('0' <= ch && ch <= '9')
+		return base64_table + 26 * 2 + ch - '0';
+	if (ch == base64_table[26 * 2 + 10])
+		return base64_table + 26 * 2 + 10;
+	if (ch == base64_table[26 * 2 + 10 + 1])
+		return base64_table + 26 * 2 + 10 + 1;
+	return NULL;
+}
+
 /**
  * base64_encode() - base64-encode some binary data
  * @src: the binary data to encode
@@ -78,7 +93,7 @@ int base64_decode(const char *src, int srclen, u8 *dst)
 	u8 *bp = dst;
 
 	for (i = 0; i < srclen; i++) {
-		const char *p = strchr(base64_table, src[i]);
+		const char *p = find_chr(base64_table, src[i]);
 
 		if (src[i] == '=') {
 			ac = (ac << 6);
-- 
2.34.1



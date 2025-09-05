Return-Path: <ceph-devel+bounces-3532-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 78F57B4641D
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 22:02:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 340F4189A3D5
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 20:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF6321B905;
	Fri,  5 Sep 2025 20:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="h1Tu8P5R"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0336D298CDC
	for <ceph-devel@vger.kernel.org>; Fri,  5 Sep 2025 20:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757102514; cv=none; b=qzwRmnSL1KQZsHqCJIt/u0X1qNI4A4CaF0BOhEmdT4yJAs73nl0YerKLTw+vjuh1OaRTCl/1yCwqO5JiB7PzILcZpk2eRm5oYkPt3GGILXTjpNhB0R422+hAbPWWdpNFsBypvMzeKMNYbmSximBMocvEMOPBCKQmBH40aFM87vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757102514; c=relaxed/simple;
	bh=1pF+sWstittMgUZAcPl2M5umxp5LdS1zVdcpd3HgX8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPIWdSXxBPy5T3injR3EL6m4TAU9Ih7Jsjy4Ui15IZp4TeCCOMN4mr1thJ0GsrM53KX+Zs69EHPA0rhSvrtANRJKY4le99fUKs844AsPejKLEAqaCHX56MpEP88GL3qvX9eJpelDzBCP8/L/8JC/MQLaKG0SNpxTF1CYRdcio1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=h1Tu8P5R; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-71d603a269cso24404907b3.1
        for <ceph-devel@vger.kernel.org>; Fri, 05 Sep 2025 13:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1757102512; x=1757707312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QYuX37VRzv81v6MGz63GM7o8pjZX+kMvsG7Qgft9nHE=;
        b=h1Tu8P5RZwudcjMXYDV8V5jwmDiDWcoZXoGoxKI3Rx8IScxHoEKwQepAON5CZ1xO/m
         6Xw7tEVKEjzlXLHnZrwQYg7mKIyLD/CZIvBV8r0ebzB28fWL0/E4ztlzrsTF7Szj3qUz
         ui/WneekqQkhtrvsyEG+XFPJ4mePu18slOI32IK9/s/oD27XqJajxzSRQ7LnxEQJSjnD
         lARQpizGqs2h0MQLVS4CCervsTlrwebIsxfux1Qgs4dDuxCiqmnaBxt2blP8pcfZ+T1W
         GsfIlqCjnwGen5Udd1sUHW/BOyfO49pyVBhJiec8DhAQsaphd9z9cOPlGDzDmr5hZvv2
         PN3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757102512; x=1757707312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QYuX37VRzv81v6MGz63GM7o8pjZX+kMvsG7Qgft9nHE=;
        b=DECiVI0y9HXi7R1vr/46dvgW6Wg/Kc2plvIvYvYtE344YfRKWGqQ8dO/az6wUqEWzK
         yzyH85JQ11Mq6Whz0PMSj7XLuA0fjflsT+tVCW0FQMJ3Qrn2Je0IKrMYzLdIoyyqnQ/Z
         lSuNu4LfcQrucnbWAyIp9GjHolKa+r3X2jQYK3UbRbeFd7YRwEaQm0wWIH02esTNW8jf
         LLFnaLujbUbBPa1fr91BiNpgOXlTHQH+mjhRxjiTejGky9bCwczU7uq8nA8WLMP4npiE
         pxyNhK/LiLeLG1uAUbzPuZV6tg+7aHZH/eHmZl9A8ixYbmnzfbRJF48iMV12vS80xaUz
         1OOg==
X-Gm-Message-State: AOJu0Yx2DYN01QLSjs1/xxi8eUkX4HeWwnR6Oh2u5E4hbqJ8J+L5Zqa2
	QckS7Ha0kTIWOUJtjkeUUFDAgjMBUcO+X/ej4A+DI8Cf/crmnc0bTzyUWCPoVLJ2GTdp3VglFfn
	GxKdVFlk=
X-Gm-Gg: ASbGncsJyPkWXTMFe8/AdQwmPlndTL9x8uGwAuVyt2kNjoJx2TM/mjKYxr6vDW9DhiM
	LIIHv0BOyWa+v4PudyWi2lwRHptePFIniXZ/SLwfJRl0ITfYv9ieV0OVv4rUxxRFHuChUCP2+Ru
	PkOeKcA8/gfOVKEQQoRanXUS/34DWxR4PNuMESFW9SaThhv3VeSru1BDWdNcn6pzxfg16Oot50b
	ZP9p9yq2AohkifiD8KPHikUAVP5/zDQln3M0aM1aDAOeV0GYxIlT7yuj1PJB0Y9w8ch+Vi9qU1N
	Xuc+ImqTHhbap2RZhGwYcsi4rP5Iqy/NLHUFeq5ll+smB+hjVrrswnQ677EH0n3FPQZct/0IAfi
	ZI9IDozxdIeKVBP6RrJAtoQT+Q+lRkQ20fwL9Kx4j
X-Google-Smtp-Source: AGHT+IHoUZBIyHXakAhMyeWSnT5cOdZAA1bvwP2q9VBhGEI2gVFuR9FBP59atz0L61EREE3/dkHLfw==
X-Received: by 2002:a05:690c:9689:b0:720:378:bee0 with SMTP id 00721157ae682-727f2bcbcf6mr1692117b3.11.1757102511487;
        Fri, 05 Sep 2025 13:01:51 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:2479:21e9:a32d:d3ee])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a834c9adsm32360857b3.28.2025.09.05.13.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 13:01:50 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	vdubeyko@redhat.com
Subject: [RFC PATCH 04/20] ceph: add comments to declarations in ceph_features.h
Date: Fri,  5 Sep 2025 13:00:52 -0700
Message-ID: <20250905200108.151563-5-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250905200108.151563-1-slava@dubeyko.com>
References: <20250905200108.151563-1-slava@dubeyko.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

We have a lot of declarations and not enough good
comments on it.

Claude AI generated comments for CephFS metadata structure
declarations in include/linux/ceph/*.h. These comments
have been reviewed, checked, and corrected.

This patch adds detailed explanation of several constants
declarations and macros in include/linux/ceph/ceph_features.h.

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Ceph Development <ceph-devel@vger.kernel.org>
---
 include/linux/ceph/ceph_features.h | 47 ++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 9 deletions(-)

diff --git a/include/linux/ceph/ceph_features.h b/include/linux/ceph/ceph_features.h
index 3a47acd9cc14..31a270b624fe 100644
--- a/include/linux/ceph/ceph_features.h
+++ b/include/linux/ceph/ceph_features.h
@@ -3,37 +3,60 @@
 #define __CEPH_FEATURES
 
 /*
- * Each time we reclaim bits for reuse we need to specify another bit
+ * Feature incarnation metadata: Each time we reclaim bits for reuse we need to specify another bit
  * that, if present, indicates we have the new incarnation of that
  * feature.  Base case is 1 (first use).
  */
+/* Base incarnation - original feature bit definitions */
 #define CEPH_FEATURE_INCARNATION_1 (0ull)
+/* Second incarnation - requires SERVER_JEWEL support */
 #define CEPH_FEATURE_INCARNATION_2 (1ull<<57)              // SERVER_JEWEL
+/* Third incarnation - requires both SERVER_JEWEL and SERVER_MIMIC */
 #define CEPH_FEATURE_INCARNATION_3 ((1ull<<57)|(1ull<<28)) // SERVER_MIMIC
 
+/*
+ * Feature definition macro: Creates both feature bit and feature mask constants.
+ * @bit: The feature bit position (0-63)
+ * @incarnation: Which incarnation of this bit (1, 2, or 3)
+ * @name: Feature name suffix for CEPH_FEATURE_* constants
+ */
 #define DEFINE_CEPH_FEATURE(bit, incarnation, name)			\
 	static const uint64_t __maybe_unused CEPH_FEATURE_##name = (1ULL<<bit);		\
 	static const uint64_t __maybe_unused CEPH_FEATUREMASK_##name =			\
 		(1ULL<<bit | CEPH_FEATURE_INCARNATION_##incarnation);
 
-/* this bit is ignored but still advertised by release *when* */
+/*
+ * Deprecated feature definition macro: This bit is ignored but still advertised by release *when*
+ * @bit: The feature bit position
+ * @incarnation: Which incarnation of this bit
+ * @name: Feature name suffix
+ * @when: Release version when this feature was deprecated
+ */
 #define DEFINE_CEPH_FEATURE_DEPRECATED(bit, incarnation, name, when) \
 	static const uint64_t __maybe_unused DEPRECATED_CEPH_FEATURE_##name = (1ULL<<bit);	\
 	static const uint64_t __maybe_unused DEPRECATED_CEPH_FEATUREMASK_##name =		\
 		(1ULL<<bit | CEPH_FEATURE_INCARNATION_##incarnation);
 
 /*
- * this bit is ignored by release *unused* and not advertised by
- * release *unadvertised*
+ * Retired feature definition macro: This bit is ignored by release *unused* and not advertised by
+ * release *unadvertised*. The bit can be safely reused in future incarnations.
+ * @bit: The feature bit position
+ * @inc: Which incarnation this bit was retired from
+ * @name: Feature name suffix
+ * @unused: Release version that stopped using this bit
+ * @unadvertised: Release version that stopped advertising this bit
  */
 #define DEFINE_CEPH_FEATURE_RETIRED(bit, inc, name, unused, unadvertised)
 
 
 /*
- * test for a feature.  this test is safer than a typical mask against
- * the bit because it ensures that we have the bit AND the marker for the
- * bit's incarnation.  this must be used in any case where the features
- * bits may include an old meaning of the bit.
+ * Safe feature testing macro: Test for a feature using incarnation-aware comparison.
+ * This test is safer than a typical mask against the bit because it ensures that we have
+ * the bit AND the marker for the bit's incarnation. This must be used in any case where
+ * the features bits may include an old meaning of the bit.
+ * @x: Feature bitmask to test
+ * @name: Feature name suffix to test for
+ * Returns: true if both the feature bit and its incarnation markers are present
  */
 #define CEPH_HAVE_FEATURE(x, name)			\
 	(((x) & (CEPH_FEATUREMASK_##name)) == (CEPH_FEATUREMASK_##name))
@@ -174,7 +197,9 @@ DEFINE_CEPH_FEATURE_DEPRECATED(63, 1, RESERVED_BROKEN, LUMINOUS) // client-facin
 
 
 /*
- * Features supported.
+ * Default supported features bitmask: Defines the complete set of Ceph protocol features
+ * that this kernel client implementation supports. This determines compatibility with
+ * different Ceph server versions and enables various protocol optimizations and capabilities.
  */
 #define CEPH_FEATURES_SUPPORTED_DEFAULT		\
 	(CEPH_FEATURE_NOSRCADDR |		\
@@ -219,6 +244,10 @@ DEFINE_CEPH_FEATURE_DEPRECATED(63, 1, RESERVED_BROKEN, LUMINOUS) // client-facin
 	 CEPH_FEATURE_MSG_ADDR2 |		\
 	 CEPH_FEATURE_CEPHX_V2)
 
+/*
+ * Required features bitmask: Features that must be supported by peers.
+ * Currently set to 0, meaning no features are strictly required.
+ */
 #define CEPH_FEATURES_REQUIRED_DEFAULT	0
 
 #endif
-- 
2.51.0



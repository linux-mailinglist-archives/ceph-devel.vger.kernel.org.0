Return-Path: <ceph-devel+bounces-3892-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B6CA1C19AD9
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Oct 2025 11:24:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F039C503012
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Oct 2025 10:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 109593115A1;
	Wed, 29 Oct 2025 10:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="FIT4rCLg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00773126C7
	for <ceph-devel@vger.kernel.org>; Wed, 29 Oct 2025 10:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733289; cv=none; b=fa8+UvoHTzgd3doxC1NW6bVanfQ3d8WaMlqOgJ5ZFb+dbXv4d9olfrIA/Aj0x8ocQUENA1QDZb8dmER2QRXDhR2VCQ+bd9ILMt7SA/dwZgYg54/ZVwlWUNIHo95sgiC213ep2fgFe0eF2onJVfn9/Lt7LnY9bN4+9r8M86n559w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733289; c=relaxed/simple;
	bh=7ZpSFlYhHsywLshY841BMnLQ4JDVPu083/yKSrCOSU8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bEgcXQGkuf99mYamy2yOG2sqcsclAXRFZA2oP5A4qGlhLvlvuBjYywE0YARRC55/FQ/ULlp00duNMwYRu51UCCfzt0n9PVE+QCd+bVMtZYqDa6ZR1ysAxDP8aPW6sciUR+aewTaZ7INH2CW2KRO2GI+0Fm4ng4gD7GijGNuvQu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=FIT4rCLg; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-78125ed4052so8173653b3a.0
        for <ceph-devel@vger.kernel.org>; Wed, 29 Oct 2025 03:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1761733287; x=1762338087; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+3yM/JSkrHG9xuS0X6b7almvh+T954lX7appXlwo1i4=;
        b=FIT4rCLghEDtp2jwQ5JKt1ppVmtmg6RO9hNbFMAvDunI+fEM66YMtO83FeaXxzwS9S
         lT3NQR6wL1EZZvN97MejLyNbu//tzU5VikRrLjZluM/dgR6NHQUpD3w/nfiy1/KMNxp1
         mIfPWxvJcFPcOSh4Q7la126Dt5fhHXRh7C15AypX3wsyzyAa0O7ybFiP5y5dZXiAz2D/
         OhaQorHrXXN/os6ZRgUSg5QsMGYVR3eQcZ3wnYsP+6UUoleDT5Y5umCk+3vkN6u1TEO9
         kczEIPK6w3eZQlV5veddhvb4786nRJlOzZPnSB8WsrjkvOeRwzzZVxKWiEPHlQqddy46
         Zfrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761733287; x=1762338087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+3yM/JSkrHG9xuS0X6b7almvh+T954lX7appXlwo1i4=;
        b=HxEk9AeuqEe7Oc9prctRH1uhMDubFG3mw6Aly4UvhokmeSi6Jzgrqse+XSdvTi98Xx
         zj/8Kx4Zf+ubY0ntSQsxYR/C2qOpvL74tuQMRiX9wOFGR6DVoPZkh6B7K/5tLfUhKC9l
         8P7q3XV1BHm9fyNQdTEhcHqIGLYl0NLJOvfw1oHyHnCLGu0euOKyssTP///VFjt3Ar2L
         waSlB7hrlaXwhYtnF8HcFyF+rvpRXf1N2Cj2qcIeSkZWSLFq34pnfRM49nHq4NgJYIuR
         rYWCfLN1TPvnDx7bFNmhkpi/IS9qXLilfs0mEaOHWNe50zd5WQaQ0j5shgEWXZBQRd/x
         jvxQ==
X-Forwarded-Encrypted: i=1; AJvYcCVA+Hchbmc8Mgo3Vr0qOfglbfgjWOAsQWkuVm099hMwfuRRR4XoIAfHrej0H3Co1HrflthNJBZhuHSn@vger.kernel.org
X-Gm-Message-State: AOJu0YxF3ojTtEphQ3DYdSkGhkG/sQAUE2XyV8hCYsZXgP4V0QPFHXRF
	CEF1yOLGDT/f01JaB5yxaUf1mh0dJwOpm05ucQhqW1G+MlIF4YvNafacG9e0hB+fh5M=
X-Gm-Gg: ASbGncvQ2Hi+WNuzo5ZPiPmiocx6OqrC3EbZDZAba1WBd6Q46+VUkfLl2VJ6O0NyBiY
	H8diZZg4xo6iFqTzE3U5VX5bCZkvabdNVh7VjhIJ+YLNS9ElAR8vj49wk5BWIEfizahSBnJKBrb
	2qcVzZ4QjBjwyC05HL3kZM7Q+FoJe01ZkVuCmBzewOs7KzI1doQMVrO5U1x6wE2/wyHg3s7hu8K
	AW+HLqRXb72bpvuUfKv+ssM/ym8Rc1gHgjvZy1Zm+RjuEzYMVmS34+lQln5WeykGg2VAbKVE524
	YYzgNiIm2UJzNR8lhgD4I7YRFKOjGucJdoi3s2DnGE4Hqg4Kqo8wwlh7RAVQh2YfPUqrMDQu7qR
	d/+csNLCGhRCQynbCso9Qr5AD117wNH1Ug+uxOhw6jBVYbyzR5LgrxG49RVmX/zwsSAoYkUIoa3
	NBWdaLnSORcjbZAqUP0je2l8Ki
X-Google-Smtp-Source: AGHT+IG+5pzmhA3lehM8DT+BFIIuL+JwZkQFAvC00uaPqNk5XJrLTdGQ9/JEniZkCW/3kiE1ZbXiZQ==
X-Received: by 2002:a05:6a00:4f85:b0:7a2:6a86:c7a3 with SMTP id d2e1a72fcca58-7a4e30e336emr2898428b3a.8.1761733287204;
        Wed, 29 Oct 2025 03:21:27 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:3fc9:8c3c:5030:1b20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a414049ee0sm14561578b3a.33.2025.10.29.03.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 03:21:26 -0700 (PDT)
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
Subject: [PATCH v4 4/6] lib: add KUnit tests for base64 encoding/decoding
Date: Wed, 29 Oct 2025 18:21:20 +0800
Message-Id: <20251029102120.543669-1-409411716@gms.tku.edu.tw>
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

Add a KUnit test suite to validate the base64 helpers. The tests cover
both encoding and decoding, including padded and unpadded forms as defined
by RFC 4648 (standard base64), and add negative cases for malformed inputs
and padding errors.

The test suite also validates other variants (URLSAFE, IMAP) to ensure
their correctness.

In addition to functional checks, the suite includes simple microbenchmarks
which report average encode/decode latency for small (64B) and larger
(1KB) inputs. These numbers are informational only and do not gate the
tests.

Kconfig (BASE64_KUNIT) and lib/tests/Makefile are updated accordingly.

Sample KUnit output:

    KTAP version 1
    # Subtest: base64
    # module: base64_kunit
    1..4
    # base64_performance_tests: [64B] encode run : 32ns
    # base64_performance_tests: [64B] decode run : 35ns
    # base64_performance_tests: [1KB] encode run : 510ns
    # base64_performance_tests: [1KB] decode run : 530ns
    ok 1 base64_performance_tests
    ok 2 base64_std_encode_tests
    ok 3 base64_std_decode_tests
    ok 4 base64_variant_tests
    # base64: pass:4 fail:0 skip:0 total:4
    # Totals: pass:4 fail:0 skip:0 total:4

Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
---
 lib/Kconfig.debug        |  19 ++-
 lib/tests/Makefile       |   1 +
 lib/tests/base64_kunit.c | 294 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 313 insertions(+), 1 deletion(-)
 create mode 100644 lib/tests/base64_kunit.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index dc0e0c6ed..1cfb12d02 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2794,8 +2794,25 @@ config CMDLINE_KUNIT_TEST
 
 	  If unsure, say N.
 
+config BASE64_KUNIT
+	tristate "KUnit test for base64 decoding and encoding" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This builds the base64 unit tests.
+
+	  The tests cover the encoding and decoding logic of Base64 functions
+	  in the kernel.
+	  In addition to correctness checks, simple performance benchmarks
+	  for both encoding and decoding are also included.
+
+	  For more information on KUnit and unit tests in general please refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
+
 config BITS_TEST
-	tristate "KUnit test for bits.h" if !KUNIT_ALL_TESTS
+	tristate "KUnit test for bit functions and macros" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
 	help
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index fa6d728a8..6593a2873 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -4,6 +4,7 @@
 
 # KUnit tests
 CFLAGS_bitfield_kunit.o := $(DISABLE_STRUCTLEAK_PLUGIN)
+obj-$(CONFIG_BASE64_KUNIT) += base64_kunit.o
 obj-$(CONFIG_BITFIELD_KUNIT) += bitfield_kunit.o
 obj-$(CONFIG_BITS_TEST) += test_bits.o
 obj-$(CONFIG_BLACKHOLE_DEV_KUNIT_TEST) += blackhole_dev_kunit.o
diff --git a/lib/tests/base64_kunit.c b/lib/tests/base64_kunit.c
new file mode 100644
index 000000000..f7252070c
--- /dev/null
+++ b/lib/tests/base64_kunit.c
@@ -0,0 +1,294 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * base64_kunit_test.c - KUnit tests for base64 encoding and decoding functions
+ *
+ * Copyright (c) 2025, Guan-Chun Wu <409411716@gms.tku.edu.tw>
+ */
+
+#include <kunit/test.h>
+#include <linux/base64.h>
+
+/* ---------- Benchmark helpers ---------- */
+static u64 bench_encode_ns(const u8 *data, int len, char *dst, int reps,
+			   enum base64_variant variant)
+{
+	u64 t0, t1;
+
+	t0 = ktime_get_ns();
+	for (int i = 0; i < reps; i++)
+		base64_encode(data, len, dst, true, variant);
+	t1 = ktime_get_ns();
+
+	return div64_u64(t1 - t0, (u64)reps);
+}
+
+static u64 bench_decode_ns(const char *data, int len, u8 *dst, int reps,
+			   enum base64_variant variant)
+{
+	u64 t0, t1;
+
+	t0 = ktime_get_ns();
+	for (int i = 0; i < reps; i++)
+		base64_decode(data, len, dst, true, variant);
+	t1 = ktime_get_ns();
+
+	return div64_u64(t1 - t0, (u64)reps);
+}
+
+static void run_perf_and_check(struct kunit *test, const char *label, int size,
+			       enum base64_variant variant)
+{
+	const int reps = 1000;
+	size_t outlen = DIV_ROUND_UP(size, 3) * 4;
+	u8 *in = kmalloc(size, GFP_KERNEL);
+	char *enc = kmalloc(outlen, GFP_KERNEL);
+	u8 *decoded = kmalloc(size, GFP_KERNEL);
+
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, in);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, enc);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, decoded);
+
+	get_random_bytes(in, size);
+	int enc_len = base64_encode(in, size, enc, true, variant);
+	int dec_len = base64_decode(enc, enc_len, decoded, true, variant);
+
+	/* correctness sanity check */
+	KUNIT_EXPECT_EQ(test, dec_len, size);
+	KUNIT_EXPECT_MEMEQ(test, decoded, in, size);
+
+	/* benchmark encode */
+
+	u64 t1 = bench_encode_ns(in, size, enc, reps, variant);
+
+	kunit_info(test, "[%s] encode run : %lluns", label, t1);
+
+	u64 t2 = bench_decode_ns(enc, enc_len, decoded, reps, variant);
+
+	kunit_info(test, "[%s] decode run : %lluns", label, t2);
+
+	kfree(in);
+	kfree(enc);
+	kfree(decoded);
+}
+
+static void base64_performance_tests(struct kunit *test)
+{
+	/* run on STD variant only */
+	run_perf_and_check(test, "64B", 64, BASE64_STD);
+	run_perf_and_check(test, "1KB", 1024, BASE64_STD);
+}
+
+/* ---------- Helpers for encode ---------- */
+static void expect_encode_ok(struct kunit *test, const u8 *src, int srclen,
+			     const char *expected, bool padding,
+			     enum base64_variant variant)
+{
+	char buf[128];
+	int encoded_len = base64_encode(src, srclen, buf, padding, variant);
+
+	buf[encoded_len] = '\0';
+
+	KUNIT_EXPECT_EQ(test, encoded_len, strlen(expected));
+	KUNIT_EXPECT_STREQ(test, buf, expected);
+}
+
+/* ---------- Helpers for decode ---------- */
+static void expect_decode_ok(struct kunit *test, const char *src,
+			     const u8 *expected, int expected_len, bool padding,
+			     enum base64_variant variant)
+{
+	u8 buf[128];
+	int decoded_len = base64_decode(src, strlen(src), buf, padding, variant);
+
+	KUNIT_EXPECT_EQ(test, decoded_len, expected_len);
+	KUNIT_EXPECT_MEMEQ(test, buf, expected, expected_len);
+}
+
+static void expect_decode_err(struct kunit *test, const char *src,
+			      int srclen, bool padding,
+			      enum base64_variant variant)
+{
+	u8 buf[64];
+	int decoded_len = base64_decode(src, srclen, buf, padding, variant);
+
+	KUNIT_EXPECT_EQ(test, decoded_len, -1);
+}
+
+/* ---------- Encode Tests ---------- */
+static void base64_std_encode_tests(struct kunit *test)
+{
+	/* With padding */
+	expect_encode_ok(test, (const u8 *)"", 0, "", true, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"f", 1, "Zg==", true, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"fo", 2, "Zm8=", true, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"foo", 3, "Zm9v", true, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"foob", 4, "Zm9vYg==", true, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"fooba", 5, "Zm9vYmE=", true, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"foobar", 6, "Zm9vYmFy", true, BASE64_STD);
+
+	/* Extra cases with padding */
+	expect_encode_ok(test, (const u8 *)"Hello, world!", 13, "SGVsbG8sIHdvcmxkIQ==",
+			 true, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"ABCDEFGHIJKLMNOPQRSTUVWXYZ", 26,
+			 "QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVo=", true, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"abcdefghijklmnopqrstuvwxyz", 26,
+			 "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXo=", true, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"0123456789+/", 12, "MDEyMzQ1Njc4OSsv",
+			 true, BASE64_STD);
+
+	/* Without padding */
+	expect_encode_ok(test, (const u8 *)"", 0, "", false, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"f", 1, "Zg", false, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"fo", 2, "Zm8", false, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"foo", 3, "Zm9v", false, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"foob", 4, "Zm9vYg", false, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"fooba", 5, "Zm9vYmE", false, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"foobar", 6, "Zm9vYmFy", false, BASE64_STD);
+
+	/* Extra cases without padding */
+	expect_encode_ok(test, (const u8 *)"Hello, world!", 13, "SGVsbG8sIHdvcmxkIQ",
+			 false, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"ABCDEFGHIJKLMNOPQRSTUVWXYZ", 26,
+			 "QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVo", false, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"abcdefghijklmnopqrstuvwxyz", 26,
+			 "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXo", false, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"0123456789+/", 12, "MDEyMzQ1Njc4OSsv",
+			 false, BASE64_STD);
+}
+
+/* ---------- Decode Tests ---------- */
+static void base64_std_decode_tests(struct kunit *test)
+{
+	/* -------- With padding --------*/
+	expect_decode_ok(test, "", (const u8 *)"", 0, true, BASE64_STD);
+	expect_decode_ok(test, "Zg==", (const u8 *)"f", 1, true, BASE64_STD);
+	expect_decode_ok(test, "Zm8=", (const u8 *)"fo", 2, true, BASE64_STD);
+	expect_decode_ok(test, "Zm9v", (const u8 *)"foo", 3, true, BASE64_STD);
+	expect_decode_ok(test, "Zm9vYg==", (const u8 *)"foob", 4, true, BASE64_STD);
+	expect_decode_ok(test, "Zm9vYmE=", (const u8 *)"fooba", 5, true, BASE64_STD);
+	expect_decode_ok(test, "Zm9vYmFy", (const u8 *)"foobar", 6, true, BASE64_STD);
+	expect_decode_ok(test, "SGVsbG8sIHdvcmxkIQ==", (const u8 *)"Hello, world!", 13,
+			 true, BASE64_STD);
+	expect_decode_ok(test, "QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVo=",
+			 (const u8 *)"ABCDEFGHIJKLMNOPQRSTUVWXYZ", 26, true, BASE64_STD);
+	expect_decode_ok(test, "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXo=",
+			 (const u8 *)"abcdefghijklmnopqrstuvwxyz", 26, true, BASE64_STD);
+
+	/* Error cases */
+	expect_decode_err(test, "Zg=!", 4, true, BASE64_STD);
+	expect_decode_err(test, "Zm$=", 4, true, BASE64_STD);
+	expect_decode_err(test, "Z===", 4, true, BASE64_STD);
+	expect_decode_err(test, "Zg", 2, true, BASE64_STD);
+	expect_decode_err(test, "Zm9v====", 8, true, BASE64_STD);
+	expect_decode_err(test, "Zm==A", 5, true, BASE64_STD);
+
+	{
+		char with_nul[4] = { 'Z', 'g', '\0', '=' };
+
+		expect_decode_err(test, with_nul, 4, true, BASE64_STD);
+	}
+
+	/* -------- Without padding --------*/
+	expect_decode_ok(test, "", (const u8 *)"", 0, false, BASE64_STD);
+	expect_decode_ok(test, "Zg", (const u8 *)"f", 1, false, BASE64_STD);
+	expect_decode_ok(test, "Zm8", (const u8 *)"fo", 2, false, BASE64_STD);
+	expect_decode_ok(test, "Zm9v", (const u8 *)"foo", 3, false, BASE64_STD);
+	expect_decode_ok(test, "Zm9vYg", (const u8 *)"foob", 4, false, BASE64_STD);
+	expect_decode_ok(test, "Zm9vYmE", (const u8 *)"fooba", 5, false, BASE64_STD);
+	expect_decode_ok(test, "Zm9vYmFy", (const u8 *)"foobar", 6, false, BASE64_STD);
+	expect_decode_ok(test, "TWFu", (const u8 *)"Man", 3, false, BASE64_STD);
+	expect_decode_ok(test, "SGVsbG8sIHdvcmxkIQ", (const u8 *)"Hello, world!", 13,
+			 false, BASE64_STD);
+	expect_decode_ok(test, "QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVo",
+			 (const u8 *)"ABCDEFGHIJKLMNOPQRSTUVWXYZ", 26, false, BASE64_STD);
+	expect_decode_ok(test, "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXo",
+			 (const u8 *)"abcdefghijklmnopqrstuvwxyz", 26, false, BASE64_STD);
+	expect_decode_ok(test, "MDEyMzQ1Njc4OSsv", (const u8 *)"0123456789+/", 12,
+			 false, BASE64_STD);
+
+	/* Error cases */
+	expect_decode_err(test, "Zg=!", 4, false, BASE64_STD);
+	expect_decode_err(test, "Zm$=", 4, false, BASE64_STD);
+	expect_decode_err(test, "Z===", 4, false, BASE64_STD);
+	expect_decode_err(test, "Zg=", 3, false, BASE64_STD);
+	expect_decode_err(test, "Zm9v====", 8, false, BASE64_STD);
+	expect_decode_err(test, "Zm==v", 4, false, BASE64_STD);
+
+	{
+		char with_nul[4] = { 'Z', 'g', '\0', '=' };
+
+		expect_decode_err(test, with_nul, 4, false, BASE64_STD);
+	}
+}
+
+/* ---------- Variant tests (URLSAFE / IMAP) ---------- */
+static void base64_variant_tests(struct kunit *test)
+{
+	const u8 sample1[] = { 0x00, 0xfb, 0xff, 0x7f, 0x80 };
+	char std_buf[128], url_buf[128], imap_buf[128];
+	u8 back[128];
+	int n_std, n_url, n_imap, m;
+	int i;
+
+	n_std = base64_encode(sample1, sizeof(sample1), std_buf, false, BASE64_STD);
+	n_url = base64_encode(sample1, sizeof(sample1), url_buf, false, BASE64_URLSAFE);
+	std_buf[n_std] = '\0';
+	url_buf[n_url] = '\0';
+
+	for (i = 0; i < n_std; i++) {
+		if (std_buf[i] == '+')
+			std_buf[i] = '-';
+		else if (std_buf[i] == '/')
+			std_buf[i] = '_';
+	}
+	KUNIT_EXPECT_STREQ(test, std_buf, url_buf);
+
+	m = base64_decode(url_buf, n_url, back, false, BASE64_URLSAFE);
+	KUNIT_EXPECT_EQ(test, m, (int)sizeof(sample1));
+	KUNIT_EXPECT_MEMEQ(test, back, sample1, sizeof(sample1));
+
+	n_std  = base64_encode(sample1, sizeof(sample1), std_buf, false, BASE64_STD);
+	n_imap = base64_encode(sample1, sizeof(sample1), imap_buf, false, BASE64_IMAP);
+	std_buf[n_std]   = '\0';
+	imap_buf[n_imap] = '\0';
+
+	for (i = 0; i < n_std; i++)
+		if (std_buf[i] == '/')
+			std_buf[i] = ',';
+	KUNIT_EXPECT_STREQ(test, std_buf, imap_buf);
+
+	m = base64_decode(imap_buf, n_imap, back, false, BASE64_IMAP);
+	KUNIT_EXPECT_EQ(test, m, (int)sizeof(sample1));
+	KUNIT_EXPECT_MEMEQ(test, back, sample1, sizeof(sample1));
+
+	{
+		const char *bad = "Zg==";
+		u8 tmp[8];
+
+		m = base64_decode(bad, strlen(bad), tmp, false, BASE64_URLSAFE);
+		KUNIT_EXPECT_EQ(test, m, -1);
+
+		m = base64_decode(bad, strlen(bad), tmp, false, BASE64_IMAP);
+		KUNIT_EXPECT_EQ(test, m, -1);
+	}
+}
+
+/* ---------- Test registration ---------- */
+static struct kunit_case base64_test_cases[] = {
+	KUNIT_CASE(base64_performance_tests),
+	KUNIT_CASE(base64_std_encode_tests),
+	KUNIT_CASE(base64_std_decode_tests),
+	KUNIT_CASE(base64_variant_tests),
+	{}
+};
+
+static struct kunit_suite base64_test_suite = {
+	.name = "base64",
+	.test_cases = base64_test_cases,
+};
+
+kunit_test_suite(base64_test_suite);
+
+MODULE_AUTHOR("Guan-Chun Wu <409411716@gms.tku.edu.tw>");
+MODULE_DESCRIPTION("KUnit tests for Base64 encoding/decoding, including performance checks");
+MODULE_LICENSE("GPL");
-- 
2.34.1



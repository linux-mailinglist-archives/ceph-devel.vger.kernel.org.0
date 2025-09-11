Return-Path: <ceph-devel+bounces-3571-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 36B9EB529F4
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Sep 2025 09:29:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E0AD21C26332
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Sep 2025 07:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 360D826CE39;
	Thu, 11 Sep 2025 07:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="zgp44XFw"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5219526C386
	for <ceph-devel@vger.kernel.org>; Thu, 11 Sep 2025 07:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757575782; cv=none; b=V/pDnhDs9h5gQa+XbHsdFlEmnHoH0Ga7FR6iCtrW3OhqC9kV7yqxKYspPwo0sjnSbU53yNo192X65AFTAWT8kJxM8q1Y+00rw+urMT3ZHcSLPcI6kSID1wRDvcfoB3DdtsUkqCBU9MUQNPaKYEcQGV/gqdzZOuj8sMvOu0F+TOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757575782; c=relaxed/simple;
	bh=dzyPDAyBY3iE453hKGZWh2GhozhS+rLJS+JK8T73SRs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MJefvQd1pKkcdiY7g0WcsMnNwDlROIgl+BIkk7LVbSKd2IZ85HpHE++fI+msd1s0LxFkJaPeIEjWDEk6XzW2U5ajFpbSgdjM+JwqINKPF+Y1k91xc/vxaAYQOvGpuRTXDRCD3t0IKwydX/kADhsy2a6Sp6pUHz5XWGEErOyqnsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=zgp44XFw; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-25c5e597cfcso1677325ad.1
        for <ceph-devel@vger.kernel.org>; Thu, 11 Sep 2025 00:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1757575777; x=1758180577; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D81Vt79I/BTOBBePW6+0X1oh6zDyKaYVMRC1TVaQyRM=;
        b=zgp44XFwPbkb7o2cKpnE2r7Xs7lyjr3cY0QI3HrjgdAMbh33t/+5pXXQkW2WYVI5k4
         gh9OK4ITqPQEKt272Qe5ZGfLR1PhrTkWsnMwPRx9vexHj3RpxsXU6/oWTg3QH12gPJd6
         dq9lK3cBKwbcf2ypExkbHjSOxcRvzRuTcFPWLJZ21iUtqgYS22oPWVB9vl8UXiyVQInD
         MlcHyJKYUXz7hr9V4wKVU3sRkvF6h8HgWlfPLLWFJb1OCPkYruVQNudDBIzLwkwNBAi6
         9Oh57zk/RWXKrzNKhXLii6F4JOjfsMqdG9ETPmPx71gVAwGkHkmKGHAQHgzh2XUo+25j
         ZJqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757575777; x=1758180577;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D81Vt79I/BTOBBePW6+0X1oh6zDyKaYVMRC1TVaQyRM=;
        b=aiFybT2n/dd676bvIq1brxxw9v28npUfDHgtfcSW/DUATpz+27OLCFPT06O9Ro6J9d
         U7hP/NKPlXvtQDq5IAApjwgWbBo9lP0aZTeh8l4q08bYOsUnYi/fPdMXa7DoIy3eRSnb
         bP7jr6oYJ9x+kTwB30JFFoTkQZqQf47fHr25uOZcyrWUAZzqP+FH19XUwTQpUKMFcrQI
         5uituYAoWQzAaZ+UCeL/W/sD4/g6o+is+E9NMuYANaWjVASc51QYay0FfN1tHMvYVI+C
         etrfBHprmIMLZc7XmhAk58Aw834NL692wBsmkJbckaQsIWJzhTxevl087/fFY7GkBXm8
         VZJA==
X-Forwarded-Encrypted: i=1; AJvYcCVVRdzbzjL2Ewx71hWI2sygKJsduQnjAXSEPJIJqGrc2KLIH7Bu8CKk815+q3Q4EpYPaS3jKkrbEo66@vger.kernel.org
X-Gm-Message-State: AOJu0YwPzsMn2qkt7RTptcpLKk9NQwrnM0kRmUi6pVzP/KWT9qRD0unq
	2RYPEF3hTBkKvPAffVEPZ3J0SwYR6zkK56QNx720dH2A46RB6XvTbaT4G4QvfmOAhbU=
X-Gm-Gg: ASbGncvoc3nDRrhWGyrVyTNRclL0WXsOBOfIbn6KEaLU4OcMHVP5C2f4miiqjusfZXI
	2RBZxkUFCeuwcRZwbvOmGRAOmh1u+8TBpxp54sAazYxenNUoaxnVq/8EgX1ZVxu/q/W9B8ddfWX
	yr6wx6Y2+jeUuIAc28y6NQW0ZdS06Mh/WSj5oPdZebhdrho6B/pmI4+qlZWZ4m3MikaEAU9w6S/
	TqOyrtG1PxrU70R/NXvWjFGsz7+4pPPpPV6GWbt3r9k6ZeXlcUYdzS1iKOxdxhUcvwLxVs1zAWu
	UnW6LawRL5H0ps8HpbwrEv50SB6pBdoDmXw1/EvbRYLyhO4dGRquDVFgeG42ckwe603/bDLJXD7
	FAPLB/rozBe2bfUSvuj4PP9A8MuE/9NC07rVwwDmPnTjZYuiOjhGqT1VRtg==
X-Google-Smtp-Source: AGHT+IHO7xlf6/5dPDqWynFAANB+M0UuBkmme6pcsf85zd3+cmkflA/c+A0enwc+u10nZW1Fv/oP5w==
X-Received: by 2002:a17:903:1111:b0:251:3d1c:81f4 with SMTP id d9443c01a7336-25173bbbab1mr288649825ad.54.1757575777526;
        Thu, 11 Sep 2025 00:29:37 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:7811:c085:c184:85be])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c37293ef1sm9838395ad.41.2025.09.11.00.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 00:29:36 -0700 (PDT)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: kbusch@kernel.org,
	axboe@kernel.dk,
	hch@lst.de,
	sagi@grimberg.me,
	xiubli@redhat.com,
	idryomov@gmail.com,
	ebiggers@kernel.org,
	tytso@mit.edu,
	jaegeuk@kernel.org,
	akpm@linux-foundation.org
Cc: visitorckw@gmail.com,
	home7438072@gmail.com,
	409411716@gms.tku.edu.tw,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	ceph-devel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 0/5] lib/base64: add generic encoder/decoder, migrate users
Date: Thu, 11 Sep 2025 15:29:25 +0800
Message-Id: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series introduces a generic, customizable Base64 encoder/decoder to
the kernel library, eliminating duplicated implementations and delivering
significant performance improvements.

The new helpers support a caller-supplied 64-character table and optional
'=' padding, covering existing variants such as base64url (fscrypt) and
Ceph's custom alphabet. As part of this series, both fscrypt and Ceph are
migrated to the generic helpers, removing their local routines while
preserving their specific formats.

On the encoder side, the implementation operates on 3-byte input blocks
mapped directly to 4 output symbols, avoiding bit-by-bit streaming. This
reduces shifts, masks, and loop overhead, achieving up to ~2.7x speedup
over previous implementations while remaining fully RFC 4648-compatible.

On the decoder side, optimizations replace strchr()-based lookups with a
direct mapping table. Together with stricter RFC 4648 validation, this
yields a ~12-15x improvement in decode throughput.

Overall, the series improves maintainability, correctness, and
performance of Base64 handling across the kernel.

Note:
  - The included KUnit patch provides correctness and performance
    comparison tests to help reviewers validate the improvements. All
    tests pass locally on x86_64 (KTAP: pass:3 fail:0 skip:0). Benchmark
    numbers are informational only and do not gate the tests.
  - Updates nvme-auth call sites to the new API.

Thanks,
Guan-Chun Wu

---

v1 -> v2:
  - Add a KUnit test suite for lib/base64:
      * correctness tests (multiple alphabets, with/without padding)
      * simple microbenchmark for informational performance comparison
  - Rework encoder/decoder:
      * encoder: generalize to a caller-provided 64-character table and
        optional '=' padding
      * decoder: optimize and extend to generic tables
  - fscrypt: migrate from local base64url helpers to generic lib/base64
  - ceph: migrate from local base64 helpers to generic lib/base64

---

Guan-Chun Wu (4):
  lib/base64: rework encoder/decoder with customizable support and
    update nvme-auth
  lib: add KUnit tests for base64 encoding/decoding
  fscrypt: replace local base64url helpers with generic lib/base64
    helpers
  ceph: replace local base64 encode/decode with generic lib/base64
    helpers

Kuan-Wei Chiu (1):
  lib/base64: Replace strchr() for better performance

 drivers/nvme/common/auth.c |   7 +-
 fs/ceph/crypto.c           |  53 +-------
 fs/ceph/crypto.h           |   6 +-
 fs/ceph/dir.c              |   5 +-
 fs/ceph/inode.c            |   2 +-
 fs/crypto/fname.c          |  86 +------------
 include/linux/base64.h     |   4 +-
 lib/Kconfig.debug          |  19 ++-
 lib/base64.c               | 239 ++++++++++++++++++++++++++++++-------
 lib/tests/Makefile         |   1 +
 lib/tests/base64_kunit.c   | 230 +++++++++++++++++++++++++++++++++++
 11 files changed, 466 insertions(+), 186 deletions(-)
 create mode 100644 lib/tests/base64_kunit.c

-- 
2.34.1



Return-Path: <ceph-devel+bounces-4060-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 43859C5B70D
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Nov 2025 06:58:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AC3004E80FF
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Nov 2025 05:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC1D52D838E;
	Fri, 14 Nov 2025 05:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="SUp2liwD"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A8B2D8385
	for <ceph-devel@vger.kernel.org>; Fri, 14 Nov 2025 05:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763099920; cv=none; b=JL4HXvKwhaF/+UlXRUTcTgux2pcBujUJpNeGVwglfsy8Xn44ve3NjATP1VZRaWzV2/V3GWwnKAfuW/KR3sYeDaukeXBhJyl4eY7s75UARBpXm+PsIWEE8A0xUkDBvp0AuUtDNqE6YielPLJPZksUWEnl/zLBmYgK/E9WVu1R5Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763099920; c=relaxed/simple;
	bh=RHXnTFY4Vjt79fDUxT3cRYXGuRmkpqXY8Q1+NN8qIIk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=e+hhQN8AVzPKg/fw6ry54Eq8j8Zzlobaueja7wvbd94549XVaZKp8x5E/AxSOegqNiRC3Zvpc9Jz23Jpxz0PnvdbjmX3q7CPpFhfa25Kcuuj79X78gFJtsx6FEIIGL2CKeJLIJcHjKVk5q4KLGwYqoFEmdYBNvloO2JIosz/pcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=SUp2liwD; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-297d4a56f97so15836715ad.1
        for <ceph-devel@vger.kernel.org>; Thu, 13 Nov 2025 21:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1763099917; x=1763704717; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fupJk9ycgxTR9K+qzkaB5UIJKdModxQ3EoXqNJbHRwk=;
        b=SUp2liwDkCBhLBgCyXBL+v/ZZW9IwteFtvuO8Yk7uFlPp9DqODR9gfc9hvyYRkNqIc
         PumGeNJCNskSl5xWXchGXmRr8NRDU01Gnq4RT2yenQMRZFj5dPub3kra36L0P7H90a1B
         UpowwhnQHFX2xPC5JZAy1ciO6LUrjxpHbRh0a/ZGnR+0HzzKLDp+K1KAdTI6vjCENjEQ
         1jU53sPR+usds0kEhLM2QGn4h19/FgzDjPeUQb/bLaDL96mT6v4HwnwarK71P4i1zs01
         PNOdRSw9/Ys6xsOOg8qNEx+5vGTGobzGMfstI1KyBNLbdtB0/FylM8kAoAOm/+K6QRfi
         6Urw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763099917; x=1763704717;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fupJk9ycgxTR9K+qzkaB5UIJKdModxQ3EoXqNJbHRwk=;
        b=ujUkc0zPO1ZIGkKRjGeSaAz0qnE27/1MnWgIwQLGf21ADM7anqEP233ue1gy6nOb7p
         YeGGglz4VrC7u2hEyHQVolWjoYpAVOh7oAgt9g0vnczDYiTYuyu1fjdBsPaXXrZgx+sD
         5/GOXbxgytoxX9V+PmK2c+jBDX2Y00f4ncl3zVSYB+Zq/of9PXLRem85ctSHtgIG46W6
         TVyAcrELMPc3C7DVw0Cwl+c5WH+4Vvc5J+qtiie7zjcfi83yKBdXl2XI/u/CYfH3Tcso
         dUozmAvtB9WyxmIKMbgj7DqRrEdXk3qq8wkhuLCWaw0vsflC6GkIb+e9G/pYhJ5yNjlU
         kr8A==
X-Forwarded-Encrypted: i=1; AJvYcCXYwvTf3tBBJXdfdCNO02sF0ABH54mTLUvXWzochNbueUfqyX5a/IqBNfmj44+n8+mLF6ZvJaXusYe5@vger.kernel.org
X-Gm-Message-State: AOJu0Ywg7HIhe/2dY0sNqePgw9TqYWm5St3ko5HJC3iFy7TAFot5/ojk
	DCr6HX2p07Y2jyQIfFiYqtbHdUkmBMdWC7FytRzYYFa3081TKMYaEbrqd47gstRaXXQ=
X-Gm-Gg: ASbGncvTKcJt9LajYOzwatMj6bam8U6x6NDGmzKkQAzfxXiEG3nOyNKgT5unks0Hpgd
	//S4nPvGwuaRHQO55eV64DiIdsMTWPd6892mapQGMuJDkRSUmfRv2qDBVjj7OZe7NqQ9zaoJdI/
	N5lefiOjxMW2tHBiCza7iY5vdL5PJnIrrmv4B/OX+zCMtQiuOWYSQ7NJ9pozloquCdC8BlhfNhd
	xdjV7/apVSdFgr0ZnU0bh1fkDct7IndXLn2XudxZtIpj0/RWZ8OCnkMYNG1PInpcaZCHhAFZbZP
	e1CrorNRkuZcVzgJx9y1Llk/cQNkrjgkQiPTM1tw4EACJAo5bhj3EheOKmBIvsDTL3af2sfyDBK
	vbwlTCDBtdft+ZmLY3+JbOyom1bzkFOlBXAAHszHwOCJzxM0zKT6rsdp/HZDXjI/Mw8O3m8rL8t
	kPlXFdtaxo4gCBMPcUNzyjlUQf
X-Google-Smtp-Source: AGHT+IFojfSCG/W0M3Jt5J4Jz8XjM+U4I16pRFtTj2FRmRxZFPiZbCx8UawP3/kCmEgwqKCvZRSjlA==
X-Received: by 2002:a17:903:2f0e:b0:24c:965a:f94d with SMTP id d9443c01a7336-2986a741b6cmr18474075ad.46.1763099917503;
        Thu, 13 Nov 2025 21:58:37 -0800 (PST)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:22d2:323c:497d:adbd])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2beb34sm43727825ad.76.2025.11.13.21.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 21:58:36 -0800 (PST)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: akpm@linux-foundation.org,
	ebiggers@kernel.org,
	tytso@mit.edu,
	jaegeuk@kernel.org,
	xiubli@redhat.com,
	idryomov@gmail.com,
	kbusch@kernel.org,
	axboe@kernel.dk,
	hch@lst.de,
	sagi@grimberg.me
Cc: visitorckw@gmail.com,
	409411716@gms.tku.edu.tw,
	home7438072@gmail.com,
	andriy.shevchenko@intel.com,
	david.laight.linux@gmail.com,
	linux-nvme@lists.infradead.org,
	linux-fscrypt@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/6]  lib/base64: add generic encoder/decoder, migrate users
Date: Fri, 14 Nov 2025 13:58:29 +0800
Message-Id: <20251114055829.87814-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series introduces a generic Base64 encoder/decoder to the kernel
library, eliminating duplicated implementations and delivering significant
performance improvements.

The Base64 API has been extended to support multiple variants (Standard,
URL-safe, and IMAP) as defined in RFC 4648 and RFC 3501. The API now takes
a variant parameter and an option to control padding. As part of this
series, users are migrated to the new interface while preserving their
specific formats: fscrypt now uses BASE64_URLSAFE, Ceph uses BASE64_IMAP,
and NVMe is updated to BASE64_STD.

On the encoder side, the implementation processes input in 3-byte blocks,
mapping 24 bits directly to 4 output symbols. This avoids bit-by-bit
streaming and reduces loop overhead, achieving about a 2.7x speedup compared
to previous implementations.

On the decoder side, replace strchr() lookups with per-variant reverse tables
and process input in 4-character groups. Each group is mapped to numeric values
and combined into 3 bytes. Padded and unpadded forms are validated explicitly,
rejecting invalid '=' usage and enforcing tail rules. This improves throughput
by ~43-52x.

Thanks,
Guan-Chun Wu

Link: https://lore.kernel.org/lkml/20251029101725.541758-1-409411716@gms.tku.edu.tw/

---

v4 -> v5:
  - lib/base64: Fixed initializer-overrides compiler error by replacing designated
    initializer approach with macro-based constant expressions.

---

Guan-Chun Wu (4):
  lib/base64: rework encode/decode for speed and stricter validation
  lib: add KUnit tests for base64 encoding/decoding
  fscrypt: replace local base64url helpers with lib/base64
  ceph: replace local base64 helpers with lib/base64

Kuan-Wei Chiu (2):
  lib/base64: Add support for multiple variants
  lib/base64: Optimize base64_decode() with reverse lookup tables

 drivers/nvme/common/auth.c |   4 +-
 fs/ceph/crypto.c           |  60 +-------
 fs/ceph/crypto.h           |   6 +-
 fs/ceph/dir.c              |   5 +-
 fs/ceph/inode.c            |   2 +-
 fs/crypto/fname.c          |  89 +----------
 include/linux/base64.h     |  10 +-
 lib/Kconfig.debug          |  19 ++-
 lib/base64.c               | 188 +++++++++++++++++-------
 lib/tests/Makefile         |   1 +
 lib/tests/base64_kunit.c   | 294 +++++++++++++++++++++++++++++++++++++
 11 files changed, 472 insertions(+), 206 deletions(-)
 create mode 100644 lib/tests/base64_kunit.c

-- 
2.34.1



Return-Path: <ceph-devel+bounces-3603-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E1ECB56220
	for <lists+ceph-devel@lfdr.de>; Sat, 13 Sep 2025 17:58:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04468A04B7F
	for <lists+ceph-devel@lfdr.de>; Sat, 13 Sep 2025 15:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 368892F1FD8;
	Sat, 13 Sep 2025 15:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RhcpdItY"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0DA2E88AB
	for <ceph-devel@vger.kernel.org>; Sat, 13 Sep 2025 15:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757779129; cv=none; b=n2IYzo8zwZg+JszvlcO/aRz07FpsPTTkOx/G+0GssDCnttCiPDTkUdUndunmjGyqvGinGTx5NQsG/et7Bu7xSIn7sJK6uRRxUFfjKUpshAMs8OTYTm2s2FVENi5kyCDoPPb/1cN5jTz54uUlJlQL4rc5XDjPKX2IuwBbLxzkuFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757779129; c=relaxed/simple;
	bh=ysEO5UfPlgDYvjZpTZ5QQdgQAIUSS7tS69IXC4Lp6ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qZ1RKKlAkUzte/zZQ13KAyxBgYXt62jmKW5UtY3SHLsHs4b+39cSLhxXkCU3wKLOlB8T+bgPIXk0JmXxezXVRXUPMIBIsktbdK4uN/+tZ42z1KMbLtL2T450H8nuObp9uIpPS2HsMLZo8i3pRHQz5XvOf9fSvePl0YxyHWJfCg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RhcpdItY; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45dde353b47so17858285e9.3
        for <ceph-devel@vger.kernel.org>; Sat, 13 Sep 2025 08:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757779126; x=1758383926; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4fTzk4osdS7kL0jIAxv8b2eMmWAJ1UpX17/BW+y0ay0=;
        b=RhcpdItYxgncORRtdWuCCiMOBjjIFwyAwEkK7e/p7hMKnwaK/px/jN0inDnXMCMxbt
         AusHNYNVt25z4Ow1i/KhtXhveNCA3yxxLYAIN61yYpd4KDvqO+/HB6IKt5bEJL5H6jIo
         TEePTfx/8P71+JjIBm5k+8LAurTTrxQQG4pd0pjAopIlwz/BdztzSXhbppVMxB7qsehj
         StRNdQa350bSMcmhpST9psqH6LZhv0XtRzlpXqpbDSowQAAAC92sKjbDqS+NeMRSaezc
         NZiB3rHd4YKvzMzc8CVNLITkkjxe03Wv2oyvdsbYNzcc/pGI2U2SlkBBKAvCOQgfO3q2
         GE+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757779126; x=1758383926;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4fTzk4osdS7kL0jIAxv8b2eMmWAJ1UpX17/BW+y0ay0=;
        b=QDGStWj7iI1Ldez+kcF/tsltkKuY5l725lwVaqejv73jjGTNJ/pkTVxFl+doBUnM9v
         6ZKxAlCOmV9m6S5lmsewbX4Pcuc8pLrV6zxcXNBxo8qoTxHYfhMDDpDPHGRi3vuH66f0
         oNuNE79Od/PkiClxmR7Wabsw7yfjJNDKAM3vs/haFqK2VD2d/LhUt4N4tVOyHww6Z82g
         nlMHLBeCNqUJl45MRLn7m8ck2xCjdHn1pEbhnhnixe0Lo4idDa/IZPlEYLRGnVZU1QYR
         ZtM2NShRdHzcV+YU0E3hyAJWfoQGVopAnZcHTRuNmuo7lCpn0pFs95MNhDB+s6OgwT8x
         afUA==
X-Gm-Message-State: AOJu0Yy6Lgq1/Gii5gv8Q6qe9hsE2O3qr1GqEB7REYZF6Ck/P1QOiC2B
	i18FHBvSNo7070UeCO1OYyVM1mymaHHPrxT+H5ubBU0AwigNZYwMsuQO
X-Gm-Gg: ASbGnctGr9HsWZcdL+tUPRn2eVZ/XXUXenbMpKVwBJPrnT8n9r1SwhSBtIOgdbfZf6E
	j9YIiJY46/LJeWPy+YwoGAZwkp8bifz1fXT0BmDjkA7U/d4t5Go/MtJIL9RFvjBrQNRBMD+/vMe
	TBnC8gjIdYPIznwXRlUMj+gWfMy0N6znxRI/9Vp1orMhPV0jSVQ+yTFFd42MZMAYJMhumfLeny5
	QNGW9Z6JYZF4VygArGtkCS6OSzfT9oDwpwY5BfjfAcRuYaN8kYsN5nPyi7hLckaM1c97xhQsaVi
	ZMUT7yCbokdXxYz1yC36fyebWdtot5vr3rLUezPfOmJi+cG124JTxjys1ClOZW4YdQikH3KtLV3
	jDLs2BYGsvIRVExvILTN5oqE+AHdGUlZqQg5A0c8XJTyH+0qpozlQGOnoBHS3psdQMw==
X-Google-Smtp-Source: AGHT+IEZjKHYvnIe99kbdNvb3qo3o/kahoQ23h4rmRfRqeXhpX+qGek9qlWilTTZAewjhFFXhHpxrQ==
X-Received: by 2002:a05:600c:2113:b0:45d:d5c6:97b4 with SMTP id 5b1f17b1804b1-45f211d4efamr49863105e9.9.1757779125528;
        Sat, 13 Sep 2025 08:58:45 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45f290d1512sm17659805e9.16.2025.09.13.08.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Sep 2025 08:58:44 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 6.17-rc6
Date: Sat, 13 Sep 2025 17:58:29 +0200
Message-ID: <20250913155830.96394-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linus,

The following changes since commit 76eeb9b8de9880ca38696b2fb56ac45ac0a25c6c:

  Linux 6.17-rc5 (2025-09-07 14:22:57 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-6.17-rc6

for you to fetch changes up to cdbc9836c7afadad68f374791738f118263c5371:

  libceph: fix invalid accesses to ceph_connection_v1_info (2025-09-10 21:22:56 +0200)

----------------------------------------------------------------
A fix for a race condition around r_parent tracking that took a long
time to track down from Alex and some fixes for potential crashes on
accessing invalid memory from Max and myself.  All marked for stable.

----------------------------------------------------------------
Alex Markuze (2):
      ceph: fix race condition validating r_parent before applying state
      ceph: fix race condition where r_parent becomes stale before sending message

Ilya Dryomov (1):
      libceph: fix invalid accesses to ceph_connection_v1_info

Max Kellermann (2):
      ceph: always call ceph_shift_unused_folios_left()
      ceph: fix crash after fscrypt_encrypt_pagecache_blocks() error

 fs/ceph/addr.c       |   9 +--
 fs/ceph/debugfs.c    |  14 ++---
 fs/ceph/dir.c        |  17 +++--
 fs/ceph/file.c       |  24 +++----
 fs/ceph/inode.c      |  88 +++++++++++++++++++++-----
 fs/ceph/mds_client.c | 172 +++++++++++++++++++++++++++++++--------------------
 fs/ceph/mds_client.h |  18 ++++--
 net/ceph/messenger.c |   7 ++-
 8 files changed, 223 insertions(+), 126 deletions(-)


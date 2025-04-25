Return-Path: <ceph-devel+bounces-3022-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B1BB4A9D099
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Apr 2025 20:39:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA112463180
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Apr 2025 18:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3459821767B;
	Fri, 25 Apr 2025 18:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nDKcDPoF"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565781A256E;
	Fri, 25 Apr 2025 18:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745606385; cv=none; b=vAbZ8I5nzpg60oQnxJ4jExOLT8qjEFbXX1Bp27mtazTaUo5KdiXyGhd4Cq3hKhJPOg7eCazG6hWr42H1fs7oZM22fUtJgp9MhbGND1J9ctsUgeQRrbYRpxJLl/eqwls6YSCksYUlFZnkF7zVobj24u9ieUpU56I4Mr3/I0JZ7J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745606385; c=relaxed/simple;
	bh=gcbMfwuchExgCIg31v1vUna7Oyyi0oWTiWY84a+dhg8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WvugIb2Irp4MTlwckfu8rotAwNoA0ChVAB5OeceKEGqfA1BF3q8dFTQ4VBUWwCSwlI2WRyaVhZ/J782KTTIwNDyPOljHCSFGvihYBfjD4H22CSa/wW5DBgpUCBuNopZ/eZr2xOZhsyq3keCPOYOvzcCf/cmEid9AkVp7OrdmKvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nDKcDPoF; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43ed8d32a95so22804285e9.3;
        Fri, 25 Apr 2025 11:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745606380; x=1746211180; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=igHnWocn5R9LyAG2oM7HyzlhM7FhyrOUUXReB1zj3bk=;
        b=nDKcDPoFoUtP7bsqqdcswkSk7yyc7Eoh+BSo+O7dkKVdHoKCPwv2wRxWOo5Pi5v8bs
         W+hbWb2l9rAnaUXdSdp3CNTXbYL8XN5O/rt9d32LZ3TM6kc3lH8yBgtNCxoqv2rhHdFQ
         wDFIGXY3nFRmA2RnKLtIEa9uXa0eiLsr3sHmFPU4yt/VbA2Z7ZaYjhTvvPMOMvM6OU/U
         g5gMq3x1loGWSrI9WEsqWhQuzEEM3fafLHW2vEbiPC+FpXxjrS6m0tNM/CXPDO/QN8aG
         wCRGzvaTL5LqhkTjQR+lACc5SW6Xq4uKE3OCGmYMs+cES+NinJHElcN+Qqz8oj2kEBas
         68EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745606380; x=1746211180;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=igHnWocn5R9LyAG2oM7HyzlhM7FhyrOUUXReB1zj3bk=;
        b=EdWPEwWhCNuoD8/OxSqzBKI/CXIDUzO2Vmi54hF6rEg7coqcDxwVY3YxodMrVDURJ8
         m/1k/5arJRNEVM1PwXJaD07VspRHxVRedF9WV1C6X78cXOsWGqxR4gqoigh6KuWkQLAo
         aEJ1zlHp/WoAXg8TUVJVxFiCv5244xtHoLcAW7CDsGCE/OaVOYYQtpBqzYgdmLt0S5+B
         ZeM1aRaOtig1YBbPLkUO4l5hVhJ6zbbuOvLZ/bU9KquhCT6CoKxSEaPxaY9MzF9sLAEZ
         elvfQmCutC+iZRwntaHGOc/dQ18qM/JSAigm1xdtphUCkuEFCWAEJjHMByMexin4hw8C
         h8tA==
X-Forwarded-Encrypted: i=1; AJvYcCVKsZ+4kgS2T2CANT8E1Dv0ZP5SEeQUYapxV4Z/vUFCbFRMA2RTFfQgckC/gBBo1QV62gmmL8rBn3jhQCM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yym9Y/Dq2ohHv7y0nAn8LZ+LJ7C6lSh82UYl6cy9kCmh4euNAK8
	PF0B8E6VSW+pW9lQJpoNfi2EV1e09+lLBXhg6DrM0bzVslTD8pJ9Cco7ZQ==
X-Gm-Gg: ASbGncsFhpehkRaOXz7VtbUctky8wlRj5QqsBLTGWAmV8VbIUplB8BHDRfs822dT2Qj
	/PtmD/4VCJbv2SUIktz2nbOAloX1OuQFSF8XAhHC0HfPEAdsWRO/d/QlRTNFdxwfeh0QLR4mq+L
	gyc6yOmSv3028mKI39QusIq5wlAcLUTWLr+vdnMgQ/e7KK/O6kQC2Ayjfsa01g5zxHWJeeZ5mDi
	FfC3CP7kzW7uBaKqzvbqeUPAftwRUiS0NArbLsZsmZY67eADGkiNEY7pIkpDKmxBExS6C9P6DiY
	TAVXe78S5DdRTWWt3ykSDnn9lBJoMkKK4w741ezEXFit0xHuiolz8Z7BX2EHTJKfCO/Ekf+e+ok
	d3g0Xw+tKBl3OpwT9Rq4=
X-Google-Smtp-Source: AGHT+IHj6IpZJB1Z0yK7CGubdXCZAXsRt2TUa2ds3VaS8TVBxn2HIBLywqSKFefoQQNIuf27uY1EJQ==
X-Received: by 2002:a05:600c:4e16:b0:43b:ca39:6c75 with SMTP id 5b1f17b1804b1-440a660a95dmr37717415e9.16.1745606380264;
        Fri, 25 Apr 2025 11:39:40 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-440a5369cc1sm32384915e9.32.2025.04.25.11.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 11:39:38 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 6.15-rc4
Date: Fri, 25 Apr 2025 20:39:22 +0200
Message-ID: <20250425183924.2739969-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linus,

The following changes since commit 38fec10eb60d687e30c8c6b5420d86e8149f7557:

  Linux 6.14 (2025-03-24 07:02:41 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-6.15-rc4

for you to fetch changes up to f452a2204614fc10e2c3b85904c4bd300c2789dc:

  ceph: Fix incorrect flush end position calculation (2025-04-03 21:35:32 +0200)

----------------------------------------------------------------
A small CephFS encryption-related fix and a dead code cleanup.

----------------------------------------------------------------
David Howells (1):
      ceph: Fix incorrect flush end position calculation

Dr. David Alan Gilbert (1):
      ceph: Remove osd_client deadcode

 fs/ceph/inode.c                 |  2 +-
 include/linux/ceph/osd_client.h |  6 ------
 net/ceph/osd_client.c           | 23 -----------------------
 3 files changed, 1 insertion(+), 30 deletions(-)


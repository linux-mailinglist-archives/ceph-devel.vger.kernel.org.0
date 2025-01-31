Return-Path: <ceph-devel+bounces-2618-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1598EA24274
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2025 19:15:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41DD3169015
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2025 18:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68B5F1F2C32;
	Fri, 31 Jan 2025 18:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OAgRtX8l"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808711F238B;
	Fri, 31 Jan 2025 18:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738347289; cv=none; b=TK6WFnO60G33OyGKIZ989tFM23ClDE2DrrF+OyS0+5pNo/GGvGpr3h1nb4sj7qTC48E7FCkqlsb9/Hwj2RPm7mdsKQftZHuQYQWT+DQHlP6Rxi2fXb3FMGKnHHTDF2VMSa6lx95AF2l59c5QLI+gxrP4xMuUS4KjXLP/Lqjw7Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738347289; c=relaxed/simple;
	bh=anQJSzUxW8U+cVQKhUOthp3ugwYG38yHlIVcGOOgMog=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IEpBrdSshpGp1foiVURCsxIoHbNEHuJE0Zo3Gn36IdvpmLEMQaehAT1fxvrlNQq40UaClfCuaUwnpdRFmFWzIErqMPqmM4m5Y+lbvJ8+W0N/a9Jy0za3W4mWRAZaDXQR9UgtppbzEpGctYPCv1H5mQoZRknVqqWEGMp7LVfPq/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OAgRtX8l; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43618283dedso23525565e9.3;
        Fri, 31 Jan 2025 10:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738347286; x=1738952086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=twg6JYyOJOvZqkdJ76pZB54ODqpgYmfn5BjcDhAkADY=;
        b=OAgRtX8l8HIAu3YBn277919OkFAM34h8QS6FNVTEA3I0gIpKFMSH8Ztgofp9xj7t0w
         zZKIJZen6C4jo0zWr6cCd2LKUFEPY0yRFm6EFZ7Zz4hGpPtEqSsaZ1JhaSMD3hn3oTZO
         bo/W04uLL4YfBcmAzCsMN3witSV5XMraPIxgJHHgbpRvlUo1eSpZ1J3PXDZDSOJTzP0k
         hvgfm2CUzYC/BYWacAk8g6licCoPOCyXcWUQfLEyMCxRsu97ixyVHYMgal9hh3hGJAS8
         5BI930pHqhiEpagCJ1g25BXB8LmQkXDdnojN8NwEmRrzGJyz/XIpzDJwEU5R9bjcgbxn
         v/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738347286; x=1738952086;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=twg6JYyOJOvZqkdJ76pZB54ODqpgYmfn5BjcDhAkADY=;
        b=Ro5X2j714MZjrOb/c0jm4UnIJedDnDPCoci8YYVKyGltgwaY2vSavvjvSLqsVuJ8Q2
         p1oaJnDrPjJqDgR6e2NknIUeGWE9ynlAL7NwPFM0/FeOa83zg+2xJhS0rQRDB/s9FSVa
         H61semKdfYXyDqh8Q5bMSz4v9S4lb32RYP2AcgYJ2D+jcJb8disB36a4sL7rkvRVFAa4
         TXvPeGam4/Orl6KoIR2AUGATlZADw0Ybc1pL/7aKHRxeZpZXy06A829r99hKYe32IcWB
         xqjTDCiVtIvzhbXPggqQ69RRjAtFwmJ6pW9evntDtCbIZnS6PubVgOdESHvIJt8GyNR+
         JYcA==
X-Forwarded-Encrypted: i=1; AJvYcCVljZLEux9BJz76i855OoMWy1vNJBalW1obaz7DGhJ1+HZ1Ys+UFGtAMNMTU2cURrMpdYpnFXa9rftrzHQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9VhTZuEPzugKG/axvL9FKRGDU1sjo3rfHUngEviVpelckjz/S
	+8iHCPT5c55h7aE+LYFzXZZuVOfPDSPLeUnZhIl5s7uGU7Uvtq9jKPvBGA==
X-Gm-Gg: ASbGncvMJ80okyCcJFyNkZHLyezCg9znTRk20nJqZxwYo0sBD6tF82SknQzlPpn3SRf
	NQ+4Y4/y3UICZVWffrsDhNi/LAmxSl56nfqdDbcNaoyyfuzqzWJ5m/N5VWGqlesHjrNgSg5S9NJ
	Jg4/AoSYP8nqscoIcZEmT8KTtzPESXUEiwJULW4Z4+j/RIKgdtUin+L1asyuPdshPbals6w4rdg
	+ck/+zEfAnvqcLJQMeNml9dRq/LJQgDX3XaCCbkNnWyf+FXnaerfPJ3LTZxsYqC0bIxyYBK3Spl
	sGEA2RDoWfuTs/tEszLTlfN7ag==
X-Google-Smtp-Source: AGHT+IEw+rB47H+JGUnXWRHPlt11RrbhPObbqox/RfcPbzWKlRuSASebdO/RGrFLq8bDubxgz4Oweg==
X-Received: by 2002:a05:600c:ccc:b0:435:14d:f61a with SMTP id 5b1f17b1804b1-438dc420083mr95909595e9.25.1738347285415;
        Fri, 31 Jan 2025 10:14:45 -0800 (PST)
Received: from localhost.localdomain ([94.112.167.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438dcc265c0sm97911025e9.10.2025.01.31.10.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 10:14:44 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 6.14-rc1
Date: Fri, 31 Jan 2025 19:14:22 +0100
Message-ID: <20250131181425.3962976-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linus,

The following changes since commit 5bc55a333a2f7316b58edc7573e8e893f7acb532:

  Linux 6.13-rc7 (2025-01-12 14:37:56 -0800)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-6.14-rc1

for you to fetch changes up to 3981be13ec1baf811bfb93ed6a98bafc85cdeab1:

  ceph: exchange hardcoded value on NAME_MAX (2025-01-27 16:07:42 +0100)

----------------------------------------------------------------
A fix for a memory leak from Antoine (marked for stable) and two
cleanups from Liang and Slava, all in CephFS.

----------------------------------------------------------------
Antoine Viallon (1):
      ceph: fix memory leak in ceph_mds_auth_match()

Liang Jie (1):
      ceph: streamline request head structures in MDS client

Viacheslav Dubeyko (1):
      ceph: exchange hardcoded value on NAME_MAX

 fs/ceph/debugfs.c            |  2 +-
 fs/ceph/mds_client.c         | 32 ++++++++++++++++----------------
 include/linux/ceph/ceph_fs.h | 14 --------------
 3 files changed, 17 insertions(+), 31 deletions(-)


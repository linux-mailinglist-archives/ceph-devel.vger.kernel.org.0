Return-Path: <ceph-devel+bounces-1813-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06538976DF6
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Sep 2024 17:40:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5FB79B217FB
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Sep 2024 15:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AE251B984E;
	Thu, 12 Sep 2024 15:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="KYutAf2z"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5831B9832
	for <ceph-devel@vger.kernel.org>; Thu, 12 Sep 2024 15:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726155582; cv=none; b=lywatYKaOU1Mu1Xdc75rQHoi4GA+kVAzS1/ceHLsiKMGqR3ZBbcpeJ1UgBo0bKqSJ2bG60kIQARJyBqZb856bT2ARKAHPUBiMq8O5bqfHIkOcoOwMCELUFzEWabgsBbXJacEAVEYFOWC2KO93KjSyLH1j42i+ZCsFuOX7pEIybg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726155582; c=relaxed/simple;
	bh=36Sxi+gbBpE+8wmTVMyJTVNzyvmV3WPwvvIGgTk/KzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bdbp7+O+yaYyTwJWed1YCCxmDU0hzpJpaNPvJ0oKdNICCMNxh+mKxJzezOOeYFtHX1/1GkRRE0Jub3Jv/bWSrRIvkYLcpxcI2l5th0EGT4c7v1BK3a3++HhYlDwDM+b6e8QRBtwwZDVIogR/BBo7SjHAFJwXAvF0IKFG6DmurGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=KYutAf2z; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5c254a544bfso157002a12.1
        for <ceph-devel@vger.kernel.org>; Thu, 12 Sep 2024 08:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1726155579; x=1726760379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=z9euUjqtbYgwWwgE1/oq9DzNoO18ZxptGpiy8C+yuEE=;
        b=KYutAf2z6ZdLzRKbhPktFomiuVkRknUGUH4UeVhcTvTkCE+NxdsnddJuRg7m9daqro
         YRZTGuNzbQwzuZQilReSOzgw9mAvQBLB2RnmuxaC4SYBlmWPiDn0wG2Kh5MkphFTUbNz
         xijolhFaPcF+1VzcT6T4iw0H+I/JKIYEqa2R9i5Y1y9MIXw3fWGnq5g44paPhJ1E2KoX
         7rH7km5U5ik9Z8Prm6lcGjippwCKjCFCh67Xwl51WTvxxUhGX1LgAGcbu7PhICmqxcjd
         NBaIGgx5Tkye0zMpIw2JCbn6/oRx3SqVgFI9yhrgc2ndkSJ7c6JiEZklnYWtckYRJf9a
         nqKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726155579; x=1726760379;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z9euUjqtbYgwWwgE1/oq9DzNoO18ZxptGpiy8C+yuEE=;
        b=p1UgenwYFQnG8Hz57Q3PVAa0wLEmhVaxlETlibujzhcBkkqSQp3VBbrTtHtIHPqwlK
         h9DGohyN9OHWAXQwiA8XgroBc4dvUZmNDTvb7imghU9gHybTHzj49Fx29Wvq4urDT4Jj
         WMbMqZ342HSUJ3+Yu3Mx2zs4VsFEre1jZqe4VVW5QtvqZLi50ADSfBsO2grDInwnjRfv
         uj/nuixu2AChIyW0Qd9WIf7wtQeynWjagLGUjnSJ1oGskZs/dLEv+6xD07ZPzhOHuGDZ
         twM+GmPzx4Ksx5smCxIC333ttPoO9B6k4rWvUEWd2ojGlxd+vParMc32epcTajNULnlU
         kyzg==
X-Gm-Message-State: AOJu0YwKzNvm4iXii2GaPP1NuLX68KQ2ZsalAaYdO17CMw+FU0rxCEaq
	kIs2IdRKEMgBj4WqwyVimqWVeVagn65Ix+gCrRbKIgdBhs2zeKmZ8Kl44hZs9dE=
X-Google-Smtp-Source: AGHT+IHCqQ88trVe2YKiL2igp8EWFO/FeGG+AEqn7eeF6kH5sk4mmdw/rmPnL7ucA079Y/QGVbLl/g==
X-Received: by 2002:a05:6402:2113:b0:5c3:eb29:83ce with SMTP id 4fb4d7f45d1cf-5c413e60babmr1334577a12.9.1726155579239;
        Thu, 12 Sep 2024 08:39:39 -0700 (PDT)
Received: from fedora.fritz.box (aftr-62-216-208-212.dynamic.mnet-online.de. [62.216.208.212])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3ebd52135sm6694734a12.49.2024.09.12.08.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 08:39:38 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: xiubli@redhat.com,
	idryomov@gmail.com
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] ceph: Use struct_size() helper
Date: Thu, 12 Sep 2024 17:39:24 +0200
Message-ID: <20240912153924.78724-1-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use struct_size() to calculate the number of bytes to be allocated.

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 fs/ceph/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index c4744a02db75..ab494f250d80 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -2133,7 +2133,7 @@ static int __ceph_pool_perm_get(struct ceph_inode_info *ci,
 	}
 
 	pool_ns_len = pool_ns ? pool_ns->len : 0;
-	perm = kmalloc(sizeof(*perm) + pool_ns_len + 1, GFP_NOFS);
+	perm = kmalloc(struct_size(perm, pool_ns, pool_ns_len + 1), GFP_NOFS);
 	if (!perm) {
 		err = -ENOMEM;
 		goto out_unlock;
-- 
2.46.0



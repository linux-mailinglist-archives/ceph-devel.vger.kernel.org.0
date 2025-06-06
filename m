Return-Path: <ceph-devel+bounces-3074-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 53E41AD07C2
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Jun 2025 19:53:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAE171897D03
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Jun 2025 17:53:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7F31E231D;
	Fri,  6 Jun 2025 17:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IIHrlvB9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FED11534EC;
	Fri,  6 Jun 2025 17:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749232395; cv=none; b=s2NZHSYou84Cj9LZiPM5TRAoCoGCn4Z6Yyfi1EB6CiR4d7hZKZeUnPM68Wp3BsAC4Xc23iML37M6n9OBevFR4DWUiAwEXObM6JB7cm+ZoKRHt5e890gBgnET+ZH6U82rbVDhh8MCk47NT6AAYkKEvTSI2ieQ6shS3m+XsdDmSOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749232395; c=relaxed/simple;
	bh=DrrfqHnraMiRVZbG+cy686JkCQzye8ccB4mjKKaNXwM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Map5JcqStJTpYkxaCAwXPiLEqJOMFHPvZBJO1YoVllwF5C/irjwDaNBN1fxJVEsy6p7x6DIKjb2Uj3DQwPvG1C8FboJvw5ae6TxzZF+4AgNTzbhX+zCy4wC4IiRKL72gaKKwp8bchF5Ef72DqFA9IQymp/T9grxofnsSJ2tfT5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IIHrlvB9; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-450cea01b9cso7943435e9.0;
        Fri, 06 Jun 2025 10:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749232392; x=1749837192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9WHVcosRfK50Pe35UJvolvwm9bCStvOoRRlpJoarK7w=;
        b=IIHrlvB9UIn3dRDxaEkSUDlO9rmOYID1uj2yAMzmTvyiFEaMC6Z0Y36buQhyvWffEg
         XHmP2WsVNJJeIPK3V2Ygp9KTvpOryTtQef7PetSjV8xn3dJn9AsBabZlxEmjQR3Q0b1b
         DUzrb1eZJRlF2oaKUF7/QyO9lCZtkjIrIz+h3wT0h9BGKJMDcLogMSAfgCSdX1jl3EqI
         +jOxNYig04/6UavNnrkJwUxhR+D1NGRze75z/Eewft7eL88vlVbltNNbcAVkedawFjsk
         LpX/Z1e6ogQLV4VCKRiteCZHEhhS3LlayxiUjm4gMUbr5FyXSu1FoSjtzrH4cJvNALEi
         WtpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749232392; x=1749837192;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9WHVcosRfK50Pe35UJvolvwm9bCStvOoRRlpJoarK7w=;
        b=AfwIDrNUhGxbdSJHfx99OVeCIvoSFaMWcMtkBdYI++ZqcEMQVBoJBk2ZJbYfca93HI
         XcXu4EI1+zjL8Qj0SXTYcLavzD9Pn165mOe2gvt3079jdomvGEL3jhckSCqW7Dl55VGP
         X+rYQAooCltSNqgzXfedYx1mgUthm9ft0tnfN4FqK1UTowZSF20hD3M+eMLkBoT9ZMZw
         Jsbmq4kcQYzS9Dk2ZUaLdWSKXDDpvwLvGKmn/8mK+lQUAFgp+n4j/3DOyJQjyNBWdjH7
         cSL0RoPcKOzddAzf2JO736zUm654AFocth8590LtMYhBZRmKLEybbFnFj+EvaJYyaVK7
         m/xA==
X-Forwarded-Encrypted: i=1; AJvYcCUdkTxd8nF3E44Xq1L9MC0iR1lt1dUAMC8kXWE/pnMMmzQ8GvG1TjkzwdvaH3SrjPS/Sof21rncIy98tX8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFQ+Dsnt1dBlSUYPL7yOmlzXhb6m8RcQbZYpfLo3lCRmAC9sqB
	NnZb50YbSAuWgt6EJsGRDrs6QA+9McyUR8Na1wymvl2vfwwsxHNxsjRiHpwx5w==
X-Gm-Gg: ASbGncs/mML5HS0X5rP+OW6EMnoEjRSn7NBtjrDD7BjGLGI63p11I872uxjf28x9jrp
	6tJQHFq85Pl8r2R7mdS5vdmIERgdtmpJSR+EUZRfd/STTz94fXX7vBgL2knEqAL33HXT9LiERXP
	+GzmN3wjMKuJUJEAW6HCbodi/KbRgU2B3sBPhZoa2fioe/ZwBINwggrTftMTUef52nCNSmgakCC
	0atX2pX4fjFg/xtxjdrQRkeUSzMOCskv9SxB5E8vUDZUBmuJ1HCmZ0smabCrLxwIYmuWqK5rCif
	pDTs9tyIQrcstRnz80oo3GZNyqb0bY6ql3BnqqXyIBYgpEwxM71ZugJIO/7pN1lHNzNI4Nd9YrU
	QbkKms8FhvkgHl39oUY9cq7K31Rz9Ow==
X-Google-Smtp-Source: AGHT+IGr8PGqpAet49FSV5u9GwbjS5WXDSxlVc/X7saUGtXSrjQpzMXDvfMK9+KybE1j9p6RThQgYg==
X-Received: by 2002:a05:6000:40d9:b0:3a4:d4cd:b06 with SMTP id ffacd0b85a97d-3a5318a06b3mr3525989f8f.34.1749232392128;
        Fri, 06 Jun 2025 10:53:12 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a53229d96fsm2504582f8f.7.2025.06.06.10.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 10:53:11 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 6.16-rc1
Date: Fri,  6 Jun 2025 19:52:35 +0200
Message-ID: <20250606175250.218814-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linus,

The following changes since commit 0ff41df1cb268fc69e703a08a57ee14ae967d0ca:

  Linux 6.15 (2025-05-25 16:09:23 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-6.16-rc1

for you to fetch changes up to b828b4bf29d10a3e505a76a39c4daea969e19dc9:

  ceph: fix variable dereferenced before check in ceph_umount_begin() (2025-06-06 11:08:59 +0200)

----------------------------------------------------------------
A one-liner that leads to a startling (but also very much rational)
performance improvement in cases where an IMA policy with rules that
are based on fsmagic matching is enforced, an encryption-related fixup
that addresses generic/397 and other fstest failures and a couple of
cleanups in CephFS.

----------------------------------------------------------------
Dennis Marttinen (1):
      ceph: set superblock s_magic for IMA fsmagic matching

Dmitry Kandybka (1):
      ceph: fix possible integer overflow in ceph_zero_objects()

Viacheslav Dubeyko (3):
      ceph: avoid kernel BUG for encrypted inode with unaligned file size
      ceph: cleanup hardcoded constants of file handle size
      ceph: fix variable dereferenced before check in ceph_umount_begin()

 fs/ceph/addr.c   |  9 +++++++++
 fs/ceph/export.c | 21 +++++++++++++--------
 fs/ceph/file.c   |  2 +-
 fs/ceph/super.c  |  4 ++--
 4 files changed, 25 insertions(+), 11 deletions(-)


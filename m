Return-Path: <ceph-devel+bounces-1568-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C772793D541
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Jul 2024 16:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D24F1F24ED5
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Jul 2024 14:42:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 269E91CAA4;
	Fri, 26 Jul 2024 14:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ELE2TAuZ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFF217583;
	Fri, 26 Jul 2024 14:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722004953; cv=none; b=R/frS/gDCJ+uTo2sf+X6/IwieSIfslnnBOs4j4p9RrGGC3+2gY8rL3qQ7ooJu6nR1taj/PzVn23UqaEvpxwvxQl38dFDRNM5g1sy4kxi8ILKUMedseOlqPRwR5wPU37VYfK5wUj8znPH6UOgGz/gE1NZYfBDTExwiJPAKqcPH3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722004953; c=relaxed/simple;
	bh=JnqYVeMkZ5P7NJvf3bOuzkjdymBiauzlUv3ZofhKh8M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aNCyreDKQxnJ9IDlfDijAVZTym/znSlbTDewfVt/3jXIYbXb8GHORAMNTq31APdXvi0br+ZXR0FHXnaSHDXb2pjySbeXA+TegI1xNWi+upN6pnWll5FLLHtdv5w0sc3x1Rc8lKhb0Lld3h7E5Nu9NN2BDwCQRlDLIRxkkXo5y5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ELE2TAuZ; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-42809d6e719so9169595e9.3;
        Fri, 26 Jul 2024 07:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722004950; x=1722609750; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFrlJv+a5LiLu9tm09qkDCsX61n48yEq7Yy3GdcUzE8=;
        b=ELE2TAuZ4C2i5jKsIWN9Nv1W1fViuoGqFPl5ht9Xxdnu/axaDKuRNfiw5iOdQDI8PE
         JyGatnLezmorsARd2GO+THtXxdq+o/PRCf0mtz9GMn8akr6LFEwoUzW6fTiDDDJZajF+
         QKDSr2r4nYLOvPkw44BaaBIDJ7lszt2a8Rtry9tkWv7FOC0XCgty549NoiAsjcQbZEIb
         hZvkKE0ZtUf48Vu3u6umbyTtdkRSH1aRnbjDKw2iX93WSgMU3okh8bf0OcapOnigOzSs
         uvZ0Ye7JFFnp1GfkA/MQ5bBnTWMCX4XwvAnXkJtNqkJkUXC8+1nqWp7a3Ta6jueNtXpn
         5L/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722004950; x=1722609750;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZFrlJv+a5LiLu9tm09qkDCsX61n48yEq7Yy3GdcUzE8=;
        b=Luh11XzGfjvDGeqyyDE3pTSH3fWsl9yoSXRmAKBUXZOE2l+P6BTrIHxzs0Wl0ajazi
         dVNu3y+3xgWBj5nZ/zuLuQf7GRjJH7vSzGUVWvoLOR0gU/rNP7/KgYGcIcCL2SMMMKnn
         DNUNfoK2rmE9gjCQqekAXH++O7OXOeRQdIfSXrQK8Y97cEJgTx579QGm/ECMRmjxquiy
         lKd1Bhuj5JwaZdEnmzLDW1YPJzxptJIpDh/y+/DLFjHFplV2fFd1S7QqD4MnaDoO86e2
         TcmmuWZeVYxIBlI0gffTJ3UqYSRiKcCF9Evk7tlxn6OcgPCekM/oHVVmgQ42WlfYpEGk
         EGeA==
X-Forwarded-Encrypted: i=1; AJvYcCVpxYjFpmZd/Y1f7+/4AUboRMAF3zIJY8Eyf1QuvZZCAoyVhMwlsKbkhgjFxWH/oO8Db4grXvEYR19E75zMUx3JH27XUo7bq49WCA4S
X-Gm-Message-State: AOJu0Yw+XKbGqg4Z7cFNFHuOckkj9fyqEwzfBi2SOESTPjvj7czsLSC3
	woMjTMrt9CmdfHd669lrT4QwwlDiasokr96vccbQuBy1ypiJYbuG
X-Google-Smtp-Source: AGHT+IFvNXklsIV60gmKS0gamXLxzmSNPl+zpMy+OnX5LvdEKCjJEC9CbyREaRpzn33IIvRp9+GSug==
X-Received: by 2002:a5d:64af:0:b0:367:4e1a:240e with SMTP id ffacd0b85a97d-36b31a4188amr4969607f8f.50.1722004950301;
        Fri, 26 Jul 2024 07:42:30 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427f940e62dsm125608565e9.39.2024.07.26.07.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 07:42:29 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 6.11-rc1
Date: Fri, 26 Jul 2024 16:42:11 +0200
Message-ID: <20240726144215.738251-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linus,

The following changes since commit 0c3836482481200ead7b416ca80c68a29cfdaabd:

  Linux 6.10 (2024-07-14 15:43:32 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-6.11-rc1

for you to fetch changes up to 3ceccb14f5576e02b81cc8b105ab81f224bd87f6:

  rbd: don't assume rbd_is_lock_owner() for exclusive mappings (2024-07-25 12:18:29 +0200)

----------------------------------------------------------------
A small patchset to address bogus I/O errors and ultimately an
assertion failure in the face of watch errors with -o exclusive
mappings in RBD marked for stable and some assorted CephFS fixes.

----------------------------------------------------------------
Chen Ni (1):
      ceph: convert comma to semicolon in __ceph_dentry_dir_lease_touch()

Ilya Dryomov (3):
      rbd: rename RBD_LOCK_STATE_RELEASING and releasing_wait
      rbd: don't assume RBD_LOCK_STATE_LOCKED for exclusive mappings
      rbd: don't assume rbd_is_lock_owner() for exclusive mappings

Max Kellermann (1):
      ceph: use cap_wait_list only if debugfs is enabled

Xiubo Li (1):
      ceph: periodically flush the cap releases

ethanwu (1):
      ceph: fix incorrect kmalloc size of pagevec mempool

 drivers/block/rbd.c  | 35 +++++++++++++++--------------------
 fs/ceph/caps.c       |  6 ++++++
 fs/ceph/dir.c        |  2 +-
 fs/ceph/mds_client.c |  4 ++++
 fs/ceph/mds_client.h |  6 ++++++
 fs/ceph/super.c      |  3 ++-
 6 files changed, 34 insertions(+), 22 deletions(-)


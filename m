Return-Path: <ceph-devel+bounces-4174-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF75CB99DD
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Dec 2025 20:02:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F2C383069CAE
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Dec 2025 19:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B88022F74D;
	Fri, 12 Dec 2025 19:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AYovUQ3O"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5FF145FE0
	for <ceph-devel@vger.kernel.org>; Fri, 12 Dec 2025 19:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765566153; cv=none; b=WJUsXCPo52gyImFxT+zanm6Qn3uKzkXPa21WrZBug5P2I96q3MI4h64NQ0aocEr5qZO5e0M01rnzDdpqjrh3dPkx31237aSN+wwEdmv0V6NSqG3NK6MWfA11QqUEX3/akf1CRmZ/3LhCEuM8HV7Wjod6Um6rR65DTaxvEa2Y4zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765566153; c=relaxed/simple;
	bh=Tx/P4rPgjUOTL/5oPVPr/Zgvq6dvNYtkHHLtmERCYCw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G41/XH/yRdNAnJX98V9WIkXaOF9YsG60qUyJv/ELCPzNDO3o8/ZILmlkbDHA/qmmBUkD+vy5tn55c8BYGc1nyEGJmQ0LSybfitN784GfMG9aoqy0b110ZT5em8jZkmC/TKEJ/7G0T1eO4ovlMu41I5K3VkYyWyGYhGv0E5ds9LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AYovUQ3O; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-477632d9326so10243475e9.1
        for <ceph-devel@vger.kernel.org>; Fri, 12 Dec 2025 11:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765566149; x=1766170949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ALjlP/YZM+CLMeajHBSIgsf89kz+mcUZBKGmuXpgx1Q=;
        b=AYovUQ3OUIMjpMB+9k0Xt6hiciP1EdBJ6WqZz8mgVt2NcKFzqdxA7bQYKRuCzSTIUj
         RVHtK/23jn0KF2MNZEnKs1NXd8es/yVBhDt1bCk+U5dNeErYwao98VCQVTjnKocF4676
         I0vswTJVOTH+y7oAv3faJHE1pOUipNMFP9ePKWXW/UbvpzzR8MZk1tv2tTo+ucIoLYNe
         zxOOAiKNCKrVBm9uE8v7ZXcXLxcPs7XPhjb0EJtcrL0sBR0b0pK1bPK165++AJeZWIvG
         BH7iO9XkftjtbXto8je3dA22oS/xaT4ptS9bwmDW/meQx4Qrx8Hw7XYUjatv6EjZhLSG
         BDIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765566149; x=1766170949;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ALjlP/YZM+CLMeajHBSIgsf89kz+mcUZBKGmuXpgx1Q=;
        b=QISFzpv/r3nWFXFWrZTj0WJAB9I3v0KNfw8gu0oVOhRHsttz9igLG9kF8htkrwvlXY
         8uT5GZyVrbqC4feq9AqJB9nanGsC78Ys3h5WOlCPlTvZgXjdOnatA5HFmp+ewGSYJcv7
         xaHduFbhg7o7d4vQ9qnmFJFNlDznL0LA59AbQv+dbCscu96iB9T8L78+gH3RUshAhuiz
         /IBBXkekHdXwUhdUFw7WtKq49Q09UNH6m/SM1ofo74KYrh5LqcqIO0i1AOeePSnJLm2Q
         GTR48F9HSCuD/4LKNE5bp0I3L8oFcecOv8haHFDWwJgl/MYGRk8sTRXz1d5GTexJng4X
         AQ/Q==
X-Gm-Message-State: AOJu0YyZnoiOnalH2H/542nQ/SXb9mt4EGYbYydQkb90i/JI2MEz2bHB
	ryC/RTekaJZaP5vqS+3/uOEMEu0h1u3Zbl560NXmLSwf95IE9aGyn54bWUFD9A==
X-Gm-Gg: AY/fxX5Liadggbt04HKoiSRUP5IkARQR3yQ3TxWAHUw7I6+lr5iR6eeJTl7Wu7vxcb6
	sP+w8sWeNNEfzCeRipcxT44dpDnKXBn88YDwikVEaOgp8xfK+1VchzrInNaGc0rE4IeCIicznFA
	bwNYsGjQpBlJX9jKRiCp+cfhKex3uMTZs5g2AmjICR1+/tiCC7PC9HU0uv1X4gmZ+Av9wpiB6Js
	zdANIBTgqyfinzzrez25obVK5e2y3adcTwd48tpRwNNW3NRfdmSLgoPVfT6uuHMmTJMEFsYs8A3
	C8Fqzgc9K3PplQiyipw/SnQpqeO/7awkeA+cuwY81s/4qMLlCcCS9zjbPcK5CQPDHnT5xrloexE
	VijHxSh/vfbjR84qkKSoLY9ZlQgaE5hHEMSV1lPjyXtVtbZAJr7SSbwfCscfidZhuKuIbTm6mhw
	Ou4gxpZmQTVMZ4RDMOc68OGutMEU+aui5EitdPAdoSaNFiYU2GsucPbKcwhplyod7f
X-Google-Smtp-Source: AGHT+IG8rA3MqQnT56CK7EcZUOlc3n8NWgG2L43fRkL3jiZQJ4xVLSgjyjpyI4kze3SUx5TDjg0eLw==
X-Received: by 2002:a05:600c:c16f:b0:477:abea:901c with SMTP id 5b1f17b1804b1-47a8f8c0a16mr32593705e9.11.1765566148711;
        Fri, 12 Dec 2025 11:02:28 -0800 (PST)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42fa8b8601csm14660538f8f.22.2025.12.12.11.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 11:02:28 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 6.19-rc1
Date: Fri, 12 Dec 2025 20:02:12 +0100
Message-ID: <20251212190213.3275119-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linus,

The following changes since commit 7d0a66e4bb9081d75c82ec4957c50034cb0ea449:

  Linux 6.18 (2025-11-30 14:42:10 -0800)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-6.19-rc1

for you to fetch changes up to 21c1466ea25114871707d95745a16ebcf231e197:

  rbd: stop selecting CRC32, CRYPTO, and CRYPTO_AES (2025-12-10 11:50:54 +0100)

The reason I'm sending this pretty late is that I was waiting for
another fix for a regression in CephFS that was introduced in 6.18-rc1.
Unfortunately, it didn't get finalized this week.

----------------------------------------------------------------
We have a patch that adds an initial set of tracepoints to the MDS
client from Max, a fix that hardens osdmap parsing code from myself
(marked for stable) and a few assorted fixups.

----------------------------------------------------------------
Andy Shevchenko (2):
      ceph: Amend checking to fix `make W=1` build breakage
      libceph: Amend checking to fix `make W=1` build breakage

Eric Biggers (1):
      ceph: stop selecting CRC32, CRYPTO, and CRYPTO_AES

Ilya Dryomov (2):
      libceph: make decode_pool() more resilient against corrupted osdmaps
      rbd: stop selecting CRC32, CRYPTO, and CRYPTO_AES

Max Kellermann (1):
      ceph: add trace points to the MDS client

Simon Buttgereit (1):
      libceph: fix log output race condition in OSD client

 drivers/block/Kconfig       |   3 -
 fs/ceph/Kconfig             |   3 -
 fs/ceph/caps.c              |   4 +
 fs/ceph/mds_client.c        |  20 +++-
 fs/ceph/snap.c              |   2 +-
 fs/ceph/super.c             |   3 +
 include/trace/events/ceph.h | 234 ++++++++++++++++++++++++++++++++++++++++++++
 net/ceph/osd_client.c       |   6 +-
 net/ceph/osdmap.c           | 120 ++++++++++-------------
 9 files changed, 316 insertions(+), 79 deletions(-)
 create mode 100644 include/trace/events/ceph.h


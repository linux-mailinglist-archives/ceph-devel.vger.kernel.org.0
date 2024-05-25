Return-Path: <ceph-devel+bounces-1161-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 115768CEE66
	for <lists+ceph-devel@lfdr.de>; Sat, 25 May 2024 11:58:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A0501C20A83
	for <lists+ceph-devel@lfdr.de>; Sat, 25 May 2024 09:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A26320DD3;
	Sat, 25 May 2024 09:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZAQbjCXT"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF883208D6;
	Sat, 25 May 2024 09:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716631088; cv=none; b=bf2lvNvWnBYZ/RrdVQ/2cEqRCLFB/woI3NPM7SXGWUc92nikI4b2s1+1hDRSG0qsmGYvvF2KIAxHd7YS3JfK57uHcvGm0TL9SFVRyRZ9oCAETb68WyiT/Id6u1kLclBGxB0zqqcbPXL+VVinU9IS6kutERE+DF7vQ5dyLr3MhAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716631088; c=relaxed/simple;
	bh=uVSIth6ogeOC/8FQzcjH9y0w6jOWh1Y0ZlSRtiXqTw4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GhYEKZhJ9ETMkLdVCeNxwpHeAtB5PdhfckoAyeQr6epSnk3Y4tlQLQwbvF9ro2bDq49G55srkdk1VdRcbXsWjhfBUTAjaLAkGmtPlh3PB9P+0hO1ha1sdDWTYw4j6x28fyuNsE+yIL6cnMiStmZVyAWMsA5XwCklkbGZqXgpBzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZAQbjCXT; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-529597d77b4so1662731e87.0;
        Sat, 25 May 2024 02:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716631085; x=1717235885; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G/oK9VbRLSqksA3s8yPL/Mo5ZKUPSWzfI/BM0U3lWD4=;
        b=ZAQbjCXTgGZ04jt6okbx5HyEiVAB9pCkZ4nwHr9GIAPFnZrlpomkQ1Lav86dIe/x9+
         l94lcfywuWixs2yf0ygtOXJlEo7pxI/s7MPHuzJOTs3YOt92OGQxD4QlOTMXswAGpE5I
         XcGnrqgKwyUUfap1IZ4ByccriR2XOu03+Gc/P8uBt7umI5Ski2AOwox82tbTzd1nzRcV
         RCddDBEMkrungKtC6qoOlWNq1FsmzvAQpHw1LQRAvxv9ztaI3Clxs9Sn/cEPBuo3v4zy
         DF8TclpwvnFdi6AjP4kCGSoAz+9zFzb4AP05ddn/ytE+sTbk4CRMa5Ok1IjGsD2YgPoi
         gyWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716631085; x=1717235885;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G/oK9VbRLSqksA3s8yPL/Mo5ZKUPSWzfI/BM0U3lWD4=;
        b=jHuG9sj4/eiiOIvlpC4IXfCFhUGR6ZYoa0qXPZoAST0sYWvo7lC1zTAxl6sRdzvAyV
         FIyd7fTstL3kHKui838hsfc2qWbiPn6nsGLEqCfGDhqhQslXaQwnUgEkQZjlJjwxFhSf
         nGn16XDeRcgZ8SjBtre1gkxzMqqcNQFSCSrUYvsbpPL4ZSyPBLmlVUiiZGVfrtTbwb4h
         7dIZpAIRWIKvA6fcu7J6lQiBBI0qNgxKWlYKAm583/GvQwsLPmVHxHx2pi7bOV7FeZne
         3TuiTHlNrRz1WcspYhogWBPn2/X8BMtVhY0H9xPs4WFpNCQPl6lE33R6wm0MoAq2IA2U
         y+Ag==
X-Forwarded-Encrypted: i=1; AJvYcCUUGcDfl05wd1BLvcVuMDfIVGMnx1Mse1JqLKfvx3spe6OSGtiJ8tMwLrTpXeuYLNFmgTw1VWMgZthojZSNyesiUK4JBQJiGrCKK7Ha
X-Gm-Message-State: AOJu0YxVAgL65ShlvmmHrc6/0uAGmMqf+Gi9TckLIX+mLOJKhyQUY1mJ
	Y9/u6H4oTpLPo5eXTIfDscRvEhF8MqxVSvpaqByEaF98KKWzgvJHS3plx5If
X-Google-Smtp-Source: AGHT+IG2M3nzhep0olkhXEKvEzVhg9J40leNtuAl3S+t1h+TD9xTwQ1I/O+XdGle4xU4PPu8l57w7g==
X-Received: by 2002:a05:6512:68b:b0:520:7a44:3f30 with SMTP id 2adb3069b0e04-529645e342amr2766068e87.16.1716631084319;
        Sat, 25 May 2024 02:58:04 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42100fad965sm77025795e9.34.2024.05.25.02.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 May 2024 02:58:03 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 6.10-rc1
Date: Sat, 25 May 2024 11:57:37 +0200
Message-ID: <20240525095738.3046298-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linus,

The following changes since commit a38297e3fb012ddfa7ce0321a7e5a8daeb1872b6:

  Linux 6.9 (2024-05-12 14:12:29 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-6.10-rc1

for you to fetch changes up to 93a2221c9c1ae32643df67c482dc4c4c591b7514:

  doc: ceph: update userspace command to get CephFS metadata (2024-05-23 10:35:47 +0200)

----------------------------------------------------------------
We have a series from Xiubo that adds support for additional access
checks based on MDS auth caps which were recently made available to
clients.  This is needed to prevent scenarios where the MDS quietly
discards updates that a UID-restricted client previously (wrongfully)
acked to the user.  Other than that, just a documentation fixup.

----------------------------------------------------------------
Artem Ikonnikov (1):
      doc: ceph: update userspace command to get CephFS metadata

Xiubo Li (6):
      ceph: save cap_auths in MDS client when session is opened
      ceph: add ceph_mds_check_access() helper
      ceph: check the cephx mds auth access for setattr
      ceph: check the cephx mds auth access for open
      ceph: check the cephx mds auth access for async dirop
      ceph: add CEPHFS_FEATURE_MDS_AUTH_CAPS_CHECK feature bit

 Documentation/filesystems/ceph.rst |  15 ++-
 fs/ceph/dir.c                      |  28 ++++
 fs/ceph/file.c                     |  66 ++++++++-
 fs/ceph/inode.c                    |  46 +++++--
 fs/ceph/mds_client.c               | 270 ++++++++++++++++++++++++++++++++++++-
 fs/ceph/mds_client.h               |  28 +++-
 6 files changed, 434 insertions(+), 19 deletions(-)


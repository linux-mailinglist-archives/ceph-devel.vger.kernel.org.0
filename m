Return-Path: <ceph-devel+bounces-2230-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB0529DEBE8
	for <lists+ceph-devel@lfdr.de>; Fri, 29 Nov 2024 19:03:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C084163A3C
	for <lists+ceph-devel@lfdr.de>; Fri, 29 Nov 2024 18:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C6219F104;
	Fri, 29 Nov 2024 18:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gwlvj2aH"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152644174A;
	Fri, 29 Nov 2024 18:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732903423; cv=none; b=YOOQJgIqsrcqnXOOwf+eKIZtmrQRxwTKFjuSxR6axfSqfXqA3vbNfQZvwjTa6dVio4OZCa4Z0+fWBNZ5Y1gSo0q8y8BZhwqwZR1Jl1omkBJGpfB3Dc+PRO4s65MIySpwsygtfNSxqri/UlxRZrN+UnxotVc5Gic1//wXXLUUBH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732903423; c=relaxed/simple;
	bh=Gv8S5x+l392hhvijDUS3z1OIN++s9eaH4XpkiQ65nk4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WBtTxG5Q59dup7l2Ig055m/0dlbRmd0Y75SnxoO4XPZnh+AX2Rav3dhXyRSa2m+k6kSQLjK135F/b4n+Hrm3YYpWNa4/72rCJWZS5fMfsYDvrqaPnsFCJGHrupCB2vgfU3VpQAPp9o1m2c+Fc3nSJNmzZGhvTvnE7dB4pfr3zIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gwlvj2aH; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-434a90fed23so18825275e9.1;
        Fri, 29 Nov 2024 10:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732903420; x=1733508220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CenMzMPai/pxzLt396YWHlzs8SLJnNTmo3RXnhT7Koc=;
        b=Gwlvj2aHOLMFqwGrfTdj4MEzxAkqA1GAgd2qk49d5JJJYcfxDRfT8H/U2MrxVdzLLj
         FeT8C/U06Dd1PcEp2gYpHZZRNWNY2hCLvg2nTOYtXon3b/EqgvT2E/9VJuPbh48lctx5
         bGvDn5Qk7bkRLTz57KwOomKxGYly4/rUu5Ywrth/A9My+LXwlyja8+xYKoQNAIY+3Z+d
         nFoI+z+2ITDGc5ZN4PePoj8iclJT8qqiLOcwBcLKVrMJuT2SAaQn1ZddyVzM2kwNBip1
         stoe9hg1dKpwOtztY/U2sIZT9s3n7p8IFNqKu8trWNgehG8IjpBy1ifWtQg+jbpsQwug
         /5Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732903420; x=1733508220;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CenMzMPai/pxzLt396YWHlzs8SLJnNTmo3RXnhT7Koc=;
        b=jtyXG+qRCdAYVDHWrizCB668N1ELtiCcFy2fKHicpo8oJoaUXWJ6HmXqpb4h068UEv
         slA+J7gAzai29DvJs4Gr2Jtr7oW9IIOtzOMgVbh2zPcHqL8X/Wrg1Cfk0ofbFsqkDlEp
         pke0yKHsztJsrt9EXjKR3Z5v+4cwprE5KLyopO3yV8rpoU45uwR3a9aRLHYvy2z/PfGP
         BOc78FIjQ96SQO5ImzXoNBY9UKKCUDaDQg9N1vg8Mz52dirJLAhF0UphabQQhWH2LNe8
         +S3dscSY44JYJHRVfG6yEAZX0lhGcZNS6Ef+qr7/FHGSjKIRlnk9EIlHgDcnYZ6OADvI
         9Pcg==
X-Forwarded-Encrypted: i=1; AJvYcCXMZVn6U8N8zG5FohyKRdNYFvuHWpdcwamHmqk1zea/kdAiupbFGc95pxs/7ej+niAHv5bBnXoaX5/aoww=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsvUWLHiBTZ3o1IHqBl7lw1P8fJD/ssEP3webn1GvKjPUHZcyK
	VvAI2VEikGd+6OCOW23Bao4zrOYeZnkjsuPxOdlghDRisRch8F/d
X-Gm-Gg: ASbGncvqnkLnZ6aeru6XM/P/0ppb7lsSuo17GCazuNrGE+ahnRC7jmTbN9Dqo32u5Z3
	US9Z0Lbo6hYA2J8CpRWNANfjSAxCIRDiFmRnSS+4uhIRFPekW5Aqcy6eiQ7lnJqhabwKnOSqh1g
	lFTsCs7Qh6vIeXCeaI3v9A38NP+7G6TjVciwVALkZh7OB+u90LRtezuSM/cw/69DlbfXO3qWcUe
	U2MBT6UzjhM7VbHLr6/cpSNsiqjcTvvd2ENjqDYVkypiWwVvSQV6jHff/QytXXwxJmYPKVTt3Bp
	noBKJLWk+1EVMwM7Yg==
X-Google-Smtp-Source: AGHT+IHUrjrzt3Ys5oACgUij0MrDCiNnTxo7rIeSEgXrQC3YPRFCL1TJCC+Ix+XbhR8MUFhPw0UEmg==
X-Received: by 2002:a05:600c:5253:b0:434:9da3:602b with SMTP id 5b1f17b1804b1-434a9dbc410mr117616375e9.5.1732903419731;
        Fri, 29 Nov 2024 10:03:39 -0800 (PST)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-385de98d618sm2489949f8f.90.2024.11.29.10.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 10:03:38 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 6.13-rc1
Date: Fri, 29 Nov 2024 19:03:19 +0100
Message-ID: <20241129180323.3625355-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linus,

The following changes since commit adc218676eef25575469234709c2d87185ca223a:

  Linux 6.12 (2024-11-17 14:15:08 -0800)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-6.13-rc1

for you to fetch changes up to c5cf420303256dcd6ff175643e9e9558543c2047:

  ceph: fix cred leak in ceph_mds_check_access() (2024-11-25 15:51:13 +0100)

There is a trivial conflict in MAINTAINERS caused by an unrelated
X: entry for NETWORKING [GENERAL] that merged last week.

----------------------------------------------------------------
A fix for the mount "device" string parser from Patrick and two cred
reference counting fixups from Max, marked for stable.  Also included
a number of cleanups and a tweak to MAINTAINERS to avoid unnecessarily
CCing netdev list.

----------------------------------------------------------------
Abdul Rahim (1):
      ceph: Use strscpy() instead of strcpy() in __get_snap_name()

Dmitry Antipov (1):
      ceph: miscellaneous spelling fixes

Dr. David Alan Gilbert (5):
      libceph: Remove unused ceph_pagelist functions
      libceph: Remove unused pagevec functions
      libceph: Remove unused ceph_osdc_watch_check
      libceph: Remove unused ceph_crypto_key_encode
      ceph: Remove fs/ceph deadcode

Ilya Dryomov (1):
      MAINTAINERS: exclude net/ceph from networking

Max Kellermann (2):
      ceph: pass cred pointer to ceph_mds_auth_match()
      ceph: fix cred leak in ceph_mds_check_access()

Patrick Donnelly (5):
      ceph: extract entity name from device id
      ceph: requalify some char pointers as const
      ceph: correct ceph_mds_cap_item field name
      ceph: correct ceph_mds_cap_peer field name
      ceph: improve caps debugging output

Thorsten Blum (1):
      ceph: Use str_true_false() helper in status_show()

 MAINTAINERS                     |  1 +
 fs/ceph/addr.c                  |  2 +-
 fs/ceph/caps.c                  | 63 ++++++++++++++++-------------------------
 fs/ceph/crypto.h                |  2 +-
 fs/ceph/debugfs.c               |  2 +-
 fs/ceph/dir.c                   |  4 +--
 fs/ceph/export.c                | 12 ++++++--
 fs/ceph/inode.c                 |  2 +-
 fs/ceph/mds_client.c            | 27 +++++++-----------
 fs/ceph/mds_client.h            |  2 --
 fs/ceph/super.c                 | 12 ++++++--
 fs/ceph/super.h                 |  3 +-
 fs/ceph/xattr.c                 |  2 +-
 include/linux/ceph/ceph_fs.h    |  4 +--
 include/linux/ceph/libceph.h    |  6 ----
 include/linux/ceph/osd_client.h |  2 --
 include/linux/ceph/pagelist.h   | 12 --------
 net/ceph/crypto.c               | 12 --------
 net/ceph/crypto.h               |  1 -
 net/ceph/osd_client.c           | 34 ----------------------
 net/ceph/pagelist.c             | 38 -------------------------
 net/ceph/pagevec.c              | 52 ----------------------------------
 22 files changed, 65 insertions(+), 230 deletions(-)


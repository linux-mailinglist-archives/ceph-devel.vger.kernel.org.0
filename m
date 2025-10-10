Return-Path: <ceph-devel+bounces-3832-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 727C5BCE307
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Oct 2025 20:07:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 650574F853B
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Oct 2025 18:07:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 037B52701B6;
	Fri, 10 Oct 2025 18:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BvwRUBTZ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2981FFC7B
	for <ceph-devel@vger.kernel.org>; Fri, 10 Oct 2025 18:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760119671; cv=none; b=MBt1oGkrDMQfQWWrCPgSJJ4jUH8iek2iWPa9tohJXvnHmDWddBPdedoMZYg8J6tjxEE3vi39tzqMO1B5hzTtQ6MkYgi2KGw9O7k2vGk2Z4X6RktcoCfE+r1BjjNHeo3VW5TR7yEu6b1xE+NTI2KpVr57mzFg2l5jk+9Sujouigo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760119671; c=relaxed/simple;
	bh=wqfBWxmDIQi5vwtC1MbdIcpo0h3rSX9ClNyEAV6ccYs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BLcBoqF3RfpLXI4PU4SMEEzU/t8fjVkpMrk+qPB7SImWx1SGGupG5A1DyBt0xT1mxbH/PV4q4N6P8YGL3Qb5Un8GLcl9xGDJ41QXtz0V0/nRWnjpZwTQ5qZ7lNNkCsZA6KviogkyuOdLXwFq+OCSLCdlFWG3QCuxXNs81/EFau4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BvwRUBTZ; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-639fe77bb29so3444259a12.1
        for <ceph-devel@vger.kernel.org>; Fri, 10 Oct 2025 11:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760119668; x=1760724468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BhxK1GJK5sA7N9K5yZGCGEkUd+inQEG5jk/d8suAk4A=;
        b=BvwRUBTZeBMp0U9s0lg2I0D8mhcBltBNzBEe2M7TUtCqWM5FvKWN53YmKGt/EVPhPr
         O6fQC96uJUGoJXtJkPCQHaCjdQfcLgF8r1sWE0rMAX0Pa/C5mCSad9zzkBZ6E6BDaVGt
         VrJMjIqDCsVRdDDyJbRxb4oWFXYBI5bQ6BzVAwaw8A70/IcmAId57ga1Gs99S2SxnO3C
         OJGBHJwkJSGMivpfJvkmCz+RGIV7Y841diSh1H9CZni7bQSN4itvsEZS7fOwhbEodMED
         N7pw0F26I/WjMMRorH94yeD+/0GzhZULbKmf7eVdz2L3D00KAUZmLilVw8mAqqoh1i3D
         Et6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760119668; x=1760724468;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BhxK1GJK5sA7N9K5yZGCGEkUd+inQEG5jk/d8suAk4A=;
        b=bZW9So2UT2Ql1o0z0skQQd4ceh4iUetkIZBUb/2BMDZEE5AO7PbUKA4MMw6kK9DIri
         QyqVfeKBdEMEr/kZ+v5w1Z/yEPHT2NBGsKbar6961++pbkpHoRtK1I9ARObnc2IsLAvv
         j+86vaLYohZi0Ko5iWm77QzJWVmNABd92j7vxIh8YAw4mTHgYbcOiYKg5l936xcqxVCf
         e+nukr+6JUYDjYlihvjL2WkwgrF2DsMABp2ivJQqdPoDAbtJs7wde0/y7c8NvnViOk0+
         nGFb/RbH3jVfGBM9SWeTAL7bqkPODTO/pP8bxNbidDY9ZfUbnsr2gLb4qLp3wXfCu6dm
         mg+Q==
X-Gm-Message-State: AOJu0Yz4uWQSMaAGE25dR4aBJ1TjmE15R+JNKx9OEvAFxNwSdy5JgpSV
	6m2nE84ghJ3xV8/+uIK5o+AIsxUTzt6q8ZGlKfXm7Y/OC05zNfjpZ82W
X-Gm-Gg: ASbGncssLdoyaM2gyk7nWVH5N26t5qSaJyBani7SFfI37XhUTa6OS0+n8OVZFQChPPG
	yA9ReT7LaSP1gur0rVHeSwyGVjLuIGoa0EbWUxwUeUzi+KjiexWm4hj+sKT0p68fzJREeWjPWPx
	R4YvHNuAj96dQziHkSuvzIOf9OtYorkVLKtxU4gGrJ4NIj5gzQa/P/CHbB/fRLeMGyneWuEcHSW
	0bYBobzZLFPThB/WiEHXYNaliirr4g32p0LczRkHm3Jk1nXTmfsJAjHM32l14LvO4q9EwYwu9qK
	LnuQ5aEL/unhMV2ISO/GvTKhD5OWhdHOgphaE5x90dC0KGgXS5v9+p6V7zg8WwnvjgO6uGKLPV4
	msQbaclWH+0QDMcVE+XlKc8wZVmKE1y340A2/1eoFuRCG92Fz+Zf9vJzyqWIGtmaTXDfCyjexO/
	MkUkbu4Gir
X-Google-Smtp-Source: AGHT+IFtha2OqKiOJaCe8DsE10T8YUc7pDffBcQTX15Aqoy/DyULhpRhI6gqFsXCRrzqzWJFg697+A==
X-Received: by 2002:a05:6402:354e:b0:639:fb11:994f with SMTP id 4fb4d7f45d1cf-639fb119be2mr6397865a12.4.1760119668094;
        Fri, 10 Oct 2025 11:07:48 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63b7334cb4bsm87907a12.44.2025.10.10.11.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 11:07:47 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 6.18-rc1
Date: Fri, 10 Oct 2025 20:07:25 +0200
Message-ID: <20251010180728.1007863-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linus,

The following changes since commit e5f0a698b34ed76002dc5cff3804a61c80233a7a:

  Linux 6.17 (2025-09-28 14:39:22 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-6.18-rc1

for you to fetch changes up to d74d6c0e98958aa0bdb6f0a93258a856bda58b97:

  ceph: add bug tracking system info to MAINTAINERS (2025-10-09 00:15:04 +0200)

----------------------------------------------------------------
Some messenger improvements from Eric and Max, a patch to address the
issue (also affected userspace) of incorrect permissions being granted
to users who have access to multiple different CephFS instances within
the same cluster from Kotresh and a bunch of assorted CephFS fixes from
Slava.

----------------------------------------------------------------
Eric Biggers (1):
      libceph: Use HMAC-SHA256 library instead of crypto_shash

Kotresh HR (1):
      ceph: fix multifs mds auth caps issue

Max Kellermann (4):
      ceph: make ceph_start_io_*() killable
      libceph: make ceph_con_get_out_msg() return the message pointer
      libceph: pass the message pointer instead of loading con->out_msg
      libceph: add empty check to ceph_con_get_out_msg()

Viacheslav Dubeyko (9):
      ceph: add checking of wait_for_completion_killable() return value
      ceph: fix wrong sizeof argument issue in register_session()
      ceph: fix overflowed constant issue in ceph_do_objects_copy()
      ceph: fix potential race condition in ceph_ioctl_lazyio()
      ceph: refactor wake_up_bit() pattern of calling
      ceph: fix potential race condition on operations with CEPH_I_ODIRECT flag
      ceph: fix potential NULL dereference issue in ceph_fill_trace()
      ceph: cleanup in ceph_alloc_readdir_reply_buffer()
      ceph: add bug tracking system info to MAINTAINERS

 MAINTAINERS                    |   3 +
 fs/ceph/dir.c                  |   3 +-
 fs/ceph/file.c                 |  30 ++---
 fs/ceph/inode.c                |  11 ++
 fs/ceph/io.c                   | 100 ++++++++++++-----
 fs/ceph/io.h                   |   8 +-
 fs/ceph/ioctl.c                |  17 ++-
 fs/ceph/locks.c                |   5 +-
 fs/ceph/mds_client.c           |  22 +++-
 fs/ceph/mdsmap.c               |  14 ++-
 fs/ceph/super.c                |  14 ---
 fs/ceph/super.h                |  17 ++-
 include/linux/ceph/messenger.h |  10 +-
 net/ceph/Kconfig               |   3 +-
 net/ceph/messenger.c           |  12 +-
 net/ceph/messenger_v1.c        |  56 +++++-----
 net/ceph/messenger_v2.c        | 246 ++++++++++++++++++-----------------------
 17 files changed, 323 insertions(+), 248 deletions(-)


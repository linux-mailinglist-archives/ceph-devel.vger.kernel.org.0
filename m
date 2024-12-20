Return-Path: <ceph-devel+bounces-2394-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EDD4C9F9A9F
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Dec 2024 20:41:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C256D7A1425
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Dec 2024 19:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC61F2210CB;
	Fri, 20 Dec 2024 19:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KMJOnwOd"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA3821A431;
	Fri, 20 Dec 2024 19:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734723684; cv=none; b=nMJ5AqJcrXYMxddZ1I1Vv9eWql2n4g8ulvWiW/grZfHhmumOFrBBBgh6bZryV+HM+MMVe1zoDO5+T4OXOpeqYYwzCBkRQAi5LZri+0LP21rqtp3ReBhOG33BNNGziMPERZGJa3MDepULLdPVhbR2/yuh79CfthZMsq5MbEX9EbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734723684; c=relaxed/simple;
	bh=E/WRb/pNvnXY2qk2YNDcschtiMdzQ+FZMT9rhWCoHcs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uqpAMeikUQYNwJan7WRp/oUnKcIV5lw6soXKeYFTnfrk96vO+gmsgILsbLMMvV2NNysSvInclvUR2RBgG+/lGqwrSp9C07SV30za3S60Pw8nc/rVhRkrvuZItRDDTMHnOgrjWz81BparHrsAhXHNqbw2KJlJeBtXCPREVYeljQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KMJOnwOd; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43622354a3eso15954315e9.1;
        Fri, 20 Dec 2024 11:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734723681; x=1735328481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YjdD6prJzeYPbT7/p3B9He6nK1v9LqKxf93CEzQXR4Q=;
        b=KMJOnwOdAcKYxccWeiMmM8G/S7I+WzkJWXrRtlEu0nf/+R/U/9ijoC/v5ItuDjEOCc
         J43qKSaVPK67LQmGPmGag8nWmzr1iCtNAO7NbQ28oBf4ts1FZxEGmZ9K2o/Elq7zpn3x
         Zn6ZqW6w21uU505Vz9mjp/5eHvyp4tbwsodmvec8WaaAS/e5lA15C+N7KnojoKeFoXo4
         DbeOWjm+3lwUR50St0SRgj3puATf8M0R05p9k2jJLVLtCnO/EVj7yfh+RzoEv00gAKd2
         HxeSNKqgeJbNEi4ocquEAoQhCDOD1c3jqcrnKzduT3vJT7Smin8+8v92UVjK+qq06ZTJ
         ZMog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734723681; x=1735328481;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YjdD6prJzeYPbT7/p3B9He6nK1v9LqKxf93CEzQXR4Q=;
        b=eJyJO9sc3vZCvy6JhmhACJ9r9hdaWN8w36Hn8cL6Mpnhp5IGpOiXgLL0zSPThBxPFL
         VqW1uoAfob6weCYDuRZabNjO+nlVfXWn9PRCvFcQCvEGvlmJutCjkM8IKiwpvKvSYjc4
         me3URFbr0e4mf4qUch1QXPx0AlqnQrastr97H2ycrrMxketuUQTcZK0nfpDGuFE5H+vK
         NWbRHYCc3N6KJPeOo6oGgWkpa5EoteN91gTTydSh8cMEt3G98XaHuu0GvppVCp8A//Cz
         q2Xv+sUp+h+do6ThfwQe+D9jke1+TqAC16SxnvigVHVLxlBHY/+wA5PMf8NBAdw6Gqyv
         ErSg==
X-Forwarded-Encrypted: i=1; AJvYcCVQd2fZ+xXXgiUatyA2dKSmp9G5/Ut6E5pALiu12GFphST+xSrOZIdatxrZeDc6Al/Q2BDphQ3e1KL9YDg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzKBNmZFCwJD73/q4H2a/iUZ9GY8V5aj1EnUAbdkdtoV+0oUv2
	w8g0dXr+w40jjsTwDBRsvmDd93dAguCwjgWAWcKBBa0qQSOSkWKWzgf3yw==
X-Gm-Gg: ASbGncvjTWwRoJ6jiyp8NcDGHGAOaFjmLgaOp003svSABSWYZJK+8CPVleK0QjDzKXu
	aYDpZFAlJOxhq18ToHit+mw3r2g22SM3n9lwcz83LWbemI6DhrKCsLPIzv2RZ4/UjawdZZEcNOa
	O+ZF7Y9hxJZijbnNKwzEBkPoZibrpe2uXq5FmucuP3agwWHziLxNgP9nJW8y9B78EMA7bMpsv84
	vGfPBxuk1lff1Sl6YMk7DX6bYa5LSHhrbtTKA0ZSKtHXoM1siwi/XXU9ioI0XM3/jvc9k+/dHPn
	aZxE5XlxGR74pHKF8XlIO4mi
X-Google-Smtp-Source: AGHT+IF4JCJH6I7vd5QJLBvz8WEPqMObti/syADEBcCIQLY/eB5ud5FXZS9EsS0FavKJQasBG83wcg==
X-Received: by 2002:a05:6000:1547:b0:385:e16d:f89 with SMTP id ffacd0b85a97d-38a22200a09mr4270252f8f.34.1734723681049;
        Fri, 20 Dec 2024 11:41:21 -0800 (PST)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8b830csm4793412f8f.108.2024.12.20.11.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2024 11:41:20 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 6.13-rc4
Date: Fri, 20 Dec 2024 20:40:54 +0100
Message-ID: <20241220194104.1350097-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linus,

The following changes since commit 78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8:

  Linux 6.13-rc3 (2024-12-15 15:58:23 -0800)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-6.13-rc4

for you to fetch changes up to 18d44c5d062b97b97bb0162d9742440518958dc1:

  ceph: allocate sparse_ext map only for sparse reads (2024-12-16 23:25:44 +0100)

----------------------------------------------------------------
A handful of important CephFS fixes from Max, Alex and myself: memory
corruption due to a buffer overrun, potential infinite loop and several
memory leaks on the error paths.  All but one marked for stable.

----------------------------------------------------------------
Alex Markuze (1):
      ceph: improve error handling and short/overflow-read logic in __ceph_sync_read()

Ilya Dryomov (3):
      ceph: validate snapdirname option length when mounting
      ceph: fix memory leak in ceph_direct_read_write()
      ceph: allocate sparse_ext map only for sparse reads

Max Kellermann (2):
      ceph: fix memory leaks in __ceph_sync_read()
      ceph: give up on paths longer than PATH_MAX

 fs/ceph/file.c        | 77 +++++++++++++++++++++++++--------------------------
 fs/ceph/mds_client.c  |  9 +++---
 fs/ceph/super.c       |  2 ++
 net/ceph/osd_client.c |  2 ++
 4 files changed, 46 insertions(+), 44 deletions(-)


Return-Path: <ceph-devel+bounces-3528-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 93F5AB46416
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 22:01:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 27C274E2A9E
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 20:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EDD128488D;
	Fri,  5 Sep 2025 20:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="3F3aTWeV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2890121B905
	for <ceph-devel@vger.kernel.org>; Fri,  5 Sep 2025 20:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757102510; cv=none; b=VUQ17Ges93DNWwaIYaCdPfDkt8emqxG5RlKPBE+cejKlKm2YM2fSIPLcXg1jZEES85HB5FhvJO23OmKbLNuQruQK0sLk+6/Zd1+YZARtTOymV9wZa75rFhMrVKQ5ReWrwKIUyOBf11UOsM6f3/CF4VtTXdkDF/MUe3NUpSBTW48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757102510; c=relaxed/simple;
	bh=CIt2rudRtW4UBrSZeLFjRUpcL/34sCPSMHO4G+HzerI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L4DeIlrslDPKa0OvlpWHzgFLpQ06r39t6Ka7VGYwy3s/w+ZuQhB4LIUwsX96LyvXrAKsbY3pOYScQuK4sWUcC9+4bbVmwunMo/c5aRAHWossTaTu1KSHzIOzKitiQ8Zxjd6xoMDQSaIU3/AXppPVobW2dErVq2qQTKxyeREAXbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=3F3aTWeV; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-723ae0bb4e4so28928097b3.1
        for <ceph-devel@vger.kernel.org>; Fri, 05 Sep 2025 13:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1757102505; x=1757707305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jOy/Lx1hali3hqni7ugXsZX+qSqE1qh4LpVXkqYzo1w=;
        b=3F3aTWeVRG9DQesHQ95dW/ZLjipg1N52Qoxfgnc8uk1S3x8ne6qRrPGapWfCDB2Mpe
         /ckbbbTu1EJTh32mawJFf/zEVAr4UwxQMJ2mm9L+a+ZE7HQ3nmt0DyaonpDrqcgUIa0C
         bN6NtVTj4GyDa5g4IqMQedCS/P2NsAJlh2e5DkaQq0OPXeG5NiqKaUP0pocUCasvSqQY
         umwwgltqis3VwpLY0X+pWaQnr/rxJuYho81CeAV2nsuv+hhL0qlbIdXp8TN33KKYV6wc
         b5STtHAH0ep6mymockMqm0Ezcf8jp2gN0g00ATux1X/889KvmyQ8DJfQFVGcH5nyDPPn
         fqRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757102505; x=1757707305;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jOy/Lx1hali3hqni7ugXsZX+qSqE1qh4LpVXkqYzo1w=;
        b=vjNvtNbs1bvfN/XeCtxiAExRTSZNiF2ZDE+gKPOsPqhOTTthp2Es/UX0rUjzkRmEVy
         BvebAc2yzhGxZqm0oZh+0GTB1vZX6MdoeGjTPh9NTmYc56kmOAOVBZk4XopE28+zpi7x
         G+WWz8l0P7XiM8PQh/+ptiPIiesSeL1ZM6pW+PGU5/DbNI1ZQHaV/IOqfiwdXDV9mncY
         WC6jGvdNUp0NeJM0tsFIawN5wq/ZjTzTx6BiEk+aOWpPfEOQWd/biphwwh/zOVHVrCDX
         Sy+hxoUYZ12XYwGcHswaIvBJuoPq3BDV+pr/XAXP5AbQTos/ze96WO+IeOv3IUkdS0vX
         vJ+A==
X-Gm-Message-State: AOJu0YzYpTkgrnQL3mCy6XWl6Ko4GwtEcUzNoRNBkqxKLXDVp81EHSNd
	eZPDWh9NuBkxLOmpIZUqpx51IqEv6Pgfv5amUrwg/q8POeje74Uz46wgH5JlceATyRlgwP3eiBK
	tZcmfqFs=
X-Gm-Gg: ASbGncuzvYyoZmxIX7i5QHWb66Nf5tOp86Cn60l+qd7EU3kaJmXTdvmnMELZ9xYYdAs
	L13JEnla6l6bNyVuXc4+Aky6RV7MyXP6nfQ8qQIov+UsiBGQZ8Z+13T/AFWGfwdAigWjTjNBklB
	SkM3Uc4LEqih6FimSBvXybTgcxJdOnJ8fQQjDqwuKJ4v1DYqwXQbQwm1cxuJnRmbCVjjsRjbZMH
	/b7BKeCdzjsDHxd3LC50kaU83NnVAww9LEZeK2a/5z+eXChWcpmNJW6rgBUBOCQ27KV3qAFiODL
	2MgCDKfDMHNy84gfj5FbR/XJ6McMi9095MvegqXjlzxeA0bul0JGTPLIfW9ZopDcbevfEuhOage
	H4T4WOjZdxXcXSD5G1rea6mrcZxiedgxDrFvNPQBNo0PKbThLuu8=
X-Google-Smtp-Source: AGHT+IEr/a6oBelU2QV3zVFEFZ3TC++egfhB+J+cNPqYIHA9Iy874iEk3OeK+W4CA42HPxHoko/Auw==
X-Received: by 2002:a05:690c:620d:b0:722:875f:5ba7 with SMTP id 00721157ae682-727f6b21ff2mr1152567b3.39.1757102505276;
        Fri, 05 Sep 2025 13:01:45 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:2479:21e9:a32d:d3ee])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a834c9adsm32360857b3.28.2025.09.05.13.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 13:01:44 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	vdubeyko@redhat.com
Subject: [RFC PATCH 00/20] add comments in include/linux/ceph/*.h
Date: Fri,  5 Sep 2025 13:00:48 -0700
Message-ID: <20250905200108.151563-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

We have a lot of declarations and not enough good
comments on it.

Claude AI generated comments for CephFS metadata structure
declarations in include/linux/ceph/*.h. These comments
have been reviewed, checked, and corrected.

Viacheslav Dubeyko (20):
  ceph: add comments to metadata structures in auth.h
  ceph: add comments to metadata structures in buffer.h
  ceph: add comments in ceph_debug.h
  ceph: add comments to declarations in ceph_features.h
  ceph: rework comments in ceph_frag.h
  ceph: add comments to metadata structures in ceph_fs.h
  ceph: add comments in ceph_hash.h
  ceph: add comments to metadata structures in cls_lock_client.h
  ceph: add comments to metadata structures in libceph.h
  ceph: add comments to metadata structures in messenger.h
  ceph: add comments to metadata structures in mon_client.h
  ceph: add comments to metadata structures in msgpool.h
  ceph: add comments to metadata structures in msgr.h
  ceph: add comments to metadata structures in osd_client.h
  ceph: add comments to metadata structures in osdmap.h
  ceph: add comments to metadata structures in pagelist.h
  ceph: add comments to metadata structures in rados.h
  ceph: add comments to metadata structures in string_table.h
  ceph: add comments to metadata structures in striper.h
  ceph: add comments to metadata structures in types.h

 include/linux/ceph/auth.h            |  59 +-
 include/linux/ceph/buffer.h          |   9 +-
 include/linux/ceph/ceph_debug.h      |  25 +-
 include/linux/ceph/ceph_features.h   |  47 +-
 include/linux/ceph/ceph_frag.h       |  24 +-
 include/linux/ceph/ceph_fs.h         | 792 ++++++++++++++++++---------
 include/linux/ceph/ceph_hash.h       |  21 +-
 include/linux/ceph/cls_lock_client.h |  34 +-
 include/linux/ceph/libceph.h         |  50 +-
 include/linux/ceph/messenger.h       | 449 +++++++++++----
 include/linux/ceph/mon_client.h      |  93 +++-
 include/linux/ceph/msgpool.h         |  15 +-
 include/linux/ceph/msgr.h            | 162 +++++-
 include/linux/ceph/osd_client.h      | 407 ++++++++++++--
 include/linux/ceph/osdmap.h          | 124 ++++-
 include/linux/ceph/pagelist.h        |  13 +
 include/linux/ceph/rados.h           |  91 ++-
 include/linux/ceph/string_table.h    |  11 +
 include/linux/ceph/striper.h         |  16 +
 include/linux/ceph/types.h           |  14 +-
 20 files changed, 1907 insertions(+), 549 deletions(-)

-- 
2.51.0



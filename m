Return-Path: <ceph-devel+bounces-3334-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 03B5DB1637F
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jul 2025 17:19:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D97FE1888014
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jul 2025 15:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8590715853B;
	Wed, 30 Jul 2025 15:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hF7Us5MD"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA7A153BE8
	for <ceph-devel@vger.kernel.org>; Wed, 30 Jul 2025 15:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753888755; cv=none; b=o3TGyqh/SV84h27Sfkmba76770gJItNT4ZICf0zjLeNI2VKzGsDSP5LjvqEkRXiTvSxiXOVQgaeUiK0X+qtwAGLyoPmzYaQ2v2OeLtUYiNJYRDP7XXYEHgjEeVY830vw8OKHv52idFaASSwWCdcTur5MzUiGASf5Ly9lqlec8M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753888755; c=relaxed/simple;
	bh=86xZu00+UDnBPH6MuEJGYfj4bcSnDnN94cUc+QXGuL8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XnRAzeJJ3qHBaDtKH8Z/s3D/TI4IdXXWhdvzqnxdD8Rcw9X/w952YDTlwk23i30Zo5c5+hJs9fKlEs7d6IADnB18aJgnND86uKKJyYd9R9u3NrdzNXUCAZQ+Dq8ysQ65zlsvshnpETr4aYjvyJtS9EK62abib5jc4YDzez4V1qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hF7Us5MD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753888752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hNbEQ0dntB4TZw05j2S92XHQV8iXE8KzN/fVBin+25o=;
	b=hF7Us5MDUfB74bOCss8bx9ios24shGHSuV6eabhvcxqFbqhfnjrYVRgxzFp684guBABTm4
	BXA+lnpjozMmWMavMhiZLb0oWEIajclYISLlho93W7E53NYeU6gn5hrWj8ywqnP6rf08d6
	36Stc0/OwI96FaYcrrxxHHdhX+c58Xw=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-Be9cl-mTP665D6WRzHHHAg-1; Wed, 30 Jul 2025 11:19:11 -0400
X-MC-Unique: Be9cl-mTP665D6WRzHHHAg-1
X-Mimecast-MFC-AGG-ID: Be9cl-mTP665D6WRzHHHAg_1753888751
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-70741fda996so65127346d6.0
        for <ceph-devel@vger.kernel.org>; Wed, 30 Jul 2025 08:19:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753888750; x=1754493550;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hNbEQ0dntB4TZw05j2S92XHQV8iXE8KzN/fVBin+25o=;
        b=Lsrigp804SApk5EER3luOxfxbBwKSTXsO8B/myhYgulqBLp3RApBfXq0CAiIhUX2+L
         gMb+Yr3xYHJCqcRF52zZ5F6TekhRODI5LajfPoJrt8PXi9h3R4NcT3U0lkZkoD6flNJh
         ggLd4GYZ3YUGG2sZdL5SSZIZYZ2ZjM08UEqO51BY3FO3eaoQFX1FFwBQt+4zxAcZv5Oy
         TwOn2g3VwnJsFWIvPFT+NdTnCEzafjnm7XU8sa9efflNT2/i0Yc6O4/9AVXD9ihdu0J8
         PCTbeQu2+7n7tsP/5i4+m+ctHStQp2K5eUx067Cgm2CZqm6oJZguEzXiwT6t6YwL+TPs
         XW0g==
X-Gm-Message-State: AOJu0YytKnRpfikSSR/V1rtfJukTgvY/EG2MWY+vL/AHqspwsIG8yHTX
	bap7PhksWP67rTxSiM4v5LmzoPHZkFJHL9XLiFh6ANS2wrsVtbDCHviIDuvghh2UZgi1niV6tC9
	alFldQKBAFCiP2mNc8JI+T2fCurZWnDAiaZfUm0XO6NSaPenMqrO9EjCOSP/3C/iEx+rUUFySbb
	D8gSQJEqtg2xSBIOcjQD0Xhw3Ftcay8fSbV1gBTrH+cy+1KJ2laEPn
X-Gm-Gg: ASbGncvvjB/8ytu+lRYwjXrMZtj4LPq5i1FiwAQe6V8asKC18fzKd7y6iGHTtNYW+Rt
	MMvcMtfUwzcERivQWcf1RMIA1qW34ZANSwYEtoaCoWmh7uw5AxofqkESO8bdH24UUHpSqKZeK6X
	SLJ2Om5A85oXtw7KLp7o0lztGks61aNUjlB4itnqTJXTtkN90290oeoT9lGp7JZ8veqRTUYDOmy
	qkfS4Uwx1FafOBoEgCSrS4yGlY4721HEqdWETKW/lu34jAiXCVZ0+HCi9R4mrsannj1tE++dF7l
	vRpP3MTYzonF3EUMuh2tFUg0oaSUtO2zRrLST+penQgsT8V4HTGDHbEPpT2P2jOGDpOhdwL2Xw=
	=
X-Received: by 2002:a0c:f095:0:b0:707:73d0:281c with SMTP id 6a1803df08f44-70773d04093mr14452306d6.27.1753888750513;
        Wed, 30 Jul 2025 08:19:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHa8aWnTvjk43jMfW0UI2D96LhguBFBsTIiHE7ylxHUTQANU31Uk53IFE9PuU2J2gpk9OuARw==
X-Received: by 2002:a0c:f095:0:b0:707:73d0:281c with SMTP id 6a1803df08f44-70773d04093mr14451626d6.27.1753888749860;
        Wed, 30 Jul 2025 08:19:09 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7076ba8834asm11322986d6.25.2025.07.30.08.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 08:19:09 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: Slava.Dubeyko@ibm.com,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH 0/2] ceph: Fix r_parent staleness race and related deadlock
Date: Wed, 30 Jul 2025 15:18:58 +0000
Message-Id: <20250730151900.1591177-1-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This patchset addresses two related issues in CephFS client request handling.

**Patch 1/2 ("ceph: fix client race condition where r_parent becomes stale before sending message")**

This patch fixes a race condition where the `req->r_parent` inode reference can become stale. Under specific conditions (e.g., expired dentry leases), the client can perform lockless lookups, creating a window where a concurrent `rename` operation can invalidate `req->r_parent` between initial VFS lookup and MDS request message creation. The MDS reply handler (`create_request_message`) previously trusted the cached `r_parent` without verification. This patch enhances path-building functions to track the full `ceph_vino` and adds a validation step in `create_request_message` to compare and correct `req->r_parent` if a mismatch is detected (when the parent wasn't locked).

**Patch 2/2 ("ceph: fix deadlock in ceph_readdir_prepopulate due to snap_rwsem")**

This patch fixes a deadlock in `ceph_readdir_prepopulate`. The function holds `mdsc->snap_rwsem` (read lock) while calling `ceph_get_inode`, which can potentially block on inode operations that might require the `snap_rwsem` write lock, leading to a classic reader/writer deadlock. This patch releases `mdsc->snap_rwsem` before calling `ceph_get_inode` and re-acquires it afterwards, breaking the deadlock cycle.

Together, these patches improve the robustness and stability of CephFS client request handling by fixing a correctness race and a critical deadlock.


Alex Markuze (2):
  ceph: fix client race condition validating r_parent before applying
    state
  ceph: fix client race condition where r_parent becomes stale before
    sending message

 fs/ceph/inode.c      | 44 +++++++++++++++++++++++++++--
 fs/ceph/mds_client.c | 67 +++++++++++++++++++++++++++++++-------------
 2 files changed, 89 insertions(+), 22 deletions(-)

-- 
2.34.1



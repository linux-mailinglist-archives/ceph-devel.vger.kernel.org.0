Return-Path: <ceph-devel+bounces-3718-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 443FAB99455
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Sep 2025 11:58:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 177574E035E
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Sep 2025 09:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD3BE2D9ED8;
	Wed, 24 Sep 2025 09:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ug3j3c2F"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553012D738B
	for <ceph-devel@vger.kernel.org>; Wed, 24 Sep 2025 09:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758707910; cv=none; b=fFoQKOr0t/ZCmQ8q2cc/y1RUQpvA1Hr2cDmqpJtVpqqjOkFVWp2dRQjsB/e/DgiYt7dCLc5kXNCjTYjrruF/PYPXGV9A7wOCSJ4UNoeBzNR9J/ZWQ8z5QslRaWGpAwYN9IA9RReON0s1I9hisda7p5w15Do8aKuHJk2kUaIY4TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758707910; c=relaxed/simple;
	bh=SiLoUVRaH4UCwYO+7nZIMOSJgk5BMtb5G5hQma8k8Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U04QHRX/9RbUWzmK7ObVIIRMoBUvQ8co3LKP3msIXiJ1KhS+VmUbklx1m39pE+p2w7J65CcUjolZNpbTlmlL312PWczqExfCHEqV+li3Gn8go6YIC2c8zkxh+q5fMXqLgfBCnaHbGSZaAlHDSg/VdNvSpzlUhABtQ5fRWU1TWCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ug3j3c2F; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b4f7053cc38so4803128a12.2
        for <ceph-devel@vger.kernel.org>; Wed, 24 Sep 2025 02:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758707904; x=1759312704; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KsoCbCZ8+3FAAH6Rhz9Znu4V7ZD17IQs0kKBU+sA28g=;
        b=Ug3j3c2FJL8YmbplWK6R3M40fTJTN828P28HivFwk23ceGQyORZszghlQcVwbSAfny
         Fs9DB1C5bAWYyFywwhE9K6mXGMhjNQkLFQz0pmtZV9lt3n6T8IYwUASybV1wr9X7frEt
         4dyvogAC0Dd7jxMJ35WQzPFvUkCvQLJYb6dkHqsp+FbUoStqAdQSGOb/qQULZ2+iZ/9H
         WjekZ7j82jdIvJCGIRD6rzHrR+sCBSTdB+lrUAbXHZ2Gtc4N9DMi1196FxYM+0zcXdtT
         yjhYEg5CIe1H8CLP4Eh9CKFr3QUeTgK6q202t76ODRnu4f9VjsbuXUS2X6TQEA8LoG23
         2KLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758707904; x=1759312704;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KsoCbCZ8+3FAAH6Rhz9Znu4V7ZD17IQs0kKBU+sA28g=;
        b=Nu3giQZP28P4ztZ2XeEzonVUuYO7SYlA82rtP19eIqijSD9hYXmnNUEkHUFKBbTFmR
         tGBrYNzptD5sOUL70PqF9buSvslIWBxIG/u0x9WwpUrO41wJtezG7kzstbggqXySfsHe
         3z65TvphocSLv82M04bu6Rv8/JF8hXi7TATjhIlI4pSPWDybxPzl1aolGYEX5vDQfdED
         2jfJsu/LjYT6pT06xtk02o/PKXarezwYO7eIarylt8PubKxcRYfj5ZZDagLw+swkvlg/
         zd7GhG+6eGFHsUtlDn62ILREiSWK73ErojH1PIMc5v95FtTwZEkQ5RgJN9xhUVx9dJM9
         i3uQ==
X-Gm-Message-State: AOJu0YyQ9sHq56C4K7D0C2PIa8Q3sCXD0HWY2sSbmZoWzDAcrT8qQy0M
	e3NOESmMrwtpxzPzSkifS5DNxF98GoDJUtFIi8trFHKrMI3ZQghG9B0VjU0EJdip
X-Gm-Gg: ASbGnct7SPlbPglSh27fOUjUErWmrXQAD4fWMOcO3pDbSXD+bwcLHA/CKji9BEhanCC
	ekg+r4UYapX9Fg4nd4VLEllarYLH7HPJkZh3T1RKuKQiv8ueDFIpbwfqpHrEvztyqyyl0oj/kts
	/HHEbR21uIo7rHTDyCdvKKD4ch7PhtewmggOcsAUFARxI0QhsMSLDfQ7z81C3TtpAFMaawfXTBS
	uKRQJWySKdbkWiWrnZOlLV+5v/szwG8doUAgfXY/TJc3+vIaJdoUg9rwosP+ujMf9GFXDaTbvRQ
	DITRCGQnRX39YUdAtlbe8+85/xv3HeLHuzTstLSmBl9vd9xb0301A3duQRqGPTW41PLtVmDSqya
	WLQqPZjQzFJk20U6tIOcXw+j4haI0TgbFlHeDBvYgLSOPg+29TR7uQedv1EzIbRRMkaEa
X-Google-Smtp-Source: AGHT+IFZgtoabcvsoWaEwkhtGGPXXiK8FQSGpTFLzXDxQ+0xVb59wFZ3tzoYC6Zi+8yYaygGX5P4og==
X-Received: by 2002:a17:903:2342:b0:267:d2a9:eabb with SMTP id d9443c01a7336-27cc28be6b0mr67107045ad.25.1758707904215;
        Wed, 24 Sep 2025 02:58:24 -0700 (PDT)
Received: from ethanwu-VM-ubuntu.. (203-74-127-94.hinet-ip.hinet.net. [203.74.127.94])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269803601a5sm187502035ad.141.2025.09.24.02.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 02:58:23 -0700 (PDT)
From: ethanwu <ethan198912@gmail.com>
X-Google-Original-From: ethanwu <ethanwu@synology.com>
To: ceph-devel@vger.kernel.org
Cc: xiubli@redhat.com,
	idryomov@gmail.com,
	ethanwu@synology.com
Subject: [PATCH] ceph: fix missing snapshot context in write operations
Date: Wed, 24 Sep 2025 17:58:04 +0800
Message-ID: <20250924095807.27471-1-ethanwu@synology.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series addresses two instances where Ceph filesystem operations
were missing proper snapshot context handling, which could lead to
data inconsistencies in snapshots.

The issue occurs in two scenarios:
1. ceph_zero_partial_object() during fallocate punch hole operations
2. ceph_uninline_data() when converting inline data to regular objects

Both functions were passing NULL snapshot context to OSD write operations
instead of acquiring the appropriate context from either pending cap snaps
or the inode's head snapc. This could result in snapshot data corruption
where subsequent reads from snapshots would return modified data instead
of the original snapshot content.

The fix ensures that proper snapshot context is acquired and passed to
all OSD write operations in these code paths.

ethanwu (2):
  ceph: fix snapshot context missing in ceph_zero_partial_object
  ceph: fix snapshot context missing in ceph_uninline_data

 fs/ceph/addr.c | 19 +++++++++++++++++--
 fs/ceph/file.c | 17 ++++++++++++++++-
 2 files changed, 33 insertions(+), 3 deletions(-)

-- 
2.43.0



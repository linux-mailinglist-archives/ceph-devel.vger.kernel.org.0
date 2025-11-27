Return-Path: <ceph-devel+bounces-4123-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F8DCC8FF01
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Nov 2025 19:50:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1D9454E1EAD
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Nov 2025 18:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 930C62F4A18;
	Thu, 27 Nov 2025 18:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="br5DcfmE"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFCE79C8
	for <ceph-devel@vger.kernel.org>; Thu, 27 Nov 2025 18:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764269417; cv=none; b=udvywf370ZBX1hUrAmwE6nYix4THEX+5D5rw3omIKXWYvNpBCytvF7TPeZfMTlMLPxHjym8OKdipeX6OdZDoYlhuVP4QtlDmsuSa1XW5Jyyhe+ds9WYKzVzCcVF+1bXh+lcrkyAaIIDb3Wu0uMgTseoZWsVgVlF0lCPhlPe0jd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764269417; c=relaxed/simple;
	bh=y3UvB//J9w/9aLv+hFVkN/urJK44LVwFSZcYd6cDEdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SswNMFK4KBv/UEjnxafov17cPgWEkX/3uxPUk6toU066NMHGbsIDLw8UeQV37VQt6ls6MvS28URUdGQgxe6QbY36/UVQ265vHU6ByE0w4K4lG47cl/RD52wv4aR7DJB4+mwd9ul/O8BeYuNz0i4WZroXDea1fArHuUKwXXKbVSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=br5DcfmE; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-477632d9326so6480285e9.1
        for <ceph-devel@vger.kernel.org>; Thu, 27 Nov 2025 10:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764269413; x=1764874213; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e0raydlRVTRX66nafl3EITwHtFIoWWVi8PlBAcgaoUw=;
        b=br5DcfmE/chYlJN/WVYwjM1TjCJ65PjJBOpzojVADUcMZQPnhIA6C67e2bwfFb6twF
         MQXvmsK9xPMAk7BS05tUp7gCeW1hWksupODf0DEQMkTxXMyDvKLv8bJlV2/EdsMafLRg
         X6/wsnQghbG9tCyNMr5Fi8wje7KRMTsQ3iuGiRAUTr15slOrNaOZzmmAXmuVpnkrTNS/
         ONcr8+w5RdMRo8UP6asVaqHmCBrIFz/rHMQGNzpvlGT43GVqMF3ZKewxeWiMhpgywK9U
         RWIJ8czFi861IRFh5qXJHsO+lgSCzN+ru2mJmij483MBG3LLYQ3wza7xgIgZlQGk/FzG
         BFDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764269413; x=1764874213;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e0raydlRVTRX66nafl3EITwHtFIoWWVi8PlBAcgaoUw=;
        b=di/Z5IeivPV8ImLQTp9ugQ+u4cCX2ROkRuZlf4ctlYlHRZAkdvlsk0jXpNYMVvcIKg
         jTk333nHQXqjLa8LGDOeS+SihJAO03PcqETmAcbpiJKroLXePAHkxe3hZ2fvjNnQ0wXI
         lDX8DGY7fT5F3vcfl0grIF1nJvKNCGx4CUvNVKjN4RvZxiTbmM80dksA482UDkWeO/Mv
         Pi49WuijAU77CbK3tqQkphcieLGyPQJc4Hqhyh/u9phpzHv57j4ZgLHHFEqdCViZ9qdu
         030Rdg2NZxxDVuheDnjzHz6g5ynlPgK9mI8ZdGiXvlYwNTur6B5S/VCgmKmcuOcevzSb
         8I2A==
X-Gm-Message-State: AOJu0YydvmpS3mwLvfogVT5TKf+26OS6OgpxzyAtPCR6Th8Y2e8JHHXj
	Mr37l/OQWiw/O1/HTybxHlIQZf2+zVtYXH2TY07A8dlULm/ywkrllQW4+eqJsw==
X-Gm-Gg: ASbGncvq886kEcrAYg1SIdlGltJINipQkkGM2OtwS2leySdKTxM3HF/CYKBHAP/9FwS
	n+qbpW19mtRhmVdeS5lGRLigi0aXVkU/+fa2QLk8dreubMU/3Udb54KaNxpWsBBzgWV7mDrOWy0
	7yGrbUlmqGymPV9mHJtum4LF/JtDdhGWEjfhS+IutFoaGwiXYl9pTc3VpK+dtwk8Z2nSltJNNVb
	JwYIqDqKrAHQxlDYl7Qxd0/mb5rzwmi1EsDLR0xEbuegParxP+AMOGZ1J9CMjVykyxAkV8M0QF6
	BwZEx44I0BAdP/Wdpn84I919gm7C8JT2ndZSq6F1omCoBPn3DS14sN1dUZAROFMkD2XiFdyZLK0
	L6gqyVug7BCpMdYjiq89Fuo9geqPhBKTdwNjmrrQEWfqXlCQZ0ax4HUB1SRTqaJwHH0OeXTtUVw
	Xpirs0ne/y/Uf1RX0QkNUl9gAbxFS116ly13XdK3qKqBSuckyFcJp86Q==
X-Google-Smtp-Source: AGHT+IFpZaL8hrwciFMTzw5ru196/68k5fV1cy5m86NgsLOmCf24IrTkNwmnzglXIdH4B7cLxDLv7w==
X-Received: by 2002:a05:600c:46cc:b0:477:7b16:5fb1 with SMTP id 5b1f17b1804b1-477c0174856mr246174865e9.7.1764269413282;
        Thu, 27 Nov 2025 10:50:13 -0800 (PST)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479040b5c53sm77427515e9.2.2025.11.27.10.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 10:50:12 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 6.18-rc8
Date: Thu, 27 Nov 2025 19:49:56 +0100
Message-ID: <20251127184958.2776540-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linus,

The following changes since commit ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d:

  Linux 6.18-rc7 (2025-11-23 14:53:16 -0800)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-6.18-rc8

for you to fetch changes up to 7fce830ecd0a0256590ee37eb65a39cbad3d64fc:

  libceph: prevent potential out-of-bounds writes in handle_auth_session_key() (2025-11-27 09:59:49 +0100)

----------------------------------------------------------------
A patch to make sparse read handling work in msgr2 secure mode from
Slava and a couple of fixes from Ziming and myself to avoid operating
on potentially invalid memory, all marked for stable.

----------------------------------------------------------------
Ilya Dryomov (2):
      libceph: fix potential use-after-free in have_mon_and_osd_map()
      libceph: drop started parameter of __ceph_open_session()

Viacheslav Dubeyko (1):
      ceph: fix crash in process_v2_sparse_read() for encrypted directories

ziming zhang (2):
      libceph: replace BUG_ON with bounds check for map->max_osd
      libceph: prevent potential out-of-bounds writes in handle_auth_session_key()

 fs/ceph/super.c              |  2 +-
 include/linux/ceph/libceph.h |  3 +--
 net/ceph/auth_x.c            |  2 ++
 net/ceph/ceph_common.c       | 58 ++++++++++++++++++++++++++------------------
 net/ceph/debugfs.c           | 14 ++++++++---
 net/ceph/messenger_v2.c      | 11 ++++++---
 net/ceph/osdmap.c            | 18 ++++++++------
 7 files changed, 66 insertions(+), 42 deletions(-)


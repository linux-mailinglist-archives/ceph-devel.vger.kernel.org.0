Return-Path: <ceph-devel+bounces-4353-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F9C4D0BC36
	for <lists+ceph-devel@lfdr.de>; Fri, 09 Jan 2026 18:56:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D4137300EA32
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Jan 2026 17:51:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F43A27E05F;
	Fri,  9 Jan 2026 17:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j+eHDuLb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B126654763
	for <ceph-devel@vger.kernel.org>; Fri,  9 Jan 2026 17:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767981086; cv=none; b=QdmA1xk+VH1Q3UuQEZ9zytRXbznv7ULCcGWt5IdegMXrG1QB5aKHmYLqCwhKyK9YOsy6dnCfrI2RQmDdiPU2sBOWVCGb5zOq92/gxEDXSsskHoRnx8x2+ciIDpAdGxTf+D9yOFbbUzXjIvBN1jlx6BbCAXqaE0WEuGTh0f0/Fik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767981086; c=relaxed/simple;
	bh=nukBL3JnI4nbwdWBAIGHNcArZ4KLANy69KPxQgTfh38=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZDVqGM2Ycu3hQ+sP6GJelrMV3ZQZ+lDObeZnevZY9m3R6YxoOKcgf+WcocKUkJ5imU6Yo3XtqUSUeNcLSJzT2CCfRMGR3PjJVDRZtyiBXRLyDG+wDF3ymn3ct6KDrzGXAWnqhtzPRhK3mAcvaJteYW3iH3zd+Bq0zwBp+Jw53MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j+eHDuLb; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8c24f867b75so446540785a.2
        for <ceph-devel@vger.kernel.org>; Fri, 09 Jan 2026 09:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767981084; x=1768585884; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=59pVZqqsEkxF25vG/jfyP2Kz/TpG3GjdkBRW4z0ohCo=;
        b=j+eHDuLb0hZlRa2B6JFCtTKKYox6YGniWjJW58XYAQXANxZp9SEf+MZNzdsBInTWN9
         nDwuvjPdf0g2anSm1KKcsn5zs/skHtOURLyMBGAB3q+f0ek6fi//AOEomICAbSAQsNRZ
         EL6uGh+8OrwY/VOfEnTr/Xt5uNo1+X3X07s1NhIBnDs4oJwOh1QWywGkrxyQ7K9pRFXQ
         kWyvLxLXYYVB+BaiVFQP6RBpmSxaUE4aU+AH11nNuDHph7GD3UI3t/nkMDPuKbZmPRQ0
         pIfsRX2OiKNY2S+qJYNrRYaubdYabIkL5UgZiLvYVQ9fkliu490JelkTgEkHr3OgNYzE
         lxwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767981084; x=1768585884;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=59pVZqqsEkxF25vG/jfyP2Kz/TpG3GjdkBRW4z0ohCo=;
        b=o/na98D9LM4oIqfIB0yWzExEfgPfOeEFrILjMQa4MCd10/7CIDcZcYM8XMOEtyOO1u
         90glvqDYTxiN3QjmGHZ8IdGs2xWadMS4PRgQcHbKxlc5Q+dt4ajkudIzgivk8uiMq8In
         wW1s0WAouuFcRNH3tiYhSMKorZEWAw9CUQQefrUHT4z/Dgrmu6lrYcDLIfGGGxQnDKyZ
         EZDWMgYuz5VkDX8+TBOmNw3e0Osr1AQr6Ph3ZJBRLhZ4IRAl+MBi9lFcNu9SSNbmZDRg
         AW+LCmndMaxmAHQqD5wtNfMJMTCshGCnwqXqwwiWV2PFmergOFb5qTQWbuUnjbHnXsF9
         9+tg==
X-Gm-Message-State: AOJu0Yx5jj/kLTcV9OKUT+m95Xre0AfGPqXOC0TJvLC0WBOQE4zclqeK
	kw+wuXdd4USlkxKyOp7ENh8LzM4u/H1c7Fs2x+u+i5r7X58uOhYuKZJ+bngEHw==
X-Gm-Gg: AY/fxX7/rTbCFcWyk39Kr/dIDuRwoqwYlrYYY4+CTWGFwgzWjQbEp7+ZsrF+e/yM1cr
	SCmmGTzJgtmWSBIWku/gZ8oeUt5YsT/PuN2CiOacosZiEYUxz/Rexj/uBPQVvIZpiA280vryAld
	ukTOgqN+uvEQ5LgTnYIg8/Ysc0XKZgJxmd4Rx+M1Vc9g30ykx9FPWMPkFcNVZ9NVO+zFHOTWXyx
	q/xWXtMGG7NZkB52F3MynAKAXAaMFPBQg2zBy1lu4IQmY5V1UFtmSlaXCEV+GFG8FfMuyy62xZ1
	CiBc/NIjS0owdJGlnTQ0dpkepFNCDMRChywzL71TNmmtt1MxxO7CGRaITkNk+1QF7OdOwefP82H
	U1TEkSkcErsZj6ZHsJP5VRREinDgDRXZonqiOrWVdT6YxqMWPo0eRIPlugvvu/6sP6fyPC4EMWm
	0wUsTeO1llrIY9txUNco3sbc8ZZMacLMGU1DUzow6Rj5RdrSvAYbxF0A==
X-Google-Smtp-Source: AGHT+IHB/pkoDa+k1N/dFfOsiAerbCNlfCbYiQwnKaY0L49/NEWS7OIUIfssBA/T108n/KLkUoj9nA==
X-Received: by 2002:a05:622a:4c11:b0:4ee:49b8:fb7f with SMTP id d75a77b69052e-4ffb49e9d10mr160407031cf.58.1767981083677;
        Fri, 09 Jan 2026 09:51:23 -0800 (PST)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8907723436fsm90847846d6.34.2026.01.09.09.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 09:51:23 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 6.19-rc5
Date: Fri,  9 Jan 2026 18:50:57 +0100
Message-ID: <20260109175103.174536-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linus,

The following changes since commit 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb:

  Linux 6.19-rc4 (2026-01-04 14:41:55 -0800)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-6.19-rc5

for you to fetch changes up to c0fe2994f9a9d0a2ec9e42441ea5ba74b6a16176:

  libceph: make calc_target() set t->paused, not just clear it (2026-01-06 00:39:43 +0100)

----------------------------------------------------------------
A bunch of libceph fixes split evenly between memory safety and
implementation correctness issues (all marked for stable) and a change
in maintainers for CephFS: Slava and Alex have formally taken over
Xiubo's role.

----------------------------------------------------------------
Ilya Dryomov (3):
      libceph: replace overzealous BUG_ON in osdmap_apply_incremental()
      libceph: return the handler error from mon_handle_auth_done()
      libceph: make calc_target() set t->paused, not just clear it

Sam Edwards (1):
      libceph: reset sparse-read state in osd_fault()

Tuo Li (1):
      libceph: make free_choose_arg_map() resilient to partial allocation

Viacheslav Dubeyko (1):
      ceph: update co-maintainers list in MAINTAINERS

ziming zhang (1):
      libceph: prevent potential out-of-bounds reads in handle_auth_done()

 MAINTAINERS             |  6 ++++--
 net/ceph/messenger_v2.c |  2 ++
 net/ceph/mon_client.c   |  2 +-
 net/ceph/osd_client.c   | 14 ++++++++++++--
 net/ceph/osdmap.c       | 24 +++++++++++++++---------
 5 files changed, 34 insertions(+), 14 deletions(-)


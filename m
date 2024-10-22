Return-Path: <ceph-devel+bounces-1914-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21E0B9AB153
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Oct 2024 16:49:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD16D2813CA
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Oct 2024 14:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B4491A00C9;
	Tue, 22 Oct 2024 14:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b="kPtpWVPD"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B3742065
	for <ceph-devel@vger.kernel.org>; Tue, 22 Oct 2024 14:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729608551; cv=none; b=MLnVU5OpuJOZ0ATsEQnRH5H7QKTdZ5wivVLcCpsxrJPACSAMgsrF07OjkSRj8DvVZl/p9F/6J+HFLEJ4MwB15VtpKpa7ihDTLHOP/3fA35P1cn/Y0LYGc0NUxiPH00QjgeMORY5qkQVhz4ZOCMMe4Dhnhpu/7/b0qy8r1IMco5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729608551; c=relaxed/simple;
	bh=3LQjBU2NptVK3uvEYO7/wNfxRHp8C2WVWmyIbAQXQLc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QBu6OpTUTfjhOSS0DbzCI0PA3ysKhZmRXRfLOz63EwR3lRWWLlHaiYSoN5hEpQ8uLQ7HPbrdomF0M2bURQRiKhuh4yzI12iZcFxfq5sws5/F7gHFNC2EGl69c8m05H+J1h/EtOE1tflKo+VM+YSqFgrp/2TX6wBO23fUyZkhtik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com; spf=none smtp.mailfrom=batbytes.com; dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b=kPtpWVPD; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=batbytes.com
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7180e45d42fso3417806a34.0
        for <ceph-devel@vger.kernel.org>; Tue, 22 Oct 2024 07:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=batbytes-com.20230601.gappssmtp.com; s=20230601; t=1729608549; x=1730213349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9fvY5MJdcCe/8ndgD+S+xzsw7jUpi7llSam7Opftd/4=;
        b=kPtpWVPDNmIOnIi8SP2epCxSHpR5wzW2GRhRu4kw2s5Ip9W5uBDqdsg9ivIeZ7ge0R
         hZQfYxAqNIc2LB5ZbxB1CV/dW8ConMnT7BkpvxgshtUZmF4zPuc5XIyy3aFK05GOMte7
         fpq1g+Wro1K81QV77pL8IoVseAK6fjv78/oIwni9vVmSKEeHMjh9bi7HYsq+yTcfOJrV
         Emxbb5/NQNmZ7fU9v9kPQDAqrEdE+lFF/2rP1hQ3X2q1HlMSrGLsuJJ7s1ZR9rFadLLo
         wYuBI2ETdZPEGrgIjZUmn2kkbtXtn57MEYxz3bPyuJc9IVWMwEToCBFhCNdVGU/3sFD+
         tKgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729608549; x=1730213349;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9fvY5MJdcCe/8ndgD+S+xzsw7jUpi7llSam7Opftd/4=;
        b=qDcKoSqSZN7e2AdPqSB7k2bIHR6Fv4vW0DRgGEmuXIGhLEw3YCCScJHnkvq66ZxuEy
         zS8O8gIWYQUxX2BSLiognK84ldzrConaQSK7b4wEsmyDziFXD7eTgIM88NiY9lO9O6H1
         NwGTrDqIur2vRTpL4GB9tXLXyS8/83Sj6BqIf0ZNxcg7/SPgQ1SKOvGvBVXNvtd/Opgl
         DmgdQBa+vUdDJDZb0pLzVz3/6YpUKXZU5SIXOr50mO4CrK1AQ8BlaXrYEtXVU1GnzInM
         jv+BAA/aXdcIAGPeyzEM5+8WtufY0K5Tg7cW5XSE3VFlOVyM/FdBJCuYrIPdYB1YYDcu
         MPag==
X-Forwarded-Encrypted: i=1; AJvYcCWrCn/KUHPWwu1CezClAJPTP2gXdJHHoOSe1UGqZOSW3Q6NTMePSC6BtLDhe5uSkntHPSIV2Z7RL3Kp@vger.kernel.org
X-Gm-Message-State: AOJu0Yz08vj6vIZ5KFvaa7WXzE0n2hre/QBcJ7DHFczUqXhsx/1ZVGZZ
	fiMC48oORgWBIcQjJG80AXlalww5B8iCIO5ug5SjOHjGmkyB5Sufdsc2hdMpsw==
X-Google-Smtp-Source: AGHT+IEWsqVQB9L0AeieSatmVN1Q71xQ1WGs05yp4jFTkJkdDnI9yZU2wQ0beQwdCWLK4nxNCcK8Kg==
X-Received: by 2002:a05:6830:4490:b0:716:a8d5:d501 with SMTP id 46e09a7af769-7181a8348c0mr13161041a34.19.1729608548691;
        Tue, 22 Oct 2024 07:49:08 -0700 (PDT)
Received: from batbytes.com ([216.212.123.7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ce008fb5e0sm29567476d6.33.2024.10.22.07.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 07:49:08 -0700 (PDT)
From: Patrick Donnelly <batrick@batbytes.com>
To: Ilya Dryomov <idryomov@gmail.com>,
	Xiubo Li <xiubli@redhat.com>
Cc: Patrick Donnelly <pdonnell@redhat.com>,
	ceph-devel@vger.kernel.org (open list:CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 0/3] ceph: use issue_seq for struct field names
Date: Tue, 22 Oct 2024 10:48:32 -0400
Message-ID: <20241022144838.1049499-1-batrick@batbytes.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Patrick Donnelly <pdonnell@redhat.com>

Respinning this because the last series accidentally included patches from
another set.

Patrick Donnelly (3):
  ceph: correct ceph_mds_cap_item field name
  ceph: correct ceph_mds_cap_peer field name
  ceph: improve caps debugging output

 fs/ceph/caps.c               | 49 ++++++++++++++++++------------------
 fs/ceph/mds_client.c         |  2 +-
 include/linux/ceph/ceph_fs.h |  4 +--
 3 files changed, 27 insertions(+), 28 deletions(-)


base-commit: c2ee9f594da826bea183ed14f2cc029c719bf4da
-- 
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D



Return-Path: <ceph-devel+bounces-1849-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 684F2988BF5
	for <lists+ceph-devel@lfdr.de>; Fri, 27 Sep 2024 23:46:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20C5F1F22277
	for <lists+ceph-devel@lfdr.de>; Fri, 27 Sep 2024 21:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C43C172BDE;
	Fri, 27 Sep 2024 21:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NWWMHkvD"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E88414BF8B;
	Fri, 27 Sep 2024 21:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727473610; cv=none; b=dN1qGMPgX7zHctRKKRJ8qqOrf0d8DPSoJ/3+9aQeE9y1N2nFzu7xs+AYG8XMRtlBJC5bvn0Ljf0LfJnpj7bWGe1XmLoJ1eyL0TdLmX4PAvMS/WY2oceFUfYg9awl/NTZlnUQy2fAeR0N945UcBTgII4L6dbf+P3MkZR7RY5N790=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727473610; c=relaxed/simple;
	bh=Wn0F4ZZKy7MrtCQLcs6efedBXXHQO4GrYg9FzCiBgHk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rBegVL+aXmUA5GN8JeLwhZxLbwRoATigGSKkao9XjzFpu5+wq4Cqi+XeAFaFjHVcZRNuSgbCca2mzhozFDnb0U0N/vwqWVWOOb0gPzTAvHaPrGe2Okuioo8eotY1FkX0/r53UwHJW199Czuc0o6sv8cfbgRdDnqZCEIyfiZG3x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NWWMHkvD; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-42cafda818aso24499545e9.2;
        Fri, 27 Sep 2024 14:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727473607; x=1728078407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yn/nHA6wY7ndJPorvaTWw/EXz9mbabGh25VhoL58iXI=;
        b=NWWMHkvDO5DQjyP67ytlAOGUc+1qUdWc5oc6YHUS4jbpT3/2Eho+PZYit/Gt6mUm1/
         BY57NFTbiS4NPEMG20YtZdJzlBwZP4947bvKnHuXreTkwhA1iZSVGGMC8K2uAAtt5ANT
         NxJ8DQICQhRIZpzT+FFThUg34WMezz8kJNo2uza3tRNM6ZNw8IUj0JdUVyZl+5KrT/Ed
         5DgWSOpGGWwmqsFDPNYdGozDsM8qLXHZq5i3sdhOXhhvdPyxzrnX8x2NYYk1bzQGQzHE
         fd3iFPGaRYnxu/smUN6jzFUgpPRNv3UlupDeeqLpUAU610wpX6rVlzJzxpSAYmnwyJ41
         oKdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727473607; x=1728078407;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yn/nHA6wY7ndJPorvaTWw/EXz9mbabGh25VhoL58iXI=;
        b=pKV2Q3DDIeD2pewRpueTjTWyJlWM5AnoSWrCenT3zRG1NfqJmVe7O46ah9kXqUwVeB
         TYK+JlMVl4y3udGIrxLl4HKKshkLcRlBYofx2N3vrzoOCeJLDlm5sasffzN3G43Nt2Ti
         E2hWu00GZBZIkN1C7FyfNBF3O2WmeE2TJrzZCqrGLX7OJwFbEDEoq8ZfhH5NHcUbOvlf
         70EXITQfRcxRKuj8hRlzFWnwprB6zYfHNRHrl076wTFbj0ufiSxa521TS+VHtAX84Clp
         ts9Gx8Nl+oh4gdG0+ibb2euKY+ecrzPCKnnEZLTnFEhmj9iy93IwDvvsgHyc3bE9cFzq
         hdzg==
X-Forwarded-Encrypted: i=1; AJvYcCWCWNLxAgiuPbhU0dECE1TCQT84+UwmMQrGtDOIg8af+H8SMN3E570ra8UqyJwfQc6VJNjV8r8Thfj3ZPE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyY5T0P+m3ZaEN3tYCzsBimBTBkQVaMs9L+wslloTyd8ri0gUrO
	60v1FNe+0vQquI4KxpBy6/GI5ohMmJiUy0RXY901OMKi/8iCqmDhDovf5Q==
X-Google-Smtp-Source: AGHT+IGovXrIxhKdAwoOy3jyj3LmcNzEFNW26eyNFeKEnYT4q4VO5oouO+6VkbozV9mGzQJzRc5aNQ==
X-Received: by 2002:a05:600c:4f82:b0:42c:bb41:a05a with SMTP id 5b1f17b1804b1-42f584a06camr33248175e9.34.1727473606615;
        Fri, 27 Sep 2024 14:46:46 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e902560cfsm115186515e9.0.2024.09.27.14.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 14:46:44 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 6.12-rc1
Date: Fri, 27 Sep 2024 23:46:17 +0200
Message-ID: <20240927214629.141146-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linus,

The following changes since commit 5be63fc19fcaa4c236b307420483578a56986a37:

  Linux 6.11-rc5 (2024-08-25 19:07:11 +1200)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-6.12-rc1

for you to fetch changes up to c08dfb1b49492c09cf13838c71897493ea3b424e:

  ceph: remove the incorrect Fw reference check when dirtying pages (2024-09-24 22:51:33 +0200)

----------------------------------------------------------------
Three CephFS fixes from Xiubo and Luis and a bunch of assorted
cleanups.

----------------------------------------------------------------
Chen Yufan (1):
      ceph: Convert to use jiffies macro

Li Zetao (1):
      libceph: use min() to simplify code in ceph_dns_resolve_name()

Luis Henriques (SUSE) (1):
      ceph: fix a memory leak on cap_auths in MDS client

Xiubo Li (3):
      ceph: rename ceph_flush_cap_releases() to ceph_flush_session_cap_releases()
      ceph: flush all caps releases when syncing the whole filesystem
      ceph: remove the incorrect Fw reference check when dirtying pages

Yan Zhen (1):
      ceph: Fix typo in the comment

Yue Haibing (1):
      ceph: Remove unused declarations

Zhang Zekun (1):
      ceph: Remove empty definition in header file

 fs/ceph/addr.c                  |  1 -
 fs/ceph/caps.c                  | 29 ++++++++++++++++++++++++++---
 fs/ceph/dir.c                   |  2 +-
 fs/ceph/inode.c                 |  2 +-
 fs/ceph/mds_client.c            | 25 +++++++++++++++++++------
 fs/ceph/mds_client.h            |  7 ++-----
 fs/ceph/super.c                 |  1 +
 fs/ceph/super.h                 |  7 +------
 include/linux/ceph/osd_client.h |  2 --
 net/ceph/messenger.c            |  2 +-
 10 files changed, 52 insertions(+), 26 deletions(-)


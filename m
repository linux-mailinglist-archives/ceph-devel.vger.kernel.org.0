Return-Path: <ceph-devel+bounces-1804-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C29C0975536
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2024 16:25:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF6DA1C225CF
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2024 14:25:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE88319E986;
	Wed, 11 Sep 2024 14:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Lk+UZNi9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCA18F6C
	for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2024 14:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726064707; cv=none; b=nVv1slXsbqRJIc6q58XgYUJ4PcKP5U2v79QotgvXOD2i1egR/mZAXxygFH5Gem68WKr4TG41tl7MhK5KohBjlDUCNG6v/rrE12zFfo8fvV0N7b+lEmLn+ingEEswmKm8qs2Tf3jiCh/YWH7EKzzZaBWLzx0Y22OIzXGPh8bV9MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726064707; c=relaxed/simple;
	bh=rJkqHF3kgSTh8lTIZH69C0PI4ooOuBYjzOz14AO1wwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eh9tkaI343EusPRAPZPjKykVpNcfZM77MABoSY7iK/ys4XNlbOwEneaN97oaq+mJ4yDsg3XURoOjGuaVZLnMH5cwchJLt0QU1/+9ALrvhZU02TG27dgjQrnzGtbiL8nLMTuQ8uPC5OXROkhaVWqn2TreRFKhrckPlCKEGaETu+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Lk+UZNi9; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-42cbface8d6so26206625e9.3
        for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2024 07:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1726064703; x=1726669503; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UZWhUioBFQ3JU3K07edzA7pFIadgF1M47jgivmCV/Sc=;
        b=Lk+UZNi9wEwhymDaSkvVK0Nrl/ZSBn4cjE5uyFrV544OvZq7t0Hig+1C9xvXCSsuK6
         6D0JKkFu1arS92B12kdzZPdKxllBTyVq/8wcW01Nw6r4DgK9wmdNfZ3w7BdL7l3wxG9j
         ZWVoyF0yGBk/ueGeuwsCMDh2VXvooCPzLEXGmX+vvIlCAIMamuw9XIYBxbgNY4pvJQwn
         cWHFINtv8n8oR4Votdf4jbPLgLa/I3YmmTEK7D46ifWsA0MxTIprJiywLXg0VwuSKkpO
         wrcCxWg5WCqArKSuUGKJ/QyBdyhIvnuMkjjIxL/e2cDL4rapZ92C/CpIIy8v7VFqBxqv
         jsfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726064703; x=1726669503;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UZWhUioBFQ3JU3K07edzA7pFIadgF1M47jgivmCV/Sc=;
        b=ab9NOqql2uYxDIeCdbRYwCv9q48moZ8w4CzqLttM0ufuwyR+jGweyM/xq00B23Cp4d
         s7Ud/Yh/cKCYa35xHNG88G4nLCBoq3e5+1BKR2FB9Qm4EgzOE0wTfb5t2i0AFGJJRNxb
         mOiZ86oUkRCOwU93tbGSN9L4ZW4sl+b6pQsomI5x97++wdlXnWYUfoRFwPpYFEXkGpek
         tSIACeG/JVQzuIpF8bTRu8XhLCKwjQLxZDMB0/mjP7pumXkI1xQhUoNgy+X8pODDATvv
         5bUeXH0IZ1TslQQ8NZamZEheDQcJpkCBXtrxKZGpVdGwhmDSy7D2BYIr9M7T7PPQMkrp
         Ectw==
X-Forwarded-Encrypted: i=1; AJvYcCUNBgzPTW5GbgO7hIClmIflGdRY7PE1KUsLJawUJDFgujpKsjlN7yZTNOCTZmDWA5UGIiZAc1FO1Yzc@vger.kernel.org
X-Gm-Message-State: AOJu0Yx35V8A3hEdWfiM8psZbjErDu66/myhlh/CwuGfx5EPKKn/1Gyt
	h5B2ym5OTgMahBVO7hVVDQXg2EHmXwQ/16KhW0dt40LogDc2QBnKgDqyGFQnoJR/24yVDf7M7g5
	p
X-Google-Smtp-Source: AGHT+IED/DWYZSVkeDvPUoWGGZh5nk4+13ski44tln3BTTKPffV0K2R6735Rj+dUclNsjidwSkEtfg==
X-Received: by 2002:adf:e949:0:b0:374:bd48:fae8 with SMTP id ffacd0b85a97d-378922b691amr12097174f8f.25.1726064702614;
        Wed, 11 Sep 2024 07:25:02 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f17fa00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f17:fa00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d259c76e2sm617027866b.79.2024.09.11.07.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 07:25:02 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: xiubli@redhat.com,
	idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v2] fs/ceph/quota: ignore quota with CAP_SYS_RESOURCE
Date: Wed, 11 Sep 2024 16:24:51 +0200
Message-ID: <20240911142452.4110190-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <4b6aec51-dc23-4e49-86c5-0496823dfa3c@redhat.com>
References: <4b6aec51-dc23-4e49-86c5-0496823dfa3c@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CAP_SYS_RESOURCE allows users to "override disk quota limits".  Most
filesystems have a CAP_SYS_RESOURCE check in all quota check code
paths, but Ceph currently does not.  This patch implements the
feature.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
v1 -> v2: moved capable check to check_quota_exceeded()
---
 fs/ceph/quota.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index 06ee397e0c3a..c428dc8e8f23 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -334,6 +334,9 @@ static bool check_quota_exceeded(struct inode *inode, enum quota_check_op op,
 	u64 max, rvalue;
 	bool exceeded = false;
 
+	if (capable(CAP_SYS_RESOURCE))
+		return false;
+
 	if (ceph_snap(inode) != CEPH_NOSNAP)
 		return false;
 
-- 
2.45.2



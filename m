Return-Path: <ceph-devel+bounces-2639-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EBACA2B204
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Feb 2025 20:11:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15B6A188923F
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Feb 2025 19:11:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5013A1A2643;
	Thu,  6 Feb 2025 19:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="N21evy+s"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F96619F111
	for <ceph-devel@vger.kernel.org>; Thu,  6 Feb 2025 19:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738869098; cv=none; b=bjQReWlrH1O0urBTiwui3JRf7P3te9J2cM7wxybQ4myMWPowMI1e9m/901NHr56XwiRJbUu+CtJonLyHLra1DIgB6LlGQevCLNJozcf9RoeUe016LvWdrmCzsiYmtdiriewfIbhDPmMcUuV1JWGU25WNqA8vuiVBuQ1U0qwIigc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738869098; c=relaxed/simple;
	bh=9I0quCuK3ocB6TnLZEvD4/SWmOHMQKlhuRxWXICl38A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZcICyo4XavOEofik9C86ONmH3In5+jao02Bm/EinLyyN6yduYY8AVk4n1RrNZAA+cvdhK5zm8IvZ6ILen6nxHPAUdlXczt1imC0y35o8jYcd0gm0lwP95GUTt3qiyj3BJhfWHEW+mCySkO9MjdlSEz7cYPxZT0lTDGR4iufoivo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=N21evy+s; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2f9d5f8a4b9so2050038a91.0
        for <ceph-devel@vger.kernel.org>; Thu, 06 Feb 2025 11:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1738869095; x=1739473895; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MJbpg75fLLo+n0ed/sL2cOGuJyTnrmNtjTMREUR+jy0=;
        b=N21evy+savpUHrYFOo0CdnxB1C60mmja6DGgymjePyNtHUczzUlHnL2UQiTCseEVA5
         hGzQ1WiSPmFAEw28EGhdVpx3mU/if1SZ6cIMaGNHzVFgPNPsWJK8/7ltyTIUQaQuOGlF
         wsU7mkyE17GpNS+crKGf51O9cEu+VSnkKbxKBuSfe/rFsYVABr/yq4taMxm5V1IRA0NE
         ds2xwEmw36b0zZgQu7WmwCtwJKinh+S2DlPNN+ytJUC/bTkiqVj5FpYLaeW9UmGpVweG
         13eeQOfGk2qQtBC/EprDPEydVsgNQ/RzFGKAmHxKMUSKeIqGQ3JO7jclcdKBgY4gUyT6
         t9EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738869095; x=1739473895;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MJbpg75fLLo+n0ed/sL2cOGuJyTnrmNtjTMREUR+jy0=;
        b=kOWkE17bN0pyWM4ZKb03KFw1y3Sg22mTDjBZvG8kO5k2r72ekWlOg7VyW4ifn3BK3D
         N3HylFos8HRDmzrmYxZcwNCW3O59E7FlDoRLM43ECq5OxzyebLypgQjCfmfUcoIkmT+Q
         zd208lADleqrZSgnBwgbuIjhcYKVWUueqwTRYDpZr6/9EHUT5Zk5sI1+maswcgVrW+JQ
         i9lUJMlixolABR8ICEpsa/3PBtVGBp0cOq6bziueyDyAOD+bhN7cmPy62My7gepPIMQ4
         fDl+uVF3c2So1ieCPkcRTqqUvwky0gcfscEXIc96BYQqM760Ulx+l9nHDYDe/zF2RU/q
         2FAQ==
X-Gm-Message-State: AOJu0YyGV0vdHhl4f3gemonJbhh67jRwy0ZHhFIb7Ku2RdlvT0zzGJHA
	eTTFECQcsuJnqW4t9JMeLTHZlTnHahAyjZf9+8JnOXTxHdm1DYyAJOyNcaxz/SBndG/zkZ0T1D5
	zyAHb6A==
X-Gm-Gg: ASbGnctbiGwmpWpLcHtkzbpFyWG+sdnwPw0UI3y7RhEnn1VWCTgJJpw3tK5qzk7DDN+
	c5xdobQ8PzqCapu7KNaxrKhdetwFVqCeOPTUaaUdBc5zDCQcdciJYcdsT6bapBHQYZyqDf+YXBd
	ZSnOOYfexGnRs+hNzk7a2vx2CWBsnd62ZpOV4xXOw+rUqST/pJZJIBbPBCKwQ6OfbMBtP21egxd
	FEiXGYwBxnegHOn7cNOAsekkiU4wVJEydfkg0Krc2Xfi33eRJuobFbgSN+U6hiJKgPKeR9TQHRS
	GTXz2HbUkvrCtpNH0GUFirmUmWNCbVyTAA==
X-Google-Smtp-Source: AGHT+IHpR9Cnm7qEforH5SUfctVVPWqK7U1sHf/lRtPer8qEaC/amdfvhSui6GQLza8k3+7U2f6oxA==
X-Received: by 2002:a05:6a00:1f1a:b0:725:a78c:6c31 with SMTP id d2e1a72fcca58-7305d4135demr740958b3a.3.1738869094843;
        Thu, 06 Feb 2025 11:11:34 -0800 (PST)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:9444:201b:e311:73ea])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ad51af649d2sm1674301a12.56.2025.02.06.11.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2025 11:11:34 -0800 (PST)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com
Subject: [PATCH] ceph: add process/thread ID into debug output
Date: Thu,  6 Feb 2025 11:11:26 -0800
Message-ID: <20250206191126.137262-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

Process/Thread ID (pid) is crucial and essential info
during the debug and bug fix. It is really hard
to analyze the debug output without these details.
This patch addes PID info into the debug output.

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
---
 include/linux/ceph/ceph_debug.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_debug.h
index 5f904591fa5f..6292db198f61 100644
--- a/include/linux/ceph/ceph_debug.h
+++ b/include/linux/ceph/ceph_debug.h
@@ -16,13 +16,15 @@
 
 # if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
 #  define dout(fmt, ...)						\
-	pr_debug("%.*s %12.12s:%-4d : " fmt,				\
+	pr_debug("pid %d %.*s %12.12s:%-4d : " fmt,			\
+		 current->pid,						\
 		 8 - (int)sizeof(KBUILD_MODNAME), "    ",		\
 		 kbasename(__FILE__), __LINE__, ##__VA_ARGS__)
 #  define doutc(client, fmt, ...)					\
-	pr_debug("%.*s %12.12s:%-4d : [%pU %llu] " fmt,			\
+	pr_debug("pid %d %.*s %12.12s:%-4d %s() : [%pU %llu] " fmt,	\
+		 current->pid,						\
 		 8 - (int)sizeof(KBUILD_MODNAME), "    ",		\
-		 kbasename(__FILE__), __LINE__,				\
+		 kbasename(__FILE__), __LINE__, __func__,		\
 		 &client->fsid, client->monc.auth->global_id,		\
 		 ##__VA_ARGS__)
 # else
-- 
2.48.0



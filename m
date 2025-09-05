Return-Path: <ceph-devel+bounces-3531-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB390B4641B
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 22:02:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94F3117C106
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 20:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEEB129A9C9;
	Fri,  5 Sep 2025 20:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="2iKVHs5E"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC2D21B905
	for <ceph-devel@vger.kernel.org>; Fri,  5 Sep 2025 20:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757102513; cv=none; b=O/v9aagD1QgMuDqrRiA8iCsa21SZoOh2JsiZqwmM+3R6jZefPYn6eHhA62I0rID5/xIYTSKaE0WgtCexIQjPRL26ATFuFD1vvu7BiJxw0oGN4+0QS6hw8OCRfky+0BJVTAiZnl4uLrf1LbyQZhHq+j+ycuSNdVbxzLrOevvHBn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757102513; c=relaxed/simple;
	bh=m4Shq0w1QeGWE+lESirfaTaJl7mavJNlhxShOIYSN9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+0/wMWNHBMrik88xbvw4qDsQCPVpCAe+vAp9r6iTTKpi8ctPFwy4v9PJNYjlKyu4WcwF9KAumb1ngsn9MY46HiynvDdXDe4UIM348JoS6Fd1D1dxPzd61NufTo4k+Y36Ld0CUORBCSms7O/6xkVdEN5R+X5My9SwbiE095XCNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=2iKVHs5E; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e96c48e7101so2578180276.2
        for <ceph-devel@vger.kernel.org>; Fri, 05 Sep 2025 13:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1757102510; x=1757707310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y6o6xlEervPq3TBu5cEylN0YsfH2EgWkd2uA0/3pnh0=;
        b=2iKVHs5EIhD8HfzQ8cZ/uOk3sD0W593VduS/a1JMssFmjCzbcz9OZ1DKsTHQphVQcF
         HUgdEHxE84FZHMlMVJadXaz/Gqfn1/F10CpBhgGRYl1NKEeB/iiWfT8kFPvn+Gw7PgyW
         uunWI186YR/L2TDUPT1DyAhByU6yMm+YNMfhO+E3xX/T9bslSQdQdMn0fiEWTkHS3raV
         pFImyPLxTSSaZCVeI7gOUegQ4DrPzLAkFSNAIAkZsov058HcVhhLZtGhpkK6SvND5Fal
         Xa9XjxLwBNybYmcpekGJqYGDUY4yRoYS+YpK88I7dzbeAWyK1bUrM7siXhbfGLMeJC5x
         nWew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757102510; x=1757707310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y6o6xlEervPq3TBu5cEylN0YsfH2EgWkd2uA0/3pnh0=;
        b=BmOa5w58RRv0YmeThwWEvGOylk3osGiZvQRMpHnG9gZm3lyHKLQRbdFDHRq5LNQLZb
         Aj9Ul82dW2YxsEd0hFBm26svHrlFgu9yTPBXB7CSz8Z9sNlA9ZSrhPO0s4KRYY5EYjgO
         LgWyl0H8bQh6AeX6BmAa4Vr3N4iNv0LTWZki/xmPngtkV6b9WrTrarwZUle+pNDG48is
         9dSjltX9whXLaHyukUvdLCIViDHVLkytyox8R28Al3+r4t5vITph/Z0E621etU9S+5zz
         NPms3EcRq478kR7Q9z2s9+zcOJGgMJBHlS4PpcRgN6pk8GtFJEZoU5rA8nwFmoxmTymd
         Vgxg==
X-Gm-Message-State: AOJu0Yyv4RLHEZZVS8CHimIrCluZy6p0fef48j+7hzAJfUWJZCrpjlsG
	vPvjYuSaL4aMTJXnQcKfhGpGZYwj1FR9XWI96XKGZL9zbOdL/SXJllgT6pCo8ZrupwRqYDOHcxr
	TEtiFEd0=
X-Gm-Gg: ASbGncv48HRN/2AMB5sw+6OdgNcX4wy/JccIfOFAr8XHjX7jIV4P6hv/42iZEnMPN9L
	u045sCwzQqqmbS9E3hWSsbtPOWJXNJXVKzwan0uFgSzOaBzJ6kQVEEeJidEroErhu9s2IrjkL6m
	TzdwAZmppNwGUg6griqOPwP95P5ezfXg13dRv0ch5vT8WrktZT86puN1+tzlfCe4AxkijRZyC19
	5esNeOdib0KULnjZQo/0ose7f4yMfGvSx8njlvp1PelYn3sybujHs+6GU6mf+xXL1bnKJocbwf1
	QYJF/lL+qmaYLY15tpNW57vc6QRLYCkj8BxFFFJu1YyfnJB+sNqcxGvIijtZHIjy27G+IbyN14B
	ooRPFJe+xL3IdnmmNBPth0AFy8a5RfQiyuN8HJr/3XhGH6ydRMEw=
X-Google-Smtp-Source: AGHT+IGq2TElXN07d6LtA/B+GqmB04VnpnY/X4EZ8ZQmTbnUQB9PdZstgAs6SBiiv+TeeqZg/XDQsg==
X-Received: by 2002:a05:690c:4889:b0:70f:83af:7db1 with SMTP id 00721157ae682-727f2eb8fdbmr1687677b3.19.1757102509923;
        Fri, 05 Sep 2025 13:01:49 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:2479:21e9:a32d:d3ee])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a834c9adsm32360857b3.28.2025.09.05.13.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 13:01:49 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	vdubeyko@redhat.com
Subject: [RFC PATCH 03/20] ceph: add comments in ceph_debug.h
Date: Fri,  5 Sep 2025 13:00:51 -0700
Message-ID: <20250905200108.151563-4-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250905200108.151563-1-slava@dubeyko.com>
References: <20250905200108.151563-1-slava@dubeyko.com>
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

This patch adds clarifiying comments in
include/linux/ceph/ceph_debug.h.

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Ceph Development <ceph-devel@vger.kernel.org>
---
 include/linux/ceph/ceph_debug.h | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_debug.h
index 5f904591fa5f..d94865e762d1 100644
--- a/include/linux/ceph/ceph_debug.h
+++ b/include/linux/ceph/ceph_debug.h
@@ -9,11 +9,16 @@
 #ifdef CONFIG_CEPH_LIB_PRETTYDEBUG
 
 /*
- * wrap pr_debug to include a filename:lineno prefix on each line.
- * this incurs some overhead (kernel size and execution time) due to
- * the extra function call at each call site.
+ * Pretty debug output metadata: Enhanced debugging infrastructure that provides
+ * detailed context information including filenames, line numbers, and client
+ * identification. Incurs additional overhead but significantly improves debugging
+ * capabilities for complex distributed system interactions.
  */
 
+/*
+ * Active debug macros: Full-featured debugging with file/line context.
+ * Format: "MODULE FILE:LINE : message" with optional client identification.
+ */
 # if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
 #  define dout(fmt, ...)						\
 	pr_debug("%.*s %12.12s:%-4d : " fmt,				\
@@ -26,7 +31,10 @@
 		 &client->fsid, client->monc.auth->global_id,		\
 		 ##__VA_ARGS__)
 # else
-/* faux printk call just to see any compiler warnings. */
+/*
+ * Compile-time debug validation: No-op macros that preserve format string
+ * checking without generating debug output. Catches format errors at compile time.
+ */
 #  define dout(fmt, ...)					\
 		no_printk(KERN_DEBUG fmt, ##__VA_ARGS__)
 #  define doutc(client, fmt, ...)				\
@@ -39,7 +47,8 @@
 #else
 
 /*
- * or, just wrap pr_debug
+ * Simple debug output metadata: Basic debugging without filename/line context.
+ * Lighter weight alternative that includes client identification and function names.
  */
 # define dout(fmt, ...)	pr_debug(" " fmt, ##__VA_ARGS__)
 # define doutc(client, fmt, ...)					\
@@ -48,6 +57,12 @@
 
 #endif
 
+/*
+ * Client-aware logging macros: Production logging infrastructure that includes
+ * client identification (FSID + global ID) in all messages. Essential for
+ * debugging multi-client scenarios and cluster-wide issues.
+ * Format: "[FSID GLOBAL_ID]: message"
+ */
 #define pr_notice_client(client, fmt, ...)				\
 	pr_notice("[%pU %llu]: " fmt, &client->fsid,			\
 		  client->monc.auth->global_id, ##__VA_ARGS__)
-- 
2.51.0



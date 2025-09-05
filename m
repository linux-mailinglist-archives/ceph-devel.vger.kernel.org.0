Return-Path: <ceph-devel+bounces-3530-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F0F0B46419
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 22:02:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16E5317810A
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 20:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7A0D289376;
	Fri,  5 Sep 2025 20:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="ZoKYS9GW"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327122848B4
	for <ceph-devel@vger.kernel.org>; Fri,  5 Sep 2025 20:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757102511; cv=none; b=FTLcwKvB3H7Jr+LEdIoavEcUrxithM3PP+CT6+FsZ7QCmFUn+XUintwoe81Icf7/Gb4FwFzaN8Trmes0tGZgI3OkFAyEGsoe+n0QGjNKWaTUKXPeU47QdDf4e9pW3vzmBn5ABnMjq42fbe1cil9jv+Fbt2GCc7NhYAvco7wp2nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757102511; c=relaxed/simple;
	bh=9jtlf/krizDkOIprWZoV2qhZCkuJgtwjIljwr8RMNmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Clkr0+ox/KLNGS/nmW/LnLKEKvpxEMyrCuLpqOu5D/el0r/6zu7kTbiiv7kmEgYeOWgea/12Ean9+ItAXoQPffREDVYhjFIENGnzOyvif0gF+cAHsmlvndpIELDPmm9AtqS5QPK7J+xSzOzCYJmdJVn7xd/Wgdio23NH8gm2Vjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=ZoKYS9GW; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e96e45e47daso2067308276.3
        for <ceph-devel@vger.kernel.org>; Fri, 05 Sep 2025 13:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1757102508; x=1757707308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Pxp+PP2D9JPqoOUwSCs12Do/JSAVu31Lefgsp/HENc=;
        b=ZoKYS9GWzzmdQOnF78IM+M7Jma/i9Cc3xVC4bFc3FwhVp5Vhy/g4srSNoPUoz8ljDv
         Xadr1ke3NQ/20YGab3cg51YIbNhrj/l5zJa9O43OV3hS0BrvX2f8bZarKoJAK+kEpgGu
         9kc75dPlfWkL4iv2sLYAAdU03aoGclds6GFeQ4413/IMCYR6Z38jHwtKzCLtW/c77MdM
         3R3iD53PckW0UiGw5wakjcvrTO6icFgmbVYxjD4ApZj+qrNhYwgOwtLYp9Ty14+6EabQ
         e8s1U/QTTaE6xNKl9J49SlWUyZG6EaxyOm7+OLlKnxbZ2SC37xebAo00dxkg28fWW34b
         y2yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757102508; x=1757707308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Pxp+PP2D9JPqoOUwSCs12Do/JSAVu31Lefgsp/HENc=;
        b=og77ZEIZCkMBL9IfLfByxlmaxdsndktOXXGBk22gel6toGwaa2W1Ws3ucuhYi6j8xG
         ngQEOdapqr9xXeRZIMuLgpqZCi9u4marfLyu2Wh7Q9CvgMSB78MlWS+pkRGiil1R/fue
         f4lryC1D4USCkJTdstRnGS8aQ6HV+ZLN1VEjUQiKTGmoZLne+gjusjN3VO9VJc4JTROO
         ZZtjYcIVL+FpRtJVKZ5fifwxnQsmuf6bqIQK7wdlajpqAwFIAtQjhWmptqhFhvxE9AuW
         1RX9NI0uSHcsAaog5wedSORf5YaBqt3Cw6b8mcWcQ860dSBlalOvNH2R3rrhA1PnhTrT
         CT/A==
X-Gm-Message-State: AOJu0YyxWu7E4B7VlejFA4N21DNu7RohtmBncyiL5fQNfaouPFh+rY6h
	Ysl1WYzt2Ql05RpfIIrl+HrbMaMKcylmNG6IMzjF+9iBKL3sut6XgK8pnmjQealL1FZz/5UbCtD
	atl0hvC4=
X-Gm-Gg: ASbGncugR+OBmH4zCNxbuTQY40xQPU36O7WMEHpP7VRqknsJ6vhiViUlFGjYGX9ZJLZ
	7Z49hsDCTnNZNKhq7sc0lap6xf6ecYW72GdEVOmcMErx9RmDq8BAYuvfOrYuWXp+fD/ZVL5Nw2H
	WS/woEvCa7KwaYaSSzYe4mFt5rrKMa4B12k06K7abGfCPrD4AvzVrb44s1MDF3HvRWpchDR6IY0
	GMHGxv+xVdFJ8MSzqgDVIjNJNZCHZWwYpiYJeg6TRkf9eejXtR1nRPVD66ll9mprB2y2yttsRGR
	z+8S7ojWXIuFEVTsJcEvi4wW75BFZnPLyu92zqPxilx/xbeWGT8CcS6sDwW894mBGZW53Wc0HqQ
	EUbEQL9tl14wPCRNmYm9nEoars+nTQUdCuKVvRhh0+qZvbQxYuZo=
X-Google-Smtp-Source: AGHT+IFW4FGpjYdcjvZZ0/e6e3FCzxjARdw8hXw3Pzh3K0KEgYqqFtNt66+mxG//k0E+uu5F0qQwKg==
X-Received: by 2002:a05:690c:3503:b0:720:5fbc:20c2 with SMTP id 00721157ae682-727f544457dmr1101187b3.36.1757102508358;
        Fri, 05 Sep 2025 13:01:48 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:2479:21e9:a32d:d3ee])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a834c9adsm32360857b3.28.2025.09.05.13.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 13:01:47 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	vdubeyko@redhat.com
Subject: [RFC PATCH 02/20] ceph: add comments to metadata structures in buffer.h
Date: Fri,  5 Sep 2025 13:00:50 -0700
Message-ID: <20250905200108.151563-3-slava@dubeyko.com>
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

This patch adds comments for struct ceph_buffer in
include/linux/ceph/buffer.h.

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Ceph Development <ceph-devel@vger.kernel.org>
---
 include/linux/ceph/buffer.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/ceph/buffer.h b/include/linux/ceph/buffer.h
index 11cdc7c60480..e04f216d2347 100644
--- a/include/linux/ceph/buffer.h
+++ b/include/linux/ceph/buffer.h
@@ -9,13 +9,16 @@
 #include <linux/uio.h>
 
 /*
- * a simple reference counted buffer.
- *
- * use kmalloc for smaller sizes, vmalloc for larger sizes.
+ * Reference counted buffer metadata: Simple buffer management with automatic
+ * memory allocation strategy. Uses kmalloc for smaller buffers and vmalloc
+ * for larger buffers to optimize memory usage and fragmentation.
  */
 struct ceph_buffer {
+	/* Reference counting for safe shared access */
 	struct kref kref;
+	/* Kernel vector containing buffer pointer and length */
 	struct kvec vec;
+	/* Total allocated buffer size (may be larger than vec.iov_len) */
 	size_t alloc_len;
 };
 
-- 
2.51.0



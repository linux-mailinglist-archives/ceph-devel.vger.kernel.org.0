Return-Path: <ceph-devel+bounces-2511-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 34E70A15986
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Jan 2025 23:30:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CB78188CD01
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Jan 2025 22:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06DF81DB14C;
	Fri, 17 Jan 2025 22:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="pUdAmumX"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFE41ACDE7
	for <ceph-devel@vger.kernel.org>; Fri, 17 Jan 2025 22:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737153015; cv=none; b=eT+Hsoj/xNksC8QbI9d6QMm6M2vOqbIao0wWww68rqPtB1of61TUOE9WxyzJlxqCqbSWENUzlP61bhLYzFPeGpzFLXa1eAZbg4BWPqMNtj3LTToTqHm/dz2Sg6ODdx9ddg33WHXYMx7JoYHR9D5h76kaJ0tn47EfDxiZiRTsQaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737153015; c=relaxed/simple;
	bh=xr4XumRL9mJCriRsNckzs7LehNxT7dtEBYJE0fFFcVo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FQLjdFnROH3RDiO71nwm411M6az3cBbSD14vnLD2OCzCbAAqV7u0DnPPKyERppfoaYNifesBd0O1b5Yu4mRugnfbm7CG+JJf6MHE8dYzAj8z2HAaBhkm4ov14WGNyj9rRsfuL8q98C+AMz1bvS/llRtCIRiJ+QlRT0tp6scQgp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=pUdAmumX; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-219f8263ae0so50263805ad.0
        for <ceph-devel@vger.kernel.org>; Fri, 17 Jan 2025 14:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1737153012; x=1737757812; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JKzKB7GQOVB99Pmp+SqK7Er1d4vaJawJ00TnzS69gCk=;
        b=pUdAmumX9beVhYp2dBZgEi2onLLfqbo9A+YIAfDNwTsImM3By9OFSqo7e976cgto9Y
         mrL7WDr6RzUgV3pe9D31o+cZeXPf9Wsy9jeYWUdHBoLUvGhILDZKFRR/cl9s38vDMjbo
         L533Z83xFCYfNoWCHg2IZVnupcJD+21Uuio85bwXuenOhY9ToN4MAbLHfD8aajNldHPQ
         y2eDvmMhoMhbKK6BhJnluj64wA+BIH5k0NeFm7B4SG0ET0wQgnvxrwsF19oeKatcqj/7
         +rzhvUVOQn57ZGHTdV+4nhHJzYIhAAMBXDuu9LL+57/smvs/C0y09hdHzh9XmtqXyLfU
         ghAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737153012; x=1737757812;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JKzKB7GQOVB99Pmp+SqK7Er1d4vaJawJ00TnzS69gCk=;
        b=PuGVLMehPYz92cKIRUk8JVEZRqK5iDo8EJhv5DqkDkcmOJC7EBRp4F08FN+hfLm+xc
         DTp11MirPYua6tALRgOvQJk0q3IDYXhFcetctLtNqe8uBSJnMn7tPT68ShIEYfDjG9jn
         RkAR9U4rY6SfON0t52QVe2Y0my5QDe8WSyU448xQFXIFi2IxSZDdLLlkKBbifRO/l5ld
         yIqq2txheu3yhSuLKHtaNbXyfuxCAxuECC6GpJCDzxBg6OExunqL2N9CZN8puYdmFq2D
         y9L+UmCdDYFWKTNUdNTaWFsUqmYZZAPmnmp3yg135aJl8ztPaYeabcvgu8HgduHgVbj6
         0JcQ==
X-Gm-Message-State: AOJu0Yw1tvisTvDclthO4RbxiuTvXAk3ybwRBpL475GVwLF1HJOpaORu
	LhRpMqQXEXROf/Ayy3FZipsCMfXaGlXP7CUpX5REPj25dH1HIKy3jfoLGdbUx00Eo+j4aaGzDbK
	z24s=
X-Gm-Gg: ASbGncsPG2ohstPmb7dNfay3FYSp/Gxuac634OIWrBj1C2+BAYRcM173on1CUTUGh7Q
	zBftFS4hIokn2IXYLej08bAhHMK/lfpW/cm1BpaXnF85ndtdUeEPcZbL//uHI0qmhIM60o3CFVt
	C0qXdSctKf9Atad/ii0G8Y374xFCA1k9/OXodLMJ1tZkOugGNAIhQ3UaoUTeNEVF7sutKTUBWAK
	sdMnlJov2Fpy68k1ahE83HEFwGw8RxoFbfarXW0H4NPEveg1hsmf+CWhtIN8Mt8Q2vFF84q+z0=
X-Google-Smtp-Source: AGHT+IGRe1AquGZMFWjKl4R5TenxdEtlk7gYdzUwU6fJeIQO0+L3E0+EZvaXTaMv32TW8TqPA1lnZg==
X-Received: by 2002:a05:6a20:7349:b0:1e1:afa9:d38b with SMTP id adf61e73a8af0-1eb2145ccd8mr6585640637.8.1737153012079;
        Fri, 17 Jan 2025 14:30:12 -0800 (PST)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:7954:52d1:acc0:176e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dab9c9462sm2494324b3a.100.2025.01.17.14.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 14:30:11 -0800 (PST)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com
Subject: [PATCH] ceph: move ceph_frag_compare() into include/linux/ceph/ceph_frag.h
Date: Fri, 17 Jan 2025 14:29:58 -0800
Message-ID: <20250117222958.43129-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

The fs/ceph/ceph_frag.c contains only tiny ceph_frag_compare()
method. However, ceph frag related family of methods located
in include/linux/ceph/ceph_frag.h.

This patch moves ceph_frag_compare() method into
include/linux/ceph/ceph_frag.h and deletes file
fs/ceph/ceph_frag.c with the goal to keep all
ceph frag related family of methods in one place.

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
---
 fs/ceph/Makefile               |  2 +-
 fs/ceph/ceph_frag.c            | 23 -----------------------
 include/linux/ceph/ceph_frag.h | 17 ++++++++++++++++-
 3 files changed, 17 insertions(+), 25 deletions(-)
 delete mode 100644 fs/ceph/ceph_frag.c

diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
index 1f77ca04c426..4333af217557 100644
--- a/fs/ceph/Makefile
+++ b/fs/ceph/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_CEPH_FS) += ceph.o
 
 ceph-y := super.o inode.o dir.o file.o locks.o addr.o ioctl.o \
 	export.o caps.o snap.o xattr.o quota.o io.o \
-	mds_client.o mdsmap.o strings.o ceph_frag.o \
+	mds_client.o mdsmap.o strings.o \
 	debugfs.o util.o metric.o
 
 ceph-$(CONFIG_CEPH_FSCACHE) += cache.o
diff --git a/fs/ceph/ceph_frag.c b/fs/ceph/ceph_frag.c
deleted file mode 100644
index 6f67d5b884a0..000000000000
--- a/fs/ceph/ceph_frag.c
+++ /dev/null
@@ -1,23 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Ceph 'frag' type
- */
-#include <linux/module.h>
-#include <linux/ceph/types.h>
-
-int ceph_frag_compare(__u32 a, __u32 b)
-{
-	unsigned va = ceph_frag_value(a);
-	unsigned vb = ceph_frag_value(b);
-	if (va < vb)
-		return -1;
-	if (va > vb)
-		return 1;
-	va = ceph_frag_bits(a);
-	vb = ceph_frag_bits(b);
-	if (va < vb)
-		return -1;
-	if (va > vb)
-		return 1;
-	return 0;
-}
diff --git a/include/linux/ceph/ceph_frag.h b/include/linux/ceph/ceph_frag.h
index 97bab0adc58a..cb2b7610bf95 100644
--- a/include/linux/ceph/ceph_frag.h
+++ b/include/linux/ceph/ceph_frag.h
@@ -70,6 +70,21 @@ static inline __u32 ceph_frag_next(__u32 f)
  * comparator to sort frags logically, as when traversing the
  * number space in ascending order...
  */
-int ceph_frag_compare(__u32 a, __u32 b);
+static inline int ceph_frag_compare(__u32 a, __u32 b)
+{
+	unsigned va = ceph_frag_value(a);
+	unsigned vb = ceph_frag_value(b);
+	if (va < vb)
+		return -1;
+	if (va > vb)
+		return 1;
+	va = ceph_frag_bits(a);
+	vb = ceph_frag_bits(b);
+	if (va < vb)
+		return -1;
+	if (va > vb)
+		return 1;
+	return 0;
+}
 
 #endif
-- 
2.48.0



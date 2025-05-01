Return-Path: <ceph-devel+bounces-3027-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23112AA6432
	for <lists+ceph-devel@lfdr.de>; Thu,  1 May 2025 21:43:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8844A4A5BD8
	for <lists+ceph-devel@lfdr.de>; Thu,  1 May 2025 19:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 037EC22A4EE;
	Thu,  1 May 2025 19:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="2inv52Tw"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA13228CB2
	for <ceph-devel@vger.kernel.org>; Thu,  1 May 2025 19:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746128594; cv=none; b=ozRjYqFcNOtdymL+fBAIF53Aw7/9qlczQfq9sg7OZ4keCyECCl1wt2j3sazcigUh+Yhdyyc2ccqKJ1/UFaTjIJ9zEvGkJBrmwhvy0aZYIwLYjI9kWBzVIwQqpQMoe3PVlSLeYN+xRDfTN6jkNdfhTgcuPaptErztYFFB3jTBtjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746128594; c=relaxed/simple;
	bh=Qlw96zmMGwb4MvpdHK1mBI13urZDXQDO3zR6AcSYDUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdMpsxY/zDqU47VgmOHffle2CaZRETiOsE03NMlkjfoy7POC0v+TF11Bqvgd4g7Ms+c24JuXVvJkDJLTSRdXMFDQsdQrUmG+4zDujw/42N+8hOa0ykfmajhlfMdwcGeSNgkk08XXzyoRoDSAHUHhKQgjVcfgXCh0owz7+/P/LNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=2inv52Tw; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7396f13b750so1741517b3a.1
        for <ceph-devel@vger.kernel.org>; Thu, 01 May 2025 12:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1746128592; x=1746733392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iKuOTjRzfAtrB6DFEozUKn3GSt0zQlk92+VKe5OQ3fY=;
        b=2inv52TwLjfQ4OOyUCTFq8D+/V6k2xdov/IcYTKMgrebdBLUi66GpWn/4QPdZj5+pq
         sk0oExMr1jxhje5m4Gp69DMMrQe1c3I+REEiQ4hcZm8PVwT/t2huZdbnwK201ImHWYGy
         vjGd3rS86o3MCiEkP8L0e7zHSyjbbsmfDDYzFq6VR0zzqCDbTMuDlc0RehOqPW2xAnlb
         LkHYC5cH6qkHC3tcflB3soCUzZgAFT2NHPH7PSyrq0G9FnqmeJ37OapyjNrb145bVFn/
         yI0I04xD8uNStNzy95uevmAfyUWOEhosH/c9cY13BqcF2plZ+Oqcn+RpI1gEelOcLCK3
         C7gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746128592; x=1746733392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iKuOTjRzfAtrB6DFEozUKn3GSt0zQlk92+VKe5OQ3fY=;
        b=ohwDP2rguuwpdvQouijqxycQCKyq5t8du2VSxgGau+wb5yIHS2nPUFIWW3+ZVQFvdN
         4HlwkjyYoy/FsdRsWboi9tIVWRvp8PQu0axdSxogfvKkShg/uxGo+22qZlC293ncwTH7
         5KMlfrwakfx308Zay5uo2bxNUDtNXpNjOsyuQ41MRSFRzruAeqZvwrCHWK191d6YVtEG
         x6vzV82XFL2A/vFeHNN2+We+JUNwnDlv7xd9mUTKmxr0RvpRhaToqfQ65BuHNwgSPu1q
         sMs4z/h0008JmXrznfzMKn5MwfDS+XemsggtX5MTL5goxRfZwQTptR77ne76yKDDZvjs
         GhaQ==
X-Gm-Message-State: AOJu0Yww4so28isGOLllhNB0pKvyKouDt128G/Lu2Nc/08yuzG+i95BT
	v2A8i6yjFxvHEfh42T+AsqS3Rh/mhg3/6aCQTPYr3bpPyHIT3nI+mORT66lWPxBirj+pEeHyRud
	djkA=
X-Gm-Gg: ASbGncveFhDwFiFOc/JSgTmb2Q7oa6hZO3g5uMpDU9QBzX8KSjB1hugDyEC49El3OuM
	tfxWF6opy0Efh1i6JxaQImS26+hirfnrWPtFnp/cSXobd+aFIBacw5c6NjPPQeIezXWjvt1Fz8j
	Lf2i2nYim3GogfO9jqKrSw73vuwDI3qKY/Kx8vxaNNDaJGlsXhC/jzRf46LBu6NMHSxCt2B8Ue5
	4171Y4bBGa5bmmMWOVrG+hhWDhC/T3aBQQ7x8VuAt1lSyhaPIrBLTc4DGodTgTkxVdFlqX9vT/9
	1popzWAda8vLEiODTDUGbS6AZP7vO4XVx2P/N2DuOVuk/IkImyACFdcRww==
X-Google-Smtp-Source: AGHT+IFBY/vwQtnJX3EGSQ5xn9qNCaUXSy6ba87sY+Hksmpz96KowjcefUgUVPK4XtggQ5M3GXExxg==
X-Received: by 2002:a05:6a00:f0c:b0:736:3c2b:c38e with SMTP id d2e1a72fcca58-74058a42afcmr311937b3a.13.1746128592273;
        Thu, 01 May 2025 12:43:12 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:7a9:d9dd:47b7:3886])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058dc45basm50882b3a.69.2025.05.01.12.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 12:43:11 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com
Subject: [RFC PATCH 2/2] ceph: exchange BUG_ON on WARN_ON in ceph_readdir()
Date: Thu,  1 May 2025 12:42:48 -0700
Message-ID: <20250501194248.660959-3-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250501194248.660959-1-slava@dubeyko.com>
References: <20250501194248.660959-1-slava@dubeyko.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

This patch leaves BUG_ON() for debug case and
introduces WARN_ON() for release case in ceph_readdir()
logic. If dfi->readdir_cache_idx somehow is invalid,
then we will have BUG_ON() in debug build but
release build will issue WARN_ON() instead.

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
---
 fs/ceph/Kconfig | 13 +++++++++++++
 fs/ceph/dir.c   | 21 ++++++++++++++++++---
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
index 3e7def3d31c1..dba85d202a14 100644
--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@ -50,3 +50,16 @@ config CEPH_FS_SECURITY_LABEL
 
 	  If you are not using a security module that requires using
 	  extended attributes for file security labels, say N.
+
+config CEPH_FS_DEBUG
+	bool "Ceph client debugging"
+	depends on CEPH_FS
+	default n
+	help
+	  If you say Y here, this option enables additional pre-condition
+	  and post-condition checks in functions. Also it could enable
+	  BUG_ON() instead of returning the error code. This option could
+	  save more messages in system log and execute additional computation.
+
+	  If you are going to debug the code, then chose Y here.
+	  If unsure, say N.
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index acecc16f2b99..c88326e2ddbf 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -614,13 +614,28 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 		spin_lock(&ci->i_ceph_lock);
 		if (dfi->dir_ordered_count ==
 				atomic64_read(&ci->i_ordered_count)) {
+			bool is_invalid;
+			size_t size;
+
 			doutc(cl, " marking %p %llx.%llx complete and ordered\n",
 			      inode, ceph_vinop(inode));
 			/* use i_size to track number of entries in
 			 * readdir cache */
-			BUG_ON(dfi->readdir_cache_idx < 0);
-			i_size_write(inode, dfi->readdir_cache_idx *
-				     sizeof(struct dentry*));
+
+			is_invalid =
+				is_cache_idx_invalid(dfi->readdir_cache_idx);
+
+#ifdef CONFIG_CEPH_FS_DEBUG
+			BUG_ON(is_invalid);
+#else
+			WARN_ON(is_invalid);
+#endif /* CONFIG_CEPH_FS_DEBUG */
+
+			if (!is_invalid) {
+				size = dfi->readdir_cache_idx;
+				size *= sizeof(struct dentry*);
+				i_size_write(inode, size);
+			}
 		} else {
 			doutc(cl, " marking %llx.%llx complete\n",
 			      ceph_vinop(inode));
-- 
2.48.0



Return-Path: <ceph-devel+bounces-3707-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C4996B957DD
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Sep 2025 12:48:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 155AD189CA07
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Sep 2025 10:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E1BB321F22;
	Tue, 23 Sep 2025 10:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FMiDhOih"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C448E32129F
	for <ceph-devel@vger.kernel.org>; Tue, 23 Sep 2025 10:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758624448; cv=none; b=rQ5vvMtbOa0Ogow9LFiKgxChSNqsixLjB0MDNZEFnaxtzmuKEDpozvTIBKUvNJvbgvoPoO5jdqOf61N3eQo2//Nj1P5GDzWdu2HpNql5/gbNn44h4f5yEbklYSJZY+j/xOiE9dXPyCJW8FX/V5pNTNeENmPsY70zTYOWEYGN+UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758624448; c=relaxed/simple;
	bh=l2+XRRMMlUv38cxkDkgsNP7PrYQqTHAOPnKjsX3NKpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpykyGBZrQSBvONZ9ZwJxcdNs0NSx/ljQ0aDpNb9piDbD38uSVfTRxDdxwtxHBFdvOG9cUrhYXVKv1IXT8CxavS2jkeyrlTsSU9a9/8j5rrMvazgqI7kOlXR8JRUusPYKuXJ4yD6TZNBoGf7UIbOsewYXIsVznDvxYW+iAfRlE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FMiDhOih; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45ed646b656so47376115e9.3
        for <ceph-devel@vger.kernel.org>; Tue, 23 Sep 2025 03:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758624444; x=1759229244; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wY/sdmBMIe7/evMOyoyNDBqGuIEYNCftZNVDhHEUu68=;
        b=FMiDhOiher0WYGTvi9mlL0UHvwCKsGGmjWkge3xsWfv/uDzLFpbP40NiXIRMUUP968
         xwfEckY67Oh/E1gCkApvZxxe7wm6INY2+PfRri4sRHZaVJf4VH4MFohjjbV1yLhbrQxa
         lCOhz4kRZejjx8sWCcm9SeekQG7H+5pEgj/QwQxYDKdtPvmq51GHckIGEYdxBvp+43N4
         TQXV12quwS3Y2e3xL1iAppawPO1vf2BbQCcO3YiNEbW9LzcTsFrws8GNCQQXtkGQxfNH
         wy+seOz/vpZ2cdR+r84jaFF8A3IuG+Id/1OnsEzN5y25ZVX/k6owrKNrmSUGyBAYdfLY
         zsTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758624444; x=1759229244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wY/sdmBMIe7/evMOyoyNDBqGuIEYNCftZNVDhHEUu68=;
        b=s35x39kwtsPH4cEZ4UKJYj8rOpLE5KSLvXhs3e3WY1aiuMwBVjV05uuk5QprL1BgFi
         cHzUVinVi0CwM8onO7z8lqw3K4U1ICGeqzvzsiKA+OQIsgr9tmhi3NKpuuiGwMy6PwuV
         8T8whXNZy0ijGUyaz96ts8EPwe/TBjuDSl4rnF3ZbO6fTUwBrGnc3RGhYnJe4XXbEb2y
         lr1WhwP//EfRB7fJ1ACztibP3nCI/9Vsv209Lp22hzo/bK7LVdujAk1dfW7+OBQx7N79
         Eoe1m9QFZaKkxlerxXiNWOyO1RW/zpst3MPBrMyHWGewVV0BJ70ip4kudXRUP9Ep/B6Y
         wWGg==
X-Forwarded-Encrypted: i=1; AJvYcCUtE+2OCjly0/n97PhZxb4mGAOLT3kock7JzMu1ZbIX9R2j0BgGUbDsAEbHaxDdF47mCkZbzi5Q03bR@vger.kernel.org
X-Gm-Message-State: AOJu0YzeFGLdhtliUDJNe4sg4r/YryuTMXytwAU/vh//4WKsWKMKSie8
	eiHMSDviIHCArDU4zOh0DQ9nOzsYDQnwi30tjAoBDZo/9CesxksNUPuT
X-Gm-Gg: ASbGncvstimQ1zfkybbFQh3eEWA8A+dNZZtSM/yNLLGtPazPQRlMIoyFznG7e3MKEA4
	c80FAtPnTV7o/BVPX3Jq6srAyVyTqIwjrW6QapZH48l/25w1kAdYq6En7urWXGT5A1iO8XVu5Vl
	XO3FMJ57YI2bYK3R9f+l1/EctqE/eSChK8y7WntlNf5ILPKaowgQPo/Izu/4nwemAQQBrQIhaeR
	hTH0EsK15CNDocvJnDWtpvhXBrDEKjJmylMEK40bzn1CN/u3pw7FDVq3oGifHqB8bp1AZ+SXxel
	oXZHqV1Zcyq8sbmb03bR0S38mCTlnRdZEfN5B8gXsUYTbdQ4HR/Yd2/f6iBKraCajRnwoenfiu2
	Gr/48JdIq6fNZzBJhUggkYE20747prHCbjMFSaVsFumF4FpbqnBO5E8ocX4Mf9d9wEEth/4WiGF
	AtIj4F
X-Google-Smtp-Source: AGHT+IFG/viu/Q5UoxWFmn6MCDA3PwXtIt4JmmoJtRIj8itygK9JQbD92sFVJjS9mxr6/B7iPXdZCA==
X-Received: by 2002:a05:600c:c8a:b0:46e:978:e231 with SMTP id 5b1f17b1804b1-46e1e0aec9bmr23755185e9.17.1758624443810;
        Tue, 23 Sep 2025 03:47:23 -0700 (PDT)
Received: from f.. (cst-prg-21-74.cust.vodafone.cz. [46.135.21.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e23adce1bsm9710525e9.24.2025.09.23.03.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 03:47:23 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	kernel-team@fb.com,
	amir73il@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v6 1/4] fs: provide accessors for ->i_state
Date: Tue, 23 Sep 2025 12:47:07 +0200
Message-ID: <20250923104710.2973493-2-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250923104710.2973493-1-mjguzik@gmail.com>
References: <20250923104710.2973493-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Open-coded accesses prevent asserting they are done correctly. One
obvious aspect is locking, but significantly more can checked. For
example it can be detected when the code is clearing flags which are
already missing, or is setting flags when it is illegal (e.g., I_FREEING
when ->i_count > 0).

Given the late stage of the release cycle this patchset only aims to
hide access, it does not provide any of the checks.

Consumers can be trivially converted. Suppose flags I_A and I_B are to
be handled, then:

state = inode->i_state  	=> state = inode_state_read(inode)
inode->i_state |= (I_A | I_B) 	=> inode_state_set(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B) 	=> inode_state_clear(inode, I_A | I_B)
inode->i_state = I_A | I_B	=> inode_state_assign(inode, I_A | I_B)

Note open-coded access compiles just fine until the last patch in the
series.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 include/linux/fs.h | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index c4fd010cf5bf..06bece8d1f18 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -756,7 +756,7 @@ enum inode_state_bits {
 	/* reserved wait address bit 3 */
 };
 
-enum inode_state_flags_t {
+enum inode_state_flags_enum {
 	I_NEW			= (1U << __I_NEW),
 	I_SYNC			= (1U << __I_SYNC),
 	I_LRU_ISOLATING         = (1U << __I_LRU_ISOLATING),
@@ -840,7 +840,7 @@ struct inode {
 #endif
 
 	/* Misc */
-	enum inode_state_flags_t	i_state;
+	enum inode_state_flags_enum i_state;
 	/* 32-bit hole */
 	struct rw_semaphore	i_rwsem;
 
@@ -899,6 +899,35 @@ struct inode {
 	void			*i_private; /* fs or device private pointer */
 } __randomize_layout;
 
+/*
+ * i_state handling
+ *
+ * We hide all of it behind helpers so that we can validate consumers.
+ */
+static inline enum inode_state_flags_enum inode_state_read(struct inode *inode)
+{
+	return READ_ONCE(inode->i_state);
+}
+
+static inline void inode_state_set(struct inode *inode,
+				   enum inode_state_flags_enum flags)
+{
+	WRITE_ONCE(inode->i_state, inode->i_state | flags);
+}
+
+static inline void inode_state_clear(struct inode *inode,
+				     enum inode_state_flags_enum flags)
+{
+	WRITE_ONCE(inode->i_state, inode->i_state & ~flags);
+
+}
+
+static inline void inode_state_assign(struct inode *inode,
+				      enum inode_state_flags_enum flags)
+{
+	WRITE_ONCE(inode->i_state, flags);
+}
+
 static inline void inode_set_cached_link(struct inode *inode, char *link, int linklen)
 {
 	VFS_WARN_ON_INODE(strlen(link) != linklen, inode);
-- 
2.43.0



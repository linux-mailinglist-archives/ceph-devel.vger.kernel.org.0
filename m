Return-Path: <ceph-devel+bounces-3547-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B183FB4643C
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 22:04:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9A8544E3830
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 20:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA3A529A9E9;
	Fri,  5 Sep 2025 20:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="3Ng9vjS3"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C74303A27
	for <ceph-devel@vger.kernel.org>; Fri,  5 Sep 2025 20:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757102542; cv=none; b=PE/YKKhGiVq7/R+S4gnFZ5xe9EYdBW2dXXLZUTe16NaKwMnXJxYUsEG0KnE85qToeiIn0zpu3wTu9RSEEg46HvwIaoIAbM2FXTzxPGKVLrWGubNNCNAdPo6BGSfJdzThas/VNud5oiaCdHArvlX7XCoCFC23xETi+y+tnKImlv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757102542; c=relaxed/simple;
	bh=Z70XoPTOlkx9NTkkt2pkQeBwuj916mfiH00C2upYnDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WO/6clCehJ5QwNrh7CLVT2aXIVIHy69q669lX3uB16B8jBHNZoxPH/q3fCFpZE3yxd5IT2WnS+mzMKKLoy7flep0DdB+6EPhXP8x3BXfkoWot8s4B8kd34dyLf8trzg0i/9N/3IMkCsELAnDmFxNRgN2Kw0DO1WCRwBqPBL0YkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=3Ng9vjS3; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e9e87d98ce1so627021276.1
        for <ceph-devel@vger.kernel.org>; Fri, 05 Sep 2025 13:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1757102539; x=1757707339; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uWQO3dA2PY3E2HhVFs5HhmytlwkwxTfpbqYMbwO7Sb0=;
        b=3Ng9vjS3jhHMYdkXV+64ISA+U1W+sh0uWro6avjb/ozzrtS6fR38lnhKf24IA5mA4m
         WNsF0p1sQ0ZKfc+rRHEDumW9oz7Yfgr1KWe1C8VRVOfRFe6br94XPvFsbzZRL+bYuzCa
         YZuZ2BGKs3RYnMxT2aU+KhcFe+9lheVLKM6wE0nM6wl0EWXA5giQuoRloWj5NJpA1a4f
         r47jWSilgual8OD0no97H5VJKttBZgdjHFgphJWC4UJpTEQ/qHIVWyoTkHD/YhmCW2iQ
         uWkv3/EBQ0Ba4aCvn5prED+aje2vba9vibcYiBXDrYP1WYiYSlNNFxpFeMvThlFXQd+u
         2y3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757102539; x=1757707339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uWQO3dA2PY3E2HhVFs5HhmytlwkwxTfpbqYMbwO7Sb0=;
        b=lJJDynt1OFGrI8nKuCpqRI/tdz2Y1TA1Vj0swChqgtxIkUgMhRJEYrRNSXCnM5ab7/
         4YJuvHYWtCq+4FNG5jc4KfuSrfhKTcNKpPMCMQX9Vp2+//5UWLoUrTd+3KD8RLCEe3Su
         bCyGxaGMQcI+2TkGgpOnUs73ARihs07JuGzumlGTkQ4hFOAppRBALDFv7gbwAqWhL3Tn
         ja/OYTj17SBuSrqidn8xKMwNmGgJTPZFJrGsLer8QCxUQlbZwoUo6XYUikUTMZwGPdx2
         zxZ+ZL2ZOWV7gIRvQhwrMj6lgjOnPG+p4vnOBT69qXOBSOa6iQCys52hKEGaegFmFHaH
         HoAw==
X-Gm-Message-State: AOJu0YxJ/XtnmB/Lk4PFT3NeUjLp9u9VpYW2k/KmE4gz6iNNs1etH+aW
	1FYTPXkB7J5l78hUp1WM2Hd4U4LGSkcrhWSPaTXlPy1Ezk3rjWcwabAJHRp0DQeKvdMDSa0/IjR
	rHoJeHNk=
X-Gm-Gg: ASbGncuXNHjaGQaL7Piw2PJ6BOms4PPwwNwBEf8RIBbeyzJkw4s1awgI5W9hZsWmwIk
	13x1Ew0ncnebFh7JGqUtPMMEvjZy1OM//oJRnKukAnplwx7XYO8Ral7zIxrZ0jfcjlACWwPFhHH
	y+iMPk6cpKEX6DwhWHZnWR/78sKR/tz5iHCA0YZrQOtPkuvbcxCdMY/txoyX8twrjpGGjf3f591
	/2ieezJjBDfhnlDwuXHXYADaxwGCHpjhcIDUS/zMBdXBdpGn2c9hs7fC/cBT9jlfWJgt8hJBp8c
	ACJp+ZtjQfVnsvTXUzIjbhPPOCkUS8HrM8qMtCqYh5BggN4VizAsUQ3ST965n+XflKSimcy56Qu
	ntBWLuCJhKQ2+rdLtLg0b3ZYkNh1BVo1jejxN8SEF3Lz49dI4Tas=
X-Google-Smtp-Source: AGHT+IG/kcbnQZ4r9wPJa9PEhHM8BCr/6/zPvPVkQZKVMMQuqOVGK6oRdeQv44iVffo3zR4wH5qKDQ==
X-Received: by 2002:a05:690c:968f:b0:70e:142d:9c6e with SMTP id 00721157ae682-727f496b52cmr1217857b3.32.1757102539448;
        Fri, 05 Sep 2025 13:02:19 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:2479:21e9:a32d:d3ee])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a834c9adsm32360857b3.28.2025.09.05.13.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 13:02:18 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	vdubeyko@redhat.com
Subject: [RFC PATCH 19/20] ceph: add comments to metadata structures in striper.h
Date: Fri,  5 Sep 2025 13:01:07 -0700
Message-ID: <20250905200108.151563-20-slava@dubeyko.com>
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

This patch adds comments for struct ceph_object_extent,
struct ceph_file_extent in /include/linux/ceph/striper.h.

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Ceph Development <ceph-devel@vger.kernel.org>
---
 include/linux/ceph/striper.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/ceph/striper.h b/include/linux/ceph/striper.h
index 3486636c0e6e..b59c055ce562 100644
--- a/include/linux/ceph/striper.h
+++ b/include/linux/ceph/striper.h
@@ -11,10 +11,19 @@ void ceph_calc_file_object_mapping(struct ceph_file_layout *l,
 				   u64 off, u64 len,
 				   u64 *objno, u64 *objoff, u32 *xlen);
 
+/*
+ * Object extent metadata: Represents a contiguous range within a RADOS object
+ * that maps to part of a file. Used by the striping layer to break file I/O
+ * operations into object-level operations distributed across the cluster.
+ */
 struct ceph_object_extent {
+	/* Linkage for lists of extents */
 	struct list_head oe_item;
+	/* RADOS object number containing this extent */
 	u64 oe_objno;
+	/* Byte offset within the object */
 	u64 oe_off;
+	/* Length of the extent in bytes */
 	u64 oe_len;
 };
 
@@ -44,8 +53,15 @@ int ceph_iterate_extents(struct ceph_file_layout *l, u64 off, u64 len,
 			 ceph_object_extent_fn_t action_fn,
 			 void *action_arg);
 
+/*
+ * File extent metadata: Represents a contiguous range within a file.
+ * Used to describe logical file ranges that correspond to object extents
+ * after stripe mapping calculations.
+ */
 struct ceph_file_extent {
+	/* Byte offset within the file */
 	u64 fe_off;
+	/* Length of the extent in bytes */
 	u64 fe_len;
 };
 
-- 
2.51.0



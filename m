Return-Path: <ceph-devel+bounces-3548-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F037B4643F
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 22:05:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0884188B3C2
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 20:05:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 256C7305940;
	Fri,  5 Sep 2025 20:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="hlM+HBLh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2AE303A2F
	for <ceph-devel@vger.kernel.org>; Fri,  5 Sep 2025 20:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757102543; cv=none; b=AoHS/BXFSxbJg8WQGRzpH3j0nyhmmx5kkvLVeWQkbmHH5CkOMsLVBrQVLqQ10cb8k5Z70PcpDFcKeexW4g/dwUfyTsoRppmhlSr2YYLniyXfTUruHTyfRGGs+dTtkfw/tprpz9+J4N8imnmxv8wXqzvvHARw26AOflL+ItcFKfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757102543; c=relaxed/simple;
	bh=elXegIfp06UvQ3ZBvL3K2a7cSQ/TfQ317ejtVGBqJMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmfbdBFJuzBTSEZrDPwoX4P1yyNYN3eoaKaSDELUAhKbNrZYjj7VzSglpnFLoLYJXiJX6qAkoJzBGe8h8UHL4N0nYz2jv8tEKr6QKSDttTWhHVeNT3fiPoLIVigYALc4HwGA/Zi0DfLyXq5f9r5VW/idbtcEILlDHPvAMi3yJJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=hlM+HBLh; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e96ff16fea1so2649918276.0
        for <ceph-devel@vger.kernel.org>; Fri, 05 Sep 2025 13:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1757102541; x=1757707341; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SqXD0VXFoBYU6cJ8Lcdh6/Uq/24eOSrXykVwDRLc2Ss=;
        b=hlM+HBLhyQLOK33F2JAKPy0AzmqZ53wDaAwOcx5TDXFvo73AaTSqzfz5OUaKWlCjQD
         nouznFBzJURnT5UZGNBjh9bRynBui8nwmSGbkAItEN8dNYbC6jTfpipoLzOZwoWaRN/P
         ZHGzkI+bdzuo9zJzYleZyrLtqz9z1dVRHxUJuDZAkTL4US7s8D8q0NR1hdTgqtFfVljJ
         C+VPKKARyL+CSelctt8AXyghbC9h95qgSaWb5GRFm355/xDpPdMeEJWQYRPUZXLy8FDs
         pbj/eUs0jLWuTEHo+yb87UXMZ2dtl3zTSa6G8iwQmgY7OVqvXt3+FeJr3TK6T0gB7oGm
         WQhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757102541; x=1757707341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SqXD0VXFoBYU6cJ8Lcdh6/Uq/24eOSrXykVwDRLc2Ss=;
        b=lr9V4rVvyhwio2dQAVuXS5/812ZQ/HmyQEeH7l5HHtjbxxi6NJpN9+X/alVJaXnxCy
         hc2ByJ+Y7VErZ8BzNRK5QT8HAYvoSefsTQjh86UnOPJQv7sSk6o0HeJxtn8VklhX6VSK
         2yLnKqIashLGnTl6f6NY3cm364PCgT6U/azK8o2vfuCma6JRgPTFk1gy6uHvXTx0/LUp
         8qdUxIs0n5qABbbPHSiIVsn9UwwJMa99hDH014XLutstq5QZygaH0pZv9d0/U8Qqx3kl
         BTJSdLo9oeqSGB2GdJ/FDLkZ5/ux7WrV2QMQOI/OBSAoxAU4jifbA+mj5nr6Upg5skOD
         ji1w==
X-Gm-Message-State: AOJu0Yw3+yu8YwXU2/C62RK4WldvnjmCFl8Tv0X8FCDyloSHhqdLUVs+
	XQArovHHYZQTYrPbsfUehtZvR3swwrjTdFzGgYPUorXNOZnwziw18RNMFU1+gaxDGIncish9EBO
	iQPdl8Bs=
X-Gm-Gg: ASbGncvRBBNvv24tIwDmx1hAPLwZNwgd0bWiytMrbQUI0YjNmt459O736zbCSUK+KKz
	9nCpKzVU+fjeUvQniyHP8fOYOPJX3BWemAqtSZLxvuwvOtUcaiDeUwBg333nhuMfIj5pjvN9H+2
	K8M4Epbhecul6fP9d6589aZDckdvQREWuY3sPAMoHXyUil8I3FZ0c6QPk0R+BKzFboIwXzReTE2
	tKWn3NwsElgM/twlFquQ4DmlG4lwbtFDMaIJg6EpwvdWfSCt+cCZ7So2eaVIejm4LEE78k4vapV
	S82zEoshKgjE/9+5cQZ94JiTGTHn5pPQhobfVeMDJX13oyhe1JGqzPoR5s5nOLyqxAwlGPRW1GL
	CBItOChW/SHEs+MFu6VDr96sDVPlFZv0OipFrKvCsTArjxsk3KOA=
X-Google-Smtp-Source: AGHT+IF0RPvY2dcjsztligiYELPKSNmT6JTy56lcJSET5h1grWi9u8ykkmcx52gOkw15c48qJRX0yw==
X-Received: by 2002:a05:690c:6485:b0:720:d27:5d0 with SMTP id 00721157ae682-727ef8d7f3amr1959347b3.0.1757102541016;
        Fri, 05 Sep 2025 13:02:21 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:2479:21e9:a32d:d3ee])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a834c9adsm32360857b3.28.2025.09.05.13.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 13:02:20 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	vdubeyko@redhat.com
Subject: [RFC PATCH 20/20] ceph: add comments to metadata structures in types.h
Date: Fri,  5 Sep 2025 13:01:08 -0700
Message-ID: <20250905200108.151563-21-slava@dubeyko.com>
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

This patch adds comments for struct ceph_vino,
struct ceph_cap_reservation in /include/linux/ceph/types.h.

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Ceph Development <ceph-devel@vger.kernel.org>
---
 include/linux/ceph/types.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/ceph/types.h b/include/linux/ceph/types.h
index bd3d532902d7..beda96d2c872 100644
--- a/include/linux/ceph/types.h
+++ b/include/linux/ceph/types.h
@@ -13,17 +13,27 @@
 #include <linux/ceph/ceph_hash.h>
 
 /*
- * Identify inodes by both their ino AND snapshot id (a u64).
+ * Virtual inode identifier metadata: Uniquely identifies an inode within
+ * the CephFS namespace by combining the inode number with a snapshot ID.
+ * This allows the same inode to exist in multiple snapshots simultaneously.
  */
 struct ceph_vino {
+	/* Inode number within the filesystem */
 	u64 ino;
+	/* Snapshot ID (CEPH_NOSNAP for head/live version) */
 	u64 snap;
 };
 
 
-/* context for the caps reservation mechanism */
+/*
+ * Capability reservation context metadata: Tracks reserved capabilities
+ * for atomic operations that require multiple caps. Prevents deadlocks
+ * by pre-reserving the required capabilities before starting operations.
+ */
 struct ceph_cap_reservation {
+	/* Total number of capabilities reserved */
 	int count;
+	/* Number of reserved capabilities already consumed */
 	int used;
 };
 
-- 
2.51.0



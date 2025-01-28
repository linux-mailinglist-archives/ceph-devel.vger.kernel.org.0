Return-Path: <ceph-devel+bounces-2563-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 513DBA202E3
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jan 2025 02:10:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C3163A2D4F
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jan 2025 01:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF92371750;
	Tue, 28 Jan 2025 01:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="w4ykXNSY"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E42B8462
	for <ceph-devel@vger.kernel.org>; Tue, 28 Jan 2025 01:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738026643; cv=none; b=OB3Zo3mHc9c18dqCT5qOfvNlHqqB1c13m+vRsJ7dexLMlqqrRvFu5zDMujrqRgj+cQ5IEUc5kUVLauBbjz6LbmN14Cpe3AnjSsAVWmbnzLej19InGtR/xdYLsRJlD7HzorJcjxJ2uvTzOOBAW4uccwmFDxZjVHdj1basSuIZ1EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738026643; c=relaxed/simple;
	bh=idoWM8EkAkPekIxfJWfU90+4BQccVkcX3Cz8OZha4rk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pRXjZb8UfSnXQALa/J/e8tLumTgsPVW/CcX6ZH8J3gtq7O8OyH67L3rT3p3vJYNdOyL7dzpQ++GWIK+eCWoM4isohxa45mRaHEpFWS2tkQ2+K6OxPIuRgK1WestfnWUJxcCVsrzD1u/QVp2lV07banjhMvsLFsNHlqKwKo0wtEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=w4ykXNSY; arc=none smtp.client-ip=209.85.214.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-21670dce0a7so106304965ad.1
        for <ceph-devel@vger.kernel.org>; Mon, 27 Jan 2025 17:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1738026640; x=1738631440; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7aW1EosRXYDRl1YDPbjGpE1cgwqJRDI2u+FOfmgEW9c=;
        b=w4ykXNSY9SfS6yyMyCqrkouAFYgAQ037wQgy+y4bZilneK579qODJcKZUCawkTMqjY
         q7kPIC4TcgADEcaZTX7isH4G7bcubymmrTE3Pqe6W6mYparQl+99jydlY6VbeIdMSbJO
         BLPfgKjNJIQJ/FuvyptodPRUlKHdTbG7ZkWwcHa9SCYJeJduk3KfVwTkRhyLWYZJ0IIl
         V3EUDCJxUix9BnuMcN8f8fA/AaZwZaRTnjel2dQOcGHj2adnOfuglLPFK6wSIHuxOY7q
         jSdjnP/XhGcQJUeMEBCK80Tw8Oe9oiDa7Dy4urK7G1T6vX0qB11An9CtrqxNieHPzlGP
         MVcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738026640; x=1738631440;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7aW1EosRXYDRl1YDPbjGpE1cgwqJRDI2u+FOfmgEW9c=;
        b=dWyp10TBH0YQFxdodjnLaIGeP/KM574+XLbS+e3B27Mtmf7hXttjK2g1iyr76njBJ4
         7X6fAwQLYRrGnWhwButIfRTHZEKhejk16vRM4I6YN4d1hfNhU2pFMgjezb9yyHc3REVX
         ehv1jryBjHmJlqwtNeWqREu1aXp0LPbhM2vECzqcgzm48bg0bG2bZDfXbbf9N4IEhqaK
         OC9ZMkVy+IgO2PcwE/90+vJVEcs9uzTsyj1Ep9Kht8HwjQc1HZSlT6rA9f/ZrmjH7Ze9
         2RL5NGe70SKwEK2di2IVDWhAsHw8wwVO9MONYcWa766RgtzK4qCfek0eejLfP3Q86i46
         416Q==
X-Gm-Message-State: AOJu0YzYHcjkYwPcEAP2p+wzTAdWN6/FPiNjaz8mcy/+gtJ3uSj4MX2G
	2HpvXdvOxOMkuUOKz+gNj3El7k47sOE5LDE7wjD2iH04LTiujGCzHhch5fsKn6aELBNa/ruKvKB
	qyp+AkHDE
X-Gm-Gg: ASbGncublah9DUYJef3rBSdj4ryRl1/C44C6giWY3YpLM7eB4WEM+2NYiyJfTmqDbvb
	KZEO+yIaqYQ1WzsCGyiOtZdbGKZWsurpB6UxheXqKvnH/pM6mwh7EogyvhidIOnp5KCPdGL+dUp
	HuGQfzPzL3Dz1GOHdlhpfVEpsYdxAJ3juLgiyupUym1+nCtGpva6tOxvRcq+QV/EboSxH8CEMMC
	8iXE8f6RKJuFdC4e1+95f78c8Yt1Q2w1AH2PR4YAcu4HRIUDwvFCHH67skA9XpdfsllSxv3TN2U
	kaZm/X2feFuBSy5Ki2eAoDM=
X-Google-Smtp-Source: AGHT+IG2DbeQ9tm5aIbKtVDA1Dig3K5nSBz2CgNabcBO5SVG1W/sVFCbwrxpG/Bo7uYNbhrWbPdlXw==
X-Received: by 2002:a17:902:ea10:b0:216:4e9f:4ec9 with SMTP id d9443c01a7336-21c355c2906mr698721305ad.38.1738026640036;
        Mon, 27 Jan 2025 17:10:40 -0800 (PST)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:c976:3cdd:dcf6:6f29])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da424dabdsm69745735ad.253.2025.01.27.17.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 17:10:39 -0800 (PST)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com
Subject: [PATCH] ceph: is_root_ceph_dentry() cleanup
Date: Mon, 27 Jan 2025 17:10:23 -0800
Message-ID: <20250128011023.55012-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

This patch introduces CEPH_HIDDEN_DIR_NAME. It
declares name of the hidden directory .ceph in
the include/linux/ceph/ceph_fs.h instead of hiding
it in dir.c file. Also hardcoded length of the name
is changed on strlen(CEPH_HIDDEN_DIR_NAME).

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
---
 fs/ceph/dir.c                | 10 ++++++++--
 include/linux/ceph/ceph_fs.h |  2 ++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 0bf388e07a02..5151c614b5cb 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -782,10 +782,16 @@ struct dentry *ceph_finish_lookup(struct ceph_mds_request *req,
 	return dentry;
 }
 
+static inline
+bool is_hidden_ceph_dir(struct dentry *dentry)
+{
+	size_t len = strlen(CEPH_HIDDEN_DIR_NAME);
+	return strncmp(dentry->d_name.name, CEPH_HIDDEN_DIR_NAME, len) == 0;
+}
+
 static bool is_root_ceph_dentry(struct inode *inode, struct dentry *dentry)
 {
-	return ceph_ino(inode) == CEPH_INO_ROOT &&
-		strncmp(dentry->d_name.name, ".ceph", 5) == 0;
+	return ceph_ino(inode) == CEPH_INO_ROOT && is_hidden_ceph_dir(dentry);
 }
 
 /*
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index 2d7d86f0290d..84a1391aab29 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -31,6 +31,8 @@
 #define CEPH_INO_CEPH   2            /* hidden .ceph dir */
 #define CEPH_INO_GLOBAL_SNAPREALM  3 /* global dummy snaprealm */
 
+#define CEPH_HIDDEN_DIR_NAME	".ceph"
+
 /* arbitrary limit on max # of monitors (cluster of 3 is typical) */
 #define CEPH_MAX_MON   31
 
-- 
2.48.0



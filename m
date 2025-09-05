Return-Path: <ceph-devel+bounces-3540-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 46684B4642F
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 22:03:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 009533A622D
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 20:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E23132D6E4A;
	Fri,  5 Sep 2025 20:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="vpFD+WRJ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E042D1F4A
	for <ceph-devel@vger.kernel.org>; Fri,  5 Sep 2025 20:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757102527; cv=none; b=iyDJC8BBikpgdSo6Q9B3kX69OvG3dszIzF2nKxL9YBSVu9O1zR1WDlz93BlvhUpheWXNb7ZfBKdQ3R6QmDNztYTnklm+tqXd29bd+S33eA5Msyw2uoXX30VrVdHX7WZLcZL2BcRq64f1RoVQJlqu+h4cX9C2Felh5lSPbeG9XpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757102527; c=relaxed/simple;
	bh=lzvZtd9QaLs9Mp4bnsCTmfgKDPRPxFwFfvTW9YuwzWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGCqrJby+Hc5Uy9Al2O57P2Jgz0N+zvQhq4UXKbMmsHFjXLVkbb4p1y44LbjwrBAmE/bnfIdhtY5nnOmwbtREc0SZpag0ZbyFS6+UDAq0DzDlS43iW2upxbl6MbdZ2qDRQdQ9SdsvX7NrexIwMQkPAf2mHPhVZRiGg1DSafa334=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=vpFD+WRJ; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-71d5fe46572so26627567b3.1
        for <ceph-devel@vger.kernel.org>; Fri, 05 Sep 2025 13:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1757102525; x=1757707325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AT02V3uoxau5C6n6cmuTqXU0grnKwiAJMFAqst9Yb2M=;
        b=vpFD+WRJ2l4nQKm3dIh2OtyiW6Yk+PMcE4C073glUSFHvLzhF9oK9IV49LE1OTk6R0
         1cVt5gOrtuFihnamjOZ6aRebPI7wFRFTDfQM73KkeKJuXaakYVFDgoqkSvjrW5Ld9F8G
         U8vNHrPkh+mOfFFxfo0Z7vhdWHLLSs6rElKgD2L3MB1BFvxxaxVitZOOpPyn+ChrCE6x
         HhlOJ69i1GpqkYKp4Xx5HGft02sP+ywBT3yaf//yedtgJWImQfzBCq8B7e1TZKok7ejY
         I1TX4QZP9l2l7sKZdkAuVHI84j/qKO3Ceii/EJ+WP+mrHwGG4UgKMfsjGwlKcO7Xi9ds
         rGlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757102525; x=1757707325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AT02V3uoxau5C6n6cmuTqXU0grnKwiAJMFAqst9Yb2M=;
        b=XhZKOvrOdoeBE5G5BPW9iOZQo4Zh5+Bt4ZW36ZWJiiI0Dedz/M301Ls24y1xb3vx8w
         YLNlJbjK0eEMJRNbQw7MtTq2Ac0bF3oQSjkpuLJlBBkepUQjxxKj+BwpHMAmCy7HxfUg
         c6SZIdOGhlqnBfQ+KdLQRNNjTj68Sqvu+YgFfDW2emMM6/2vUlPYtk5hmvQlxjTdl5ei
         9i+JBbOghCsaWszWqOVEuED2FNuZhv7/q9h38BSmQXbiYuHx9dthBy5Aq0iWeHp0AnPW
         oG6i5gOHc7rivtbjGEaMyGOW3tWAfNMZ1sW09kydbEGMC+/gxNBY5mCiQ4hTahkGsTSk
         2PXg==
X-Gm-Message-State: AOJu0Yy7Sm4ncBGdzE1F3PQINVgu2EmBuka59QUjbZOJP2rEFTojhg3X
	8WR6rJdWFj7ZwR3gr+HZ0KFCH+V3Xr8Y1h7wdLOsYmu2+3zgDxt7yzpQGli562LabdfvTD9AkGa
	thz+3TcE=
X-Gm-Gg: ASbGncsMci7CKGT1LOvqgZpf344YX048ke5Giy9WXMg/fuyOoVgYujnV0WOpydCXD+O
	Cpg5oqHfHJrcrOSXTr/qOiM3kTCzAAtFGdgtdcbRdj6TooPDkq+AvMIkcJ0Td7KJw5mQcU4LSJe
	GWW6brf7BXuwA+j9qeoHN9INLXEkmfaC6Pc4O+uD5l49JaHIHDV+jtJAbkGv8VF07yOFmXKdGV3
	2wjOOC+jbB7pQ4RHEmifIwyo/zDlPwVJQ1nyb1VLPyphDtfReZVp64zbUbee+VpyzP5A9g/oa3E
	xu7dFJbCDm1u+2lymeJ0ba4/R6OZksFWZmUIHDADZBt1maPrfUhFJk8uWYVIqDX4NabTGjn5oSM
	0jR3Ffjt85hxF7ANDmMysT7N3lV9gywDkkl1mS3yM
X-Google-Smtp-Source: AGHT+IFHAx9lD6xpdTqy04zuegUJ0B3AsKgYgmCqBxZsWyOgz+3OzQJ2I0nLByYcffNTK474tlO+kg==
X-Received: by 2002:a05:690c:dcf:b0:721:b47:e22a with SMTP id 00721157ae682-725479a4e6amr49658577b3.25.1757102524657;
        Fri, 05 Sep 2025 13:02:04 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:2479:21e9:a32d:d3ee])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a834c9adsm32360857b3.28.2025.09.05.13.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 13:02:04 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	vdubeyko@redhat.com
Subject: [RFC PATCH 12/20] ceph: add comments to metadata structures in msgpool.h
Date: Fri,  5 Sep 2025 13:01:00 -0700
Message-ID: <20250905200108.151563-13-slava@dubeyko.com>
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

This patch adds comments for struct ceph_msgpool
in /include/linux/ceph/msgpool.h.

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Ceph Development <ceph-devel@vger.kernel.org>
---
 include/linux/ceph/msgpool.h | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/ceph/msgpool.h b/include/linux/ceph/msgpool.h
index 729cdf700eae..27e6a53a014d 100644
--- a/include/linux/ceph/msgpool.h
+++ b/include/linux/ceph/msgpool.h
@@ -5,14 +5,21 @@
 #include <linux/mempool.h>
 
 /*
- * we use memory pools for preallocating messages we may receive, to
- * avoid unexpected OOM conditions.
+ * Ceph message pool metadata: Memory pool for preallocating network messages
+ * to avoid out-of-memory conditions during critical operations. Maintains
+ * a reserve of messages with specific types and sizes for reliable operation
+ * under memory pressure.
  */
 struct ceph_msgpool {
+	/* Descriptive name for debugging and identification */
 	const char *name;
+	/* Underlying kernel memory pool */
 	mempool_t *pool;
-	int type;               /* preallocated message type */
-	int front_len;          /* preallocated payload size */
+	/* Message type for preallocated messages */
+	int type;
+	/* Size of preallocated front payload */
+	int front_len;
+	/* Maximum number of data items in preallocated messages */
 	int max_data_items;
 };
 
-- 
2.51.0



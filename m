Return-Path: <ceph-devel+bounces-3536-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A67DB46426
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 22:03:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 208E13AAC4F
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 20:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC8222C21D1;
	Fri,  5 Sep 2025 20:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="zUlW+Elg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22BB2C0263
	for <ceph-devel@vger.kernel.org>; Fri,  5 Sep 2025 20:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757102521; cv=none; b=YJo/sFpEQGIK/BpNCtz9W3QfzZQh7p4mqFDsXmZNdTTzNvUCMcIxkxaxQ8UfewdnmYRwvABNvNNr5yUShZsul4DrOQV4VhaQuHVwa9JqFmvV4tVcnldA7V7dFQezBORRCUzZ2Pc41to5eep/AYTLlA+HgKlFTCcTX6AeutI+XtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757102521; c=relaxed/simple;
	bh=uslSZosQcItNKzefvZEkseAe4QBYafj2nUTG7MdKdOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+pybBR0zhcDMUkennQT4TQnbixpW0LW6vqBdpOlRmx6LCsxks5bqpCHDIZhTISsg7kPSj/kS04k85k411ieji6l6Cu8UzQIzS7Rxv1tPUeoZaTDI/ZHWkuX0G6jaqTy+R4aX/p22+Lyi84cppMeGUTImn+dEpGQsnZ5/xinTTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=zUlW+Elg; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-71d6014810fso25459537b3.0
        for <ceph-devel@vger.kernel.org>; Fri, 05 Sep 2025 13:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1757102518; x=1757707318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TjipGYKyY3TRsiPrjfJ9bWYd5Csk4u5UtulZ6LHB7mA=;
        b=zUlW+Elg8qGjp2PWZnBL3i3rCsw3samqBTDG4W8xzkOm8ovs4TiRCA1EaMmytHrmY7
         6YgDWYn6nGPR+SX5e4GXLYFYCPZKIKqPde5/WpkhIf/aJ5rtFY6qNNedTavEDmqrJAFL
         F585x9X5OnZ2tMUNcMeXNgjXAdHKCu1Yxfu8urUaItKJvyyESFruYqk0qS7BzI7jU3Cc
         0vfYxQxSVb0v2K+nQcBH0gSBO7cyhlh8RWAAz7rWY2vLMi138G2S439sIEEyb9mf9ObU
         wOiuWFnXG4SClmOapKxGrRY5PajJljtN/gG8oMDQAFqlPV/zQ/LmZeXMP9PWY2qU5oXJ
         zdkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757102518; x=1757707318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TjipGYKyY3TRsiPrjfJ9bWYd5Csk4u5UtulZ6LHB7mA=;
        b=bAJVo70VkrOVx8L6P5yI5A+dG5tdhiuiMgloEyAte5fj7NtY1aVyeAkuoD0csSpMkO
         gkgaE0TYiFP9bBXx6S9z7tKv4oKuZ/FIkPaqNTd7QBFvuOtpLlhPpzHICzYWZjlqPpjd
         XQue8eSOEt1x1BIhwhxsBKxaTf8fBanSZkSvwtoC8k+GlYKz6j8r+u9OpZI/XpIAu3JH
         hVoDz/IREjJYX/d2QxUgTFM7gmMQVIj8ua4cNnZ2FWghwC/SJuc3kBHDVNG1S8twSc8S
         QzmeqS7Qto2FDWOGlArx/NlCaUBwJShHlirAxcVGOFWsFaHohWdxlnjL2kpwdY9S+0X+
         Tt8w==
X-Gm-Message-State: AOJu0YypQ1JBP5OhzNz8RTXb3NHYUYeFLQIksWU0H4w2yAICZ1rh2Dn8
	6Q4j0Z6qZHIofd/O7NUnUfoUAD8mmcJx35u/NxbrJEybp8Rvukt9DoqSawA/w3Hoh97dXiDvOTL
	dq5id+zI=
X-Gm-Gg: ASbGncvr+/Zxaxu2/phGFJCk0f51VRqiMVlgnJ4Dd69BnvyTF4V0H7Igq0OHszHjTRb
	96aMfWKPgzVoTQ3zU2pXBgXL+KNovEQcuXUy3r8eND79eXNwzdBjsSzIZRDX538LLuADgWVlKOZ
	zoBlFuLNaRfMNT7LoeyyH9tpHSaxQdC81u48+ecMLX2SxtRVZMp3AtgLPZMcoOIqLAlUMfkVC3n
	uMnNc5uVMbVPSa5bdvE2RmejmTDo6vqBSPdWOhIEbfBaL2IO305fNioMbodLZuBsJD0eWbexT9S
	QekSwGRltOuvGI3n0LPf+Dng1kB9bNl7IKED7JiiFlW961TuOEGPOG1M63nJ5E4FQPy4GAHkJIF
	0CQ3yZ/9uOH764vbg9uUUcS1A85u6KWqGH6Odoe5Y
X-Google-Smtp-Source: AGHT+IEqLOrC9IAFSmIP5/QlXSkdROjARzfVFjjoirtQyRxiNVrYUsamXSZWvTI218L4UhrxfTnddw==
X-Received: by 2002:a05:690c:dcc:b0:722:77b9:705f with SMTP id 00721157ae682-727f514f0b2mr1189577b3.39.1757102518456;
        Fri, 05 Sep 2025 13:01:58 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:2479:21e9:a32d:d3ee])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a834c9adsm32360857b3.28.2025.09.05.13.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 13:01:57 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	vdubeyko@redhat.com
Subject: [RFC PATCH 08/20] ceph: add comments to metadata structures in cls_lock_client.h
Date: Fri,  5 Sep 2025 13:00:56 -0700
Message-ID: <20250905200108.151563-9-slava@dubeyko.com>
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

This patch adds comments for enum ceph_cls_lock_type,
struct ceph_locker_id, struct ceph_locker_info,
struct ceph_locker in /include/linux/ceph/cls_lock_client.h.

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Ceph Development <ceph-devel@vger.kernel.org>
---
 include/linux/ceph/cls_lock_client.h | 34 +++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/include/linux/ceph/cls_lock_client.h b/include/linux/ceph/cls_lock_client.h
index 17bc7584d1fe..8eae9f6ee8b6 100644
--- a/include/linux/ceph/cls_lock_client.h
+++ b/include/linux/ceph/cls_lock_client.h
@@ -4,23 +4,51 @@
 
 #include <linux/ceph/osd_client.h>
 
+/*
+ * Object class lock types: Defines the types of locks that can be acquired
+ * on RADOS objects through the lock object class. Supports both exclusive
+ * and shared locking semantics for distributed coordination.
+ */
 enum ceph_cls_lock_type {
+	/* No lock held */
 	CEPH_CLS_LOCK_NONE = 0,
+	/* Exclusive lock - only one holder allowed */
 	CEPH_CLS_LOCK_EXCLUSIVE = 1,
+	/* Shared lock - multiple readers allowed */
 	CEPH_CLS_LOCK_SHARED = 2,
 };
 
+/*
+ * Lock holder identifier metadata: Uniquely identifies a client that holds
+ * or is requesting a lock on a RADOS object. Combines client entity name
+ * with a session-specific cookie for disambiguation.
+ */
 struct ceph_locker_id {
-	struct ceph_entity_name name;	/* locker's client name */
-	char *cookie;			/* locker's cookie */
+	/* Client entity name (type and number) */
+	struct ceph_entity_name name;
+	/* Unique session cookie for this lock holder */
+	char *cookie;
 };
 
+/*
+ * Lock holder information metadata: Contains additional information about
+ * a lock holder, primarily the network address for client identification
+ * and potential communication.
+ */
 struct ceph_locker_info {
-	struct ceph_entity_addr addr;	/* locker's address */
+	/* Network address of the lock holder */
+	struct ceph_entity_addr addr;
 };
 
+/*
+ * Complete lock holder metadata: Combines lock holder identification and
+ * network information into a complete description of a client that holds
+ * a lock on a RADOS object. Used for lock enumeration and management.
+ */
 struct ceph_locker {
+	/* Lock holder identification (name + cookie) */
 	struct ceph_locker_id id;
+	/* Lock holder network information */
 	struct ceph_locker_info info;
 };
 
-- 
2.51.0



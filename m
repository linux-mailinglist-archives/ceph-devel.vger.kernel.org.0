Return-Path: <ceph-devel+bounces-3545-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D6383B46439
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 22:04:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FFF217BEAA
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 20:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB201303A18;
	Fri,  5 Sep 2025 20:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="VLNSJSsS"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C5A28BA95
	for <ceph-devel@vger.kernel.org>; Fri,  5 Sep 2025 20:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757102539; cv=none; b=bSOi+xz5Po9xAC2m/+cjUcL4/YD7SWLW7rFf7RML1F72a1+lBTp2OvYcBtme+CqJFCKlJf9UBJijYdpPMraNjoK1AxbpVuyAG8R7aZEMVgREyuIuVUDBbL1eLEERrB03ZGwj4i6eWuIgI/XjhNU8VkqQaUFbssS3Z1gSxO8oV5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757102539; c=relaxed/simple;
	bh=QD/XJd1fMfno8Xq/Ua6evXoBaLVg9iLmUIRUFCvvAJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugF8INFOd5f8jnnpzyqF9GqlAD5dK3ug0TWMSpF6kS6fFbBBpSWtTiYZau8g5EA12YGA5PbORMpzilFkgkciPFbB2BzfDTYcBDkkpp3AF2EV7/Jig2PEn/C1nXri1vCqb+XBVu8M05NvWW7tUnXl+eaKzqIiob7dc30OxRy7McI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=VLNSJSsS; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-71d6051afbfso25999077b3.2
        for <ceph-devel@vger.kernel.org>; Fri, 05 Sep 2025 13:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1757102536; x=1757707336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XlFTId6UV7Bo09rJ9zs7osFZ95bNpE1HJh5KJ9UpQNI=;
        b=VLNSJSsSIHP0hAF6KNRtsUx32ngJofUf2SNK+137QvDRZBmiba/98N7CcDZN/BwRbo
         YHj3yAWX5tLp97ZJMV/XDfFpl6++W87YeDIcqMIz9nk56wM5WXmuY5NIwdnUtjQk9cDX
         P1FG53yRgil439mQ52vE3YhT7fQimJzcJCqqMjqa+JbW2SaHY/kWe/RhCvKVnjFtbvnU
         5x83agg5pmXywLmXz4Q0pagCNIm/qPI8p7Xdxl1Glj6HiuTtwKiZgcx5s6rhrXItGVh6
         DxMK4hoIfLv6+SPS/eMpUgls0sdtKA3naeFoe8k5t1E5MdvDpm08womwU961eJhjYX5A
         ZJdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757102536; x=1757707336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XlFTId6UV7Bo09rJ9zs7osFZ95bNpE1HJh5KJ9UpQNI=;
        b=QQ5kIC0x6Osbwu4lRN2rMDfuguSA/7RzDy2DNwIT7So9zi9mNncGBwvsquZxN6i/CX
         gTk+8yen5z+oVWzJfH+n8cqX5tWJTC9fO5PQZyeb/48rOC5KglXqj0O0RB1b+5z8uiJH
         AucYnHbqRtOkZoQ7jIXW/NGhUYbK+KN0eEpbKkoMg/zWZ6CeKXLENkwFpu9uDKXv0NGV
         H+73pg030eERYKe59CdsQiaSHN6R17CH4cmbeR3hLIOF3pIbOjKFaLeb/j98XzshZFx3
         6ANRhbHa7r5da1VwGQDnoPR7lWU2B6Rbbwm8U9kaS5a6oxiOq38brN0Z2YwhnLk731SJ
         4cDA==
X-Gm-Message-State: AOJu0YzAF9ZT9GCrSDCN9hX18kDwh5mvCe0eUhSCiUQFClvGSuqB3Seu
	HHGZj+RrTetcUZkpsWq735Q2DFkMPGsweF7s9rD74ozcpdW/sq5nf6gw9dF3WAIbXbGdtzcgM+3
	3Azkb0Yw=
X-Gm-Gg: ASbGncurov4kr5jOMGQCfmmb6GbkEn11XvaP6RBr01qOnJ97VjBACGYVql3v3zrRlqL
	hToXCTIocc//y4jW01MuTMwHwwx6sCR2vgpj2HSfwk0YhFiGNjDjh7Ge0GtAwLGZJM70sCl6OPW
	CYF8F5u2Mk7bAOWbI7uvWKyvF9QyGplFEbx4KLpf40n/5CRWExcEXzSAVeZ2svwhvXbmViQTQlc
	WIbWwDrMyOKU5o/X7/I7Pw9MMXBxErxLLuRfavltMXX9ckWaj8ffrOOiQvckLoApH4zWDZ/A7OM
	lkPHmJgKUNXbHutavOKoyeJ8G4fhr802Qlhsx5xngqH//A/VJUhnFY9xKjreU7xxuxn/QvxgzQf
	L20N6fFavKgZoXCDrZ+WKI4ljqEKHR9e6bwqDmP9Ocu01Oh1P9T8=
X-Google-Smtp-Source: AGHT+IHa9Svm+dbm4fl3DsCOzIyUZBItu4CNR2HYQsap9/tb5+gRYuyWzuYLGaoH2mz6m166nqp7WQ==
X-Received: by 2002:a05:690c:3392:b0:726:bba4:dd50 with SMTP id 00721157ae682-727f27dbf83mr1265017b3.8.1757102536021;
        Fri, 05 Sep 2025 13:02:16 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:2479:21e9:a32d:d3ee])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a834c9adsm32360857b3.28.2025.09.05.13.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 13:02:14 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	vdubeyko@redhat.com
Subject: [RFC PATCH 17/20] ceph: add comments to metadata structures in rados.h
Date: Fri,  5 Sep 2025 13:01:05 -0700
Message-ID: <20250905200108.151563-18-slava@dubeyko.com>
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

This patch adds comments for struct ceph_fsid,
struct ceph_timespec, struct ceph_pg_v1,
struct ceph_object_layout, struct ceph_eversion,
struct ceph_osd_op in /include/linux/ceph/rados.h.

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Ceph Development <ceph-devel@vger.kernel.org>
---
 include/linux/ceph/rados.h | 91 ++++++++++++++++++++++++++++++++------
 1 file changed, 77 insertions(+), 14 deletions(-)

diff --git a/include/linux/ceph/rados.h b/include/linux/ceph/rados.h
index 73c3efbec36c..1850ef439bf6 100644
--- a/include/linux/ceph/rados.h
+++ b/include/linux/ceph/rados.h
@@ -10,9 +10,12 @@
 #include <linux/ceph/msgr.h>
 
 /*
- * fs id
+ * Filesystem identifier metadata: Unique 128-bit identifier for a Ceph cluster.
+ * All clients and daemons in the same cluster share this FSID, used to prevent
+ * accidental cross-cluster communication and data corruption.
  */
 struct ceph_fsid {
+	/* 16-byte unique cluster identifier */
 	unsigned char fsid[16];
 };
 
@@ -30,8 +33,15 @@ typedef __le64 ceph_snapid_t;
 #define CEPH_NOSNAP  ((__u64)(-2))  /* "head", "live" revision */
 #define CEPH_MAXSNAP ((__u64)(-3))  /* largest valid snapid */
 
+/*
+ * RADOS timespec metadata: Network-endian time representation used in
+ * RADOS protocol messages. Provides nanosecond precision timestamps
+ * for object modification times and other temporal data.
+ */
 struct ceph_timespec {
+	/* Seconds since Unix epoch (little-endian) */
 	__le32 tv_sec;
+	/* Nanoseconds within the second (little-endian) */
 	__le32 tv_nsec;
 } __attribute__ ((packed));
 
@@ -54,13 +64,17 @@ struct ceph_timespec {
 #define CEPH_PG_MAX_SIZE      32  /* max # osds in a single pg */
 
 /*
- * placement group.
- * we encode this into one __le64.
+ * Placement group identifier (version 1): Identifies a placement group within
+ * the RADOS system. PGs group objects together for replication and distribution.
+ * This version is encoded into a single __le64 for efficient storage and comparison.
  */
 struct ceph_pg_v1 {
-	__le16 preferred; /* preferred primary osd */
-	__le16 ps;        /* placement seed */
-	__le32 pool;      /* object pool */
+	/* Preferred primary OSD for this PG */
+	__le16 preferred;
+	/* Placement seed for object distribution */
+	__le16 ps;
+	/* Pool identifier this PG belongs to */
+	__le32 pool;
 } __attribute__ ((packed));
 
 /*
@@ -104,18 +118,26 @@ static inline int ceph_stable_mod(int x, int b, int bmask)
 }
 
 /*
- * object layout - how a given object should be stored.
+ * Object layout metadata: Describes how a specific object should be stored
+ * and distributed within the RADOS cluster. Contains placement group mapping
+ * and striping information for optimal data distribution.
  */
 struct ceph_object_layout {
-	struct ceph_pg_v1 ol_pgid;   /* raw pg, with _full_ ps precision. */
-	__le32 ol_stripe_unit;    /* for per-object parity, if any */
+	/* Raw placement group ID with full placement seed precision */
+	struct ceph_pg_v1 ol_pgid;
+	/* Stripe unit size for per-object parity (erasure coding) */
+	__le32 ol_stripe_unit;
 } __attribute__ ((packed));
 
 /*
- * compound epoch+version, used by storage layer to serialize mutations
+ * Extended version metadata: Compound epoch and version number used by the
+ * storage layer to serialize mutations and ensure consistency. Combines
+ * cluster-wide epoch with object-specific version for total ordering.
  */
 struct ceph_eversion {
+	/* Object version number within the epoch */
 	__le64 version;
+	/* Cluster epoch number (map generation) */
 	__le32 epoch;
 } __attribute__ ((packed));
 
@@ -484,61 +506,101 @@ enum {
 };
 
 /*
- * an individual object operation.  each may be accompanied by some data
- * payload
+ * Individual OSD operation metadata: Wire format for a single operation within
+ * an OSD request. Each operation may be accompanied by data payload and contains
+ * operation-specific parameters in a discriminated union.
  */
 struct ceph_osd_op {
-	__le16 op;           /* CEPH_OSD_OP_* */
-	__le32 flags;        /* CEPH_OSD_OP_FLAG_* */
+	/* Operation type code (CEPH_OSD_OP_*) */
+	__le16 op;
+	/* Operation-specific flags (CEPH_OSD_OP_FLAG_*) */
+	__le32 flags;
+	/* Operation-specific parameters */
 	union {
+		/* Extent-based operations (read, write, truncate) */
 		struct {
+			/* Byte offset and length within object */
 			__le64 offset, length;
+			/* Truncation parameters */
 			__le64 truncate_size;
 			__le32 truncate_seq;
 		} __attribute__ ((packed)) extent;
+		/* Extended attribute operations */
 		struct {
+			/* Attribute name and value lengths */
 			__le32 name_len;
 			__le32 value_len;
+			/* Comparison operation type */
 			__u8 cmp_op;       /* CEPH_OSD_CMPXATTR_OP_* */
+			/* Comparison mode (string/numeric) */
 			__u8 cmp_mode;     /* CEPH_OSD_CMPXATTR_MODE_* */
 		} __attribute__ ((packed)) xattr;
+		/* Object class method invocation */
 		struct {
+			/* Class and method name lengths */
 			__u8 class_len;
 			__u8 method_len;
+			/* Number of method arguments */
 			__u8 argc;
+			/* Input data length */
 			__le32 indata_len;
 		} __attribute__ ((packed)) cls;
+		/* Placement group listing */
 		struct {
+			/* Listing cookie and count */
 			__le64 cookie, count;
 		} __attribute__ ((packed)) pgls;
+		/* Snapshot operations */
 	        struct {
+			/* Snapshot identifier */
 		        __le64 snapid;
 	        } __attribute__ ((packed)) snap;
+		/* Watch/notify operations */
 		struct {
+			/* Unique watch cookie */
 			__le64 cookie;
+			/* Version (deprecated) */
 			__le64 ver;     /* no longer used */
+			/* Watch operation type */
 			__u8 op;	/* CEPH_OSD_WATCH_OP_* */
+			/* Watch generation number */
 			__le32 gen;     /* registration generation */
 		} __attribute__ ((packed)) watch;
+		/* Notification operations */
 		struct {
+			/* Notification cookie */
 			__le64 cookie;
 		} __attribute__ ((packed)) notify;
+		/* Version assertion */
 		struct {
+			/* Unused field */
 			__le64 unused;
+			/* Expected version */
 			__le64 ver;
 		} __attribute__ ((packed)) assert_ver;
+		/* Object cloning operations */
 		struct {
+			/* Destination offset and length */
 			__le64 offset, length;
+			/* Source offset */
 			__le64 src_offset;
 		} __attribute__ ((packed)) clonerange;
+		/* Allocation hints for object sizing */
 		struct {
+			/* Expected final object size */
 			__le64 expected_object_size;
+			/* Expected write size */
 			__le64 expected_write_size;
+			/* Allocation hint flags */
 			__le32 flags;  /* CEPH_OSD_OP_ALLOC_HINT_FLAG_* */
 		} __attribute__ ((packed)) alloc_hint;
+		/* Copy from another object */
 		struct {
+			/* Source snapshot ID */
 			__le64 snapid;
+			/* Source object version */
 			__le64 src_version;
+			/* Copy operation flags */
 			__u8 flags; /* CEPH_OSD_COPY_FROM_FLAG_* */
 			/*
 			 * CEPH_OSD_OP_FLAG_FADVISE_*: fadvise flags
@@ -548,6 +610,7 @@ struct ceph_osd_op {
 			__le32 src_fadvise_flags;
 		} __attribute__ ((packed)) copy_from;
 	};
+	/* Length of accompanying data payload */
 	__le32 payload_len;
 } __attribute__ ((packed));
 
-- 
2.51.0



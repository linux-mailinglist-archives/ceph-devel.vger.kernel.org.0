Return-Path: <ceph-devel+bounces-3537-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67B59B46428
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 22:03:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 213095E0D25
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 20:03:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 550532C3263;
	Fri,  5 Sep 2025 20:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="h94gPnyn"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDDF29C321
	for <ceph-devel@vger.kernel.org>; Fri,  5 Sep 2025 20:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757102523; cv=none; b=sKkKQTilGTUZFfYpWrVDhNpkEiNcRUrT/CNhUwhNWnPuHgZs9ra18NXLvs6V9S7I/8wlg59T+qBOMQEShGIYiwDxHQ4Upq7XKlFvfvBx57fNppdh2yj9Nucg6I4mT9BcNIvt96t1eHCYtzRto9PnTvrwI0GZunXXRJ9sGbT3KBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757102523; c=relaxed/simple;
	bh=/dn/Tuk5kcGGkCpaBhVSSD0/pN7u2RjuGUnkHEb46v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOnUc0NCgrv3qVUEle9upaBA3IfRgLF7XJCKz9L69k5ubxp0FOfqajPH9ztJ7ZukTNf++vak8HSx9a2SybcOCO5udAGc8yopMz6JfU5upeeBMYUHcQoTuGUsKEzsUZkMz4+u6f0BPA5E0WU4JB/WKsXQW2bGBw0prM9vU+Hv2KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=h94gPnyn; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-6071dbcf3fcso37201d50.0
        for <ceph-devel@vger.kernel.org>; Fri, 05 Sep 2025 13:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1757102520; x=1757707320; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yp1sT7Zh9S4RLRqp90SEVAPvKSW6mVlWCK6rmkV3qVY=;
        b=h94gPnyn71J1La1powzayv540f/tbdOl9O+AO9fSFkFR1vBgKMIANfe8aT6GuYuvyW
         p8f5eizmi1uNW4xXETw4TYxj/00i38duwBHjsBSeDZM6O/CAqCuqQW1MzHaQB9gwrXTO
         KpAmmsKjvDttc6eOSECsskWjBc4dQOG2MFG8liMxtYwhAls77AzmxTMUWsgRaWJbHFZG
         ziL9mau0CFVQoWbOy3d0wLvy+BIP5/HxBVqWppzKoIZ4skByHeeDZJeNHttaeBuy2hat
         bgpZiWDXvUgllJghiOJ/cndFybycwjsYlh9ZfBY93uZnhPQW+y+F338x+be/Ib4zn/ec
         j6Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757102520; x=1757707320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yp1sT7Zh9S4RLRqp90SEVAPvKSW6mVlWCK6rmkV3qVY=;
        b=ZuvLrnf0+R/8t9G86j4VkpB5505VCc7J8yuPBd75E83XrDLUOeejGU3BEPHPYTosoJ
         vnstSzzZckO2KMQ7arL/nktZU1XcVnVaMpkokWROC/0qmiWnWb4BTXM/zTm2Fp9aIrfJ
         LMfhj7HGHWRboLk/MIQbU/YZuzp4KqaUgXUmTC1yQ6oDyyyduFle3IAlR+g075uhtbru
         J8r0l7mIoBBX0wczuwk60Erju7aV1B+CWToMDU9+nFeJCq5ZCJkMGucQFg/NzfYU1nsB
         ZCDJ2x8nOvFp7xxCT/IdE6WGmJW/K+aiMIWAew5BFstGBroeTC/D3KoYcWFvw4tLe7Wm
         Dufw==
X-Gm-Message-State: AOJu0Yw7D82BAQji7nx7soY+8fQGPiQZzECo2/8pauNGbf3vCmkwxNIl
	A7HP5GTJVMESwgKNj+1/SNwsANR3n1s8D6tm0iK/9VYWDgpwCaQ2q6GkQBhRIk5b+CqCdcB/6L7
	FgO4fsUk=
X-Gm-Gg: ASbGncvZlPhHd34bpXzlwNibvO0/XJw1y1iPp9v2iO78aNqG3QuO0HnBGDjVAf9Tjzo
	zeik1nYXu6M1At7pm0qzXNtdTkWns/fwJhVETfmBXqnUyLdtVQCFKvlcbmFg+A1u36bvWJP9ykd
	uzduuIOsc6fwyEgtVJpBkTkkjSlxNpkN3/i46QeXmld1gJP5rUub0i9DLdotsNBqFFWqWrXE3os
	gq/f7+XZUrgeCkVi5sHrqtcx6arXjD3HI5sUSXZCn08sksCsrcWbBW5mG9HW+gyKiEi3xFMdsID
	BOm8YZs2gbSOz0rqjkdlzgOSYTFO7N6SzmDhPpBRFyrgK06BqU7z4CLn2hh3XDBQ5UzL5fw8Nlg
	N0hMKq4ST1rGpcwb93VNQgKzWkcuBnMY4xsB/VNjf
X-Google-Smtp-Source: AGHT+IEGC51m8Wi+RuAgP+jhr8wuNvs245PwOZD73y5E7J7D31ss06oENrFKZt3HGARwftb+beyx+Q==
X-Received: by 2002:a05:690e:d4f:b0:5f3:315d:8fed with SMTP id 956f58d0204a3-6102268511bmr220675d50.8.1757102519945;
        Fri, 05 Sep 2025 13:01:59 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:2479:21e9:a32d:d3ee])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a834c9adsm32360857b3.28.2025.09.05.13.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 13:01:59 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	vdubeyko@redhat.com
Subject: [RFC PATCH 09/20] ceph: add comments to metadata structures in libceph.h
Date: Fri,  5 Sep 2025 13:00:57 -0700
Message-ID: <20250905200108.151563-10-slava@dubeyko.com>
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

This patch adds comments for struct ceph_options,
struct ceph_client, struct ceph_snap_context
in /include/linux/ceph/libceph.h.

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Ceph Development <ceph-devel@vger.kernel.org>
---
 include/linux/ceph/libceph.h | 50 ++++++++++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 5 deletions(-)

diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 733e7f93db66..f7edef4fcc54 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -44,15 +44,29 @@
 #define ceph_test_opt(client, opt) \
 	(!!((client)->options->flags & CEPH_OPT_##opt))
 
+/*
+ * Ceph client options metadata: Configuration parameters for connecting to
+ * and operating with a Ceph cluster. Contains network settings, timeouts,
+ * authentication details, and cluster topology information.
+ */
 struct ceph_options {
+	/* Feature and behavior flags (CEPH_OPT_*) */
 	int flags;
+	/* Cluster filesystem identifier */
 	struct ceph_fsid fsid;
+	/* Client's network address */
 	struct ceph_entity_addr my_addr;
+	/* Timeout for initial cluster connection */
 	unsigned long mount_timeout;		/* jiffies */
+	/* How long to keep idle OSD connections */
 	unsigned long osd_idle_ttl;		/* jiffies */
+	/* OSD keepalive message interval */
 	unsigned long osd_keepalive_timeout;	/* jiffies */
+	/* Timeout for OSD requests (0 = no timeout) */
 	unsigned long osd_request_timeout;	/* jiffies */
+	/* Read from replica policy flags */
 	u32 read_from_replica;  /* CEPH_OSD_FLAG_BALANCE/LOCALIZE_READS */
+	/* Connection modes for msgr1/msgr2 protocols */
 	int con_modes[2];  /* CEPH_CON_MODE_* */
 
 	/*
@@ -61,11 +75,16 @@ struct ceph_options {
 	 * ceph_compare_options() should be updated accordingly
 	 */
 
+	/* Array of monitor addresses */
 	struct ceph_entity_addr *mon_addr; /* should be the first
 					      pointer type of args */
+	/* Number of monitors configured */
 	int num_mon;
+	/* Client authentication name */
 	char *name;
+	/* Authentication key */
 	struct ceph_crypto_key *key;
+	/* CRUSH map location constraints */
 	struct rb_root crush_locs;
 };
 
@@ -109,31 +128,46 @@ struct ceph_mds_client;
 /*
  * per client state
  *
- * possibly shared by multiple mount points, if they are
- * mounting the same ceph filesystem/cluster.
+ * Ceph client state metadata: Central state for a connection to a Ceph cluster.
+ * Manages authentication, messaging, and communication with monitors and OSDs.
+ * Can be shared by multiple mount points accessing the same cluster.
  */
 struct ceph_client {
+	/* Cluster filesystem identifier */
 	struct ceph_fsid fsid;
+	/* Whether we have received the cluster FSID */
 	bool have_fsid;
 
+	/* Private data for specific client types (RBD, CephFS, etc.) */
 	void *private;
 
+	/* Client configuration options */
 	struct ceph_options *options;
 
-	struct mutex mount_mutex;      /* serialize mount attempts */
+	/* Serializes mount and authentication attempts */
+	struct mutex mount_mutex;
+	/* Wait queue for authentication completion */
 	wait_queue_head_t auth_wq;
+	/* Latest authentication error code */
 	int auth_err;
 
+	/* Optional callback for extra monitor message handling */
 	int (*extra_mon_dispatch)(struct ceph_client *, struct ceph_msg *);
 
+	/* Feature flags supported by this client */
 	u64 supported_features;
+	/* Feature flags required by this client */
 	u64 required_features;
 
+	/* Network messaging subsystem */
 	struct ceph_messenger msgr;   /* messenger instance */
+	/* Monitor client for cluster map updates */
 	struct ceph_mon_client monc;
+	/* OSD client for data operations */
 	struct ceph_osd_client osdc;
 
 #ifdef CONFIG_DEBUG_FS
+	/* Debug filesystem entries */
 	struct dentry *debugfs_dir;
 	struct dentry *debugfs_monmap;
 	struct dentry *debugfs_osdmap;
@@ -153,17 +187,23 @@ static inline bool ceph_msgr2(struct ceph_client *client)
  */
 
 /*
- * A "snap context" is the set of existing snapshots when we
- * write data.  It is used by the OSD to guide its COW behavior.
+ * Snapshot context metadata: Represents the set of existing snapshots at the
+ * time data was written. Used by OSDs to guide copy-on-write (COW) behavior
+ * and ensure snapshot consistency. Reference-counted and attached to dirty
+ * pages to track the snapshot state when data was dirtied.
  *
  * The ceph_snap_context is refcounted, and attached to each dirty
  * page, indicating which context the dirty data belonged when it was
  * dirtied.
  */
 struct ceph_snap_context {
+	/* Reference count for safe sharing */
 	refcount_t nref;
+	/* Snapshot sequence number */
 	u64 seq;
+	/* Number of snapshots in the array */
 	u32 num_snaps;
+	/* Array of snapshot IDs (variable length) */
 	u64 snaps[];
 };
 
-- 
2.51.0



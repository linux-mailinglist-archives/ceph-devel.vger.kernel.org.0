Return-Path: <ceph-devel+bounces-3539-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF409B4642B
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 22:03:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68F8D176665
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 20:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C70D2882CC;
	Fri,  5 Sep 2025 20:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="rji4BffS"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABDE287501
	for <ceph-devel@vger.kernel.org>; Fri,  5 Sep 2025 20:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757102526; cv=none; b=nPYIYn+B7/jpGLqwo37Oxzc4k5Fi2ZM9u4FHBE4kqVB5KN33WPGv3ezHEHU4eogTPGIiz/t7YU8UIVYzPEZeAQvIvEfLo88swdqYpLyu3EGny4nRoPcC3NFKLjiXSRrPWbCi72rBxTqnlr5E4AKU1UzX61SocHdrX7nEYqL2Yxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757102526; c=relaxed/simple;
	bh=fCg26YxaUCRbmlNzgzmy8PSZvp4QyOxr8z+Mh//UC/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8yVPtHg0kuVCR8KarxwvE9EMj3XCMdHcpAXQSTPzX+pOLRzOu5I/JGGJHuBNsByTFMuuBmnumsRsI3EDhpk93HvL/KfL6kaW75nZW7bZwe2llQVhFlHrXTB9Cm1ef5+/VXklEY2VZnvkm06S57OlONnhwmvTEt+ieCKhZVsaDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=rji4BffS; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-60f4678ceabso70500d50.3
        for <ceph-devel@vger.kernel.org>; Fri, 05 Sep 2025 13:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1757102523; x=1757707323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YmgdR2Wg0SxXvC0qq716B1XeY/kCXHmuWsIrKvYM6uA=;
        b=rji4BffSbSLqkKEqJAtlz1XZ7l7AGAyWU55BQnw3fXNq3rQ26XA9ZnAlgzICVKLavl
         AMOfs8yooHmVz1LCBPiIT7V9nRiZw8y9sAIvs8NVYKbCK4zYZ5vKPKmov+Hd5i4cSccn
         mIjSuPelTo5YkpfFM5MrvvoBU7BUWSKFJGDyK7SquU/5Z1QpUre4lQxV2R0hUqbeURpc
         LJgBCousX9iCfpjWBAofAuunbhJTvmfWXIfUCMeJjQXLVuP4zbxtvtXzZs2oFuvqXxsQ
         lkLe13cYwr2ANaCT9MPrnultgU6pUl8605dOa0+HmC0rSIsJyeYo4hZ375jogwaFO4Ah
         lDlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757102523; x=1757707323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YmgdR2Wg0SxXvC0qq716B1XeY/kCXHmuWsIrKvYM6uA=;
        b=VercsUhKhys2wl21216Vu4ZjrJbgiWL56macpTOhgHDws7OFQqU1m9EsNFc99OhNSf
         4nxytgNEWYfN2GPIwbQwbWoMCuebIRforIjVzUivyNjWNTlSmXzi67IXQ2FlYKzABO4p
         /T27mYsUKWlUZ5EEGKHjR0PwV8CzLjpkTkNkjeBK/O4Osh+upWa34iSTObukYuqIsXdd
         Lq8r/0ls2jBb5oMGszKIFj+vDN/yxd0ZwQ0LRvfd+rl5uamhbHJuVcQ32nGkr24eKL/I
         zWkG1JXSWj6sUEhntk+TcXNHtbMpgbEdjiwNmJLHB3Hwc9GbZkQbzrFU33zIJI/piPo+
         OjzQ==
X-Gm-Message-State: AOJu0YzPF2QawDJEnaYcm3GHOOf1OvikEESHJLKiqTO0TOWVUuN5U8/p
	XkugXVF0nNktYz80f8YhCDv9tUdIOkt9o2R2Rz4XdIolwn5F92klPjjqcFzJGdsSj2q2nt8g7I0
	YB9NjaIE=
X-Gm-Gg: ASbGncvw/vP4ha5Wrip59XYQY39wCB1zSi3euCUpRo09va/+63hWfodCwX/Dvl3M3pP
	Afee3aYnKyYRBUqnrHxaSKQSPaB2apZxV4HHy3h3lWiRxrKG47OKM3+0IOIKSz6wrrPfNW5josu
	4OVWKhn+bS6EgHO+fM/iijCtwTWFERjqM+Iy/nYBu1shLlKI07vfud2APY5Edl2uTvw9UWEjDcE
	yLyX3E+DHMiSKyc+RtSngkad3CKqwVfNwMyElYdD+d+0BP+j8xW8a3ayLb9aErRjjT4dD2sq/yr
	ZmUUYPO33WkrRCVe+BH1Vz+RFEdJ692Lqx08MK7tyxD0KnpiHbLAIz0KUN5s3gYERlgCiIpo+kX
	LePzaGs1DhGozcgdHElDU50kI3+FK67Pd4kdoKbWX
X-Google-Smtp-Source: AGHT+IHEn5QJTd4GSgD+ky2kB+uCzoHFAKy7eJf1zqNm+u4fQPJiYuDEJ9DHGXRA2k3113KVd/mNIg==
X-Received: by 2002:a05:690e:2484:b0:5f8:7c2:61ab with SMTP id 956f58d0204a3-610235dc70dmr199666d50.9.1757102523132;
        Fri, 05 Sep 2025 13:02:03 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:2479:21e9:a32d:d3ee])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a834c9adsm32360857b3.28.2025.09.05.13.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 13:02:02 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	vdubeyko@redhat.com
Subject: [RFC PATCH 11/20] ceph: add comments to metadata structures in mon_client.h
Date: Fri,  5 Sep 2025 13:00:59 -0700
Message-ID: <20250905200108.151563-12-slava@dubeyko.com>
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

This patch adds comments for struct ceph_monmap,
struct ceph_mon_request, struct ceph_mon_generic_request,
struct ceph_mon_client in /include/linux/ceph/mon_client.h.

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Ceph Development <ceph-devel@vger.kernel.org>
---
 include/linux/ceph/mon_client.h | 93 +++++++++++++++++++++++++++------
 1 file changed, 78 insertions(+), 15 deletions(-)

diff --git a/include/linux/ceph/mon_client.h b/include/linux/ceph/mon_client.h
index 7a9a40163c0f..057bd1eed1d6 100644
--- a/include/linux/ceph/mon_client.h
+++ b/include/linux/ceph/mon_client.h
@@ -13,12 +13,17 @@ struct ceph_mount_args;
 struct ceph_auth_client;
 
 /*
- * The monitor map enumerates the set of all monitors.
+ * Monitor map metadata: Enumerates the set of all Ceph monitors in the cluster.
+ * Used to track available monitors and their network addresses for failover.
  */
 struct ceph_monmap {
+	/* Unique filesystem identifier for this Ceph cluster */
 	struct ceph_fsid fsid;
+	/* Monitor map version/epoch number */
 	u32 epoch;
+	/* Number of monitors in the cluster */
 	u32 num_mon;
+	/* Array of monitor instances (address + name) */
 	struct ceph_entity_inst mon_inst[] __counted_by(num_mon);
 };
 
@@ -27,79 +32,129 @@ struct ceph_mon_generic_request;
 
 
 /*
- * Generic mechanism for resending monitor requests.
+ * Monitor request callback metadata: Generic mechanism for resending monitor requests.
+ * Called when switching to a new monitor or retrying failed requests.
  */
 typedef void (*ceph_monc_request_func_t)(struct ceph_mon_client *monc,
 					 int newmon);
 
-/* a pending monitor request */
+/*
+ * Pending monitor request metadata: Represents a monitor request that may need
+ * to be retried or resent if the current monitor becomes unavailable.
+ */
 struct ceph_mon_request {
+	/* Monitor client this request belongs to */
 	struct ceph_mon_client *monc;
+	/* Delayed work for request retry/resend */
 	struct delayed_work delayed_work;
+	/* Current retry delay in jiffies */
 	unsigned long delay;
+	/* Callback to execute the request */
 	ceph_monc_request_func_t do_request;
 };
 
+/*
+ * Generic request completion callback metadata: Called when a generic monitor
+ * request completes, allowing the caller to process the response.
+ */
 typedef void (*ceph_monc_callback_t)(struct ceph_mon_generic_request *);
 
 /*
- * ceph_mon_generic_request is being used for the statfs and
- * mon_get_version requests which are being done a bit differently
- * because we need to get data back to the caller
+ * Generic monitor request metadata: Used for statfs and mon_get_version requests
+ * that need to return data to the caller. Provides synchronous and asynchronous
+ * request patterns with proper cleanup and response handling.
  */
 struct ceph_mon_generic_request {
+	/* Monitor client this request belongs to */
 	struct ceph_mon_client *monc;
+	/* Reference counting for safe cleanup */
 	struct kref kref;
+	/* Transaction ID for request tracking */
 	u64 tid;
+	/* Red-black tree node for efficient lookup */
 	struct rb_node node;
+	/* Request completion result code */
 	int result;
 
+	/* Synchronous completion notification */
 	struct completion completion;
+	/* Asynchronous completion callback */
 	ceph_monc_callback_t complete_cb;
-	u64 private_data;          /* r_tid/linger_id */
+	/* Caller-specific data (request ID/linger ID) */
+	u64 private_data;
 
-	struct ceph_msg *request;  /* original request */
-	struct ceph_msg *reply;    /* and reply */
+	/* Original request message sent to monitor */
+	struct ceph_msg *request;
+	/* Reply message received from monitor */
+	struct ceph_msg *reply;
 
+	/* Request-specific response data */
 	union {
+		/* For statfs requests: filesystem statistics */
 		struct ceph_statfs *st;
+		/* For version requests: newest available version */
 		u64 newest;
 	} u;
 };
 
+/*
+ * Monitor client state metadata: Manages communication with Ceph monitor cluster.
+ * Handles monitor discovery, failover, authentication, subscriptions, and request routing.
+ * Provides high availability by automatically switching between available monitors.
+ */
 struct ceph_mon_client {
+	/* Parent Ceph client instance */
 	struct ceph_client *client;
+	/* Current monitor map with available monitors */
 	struct ceph_monmap *monmap;
 
+	/* Serializes monitor client operations */
 	struct mutex mutex;
+	/* Delayed work for periodic operations and retries */
 	struct delayed_work delayed_work;
 
+	/* Authentication client for monitor authentication */
 	struct ceph_auth_client *auth;
+	/* Pre-allocated messages for auth and subscription protocols */
 	struct ceph_msg *m_auth, *m_auth_reply, *m_subscribe, *m_subscribe_ack;
+	/* Authentication request in progress flag */
 	int pending_auth;
 
+	/* Currently searching for available monitors */
 	bool hunting;
-	int cur_mon;                       /* last monitor i contacted */
+	/* Index of last monitor contacted */
+	int cur_mon;
+	/* Time when subscriptions should be renewed */
 	unsigned long sub_renew_after;
+	/* Time when subscription renewal was last sent */
 	unsigned long sub_renew_sent;
+	/* Network connection to current monitor */
 	struct ceph_connection con;
 
+	/* Ever successfully connected to any monitor */
 	bool had_a_connection;
-	int hunt_mult; /* [1..CEPH_MONC_HUNT_MAX_MULT] */
+	/* Hunt backoff multiplier [1..CEPH_MONC_HUNT_MAX_MULT] */
+	int hunt_mult;
 
-	/* pending generic requests */
+	/* Tree of pending generic requests awaiting responses */
 	struct rb_root generic_request_tree;
+	/* Last transaction ID assigned to generic requests */
 	u64 last_tid;
 
-	/* subs, indexed with CEPH_SUB_* */
+	/* Map subscriptions indexed by CEPH_SUB_* constants */
 	struct {
+		/* Subscription request details */
 		struct ceph_mon_subscribe_item item;
+		/* Want to receive updates for this map type */
 		bool want;
-		u32 have; /* epoch */
+		/* Current epoch/version we have */
+		u32 have;
 	} subs[4];
-	int fs_cluster_id; /* "mdsmap.<id>" sub */
+	/* Filesystem cluster ID for "mdsmap.<id>" subscription */
+	int fs_cluster_id;
 
 #ifdef CONFIG_DEBUG_FS
+	/* Debug filesystem entry for monitoring state */
 	struct dentry *debugfs_file;
 #endif
 };
@@ -111,10 +166,18 @@ extern int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl);
 extern void ceph_monc_stop(struct ceph_mon_client *monc);
 extern void ceph_monc_reopen_session(struct ceph_mon_client *monc);
 
+/*
+ * Map subscription type constants: Indices for different types of cluster maps
+ * that can be subscribed to for receiving updates from monitors.
+ */
 enum {
+	/* Monitor map - tracks available monitors */
 	CEPH_SUB_MONMAP = 0,
+	/* OSD map - tracks available storage daemons and placement groups */
 	CEPH_SUB_OSDMAP,
+	/* Filesystem map - tracks CephFS filesystems */
 	CEPH_SUB_FSMAP,
+	/* MDS map - tracks metadata server daemons */
 	CEPH_SUB_MDSMAP,
 };
 
-- 
2.51.0



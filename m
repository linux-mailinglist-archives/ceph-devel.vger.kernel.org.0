Return-Path: <ceph-devel+bounces-3732-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 285CCB9ECC2
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Sep 2025 12:48:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BEDD174D38
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Sep 2025 10:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E90B22EE611;
	Thu, 25 Sep 2025 10:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="PerBj9k2"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F7E2E8DFD
	for <ceph-devel@vger.kernel.org>; Thu, 25 Sep 2025 10:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758797132; cv=none; b=iIDz3bZ1dE9TUkgPHq0uUEPwHFV8Yxw/oCLtV0YalhrgvRGwzJ7DaSfWcP9gsUS+84QdHRrOlXa+OR0IZNrvD3F32Ii+qVOUpFEdQEmFxs3cWRYVApDDth9YYNE/wIDdxw2q//vfgWXy1ZPZR69tQRNMDfX+GGqGtT3CzZENPpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758797132; c=relaxed/simple;
	bh=2Y/Etx7wsAJuNVlBBeFuTxyOUrSl8OleFgQbVZG+ERY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=pu86auMfIxHbCl0bQTHd3Ky7RcPZx5kbyEryXU4dKUfrihcLJDRDXJ+hokx5cFf5h4UeN1ltKl44WRk+uSIoYKWBEOUEDFyaES+rKsQacOb0DAj4x7Dob850GP+eUQyex2k3+fhuryzqLhkvXKe0i5xU9DBomrH7FgDBFpL9YrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=PerBj9k2; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3f0ae439bc3so324013f8f.1
        for <ceph-devel@vger.kernel.org>; Thu, 25 Sep 2025 03:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758797127; x=1759401927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=rD5bRVS4j89IYhbkqtvwQE1tWcEcavfJ8B+snILPpnk=;
        b=PerBj9k2eLBk54O4yxN4q+etTdHjV8pImoynQo5XJutfbJFWirX5lKz0qRskLZHxvd
         Ufv2LDMc5QHmy6CONNM3t9WadmEZoU20bwZdUwL5MKXc7JzDlRBZKISU8zac1yZj+7wi
         zC1QfZlTcougW4R0KoueDUqLkNB/X3w5GuaqSxdaJ0NjJoeErKQcEnXERF9YKuV15yPD
         WN7kcD6mKIRRnBnOQyQVG1Ci4zToDzign5lgW7W9Zngkb8M+eYexBvVU6YF6bOyL3Ho2
         2Wvk4OIO8KDvxkmrFkRkgDdIM/8riJhf9jGoexYxEYx+CBBRDG7rWkUIK07rnu5I44xG
         D5Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758797127; x=1759401927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rD5bRVS4j89IYhbkqtvwQE1tWcEcavfJ8B+snILPpnk=;
        b=kWdDymtm+excXXgT4U0SAGQLiRq8y3tCbzn9cuf2QC7HrjC556ETEcQfMAoDjRmwfX
         MhIYHF0bxULTH/ED39Xw7hM0pgAhJ73gRQWtBkVJIS/gJ0HzN1WcglcuCW+F0rmzZGrG
         veknIAAdTUER+gjHBOavXJbZimfNnVJNwY4pBWiALrVdnclcHqETRZDKiiptJkClN2no
         olmtbf2VLAWaYDMwhKPCxnBws49ekylYBR7TfLoJzk1eKAjDo6Oej6hvbwF81HZNpd2b
         JrOpt8e4Fn/6RgEMvJUNW3ZG6YJU6TMI0i+800OvG/OlFSAjbs3TdiEFDw+zSWb7vW9V
         Dspw==
X-Forwarded-Encrypted: i=1; AJvYcCXSLk6gx/0pkjyCeTD/P5BwIBgOUuzC7O289EHVGwmoOfI2/SbN52VdGiy20HVaWu9dlCwh/8fiyMov@vger.kernel.org
X-Gm-Message-State: AOJu0YwmsL6m4CU6P4kckTqDmjbyAnI0qIBzS30CLxfe5w61D2dkXQGR
	/R57Kt2CaJzBPayaFZ7NXlW+IrWgJv0v/Gsk+dXSP+LHUW6UZlnc/yjOSU+ozKANxno=
X-Gm-Gg: ASbGnctygXl/Yf1f8YpY/nT0MCxDhd55osyJV3fsq8fjeVzDYPcjmtOLTSauAuQBcD1
	FH0VZ05bFp1Oe5M5hDooXCei6M+CE4ciRaK2WnAGQZpNdCyJ2CCiDRsdfn0zJ6Dr5i0VC16hrJg
	nF+qf1XCF3JfvOa6SgLefd5BqA5RWhV5aTUwRDsq+nxRFD+gDe0RFUuaVpY2mA25CCbqE2vuEyy
	MT9rOXpd6cquDscK9BQ2e5wv5snNBzC2aBBK/D3xIZBFbYYQxnzD0DLlIGUZNiwWTQhhLcPELKD
	5Yt9TBOglS/UZPSkaj5eooNE4GPvJV8VsWIQrGakPPm+yOnAnyVje+8Ro4/L5CpQDnAK34X1op4
	LO/haLPQZC9RKniTAKeAn1MqHmRUDCianXwILYfjKPk9qyhjPhdeYnjtThldIafWtx5FhjfUrXm
	FVIpTbSsJe3W8VpKsKqi5GGA==
X-Google-Smtp-Source: AGHT+IHT1KVxlBNxyFDCaHu545shG2L21DrIcoORWPTFR8KKA/HztsEYb06C5+5BWMpDJhnIrFGDBA==
X-Received: by 2002:a05:6000:2891:b0:3ea:80ec:8552 with SMTP id ffacd0b85a97d-40e4ce4bc13mr2854165f8f.57.1758797126522;
        Thu, 25 Sep 2025 03:45:26 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f090200023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f09:200:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e32b4f336sm16058985e9.0.2025.09.25.03.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 03:45:25 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	linux-kernel@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH] ceph: add trace points to the MDS client
Date: Thu, 25 Sep 2025 12:45:12 +0200
Message-ID: <20250925104522.3501812-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds trace points to the Ceph filesystem MDS client:

- request submission (CEPH_MSG_CLIENT_REQUEST) and completion
  (CEPH_MSG_CLIENT_REPLY)
- capabilities (CEPH_MSG_CLIENT_CAPS)

These are the central pieces that are useful for analyzing MDS
latency/performance problems from the client's perspective.

In the long run, all doutc() calls should be replaced with
tracepoints.  This way, the Ceph filesystem can be traced at any time
(without spamming the kernel log).  Additionally, trace points can be
used in BPF programs (which can even deference the pointer parameters
and extract more values).

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 fs/ceph/caps.c              |   4 +
 fs/ceph/mds_client.c        |  20 ++-
 fs/ceph/super.c             |   3 +
 include/trace/events/ceph.h | 234 ++++++++++++++++++++++++++++++++++++
 4 files changed, 259 insertions(+), 2 deletions(-)
 create mode 100644 include/trace/events/ceph.h

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index b1a8ff612c41..2f663972da99 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -18,6 +18,7 @@
 #include "crypto.h"
 #include <linux/ceph/decode.h>
 #include <linux/ceph/messenger.h>
+#include <trace/events/ceph.h>
 
 /*
  * Capability management
@@ -4452,6 +4453,9 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	      session->s_mds, ceph_cap_op_name(op), vino.ino, vino.snap, inode,
 	      seq, issue_seq, mseq);
 
+	trace_ceph_handle_caps(mdsc, session, op, &vino, ceph_inode(inode),
+			       seq, issue_seq, mseq);
+
 	mutex_lock(&session->s_mutex);
 
 	if (!inode) {
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 3bc72b47fe4d..90e4268b24f9 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -24,6 +24,7 @@
 #include <linux/ceph/pagelist.h>
 #include <linux/ceph/auth.h>
 #include <linux/ceph/debugfs.h>
+#include <trace/events/ceph.h>
 
 #define RECONNECT_MAX_SIZE (INT_MAX - PAGE_SIZE)
 
@@ -3282,6 +3283,8 @@ static void complete_request(struct ceph_mds_client *mdsc,
 {
 	req->r_end_latency = ktime_get();
 
+	trace_ceph_mdsc_complete_request(mdsc, req);
+
 	if (req->r_callback)
 		req->r_callback(mdsc, req);
 	complete_all(&req->r_completion);
@@ -3413,6 +3416,8 @@ static int __send_request(struct ceph_mds_session *session,
 {
 	int err;
 
+	trace_ceph_mdsc_send_request(session, req);
+
 	err = __prepare_send_request(session, req, drop_cap_releases);
 	if (!err) {
 		ceph_msg_get(req->r_request);
@@ -3464,6 +3469,8 @@ static void __do_request(struct ceph_mds_client *mdsc,
 		}
 		if (mdsc->mdsmap->m_epoch == 0) {
 			doutc(cl, "no mdsmap, waiting for map\n");
+			trace_ceph_mdsc_suspend_request(mdsc, session, req,
+							ceph_mdsc_suspend_reason_no_mdsmap);
 			list_add(&req->r_wait, &mdsc->waiting_for_map);
 			return;
 		}
@@ -3485,6 +3492,8 @@ static void __do_request(struct ceph_mds_client *mdsc,
 			goto finish;
 		}
 		doutc(cl, "no mds or not active, waiting for map\n");
+		trace_ceph_mdsc_suspend_request(mdsc, session, req,
+						ceph_mdsc_suspend_reason_no_active_mds);
 		list_add(&req->r_wait, &mdsc->waiting_for_map);
 		return;
 	}
@@ -3530,9 +3539,11 @@ static void __do_request(struct ceph_mds_client *mdsc,
 		 * it to the mdsc queue.
 		 */
 		if (session->s_state == CEPH_MDS_SESSION_REJECTED) {
-			if (ceph_test_mount_opt(mdsc->fsc, CLEANRECOVER))
+			if (ceph_test_mount_opt(mdsc->fsc, CLEANRECOVER)) {
+				trace_ceph_mdsc_suspend_request(mdsc, session, req,
+								ceph_mdsc_suspend_reason_rejected);
 				list_add(&req->r_wait, &mdsc->waiting_for_map);
-			else
+			} else
 				err = -EACCES;
 			goto out_session;
 		}
@@ -3546,6 +3557,8 @@ static void __do_request(struct ceph_mds_client *mdsc,
 			if (random)
 				req->r_resend_mds = mds;
 		}
+		trace_ceph_mdsc_suspend_request(mdsc, session, req,
+						ceph_mdsc_suspend_reason_session);
 		list_add(&req->r_wait, &session->s_waiting);
 		goto out_session;
 	}
@@ -3646,6 +3659,7 @@ static void __wake_requests(struct ceph_mds_client *mdsc,
 		list_del_init(&req->r_wait);
 		doutc(cl, " wake request %p tid %llu\n", req,
 		      req->r_tid);
+		trace_ceph_mdsc_resume_request(mdsc, req);
 		__do_request(mdsc, req);
 	}
 }
@@ -3672,6 +3686,7 @@ static void kick_requests(struct ceph_mds_client *mdsc, int mds)
 		    req->r_session->s_mds == mds) {
 			doutc(cl, " kicking tid %llu\n", req->r_tid);
 			list_del_init(&req->r_wait);
+			trace_ceph_mdsc_resume_request(mdsc, req);
 			__do_request(mdsc, req);
 		}
 	}
@@ -3718,6 +3733,7 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
 	doutc(cl, "submit_request on %p for inode %p\n", req, dir);
 	mutex_lock(&mdsc->mutex);
 	__register_request(mdsc, req, dir);
+	trace_ceph_mdsc_submit_request(mdsc, req);
 	__do_request(mdsc, req);
 	err = req->r_err;
 	mutex_unlock(&mdsc->mutex);
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index c3eb651862c5..f119d7260496 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -30,6 +30,9 @@
 
 #include <uapi/linux/magic.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/ceph.h>
+
 static DEFINE_SPINLOCK(ceph_fsc_lock);
 static LIST_HEAD(ceph_fsc_list);
 
diff --git a/include/trace/events/ceph.h b/include/trace/events/ceph.h
new file mode 100644
index 000000000000..08cb0659fbfc
--- /dev/null
+++ b/include/trace/events/ceph.h
@@ -0,0 +1,234 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* Ceph filesystem support module tracepoints
+ *
+ * Copyright (C) 2025 IONOS SE. All Rights Reserved.
+ * Written by Max Kellermann (max.kellermann@ionos.com)
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ceph
+
+#if !defined(_TRACE_CEPH_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_CEPH_H
+
+#include <linux/tracepoint.h>
+
+#define ceph_mdsc_suspend_reasons						\
+	EM(ceph_mdsc_suspend_reason_no_mdsmap,		"no-mdsmap")		\
+	EM(ceph_mdsc_suspend_reason_no_active_mds,	"no-active-mds")	\
+	EM(ceph_mdsc_suspend_reason_rejected,		"rejected")		\
+	E_(ceph_mdsc_suspend_reason_session,		"session")
+
+#ifndef __NETFS_DECLARE_TRACE_ENUMS_ONCE_ONLY
+#define __NETFS_DECLARE_TRACE_ENUMS_ONCE_ONLY
+
+#undef EM
+#undef E_
+#define EM(a, b) a,
+#define E_(a, b) a
+
+enum ceph_mdsc_suspend_reason { ceph_mdsc_suspend_reasons } __mode(byte);
+
+#endif
+
+/*
+ * Export enum symbols via userspace.
+ */
+#undef EM
+#undef E_
+#define EM(a, b) TRACE_DEFINE_ENUM(a);
+#define E_(a, b) TRACE_DEFINE_ENUM(a);
+
+ceph_mdsc_suspend_reasons;
+
+/*
+ * Now redefine the EM() and E_() macros to map the enums to the strings that
+ * will be printed in the output.
+ */
+#undef EM
+#undef E_
+#define EM(a, b)	{ a, b },
+#define E_(a, b)	{ a, b }
+
+TRACE_EVENT(ceph_mdsc_submit_request,
+	TP_PROTO(struct ceph_mds_client *mdsc,
+		 struct ceph_mds_request *req),
+
+	TP_ARGS(mdsc, req),
+
+	TP_STRUCT__entry(
+		__field(u64,	tid)
+		__field(int,	op)
+		__field(u64,	ino)
+		__field(u64,	snap)
+	),
+
+	TP_fast_assign(
+		struct inode *inode;
+
+		__entry->tid = req->r_tid;
+		__entry->op = req->r_op;
+
+		inode = req->r_inode;
+		if (inode == NULL && req->r_dentry)
+			inode = d_inode(req->r_dentry);
+
+		if (inode) {
+			__entry->ino = ceph_ino(inode);
+			__entry->snap = ceph_snap(inode);
+		} else {
+			__entry->ino = __entry->snap = 0;
+		}
+	),
+
+	TP_printk("R=%llu op=%s ino=%llx,%llx",
+		  __entry->tid,
+		  ceph_mds_op_name(__entry->op),
+		  __entry->ino, __entry->snap)
+);
+
+TRACE_EVENT(ceph_mdsc_suspend_request,
+	TP_PROTO(struct ceph_mds_client *mdsc,
+		     struct ceph_mds_session *session,
+		     struct ceph_mds_request *req,
+		     enum ceph_mdsc_suspend_reason reason),
+
+	TP_ARGS(mdsc, session, req, reason),
+
+	TP_STRUCT__entry(
+		__field(u64,				tid)
+		__field(int,				op)
+		__field(int,				mds)
+		__field(enum ceph_mdsc_suspend_reason,	reason)
+	),
+
+	TP_fast_assign(
+		__entry->tid = req->r_tid;
+		__entry->op = req->r_op;
+		__entry->mds = session ? session->s_mds : -1;
+		__entry->reason = reason;
+	),
+
+	TP_printk("R=%llu op=%s reason=%s",
+		  __entry->tid,
+		  ceph_mds_op_name(__entry->op),
+		  __print_symbolic(__entry->reason, ceph_mdsc_suspend_reasons))
+);
+
+TRACE_EVENT(ceph_mdsc_resume_request,
+	TP_PROTO(struct ceph_mds_client *mdsc,
+		 struct ceph_mds_request *req),
+
+	TP_ARGS(mdsc, req),
+
+	TP_STRUCT__entry(
+		__field(u64,				tid)
+		__field(int,				op)
+	),
+
+	TP_fast_assign(
+		__entry->tid = req->r_tid;
+		__entry->op = req->r_op;
+	),
+
+	TP_printk("R=%llu op=%s",
+		  __entry->tid,
+		  ceph_mds_op_name(__entry->op))
+);
+
+TRACE_EVENT(ceph_mdsc_send_request,
+	TP_PROTO(struct ceph_mds_session *session,
+		 struct ceph_mds_request *req),
+
+	TP_ARGS(session, req),
+
+	TP_STRUCT__entry(
+		__field(u64,		tid)
+		__field(int,		op)
+		__field(int,		mds)
+	),
+
+	TP_fast_assign(
+		__entry->tid = req->r_tid;
+		__entry->op = req->r_op;
+		__entry->mds = session->s_mds;
+	),
+
+	TP_printk("R=%llu op=%s mds=%d",
+		  __entry->tid,
+		  ceph_mds_op_name(__entry->op),
+		  __entry->mds)
+);
+
+TRACE_EVENT(ceph_mdsc_complete_request,
+	TP_PROTO(struct ceph_mds_client *mdsc,
+		     struct ceph_mds_request *req),
+
+	TP_ARGS(mdsc, req),
+
+	TP_STRUCT__entry(
+		__field(u64,			tid)
+		__field(int,			op)
+		__field(int,			err)
+		__field(unsigned long,		latency_ns)
+	),
+
+	TP_fast_assign(
+		__entry->tid = req->r_tid;
+		__entry->op = req->r_op;
+		__entry->err = req->r_err;
+		__entry->latency_ns = req->r_end_latency - req->r_start_latency;
+	),
+
+	TP_printk("R=%llu op=%s err=%d latency_ns=%lu",
+		  __entry->tid,
+		  ceph_mds_op_name(__entry->op),
+		  __entry->err,
+		  __entry->latency_ns)
+);
+
+TRACE_EVENT(ceph_handle_caps,
+	TP_PROTO(struct ceph_mds_client *mdsc,
+		 struct ceph_mds_session *session,
+		 int op,
+		 const struct ceph_vino *vino,
+		 struct ceph_inode_info *inode,
+		 u32 seq, u32 mseq, u32 issue_seq),
+
+	TP_ARGS(mdsc, session, op, vino, inode, seq, mseq, issue_seq),
+
+	TP_STRUCT__entry(
+		__field(int,	mds)
+		__field(int,	op)
+		__field(u64,	ino)
+		__field(u64,	snap)
+		__field(u32,	seq)
+		__field(u32,	mseq)
+		__field(u32,	issue_seq)
+	),
+
+	TP_fast_assign(
+		__entry->mds = session->s_mds;
+		__entry->op = op;
+		__entry->ino = vino->ino;
+		__entry->snap = vino->snap;
+		__entry->seq = seq;
+		__entry->mseq = mseq;
+		__entry->issue_seq = issue_seq;
+	),
+
+	TP_printk("mds=%d op=%s vino=%llx.%llx seq=%u iseq=%u mseq=%u",
+		  __entry->mds,
+		  ceph_cap_op_name(__entry->op),
+		  __entry->ino,
+		  __entry->snap,
+		  __entry->seq,
+		  __entry->issue_seq,
+		  __entry->mseq)
+);
+
+#undef EM
+#undef E_
+#endif /* _TRACE_CEPH_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
2.47.3



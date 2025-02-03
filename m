Return-Path: <ceph-devel+bounces-2628-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 48C76A2680F
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2025 00:50:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 205D61885BE4
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2025 23:50:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB225211A08;
	Mon,  3 Feb 2025 23:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="StqwqgSN"
X-Original-To: ceph-devel@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0134C20ADCF;
	Mon,  3 Feb 2025 23:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738626625; cv=none; b=m6NW5OvMIUNeMKywYW7QCd/CNrk5/8zMBLulpuSyHTiegjQrpANyyAqfhpE68tEXZjBsM/YK50TWvC2XhT8kBnarodrl9/VY6vwXKFUYS/yomGDfckoRPALzuixiqcuRWAQemA1hju4ccIi1PNd1k2ScsJGUtV4SdOp6UZ9EZ9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738626625; c=relaxed/simple;
	bh=ptKQwSeZ4N5bue1bB0zgDpOlUIKszvN84grZSQCcReQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pQ032g7apSrbeoRewfVrJT9KEiOcWqy1Y6aNP0VLDxdjPXeH45ZgnBVWQt9ramc21uFUoaN1UpICbtbjzJlb1FHrAuChr59OMSu33gqEAfVIZBFWMiNB/Dnt8Z7dcpCQINVHAiTLMRtG9tpNSsgp55aoVrxGld5EfGbd5aSe0hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=StqwqgSN; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from eahariha-devbox.internal.cloudapp.net (unknown [40.91.112.99])
	by linux.microsoft.com (Postfix) with ESMTPSA id 84A00205493E;
	Mon,  3 Feb 2025 15:50:23 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 84A00205493E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738626623;
	bh=jl/YrVgNHMJyuougsZ83XWkAHGEtBSCoppF53ehyxrQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=StqwqgSNG2KkJyJsRG/IWgyvZ5UocaH2m/+dfcXUagDXBgaYXw89QgEKxugfrep4v
	 dLKXw3DPl9XGMIJreixUiyn7yAWneAEebfFyONYlzSWFZngQlphknQdYWu13Rs37yX
	 3WP+/AGKzQjgplcS2c3XKuSfIiY+hG9bzK/eU1/c=
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Date: Mon, 03 Feb 2025 23:50:24 +0000
Subject: [PATCH v2 3/3] libceph: convert timeouts to secs_to_jiffies()
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250203-converge-secs-to-jiffies-part-two-v2-3-d7058a01fd0e@linux.microsoft.com>
References: <20250203-converge-secs-to-jiffies-part-two-v2-0-d7058a01fd0e@linux.microsoft.com>
In-Reply-To: <20250203-converge-secs-to-jiffies-part-two-v2-0-d7058a01fd0e@linux.microsoft.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Julia Lawall <Julia.Lawall@inria.fr>, Nicolas Palix <nicolas.palix@imag.fr>, 
 Ilya Dryomov <idryomov@gmail.com>, 
 Dongsheng Yang <dongsheng.yang@easystack.cn>, Jens Axboe <axboe@kernel.dk>, 
 Xiubo Li <xiubli@redhat.com>
Cc: cocci@inria.fr, linux-kernel@vger.kernel.org, 
 ceph-devel@vger.kernel.org, linux-block@vger.kernel.org, 
 Easwar Hariharan <eahariha@linux.microsoft.com>
X-Mailer: b4 0.14.2

Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
secs_to_jiffies().  As the value here is a multiple of 1000, use
secs_to_jiffies() instead of msecs_to_jiffies to avoid the multiplication.

This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
the following Coccinelle rules:

@depends on patch@ expression E; @@

-msecs_to_jiffies(E * 1000)
+secs_to_jiffies(E)

@depends on patch@ expression E; @@

-msecs_to_jiffies(E * MSEC_PER_SEC)
+secs_to_jiffies(E)

While here, remove the no-longer necessary checks for range since there's
no multiplication involved.

Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
---
 include/linux/ceph/libceph.h | 12 ++++++------
 net/ceph/ceph_common.c       | 18 ++++++------------
 net/ceph/osd_client.c        |  3 +--
 3 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 733e7f93db66a7a29a4a8eba97e9ebf2c49da1f9..5f57128ef0c7d018341c15cc59288aa47edec646 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -72,15 +72,15 @@ struct ceph_options {
 /*
  * defaults
  */
-#define CEPH_MOUNT_TIMEOUT_DEFAULT	msecs_to_jiffies(60 * 1000)
-#define CEPH_OSD_KEEPALIVE_DEFAULT	msecs_to_jiffies(5 * 1000)
-#define CEPH_OSD_IDLE_TTL_DEFAULT	msecs_to_jiffies(60 * 1000)
+#define CEPH_MOUNT_TIMEOUT_DEFAULT	secs_to_jiffies(60)
+#define CEPH_OSD_KEEPALIVE_DEFAULT	secs_to_jiffies(5)
+#define CEPH_OSD_IDLE_TTL_DEFAULT	secs_to_jiffies(60)
 #define CEPH_OSD_REQUEST_TIMEOUT_DEFAULT 0  /* no timeout */
 #define CEPH_READ_FROM_REPLICA_DEFAULT	0  /* read from primary */
 
-#define CEPH_MONC_HUNT_INTERVAL		msecs_to_jiffies(3 * 1000)
-#define CEPH_MONC_PING_INTERVAL		msecs_to_jiffies(10 * 1000)
-#define CEPH_MONC_PING_TIMEOUT		msecs_to_jiffies(30 * 1000)
+#define CEPH_MONC_HUNT_INTERVAL		secs_to_jiffies(3)
+#define CEPH_MONC_PING_INTERVAL		secs_to_jiffies(10)
+#define CEPH_MONC_PING_TIMEOUT		secs_to_jiffies(30)
 #define CEPH_MONC_HUNT_BACKOFF		2
 #define CEPH_MONC_HUNT_MAX_MULT		10
 
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 4c6441536d55b6323f4b9d93b5d4837cd4ec880c..c2a2c3bcc4e91a628c99bd1cef1211d54389efa2 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -527,29 +527,23 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
 
 	case Opt_osdkeepalivetimeout:
 		/* 0 isn't well defined right now, reject it */
-		if (result.uint_32 < 1 || result.uint_32 > INT_MAX / 1000)
+		if (result.uint_32 < 1)
 			goto out_of_range;
-		opt->osd_keepalive_timeout =
-		    msecs_to_jiffies(result.uint_32 * 1000);
+		opt->osd_keepalive_timeout = secs_to_jiffies(result.uint_32);
 		break;
 	case Opt_osd_idle_ttl:
 		/* 0 isn't well defined right now, reject it */
-		if (result.uint_32 < 1 || result.uint_32 > INT_MAX / 1000)
+		if (result.uint_32 < 1)
 			goto out_of_range;
-		opt->osd_idle_ttl = msecs_to_jiffies(result.uint_32 * 1000);
+		opt->osd_idle_ttl = secs_to_jiffies(result.uint_32);
 		break;
 	case Opt_mount_timeout:
 		/* 0 is "wait forever" (i.e. infinite timeout) */
-		if (result.uint_32 > INT_MAX / 1000)
-			goto out_of_range;
-		opt->mount_timeout = msecs_to_jiffies(result.uint_32 * 1000);
+		opt->mount_timeout = secs_to_jiffies(result.uint_32);
 		break;
 	case Opt_osd_request_timeout:
 		/* 0 is "wait forever" (i.e. infinite timeout) */
-		if (result.uint_32 > INT_MAX / 1000)
-			goto out_of_range;
-		opt->osd_request_timeout =
-		    msecs_to_jiffies(result.uint_32 * 1000);
+		opt->osd_request_timeout = secs_to_jiffies(result.uint_32);
 		break;
 
 	case Opt_share:
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index b24afec241382b60d775dd12a6561fa23a7eca45..ba61a48b4388c2eceb5b7a299906e7f90191dd5d 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -4989,8 +4989,7 @@ int ceph_osdc_notify(struct ceph_osd_client *osdc,
 	linger_submit(lreq);
 	ret = linger_reg_commit_wait(lreq);
 	if (!ret)
-		ret = linger_notify_finish_wait(lreq,
-				 msecs_to_jiffies(2 * timeout * MSEC_PER_SEC));
+		ret = linger_notify_finish_wait(lreq, secs_to_jiffies(2 * timeout));
 	else
 		dout("lreq %p failed to initiate notify %d\n", lreq, ret);
 

-- 
2.43.0



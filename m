Return-Path: <ceph-devel+bounces-2839-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D1C1A4A88B
	for <lists+ceph-devel@lfdr.de>; Sat,  1 Mar 2025 05:23:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFAD73BB71F
	for <lists+ceph-devel@lfdr.de>; Sat,  1 Mar 2025 04:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57EDC1B2194;
	Sat,  1 Mar 2025 04:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="HyEJE2kg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1B3E2C9A;
	Sat,  1 Mar 2025 04:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740802986; cv=none; b=BRezp4iGCPK5Fmnrh0JXaAxz1kFrDgCMM5Jbjp3udivLksRxTIR6942NFuv03hQxLSTqdzCYRPEC8xHUFGV8ahiOio2k3YxNct/P7cb4A2D7FsWUkWPfUIpOBSiy8Bx36onVkfFPEpzgN2GGMMS6hm3MoQ+F7Q7WEe21UBrUkmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740802986; c=relaxed/simple;
	bh=p8VM9Bl0ApB7gurlDfnc5ERgWv0qjUanc6mf2uHC3aI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eBUX98Wy+IsX51PDIik8KwPAuHqNtFts6zxdKIplpPrGU6ZeMHRrT0G/iBg8p044iE3ci0X+q/eVIYs3ZgKWW1yYil2Sq2+mAW6MPaEmMP8q3J54TfMaOt4P/7xWjuIo+ASyckACE8uTewfnI6QxbrEVyUnGhd22zC4UBCPz7ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=HyEJE2kg; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from eahariha-devbox.internal.cloudapp.net (unknown [40.91.112.99])
	by linux.microsoft.com (Postfix) with ESMTPSA id 54CED2038A28;
	Fri, 28 Feb 2025 20:23:04 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 54CED2038A28
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1740802984;
	bh=3jHYa/0Xarc29iomR76KgYiKvPwnE0MNnWeMmBfBZWk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HyEJE2kghS30G13zEV2j4oV/PdhuWKfaBvtF3ETmd9B3SdS38oITvwLfSMzQZ+tZy
	 dKeOxA1llHMf3jcgK7clLp2zTZXKXfuZzt3KGVl8OsarJrxu5dr38c8fXAtphcMvvx
	 HSkXif3K1ieDai/11Fct5h/so6j/gQNrXloYsnkY=
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Date: Sat, 01 Mar 2025 04:22:52 +0000
Subject: [PATCH v4 1/2] rbd: convert timeouts to secs_to_jiffies()
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250301-converge-secs-to-jiffies-part-two-v4-1-c9226df9e4ed@linux.microsoft.com>
References: <20250301-converge-secs-to-jiffies-part-two-v4-0-c9226df9e4ed@linux.microsoft.com>
In-Reply-To: <20250301-converge-secs-to-jiffies-part-two-v4-0-c9226df9e4ed@linux.microsoft.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>, 
 Daniel Vacek <neelx@suse.com>, Ilya Dryomov <idryomov@gmail.com>, 
 Dongsheng Yang <dongsheng.yang@easystack.cn>, Jens Axboe <axboe@kernel.dk>, 
 Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Easwar Hariharan <eahariha@linux.microsoft.com>
X-Mailer: b4 0.14.2

Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
secs_to_jiffies().  As the value here is a multiple of 1000, use
secs_to_jiffies() instead of msecs_to_jiffies() to avoid the multiplication

This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
the following Coccinelle rules:

@depends on patch@ expression E; @@

-msecs_to_jiffies(E * 1000)
+secs_to_jiffies(E)

@depends on patch@ expression E; @@

-msecs_to_jiffies(E * MSEC_PER_SEC)
+secs_to_jiffies(E)

Change the check for range to check against HZ.

Acked-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
---
 drivers/block/rbd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index faafd7ff43d6ef53110ab3663cc7ac322214cc8c..1c406b17f3cee741b7bdd9f742958b3f1d5b1bbe 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -108,7 +108,7 @@ static int atomic_dec_return_safe(atomic_t *v)
 #define RBD_OBJ_PREFIX_LEN_MAX	64
 
 #define RBD_NOTIFY_TIMEOUT	5	/* seconds */
-#define RBD_RETRY_DELAY		msecs_to_jiffies(1000)
+#define RBD_RETRY_DELAY		secs_to_jiffies(1)
 
 /* Feature bits */
 
@@ -4162,7 +4162,7 @@ static void rbd_acquire_lock(struct work_struct *work)
 		dout("%s rbd_dev %p requeuing lock_dwork\n", __func__,
 		     rbd_dev);
 		mod_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork,
-		    msecs_to_jiffies(2 * RBD_NOTIFY_TIMEOUT * MSEC_PER_SEC));
+		    secs_to_jiffies(2 * RBD_NOTIFY_TIMEOUT));
 	}
 }
 
@@ -6283,9 +6283,9 @@ static int rbd_parse_param(struct fs_parameter *param,
 		break;
 	case Opt_lock_timeout:
 		/* 0 is "wait forever" (i.e. infinite timeout) */
-		if (result.uint_32 > INT_MAX / 1000)
+		if (result.uint32 > INT_MAX / HZ)
 			goto out_of_range;
-		opt->lock_timeout = msecs_to_jiffies(result.uint_32 * 1000);
+		opt->lock_timeout = secs_to_jiffies(result.uint_32);
 		break;
 	case Opt_pool_ns:
 		kfree(pctx->spec->pool_ns);

-- 
2.43.0



Return-Path: <ceph-devel+bounces-2627-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44343A2680B
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2025 00:50:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D09131651F9
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2025 23:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EDBA2116EB;
	Mon,  3 Feb 2025 23:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ReXLE283"
X-Original-To: ceph-devel@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D065D209692;
	Mon,  3 Feb 2025 23:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738626625; cv=none; b=OTIPqy6IOlAglvMJ7oDiizV7XXUaRAmoW+QbxBQAFDG1nBN/AOQ1S4seW6x/wvNymENqBlkRZkKE1NqFbDG9zgnxTK5ZNbEwg6PrCH+EQg2my9tn8n+sAKtbjX6NuMsFUtO6TNd3vqZqBZ82uy+09veYknBTjBg1aUlnHl/OU9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738626625; c=relaxed/simple;
	bh=lcNBHMv7OMgX6nqVil6HxIOjmC/ftCct7tDml36hpRA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=J7QZVvW8st3e+u4oUba4a7frJoh4HA/B0Fz/QvtTrnSR/uU+sFnbvCvjXLJk47PWVHJmE+RMp+ibm2tZ1Qb4xi6dqfDJM5J4xLi1JWuGmEpQcM7QpS4ESUC7j8rYctVO9E0mWMhEngty/i2mMUlf1vntLWC2ANqtKm68iN3DP5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ReXLE283; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from eahariha-devbox.internal.cloudapp.net (unknown [40.91.112.99])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6B0C9205493D;
	Mon,  3 Feb 2025 15:50:23 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6B0C9205493D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738626623;
	bh=inEJFlb8r1npYTsCShTPXzeDexvNBQKU3TCcAYSm03w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ReXLE283sX5Tuc0xrvz7bAVvEIGcJWw0rsBAmKKW/ZsT5S61O5VtjQ66Z15h9nzhF
	 36WfZ+35qfNmyQRvN0ihBKzifDLm1J6exfsCS9sn+0/ui+NUyQWAcEYxIkhW55TQ/5
	 imD44gbuz+LkK2jsREe0wluFIj6KbR/2Q+blP1Ck=
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Date: Mon, 03 Feb 2025 23:50:23 +0000
Subject: [PATCH v2 2/3] rbd: convert timeouts to secs_to_jiffies()
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250203-converge-secs-to-jiffies-part-two-v2-2-d7058a01fd0e@linux.microsoft.com>
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

While here, remove the no-longer necessary check for range since there's
no multiplication involved.

Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
---
 drivers/block/rbd.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index faafd7ff43d6ef53110ab3663cc7ac322214cc8c..41207133e21e9203192adf3b92390818e8fa5a58 100644
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
 
@@ -6283,9 +6283,7 @@ static int rbd_parse_param(struct fs_parameter *param,
 		break;
 	case Opt_lock_timeout:
 		/* 0 is "wait forever" (i.e. infinite timeout) */
-		if (result.uint_32 > INT_MAX / 1000)
-			goto out_of_range;
-		opt->lock_timeout = msecs_to_jiffies(result.uint_32 * 1000);
+		opt->lock_timeout = secs_to_jiffies(result.uint_32);
 		break;
 	case Opt_pool_ns:
 		kfree(pctx->spec->pool_ns);

-- 
2.43.0



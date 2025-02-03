Return-Path: <ceph-devel+bounces-2626-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0B9BA26808
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2025 00:50:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47A7E1652C0
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2025 23:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B551211498;
	Mon,  3 Feb 2025 23:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="oEhdTh0Q"
X-Original-To: ceph-devel@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D06BE209F57;
	Mon,  3 Feb 2025 23:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738626625; cv=none; b=hy5AmEF2cw4hys/qtBbMxV1RfUSApuEqh+zpe9PCq1ISlC/9ZaEanSIk5PJUkB4/MBwKyfAnw9R2JrJ6gDzQjr6TgeMt4Y8heqXDLO5N7OCqdNQv9tZUJNuFw72nQTDcCOqZSlb20EKXpoO/Wf6XqdbY2Rx6OrH7OhJZ4t+vqDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738626625; c=relaxed/simple;
	bh=KhNEyo7WFu+pfBKWpwr7dBCkfYqG9oS0AfyoC6gzP2I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ivVt71X8r46Jpal5Fro4mFCD2JBJDR02MVi/cMmJeJHAS+E2+EF4YApR4nSHaNhrVsXVikVzA50j+ID4I0k7GcphWPqFyQwYlqjBj4NUlh0fmFDgTeL18qBDu40AfUkhSb5KYdEkDQn4aYMqRNb/SUsyY7hbZmNhhu9hyAhr9VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=oEhdTh0Q; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from eahariha-devbox.internal.cloudapp.net (unknown [40.91.112.99])
	by linux.microsoft.com (Postfix) with ESMTPSA id 50B64205493C;
	Mon,  3 Feb 2025 15:50:23 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 50B64205493C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738626623;
	bh=iYMbK5A793RDdkoEPga+PoRyWET+ntXiAELhCjFiDKo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=oEhdTh0QOjAvgDcCvjUZsTTf0lTUPwUPP4F7dTpmwoMR8Uf43qW2ThQjODVfBeW0b
	 0A6YDdlPjF9Czqd/5/jjq41qeq/60xuBa1N/Q6LH7mm4uy7SMYZgwshRZgXGrP3Sf2
	 WEnpJG8ujT5WK9I6pJnS/o5zRDHyBdC0zkVrN8s8=
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Date: Mon, 03 Feb 2025 23:50:22 +0000
Subject: [PATCH v2 1/3] coccinelle: misc: secs_to_jiffies: Patch
 expressions too
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250203-converge-secs-to-jiffies-part-two-v2-1-d7058a01fd0e@linux.microsoft.com>
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

Teach the script to suggest conversions for timeout patterns where the
arguments to msecs_to_jiffies() are expressions as well.

Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
---
 scripts/coccinelle/misc/secs_to_jiffies.cocci | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/scripts/coccinelle/misc/secs_to_jiffies.cocci b/scripts/coccinelle/misc/secs_to_jiffies.cocci
index 8bbb2884ea5db939c63fd4513cf5ca8c977aa8cb..416f348174ca659b544441f5f68f04a41d1ad4a3 100644
--- a/scripts/coccinelle/misc/secs_to_jiffies.cocci
+++ b/scripts/coccinelle/misc/secs_to_jiffies.cocci
@@ -20,3 +20,13 @@ virtual patch
 
 - msecs_to_jiffies(C * MSEC_PER_SEC)
 + secs_to_jiffies(C)
+
+@depends on patch@ expression E; @@
+
+- msecs_to_jiffies(E * 1000)
++ secs_to_jiffies(E)
+
+@depends on patch@ expression E; @@
+
+- msecs_to_jiffies(E * MSEC_PER_SEC)
++ secs_to_jiffies(E)

-- 
2.43.0



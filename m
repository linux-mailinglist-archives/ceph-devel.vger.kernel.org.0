Return-Path: <ceph-devel+bounces-2077-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A18029C8CCA
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2024 15:24:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66FE4281D6B
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2024 14:24:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09DEF2A1D1;
	Thu, 14 Nov 2024 14:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="H3gWrOrL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from forward101a.mail.yandex.net (forward101a.mail.yandex.net [178.154.239.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FEA2943F
	for <ceph-devel@vger.kernel.org>; Thu, 14 Nov 2024 14:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731594279; cv=none; b=ZXhvVwxXGPoGxb9oikAJ9I/ObP3GRB6j2xN2dsNW5XnRjvYv+SSnImpH2aUQmgwh4I6m7Dj7egtUUn3tT8/tbt/A56bvFNQR04ZvgCCXJAcnrN/p21tiCRDGC2pwRj73Vs4KqtJ8SVcc9nmC3X4glahtbVWja1OCq1B6SRrkuas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731594279; c=relaxed/simple;
	bh=xzMxe90Huz6utt9AZb0F8nnbLzpNCZVdw7AUybkeZwM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T62DdQBmPOvULvSMpc6g2ffVxzhlsGMP4dBaOLp8B69nITmuvA9jJSo5Bq8REPpxX03ja8nus9u1Pqpasi4ezWsRuMcU5hPGS6B5W3vvzpHjR+NWIvQPaP4tdfsZHYwdIgSqWgiRo/uZPSX/9qiIlItOPKuLBEejLIVVzpvcSAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=H3gWrOrL; arc=none smtp.client-ip=178.154.239.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Received: from mail-nwsmtp-smtp-production-main-73.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-73.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:c110:0:640:2b5b:0])
	by forward101a.mail.yandex.net (Yandex) with ESMTPS id 7040760A96;
	Thu, 14 Nov 2024 17:24:26 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-73.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id PONBhZQOqOs0-RP5gQHaZ;
	Thu, 14 Nov 2024 17:24:25 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1731594265; bh=SMsV7QxlmpUjdzvJWoPIcb/3xzQMpy6/p+njmuho8BI=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=H3gWrOrLTSLK2TVgg5A91u4UHdmLv6t0Gb94xMjSgGAK9KFE9SkS5w5R0/MINrM4q
	 s5q+rY2j+WuInlmX5CQGXpZ4k7XTdIlpNFQHwQPArdMHi7uWhq1Lu6MhaSyiJXn8pk
	 eQlgov5VI6UB3bbk1s65Ac4wqYm0gA3q4rRNK/+A=
Authentication-Results: mail-nwsmtp-smtp-production-main-73.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] ceph: fix overflow detection in build_snap_context()
Date: Thu, 14 Nov 2024 17:23:28 +0300
Message-ID: <20241114142328.505379-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since total number of snap contexts is 'u32', it can't exceed
'(SIZE_MAX - sizeof(...)) / sizeof(u64))'. And if we really
care about detecting possible overflows, it's better to use
explicit 'check_add_overflow()' instead. Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ceph/snap.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index c65f2b202b2b..3fa5baa73665 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -341,7 +341,11 @@ static int build_snap_context(struct ceph_mds_client *mdsc,
 	struct ceph_snap_realm *parent = realm->parent;
 	struct ceph_snap_context *snapc;
 	int err = 0;
-	u32 num = realm->num_prior_parent_snaps + realm->num_snaps;
+	u32 num, cnt;
+
+	if (check_add_overflow(realm->num_prior_parent_snaps,
+			       realm->num_snaps, &cnt))
+		return -EOVERFLOW;
 
 	/*
 	 * build parent context, if it hasn't been built.
@@ -354,8 +358,11 @@ static int build_snap_context(struct ceph_mds_client *mdsc,
 			list_add(&parent->rebuild_item, realm_queue);
 			return 1;
 		}
-		num += parent->cached_context->num_snaps;
-	}
+		if (check_add_overflow(parent->cached_context->num_snaps,
+				       cnt, &num))
+			return -EOVERFLOW;
+	} else
+		num = cnt;
 
 	/* do i actually need to update?  not if my context seq
 	   matches realm seq, and my parents' does to.  (this works
@@ -374,8 +381,6 @@ static int build_snap_context(struct ceph_mds_client *mdsc,
 
 	/* alloc new snap context */
 	err = -ENOMEM;
-	if (num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
-		goto fail;
 	snapc = ceph_create_snap_context(num, GFP_NOFS);
 	if (!snapc)
 		goto fail;
-- 
2.47.0



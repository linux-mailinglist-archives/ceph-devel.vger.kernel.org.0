Return-Path: <ceph-devel+bounces-1552-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4D493ACA3
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2024 08:29:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E64E1F23651
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2024 06:29:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E934F58ABF;
	Wed, 24 Jul 2024 06:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hhMVXQYF"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E979153368
	for <ceph-devel@vger.kernel.org>; Wed, 24 Jul 2024 06:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721802580; cv=none; b=u3tmh5aDHltEoAtEzkb+5TN/gwNJxjOq/4D248kxU+dsE5kKxR/Si5SZLuFStULyFgo1NfMoHZoMindIM2gjtGplya+sJyC9NuuSjL2Rd3ThT5ddwMSm3XRr0FiFhW4GxLDxeZJuknGzsT/IBapTbNP07JkmGog9ZIbMtTq1hm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721802580; c=relaxed/simple;
	bh=wp+ZqFjrziMqIpPgyJIjCuVtTdGjwa1bbrHpxrzfX/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KB0P7/jATnt0A8r3QLn2fuXSODVaF94D5xhg3zMMnpwn0TFO/L79L1EcvEXVtrcK5fNwcnXEtNuSekoL6bLOnJWRDPVxs4LOXUkGa2VOOLadcHoHrYzYTqs3JRW6iC/cgmIDXGp20eoihnfmp9GIbbLXMhgbD2nCzyJ2Ka3L+7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hhMVXQYF; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2ef2d582e31so33112041fa.2
        for <ceph-devel@vger.kernel.org>; Tue, 23 Jul 2024 23:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721802577; x=1722407377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=euhuSlCtu3gNSc7TeGUs2Z08XPAtseZVybmA4bpYMjs=;
        b=hhMVXQYFf5UtLb2tJ31rTrSfVHyy7zrqzfj2zLGVIZ0HHKYj4tplVxtADXj+d8w2Vt
         +2T+zhlMeqL0peO/GzX+aWlohDd9iMero6EKV+USJJIBlQ34v14D3+OilFD1DSUvuAhX
         pjTm/P48roEoS+Deyh4ZyRPvR2qE2EY0cnWaaZ+HN7Iwk76vXqkconCcG3QSls2n9OOR
         o37jpe3HUVywsp4AYH99u2SklY0e25b8gqC5f0PWTwcVVRTQzEMqw3DQlXWGpxFm2aF8
         r4LaL2jRrlz4mMhufESCFHwYzwIT0Ov/m/isJJXsJrMFFHLMJLrsptsN0xi/r/Qgbkw/
         Sfhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721802577; x=1722407377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=euhuSlCtu3gNSc7TeGUs2Z08XPAtseZVybmA4bpYMjs=;
        b=r9kHArOPGMJtqfSKe6tV4cv5Rg2pZQXq9oRL7AM251LPvEM9cihs0wX+JJwHtXE8/j
         Jlxkd+/yttbvC0tPVtMUq0dY+9fwZvQfuz06U8VouE/fQuDH+zsfequu3U6buU7kJAJS
         XyvssKOK1TJrsKDh0T8ZAfCYUX5sgsayyDGNaKJDqKH5pQhI/oD5rKA3b5tRFayOFt1J
         JuUvKBIetJCVF9qx39/sByKrVqV4VExS/TZoJLvJ4c1DkK9iA2cFywL7bTxK78wj5LX6
         tfOwgIdtmYeVlZH2HKP07sAPtEi4MGakbneKlEEntXMSjVT76wGBpN42IrGiJsUcsbTS
         xXCg==
X-Gm-Message-State: AOJu0Yyq58fJV5oSeQI//pGbw04OF0I4R1UbB8JZTW+plfoL/sAHgjzv
	4bk7foBK5CU7MmHE+mPXDPVbxitPWgxfIviPEywVJwvMGT9Wx9QiuN24Xg==
X-Google-Smtp-Source: AGHT+IEkKrTEqRn0uTmlpkxJ9BSd3AoOcrbCEPhYGFN0KrCkWmiP3kbbuiOd1cH/KF4rRgORgTXmuw==
X-Received: by 2002:a2e:2206:0:b0:2ef:32b9:85f6 with SMTP id 38308e7fff4ca-2f02b71e810mr13149341fa.11.1721802576721;
        Tue, 23 Jul 2024 23:29:36 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427f9359516sm14160325e9.2.2024.07.23.23.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 23:29:36 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: ceph-devel@vger.kernel.org
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 2/3] rbd: don't assume RBD_LOCK_STATE_LOCKED for exclusive mappings
Date: Wed, 24 Jul 2024 08:29:10 +0200
Message-ID: <20240724062914.667734-3-idryomov@gmail.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240724062914.667734-1-idryomov@gmail.com>
References: <20240724062914.667734-1-idryomov@gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Every time a watch is reestablished after getting lost, we need to
update the cookie which involves quiescing exclusive lock.  For this,
we transition from RBD_LOCK_STATE_LOCKED to RBD_LOCK_STATE_QUIESCING
roughly for the duration of rbd_reacquire_lock() call.  If the mapping
is exclusive and I/O happens to arrive in this time window, it's failed
with EROFS (later translated to EIO) based on the wrong assumption in
rbd_img_exclusive_lock() -- "lock got released?" check there stopped
making sense with commit a2b1da09793d ("rbd: lock should be quiesced on
reacquire").

To make it worse, any such I/O is added to the acquiring list before
EROFS is returned and this sets up for violating rbd_lock_del_request()
precondition that the request is either on the running list or not on
any list at all -- see commit ded080c86b3f ("rbd: don't move requests
to the running list on errors").  rbd_lock_del_request() ends up
processing these requests as if they were on the running list which
screws up quiescing_wait completion counter and ultimately leads to

    rbd_assert(!completion_done(&rbd_dev->quiescing_wait));

being triggered on the next watch error.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 77a9f19a0035..dc4ddae4f7eb 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3457,6 +3457,7 @@ static void rbd_lock_del_request(struct rbd_img_request *img_req)
 	lockdep_assert_held(&rbd_dev->lock_rwsem);
 	spin_lock(&rbd_dev->lock_lists_lock);
 	if (!list_empty(&img_req->lock_item)) {
+		rbd_assert(!list_empty(&rbd_dev->running_list));
 		list_del_init(&img_req->lock_item);
 		need_wakeup = (rbd_dev->lock_state == RBD_LOCK_STATE_QUIESCING &&
 			       list_empty(&rbd_dev->running_list));
@@ -3476,11 +3477,6 @@ static int rbd_img_exclusive_lock(struct rbd_img_request *img_req)
 	if (rbd_lock_add_request(img_req))
 		return 1;
 
-	if (rbd_dev->opts->exclusive) {
-		WARN_ON(1); /* lock got released? */
-		return -EROFS;
-	}
-
 	/*
 	 * Note the use of mod_delayed_work() in rbd_acquire_lock()
 	 * and cancel_delayed_work() in wake_lock_waiters().
@@ -4601,6 +4597,10 @@ static void rbd_reacquire_lock(struct rbd_device *rbd_dev)
 			rbd_warn(rbd_dev, "failed to update lock cookie: %d",
 				 ret);
 
+		if (rbd_dev->opts->exclusive)
+			rbd_warn(rbd_dev,
+			     "temporarily releasing lock on exclusive mapping");
+
 		/*
 		 * Lock cookie cannot be updated on older OSDs, so do
 		 * a manual release and queue an acquire.
-- 
2.45.1



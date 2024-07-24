Return-Path: <ceph-devel+bounces-1551-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EB82993ACA2
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2024 08:29:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A277F1F23692
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2024 06:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1C3C54660;
	Wed, 24 Jul 2024 06:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cp0dmJWg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7E3482FF
	for <ceph-devel@vger.kernel.org>; Wed, 24 Jul 2024 06:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721802579; cv=none; b=UMDqUqZiqq2bYYRbCWtmEr/m1iW0Cvb7NCNmTnpnGEH4wGMIsLRk2IcQzv8PfmyiLKxkSQd5owsLqKicbIZsKn2oTC+WvvcwpqoQbABE33A34BnHIS2ICMNDXbFigwbB985wPch6GmqnRsQG3EUagzV1QTFDTQhbnAmhKzF3E+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721802579; c=relaxed/simple;
	bh=ciP+1a8w2PyUHFjhBB6XCT20WH0C/BTtRfPS3euy248=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAbPBeUmQprqSirqueFytjsBWYnFmoWx85YxsbPUcOE2lIYaWhH84mWO2GUE4kcvL+Dp24gtIYcgaxTnABPvZoTbtfU1juvD+5J8v21idh8rMgZo7MoLBuhz6jEt+PiQ3PvZ3GJg88Qvv07pPeVVtU/uuyXQkTF/RguQYbjAyYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cp0dmJWg; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-427b4c621b9so42714025e9.1
        for <ceph-devel@vger.kernel.org>; Tue, 23 Jul 2024 23:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721802576; x=1722407376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RF2v8EzbqsV+xr4JQfgeYUQFiH7nOch+iX5ufPPKKrg=;
        b=cp0dmJWgMeXS1LUMdA5ODPt6kPBk/6/DzPIIzvCSLYMpa6NUFKeNezLjvC2pI8LfcV
         9gsYrjsmofhfsgVTb+TG8gakhCsd3cWveyuF2/BY3pOd3l7NEhBWmeLYMLPvlEVBtFiO
         49og9oySZzKtjcAmqtYzF67+scRiPVlLYgiaTbkL0Ix4JPIGgbw7h9dsrB7N+/A6as2V
         pwjzX/FwZCnR3f8pxaPvQaFKmBNFQnTVzugWajoC4yQlOgSZLXR9XXxGM5WG6P6CQBeq
         IuNfi2IE/XeEnbe3r/cTELuQVm8mYp7MdWNWyIZeSwAh7sWnYGX0VIIuMgqgb6yXupJx
         rcVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721802576; x=1722407376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RF2v8EzbqsV+xr4JQfgeYUQFiH7nOch+iX5ufPPKKrg=;
        b=tYXA5VYyMad9Dsat0j8D4sOieAM9hA26i2pJuoYX7IBkoPPj1p9MzQaagfraF/i6GE
         7kPh6lGY2+jrkcRwXtsQ18u0hvXyhBHAzReGeEdGEuiWJJmiUkT5VdFmSOQzBpOFAkWp
         bEHWnZXt7kphM33PdGsyM3CHE0jpdNPJHjdpkr63ER3PYTxZB3eKrOzPgRkCz67EKZqH
         0Ev4py5l+BM+x/67NVcacsfdnisV7fNSJ7AM+aEZ9cKCFbkG/27GxGZneupiyD8fY3qM
         YxEtpmMtSOpOtlTt5jAJzNYr85oR3oEBCu4dHfMx2+xx6opKZFS69L3xRP6oMl2Ox7rB
         6cjg==
X-Gm-Message-State: AOJu0Yz2dTZsmkB5ictNVR1Vj/4JGmCV3ZKuySCsnj9qhHtFpau8H3iF
	MDYVCacA/RUxCHXZ5bKNYU+SnoFW3OVQ6Zc6xaJEBlkkzm07f0kkJbL5KQ==
X-Google-Smtp-Source: AGHT+IFAYBFVriE+5Zm8fWR+H+3p0WR/dqImSMy9BXNuVNnv+CpEnMF/cM1RL1zs8BDw3TVHsE5aIQ==
X-Received: by 2002:a05:600c:4fc2:b0:426:6617:ae4a with SMTP id 5b1f17b1804b1-427f955db6bmr7347255e9.22.1721802575774;
        Tue, 23 Jul 2024 23:29:35 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427f9359516sm14160325e9.2.2024.07.23.23.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 23:29:35 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: ceph-devel@vger.kernel.org
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 1/3] rbd: rename RBD_LOCK_STATE_RELEASING and releasing_wait
Date: Wed, 24 Jul 2024 08:29:09 +0200
Message-ID: <20240724062914.667734-2-idryomov@gmail.com>
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

... to RBD_LOCK_STATE_QUIESCING to quiescing_wait to recognize that
this state and the associated completion are backing rbd_quiesce_lock(),
which isn't specific to releasing the lock.

While exclusive lock does get quiesced before it's released, it also
gets quiesced before an attempt to update the cookie is made and there
the lock is not released as long as ceph_cls_set_cookie() succeeds.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 9c6cff54831f..77a9f19a0035 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -362,7 +362,7 @@ enum rbd_watch_state {
 enum rbd_lock_state {
 	RBD_LOCK_STATE_UNLOCKED,
 	RBD_LOCK_STATE_LOCKED,
-	RBD_LOCK_STATE_RELEASING,
+	RBD_LOCK_STATE_QUIESCING,
 };
 
 /* WatchNotify::ClientId */
@@ -422,7 +422,7 @@ struct rbd_device {
 	struct list_head	running_list;
 	struct completion	acquire_wait;
 	int			acquire_err;
-	struct completion	releasing_wait;
+	struct completion	quiescing_wait;
 
 	spinlock_t		object_map_lock;
 	u8			*object_map;
@@ -525,7 +525,7 @@ static bool __rbd_is_lock_owner(struct rbd_device *rbd_dev)
 	lockdep_assert_held(&rbd_dev->lock_rwsem);
 
 	return rbd_dev->lock_state == RBD_LOCK_STATE_LOCKED ||
-	       rbd_dev->lock_state == RBD_LOCK_STATE_RELEASING;
+	       rbd_dev->lock_state == RBD_LOCK_STATE_QUIESCING;
 }
 
 static bool rbd_is_lock_owner(struct rbd_device *rbd_dev)
@@ -3458,12 +3458,12 @@ static void rbd_lock_del_request(struct rbd_img_request *img_req)
 	spin_lock(&rbd_dev->lock_lists_lock);
 	if (!list_empty(&img_req->lock_item)) {
 		list_del_init(&img_req->lock_item);
-		need_wakeup = (rbd_dev->lock_state == RBD_LOCK_STATE_RELEASING &&
+		need_wakeup = (rbd_dev->lock_state == RBD_LOCK_STATE_QUIESCING &&
 			       list_empty(&rbd_dev->running_list));
 	}
 	spin_unlock(&rbd_dev->lock_lists_lock);
 	if (need_wakeup)
-		complete(&rbd_dev->releasing_wait);
+		complete(&rbd_dev->quiescing_wait);
 }
 
 static int rbd_img_exclusive_lock(struct rbd_img_request *img_req)
@@ -4181,16 +4181,16 @@ static bool rbd_quiesce_lock(struct rbd_device *rbd_dev)
 	/*
 	 * Ensure that all in-flight IO is flushed.
 	 */
-	rbd_dev->lock_state = RBD_LOCK_STATE_RELEASING;
-	rbd_assert(!completion_done(&rbd_dev->releasing_wait));
+	rbd_dev->lock_state = RBD_LOCK_STATE_QUIESCING;
+	rbd_assert(!completion_done(&rbd_dev->quiescing_wait));
 	if (list_empty(&rbd_dev->running_list))
 		return true;
 
 	up_write(&rbd_dev->lock_rwsem);
-	wait_for_completion(&rbd_dev->releasing_wait);
+	wait_for_completion(&rbd_dev->quiescing_wait);
 
 	down_write(&rbd_dev->lock_rwsem);
-	if (rbd_dev->lock_state != RBD_LOCK_STATE_RELEASING)
+	if (rbd_dev->lock_state != RBD_LOCK_STATE_QUIESCING)
 		return false;
 
 	rbd_assert(list_empty(&rbd_dev->running_list));
@@ -5383,7 +5383,7 @@ static struct rbd_device *__rbd_dev_create(struct rbd_spec *spec)
 	INIT_LIST_HEAD(&rbd_dev->acquiring_list);
 	INIT_LIST_HEAD(&rbd_dev->running_list);
 	init_completion(&rbd_dev->acquire_wait);
-	init_completion(&rbd_dev->releasing_wait);
+	init_completion(&rbd_dev->quiescing_wait);
 
 	spin_lock_init(&rbd_dev->object_map_lock);
 
-- 
2.45.1



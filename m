Return-Path: <ceph-devel+bounces-578-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 12AB2830CC7
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Jan 2024 19:36:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 180C51C240B1
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Jan 2024 18:36:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5414A23748;
	Wed, 17 Jan 2024 18:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D61VkhBE"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A0322EE3
	for <ceph-devel@vger.kernel.org>; Wed, 17 Jan 2024 18:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705516557; cv=none; b=bJ+g5w/qyS2LAE2s3Gv7lWyetM0llS1hBnwUOv8lW0u98/Er79q/WLK5vSue+Ak6iVf5+G4f6YQnf0W7Q0qk4GOgCx5l4LPMa+MF+RsmLCSa+w2YCOdBWSLXqF58JwRobSRfaNsRmbA682TH/KJLxxXFcy91iySlYBHheMVgy5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705516557; c=relaxed/simple;
	bh=XpcEHOHDpVzirMy7vmU/e4VINHR/ERWWts8iVI61uEI=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding; b=BaFr5D6E0BYtG4ME6lD03oaySYMnK1BwN+Mef2BigPEY1eSAp13C7orS5/vNsCl2jDVM8IoEMXN03o14WQ0UA/SopilC4fiQ2CwCo7/kvM0GjsNz21MT4Nml/RXAIEVx47pBCeM+uu7+NVAR4MzYmff3vP2JFCbZUGZIqgatPkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D61VkhBE; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2cdeb80fdfdso15147401fa.2
        for <ceph-devel@vger.kernel.org>; Wed, 17 Jan 2024 10:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705516553; x=1706121353; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lRQTZkWs2JwLr85JqWlBdeU38aIAuIU7fTz++iF4hGQ=;
        b=D61VkhBED9tYOIKfAXwgqKypbT6e5o7S6EUx608go83qcLUOZWcnPozYLCQBrjetDc
         piVE6nXL2660RUUjMQX7yp/Jbe84cdCXxTE+Oh3gACdWfk+jlV6k1OAa7YdIJCFDNoRg
         0z6BHQHrifFxcYAKUBhJWgrUpKhjIpGa9duKiaS5gurxqfzssPqZEa5iJwvQlY3G8NiP
         nQV/eQs5P24+NmpbSPx9H9Skg1wJxj5Kcygamtc7Ki0MmocAkq1lYupHs0fCz1aeP7oH
         FrsymeKtARI1jCIrvMJwbjLhuEJTuXikT0weIPaaF1gKDw3Ook4vT/Aow0J3pNMCc9Xy
         fFhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705516553; x=1706121353;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lRQTZkWs2JwLr85JqWlBdeU38aIAuIU7fTz++iF4hGQ=;
        b=wvkrSuDmw3WGyS1vmCFLcFu0a6QehyMKmWZil2iOzs75iPNHPu8HUuWwSt4Jx9k0Rs
         +KJvYWL8mbZiuM2pUnpVeJgaLTvwJ5jIBGxmDaEtBYR5r+evlJ1xt1wL4QJqi4UEv7YK
         OB5sd8JFJVbYxA8eaWXP6HIOZOoO2aur6IwGrwvxPt7QhcPebB9WC9MHdoWLe/i4xQD8
         efQxWA2Yt/X8x4TwtqqXDFebWWiNeeqKq+Fkk6QAOBDLaV9pQ6ZL/iUuee8s84NmOO+2
         JgvUqo5vLQb0IkOp0Yk8QCNdch9AwJYAqztYz+DCaFeXPi44M47WBDJs+spgcoSD8XIE
         aC7Q==
X-Gm-Message-State: AOJu0Yw9ROgQvD4hm/F+8zddKOzWyS+DPpqyS/PjrAzZffFeb/ljbTbr
	xUJmc20OQq2BXUxxwPZXJyWPhPcOY1Y=
X-Google-Smtp-Source: AGHT+IFEK5JtsY8TUmvOzU7zBxne7IFlOUbv3Opa3t8f1mDUqkiMX3MgAtezxr0zYFPR4ue0YVAiaw==
X-Received: by 2002:a2e:4e11:0:b0:2cc:f286:beea with SMTP id c17-20020a2e4e11000000b002ccf286beeamr2301119ljb.100.1705516553184;
        Wed, 17 Jan 2024 10:35:53 -0800 (PST)
Received: from zambezi.redhat.com (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id o9-20020aa7c509000000b0055504002a5fsm8426622edq.72.2024.01.17.10.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jan 2024 10:35:52 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: ceph-devel@vger.kernel.org
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH] rbd: don't move requests to the running list on errors
Date: Wed, 17 Jan 2024 19:35:30 +0100
Message-ID: <20240117183542.1431147-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The running list is supposed to contain requests that are pinning the
exclusive lock, i.e. those that must be flushed before exclusive lock
is released.  When wake_lock_waiters() is called to handle an error,
requests on the acquiring list are failed with that error and no
flushing takes place.  Briefly moving them to the running list is not
only pointless but also harmful: if exclusive lock gets acquired
before all of their state machines are scheduled and go through
rbd_lock_del_request(), we trigger

    rbd_assert(list_empty(&rbd_dev->running_list));

in rbd_try_acquire_lock().

Cc: stable@vger.kernel.org
Fixes: 637cd060537d ("rbd: new exclusive lock wait/wake code")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 63897d0d6629..12b5d53ec856 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3452,14 +3452,15 @@ static bool rbd_lock_add_request(struct rbd_img_request *img_req)
 static void rbd_lock_del_request(struct rbd_img_request *img_req)
 {
 	struct rbd_device *rbd_dev = img_req->rbd_dev;
-	bool need_wakeup;
+	bool need_wakeup = false;
 
 	lockdep_assert_held(&rbd_dev->lock_rwsem);
 	spin_lock(&rbd_dev->lock_lists_lock);
-	rbd_assert(!list_empty(&img_req->lock_item));
-	list_del_init(&img_req->lock_item);
-	need_wakeup = (rbd_dev->lock_state == RBD_LOCK_STATE_RELEASING &&
-		       list_empty(&rbd_dev->running_list));
+	if (!list_empty(&img_req->lock_item)) {
+		list_del_init(&img_req->lock_item);
+		need_wakeup = (rbd_dev->lock_state == RBD_LOCK_STATE_RELEASING &&
+			       list_empty(&rbd_dev->running_list));
+	}
 	spin_unlock(&rbd_dev->lock_lists_lock);
 	if (need_wakeup)
 		complete(&rbd_dev->releasing_wait);
@@ -3842,14 +3843,19 @@ static void wake_lock_waiters(struct rbd_device *rbd_dev, int result)
 		return;
 	}
 
-	list_for_each_entry(img_req, &rbd_dev->acquiring_list, lock_item) {
+	while (!list_empty(&rbd_dev->acquiring_list)) {
+		img_req = list_first_entry(&rbd_dev->acquiring_list,
+					   struct rbd_img_request, lock_item);
 		mutex_lock(&img_req->state_mutex);
 		rbd_assert(img_req->state == RBD_IMG_EXCLUSIVE_LOCK);
+		if (!result)
+			list_move_tail(&img_req->lock_item,
+				       &rbd_dev->running_list);
+		else
+			list_del_init(&img_req->lock_item);
 		rbd_img_schedule(img_req, result);
 		mutex_unlock(&img_req->state_mutex);
 	}
-
-	list_splice_tail_init(&rbd_dev->acquiring_list, &rbd_dev->running_list);
 }
 
 static bool locker_equal(const struct ceph_locker *lhs,
-- 
2.41.0



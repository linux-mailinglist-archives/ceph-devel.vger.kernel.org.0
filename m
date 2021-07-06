Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633E93BDC05
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jul 2021 19:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhGFRQH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jul 2021 13:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbhGFRQF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jul 2021 13:16:05 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CC1C061574
        for <ceph-devel@vger.kernel.org>; Tue,  6 Jul 2021 10:13:25 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id f17so2340297wrt.6
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jul 2021 10:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1opqv17eMmDBqaN6I6hUXyUsAfMZexDjNNQ/ZlZyiQ0=;
        b=i+K7iOPwKhkNTCLFKEor93sbIZMAHqg89utWni/JNhn6P/xrwMVtXKna4tb+iDabwo
         Z05AR0tPQXX4J5qoYdfgxB/XRnTHczmp6jQeyziFlLJtKVPRv2wFARPIizRVFVCd7Hqw
         Uo5fnqFI05ALe+E5kxnb/IraW+nelM5nYthwkEcbyNBmcguxUeoUnbsIp87dOQrN/DXk
         aT7wvcIFTxfPPtOQUUegI7UXJZ2UPEHsWz1+1Go4yeB8P/IC+hF+xDvx/LQQtEgav4SM
         jlZpD1LPkEEUTQsoMKRiOOzDiLJ1iJCFgphQhT1L2wR3NY8iHwu3WRaOgZS0Zz1Kbici
         kpAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1opqv17eMmDBqaN6I6hUXyUsAfMZexDjNNQ/ZlZyiQ0=;
        b=N25aRoTqU5/PwIVwBNpmYs1VfTIzJmnTUW0+yDWYt8W9Pfgz4O9Qi65qi/zjnXNvZq
         v4pWOPLURhgC8crQrayEVMz9ncYORRRDqA8ppxhQYG4VmdDoNk3frcpqssy6CFW8VZz5
         yRPSOHEUbePm0J+MJr8S4DZ4NTSbsTF6JlFnVEnbTjMJO9OengFbojYpgW2UvMdHvmNC
         ggBukksbWB+immiQ2d5At00pfTLna0S1WFadkwbK9BQIafYHgAuCoMSmbv6/UQZLsfwC
         k7MwEEEegKltxhifHut6zM0rGCygtFdNPp/VFZ74RDim1/WLbsfny4A3N/CjJBl+NLvm
         Y4Yw==
X-Gm-Message-State: AOAM5304yNexSMUZOlrA/3znAc3GIY/5ejF2RLOYaCRQyJRE9PCbdikU
        5QxxwX/DtBe6pHijxfZHN6/UtfdmMtQpWg==
X-Google-Smtp-Source: ABdhPJytUInFFMS0cHCTz1OjMQVeAyyDMSBWzPS2+iV3xJPCNzUZZjPvCLT5YkmRfQwgS0VYMHq2tA==
X-Received: by 2002:adf:b60b:: with SMTP id f11mr3634334wre.203.1625591603824;
        Tue, 06 Jul 2021 10:13:23 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id y23sm9206733wmi.28.2021.07.06.10.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 10:13:23 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Robin Geuze <robin.geuze@nl.team.blue>
Subject: [PATCH] rbd: don't hold lock_rwsem while running_list is being drained
Date:   Tue,  6 Jul 2021 19:12:52 +0200
Message-Id: <20210706171252.1029-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently rbd_quiesce_lock() holds lock_rwsem for read while blocking
on releasing_wait completion.  On the I/O completion side, each image
request also needs to take lock_rwsem for read.  Because rw_semaphore
implementation doesn't allow new readers after a writer has indicated
interest in the lock, this can result in a deadlock if something that
needs to take lock_rwsem for write gets involved.  For example:

1. watch error occurs
2. rbd_watch_errcb() takes lock_rwsem for write, clears owner_cid and
   releases lock_rwsem
3. after reestablishing the watch, rbd_reregister_watch() takes
   lock_rwsem for write and calls rbd_reacquire_lock()
4. rbd_quiesce_lock() downgrades lock_rwsem to for read and blocks on
   releasing_wait until running_list becomes empty
5. another watch error occurs
6. rbd_watch_errcb() blocks trying to take lock_rwsem for write
7. no in-flight image request can complete and delete itself from
   running_list because lock_rwsem won't be granted anymore

A similar scenario can occur with "lock has been acquired" and "lock
has been released" notification handers which also take lock_rwsem for
write to update owner_cid.

We don't actually get anything useful from sitting on lock_rwsem in
rbd_quiesce_lock() -- owner_cid updates certainly don't need to be
synchronized with.  In fact the whole owner_cid tracking logic could
probably be removed from the kernel client because we don't support
proxied maintenance operations.

Cc: stable@vger.kernel.org # 5.3+
URL: https://tracker.ceph.com/issues/42757
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index a3caecae5d6a..8a6b7997fb1e 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4100,8 +4100,6 @@ static void rbd_acquire_lock(struct work_struct *work)
 
 static bool rbd_quiesce_lock(struct rbd_device *rbd_dev)
 {
-	bool need_wait;
-
 	dout("%s rbd_dev %p\n", __func__, rbd_dev);
 	lockdep_assert_held_write(&rbd_dev->lock_rwsem);
 
@@ -4113,11 +4111,11 @@ static bool rbd_quiesce_lock(struct rbd_device *rbd_dev)
 	 */
 	rbd_dev->lock_state = RBD_LOCK_STATE_RELEASING;
 	rbd_assert(!completion_done(&rbd_dev->releasing_wait));
-	need_wait = !list_empty(&rbd_dev->running_list);
-	downgrade_write(&rbd_dev->lock_rwsem);
-	if (need_wait)
-		wait_for_completion(&rbd_dev->releasing_wait);
-	up_read(&rbd_dev->lock_rwsem);
+	if (list_empty(&rbd_dev->running_list))
+		return true;
+
+	up_write(&rbd_dev->lock_rwsem);
+	wait_for_completion(&rbd_dev->releasing_wait);
 
 	down_write(&rbd_dev->lock_rwsem);
 	if (rbd_dev->lock_state != RBD_LOCK_STATE_RELEASING)
-- 
2.19.2


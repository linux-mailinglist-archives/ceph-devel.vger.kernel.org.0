Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41FC55523C
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731670AbfFYOlX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 10:41:23 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33649 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731158AbfFYOlW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:41:22 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so18249612wru.0
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 07:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S+nEyGpQieU0VCspLendCohnzONAtO8Jad1SFzDtK8c=;
        b=lBGorCarKe0DjUtPS2Avr+Glf7G6n9Isbmb+inhAUqSneTHf0MhBNNNyQhnq+knu+X
         a1zCj6ONl1JHrgoActaDhnJVGVWMY/KjZYbaC1jq0T98Z6Hwt7rUntKg8/3wQoJSfgcP
         N3+2ReZGrLNMmIc81jyGQMHRLQWRLlS5UGhYRqQLcZgR08k/5f3/iZOwQ6AV0PTIebS3
         emyYiOQ+O36CVWty6oWa2ZuHX+DEMQdrOE+/M8bRWe13GNPWyZCtWBC331gGWHJVW/hn
         +53nLt7SiYzVhnk6IMZ3x5d2TWsTb87KGPvjHxIRGvNRX2UQXVhJUqzU3+559Ak04lh5
         BxuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S+nEyGpQieU0VCspLendCohnzONAtO8Jad1SFzDtK8c=;
        b=oMoFJpUYHY9yV0Mb1yPN1c21oDEkyefWijLWjjGp/PbV6qI0UkrvS36Cood0osPbhR
         doEL+WX7VZuiCyiiCwHWbpkPoeNM23NHrIJchCXoJ1rnAbLPZL8KZWyJVEBOu05OniTH
         60YhW2ih2M83ihSyL2RtspQRI6ST6D2WzJXA2rZXMoHGOOpkc+mkOQr5bIHZ69cR/NcY
         zrskaX1YTYxQuAwEORR767kaPP8YwSrwmR5w8KNiOi799SEMWMl063d5n9kj5xkKga8d
         KVEkAPpK/R1ipB8erd6zZVlFa6dHys3tIVHip9Tc+BcjJ4W6qf+hrOJ/LLbhgl0Yd2Ut
         XHQQ==
X-Gm-Message-State: APjAAAUxnnFq0Yy1h4Aipawy4bj+/EGWky1Vzo6siNC2JWBNSi2PydQQ
        05TQVz6HYPL1AmzP7EAnI3hx/gYbmLM=
X-Google-Smtp-Source: APXvYqykqSZLbvBTriZfl9HwgUNkyj2ch0czjUdPN6BtTnxg228+U/hQilBkw3mooeqCulhqnlKHlg==
X-Received: by 2002:adf:e84a:: with SMTP id d10mr36224272wrn.316.1561473679843;
        Tue, 25 Jun 2019 07:41:19 -0700 (PDT)
Received: from kwango.redhat.com (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id f2sm20282378wrq.48.2019.06.25.07.41.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:41:19 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 12/20] rbd: lock should be quiesced on reacquire
Date:   Tue, 25 Jun 2019 16:41:03 +0200
Message-Id: <20190625144111.11270-13-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190625144111.11270-1-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Quiesce exclusive lock at the top of rbd_reacquire_lock() instead
of only when ceph_cls_set_cookie() fails.  This avoids a deadlock on
rbd_dev->lock_rwsem.

If rbd_dev->lock_rwsem is needed for I/O completion, set_cookie can
hang ceph-msgr worker thread if set_cookie reply ends up behind an I/O
reply, because, like lock and unlock requests, set_cookie is sent and
waited upon with rbd_dev->lock_rwsem held for write.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 34bd45d336e6..5fcb4ebd981a 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3004,6 +3004,7 @@ static void __rbd_lock(struct rbd_device *rbd_dev, const char *cookie)
 {
 	struct rbd_client_id cid = rbd_get_cid(rbd_dev);
 
+	rbd_dev->lock_state = RBD_LOCK_STATE_LOCKED;
 	strcpy(rbd_dev->lock_cookie, cookie);
 	rbd_set_owner_cid(rbd_dev, &cid);
 	queue_work(rbd_dev->task_wq, &rbd_dev->acquired_lock_work);
@@ -3028,7 +3029,6 @@ static int rbd_lock(struct rbd_device *rbd_dev)
 	if (ret)
 		return ret;
 
-	rbd_dev->lock_state = RBD_LOCK_STATE_LOCKED;
 	__rbd_lock(rbd_dev, cookie);
 	return 0;
 }
@@ -3411,13 +3411,11 @@ static void rbd_acquire_lock(struct work_struct *work)
 	}
 }
 
-/*
- * lock_rwsem must be held for write
- */
-static bool rbd_release_lock(struct rbd_device *rbd_dev)
+static bool rbd_quiesce_lock(struct rbd_device *rbd_dev)
 {
-	dout("%s rbd_dev %p read lock_state %d\n", __func__, rbd_dev,
-	     rbd_dev->lock_state);
+	dout("%s rbd_dev %p\n", __func__, rbd_dev);
+	lockdep_assert_held_exclusive(&rbd_dev->lock_rwsem);
+
 	if (rbd_dev->lock_state != RBD_LOCK_STATE_LOCKED)
 		return false;
 
@@ -3433,12 +3431,22 @@ static bool rbd_release_lock(struct rbd_device *rbd_dev)
 	up_read(&rbd_dev->lock_rwsem);
 
 	down_write(&rbd_dev->lock_rwsem);
-	dout("%s rbd_dev %p write lock_state %d\n", __func__, rbd_dev,
-	     rbd_dev->lock_state);
 	if (rbd_dev->lock_state != RBD_LOCK_STATE_RELEASING)
 		return false;
 
+	return true;
+}
+
+/*
+ * lock_rwsem must be held for write
+ */
+static void rbd_release_lock(struct rbd_device *rbd_dev)
+{
+	if (!rbd_quiesce_lock(rbd_dev))
+		return;
+
 	rbd_unlock(rbd_dev);
+
 	/*
 	 * Give others a chance to grab the lock - we would re-acquire
 	 * almost immediately if we got new IO during ceph_osdc_sync()
@@ -3447,7 +3455,6 @@ static bool rbd_release_lock(struct rbd_device *rbd_dev)
 	 * after wake_requests() in rbd_handle_released_lock().
 	 */
 	cancel_delayed_work(&rbd_dev->lock_dwork);
-	return true;
 }
 
 static void rbd_release_lock_work(struct work_struct *work)
@@ -3795,7 +3802,8 @@ static void rbd_reacquire_lock(struct rbd_device *rbd_dev)
 	char cookie[32];
 	int ret;
 
-	WARN_ON(rbd_dev->lock_state != RBD_LOCK_STATE_LOCKED);
+	if (!rbd_quiesce_lock(rbd_dev))
+		return;
 
 	format_lock_cookie(rbd_dev, cookie);
 	ret = ceph_cls_set_cookie(osdc, &rbd_dev->header_oid,
@@ -3811,9 +3819,8 @@ static void rbd_reacquire_lock(struct rbd_device *rbd_dev)
 		 * Lock cookie cannot be updated on older OSDs, so do
 		 * a manual release and queue an acquire.
 		 */
-		if (rbd_release_lock(rbd_dev))
-			queue_delayed_work(rbd_dev->task_wq,
-					   &rbd_dev->lock_dwork, 0);
+		rbd_unlock(rbd_dev);
+		queue_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork, 0);
 	} else {
 		__rbd_lock(rbd_dev, cookie);
 	}
-- 
2.19.2


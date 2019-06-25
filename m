Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7A35523F
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731727AbfFYOl0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 10:41:26 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36365 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730689AbfFYOl0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:41:26 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so16989996wrs.3
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 07:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fowyecVWneYfCbppVVllpmDlIkpxRkWryxIBUaGY+60=;
        b=UZwLJyruJ7ppodEjXl1ijI9TcPA/39S3NP26vzQAJgoqCBAf5gcrGBY2UJzDsDFXkx
         15JRZQXIW/IrdZUFC9iNCBHRNSLkoe2P29zf/k/68esJ4gw7k0VsiyUumx2bvA/l4cPY
         EJGD4V5Or7Y5cHXxbuGJVNrtTUKkui78HGrSaCNkyFsBafu3IT428/0ae+vpsNI+VMHo
         x2CoPFORn8TNSFwyq1mke6ANDX56eWxzbtI1HD/+Kz88EpfGTBtyQupW3nJkpjGiE9aR
         xWHx3sMqDaUdb8B4SIOv/tplQ/Sa5+p6ZRKb9EXLbNgEmOAt4U5d1zKoLso/mVpxiIbK
         2FCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fowyecVWneYfCbppVVllpmDlIkpxRkWryxIBUaGY+60=;
        b=ZGJFqADPs/NsEfdDmZnEeRIl9azloZq5NKc0Ey/cHgXwcWCbQGv2b6lzDVPeyNhkOS
         7fvjFcWcS4oM35a4PB4jacxm6errXlsI42ipgF7ZFjXWKnzlL/lq1e/l3Oeu3iDOmFJU
         aUXCXlCK6fwRvWTaoxC+J8SBvZ1pXj1K25o60wAW9G2IymacDdkvSnvgcP0GKV5IiDDi
         k8AGeC9TVDUX/bCQWQ+gDvsRXbfjlt2eOiCrwFNoLS3LB4BGpXhWxPrH6wmSfEUh0BYB
         Jl6f+mLFQbxz5A6rsGa27SVniNIVufByAJYsy7ZKT8qjkS4g0xQyggXd38Xp7cdDRdkt
         GgTA==
X-Gm-Message-State: APjAAAV7FpDsYDJETlJf8f1NC11+Uzh27Wz9wtX3UFwbdMR3C5OJNbU0
        Rjt2McbmAO+o+Oy3BAOHSRW0Avw29oE=
X-Google-Smtp-Source: APXvYqzTKQm7bByX+ZGtBRWTuNZkAGZ3tGCXMhiHnXkD2oX7Qmd+LfAWbVWUPB8pAZcWUTXyGmK10g==
X-Received: by 2002:a5d:5692:: with SMTP id f18mr57518495wrv.104.1561473681951;
        Tue, 25 Jun 2019 07:41:21 -0700 (PDT)
Received: from kwango.redhat.com (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id f2sm20282378wrq.48.2019.06.25.07.41.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:41:21 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 14/20] rbd: new exclusive lock wait/wake code
Date:   Tue, 25 Jun 2019 16:41:05 +0200
Message-Id: <20190625144111.11270-15-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190625144111.11270-1-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

rbd_wait_state_locked() is built around rbd_dev->lock_waitq and blocks
rbd worker threads while waiting for the lock, potentially impacting
other rbd devices.  There is no good way to pass an error code into
image request state machines when acquisition fails, hence the use of
RBD_DEV_FLAG_BLACKLISTED for everything and various other issues.

Introduce rbd_dev->acquiring_list and move acquisition into image
request state machine.  Use rbd_img_schedule() for kicking and passing
error codes.  No blocking occurs while waiting for the lock, but
rbd_dev->lock_rwsem is still held across lock, unlock and set_cookie
calls.

Always acquire the lock on "rbd map" to avoid associating the latency
of acquiring the lock with the first I/O request.

A slight regression is that lock_timeout is now respected only if lock
acquisition is triggered by "rbd map" and not by I/O.  This is somewhat
compensated by the fact that we no longer block if the peer refuses to
release lock -- I/O is failed with EROFS right away.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 325 +++++++++++++++++++++++++-------------------
 1 file changed, 182 insertions(+), 143 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 59d1fef35663..fd3f248ba9c2 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -312,6 +312,7 @@ enum img_req_flags {
 
 enum rbd_img_state {
 	RBD_IMG_START = 1,
+	RBD_IMG_EXCLUSIVE_LOCK,
 	__RBD_IMG_OBJECT_REQUESTS,
 	RBD_IMG_OBJECT_REQUESTS,
 };
@@ -412,9 +413,11 @@ struct rbd_device {
 	struct delayed_work	lock_dwork;
 	struct work_struct	unlock_work;
 	spinlock_t		lock_lists_lock;
+	struct list_head	acquiring_list;
 	struct list_head	running_list;
+	struct completion	acquire_wait;
+	int			acquire_err;
 	struct completion	releasing_wait;
-	wait_queue_head_t	lock_waitq;
 
 	struct workqueue_struct	*task_wq;
 
@@ -442,12 +445,10 @@ struct rbd_device {
  * Flag bits for rbd_dev->flags:
  * - REMOVING (which is coupled with rbd_dev->open_count) is protected
  *   by rbd_dev->lock
- * - BLACKLISTED is protected by rbd_dev->lock_rwsem
  */
 enum rbd_dev_flags {
 	RBD_DEV_FLAG_EXISTS,	/* mapped snapshot has not been deleted */
 	RBD_DEV_FLAG_REMOVING,	/* this mapping is being removed */
-	RBD_DEV_FLAG_BLACKLISTED, /* our ceph_client is blacklisted */
 };
 
 static DEFINE_MUTEX(client_mutex);	/* Serialize client creation */
@@ -500,6 +501,8 @@ static int minor_to_rbd_dev_id(int minor)
 
 static bool __rbd_is_lock_owner(struct rbd_device *rbd_dev)
 {
+	lockdep_assert_held(&rbd_dev->lock_rwsem);
+
 	return rbd_dev->lock_state == RBD_LOCK_STATE_LOCKED ||
 	       rbd_dev->lock_state == RBD_LOCK_STATE_RELEASING;
 }
@@ -2895,15 +2898,21 @@ static bool need_exclusive_lock(struct rbd_img_request *img_req)
 	return rbd_img_is_write(img_req);
 }
 
-static void rbd_lock_add_request(struct rbd_img_request *img_req)
+static bool rbd_lock_add_request(struct rbd_img_request *img_req)
 {
 	struct rbd_device *rbd_dev = img_req->rbd_dev;
+	bool locked;
 
 	lockdep_assert_held(&rbd_dev->lock_rwsem);
+	locked = rbd_dev->lock_state == RBD_LOCK_STATE_LOCKED;
 	spin_lock(&rbd_dev->lock_lists_lock);
 	rbd_assert(list_empty(&img_req->lock_item));
-	list_add_tail(&img_req->lock_item, &rbd_dev->running_list);
+	if (!locked)
+		list_add_tail(&img_req->lock_item, &rbd_dev->acquiring_list);
+	else
+		list_add_tail(&img_req->lock_item, &rbd_dev->running_list);
 	spin_unlock(&rbd_dev->lock_lists_lock);
+	return locked;
 }
 
 static void rbd_lock_del_request(struct rbd_img_request *img_req)
@@ -2922,6 +2931,30 @@ static void rbd_lock_del_request(struct rbd_img_request *img_req)
 		complete(&rbd_dev->releasing_wait);
 }
 
+static int rbd_img_exclusive_lock(struct rbd_img_request *img_req)
+{
+	struct rbd_device *rbd_dev = img_req->rbd_dev;
+
+	if (!need_exclusive_lock(img_req))
+		return 1;
+
+	if (rbd_lock_add_request(img_req))
+		return 1;
+
+	if (rbd_dev->opts->exclusive) {
+		WARN_ON(1); /* lock got released? */
+		return -EROFS;
+	}
+
+	/*
+	 * Note the use of mod_delayed_work() in rbd_acquire_lock()
+	 * and cancel_delayed_work() in wake_requests().
+	 */
+	dout("%s rbd_dev %p queueing lock_dwork\n", __func__, rbd_dev);
+	queue_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork, 0);
+	return 0;
+}
+
 static void rbd_img_object_requests(struct rbd_img_request *img_req)
 {
 	struct rbd_obj_request *obj_req;
@@ -2944,11 +2977,30 @@ static void rbd_img_object_requests(struct rbd_img_request *img_req)
 
 static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
 {
+	struct rbd_device *rbd_dev = img_req->rbd_dev;
+	int ret;
+
 again:
 	switch (img_req->state) {
 	case RBD_IMG_START:
 		rbd_assert(!*result);
 
+		ret = rbd_img_exclusive_lock(img_req);
+		if (ret < 0) {
+			*result = ret;
+			return true;
+		}
+		img_req->state = RBD_IMG_EXCLUSIVE_LOCK;
+		if (ret > 0)
+			goto again;
+		return false;
+	case RBD_IMG_EXCLUSIVE_LOCK:
+		if (*result)
+			return true;
+
+		rbd_assert(!need_exclusive_lock(img_req) ||
+			   __rbd_is_lock_owner(rbd_dev));
+
 		rbd_img_object_requests(img_req);
 		if (!img_req->pending.num_pending) {
 			*result = img_req->pending.result;
@@ -3107,7 +3159,7 @@ static void rbd_unlock(struct rbd_device *rbd_dev)
 	ret = ceph_cls_unlock(osdc, &rbd_dev->header_oid, &rbd_dev->header_oloc,
 			      RBD_LOCK_NAME, rbd_dev->lock_cookie);
 	if (ret && ret != -ENOENT)
-		rbd_warn(rbd_dev, "failed to unlock: %d", ret);
+		rbd_warn(rbd_dev, "failed to unlock header: %d", ret);
 
 	/* treat errors as the image is unlocked */
 	rbd_dev->lock_state = RBD_LOCK_STATE_UNLOCKED;
@@ -3234,15 +3286,30 @@ static int rbd_request_lock(struct rbd_device *rbd_dev)
 	goto out;
 }
 
-static void wake_requests(struct rbd_device *rbd_dev, bool wake_all)
+static void wake_requests(struct rbd_device *rbd_dev, int result)
 {
-	dout("%s rbd_dev %p wake_all %d\n", __func__, rbd_dev, wake_all);
+	struct rbd_img_request *img_req;
+
+	dout("%s rbd_dev %p result %d\n", __func__, rbd_dev, result);
+	lockdep_assert_held_exclusive(&rbd_dev->lock_rwsem);
 
 	cancel_delayed_work(&rbd_dev->lock_dwork);
-	if (wake_all)
-		wake_up_all(&rbd_dev->lock_waitq);
-	else
-		wake_up(&rbd_dev->lock_waitq);
+	if (!completion_done(&rbd_dev->acquire_wait)) {
+		rbd_assert(list_empty(&rbd_dev->acquiring_list) &&
+			   list_empty(&rbd_dev->running_list));
+		rbd_dev->acquire_err = result;
+		complete_all(&rbd_dev->acquire_wait);
+		return;
+	}
+
+	list_for_each_entry(img_req, &rbd_dev->acquiring_list, lock_item) {
+		mutex_lock(&img_req->state_mutex);
+		rbd_assert(img_req->state == RBD_IMG_EXCLUSIVE_LOCK);
+		rbd_img_schedule(img_req, result);
+		mutex_unlock(&img_req->state_mutex);
+	}
+
+	list_splice_tail_init(&rbd_dev->acquiring_list, &rbd_dev->running_list);
 }
 
 static int get_lock_owner_info(struct rbd_device *rbd_dev,
@@ -3357,11 +3424,8 @@ static int rbd_try_lock(struct rbd_device *rbd_dev)
 			goto again;
 
 		ret = find_watcher(rbd_dev, lockers);
-		if (ret) {
-			if (ret > 0)
-				ret = 0; /* have to request lock */
-			goto out;
-		}
+		if (ret)
+			goto out; /* request lock or error */
 
 		rbd_warn(rbd_dev, "%s%llu seems dead, breaking lock",
 			 ENTITY_NAME(lockers[0].id.name));
@@ -3391,52 +3455,65 @@ static int rbd_try_lock(struct rbd_device *rbd_dev)
 }
 
 /*
- * ret is set only if lock_state is RBD_LOCK_STATE_UNLOCKED
+ * Return:
+ *   0 - lock acquired
+ *   1 - caller should call rbd_request_lock()
+ *  <0 - error
  */
-static enum rbd_lock_state rbd_try_acquire_lock(struct rbd_device *rbd_dev,
-						int *pret)
+static int rbd_try_acquire_lock(struct rbd_device *rbd_dev)
 {
-	enum rbd_lock_state lock_state;
+	int ret;
 
 	down_read(&rbd_dev->lock_rwsem);
 	dout("%s rbd_dev %p read lock_state %d\n", __func__, rbd_dev,
 	     rbd_dev->lock_state);
 	if (__rbd_is_lock_owner(rbd_dev)) {
-		lock_state = rbd_dev->lock_state;
 		up_read(&rbd_dev->lock_rwsem);
-		return lock_state;
+		return 0;
 	}
 
 	up_read(&rbd_dev->lock_rwsem);
 	down_write(&rbd_dev->lock_rwsem);
 	dout("%s rbd_dev %p write lock_state %d\n", __func__, rbd_dev,
 	     rbd_dev->lock_state);
-	if (!__rbd_is_lock_owner(rbd_dev)) {
-		*pret = rbd_try_lock(rbd_dev);
-		if (*pret)
-			rbd_warn(rbd_dev, "failed to acquire lock: %d", *pret);
+	if (__rbd_is_lock_owner(rbd_dev)) {
+		up_write(&rbd_dev->lock_rwsem);
+		return 0;
 	}
 
-	lock_state = rbd_dev->lock_state;
+	ret = rbd_try_lock(rbd_dev);
+	if (ret < 0) {
+		rbd_warn(rbd_dev, "failed to lock header: %d", ret);
+		if (ret == -EBLACKLISTED)
+			goto out;
+
+		ret = 1; /* request lock anyway */
+	}
+	if (ret > 0) {
+		up_write(&rbd_dev->lock_rwsem);
+		return ret;
+	}
+
+	rbd_assert(rbd_dev->lock_state == RBD_LOCK_STATE_LOCKED);
+	rbd_assert(list_empty(&rbd_dev->running_list));
+
+out:
+	wake_requests(rbd_dev, ret);
 	up_write(&rbd_dev->lock_rwsem);
-	return lock_state;
+	return ret;
 }
 
 static void rbd_acquire_lock(struct work_struct *work)
 {
 	struct rbd_device *rbd_dev = container_of(to_delayed_work(work),
 					    struct rbd_device, lock_dwork);
-	enum rbd_lock_state lock_state;
-	int ret = 0;
+	int ret;
 
 	dout("%s rbd_dev %p\n", __func__, rbd_dev);
 again:
-	lock_state = rbd_try_acquire_lock(rbd_dev, &ret);
-	if (lock_state != RBD_LOCK_STATE_UNLOCKED || ret == -EBLACKLISTED) {
-		if (lock_state == RBD_LOCK_STATE_LOCKED)
-			wake_requests(rbd_dev, true);
-		dout("%s rbd_dev %p lock_state %d ret %d - done\n", __func__,
-		     rbd_dev, lock_state, ret);
+	ret = rbd_try_acquire_lock(rbd_dev);
+	if (ret <= 0) {
+		dout("%s rbd_dev %p ret %d - done\n", __func__, rbd_dev, ret);
 		return;
 	}
 
@@ -3445,16 +3522,9 @@ static void rbd_acquire_lock(struct work_struct *work)
 		goto again; /* treat this as a dead client */
 	} else if (ret == -EROFS) {
 		rbd_warn(rbd_dev, "peer will not release lock");
-		/*
-		 * If this is rbd_add_acquire_lock(), we want to fail
-		 * immediately -- reuse BLACKLISTED flag.  Otherwise we
-		 * want to block.
-		 */
-		if (!(rbd_dev->disk->flags & GENHD_FL_UP)) {
-			set_bit(RBD_DEV_FLAG_BLACKLISTED, &rbd_dev->flags);
-			/* wake "rbd map --exclusive" process */
-			wake_requests(rbd_dev, false);
-		}
+		down_write(&rbd_dev->lock_rwsem);
+		wake_requests(rbd_dev, ret);
+		up_write(&rbd_dev->lock_rwsem);
 	} else if (ret < 0) {
 		rbd_warn(rbd_dev, "error requesting lock: %d", ret);
 		mod_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork,
@@ -3519,10 +3589,10 @@ static void rbd_release_lock(struct rbd_device *rbd_dev)
 
 	/*
 	 * Give others a chance to grab the lock - we would re-acquire
-	 * almost immediately if we got new IO during ceph_osdc_sync()
-	 * otherwise.  We need to ack our own notifications, so this
-	 * lock_dwork will be requeued from rbd_wait_state_locked()
-	 * after wake_requests() in rbd_handle_released_lock().
+	 * almost immediately if we got new IO while draining the running
+	 * list otherwise.  We need to ack our own notifications, so this
+	 * lock_dwork will be requeued from rbd_handle_released_lock() by
+	 * way of maybe_kick_acquire().
 	 */
 	cancel_delayed_work(&rbd_dev->lock_dwork);
 }
@@ -3537,6 +3607,23 @@ static void rbd_release_lock_work(struct work_struct *work)
 	up_write(&rbd_dev->lock_rwsem);
 }
 
+static void maybe_kick_acquire(struct rbd_device *rbd_dev)
+{
+	bool have_requests;
+
+	dout("%s rbd_dev %p\n", __func__, rbd_dev);
+	if (__rbd_is_lock_owner(rbd_dev))
+		return;
+
+	spin_lock(&rbd_dev->lock_lists_lock);
+	have_requests = !list_empty(&rbd_dev->acquiring_list);
+	spin_unlock(&rbd_dev->lock_lists_lock);
+	if (have_requests || delayed_work_pending(&rbd_dev->lock_dwork)) {
+		dout("%s rbd_dev %p kicking lock_dwork\n", __func__, rbd_dev);
+		mod_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork, 0);
+	}
+}
+
 static void rbd_handle_acquired_lock(struct rbd_device *rbd_dev, u8 struct_v,
 				     void **p)
 {
@@ -3566,8 +3653,7 @@ static void rbd_handle_acquired_lock(struct rbd_device *rbd_dev, u8 struct_v,
 		down_read(&rbd_dev->lock_rwsem);
 	}
 
-	if (!__rbd_is_lock_owner(rbd_dev))
-		wake_requests(rbd_dev, false);
+	maybe_kick_acquire(rbd_dev);
 	up_read(&rbd_dev->lock_rwsem);
 }
 
@@ -3599,8 +3685,7 @@ static void rbd_handle_released_lock(struct rbd_device *rbd_dev, u8 struct_v,
 		down_read(&rbd_dev->lock_rwsem);
 	}
 
-	if (!__rbd_is_lock_owner(rbd_dev))
-		wake_requests(rbd_dev, false);
+	maybe_kick_acquire(rbd_dev);
 	up_read(&rbd_dev->lock_rwsem);
 }
 
@@ -3850,7 +3935,6 @@ static void cancel_tasks_sync(struct rbd_device *rbd_dev)
 
 static void rbd_unregister_watch(struct rbd_device *rbd_dev)
 {
-	WARN_ON(waitqueue_active(&rbd_dev->lock_waitq));
 	cancel_tasks_sync(rbd_dev);
 
 	mutex_lock(&rbd_dev->watch_mutex);
@@ -3893,6 +3977,7 @@ static void rbd_reacquire_lock(struct rbd_device *rbd_dev)
 		queue_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork, 0);
 	} else {
 		__rbd_lock(rbd_dev, cookie);
+		wake_requests(rbd_dev, 0);
 	}
 }
 
@@ -3913,15 +3998,18 @@ static void rbd_reregister_watch(struct work_struct *work)
 	ret = __rbd_register_watch(rbd_dev);
 	if (ret) {
 		rbd_warn(rbd_dev, "failed to reregister watch: %d", ret);
-		if (ret == -EBLACKLISTED || ret == -ENOENT) {
-			set_bit(RBD_DEV_FLAG_BLACKLISTED, &rbd_dev->flags);
-			wake_requests(rbd_dev, true);
-		} else {
+		if (ret != -EBLACKLISTED && ret != -ENOENT) {
 			queue_delayed_work(rbd_dev->task_wq,
 					   &rbd_dev->watch_dwork,
 					   RBD_RETRY_DELAY);
+			mutex_unlock(&rbd_dev->watch_mutex);
+			return;
 		}
+
 		mutex_unlock(&rbd_dev->watch_mutex);
+		down_write(&rbd_dev->lock_rwsem);
+		wake_requests(rbd_dev, ret);
+		up_write(&rbd_dev->lock_rwsem);
 		return;
 	}
 
@@ -3996,54 +4084,6 @@ static int rbd_obj_method_sync(struct rbd_device *rbd_dev,
 	return ret;
 }
 
-/*
- * lock_rwsem must be held for read
- */
-static int rbd_wait_state_locked(struct rbd_device *rbd_dev, bool may_acquire)
-{
-	DEFINE_WAIT(wait);
-	unsigned long timeout;
-	int ret = 0;
-
-	if (test_bit(RBD_DEV_FLAG_BLACKLISTED, &rbd_dev->flags))
-		return -EBLACKLISTED;
-
-	if (rbd_dev->lock_state == RBD_LOCK_STATE_LOCKED)
-		return 0;
-
-	if (!may_acquire) {
-		rbd_warn(rbd_dev, "exclusive lock required");
-		return -EROFS;
-	}
-
-	do {
-		/*
-		 * Note the use of mod_delayed_work() in rbd_acquire_lock()
-		 * and cancel_delayed_work() in wake_requests().
-		 */
-		dout("%s rbd_dev %p queueing lock_dwork\n", __func__, rbd_dev);
-		queue_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork, 0);
-		prepare_to_wait_exclusive(&rbd_dev->lock_waitq, &wait,
-					  TASK_UNINTERRUPTIBLE);
-		up_read(&rbd_dev->lock_rwsem);
-		timeout = schedule_timeout(ceph_timeout_jiffies(
-						rbd_dev->opts->lock_timeout));
-		down_read(&rbd_dev->lock_rwsem);
-		if (test_bit(RBD_DEV_FLAG_BLACKLISTED, &rbd_dev->flags)) {
-			ret = -EBLACKLISTED;
-			break;
-		}
-		if (!timeout) {
-			rbd_warn(rbd_dev, "timed out waiting for lock");
-			ret = -ETIMEDOUT;
-			break;
-		}
-	} while (rbd_dev->lock_state != RBD_LOCK_STATE_LOCKED);
-
-	finish_wait(&rbd_dev->lock_waitq, &wait);
-	return ret;
-}
-
 static void rbd_queue_workfn(struct work_struct *work)
 {
 	struct request *rq = blk_mq_rq_from_pdu(work);
@@ -4054,7 +4094,6 @@ static void rbd_queue_workfn(struct work_struct *work)
 	u64 length = blk_rq_bytes(rq);
 	enum obj_operation_type op_type;
 	u64 mapping_size;
-	bool must_be_locked;
 	int result;
 
 	switch (req_op(rq)) {
@@ -4128,21 +4167,10 @@ static void rbd_queue_workfn(struct work_struct *work)
 		goto err_rq;
 	}
 
-	must_be_locked =
-	    (rbd_dev->header.features & RBD_FEATURE_EXCLUSIVE_LOCK) &&
-	    (op_type != OBJ_OP_READ || rbd_dev->opts->lock_on_read);
-	if (must_be_locked) {
-		down_read(&rbd_dev->lock_rwsem);
-		result = rbd_wait_state_locked(rbd_dev,
-					       !rbd_dev->opts->exclusive);
-		if (result)
-			goto err_unlock;
-	}
-
 	img_request = rbd_img_request_create(rbd_dev, op_type, snapc);
 	if (!img_request) {
 		result = -ENOMEM;
-		goto err_unlock;
+		goto err_rq;
 	}
 	img_request->rq = rq;
 	snapc = NULL; /* img_request consumes a ref */
@@ -4155,19 +4183,11 @@ static void rbd_queue_workfn(struct work_struct *work)
 	if (result)
 		goto err_img_request;
 
-	if (must_be_locked) {
-		rbd_lock_add_request(img_request);
-		up_read(&rbd_dev->lock_rwsem);
-	}
-
 	rbd_img_handle_request(img_request, 0);
 	return;
 
 err_img_request:
 	rbd_img_request_put(img_request);
-err_unlock:
-	if (must_be_locked)
-		up_read(&rbd_dev->lock_rwsem);
 err_rq:
 	if (result)
 		rbd_warn(rbd_dev, "%s %llx at %llx result %d",
@@ -4835,9 +4855,10 @@ static struct rbd_device *__rbd_dev_create(struct rbd_client *rbdc,
 	INIT_DELAYED_WORK(&rbd_dev->lock_dwork, rbd_acquire_lock);
 	INIT_WORK(&rbd_dev->unlock_work, rbd_release_lock_work);
 	spin_lock_init(&rbd_dev->lock_lists_lock);
+	INIT_LIST_HEAD(&rbd_dev->acquiring_list);
 	INIT_LIST_HEAD(&rbd_dev->running_list);
+	init_completion(&rbd_dev->acquire_wait);
 	init_completion(&rbd_dev->releasing_wait);
-	init_waitqueue_head(&rbd_dev->lock_waitq);
 
 	rbd_dev->dev.bus = &rbd_bus_type;
 	rbd_dev->dev.type = &rbd_device_type;
@@ -5857,24 +5878,45 @@ static void rbd_dev_image_unlock(struct rbd_device *rbd_dev)
 	up_write(&rbd_dev->lock_rwsem);
 }
 
+/*
+ * If the wait is interrupted, an error is returned even if the lock
+ * was successfully acquired.  rbd_dev_image_unlock() will release it
+ * if needed.
+ */
 static int rbd_add_acquire_lock(struct rbd_device *rbd_dev)
 {
-	int ret;
+	long ret;
 
 	if (!(rbd_dev->header.features & RBD_FEATURE_EXCLUSIVE_LOCK)) {
+		if (!rbd_dev->opts->exclusive && !rbd_dev->opts->lock_on_read)
+			return 0;
+
 		rbd_warn(rbd_dev, "exclusive-lock feature is not enabled");
 		return -EINVAL;
 	}
 
-	/* FIXME: "rbd map --exclusive" should be in interruptible */
-	down_read(&rbd_dev->lock_rwsem);
-	ret = rbd_wait_state_locked(rbd_dev, true);
-	up_read(&rbd_dev->lock_rwsem);
+	if (rbd_dev->spec->snap_id != CEPH_NOSNAP)
+		return 0;
+
+	rbd_assert(!rbd_is_lock_owner(rbd_dev));
+	queue_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork, 0);
+	ret = wait_for_completion_killable_timeout(&rbd_dev->acquire_wait,
+			    ceph_timeout_jiffies(rbd_dev->opts->lock_timeout));
+	if (ret > 0)
+		ret = rbd_dev->acquire_err;
+	else if (!ret)
+		ret = -ETIMEDOUT;
+
 	if (ret) {
-		rbd_warn(rbd_dev, "failed to acquire exclusive lock");
-		return -EROFS;
+		rbd_warn(rbd_dev, "failed to acquire exclusive lock: %ld", ret);
+		return ret;
 	}
 
+	/*
+	 * The lock may have been released by now, unless automatic lock
+	 * transitions are disabled.
+	 */
+	rbd_assert(!rbd_dev->opts->exclusive || rbd_is_lock_owner(rbd_dev));
 	return 0;
 }
 
@@ -6319,11 +6361,9 @@ static ssize_t do_rbd_add(struct bus_type *bus,
 	if (rc)
 		goto err_out_image_probe;
 
-	if (rbd_dev->opts->exclusive) {
-		rc = rbd_add_acquire_lock(rbd_dev);
-		if (rc)
-			goto err_out_device_setup;
-	}
+	rc = rbd_add_acquire_lock(rbd_dev);
+	if (rc)
+		goto err_out_image_lock;
 
 	/* Everything's ready.  Announce the disk to the world. */
 
@@ -6349,7 +6389,6 @@ static ssize_t do_rbd_add(struct bus_type *bus,
 
 err_out_image_lock:
 	rbd_dev_image_unlock(rbd_dev);
-err_out_device_setup:
 	rbd_dev_device_release(rbd_dev);
 err_out_image_probe:
 	rbd_dev_image_release(rbd_dev);
-- 
2.19.2


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB60C5523D
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731689AbfFYOlY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 10:41:24 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39668 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731601AbfFYOlX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:41:23 -0400
Received: by mail-wm1-f68.google.com with SMTP id z23so3236710wma.4
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 07:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BAUed1XgGUdufZlXODFnV9udQwj1WesncWPyI/AsAes=;
        b=djdnrIxVeLQiF7lr3cdcZz+CdTVvuw9JkUildTGm0gH0ljPIu8G2Br7N20ax3qRiMp
         hS4x2Y/u9cWLf6k4YKa16vw1fhll+1Fj5/4s8motZVOOc2uO/8bFiz/btL98j8oE4+vE
         c3waEyFze2xXfnkV3YZwPSC09FT5NbemFo7zl7+VO8qGgXIPx848RaeiLFv/5W8FwvNO
         8r3PrPdzzMBNm4+61whb6yiv3p0stYfuhNG310OnDXW9cKiveSNbrbBxfzGMFDJTpNpS
         vzjLEsSlas96+03XziB6H6vCotAAALL1x8FbG0RMpQhUvo3+zclY/95CUl6Ao16T60n3
         s23A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BAUed1XgGUdufZlXODFnV9udQwj1WesncWPyI/AsAes=;
        b=pnAqmrlKWwKIUOrwyxxsLDROwba4UI7Eot/rzDcKjNqlXVL+vlvHQT9XoMMmKBsnWd
         L12qGX38TLsIWL6UgWXmt/eVVwzUF47PHu4yfWt9sz/TquspLITv/A4c6dtuCtCQt3Nx
         rIMLKa6CaST09wEifLvkvjiLCe9vt0LABCLtywrUTMBeOpa0djstZExyPBxslLzjlNnq
         qGT3MM+/PLnCre0RqqAnvQADD2zR0BDX3yIYLu48fp9PfLqoO34hBjcraqDv2DYETIiA
         M5oFLVirxI9tSbYSYtrKOEX5Xaxu7shyTRZ2QMuP3W+kLvJvlFL4syEHxTQ+8GP8aSRs
         VBcg==
X-Gm-Message-State: APjAAAXZnmD7069jQVWE3tUM6o+MURMhLmPfrkQdob5s/u7aX6Qedhlo
        10gTjXa3YVKj5kmqOOY87PY0jq+WZ4M=
X-Google-Smtp-Source: APXvYqwNUkLP+17HY00swl7wazQw3jw9+RHC2OaGXYiWSjRdUOqxzUZvntSHpZzFhSjmXMmuRa55WA==
X-Received: by 2002:a1c:740f:: with SMTP id p15mr20108921wmc.103.1561473680908;
        Tue, 25 Jun 2019 07:41:20 -0700 (PDT)
Received: from kwango.redhat.com (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id f2sm20282378wrq.48.2019.06.25.07.41.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:41:20 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 13/20] rbd: quiescing lock should wait for image requests
Date:   Tue, 25 Jun 2019 16:41:04 +0200
Message-Id: <20190625144111.11270-14-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190625144111.11270-1-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Syncing OSD requests doesn't really work.  A single image request may
be comprised of multiple object requests, each of which can go through
a series of OSD requests (original, copyups, etc).  On top of that, the
OSD cliest may be shared with other rbd devices.

What we want is to ensure that all in-flight image requests complete.
Introduce rbd_dev->running_list and block in RBD_LOCK_STATE_RELEASING
until that happens.  New OSD requests may be started during this time.

Note that __rbd_img_handle_request() acquires rbd_dev->lock_rwsem only
if need_exclusive_lock() returns true.  This avoids a deadlock similar
to the one outlined in the previous commit between unlock and I/O that
doesn't require lock, such as a read with object-map feature disabled.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 104 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 90 insertions(+), 14 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 5fcb4ebd981a..59d1fef35663 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -331,6 +331,7 @@ struct rbd_img_request {
 		struct rbd_obj_request	*obj_request;	/* obj req initiator */
 	};
 
+	struct list_head	lock_item;
 	struct list_head	object_extents;	/* obj_req.ex structs */
 
 	struct mutex		state_mutex;
@@ -410,6 +411,9 @@ struct rbd_device {
 	struct work_struct	released_lock_work;
 	struct delayed_work	lock_dwork;
 	struct work_struct	unlock_work;
+	spinlock_t		lock_lists_lock;
+	struct list_head	running_list;
+	struct completion	releasing_wait;
 	wait_queue_head_t	lock_waitq;
 
 	struct workqueue_struct	*task_wq;
@@ -1726,6 +1730,7 @@ static struct rbd_img_request *rbd_img_request_create(
 	if (rbd_dev_parent_get(rbd_dev))
 		img_request_layered_set(img_request);
 
+	INIT_LIST_HEAD(&img_request->lock_item);
 	INIT_LIST_HEAD(&img_request->object_extents);
 	mutex_init(&img_request->state_mutex);
 	kref_init(&img_request->kref);
@@ -1745,6 +1750,7 @@ static void rbd_img_request_destroy(struct kref *kref)
 
 	dout("%s: img %p\n", __func__, img_request);
 
+	WARN_ON(!list_empty(&img_request->lock_item));
 	for_each_obj_request_safe(img_request, obj_request, next_obj_request)
 		rbd_img_obj_request_del(img_request, obj_request);
 
@@ -2872,6 +2878,50 @@ static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result)
 		rbd_img_handle_request(obj_req->img_request, result);
 }
 
+static bool need_exclusive_lock(struct rbd_img_request *img_req)
+{
+	struct rbd_device *rbd_dev = img_req->rbd_dev;
+
+	if (!(rbd_dev->header.features & RBD_FEATURE_EXCLUSIVE_LOCK))
+		return false;
+
+	if (rbd_dev->spec->snap_id != CEPH_NOSNAP)
+		return false;
+
+	rbd_assert(!test_bit(IMG_REQ_CHILD, &img_req->flags));
+	if (rbd_dev->opts->lock_on_read)
+		return true;
+
+	return rbd_img_is_write(img_req);
+}
+
+static void rbd_lock_add_request(struct rbd_img_request *img_req)
+{
+	struct rbd_device *rbd_dev = img_req->rbd_dev;
+
+	lockdep_assert_held(&rbd_dev->lock_rwsem);
+	spin_lock(&rbd_dev->lock_lists_lock);
+	rbd_assert(list_empty(&img_req->lock_item));
+	list_add_tail(&img_req->lock_item, &rbd_dev->running_list);
+	spin_unlock(&rbd_dev->lock_lists_lock);
+}
+
+static void rbd_lock_del_request(struct rbd_img_request *img_req)
+{
+	struct rbd_device *rbd_dev = img_req->rbd_dev;
+	bool need_wakeup;
+
+	lockdep_assert_held(&rbd_dev->lock_rwsem);
+	spin_lock(&rbd_dev->lock_lists_lock);
+	rbd_assert(!list_empty(&img_req->lock_item));
+	list_del_init(&img_req->lock_item);
+	need_wakeup = (rbd_dev->lock_state == RBD_LOCK_STATE_RELEASING &&
+		       list_empty(&rbd_dev->running_list));
+	spin_unlock(&rbd_dev->lock_lists_lock);
+	if (need_wakeup)
+		complete(&rbd_dev->releasing_wait);
+}
+
 static void rbd_img_object_requests(struct rbd_img_request *img_req)
 {
 	struct rbd_obj_request *obj_req;
@@ -2927,9 +2977,19 @@ static bool __rbd_img_handle_request(struct rbd_img_request *img_req,
 	struct rbd_device *rbd_dev = img_req->rbd_dev;
 	bool done;
 
-	mutex_lock(&img_req->state_mutex);
-	done = rbd_img_advance(img_req, result);
-	mutex_unlock(&img_req->state_mutex);
+	if (need_exclusive_lock(img_req)) {
+		down_read(&rbd_dev->lock_rwsem);
+		mutex_lock(&img_req->state_mutex);
+		done = rbd_img_advance(img_req, result);
+		if (done)
+			rbd_lock_del_request(img_req);
+		mutex_unlock(&img_req->state_mutex);
+		up_read(&rbd_dev->lock_rwsem);
+	} else {
+		mutex_lock(&img_req->state_mutex);
+		done = rbd_img_advance(img_req, result);
+		mutex_unlock(&img_req->state_mutex);
+	}
 
 	if (done && *result) {
 		rbd_assert(*result < 0);
@@ -3413,30 +3473,40 @@ static void rbd_acquire_lock(struct work_struct *work)
 
 static bool rbd_quiesce_lock(struct rbd_device *rbd_dev)
 {
+	bool need_wait;
+
 	dout("%s rbd_dev %p\n", __func__, rbd_dev);
 	lockdep_assert_held_exclusive(&rbd_dev->lock_rwsem);
 
 	if (rbd_dev->lock_state != RBD_LOCK_STATE_LOCKED)
 		return false;
 
-	rbd_dev->lock_state = RBD_LOCK_STATE_RELEASING;
-	downgrade_write(&rbd_dev->lock_rwsem);
 	/*
 	 * Ensure that all in-flight IO is flushed.
-	 *
-	 * FIXME: ceph_osdc_sync() flushes the entire OSD client, which
-	 * may be shared with other devices.
 	 */
-	ceph_osdc_sync(&rbd_dev->rbd_client->client->osdc);
+	rbd_dev->lock_state = RBD_LOCK_STATE_RELEASING;
+	rbd_assert(!completion_done(&rbd_dev->releasing_wait));
+	need_wait = !list_empty(&rbd_dev->running_list);
+	downgrade_write(&rbd_dev->lock_rwsem);
+	if (need_wait)
+		wait_for_completion(&rbd_dev->releasing_wait);
 	up_read(&rbd_dev->lock_rwsem);
 
 	down_write(&rbd_dev->lock_rwsem);
 	if (rbd_dev->lock_state != RBD_LOCK_STATE_RELEASING)
 		return false;
 
+	rbd_assert(list_empty(&rbd_dev->running_list));
 	return true;
 }
 
+static void __rbd_release_lock(struct rbd_device *rbd_dev)
+{
+	rbd_assert(list_empty(&rbd_dev->running_list));
+
+	rbd_unlock(rbd_dev);
+}
+
 /*
  * lock_rwsem must be held for write
  */
@@ -3445,7 +3515,7 @@ static void rbd_release_lock(struct rbd_device *rbd_dev)
 	if (!rbd_quiesce_lock(rbd_dev))
 		return;
 
-	rbd_unlock(rbd_dev);
+	__rbd_release_lock(rbd_dev);
 
 	/*
 	 * Give others a chance to grab the lock - we would re-acquire
@@ -3819,7 +3889,7 @@ static void rbd_reacquire_lock(struct rbd_device *rbd_dev)
 		 * Lock cookie cannot be updated on older OSDs, so do
 		 * a manual release and queue an acquire.
 		 */
-		rbd_unlock(rbd_dev);
+		__rbd_release_lock(rbd_dev);
 		queue_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork, 0);
 	} else {
 		__rbd_lock(rbd_dev, cookie);
@@ -4085,9 +4155,12 @@ static void rbd_queue_workfn(struct work_struct *work)
 	if (result)
 		goto err_img_request;
 
-	rbd_img_handle_request(img_request, 0);
-	if (must_be_locked)
+	if (must_be_locked) {
+		rbd_lock_add_request(img_request);
 		up_read(&rbd_dev->lock_rwsem);
+	}
+
+	rbd_img_handle_request(img_request, 0);
 	return;
 
 err_img_request:
@@ -4761,6 +4834,9 @@ static struct rbd_device *__rbd_dev_create(struct rbd_client *rbdc,
 	INIT_WORK(&rbd_dev->released_lock_work, rbd_notify_released_lock);
 	INIT_DELAYED_WORK(&rbd_dev->lock_dwork, rbd_acquire_lock);
 	INIT_WORK(&rbd_dev->unlock_work, rbd_release_lock_work);
+	spin_lock_init(&rbd_dev->lock_lists_lock);
+	INIT_LIST_HEAD(&rbd_dev->running_list);
+	init_completion(&rbd_dev->releasing_wait);
 	init_waitqueue_head(&rbd_dev->lock_waitq);
 
 	rbd_dev->dev.bus = &rbd_bus_type;
@@ -5777,7 +5853,7 @@ static void rbd_dev_image_unlock(struct rbd_device *rbd_dev)
 {
 	down_write(&rbd_dev->lock_rwsem);
 	if (__rbd_is_lock_owner(rbd_dev))
-		rbd_unlock(rbd_dev);
+		__rbd_release_lock(rbd_dev);
 	up_write(&rbd_dev->lock_rwsem);
 }
 
-- 
2.19.2


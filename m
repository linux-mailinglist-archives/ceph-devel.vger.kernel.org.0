Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D81245A75
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Aug 2020 03:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgHQBfD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Aug 2020 21:35:03 -0400
Received: from smtprelay0249.hostedemail.com ([216.40.44.249]:38664 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726732AbgHQBer (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 16 Aug 2020 21:34:47 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 3BED6837F24D;
        Mon, 17 Aug 2020 01:34:45 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:69:327:355:379:541:960:966:968:973:988:989:1260:1311:1314:1345:1359:1437:1515:1605:1730:1747:1777:1792:1978:1981:2194:2196:2198:2199:2200:2201:2393:2559:2562:2693:2731:3138:3139:3140:3141:3142:3150:3865:3866:3867:3868:3870:3871:3872:4321:4384:4385:4395:4605:5007:6261:7875:7903:8603:8957:9038:10004:10848:11026:11914:12043:12291:12296:12297:12438:12555:12663:12679:12683:12895:12986:13161:13229:13894:13972:14110:14394:21080:21220:21324:21325:21433:21451:21611:21626:21740:21987:21990:30029:30054:30062:30080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: drop74_330484927012
X-Filterd-Recvd-Size: 31575
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Mon, 17 Aug 2020 01:34:43 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Jens Axboe <axboe@kernel.dk>
Cc:     ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 5/6] rbd: Use generic debugging facility
Date:   Sun, 16 Aug 2020 18:34:08 -0700
Message-Id: <6c04898b40c6ac274bc1bf1f5791df2f586c5812.1597626802.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1597626802.git.joe@perches.com>
References: <cover.1597626802.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The dout macro duplicates the generic features of pr_debug with
__FILE__ and __func__ output capability when using dynamic_debug.

Convert dout to pr_debug and remove the "pretty" print feature
of dout.

Miscellanea:

o Realign arguments

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/rbd.c | 231 +++++++++++++++++++++++---------------------
 1 file changed, 120 insertions(+), 111 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index d9c0e7d154f9..19696962c4f4 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -758,7 +758,7 @@ static struct rbd_client *rbd_client_create(struct ceph_options *ceph_opts)
 	struct rbd_client *rbdc;
 	int ret = -ENOMEM;
 
-	dout("%s:\n", __func__);
+	pr_debug("%s:\n", __func__);
 	rbdc = kmalloc(sizeof(struct rbd_client), GFP_KERNEL);
 	if (!rbdc)
 		goto out_opt;
@@ -779,7 +779,7 @@ static struct rbd_client *rbd_client_create(struct ceph_options *ceph_opts)
 	list_add_tail(&rbdc->node, &rbd_client_list);
 	spin_unlock(&rbd_client_list_lock);
 
-	dout("%s: rbdc %p\n", __func__, rbdc);
+	pr_debug("%s: rbdc %p\n", __func__, rbdc);
 
 	return rbdc;
 out_client:
@@ -789,7 +789,7 @@ static struct rbd_client *rbd_client_create(struct ceph_options *ceph_opts)
 out_opt:
 	if (ceph_opts)
 		ceph_destroy_options(ceph_opts);
-	dout("%s: error %d\n", __func__, ret);
+	pr_debug("%s: error %d\n", __func__, ret);
 
 	return ERR_PTR(ret);
 }
@@ -926,7 +926,7 @@ static void rbd_client_release(struct kref *kref)
 {
 	struct rbd_client *rbdc = container_of(kref, struct rbd_client, kref);
 
-	dout("%s: rbdc %p\n", __func__, rbdc);
+	pr_debug("%s: rbdc %p\n", __func__, rbdc);
 	spin_lock(&rbd_client_list_lock);
 	list_del(&rbdc->node);
 	spin_unlock(&rbd_client_list_lock);
@@ -1310,7 +1310,7 @@ static void zero_bvecs(struct ceph_bvec_iter *bvec_pos, u32 off, u32 bytes)
 static void rbd_obj_zero_range(struct rbd_obj_request *obj_req, u32 off,
 			       u32 bytes)
 {
-	dout("%s %p data buf %u~%u\n", __func__, obj_req, off, bytes);
+	pr_debug("%s %p data buf %u~%u\n", __func__, obj_req, off, bytes);
 
 	switch (obj_req->img_request->data_type) {
 	case OBJ_REQUEST_BIO:
@@ -1329,8 +1329,8 @@ static void rbd_obj_request_destroy(struct kref *kref);
 static void rbd_obj_request_put(struct rbd_obj_request *obj_request)
 {
 	rbd_assert(obj_request != NULL);
-	dout("%s: obj %p (was %d)\n", __func__, obj_request,
-		kref_read(&obj_request->kref));
+	pr_debug("%s: obj %p (was %d)\n",
+		 __func__, obj_request, kref_read(&obj_request->kref));
 	kref_put(&obj_request->kref, rbd_obj_request_destroy);
 }
 
@@ -1341,13 +1341,13 @@ static inline void rbd_img_obj_request_add(struct rbd_img_request *img_request,
 
 	/* Image request now owns object's original reference */
 	obj_request->img_request = img_request;
-	dout("%s: img %p obj %p\n", __func__, img_request, obj_request);
+	pr_debug("%s: img %p obj %p\n", __func__, img_request, obj_request);
 }
 
 static inline void rbd_img_obj_request_del(struct rbd_img_request *img_request,
 					struct rbd_obj_request *obj_request)
 {
-	dout("%s: img %p obj %p\n", __func__, img_request, obj_request);
+	pr_debug("%s: img %p obj %p\n", __func__, img_request, obj_request);
 	list_del(&obj_request->ex.oe_item);
 	rbd_assert(obj_request->img_request == img_request);
 	rbd_obj_request_put(obj_request);
@@ -1357,9 +1357,9 @@ static void rbd_osd_submit(struct ceph_osd_request *osd_req)
 {
 	struct rbd_obj_request *obj_req = osd_req->r_priv;
 
-	dout("%s osd_req %p for obj_req %p objno %llu %llu~%llu\n",
-	     __func__, osd_req, obj_req, obj_req->ex.oe_objno,
-	     obj_req->ex.oe_off, obj_req->ex.oe_len);
+	pr_debug("%s osd_req %p for obj_req %p objno %llu %llu~%llu\n",
+		 __func__, osd_req, obj_req, obj_req->ex.oe_objno,
+		 obj_req->ex.oe_off, obj_req->ex.oe_len);
 	ceph_osdc_start_request(osd_req->r_osdc, osd_req, false);
 }
 
@@ -1432,8 +1432,8 @@ static void rbd_osd_req_callback(struct ceph_osd_request *osd_req)
 	struct rbd_obj_request *obj_req = osd_req->r_priv;
 	int result;
 
-	dout("%s osd_req %p result %d for obj_req %p\n", __func__, osd_req,
-	     osd_req->r_result, obj_req);
+	pr_debug("%s osd_req %p result %d for obj_req %p\n",
+		 __func__, osd_req, osd_req->r_result, obj_req);
 
 	/*
 	 * Writes aren't allowed to return a data payload.  In some
@@ -1522,7 +1522,7 @@ static struct rbd_obj_request *rbd_obj_request_create(void)
 	mutex_init(&obj_request->state_mutex);
 	kref_init(&obj_request->kref);
 
-	dout("%s %p\n", __func__, obj_request);
+	pr_debug("%s %p\n", __func__, obj_request);
 	return obj_request;
 }
 
@@ -1534,7 +1534,7 @@ static void rbd_obj_request_destroy(struct kref *kref)
 
 	obj_request = container_of(kref, struct rbd_obj_request, kref);
 
-	dout("%s: obj %p\n", __func__, obj_request);
+	pr_debug("%s: obj %p\n", __func__, obj_request);
 
 	while (!list_empty(&obj_request->osd_reqs)) {
 		osd_req = list_first_entry(&obj_request->osd_reqs,
@@ -1661,7 +1661,7 @@ static void rbd_img_request_destroy(struct rbd_img_request *img_request)
 	struct rbd_obj_request *obj_request;
 	struct rbd_obj_request *next_obj_request;
 
-	dout("%s: img %p\n", __func__, img_request);
+	pr_debug("%s: img %p\n", __func__, img_request);
 
 	WARN_ON(!list_empty(&img_request->lock_item));
 	for_each_obj_request_safe(img_request, obj_request, next_obj_request)
@@ -2037,8 +2037,8 @@ static void rbd_object_map_callback(struct ceph_osd_request *osd_req)
 	struct rbd_obj_request *obj_req = osd_req->r_priv;
 	int result;
 
-	dout("%s osd_req %p result %d for obj_req %p\n", __func__, osd_req,
-	     osd_req->r_result, obj_req);
+	pr_debug("%s osd_req %p result %d for obj_req %p\n",
+		 __func__, osd_req, osd_req->r_result, obj_req);
 
 	result = rbd_object_map_update_finish(obj_req, osd_req);
 	rbd_obj_handle_request(obj_req, result);
@@ -2347,9 +2347,10 @@ static int rbd_obj_init_discard(struct rbd_obj_request *obj_req)
 		if (off >= next_off)
 			return 1;
 
-		dout("%s %p %llu~%llu -> %llu~%llu\n", __func__,
-		     obj_req, obj_req->ex.oe_off, obj_req->ex.oe_len,
-		     off, next_off - off);
+		pr_debug("%s %p %llu~%llu -> %llu~%llu\n",
+			 __func__, obj_req,
+			 obj_req->ex.oe_off, obj_req->ex.oe_len,
+			 off, next_off - off);
 		obj_req->ex.oe_off = off;
 		obj_req->ex.oe_len = next_off - off;
 	}
@@ -2661,7 +2662,7 @@ static void set_bio_pos(struct ceph_object_extent *ex, u32 bytes, void *arg)
 	    container_of(ex, struct rbd_obj_request, ex);
 	struct ceph_bio_iter *it = arg;
 
-	dout("%s objno %llu bytes %u\n", __func__, ex->oe_objno, bytes);
+	pr_debug("%s objno %llu bytes %u\n", __func__, ex->oe_objno, bytes);
 	obj_req->bio_pos = *it;
 	ceph_bio_iter_advance(it, bytes);
 }
@@ -2672,7 +2673,7 @@ static void count_bio_bvecs(struct ceph_object_extent *ex, u32 bytes, void *arg)
 	    container_of(ex, struct rbd_obj_request, ex);
 	struct ceph_bio_iter *it = arg;
 
-	dout("%s objno %llu bytes %u\n", __func__, ex->oe_objno, bytes);
+	pr_debug("%s objno %llu bytes %u\n", __func__, ex->oe_objno, bytes);
 	ceph_bio_iter_advance_step(it, bytes, ({
 		obj_req->bvec_count++;
 	}));
@@ -2685,7 +2686,7 @@ static void copy_bio_bvecs(struct ceph_object_extent *ex, u32 bytes, void *arg)
 	    container_of(ex, struct rbd_obj_request, ex);
 	struct ceph_bio_iter *it = arg;
 
-	dout("%s objno %llu bytes %u\n", __func__, ex->oe_objno, bytes);
+	pr_debug("%s objno %llu bytes %u\n", __func__, ex->oe_objno, bytes);
 	ceph_bio_iter_advance_step(it, bytes, ({
 		obj_req->bvec_pos.bvecs[obj_req->bvec_idx++] = bv;
 		obj_req->bvec_pos.iter.bi_size += bv.bv_len;
@@ -2808,8 +2809,8 @@ static bool rbd_obj_may_exist(struct rbd_obj_request *obj_req)
 		return true;
 	}
 
-	dout("%s %p objno %llu assuming dne\n", __func__, obj_req,
-	     obj_req->ex.oe_objno);
+	pr_debug("%s %p objno %llu assuming dne\n",
+		 __func__, obj_req, obj_req->ex.oe_objno);
 	return false;
 }
 
@@ -2854,8 +2855,8 @@ static int rbd_obj_read_from_parent(struct rbd_obj_request *obj_req)
 	rbd_img_capture_header(child_img_req);
 	up_read(&parent->header_rwsem);
 
-	dout("%s child_img_req %p for obj_req %p\n", __func__, child_img_req,
-	     obj_req);
+	pr_debug("%s child_img_req %p for obj_req %p\n",
+		 __func__, child_img_req, obj_req);
 
 	if (!rbd_img_is_write(img_req)) {
 		switch (img_req->data_type) {
@@ -2977,7 +2978,7 @@ static bool rbd_obj_write_is_noop(struct rbd_obj_request *obj_req)
 
 	if (!(obj_req->flags & RBD_OBJ_FLAG_MAY_EXIST) &&
 	    (obj_req->flags & RBD_OBJ_FLAG_NOOP_FOR_NONEXISTENT)) {
-		dout("%s %p noop for nonexistent\n", __func__, obj_req);
+		pr_debug("%s %p noop for nonexistent\n", __func__, obj_req);
 		return true;
 	}
 
@@ -3063,7 +3064,7 @@ static int rbd_obj_copyup_empty_snapc(struct rbd_obj_request *obj_req,
 	struct ceph_osd_request *osd_req;
 	int ret;
 
-	dout("%s obj_req %p bytes %u\n", __func__, obj_req, bytes);
+	pr_debug("%s obj_req %p bytes %u\n", __func__, obj_req, bytes);
 	rbd_assert(bytes > 0 && bytes != MODS_ONLY);
 
 	osd_req = __rbd_obj_add_osd_request(obj_req, &rbd_empty_snapc, 1);
@@ -3092,7 +3093,7 @@ static int rbd_obj_copyup_current_snapc(struct rbd_obj_request *obj_req,
 	int which = 0;
 	int ret;
 
-	dout("%s obj_req %p bytes %u\n", __func__, obj_req, bytes);
+	pr_debug("%s obj_req %p bytes %u\n", __func__, obj_req, bytes);
 
 	if (bytes != MODS_ONLY)
 		num_ops++; /* copyup */
@@ -3278,7 +3279,7 @@ static bool rbd_obj_advance_copyup(struct rbd_obj_request *obj_req, int *result)
 
 		if (is_zero_bvecs(obj_req->copyup_bvecs,
 				  rbd_obj_img_extents_bytes(obj_req))) {
-			dout("%s %p detected zeros\n", __func__, obj_req);
+			pr_debug("%s %p detected zeros\n", __func__, obj_req);
 			obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ZEROS;
 		}
 
@@ -3530,7 +3531,7 @@ static int rbd_img_exclusive_lock(struct rbd_img_request *img_req)
 	 * Note the use of mod_delayed_work() in rbd_acquire_lock()
 	 * and cancel_delayed_work() in wake_lock_waiters().
 	 */
-	dout("%s rbd_dev %p queueing lock_dwork\n", __func__, rbd_dev);
+	pr_debug("%s rbd_dev %p queueing lock_dwork\n", __func__, rbd_dev);
 	queue_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork, 0);
 	return 0;
 }
@@ -3679,9 +3680,10 @@ static struct rbd_client_id rbd_get_cid(struct rbd_device *rbd_dev)
 static void rbd_set_owner_cid(struct rbd_device *rbd_dev,
 			      const struct rbd_client_id *cid)
 {
-	dout("%s rbd_dev %p %llu-%llu -> %llu-%llu\n", __func__, rbd_dev,
-	     rbd_dev->owner_cid.gid, rbd_dev->owner_cid.handle,
-	     cid->gid, cid->handle);
+	pr_debug("%s rbd_dev %p %llu-%llu -> %llu-%llu\n",
+		 __func__, rbd_dev,
+		 rbd_dev->owner_cid.gid, rbd_dev->owner_cid.handle,
+		 cid->gid, cid->handle);
 	rbd_dev->owner_cid = *cid; /* struct */
 }
 
@@ -3759,7 +3761,7 @@ static int __rbd_notify_op_lock(struct rbd_device *rbd_dev,
 	int buf_size = sizeof(buf);
 	void *p = buf;
 
-	dout("%s rbd_dev %p notify_op %d\n", __func__, rbd_dev, notify_op);
+	pr_debug("%s rbd_dev %p notify_op %d\n", __func__, rbd_dev, notify_op);
 
 	/* encode *LockPayload NotifyMessage (op + ClientId) */
 	ceph_start_encoding(&p, 2, 1, buf_size - CEPH_ENCODING_START_BLK_LEN);
@@ -3801,7 +3803,7 @@ static int rbd_request_lock(struct rbd_device *rbd_dev)
 	bool lock_owner_responded = false;
 	int ret;
 
-	dout("%s rbd_dev %p\n", __func__, rbd_dev);
+	pr_debug("%s rbd_dev %p\n", __func__, rbd_dev);
 
 	ret = __rbd_notify_op_lock(rbd_dev, RBD_NOTIFY_OP_REQUEST_LOCK,
 				   &reply_pages, &reply_len);
@@ -3870,7 +3872,7 @@ static void wake_lock_waiters(struct rbd_device *rbd_dev, int result)
 {
 	struct rbd_img_request *img_req;
 
-	dout("%s rbd_dev %p result %d\n", __func__, rbd_dev, result);
+	pr_debug("%s rbd_dev %p result %d\n", __func__, rbd_dev, result);
 	lockdep_assert_held_write(&rbd_dev->lock_rwsem);
 
 	cancel_delayed_work(&rbd_dev->lock_dwork);
@@ -3900,7 +3902,7 @@ static int get_lock_owner_info(struct rbd_device *rbd_dev,
 	char *lock_tag;
 	int ret;
 
-	dout("%s rbd_dev %p\n", __func__, rbd_dev);
+	pr_debug("%s rbd_dev %p\n", __func__, rbd_dev);
 
 	ret = ceph_cls_lock_info(osdc, &rbd_dev->header_oid,
 				 &rbd_dev->header_oloc, RBD_LOCK_NAME,
@@ -3909,7 +3911,8 @@ static int get_lock_owner_info(struct rbd_device *rbd_dev,
 		return ret;
 
 	if (*num_lockers == 0) {
-		dout("%s rbd_dev %p no lockers detected\n", __func__, rbd_dev);
+		pr_debug("%s rbd_dev %p no lockers detected\n",
+			 __func__, rbd_dev);
 		goto out;
 	}
 
@@ -3965,15 +3968,15 @@ static int find_watcher(struct rbd_device *rbd_dev,
 				.handle = cookie,
 			};
 
-			dout("%s rbd_dev %p found cid %llu-%llu\n", __func__,
-			     rbd_dev, cid.gid, cid.handle);
+			pr_debug("%s rbd_dev %p found cid %llu-%llu\n",
+				 __func__, rbd_dev, cid.gid, cid.handle);
 			rbd_set_owner_cid(rbd_dev, &cid);
 			ret = 1;
 			goto out;
 		}
 	}
 
-	dout("%s rbd_dev %p no watchers\n", __func__, rbd_dev);
+	pr_debug("%s rbd_dev %p no watchers\n", __func__, rbd_dev);
 	ret = 0;
 out:
 	kfree(watchers);
@@ -4058,8 +4061,8 @@ static int rbd_try_acquire_lock(struct rbd_device *rbd_dev)
 	int ret;
 
 	down_read(&rbd_dev->lock_rwsem);
-	dout("%s rbd_dev %p read lock_state %d\n", __func__, rbd_dev,
-	     rbd_dev->lock_state);
+	pr_debug("%s rbd_dev %p read lock_state %d\n",
+		 __func__, rbd_dev, rbd_dev->lock_state);
 	if (__rbd_is_lock_owner(rbd_dev)) {
 		up_read(&rbd_dev->lock_rwsem);
 		return 0;
@@ -4067,8 +4070,8 @@ static int rbd_try_acquire_lock(struct rbd_device *rbd_dev)
 
 	up_read(&rbd_dev->lock_rwsem);
 	down_write(&rbd_dev->lock_rwsem);
-	dout("%s rbd_dev %p write lock_state %d\n", __func__, rbd_dev,
-	     rbd_dev->lock_state);
+	pr_debug("%s rbd_dev %p write lock_state %d\n",
+		 __func__, rbd_dev, rbd_dev->lock_state);
 	if (__rbd_is_lock_owner(rbd_dev)) {
 		up_write(&rbd_dev->lock_rwsem);
 		return 0;
@@ -4113,11 +4116,12 @@ static void rbd_acquire_lock(struct work_struct *work)
 					    struct rbd_device, lock_dwork);
 	int ret;
 
-	dout("%s rbd_dev %p\n", __func__, rbd_dev);
+	pr_debug("%s rbd_dev %p\n", __func__, rbd_dev);
 again:
 	ret = rbd_try_acquire_lock(rbd_dev);
 	if (ret <= 0) {
-		dout("%s rbd_dev %p ret %d - done\n", __func__, rbd_dev, ret);
+		pr_debug("%s rbd_dev %p ret %d - done\n",
+			 __func__, rbd_dev, ret);
 		return;
 	}
 
@@ -4138,8 +4142,8 @@ static void rbd_acquire_lock(struct work_struct *work)
 		 * lock owner acked, but resend if we don't see them
 		 * release the lock
 		 */
-		dout("%s rbd_dev %p requeuing lock_dwork\n", __func__,
-		     rbd_dev);
+		pr_debug("%s rbd_dev %p requeuing lock_dwork\n",
+			 __func__, rbd_dev);
 		mod_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork,
 		    msecs_to_jiffies(2 * RBD_NOTIFY_TIMEOUT * MSEC_PER_SEC));
 	}
@@ -4149,7 +4153,7 @@ static bool rbd_quiesce_lock(struct rbd_device *rbd_dev)
 {
 	bool need_wait;
 
-	dout("%s rbd_dev %p\n", __func__, rbd_dev);
+	pr_debug("%s rbd_dev %p\n", __func__, rbd_dev);
 	lockdep_assert_held_write(&rbd_dev->lock_rwsem);
 
 	if (rbd_dev->lock_state != RBD_LOCK_STATE_LOCKED)
@@ -4222,7 +4226,7 @@ static void maybe_kick_acquire(struct rbd_device *rbd_dev)
 {
 	bool have_requests;
 
-	dout("%s rbd_dev %p\n", __func__, rbd_dev);
+	pr_debug("%s rbd_dev %p\n", __func__, rbd_dev);
 	if (__rbd_is_lock_owner(rbd_dev))
 		return;
 
@@ -4230,7 +4234,8 @@ static void maybe_kick_acquire(struct rbd_device *rbd_dev)
 	have_requests = !list_empty(&rbd_dev->acquiring_list);
 	spin_unlock(&rbd_dev->lock_lists_lock);
 	if (have_requests || delayed_work_pending(&rbd_dev->lock_dwork)) {
-		dout("%s rbd_dev %p kicking lock_dwork\n", __func__, rbd_dev);
+		pr_debug("%s rbd_dev %p kicking lock_dwork\n",
+			 __func__, rbd_dev);
 		mod_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork, 0);
 	}
 }
@@ -4245,8 +4250,8 @@ static void rbd_handle_acquired_lock(struct rbd_device *rbd_dev, u8 struct_v,
 		cid.handle = ceph_decode_64(p);
 	}
 
-	dout("%s rbd_dev %p cid %llu-%llu\n", __func__, rbd_dev, cid.gid,
-	     cid.handle);
+	pr_debug("%s rbd_dev %p cid %llu-%llu\n",
+		 __func__, rbd_dev, cid.gid, cid.handle);
 	if (!rbd_cid_equal(&cid, &rbd_empty_cid)) {
 		down_write(&rbd_dev->lock_rwsem);
 		if (rbd_cid_equal(&cid, &rbd_dev->owner_cid)) {
@@ -4278,14 +4283,14 @@ static void rbd_handle_released_lock(struct rbd_device *rbd_dev, u8 struct_v,
 		cid.handle = ceph_decode_64(p);
 	}
 
-	dout("%s rbd_dev %p cid %llu-%llu\n", __func__, rbd_dev, cid.gid,
-	     cid.handle);
+	pr_debug("%s rbd_dev %p cid %llu-%llu\n",
+		 __func__, rbd_dev, cid.gid, cid.handle);
 	if (!rbd_cid_equal(&cid, &rbd_empty_cid)) {
 		down_write(&rbd_dev->lock_rwsem);
 		if (!rbd_cid_equal(&cid, &rbd_dev->owner_cid)) {
-			dout("%s rbd_dev %p unexpected owner, cid %llu-%llu != owner_cid %llu-%llu\n",
-			     __func__, rbd_dev, cid.gid, cid.handle,
-			     rbd_dev->owner_cid.gid, rbd_dev->owner_cid.handle);
+			pr_debug("%s rbd_dev %p unexpected owner, cid %llu-%llu != owner_cid %llu-%llu\n",
+				 __func__, rbd_dev, cid.gid, cid.handle,
+				 rbd_dev->owner_cid.gid, rbd_dev->owner_cid.handle);
 			up_write(&rbd_dev->lock_rwsem);
 			return;
 		}
@@ -4316,8 +4321,8 @@ static int rbd_handle_request_lock(struct rbd_device *rbd_dev, u8 struct_v,
 		cid.handle = ceph_decode_64(p);
 	}
 
-	dout("%s rbd_dev %p cid %llu-%llu\n", __func__, rbd_dev, cid.gid,
-	     cid.handle);
+	pr_debug("%s rbd_dev %p cid %llu-%llu\n",
+		 __func__, rbd_dev, cid.gid, cid.handle);
 	if (rbd_cid_equal(&cid, &my_cid))
 		return result;
 
@@ -4335,8 +4340,8 @@ static int rbd_handle_request_lock(struct rbd_device *rbd_dev, u8 struct_v,
 
 		if (rbd_dev->lock_state == RBD_LOCK_STATE_LOCKED) {
 			if (!rbd_dev->opts->exclusive) {
-				dout("%s rbd_dev %p queueing unlock_work\n",
-				     __func__, rbd_dev);
+				pr_debug("%s rbd_dev %p queueing unlock_work\n",
+					 __func__, rbd_dev);
 				queue_work(rbd_dev->task_wq,
 					   &rbd_dev->unlock_work);
 			} else {
@@ -4380,14 +4385,14 @@ static void __rbd_acknowledge_notify(struct rbd_device *rbd_dev,
 static void rbd_acknowledge_notify(struct rbd_device *rbd_dev, u64 notify_id,
 				   u64 cookie)
 {
-	dout("%s rbd_dev %p\n", __func__, rbd_dev);
+	pr_debug("%s rbd_dev %p\n", __func__, rbd_dev);
 	__rbd_acknowledge_notify(rbd_dev, notify_id, cookie, NULL);
 }
 
 static void rbd_acknowledge_notify_result(struct rbd_device *rbd_dev,
 					  u64 notify_id, u64 cookie, s32 result)
 {
-	dout("%s rbd_dev %p result %d\n", __func__, rbd_dev, result);
+	pr_debug("%s rbd_dev %p result %d\n", __func__, rbd_dev, result);
 	__rbd_acknowledge_notify(rbd_dev, notify_id, cookie, &result);
 }
 
@@ -4402,8 +4407,8 @@ static void rbd_watch_cb(void *arg, u64 notify_id, u64 cookie,
 	u32 notify_op;
 	int ret;
 
-	dout("%s rbd_dev %p cookie %llu notify_id %llu data_len %zu\n",
-	     __func__, rbd_dev, cookie, notify_id, data_len);
+	pr_debug("%s rbd_dev %p cookie %llu notify_id %llu data_len %zu\n",
+		 __func__, rbd_dev, cookie, notify_id, data_len);
 	if (data_len) {
 		ret = ceph_start_decoding(&p, end, 1, "NotifyMessage",
 					  &struct_v, &len);
@@ -4420,7 +4425,7 @@ static void rbd_watch_cb(void *arg, u64 notify_id, u64 cookie,
 		len = 0;
 	}
 
-	dout("%s rbd_dev %p notify_op %u\n", __func__, rbd_dev, notify_op);
+	pr_debug("%s rbd_dev %p notify_op %u\n", __func__, rbd_dev, notify_op);
 	switch (notify_op) {
 	case RBD_NOTIFY_OP_ACQUIRED_LOCK:
 		rbd_handle_acquired_lock(rbd_dev, struct_v, &p);
@@ -4486,7 +4491,7 @@ static int __rbd_register_watch(struct rbd_device *rbd_dev)
 	struct ceph_osd_linger_request *handle;
 
 	rbd_assert(!rbd_dev->watch_handle);
-	dout("%s rbd_dev %p\n", __func__, rbd_dev);
+	pr_debug("%s rbd_dev %p\n", __func__, rbd_dev);
 
 	handle = ceph_osdc_watch(osdc, &rbd_dev->header_oid,
 				 &rbd_dev->header_oloc, rbd_watch_cb,
@@ -4507,7 +4512,7 @@ static void __rbd_unregister_watch(struct rbd_device *rbd_dev)
 	int ret;
 
 	rbd_assert(rbd_dev->watch_handle);
-	dout("%s rbd_dev %p\n", __func__, rbd_dev);
+	pr_debug("%s rbd_dev %p\n", __func__, rbd_dev);
 
 	ret = ceph_osdc_unwatch(osdc, rbd_dev->watch_handle);
 	if (ret)
@@ -4536,7 +4541,7 @@ static int rbd_register_watch(struct rbd_device *rbd_dev)
 
 static void cancel_tasks_sync(struct rbd_device *rbd_dev)
 {
-	dout("%s rbd_dev %p\n", __func__, rbd_dev);
+	pr_debug("%s rbd_dev %p\n", __func__, rbd_dev);
 
 	cancel_work_sync(&rbd_dev->acquired_lock_work);
 	cancel_work_sync(&rbd_dev->released_lock_work);
@@ -4602,7 +4607,7 @@ static void rbd_reregister_watch(struct work_struct *work)
 					    struct rbd_device, watch_dwork);
 	int ret;
 
-	dout("%s rbd_dev %p\n", __func__, rbd_dev);
+	pr_debug("%s rbd_dev %p\n", __func__, rbd_dev);
 
 	mutex_lock(&rbd_dev->watch_mutex);
 	if (rbd_dev->watch_state != RBD_WATCH_STATE_ERROR) {
@@ -4713,7 +4718,7 @@ static void rbd_queue_workfn(struct work_struct *work)
 
 	/* Ignore/skip any zero-length requests */
 	if (!length) {
-		dout("%s: zero-length request\n", __func__);
+		pr_debug("%s: zero-length request\n", __func__);
 		result = 0;
 		goto err_img_request;
 	}
@@ -4732,8 +4737,9 @@ static void rbd_queue_workfn(struct work_struct *work)
 		goto err_img_request;
 	}
 
-	dout("%s rbd_dev %p img_req %p %s %llu~%llu\n", __func__, rbd_dev,
-	     img_request, obj_op_name(op_type), offset, length);
+	pr_debug("%s rbd_dev %p img_req %p %s %llu~%llu\n",
+		 __func__, rbd_dev, img_request,
+		 obj_op_name(op_type), offset, length);
 
 	if (op_type == OBJ_OP_DISCARD || op_type == OBJ_OP_ZEROOUT)
 		result = rbd_img_fill_nodata(img_request, offset, length);
@@ -4919,7 +4925,8 @@ static void rbd_dev_update_size(struct rbd_device *rbd_dev)
 	if (test_bit(RBD_DEV_FLAG_EXISTS, &rbd_dev->flags) &&
 	    !test_bit(RBD_DEV_FLAG_REMOVING, &rbd_dev->flags)) {
 		size = (sector_t)rbd_dev->mapping.size / SECTOR_SIZE;
-		dout("setting size to %llu sectors", (unsigned long long)size);
+		pr_debug("setting size to %llu sectors\n",
+			 (unsigned long long)size);
 		set_capacity(rbd_dev->disk, size);
 		revalidate_disk(rbd_dev->disk);
 	}
@@ -5454,7 +5461,8 @@ static struct rbd_device *rbd_dev_create(struct rbd_client *rbdc,
 	/* we have a ref from do_rbd_add() */
 	__module_get(THIS_MODULE);
 
-	dout("%s rbd_dev %p dev_id %d\n", __func__, rbd_dev, rbd_dev->dev_id);
+	pr_debug("%s rbd_dev %p dev_id %d\n",
+		 __func__, rbd_dev, rbd_dev->dev_id);
 	return rbd_dev;
 
 fail_dev_id:
@@ -5489,7 +5497,7 @@ static int _rbd_dev_v2_snap_size(struct rbd_device *rbd_dev, u64 snap_id,
 				  &rbd_dev->header_oloc, "get_size",
 				  &snapid, sizeof(snapid),
 				  &size_buf, sizeof(size_buf));
-	dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
+	pr_debug("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
 	if (ret < 0)
 		return ret;
 	if (ret < sizeof (size_buf))
@@ -5497,13 +5505,13 @@ static int _rbd_dev_v2_snap_size(struct rbd_device *rbd_dev, u64 snap_id,
 
 	if (order) {
 		*order = size_buf.order;
-		dout("  order %u", (unsigned int)*order);
+		pr_debug("order %u\n", (unsigned int)*order);
 	}
 	*snap_size = le64_to_cpu(size_buf.size);
 
-	dout("  snap_id 0x%016llx snap_size = %llu\n",
-		(unsigned long long)snap_id,
-		(unsigned long long)*snap_size);
+	pr_debug("snap_id 0x%016llx snap_size = %llu\n",
+		 (unsigned long long)snap_id,
+		 (unsigned long long)*snap_size);
 
 	return 0;
 }
@@ -5531,7 +5539,7 @@ static int rbd_dev_v2_object_prefix(struct rbd_device *rbd_dev)
 	ret = rbd_obj_method_sync(rbd_dev, &rbd_dev->header_oid,
 				  &rbd_dev->header_oloc, "get_object_prefix",
 				  NULL, 0, reply_buf, size);
-	dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
+	pr_debug("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
 	if (ret < 0)
 		goto out;
 
@@ -5544,7 +5552,7 @@ static int rbd_dev_v2_object_prefix(struct rbd_device *rbd_dev)
 		ret = PTR_ERR(rbd_dev->header.object_prefix);
 		rbd_dev->header.object_prefix = NULL;
 	} else {
-		dout("  object_prefix = %s\n", rbd_dev->header.object_prefix);
+		pr_debug("object_prefix = %s\n", rbd_dev->header.object_prefix);
 	}
 out:
 	kfree(reply_buf);
@@ -5573,7 +5581,7 @@ static int _rbd_dev_v2_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
 				  &rbd_dev->header_oloc, "get_features",
 				  &features_in, sizeof(features_in),
 				  &features_buf, sizeof(features_buf));
-	dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
+	pr_debug("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
 	if (ret < 0)
 		return ret;
 	if (ret < sizeof (features_buf))
@@ -5588,10 +5596,10 @@ static int _rbd_dev_v2_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
 
 	*snap_features = le64_to_cpu(features_buf.features);
 
-	dout("  snap_id 0x%016llx features = 0x%016llx incompat = 0x%016llx\n",
-		(unsigned long long)snap_id,
-		(unsigned long long)*snap_features,
-		(unsigned long long)le64_to_cpu(features_buf.incompat));
+	pr_debug("snap_id 0x%016llx features = 0x%016llx incompat = 0x%016llx\n",
+		 (unsigned long long)snap_id,
+		 (unsigned long long)*snap_features,
+		 (unsigned long long)le64_to_cpu(features_buf.incompat));
 
 	return 0;
 }
@@ -5795,9 +5803,9 @@ static int rbd_dev_v2_parent_info(struct rbd_device *rbd_dev)
 	if (ret)
 		goto out_err;
 
-	dout("%s pool_id %llu pool_ns %s image_id %s snap_id %llu has_overlap %d overlap %llu\n",
-	     __func__, pii.pool_id, pii.pool_ns, pii.image_id, pii.snap_id,
-	     pii.has_overlap, pii.overlap);
+	pr_debug("%s pool_id %llu pool_ns %s image_id %s snap_id %llu has_overlap %d overlap %llu\n",
+		 __func__, pii.pool_id, pii.pool_ns, pii.image_id, pii.snap_id,
+		 pii.has_overlap, pii.overlap);
 
 	if (pii.pool_id == CEPH_NOPOOL || !pii.has_overlap) {
 		/*
@@ -5890,7 +5898,7 @@ static int rbd_dev_v2_striping_info(struct rbd_device *rbd_dev)
 	ret = rbd_obj_method_sync(rbd_dev, &rbd_dev->header_oid,
 				&rbd_dev->header_oloc, "get_stripe_unit_count",
 				NULL, 0, &striping_info_buf, size);
-	dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
+	pr_debug("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
 	if (ret < 0)
 		return ret;
 	if (ret < size)
@@ -5963,7 +5971,8 @@ static char *rbd_dev_image_name(struct rbd_device *rbd_dev)
 	if (IS_ERR(image_name))
 		image_name = NULL;
 	else
-		dout("%s: name is %s len is %zd\n", __func__, image_name, len);
+		pr_debug("%s: name is %s len is %zd\n",
+			 __func__, image_name, len);
 out:
 	kfree(reply_buf);
 	kfree(image_id);
@@ -6135,7 +6144,7 @@ static int rbd_dev_v2_snap_context(struct rbd_device *rbd_dev)
 	ret = rbd_obj_method_sync(rbd_dev, &rbd_dev->header_oid,
 				  &rbd_dev->header_oloc, "get_snapcontext",
 				  NULL, 0, reply_buf, size);
-	dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
+	pr_debug("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
 	if (ret < 0)
 		goto out;
 
@@ -6172,8 +6181,8 @@ static int rbd_dev_v2_snap_context(struct rbd_device *rbd_dev)
 	ceph_put_snap_context(rbd_dev->header.snapc);
 	rbd_dev->header.snapc = snapc;
 
-	dout("  snap context seq = %llu, snap_count = %u\n",
-		(unsigned long long)seq, (unsigned int)snap_count);
+	pr_debug("  snap context seq = %llu, snap_count = %u\n",
+		 (unsigned long long)seq, (unsigned int)snap_count);
 out:
 	kfree(reply_buf);
 
@@ -6200,7 +6209,7 @@ static const char *rbd_dev_v2_snap_name(struct rbd_device *rbd_dev,
 	ret = rbd_obj_method_sync(rbd_dev, &rbd_dev->header_oid,
 				  &rbd_dev->header_oloc, "get_snapshot_name",
 				  &snapid, sizeof(snapid), reply_buf, size);
-	dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
+	pr_debug("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
 	if (ret < 0) {
 		snap_name = ERR_PTR(ret);
 		goto out;
@@ -6212,8 +6221,8 @@ static const char *rbd_dev_v2_snap_name(struct rbd_device *rbd_dev,
 	if (IS_ERR(snap_name))
 		goto out;
 
-	dout("  snap_id 0x%016llx snap_name = %s\n",
-		(unsigned long long)snap_id, snap_name);
+	pr_debug("  snap_id 0x%016llx snap_name = %s\n",
+		 (unsigned long long)snap_id, snap_name);
 out:
 	kfree(reply_buf);
 
@@ -6320,7 +6329,7 @@ static int rbd_parse_param(struct fs_parameter *param,
 		return ret;
 
 	token = __fs_parse(&log, rbd_parameters, param, &result);
-	dout("%s fs_parse '%s' token %d\n", __func__, param->key, token);
+	pr_debug("%s fs_parse '%s' token %d\n", __func__, param->key, token);
 	if (token < 0) {
 		if (token == -ENOPARAM)
 			return inval_plog(&log, "Unknown parameter '%s'",
@@ -6409,7 +6418,7 @@ static int rbd_parse_options(char *options, struct rbd_parse_opts_ctx *pctx)
 	char *key;
 	int ret = 0;
 
-	dout("%s '%s'\n", __func__, options);
+	pr_debug("%s '%s'\n", __func__, options);
 	while ((key = strsep(&options, ",")) != NULL) {
 		if (*key) {
 			struct fs_parameter param = {
@@ -6692,7 +6701,7 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
 	if (ret)
 		return ret;
 
-	dout("rbd id object name is %s\n", oid.name);
+	pr_debug("rbd id object name is %s\n", oid.name);
 
 	/* Response will be an encoded string, which includes a length */
 	size = sizeof (__le32) + RBD_IMAGE_ID_LEN_MAX;
@@ -6707,7 +6716,7 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
 	ret = rbd_obj_method_sync(rbd_dev, &oid, &rbd_dev->header_oloc,
 				  "get_id", NULL, 0,
 				  response, size);
-	dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
+	pr_debug("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
 	if (ret == -ENOENT) {
 		image_id = kstrdup("", GFP_KERNEL);
 		ret = image_id ? 0 : -ENOMEM;
@@ -6725,7 +6734,7 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
 
 	if (!ret) {
 		rbd_dev->spec->image_id = image_id;
-		dout("image_id is %s\n", image_id);
+		pr_debug("image_id is %s\n", image_id);
 	}
 out:
 	kfree(response);
@@ -7031,8 +7040,8 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 	if (ret)
 		goto err_out_probe;
 
-	dout("discovered format %u image, header name is %s\n",
-		rbd_dev->image_format, rbd_dev->header_oid.name);
+	pr_debug("discovered format %u image, header name is %s\n",
+		 rbd_dev->image_format, rbd_dev->header_oid.name);
 	return 0;
 
 err_out_probe:
-- 
2.26.0


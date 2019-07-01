Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B32F5B435
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 07:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfGAFe3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 01:34:29 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:23811 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727373AbfGAFe3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 01:34:29 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowABnNHYvmhldy33wAA--.1248S2;
        Mon, 01 Jul 2019 13:29:19 +0800 (CST)
Subject: Re: [PATCH 13/20] rbd: quiescing lock should wait for image requests
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
 <20190625144111.11270-14-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D199A2F.7010808@easystack.cn>
Date:   Mon, 1 Jul 2019 13:29:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20190625144111.11270-14-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowABnNHYvmhldy33wAA--.1248S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3GFWUuFy5uF45ZF15Jr18Krg_yoW3Kw4rp3
        yrJay3KFWUXr12qw1rGF15Xr4rWa18Ka9rWrySk3W7CF95Xrs2kF1IkFyjvFW3XrykArs7
        Gr45Xrs5Cr429rDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zKXHRAUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbidRDkeln5euZvfwAAsX
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 06/25/2019 10:41 PM, Ilya Dryomov wrote:
> Syncing OSD requests doesn't really work.  A single image request may
> be comprised of multiple object requests, each of which can go through
> a series of OSD requests (original, copyups, etc).  On top of that, the
> OSD cliest may be shared with other rbd devices.
>
> What we want is to ensure that all in-flight image requests complete.
> Introduce rbd_dev->running_list and block in RBD_LOCK_STATE_RELEASING
> until that happens.  New OSD requests may be started during this time.
>
> Note that __rbd_img_handle_request() acquires rbd_dev->lock_rwsem only
> if need_exclusive_lock() returns true.  This avoids a deadlock similar
> to the one outlined in the previous commit between unlock and I/O that
> doesn't require lock, such as a read with object-map feature disabled.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   drivers/block/rbd.c | 104 ++++++++++++++++++++++++++++++++++++++------
>   1 file changed, 90 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 5fcb4ebd981a..59d1fef35663 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -331,6 +331,7 @@ struct rbd_img_request {
>   		struct rbd_obj_request	*obj_request;	/* obj req initiator */
>   	};
>   
> +	struct list_head	lock_item;
>   	struct list_head	object_extents;	/* obj_req.ex structs */
>   
>   	struct mutex		state_mutex;
> @@ -410,6 +411,9 @@ struct rbd_device {
>   	struct work_struct	released_lock_work;
>   	struct delayed_work	lock_dwork;
>   	struct work_struct	unlock_work;
> +	spinlock_t		lock_lists_lock;
> +	struct list_head	running_list;
> +	struct completion	releasing_wait;
>   	wait_queue_head_t	lock_waitq;
>   
>   	struct workqueue_struct	*task_wq;
> @@ -1726,6 +1730,7 @@ static struct rbd_img_request *rbd_img_request_create(
>   	if (rbd_dev_parent_get(rbd_dev))
>   		img_request_layered_set(img_request);
>   
> +	INIT_LIST_HEAD(&img_request->lock_item);
>   	INIT_LIST_HEAD(&img_request->object_extents);
>   	mutex_init(&img_request->state_mutex);
>   	kref_init(&img_request->kref);
> @@ -1745,6 +1750,7 @@ static void rbd_img_request_destroy(struct kref *kref)
>   
>   	dout("%s: img %p\n", __func__, img_request);
>   
> +	WARN_ON(!list_empty(&img_request->lock_item));
>   	for_each_obj_request_safe(img_request, obj_request, next_obj_request)
>   		rbd_img_obj_request_del(img_request, obj_request);
>   
> @@ -2872,6 +2878,50 @@ static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result)
>   		rbd_img_handle_request(obj_req->img_request, result);
>   }
>   
> +static bool need_exclusive_lock(struct rbd_img_request *img_req)
> +{
> +	struct rbd_device *rbd_dev = img_req->rbd_dev;
> +
> +	if (!(rbd_dev->header.features & RBD_FEATURE_EXCLUSIVE_LOCK))
> +		return false;
> +
> +	if (rbd_dev->spec->snap_id != CEPH_NOSNAP)
> +		return false;
> +
> +	rbd_assert(!test_bit(IMG_REQ_CHILD, &img_req->flags));
> +	if (rbd_dev->opts->lock_on_read)
> +		return true;
> +
> +	return rbd_img_is_write(img_req);
> +}
> +
> +static void rbd_lock_add_request(struct rbd_img_request *img_req)
> +{
> +	struct rbd_device *rbd_dev = img_req->rbd_dev;
> +
> +	lockdep_assert_held(&rbd_dev->lock_rwsem);
> +	spin_lock(&rbd_dev->lock_lists_lock);
> +	rbd_assert(list_empty(&img_req->lock_item));
> +	list_add_tail(&img_req->lock_item, &rbd_dev->running_list);
> +	spin_unlock(&rbd_dev->lock_lists_lock);
> +}
> +
> +static void rbd_lock_del_request(struct rbd_img_request *img_req)
> +{
> +	struct rbd_device *rbd_dev = img_req->rbd_dev;
> +	bool need_wakeup;
> +
> +	lockdep_assert_held(&rbd_dev->lock_rwsem);
> +	spin_lock(&rbd_dev->lock_lists_lock);
> +	rbd_assert(!list_empty(&img_req->lock_item));
> +	list_del_init(&img_req->lock_item);
> +	need_wakeup = (rbd_dev->lock_state == RBD_LOCK_STATE_RELEASING &&
> +		       list_empty(&rbd_dev->running_list));
> +	spin_unlock(&rbd_dev->lock_lists_lock);
> +	if (need_wakeup)
> +		complete(&rbd_dev->releasing_wait);
> +}
> +
>   static void rbd_img_object_requests(struct rbd_img_request *img_req)
>   {
>   	struct rbd_obj_request *obj_req;
> @@ -2927,9 +2977,19 @@ static bool __rbd_img_handle_request(struct rbd_img_request *img_req,
>   	struct rbd_device *rbd_dev = img_req->rbd_dev;
>   	bool done;
>   
> -	mutex_lock(&img_req->state_mutex);
> -	done = rbd_img_advance(img_req, result);
> -	mutex_unlock(&img_req->state_mutex);
> +	if (need_exclusive_lock(img_req)) {
> +		down_read(&rbd_dev->lock_rwsem);
> +		mutex_lock(&img_req->state_mutex);
> +		done = rbd_img_advance(img_req, result);
> +		if (done)
> +			rbd_lock_del_request(img_req);
> +		mutex_unlock(&img_req->state_mutex);
> +		up_read(&rbd_dev->lock_rwsem);
> +	} else {
> +		mutex_lock(&img_req->state_mutex);
> +		done = rbd_img_advance(img_req, result);
> +		mutex_unlock(&img_req->state_mutex);
> +	}
>   
>   	if (done && *result) {
>   		rbd_assert(*result < 0);
> @@ -3413,30 +3473,40 @@ static void rbd_acquire_lock(struct work_struct *work)
>   
>   static bool rbd_quiesce_lock(struct rbd_device *rbd_dev)
>   {
> +	bool need_wait;
> +
>   	dout("%s rbd_dev %p\n", __func__, rbd_dev);
>   	lockdep_assert_held_exclusive(&rbd_dev->lock_rwsem);
>   
>   	if (rbd_dev->lock_state != RBD_LOCK_STATE_LOCKED)
>   		return false;
>   
> -	rbd_dev->lock_state = RBD_LOCK_STATE_RELEASING;
> -	downgrade_write(&rbd_dev->lock_rwsem);
>   	/*
>   	 * Ensure that all in-flight IO is flushed.
> -	 *
> -	 * FIXME: ceph_osdc_sync() flushes the entire OSD client, which
> -	 * may be shared with other devices.
>   	 */
> -	ceph_osdc_sync(&rbd_dev->rbd_client->client->osdc);
> +	rbd_dev->lock_state = RBD_LOCK_STATE_RELEASING;
> +	rbd_assert(!completion_done(&rbd_dev->releasing_wait));
> +	need_wait = !list_empty(&rbd_dev->running_list);
> +	downgrade_write(&rbd_dev->lock_rwsem);
> +	if (need_wait)
> +		wait_for_completion(&rbd_dev->releasing_wait);
>   	up_read(&rbd_dev->lock_rwsem);
>   
>   	down_write(&rbd_dev->lock_rwsem);
>   	if (rbd_dev->lock_state != RBD_LOCK_STATE_RELEASING)
>   		return false;
>   
> +	rbd_assert(list_empty(&rbd_dev->running_list));
>   	return true;
>   }
>   
> +static void __rbd_release_lock(struct rbd_device *rbd_dev)
> +{
> +	rbd_assert(list_empty(&rbd_dev->running_list));
> +
> +	rbd_unlock(rbd_dev);
> +}
> +
>   /*
>    * lock_rwsem must be held for write
>    */
> @@ -3445,7 +3515,7 @@ static void rbd_release_lock(struct rbd_device *rbd_dev)
>   	if (!rbd_quiesce_lock(rbd_dev))
>   		return;
>   
> -	rbd_unlock(rbd_dev);
> +	__rbd_release_lock(rbd_dev);
>   
>   	/*
>   	 * Give others a chance to grab the lock - we would re-acquire
> @@ -3819,7 +3889,7 @@ static void rbd_reacquire_lock(struct rbd_device *rbd_dev)
>   		 * Lock cookie cannot be updated on older OSDs, so do
>   		 * a manual release and queue an acquire.
>   		 */
> -		rbd_unlock(rbd_dev);
> +		__rbd_release_lock(rbd_dev);
>   		queue_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork, 0);
>   	} else {
>   		__rbd_lock(rbd_dev, cookie);
> @@ -4085,9 +4155,12 @@ static void rbd_queue_workfn(struct work_struct *work)
>   	if (result)
>   		goto err_img_request;
>   
> -	rbd_img_handle_request(img_request, 0);
> -	if (must_be_locked)
> +	if (must_be_locked) {
> +		rbd_lock_add_request(img_request);
>   		up_read(&rbd_dev->lock_rwsem);
> +	}
> +
> +	rbd_img_handle_request(img_request, 0);
>   	return;
>   
>   err_img_request:
> @@ -4761,6 +4834,9 @@ static struct rbd_device *__rbd_dev_create(struct rbd_client *rbdc,
>   	INIT_WORK(&rbd_dev->released_lock_work, rbd_notify_released_lock);
>   	INIT_DELAYED_WORK(&rbd_dev->lock_dwork, rbd_acquire_lock);
>   	INIT_WORK(&rbd_dev->unlock_work, rbd_release_lock_work);
> +	spin_lock_init(&rbd_dev->lock_lists_lock);
> +	INIT_LIST_HEAD(&rbd_dev->running_list);
> +	init_completion(&rbd_dev->releasing_wait);
>   	init_waitqueue_head(&rbd_dev->lock_waitq);
>   
>   	rbd_dev->dev.bus = &rbd_bus_type;
> @@ -5777,7 +5853,7 @@ static void rbd_dev_image_unlock(struct rbd_device *rbd_dev)
>   {
>   	down_write(&rbd_dev->lock_rwsem);
>   	if (__rbd_is_lock_owner(rbd_dev))
> -		rbd_unlock(rbd_dev);
> +		__rbd_release_lock(rbd_dev);
>   	up_write(&rbd_dev->lock_rwsem);
>   }
>   



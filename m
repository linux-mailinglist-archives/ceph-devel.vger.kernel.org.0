Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3625B429
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 07:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfGAFdu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 01:33:50 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22879 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbfGAFdu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 01:33:50 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAA39roBmhldMHzwAA--.1238S2;
        Mon, 01 Jul 2019 13:28:33 +0800 (CST)
Subject: Re: [PATCH 05/20] rbd: introduce image request state machine
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
 <20190625144111.11270-6-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D199A01.6020608@easystack.cn>
Date:   Mon, 1 Jul 2019 13:28:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20190625144111.11270-6-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowAA39roBmhldMHzwAA--.1238S2
X-Coremail-Antispam: 1Uf129KBjvJXoWfGw4rCw4DZF18Ar1xZr4kXrb_yoWkGF43pa
        15XF42krs8X3W8Jr4rK3ykXr13Wr4xAFW7Z3yFk34fGF1kWa1vyF18GFyjvrW3ZrWkXr4f
        Gr4qqrs7ur12qFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JU873kUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbibQLkellZul2WigAAsK
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 06/25/2019 10:40 PM, Ilya Dryomov wrote:
> Make it possible to schedule image requests on a workqueue.  This fixes
> parent chain recursion added in the previous commit and lays the ground
> for exclusive lock wait/wake improvements.
>
> The "wait for pending subrequests and report first nonzero result" code
> is generalized to be used by object request state machine.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   drivers/block/rbd.c | 194 +++++++++++++++++++++++++++++++-------------
>   1 file changed, 137 insertions(+), 57 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 9c6be82353c0..51dd1b99c242 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -203,6 +203,11 @@ struct rbd_client {
>   	struct list_head	node;
>   };
>   
> +struct pending_result {
> +	int			result;		/* first nonzero result */
> +	int			num_pending;
> +};
> +
>   struct rbd_img_request;
>   
>   enum obj_request_type {
> @@ -295,11 +300,18 @@ enum img_req_flags {
>   	IMG_REQ_LAYERED,	/* ENOENT handling: normal = 0, layered = 1 */
>   };
>   
> +enum rbd_img_state {
> +	RBD_IMG_START = 1,
> +	__RBD_IMG_OBJECT_REQUESTS,
> +	RBD_IMG_OBJECT_REQUESTS,
> +};
> +
>   struct rbd_img_request {
>   	struct rbd_device	*rbd_dev;
>   	enum obj_operation_type	op_type;
>   	enum obj_request_type	data_type;
>   	unsigned long		flags;
> +	enum rbd_img_state	state;
>   	union {
>   		u64			snap_id;	/* for reads */
>   		struct ceph_snap_context *snapc;	/* for writes */
> @@ -308,12 +320,13 @@ struct rbd_img_request {
>   		struct request		*rq;		/* block request */
>   		struct rbd_obj_request	*obj_request;	/* obj req initiator */
>   	};
> -	spinlock_t		completion_lock;
> -	int			result;	/* first nonzero obj_request result */
>   
>   	struct list_head	object_extents;	/* obj_req.ex structs */
> -	u32			pending_count;
>   
> +	struct mutex		state_mutex;
> +	struct pending_result	pending;
> +	struct work_struct	work;
> +	int			work_result;
>   	struct kref		kref;
>   };
>   
> @@ -592,6 +605,23 @@ static int _rbd_dev_v2_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
>   		u64 *snap_features);
>   
>   static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result);
> +static void rbd_img_handle_request(struct rbd_img_request *img_req, int result);
> +
> +/*
> + * Return true if nothing else is pending.
> + */
> +static bool pending_result_dec(struct pending_result *pending, int *result)
> +{
> +	rbd_assert(pending->num_pending > 0);
> +
> +	if (*result && !pending->result)
> +		pending->result = *result;
> +	if (--pending->num_pending)
> +		return false;
> +
> +	*result = pending->result;
> +	return true;
> +}
>   
>   static int rbd_open(struct block_device *bdev, fmode_t mode)
>   {
> @@ -1350,13 +1380,6 @@ static void rbd_obj_request_put(struct rbd_obj_request *obj_request)
>   	kref_put(&obj_request->kref, rbd_obj_request_destroy);
>   }
>   
> -static void rbd_img_request_get(struct rbd_img_request *img_request)
> -{
> -	dout("%s: img %p (was %d)\n", __func__, img_request,
> -	     kref_read(&img_request->kref));
> -	kref_get(&img_request->kref);
> -}
> -
>   static void rbd_img_request_destroy(struct kref *kref);
>   static void rbd_img_request_put(struct rbd_img_request *img_request)
>   {
> @@ -1373,7 +1396,6 @@ static inline void rbd_img_obj_request_add(struct rbd_img_request *img_request,
>   
>   	/* Image request now owns object's original reference */
>   	obj_request->img_request = img_request;
> -	img_request->pending_count++;
>   	dout("%s: img %p obj %p\n", __func__, img_request, obj_request);
>   }
>   
> @@ -1694,8 +1716,8 @@ static struct rbd_img_request *rbd_img_request_create(
>   	if (rbd_dev_parent_get(rbd_dev))
>   		img_request_layered_set(img_request);
>   
> -	spin_lock_init(&img_request->completion_lock);
>   	INIT_LIST_HEAD(&img_request->object_extents);
> +	mutex_init(&img_request->state_mutex);
>   	kref_init(&img_request->kref);
>   
>   	dout("%s: rbd_dev %p %s -> img %p\n", __func__, rbd_dev,
> @@ -2061,7 +2083,6 @@ static int __rbd_img_fill_request(struct rbd_img_request *img_req)
>   		if (ret < 0)
>   			return ret;
>   		if (ret > 0) {
> -			img_req->pending_count--;
>   			rbd_img_obj_request_del(img_req, obj_req);
>   			continue;
>   		}
> @@ -2071,6 +2092,7 @@ static int __rbd_img_fill_request(struct rbd_img_request *img_req)
>   			return ret;
>   	}
>   
> +	img_req->state = RBD_IMG_START;
>   	return 0;
>   }
>   
> @@ -2359,17 +2381,19 @@ static int rbd_img_fill_from_bvecs(struct rbd_img_request *img_req,
>   					 &it);
>   }
>   
> -static void rbd_img_request_submit(struct rbd_img_request *img_request)
> +static void rbd_img_handle_request_work(struct work_struct *work)
>   {
> -	struct rbd_obj_request *obj_request;
> +	struct rbd_img_request *img_req =
> +	    container_of(work, struct rbd_img_request, work);
>   
> -	dout("%s: img %p\n", __func__, img_request);
> -
> -	rbd_img_request_get(img_request);
> -	for_each_obj_request(img_request, obj_request)
> -		rbd_obj_handle_request(obj_request, 0);
> +	rbd_img_handle_request(img_req, img_req->work_result);
> +}
>   
> -	rbd_img_request_put(img_request);
> +static void rbd_img_schedule(struct rbd_img_request *img_req, int result)
> +{
> +	INIT_WORK(&img_req->work, rbd_img_handle_request_work);
> +	img_req->work_result = result;
> +	queue_work(rbd_wq, &img_req->work);
>   }
>   
>   static int rbd_obj_read_object(struct rbd_obj_request *obj_req)
> @@ -2421,7 +2445,8 @@ static int rbd_obj_read_from_parent(struct rbd_obj_request *obj_req)
>   		return ret;
>   	}
>   
> -	rbd_img_request_submit(child_img_req);
> +	/* avoid parent chain recursion */
> +	rbd_img_schedule(child_img_req, 0);
>   	return 0;
>   }
>   
> @@ -2756,6 +2781,7 @@ static bool __rbd_obj_handle_request(struct rbd_obj_request *obj_req,
>   				     int *result)
>   {
>   	struct rbd_img_request *img_req = obj_req->img_request;
> +	struct rbd_device *rbd_dev = img_req->rbd_dev;
>   	bool done;
>   
>   	mutex_lock(&obj_req->state_mutex);
> @@ -2765,59 +2791,113 @@ static bool __rbd_obj_handle_request(struct rbd_obj_request *obj_req,
>   		done = rbd_obj_advance_write(obj_req, result);
>   	mutex_unlock(&obj_req->state_mutex);
>   
> +	if (done && *result) {
> +		rbd_assert(*result < 0);
> +		rbd_warn(rbd_dev, "%s at objno %llu %llu~%llu result %d",
> +			 obj_op_name(img_req->op_type), obj_req->ex.oe_objno,
> +			 obj_req->ex.oe_off, obj_req->ex.oe_len, *result);
> +	}
>   	return done;
>   }
>   
> -static void rbd_obj_end_request(struct rbd_obj_request *obj_req, int result)
> +/*
> + * This is open-coded in rbd_img_handle_request() to avoid parent chain
> + * recursion.
> + */
> +static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result)
> +{
> +	if (__rbd_obj_handle_request(obj_req, &result))
> +		rbd_img_handle_request(obj_req->img_request, result);
> +}
> +
> +static void rbd_img_object_requests(struct rbd_img_request *img_req)
>   {
> -	struct rbd_img_request *img_req = obj_req->img_request;
> +	struct rbd_obj_request *obj_req;
>   
> -	rbd_assert(result <= 0);
> -	if (!result)
> -		return;
> +	rbd_assert(!img_req->pending.result && !img_req->pending.num_pending);
> +
> +	for_each_obj_request(img_req, obj_req) {
> +		int result = 0;
>   
> -	rbd_warn(img_req->rbd_dev, "%s at objno %llu %llu~%llu result %d",
> -		 obj_op_name(img_req->op_type), obj_req->ex.oe_objno,
> -		 obj_req->ex.oe_off, obj_req->ex.oe_len, result);
> -	if (!img_req->result)
> -		img_req->result = result;
> +		if (__rbd_obj_handle_request(obj_req, &result)) {
> +			if (result) {
> +				img_req->pending.result = result;
> +				return;
> +			}
> +		} else {
> +			img_req->pending.num_pending++;
> +		}
> +	}
>   }
>   
> -static void rbd_img_end_request(struct rbd_img_request *img_req)
> +static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
>   {
> -	rbd_assert(!test_bit(IMG_REQ_CHILD, &img_req->flags));
> +again:
> +	switch (img_req->state) {
> +	case RBD_IMG_START:
> +		rbd_assert(!*result);
>   
> -	blk_mq_end_request(img_req->rq,
> -			   errno_to_blk_status(img_req->result));
> -	rbd_img_request_put(img_req);
> +		rbd_img_object_requests(img_req);
> +		if (!img_req->pending.num_pending) {
> +			*result = img_req->pending.result;
> +			img_req->state = RBD_IMG_OBJECT_REQUESTS;
> +			goto again;
> +		}
> +		img_req->state = __RBD_IMG_OBJECT_REQUESTS;
> +		return false;
> +	case __RBD_IMG_OBJECT_REQUESTS:
> +		if (!pending_result_dec(&img_req->pending, result))
> +			return false;
> +		/* fall through */
> +	case RBD_IMG_OBJECT_REQUESTS:
> +		return true;
> +	default:
> +		BUG();
> +	}
>   }
>   
> -static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result)
> +/*
> + * Return true if @img_req is completed.
> + */
> +static bool __rbd_img_handle_request(struct rbd_img_request *img_req,
> +				     int *result)
>   {
> -	struct rbd_img_request *img_req;
> +	struct rbd_device *rbd_dev = img_req->rbd_dev;
> +	bool done;
>   
> -again:
> -	if (!__rbd_obj_handle_request(obj_req, &result))
> -		return;
> +	mutex_lock(&img_req->state_mutex);
> +	done = rbd_img_advance(img_req, result);
> +	mutex_unlock(&img_req->state_mutex);
>   
> -	img_req = obj_req->img_request;
> -	spin_lock(&img_req->completion_lock);
> -	rbd_obj_end_request(obj_req, result);
> -	rbd_assert(img_req->pending_count);
> -	if (--img_req->pending_count) {
> -		spin_unlock(&img_req->completion_lock);
> -		return;
> +	if (done && *result) {
> +		rbd_assert(*result < 0);
> +		rbd_warn(rbd_dev, "%s%s result %d",
> +		      test_bit(IMG_REQ_CHILD, &img_req->flags) ? "child " : "",
> +		      obj_op_name(img_req->op_type), *result);
>   	}
> +	return done;
> +}
> +
> +static void rbd_img_handle_request(struct rbd_img_request *img_req, int result)
> +{
> +again:
> +	if (!__rbd_img_handle_request(img_req, &result))
> +		return;
>   
> -	spin_unlock(&img_req->completion_lock);
> -	rbd_assert(img_req->result <= 0);
>   	if (test_bit(IMG_REQ_CHILD, &img_req->flags)) {
> -		obj_req = img_req->obj_request;
> -		result = img_req->result;
> +		struct rbd_obj_request *obj_req = img_req->obj_request;
> +
>   		rbd_img_request_put(img_req);
> -		goto again;
> +		if (__rbd_obj_handle_request(obj_req, &result)) {
> +			img_req = obj_req->img_request;
> +			goto again;
> +		}
> +	} else {
> +		struct request *rq = img_req->rq;
> +
> +		rbd_img_request_put(img_req);
> +		blk_mq_end_request(rq, errno_to_blk_status(result));
>   	}
> -	rbd_img_end_request(img_req);
>   }
>   
>   static const struct rbd_client_id rbd_empty_cid;
> @@ -3933,10 +4013,10 @@ static void rbd_queue_workfn(struct work_struct *work)
>   	else
>   		result = rbd_img_fill_from_bio(img_request, offset, length,
>   					       rq->bio);
> -	if (result || !img_request->pending_count)
> +	if (result)
>   		goto err_img_request;
>   
> -	rbd_img_request_submit(img_request);
> +	rbd_img_handle_request(img_request, 0);
>   	if (must_be_locked)
>   		up_read(&rbd_dev->lock_rwsem);
>   	return;



Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24B125B424
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 07:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbfGAFdQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 01:33:16 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:21983 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfGAFdQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 01:33:16 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jul 2019 01:33:13 EDT
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowACnkbDcmRldC3vwAA--.1130S2;
        Mon, 01 Jul 2019 13:27:56 +0800 (CST)
Subject: Re: [PATCH 01/20] rbd: get rid of obj_req->xferred, obj_req->result
 and img_req->xferred
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
 <20190625144111.11270-2-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D1999DC.4030108@easystack.cn>
Date:   Mon, 1 Jul 2019 13:27:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20190625144111.11270-2-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowACnkbDcmRldC3vwAA--.1130S2
X-Coremail-Antispam: 1Uf129KBjvAXoWfJry7ZF4rCr1xCFWDAFWUArb_yoW8Jr1xKo
        Z3Xry7Ja1ktF9rKw1kW395t3WkArWIkF13Zrs5Ga15urs2grWagw17Gr43Ja43ZFyFgry8
        uw48Jasakr18A3y5n29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRCmhwUUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbibRzkellZul2V2wAAsG
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 06/25/2019 10:40 PM, Ilya Dryomov wrote:
> obj_req->xferred and img_req->xferred don't bring any value.  The
> former is used for short reads and has to be set to obj_req->ex.oe_len
> after that and elsewhere.  The latter is just an aggregate.
>
> Use result for short reads (>=0 - number of bytes read, <0 - error) and
> pass it around explicitly.  No need to store it in obj_req.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Looks good. As we don't need partial complete (some driver call 
blk_update_request() for partial reading)
in rbd driver at all, img_req->xfereed really don't bring any value.

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   drivers/block/rbd.c | 149 +++++++++++++++++---------------------------
>   1 file changed, 58 insertions(+), 91 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index e5009a34f9c2..a9b0b23148f9 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -276,9 +276,6 @@ struct rbd_obj_request {
>   
>   	struct ceph_osd_request	*osd_req;
>   
> -	u64			xferred;	/* bytes transferred */
> -	int			result;
> -
>   	struct kref		kref;
>   };
>   
> @@ -301,7 +298,6 @@ struct rbd_img_request {
>   		struct rbd_obj_request	*obj_request;	/* obj req initiator */
>   	};
>   	spinlock_t		completion_lock;
> -	u64			xferred;/* aggregate bytes transferred */
>   	int			result;	/* first nonzero obj_request result */
>   
>   	struct list_head	object_extents;	/* obj_req.ex structs */
> @@ -584,6 +580,8 @@ static int _rbd_dev_v2_snap_size(struct rbd_device *rbd_dev, u64 snap_id,
>   static int _rbd_dev_v2_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
>   		u64 *snap_features);
>   
> +static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result);
> +
>   static int rbd_open(struct block_device *bdev, fmode_t mode)
>   {
>   	struct rbd_device *rbd_dev = bdev->bd_disk->private_data;
> @@ -1317,6 +1315,8 @@ static void zero_bvecs(struct ceph_bvec_iter *bvec_pos, u32 off, u32 bytes)
>   static void rbd_obj_zero_range(struct rbd_obj_request *obj_req, u32 off,
>   			       u32 bytes)
>   {
> +	dout("%s %p data buf %u~%u\n", __func__, obj_req, off, bytes);
> +
>   	switch (obj_req->img_request->data_type) {
>   	case OBJ_REQUEST_BIO:
>   		zero_bios(&obj_req->bio_pos, off, bytes);
> @@ -1457,28 +1457,26 @@ static bool rbd_img_is_write(struct rbd_img_request *img_req)
>   	}
>   }
>   
> -static void rbd_obj_handle_request(struct rbd_obj_request *obj_req);
> -
>   static void rbd_osd_req_callback(struct ceph_osd_request *osd_req)
>   {
>   	struct rbd_obj_request *obj_req = osd_req->r_priv;
> +	int result;
>   
>   	dout("%s osd_req %p result %d for obj_req %p\n", __func__, osd_req,
>   	     osd_req->r_result, obj_req);
>   	rbd_assert(osd_req == obj_req->osd_req);
>   
> -	obj_req->result = osd_req->r_result < 0 ? osd_req->r_result : 0;
> -	if (!obj_req->result && !rbd_img_is_write(obj_req->img_request))
> -		obj_req->xferred = osd_req->r_result;
> +	/*
> +	 * Writes aren't allowed to return a data payload.  In some
> +	 * guarded write cases (e.g. stat + zero on an empty object)
> +	 * a stat response makes it through, but we don't care.
> +	 */
> +	if (osd_req->r_result > 0 && rbd_img_is_write(obj_req->img_request))
> +		result = 0;
>   	else
> -		/*
> -		 * Writes aren't allowed to return a data payload.  In some
> -		 * guarded write cases (e.g. stat + zero on an empty object)
> -		 * a stat response makes it through, but we don't care.
> -		 */
> -		obj_req->xferred = 0;
> +		result = osd_req->r_result;
>   
> -	rbd_obj_handle_request(obj_req);
> +	rbd_obj_handle_request(obj_req, result);
>   }
>   
>   static void rbd_osd_req_format_read(struct rbd_obj_request *obj_request)
> @@ -2041,7 +2039,6 @@ static int __rbd_img_fill_request(struct rbd_img_request *img_req)
>   		if (ret < 0)
>   			return ret;
>   		if (ret > 0) {
> -			img_req->xferred += obj_req->ex.oe_len;
>   			img_req->pending_count--;
>   			rbd_img_obj_request_del(img_req, obj_req);
>   			continue;
> @@ -2400,17 +2397,17 @@ static int rbd_obj_read_from_parent(struct rbd_obj_request *obj_req)
>   	return 0;
>   }
>   
> -static bool rbd_obj_handle_read(struct rbd_obj_request *obj_req)
> +static bool rbd_obj_handle_read(struct rbd_obj_request *obj_req, int *result)
>   {
>   	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>   	int ret;
>   
> -	if (obj_req->result == -ENOENT &&
> +	if (*result == -ENOENT &&
>   	    rbd_dev->parent_overlap && !obj_req->tried_parent) {
>   		/* reverse map this object extent onto the parent */
>   		ret = rbd_obj_calc_img_extents(obj_req, false);
>   		if (ret) {
> -			obj_req->result = ret;
> +			*result = ret;
>   			return true;
>   		}
>   
> @@ -2418,7 +2415,7 @@ static bool rbd_obj_handle_read(struct rbd_obj_request *obj_req)
>   			obj_req->tried_parent = true;
>   			ret = rbd_obj_read_from_parent(obj_req);
>   			if (ret) {
> -				obj_req->result = ret;
> +				*result = ret;
>   				return true;
>   			}
>   			return false;
> @@ -2428,16 +2425,18 @@ static bool rbd_obj_handle_read(struct rbd_obj_request *obj_req)
>   	/*
>   	 * -ENOENT means a hole in the image -- zero-fill the entire
>   	 * length of the request.  A short read also implies zero-fill
> -	 * to the end of the request.  In both cases we update xferred
> -	 * count to indicate the whole request was satisfied.
> +	 * to the end of the request.
>   	 */
> -	if (obj_req->result == -ENOENT ||
> -	    (!obj_req->result && obj_req->xferred < obj_req->ex.oe_len)) {
> -		rbd_assert(!obj_req->xferred || !obj_req->result);
> -		rbd_obj_zero_range(obj_req, obj_req->xferred,
> -				   obj_req->ex.oe_len - obj_req->xferred);
> -		obj_req->result = 0;
> -		obj_req->xferred = obj_req->ex.oe_len;
> +	if (*result == -ENOENT) {
> +		rbd_obj_zero_range(obj_req, 0, obj_req->ex.oe_len);
> +		*result = 0;
> +	} else if (*result >= 0) {
> +		if (*result < obj_req->ex.oe_len)
> +			rbd_obj_zero_range(obj_req, *result,
> +					   obj_req->ex.oe_len - *result);
> +		else
> +			rbd_assert(*result == obj_req->ex.oe_len);
> +		*result = 0;
>   	}
>   
>   	return true;
> @@ -2635,14 +2634,13 @@ static int rbd_obj_handle_write_guard(struct rbd_obj_request *obj_req)
>   	return rbd_obj_read_from_parent(obj_req);
>   }
>   
> -static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req)
> +static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req, int *result)
>   {
>   	int ret;
>   
>   	switch (obj_req->write_state) {
>   	case RBD_OBJ_WRITE_GUARD:
> -		rbd_assert(!obj_req->xferred);
> -		if (obj_req->result == -ENOENT) {
> +		if (*result == -ENOENT) {
>   			/*
>   			 * The target object doesn't exist.  Read the data for
>   			 * the entire target object up to the overlap point (if
> @@ -2650,7 +2648,7 @@ static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req)
>   			 */
>   			ret = rbd_obj_handle_write_guard(obj_req);
>   			if (ret) {
> -				obj_req->result = ret;
> +				*result = ret;
>   				return true;
>   			}
>   			return false;
> @@ -2658,33 +2656,26 @@ static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req)
>   		/* fall through */
>   	case RBD_OBJ_WRITE_FLAT:
>   	case RBD_OBJ_WRITE_COPYUP_OPS:
> -		if (!obj_req->result)
> -			/*
> -			 * There is no such thing as a successful short
> -			 * write -- indicate the whole request was satisfied.
> -			 */
> -			obj_req->xferred = obj_req->ex.oe_len;
>   		return true;
>   	case RBD_OBJ_WRITE_READ_FROM_PARENT:
> -		if (obj_req->result)
> +		if (*result < 0)
>   			return true;
>   
> -		rbd_assert(obj_req->xferred);
> -		ret = rbd_obj_issue_copyup(obj_req, obj_req->xferred);
> +		rbd_assert(*result);
> +		ret = rbd_obj_issue_copyup(obj_req, *result);
>   		if (ret) {
> -			obj_req->result = ret;
> -			obj_req->xferred = 0;
> +			*result = ret;
>   			return true;
>   		}
>   		return false;
>   	case RBD_OBJ_WRITE_COPYUP_EMPTY_SNAPC:
> -		if (obj_req->result)
> +		if (*result)
>   			return true;
>   
>   		obj_req->write_state = RBD_OBJ_WRITE_COPYUP_OPS;
>   		ret = rbd_obj_issue_copyup_ops(obj_req, MODS_ONLY);
>   		if (ret) {
> -			obj_req->result = ret;
> +			*result = ret;
>   			return true;
>   		}
>   		return false;
> @@ -2696,24 +2687,23 @@ static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req)
>   /*
>    * Returns true if @obj_req is completed, or false otherwise.
>    */
> -static bool __rbd_obj_handle_request(struct rbd_obj_request *obj_req)
> +static bool __rbd_obj_handle_request(struct rbd_obj_request *obj_req,
> +				     int *result)
>   {
>   	switch (obj_req->img_request->op_type) {
>   	case OBJ_OP_READ:
> -		return rbd_obj_handle_read(obj_req);
> +		return rbd_obj_handle_read(obj_req, result);
>   	case OBJ_OP_WRITE:
> -		return rbd_obj_handle_write(obj_req);
> +		return rbd_obj_handle_write(obj_req, result);
>   	case OBJ_OP_DISCARD:
>   	case OBJ_OP_ZEROOUT:
> -		if (rbd_obj_handle_write(obj_req)) {
> +		if (rbd_obj_handle_write(obj_req, result)) {
>   			/*
>   			 * Hide -ENOENT from delete/truncate/zero -- discarding
>   			 * a non-existent object is not a problem.
>   			 */
> -			if (obj_req->result == -ENOENT) {
> -				obj_req->result = 0;
> -				obj_req->xferred = obj_req->ex.oe_len;
> -			}
> +			if (*result == -ENOENT)
> +				*result = 0;
>   			return true;
>   		}
>   		return false;
> @@ -2722,66 +2712,41 @@ static bool __rbd_obj_handle_request(struct rbd_obj_request *obj_req)
>   	}
>   }
>   
> -static void rbd_obj_end_request(struct rbd_obj_request *obj_req)
> +static void rbd_obj_end_request(struct rbd_obj_request *obj_req, int result)
>   {
>   	struct rbd_img_request *img_req = obj_req->img_request;
>   
> -	rbd_assert((!obj_req->result &&
> -		    obj_req->xferred == obj_req->ex.oe_len) ||
> -		   (obj_req->result < 0 && !obj_req->xferred));
> -	if (!obj_req->result) {
> -		img_req->xferred += obj_req->xferred;
> +	rbd_assert(result <= 0);
> +	if (!result)
>   		return;
> -	}
>   
> -	rbd_warn(img_req->rbd_dev,
> -		 "%s at objno %llu %llu~%llu result %d xferred %llu",
> +	rbd_warn(img_req->rbd_dev, "%s at objno %llu %llu~%llu result %d",
>   		 obj_op_name(img_req->op_type), obj_req->ex.oe_objno,
> -		 obj_req->ex.oe_off, obj_req->ex.oe_len, obj_req->result,
> -		 obj_req->xferred);
> -	if (!img_req->result) {
> -		img_req->result = obj_req->result;
> -		img_req->xferred = 0;
> -	}
> -}
> -
> -static void rbd_img_end_child_request(struct rbd_img_request *img_req)
> -{
> -	struct rbd_obj_request *obj_req = img_req->obj_request;
> -
> -	rbd_assert(test_bit(IMG_REQ_CHILD, &img_req->flags));
> -	rbd_assert((!img_req->result &&
> -		    img_req->xferred == rbd_obj_img_extents_bytes(obj_req)) ||
> -		   (img_req->result < 0 && !img_req->xferred));
> -
> -	obj_req->result = img_req->result;
> -	obj_req->xferred = img_req->xferred;
> -	rbd_img_request_put(img_req);
> +		 obj_req->ex.oe_off, obj_req->ex.oe_len, result);
> +	if (!img_req->result)
> +		img_req->result = result;
>   }
>   
>   static void rbd_img_end_request(struct rbd_img_request *img_req)
>   {
>   	rbd_assert(!test_bit(IMG_REQ_CHILD, &img_req->flags));
> -	rbd_assert((!img_req->result &&
> -		    img_req->xferred == blk_rq_bytes(img_req->rq)) ||
> -		   (img_req->result < 0 && !img_req->xferred));
>   
>   	blk_mq_end_request(img_req->rq,
>   			   errno_to_blk_status(img_req->result));
>   	rbd_img_request_put(img_req);
>   }
>   
> -static void rbd_obj_handle_request(struct rbd_obj_request *obj_req)
> +static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result)
>   {
>   	struct rbd_img_request *img_req;
>   
>   again:
> -	if (!__rbd_obj_handle_request(obj_req))
> +	if (!__rbd_obj_handle_request(obj_req, &result))
>   		return;
>   
>   	img_req = obj_req->img_request;
>   	spin_lock(&img_req->completion_lock);
> -	rbd_obj_end_request(obj_req);
> +	rbd_obj_end_request(obj_req, result);
>   	rbd_assert(img_req->pending_count);
>   	if (--img_req->pending_count) {
>   		spin_unlock(&img_req->completion_lock);
> @@ -2789,9 +2754,11 @@ static void rbd_obj_handle_request(struct rbd_obj_request *obj_req)
>   	}
>   
>   	spin_unlock(&img_req->completion_lock);
> +	rbd_assert(img_req->result <= 0);
>   	if (test_bit(IMG_REQ_CHILD, &img_req->flags)) {
>   		obj_req = img_req->obj_request;
> -		rbd_img_end_child_request(img_req);
> +		result = img_req->result ?: rbd_obj_img_extents_bytes(obj_req);
> +		rbd_img_request_put(img_req);
>   		goto again;
>   	}
>   	rbd_img_end_request(img_req);



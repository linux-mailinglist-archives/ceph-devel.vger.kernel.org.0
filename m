Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D75EE5B436
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 07:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbfGAFeb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 01:34:31 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:23810 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727169AbfGAFe3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 01:34:29 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAAHBmspmhldon3wAA--.1297S2;
        Mon, 01 Jul 2019 13:29:13 +0800 (CST)
Subject: Re: [PATCH 11/20] rbd: introduce copyup state machine
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
 <20190625144111.11270-12-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D199A29.3050704@easystack.cn>
Date:   Mon, 1 Jul 2019 13:29:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20190625144111.11270-12-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowAAHBmspmhldon3wAA--.1297S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3WF1DXF4xGF45uw1kCFy5twb_yoWfCF4rpF
        WUtF1jkw1DJ3Wktw4Yqa1DZr4Fgr4xAFyxu393ta4xGa1fW3Z5GF1xKa4jkFy5Zr95Xr4I
        yw4jkFZxJw47t37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pR78n7UUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiZgnkellZuljcKQAAsm
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 06/25/2019 10:41 PM, Ilya Dryomov wrote:
> Both write and copyup paths will get more complex with object map.
> Factor copyup code out into a separate state machine.
>
> While at it, take advantage of obj_req->osd_reqs list and issue empty
> and current snapc OSD requests together, one after another.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   drivers/block/rbd.c | 187 +++++++++++++++++++++++++++++---------------
>   1 file changed, 123 insertions(+), 64 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 2bafdee61dbd..34bd45d336e6 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -226,6 +226,7 @@ enum obj_operation_type {
>   
>   #define RBD_OBJ_FLAG_DELETION			(1U << 0)
>   #define RBD_OBJ_FLAG_COPYUP_ENABLED		(1U << 1)
> +#define RBD_OBJ_FLAG_COPYUP_ZEROS		(1U << 2)
>   
>   enum rbd_obj_read_state {
>   	RBD_OBJ_READ_START = 1,
> @@ -261,9 +262,15 @@ enum rbd_obj_read_state {
>   enum rbd_obj_write_state {
>   	RBD_OBJ_WRITE_START = 1,
>   	RBD_OBJ_WRITE_OBJECT,
> -	RBD_OBJ_WRITE_READ_FROM_PARENT,
> -	RBD_OBJ_WRITE_COPYUP_EMPTY_SNAPC,
> -	RBD_OBJ_WRITE_COPYUP_OPS,
> +	__RBD_OBJ_WRITE_COPYUP,
> +	RBD_OBJ_WRITE_COPYUP,
> +};
> +
> +enum rbd_obj_copyup_state {
> +	RBD_OBJ_COPYUP_START = 1,
> +	RBD_OBJ_COPYUP_READ_PARENT,
> +	__RBD_OBJ_COPYUP_WRITE_OBJECT,
> +	RBD_OBJ_COPYUP_WRITE_OBJECT,
>   };
>   
>   struct rbd_obj_request {
> @@ -286,12 +293,15 @@ struct rbd_obj_request {
>   			u32			bvec_idx;
>   		};
>   	};
> +
> +	enum rbd_obj_copyup_state copyup_state;
>   	struct bio_vec		*copyup_bvecs;
>   	u32			copyup_bvec_count;
>   
>   	struct list_head	osd_reqs;	/* w/ r_unsafe_item */
>   
>   	struct mutex		state_mutex;
> +	struct pending_result	pending;
>   	struct kref		kref;
>   };
>   
> @@ -2568,8 +2578,8 @@ static bool is_zero_bvecs(struct bio_vec *bvecs, u32 bytes)
>   
>   #define MODS_ONLY	U32_MAX
>   
> -static int rbd_obj_issue_copyup_empty_snapc(struct rbd_obj_request *obj_req,
> -					    u32 bytes)
> +static int rbd_obj_copyup_empty_snapc(struct rbd_obj_request *obj_req,
> +				      u32 bytes)
>   {
>   	struct ceph_osd_request *osd_req;
>   	int ret;
> @@ -2595,7 +2605,8 @@ static int rbd_obj_issue_copyup_empty_snapc(struct rbd_obj_request *obj_req,
>   	return 0;
>   }
>   
> -static int rbd_obj_issue_copyup_ops(struct rbd_obj_request *obj_req, u32 bytes)
> +static int rbd_obj_copyup_current_snapc(struct rbd_obj_request *obj_req,
> +					u32 bytes)
>   {
>   	struct ceph_osd_request *osd_req;
>   	int num_ops = count_write_ops(obj_req);
> @@ -2628,33 +2639,6 @@ static int rbd_obj_issue_copyup_ops(struct rbd_obj_request *obj_req, u32 bytes)
>   	return 0;
>   }
>   
> -static int rbd_obj_issue_copyup(struct rbd_obj_request *obj_req, u32 bytes)
> -{
> -	/*
> -	 * Only send non-zero copyup data to save some I/O and network
> -	 * bandwidth -- zero copyup data is equivalent to the object not
> -	 * existing.
> -	 */
> -	if (is_zero_bvecs(obj_req->copyup_bvecs, bytes)) {
> -		dout("%s obj_req %p detected zeroes\n", __func__, obj_req);
> -		bytes = 0;
> -	}
> -
> -	if (obj_req->img_request->snapc->num_snaps && bytes > 0) {
> -		/*
> -		 * Send a copyup request with an empty snapshot context to
> -		 * deep-copyup the object through all existing snapshots.
> -		 * A second request with the current snapshot context will be
> -		 * sent for the actual modification.
> -		 */
> -		obj_req->write_state = RBD_OBJ_WRITE_COPYUP_EMPTY_SNAPC;
> -		return rbd_obj_issue_copyup_empty_snapc(obj_req, bytes);
> -	}
> -
> -	obj_req->write_state = RBD_OBJ_WRITE_COPYUP_OPS;
> -	return rbd_obj_issue_copyup_ops(obj_req, bytes);
> -}
> -
>   static int setup_copyup_bvecs(struct rbd_obj_request *obj_req, u64 obj_overlap)
>   {
>   	u32 i;
> @@ -2688,7 +2672,7 @@ static int setup_copyup_bvecs(struct rbd_obj_request *obj_req, u64 obj_overlap)
>    * target object up to the overlap point (if any) from the parent,
>    * so we can use it for a copyup.
>    */
> -static int rbd_obj_handle_write_guard(struct rbd_obj_request *obj_req)
> +static int rbd_obj_copyup_read_parent(struct rbd_obj_request *obj_req)
>   {
>   	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>   	int ret;
> @@ -2703,22 +2687,111 @@ static int rbd_obj_handle_write_guard(struct rbd_obj_request *obj_req)
>   		 * request -- pass MODS_ONLY since the copyup isn't needed
>   		 * anymore.
>   		 */
> -		obj_req->write_state = RBD_OBJ_WRITE_COPYUP_OPS;
> -		return rbd_obj_issue_copyup_ops(obj_req, MODS_ONLY);
> +		return rbd_obj_copyup_current_snapc(obj_req, MODS_ONLY);
>   	}
>   
>   	ret = setup_copyup_bvecs(obj_req, rbd_obj_img_extents_bytes(obj_req));
>   	if (ret)
>   		return ret;
>   
> -	obj_req->write_state = RBD_OBJ_WRITE_READ_FROM_PARENT;
>   	return rbd_obj_read_from_parent(obj_req);
>   }
>   
> +static void rbd_obj_copyup_write_object(struct rbd_obj_request *obj_req)
> +{
> +	u32 bytes = rbd_obj_img_extents_bytes(obj_req);
> +	int ret;
> +
> +	rbd_assert(!obj_req->pending.result && !obj_req->pending.num_pending);
> +
> +	/*
> +	 * Only send non-zero copyup data to save some I/O and network
> +	 * bandwidth -- zero copyup data is equivalent to the object not
> +	 * existing.
> +	 */
> +	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ZEROS)
> +		bytes = 0;
> +
> +	if (obj_req->img_request->snapc->num_snaps && bytes > 0) {
> +		/*
> +		 * Send a copyup request with an empty snapshot context to
> +		 * deep-copyup the object through all existing snapshots.
> +		 * A second request with the current snapshot context will be
> +		 * sent for the actual modification.
> +		 */
> +		ret = rbd_obj_copyup_empty_snapc(obj_req, bytes);
> +		if (ret) {
> +			obj_req->pending.result = ret;
> +			return;
> +		}
> +
> +		obj_req->pending.num_pending++;
> +		bytes = MODS_ONLY;
> +	}
> +
> +	ret = rbd_obj_copyup_current_snapc(obj_req, bytes);
> +	if (ret) {
> +		obj_req->pending.result = ret;
> +		return;
> +	}
> +
> +	obj_req->pending.num_pending++;
> +}
> +
> +static bool rbd_obj_advance_copyup(struct rbd_obj_request *obj_req, int *result)
> +{
> +	int ret;
> +
> +again:
> +	switch (obj_req->copyup_state) {
> +	case RBD_OBJ_COPYUP_START:
> +		rbd_assert(!*result);
> +
> +		ret = rbd_obj_copyup_read_parent(obj_req);
> +		if (ret) {
> +			*result = ret;
> +			return true;
> +		}
> +		if (obj_req->num_img_extents)
> +			obj_req->copyup_state = RBD_OBJ_COPYUP_READ_PARENT;
> +		else
> +			obj_req->copyup_state = RBD_OBJ_COPYUP_WRITE_OBJECT;
> +		return false;
> +	case RBD_OBJ_COPYUP_READ_PARENT:
> +		if (*result)
> +			return true;
> +
> +		if (is_zero_bvecs(obj_req->copyup_bvecs,
> +				  rbd_obj_img_extents_bytes(obj_req))) {
> +			dout("%s %p detected zeros\n", __func__, obj_req);
> +			obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ZEROS;
> +		}
> +
> +		rbd_obj_copyup_write_object(obj_req);
> +		if (!obj_req->pending.num_pending) {
> +			*result = obj_req->pending.result;
> +			obj_req->copyup_state = RBD_OBJ_COPYUP_WRITE_OBJECT;
> +			goto again;
> +		}
> +		obj_req->copyup_state = __RBD_OBJ_COPYUP_WRITE_OBJECT;
> +		return false;
> +	case __RBD_OBJ_COPYUP_WRITE_OBJECT:
> +		if (!pending_result_dec(&obj_req->pending, result))
> +			return false;
> +		/* fall through */
> +	case RBD_OBJ_COPYUP_WRITE_OBJECT:
> +		return true;
> +	default:
> +		BUG();
> +	}
> +}
> +
>   static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, int *result)
>   {
> +	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>   	int ret;
>   
> +again:
>   	switch (obj_req->write_state) {
>   	case RBD_OBJ_WRITE_START:
>   		rbd_assert(!*result);
> @@ -2733,12 +2806,10 @@ static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, int *result)
>   	case RBD_OBJ_WRITE_OBJECT:
>   		if (*result == -ENOENT) {
>   			if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED) {
> -				ret = rbd_obj_handle_write_guard(obj_req);
> -				if (ret) {
> -					*result = ret;
> -					return true;
> -				}
> -				return false;
> +				*result = 0;
> +				obj_req->copyup_state = RBD_OBJ_COPYUP_START;
> +				obj_req->write_state = __RBD_OBJ_WRITE_COPYUP;
> +				goto again;
>   			}
>   			/*
>   			 * On a non-existent object:
> @@ -2747,31 +2818,19 @@ static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, int *result)
>   			if (obj_req->flags & RBD_OBJ_FLAG_DELETION)
>   				*result = 0;
>   		}
> -		/* fall through */
> -	case RBD_OBJ_WRITE_COPYUP_OPS:
> -		return true;
> -	case RBD_OBJ_WRITE_READ_FROM_PARENT:
>   		if (*result)
>   			return true;
>   
> -		ret = rbd_obj_issue_copyup(obj_req,
> -					   rbd_obj_img_extents_bytes(obj_req));
> -		if (ret) {
> -			*result = ret;
> -			return true;
> -		}
> -		return false;
> -	case RBD_OBJ_WRITE_COPYUP_EMPTY_SNAPC:
> +		obj_req->write_state = RBD_OBJ_WRITE_COPYUP;
> +		goto again;
> +	case __RBD_OBJ_WRITE_COPYUP:
> +		if (!rbd_obj_advance_copyup(obj_req, result))
> +			return false;
> +		/* fall through */
> +	case RBD_OBJ_WRITE_COPYUP:
>   		if (*result)
> -			return true;
> -
> -		obj_req->write_state = RBD_OBJ_WRITE_COPYUP_OPS;
> -		ret = rbd_obj_issue_copyup_ops(obj_req, MODS_ONLY);
> -		if (ret) {
> -			*result = ret;
> -			return true;
> -		}
> -		return false;
> +			rbd_warn(rbd_dev, "copyup failed: %d", *result);
> +		return true;
>   	default:
>   		BUG();
>   	}



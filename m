Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEC7C5B426
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 07:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbfGAFd3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 01:33:29 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22343 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbfGAFd3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 01:33:29 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAA39rrxmRldwXvwAA--.1234S2;
        Mon, 01 Jul 2019 13:28:17 +0800 (CST)
Subject: Re: [PATCH 03/20] rbd: get rid of RBD_OBJ_WRITE_{FLAT,GUARD}
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
 <20190625144111.11270-4-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D1999F1.1040105@easystack.cn>
Date:   Mon, 1 Jul 2019 13:28:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20190625144111.11270-4-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowAA39rrxmRldwXvwAA--.1234S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3XryUCFyfWr1DWrWUXw43Wrg_yoWfJFy3pr
        WUKr4jyw1DJw1kJwsxta1DAr15KF4xZry3X395KryxGa1rXrn5KFyxta4jkFyUArZYqF4x
        tw4Y9FZ3J3y7K37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUjPfdUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiZhHkellZuljaPgAAsv
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 06/25/2019 10:40 PM, Ilya Dryomov wrote:
> In preparation for moving OSD request allocation and submission into
> object request state machines, get rid of RBD_OBJ_WRITE_{FLAT,GUARD}.
> We would need to start in a new state, whether the request is guarded
> or not.  Unify them into RBD_OBJ_WRITE_OBJECT and pass guard info
> through obj_req->flags.
>
> While at it, make our ENOENT handling a little more precise: only hide
> ENOENT when it is actually expected, that is on delete.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   drivers/block/rbd.c | 112 ++++++++++++++++++++++++--------------------
>   1 file changed, 60 insertions(+), 52 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 7925b2fdde79..488da877a2bb 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -219,6 +219,9 @@ enum obj_operation_type {
>   	OBJ_OP_ZEROOUT,
>   };
>   
> +#define RBD_OBJ_FLAG_DELETION			(1U << 0)
> +#define RBD_OBJ_FLAG_COPYUP_ENABLED		(1U << 1)
> +
>   enum rbd_obj_read_state {
>   	RBD_OBJ_READ_OBJECT = 1,
>   	RBD_OBJ_READ_PARENT,
> @@ -250,8 +253,7 @@ enum rbd_obj_read_state {
>    * even if there is a parent).
>    */
>   enum rbd_obj_write_state {
> -	RBD_OBJ_WRITE_FLAT = 1,
> -	RBD_OBJ_WRITE_GUARD,
> +	RBD_OBJ_WRITE_OBJECT = 1,
>   	RBD_OBJ_WRITE_READ_FROM_PARENT,
>   	RBD_OBJ_WRITE_COPYUP_EMPTY_SNAPC,
>   	RBD_OBJ_WRITE_COPYUP_OPS,
> @@ -259,6 +261,7 @@ enum rbd_obj_write_state {
>   
>   struct rbd_obj_request {
>   	struct ceph_object_extent ex;
> +	unsigned int		flags;	/* RBD_OBJ_FLAG_* */
>   	union {
>   		enum rbd_obj_read_state	 read_state;	/* for reads */
>   		enum rbd_obj_write_state write_state;	/* for writes */
> @@ -1858,7 +1861,6 @@ static void __rbd_obj_setup_write(struct rbd_obj_request *obj_req,
>   static int rbd_obj_setup_write(struct rbd_obj_request *obj_req)
>   {
>   	unsigned int num_osd_ops, which = 0;
> -	bool need_guard;
>   	int ret;
>   
>   	/* reverse map the entire object onto the parent */
> @@ -1866,23 +1868,24 @@ static int rbd_obj_setup_write(struct rbd_obj_request *obj_req)
>   	if (ret)
>   		return ret;
>   
> -	need_guard = rbd_obj_copyup_enabled(obj_req);
> -	num_osd_ops = need_guard + count_write_ops(obj_req);
> +	if (rbd_obj_copyup_enabled(obj_req))
> +		obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ENABLED;
> +
> +	num_osd_ops = count_write_ops(obj_req);
> +	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED)
> +		num_osd_ops++; /* stat */
>   
>   	obj_req->osd_req = rbd_osd_req_create(obj_req, num_osd_ops);
>   	if (!obj_req->osd_req)
>   		return -ENOMEM;
>   
> -	if (need_guard) {
> +	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED) {
>   		ret = __rbd_obj_setup_stat(obj_req, which++);
>   		if (ret)
>   			return ret;
> -
> -		obj_req->write_state = RBD_OBJ_WRITE_GUARD;
> -	} else {
> -		obj_req->write_state = RBD_OBJ_WRITE_FLAT;
>   	}
>   
> +	obj_req->write_state = RBD_OBJ_WRITE_OBJECT;
>   	__rbd_obj_setup_write(obj_req, which);
>   	return 0;
>   }
> @@ -1921,11 +1924,15 @@ static int rbd_obj_setup_discard(struct rbd_obj_request *obj_req)
>   	if (ret)
>   		return ret;
>   
> +	if (rbd_obj_is_entire(obj_req) && !obj_req->num_img_extents)
> +		obj_req->flags |= RBD_OBJ_FLAG_DELETION;
> +
>   	obj_req->osd_req = rbd_osd_req_create(obj_req, 1);
>   	if (!obj_req->osd_req)
>   		return -ENOMEM;
>   
>   	if (rbd_obj_is_entire(obj_req) && !obj_req->num_img_extents) {
> +		rbd_assert(obj_req->flags & RBD_OBJ_FLAG_DELETION);
>   		osd_req_op_init(obj_req->osd_req, 0, CEPH_OSD_OP_DELETE, 0);
>   	} else {
>   		dout("%s %p %llu~%llu -> %llu~%llu\n", __func__,
> @@ -1936,7 +1943,7 @@ static int rbd_obj_setup_discard(struct rbd_obj_request *obj_req)
>   				       off, next_off - off, 0, 0);
>   	}
>   
> -	obj_req->write_state = RBD_OBJ_WRITE_FLAT;
> +	obj_req->write_state = RBD_OBJ_WRITE_OBJECT;
>   	rbd_osd_req_format_write(obj_req);
>   	return 0;
>   }
> @@ -1961,11 +1968,12 @@ static void __rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req,
>   
>   	if (rbd_obj_is_entire(obj_req)) {
>   		if (obj_req->num_img_extents) {
> -			if (!rbd_obj_copyup_enabled(obj_req))
> +			if (!(obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED))
>   				osd_req_op_init(obj_req->osd_req, which++,
>   						CEPH_OSD_OP_CREATE, 0);
>   			opcode = CEPH_OSD_OP_TRUNCATE;
>   		} else {
> +			rbd_assert(obj_req->flags & RBD_OBJ_FLAG_DELETION);
>   			osd_req_op_init(obj_req->osd_req, which++,
>   					CEPH_OSD_OP_DELETE, 0);
>   			opcode = 0;
> @@ -1986,7 +1994,6 @@ static void __rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req,
>   static int rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req)
>   {
>   	unsigned int num_osd_ops, which = 0;
> -	bool need_guard;
>   	int ret;
>   
>   	/* reverse map the entire object onto the parent */
> @@ -1994,23 +2001,28 @@ static int rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req)
>   	if (ret)
>   		return ret;
>   
> -	need_guard = rbd_obj_copyup_enabled(obj_req);
> -	num_osd_ops = need_guard + count_zeroout_ops(obj_req);
> +	if (rbd_obj_copyup_enabled(obj_req))
> +		obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ENABLED;
> +	if (!obj_req->num_img_extents) {
> +		if (rbd_obj_is_entire(obj_req))
> +			obj_req->flags |= RBD_OBJ_FLAG_DELETION;
> +	}
> +
> +	num_osd_ops = count_zeroout_ops(obj_req);
> +	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED)
> +		num_osd_ops++; /* stat */
>   
>   	obj_req->osd_req = rbd_osd_req_create(obj_req, num_osd_ops);
>   	if (!obj_req->osd_req)
>   		return -ENOMEM;
>   
> -	if (need_guard) {
> +	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED) {
>   		ret = __rbd_obj_setup_stat(obj_req, which++);
>   		if (ret)
>   			return ret;
> -
> -		obj_req->write_state = RBD_OBJ_WRITE_GUARD;
> -	} else {
> -		obj_req->write_state = RBD_OBJ_WRITE_FLAT;
>   	}
>   
> +	obj_req->write_state = RBD_OBJ_WRITE_OBJECT;
>   	__rbd_obj_setup_zeroout(obj_req, which);
>   	return 0;
>   }
> @@ -2617,6 +2629,11 @@ static int setup_copyup_bvecs(struct rbd_obj_request *obj_req, u64 obj_overlap)
>   	return 0;
>   }
>   
> +/*
> + * The target object doesn't exist.  Read the data for the entire
> + * target object up to the overlap point (if any) from the parent,
> + * so we can use it for a copyup.
> + */
>   static int rbd_obj_handle_write_guard(struct rbd_obj_request *obj_req)
>   {
>   	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
> @@ -2649,22 +2666,24 @@ static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req, int *result)
>   	int ret;
>   
>   	switch (obj_req->write_state) {
> -	case RBD_OBJ_WRITE_GUARD:
> +	case RBD_OBJ_WRITE_OBJECT:
>   		if (*result == -ENOENT) {
> +			if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED) {
> +				ret = rbd_obj_handle_write_guard(obj_req);
> +				if (ret) {
> +					*result = ret;
> +					return true;
> +				}
> +				return false;
> +			}
>   			/*
> -			 * The target object doesn't exist.  Read the data for
> -			 * the entire target object up to the overlap point (if
> -			 * any) from the parent, so we can use it for a copyup.
> +			 * On a non-existent object:
> +			 *   delete - -ENOENT, truncate/zero - 0
>   			 */
> -			ret = rbd_obj_handle_write_guard(obj_req);
> -			if (ret) {
> -				*result = ret;
> -				return true;
> -			}
> -			return false;
> +			if (obj_req->flags & RBD_OBJ_FLAG_DELETION)
> +				*result = 0;
>   		}
>   		/* fall through */
> -	case RBD_OBJ_WRITE_FLAT:
>   	case RBD_OBJ_WRITE_COPYUP_OPS:
>   		return true;
>   	case RBD_OBJ_WRITE_READ_FROM_PARENT:
> @@ -2695,31 +2714,20 @@ static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req, int *result)
>   }
>   
>   /*
> - * Returns true if @obj_req is completed, or false otherwise.
> + * Return true if @obj_req is completed.
>    */
>   static bool __rbd_obj_handle_request(struct rbd_obj_request *obj_req,
>   				     int *result)
>   {
> -	switch (obj_req->img_request->op_type) {
> -	case OBJ_OP_READ:
> -		return rbd_obj_handle_read(obj_req, result);
> -	case OBJ_OP_WRITE:
> -		return rbd_obj_handle_write(obj_req, result);
> -	case OBJ_OP_DISCARD:
> -	case OBJ_OP_ZEROOUT:
> -		if (rbd_obj_handle_write(obj_req, result)) {
> -			/*
> -			 * Hide -ENOENT from delete/truncate/zero -- discarding
> -			 * a non-existent object is not a problem.
> -			 */
> -			if (*result == -ENOENT)
> -				*result = 0;
> -			return true;
> -		}
> -		return false;
> -	default:
> -		BUG();
> -	}
> +	struct rbd_img_request *img_req = obj_req->img_request;
> +	bool done;
> +
> +	if (!rbd_img_is_write(img_req))
> +		done = rbd_obj_handle_read(obj_req, result);
> +	else
> +		done = rbd_obj_handle_write(obj_req, result);
> +
> +	return done;
>   }
>   
>   static void rbd_obj_end_request(struct rbd_obj_request *obj_req, int result)



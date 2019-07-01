Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84EB65B423
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 07:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfGAFdP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 01:33:15 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22026 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfGAFdP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 01:33:15 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowABH8LfqmRldl3vwAA--.1298S2;
        Mon, 01 Jul 2019 13:28:10 +0800 (CST)
Subject: Re: [PATCH 02/20] rbd: replace obj_req->tried_parent with
 obj_req->read_state
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
 <20190625144111.11270-3-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D1999EA.30102@easystack.cn>
Date:   Mon, 1 Jul 2019 13:28:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20190625144111.11270-3-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowABH8LfqmRldl3vwAA--.1298S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWw1UWr48CrWkuryDXw43KFg_yoWruFyxpa
        y5AF1jk34DA3Wktw4fKayqqr1rWF4SyFy7W340kryfWan3WF95CFyUGa4Y9Fy7ZrZYqr4I
        yF4jy393Gr12g37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRijjgUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbihwrkeltVgST9qwAAsu
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 06/25/2019 10:40 PM, Ilya Dryomov wrote:
> Make rbd_obj_handle_read() look like a state machine and get rid of
> the necessity to patch result in rbd_obj_handle_request(), completing
> the removal of obj_req->xferred and img_req->xferred.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>   drivers/block/rbd.c | 82 +++++++++++++++++++++++++--------------------
>   1 file changed, 46 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index a9b0b23148f9..7925b2fdde79 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -219,6 +219,11 @@ enum obj_operation_type {
>   	OBJ_OP_ZEROOUT,
>   };
>   
> +enum rbd_obj_read_state {
> +	RBD_OBJ_READ_OBJECT = 1,
> +	RBD_OBJ_READ_PARENT,
> +};
> +
>   /*
>    * Writes go through the following state machine to deal with
>    * layering:
> @@ -255,7 +260,7 @@ enum rbd_obj_write_state {
>   struct rbd_obj_request {
>   	struct ceph_object_extent ex;
>   	union {
> -		bool			tried_parent;	/* for reads */
> +		enum rbd_obj_read_state	 read_state;	/* for reads */
>   		enum rbd_obj_write_state write_state;	/* for writes */
>   	};
>   
> @@ -1794,6 +1799,7 @@ static int rbd_obj_setup_read(struct rbd_obj_request *obj_req)
>   	rbd_osd_req_setup_data(obj_req, 0);
>   
>   	rbd_osd_req_format_read(obj_req);
> +	obj_req->read_state = RBD_OBJ_READ_OBJECT;
>   	return 0;
>   }
>   
> @@ -2402,44 +2408,48 @@ static bool rbd_obj_handle_read(struct rbd_obj_request *obj_req, int *result)
>   	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>   	int ret;
>   
> -	if (*result == -ENOENT &&
> -	    rbd_dev->parent_overlap && !obj_req->tried_parent) {
> -		/* reverse map this object extent onto the parent */
> -		ret = rbd_obj_calc_img_extents(obj_req, false);
> -		if (ret) {
> -			*result = ret;
> -			return true;
> -		}
> -
> -		if (obj_req->num_img_extents) {
> -			obj_req->tried_parent = true;
> -			ret = rbd_obj_read_from_parent(obj_req);
> +	switch (obj_req->read_state) {
> +	case RBD_OBJ_READ_OBJECT:
> +		if (*result == -ENOENT && rbd_dev->parent_overlap) {
> +			/* reverse map this object extent onto the parent */
> +			ret = rbd_obj_calc_img_extents(obj_req, false);
>   			if (ret) {
>   				*result = ret;
>   				return true;
>   			}
> -			return false;
> +			if (obj_req->num_img_extents) {
> +				ret = rbd_obj_read_from_parent(obj_req);
> +				if (ret) {
> +					*result = ret;
> +					return true;
> +				}
> +				obj_req->read_state = RBD_OBJ_READ_PARENT;
Seems there is a race window between the read request complete but the 
read_state is still RBD_OBJ_READ_OBJECT.
> +				return false;
> +			}
>   		}
> -	}
>   
> -	/*
> -	 * -ENOENT means a hole in the image -- zero-fill the entire
> -	 * length of the request.  A short read also implies zero-fill
> -	 * to the end of the request.
> -	 */
> -	if (*result == -ENOENT) {
> -		rbd_obj_zero_range(obj_req, 0, obj_req->ex.oe_len);
> -		*result = 0;
> -	} else if (*result >= 0) {
> -		if (*result < obj_req->ex.oe_len)
> -			rbd_obj_zero_range(obj_req, *result,
> -					   obj_req->ex.oe_len - *result);
> -		else
> -			rbd_assert(*result == obj_req->ex.oe_len);
> -		*result = 0;
> +		/*
> +		 * -ENOENT means a hole in the image -- zero-fill the entire
> +		 * length of the request.  A short read also implies zero-fill
> +		 * to the end of the request.
> +		 */
> +		if (*result == -ENOENT) {
> +			rbd_obj_zero_range(obj_req, 0, obj_req->ex.oe_len);
> +			*result = 0;
> +		} else if (*result >= 0) {
> +			if (*result < obj_req->ex.oe_len)
> +				rbd_obj_zero_range(obj_req, *result,
> +						obj_req->ex.oe_len - *result);
> +			else
> +				rbd_assert(*result == obj_req->ex.oe_len);
> +			*result = 0;
> +		}
> +		return true;
> +	case RBD_OBJ_READ_PARENT:
> +		return true;
> +	default:
> +		BUG();
>   	}
> -
> -	return true;
>   }
>   
>   /*
> @@ -2658,11 +2668,11 @@ static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req, int *result)
>   	case RBD_OBJ_WRITE_COPYUP_OPS:
>   		return true;
>   	case RBD_OBJ_WRITE_READ_FROM_PARENT:
> -		if (*result < 0)
> +		if (*result)
>   			return true;
>   
> -		rbd_assert(*result);
> -		ret = rbd_obj_issue_copyup(obj_req, *result);
> +		ret = rbd_obj_issue_copyup(obj_req,
> +					   rbd_obj_img_extents_bytes(obj_req));
>   		if (ret) {
>   			*result = ret;
>   			return true;
> @@ -2757,7 +2767,7 @@ static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result)
>   	rbd_assert(img_req->result <= 0);
>   	if (test_bit(IMG_REQ_CHILD, &img_req->flags)) {
>   		obj_req = img_req->obj_request;
> -		result = img_req->result ?: rbd_obj_img_extents_bytes(obj_req);
> +		result = img_req->result;
>   		rbd_img_request_put(img_req);
>   		goto again;
>   	}
should this part be in 01/20 ?
Thanx



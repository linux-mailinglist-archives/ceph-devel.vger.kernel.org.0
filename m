Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE965B434
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 07:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbfGAFea (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 01:34:30 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:23794 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727349AbfGAFe3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 01:34:29 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowABH8LchmhldX33wAA--.1308S2;
        Mon, 01 Jul 2019 13:29:05 +0800 (CST)
Subject: Re: [PATCH 09/20] rbd: move OSD request allocation into object
 request state machines
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
 <20190625144111.11270-10-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D199A21.9040003@easystack.cn>
Date:   Mon, 1 Jul 2019 13:29:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20190625144111.11270-10-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowABH8LchmhldX33wAA--.1308S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3tw48Zw48uF1kKr13JFyrWFg_yoWkur4Dp3
        9rKF40ywn8Xw1DJws0q3yDZryYgr4xArW7X348Kwn7Ga1kXrsY9F18Gry2qa47CF95Xr4x
        Ka1j9rZ3Xw12g37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pR66wtUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiiAzkeltVgci6+gAAsd
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 06/25/2019 10:41 PM, Ilya Dryomov wrote:
> Following submission, move initial OSD request allocation into object
> request state machines.  Everything that has to do with OSD requests is
> now handled inside the state machine, all __rbd_img_fill_request() has
> left is initialization.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   drivers/block/rbd.c | 214 ++++++++++++++++++++------------------------
>   1 file changed, 96 insertions(+), 118 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index acc9017034d7..61bc20cf1c29 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -1408,15 +1408,13 @@ static inline void rbd_img_obj_request_del(struct rbd_img_request *img_request,
>   	rbd_obj_request_put(obj_request);
>   }
>   
> -static void rbd_obj_request_submit(struct rbd_obj_request *obj_request)
> +static void rbd_osd_submit(struct ceph_osd_request *osd_req)
>   {
> -	struct ceph_osd_request *osd_req =
> -	    list_last_entry(&obj_request->osd_reqs, struct ceph_osd_request,
> -			    r_unsafe_item);
> +	struct rbd_obj_request *obj_req = osd_req->r_priv;
>   
> -	dout("%s %p object_no %016llx %llu~%llu osd_req %p\n", __func__,
> -	     obj_request, obj_request->ex.oe_objno, obj_request->ex.oe_off,
> -	     obj_request->ex.oe_len, osd_req);
> +	dout("%s osd_req %p for obj_req %p objno %llu %llu~%llu\n",
> +	     __func__, osd_req, obj_req, obj_req->ex.oe_objno,
> +	     obj_req->ex.oe_off, obj_req->ex.oe_len);
>   	ceph_osdc_start_request(osd_req->r_osdc, osd_req, false);
>   }
>   
> @@ -1823,17 +1821,6 @@ static void rbd_osd_setup_data(struct ceph_osd_request *osd_req, int which)
>   
>   static int rbd_obj_setup_read(struct rbd_obj_request *obj_req)
>   {
> -	struct ceph_osd_request *osd_req;
> -
> -	osd_req = __rbd_obj_add_osd_request(obj_req, NULL, 1);
> -	if (IS_ERR(osd_req))
> -		return PTR_ERR(osd_req);
> -
> -	osd_req_op_extent_init(osd_req, 0, CEPH_OSD_OP_READ,
> -			       obj_req->ex.oe_off, obj_req->ex.oe_len, 0, 0);
> -	rbd_osd_setup_data(osd_req, 0);
> -
> -	rbd_osd_format_read(osd_req);
>   	obj_req->read_state = RBD_OBJ_READ_START;
>   	return 0;
>   }
> @@ -1876,11 +1863,6 @@ static int rbd_osd_setup_copyup(struct ceph_osd_request *osd_req, int which,
>   	return 0;
>   }
>   
> -static int count_write_ops(struct rbd_obj_request *obj_req)
> -{
> -	return 2; /* setallochint + write/writefull */
> -}
> -
>   static void __rbd_osd_setup_write_ops(struct ceph_osd_request *osd_req,
>   				      int which)
>   {
> @@ -1900,14 +1882,10 @@ static void __rbd_osd_setup_write_ops(struct ceph_osd_request *osd_req,
>   	osd_req_op_extent_init(osd_req, which, opcode,
>   			       obj_req->ex.oe_off, obj_req->ex.oe_len, 0, 0);
>   	rbd_osd_setup_data(osd_req, which);
> -
> -	rbd_osd_format_write(osd_req);
>   }
>   
>   static int rbd_obj_setup_write(struct rbd_obj_request *obj_req)
>   {
> -	struct ceph_osd_request *osd_req;
> -	unsigned int num_osd_ops, which = 0;
>   	int ret;
>   
>   	/* reverse map the entire object onto the parent */
> @@ -1918,22 +1896,7 @@ static int rbd_obj_setup_write(struct rbd_obj_request *obj_req)
>   	if (rbd_obj_copyup_enabled(obj_req))
>   		obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ENABLED;
>   
> -	num_osd_ops = count_write_ops(obj_req);
> -	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED)
> -		num_osd_ops++; /* stat */
> -
> -	osd_req = rbd_obj_add_osd_request(obj_req, num_osd_ops);
> -	if (IS_ERR(osd_req))
> -		return PTR_ERR(osd_req);
> -
> -	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED) {
> -		ret = rbd_osd_setup_stat(osd_req, which++);
> -		if (ret)
> -			return ret;
> -	}
> -
>   	obj_req->write_state = RBD_OBJ_WRITE_START;
> -	__rbd_osd_setup_write_ops(osd_req, which);
>   	return 0;
>   }
>   
> @@ -1962,7 +1925,6 @@ static void __rbd_osd_setup_discard_ops(struct ceph_osd_request *osd_req,
>   static int rbd_obj_setup_discard(struct rbd_obj_request *obj_req)
>   {
>   	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
> -	struct ceph_osd_request *osd_req;
>   	u64 off, next_off;
>   	int ret;
>   
> @@ -1997,29 +1959,10 @@ static int rbd_obj_setup_discard(struct rbd_obj_request *obj_req)
>   	if (rbd_obj_is_entire(obj_req) && !obj_req->num_img_extents)
>   		obj_req->flags |= RBD_OBJ_FLAG_DELETION;
>   
> -	osd_req = rbd_obj_add_osd_request(obj_req, 1);
> -	if (IS_ERR(osd_req))
> -		return PTR_ERR(osd_req);
> -
>   	obj_req->write_state = RBD_OBJ_WRITE_START;
> -	__rbd_osd_setup_discard_ops(osd_req, 0);
> -	rbd_osd_format_write(osd_req);
>   	return 0;
>   }
>   
> -static int count_zeroout_ops(struct rbd_obj_request *obj_req)
> -{
> -	int num_osd_ops;
> -
> -	if (rbd_obj_is_entire(obj_req) && obj_req->num_img_extents &&
> -	    !rbd_obj_copyup_enabled(obj_req))
> -		num_osd_ops = 2; /* create + truncate */
> -	else
> -		num_osd_ops = 1; /* delete/truncate/zero */
> -
> -	return num_osd_ops;
> -}
> -
>   static void __rbd_osd_setup_zeroout_ops(struct ceph_osd_request *osd_req,
>   					int which)
>   {
> @@ -2046,14 +1989,10 @@ static void __rbd_osd_setup_zeroout_ops(struct ceph_osd_request *osd_req,
>   		osd_req_op_extent_init(osd_req, which, opcode,
>   				       obj_req->ex.oe_off, obj_req->ex.oe_len,
>   				       0, 0);
> -
> -	rbd_osd_format_write(osd_req);
>   }
>   
>   static int rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req)
>   {
> -	struct ceph_osd_request *osd_req;
> -	unsigned int num_osd_ops, which = 0;
>   	int ret;
>   
>   	/* reverse map the entire object onto the parent */
> @@ -2068,34 +2007,56 @@ static int rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req)
>   			obj_req->flags |= RBD_OBJ_FLAG_DELETION;
>   	}
>   
> -	num_osd_ops = count_zeroout_ops(obj_req);
> -	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED)
> -		num_osd_ops++; /* stat */
> +	obj_req->write_state = RBD_OBJ_WRITE_START;
> +	return 0;
> +}
>   
> -	osd_req = rbd_obj_add_osd_request(obj_req, num_osd_ops);
> -	if (IS_ERR(osd_req))
> -		return PTR_ERR(osd_req);
> +static int count_write_ops(struct rbd_obj_request *obj_req)
> +{
> +	switch (obj_req->img_request->op_type) {
> +	case OBJ_OP_WRITE:
> +		return 2; /* setallochint + write/writefull */
> +	case OBJ_OP_DISCARD:
> +		return 1; /* delete/truncate/zero */
> +	case OBJ_OP_ZEROOUT:
> +		if (rbd_obj_is_entire(obj_req) && obj_req->num_img_extents &&
> +		    !(obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED))
> +			return 2; /* create + truncate */
>   
> -	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED) {
> -		ret = rbd_osd_setup_stat(osd_req, which++);
> -		if (ret)
> -			return ret;
> +		return 1; /* delete/truncate/zero */
> +	default:
> +		BUG();
>   	}
> +}
>   
> -	obj_req->write_state = RBD_OBJ_WRITE_START;
> -	__rbd_osd_setup_zeroout_ops(osd_req, which);
> -	return 0;
> +static void rbd_osd_setup_write_ops(struct ceph_osd_request *osd_req,
> +				    int which)
> +{
> +	struct rbd_obj_request *obj_req = osd_req->r_priv;
> +
> +	switch (obj_req->img_request->op_type) {
> +	case OBJ_OP_WRITE:
> +		__rbd_osd_setup_write_ops(osd_req, which);
> +		break;
> +	case OBJ_OP_DISCARD:
> +		__rbd_osd_setup_discard_ops(osd_req, which);
> +		break;
> +	case OBJ_OP_ZEROOUT:
> +		__rbd_osd_setup_zeroout_ops(osd_req, which);
> +		break;
> +	default:
> +		BUG();
> +	}
>   }
>   
>   /*
> - * For each object request in @img_req, allocate an OSD request, add
> - * individual OSD ops and prepare them for submission.  The number of
> - * OSD ops depends on op_type and the overlap point (if any).
> + * Prune the list of object requests (adjust offset and/or length, drop
> + * redundant requests).  Prepare object request state machines and image
> + * request state machine for execution.
>    */
>   static int __rbd_img_fill_request(struct rbd_img_request *img_req)
>   {
>   	struct rbd_obj_request *obj_req, *next_obj_req;
> -	struct ceph_osd_request *osd_req;
>   	int ret;
>   
>   	for_each_obj_request_safe(img_req, obj_req, next_obj_req) {
> @@ -2121,13 +2082,6 @@ static int __rbd_img_fill_request(struct rbd_img_request *img_req)
>   			rbd_img_obj_request_del(img_req, obj_req);
>   			continue;
>   		}
> -
> -		osd_req = list_last_entry(&obj_req->osd_reqs,
> -					  struct ceph_osd_request,
> -					  r_unsafe_item);
> -		ret = ceph_osdc_alloc_messages(osd_req, GFP_NOIO);
> -		if (ret)
> -			return ret;
>   	}
>   
>   	img_req->state = RBD_IMG_START;
> @@ -2436,7 +2390,23 @@ static void rbd_img_schedule(struct rbd_img_request *img_req, int result)
>   
>   static int rbd_obj_read_object(struct rbd_obj_request *obj_req)
>   {
> -	rbd_obj_request_submit(obj_req);
> +	struct ceph_osd_request *osd_req;
> +	int ret;
> +
> +	osd_req = __rbd_obj_add_osd_request(obj_req, NULL, 1);
> +	if (IS_ERR(osd_req))
> +		return PTR_ERR(osd_req);
> +
> +	osd_req_op_extent_init(osd_req, 0, CEPH_OSD_OP_READ,
> +			       obj_req->ex.oe_off, obj_req->ex.oe_len, 0, 0);
> +	rbd_osd_setup_data(osd_req, 0);
> +	rbd_osd_format_read(osd_req);
> +
> +	ret = ceph_osdc_alloc_messages(osd_req, GFP_NOIO);
> +	if (ret)
> +		return ret;
> +
> +	rbd_osd_submit(osd_req);
>   	return 0;
>   }
>   
> @@ -2549,7 +2519,32 @@ static bool rbd_obj_advance_read(struct rbd_obj_request *obj_req, int *result)
>   
>   static int rbd_obj_write_object(struct rbd_obj_request *obj_req)
>   {
> -	rbd_obj_request_submit(obj_req);
> +	struct ceph_osd_request *osd_req;
> +	int num_ops = count_write_ops(obj_req);
> +	int which = 0;
> +	int ret;
> +
> +	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED)
> +		num_ops++; /* stat */
> +
> +	osd_req = rbd_obj_add_osd_request(obj_req, num_ops);
> +	if (IS_ERR(osd_req))
> +		return PTR_ERR(osd_req);
> +
> +	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED) {
> +		ret = rbd_osd_setup_stat(osd_req, which++);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	rbd_osd_setup_write_ops(osd_req, which);
> +	rbd_osd_format_write(osd_req);
> +
> +	ret = ceph_osdc_alloc_messages(osd_req, GFP_NOIO);
> +	if (ret)
> +		return ret;
> +
> +	rbd_osd_submit(osd_req);
>   	return 0;
>   }
>   
> @@ -2596,32 +2591,23 @@ static int rbd_obj_issue_copyup_empty_snapc(struct rbd_obj_request *obj_req,
>   	if (ret)
>   		return ret;
>   
> -	rbd_obj_request_submit(obj_req);
> +	rbd_osd_submit(osd_req);
>   	return 0;
>   }
>   
>   static int rbd_obj_issue_copyup_ops(struct rbd_obj_request *obj_req, u32 bytes)
>   {
> -	struct rbd_img_request *img_req = obj_req->img_request;
>   	struct ceph_osd_request *osd_req;
> -	unsigned int num_osd_ops = (bytes != MODS_ONLY);
> -	unsigned int which = 0;
> +	int num_ops = count_write_ops(obj_req);
> +	int which = 0;
>   	int ret;
>   
>   	dout("%s obj_req %p bytes %u\n", __func__, obj_req, bytes);
>   
> -	switch (img_req->op_type) {
> -	case OBJ_OP_WRITE:
> -		num_osd_ops += count_write_ops(obj_req);
> -		break;
> -	case OBJ_OP_ZEROOUT:
> -		num_osd_ops += count_zeroout_ops(obj_req);
> -		break;
> -	default:
> -		BUG();
> -	}
> +	if (bytes != MODS_ONLY)
> +		num_ops++; /* copyup */
>   
> -	osd_req = rbd_obj_add_osd_request(obj_req, num_osd_ops);
> +	osd_req = rbd_obj_add_osd_request(obj_req, num_ops);
>   	if (IS_ERR(osd_req))
>   		return PTR_ERR(osd_req);
>   
> @@ -2631,22 +2617,14 @@ static int rbd_obj_issue_copyup_ops(struct rbd_obj_request *obj_req, u32 bytes)
>   			return ret;
>   	}
>   
> -	switch (img_req->op_type) {
> -	case OBJ_OP_WRITE:
> -		__rbd_osd_setup_write_ops(osd_req, which);
> -		break;
> -	case OBJ_OP_ZEROOUT:
> -		__rbd_osd_setup_zeroout_ops(osd_req, which);
> -		break;
> -	default:
> -		BUG();
> -	}
> +	rbd_osd_setup_write_ops(osd_req, which);
> +	rbd_osd_format_write(osd_req);
>   
>   	ret = ceph_osdc_alloc_messages(osd_req, GFP_NOIO);
>   	if (ret)
>   		return ret;
>   
> -	rbd_obj_request_submit(obj_req);
> +	rbd_osd_submit(osd_req);
>   	return 0;
>   }
>   



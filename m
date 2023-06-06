Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22BF9723569
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 04:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234246AbjFFCn5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Jun 2023 22:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbjFFCn4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Jun 2023 22:43:56 -0400
Received: from mail-m3173.qiye.163.com (mail-m3173.qiye.163.com [103.74.31.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5740B127
        for <ceph-devel@vger.kernel.org>; Mon,  5 Jun 2023 19:43:53 -0700 (PDT)
Received: from [192.168.0.9] (unknown [218.94.118.90])
        by mail-m3173.qiye.163.com (Hmail) with ESMTPA id C5AAEE0192;
        Tue,  6 Jun 2023 10:34:13 +0800 (CST)
Subject: Re: [PATCH 1/2] rbd: move RBD_OBJ_FLAG_COPYUP_ENABLED flag setting
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20230605202715.968962-1-idryomov@gmail.com>
 <20230605202715.968962-2-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <943d0827-4bbb-4b1d-e945-0ee9fd8f066d@easystack.cn>
Date:   Tue, 6 Jun 2023 10:34:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20230605202715.968962-2-idryomov@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDSkJIVkweSEkfGh8aTE5NSVUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Tid: 0a888e8e0be700adkurmc5aaee0192
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mjo6Tio5EjJJL00dMEoJSgsB
        DAIwCwFVSlVKTUNNS0pDQ05PSU1MVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
        V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT0tKTDcG
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



在 2023/6/6 星期二 上午 4:27, Ilya Dryomov 写道:
> Move RBD_OBJ_FLAG_COPYUP_ENABLED flag setting into the object request
> state machine to allow for the snapshot context to be captured in the
> image request state machine rather than in rbd_queue_workfn().
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Dongsheng Yang dongsheng.yang@easystack.cn
> ---
>   drivers/block/rbd.c | 32 +++++++++++++++++++++-----------
>   1 file changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 84ad3b17956f..6c847db6ee2c 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -1334,14 +1334,28 @@ static bool rbd_obj_is_tail(struct rbd_obj_request *obj_req)
>   /*
>    * Must be called after rbd_obj_calc_img_extents().
>    */
> -static bool rbd_obj_copyup_enabled(struct rbd_obj_request *obj_req)
> +static void rbd_obj_set_copyup_enabled(struct rbd_obj_request *obj_req)
>   {
> -	if (!obj_req->num_img_extents ||
> -	    (rbd_obj_is_entire(obj_req) &&
> -	     !obj_req->img_request->snapc->num_snaps))
> -		return false;
> +	if (obj_req->img_request->op_type == OBJ_OP_DISCARD) {
> +		dout("%s %p objno %llu discard\n", __func__, obj_req,
> +		     obj_req->ex.oe_objno);
> +		return;
> +	}
>   
> -	return true;
> +	if (!obj_req->num_img_extents) {
> +		dout("%s %p objno %llu not overlapping\n", __func__, obj_req,
> +		     obj_req->ex.oe_objno);
> +		return;
> +	}
> +
> +	if (rbd_obj_is_entire(obj_req) &&
> +	    !obj_req->img_request->snapc->num_snaps) {
> +		dout("%s %p objno %llu entire\n", __func__, obj_req,
> +		     obj_req->ex.oe_objno);
> +		return;
> +	}
> +
> +	obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ENABLED;
>   }
>   
>   static u64 rbd_obj_img_extents_bytes(struct rbd_obj_request *obj_req)
> @@ -2233,9 +2247,6 @@ static int rbd_obj_init_write(struct rbd_obj_request *obj_req)
>   	if (ret)
>   		return ret;
>   
> -	if (rbd_obj_copyup_enabled(obj_req))
> -		obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ENABLED;
> -
>   	obj_req->write_state = RBD_OBJ_WRITE_START;
>   	return 0;
>   }
> @@ -2341,8 +2352,6 @@ static int rbd_obj_init_zeroout(struct rbd_obj_request *obj_req)
>   	if (ret)
>   		return ret;
>   
> -	if (rbd_obj_copyup_enabled(obj_req))
> -		obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ENABLED;
>   	if (!obj_req->num_img_extents) {
>   		obj_req->flags |= RBD_OBJ_FLAG_NOOP_FOR_NONEXISTENT;
>   		if (rbd_obj_is_entire(obj_req))
> @@ -3286,6 +3295,7 @@ static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, int *result)
>   	case RBD_OBJ_WRITE_START:
>   		rbd_assert(!*result);
>   
> +		rbd_obj_set_copyup_enabled(obj_req);
>   		if (rbd_obj_write_is_noop(obj_req))
>   			return true;
>   
> 

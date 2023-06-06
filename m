Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C491972356A
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 04:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbjFFCn6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Jun 2023 22:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbjFFCn4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Jun 2023 22:43:56 -0400
X-Greylist: delayed 577 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Jun 2023 19:43:54 PDT
Received: from mail-m3173.qiye.163.com (mail-m3173.qiye.163.com [103.74.31.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BBD102
        for <ceph-devel@vger.kernel.org>; Mon,  5 Jun 2023 19:43:53 -0700 (PDT)
Received: from [192.168.0.9] (unknown [218.94.118.90])
        by mail-m3173.qiye.163.com (Hmail) with ESMTPA id CB53AE01C5;
        Tue,  6 Jun 2023 10:34:29 +0800 (CST)
Subject: Re: [PATCH 2/2] rbd: get snapshot context after exclusive lock is
 ensured to be held
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20230605202715.968962-1-idryomov@gmail.com>
 <20230605202715.968962-3-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <cb1cb951-1e87-fa2a-181e-09a754ad6e52@easystack.cn>
Date:   Tue, 6 Jun 2023 10:34:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20230605202715.968962-3-idryomov@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDH0pMVkJMHxofHh5DQh4eTVUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKQ1VKS0tVS1kG
X-HM-Tid: 0a888e8e4a8800adkurmcb53ae01c5
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pj46FQw4NjIML005GktKSlEc
        SSNPCT5VSlVKTUNNS0pDQ0xLTklOVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
        V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTk1DSDcG
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



在 2023/6/6 星期二 上午 4:27, Ilya Dryomov 写道:
> Move capturing the snapshot context into the image request state
> machine, after exclusive lock is ensured to be held for the duration of
> dealing with the image request.  This is needed to ensure correctness
> of fast-diff states (OBJECT_EXISTS vs OBJECT_EXISTS_CLEAN) and object
> deltas computed based off of them.  Otherwise the object map that is
> forked for the snapshot isn't guaranteed to accurately reflect the
> contents of the snapshot when the snapshot is taken under I/O.  This
> breaks differential backup and snapshot-based mirroring use cases with
> fast-diff enabled: since some object deltas may be incomplete, the
> destination image may get corrupted.
> 
> Cc: stable@vger.kernel.org
> Link: https://tracker.ceph.com/issues/61472
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Dongsheng Yang dongsheng.yang@easystack.cn
> ---
>   drivers/block/rbd.c | 30 +++++++++++++++++++++++-------
>   1 file changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 6c847db6ee2c..632751ddb287 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -1336,6 +1336,8 @@ static bool rbd_obj_is_tail(struct rbd_obj_request *obj_req)
>    */
>   static void rbd_obj_set_copyup_enabled(struct rbd_obj_request *obj_req)
>   {
> +	rbd_assert(obj_req->img_request->snapc);
> +
>   	if (obj_req->img_request->op_type == OBJ_OP_DISCARD) {
>   		dout("%s %p objno %llu discard\n", __func__, obj_req,
>   		     obj_req->ex.oe_objno);
> @@ -1456,6 +1458,7 @@ __rbd_obj_add_osd_request(struct rbd_obj_request *obj_req,
>   static struct ceph_osd_request *
>   rbd_obj_add_osd_request(struct rbd_obj_request *obj_req, int num_ops)
>   {
> +	rbd_assert(obj_req->img_request->snapc);
>   	return __rbd_obj_add_osd_request(obj_req, obj_req->img_request->snapc,
>   					 num_ops);
>   }
> @@ -1592,15 +1595,18 @@ static void rbd_img_request_init(struct rbd_img_request *img_request,
>   	mutex_init(&img_request->state_mutex);
>   }
>   
> +/*
> + * Only snap_id is captured here, for reads.  For writes, snapshot
> + * context is captured in rbd_img_object_requests() after exclusive
> + * lock is ensured to be held.
> + */
>   static void rbd_img_capture_header(struct rbd_img_request *img_req)
>   {
>   	struct rbd_device *rbd_dev = img_req->rbd_dev;
>   
>   	lockdep_assert_held(&rbd_dev->header_rwsem);
>   
> -	if (rbd_img_is_write(img_req))
> -		img_req->snapc = ceph_get_snap_context(rbd_dev->header.snapc);
> -	else
> +	if (!rbd_img_is_write(img_req))
>   		img_req->snap_id = rbd_dev->spec->snap_id;
>   
>   	if (rbd_dev_parent_get(rbd_dev))
> @@ -3482,9 +3488,19 @@ static int rbd_img_exclusive_lock(struct rbd_img_request *img_req)
>   
>   static void rbd_img_object_requests(struct rbd_img_request *img_req)
>   {
> +	struct rbd_device *rbd_dev = img_req->rbd_dev;
>   	struct rbd_obj_request *obj_req;
>   
>   	rbd_assert(!img_req->pending.result && !img_req->pending.num_pending);
> +	rbd_assert(!need_exclusive_lock(img_req) ||
> +		   __rbd_is_lock_owner(rbd_dev));
> +
> +	if (rbd_img_is_write(img_req)) {
> +		rbd_assert(!img_req->snapc);
> +		down_read(&rbd_dev->header_rwsem);
> +		img_req->snapc = ceph_get_snap_context(rbd_dev->header.snapc);
> +		up_read(&rbd_dev->header_rwsem);
> +	}
>   
>   	for_each_obj_request(img_req, obj_req) {
>   		int result = 0;
> @@ -3502,7 +3518,6 @@ static void rbd_img_object_requests(struct rbd_img_request *img_req)
>   
>   static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
>   {
> -	struct rbd_device *rbd_dev = img_req->rbd_dev;
>   	int ret;
>   
>   again:
> @@ -3523,9 +3538,6 @@ static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
>   		if (*result)
>   			return true;
>   
> -		rbd_assert(!need_exclusive_lock(img_req) ||
> -			   __rbd_is_lock_owner(rbd_dev));
> -
>   		rbd_img_object_requests(img_req);
>   		if (!img_req->pending.num_pending) {
>   			*result = img_req->pending.result;
> @@ -3987,6 +3999,10 @@ static int rbd_post_acquire_action(struct rbd_device *rbd_dev)
>   {
>   	int ret;
>   
> +	ret = rbd_dev_refresh(rbd_dev);
> +	if (ret)
> +		return ret;
> +
>   	if (rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP) {
>   		ret = rbd_object_map_open(rbd_dev);
>   		if (ret)
> 

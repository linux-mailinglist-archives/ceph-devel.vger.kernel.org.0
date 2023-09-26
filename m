Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA727AE812
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Sep 2023 10:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbjIZI34 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Sep 2023 04:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233835AbjIZI34 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 26 Sep 2023 04:29:56 -0400
X-Greylist: delayed 344 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Sep 2023 01:29:48 PDT
Received: from mail-m127225.xmail.ntesmail.com (mail-m127225.xmail.ntesmail.com [115.236.127.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1915410E
        for <ceph-devel@vger.kernel.org>; Tue, 26 Sep 2023 01:29:47 -0700 (PDT)
Received: from [192.168.122.37] (unknown [218.94.118.90])
        by mail-m3161.qiye.163.com (Hmail) with ESMTPA id 587F54404C4;
        Tue, 26 Sep 2023 16:24:00 +0800 (CST)
Subject: Re: [PATCH 4/4] rbd: take header_rwsem in rbd_dev_refresh() only when
 updating
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20230925194036.197899-1-idryomov@gmail.com>
 <20230925194036.197899-5-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <99159846-2913-9ffe-fa36-776cefecb8d5@easystack.cn>
Date:   Tue, 26 Sep 2023 16:23:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20230925194036.197899-5-idryomov@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDT0NLVh8ZSkgYShhPGRhCTFUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpNT0lMTlVKS0tVSkJLS1kG
X-HM-Tid: 0a8ad09686c400a1kurm587f54404c4
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OhA6Egw*PDExPDYBSRxLPwMZ
        Ei4wCkhVSlVKTUJOTEpNTU9LTExNVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
        V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTk9LTDcG
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



在 2023/9/26 星期二 上午 3:40, Ilya Dryomov 写道:
> rbd_dev_refresh() has been holding header_rwsem across header and
> parent info read-in unnecessarily for ages.  With commit 870611e4877e
> ("rbd: get snapshot context after exclusive lock is ensured to be
> held"), the potential for deadlocks became much more real owning to
> a) header_rwsem now nesting inside lock_rwsem and b) rw_semaphores
> not allowing new readers after a writer is registered.
> 
> For example, assuming that I/O request 1, I/O request 2 and header
> read-in request all target the same OSD:
> 
> 1. I/O request 1 comes in and gets submitted
> 2. watch error occurs
> 3. rbd_watch_errcb() takes lock_rwsem for write, clears owner_cid and
>     releases lock_rwsem
> 4. after reestablishing the watch, rbd_reregister_watch() calls
>     rbd_dev_refresh() which takes header_rwsem for write and submits
>     a header read-in request
> 5. I/O request 2 comes in: after taking lock_rwsem for read in
>     __rbd_img_handle_request(), it blocks trying to take header_rwsem
>     for read in rbd_img_object_requests()
> 6. another watch error occurs
> 7. rbd_watch_errcb() blocks trying to take lock_rwsem for write
> 8. I/O request 1 completion is received by the messenger but can't be
>     processed because lock_rwsem won't be granted anymore
> 9. header read-in request completion can't be received, let alone
>     processed, because the messenger is stranded
> 
> Change rbd_dev_refresh() to take header_rwsem only for actually
> updating rbd_dev->header.  Header and parent info read-in don't need
> any locking.

Nice catch

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>

for the whole patchset.
> 
> Cc: stable@vger.kernel.org # e3580eaee090: rbd: move rbd_dev_refresh() definition
> Cc: stable@vger.kernel.org # 641d828d82d0: rbd: decouple header read-in from updating rbd_dev->header
> Cc: stable@vger.kernel.org # 2147c0b31b95: rbd: decouple parent info read-in from updating rbd_dev
> Cc: stable@vger.kernel.org
> Fixes: 870611e4877e ("rbd: get snapshot context after exclusive lock is ensured to be held")
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>   drivers/block/rbd.c | 22 +++++++++++-----------
>   1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index d62a0298c890..a999b698b131 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -6986,7 +6986,14 @@ static void rbd_dev_update_header(struct rbd_device *rbd_dev,
>   	rbd_assert(rbd_image_format_valid(rbd_dev->image_format));
>   	rbd_assert(rbd_dev->header.object_prefix); /* !first_time */
>   
> -	rbd_dev->header.image_size = header->image_size;
> +	if (rbd_dev->header.image_size != header->image_size) {
> +		rbd_dev->header.image_size = header->image_size;
> +
> +		if (!rbd_is_snap(rbd_dev)) {
> +			rbd_dev->mapping.size = header->image_size;
> +			rbd_dev_update_size(rbd_dev);
> +		}
> +	}
>   
>   	ceph_put_snap_context(rbd_dev->header.snapc);
>   	rbd_dev->header.snapc = header->snapc;
> @@ -7044,11 +7051,9 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
>   {
>   	struct rbd_image_header	header = { 0 };
>   	struct parent_image_info pii = { 0 };
> -	u64 mapping_size;
>   	int ret;
>   
> -	down_write(&rbd_dev->header_rwsem);
> -	mapping_size = rbd_dev->mapping.size;
> +	dout("%s rbd_dev %p\n", __func__, rbd_dev);
>   
>   	ret = rbd_dev_header_info(rbd_dev, &header, false);
>   	if (ret)
> @@ -7064,18 +7069,13 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
>   			goto out;
>   	}
>   
> +	down_write(&rbd_dev->header_rwsem);
>   	rbd_dev_update_header(rbd_dev, &header);
>   	if (rbd_dev->parent)
>   		rbd_dev_update_parent(rbd_dev, &pii);
> -
> -	rbd_assert(!rbd_is_snap(rbd_dev));
> -	rbd_dev->mapping.size = rbd_dev->header.image_size;
> -
> -out:
>   	up_write(&rbd_dev->header_rwsem);
> -	if (!ret && mapping_size != rbd_dev->mapping.size)
> -		rbd_dev_update_size(rbd_dev);
>   
> +out:
>   	rbd_parent_info_cleanup(&pii);
>   	rbd_image_header_cleanup(&header);
>   	return ret;
> 

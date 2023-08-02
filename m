Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB0E76C5DA
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Aug 2023 08:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbjHBGyZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Aug 2023 02:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbjHBGx7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Aug 2023 02:53:59 -0400
Received: from mail-m2835.qiye.163.com (mail-m2835.qiye.163.com [103.74.28.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC7935A9
        for <ceph-devel@vger.kernel.org>; Tue,  1 Aug 2023 23:53:37 -0700 (PDT)
Received: from [192.168.122.37] (unknown [218.94.118.90])
        by mail-m2835.qiye.163.com (Hmail) with ESMTPA id E41208A0098;
        Wed,  2 Aug 2023 14:53:34 +0800 (CST)
Subject: Re: [PATCH] libceph: fix potential hang in ceph_osdc_notify()
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20230801222529.674721-1-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <27913bcb-9315-004d-8c71-6ccde10580bf@easystack.cn>
Date:   Wed, 2 Aug 2023 14:53:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20230801222529.674721-1-idryomov@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDGEIfVkNJQ00fTE1NQxoeTFUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpNT0lMTlVKS0tVSkJLS1kG
X-HM-Tid: 0a89b505f99d841dkuqwe41208a0098
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NBg6Lxw6HjE1FzM1IhQjCCEM
        GDNPCklVSlVKTUJLQk5CSUpOT0lPVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
        V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSE9CSjcG
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



在 2023/8/2 星期三 上午 6:25, Ilya Dryomov 写道:
> If the cluster becomes unavailable, ceph_osdc_notify() may hang even
> with osd_request_timeout option set because linger_notify_finish_wait()
> waits for MWatchNotify NOTIFY_COMPLETE message with no associated OSD
> request in flight -- it's completely asynchronous.
> 
> Introduce an additional timeout, derived from the specified notify
> timeout.  While at it, switch both waits to killable which is more
> correct.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   net/ceph/osd_client.c | 20 ++++++++++++++------
>   1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 11c04e7d928e..658a6f2320cf 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -3334,17 +3334,24 @@ static int linger_reg_commit_wait(struct ceph_osd_linger_request *lreq)
>   	int ret;
>   
>   	dout("%s lreq %p linger_id %llu\n", __func__, lreq, lreq->linger_id);
> -	ret = wait_for_completion_interruptible(&lreq->reg_commit_wait);
> +	ret = wait_for_completion_killable(&lreq->reg_commit_wait);
>   	return ret ?: lreq->reg_commit_error;
>   }
>   
> -static int linger_notify_finish_wait(struct ceph_osd_linger_request *lreq)
> +static int linger_notify_finish_wait(struct ceph_osd_linger_request *lreq,
> +				     unsigned long timeout)
>   {
> -	int ret;
> +	long left;
>   
>   	dout("%s lreq %p linger_id %llu\n", __func__, lreq, lreq->linger_id);
> -	ret = wait_for_completion_interruptible(&lreq->notify_finish_wait);
> -	return ret ?: lreq->notify_finish_error;
> +	left = wait_for_completion_killable_timeout(&lreq->notify_finish_wait,
> +						ceph_timeout_jiffies(timeout));
> +	if (left <= 0)
> +		left = left ?: -ETIMEDOUT;
> +	else
> +		left = lreq->notify_finish_error; /* completed */
> +
> +	return left;
>   }
>   
>   /*
> @@ -4896,7 +4903,8 @@ int ceph_osdc_notify(struct ceph_osd_client *osdc,
>   	linger_submit(lreq);
>   	ret = linger_reg_commit_wait(lreq);
>   	if (!ret)
> -		ret = linger_notify_finish_wait(lreq);
> +		ret = linger_notify_finish_wait(lreq,
> +				 msecs_to_jiffies(2 * timeout * MSEC_PER_SEC));
>   	else
>   		dout("lreq %p failed to initiate notify %d\n", lreq, ret);
>   
> 

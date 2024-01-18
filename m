Return-Path: <ceph-devel+bounces-582-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDBB78316C8
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jan 2024 11:47:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 585B7B23AFA
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jan 2024 10:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA30922F09;
	Thu, 18 Jan 2024 10:47:11 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-m92248.xmail.ntesmail.com (mail-m92248.xmail.ntesmail.com [103.126.92.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94F4B65C
	for <ceph-devel@vger.kernel.org>; Thu, 18 Jan 2024 10:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.126.92.248
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705574831; cv=none; b=CcuBHdwbnYAj0xvYvdPWlh1CVjkljYDhkmI5SJjkh9TEeYmcGRAjg6CMO1XxQhBOsiXRwOSdTUI6FoceK1p/HLiyTur++x2sU7HyAqGwmyIbCqnwuep3Qm5+c6hBioezdvUYpqNol1Nq82XG6rshbMZT9a8c0+h8Jvj1IIbQ+wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705574831; c=relaxed/simple;
	bh=6C1ClHflWcyFfmTYP5mxKK8kT/PjD7Z7dZt3dCyUof0=;
	h=Received:Subject:To:Cc:References:From:Message-ID:Date:User-Agent:
	 MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-HM-Spam-Status:X-HM-Tid:X-HM-MType:X-HM-Sender-Digest; b=FC2ZJYToBxzSLMO96vVlU8eHbUg7be2C/GmvglDI3qae5aaWED56iqK3UwbBZ7nxZ2XfLoOYHpVqEKoqQx88IlWHJB4BwRwa9WY3CTtxg/PgHHemfO+R7a5TFytvdGVq/66npGyhWP6NSCsU1cOmf9oJRAMdpdjQKKeS7nJxMIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn; spf=none smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=103.126.92.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=easystack.cn
Received: from [192.168.122.189] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTPA id C01E68602CD;
	Thu, 18 Jan 2024 18:46:50 +0800 (CST)
Subject: Re: [PATCH] rbd: don't move requests to the running list on errors
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
References: <20240117183542.1431147-1-idryomov@gmail.com>
 <88e01e98-6e1b-446f-7d23-a576a2b5f890@easystack.cn>
 <CAOi1vP8qAN3JivSUaqjNODRLQqhcYDg1w-ByKgHcdStNjP_-Jg@mail.gmail.com>
From: Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <b61088eb-cce5-48f6-391e-759e00ee7018@easystack.cn>
Date: Thu, 18 Jan 2024 18:46:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAOi1vP8qAN3JivSUaqjNODRLQqhcYDg1w-ByKgHcdStNjP_-Jg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkaTElKVkJJSUxPS0NJTRpMSVUZERMWGhIXJBQOD1
	lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpNT0lOSFVKS0tVSkJLS1kG
X-HM-Tid: 0a8d1c2e450d023ckunmc01e68602cd
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6KxA6Pww5Djc2AwJNOh9NQgIf
	DxYKCh9VSlVKTEtOTkxPQ0pKSUhCVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
	V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTkxCSDcG



在 2024/1/18 星期四 下午 6:24, Ilya Dryomov 写道:
> On Thu, Jan 18, 2024 at 4:13 AM Dongsheng Yang
> <dongsheng.yang@easystack.cn> wrote:
>>
>>
>>
>> 在 2024/1/18 星期四 上午 2:35, Ilya Dryomov 写道:
>>> The running list is supposed to contain requests that are pinning the
>>> exclusive lock, i.e. those that must be flushed before exclusive lock
>>> is released.  When wake_lock_waiters() is called to handle an error,
>>> requests on the acquiring list are failed with that error and no
>>> flushing takes place.  Briefly moving them to the running list is not
>>> only pointless but also harmful: if exclusive lock gets acquired
>>> before all of their state machines are scheduled and go through
>>> rbd_lock_del_request(), we trigger
>>>
>>>       rbd_assert(list_empty(&rbd_dev->running_list));
>>>
>>> in rbd_try_acquire_lock().
>>>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 637cd060537d ("rbd: new exclusive lock wait/wake code")
>>> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>>> ---
>>>    drivers/block/rbd.c | 22 ++++++++++++++--------
>>>    1 file changed, 14 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
>>> index 63897d0d6629..12b5d53ec856 100644
>>> --- a/drivers/block/rbd.c
>>> +++ b/drivers/block/rbd.c
>>> @@ -3452,14 +3452,15 @@ static bool rbd_lock_add_request(struct rbd_img_request *img_req)
>>>    static void rbd_lock_del_request(struct rbd_img_request *img_req)
>>>    {
>>>        struct rbd_device *rbd_dev = img_req->rbd_dev;
>>> -     bool need_wakeup;
>>> +     bool need_wakeup = false;
>>>
>>>        lockdep_assert_held(&rbd_dev->lock_rwsem);
>>>        spin_lock(&rbd_dev->lock_lists_lock);
>>> -     rbd_assert(!list_empty(&img_req->lock_item));
>>> -     list_del_init(&img_req->lock_item);
>>> -     need_wakeup = (rbd_dev->lock_state == RBD_LOCK_STATE_RELEASING &&
>>> -                    list_empty(&rbd_dev->running_list));
>>> +     if (!list_empty(&img_req->lock_item)) {
>>> +             list_del_init(&img_req->lock_item);
>>> +             need_wakeup = (rbd_dev->lock_state == RBD_LOCK_STATE_RELEASING &&
>>> +                            list_empty(&rbd_dev->running_list));
>>> +     }
>>>        spin_unlock(&rbd_dev->lock_lists_lock);
>>>        if (need_wakeup)
>>>                complete(&rbd_dev->releasing_wait);
>>> @@ -3842,14 +3843,19 @@ static void wake_lock_waiters(struct rbd_device *rbd_dev, int result)
>>>                return;
>>>        }
>>>
>>> -     list_for_each_entry(img_req, &rbd_dev->acquiring_list, lock_item) {
>>> +     while (!list_empty(&rbd_dev->acquiring_list)) {
>>> +             img_req = list_first_entry(&rbd_dev->acquiring_list,
>>> +                                        struct rbd_img_request, lock_item);
>>>                mutex_lock(&img_req->state_mutex);
>>>                rbd_assert(img_req->state == RBD_IMG_EXCLUSIVE_LOCK);
>>> +             if (!result)
>>> +                     list_move_tail(&img_req->lock_item,
>>> +                                    &rbd_dev->running_list);
>>> +             else
>>> +                     list_del_init(&img_req->lock_item);
>>>                rbd_img_schedule(img_req, result);
>>>                mutex_unlock(&img_req->state_mutex);
>>>        }
>>> -
>>> -     list_splice_tail_init(&rbd_dev->acquiring_list, &rbd_dev->running_list);
>>
>> Hi Ilya,
>>          If we dont move these requests to ->running_list, then the need_wakeup
>> is always false for these requests. So who will finally complete the
>> &rbd_dev->releaseing_wait ?
> 
> Hi Dongsheng,
> 
> These requests are woken up explicitly in rbd_img_schedule().  Because
> img_req->work_result would be set to an error, the state machine would
> finish immediately on:
> 
>      case RBD_IMG_EXCLUSIVE_LOCK:
>              if (*result)
>                      return true;
> 
> rbd_dev->releasing_wait doesn't need to be completed in this case
> because these requests are terminated while still on the acquiring
> list.  Waiting for their state machines to get scheduled just to hit
> that "if (*result)" check and bail isn't necessary.

Hi Ilya,
	Thanx for your explanation, looks good to me now.

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>

Thanx
> 
> Thanks,
> 
>                  Ilya
> 


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B83176C5CF
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Aug 2023 08:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbjHBGx6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Aug 2023 02:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbjHBGxo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Aug 2023 02:53:44 -0400
Received: from mail-m2835.qiye.163.com (mail-m2835.qiye.163.com [103.74.28.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F2C30FA
        for <ceph-devel@vger.kernel.org>; Tue,  1 Aug 2023 23:53:17 -0700 (PDT)
Received: from [192.168.122.37] (unknown [218.94.118.90])
        by mail-m2835.qiye.163.com (Hmail) with ESMTPA id 0FE058A005B;
        Wed,  2 Aug 2023 14:52:48 +0800 (CST)
Subject: Re: [PATCH] rbd: prevent busy loop when requesting exclusive lock
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org
References: <20230801222238.674641-1-idryomov@gmail.com>
 <99bdb9ff-be19-6f3c-6b6f-0423f3d12796@easystack.cn>
 <CAOi1vP9s_4j8QLBYRyCTi3XCKdPagtZusM=S+z7BJDbHAVye_Q@mail.gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <256d4476-1fb6-5129-2e52-7a09f194a9b4@easystack.cn>
Date:   Wed, 2 Aug 2023 14:52:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP9s_4j8QLBYRyCTi3XCKdPagtZusM=S+z7BJDbHAVye_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCGBofVkxPHkJLTRhCThlJTlUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpNT0lMTlVKS0tVSkJLS1kG
X-HM-Tid: 0a89b50543a7841dkuqw0fe058a005b
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6ODo6CSo*DjEzMTMySRRKCUs8
        Ph9PFBZVSlVKTUJLQk5CSk1DQ0xJVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
        V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT0tOSDcG
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



在 2023/8/2 星期三 下午 2:41, Ilya Dryomov 写道:
> On Wed, Aug 2, 2023 at 8:36 AM Dongsheng Yang
> <dongsheng.yang@easystack.cn> wrote:
>>
>> Hi Ilya
>>
>> 在 2023/8/2 星期三 上午 6:22, Ilya Dryomov 写道:
>>> Due to rbd_try_acquire_lock() effectively swallowing all but
>>> EBLOCKLISTED error from rbd_try_lock() ("request lock anyway") and
>>> rbd_request_lock() returning ETIMEDOUT error not only for an actual
>>> notify timeout but also when the lock owner doesn't respond, a busy
>>> loop inside of rbd_acquire_lock() between rbd_try_acquire_lock() and
>>> rbd_request_lock() is possible.
>>>
>>> Requesting the lock on EBUSY error (returned by get_lock_owner_info()
>>> if an incompatible lock or invalid lock owner is detected) makes very
>>> little sense.  The same goes for ETIMEDOUT error (might pop up pretty
>>> much anywhere if osd_request_timeout option is set) and many others.
>>>
>>> Just fail I/O requests on rbd_dev->acquiring_list immediately on any
>>> error from rbd_try_lock().
>>>
>>> Cc: stable@vger.kernel.org # 588159009d5b: rbd: retrieve and check lock owner twice before blocklisting
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>>> ---
>>>    drivers/block/rbd.c | 28 +++++++++++++++-------------
>>>    1 file changed, 15 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
>>> index 24afcc93ac01..2328cc05be36 100644
>>> --- a/drivers/block/rbd.c
>>> +++ b/drivers/block/rbd.c
>>> @@ -3675,7 +3675,7 @@ static int rbd_lock(struct rbd_device *rbd_dev)
>>>        ret = ceph_cls_lock(osdc, &rbd_dev->header_oid, &rbd_dev->header_oloc,
>>>                            RBD_LOCK_NAME, CEPH_CLS_LOCK_EXCLUSIVE, cookie,
>>>                            RBD_LOCK_TAG, "", 0);
>>> -     if (ret)
>>> +     if (ret && ret != -EEXIST)
>>>                return ret;
>>>
>>>        __rbd_lock(rbd_dev, cookie);
>>
>> If we got -EEXIST here, we will call __rbd_lock() and return 0. -EEXIST
>> means lock is held by myself, is that necessary to call __rbd_lock()?
> 
> Hi Dongsheng,
> 
> Yes, because the reason rbd_lock() gets called in the first place is
> that the kernel client doesn't "know" that it's still holding the lock
> in RADOS.  This can happen if the unlock operation times out, for
> example.
> 
> Notice
> 
>          WARN_ON(__rbd_is_lock_owner(rbd_dev) ||
>                  rbd_dev->lock_cookie[0] != '\0');
> 
> at the top of rbd_lock().

Okey, then

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> 
> Thanks,
> 
>                  Ilya
> .
> 

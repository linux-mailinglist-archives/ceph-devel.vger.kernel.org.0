Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5177F1BC050
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Apr 2020 15:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgD1NzF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Apr 2020 09:55:05 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59976 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726868AbgD1NzF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 09:55:05 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D7F1FFE6ACFFF91720DA;
        Tue, 28 Apr 2020 21:54:47 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.100) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Tue, 28 Apr 2020
 21:54:39 +0800
Subject: Re: [PATCH] fs/ceph:fix double unlock in handle_cap_export()
To:     "Yan, Zheng" <ukernel@gmail.com>
CC:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Ilya Dryomov" <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        <liuzhiqiang26@huawei.com>, <linfeilong@huawei.com>
References: <1588077962-353994-1-git-send-email-wubo40@huawei.com>
 <CAAM7YAnWM4oHgwBNXQWY5BOMDmZ9Pbqdd7N0DDedTO6HxQQeqg@mail.gmail.com>
From:   Wu Bo <wubo40@huawei.com>
Message-ID: <f40f07f4-27b8-5308-80f6-9d2904c8dd52@huawei.com>
Date:   Tue, 28 Apr 2020 21:54:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAAM7YAnWM4oHgwBNXQWY5BOMDmZ9Pbqdd7N0DDedTO6HxQQeqg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.215.100]
X-CFilter-Loop: Reflected
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/4/28 21:41, Yan, Zheng wrote:
> On Tue, Apr 28, 2020 at 8:50 PM Wu Bo <wubo40@huawei.com> wrote:
>>
>> If the ceph_mdsc_open_export_target_session() return fails,
>> should add a lock to avoid twice unlocking.
>> Because the lock will be released at the retry or out_unlock tag.
>>
> 
> at retry label, i_ceph_lock get locked. I don't see how i_ceph_lock
> can get double unlock
>sorry, maybe I didn't describe it clearly enough, not i_ceph_lock, but 
session->s_mutex.

Thanks.

Wu Bo
>> Signed-off-by: Wu Bo <wubo40@huawei.com>
>> ---
>>   fs/ceph/caps.c | 26 ++++++++++++++------------
>>   1 file changed, 14 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 185db76..b5a62a8 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -3731,22 +3731,24 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>>
>>          /* open target session */
>>          tsession = ceph_mdsc_open_export_target_session(mdsc, target);
>> -       if (!IS_ERR(tsession)) {
>> -               if (mds > target) {
>> -                       mutex_lock(&session->s_mutex);
>> -                       mutex_lock_nested(&tsession->s_mutex,
>> -                                         SINGLE_DEPTH_NESTING);
>> -               } else {
>> -                       mutex_lock(&tsession->s_mutex);
>> -                       mutex_lock_nested(&session->s_mutex,
>> -                                         SINGLE_DEPTH_NESTING);
>> -               }
>> -               new_cap = ceph_get_cap(mdsc, NULL);
>> -       } else {
>> +       if (IS_ERR(tsession)) {
>>                  WARN_ON(1);
>>                  tsession = NULL;
>>                  target = -1;
>> +               mutex_lock(&session->s_mutex);
>> +               goto out_unlock;
>> +       }
>> +
>> +       if (mds > target) {
>> +               mutex_lock(&session->s_mutex);
>> +               mutex_lock_nested(&tsession->s_mutex,
>> +                                       SINGLE_DEPTH_NESTING);
>> +       } else {
>> +               mutex_lock(&tsession->s_mutex);
>> +               mutex_lock_nested(&session->s_mutex,
>> +                                       SINGLE_DEPTH_NESTING);
>>          }
>> +       new_cap = ceph_get_cap(mdsc, NULL);
>>          goto retry;
>>
>>   out_unlock:
>> --
>> 1.8.3.1
>>
> 
> .
> 



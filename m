Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473FC3BA6A2
	for <lists+ceph-devel@lfdr.de>; Sat,  3 Jul 2021 03:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhGCBgG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Jul 2021 21:36:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49848 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230017AbhGCBgG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Jul 2021 21:36:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625276013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2wp9z/3iSUjXYkr8aC6c1PIEXxI5t7wNwJn3Y9wTS08=;
        b=QZiDjC1WnQ4F6kGuVCZR8T382sSdfzkwPJS86zfWqJLscvxFwzHgz0C1JGFKFDkTOQjFEm
        KXS/MAALJNsCPrhHy7hIlGtPuJZHkRIXNZ6wPc++Ykn7B9NttoQ6uvfkHJVCs20ne5tiXY
        s2IuVRC4Coj8KAg067TcrARZqBfyYos=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-1cGsRfOVPKmHQ2gOBMxJJA-1; Fri, 02 Jul 2021 21:33:32 -0400
X-MC-Unique: 1cGsRfOVPKmHQ2gOBMxJJA-1
Received: by mail-pj1-f70.google.com with SMTP id cm22-20020a17090afa16b0290170b1e4383fso5737787pjb.1
        for <ceph-devel@vger.kernel.org>; Fri, 02 Jul 2021 18:33:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=2wp9z/3iSUjXYkr8aC6c1PIEXxI5t7wNwJn3Y9wTS08=;
        b=io5iFANvvJVI1NY8nYXfIEV/n2Txf72T9UdkbkjMvZByb4tm7rxZoSfOgL5bzSJuwy
         mjMIjLLAIj8DMXk0q+DT+CHuJrpuajHyA7JlrneKd2IFDSAuE9W8LqTu/+DMlqg+LnJz
         s6dvYy1Ee+Awc+L4sbLoh8bo3QI7kyAGp2ury9pN8nHr3cL7CNckYiwpyJFDtBtjpPfg
         NRU8xurSDOaYoFNJq8dpWypQCyTe0mIBLRutX2MdwEsYx9Wkj4MBHuc0QjpXD/n4S4oA
         +9+ccpeTbmF4Dx25arUdPzweRlWkhcbZjw371yBqGlxa0vno/h+xS21tq/KRdHilATaw
         xMLw==
X-Gm-Message-State: AOAM531HEwm36EN7uUWSJ3TP6GiWANeW2XwwpPa++9at4yizQWi/82At
        fg3d9F7gUwvkaFXtyCaXAX7gZ9fI2x3bVC3IuUBhuuBa4QQy/x6/i6XXdAhn/3qBHLSPfifx+jn
        EID2hBOK4etaH/5WOZ6vXa0dqt0BL7Sx0tG6KLrG32pNCH5MgChrzpxjTFPGPGsQDZ/yDmFY=
X-Received: by 2002:a65:4949:: with SMTP id q9mr1956897pgs.327.1625276010923;
        Fri, 02 Jul 2021 18:33:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpG4SnttGA5IgQyju7i2fmdO4cNUassmy8ilpxed1Yj1PKe/xFf52rS3A8yEIGZZlpy/N7vg==
X-Received: by 2002:a65:4949:: with SMTP id q9mr1956868pgs.327.1625276010611;
        Fri, 02 Jul 2021 18:33:30 -0700 (PDT)
Received: from [10.72.12.103] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g204sm4842983pfb.206.2021.07.02.18.33.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 18:33:29 -0700 (PDT)
Subject: Re: [PATCH 4/5] ceph: flush the mdlog before waiting on unsafe reqs
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20210629044241.30359-1-xiubli@redhat.com>
 <20210629044241.30359-5-xiubli@redhat.com>
 <b531585184df099e633a4b92e3be23b4b8384253.camel@kernel.org>
 <4f2f6de6-eb1f-1527-de73-2378f262228b@redhat.com>
 <2e8aabad80e166d7c628fde9d820fc5f403e034f.camel@kernel.org>
 <379d5257-f182-c455-9675-b199aeb8ce1b@redhat.com>
 <CA+2bHPZNQU9wZr2W3FjW453KKFVi4q+LwVyicTPQ7kihhoQpQg@mail.gmail.com>
 <e917a3e1-2902-604b-5154-98086c95357f@redhat.com>
 <CA+2bHPY=xyqW48RfuGX8C9Br7vRUArF66AK5yDTOKH4Ewdt8dg@mail.gmail.com>
 <838be760-4d61-9fc7-be8c-59deea9d0e98@redhat.com>
 <CA+2bHPbtUchykAeDcH1rh5YXzJHRMLPtOaHy7f332scX+9wmHw@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b32a4f22-52f5-9c1d-a89f-373093c84dca@redhat.com>
Date:   Sat, 3 Jul 2021 09:33:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CA+2bHPbtUchykAeDcH1rh5YXzJHRMLPtOaHy7f332scX+9wmHw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/3/21 2:14 AM, Patrick Donnelly wrote:
> On Fri, Jul 2, 2021 at 6:17 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 7/2/21 7:46 AM, Patrick Donnelly wrote:
>>> On Wed, Jun 30, 2021 at 11:18 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>> And just now I have run by adding the time stamp:
>>>>
>>>>> fd = open("/path")
>>>>> fopenat(fd, "foo")
>>>>> renameat(fd, "foo", fd, "bar")
>>>>> fstat(fd)
>>>>> fsync(fd)
>>>> lxb ----- before renameat ---> Current time is Thu Jul  1 13:28:52 2021
>>>> lxb ----- after renameat ---> Current time is Thu Jul  1 13:28:52 2021
>>>> lxb ----- before fstat ---> Current time is Thu Jul  1 13:28:52 2021
>>>> lxb ----- after fstat ---> Current time is Thu Jul  1 13:28:52 2021
>>>> lxb ----- before fsync ---> Current time is Thu Jul  1 13:28:52 2021
>>>> lxb ----- after fsync ---> Current time is Thu Jul  1 13:28:56 2021
>>>>
>>>> We can see that even after 'fstat(fd)', the 'fsync(fd)' still will wait around 4s.
>>>>
>>>> Why your test worked it should be the MDS's tick thread and the 'fstat(fd)' were running almost simultaneously sometimes, I also could see the 'fsync(fd)' finished very fast sometimes:
>>>>
>>>> lxb ----- before renameat ---> Current time is Thu Jul  1 13:29:51 2021
>>>> lxb ----- after renameat ---> Current time is Thu Jul  1 13:29:51 2021
>>>> lxb ----- before fstat ---> Current time is Thu Jul  1 13:29:51 2021
>>>> lxb ----- after fstat ---> Current time is Thu Jul  1 13:29:51 2021
>>>> lxb ----- before fsync ---> Current time is Thu Jul  1 13:29:51 2021
>>>> lxb ----- after fsync ---> Current time is Thu Jul  1 13:29:51 2021
>>> Actually, I did a lot more testing on this. It's a unique behavior of
>>> the directory is /. You will see a getattr force a flush of the
>>> journal:
>>>
>>> 2021-07-01T23:42:18.095+0000 7fcc7741c700  7 mds.0.server
>>> dispatch_client_request client_request(client.4257:74 getattr
>>> pAsLsXsFs #0x1 2021-07-01T23:42:18.095884+0000 caller_uid=1147,
>>> caller_gid=1147{1000,1147,}) v5
>>> ...
>>> 2021-07-01T23:42:18.096+0000 7fcc7741c700 10 mds.0.locker nudge_log
>>> (ifile mix->sync w=2) on [inode 0x1 [...2,head] / auth v34 pv39 ap=6
>>> snaprealm=0x564734479600 DIRTYPARENT f(v0
>>> m2021-07-01T23:38:00.418466+0000 3=1+2) n(v6
>>> rc2021-07-01T23:38:15.692076+0000 b65536 7=2+5)/n(v0
>>> rc2021-07-01T19:31:40.924877+0000 1=0+1) (iauth sync r=1) (isnap sync
>>> r=4) (inest mix w=3) (ipolicy sync r=2) (ifile mix->sync w=2)
>>> (iversion lock w=3) caps={4257=pAsLsXs/-@32} | dirtyscattered=0
>>> request=1 lock=6 dirfrag=1 caps=1 dirtyparent=1 dirty=1 waiter=1
>>> authpin=1 0x56473913a580]
>>>
>>> You don't see that getattr for directories other than root. That's
>>> probably because the client has been issued more caps than what the
>>> MDS is willing to normally hand out for root.
>> For the root dir, when doing the 'rename' the wrlock_start('ifile lock')
>> will change the lock state 'SYNC' --> 'MIX'. Then the inode 0x1 will
>> issue 'pAsLsXs' to clients. So when the client sends a 'getattr' request
>> with caps 'AsXsFs' wanted, the mds will try to switch the 'ifile lock'
>> state back to 'SYNC' to get the 'Fs' cap. Since the rdlock_start('ifile
>> lock') needs to do the lock state transition, it will wait and trigger
>> the 'nudge_log'.
>>
>> The reason why will wrlock_start('ifile lock') change the lock state
>> 'SYNC' --> 'MIX' above is that the inode '0x1' has subtree, if my
>> understanding is correct so for the root dir it should be very probably
>> shared by multiple MDSes and it chooses to switch to MIX.
>>
>> This is why the root dir will work when we send a 'getattr' request.
>>
>>
>> For the none root directories, it will bump to loner and then the
>> 'ifile/iauth/ixattr locks' state switched to EXCL instead, for this lock
>> state it will issue 'pAsxLsXsxFsx' cap. So when doing the
>> 'getattr(AsXsFs)' in client, it will do nothing since it's already
>> issued the caps needed. This is why we couldn't see the getattr request
>> was sent out.
>>
>> Even we 'forced' to call the getattr, it can get the rdlock immediately
>> and no need to gather or do lock state transition, so no 'nudge_log' was
>> called. Since in case if the none directories are in loner mode and the
>> locks will be in 'EXCL' state, so it will allow 'pAsxLsXsxFsxrwb' as
>> default, then even we 'forced' call the getattr('pAsxLsXsxFsxrwb') in
>> fsync, in the MDS side it still won't do the lock states transition.
>>
>>
>>> I'm not really sure why there is a difference. I even experimented
>>> with redundant getattr ("forced") calls to cause a journal flush on
>>> non-root directories but didn't get anywhere. Maybe you can
>>> investigate further? It'd be optimal if we could nudge the log just by
>>> doing a getattr.
>> So in the above case, from my tests and reading the Locker code, I
>> didn't figure out how can the getattr could work for this issue yet.
>>
>> Patrick,
>>
>> Did I miss something about the Lockers ?
> No, your analysis looks right. Thanks.
>
> I suppose this flush_mdlog message is the best tool we have to fix this.
>
Cool.

I will post the second version of this patch series by just sending the 
mdlog flush requests to the relevant and auth MDSes. I will fix this in 
fuse client, which is trying to send mdlog flush to all the MDSes, later.

Thanks Patrick.

BRs



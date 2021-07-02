Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A414F3BA118
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jul 2021 15:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbhGBNTz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Jul 2021 09:19:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27316 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231899AbhGBNTy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Jul 2021 09:19:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625231842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=suQ2SBJYRyz83Xz9KNESV8RFTLlZTKpeyX89DHt9QDk=;
        b=IGdYzFKw8gD4WQ76TQHaHEvds52BTKaX8OHIN+RXdT27hv4p9Tqu9Y4x7zMGMO0PwwVdNC
        BsLbJt8w2JPSDDfhUWAdGI4sppHFX3k3z1UxIaEzxoWHjXTIU0vLb3XagTIrT9TVv0NI1q
        R0o6135dg9lxHWoJ7MvLWQWbhWeVCPI=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-YquHG-MpOmmsQVDBCOP2NA-1; Fri, 02 Jul 2021 09:17:21 -0400
X-MC-Unique: YquHG-MpOmmsQVDBCOP2NA-1
Received: by mail-pj1-f70.google.com with SMTP id r17-20020a17090aa091b029016eedf1dd17so6034554pjp.0
        for <ceph-devel@vger.kernel.org>; Fri, 02 Jul 2021 06:17:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=suQ2SBJYRyz83Xz9KNESV8RFTLlZTKpeyX89DHt9QDk=;
        b=rpnL2lSyMa6TqT7tI6wK0ZFNO4a7aQoi7M6SXVvtyl0mHCRVAzQV1J8GhuxJeEc2ta
         ynzVL0oUL3H4gknGVqsdMqjjBaeZ59okJYXPQNO53NaYm+bsJ+MB5p8Zdces3ILxy2gi
         X8MWQd0RjaWqhN51iwyV2EJT8oaaq//NYu5DcnnYcrgxcBhlIVed9VrYhTcnaVbj4LVM
         JgSSBINSJF704Dplwp2sDk97ojEMcLW3r1cFCCo6ARpHGAQEGCOF/DmBg42w77DJFqav
         gI1DNVLHcmR3vqJov1E4eK9D2xXQMeQNgGVhXnSRdAnh60lHVclgxQgLdUKfTrZPfTdU
         13qA==
X-Gm-Message-State: AOAM530M77bJCzNj7fuef5dew8W+qYhVbZ8AdfbSALRp8S0O3vQuVFHW
        2xq01AOlvSDKAjw84Ne2Xcd9eJOnOWdGGNPVWdFEyyBl8Q3XlRsAtlERd6csxAZDbkViIwpqc9E
        5Yt2dWKRkH3H52T7gTkD7eFyY/XDM1kRMwpYv0qMndfWH4yyRCZog6yvipWRR08xlsiRw3h8=
X-Received: by 2002:a17:90a:a108:: with SMTP id s8mr15167020pjp.85.1625231839781;
        Fri, 02 Jul 2021 06:17:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyqSPyUkM/jBq63eeM8++gi6U8oAKGtlN4J+Hjds1I+beQ0xBwchhvwY2AzI9Za25HRK66Fg==
X-Received: by 2002:a17:90a:a108:: with SMTP id s8mr15166985pjp.85.1625231839370;
        Fri, 02 Jul 2021 06:17:19 -0700 (PDT)
Received: from [10.72.12.103] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a130sm3831008pfa.90.2021.07.02.06.17.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 06:17:19 -0700 (PDT)
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
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <838be760-4d61-9fc7-be8c-59deea9d0e98@redhat.com>
Date:   Fri, 2 Jul 2021 21:17:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CA+2bHPY=xyqW48RfuGX8C9Br7vRUArF66AK5yDTOKH4Ewdt8dg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/2/21 7:46 AM, Patrick Donnelly wrote:
> On Wed, Jun 30, 2021 at 11:18 PM Xiubo Li <xiubli@redhat.com> wrote:
>> And just now I have run by adding the time stamp:
>>
>>> fd = open("/path")
>>> fopenat(fd, "foo")
>>> renameat(fd, "foo", fd, "bar")
>>> fstat(fd)
>>> fsync(fd)
>> lxb ----- before renameat ---> Current time is Thu Jul  1 13:28:52 2021
>> lxb ----- after renameat ---> Current time is Thu Jul  1 13:28:52 2021
>> lxb ----- before fstat ---> Current time is Thu Jul  1 13:28:52 2021
>> lxb ----- after fstat ---> Current time is Thu Jul  1 13:28:52 2021
>> lxb ----- before fsync ---> Current time is Thu Jul  1 13:28:52 2021
>> lxb ----- after fsync ---> Current time is Thu Jul  1 13:28:56 2021
>>
>> We can see that even after 'fstat(fd)', the 'fsync(fd)' still will wait around 4s.
>>
>> Why your test worked it should be the MDS's tick thread and the 'fstat(fd)' were running almost simultaneously sometimes, I also could see the 'fsync(fd)' finished very fast sometimes:
>>
>> lxb ----- before renameat ---> Current time is Thu Jul  1 13:29:51 2021
>> lxb ----- after renameat ---> Current time is Thu Jul  1 13:29:51 2021
>> lxb ----- before fstat ---> Current time is Thu Jul  1 13:29:51 2021
>> lxb ----- after fstat ---> Current time is Thu Jul  1 13:29:51 2021
>> lxb ----- before fsync ---> Current time is Thu Jul  1 13:29:51 2021
>> lxb ----- after fsync ---> Current time is Thu Jul  1 13:29:51 2021
> Actually, I did a lot more testing on this. It's a unique behavior of
> the directory is /. You will see a getattr force a flush of the
> journal:
>
> 2021-07-01T23:42:18.095+0000 7fcc7741c700  7 mds.0.server
> dispatch_client_request client_request(client.4257:74 getattr
> pAsLsXsFs #0x1 2021-07-01T23:42:18.095884+0000 caller_uid=1147,
> caller_gid=1147{1000,1147,}) v5
> ...
> 2021-07-01T23:42:18.096+0000 7fcc7741c700 10 mds.0.locker nudge_log
> (ifile mix->sync w=2) on [inode 0x1 [...2,head] / auth v34 pv39 ap=6
> snaprealm=0x564734479600 DIRTYPARENT f(v0
> m2021-07-01T23:38:00.418466+0000 3=1+2) n(v6
> rc2021-07-01T23:38:15.692076+0000 b65536 7=2+5)/n(v0
> rc2021-07-01T19:31:40.924877+0000 1=0+1) (iauth sync r=1) (isnap sync
> r=4) (inest mix w=3) (ipolicy sync r=2) (ifile mix->sync w=2)
> (iversion lock w=3) caps={4257=pAsLsXs/-@32} | dirtyscattered=0
> request=1 lock=6 dirfrag=1 caps=1 dirtyparent=1 dirty=1 waiter=1
> authpin=1 0x56473913a580]
>
> You don't see that getattr for directories other than root. That's
> probably because the client has been issued more caps than what the
> MDS is willing to normally hand out for root.

For the root dir, when doing the 'rename' the wrlock_start('ifile lock') 
will change the lock state 'SYNC' --> 'MIX'. Then the inode 0x1 will 
issue 'pAsLsXs' to clients. So when the client sends a 'getattr' request 
with caps 'AsXsFs' wanted, the mds will try to switch the 'ifile lock' 
state back to 'SYNC' to get the 'Fs' cap. Since the rdlock_start('ifile 
lock') needs to do the lock state transition, it will wait and trigger 
the 'nudge_log'.

The reason why will wrlock_start('ifile lock') change the lock state 
'SYNC' --> 'MIX' above is that the inode '0x1' has subtree, if my 
understanding is correct so for the root dir it should be very probably 
shared by multiple MDSes and it chooses to switch to MIX.

This is why the root dir will work when we send a 'getattr' request.


For the none root directories, it will bump to loner and then the 
'ifile/iauth/ixattr locks' state switched to EXCL instead, for this lock 
state it will issue 'pAsxLsXsxFsx' cap. So when doing the 
'getattr(AsXsFs)' in client, it will do nothing since it's already 
issued the caps needed. This is why we couldn't see the getattr request 
was sent out.

Even we 'forced' to call the getattr, it can get the rdlock immediately 
and no need to gather or do lock state transition, so no 'nudge_log' was 
called. Since in case if the none directories are in loner mode and the 
locks will be in 'EXCL' state, so it will allow 'pAsxLsXsxFsxrwb' as 
default, then even we 'forced' call the getattr('pAsxLsXsxFsxrwb') in 
fsync, in the MDS side it still won't do the lock states transition.


>
> I'm not really sure why there is a difference. I even experimented
> with redundant getattr ("forced") calls to cause a journal flush on
> non-root directories but didn't get anywhere. Maybe you can
> investigate further? It'd be optimal if we could nudge the log just by
> doing a getattr.

So in the above case, from my tests and reading the Locker code, I 
didn't figure out how can the getattr could work for this issue yet.

Patrick,

Did I miss something about the Lockers ?


BRs

Xiubo



Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09AB41171B
	for <lists+ceph-devel@lfdr.de>; Mon, 20 Sep 2021 16:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237073AbhITOds (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 20 Sep 2021 10:33:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26953 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237218AbhITOdq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 20 Sep 2021 10:33:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632148339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F52ubOrJkCN8PcDbKeG4EQevmrLAxr+H9gLlwkWJld0=;
        b=HHEsDTgSuRKG94U/c2BKaRKUSY/rXqPyy1saJ1p5xyg0aVwIvvj/4D/NIdtVosEmjuuiaX
        tvXAZQTQYzPViqUSFsJwid3Sb69l5LgLU2zmZIJjOU1pC8h6SQGRmgnpgZ/3PyEPudEAL/
        tTZfldF8dLEAZz+j3Xq6POh4pZ38cWQ=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-mcqX6M6nPaadrYhHZSle6w-1; Mon, 20 Sep 2021 10:32:18 -0400
X-MC-Unique: mcqX6M6nPaadrYhHZSle6w-1
Received: by mail-pf1-f198.google.com with SMTP id v206-20020a627ad7000000b0043e010e5392so13187600pfc.1
        for <ceph-devel@vger.kernel.org>; Mon, 20 Sep 2021 07:32:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=F52ubOrJkCN8PcDbKeG4EQevmrLAxr+H9gLlwkWJld0=;
        b=3UWNXylBP+00MAoTOOgrTeHMA/NVuT68uFTzSXvEnYil5xgnWB30lSvF2uhIOAfMKi
         OOGOGHV7H7PKYCGdRcPPitBWQgyiI2JCa5JjKm/JT0QOPlMdySZuZCHlXbCcKws4zUOx
         6U9vjslHLwdFFkCujukb4jqY2qeLbFenKIM6fhIkD6ah1JgUBQ8LKNeqJIJMtlbD5a/6
         nYNjCvE5aa1jLxOWCVMIevARliO4PDaISdVAOY4PKFJ/K0hyEIXcFJ0k90VqqzCrC6ae
         YA4ppzhFPHBD3rh5/V11nghT1mNxpnR+gGPcZpN3vpgnBTjI8zfz1pKICM5/O7VX2HOf
         5dZg==
X-Gm-Message-State: AOAM530whI5HTt3W+lyjr9imk2MwtfftXCahfGxwXXoYL2KN5jhbUS2p
        eEC68UUax/UMcO/KdLu6uyl1DuiSEAVKMoWuBGqz92lFUPk9DYBIs4WSrSufwRyJEH8D4DYcjdS
        JmWTF5yfNUYcfsiNcaWr9RQ3OTooOYoA5T8vdlBf2P/l/D2BWndm9ILCuw1329rgNUlF8IgQ=
X-Received: by 2002:a17:90a:19d2:: with SMTP id 18mr20206294pjj.27.1632148336846;
        Mon, 20 Sep 2021 07:32:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymzogVcWcI792jtzxYXcUrWuqS1PtbgAOBGyukkF9OzEt8wdu6Jb+C5V4GQL7oLjky8UJb8A==
X-Received: by 2002:a17:90a:19d2:: with SMTP id 18mr20206235pjj.27.1632148336269;
        Mon, 20 Sep 2021 07:32:16 -0700 (PDT)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d3sm16135478pga.7.2021.09.20.07.32.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 07:32:15 -0700 (PDT)
Subject: Re: [PATCH RFC 2/2] ceph: truncate the file contents when needed when
 file scrypted
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>
References: <20210903081510.982827-1-xiubli@redhat.com>
 <20210903081510.982827-3-xiubli@redhat.com>
 <34538b56f366596fa96a8da8bf1a60f1c1257367.camel@kernel.org>
 <19fac1bf-804c-1577-7aa8-9dcfa52418f9@redhat.com>
 <e97616fc4f8f090f73a39f56de2ece7ed26fbd65.camel@kernel.org>
 <fabbaeae-d63e-a2e2-0717-47afea66f82f@redhat.com>
 <64c8d4daf2bfd9d20dd55ea1b29af7b7f690407d.camel@kernel.org>
 <cadc9f02-d52e-b1fc-1752-20dd6eb1d1c4@redhat.com>
 <90b25a04fb50b42559f1e153dd4b96df54a58c03.camel@kernel.org>
 <5f33583a-8060-1f0f-d200-abfbd1705ba1@redhat.com>
 <7eb2a71e54cb246a8ce1bea642bbdbd2581122f8.camel@kernel.org>
 <747cf4f4-0048-df9d-c38f-2ab284851320@redhat.com>
 <27b119711a065a2441337298fada3d941c30932a.camel@kernel.org>
 <3b2878f8-9655-b4a0-c6bd-3cf61eaffb13@redhat.com>
 <092f6a9ab8396b53f1f9e7af51e40563a2ea06d2.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <6d84f34d-28d4-1b82-3c70-1209bea37ddf@redhat.com>
Date:   Mon, 20 Sep 2021 22:32:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <092f6a9ab8396b53f1f9e7af51e40563a2ea06d2.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/18/21 1:19 AM, Jeff Layton wrote:
> On Thu, 2021-09-16 at 18:02 +0800, Xiubo Li wrote:
>> On 9/14/21 10:24 PM, Jeff Layton wrote:
>>> On Tue, 2021-09-14 at 13:40 +0800, Xiubo Li wrote:
>>>> On 9/14/21 3:34 AM, Jeff Layton wrote:
>>>>
>>>> [...]
>>>>
>>>>> I'll have to think about whether that's still racy. Part of the problem
>>>>>>>>> is that once the client doesn't have caps, it doesn't have a way to
>>>>>>>>> ensure that fscrypt_file (whatever it holds) doesn't change while it's
>>>>>>>>> doing that zeroing.
>>>>>>>> As my understanding, if clientA want to read a file, it will open it
>>>>>>>> with RD mode, then it will get the fscrypt_file meta and "Fr" caps, then
>>>>>>>> it can safely read the file contents and do the zeroing for that block.
>>>>>>> Ok, so in this case, the client is just zeroing out the appropriate
>>>>>>> region in the resulting read data, and not on the OSD. That should be
>>>>>>> ok.
>>>>>>>
>>>>>>>> Then the opened file shouldn't worry whether the fscrypt_file will be
>>>>>>>> changed by others during it still holding the Fr caps, because if the
>>>>>>>> clientB wants to update the fscrypt_file it must acquire the Fw caps
>>>>>>>> first, before that the Fr caps must be revoked from clientA and at the
>>>>>>>> same time the read pagecache in clientA will be invalidated.
>>>>>>>>
>>>>>>> Are you certain that Fw caps is enough to ensure that no other client
>>>>>>> holds Fr caps?
>>>>>> I spent hours and went through the mds Locker related code on the weekends.
>>>>>>
>>>>>>     From the mds/lock.cc code, for mds filelock for example in the LOCK_MIX
>>>>>> state and some interim transition states to LOCK_MIX it will allow
>>>>>> different clients could hold any of Fw or Fr caps. But the Fb/Fc will be
>>>>>> disabled. Checked the mds/Locker.cc code, found that the mds filelock
>>>>>> could to switch LOCK_MIX state in some cases when there has one client
>>>>>> wants Fw and another client wants any of Fr and Fw.
>>>>>>
>>>>>> In this case I think the Linux advisory or mandatory locks are necessary
>>>>>> to keep the file contents concurrency. In multiple processes' concurrent
>>>>>> read/write or write/write cases without the Linux advisory/mandatory
>>>>>> locks the file contents' concurrency won't be guaranteed, so the logic
>>>>>> is the same here ?
>>>>>>
>>>>>> If so, couldn't we just assume the Fw vs Fw and Fr vs Fw caps should be
>>>>>> exclusive in correct use case ? For example, just after the mds filelock
>>>>>> state switches to LOCK_MIX, if clientA gets the advisory file lock and
>>>>>> the Fw caps, and even another clientB could be successfully issued the
>>>>>> Fr caps, the clientB won't do any read because it should be still stuck
>>>>>> and be waiting for the advisory file lock.
>>>>>>
>>>>> I'm not sure I like that idea. Basically, that would change the meaning
>>>>> of the what Frw caps represent, in a way that is not really consistent
>>>>> with how they have been used before.
>>>>>
>>>>> We could gate that new behavior on the new feature flags, but it sounds
>>>>> pretty tough.
>>>>>
>>>>> I think we have a couple of options:
>>>>>
>>>>> 1) we could just make the clients request and wait on Fx caps when they
>>>>> do a truncate. They might stall for a bit if there is contention, but it
>>>>> would ensure consistency and the client could be completely in charge of
>>>>> the truncate. [a]
>>>> Yeah, for my defer RMW approach we need to held the Fx caps every time
>>>> when writing/truncating files, and the Fs caps every time when reading.
>>>>
>>>> While currently almost all the read/write code have ignored them because
>>>> read/write do not need them in most cases.
>>>>
>>> Note that we already cache truncate operations when we have Fx.
>> Yeah, only when we have Fx and the attr.ia_size > isize will it cache
>> the truncate operation.
>>
>> For this I am a little curious why couldn't we cache truncate operations
>> when attr.ia_size >= isize ?
>>
> It seems to me that if attr.ia_size == i_size, then there is nothing to
> change. We can just optimize that case away, assuming the client has
> caps that ensure the size is correct.

 From MDS side I didn't find any limitation why couldn't we optimize it.


>
> Based on the kclient code, for size changes after a write that extends a
> file, it seems like Fw is sufficient to allow the client to buffer these
> things.

Since the MDS will only allow us to increase the file size, just like 
the mtime/ctime/atime, so even the write size has exceed current file 
size, the Fw is sufficient.


>   For a truncate (aka setattr) operation, we apparently need Fx.

In case one client is truncating the file, if the new size is larger 
than or equal to current size, this should be okay and will behave just 
like normal write case above.

If the new size is smaller, the MDS will handle this in a different way. 
When the MDS received the truncate request, it will first xlock the 
filelock, which will switch the filelock state and in all these possible 
interim or stable states, the Fw caps will be revoked from all the 
clients, but the clients still could cache/buffer the file contents, 
that means no client is allowed to change the size during the truncate 
operation is on the way. After the truncate succeeds the MDS Locker will 
issue_truncate() to all the clients and the clients will truncate the 
caches/buffers, etc.

And also the truncate operations will always be queued sequentially.


> It sort of makes sense, but the more I look over the existing code, the
> less sure I am about how this is intended to work. I think before we
> make any changes for fscrypt, we need to make sure we understand what's
> there now.

So if my understanding is correct, the Fx is not a must for the truncate 
operation.

I will check more about this later.

BRs

-- Xiubo

>>>    See
>>> __ceph_setattr. Do we even need to change the read path here, or is the
>>> existing code just wrong?
>>>
>>> This is info I've been trying to get a handle on since I started working
>>> on cephfs. The rules for FILE caps are still extremely unclear.
>> I am still check this logic from MDS side. Still not very clear.
>>
>>
>> [...]
>>>>> 2) we could rev the protocol, and have the client send along the last
>>>>> block to be written along with the SETATTR request. Maybe we even
>>>>> consider just adding a new TRUNCATE call independent of SETATTR. The MDS
>>>>> would remain in complete control of it at that point.
>>>> This approach seems much better, since the last block size will always
>>>> less than or equal to 4K(CEPH_FSCRYPT_BLOCK_SIZE) and the truncate
>>>> should be rare in normal use cases (?), with extra ~4K data in the
>>>> SETATTR should be okay when truncating the file.
>>>>
>>>> So when truncating a file, in kclient it should read that block, which
>>>> needs to do the RMW, first, and then do the truncate locally and encrypt
>>>> it again, and then together with SETATTR request send it to MDS. And the
>>>> MDS will update that block just before truncating the file.
>>>>
>>>> This approach could also keep the fscrypt logic being opaque for the MDS.
>>>>
>>>>
>>> Note that you'll need to guard against races on the RMW. For instance,
>>> another client could issue a write to that last block just after we do
>>> the read for the rmw.
>>>
>>> If you do this, then you'll probably need to send along the object
>>> version that you got from the read and have the MDS validate that before
>>> it does the truncate and writes out the updated crypto block.
>>>
>>> If something changed in the interim, the MDS can just return -EAGAIN or
>>> whatever to the client and it can re-do the whole thing. It's a mess,
>>> but it should be consistent.
>>>
>>> I think we probably want a new call for this too instead of overloading
>>> SETATTR (which is already extremely messy).
>> Okay, I will check this more carefully.
>>
>>
>>>>> The other ideas I've considered seem more complex and don't offer any
>>>>> significant advantages that I can see.
>>>>>
>>>>> [a]: Side question: why does buffering a truncate require Fx and not Fb?
>>>>> How do Fx and Fb interact?
>>>> For my defer RMW approach we need the Fx caps every time when writing
>>>> the file, and the Fw caps is the 'need' caps for write, while the Fb is
>>>> the 'want' caps. If the Fb caps is not allowed or issued by the MDS, it
>>>> will write-through data to the osd, after that the Fxw could be safely
>>>> released. If the client gets the Fb caps, the client must also hold the
>>>> Fx caps until the buffer has been writen back.
>>>>
>>> The problem there is that will effectively serialize all writers of a
>>> file -- even ones that are writing to completely different backend
>>> objects.
>>>
>>> That will almost certainly regress performance. I think we want to try
>>> to avoid that. I'd rather that truncate be extremely slow and expensive
>>> than slow down writes.
>> Agree.
>>
>> Thanks.
>>
>>


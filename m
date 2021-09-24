Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE217417734
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Sep 2021 17:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346963AbhIXPC6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 Sep 2021 11:02:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346921AbhIXPC5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 11:02:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632495684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hwzjENYDKBTBiIie5My1MrxerbGC6s/GBl/hhgI6OdA=;
        b=gnuod1F1PbPnAd8gYGGbOeabJpB8fFj3I3wRw0Rveej9iNWxvcKkTL9AgVNZNIkVpu0YF6
        rW4U+KYPtZJ/cHIacgwUqovJMJVgRfPgv7f9VA4pFe7JRwbisRxC8AR8rmgrZsOwTkAFm7
        yT1kECKnRBNsUkKl7ZdM/jOtXoZ1cNQ=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-mtaYTwjsMAmvson8meon4A-1; Fri, 24 Sep 2021 11:01:22 -0400
X-MC-Unique: mtaYTwjsMAmvson8meon4A-1
Received: by mail-pg1-f198.google.com with SMTP id u7-20020a632347000000b0026722cd9defso6348093pgm.7
        for <ceph-devel@vger.kernel.org>; Fri, 24 Sep 2021 08:01:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hwzjENYDKBTBiIie5My1MrxerbGC6s/GBl/hhgI6OdA=;
        b=CV/ZU612jXrN8x3EeTDbBaDzIi5LMfSsYMzntxwKko+3gqISHFwFoCbVzTgp1s3Cm3
         V1BpdXMbrLctH00I5dmpIKnCATt2H98R06Tm2qPLE/Zq5Z/tcRH9E7agqn+4WjqQUbDs
         aWAtWnSkLbJGATb02c+cSLD7GxkNBsL9SIPxDOCXPfg6SJ969PSRkmR0djFnqsPoxDgw
         G7Gy1sivr2nFGRInPTDismxKmSdh+QVwpNlYN1f6Szj7/HttoNJE/tOuE3TtJ7oYoHH3
         /t8nJwPlhBsvIpLwzhtXJBuJPNySYvK7gjOSqaj3xQUzi8g8BUp0tlbxoKK+5rmup/BP
         D2Fg==
X-Gm-Message-State: AOAM532lnaICn288Nygsmil1CdSw8B1iNOmOPUc1zdBVQrBhLoWQLAkp
        o7pbHSeB6FGI09mtSZgw6qaCNYQiF76jgiMUpoSKtimgflY6wu0H3vWyLBi3s6mgiMM3F1epqh0
        rHCJ5gxgMSPjMjDaaRDbiJg==
X-Received: by 2002:a17:90b:3901:: with SMTP id ob1mr2797748pjb.136.1632495681229;
        Fri, 24 Sep 2021 08:01:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9eit+xocNN1x+A1fDR3OHU5ERXQsx1gCeWFYyhlRVH+WIHPZarp5h1sIIA9e1k6/FsNMlfA==
X-Received: by 2002:a17:90b:3901:: with SMTP id ob1mr2797709pjb.136.1632495680896;
        Fri, 24 Sep 2021 08:01:20 -0700 (PDT)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m7sm9710193pgn.32.2021.09.24.08.01.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 08:01:19 -0700 (PDT)
From:   Xiubo Li <xiubli@redhat.com>
Subject: Re: [PATCH RFC 2/2] ceph: truncate the file contents when needed when
 file scrypted
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Douglas Fuller <dfuller@redhat.com>
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
Message-ID: <60fb4f6d-6c7a-ed63-6a85-6b1270209b97@redhat.com>
Date:   Fri, 24 Sep 2021 23:01:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <7eb2a71e54cb246a8ce1bea642bbdbd2581122f8.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/14/21 3:34 AM, Jeff Layton wrote:
> On Mon, 2021-09-13 at 13:42 +0800, Xiubo Li wrote:
>> On 9/10/21 7:46 PM, Jeff Layton wrote:
>>> On Fri, 2021-09-10 at 10:30 +0800, Xiubo Li wrote:
>>>> On 9/9/21 8:48 PM, Jeff Layton wrote:
>>>>> On Thu, 2021-09-09 at 11:38 +0800, Xiubo Li wrote:
>>>>>> On 9/8/21 9:57 PM, Jeff Layton wrote:
>>>>>>> On Wed, 2021-09-08 at 17:37 +0800, Xiubo Li wrote:
>>>>>>>> On 9/8/21 12:26 AM, Jeff Layton wrote:
>>>>>>>>> On Fri, 2021-09-03 at 16:15 +0800,xiubli@redhat.com  wrote:
[...]
>> I spent hours and went through the mds Locker related code on the weekends.
>>
>>   From the mds/lock.cc code, for mds filelock for example in the LOCK_MIX
>> state and some interim transition states to LOCK_MIX it will allow
>> different clients could hold any of Fw or Fr caps. But the Fb/Fc will be
>> disabled. Checked the mds/Locker.cc code, found that the mds filelock
>> could to switch LOCK_MIX state in some cases when there has one client
>> wants Fw and another client wants any of Fr and Fw.
>>
>> In this case I think the Linux advisory or mandatory locks are necessary
>> to keep the file contents concurrency. In multiple processes' concurrent
>> read/write or write/write cases without the Linux advisory/mandatory
>> locks the file contents' concurrency won't be guaranteed, so the logic
>> is the same here ?
>>
>> If so, couldn't we just assume the Fw vs Fw and Fr vs Fw caps should be
>> exclusive in correct use case ? For example, just after the mds filelock
>> state switches to LOCK_MIX, if clientA gets the advisory file lock and
>> the Fw caps, and even another clientB could be successfully issued the
>> Fr caps, the clientB won't do any read because it should be still stuck
>> and be waiting for the advisory file lock.
>>
> I'm not sure I like that idea. Basically, that would change the meaning
> of the what Frw caps represent, in a way that is not really consistent
> with how they have been used before.
>
> We could gate that new behavior on the new feature flags, but it sounds
> pretty tough.
>
> I think we have a couple of options:
>
> 1) we could just make the clients request and wait on Fx caps when they
> do a truncate. They might stall for a bit if there is contention, but it
> would ensure consistency and the client could be completely in charge of
> the truncate. [a]

For this approach do you mean holding the Fx caps when doing a truncate ?

If so, I am afraid it won't work.

Because only in loner mode will the kclient could be issued the Fx caps, 
if we can get the Fx caps in the kclient then in MDS the filelock will 
be in LOCK_EXCL state.

And then if we send MDS the setattr request to truncate the size, then 
in the MDS it will try to xlock the filelock, then it will try to switch 
the filelock's state to LOCK_XLOCK, during which it must revoke the 
Frxrw caps from the kclient. That means the kclient will wait for the 
setattr request to finish by holding the Fx caps while the MDS will wait 
for the kclient to release the Fx caps.



> 2) we could rev the protocol, and have the client send along the last
> block to be written along with the SETATTR request. Maybe we even
> consider just adding a new TRUNCATE call independent of SETATTR. The MDS
> would remain in complete control of it at that point.
>
> The other ideas I've considered seem more complex and don't offer any
> significant advantages that I can see.
>
> [a]: Side question: why does buffering a truncate require Fx and not Fb?
> How do Fx and Fb interact?
>
>>> IIRC, Frw don't have the same exclusionary relationship
>>> that (e.g.) Asx has. To exclude Fr, you may need Fb.
>>>
>>> (Side note: these rules really need to be codified into a document
>>> somewhere. I started that with the capabilities doc in the ceph tree,
>>> but it's light on details of the FILE caps)
>> Yeah, that doc is light on the details for now.
>>
>>
>>>> And if after clientB have been issued the Fw caps and have modified that
>>>> block and still not flushed back, a new clientC comes and wants to read
>>>> the file, so the Fw caps must be revoked from clientB and the dirty data
>>>> will be flushed, and then when releasing the Fw caps to the MDS, it will
>>>> update the new fscrypt_file meta together.
>>>>
>>>> I haven't see which case will be racy yet. Or did I miss some cases or
>>>> something important ?
>>>>
>>>>
>>> We also need to consider how legacy, non-fscrypt-capable clients will
>>> interact with files that have this field set. If one comes in and writes
>>> to or truncates one of these files, it's liable to leave a real mess.
>>> The simplest solution may be to just bar them from doing anything with
>>> fscrypted files aside from deleting them -- maybe we'd allow them to
>>> acquire Fr caps but not Fw?
>> For the legacy, non-fscrypt-capable clients, the reading contents should
>> be encrypted any way, so there won't be any problem even if that
>> specified block is not RMWed yet and it should ignore this field.
>>
> Right, and I think we have to allow those clients to request Fr caps so
> that they have the ability to backup and archive encrypted files without
> needing the key. The cephfs-mirror-daemon, in particular, may need this.
>
>> But for write case, I think the MDS should fail it in the open() stage
>> if the mode has any of Write/Truncate, etc, and only Read/Buffer-read,
>> etc are allowed. Or if we change the mds/Locker.cc code by not allowing
>> it to issue the Fw caps to the legacy/non-fscrypt-capable clients, after
>> the file is successfully opened with Write mode, it should be stuck
>> forever when writing data to the file by waiting the Fw caps, which will
>> never come ?
>>
> Yes. Those clients should be barred from making any changes to file
> contents or doing anything that might result in a new dentry being
> attached to an existing inode.
>
> We need to allow them to read files, and unlink them, but that's really
> about it.
>
>>>>> Really, it comes down to the fact that truncates are supposed to be an
>>>>> atomic operation, but we need to perform actions in two different
>>>>> places.
>>>>>
>>>>> Hmmm...it's worse than that even -- if the truncate changes it so that
>>>>> the last block is in an entirely different object, then there are 3
>>>>> places that will need to coordinate access.
>>>>>
>>>>> Tricky.


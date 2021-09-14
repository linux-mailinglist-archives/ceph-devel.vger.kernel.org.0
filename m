Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB9340A60A
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Sep 2021 07:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239595AbhINFln (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Sep 2021 01:41:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42231 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239398AbhINFlm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 01:41:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631598025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UKZtpUpyo1RI/FhlehtbWiD+0yb3EBehEAHCguHsBEo=;
        b=eggpc0oOvmSjw7PzbAh5fOyrfYNeDFBvQBmKcLBJtB251evzFceIZM3Rzo+GK+Rea3YvH6
        vp59kVxemhbg1x9vMhMb2bGyggFm0dlELmISiZwGirwtRtYBfpcaSGpx+LF2iFBn+em/V9
        LRVimJlbW/7xv1oaZUjP0nYi2Li91/8=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-Qg8vQwbTNTuUtwZhPT6fWg-1; Tue, 14 Sep 2021 01:40:24 -0400
X-MC-Unique: Qg8vQwbTNTuUtwZhPT6fWg-1
Received: by mail-pg1-f199.google.com with SMTP id e18-20020a656792000000b00268773b02d1so8765795pgr.13
        for <ceph-devel@vger.kernel.org>; Mon, 13 Sep 2021 22:40:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=UKZtpUpyo1RI/FhlehtbWiD+0yb3EBehEAHCguHsBEo=;
        b=URYtgoectTzPHI6SAUCPbjvxnVr5rwdXGm18AbOq//Obv2MwnxZJjLGXa08PnolIWI
         /BTl+E9iVbcxAh4OB60zNqS24ANK7GFQIoFLHXRqxns+346McXT1mCBiNMe9R8pK4A+r
         zQTd0Y02LtHY/6TZ9AZUH4x/d9tmCUP58+zxGsYuPpvjKnFo0VwobBycStZ7nZMXBbAB
         mwF/oiTUajNaUweKDtv0S4hU/A7AzxPU93U8N4qhE/uPGmDHP8Zcj/MWdodrdJhpdVM1
         eT33bwOq6XR9vyFv3KmKq+wEmbro0g2n8utTpNSs4Cw9BmI9M0MRj4DAVkYlLuSFaQxC
         lLfQ==
X-Gm-Message-State: AOAM530/6pg7/bnGMlrRm3u4KNEugBnPDWGXuKbGPSa+QrV0JkpigUtj
        cHwyDyCh1gXK6DVXWZyuguG9zOY+pG3vP6Soa9TjSCrS1wOH1fpTZ+ury0TmHCIQp62am/QiIfR
        QF62h/D6zk/OVcWirBowykKnh6FaSW58w9V8ZBZGVW8wOGMeHy86vechCqyYneQPw/UZDRpw=
X-Received: by 2002:a17:902:d202:b0:13a:709b:dfb0 with SMTP id t2-20020a170902d20200b0013a709bdfb0mr13682018ply.34.1631598023220;
        Mon, 13 Sep 2021 22:40:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6rwMq5NZNuinvRHRshIpXs8zobIbRxMPNG2mvBTEBTUAL41XeRF+VLdfz7kgAPJMqM7IbZg==
X-Received: by 2002:a17:902:d202:b0:13a:709b:dfb0 with SMTP id t2-20020a170902d20200b0013a709bdfb0mr13681984ply.34.1631598022749;
        Mon, 13 Sep 2021 22:40:22 -0700 (PDT)
Received: from [10.72.12.89] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q2sm86282pjo.27.2021.09.13.22.40.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 22:40:22 -0700 (PDT)
Subject: Re: [PATCH RFC 2/2] ceph: truncate the file contents when needed when
 file scrypted
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
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
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <747cf4f4-0048-df9d-c38f-2ab284851320@redhat.com>
Date:   Tue, 14 Sep 2021 13:40:16 +0800
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

[...]

> I'll have to think about whether that's still racy. Part of the problem
>>>>> is that once the client doesn't have caps, it doesn't have a way to
>>>>> ensure that fscrypt_file (whatever it holds) doesn't change while it's
>>>>> doing that zeroing.
>>>> As my understanding, if clientA want to read a file, it will open it
>>>> with RD mode, then it will get the fscrypt_file meta and "Fr" caps, then
>>>> it can safely read the file contents and do the zeroing for that block.
>>> Ok, so in this case, the client is just zeroing out the appropriate
>>> region in the resulting read data, and not on the OSD. That should be
>>> ok.
>>>
>>>> Then the opened file shouldn't worry whether the fscrypt_file will be
>>>> changed by others during it still holding the Fr caps, because if the
>>>> clientB wants to update the fscrypt_file it must acquire the Fw caps
>>>> first, before that the Fr caps must be revoked from clientA and at the
>>>> same time the read pagecache in clientA will be invalidated.
>>>>
>>> Are you certain that Fw caps is enough to ensure that no other client
>>> holds Fr caps?
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

Yeah, for my defer RMW approach we need to held the Fx caps every time 
when writing/truncating files, and the Fs caps every time when reading.

While currently almost all the read/write code have ignored them because 
read/write do not need them in most cases.

I am not sure if we add the Fx caps to the 'need' in 
write/truncating,etc code and the Fs caps in "need" in reading related 
code will slow the perf. If my understanding is correct, the most of the 
mds filelock's lock states do no allow the Fx/Fs caps to clients, so the 
clients may need to wait a longer time than before.

After checking more about the Locker code, this seems not a perfect 
approach IMO.


> 2) we could rev the protocol, and have the client send along the last
> block to be written along with the SETATTR request. Maybe we even
> consider just adding a new TRUNCATE call independent of SETATTR. The MDS
> would remain in complete control of it at that point.

This approach seems much better, since the last block size will always 
less than or equal to 4K(CEPH_FSCRYPT_BLOCK_SIZE) and the truncate 
should be rare in normal use cases (?), with extra ~4K data in the 
SETATTR should be okay when truncating the file.

So when truncating a file, in kclient it should read that block, which 
needs to do the RMW, first, and then do the truncate locally and encrypt 
it again, and then together with SETATTR request send it to MDS. And the 
MDS will update that block just before truncating the file.

This approach could also keep the fscrypt logic being opaque for the MDS.


>
> The other ideas I've considered seem more complex and don't offer any
> significant advantages that I can see.
>
> [a]: Side question: why does buffering a truncate require Fx and not Fb?
> How do Fx and Fb interact?

For my defer RMW approach we need the Fx caps every time when writing 
the file, and the Fw caps is the 'need' caps for write, while the Fb is 
the 'want' caps. If the Fb caps is not allowed or issued by the MDS, it 
will write-through data to the osd, after that the Fxw could be safely 
released. If the client gets the Fb caps, the client must also hold the 
Fx caps until the buffer has been writen back.

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

Yeah, agree.

BRs


>>>>> Really, it comes down to the fact that truncates are supposed to be an
>>>>> atomic operation, but we need to perform actions in two different
>>>>> places.
>>>>>
>>>>> Hmmm...it's worse than that even -- if the truncate changes it so that
>>>>> the last block is in an entirely different object, then there are 3
>>>>> places that will need to coordinate access.
>>>>>
>>>>> Tricky.


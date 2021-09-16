Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6190840D6F9
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Sep 2021 12:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbhIPKEY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Sep 2021 06:04:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40989 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235574AbhIPKER (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 16 Sep 2021 06:04:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631786577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hvXYc+ujhkC2wnup2wtvFEncR4jg3gZBh6gOo6NUr/Q=;
        b=T9tJHQfFgj+UZNyWQlo/YxIWTNeiHka8wXcQy0hoA+2GrVMjonRZ5Ovt9uIfPhy1ennCmi
        8gkOBQALnOspjBxDLS6kiJA9SZI2NCCLaSI9jchP88Qm9rvAOaV1Yt609sl5pWLfwV9xrl
        fnZr97n85rdCKp26q2BhI7siAC14iZY=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-SClo4GDvNK2HSP67zi51CA-1; Thu, 16 Sep 2021 06:02:56 -0400
X-MC-Unique: SClo4GDvNK2HSP67zi51CA-1
Received: by mail-pf1-f200.google.com with SMTP id x29-20020aa7941d000000b0043c26e9eeddso4364339pfo.5
        for <ceph-devel@vger.kernel.org>; Thu, 16 Sep 2021 03:02:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hvXYc+ujhkC2wnup2wtvFEncR4jg3gZBh6gOo6NUr/Q=;
        b=YqoS2FKsvb/4PCY/lm0Jg95NNZg9CTMUHkJFQ9Z+ENn5LVbRISo8oNDxOoAXocFGwg
         uMenFnlT3s6X9RMRNGFTDf/HsYzXwS6ZImz/W4YVyklD8CJYFiAmnIOFqlmWKSzr0aOl
         Q56akFZSBYjMiGqqz07a48bfz/vGas2WExJaTSLzRUhw5YolHCtzPO0Y9Ef7GhBqxoEW
         JOTgOOVUOgfgw9tkehpHWz6rwqpdVASQEWPdjw//cUU3jwyHuQj1yY7hV8+U6kXvWLVy
         wgpHCGApQNzTGfhSMCaWgihAG5xLrWHhzHj4Yt8hmNeNSWcahz/zFGC3h6wEepuDUiyr
         SfQA==
X-Gm-Message-State: AOAM531bH2Ps6Os/w147XaxBU2Wzgh4QSuFJE9G4IZ5x5fm2PJa5D3yL
        pExCxA+S+zTp2rRh+mzy80oDZB2W7XMEh+omTALxfRUkgxE7PckYtHFiphVKxZO7DUSZTE5m3IP
        X0C7Eog0p7ewkac/NM56htGVuRgu9jLol96hyKPMrewuPlQ+OnE4KjCYyR4Durb1EpwIyPtk=
X-Received: by 2002:a17:90a:a089:: with SMTP id r9mr5089043pjp.18.1631786574508;
        Thu, 16 Sep 2021 03:02:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwC2XgfXocwEBKZqduMlrzIg+vzK0OhICQ6q325wh8vnoDGHnlqh+tvcKde5bKx6GkzoWthrg==
X-Received: by 2002:a17:90a:a089:: with SMTP id r9mr5089004pjp.18.1631786574007;
        Thu, 16 Sep 2021 03:02:54 -0700 (PDT)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b12sm7679040pjg.0.2021.09.16.03.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 03:02:53 -0700 (PDT)
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
 <747cf4f4-0048-df9d-c38f-2ab284851320@redhat.com>
 <27b119711a065a2441337298fada3d941c30932a.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3b2878f8-9655-b4a0-c6bd-3cf61eaffb13@redhat.com>
Date:   Thu, 16 Sep 2021 18:02:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <27b119711a065a2441337298fada3d941c30932a.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/14/21 10:24 PM, Jeff Layton wrote:
> On Tue, 2021-09-14 at 13:40 +0800, Xiubo Li wrote:
>> On 9/14/21 3:34 AM, Jeff Layton wrote:
>>
>> [...]
>>
>>> I'll have to think about whether that's still racy. Part of the problem
>>>>>>> is that once the client doesn't have caps, it doesn't have a way to
>>>>>>> ensure that fscrypt_file (whatever it holds) doesn't change while it's
>>>>>>> doing that zeroing.
>>>>>> As my understanding, if clientA want to read a file, it will open it
>>>>>> with RD mode, then it will get the fscrypt_file meta and "Fr" caps, then
>>>>>> it can safely read the file contents and do the zeroing for that block.
>>>>> Ok, so in this case, the client is just zeroing out the appropriate
>>>>> region in the resulting read data, and not on the OSD. That should be
>>>>> ok.
>>>>>
>>>>>> Then the opened file shouldn't worry whether the fscrypt_file will be
>>>>>> changed by others during it still holding the Fr caps, because if the
>>>>>> clientB wants to update the fscrypt_file it must acquire the Fw caps
>>>>>> first, before that the Fr caps must be revoked from clientA and at the
>>>>>> same time the read pagecache in clientA will be invalidated.
>>>>>>
>>>>> Are you certain that Fw caps is enough to ensure that no other client
>>>>> holds Fr caps?
>>>> I spent hours and went through the mds Locker related code on the weekends.
>>>>
>>>>    From the mds/lock.cc code, for mds filelock for example in the LOCK_MIX
>>>> state and some interim transition states to LOCK_MIX it will allow
>>>> different clients could hold any of Fw or Fr caps. But the Fb/Fc will be
>>>> disabled. Checked the mds/Locker.cc code, found that the mds filelock
>>>> could to switch LOCK_MIX state in some cases when there has one client
>>>> wants Fw and another client wants any of Fr and Fw.
>>>>
>>>> In this case I think the Linux advisory or mandatory locks are necessary
>>>> to keep the file contents concurrency. In multiple processes' concurrent
>>>> read/write or write/write cases without the Linux advisory/mandatory
>>>> locks the file contents' concurrency won't be guaranteed, so the logic
>>>> is the same here ?
>>>>
>>>> If so, couldn't we just assume the Fw vs Fw and Fr vs Fw caps should be
>>>> exclusive in correct use case ? For example, just after the mds filelock
>>>> state switches to LOCK_MIX, if clientA gets the advisory file lock and
>>>> the Fw caps, and even another clientB could be successfully issued the
>>>> Fr caps, the clientB won't do any read because it should be still stuck
>>>> and be waiting for the advisory file lock.
>>>>
>>> I'm not sure I like that idea. Basically, that would change the meaning
>>> of the what Frw caps represent, in a way that is not really consistent
>>> with how they have been used before.
>>>
>>> We could gate that new behavior on the new feature flags, but it sounds
>>> pretty tough.
>>>
>>> I think we have a couple of options:
>>>
>>> 1) we could just make the clients request and wait on Fx caps when they
>>> do a truncate. They might stall for a bit if there is contention, but it
>>> would ensure consistency and the client could be completely in charge of
>>> the truncate. [a]
>> Yeah, for my defer RMW approach we need to held the Fx caps every time
>> when writing/truncating files, and the Fs caps every time when reading.
>>
>> While currently almost all the read/write code have ignored them because
>> read/write do not need them in most cases.
>>
> Note that we already cache truncate operations when we have Fx.

Yeah, only when we have Fx and the attr.ia_size > isize will it cache 
the truncate operation.

For this I am a little curious why couldn't we cache truncate operations 
when attr.ia_size >= isize ?


>   See
> __ceph_setattr. Do we even need to change the read path here, or is the
> existing code just wrong?
>
> This is info I've been trying to get a handle on since I started working
> on cephfs. The rules for FILE caps are still extremely unclear.

I am still check this logic from MDS side. Still not very clear.


[...]
>>
>>> 2) we could rev the protocol, and have the client send along the last
>>> block to be written along with the SETATTR request. Maybe we even
>>> consider just adding a new TRUNCATE call independent of SETATTR. The MDS
>>> would remain in complete control of it at that point.
>> This approach seems much better, since the last block size will always
>> less than or equal to 4K(CEPH_FSCRYPT_BLOCK_SIZE) and the truncate
>> should be rare in normal use cases (?), with extra ~4K data in the
>> SETATTR should be okay when truncating the file.
>>
>> So when truncating a file, in kclient it should read that block, which
>> needs to do the RMW, first, and then do the truncate locally and encrypt
>> it again, and then together with SETATTR request send it to MDS. And the
>> MDS will update that block just before truncating the file.
>>
>> This approach could also keep the fscrypt logic being opaque for the MDS.
>>
>>
> Note that you'll need to guard against races on the RMW. For instance,
> another client could issue a write to that last block just after we do
> the read for the rmw.
>
> If you do this, then you'll probably need to send along the object
> version that you got from the read and have the MDS validate that before
> it does the truncate and writes out the updated crypto block.
>
> If something changed in the interim, the MDS can just return -EAGAIN or
> whatever to the client and it can re-do the whole thing. It's a mess,
> but it should be consistent.
>
> I think we probably want a new call for this too instead of overloading
> SETATTR (which is already extremely messy).

Okay, I will check this more carefully.


>>> The other ideas I've considered seem more complex and don't offer any
>>> significant advantages that I can see.
>>>
>>> [a]: Side question: why does buffering a truncate require Fx and not Fb?
>>> How do Fx and Fb interact?
>> For my defer RMW approach we need the Fx caps every time when writing
>> the file, and the Fw caps is the 'need' caps for write, while the Fb is
>> the 'want' caps. If the Fb caps is not allowed or issued by the MDS, it
>> will write-through data to the osd, after that the Fxw could be safely
>> released. If the client gets the Fb caps, the client must also hold the
>> Fx caps until the buffer has been writen back.
>>
> The problem there is that will effectively serialize all writers of a
> file -- even ones that are writing to completely different backend
> objects.
>
> That will almost certainly regress performance. I think we want to try
> to avoid that. I'd rather that truncate be extremely slow and expensive
> than slow down writes.

Agree.

Thanks.



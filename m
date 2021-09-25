Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FD3417F00
	for <lists+ceph-devel@lfdr.de>; Sat, 25 Sep 2021 03:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238899AbhIYBEs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 Sep 2021 21:04:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235204AbhIYBEr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 21:04:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632531793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DRTfAXx4U0jwz8YyLMy5Wh4jpJZBzgHULujXKNEeHFg=;
        b=CmkiJf5gysKumCkVt/IFz6C5EQapxnGGltielpKAXXL2lJu4lD4jdfNj/z3rtmKTMPA3ro
        BoF9pRZDGv4c4lEqntrSdO1hvzPQIu/M0CHN797nhLOHzKCN5OwZRV9QMthAK064odfAOv
        0kO5OmRu7Y41Gt9KB1Rfw+X0GlynlmE=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-JgA-GkpzPZeBFlTwCBc9Ng-1; Fri, 24 Sep 2021 21:03:10 -0400
X-MC-Unique: JgA-GkpzPZeBFlTwCBc9Ng-1
Received: by mail-pj1-f71.google.com with SMTP id v19-20020a17090a459300b0019c6f43c66fso7397186pjg.3
        for <ceph-devel@vger.kernel.org>; Fri, 24 Sep 2021 18:03:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DRTfAXx4U0jwz8YyLMy5Wh4jpJZBzgHULujXKNEeHFg=;
        b=BM62PpZAebb3bcGXL/42DAmVdc69pQT1PXkM7YLhsKzdAOncUwcEi5yj/37zCr/kkP
         aXZIs9e7I6flIrkzMVgH6pXBUbh9ICOT5yBW6B20+UgSJZuSNnqGMEDb9sI2jbWCm9Ee
         xwaoeUf5UG5oHdmn39NXJR9zDv1EGuvBYN1k265MfOq1EnrASUA+apMMMXB/i7ihrlXb
         FKf0a1dodx/1kOmZHooZ36bDdI+FRSF6aPHcndBwbQiFKoB/LWFxKLleH4IbGy79CSpg
         cayozaZWhV9yPljS+xAN8OIbxUaHsZVrIEfI8TPk6X1Hptjr1Qlm3X3d2TjFL4nbNKic
         XBmg==
X-Gm-Message-State: AOAM532QkZi/wPW88RAC0ir/Grcf14Wu5GViUpnWb2jQRNf1SS2D3Z4U
        2YLUzQwIdyJdkTI0/Z6V3At7DTDzryeTMxlG04GaBsxrLcpXX2wmlhTeXMc4lXOLcSy0VEwjWts
        ktbgLwOscYYkI13pDGTU3nmwRoThi5a92dJss4Eh18CYbQD0gKbnYUnqkgK0feOdwFj90eKQ=
X-Received: by 2002:a62:d11e:0:b0:446:d705:7175 with SMTP id z30-20020a62d11e000000b00446d7057175mr9629848pfg.74.1632531788248;
        Fri, 24 Sep 2021 18:03:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw3UcpRGa/br4NUUonD/YeZIJC9clYW+Jj8i6OCMsOlrgs4rGD5dhqhpsuNENtMM09iP6GYhg==
X-Received: by 2002:a62:d11e:0:b0:446:d705:7175 with SMTP id z30-20020a62d11e000000b00446d7057175mr9629807pfg.74.1632531787710;
        Fri, 24 Sep 2021 18:03:07 -0700 (PDT)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s2sm13735461pjs.56.2021.09.24.18.03.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 18:03:05 -0700 (PDT)
Subject: Re: [PATCH RFC 2/2] ceph: truncate the file contents when needed when
 file scrypted
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>
References: <20210903081510.982827-1-xiubli@redhat.com>
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
 <6d84f34d-28d4-1b82-3c70-1209bea37ddf@redhat.com>
 <20c3630d2ac2e2e7c4a708fdeb7409077f36d8f0.camel@kernel.org>
 <5cf666a9-3b33-ad54-3878-a975505c872e@redhat.com>
 <066668c34c8022c18df4634bb2fb9ecfd1d6d93b.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <1f26b8ad-c100-2d4b-9269-d890e63f8830@redhat.com>
Date:   Sat, 25 Sep 2021 09:02:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <066668c34c8022c18df4634bb2fb9ecfd1d6d93b.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/25/21 2:52 AM, Jeff Layton wrote:
> On Wed, 2021-09-22 at 10:23 +0800, Xiubo Li wrote:
>> On 9/21/21 3:24 AM, Jeff Layton wrote:
>>> On Mon, 2021-09-20 at 22:32 +0800, Xiubo Li wrote:
>>>> On 9/18/21 1:19 AM, Jeff Layton wrote:
>>>>> On Thu, 2021-09-16 at 18:02 +0800, Xiubo Li wrote:
>>>>>> For this I am a little curious why couldn't we cache truncate operations
>>>>>> when attr.ia_size >= isize ?
>>>>>>
>>>>> It seems to me that if attr.ia_size == i_size, then there is nothing to
>>>>> change. We can just optimize that case away, assuming the client has
>>>>> caps that ensure the size is correct.
>>>>    From MDS side I didn't find any limitation why couldn't we optimize it.
>>>>
>>>>
>>> Well...I think we do still need to change the mtime in that case. We
>>> probably do still need to do a setattr or something that makes the MDS
>>> set it to its current local time, even if the size doesn't change.
>> Since there hasn't any change for the file data, will change the 'mtime'
>> make sense here ? If so, then why in case the current client has the Fr

Sorry, s/Fr/Fs/


>> caps and sizes are the same it won't.
>>
>> In this case I found in the MDS side, it will also update the 'ctime'
>> always even it will change nothing.
>>
> I think I'm wrong here, actually, but the POSIX spec is a bit vague on
> the topic. Conceptually though since nothing changed, it doesn't seem
> like we'd be mandated to change the mtime or change attribute.
>
> https://pubs.opengroup.org/onlinepubs/9699919799/functions/truncate.html

Yeah, I also read this spec and didn't find any place saying in this 
case should the mtime need to update.


>>>>> Based on the kclient code, for size changes after a write that extends a
>>>>> file, it seems like Fw is sufficient to allow the client to buffer these
>>>>> things.
>>>> Since the MDS will only allow us to increase the file size, just like
>>>> the mtime/ctime/atime, so even the write size has exceed current file
>>>> size, the Fw is sufficient.
>>>>
>>> Good.
>>>
>>>>>     For a truncate (aka setattr) operation, we apparently need Fx.
>>>> In case one client is truncating the file, if the new size is larger
>>>> than or equal to current size, this should be okay and will behave just
>>>> like normal write case above.
>>>>
>>>> If the new size is smaller, the MDS will handle this in a different way.
>>>> When the MDS received the truncate request, it will first xlock the
>>>> filelock, which will switch the filelock state and in all these possible
>>>> interim or stable states, the Fw caps will be revoked from all the
>>>> clients, but the clients still could cache/buffer the file contents,
>>>> that means no client is allowed to change the size during the truncate
>>>> operation is on the way. After the truncate succeeds the MDS Locker will
>>>> issue_truncate() to all the clients and the clients will truncate the
>>>> caches/buffers, etc.
>>>>
>>>> And also the truncate operations will always be queued sequentially.
>>>>
>>>>
>>>>> It sort of makes sense, but the more I look over the existing code, the
>>>>> less sure I am about how this is intended to work. I think before we
>>>>> make any changes for fscrypt, we need to make sure we understand what's
>>>>> there now.
>>>> So if my understanding is correct, the Fx is not a must for the truncate
>>>> operation.
>>>>
>>> Basically, when a truncate up or down comes in, we have to make a
>>> determination of whether we can buffer that change, or whether we need
>>> to do it synchronously.
>>>
>>> The current kclient code bases that on whether it has Fx. I suspect
>>> that ensures that no other client has Frw, which sounds like what we
>>> probably want.
>> The Fx caps is only for the loner client and once the client has the Fx
>> caps it will always have the Fsrwcb at the same time. From the
>> mds/locker.cc I didn't find it'll allow that.
>>
> So if I'm a "loner" client, then no one else has _any_ caps, right?

Yeah, from the mds/locker.c no one else should have any file caps.

If I didn't miss something from the MDS code, if there has any other 
client also wants any of Fr and Fw, so there will be no loner client 
exist or won't set a new one. That means when there has only one client 
will the loner should always exist, and in multiple clients case the 
loner should rarely exist.


>   If
> so, then really Fx conflicts with all other FILE caps.

Once a client has Fx, I think it always should have the Fsxrcwb.


>
>> If current client has the Fx caps, so when there has another client is
>> trying to truncate the same file at the same time, the MDS will have to
>> revoke the Fx caps first and during which the buffered truncate will be
>> flushed and be finished first too. So when Fx caps is issued and new
>> size equals to the current size, why couldn't we buffer it ?
>>
>>
> I think we should be able to buffer it in that case.
>
>>>    We need to prevent anyone from doing writes that might
>>> extend the file at that time
>> Yeah, since the Fx is only for loner client, and all other clients will
>> have zero file caps. so it won't happen.
>>
>
> What would be nice is to formally define what it means to be a "loner"
> client? Does that mean that no other client has any outstanding caps?
When the first client comes it will be the loner client, then if a new 
client comes the loner client should be revoked usually. From the code 
this is what I can get.

>
> A related question: Is loner status attached to the client or the cap
> family? IOW, can I be a loner for FILE caps but not AUTH caps?

The loner should always have the whole FILE caps, but possibly not the 
whole AUTH caps, only when the client want Ax will it try to switch the 
authlock to LOCK_EXCL, or just switch to LOCK_SYNC.

 From calc_ideal_loner(), it's calculating the loner client and if there 
has only one client's "cap.wanted() & 
(CEPH_CAP_ANY_WR|CEPH_CAP_FILE_RD)" is true will the calc_ideal_loner() 
succeed.

IMO we can just simply assume that the loner is for single client use case.


>>>    _and_ need to ensure that stat/statx for
>>> the file size blocks until it's complete. ceph_getattr will issue a
>>> GETATTR to the MDS if it doesn't have Fs in that case, so that should
>>> be fine.
>>>
>>> I assume that the MDS will never give out Fx caps to one client and Fs
>>> to another.
>> Yeah, It won't happen.
>>
>>
>>>    What about Fw, though?
>> While for the Fw caps, it will allow it. If the filelock is in LOCK_MIX
>> state, the filelock maybe in this state if there at least one client
>> wants the Fw caps and some others want any of Fr and Fw caps.
>>
> Sorry, I think you misunderstood my question.
>
> We have to think about whether certain caps conflict with one another
> when given to different clients. I meant do Fx and Fw conflict with one
> another? If a client holds Fx and another requests Fw, then the MDS will
> need to revoke Fx before it will hand Fw to another client. Correct?
>
Okay, yeah. Since only the loner client will have the Fx caps and 
because the FILE's LOCK_EXCL state won't allow any other client have the 
Fw caps, so in this case when the MDS is doing the FILE lock state 
transition the Fx will be revoked.


> I suspect that's the case as nothing else makes any sense. :)
>
>>>    Do Fx caps conflict with Frw the
>>> same way as they do with Fs?
>> Yeah, it will be the same with Fs.
>>
> Thanks for doing the archaeology on this. This is all really good info.
> We need to get this into the capabilities.rst file in the ceph tree. I'd
> really like to see a formal writeup of how FILE caps work.

Maybe we can try this after the file scryption feature is done.


> Maybe we need a nice ASCII art matrix that indicates how various FILE
> caps conflict with one another?
>
Yeah, sounds nice.



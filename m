Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25755413F5D
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Sep 2021 04:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhIVCZK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Sep 2021 22:25:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44749 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229505AbhIVCZK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Sep 2021 22:25:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632277420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EpsqktvUqF/Q7esfgYDrhW3/tzWa1y25ATDVk1MLJxI=;
        b=KXTX0Ah2BLCgUqQc1OZQKNC4U8QuRU9+XCWxgKr/yI95UazG/KBvwUvkfbffr+EfajHdml
        CP96+elcbY9WhJPrkfwdcBiUffflVEUUgbTt+O9MT4hi/6IhXgC8N+Ggnq8iOPOXuYEaXx
        n7JMJ6zItE50RhKYoTJ8fETSNRIWvOg=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-Pr8hjXaPN2OPwXu6yXwjQg-1; Tue, 21 Sep 2021 22:23:39 -0400
X-MC-Unique: Pr8hjXaPN2OPwXu6yXwjQg-1
Received: by mail-pl1-f198.google.com with SMTP id i2-20020a1709026ac200b0013a0caa0cebso216544plt.23
        for <ceph-devel@vger.kernel.org>; Tue, 21 Sep 2021 19:23:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=EpsqktvUqF/Q7esfgYDrhW3/tzWa1y25ATDVk1MLJxI=;
        b=rbi8xh8MXajxqI/OxukYUh4D/m4Hk1qd7Ii6uR/ZCueuOXt2GPjZaVXksKlWpMEJ2e
         RYM0t80G8AdDiKbDuNEXkXJmLQOrZ5SMIBf4PaDRrJCcrsRZL0ymv+nUyuVfKvrWlIcD
         RQ6yq00DRJ2gevabnK56i1v+/gU8V8x8etc+/Nxk0dw4W4+07DGyJtXb1TTfR4H0NW2n
         xXy9EdSd2zlYNGjDv3kFOvU9ApFk/7A0Q4Fp21nPph/DWHEA+eTyQmez+vq37Um7+Inn
         H/bqwgsId8lz+XPKRCcmPNxyjbbh/xTu/LjD62xCEGfhWUQylSUG+GqH4cwFM6KF5aAh
         FbkQ==
X-Gm-Message-State: AOAM533nMjuEfVCLZmJdAQHtWk1q9UPH6BCs1kFPQEsHYrigxu2xZLfc
        QSy78AzFqSvOtviR4Yz0z4k4ZJ7sM43xKau2JFRanrBU07+o2newjmOG5Sj4zTJgFBKtIWl2GKT
        TRQiPyr8ejIgnYEnTYdG+qgiLxvdIxp++vaajgiMeLwN4a/swTnkPaZP4wbgD1+E5HGwWMEI=
X-Received: by 2002:a17:90a:b907:: with SMTP id p7mr8724638pjr.142.1632277417603;
        Tue, 21 Sep 2021 19:23:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3McCByvJ+NGcalCn/kTdfWws0gG+spNiUDgTtq6hK1TuENX9um/iUyWiZnwGK4+UUmx3ZUQ==
X-Received: by 2002:a17:90a:b907:: with SMTP id p7mr8724601pjr.142.1632277417118;
        Tue, 21 Sep 2021 19:23:37 -0700 (PDT)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l14sm3932319pjq.13.2021.09.21.19.23.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 19:23:36 -0700 (PDT)
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
 <6d84f34d-28d4-1b82-3c70-1209bea37ddf@redhat.com>
 <20c3630d2ac2e2e7c4a708fdeb7409077f36d8f0.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <5cf666a9-3b33-ad54-3878-a975505c872e@redhat.com>
Date:   Wed, 22 Sep 2021 10:23:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20c3630d2ac2e2e7c4a708fdeb7409077f36d8f0.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/21/21 3:24 AM, Jeff Layton wrote:
> On Mon, 2021-09-20 at 22:32 +0800, Xiubo Li wrote:
>> On 9/18/21 1:19 AM, Jeff Layton wrote:
>>> On Thu, 2021-09-16 at 18:02 +0800, Xiubo Li wrote:
>>>> For this I am a little curious why couldn't we cache truncate operations
>>>> when attr.ia_size >= isize ?
>>>>
>>> It seems to me that if attr.ia_size == i_size, then there is nothing to
>>> change. We can just optimize that case away, assuming the client has
>>> caps that ensure the size is correct.
>>   From MDS side I didn't find any limitation why couldn't we optimize it.
>>
>>
> Well...I think we do still need to change the mtime in that case. We
> probably do still need to do a setattr or something that makes the MDS
> set it to its current local time, even if the size doesn't change.

Since there hasn't any change for the file data, will change the 'mtime' 
make sense here ? If so, then why in case the current client has the Fr 
caps and sizes are the same it won't.

In this case I found in the MDS side, it will also update the 'ctime' 
always even it will change nothing.

>>> Based on the kclient code, for size changes after a write that extends a
>>> file, it seems like Fw is sufficient to allow the client to buffer these
>>> things.
>> Since the MDS will only allow us to increase the file size, just like
>> the mtime/ctime/atime, so even the write size has exceed current file
>> size, the Fw is sufficient.
>>
> Good.
>
>>>    For a truncate (aka setattr) operation, we apparently need Fx.
>> In case one client is truncating the file, if the new size is larger
>> than or equal to current size, this should be okay and will behave just
>> like normal write case above.
>>
>> If the new size is smaller, the MDS will handle this in a different way.
>> When the MDS received the truncate request, it will first xlock the
>> filelock, which will switch the filelock state and in all these possible
>> interim or stable states, the Fw caps will be revoked from all the
>> clients, but the clients still could cache/buffer the file contents,
>> that means no client is allowed to change the size during the truncate
>> operation is on the way. After the truncate succeeds the MDS Locker will
>> issue_truncate() to all the clients and the clients will truncate the
>> caches/buffers, etc.
>>
>> And also the truncate operations will always be queued sequentially.
>>
>>
>>> It sort of makes sense, but the more I look over the existing code, the
>>> less sure I am about how this is intended to work. I think before we
>>> make any changes for fscrypt, we need to make sure we understand what's
>>> there now.
>> So if my understanding is correct, the Fx is not a must for the truncate
>> operation.
>>
> Basically, when a truncate up or down comes in, we have to make a
> determination of whether we can buffer that change, or whether we need
> to do it synchronously.
>
> The current kclient code bases that on whether it has Fx. I suspect
> that ensures that no other client has Frw, which sounds like what we
> probably want.

The Fx caps is only for the loner client and once the client has the Fx 
caps it will always have the Fsrwcb at the same time. From the 
mds/locker.cc I didn't find it'll allow that.

If current client has the Fx caps, so when there has another client is 
trying to truncate the same file at the same time, the MDS will have to 
revoke the Fx caps first and during which the buffered truncate will be 
flushed and be finished first too. So when Fx caps is issued and new 
size equals to the current size, why couldn't we buffer it ?


>   We need to prevent anyone from doing writes that might
> extend the file at that time

Yeah, since the Fx is only for loner client, and all other clients will 
have zero file caps. so it won't happen.


>   _and_ need to ensure that stat/statx for
> the file size blocks until it's complete. ceph_getattr will issue a
> GETATTR to the MDS if it doesn't have Fs in that case, so that should
> be fine.
>
> I assume that the MDS will never give out Fx caps to one client and Fs
> to another.
Yeah, It won't happen.


>   What about Fw, though?

While for the Fw caps, it will allow it. If the filelock is in LOCK_MIX 
state, the filelock maybe in this state if there at least one client 
wants the Fw caps and some others want any of Fr and Fw caps.


>   Do Fx caps conflict with Frw the
> same way as they do with Fs?

Yeah, it will be the same with Fs.

Thanks.


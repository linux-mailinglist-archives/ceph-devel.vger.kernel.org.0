Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100804292F9
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Oct 2021 17:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235157AbhJKPSv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 11 Oct 2021 11:18:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236517AbhJKPSu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 11:18:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633965410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DPmq9kHpbl+yHlJFXQdxJbgWoQ0WEY8itjtYZlD5JW0=;
        b=CyNLz9z+CxQ7KOxt5a1Q9C628iE6Lv5PjimmEAb8UnouFJOfZszB707SbdeWzTERCV4oC7
        Uw44BHTNwL6iyg0aj9kTlOyc/wU1YaGVjDX62XvfMeU/RIRdABlKj/n/L88riPCHQR3b4R
        2h4nimuk4whJuWojm24LQWMcd1BT1Is=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-hFciYUSmO0-S62uCXnZkwg-1; Mon, 11 Oct 2021 11:16:49 -0400
X-MC-Unique: hFciYUSmO0-S62uCXnZkwg-1
Received: by mail-pf1-f200.google.com with SMTP id d10-20020a621d0a000000b0044ca56b97f5so7239128pfd.2
        for <ceph-devel@vger.kernel.org>; Mon, 11 Oct 2021 08:16:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DPmq9kHpbl+yHlJFXQdxJbgWoQ0WEY8itjtYZlD5JW0=;
        b=Agd/O3iPGzoTBrmOMMZJenmabjLNNlbCJ2cLkT6h/0cvX1scMoVmRfLTaKzrbK21h3
         sk6blMVf2JFq2FefapIdOAPtc35QmF4PhBnP9Gg3F11yNmSgCJBuivNq+XiG41IRwk/W
         3mj1TQXzQvpnePNaEcds+ivBuR4mqr1y/x5lYkVO/f7l+gdAzAChywnWOxh4qacftDNp
         F8WSIRMciBc3Qsp6qplR6bT5qRh6jewBIjVgc0OJxbuhixd1pJxIlEfzM5Yeo2xGTY1c
         8k9G7tIG5XHlRpz+G2AvwPpCcqCbECXhorMw5xd6+xE1kA/DeoijMwGh+cpOgqCgtDO9
         P3uQ==
X-Gm-Message-State: AOAM533AAmw8ynzy3FFsmuYgmMwATlhX2qaD06JLYxwqjKVCK/vIVITI
        N8T12mpHReI1jAEsGGSk8j37Scjkrpn2cikzd3pJ0cSyWlph2LTHfjGKsKB6z7hb9AVLMTsXNjJ
        7kni7Md6CknGiCoaMYPJIYA==
X-Received: by 2002:a17:90a:fb87:: with SMTP id cp7mr30062278pjb.114.1633965407596;
        Mon, 11 Oct 2021 08:16:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoRvhgBdODMQi45oJsbJOpWo0Xyiis3ZK+zczVozLGP+0bAmEz6Gna/QQ52qwvsxESkXxXZw==
X-Received: by 2002:a17:90a:fb87:: with SMTP id cp7mr30062248pjb.114.1633965407269;
        Mon, 11 Oct 2021 08:16:47 -0700 (PDT)
Received: from [10.72.12.176] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i13sm3145255pgf.77.2021.10.11.08.16.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 08:16:46 -0700 (PDT)
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
 <9f5ab28e-d5b1-1909-a051-249661f6d150@redhat.com>
 <126f465b60fd02e14dcc1d6901a80065424c1f17.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <05c0cca9-5447-7199-afcb-b02a15cb6ec7@redhat.com>
Date:   Mon, 11 Oct 2021 23:16:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <126f465b60fd02e14dcc1d6901a80065424c1f17.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/11/21 9:29 PM, Jeff Layton wrote:
> On Sat, 2021-09-25 at 17:56 +0800, Xiubo Li wrote:
>> On 9/14/21 3:34 AM, Jeff Layton wrote:
>>> On Mon, 2021-09-13 at 13:42 +0800, Xiubo Li wrote:
>>>> On 9/10/21 7:46 PM, Jeff Layton wrote:
>> [...]
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
>>>
>>> 2) we could rev the protocol, and have the client send along the last
>>> block to be written along with the SETATTR request.
>> I am also thinking send the last block along with SETATTR request, it
>> must journal the last block too, I am afraid it will occupy many cephfs
>> meta pool in corner case, such as when client send massive truncate
>> requests in a short time, just like in this bug:
>> https://tracker.ceph.com/issues/52280.
>>
>>
> Good point.
>
> Yes, we'd need to buffer the last block on a truncate like this, but we
> could limit the amount of truncates with "last block" operations that
> run concurrently. We'd probably also want to cap the size of the "last
> block" too.

Okay. So by far this seems the best approach.

I will try to it tomorrow.


>
>>>    Maybe we even
>>> consider just adding a new TRUNCATE call independent of SETATTR. The MDS
>>> would remain in complete control of it at that point.
>> Maybe we can just do:
>>
>> When the MDS received a SETATTR request with size changing from clientA,
>> it will try to xlock(filelock), during which the MDS will always only
>> allow Fcb caps to all the clients, so another client could still
>> buffering the last block.
>>
>> I think we can just nudge the journal log for this request in MDS and do
>> not do the early reply to let the clientA's truncate request to wait.
>> When the journal log is successfully flushed and before releasing the
>> xlock(filelock), we can tell the clientA to do the RMW for the last
>> block. Currently while the xlock is held, no client could get the Frw
>> caps, so we need to add one interim xlock state to only allow the
>> xlocker clientA to have the Frw, such as:
>>
>> [LOCK_XLOCKDONE_TRUNC]  = { LOCK_LOCK, false, LOCK_LOCK, 0, XCL, 0,
>> 0,   0,   0,   0,  0,0,CEPH_CAP_GRD|CEPH_CAP_GWR,0 },
>>
>> So for clientA it will be safe to do the RMW, after this the MDS will
>> finished the truncate request with safe reply only.
>>
>>
> This sounds pretty fragile. I worry about splitting responsibility for
> truncates across two different entities (MDS and client). That means a
> lot more complex failure cases.

Yeah, this will be more complex to handle the failure cases.


> What will you do if you do this, and then the client dies before it can
> finish the RMW? How will you know when the client's RMW cycle is
> complete? I assume it'll have to send a "truncate complete" message to
> the MDS in that case to know when it can release the xlock?
>
Okay, I didn't foresee this case, this sounds making it very complex...
>>> The other ideas I've considered seem more complex and don't offer any
>>> significant advantages that I can see.
>>>
>>> [a]: Side question: why does buffering a truncate require Fx and not Fb?
>>> How do Fx and Fb interact?
>>>
[...]


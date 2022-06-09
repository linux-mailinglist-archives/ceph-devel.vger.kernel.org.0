Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4307544262
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 06:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbiFIEOw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jun 2022 00:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiFIEOv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jun 2022 00:14:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90BF72F1810
        for <ceph-devel@vger.kernel.org>; Wed,  8 Jun 2022 21:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654748089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e2AoUukwZ3uOBqWsuAdAue69/8GuB6OtEg0fhvzJImI=;
        b=F3GrnHKfAG/tckEWI+8BGNEopMOmyDs+4Lp8Fi4UZj+RXmc28/6bXuycG3NgeJiP1VTpqU
        VdAU661tf1cwUwkyo6k55l98W8wrkCrAZWDZOixKeR2Bo3SJIPmKd8u15cSPLtRh+oT/x/
        OBj9OKH9hr9U8XbjDA9TTkL6DJtBefg=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-yi0AOWpiOD-OeaWjh8yh9A-1; Thu, 09 Jun 2022 00:14:48 -0400
X-MC-Unique: yi0AOWpiOD-OeaWjh8yh9A-1
Received: by mail-pf1-f199.google.com with SMTP id i19-20020aa79093000000b0050d44b83506so11800642pfa.22
        for <ceph-devel@vger.kernel.org>; Wed, 08 Jun 2022 21:14:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=e2AoUukwZ3uOBqWsuAdAue69/8GuB6OtEg0fhvzJImI=;
        b=6OB5Lf+ql+J8S6wGBvYouYx8NnHzMl+q21OafMjlmbvYp897dms28bNOHQNIoHq4Za
         13fniyWSIVsZIp7QnCMnjVp1j1/aAZPHdeef3w4BbOupsZuabmYgAJIDHwGqTLFFbjEs
         HVxlGoZSTUzsu+cbQHOb1vggB2FTqcZy7iFK8ph86mhDtAPowulYPZVlU85IVn6FUsoZ
         mZ5IzgJCMarHeRIUeqSRKy4EzgfnNQD1cXx/ptBtcI/N8o4d7xLVQP5IT6vQL1IvBIU0
         K9wDDMC7RS+iTOf6+VhF4gaT8Xgp2KC35lkw7OayXRYTUXXVNrkD/plSlNtlgVn6Q+uy
         fmjg==
X-Gm-Message-State: AOAM533cRHedEPJGXaJNou9uGy0qVIlw7H+rN83sfW5dfYcKr1Q8JhFP
        AmIYmR4g/ADrwoi2V0ULxI4L5rlOdATPzQN3BAjm8BDV8uojZED4WlraGZpq7UomW4X8BbK6reb
        z/8MZ6LfvvvLPCMFYADJNckd0R3rnXVMSSvriPl3FNM8jR/FskOGrL1jRRpgOCErCShtwGeQ=
X-Received: by 2002:a63:9142:0:b0:3fc:c021:e237 with SMTP id l63-20020a639142000000b003fcc021e237mr33391687pge.279.1654748087028;
        Wed, 08 Jun 2022 21:14:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIRFpBCEG5/ATAwhV4/m0vQ6QOweBXOBo2ZCFrfRYE+3Z7+glaE3DtjNaIziVytxOyGMp5NQ==
X-Received: by 2002:a63:9142:0:b0:3fc:c021:e237 with SMTP id l63-20020a639142000000b003fcc021e237mr33391666pge.279.1654748086678;
        Wed, 08 Jun 2022 21:14:46 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ck6-20020a17090afe0600b001e880972840sm6845785pjb.29.2022.06.08.21.14.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 21:14:45 -0700 (PDT)
Subject: Re: [PATCH] ceph: wait on async create before checking caps for
 syncfs
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <20220606233142.150457-1-jlayton@kernel.org>
 <CAAM7YAmguEUbX7XWc9HV0traYT-CgKWdDWV8-OyjwLc2+Tk8EQ@mail.gmail.com>
 <eaa4e405-d7a5-7cf2-d9e2-4cce55f3c1f9@redhat.com>
 <CAAM7YAn7UBP-ip=71AcApu70wpvYLS9-q843LALkA9oyw8MqAw@mail.gmail.com>
 <115f53c7-4ad4-aa1f-05b0-66de7d2cdb03@redhat.com>
 <CAAM7YAnR2dir=8dhWKqYG1YMLVQ_YRADa3Kq=Q9MD-YaYbg5jA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4010191e-5421-712e-e3fc-ea7f49b8dbce@redhat.com>
Date:   Thu, 9 Jun 2022 12:14:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAM7YAnR2dir=8dhWKqYG1YMLVQ_YRADa3Kq=Q9MD-YaYbg5jA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/9/22 12:02 PM, Yan, Zheng wrote:
> On Thu, Jun 9, 2022 at 11:56 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 6/9/22 11:29 AM, Yan, Zheng wrote:
>>> On Thu, Jun 9, 2022 at 11:19 AM Xiubo Li <xiubli@redhat.com> wrote:
>>>> On 6/9/22 10:15 AM, Yan, Zheng wrote:
>>>>> The recent series of patches that add "wait on async xxxx" at various
>>>>> places do not seem correct. The correct fix should make mds avoid any
>>>>> wait when handling async requests.
>>>>>
>>>> In this case I am thinking what will happen if the async create request
>>>> is deferred, then the cap flush related request should fail to find the
>>>> ino.
>>>>
>>>> Should we wait ? Then how to distinguish from migrating a subtree and a
>>>> deferred async create cases ?
>>>>
>>> async op caps are revoked at freezingtree stage of subtree migration.
>>> see Locker::invalidate_lock_caches
>>>
>> Sorry I may not totally understand this issue.
>>
>> I think you mean in case of migration and then the MDS will revoke caps
>> for the async create files and then the kclient will send a MclientCap
>> request to mds, right ?
>>
>> If my understanding is correct, there is another case that:
>>
>> 1, async create a fileA
>>
>> 2, then write a lot of data to it and then release the Fw cap ref, and
>> if we should report the size to MDS, it will send a MclientCap request
>> to MDS too.
>>
>> 3, what if the async create of fileA was deferred due to some reason,
>> then the MclientCap request will fail to find the ino ?
>>
> Async op should not be deferred in any case.

I am still checking the 'mdcache->path_traverse()', in which it seems 
could forward the request or requeue the request when failing to acquire 
locks. And also in case [1].

[1] https://github.com/ceph/ceph/blob/main/src/mds/Server.cc#L4501.


>>>>> On Wed, Jun 8, 2022 at 12:56 PM Jeff Layton <jlayton@kernel.org> wrote:
>>>>>> Currently, we'll call ceph_check_caps, but if we're still waiting on the
>>>>>> reply, we'll end up spinning around on the same inode in
>>>>>> flush_dirty_session_caps. Wait for the async create reply before
>>>>>> flushing caps.
>>>>>>
>>>>>> Fixes: fbed7045f552 (ceph: wait for async create reply before sending any cap messages)
>>>>>> URL: https://tracker.ceph.com/issues/55823
>>>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>>>>> ---
>>>>>>     fs/ceph/caps.c | 1 +
>>>>>>     1 file changed, 1 insertion(+)
>>>>>>
>>>>>> I don't know if this will fix the tx queue stalls completely, but I
>>>>>> haven't seen one with this patch in place. I think it makes sense on its
>>>>>> own, either way.
>>>>>>
>>>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>>>> index 0a48bf829671..5ecfff4b37c9 100644
>>>>>> --- a/fs/ceph/caps.c
>>>>>> +++ b/fs/ceph/caps.c
>>>>>> @@ -4389,6 +4389,7 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
>>>>>>                    ihold(inode);
>>>>>>                    dout("flush_dirty_caps %llx.%llx\n", ceph_vinop(inode));
>>>>>>                    spin_unlock(&mdsc->cap_dirty_lock);
>>>>>> +               ceph_wait_on_async_create(inode);
>>>>>>                    ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
>>>>>>                    iput(inode);
>>>>>>                    spin_lock(&mdsc->cap_dirty_lock);
>>>>>> --
>>>>>> 2.36.1
>>>>>>


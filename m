Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D54544264
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 06:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbiFIESL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jun 2022 00:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbiFIESK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jun 2022 00:18:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD7FB3724B8
        for <ceph-devel@vger.kernel.org>; Wed,  8 Jun 2022 21:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654748286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MjkqCDQw4wj3AHZbUKFy5bDcfPtOHf//uF0ZNSnDb9M=;
        b=XdPAcGIvZENREX0FOuuQeACEEx+bN8+F8Doql3fjRdWfr4XIfPSRQy/LhcKaf4at2ZUbM+
        4m57cDlKH/95DIUV0o/GpSggfK6o7KLrQMtIG/ajqQnYnNprye2xbBFC/TGjkKDVWlN+gI
        bGQkccXThGT+hKrGxraA1pNXKxGsc6A=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-494--HZwLkDVP8-KwBPImPYhhg-1; Thu, 09 Jun 2022 00:18:04 -0400
X-MC-Unique: -HZwLkDVP8-KwBPImPYhhg-1
Received: by mail-pj1-f70.google.com with SMTP id 92-20020a17090a09e500b001d917022847so11597771pjo.1
        for <ceph-devel@vger.kernel.org>; Wed, 08 Jun 2022 21:18:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=MjkqCDQw4wj3AHZbUKFy5bDcfPtOHf//uF0ZNSnDb9M=;
        b=INKDhONf66zTLg873K3DmrHtoH+k1O5qKk9N6w7pRJvc+HbBKp0qSpRgzIuffsd6w+
         BRQRNQmGugHY6RlNMoNCQELYtQmUw1WIo/u8RwdVk5+gw72xwGUK0H8kDIJICrepOwKp
         M3fofvHpHsIDpRpiAPOybBFtnP34KhoJvfUVzWWfzcrtrw/SP1xX48mCqkAegTCHU1Hg
         R0JAOjV+hLphqksX0bBs5YvTQTiilyjtM1QMTEyzuf0cxw+VADso7qo0MwFdeYqnnFYy
         DKxw3v+fOhiC+QduOR6grm83Y8Q6nk33GcRqccd8geTnIvk9nyTHCG8fR1o0RzeIf7DS
         hEiw==
X-Gm-Message-State: AOAM531/lzJa1RZaMrZEG6Antl3r8PTiXuntAka1eIWeBBz2FdWq2TVt
        Fx2+FHlDW6YAJHqZw+4PHu510q0owkabkVeHTOGIo+8IFJ2cxD7XLi0UVhKFyxxjk8IVKDBVAWl
        CIMGUukSP4J7DTQKvdDGDe4vxP10N/ZK8cg02hZXFvURmi25qa2s8jGNCDkmI+HqkDcGCUaw=
X-Received: by 2002:a63:3143:0:b0:3fc:6078:7e0f with SMTP id x64-20020a633143000000b003fc60787e0fmr32711835pgx.272.1654748283428;
        Wed, 08 Jun 2022 21:18:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwY1NYImRKuMbi4cL/TL2r+YTtTIKux20huCQhCA8HZy71dXmAS127+UCqiKfw4e+p/+sTY3w==
X-Received: by 2002:a63:3143:0:b0:3fc:6078:7e0f with SMTP id x64-20020a633143000000b003fc60787e0fmr32711818pgx.272.1654748283144;
        Wed, 08 Jun 2022 21:18:03 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id nr11-20020a17090b240b00b001ea5ef30096sm291425pjb.10.2022.06.08.21.17.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 21:18:02 -0700 (PDT)
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
Message-ID: <b405ddd5-1df2-1568-6ea3-51279524e099@redhat.com>
Date:   Thu, 9 Jun 2022 12:17:57 +0800
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

Recently we have hit a similar bug, caused by deferring a request and 
requeuing it and the following request was executed before it.


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


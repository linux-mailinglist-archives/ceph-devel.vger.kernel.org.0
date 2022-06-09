Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F01B544239
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 05:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237724AbiFID4L (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jun 2022 23:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbiFID4K (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jun 2022 23:56:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 027F327B0A
        for <ceph-devel@vger.kernel.org>; Wed,  8 Jun 2022 20:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654746968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6MR0q2fy6oj2HLkej5FIpQF3WyZxvNluSDtfrcL0lJA=;
        b=fYranntXxanZt/ZW8TcKNra3jJacPN3hEK2C9xjlHwre/t6gNeW/jlfIMPi9TqomDRCK8B
        lX0CypN/R6/1Gf/kQx9m7wUkNUqRKGHJWIsOkrsR/yVzweIHYqHg5g2C+1s4/+uOEiMrDU
        RGMWwvS9cKgUxOliH28PABBnzD9ZLlA=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-PCE0gQfeMO2A_jZbhtVZgg-1; Wed, 08 Jun 2022 23:56:07 -0400
X-MC-Unique: PCE0gQfeMO2A_jZbhtVZgg-1
Received: by mail-pl1-f199.google.com with SMTP id i8-20020a170902c94800b0016517194819so12041843pla.7
        for <ceph-devel@vger.kernel.org>; Wed, 08 Jun 2022 20:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6MR0q2fy6oj2HLkej5FIpQF3WyZxvNluSDtfrcL0lJA=;
        b=r3WP1knun0ogLDget/ctjNf3w6plkUe4BujFfi8fOdWp/cu5wyIBZF4pUiMdsKjDLT
         eCJVcWYZavDMRWSVzlAxqOuYJrTaKl+BUZftUAO0E/Wz+RhKrRS31WKsH1DA5xl00hv+
         yCaVTZuhXQlDjPypNPNWHYNaQowh+rMnxviCB1iomYBV8P5X8S938YuRULnSno05Ujk0
         V02ri8+blIYIgb92rr4WSZrz/eVoNvrr0PMb/7noYnkqfcFi7oUI6wmvB7sGcQm3iZaG
         lZ0bHBi7ZuV2bYjeIk2gK/68HCs8/m+K2jkdrbi2aKQZ6FwyGf0J6foBEWJ18hIY/saB
         pngQ==
X-Gm-Message-State: AOAM532Bni25LHsnU/Uwidc/EINW0mg35BpJOZ2kJ9oYd3QjWE1d9Qt8
        nvrOpSxkKEHHSGCU3QPW0bf9tlCDLgBZNIjv/IZpSzaZ7WrZbjgRTinpNZBJyb9sMYehibe7Mau
        tIfoaKIXFXhFb88HlIgUsYIdPPPtvsJLux81f8UTVfdCMoWIViXnWMSbUVFe71f+TUyW4IQg=
X-Received: by 2002:aa7:80ce:0:b0:51c:70fc:8f5d with SMTP id a14-20020aa780ce000000b0051c70fc8f5dmr4870824pfn.1.1654746965432;
        Wed, 08 Jun 2022 20:56:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw3GJzGITlj6GiGwZRK1Xs5y3GlaRPL0W4vfArrSBJJnx2ariYFXIcYURBGXWMyxXSodkJb1A==
X-Received: by 2002:aa7:80ce:0:b0:51c:70fc:8f5d with SMTP id a14-20020aa780ce000000b0051c70fc8f5dmr4870798pfn.1.1654746965080;
        Wed, 08 Jun 2022 20:56:05 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x17-20020a056a000bd100b0051be1b4cfb5sm11820527pfu.5.2022.06.08.20.56.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 20:56:04 -0700 (PDT)
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
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <115f53c7-4ad4-aa1f-05b0-66de7d2cdb03@redhat.com>
Date:   Thu, 9 Jun 2022 11:55:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAM7YAn7UBP-ip=71AcApu70wpvYLS9-q843LALkA9oyw8MqAw@mail.gmail.com>
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


On 6/9/22 11:29 AM, Yan, Zheng wrote:
> On Thu, Jun 9, 2022 at 11:19 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 6/9/22 10:15 AM, Yan, Zheng wrote:
>>> The recent series of patches that add "wait on async xxxx" at various
>>> places do not seem correct. The correct fix should make mds avoid any
>>> wait when handling async requests.
>>>
>> In this case I am thinking what will happen if the async create request
>> is deferred, then the cap flush related request should fail to find the
>> ino.
>>
>> Should we wait ? Then how to distinguish from migrating a subtree and a
>> deferred async create cases ?
>>
> async op caps are revoked at freezingtree stage of subtree migration.
> see Locker::invalidate_lock_caches
>
Sorry I may not totally understand this issue.

I think you mean in case of migration and then the MDS will revoke caps 
for the async create files and then the kclient will send a MclientCap 
request to mds, right ?

If my understanding is correct, there is another case that:

1, async create a fileA

2, then write a lot of data to it and then release the Fw cap ref, and 
if we should report the size to MDS, it will send a MclientCap request 
to MDS too.

3, what if the async create of fileA was deferred due to some reason, 
then the MclientCap request will fail to find the ino ?


>>> On Wed, Jun 8, 2022 at 12:56 PM Jeff Layton <jlayton@kernel.org> wrote:
>>>> Currently, we'll call ceph_check_caps, but if we're still waiting on the
>>>> reply, we'll end up spinning around on the same inode in
>>>> flush_dirty_session_caps. Wait for the async create reply before
>>>> flushing caps.
>>>>
>>>> Fixes: fbed7045f552 (ceph: wait for async create reply before sending any cap messages)
>>>> URL: https://tracker.ceph.com/issues/55823
>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>>> ---
>>>>    fs/ceph/caps.c | 1 +
>>>>    1 file changed, 1 insertion(+)
>>>>
>>>> I don't know if this will fix the tx queue stalls completely, but I
>>>> haven't seen one with this patch in place. I think it makes sense on its
>>>> own, either way.
>>>>
>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>> index 0a48bf829671..5ecfff4b37c9 100644
>>>> --- a/fs/ceph/caps.c
>>>> +++ b/fs/ceph/caps.c
>>>> @@ -4389,6 +4389,7 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
>>>>                   ihold(inode);
>>>>                   dout("flush_dirty_caps %llx.%llx\n", ceph_vinop(inode));
>>>>                   spin_unlock(&mdsc->cap_dirty_lock);
>>>> +               ceph_wait_on_async_create(inode);
>>>>                   ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
>>>>                   iput(inode);
>>>>                   spin_lock(&mdsc->cap_dirty_lock);
>>>> --
>>>> 2.36.1
>>>>


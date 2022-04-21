Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B9150948D
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Apr 2022 03:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383590AbiDUBPN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Apr 2022 21:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381986AbiDUBPL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Apr 2022 21:15:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D7A0D14099
        for <ceph-devel@vger.kernel.org>; Wed, 20 Apr 2022 18:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650503540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=azovI5go3NRMIFkVa/N6Ukgez/dLhNMDbE+pGwMpvI8=;
        b=DSZU1UqawkJ1LYwIG8HWmfbv0HY4OQSstaZDvIfUUMukbl9gHEnUAypAEn1Af20iVwa6h1
        QKuRiWOvjJM4UehDpt7mD4UyUbtV3Gg5oS3Io0cK/3JFarfx1APCM9fDiQgeeRxBmfw4Ub
        yQgvuVesGbaGSzKN5tYboD9GFm4779I=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-pv_H31Z9NmiV_7KX4SfT9Q-1; Wed, 20 Apr 2022 21:12:19 -0400
X-MC-Unique: pv_H31Z9NmiV_7KX4SfT9Q-1
Received: by mail-pj1-f71.google.com with SMTP id a4-20020a17090acb8400b001d1d9a6a9f1so1622141pju.5
        for <ceph-devel@vger.kernel.org>; Wed, 20 Apr 2022 18:12:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=azovI5go3NRMIFkVa/N6Ukgez/dLhNMDbE+pGwMpvI8=;
        b=r/9NstY3uLpsPa5mukXHc44cxY1ITFsl7dTx3Xkp7oa3V4cHIYQLrtmgzFg2m8sxZV
         SX6vPmPIMkVHkY1vJYh/raxMfvZxpng+aQ1VMknkHq02fN9Pj1RWzMZZqX+XyM2EOseF
         Z8znHkj0taxk7y1w3PHqPW5SGoQQJv7BEN6eKfzor49Q+duF1haqSRA28glL4TbRU7Tf
         jJH3/UtOhLdKju5yGQryPI8Aa0HqxEhhK2ND6kbfQtvoaVJYCMG6zWfzqlz+VZlj1wXR
         ezZfq6kNFOaFABr2Gie3E7GTT5VeQGsGNUa1D2fh21DmzHwjoRy6MjL25tGC8+sxM3qD
         Egmg==
X-Gm-Message-State: AOAM533/rAUTaz2x13DuWC8EiYe3snBN+7ike6DKi1Fn/Od2TQqX2RR7
        ZFuyB+rX4MkfApYT1kXGZM+xKJStL9dNghR1QXoxlAE5wsKnVZOprBBc5Hk42UW3HyDatzFXnF1
        1b6dGoX5217nbpn/ijms9vcWw0mWHNJhRQywmG22eOgIA3iODc23+Ch34R9D0HYymvSI1RpA=
X-Received: by 2002:a17:90b:203:b0:1cb:bfe7:106 with SMTP id fy3-20020a17090b020300b001cbbfe70106mr7502383pjb.78.1650503538138;
        Wed, 20 Apr 2022 18:12:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxi4fls6LDieWCkJbs8VcxqrFJAVJsO2pHjVk+1hjaG3nu0OOGaRH0mXHwNlLDh0eE3pMdc/Q==
X-Received: by 2002:a17:90b:203:b0:1cb:bfe7:106 with SMTP id fy3-20020a17090b020300b001cbbfe70106mr7502352pjb.78.1650503537774;
        Wed, 20 Apr 2022 18:12:17 -0700 (PDT)
Received: from [10.72.12.77] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l2-20020a056a0016c200b004f7e3181a41sm22987134pfc.98.2022.04.20.18.12.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 18:12:17 -0700 (PDT)
Subject: Re: [RFC PATCH] ceph: disable updating the atime since cephfs won't
 maintain it
To:     Gregory Farnum <gfarnum@redhat.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <20220420052404.1144209-1-xiubli@redhat.com>
 <5b6832315f8561010bb2a7dd93638752ebf8166b.camel@kernel.org>
 <CAJ4mKGb+ru__H24Z2vONJ+Q3np5ix+mqju7iYBayrAwZG1CxAQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <878e3078-e72c-641f-4207-5058edb6ac62@redhat.com>
Date:   Thu, 21 Apr 2022 09:12:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAJ4mKGb+ru__H24Z2vONJ+Q3np5ix+mqju7iYBayrAwZG1CxAQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/20/22 10:08 PM, Gregory Farnum wrote:
> On Wed, Apr 20, 2022 at 6:57 AM Jeff Layton <jlayton@kernel.org> wrote:
>> On Wed, 2022-04-20 at 13:24 +0800, Xiubo Li wrote:
>>> Since the cephFS makes no attempt to maintain atime, we shouldn't
>>> try to update it in mmap and generic read cases and ignore updating
>>> it in direct and sync read cases.
>>>
>>> And even we update it in mmap and generic read cases we will drop
>>> it and won't sync it to MDS. And we are seeing the atime will be
>>> updated and then dropped to the floor again and again.
>>>
>>> URL: https://lists.ceph.io/hyperkitty/list/ceph-users@ceph.io/thread/VSJM7T4CS5TDRFF6XFPIYMHP75K73PZ6/
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   fs/ceph/addr.c  | 1 -
>>>   fs/ceph/super.c | 1 +
>>>   2 files changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>>> index aa25bffd4823..02722ac86d73 100644
>>> --- a/fs/ceph/addr.c
>>> +++ b/fs/ceph/addr.c
>>> @@ -1774,7 +1774,6 @@ int ceph_mmap(struct file *file, struct vm_area_struct *vma)
>>>
>>>        if (!mapping->a_ops->readpage)
>>>                return -ENOEXEC;
>>> -     file_accessed(file);
>>>        vma->vm_ops = &ceph_vmops;
>>>        return 0;
>>>   }
>>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>>> index e6987d295079..b73b4f75462c 100644
>>> --- a/fs/ceph/super.c
>>> +++ b/fs/ceph/super.c
>>> @@ -1119,6 +1119,7 @@ static int ceph_set_super(struct super_block *s, struct fs_context *fc)
>>>        s->s_time_gran = 1;
>>>        s->s_time_min = 0;
>>>        s->s_time_max = U32_MAX;
>>> +     s->s_flags |= SB_NODIRATIME | SB_NOATIME;
>>>
>>>        ret = set_anon_super_fc(s, fc);
>>>        if (ret != 0)
>> (cc'ing Greg since he claimed this...)
> Hmm? I don't think I've been in any atime discussions in years...

Yeah, it's around 3 years ago in that link :-)

I checked the history of both libcephfs and kernel about the atime 
changes, it not ever maintained.

-- Xiubo

>> I confess, I've never dug into the MDS code that should track atime, but
>> I'm rather surprised that the MDS just drops those updates onto the
>> floor.
>>
>> It's obviously updated when the mtime changes. The SETATTR operation
>> allows the client to set the atime directly, and there is an "atime"
>> slot in the cap structure that does get populated by the client. I guess
>> though that it has never been 100% clear what cap the atime should be
>> governed by so maybe it just always ignores that field?
>>
>> Anyway, I've no firm objection to this since no one in their right mind
>> should use the atime anyway, but you may see some complaints if you just
>> turn it off like this. There are some applications that use it.
>> Hopefully no one is running those on ceph.
>>
>> It would be nice to document this somewhere as well -- maybe on the ceph
>> POSIX conformance page?
>>
>>      https://docs.ceph.com/en/latest/cephfs/posix/
>>
>> --
>> Jeff Layton <jlayton@kernel.org>
>>


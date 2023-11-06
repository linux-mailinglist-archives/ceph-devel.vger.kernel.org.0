Return-Path: <ceph-devel+bounces-53-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FE487E2114
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 13:16:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A373281366
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 12:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A581EB50;
	Mon,  6 Nov 2023 12:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rt5MmEJv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4A21EB4A
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 12:15:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B106E1BF
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 04:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699272953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+sJt7sbRaLLbMIE8mWTEhgxYgqEMNmGci4zAkPiHSek=;
	b=Rt5MmEJvmxcedA6b42ih5uvQZ2oFYATZMEJEmj60qCMCCGYePuBMWcPmndKgUOVKYON0t0
	D7c98zhcaoifC3ypKLQVkb5P4lyAmsBABlT37RDbVEv6yoN6Ytl9WcVpDfccMT4OQeCmWG
	XF4t95W3xfbg4NedXlwqwXkRhBKoVew=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-Pi3P1pCAM26GWrJPyVx3gA-1; Mon, 06 Nov 2023 07:15:52 -0500
X-MC-Unique: Pi3P1pCAM26GWrJPyVx3gA-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6b1f7baa5ceso2924290b3a.2
        for <ceph-devel@vger.kernel.org>; Mon, 06 Nov 2023 04:15:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699272951; x=1699877751;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+sJt7sbRaLLbMIE8mWTEhgxYgqEMNmGci4zAkPiHSek=;
        b=XnCxcQbhCkEmD7ejyQhCmNaHUthEnR4sfkVZB1IzyJBHEw1R2LjpxOCyhGdbIMazjE
         lB9Gp3wOoTcRvT/r4vmi7HK7Ds4HUf/t2Czx8tH92tKL76+T8JkFYUJkZ12tv6ywSIs2
         N7RvXDY/L1hSu9b0DL4UJMFo2Fww9cQYj8vs9uIPv40T61dH9UdEqJjRON1LGKsb1UG5
         g8m8BFrurYK/bWXhn/HZ2rl/A8Q9xNqtAzFWO2xMpDaZnFt/MyXTZh5hHaeiMQAR/NcX
         S4NCCVQRLcUMAF5Q/c+X6sqeHACE4h55/PNh7IdsJaqrZUk+RFcNo1qxwndz6pgwNllJ
         fU7A==
X-Gm-Message-State: AOJu0YzU/xXIlaB0dpETbZKbgGlGKDvx65lM48EXGuab0ZbYA45Aly0t
	JpWwSvEuLBA71PN0h+EKnnYZtntkkq1wTDcfW+VgOxwLU1wSoy9LvokRtU0Dz8M707SqT46ecsb
	ry5zWgnDAiIWQMdtInxnLpQ==
X-Received: by 2002:a05:6a00:1307:b0:6bd:8c4a:ab8f with SMTP id j7-20020a056a00130700b006bd8c4aab8fmr25503014pfu.2.1699272951199;
        Mon, 06 Nov 2023 04:15:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF2KjM2PVQEEII8Xr33UlEJ+HTwSa4GtjJbBZ6ikKrajTlDLBw4dq36yvNazpHJFoVg+UwBCg==
X-Received: by 2002:a05:6a00:1307:b0:6bd:8c4a:ab8f with SMTP id j7-20020a056a00130700b006bd8c4aab8fmr25502994pfu.2.1699272950582;
        Mon, 06 Nov 2023 04:15:50 -0800 (PST)
Received: from [10.72.112.221] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p56-20020a056a0026f800b006c31c239345sm5697415pfw.177.2023.11.06.04.15.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 04:15:50 -0800 (PST)
Message-ID: <3d84df08-661d-ce82-45e6-88168b65bc1d@redhat.com>
Date: Mon, 6 Nov 2023 20:15:46 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] libceph: remove the max extents check for sparse read
Content-Language: en-US
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
 vshankar@redhat.com, mchangir@redhat.com
References: <20231103033900.122990-1-xiubli@redhat.com>
 <CAOi1vP8EtALzni0sdj0o4j61KkC6XqgzEgikCDhDPOHX6LNYZw@mail.gmail.com>
 <23b5dc4e0607a033714e50c3326d587fd0cf99bf.camel@kernel.org>
 <1cded211-047b-ae79-fcf8-0838c1f8a21c@redhat.com>
 <CAOi1vP8x0-o3+wqi6oTBAY_v7-SnvNoC48AcCAJP8BOAUb+sLg@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP8x0-o3+wqi6oTBAY_v7-SnvNoC48AcCAJP8BOAUb+sLg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/6/23 19:42, Ilya Dryomov wrote:
> On Mon, Nov 6, 2023 at 7:43 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 11/3/23 18:14, Jeff Layton wrote:
>>> On Fri, 2023-11-03 at 11:07 +0100, Ilya Dryomov wrote:
>>>> On Fri, Nov 3, 2023 at 4:41 AM <xiubli@redhat.com> wrote:
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> There is no any limit for the extent array size and it's possible
>>>>> that when reading with a large size contents. Else the messager
>>>>> will fail by reseting the connection and keeps resending the inflight
>>>>> IOs.
>>>>>
>>>>> URL: https://tracker.ceph.com/issues/62081
>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>> ---
>>>>>    net/ceph/osd_client.c | 12 ------------
>>>>>    1 file changed, 12 deletions(-)
>>>>>
>>>>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>>>>> index 7af35106acaf..177a1d92c517 100644
>>>>> --- a/net/ceph/osd_client.c
>>>>> +++ b/net/ceph/osd_client.c
>>>>> @@ -5850,8 +5850,6 @@ static inline void convert_extent_map(struct ceph_sparse_read *sr)
>>>>>    }
>>>>>    #endif
>>>>>
>>>>> -#define MAX_EXTENTS 4096
>>>>> -
>>>>>    static int osd_sparse_read(struct ceph_connection *con,
>>>>>                              struct ceph_msg_data_cursor *cursor,
>>>>>                              char **pbuf)
>>>>> @@ -5882,16 +5880,6 @@ static int osd_sparse_read(struct ceph_connection *con,
>>>>>
>>>>>                   if (count > 0) {
>>>>>                           if (!sr->sr_extent || count > sr->sr_ext_len) {
>>>>> -                               /*
>>>>> -                                * Apply a hard cap to the number of extents.
>>>>> -                                * If we have more, assume something is wrong.
>>>>> -                                */
>>>>> -                               if (count > MAX_EXTENTS) {
>>>>> -                                       dout("%s: OSD returned 0x%x extents in a single reply!\n",
>>>>> -                                            __func__, count);
>>>>> -                                       return -EREMOTEIO;
>>>>> -                               }
>>>>> -
>>>>>                                   /* no extent array provided, or too short */
>>>>>                                   kfree(sr->sr_extent);
>>>>>                                   sr->sr_extent = kmalloc_array(count,
>>>>> --
>>>>> 2.39.1
>>>>>
>>>> Hi Xiubo,
>>>>
>>>> As noted in the tracker ticket, there are many "sanity" limits like
>>>> that in the messenger and other parts of the kernel client.  First,
>>>> let's change that dout to pr_warn_ratelimited so that it's immediately
>>>> clear what is going on.  Then, if the limit actually gets hit, let's
>>>> dig into why and see if it can be increased rather than just removed.
>>>>
>>> Yeah, agreed. I think when I wrote this, I couldn't figure out if there
>>> was an actual hard cap on the number of extents, so I figured 4k ought
>>> to be enough for anybody. Clearly that was wrong though.
>>>
>>> I'd still favor raising the cap instead eliminating it altogether. Is
>>> there a hard cap on the number of extents that the OSD will send in a
>>> single reply? That's really what this limit should be.
>> I went through the messager code again carefully, I found that even in
>> case when the errno is '-ENOMEM' for a request the messager will trigger
>> the connection fault, which will reconnect the connection and retry all
>> the osd requests. This looks incorrect.
> In theory, ENOMEM can be transient.  If memory is too fragmented (e.g.
> kmalloc is used and there is no physically contiguous chunk of required
> size available), it makes sense to retry the allocation after some time
> passes.
>
>> IMO only in case when the errno is any of '-EBADMSG' or '-EREMOTEIO',
>> etc should we retry the osd requests. And for the errors that caused by
>> the client side we should fail the osd requests instead.
> The messenger never fails higher level requests, no matter what the
> error is.  Whether it's a good idea is debatable (personally I'm not
> a fan), but this is how it behaves in userspace, so there isn't much
> implementation freedom here.

Okay. Get it.

Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>



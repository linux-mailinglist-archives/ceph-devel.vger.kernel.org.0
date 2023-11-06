Return-Path: <ceph-devel+bounces-60-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAF177E22AB
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 14:02:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01975B20EA5
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 13:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1EFF200A5;
	Mon,  6 Nov 2023 13:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cnlpvj4K"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE571A592
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 13:02:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67636A9
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 05:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699275758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Et0n6pE0VqcKcoQLytkFdqaSKPeLmD1dVaHH7tBy5o=;
	b=Cnlpvj4KjIJxhEtjVg+xWF+4IIjocfRiRD0dap6INqPqjUFUZz3Vzcz1CLenc+nBZ4pqbU
	JQ4240+3vqTnge2pZN0EsrGCDjUGu2nmKYBYwi17a2Rot+xxjKkARzXzKmrmwB7FrfyqCh
	f2zv/MZGM09Qml1dZ9pVZ0eym/1ULCM=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-hr-iVX-MP0qRp6HHU9Qliw-1; Mon, 06 Nov 2023 08:02:15 -0500
X-MC-Unique: hr-iVX-MP0qRp6HHU9Qliw-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-28014ce75d5so4236406a91.2
        for <ceph-devel@vger.kernel.org>; Mon, 06 Nov 2023 05:02:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699275734; x=1699880534;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Et0n6pE0VqcKcoQLytkFdqaSKPeLmD1dVaHH7tBy5o=;
        b=sYTMJdpK4seIhC/UIhyQ3t5iltjKUgykHOGIjq3+IUgLObtIA+3UW+mG7ua+Pj/BEH
         6nIrXKf4QID7spFq7YNFYM2CCXMC9uPSeBlpFhnunUUBfExTwFI+fwcACGzAqV2zQ7WO
         /WaJhW6tnxse89mKyCVhGRiPbLegJRmMt2DB0hYsCsmq3zOxSnkFzM9U0Ti3HFIuqbub
         aEDE0RiZ1VcG5J5BNFrbHgV/gKklLAYVooFH6d+YF66UARlnb3lzeWOIdDBzDpPTMYMH
         JuUJMKU1XF1cJY6aeCvhQOUs715q5zuLrgwnXe7xaBtwH7p1w+gSRe1zU+xd4VLAO5os
         V65A==
X-Gm-Message-State: AOJu0YyvZkBxVlNqDekoHTObIBtjYYliwLXaP510bTIBl9TwVLeeurXl
	66tj37kS6wXSoAxz+mO5j2qoM7GU9JR7iPz+JZaIjkY8lOMHnWCxuMR86+ZjmTRo+s0qcKi3kj6
	Vg/DWsoHDUgARhwThknVC7Z4Z5Bry6b8f
X-Received: by 2002:a17:90a:4e:b0:280:3a8:6499 with SMTP id 14-20020a17090a004e00b0028003a86499mr24876340pjb.40.1699275733839;
        Mon, 06 Nov 2023 05:02:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFKWF30vzrdFjIdq1GSLPU3aS0wMZ+seCdFWFplCk2uMJ7AwuAcne6oi20VCj5rK4CZANVOGg==
X-Received: by 2002:a17:90a:4e:b0:280:3a8:6499 with SMTP id 14-20020a17090a004e00b0028003a86499mr24876316pjb.40.1699275733389;
        Mon, 06 Nov 2023 05:02:13 -0800 (PST)
Received: from [10.72.112.221] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 7-20020a17090a000700b00280fcbbe774sm1782100pja.10.2023.11.06.05.02.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 05:02:13 -0800 (PST)
Message-ID: <99d6468e-f287-43a7-fa55-48e570234a00@redhat.com>
Date: Mon, 6 Nov 2023 21:02:09 +0800
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
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com,
 mchangir@redhat.com
References: <20231103033900.122990-1-xiubli@redhat.com>
 <CAOi1vP8EtALzni0sdj0o4j61KkC6XqgzEgikCDhDPOHX6LNYZw@mail.gmail.com>
 <e350e6e7-22a2-69de-258f-70c2050dbd50@redhat.com>
 <CAOi1vP9haOn0RujjiWU5TQ3F-ZEi8GKXYFV+xzTrX3V3saH46A@mail.gmail.com>
 <cee744a4-de97-0055-be94-1f928b06928e@redhat.com>
 <CAOi1vP-kUkUurOSS31_F9ND_X8BwxPp1uXo0EUkeuaP3ORK0Pg@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP-kUkUurOSS31_F9ND_X8BwxPp1uXo0EUkeuaP3ORK0Pg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/6/23 20:32, Ilya Dryomov wrote:
> On Mon, Nov 6, 2023 at 1:15 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 11/6/23 19:38, Ilya Dryomov wrote:
>>> On Mon, Nov 6, 2023 at 1:14 AM Xiubo Li <xiubli@redhat.com> wrote:
>>>> On 11/3/23 18:07, Ilya Dryomov wrote:
>>>>
>>>> On Fri, Nov 3, 2023 at 4:41 AM <xiubli@redhat.com> wrote:
>>>>
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> There is no any limit for the extent array size and it's possible
>>>> that when reading with a large size contents. Else the messager
>>>> will fail by reseting the connection and keeps resending the inflight
>>>> IOs.
>>>>
>>>> URL: https://tracker.ceph.com/issues/62081
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    net/ceph/osd_client.c | 12 ------------
>>>>    1 file changed, 12 deletions(-)
>>>>
>>>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>>>> index 7af35106acaf..177a1d92c517 100644
>>>> --- a/net/ceph/osd_client.c
>>>> +++ b/net/ceph/osd_client.c
>>>> @@ -5850,8 +5850,6 @@ static inline void convert_extent_map(struct ceph_sparse_read *sr)
>>>>    }
>>>>    #endif
>>>>
>>>> -#define MAX_EXTENTS 4096
>>>> -
>>>>    static int osd_sparse_read(struct ceph_connection *con,
>>>>                              struct ceph_msg_data_cursor *cursor,
>>>>                              char **pbuf)
>>>> @@ -5882,16 +5880,6 @@ static int osd_sparse_read(struct ceph_connection *con,
>>>>
>>>>                   if (count > 0) {
>>>>                           if (!sr->sr_extent || count > sr->sr_ext_len) {
>>>> -                               /*
>>>> -                                * Apply a hard cap to the number of extents.
>>>> -                                * If we have more, assume something is wrong.
>>>> -                                */
>>>> -                               if (count > MAX_EXTENTS) {
>>>> -                                       dout("%s: OSD returned 0x%x extents in a single reply!\n",
>>>> -                                            __func__, count);
>>>> -                                       return -EREMOTEIO;
>>>> -                               }
>>>> -
>>>>                                   /* no extent array provided, or too short */
>>>>                                   kfree(sr->sr_extent);
>>>>                                   sr->sr_extent = kmalloc_array(count,
>>>> --
>>>> 2.39.1
>>>>
>>>> Hi Xiubo,
>>>>
>>>> As noted in the tracker ticket, there are many "sanity" limits like
>>>> that in the messenger and other parts of the kernel client.  First,
>>>> let's change that dout to pr_warn_ratelimited so that it's immediately
>>>> clear what is going on.
>>>>
>>>> Sounds good to me.
>>>>
>>>>    Then, if the limit actually gets hit, let's
>>>> dig into why and see if it can be increased rather than just removed.
>>>>
>>>> The test result in https://tracker.ceph.com/issues/62081#note-16 is that I just changed the 'len' to 5000 in ceph PR https://github.com/ceph/ceph/pull/54301 to emulate a random writes to a file and then tries to read with a large size:
>>>>
>>>> [ RUN      ] LibRadosIoPP.SparseReadExtentArrayOpPP
>>>> extents array size : 4297
>>>>
>>>> For the 'extents array size' it could reach up to a very large number, then what it should be ? Any idea ?
>>> Hi Xiubo,
>>>
>>> I don't think it can be a very large number in practice.
>>>
>>> CephFS uses sparse reads only in the fscrypt case, right?
>> Yeah, it is.
>>
>>
>>>     With
>>> fscrypt, sub-4K writes to the object store aren't possible, right?
>> Yeah.
>>
>>
>>> If the answer to both is yes, then the maximum number of extents
>>> would be
>>>
>>>       64M (CEPH_MSG_MAX_DATA_LEN) / 4K = 16384
>>>
>>> even if the object store does tracking at byte granularity.
>> So yeah, just for the fscrypt case if we set the max extent number to
>> 16384 it should be fine. But the sparse read could also be enabled in
>> non-fscrypt case.
> Ah, I see that it's also exposed as a mount option.  If we expect
> people to use it, then dropping MAX_EXTENTS altogether might be the
> best approach after all -- it doesn't make sense to warn about
> something that we don't really control.
>
> How about printing the number of extents only if the allocation fails?
> Something like:
>
>      if (!sr->sr_extent) {
>              pr_err("failed to allocate %u sparse read extents\n", count);
>              return -ENOMEM;
>      }

Yeah, this also looks good to me.

I will fix it.

Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>



Return-Path: <ceph-devel+bounces-59-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C582D7E22A8
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 14:01:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6E781B20EC1
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 13:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F36721F951;
	Mon,  6 Nov 2023 13:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jDps5Rcx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9BA1A592
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 13:01:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B62BF
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 05:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699275696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2he4cO+JKm41yuvaGZzl2SQojqAf9W5KklbyadCnAY8=;
	b=jDps5RcxZ9h7IfmQBU7BqtTKA0mjv1a7dFulHydCaHaHHJ88ElQiZtOLHL5XeGTS2+z7IJ
	9l0NIFq4Daal9UW/nCgK/9H1jpN0cCNSdwkGIf8a/q8v6tKbpF7rwLQHFZwHbscU53kWzd
	Tf8PL3MrBp+2uxf3NW/lSpWM7bm5r2g=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-cjugnVgBMfyOJ5vjBIPmvg-1; Mon, 06 Nov 2023 08:01:34 -0500
X-MC-Unique: cjugnVgBMfyOJ5vjBIPmvg-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6b243dc6aeeso3278247b3a.3
        for <ceph-devel@vger.kernel.org>; Mon, 06 Nov 2023 05:01:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699275694; x=1699880494;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2he4cO+JKm41yuvaGZzl2SQojqAf9W5KklbyadCnAY8=;
        b=oT+GaqcsXFsZar2REcyuOyhBf+xCI1bTjnxPRMRETSvipE39rO9G9owy+4EQFbGKuf
         wacSEo1zWT/4/5fvgA2YKRBkF6t6W94fS/WYyXXXmV/tErXNVtBV9W+VwbHigcmjx0T2
         ehkCbsijN5qPzp3EuyqSOdw+LuAE0Y1NmIQq7H+zbw99FyYv52XA2aZJ82Q1xk1wjbIL
         NWPcLmf7d4br68Tg2u3r2SY7i+fXNv1FgpDlOXWbtMBiNrK6WaUQYdWl2YOyTnm447XW
         VK/S7vJ42xZXOXaMRhcyNqMc5B2nAnF3HgHFPPfDTSEdxbBJ3G9lv+Wk1zqYzcuihdio
         JQ9A==
X-Gm-Message-State: AOJu0Yxa0G6Q4Li7howuocEVdmunLpY0fXrpi5lqw4TMLnVcVVcjfn2n
	GO4Y8fYRfVFvFAoR7G2RT94vU5xcBJ/JCUgAHvXx+6Ucr1Ws1WcF0EgZnvycbXdDFQD3Lu6Ckh1
	MjGJpzWLUEydkMPhYns7rfg==
X-Received: by 2002:a05:6a20:4401:b0:179:faa1:46ba with SMTP id ce1-20020a056a20440100b00179faa146bamr30709983pzb.35.1699275693653;
        Mon, 06 Nov 2023 05:01:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGncxzvElqLxFuynkDXABQLNQjeaVRv4kfYGtOfADyuJOgMLWe37Ri6CwO6Q8HARzlbRkFAZw==
X-Received: by 2002:a05:6a20:4401:b0:179:faa1:46ba with SMTP id ce1-20020a056a20440100b00179faa146bamr30709955pzb.35.1699275693288;
        Mon, 06 Nov 2023 05:01:33 -0800 (PST)
Received: from [10.72.112.221] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s22-20020a17090aad9600b0027d0a60b9c9sm5475535pjq.28.2023.11.06.05.01.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 05:01:33 -0800 (PST)
Message-ID: <c3efdf13-89b6-bcff-2ac4-7bb4681862a2@redhat.com>
Date: Mon, 6 Nov 2023 21:01:28 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 2/2] libceph: check the data length when sparse-read
 finishes
Content-Language: en-US
To: Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, vshankar@redhat.com, mchangir@redhat.com
References: <20231106011644.248119-1-xiubli@redhat.com>
 <20231106011644.248119-3-xiubli@redhat.com>
 <CAOi1vP_NQmkreqVoM+CP=v3PkGh-79jYV8xgrmDA0b4z8PJ3mA@mail.gmail.com>
 <873e9540-cf61-e517-eb68-5b83e8984f0e@redhat.com>
 <85fd22f7f3b3c18cbb9a1edf5894300faca0f2fa.camel@kernel.org>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <85fd22f7f3b3c18cbb9a1edf5894300faca0f2fa.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/6/23 20:32, Jeff Layton wrote:
> On Mon, 2023-11-06 at 20:17 +0800, Xiubo Li wrote:
>> On 11/6/23 19:54, Ilya Dryomov wrote:
>>> On Mon, Nov 6, 2023 at 2:19 AM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> For sparse reading the real length of the data should equal to the
>>>> total length from the extent array.
>>>>
>>>> URL: https://tracker.ceph.com/issues/62081
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> Reviewed-by: Jeff Layton <jlayton@kernel.org>
>>>> ---
>>>>    net/ceph/osd_client.c | 8 ++++++++
>>>>    1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>>>> index 0e629dfd55ee..050dc39065fb 100644
>>>> --- a/net/ceph/osd_client.c
>>>> +++ b/net/ceph/osd_client.c
>>>> @@ -5920,6 +5920,12 @@ static int osd_sparse_read(struct ceph_connection *con,
>>>>                   fallthrough;
>>>>           case CEPH_SPARSE_READ_DATA:
>>>>                   if (sr->sr_index >= count) {
>>>> +                       if (sr->sr_datalen && count) {
>>>> +                               pr_warn_ratelimited("%s: datalen and extents mismath, %d left\n",
>>>> +                                                   __func__, sr->sr_datalen);
>>>> +                               return -EREMOTEIO;
>>> By returning EREMOTEIO here you have significantly changed the
>>> semantics (in v2 it was just a warning) but Jeff's Reviewed-by is
>>> retained.  Has he acked the change?
>> Oh, sorry I forgot to remove that.
>>
>> Jeff, Please take a look here again.
>>
>> Thanks
>>
>> - Xiubo
>>
>>
> Returning EREMOTEIO if the lengths don't match seems like a reasonable
> thing to do. You can retain the R-b.
>
Thanks Jeff.

- Xiubo



Return-Path: <ceph-devel+bounces-269-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5A1580A82C
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 17:07:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81B262818CC
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 16:07:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF11C37146;
	Fri,  8 Dec 2023 16:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RPtMax9q"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43AF172A
	for <ceph-devel@vger.kernel.org>; Fri,  8 Dec 2023 08:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702051631;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vc7wda/3HguqP2CPbYIT/E8AxuNcDtlXCuOb9Oq/NAA=;
	b=RPtMax9qoyqa1tbN+4qayA6EpkgfnNl7c71pSkNXPxm8P0Qcev6sJ5ITGGPNPhsNhwtXmb
	sq2dTppStvJp9NwwBaN0qP2Z33sEMybyYz7JW4XghH94N8jJdpy1N1RZGDQKt6O9u3A+IU
	mRrePILk9Uych+Ve95msV9n1Hngyzgo=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-J8oBguaVP6ClXKhXzRyBew-1; Fri, 08 Dec 2023 11:07:09 -0500
X-MC-Unique: J8oBguaVP6ClXKhXzRyBew-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6cb42be51easo1386160b3a.1
        for <ceph-devel@vger.kernel.org>; Fri, 08 Dec 2023 08:07:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702051628; x=1702656428;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vc7wda/3HguqP2CPbYIT/E8AxuNcDtlXCuOb9Oq/NAA=;
        b=Pq+SAicC1yWlctyxME+btSVODdHx1EZDlHoBqAKjzq2WxzrCOKXGse++dWqyCLHX2k
         QMoGrSlMbUznWMWwt1r22WfgAZeqLm7LO/jsBqF0AkgNZE1PZsFupLVYuAtmbmZe5bmy
         +zT1SJsOiO3DIav5eBZVVuGJ7+1aEGwR+ljhypzxiMRYXt/2mFpfhrdlKQdL/qZ6X5MA
         GDHshv3AN7fciBiveXFyLwz+8wftJKRLn6MPfPldY7XP35L4BhHWgMj4uowSIgdHge37
         bMy2Ef/mbEIOz3e2R6VC+rnFDFR91/u6OjhZoVN/7jkmSvW1hwo3J8zITgnOSujbags9
         tIzQ==
X-Gm-Message-State: AOJu0YyHtFF/BUSAyB6V1PZQajd8KwX5MjtlS57S8/G+2sVVvOGRuRBH
	2CR4Quv1tN/Q0sno916+PlIs1zL/DVFnBHKPi2DuoOpShPeM6kfkPSdDHP+xExOeBolYxj6fqSD
	xJrmvnCOmHzfb6C+/QuEcCbgwA6PfyfOEfyI=
X-Received: by 2002:a05:6a21:1a3:b0:18f:e956:8332 with SMTP id le35-20020a056a2101a300b0018fe9568332mr521597pzb.8.1702051627718;
        Fri, 08 Dec 2023 08:07:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFa0StX7SC0z/5dha7yYpf7eaLEKaO8hv9tNg/rtE/6QwU2PSF6Hd0exrILWGseD+v6iaXRtA==
X-Received: by 2002:a05:6a21:1a3:b0:18f:e956:8332 with SMTP id le35-20020a056a2101a300b0018fe9568332mr521581pzb.8.1702051627399;
        Fri, 08 Dec 2023 08:07:07 -0800 (PST)
Received: from [10.72.112.27] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id du6-20020a056a002b4600b006cde7dd80cbsm1758046pfb.191.2023.12.08.08.07.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Dec 2023 08:07:07 -0800 (PST)
Message-ID: <dd483af6-63af-4343-aebe-59faa8c5aca8@redhat.com>
Date: Sat, 9 Dec 2023 00:07:02 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] libceph: fail the sparse-read if there still has data
 in socket
Content-Language: en-US
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com,
 mchangir@redhat.com
References: <20231208043305.91249-1-xiubli@redhat.com>
 <20231208043305.91249-2-xiubli@redhat.com>
 <CAOi1vP-aL0viMVHjXQr_CA0MyKNQ8FWH1qF4Vh-ntjFrOqYMNA@mail.gmail.com>
 <45aa72ee-4561-4159-ad52-055ae29da1f1@redhat.com>
 <CAOi1vP_AArSuq7h0EhKC_K3cs+nbrzzypPcqyyQU+Tk0Gu3y2Q@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_AArSuq7h0EhKC_K3cs+nbrzzypPcqyyQU+Tk0Gu3y2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 12/8/23 23:28, Ilya Dryomov wrote:
> On Fri, Dec 8, 2023 at 4:18 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 12/8/23 19:31, Ilya Dryomov wrote:
>>
>> On Fri, Dec 8, 2023 at 5:34 AM <xiubli@redhat.com> wrote:
>>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Once this happens that means there have bugs.
>>
>> URL: https://tracker.ceph.com/issues/63586
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   net/ceph/osd_client.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index 5753036d1957..848ef19055a0 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -5912,10 +5912,12 @@ static int osd_sparse_read(struct ceph_connection *con,
>>                  fallthrough;
>>          case CEPH_SPARSE_READ_DATA:
>>                  if (sr->sr_index >= count) {
>> -                       if (sr->sr_datalen && count)
>> +                       if (sr->sr_datalen) {
>>                                  pr_warn_ratelimited("sr_datalen %u sr_index %d count %u\n",
>>                                                      sr->sr_datalen, sr->sr_index,
>>                                                      count);
>> +                               return -EREMOTEIO;
>> +                       }
>>
>>                          sr->sr_state = CEPH_SPARSE_READ_HDR;
>>                          goto next_op;
>> --
>> 2.43.0
>>
>> Hi Xiubo,
>>
>> There is a patch in linux-next, also from you, which is conflicting
>> with this one: cca19d307d35 ("libceph: check the data length when
>> sparse read finishes").  Do you want it replaced?
>>
>> Ilya,
>>
>> I found the commit cca19d307d35 has already in the master branch. Could you fold and update it ?
> I would like to see the entire fix first.  You seem to be going back
> and forth between just issuing a warning or also returning an error and
> the precise if condition there, so I'm starting to think that the bug
> is not fully understood and neither patch might be necessary.

Sure, I just sent out the second version.

Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>



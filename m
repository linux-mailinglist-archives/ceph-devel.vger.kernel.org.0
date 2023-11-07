Return-Path: <ceph-devel+bounces-66-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE28A7E3A21
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Nov 2023 11:43:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDA6F1C20C42
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Nov 2023 10:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E350829420;
	Tue,  7 Nov 2023 10:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KKbXmrlz"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A2F1864A
	for <ceph-devel@vger.kernel.org>; Tue,  7 Nov 2023 10:43:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F70011A
	for <ceph-devel@vger.kernel.org>; Tue,  7 Nov 2023 02:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699353784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AlrHvdnn+fXHayYhtZXJKu1Pi6zziGmN9RfFIWP0WKg=;
	b=KKbXmrlzgsjrqKbGwSklTAYHRAEsEGIN1+LS1HCftubEx9z7qpIYXmgg/e0/O7CIgh/M63
	PRAVLJQS6wuUYSAjGXfAQEsL8U2oKA3jBPNXzxMHqyJEirMZtqkmJrqDbhg9B5G6IkfIn1
	uUeRdKpdGE+Toq9/1ju7ljIAQHrm1pU=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-zYVZq1STPxCnHwH5RidIpQ-1; Tue, 07 Nov 2023 05:43:03 -0500
X-MC-Unique: zYVZq1STPxCnHwH5RidIpQ-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5b99999614bso3387969a12.0
        for <ceph-devel@vger.kernel.org>; Tue, 07 Nov 2023 02:43:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699353782; x=1699958582;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AlrHvdnn+fXHayYhtZXJKu1Pi6zziGmN9RfFIWP0WKg=;
        b=Sx6z9ifrbw6rKoCRV7LmS3SkpTN114wPCd6m0zAZ09qoKTeojIdKWnH0uXH4ppeGl6
         h3/F6Llc5wMX4DnkygnraunIhIZymj2QjKEh+2Wf2MjyiXKTUZfYGBFvEILUwKdJEIfo
         JYi2L/Xfmxw7NyudMABw+MpRH4rIt5ZQL5Zm+37sxYZzQpybsBtr2smDLGonh3K4Gdai
         TItctsff7vd9EFxGDfOgTa2wrqd6KPaSCJY5GgVevLxoMBLq3JAqBYrwyV1TgcbJGkNZ
         KJ4loV9XxaCgsLOBOeLZRISdHpYqUu8lfH7cST7d8rnHJR74BBwfedZ9uyD2cRMyC3yu
         PHyg==
X-Gm-Message-State: AOJu0YxWe6fZ6YgXIeHICC104Eja2VQQaxYTCA4/1V3dD6g3blrsvpN5
	KdogURUsDw77TTIQzaSTK1GvIUgA6PkHTGjRLNv+RkSm6G5327UvMMunOimJE5gEMvjWExgCbYa
	ElI1mHE+5yf13ltMjeiuKvzMqdyJ16Etn
X-Received: by 2002:a05:6a21:3984:b0:182:11b2:b990 with SMTP id ad4-20020a056a21398400b0018211b2b990mr9875624pzc.12.1699353782377;
        Tue, 07 Nov 2023 02:43:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFxNtmYKMDa/Ikd7fgBXUEQzstMveBo0NKnaa/rJgQkB/6YDFYYXna486aT3MRDPp95gESipw==
X-Received: by 2002:a05:6a21:3984:b0:182:11b2:b990 with SMTP id ad4-20020a056a21398400b0018211b2b990mr9875611pzc.12.1699353782056;
        Tue, 07 Nov 2023 02:43:02 -0800 (PST)
Received: from [10.72.112.221] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id iy10-20020a170903130a00b001cc3a8af18dsm7374283plb.60.2023.11.07.02.42.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Nov 2023 02:43:01 -0800 (PST)
Message-ID: <19db51b8-841b-8433-2b42-7bc9c70e383f@redhat.com>
Date: Tue, 7 Nov 2023 18:42:57 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3] libceph: remove the max extents check for sparse read
Content-Language: en-US
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com,
 mchangir@redhat.com
References: <20231107014458.299637-1-xiubli@redhat.com>
 <CAOi1vP9J8JWFRpVEoojgH_LOdJm+dvvQO-EzyhPAW55kQ0k_vw@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP9J8JWFRpVEoojgH_LOdJm+dvvQO-EzyhPAW55kQ0k_vw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/7/23 18:14, Ilya Dryomov wrote:
> On Tue, Nov 7, 2023 at 2:47 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> There is no any limit for the extent array size and it's possible
>> that when reading with a large size contents the total number of
>> extents will exceed 4096. Then the messager will fail by reseting
>> the connection and keeps resending the inflight IOs infinitely.
>>
>> URL: https://tracker.ceph.com/issues/62081
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V3:
>> - Remove the max extents check and add one debug log.
>>
>> V2:
>> - Increase the MAX_EXTENTS instead of removing it.
>> - Do not return an errno when hit the limit.
>>
>>
>>
>>
>>   net/ceph/osd_client.c | 17 ++++-------------
>>   1 file changed, 4 insertions(+), 13 deletions(-)
>>
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index c03d48bd3aff..5f10ab76d0f3 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -5850,8 +5850,6 @@ static inline void convert_extent_map(struct ceph_sparse_read *sr)
>>   }
>>   #endif
>>
>> -#define MAX_EXTENTS 4096
>> -
>>   static int osd_sparse_read(struct ceph_connection *con,
>>                             struct ceph_msg_data_cursor *cursor,
>>                             char **pbuf)
>> @@ -5882,23 +5880,16 @@ static int osd_sparse_read(struct ceph_connection *con,
>>
>>                  if (count > 0) {
>>                          if (!sr->sr_extent || count > sr->sr_ext_len) {
>> -                               /*
>> -                                * Apply a hard cap to the number of extents.
>> -                                * If we have more, assume something is wrong.
>> -                                */
>> -                               if (count > MAX_EXTENTS) {
>> -                                       dout("%s: OSD returned 0x%x extents in a single reply!\n",
>> -                                            __func__, count);
>> -                                       return -EREMOTEIO;
>> -                               }
>> -
>>                                  /* no extent array provided, or too short */
>>                                  kfree(sr->sr_extent);
>>                                  sr->sr_extent = kmalloc_array(count,
>>                                                                sizeof(*sr->sr_extent),
>>                                                                GFP_NOIO);
>> -                               if (!sr->sr_extent)
>> +                               if (!sr->sr_extent) {
>> +                                       pr_err("%s: failed to allocate %u sparse read extents\n",
>> +                                              __func__, count);
> Hi Xiubo,
>
> No need to include the function name: a) this is an error message as
> opposed to a debug message and b) such allocation is done only in one
> place anyway.

Okay, will remove it.

Thanks

- Xiubo


> Otherwise LGTM!
>
> Thanks,
>
>                  Ilya
>



Return-Path: <ceph-devel+bounces-267-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BE33580A578
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 15:28:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E399B20CCD
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 14:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 579D21E495;
	Fri,  8 Dec 2023 14:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hAROLYFT"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D001723
	for <ceph-devel@vger.kernel.org>; Fri,  8 Dec 2023 06:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702045708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TSIhDM67hTU2b+eXZFeBA7EaaPFHMUX3BoW8IPqZ8hs=;
	b=hAROLYFTwHYDP5w/Q+uwpkBGd4AiH3B1nkqfnQ9sPZfIS5tQS1EDxxuKvdBzf+4ews2cXU
	PlsqFmpSeZM+siaXtlNx5Pa/14W0O7PaNxWDm3DpVLLGK1bPAjC6ATOlzDjM80oSGHi/LT
	+0FN8iY3c1aYziq6HP7HzJ2NC6/4ZEk=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-RRdqL62HPqWWC4Xk8INhKw-1; Fri, 08 Dec 2023 09:28:27 -0500
X-MC-Unique: RRdqL62HPqWWC4Xk8INhKw-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1d08383e566so17452975ad.2
        for <ceph-devel@vger.kernel.org>; Fri, 08 Dec 2023 06:28:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702045706; x=1702650506;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TSIhDM67hTU2b+eXZFeBA7EaaPFHMUX3BoW8IPqZ8hs=;
        b=ezYwRCjiFPQSwxlZ12jHeE0PjtbbT+26EAz7MlnCAwkkrH88cv32RkrjEn4KlQprag
         wjXu6zfnMMO0IK9xgi8AGZb2eCxAVnlTMrrQneiAKeRg3j82u3B5y3EgsbYaOWDotFjA
         kr0tWv6SWCrNc1AmWeakl1W+Dw3bmSxjWGNtKf7xIUYLrCMWia7dXTr3LPFbUgcDqcIL
         bk3+l3wirJjjL/70jyv7gjLi/j3bYFO20aZ+Zg/2WKjNt/vcaxVwBncEh0m8bG9jIoUD
         4np5tKOdKwYpn6cDHzch4IVYjdw6F4AgWbByqCpW7xW1vEYaJu1+zH6YgPBMXgtof3WJ
         cB4g==
X-Gm-Message-State: AOJu0Ywt3TNXKQnbt6yMzCZJ7sXskSDrx3p13J+MOjhWwj+cbM86Mxyr
	tM+AtHjej6iqLCbMOg4JnPKSSPAdcvc0onACZHUFT5pbA//5LkI2U2PYpmFCuS8b5EAljxIXWBN
	A/8y8VLSUv6WCfz0VuGfYjQ==
X-Received: by 2002:a17:902:c3d1:b0:1d0:d168:daae with SMTP id j17-20020a170902c3d100b001d0d168daaemr96669plj.95.1702045706037;
        Fri, 08 Dec 2023 06:28:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGithzDWvWC9NP4w6TJUzxOvD2VyVNewaLREenAk58S/OAkTBatLMfe/FDquK8pZKpj8UOGgw==
X-Received: by 2002:a17:902:c3d1:b0:1d0:d168:daae with SMTP id j17-20020a170902c3d100b001d0d168daaemr96659plj.95.1702045705752;
        Fri, 08 Dec 2023 06:28:25 -0800 (PST)
Received: from [10.72.112.27] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w18-20020a170902e89200b001d051725d09sm1754252plg.241.2023.12.08.06.28.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Dec 2023 06:28:25 -0800 (PST)
Message-ID: <029f3121-1236-4b4a-8200-e3fafa42c2f2@redhat.com>
Date: Fri, 8 Dec 2023 22:28:23 +0800
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
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP-aL0viMVHjXQr_CA0MyKNQ8FWH1qF4Vh-ntjFrOqYMNA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 12/8/23 19:31, Ilya Dryomov wrote:
> On Fri, Dec 8, 2023 at 5:34 AM <xiubli@redhat.com> wrote:
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
> Hi Xiubo,
>
> There is a patch in linux-next, also from you, which is conflicting
> with this one: cca19d307d35 ("libceph: check the data length when
> sparse read finishes").  Do you want it replaced?

Yeah, let me fold them.

Thanks Jeff and Ilya.


> Thanks,
>
>                  Ilya
>



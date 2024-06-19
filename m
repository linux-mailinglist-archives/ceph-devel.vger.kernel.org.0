Return-Path: <ceph-devel+bounces-1468-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 904ED90EC73
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Jun 2024 15:07:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 481BE1F2135D
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Jun 2024 13:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C82A21442F1;
	Wed, 19 Jun 2024 13:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GKaUu2lZ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC60F132129
	for <ceph-devel@vger.kernel.org>; Wed, 19 Jun 2024 13:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802456; cv=none; b=S2+hSS/1PqckNL8LnTAhQ/+aMTD8UcJHrjqtQGYqQXZl2nN9qnIq97Vzqlmg9MabZw0Mb211w8Ezoi4C4U6CCbdjut/QkZqpcVqSIID5UiEIpgQT8Pw2yxDrZxrir6d+CpR+EQ9iwt0DcpmW7sy916PHc339AQxH8rZZP2rBnkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802456; c=relaxed/simple;
	bh=oR/XJdTaTgMDCph292kkrVKOp3lr4chKtxfxQIPE684=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lUZY0jvOoP1MlsEdveOjjNPdGl5xjgVcK/a8Cf6329Jtw1JsP9drFzIexkI9QqWIPsRtjuXqCnWcE/6HKS4e2S8wNmdriTssL7BLc686TvIWTHlYcWsvoWtSYsZpJFMyIPhekcljgb+JOTEHobWo9eM8yLQ/Ds1g18Ba/AYE3yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GKaUu2lZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718802453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Az1ZS8aS7ItNBBUqMTEJ3GB50fsB7v5eFGmERZgF0O8=;
	b=GKaUu2lZkTlj51e7ZM/r6xareA6p7ygdrsa6yoJoSGyESgsnjEbD48E9PSDEO3yaOJax5o
	3+GfH3Y4TwDZ21GWKmMI6rfe2qm7J0D0eHOHZZVpXflI19mYIHpLEjfk7l8URMbGmN+6Jt
	YT4+85z43D3R/0Fg8BVEmYnwyar8vI0=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-FsSvKP5IOiORFfxFkUknDw-1; Wed, 19 Jun 2024 09:07:32 -0400
X-MC-Unique: FsSvKP5IOiORFfxFkUknDw-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1f9abbcf092so8760935ad.0
        for <ceph-devel@vger.kernel.org>; Wed, 19 Jun 2024 06:07:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718802451; x=1719407251;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Az1ZS8aS7ItNBBUqMTEJ3GB50fsB7v5eFGmERZgF0O8=;
        b=tLX56AzwHXfGcg1kY59I/yyLEp25J8PtkPu7AAxVTQxxWsJoksatfQXpDXoZaR8tEj
         L4iwQIG7n367X7aE06hhEGP6JxUKE75obEiwPpNx6le/VGYi29e3geI1lL/5L59SSCqh
         3sg1FIkfUXAlvTphmYrIboBLoxuno6+jTr2IwoiA0Svd7tGoU2f6NXl9ulFJJR6eLKI1
         y0Uo685QUk2mTcCr7CzdfDzMzhgacgn4VK417i+LliAtuXwcKJwH/lsl6E/rJGGeSCUJ
         RGV4D3W0xSjHZHxr/0wPp5+x8/V1VLaqqghqjoVgXxPvmbZRHN9Q3P3kN4YIpXU9L642
         50bA==
X-Gm-Message-State: AOJu0Yx/xWi4j8Ys/Ixl0mb5vxsrTAXW65G0KW8vpH13XCr/g/TUtb6h
	NIiY7BaMLZGSageeKdrf+eQCtwxUhz73V4NssoYTEHWwxR4b4f+jEvh04RIfQD8fyq3B8twuAzc
	eKJlK5zNwKp8dG+1gb63eYfhyVn5xhGpo1St2b7o0V2Cnn9zRcXPMekR2oRM=
X-Received: by 2002:a17:902:c94c:b0:1f4:ac10:3ede with SMTP id d9443c01a7336-1f9aa3dc9d8mr25554815ad.21.1718802451464;
        Wed, 19 Jun 2024 06:07:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHa3RMe0evPVas5/3g3pbVJ9ptWvHPlN2e0EsTt/pF0JeV2jS+ykarGG5PfaTlSG8fvOq3Udg==
X-Received: by 2002:a17:902:c94c:b0:1f4:ac10:3ede with SMTP id d9443c01a7336-1f9aa3dc9d8mr25554515ad.21.1718802451079;
        Wed, 19 Jun 2024 06:07:31 -0700 (PDT)
Received: from [10.72.116.38] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855efea73sm115502395ad.182.2024.06.19.06.07.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jun 2024 06:07:30 -0700 (PDT)
Message-ID: <d82dd1a8-e302-48fd-9d9f-632dc573a7a4@redhat.com>
Date: Wed, 19 Jun 2024 21:07:26 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ceph: avoid call to strlen() in ceph_mds_auth_match()
To: Luis Henriques <luis.henriques@linux.dev>,
 Dmitry Antipov <dmantipov@yandex.ru>
Cc: ceph-devel@vger.kernel.org
References: <20240618143640.169194-1-dmantipov@yandex.ru>
 <87bk3xglbl.fsf@brahms.olymp>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <87bk3xglbl.fsf@brahms.olymp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 6/19/24 20:37, Luis Henriques wrote:
> On Tue 18 Jun 2024 05:36:40 PM +03, Dmitry Antipov wrote;
>
>> Since 'snprintf()' returns the number of characters emitted,
>> an extra call to 'strlen()' in 'ceph_mds_auth_match()' may
>> be dropped. Compile tested only.
>>
>> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
>> ---
>>   fs/ceph/mds_client.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index c2157f6e0c69..7224283046a7 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -5665,9 +5665,9 @@ static int ceph_mds_auth_match(struct ceph_mds_client *mdsc,
>>   				if (!_tpath)
>>   					return -ENOMEM;
>>   				/* remove the leading '/' */
>> -				snprintf(_tpath, n, "%s/%s", spath + 1, tpath);
>> +				tlen = snprintf(_tpath, n, "%s/%s",
>> +						spath + 1, tpath);
>>   				free_tpath = true;
>> -				tlen = strlen(_tpath);
>>   			}
> Unless I'm missing something, this patch is incorrect.  snprintf() may not
> return the actual string length *if* the output is truncated.  For
> example:
>
> 	snprintf(str, 5, "%s", "0123456789");
>
> snprintf() will return 10, while strlen(str) will return 4.

Yeah, you are correct.

Thanks Luis.


> Cheers,



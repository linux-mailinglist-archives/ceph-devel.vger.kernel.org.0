Return-Path: <ceph-devel+bounces-22-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 57ECE7DC424
	for <lists+ceph-devel@lfdr.de>; Tue, 31 Oct 2023 03:05:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 738E3B20E60
	for <lists+ceph-devel@lfdr.de>; Tue, 31 Oct 2023 02:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A2E810F1;
	Tue, 31 Oct 2023 02:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="deosC4oJ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3444BECD
	for <ceph-devel@vger.kernel.org>; Tue, 31 Oct 2023 02:04:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96EFB3
	for <ceph-devel@vger.kernel.org>; Mon, 30 Oct 2023 19:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698717894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TDTiZeN9dVOEs6Ds1Q+BAVDOYNa9Jg7m9OeQgbY2LmA=;
	b=deosC4oJLkkMsQgqnAPpVxIMn+mW50S0t/ascUa6cHii4h+2gOnrJeLFvuZAfL2S3dR8Ln
	W9lZlfpkzhKUB2rbNx0sCfFaoXwY2I7m6l36dInAXm8/OrKou/UHTZ/VUeyjbmHok7tvU7
	nT+c9yLhRHRoINt4jpORARpZ1qa9ELI=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675--ahFmlkQMwefyvrj_s3cEQ-1; Mon, 30 Oct 2023 22:04:51 -0400
X-MC-Unique: -ahFmlkQMwefyvrj_s3cEQ-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1cc5ef7e815so7132545ad.3
        for <ceph-devel@vger.kernel.org>; Mon, 30 Oct 2023 19:04:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698717890; x=1699322690;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TDTiZeN9dVOEs6Ds1Q+BAVDOYNa9Jg7m9OeQgbY2LmA=;
        b=QUqTEeM1whxltC9zrvokwQe4EKFMlG03oD5taHQDy1T4fkYsakoHXCgVH77cEL44G5
         iFiW94EiOAIDzbON/ycl8HiZK+YthSZspOU3eggElpno63Z33PbzLzj/MXbkwdlZVoMA
         s57jH+jN72b8wMQoPQFp1Ps5WVME+gYT1fC0Lr94QtYtgZ40S4UxwbYIpvzfTcSz2UJ/
         BzfnUPB0ClK6o6AUdrqIWdDt6NvrPmxy/74iVlK3aaNtdf1wn5xOeHfJ3/JVmwXrnA8t
         McLSON6lEpbuxKxzG4SS1/56IvZTbcKYvyUDGVYmovwRf53nhsZmRgYWttcrA4J13O8c
         ckeA==
X-Gm-Message-State: AOJu0YxrJQZU5qSgXljdXE+ANkXn4CO9gtZZmtXKSYmGMx9wS1BuEGoA
	5AYvqyuvXdqMCGg7j+Rngdbz8N4t0+vOkp2uP/Bkzx8OoCRQDyX8eoWTpvZMueA5AmGKzNPpnQe
	eLuhgyNl5Sx3jhfRxUkLEJA==
X-Received: by 2002:a17:902:f690:b0:1cc:21f1:c05c with SMTP id l16-20020a170902f69000b001cc21f1c05cmr8005414plg.11.1698717890557;
        Mon, 30 Oct 2023 19:04:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1mGqTRD7c0DfpOwvQv0eTZoAc6toRk4253ulboqUExodJMxQDxsqsfjg/tk4LOag+KmMfxw==
X-Received: by 2002:a17:902:f690:b0:1cc:21f1:c05c with SMTP id l16-20020a170902f69000b001cc21f1c05cmr8005391plg.11.1698717890171;
        Mon, 30 Oct 2023 19:04:50 -0700 (PDT)
Received: from [10.72.112.59] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u8-20020a170902b28800b001c739768214sm161428plr.92.2023.10.30.19.04.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Oct 2023 19:04:49 -0700 (PDT)
Message-ID: <a333ae58-1133-1030-f4d2-007d6297fe55@redhat.com>
Date: Tue, 31 Oct 2023 10:04:44 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 1/3] libceph: do not decrease the data length more than
 once
Content-Language: en-US
To: Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com, vshankar@redhat.com, mchangir@redhat.com
References: <20231024050039.231143-1-xiubli@redhat.com>
 <20231024050039.231143-2-xiubli@redhat.com>
 <832919f25c9f923e5f908d18a3581375d02342ef.camel@kernel.org>
 <cc4eb9db0d65d324bb658ef4a40f6715653d75aa.camel@kernel.org>
 <5562bc72-679c-46e8-1d6c-f31782479649@redhat.com>
 <9ed3a4a7a481f1d40661a717d0f6110558b29f7f.camel@kernel.org>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <9ed3a4a7a481f1d40661a717d0f6110558b29f7f.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 10/31/23 08:23, Jeff Layton wrote:
> On Tue, 2023-10-31 at 08:17 +0800, Xiubo Li wrote:
>> On 10/30/23 20:30, Jeff Layton wrote:
>>> On Mon, 2023-10-30 at 06:21 -0400, Jeff Layton wrote:
>>>> On Tue, 2023-10-24 at 13:00 +0800, xiubli@redhat.com wrote:
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> No need to decrease the data length again if we need to read the
>>>>> left data.
>>>>>
>>>>> URL: https://tracker.ceph.com/issues/62081
>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>> ---
>>>>>    net/ceph/messenger_v2.c | 1 -
>>>>>    1 file changed, 1 deletion(-)
>>>>>
>>>>> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
>>>>> index d09a39ff2cf0..9e3f95d5e425 100644
>>>>> --- a/net/ceph/messenger_v2.c
>>>>> +++ b/net/ceph/messenger_v2.c
>>>>> @@ -1966,7 +1966,6 @@ static int prepare_sparse_read_cont(struct ceph_connection *con)
>>>>>    				bv.bv_offset = 0;
>>>>>    			}
>>>>>    			set_in_bvec(con, &bv);
>>>>> -			con->v2.data_len_remain -= bv.bv_len;
>>>>>    			return 0;
>>>>>    		}
>>>>>    	} else if (iov_iter_is_kvec(&con->v2.in_iter)) {
>>>> It's been a while since I was in this code, but where does this get
>>>> decremented if you're removing it here?
>>>>
>>> My question was a bit vague, so let me elaborate a bit:
>>>
>>> data_len_remain should be how much unconsumed data is in the message
>>> (IIRC). As we call prepare_sparse_read_cont multiple times, we're
>>> consuming the message data and this gets decremented as we go.
>>>
>>> In the above case, we're consuming the message data into the bvec, so
>>> why shouldn't we be decrementing the remaining data by that amount?
>> Hi Jeff,
>>
>> If I didn't miss something about this. IMO we have already decreased it
>> in the following two cases:
>>
>> [1]
>> https://github.com/ceph/ceph-client/blob/for-linus/net/ceph/messenger_v2.c#L2000
>>
>> [2]
>> https://github.com/ceph/ceph-client/blob/for-linus/net/ceph/messenger_v2.c#L2025
>>
>> And here won't we decrease them twice ?
>>
>>
> I don't get it. The functions returns in both of those cases just after
> decrementing data_len_remain, so how can it have already decremented it?
>
> Maybe I don't understand the bug you're trying to fix. data_len_remain
> only comes into play when we need to revert. Does the problem involve a
> trip through revoke_at_prepare_sparse_data()?

Such as for the first time to read the data it will trigger:

prepare_sparse_read_cont()

   --> ret = con->ops->sparse_read()

        --> cursor->sr_resid = elen;

   --> if (buf) {con->v2.data_len_remain -= ret;}   // After calling 
->sparse_read() it will decrease 'ret', which is 'elen'.

Then the msg will try to read data from the socket buffer, and if the 
data read is less than expected 'elen' then it will go to the code:

https://github.com/ceph/ceph-client/blob/for-linus/net/ceph/messenger_v2.c#L1960-L1971

And then won't it decrease 'data_len_remain' twice ?

Did I misreading it the sparse read state machine ?

Thanks

- Xiubo




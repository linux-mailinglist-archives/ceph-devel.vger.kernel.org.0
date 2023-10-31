Return-Path: <ceph-devel+bounces-20-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74CD17DC379
	for <lists+ceph-devel@lfdr.de>; Tue, 31 Oct 2023 01:17:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 957701C20B50
	for <lists+ceph-devel@lfdr.de>; Tue, 31 Oct 2023 00:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C2DA365;
	Tue, 31 Oct 2023 00:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GslTuGtH"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A6E360
	for <ceph-devel@vger.kernel.org>; Tue, 31 Oct 2023 00:17:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60949A6
	for <ceph-devel@vger.kernel.org>; Mon, 30 Oct 2023 17:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698711430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wBJZ2fuSIQGF627jNu2zSdLuBFlmtJie0cvBwQRMLJM=;
	b=GslTuGtHAlZrCQ4/bw5S9sWh7Sxoep+O+iK3CC+Dz/ew0bsfjmClAupsb55aQbxaLG27Uu
	tE3qanV59pJO16famGu+c5vVmrMOgyc6VfKgXs/QOWwAo1bREAs5eIIKZhenHJwqHjcKaZ
	jgaDsy1Mprx6nmrfglcdXJyj9oOvSjU=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-295-p9LIlgVINGyXpdfQ_m1UFw-1; Mon, 30 Oct 2023 20:17:08 -0400
X-MC-Unique: p9LIlgVINGyXpdfQ_m1UFw-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5b7bf88d712so2737145a12.1
        for <ceph-devel@vger.kernel.org>; Mon, 30 Oct 2023 17:17:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698711427; x=1699316227;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wBJZ2fuSIQGF627jNu2zSdLuBFlmtJie0cvBwQRMLJM=;
        b=FG8xJLikdNOYgO+urgNqt+sPGq6hIDgKx7Yt0xMHU90gy9JRPIuOMp9YjmzekocZM8
         bW5a9+V2NFN1xGrmJMEbzcs5mUZJKqOz0/drO+c5r2q4cxOSrVUp+bffZa95UwiHQomU
         zdFCn0ElKRvCLBdGFLH5rMidECYcUjGPEyplJOX+/lhdLqXI/4/OOQJ3riSC9Fn7Di/L
         we1ffo0hkk5eiOmPWcK199KrwrTmPHPoQD0yscIHIz0SWb+ygOlzmnDFKvAWZPbWA2MV
         p/ZgJGS0KyYbqctHjy1eskBSFQlR6ZnTrNUeyesnGR0KtFVcCejjKUN7dqX1bxWNlijX
         GsNg==
X-Gm-Message-State: AOJu0Ywoi8PTcJXq8MPcYFt/7OGiFz/B36tZtjxLmPE+58HAsITVqsM/
	6wUknMaftUFV6XDyDLylCYpnOG9enYj9Zrzzw/faN6+STvzz2sn2LpjIxiVRTlBNRvAQ4FJJVzD
	EKjLF3pUR4XTOjznz2GqioA==
X-Received: by 2002:a05:6a20:7485:b0:133:1d62:dcbd with SMTP id p5-20020a056a20748500b001331d62dcbdmr1107568pzd.28.1698711427524;
        Mon, 30 Oct 2023 17:17:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOxL0IVl7qFGvomgCmRvaCEeaT0xjhupUVQrzImUcG7oCgmt6umYvFTlCpTralPCfwM5sZGw==
X-Received: by 2002:a05:6a20:7485:b0:133:1d62:dcbd with SMTP id p5-20020a056a20748500b001331d62dcbdmr1107556pzd.28.1698711427174;
        Mon, 30 Oct 2023 17:17:07 -0700 (PDT)
Received: from [10.72.112.59] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z1-20020a63b041000000b0058901200bbbsm96315pgo.40.2023.10.30.17.17.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Oct 2023 17:17:06 -0700 (PDT)
Message-ID: <5562bc72-679c-46e8-1d6c-f31782479649@redhat.com>
Date: Tue, 31 Oct 2023 08:17:02 +0800
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
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <cc4eb9db0d65d324bb658ef4a40f6715653d75aa.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/30/23 20:30, Jeff Layton wrote:
> On Mon, 2023-10-30 at 06:21 -0400, Jeff Layton wrote:
>> On Tue, 2023-10-24 at 13:00 +0800, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> No need to decrease the data length again if we need to read the
>>> left data.
>>>
>>> URL: https://tracker.ceph.com/issues/62081
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   net/ceph/messenger_v2.c | 1 -
>>>   1 file changed, 1 deletion(-)
>>>
>>> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
>>> index d09a39ff2cf0..9e3f95d5e425 100644
>>> --- a/net/ceph/messenger_v2.c
>>> +++ b/net/ceph/messenger_v2.c
>>> @@ -1966,7 +1966,6 @@ static int prepare_sparse_read_cont(struct ceph_connection *con)
>>>   				bv.bv_offset = 0;
>>>   			}
>>>   			set_in_bvec(con, &bv);
>>> -			con->v2.data_len_remain -= bv.bv_len;
>>>   			return 0;
>>>   		}
>>>   	} else if (iov_iter_is_kvec(&con->v2.in_iter)) {
>> It's been a while since I was in this code, but where does this get
>> decremented if you're removing it here?
>>
> My question was a bit vague, so let me elaborate a bit:
>
> data_len_remain should be how much unconsumed data is in the message
> (IIRC). As we call prepare_sparse_read_cont multiple times, we're
> consuming the message data and this gets decremented as we go.
>
> In the above case, we're consuming the message data into the bvec, so
> why shouldn't we be decrementing the remaining data by that amount?

Hi Jeff,

If I didn't miss something about this. IMO we have already decreased it 
in the following two cases:

[1] 
https://github.com/ceph/ceph-client/blob/for-linus/net/ceph/messenger_v2.c#L2000

[2] 
https://github.com/ceph/ceph-client/blob/for-linus/net/ceph/messenger_v2.c#L2025

And here won't we decrease them twice ?

Thanks

- Xiubo






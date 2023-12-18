Return-Path: <ceph-devel+bounces-359-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55E948163FF
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Dec 2023 02:23:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DB062823EF
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Dec 2023 01:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C011FC4;
	Mon, 18 Dec 2023 01:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EqwFvoUV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ACB1FA3
	for <ceph-devel@vger.kernel.org>; Mon, 18 Dec 2023 01:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702862603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RLK+Ub7NIaJUsoBRC6Y4ipKjl/Ovie111A+W/hbv+Hw=;
	b=EqwFvoUVhjQW5NmIE57Xp0meGMGno0ErcXmiKCI1437SkNW/Edz3sSzqiyekfHxxPGnl5a
	4KrvtjyUCvmlAI2NvXUNj7HrIB8rExzGiI0AiFz66Z11c9dVpiQNTZKAbC1MHsJeXvAlen
	oDjVr7ZuIzCXotkMkCEiHQvnCwXhp5I=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-330-Ots11gXWPlCIReuo-9kEbw-1; Sun, 17 Dec 2023 20:23:21 -0500
X-MC-Unique: Ots11gXWPlCIReuo-9kEbw-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5c6bd30ee89so2772490a12.0
        for <ceph-devel@vger.kernel.org>; Sun, 17 Dec 2023 17:23:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702862600; x=1703467400;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RLK+Ub7NIaJUsoBRC6Y4ipKjl/Ovie111A+W/hbv+Hw=;
        b=o3wQqQSmhcXYsgZDUoylqWhh5svA+FkHzaNEGkURm9eK5w+Czun0+nfOOs2cVOUDDy
         9cBtFO9T8I7WgQhhlPmQlay4/KeSGJqtZ64MNvYGsl8VsApVXmVpdylmiLZ6LxndqaAr
         s8RkLncMKxJlspp3TAi1hTdvcOl8PmU93KOFhZlQ1wsne3PWoZmmdM3w2am3aLf8FCrq
         Q5KJcvqwkSnZlrha+bdl6GM1VmPXmjRZO1R3broih2SF4mgd1pHFfk65xxo9u0diBITn
         vK8N/SZ57F5mSfmOwOLSEEY1Z2O0EzpyEIk/32lIKTvwABU3530BVpz2FoQ69+wbG3eo
         iDXA==
X-Gm-Message-State: AOJu0YytuugyJHbX+QX3pHVYNy9xa5G1mixyLh6hEtiF9k3Kq/EmBVRF
	vLe/FU+DJhJLty8aOeEVg2UB9Lv5URt+jQLkcM2YNwNwb9P1LcD5vruvQqiUT3nR5ge9NV6yaLa
	4duJK9ydE9Uzc4IgGNpN6SQ==
X-Received: by 2002:a05:6a21:18b:b0:194:6838:69b9 with SMTP id le11-20020a056a21018b00b00194683869b9mr567369pzb.93.1702862600386;
        Sun, 17 Dec 2023 17:23:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFhD6Ycub3KPWds3rHByNP4IsCr/uoFxFKHeRExTa7ZnbHrYNKqTF5jgRFEPe4Ck1302Yij0w==
X-Received: by 2002:a05:6a21:18b:b0:194:6838:69b9 with SMTP id le11-20020a056a21018b00b00194683869b9mr567355pzb.93.1702862600053;
        Sun, 17 Dec 2023 17:23:20 -0800 (PST)
Received: from [10.72.113.27] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x1-20020a636301000000b005cd80a2e63csm2696081pgb.67.2023.12.17.17.23.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Dec 2023 17:23:19 -0800 (PST)
Message-ID: <2d23c041-c329-422c-bb6b-98b6dc4813b7@redhat.com>
Date: Mon, 18 Dec 2023 09:23:13 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] libceph: fail the sparse-read if there still has
 data in socket
Content-Language: en-US
To: Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com, vshankar@redhat.com, mchangir@redhat.com
References: <20231215002034.205780-1-xiubli@redhat.com>
 <20231215002034.205780-2-xiubli@redhat.com>
 <9f7d560bdc3eb80dd03b1fe500a78da0959cab0b.camel@kernel.org>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <9f7d560bdc3eb80dd03b1fe500a78da0959cab0b.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 12/16/23 01:06, Jeff Layton wrote:
> On Fri, 2023-12-15 at 08:20 +0800, xiubli@redhat.com wrote:
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
>>   		fallthrough;
>>   	case CEPH_SPARSE_READ_DATA:
>>   		if (sr->sr_index >= count) {
>> -			if (sr->sr_datalen && count)
>> +			if (sr->sr_datalen) {
>>   				pr_warn_ratelimited("sr_datalen %u sr_index %d count %u\n",
>>   						    sr->sr_datalen, sr->sr_index,
>>   						    count);
>> +				return -EREMOTEIO;
>> +			}
>>   
>>   			sr->sr_state = CEPH_SPARSE_READ_HDR;
>>   			goto next_op;
> Do you really need to fail the read in this case? Would it not be better
> to just advance past the extra junk? Or is this problem more indicative
> of a malformed frame?
>
> It'd be nice to have some specific explanation of the problem this is
> fixing and how it was triggered. If this due to a misbehaving server?
> Bad hw?

Hi Jeff,

Why I added this check before was that when I was debugging the 
sparse-read issue last time I found even when the extent array 'count == 
0', sometimes the 'sr_datalen != 0'. I just thought the ceph side's 
logic allowed it.

But this time from going through and debugging more in the ceph side 
code, I didn't get where was doing this. So I just suspected it should 
be an issue somewhere in kclient side and it also possibly would trigger 
the sparse-read bug.  So I just removed the 'count' check and finally 
found the root case for both these two issues.

IMO normally this shouldn't happen anyway. Once this happens in kclient 
side it will 100% corrupt the following msgs and reset the connection 
from my tests. Actually when the 'count ==0' the 'sr_datalen' will be a 
random number, sometimes very large, so just advancing past the extra 
junk makes no any sense.

Thanks

- Xiubo




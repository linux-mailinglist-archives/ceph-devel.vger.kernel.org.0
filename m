Return-Path: <ceph-devel+bounces-591-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97AC7832401
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Jan 2024 05:09:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 276551F2392C
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Jan 2024 04:09:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2F703D60;
	Fri, 19 Jan 2024 04:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DPjgXl1r"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0813C35
	for <ceph-devel@vger.kernel.org>; Fri, 19 Jan 2024 04:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705637277; cv=none; b=AkP+uMHhWHPwezrgQK05zlP3EVLOP8NH/AXuEoqasg2+H6xp53Ftj/hg1ermrE/YYGUJ9EU+dioCHtqLgFUB0INRHhYm+zwcbGx2zdpC/SUL1JD+kFJWek3zV2sw05s7jH3itpDOfRVGEqm+hP/3Pp7nflCtRBY+L4oMZtfWi8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705637277; c=relaxed/simple;
	bh=LRaC0a9ab4hkzhN3mXdTCtF1rWp100Y/SHb7F7OzXpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EzNCTOUMxKA7l/h+fKhgQ02wkXE0zAnr7kD24+4/mpjcgDg52a37mZmIv4p6w5qW54QMaBHghWIXqYzO9BD0XRfJ+ba7Sd6466e9fDGdTOdd+0cRihZ91OEYrFDD1trPB96eJBBqUkoHnLprgTG65gOWTYPxWcblP8zOLqXc8mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DPjgXl1r; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705637274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=anPiXr3Kez8QzqWP38D7n2W+2+sEPaZD/hZWdhsH6zw=;
	b=DPjgXl1rsOhVOOAI98CMTQL4biBUTrkbxeVFaTyxNtuvUZS4esdSn8idimTkJzpje55Nel
	HfaFCX2fvLKh6H+lSOWHJdu4GwM5KXLVfjo4ENNM+TKDzyr7FfqiZapZvpQpOnVhSQdKWn
	pKoMRtjPoAmMsuZvOQWyPq/5iT/nekA=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-0HOaRl4OO_69emfidessvw-1; Thu, 18 Jan 2024 23:07:47 -0500
X-MC-Unique: 0HOaRl4OO_69emfidessvw-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-29041401e70so363422a91.1
        for <ceph-devel@vger.kernel.org>; Thu, 18 Jan 2024 20:07:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705637267; x=1706242067;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=anPiXr3Kez8QzqWP38D7n2W+2+sEPaZD/hZWdhsH6zw=;
        b=fKFhWAyjLa0uHafpH6p1tGR8Wm5rq0ph4QAPXj9YVInbxdLGo36ofFaWsecOcT3CJC
         y+yVd7aFwN3vTxRcsS5KnAX1g8SN7IZR3xNYmDZoO7fw1KM63SRbM8mLq83Kx8HJZVsO
         ag6frkG9Tmn55oiu7VxBy16vh13Nu0uPfdBBhSW2rl6CkwE1QAJEVUREvZYy/6OvpRXc
         elTOsuhte8ABC9Rl9262o67RxCkJpbp6Pekrim9+GMAwAoawV4WRluXFyZRsIuWj6Net
         Aw2lMiH64crcXpANIIw4w7fEV97l57BJXbn1mlDq/0iiszB1hwYa3UnVjeoiJvQjWCis
         i1/A==
X-Gm-Message-State: AOJu0Yx6Ohj1d3oDEMkHKP8FBdvZsu72exNQxaBz/S89r2/aArOP++na
	+HxKWQRB/oRbxYw6nbXZKChZBswZgSuNXB7cPkJEI7wfwiFhHUOrkmqK3Sg87YFuOB3adCobI7w
	zJogtcYtiiljbUtOwyBz+MOrj4JJw99WAgMZr08J263egYvTjDNJvMMnqymo=
X-Received: by 2002:a17:90a:4d8e:b0:28b:8e2d:4131 with SMTP id m14-20020a17090a4d8e00b0028b8e2d4131mr1454568pjh.31.1705637266781;
        Thu, 18 Jan 2024 20:07:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFVqw2yXtED/+T4b20HL0S+tjeeEbKBiZFZNH7HM0gF0JhHOYs0D38hhh5GzQcjr3kTj5C+/w==
X-Received: by 2002:a17:90a:4d8e:b0:28b:8e2d:4131 with SMTP id m14-20020a17090a4d8e00b0028b8e2d4131mr1454563pjh.31.1705637266134;
        Thu, 18 Jan 2024 20:07:46 -0800 (PST)
Received: from [10.72.112.62] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t2-20020a170902bc4200b001d5a57054d8sm2073507plz.104.2024.01.18.20.07.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 20:07:45 -0800 (PST)
Message-ID: <bd81112b-bdbd-466a-943e-90742c100c47@redhat.com>
Date: Fri, 19 Jan 2024 12:07:42 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] libceph: fail the sparse-read if there still has
 data in socket
Content-Language: en-US
To: Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com, vshankar@redhat.com, mchangir@redhat.com
References: <20240118105047.792879-1-xiubli@redhat.com>
 <20240118105047.792879-2-xiubli@redhat.com>
 <cca21aec6fa2a1728cb85099e1ba750bdf2fd696.camel@kernel.org>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <cca21aec6fa2a1728cb85099e1ba750bdf2fd696.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 1/18/24 22:03, Jeff Layton wrote:
> On Thu, 2024-01-18 at 18:50 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Once this happens that means there have bugs.
>>
>> URL: https://tracker.ceph.com/issues/63586
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   net/ceph/osd_client.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index 9be80d01c1dc..f8029b30a3fb 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -5912,6 +5912,13 @@ static int osd_sparse_read(struct ceph_connection *con,
>>   		fallthrough;
>>   	case CEPH_SPARSE_READ_DATA:
>>   		if (sr->sr_index >= count) {
>> +			if (sr->sr_datalen) {
>> +				pr_warn_ratelimited("sr_datalen %u sr_index %d count %u\n",
>> +						    sr->sr_datalen, sr->sr_index,
>> +						    count);
>> +				return -EREMOTEIO;
>> +			}
>> +
> Ok, so the server has (presumably) sent us a longer value for the
> sr_datalen than was in the extent map?
>
> Why should the sparse read engine care about that? It was (presumably)
> able to do its job of handling the read. Why not just advance past the
> extra junk and try to do another sparse read? Do we really need to fail
> the op for this?

Hi Jeff,

I saw the problem just when I first debugging the sparse-read bug, and 
the length will be very large, more detail and the logs please see the 
tracker https://tracker.ceph.com/issues/63586:

      11741055 <4>[180940.606488] libceph: sr_datalen 251723776 sr_index 
0 count 0

In this case the request could cause the same request being retrying 
infinitely. While just in other case the when the ceph send a incorrect 
data length, how should we do ? Should we retry it ? How could we skip 
it if the length is so large ?

Thanks

- Xiubo


>
>>   			sr->sr_state = CEPH_SPARSE_READ_HDR;
>>   			goto next_op;
>>   		}
>> @@ -5919,6 +5926,8 @@ static int osd_sparse_read(struct ceph_connection *con,
>>   		eoff = sr->sr_extent[sr->sr_index].off;
>>   		elen = sr->sr_extent[sr->sr_index].len;
>>   
>> +		sr->sr_datalen -= elen;
>> +
>>   		dout("[%d] ext %d off 0x%llx len 0x%llx\n",
>>   		     o->o_osd, sr->sr_index, eoff, elen);
>>   



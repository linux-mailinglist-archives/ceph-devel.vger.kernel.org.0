Return-Path: <ceph-devel+bounces-598-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CABA28359B3
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 04:18:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E3E01F23324
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 03:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E23415C9;
	Mon, 22 Jan 2024 03:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WcHL/E+s"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5414D4A28
	for <ceph-devel@vger.kernel.org>; Mon, 22 Jan 2024 03:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705893474; cv=none; b=uwNQiKNACUz8BMq1OsvEI56NutSFXZSkuuUsYLoLfZGeM7j0VyfoTKPevOTtxhFKVm0qMC/VUM21lyOYvY32lU3ERY5qHqPt0zKv0jlGathmQ7WLpux7UmwesOMx2JZyV3CQ02Fd+PlCxJjnfHJW0wyZ3pdSKmldq7vZ17DD2QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705893474; c=relaxed/simple;
	bh=qBnu5AgUaM1HqtPynST+HEPPWs22p4Qz0xAhReFtq8s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IAftfT/1wPA6Cy1vDmBN8gXeavZ0SHNumGseUD6MTPEHYS7yth14FSkKBCGtDlmJEi94qJKicsJL8gVmbEjzXMzwwELTpcgoV5hSbILh+y4AFl4DZ4K25mYYGmTd+SFviLeC5LW058HbUgGm0jHVteyrxHwb4dMkMGH2+3UBSYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WcHL/E+s; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705893471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FtrFEp7Vzpv9Szo5ozvxUy2yRpOhIeFVJ0UMzafIo2Q=;
	b=WcHL/E+suWvdVf8AK+wLlcZafFZpq2JbhPffhsX9P00l2ocfFQBX4ySmRWWLkQAsC+Pt4u
	uqzelia4jzo7LFwB2jJNur1hSZ9I8UxSjaprNOLmDnAziRdSv3+JE342djM0MG6o7dxLbu
	FXehZTZKUIXxxBzZ5TKHt5xcxkaHS5s=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-tW4lONmHMd-n5ObPJX2XHg-1; Sun, 21 Jan 2024 22:17:50 -0500
X-MC-Unique: tW4lONmHMd-n5ObPJX2XHg-1
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-dc2358dce6bso2789988276.3
        for <ceph-devel@vger.kernel.org>; Sun, 21 Jan 2024 19:17:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705893469; x=1706498269;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FtrFEp7Vzpv9Szo5ozvxUy2yRpOhIeFVJ0UMzafIo2Q=;
        b=pu/UDQ9w3dbiymvN+MomGdLOYKjVjpcoY7TXbHma84w3jD+2emN06Gmbj1k/MF+nQc
         LAE8x52htIg7uXRohEi80SJkH6UjFdz8j2RzHtYScVPbyhbdyT7yEUQ9WPjMyQPjNkZg
         L6ymBrDFikscgCl5lg5NE73yAs3asl8uKsD4UdEi2g3YGNL6b7w5xl514hZImckP9BeE
         cCNM8/kgvDoplLZ0h1w/D56qpxjuxjGLWl2g/dqI89nDuVU5ac5WT3TjLWJooPmrKApz
         LHCUr5cNoAjoDfRy0CbL2br0EhbjrtUKWQHkzd+GY44sQ2YgU7/Ji3TzZKZ1VJoah37b
         YRnQ==
X-Gm-Message-State: AOJu0YzkWBnSMmwVZhr6Pig/MACmVc+IP/hBClpHZIQ7266HyLow6HKo
	DcIUrx8E8nbz4cdwbYiw7vpzpYEkQbCqZgTWOyleaAkIcC9TtaSJATHY2ux207rN/pD8Jz/9aok
	O53OoZ94E5TLg2cDifYithERCGXP/j39dF/eOlgSSgUmOrcVt45paFdmylKE=
X-Received: by 2002:a25:a28b:0:b0:dbf:1152:cabc with SMTP id c11-20020a25a28b000000b00dbf1152cabcmr1464794ybi.25.1705893469664;
        Sun, 21 Jan 2024 19:17:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF8hPwShnsvnbSdLUCgyFgn3Y7MIFpihEVtudThDsVHpPKL3dr6E2b3BXokzBbK81+H1+FPcQ==
X-Received: by 2002:a25:a28b:0:b0:dbf:1152:cabc with SMTP id c11-20020a25a28b000000b00dbf1152cabcmr1464789ybi.25.1705893469384;
        Sun, 21 Jan 2024 19:17:49 -0800 (PST)
Received: from [10.72.112.62] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id r6-20020a25ac46000000b00dc2246159f3sm1367053ybd.1.2024.01.21.19.17.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jan 2024 19:17:49 -0800 (PST)
Message-ID: <4d5b2bfe-47b2-4003-a8e7-ebc71bbf33ec@redhat.com>
Date: Mon, 22 Jan 2024 11:17:43 +0800
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
 <bd81112b-bdbd-466a-943e-90742c100c47@redhat.com>
 <6f1e6ba6f0f5ca1b613aa0372c109289193170ee.camel@kernel.org>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <6f1e6ba6f0f5ca1b613aa0372c109289193170ee.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 1/19/24 19:03, Jeff Layton wrote:
> On Fri, 2024-01-19 at 12:07 +0800, Xiubo Li wrote:
>> On 1/18/24 22:03, Jeff Layton wrote:
>>> On Thu, 2024-01-18 at 18:50 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> Once this happens that means there have bugs.
>>>>
>>>> URL: https://tracker.ceph.com/issues/63586
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    net/ceph/osd_client.c | 9 +++++++++
>>>>    1 file changed, 9 insertions(+)
>>>>
>>>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>>>> index 9be80d01c1dc..f8029b30a3fb 100644
>>>> --- a/net/ceph/osd_client.c
>>>> +++ b/net/ceph/osd_client.c
>>>> @@ -5912,6 +5912,13 @@ static int osd_sparse_read(struct ceph_connection *con,
>>>>    		fallthrough;
>>>>    	case CEPH_SPARSE_READ_DATA:
>>>>    		if (sr->sr_index >= count) {
>>>> +			if (sr->sr_datalen) {
>>>> +				pr_warn_ratelimited("sr_datalen %u sr_index %d count %u\n",
>>>> +						    sr->sr_datalen, sr->sr_index,
>>>> +						    count);
>>>> +				return -EREMOTEIO;
>>>> +			}
>>>> +
>>> Ok, so the server has (presumably) sent us a longer value for the
>>> sr_datalen than was in the extent map?
>>>
>>> Why should the sparse read engine care about that? It was (presumably)
>>> able to do its job of handling the read. Why not just advance past the
>>> extra junk and try to do another sparse read? Do we really need to fail
>>> the op for this?
>> Hi Jeff,
>>
>> I saw the problem just when I first debugging the sparse-read bug, and
>> the length will be very large, more detail and the logs please see the
>> tracker https://tracker.ceph.com/issues/63586:
>>
>>        11741055 <4>[180940.606488] libceph: sr_datalen 251723776 sr_index
>> 0 count 0
>>
>> In this case the request could cause the same request being retrying
>> infinitely. While just in other case the when the ceph send a incorrect
>> data length, how should we do ? Should we retry it ? How could we skip
>> it if the length is so large ?
>>
>>
> If the sparse_read datalen is so long that it goes beyond the length of
> the entire frame, then it's clearly malformed and we have to reject it.
>
> I do wonder though whether this is the right place to do that. It seems
> like the client ought to do that sort of vetting of lengths before it
> starts dealing with the read data.
>
> IOW, maybe there should be a simple check in the
> CEPH_SPARSE_READ_DATA_LEN case that validates that the sr_datalen fits
> inside the "data_len" of the entire frame?

Well it should be in CEPH_SPARSE_READ_DATA_PRE instead.

I can improve this.

Thanks

- Xiubo

>>
>>>>    			sr->sr_state = CEPH_SPARSE_READ_HDR;
>>>>    			goto next_op;
>>>>    		}
>>>> @@ -5919,6 +5926,8 @@ static int osd_sparse_read(struct ceph_connection *con,
>>>>    		eoff = sr->sr_extent[sr->sr_index].off;
>>>>    		elen = sr->sr_extent[sr->sr_index].len;
>>>>    
>>>> +		sr->sr_datalen -= elen;
>>>> +
>>>>    		dout("[%d] ext %d off 0x%llx len 0x%llx\n",
>>>>    		     o->o_osd, sr->sr_index, eoff, elen);
>>>>    



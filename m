Return-Path: <ceph-devel+bounces-277-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DED5F810724
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Dec 2023 02:02:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AB37281AA7
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Dec 2023 01:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB8AA53;
	Wed, 13 Dec 2023 01:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c4wAH6sv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFB2A0
	for <ceph-devel@vger.kernel.org>; Tue, 12 Dec 2023 17:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702429322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BL5uDHmInEYQ9pfGhyjYyI2Y62+IqvU9y4w0gqmIIZk=;
	b=c4wAH6svUCKqfWy5ozWD8yTpGuH2/x0yk5R1qJdwYyUgJFo0FiFHX66XpjZpEYd2H5G9LR
	aBc0hPNZsiL+qEpGa16afkDWxWCzNsWqZZramwFLoINGyk7ffi91eX/sHCDP+8RgpdYpke
	cznKSGdHxnnmh5YT+1DRo4i79BJARZE=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-p8_mRxsaMSeUuKs2xrxgwQ-1; Tue, 12 Dec 2023 20:02:00 -0500
X-MC-Unique: p8_mRxsaMSeUuKs2xrxgwQ-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1d0704bdd5bso36712575ad.0
        for <ceph-devel@vger.kernel.org>; Tue, 12 Dec 2023 17:02:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702429319; x=1703034119;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BL5uDHmInEYQ9pfGhyjYyI2Y62+IqvU9y4w0gqmIIZk=;
        b=TqODrk9OsnbZJ5+bdzhqHSCK5DKkV/YpIXMTrzUJy/Ks8WH3rAx62v5pvLw6J079N5
         89R3UZ38f+Dk7S/BnbxOs35QvFeZ2R0YBaWBeqCaaq41IWhJR/m3Jgkthk2XYRvw6GQr
         mozvKX2SPw0c5tXdqZTTZvrBF+BggPvhWfYPGeoJravOpDS8PSE3kUvp/A8q/0tJjChW
         Elpw7JGRHpF646b4MDFwWXFLhkuPzowTZpQIYfp07sfPGMNPMSt1LxdabPl2VciLz2ia
         LrogNz4UdjZBv5HycvMseifNXomhXzjKXK8dNDqF0/tFpyhkvPOHXoko0zYyfVup8717
         q+qQ==
X-Gm-Message-State: AOJu0YxAsss+kHy+Qyxgw6W1AaDCkjPBRr3cWPyDeQegmbWcxX5AHncx
	W4NXjnA2OxsICtxQp5XDK1HbL163gsOrZzdBjIkthHK3BG9C9h05Rg8hM05Br2f2pYSlmPPc8SL
	tlkdusqGAoYeDMdViPVgSYw==
X-Received: by 2002:a05:6a20:549a:b0:18f:97c:9279 with SMTP id i26-20020a056a20549a00b0018f097c9279mr4191445pzk.94.1702429319579;
        Tue, 12 Dec 2023 17:01:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IECEERRLEGj7OrWfWHIn+BGTfP9+a8JWX09PN1ilGxUoxSBOsovsqTyqV6in7mJXy89QfIv8A==
X-Received: by 2002:a05:6a20:549a:b0:18f:97c:9279 with SMTP id i26-20020a056a20549a00b0018f097c9279mr4191439pzk.94.1702429319267;
        Tue, 12 Dec 2023 17:01:59 -0800 (PST)
Received: from [10.72.113.27] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h8-20020a170902680800b001c736b0037fsm9455668plk.231.2023.12.12.17.01.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Dec 2023 17:01:58 -0800 (PST)
Message-ID: <af3d24bc-0a4f-4e30-ba3d-80d41a7fd94c@redhat.com>
Date: Wed, 13 Dec 2023 09:01:54 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] libceph: just wait for more data to be available
 on the socket
Content-Language: en-US
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com,
 mchangir@redhat.com
References: <20231208160601.124892-1-xiubli@redhat.com>
 <20231208160601.124892-3-xiubli@redhat.com>
 <CAOi1vP8ft0nFh2qdQDRpGr7gPCj3HHDzY4Q7i69WQLiASPxNyw@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP8ft0nFh2qdQDRpGr7gPCj3HHDzY4Q7i69WQLiASPxNyw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 12/13/23 00:31, Ilya Dryomov wrote:
> On Fri, Dec 8, 2023 at 5:08 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The messages from ceph maybe split into multiple socket packages
>> and we just need to wait for all the data to be availiable on the
>> sokcet.
>>
>> This will add a new _FINISH state for the sparse-read to mark the
>> current sparse-read succeeded. Else it will treat it as a new
>> sparse-read when the socket receives the last piece of the osd
>> request reply message, and the cancel_request() later will help
>> init the sparse-read context.
>>
>> URL: https://tracker.ceph.com/issues/63586
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   include/linux/ceph/osd_client.h | 1 +
>>   net/ceph/osd_client.c           | 6 +++---
>>   2 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
>> index 493de3496cd3..00d98e13100f 100644
>> --- a/include/linux/ceph/osd_client.h
>> +++ b/include/linux/ceph/osd_client.h
>> @@ -47,6 +47,7 @@ enum ceph_sparse_read_state {
>>          CEPH_SPARSE_READ_DATA_LEN,
>>          CEPH_SPARSE_READ_DATA_PRE,
>>          CEPH_SPARSE_READ_DATA,
>> +       CEPH_SPARSE_READ_FINISH,
>>   };
>>
>>   /*
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index 848ef19055a0..f1705b4f19eb 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -5802,8 +5802,6 @@ static int prep_next_sparse_read(struct ceph_connection *con,
>>                          advance_cursor(cursor, sr->sr_req_len - end, false);
>>          }
>>
>> -       ceph_init_sparse_read(sr);
>> -
>>          /* find next op in this request (if any) */
>>          while (++o->o_sparse_op_idx < req->r_num_ops) {
>>                  op = &req->r_ops[o->o_sparse_op_idx];
>> @@ -5919,7 +5917,7 @@ static int osd_sparse_read(struct ceph_connection *con,
>>                                  return -EREMOTEIO;
>>                          }
>>
>> -                       sr->sr_state = CEPH_SPARSE_READ_HDR;
>> +                       sr->sr_state = CEPH_SPARSE_READ_FINISH;
>>                          goto next_op;
> Hi Xiubo,
>
> This code appears to be set up to handle multiple (sparse-read) ops in
> a single OSD request.  Wouldn't this break that case?

Yeah, it will break it. I just missed it.

> I think the bug is in read_sparse_msg_data().  It shouldn't be calling
> con->ops->sparse_read() after the message has progressed to the footer.
> osd_sparse_read() is most likely fine as is.

Yes it is. We cannot tell exactly whether has it progressed to the 
footer IMO, such as when in case 'con->v1.in_base_pos == 
sizeof(con->v1.in_hdr)' the socket buffer may break just after finishing 
sparse-read and before reading footer or some where in sparse-read. For 
the later case then we should continue in the sparse reads.


> Notice how read_partial_msg_data() and read_partial_msg_data_bounce()
> behave: if called at that point (i.e. after the data section has been
> processed, meaning that cursor->total_resid == 0), they do nothing.
> read_sparse_msg_data() should have a similar condition and basically
> no-op itself.

Correct, this what I want to do in the sparse-read code.

>
> While at it, let's rename it to read_partial_sparse_msg_data() to
> emphasize the "partial"/no-op semantics that are required there.

Sure.

Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>



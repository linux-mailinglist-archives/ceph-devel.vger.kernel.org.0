Return-Path: <ceph-devel+bounces-280-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32253810F57
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Dec 2023 12:03:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1D09B20EED
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Dec 2023 11:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E06222F1D;
	Wed, 13 Dec 2023 11:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IkyjvFUi"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7486123
	for <ceph-devel@vger.kernel.org>; Wed, 13 Dec 2023 03:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702465397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3a7vbfSnJNOJd+SOmIToYuNb3ztRe/bNkh4yV87dDak=;
	b=IkyjvFUiffrxTMrr8VRHRabXOnisUYYG31m14VUndHC36KaKt/2uhyph90Ai5Ms2hV1KBX
	RNOVruN+4k5pYhehLxmQxv3ksBUgseAjduAbQnbqCnSniltro4GhN3bl8fPvIBLii0ti75
	y3SCBvVOIaWurft0CJ2zRAiYErpxdzE=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-ofx3iLo3NUeSGOvaOK4uQA-1; Wed, 13 Dec 2023 06:03:15 -0500
X-MC-Unique: ofx3iLo3NUeSGOvaOK4uQA-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5c6bd30ee89so6104301a12.0
        for <ceph-devel@vger.kernel.org>; Wed, 13 Dec 2023 03:03:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702465394; x=1703070194;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3a7vbfSnJNOJd+SOmIToYuNb3ztRe/bNkh4yV87dDak=;
        b=rlPIdnT2PrqDAxuLL8vFGGGf73w9gD+s/cEb2Ue1REbyXGPLtuuznQGK/DeSITo/99
         a5t+soKimhAiW6E64PZrj6Sg+yeFXS2+u+lIgFyMc7DUO8njnOB6eWJ4qkAOEB7HYNSK
         BsmN65o1ZyJ3JnbYe5L8DlMfufnxiiyzoTQG0fZknRQdyp/oMFWZU+h/BrYo+tBwacQz
         vp9atyMr6E+4wo3J/De1c41htYDjZ8IYBuaFY3UBpHT25bgI+PClZDud8Avj1kXOu38B
         JuvX3fqupNLMKrifa85zJ+WijdnSF8+9TJfPo8jxlp7wtKU11JU943ndyI3qm94Ju8i8
         TT5w==
X-Gm-Message-State: AOJu0YyV7wUoeZWuTyVjpPnjIWl2MGm2iVz75XN8Z3J+Y4wfCKZm2uXV
	M60RF86cxn0/PhFt6HF101Iw7v8v5M3aZ0nLB9Bz3/qjqVspI1zMP+hfRG39sTy2yyiMoxH2lKl
	Bs4sgKleLk0Cp82/nLgLKKg==
X-Received: by 2002:a05:6a20:244f:b0:18f:f040:86df with SMTP id t15-20020a056a20244f00b0018ff04086dfmr8438580pzc.82.1702465394509;
        Wed, 13 Dec 2023 03:03:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH20v6W/bkVcS6vJcbJFfJ5ZEVzbkOXDl3OuSBf7PoktRNfJgPfOLM2pSaTXpyPaCsQCvNhMg==
X-Received: by 2002:a05:6a20:244f:b0:18f:f040:86df with SMTP id t15-20020a056a20244f00b0018ff04086dfmr8438570pzc.82.1702465394193;
        Wed, 13 Dec 2023 03:03:14 -0800 (PST)
Received: from [10.72.113.27] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c7-20020a056a00008700b006ce458995f8sm9767333pfj.173.2023.12.13.03.03.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Dec 2023 03:03:13 -0800 (PST)
Message-ID: <008fe687-9df0-45d2-929c-168a10222b2f@redhat.com>
Date: Wed, 13 Dec 2023 19:03:09 +0800
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
 <af3d24bc-0a4f-4e30-ba3d-80d41a7fd94c@redhat.com>
 <CAOi1vP9EzGZM=U1jDzAnTwFvWD6fpZ+qMedgOQuK79qOodU+NQ@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP9EzGZM=U1jDzAnTwFvWD6fpZ+qMedgOQuK79qOodU+NQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 12/13/23 18:31, Ilya Dryomov wrote:
> On Wed, Dec 13, 2023 at 2:02 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 12/13/23 00:31, Ilya Dryomov wrote:
>>> On Fri, Dec 8, 2023 at 5:08 PM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> The messages from ceph maybe split into multiple socket packages
>>>> and we just need to wait for all the data to be availiable on the
>>>> sokcet.
>>>>
>>>> This will add a new _FINISH state for the sparse-read to mark the
>>>> current sparse-read succeeded. Else it will treat it as a new
>>>> sparse-read when the socket receives the last piece of the osd
>>>> request reply message, and the cancel_request() later will help
>>>> init the sparse-read context.
>>>>
>>>> URL: https://tracker.ceph.com/issues/63586
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    include/linux/ceph/osd_client.h | 1 +
>>>>    net/ceph/osd_client.c           | 6 +++---
>>>>    2 files changed, 4 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
>>>> index 493de3496cd3..00d98e13100f 100644
>>>> --- a/include/linux/ceph/osd_client.h
>>>> +++ b/include/linux/ceph/osd_client.h
>>>> @@ -47,6 +47,7 @@ enum ceph_sparse_read_state {
>>>>           CEPH_SPARSE_READ_DATA_LEN,
>>>>           CEPH_SPARSE_READ_DATA_PRE,
>>>>           CEPH_SPARSE_READ_DATA,
>>>> +       CEPH_SPARSE_READ_FINISH,
>>>>    };
>>>>
>>>>    /*
>>>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>>>> index 848ef19055a0..f1705b4f19eb 100644
>>>> --- a/net/ceph/osd_client.c
>>>> +++ b/net/ceph/osd_client.c
>>>> @@ -5802,8 +5802,6 @@ static int prep_next_sparse_read(struct ceph_connection *con,
>>>>                           advance_cursor(cursor, sr->sr_req_len - end, false);
>>>>           }
>>>>
>>>> -       ceph_init_sparse_read(sr);
>>>> -
>>>>           /* find next op in this request (if any) */
>>>>           while (++o->o_sparse_op_idx < req->r_num_ops) {
>>>>                   op = &req->r_ops[o->o_sparse_op_idx];
>>>> @@ -5919,7 +5917,7 @@ static int osd_sparse_read(struct ceph_connection *con,
>>>>                                   return -EREMOTEIO;
>>>>                           }
>>>>
>>>> -                       sr->sr_state = CEPH_SPARSE_READ_HDR;
>>>> +                       sr->sr_state = CEPH_SPARSE_READ_FINISH;
>>>>                           goto next_op;
>>> Hi Xiubo,
>>>
>>> This code appears to be set up to handle multiple (sparse-read) ops in
>>> a single OSD request.  Wouldn't this break that case?
>> Yeah, it will break it. I just missed it.
>>
>>> I think the bug is in read_sparse_msg_data().  It shouldn't be calling
>>> con->ops->sparse_read() after the message has progressed to the footer.
>>> osd_sparse_read() is most likely fine as is.
>> Yes it is. We cannot tell exactly whether has it progressed to the
>> footer IMO, such as when in case 'con->v1.in_base_pos ==
> Hi Xiubo,
>
> I don't buy this.  If the messenger is trying to read the footer, it
> _has_ progressed to the footer.  This is definitive and irreversible,
> not a "maybe".
>
>> sizeof(con->v1.in_hdr)' the socket buffer may break just after finishing
>> sparse-read and before reading footer or some where in sparse-read. For
>> the later case then we should continue in the sparse reads.
> The size of the data section of the message is always known.  The
> contract is that read_partial_msg_data*() returns 1 and does nothing
> else after the data section is consumed.  This is how the messenger is
> told to move on to the footer.
>
> read_partial_sparse_msg_data() doesn't adhere to this contract and
> should be fixed.
>
>>
>>> Notice how read_partial_msg_data() and read_partial_msg_data_bounce()
>>> behave: if called at that point (i.e. after the data section has been
>>> processed, meaning that cursor->total_resid == 0), they do nothing.
>>> read_sparse_msg_data() should have a similar condition and basically
>>> no-op itself.
>> Correct, this what I want to do in the sparse-read code.
> No, this needs to be done on the messenger side.  sparse-read code
> should not be invoked after the messenger has moved on to the footer.

 From my reading, even the messenger has moved on to the 'footer', it 
will always try to invoke to parse the 'header':

read_partial(con, end, size, &con->v1.in_hdr);

But it will do nothing and just returns.

And the same for 'front', 'middle' and '(page) data', then the last for 
'footer'.

Did I miss something ?

Thanks

- Xiubo

> Thanks,
>
>                  Ilya
>



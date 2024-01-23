Return-Path: <ceph-devel+bounces-644-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0946C837F99
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jan 2024 02:53:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88EA41F29D2B
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jan 2024 01:53:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0660A6341C;
	Tue, 23 Jan 2024 00:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dw/0HqJY"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050336280D
	for <ceph-devel@vger.kernel.org>; Tue, 23 Jan 2024 00:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971229; cv=none; b=Z0usd89yTGt9HBy7TjVNOqlxTP1kpX0Ten6KMwGNYBPAEGVoMOLEmYA7UXU4ROk4V7/NMRtN01tobY8Z69poc4XEn9BGaKeAjaJZt+vikDuPxGrliPXHEQkMNwOgHZMXnlnmeVsDMH/i+aAqFJC+ngDXjMVHV2vRQsDy/BNv+Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971229; c=relaxed/simple;
	bh=vCSX1//eukW1LwiLGRR2hVFVYbyyWTV+6NqUPE3AXGI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=loLuYBU3LAHZDi7kxBuq3hDEiM78gg5aXI8DOQgDiWULoq2w87sO5YoKOoDFDweuSYLRY00Ku7o/8u2YCPcfv5RclCeMcbC0e+kYG/CuqPpuTVRHc3Q/dyfI3ocboSS1WM9cgAW+QwTygNMx4PvYDAjOG9UASF+zaE0MiMbFyv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dw/0HqJY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705971226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lo/lvL81OcARqZhElLE2/bbT2rBk92SxjH9Jx5guXQE=;
	b=Dw/0HqJY3GU1ObsJ1uNgLtIdb6MQIia/M704PyhuOCcKfmKECWv9cv6wd4/q9XTADz6e9Y
	3SyXBhWKZqkkBilASds6z3d88+8Cy1sCxUmcUd3MgjdpXbUFtYXqe1JZq8F9SvD6Fr/DkT
	asLceb7mEC7edwKcpOcqSS/QR1PNNRo=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-XjL1pbhJNmu7ic02Mj0oxQ-1; Mon, 22 Jan 2024 19:53:45 -0500
X-MC-Unique: XjL1pbhJNmu7ic02Mj0oxQ-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1d731244132so8733715ad.2
        for <ceph-devel@vger.kernel.org>; Mon, 22 Jan 2024 16:53:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705971224; x=1706576024;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lo/lvL81OcARqZhElLE2/bbT2rBk92SxjH9Jx5guXQE=;
        b=hB+ePM5ic7W8k4MVQSMr6t3HdxVdVzbKtnejBJhST0HJ0LtcH6jdcyjpxcaIKNRIAv
         X3XBIiGPd21i9WHlDcrkBBIV9/Ybaviy8zVuUrUatJVrCq6vxxCMCsWH7XYjm+V8TCx4
         tuJGMJ4SjGLu84aZegl0yOnBVFqtKDNKBWzKo56ODLy1AohF2ws002xk/A3rY8jHxlrj
         qoZuw9lunFUJ28qpMEQ72p6WAe+LNIJsYeLPxFRsIABHboDzHJzM0qydcZBPM/N7bTCr
         R9e7G0o8zlIqs6P21BLxywclyyW7e3Xj2pTRXmXB3yNHgbvsDjmnoPlzE2AwpNBwP0sr
         Wttg==
X-Gm-Message-State: AOJu0YyduPn16rkWUcs7qIIbaEyveiNe8KmmfyV8magDcBDssm32r5AV
	dPInBP6I/aS5RzACdmQVkQAInYUcC1ZLTbxWy4NfVBC969I9e+AENL9mslDnx5lKDfFo1uL8ItD
	1gvFEQiy7pxRKPAROS76jkkRRNEr7emN70SU0KBJ4Amze8O0MiTf8iTeq3nY=
X-Received: by 2002:a17:902:b595:b0:1d4:4a0e:72a with SMTP id a21-20020a170902b59500b001d44a0e072amr2419595pls.93.1705971224343;
        Mon, 22 Jan 2024 16:53:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG82uH8qhB/SjYj/iVXNAHJjP7Kv3umnn9Tw1AW8gYKyAabb/riR//uGxJlxaBLyOiltlJrwQ==
X-Received: by 2002:a17:902:b595:b0:1d4:4a0e:72a with SMTP id a21-20020a170902b59500b001d44a0e072amr2419587pls.93.1705971224013;
        Mon, 22 Jan 2024 16:53:44 -0800 (PST)
Received: from [10.72.112.62] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id je2-20020a170903264200b001d7385ef111sm3728802plb.79.2024.01.22.16.53.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jan 2024 16:53:43 -0800 (PST)
Message-ID: <957d62aa-2ef4-4402-8cd8-d044b61c4c5e@redhat.com>
Date: Tue, 23 Jan 2024 08:53:39 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] libceph: just wait for more data to be available
 on the socket
Content-Language: en-US
To: Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org, vshankar@redhat.com, mchangir@redhat.com
References: <20240118105047.792879-1-xiubli@redhat.com>
 <20240118105047.792879-4-xiubli@redhat.com>
 <62794a33b27424dac66d4a09515147f763acc9de.camel@kernel.org>
 <CAOi1vP9sLmYVwpBjhyKD9mrXLUoRgXpK5EcQL0V7=uJUHuGbVw@mail.gmail.com>
 <69fdd8a5c50987ad468567573e88a54c91ef971e.camel@kernel.org>
 <CAOi1vP8M_85Xr20swLJzjh5y4J2ZoDe4R4ZQ602MrNtV6UcVVA@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP8M_85Xr20swLJzjh5y4J2ZoDe4R4ZQ602MrNtV6UcVVA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 1/23/24 03:41, Ilya Dryomov wrote:
> On Mon, Jan 22, 2024 at 6:14 PM Jeff Layton <jlayton@kernel.org> wrote:
>> On Mon, 2024-01-22 at 17:55 +0100, Ilya Dryomov wrote:
>>> On Mon, Jan 22, 2024 at 4:02 PM Jeff Layton <jlayton@kernel.org> wrote:
>>>> On Thu, 2024-01-18 at 18:50 +0800, xiubli@redhat.com wrote:
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> The messages from ceph maybe split into multiple socket packages
>>>>> and we just need to wait for all the data to be availiable on the
>>>>> sokcet.
>>>>>
>>>>> This will add 'sr_total_resid' to record the total length for all
>>>>> data items for sparse-read message and 'sr_resid_elen' to record
>>>>> the current extent total length.
>>>>>
>>>>> URL: https://tracker.ceph.com/issues/63586
>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>> ---
>>>>>   include/linux/ceph/messenger.h |  1 +
>>>>>   net/ceph/messenger_v1.c        | 32 +++++++++++++++++++++-----------
>>>>>   2 files changed, 22 insertions(+), 11 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
>>>>> index 2eaaabbe98cb..ca6f82abed62 100644
>>>>> --- a/include/linux/ceph/messenger.h
>>>>> +++ b/include/linux/ceph/messenger.h
>>>>> @@ -231,6 +231,7 @@ struct ceph_msg_data {
>>>>>
>>>>>   struct ceph_msg_data_cursor {
>>>>>        size_t                  total_resid;    /* across all data items */
>>>>> +     size_t                  sr_total_resid; /* across all data items for sparse-read */
>>>>>
>>>>>        struct ceph_msg_data    *data;          /* current data item */
>>>>>        size_t                  resid;          /* bytes not yet consumed */
>>>>> diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
>>>>> index 4cb60bacf5f5..2733da891688 100644
>>>>> --- a/net/ceph/messenger_v1.c
>>>>> +++ b/net/ceph/messenger_v1.c
>>>>> @@ -160,7 +160,9 @@ static size_t sizeof_footer(struct ceph_connection *con)
>>>>>   static void prepare_message_data(struct ceph_msg *msg, u32 data_len)
>>>>>   {
>>>>>        /* Initialize data cursor if it's not a sparse read */
>>>>> -     if (!msg->sparse_read)
>>>>> +     if (msg->sparse_read)
>>>>> +             msg->cursor.sr_total_resid = data_len;
>>>>> +     else
>>>>>                ceph_msg_data_cursor_init(&msg->cursor, msg, data_len);
>>>>>   }
>>>>>
>>>>>
>>>> Sorry, disregard my last email.
>>>>
>>>> I went and looked at the patch in the tree, and I better understand what
>>>> you're trying to do. We already have a value that gets set to data_len
>>>> called total_resid, but that is a nonsense value in a sparse read,
>>>> because we can advance farther through the receive buffer than the
>>>> amount of data in the socket.
>>> Hi Jeff,
>>>
>>> I see that total_resid is set to sparse_data_requested(), which is
>>> effectively the size of the receive buffer, not data_len.  (This is
>>> ignoring the seemingly unnecessary complication of trying to support
>>> normal reads mixed with sparse reads in the same message, which I'm
>>> pretty sure doesn't work anyway.)
>>>
>> Oh right. I missed that bit when I was re-reviewing this. Once we're in
>> a sparse read we'll override that value. Ok, so maybe we don't need
>> sr_total_resid.
>>
Oh, I get you now. Yeah we can just reuse the 'total_resid' instead of 
adding a new one.

>>> With that, total_resid should represent the amount that needs to be
>>> filled in (advanced through) in the receive buffer.  When total_resid
>>> reaches 0, wouldn't that mean that the amount of data in the socket is
>>> also 0?  If not, where would the remaining data in the socket go?
>>>
>> With a properly formed reply, then I think yes, there should be no
>> remaining data in the socket at the end of the receive.
> There would be no actual data, but a message footer which follows the
> data section and ends the message would be outstanding.

Yeah, correct.

>> At this point I think I must just be confused about the actual problem.
>> I think I need a detailed description of it before I can properly review
>> this patch.
> AFAIU the problem is that a short read may occur while reading the
> message footer from the socket.  Later, when the socket is ready for
> another read, the messenger invokes all read_partial* handlers,
> including read_partial_sparse_msg_data().  The contract between the
> messenger and these handlers is that the handler should bail if the
> area of the message it's responsible for is already processed.  So,
> in this case, it's expected that read_sparse_msg_data() would bail,
> allowing the messenger to invoke read_partial() for the footer and
> pick up where it left off.
>
> However read_sparse_msg_data() violates that contract and ends up
> calling into the state machine in the OSD client.  The state machine
> assumes that it's a new op and interprets some piece of the footer (or
> even completely random memory?) as the sparse-read header and returns
> bogus extent length, etc.
>
> (BTW it's why I suggested the rename from read_sparse_msg_data() to
> read_partial_sparse_msg_data() in another patch -- to highlight that
> it's one of the "partial" handlers and the respective behavior.)

Yeah, Ilya is correct.

Thanks

- Xiubo

> Thanks,
>
>                  Ilya
>



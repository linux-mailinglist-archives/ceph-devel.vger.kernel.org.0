Return-Path: <ceph-devel+bounces-52-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E1C647E210F
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 13:15:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 791F7281334
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 12:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40EAA1EB4A;
	Mon,  6 Nov 2023 12:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fFH0484x"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B7F1EB36
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 12:15:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8C692
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 04:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699272899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RirNUScg5uhCVCsnQC4Nb7R5KssNm7M/gcq8426GszI=;
	b=fFH0484xX3wz32cNFx3gchOoQHccg6ycCbNtC4hfb30XtA2Wf8gaTpCLwO7MnaLx90lJrn
	MUyQ5kwd7yoZ5q1YJjH5dMHBtWo7d/c2soXmcHGOY/7nBDzLQIntlbaAd+ZILjbWz2kxH8
	wby0hltk9O6+tYpNWfSooyPK3kVyBuk=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-7OiOO7ScPrKaORHX1bWdxg-1; Mon, 06 Nov 2023 07:14:58 -0500
X-MC-Unique: 7OiOO7ScPrKaORHX1bWdxg-1
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-57b6b3bde6cso4490285eaf.1
        for <ceph-devel@vger.kernel.org>; Mon, 06 Nov 2023 04:14:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699272897; x=1699877697;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RirNUScg5uhCVCsnQC4Nb7R5KssNm7M/gcq8426GszI=;
        b=uXC6MakWMe8WqDiwwEseP9vWjef3mw1ElICBt03KqiJSk/3DPFM4T/ggrBVc6B4ySY
         G5GudBrD7pOJxRG6+r+EfzVKDUIou71CtP+Qtx+F6gFQVkiw21v3aTqlyc4k+h9k6Ym8
         O03dag+shtLddC8409z3vDGYhRxEij/KI4aVvoCHUA+6y/I3WE4maEIFKbKhC9/352Sw
         f7oNCEFpgY9hJS0oJRnEzhEZ4JyMsMt48DYRvj8D380i2/lkO7d7GYbs1ZDDIZsmupxd
         axlxCXqRh7viHaL7eNfNGUhkBVKsbEeZg24chHKLvPxCVtiYCMFLWbifmfxpB+lpbLgF
         esTA==
X-Gm-Message-State: AOJu0Yxnst+tBHiAZiSHoDED85hhB8BHhi+AgKB39ulGIFKQhPOCiO2u
	M7wd0kCOS3TRSwuA6iwdqBjLyvqr4iWtty4sCrb9Jk+bYfhQ+/7qungjWFuJMDgrGG76R+WePjX
	v2ft/SbM81OhmzIaBUpsxTA==
X-Received: by 2002:a05:6359:6513:b0:168:e707:2e56 with SMTP id sk19-20020a056359651300b00168e7072e56mr14739784rwb.16.1699272897318;
        Mon, 06 Nov 2023 04:14:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEsrOusePTECNZZzQektlK/SCWRcQs6dsfyum6kI+VpYnz9rrfa1zl4IFV0J6DltLxnuCN4sA==
X-Received: by 2002:a05:6359:6513:b0:168:e707:2e56 with SMTP id sk19-20020a056359651300b00168e7072e56mr14739765rwb.16.1699272896976;
        Mon, 06 Nov 2023 04:14:56 -0800 (PST)
Received: from [10.72.112.221] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id f20-20020a635554000000b0059d6f5196fasm5440949pgm.78.2023.11.06.04.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 04:14:56 -0800 (PST)
Message-ID: <cee744a4-de97-0055-be94-1f928b06928e@redhat.com>
Date: Mon, 6 Nov 2023 20:14:51 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] libceph: remove the max extents check for sparse read
Content-Language: en-US
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com,
 mchangir@redhat.com
References: <20231103033900.122990-1-xiubli@redhat.com>
 <CAOi1vP8EtALzni0sdj0o4j61KkC6XqgzEgikCDhDPOHX6LNYZw@mail.gmail.com>
 <e350e6e7-22a2-69de-258f-70c2050dbd50@redhat.com>
 <CAOi1vP9haOn0RujjiWU5TQ3F-ZEi8GKXYFV+xzTrX3V3saH46A@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP9haOn0RujjiWU5TQ3F-ZEi8GKXYFV+xzTrX3V3saH46A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/6/23 19:38, Ilya Dryomov wrote:
> On Mon, Nov 6, 2023 at 1:14 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 11/3/23 18:07, Ilya Dryomov wrote:
>>
>> On Fri, Nov 3, 2023 at 4:41 AM <xiubli@redhat.com> wrote:
>>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> There is no any limit for the extent array size and it's possible
>> that when reading with a large size contents. Else the messager
>> will fail by reseting the connection and keeps resending the inflight
>> IOs.
>>
>> URL: https://tracker.ceph.com/issues/62081
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   net/ceph/osd_client.c | 12 ------------
>>   1 file changed, 12 deletions(-)
>>
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index 7af35106acaf..177a1d92c517 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -5850,8 +5850,6 @@ static inline void convert_extent_map(struct ceph_sparse_read *sr)
>>   }
>>   #endif
>>
>> -#define MAX_EXTENTS 4096
>> -
>>   static int osd_sparse_read(struct ceph_connection *con,
>>                             struct ceph_msg_data_cursor *cursor,
>>                             char **pbuf)
>> @@ -5882,16 +5880,6 @@ static int osd_sparse_read(struct ceph_connection *con,
>>
>>                  if (count > 0) {
>>                          if (!sr->sr_extent || count > sr->sr_ext_len) {
>> -                               /*
>> -                                * Apply a hard cap to the number of extents.
>> -                                * If we have more, assume something is wrong.
>> -                                */
>> -                               if (count > MAX_EXTENTS) {
>> -                                       dout("%s: OSD returned 0x%x extents in a single reply!\n",
>> -                                            __func__, count);
>> -                                       return -EREMOTEIO;
>> -                               }
>> -
>>                                  /* no extent array provided, or too short */
>>                                  kfree(sr->sr_extent);
>>                                  sr->sr_extent = kmalloc_array(count,
>> --
>> 2.39.1
>>
>> Hi Xiubo,
>>
>> As noted in the tracker ticket, there are many "sanity" limits like
>> that in the messenger and other parts of the kernel client.  First,
>> let's change that dout to pr_warn_ratelimited so that it's immediately
>> clear what is going on.
>>
>> Sounds good to me.
>>
>>   Then, if the limit actually gets hit, let's
>> dig into why and see if it can be increased rather than just removed.
>>
>> The test result in https://tracker.ceph.com/issues/62081#note-16 is that I just changed the 'len' to 5000 in ceph PR https://github.com/ceph/ceph/pull/54301 to emulate a random writes to a file and then tries to read with a large size:
>>
>> [ RUN      ] LibRadosIoPP.SparseReadExtentArrayOpPP
>> extents array size : 4297
>>
>> For the 'extents array size' it could reach up to a very large number, then what it should be ? Any idea ?
> Hi Xiubo,
>
> I don't think it can be a very large number in practice.
>
> CephFS uses sparse reads only in the fscrypt case, right?

Yeah, it is.


>    With
> fscrypt, sub-4K writes to the object store aren't possible, right?

Yeah.


> If the answer to both is yes, then the maximum number of extents
> would be
>
>      64M (CEPH_MSG_MAX_DATA_LEN) / 4K = 16384
>
> even if the object store does tracking at byte granularity.
So yeah, just for the fscrypt case if we set the max extent number to 
16384 it should be fine. But the sparse read could also be enabled in 
non-fscrypt case. From my test in 
https://github.com/ceph/ceph/pull/54301 if we set the segment size to 8 
bytes the extent number could be very large.

Thanks

- Xiubo

> Thanks,
>
>                  Ilya
>



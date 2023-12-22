Return-Path: <ceph-devel+bounces-433-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70CFD81CB81
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Dec 2023 15:49:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5584B23044
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Dec 2023 14:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FB8023745;
	Fri, 22 Dec 2023 14:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b="aAgxxDeh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7FC22F0C
	for <ceph-devel@vger.kernel.org>; Fri, 22 Dec 2023 14:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ieee.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ieee.org
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-35fb96f3404so7613565ab.2
        for <ceph-devel@vger.kernel.org>; Fri, 22 Dec 2023 06:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1703256526; x=1703861326; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+/ZtCzo4gYUCk7AMUM/tMA1erkQjpbn3vDUdNYgyjz8=;
        b=aAgxxDehu5Q1sN59k+x0HZ6yBENWY1kl1mn3s1js3owRcypyP/39gKqAke5Xn6vVvQ
         KOFkIcpieWVImkGIIFZ3EjqlPBf73mijaETSePkexTwn3aN8HmsIPuEnzWMy7HgmR+Cn
         0i6evkso8DlS8M6HcaHNz5WOtY3uQaAtbjHSM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703256526; x=1703861326;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+/ZtCzo4gYUCk7AMUM/tMA1erkQjpbn3vDUdNYgyjz8=;
        b=cYU3MDaNFhmFyJTqHh0FK3sN9KaVPb6BRiq6idu8MQkYfUAoH9DbL7fphJW/yYN2zZ
         6r2oWuG6fdNrrDJqfYgl4ts9ZThHbkQ39MAN17Si9wAjF1xKPugxzVe20HSV4YzrH2dq
         IPwEd7Zk0IM79vpkvtgo3Cl17M8nlV111z6aKZCXz9swqgIh4A5GpGQkTnj1R6LBoYu4
         6zD8IsaT9OXuwZyAviZHahhfi1WY0PO/mbrNk/NZSMMWXmqzsGGTlbzfpWpcKlwZz9nj
         WSs2TvOnBGjR42skHxol4n+QHZRQYPL3nP5L8h0tRWfyOA+MUmqrW1rhJumMLx65O5/I
         tg0w==
X-Gm-Message-State: AOJu0Yw9QQHdCM6Hw9Vc60Fh94tpvDQiXkC4QhTjXv+ljLu95IFdaQc9
	ifMpvUNvYLGFzKMjOZTBCmWI+O6m67pm
X-Google-Smtp-Source: AGHT+IGNYEaCd7VnPJU+SLpCD00SyqziVzBEcJfYwyIvGvGwG7rBqN/uqdW99GtII8NqYrU3bv6fnw==
X-Received: by 2002:a05:6e02:330a:b0:35f:d251:3373 with SMTP id bm10-20020a056e02330a00b0035fd2513373mr1879802ilb.28.1703256526712;
        Fri, 22 Dec 2023 06:48:46 -0800 (PST)
Received: from [172.22.22.28] (c-98-61-227-136.hsd1.mn.comcast.net. [98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id l3-20020a92d943000000b0035fda20a688sm680466ilq.60.2023.12.22.06.48.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Dec 2023 06:48:46 -0800 (PST)
Message-ID: <31812ee1-3f57-48b0-a623-fa5921156cb6@ieee.org>
Date: Fri, 22 Dec 2023 08:48:45 -0600
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] rbd: use check_sub_overflow() to limit the number of
 snapshots
Content-Language: en-US
To: Ilya Dryomov <idryomov@gmail.com>, Dmitry Antipov <dmantipov@yandex.ru>
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>, ceph-devel@vger.kernel.org,
 linux-block@vger.kernel.org
References: <20231221133928.49824-1-dmantipov@yandex.ru>
 <CAOi1vP9wHBG_g7mxZ4NoM5Y6b_xW-fRF6iUcvC_W3UcF3FbESA@mail.gmail.com>
From: Alex Elder <elder@ieee.org>
In-Reply-To: <CAOi1vP9wHBG_g7mxZ4NoM5Y6b_xW-fRF6iUcvC_W3UcF3FbESA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/22/23 8:23 AM, Ilya Dryomov wrote:
> On Thu, Dec 21, 2023 at 2:40 PM Dmitry Antipov <dmantipov@yandex.ru> wrote:
>>
>> When compiling with clang-18 and W=1, I've noticed the following
>> warning:
>>
>> drivers/block/rbd.c:6093:17: warning: result of comparison of constant
>> 2305843009213693948 with expression of type 'u32' (aka 'unsigned int')
>> is always false [-Wtautological-constant-out-of-range-compare]
>>   6093 |         if (snap_count > (SIZE_MAX - sizeof (struct ceph_snap_context))
>>        |             ~~~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>   6094 |                                  / sizeof (u64)) {
>>        |                                  ~~~~~~~~~~~~~~
>>
>> Since the plain check with '>' makes sense only if U32_MAX == SIZE_MAX
>> which is not true for the 64-bit kernel, prefer 'check_sub_overflow()'
>> in 'rbd_dev_v2_snap_context()' and 'rbd_dev_ondisk_valid()' as well.
>>
>> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
>> ---
>>   drivers/block/rbd.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
>> index a999b698b131..ef8e6fbc9a79 100644
>> --- a/drivers/block/rbd.c
>> +++ b/drivers/block/rbd.c
>> @@ -933,7 +933,7 @@ static bool rbd_image_format_valid(u32 image_format)
>>
>>   static bool rbd_dev_ondisk_valid(struct rbd_image_header_ondisk *ondisk)
>>   {
>> -       size_t size;
>> +       size_t size, result;
>>          u32 snap_count;
>>
>>          /* The header has to start with the magic rbd header text */
>> @@ -956,7 +956,7 @@ static bool rbd_dev_ondisk_valid(struct rbd_image_header_ondisk *ondisk)
>>           */
>>          snap_count = le32_to_cpu(ondisk->snap_count);
>>          size = SIZE_MAX - sizeof (struct ceph_snap_context);
>> -       if (snap_count > size / sizeof (__le64))
>> +       if (check_sub_overflow(size / sizeof(__le64), snap_count, &result))
> 
> Hi Dmitry,
> 
> There is a limit on the number of snapshots:
> 
> #define RBD_MAX_SNAP_COUNT      510     /* allows max snapc to fit in 4KB */
> 
> It's not direct, but it's a hard limit, at least in the current
> implementation.  Let's just replace these with direct comparisons for
> RBD_MAX_SNAP_COUNT.

The point of the original code was to ensure the on-disk snap_count
value was sane, but there's no point in checking for a 64-bit size_t. 
Comparing against RBD_MAX_SNAP_COUNT is better.  I think it's safe
to assume RBD_MAX_SNAP_COUNT (or rather, the size required to hold
that many snapshot IDs) can always be represented in a size_t.

					-Alex

> 
> Thanks,
> 
>                  Ilya
> 



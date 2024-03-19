Return-Path: <ceph-devel+bounces-990-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BF6088084B
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Mar 2024 00:54:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEE1F1F22C7A
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Mar 2024 23:54:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7C05FBA6;
	Tue, 19 Mar 2024 23:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bKZIbLkA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EC93FBAF
	for <ceph-devel@vger.kernel.org>; Tue, 19 Mar 2024 23:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710892448; cv=none; b=nwUxVenKggNT/X03dQi/1NpjbomIXzxkUNoMZyBuHQ63Ok4Mu5qWPXWiToF4LSn944NlMyVxNULgMy24/1R2/5xYBxU2qU7//dN9unS6D2o7ECogyIYAZ5KBeXWgaaVMyUG900Z6Qp12Tyx0ZyDxDSn9bgF6sRZLgShJn278o8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710892448; c=relaxed/simple;
	bh=mIbjAL4Tsu4N7WJ2AnDN9Y2PUjmWm7rx8+1Q54N1ipI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PO/DD+V6jf8dMwGSIUEhi0C0nJP2q/R3YOuVZAN6meZ+Mdx+8Gn2g4KsdsgnBYz+5MXVsnQjli5U3tXM3ysF6w9HO6yjQpMvXf6Gy6aNexJA6qzst3rWf00A25i+C4R0jEa0AtpvN9O7WnUboTTmH4edhRhjIXcu3XAz8Jpsjd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bKZIbLkA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710892445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zbEun43ZBsQsywHu6L/M5t0ZX1iHNKcnRwo0liRQ+Lg=;
	b=bKZIbLkAN+Hb05fTIxjcEEj29p6tqkvI8SrAkBp2p8vam9meCdxmNiNRRxABKOnnHSJdLQ
	zdIdCTU5aNLMlszOWIbQlfFNUwaDVFgniO1QSEw5+EOq5Y6F/nsiOr7avoDlCrjWEYDZLT
	97EiO1nGHmSVgP07PIgigC/XQ8No0nE=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-u6Ce9Rf-Oqu-dIawrJeCrw-1; Tue, 19 Mar 2024 19:54:03 -0400
X-MC-Unique: u6Ce9Rf-Oqu-dIawrJeCrw-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1e00e166ff4so24126335ad.0
        for <ceph-devel@vger.kernel.org>; Tue, 19 Mar 2024 16:54:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710892442; x=1711497242;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zbEun43ZBsQsywHu6L/M5t0ZX1iHNKcnRwo0liRQ+Lg=;
        b=L88c0qTHrQloiScPD7+aYIOV+qEGY0s1U5U2otLDyk3tKufZEvSBEmX+lGl996ISoL
         HA8FFz7hUXMFKPVhguAWoxEEFnZkEXCRBEQtxy4DM9vCb7IRBQVfHaKiE/xKIoWSHxmB
         yZweZ7tdc/AEBaevMmWJ9UvXFHjDhRaS/Wj6P4MGf04Fb5LcADJL51wI16J8wic/r8om
         dL1L3AOOB5cCtaD5G0cnCTwtpU7Un0sVLer73IkDP73iI7l+/6J/5js6d1xJm3Ie2m/B
         s7Nxr1a+mBdzFW8j8dGlWl7FBHGy0DZuP/wLuKgWIucj8f5qjyqZEByvYw8Akd7pn4NC
         NjcQ==
X-Gm-Message-State: AOJu0YwC54zNoKmu5j1vi5S3k7qpdgm3hENkTHSFKE9hRND0uipljOIv
	uLTLpYSdqiM0+u1QTgRX2QWCZzg3W1+DxzSkqpLr/AvR2F2pfgGlLfwsyble6zC3zGUxsE4sgam
	bhdO1wNEN3yws+nR2hbRuS3W5Lq0gwDwAS3EBMadO/6CQbUzwlKbnjw9HcI8=
X-Received: by 2002:a17:902:a3c4:b0:1dd:78f8:3e1 with SMTP id q4-20020a170902a3c400b001dd78f803e1mr3822489plb.44.1710892442564;
        Tue, 19 Mar 2024 16:54:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFIIxPYx5X98gEM1xNWeFvytFo3bhp8CWTpeDgtB12FcKOGmF49Wa8b+jK+mCMxSaS+HG7fJA==
X-Received: by 2002:a17:902:a3c4:b0:1dd:78f8:3e1 with SMTP id q4-20020a170902a3c400b001dd78f803e1mr3822478plb.44.1710892442141;
        Tue, 19 Mar 2024 16:54:02 -0700 (PDT)
Received: from [10.72.112.131] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ja9-20020a170902efc900b001ddd0eb63f4sm12096443plb.105.2024.03.19.16.53.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Mar 2024 16:54:01 -0700 (PDT)
Message-ID: <c03bce46-b4a6-40e4-984d-19c1e676d07e@redhat.com>
Date: Wed, 20 Mar 2024 07:53:56 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] ceph: set the correct mask for getattr reqeust for
 read
Content-Language: en-US
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com,
 mchangir@redhat.com, frankhsiao@qnap.com
References: <20240319002925.1228063-1-xiubli@redhat.com>
 <20240319002925.1228063-3-xiubli@redhat.com>
 <CAOi1vP_xiO-0EFq2T100Tx30ayR4dyegxJR-CcZX34peYg09gg@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_xiO-0EFq2T100Tx30ayR4dyegxJR-CcZX34peYg09gg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 3/19/24 21:35, Ilya Dryomov wrote:
> On Tue, Mar 19, 2024 at 1:32 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> In case of hitting the file EOF the ceph_read_iter() needs to
>> retrieve the file size from MDS, and the Fr caps is not a neccessary.
>>
>> URL: https://patchwork.kernel.org/project/ceph-devel/list/?series=819323
>> Reported-by: Frank Hsiao 蕭法宣 <frankhsiao@qnap.com>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> Tested-by: Frank Hsiao 蕭法宣 <frankhsiao@qnap.com>
>> ---
>>   fs/ceph/file.c | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index c35878427985..a85f95c941fc 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -2191,14 +2191,16 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>                  int statret;
>>                  struct page *page = NULL;
>>                  loff_t i_size;
>> +               int mask = CEPH_STAT_CAP_SIZE;
>>                  if (retry_op == READ_INLINE) {
>>                          page = __page_cache_alloc(GFP_KERNEL);
>>                          if (!page)
>>                                  return -ENOMEM;
>>                  }
>>
>> -               statret = __ceph_do_getattr(inode, page,
>> -                                           CEPH_STAT_CAP_INLINE_DATA, !!page);
>> +               if (retry_op == READ_INLINE)
>> +                       mask = CEPH_STAT_CAP_INLINE_DATA;
> Hi Xiubo,
>
> This introduces an additional retry_op == READ_INLINE branch right
> below an existing one.  Should this be:
>
>      int mask = CEPH_STAT_CAP_SIZE;
>      if (retry_op == READ_INLINE) {
>              page = __page_cache_alloc(GFP_KERNEL);
>              if (!page)
>                      return -ENOMEM;
>
>              mask = CEPH_STAT_CAP_INLINE_DATA;
>      }

Look good to me.

Thanks Ilya.

- Xiubo


> Thanks,
>
>                  Ilya
>



Return-Path: <ceph-devel+bounces-1799-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C068396F491
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 14:48:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 505032816AB
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 12:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD5E32745B;
	Fri,  6 Sep 2024 12:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c9yqty/Z"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC2F1E49B
	for <ceph-devel@vger.kernel.org>; Fri,  6 Sep 2024 12:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725626905; cv=none; b=B0cegOHcYJv7rkq12B1LooLbhONFEiswUzNPBIul71TRoBZTHfrqKl/3cYtHLnkP62NbtXvKhORow13ymZ6VmMN2QVGGA3haq2ZPOzdZMQg1x+oIrCKmDjZX5t5rO9G+VCKoNgXg5XWklu/O/qzB2NRRw69fs5v9r+Z6mOFIMPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725626905; c=relaxed/simple;
	bh=1YwdWI4SxTBGk0/J0qjYGGxIvNxBjfDUb5Q4hu2E1xU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZEdyYiX/BWi4TRA2/3Dzko9aVhyJYf5B8YV/dr1RVMELml50BIZ70xlzkuB4LlzDgA75GGVULbKAMu3WNMsEqv8uMn/u1y7VIo+sv6FliRnXx7t/F8fyaSuNZR6jNvTt6CYPxmLh98f2/68tIej3P9xF2lIhWYdEpsc+R7CGW8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c9yqty/Z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725626901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JMckFxnNPflZ4rNmGcRAMslCYWQbbH8yLwun1LJ+Z5E=;
	b=c9yqty/Z5YTD6Xihd4XyYJLzJDsjWHLgOw24UMDqBpgK0Wf0W4U+TMKEsFSoRZ2nK0G2yi
	kqLj6HgkgUT5zocj/bZG5es411exl+QYKS8X+4lb+WlVNKUfOMyQFKxWpiAlRTHtDD7lYl
	v4b6nljvY9VhEkYTWkloXgLqB5YRrUw=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-U0AH-IKvOA2XKKuHX9A_mw-1; Fri, 06 Sep 2024 08:48:20 -0400
X-MC-Unique: U0AH-IKvOA2XKKuHX9A_mw-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1fc6db23c74so26778465ad.0
        for <ceph-devel@vger.kernel.org>; Fri, 06 Sep 2024 05:48:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725626900; x=1726231700;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JMckFxnNPflZ4rNmGcRAMslCYWQbbH8yLwun1LJ+Z5E=;
        b=Ahg5W3qDfwNM9voet+9sBjBB8+7QRZtlZfdjvBLCplzr07Y+yadfN0I+cuRLldwRBZ
         oBcs6pBK0fCsrTkoJN5ZBysAF4wYO4MP0TplLcEMElWfz7i6Wlbk/hwwwI7Nj8QAHtF6
         mFdtRfW3deKIJ1cSXYd7e1GT5i249Rpiu7j0qXScC5Du90pNp7uG9gE5fZ0YgRzd7HXE
         +PelyoDwCxY+krNSnQlwf2jtiuuiHoBVk91ty1ivemEFQHxrDXo15Mi2wK9MLBryxDQO
         tMtD2bjSLhO+y7nTmIQ7XBrR6NzQ76tqsAuoCClopSZ5iWSrjIq/ubzeSesenI9Q15YY
         DREw==
X-Forwarded-Encrypted: i=1; AJvYcCVjn7wZgvQaYSEj7jQVoLnZ1bPfnbThHBiFH4wau0YNiQp4qSwdS6Zr6I8B1UNbIPTmIo2Zfp+x1dK6@vger.kernel.org
X-Gm-Message-State: AOJu0YzmECHA34scjzKLBLApts3PSWw1GKdsXuHjFIH7B7huMGRt8J2Y
	6LHaIGYt3RGuVLAWqikwT93D7iSBEqrRhzuj03F4C6Je9ZvscXMrrKWkVIFVOuObFlhLpwfKWe4
	ClNMtehvjXfqC7sAR/2tlE/X38C+epdoO8eKS+OdaUMuN/oE86XG/2mObptw=
X-Received: by 2002:a17:902:db0d:b0:205:4885:235e with SMTP id d9443c01a7336-206f05b1527mr26207415ad.39.1725626899729;
        Fri, 06 Sep 2024 05:48:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFZJ24dg0qGHkaTDQnzkspR+EyM42irNnK7ogdIDDHMh5Ocbubbi1UyEH0axueQD5eFz3AHQ==
X-Received: by 2002:a17:902:db0d:b0:205:4885:235e with SMTP id d9443c01a7336-206f05b1527mr26207235ad.39.1725626899386;
        Fri, 06 Sep 2024 05:48:19 -0700 (PDT)
Received: from [10.72.116.139] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea37b03sm42926865ad.178.2024.09.06.05.48.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 05:48:18 -0700 (PDT)
Message-ID: <bb7c03b3-f922-4146-8644-bd9889e1bf86@redhat.com>
Date: Fri, 6 Sep 2024 20:48:13 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2] ceph: ceph: fix out-of-bound array access when
 doing a file read
To: Luis Henriques <luis.henriques@linux.dev>
Cc: Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240905135700.16394-1-luis.henriques@linux.dev>
 <e1c50195-07a9-4634-be01-71f4567daa54@redhat.com> <87plphm32k.fsf@linux.dev>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <87plphm32k.fsf@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 9/6/24 19:30, Luis Henriques wrote:
> On Fri, Sep 06 2024, Xiubo Li wrote:
>
>> On 9/5/24 21:57, Luis Henriques (SUSE) wrote:
>>> __ceph_sync_read() does not correctly handle reads when the inode size is
>>> zero.  It is easy to hit a NULL pointer dereference by continuously reading
>>> a file while, on another client, we keep truncating and writing new data
>>> into it.
>>>
>>> The NULL pointer dereference happens when the inode size is zero but the
>>> read op returns some data (ceph_osdc_wait_request()).  This will lead to
>>> 'left' being set to a huge value due to the overflow in:
>>>
>>> 	left = i_size - off;
>>>
>>> and, in the loop that follows, the pages[] array being accessed beyond
>>> num_pages.
>>>
>>> This patch fixes the issue simply by checking the inode size and returning
>>> if it is zero, even if there was data from the read op.
>>>
>>> Link: https://tracker.ceph.com/issues/67524
>>> Fixes: 1065da21e5df ("ceph: stop copying to iter at EOF on sync reads")
>>> Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
>>> ---
>>>    fs/ceph/file.c | 5 ++++-
>>>    1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>> index 4b8d59ebda00..41d4eac128bb 100644
>>> --- a/fs/ceph/file.c
>>> +++ b/fs/ceph/file.c
>>> @@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>>>    	if (ceph_inode_is_shutdown(inode))
>>>    		return -EIO;
>>>    -	if (!len)
>>> +	if (!len || !i_size)
>>>    		return 0;
>>>    	/*
>>>    	 * flush any page cache pages in this range.  this
>>> @@ -1154,6 +1154,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>>>    		doutc(cl, "%llu~%llu got %zd i_size %llu%s\n", off, len,
>>>    		      ret, i_size, (more ? " MORE" : ""));
>>>    +		if (i_size == 0)
>>> +			ret = 0;
>>> +
>>>    		/* Fix it to go to end of extent map */
>>>    		if (sparse && ret >= 0)
>>>    			ret = ceph_sparse_ext_map_end(op);
>>>
>> Hi Luis,
>>
>> BTW, so in the following code:
>>
>> 1202                 idx = 0;
>> 1203                 if (ret <= 0)
>> 1204                         left = 0;
>> 1205                 else if (off + ret > i_size)
>> 1206                         left = i_size - off;
>> 1207                 else
>> 1208                         left = ret;
>>
>> The 'ret' should be larger than '0', right ?
> Right.  (Which means we read something from the file.)
>
>> If so we do not check anf fix it in the 'else if' branch instead?
> Yes, and then we'll have:
>
> 	left = i_size - off;
>
> and because 'i_size' is 0, so 'left' will be set to 0xffffffffff...
> And the loop that follows:
>
> 	while (left > 0) {
>          	...
>          }
>
> will keep looping until we get a NULL pointer.  Have you tried the
> reproducer?

Hi Luis,

Not yet, and recently I haven't get a chance to do that for the reason 
as you know.

Thanks

- Xiubo


> Cheers,



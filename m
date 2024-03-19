Return-Path: <ceph-devel+bounces-978-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C23F87F476
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Mar 2024 01:18:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E60A4B20C7C
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Mar 2024 00:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4767C3C24;
	Tue, 19 Mar 2024 00:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J/gi9+SR"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCD03224
	for <ceph-devel@vger.kernel.org>; Tue, 19 Mar 2024 00:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710807525; cv=none; b=Z6faU/Q/u76priVX6FVM/CZ1FgWAaH6ZWiTQ6fbnGXcBi3JwfeR3pMseCQKHKNiED6XZUNUuVWfQ+dowIviCkqjzXK/wS87ynprR/Qx8TJZi12nI/i5o+rYjCG2VfhI+FYJADUrw8SJ4OFkXHyYU+/0M95v0Ppd4dBow8jASyZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710807525; c=relaxed/simple;
	bh=+90gLwKw6l4O5KhkflHQvnMzipK0qpxyhw/EP6FbbTs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rqj6fj/PsFBs9MKNPaYMVu7nssnyTWwhVECJ6CXdyoky85+Cdi3igWuUXK/qXhIKEWEDQlyuIQkZ+Mw1sSI6lcrunsaurHm636c8re5CGwyMzNe44+/eFBnp1rmPsvF6JgDnWBnAUQyR9MqcoyV4bT6/DGyecvlqOJYTCx+EM6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J/gi9+SR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710807521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s8pqFquHTnIQP41GOXq4l8ajyKoN7y0BKUEu2aHCgcY=;
	b=J/gi9+SRhxa816oUM5eLW+JTUN5nVuLJu9bIR/xbdOcaBoHyxnutu+nueUI1ilBZwgxolw
	Jur36rDaB18JaxK9jIuIoLmtpUJa20SL4sOgZZp9OR5kj2bmRaeSFeSisdNAJPpiHKnjKl
	z8soZ58hkWmLUw6gyXM5X75GJZHylUY=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-sjdJ7E5eNUWlkd7AswIGgQ-1; Mon, 18 Mar 2024 20:18:40 -0400
X-MC-Unique: sjdJ7E5eNUWlkd7AswIGgQ-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1e01e8875b9so13228115ad.1
        for <ceph-devel@vger.kernel.org>; Mon, 18 Mar 2024 17:18:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710807519; x=1711412319;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s8pqFquHTnIQP41GOXq4l8ajyKoN7y0BKUEu2aHCgcY=;
        b=HARRvoBaMq8JMn8r8YuxzgLbS134VCsJ23weMNC1NrJP/B4fAKd6ya+0iLyfQSvi8Y
         snDPBR4eJIAvhQgWi9Yy9zZHh2tXIwd6smT0O9iYLpuX15R7eQTjdU0hR2DXz5LqSW+E
         IvMk58AjhLE9pDpe5XWaDcD3qhMMy80/Bandm32HEa7UwGpOCF99EWalZUhSy/BThwvg
         FaUWarnthOO+B+CNYon89YTs+mbKpmh0tbGm3x0c4cEAiQ8c164wrFbh6a+9L0w7qCHu
         j3ITndrUaXinKCyuGuNqiMN/Q5+RyVaj9+BkdeDlGpNDHwUKgFMO3rrDO/BE6aEQy6tV
         kwyw==
X-Gm-Message-State: AOJu0YyYeTfMQ8A2q6Lw9G01CV37oTlGvcTNY5IGwGBFr13bzOraikQF
	q7Wtz4GXN6IwB/b4AZGJN9C7in8sbBfEmfuZH4y2JrMSQ+go69K/sBB7PhK5/lO/PodGRNttrbH
	zJt4yOp/+tVZGezLcGVelUlPHOY1OqQ+IqQYLrnrZnb+W6q3gkyc1r0o3poA=
X-Received: by 2002:a17:903:2281:b0:1df:ff0a:7130 with SMTP id b1-20020a170903228100b001dfff0a7130mr1396105plh.33.1710807518950;
        Mon, 18 Mar 2024 17:18:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWp90CEQBNZFvlSMVw0uA/Og6XBJZCm8tSWnpa2toTmsdTpeEMFVJUu15yCNIFP6yWcr589g==
X-Received: by 2002:a17:903:2281:b0:1df:ff0a:7130 with SMTP id b1-20020a170903228100b001dfff0a7130mr1396087plh.33.1710807518589;
        Mon, 18 Mar 2024 17:18:38 -0700 (PDT)
Received: from [10.72.112.45] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm3730056ple.219.2024.03.18.17.18.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Mar 2024 17:18:38 -0700 (PDT)
Message-ID: <0198ce37-e5ec-4ccc-b847-06765bd87156@redhat.com>
Date: Tue, 19 Mar 2024 08:18:33 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] ceph: skip copying the data extends the file EOF
Content-Language: en-US
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com,
 mchangir@redhat.com, =?UTF-8?B?RnJhbmsgSHNpYW8g6JWt5rOV5a6j?=
 <frankhsiao@qnap.com>
References: <20240222131900.179717-1-xiubli@redhat.com>
 <20240222131900.179717-2-xiubli@redhat.com>
 <CAOi1vP-eqXSzfQ82AB9yxqKvSHoV43FVg3WnFupDo=v1fLvaUg@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP-eqXSzfQ82AB9yxqKvSHoV43FVg3WnFupDo=v1fLvaUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 3/19/24 05:02, Ilya Dryomov wrote:
> On Thu, Feb 22, 2024 at 2:21 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> If hits the EOF it will revise the return value to the i_size
>> instead of the real length read, but it will advance the offset
>> of iovc, then for the next try it may be incorrectly skipped.
>>
>> This will just skip advancing the iovc's offset more than i_size.
>>
>> URL: https://patchwork.kernel.org/project/ceph-devel/list/?series=819323
>> Reported-by: Frank Hsiao 蕭法宣 <frankhsiao@qnap.com>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/file.c | 18 ++++++++----------
>>   1 file changed, 8 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 71d29571712d..2b2b07a0a61b 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -1195,7 +1195,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>>                  }
>>
>>                  idx = 0;
>> -               left = ret > 0 ? ret : 0;
>> +               left = ret > 0 ? umin(ret, i_size) : 0;
> Hi Xiubo,
>
> Can ret (i.e. the number of bytes actually read) be compared to i_size
> without taking the offset into account?  How does this a handle a case
> where e.g.
>
>      off = 20
>      ret = 10
>      i_size = 25
>
> Did you intend the copy_page_to_iter() loop to go over 10 bytes and
> therefore advance the iovc ("to") by 10 instead of 5 bytes here?

Good catch!

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 142deb242196..531874935c21 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1204,7 +1204,12 @@ ssize_t __ceph_sync_read(struct inode *inode, 
loff_t *ki_pos,
                 }

                 idx = 0;
-               left = ret > 0 ? umin(ret, i_size) : 0;
+               if (ret <= 0)
+                       left = 0;
+               else if (off + ret > i_size)
+                       left = i_size - off;
+               else
+                       left = ret;
                 while (left > 0) {
                         size_t plen, copied;

Let me fix this in V3.

Thanks Ilya!

- Xiubo


> Thanks,
>
>                  Ilya
>



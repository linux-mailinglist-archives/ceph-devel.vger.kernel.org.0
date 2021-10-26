Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A0C43AAA0
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Oct 2021 05:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbhJZDOm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Oct 2021 23:14:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49355 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233243AbhJZDOl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 25 Oct 2021 23:14:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635217938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2B2M0hCUNoaQnu0yoM5MSDN4b3T09yKt6+F+5sdNuSs=;
        b=YFD3oqi/XK6rHgsXv15CsuX75f0JsVYqXYrG0pUUuQEhzdeZn6FeGekeQ/+XTJzVJrtjE3
        9i+9/DiX+y7bFHxPz9P5czSUqjpENPwu8P129wHEjxuOmzFgvzYVsBrzAJyRtkzTuclZ51
        CCQPJngLmVSJRs79X+CaTiTstn0eBjQ=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-w9DeS6wCMaSxvZ3OmUy8Ww-1; Mon, 25 Oct 2021 23:12:16 -0400
X-MC-Unique: w9DeS6wCMaSxvZ3OmUy8Ww-1
Received: by mail-pj1-f69.google.com with SMTP id 13-20020a17090a098d00b001a277f92695so659391pjo.7
        for <ceph-devel@vger.kernel.org>; Mon, 25 Oct 2021 20:12:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=2B2M0hCUNoaQnu0yoM5MSDN4b3T09yKt6+F+5sdNuSs=;
        b=ntvZKQEDApuSPjH4Y41iZ+NQElOGML0Iltv+2YQRdqzeYjSev2Oajn9rw1fPFIVcRs
         SVymyU1/PwQ4qOh1k/a86nx+fnsBGwhN7rmVDAaN32nEaCVYHXoWvQTW0s848r9mrjU3
         ln8MCriqmhBym2zurCZUAegbkb1vN9LEPNvFvNRZobMz7AmxPnoER9wteYFoThyd8FIq
         A2nwx0Oaz1l32A8KD2v9hJsxd/lah5JX/kAU060nPJijlEkX84ePncJjSmVxPBcvLQfU
         uB30ykh00Xt5UbPX6kyp0UHPp1znBPLDdHqoSv884+BQMYbpMxYRr7zydoFHCz9tyAEN
         rPGQ==
X-Gm-Message-State: AOAM531Rim2E2M/daqM+cMOGzRAnyTcLSdTLlPAI6KXs/i5l0PfMjuuV
        3dEEXczRLeRL+DMbLxVX8P+emBNylJe1RAinQHPWrG9nbZULtfhJPg5x8eRjqGFRX+LwOGI7ZKt
        ZFXDj8H7AIyuYv4j3sHu78ehdi7xhJkhfTx/JKQDmV9orqOzri8y4zR6gYukqIn8MF+ZtNJQ=
X-Received: by 2002:a17:90b:4c88:: with SMTP id my8mr25217560pjb.49.1635217935559;
        Mon, 25 Oct 2021 20:12:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYif2ilFJIALOMRbfFXkFaVIQ0UOMMdvij9+VM+WF92AcmgmP5XmS4Rf9t2KFU4F1phaKnYg==
X-Received: by 2002:a17:90b:4c88:: with SMTP id my8mr25217517pjb.49.1635217935137;
        Mon, 25 Oct 2021 20:12:15 -0700 (PDT)
Received: from [10.72.12.93] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v1sm7065024pfu.213.2021.10.25.20.12.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 20:12:14 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] ceph: return the real size readed when hit EOF
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20211020132813.543695-1-xiubli@redhat.com>
 <20211020132813.543695-4-xiubli@redhat.com>
 <77d0ebff15e86a05d4068982830222e1aed97a6b.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <a1646896-e8b3-212b-3123-3d0cf8fc1e91@redhat.com>
Date:   Tue, 26 Oct 2021 11:12:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <77d0ebff15e86a05d4068982830222e1aed97a6b.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/26/21 3:05 AM, Jeff Layton wrote:
> On Wed, 2021-10-20 at 21:28 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/file.c | 14 ++++++++------
>>   1 file changed, 8 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 74db403a4c35..1988e75ad4a2 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -910,6 +910,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>>   	ssize_t ret;
>>   	u64 off = *ki_pos;
>>   	u64 len = iov_iter_count(to);
>> +	u64 i_size = i_size_read(inode);
>>   
>>   	dout("sync_read on inode %p %llu~%u\n", inode, *ki_pos, (unsigned)len);
>>   
>> @@ -933,7 +934,6 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>>   		struct page **pages;
>>   		int num_pages;
>>   		size_t page_off;
>> -		u64 i_size;
>>   		bool more;
>>   		int idx;
>>   		size_t left;
>> @@ -980,7 +980,6 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>>   
>>   		ceph_osdc_put_request(req);
>>   
>> -		i_size = i_size_read(inode);
>>   		dout("sync_read %llu~%llu got %zd i_size %llu%s\n",
>>   		     off, len, ret, i_size, (more ? " MORE" : ""));
>>   
>> @@ -1056,11 +1055,14 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>>   	}
>>   
>>   	if (off > *ki_pos) {
>> -		if (ret >= 0 &&
>> -		    iov_iter_count(to) > 0 && off >= i_size_read(inode))
>> +		if (off >= i_size) {
>>   			*retry_op = CHECK_EOF;
>> -		ret = off - *ki_pos;
>> -		*ki_pos = off;
>> +			ret = i_size - *ki_pos;
>> +			*ki_pos = i_size;
>> +		} else {
>> +			ret = off - *ki_pos;
>> +			*ki_pos = off;
>> +		}
>>   	}
>>   out:
>>   	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);
> I'm guessing this is fixing a bug? Did you hit this in testing or did
> you just notice by inspection? Should we merge this in advance of the
> rest of the set?

This is one bug, when testing the fscrypt feature and I can reproduce it 
every time, in theory this bug should be seen in none fscrypt case.

I just send the V2 here in this series to show in which use case I hit 
this bug.

If it looks good I will post the V3 based the upstream code and add more 
comments on it.



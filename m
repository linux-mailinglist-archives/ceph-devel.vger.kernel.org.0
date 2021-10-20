Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAE9434347
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Oct 2021 04:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhJTCHG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Oct 2021 22:07:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32999 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229637AbhJTCHG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 22:07:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634695492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q8BHj75khUtnHbFt7SPqDyF+nENfognHeUJhvxJDoZg=;
        b=hNfG9JIQXwCIerXOletITneN4luyGDlyFF7jIFy3FpSUQbmTH3TguHcFkt4YU5s1+QSVQg
        afe5FL9GvroH9OW3KN+LhhI9eItcufUzfUK/FoIAwJvOSE2Ih740/RnU19+zmrrwS41yNN
        mfLN6zlpyda9SZ2FJHQGvO1IkefJ7nk=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-MmUO2OzhM8yqGALMGKC3dw-1; Tue, 19 Oct 2021 22:04:51 -0400
X-MC-Unique: MmUO2OzhM8yqGALMGKC3dw-1
Received: by mail-pg1-f200.google.com with SMTP id b6-20020a631b46000000b0029a054d00f3so2338266pgm.17
        for <ceph-devel@vger.kernel.org>; Tue, 19 Oct 2021 19:04:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=q8BHj75khUtnHbFt7SPqDyF+nENfognHeUJhvxJDoZg=;
        b=3cLkSiFuYHtczY9WAVW3irfb2rPJr2Pwj1iAHNTEtJP0+DJZMhJQlRSW/CgwtOGGm9
         +JylJL6mE5ZfWgCaNTMlvdgdRoiIMMRR0t4CsdPk1hRSwgpfjG3rkPf+rrQuF8rYmV72
         j4t+T3oEO5c4VH4Ey43kif7MwN/wCNw+mHRX9WJLeBLMGl+Mu+0CNQk4TLMXIU1H3umU
         R18iCRyWOhPID7yfPKEBDXUmKlk9w++PDaILwTq/y8pfGShgXY3DAiuMK5WlVL4uO0N5
         kLr31mP5zuyh5l7yVdkUKWwUFqtmLzBA6mo/W/KheHXm9nUz68FIBfuq2wyMEA+9hM2I
         nu6w==
X-Gm-Message-State: AOAM532LLo0U3P9rV+rnJO+QlZfCxWauNFMpzhyDGtLzjgOBypT594m8
        SKoTs1LLZFcEgaG/coO1XU6lH2AV1LLgsipRsRsiptvMxoLnKzEQA5zd3WWbyaxI8xpw8aGPhmZ
        IsyvCVVYhhVyIbqyk+oZ7PFuG5aAv376OF+d6IhBTanBGGJqpwsmhkH2quZ+2HwklL8+h7Kw=
X-Received: by 2002:aa7:94a8:0:b0:44c:f3e0:81fb with SMTP id a8-20020aa794a8000000b0044cf3e081fbmr3462299pfl.6.1634695489474;
        Tue, 19 Oct 2021 19:04:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGHQSTrWk4I9JjFnh6BqP45vmfM/dkjiQW9HNuIpBh5Emd+d2mrVIS2hGr4OClGVigDdvdRA==
X-Received: by 2002:aa7:94a8:0:b0:44c:f3e0:81fb with SMTP id a8-20020aa794a8000000b0044cf3e081fbmr3462257pfl.6.1634695489025;
        Tue, 19 Oct 2021 19:04:49 -0700 (PDT)
Received: from [10.72.12.135] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o72sm399430pjo.50.2021.10.19.19.04.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 19:04:48 -0700 (PDT)
Subject: Re: [PATCH] ceph: return the real size readed when hit EOF
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, khiremat@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20211019115138.414187-1-xiubli@redhat.com>
 <23269de451786354f33adc8a8f59a48c89748ddd.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <9026d15c-f238-c56d-1fa4-bf859847baec@redhat.com>
Date:   Wed, 20 Oct 2021 10:04:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <23269de451786354f33adc8a8f59a48c89748ddd.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/19/21 8:59 PM, Jeff Layton wrote:
> On Tue, 2021-10-19 at 19:51 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> At the same time set the ki_pos to the file size.
>>
> It would be good to put the comments in your follow up email into the
> patch description here, so that it explains what you're fixing and why.
Sure.
>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/file.c | 14 +++++++++-----
>>   1 file changed, 9 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 91173d3aa161..1abc3b591740 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -847,6 +847,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>>   	ssize_t ret;
>>   	u64 off = iocb->ki_pos;
>>   	u64 len = iov_iter_count(to);
>> +	u64 i_size = i_size_read(inode);
>>   
> Was there a reason to change where the i_size is fetched, or did you
> just not see the point in fetching it on each loop? I wonder if we can
> hit any races vs. truncates with this?

 From my reading from the code, it shouldn't.

While doing the truncate it will down_write(&inode->i_rwsem). And the 
sync read will hold down_read() it. It should be safe.

>
> Oh well, all of this non-buffered I/O seems somewhat racy anyway. ;)
>
>>   	dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
>>   	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
>> @@ -870,7 +871,6 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>>   		struct page **pages;
>>   		int num_pages;
>>   		size_t page_off;
>> -		u64 i_size;
>>   		bool more;
>>   		int idx;
>>   		size_t left;
>> @@ -909,7 +909,6 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>>   
>>   		ceph_osdc_put_request(req);
>>   
>> -		i_size = i_size_read(inode);
>>   		dout("sync_read %llu~%llu got %zd i_size %llu%s\n",
>>   		     off, len, ret, i_size, (more ? " MORE" : ""));
>>   
>> @@ -954,10 +953,15 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>>   
>>   	if (off > iocb->ki_pos) {
>>   		if (ret >= 0 &&
> Do we need to check ret here?

It seems this check makes no sense even in the following case I 
mentioned. Will check it more and try to remove it.


> I think that if ret < 0, then "off" must
> be smaller than "i_size", no?

 From current code, there has one case that it's no, such as if the file 
size is 10, and the ceph may return 4K contents and then the read length 
will be 4K too, and if it just fails in case:

                         copied = copy_page_to_iter(pages[idx++],
                                                    page_off, len, to);
                         off += copied;
                         left -= copied;
                         if (copied < len) {
                                 ret = -EFAULT;
                                 break;
                         }

And if the "copied = 1K" for some reasons, the "off" will be larger than 
the "i_size" but ret < 0.

BRs

Xiubo



>
>> -		    iov_iter_count(to) > 0 && off >= i_size_read(inode))
>> +		    iov_iter_count(to) > 0 &&
>> +		    off >= i_size_read(inode)) {
>>   			*retry_op = CHECK_EOF;
>> -		ret = off - iocb->ki_pos;
>> -		iocb->ki_pos = off;
>> +			ret = i_size - iocb->ki_pos;
>> +			iocb->ki_pos = i_size;
>> +		} else {
>> +			ret = off - iocb->ki_pos;
>> +			iocb->ki_pos = off;
>> +		}
>>   	}
>>   
>>   	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);


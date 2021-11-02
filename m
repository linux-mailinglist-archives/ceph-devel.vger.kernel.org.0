Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970924424F7
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Nov 2021 02:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbhKBBCz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Nov 2021 21:02:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57853 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229479AbhKBBCz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Nov 2021 21:02:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635814820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RNUx0+dqMlXMoYUd6I5hCx/Th8lTboqaJvCBqrQ/3w4=;
        b=JjhzomUhJ7ZapaDyUVf91VxE3vDKFABngou6pJ+9FYSCGHNQ6+tgBgVeXU0H6mB387O7dB
        RjY99spABkUrYwatOhDZ1g/oorAkUlBE+c+5d3Y62jnVAuz/ClglGFRPG44VDT1GXl8MNZ
        t0OfEkKaSUN9YpKYzK/mQoNmVh+/74g=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-kUjYXbs0NAmNax3gtIwqjQ-1; Mon, 01 Nov 2021 21:00:19 -0400
X-MC-Unique: kUjYXbs0NAmNax3gtIwqjQ-1
Received: by mail-pl1-f199.google.com with SMTP id e10-20020a17090301ca00b00141fbe2569dso1419973plh.14
        for <ceph-devel@vger.kernel.org>; Mon, 01 Nov 2021 18:00:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=RNUx0+dqMlXMoYUd6I5hCx/Th8lTboqaJvCBqrQ/3w4=;
        b=huYrs0COb8wHEH+tceJeHvUQLSMuB4K5G1t7TLdqD1DeR3IlL1Ot5dfqCgQZ9ZRTRX
         BM201N1JcgS+fHaiEaCQ46/sQ+9610df3BVCbHEuO0Xdl1dpc7f2/YRut4raAE3YwhN/
         AZZPm2qHbIg+hvbWmLhhGGW8CtCBuqNGhsLUKban5azXnbUbGOugkwJOQ7EEQNYq539P
         Li6aj6xyfwZ4Zna1Go2Q0ej8cO7YVCT3RWS6g1wJ2oRevMdbaXy7hWxtzPeY9mbf55xz
         ziHj40+c0nKFBQGdb6E126rso3dOkZRn2xQLYJps6akDkeSu035O8eBYP6muFXLt89Qo
         JzRw==
X-Gm-Message-State: AOAM532kaxmxyGY2+Lp1As1enSrvO0QyIFruVCXzSH6Rlj8fxK9uKcsj
        iqroXGEmSHSOPUDwhXlsrF4n/njiODZ8Z86zdgTaeB1Hv/3NBN6g0KMEbEQ8/VzSYazh/GGei9g
        chrWV9XX6zwq99uwlr/CXID6a2kW1kDCPQ+3mEiTQIG2rtAKsOuOyHvkh6IAhRN7XW9zCMfo=
X-Received: by 2002:a05:6a00:1787:b0:481:1503:e631 with SMTP id s7-20020a056a00178700b004811503e631mr7460410pfg.6.1635814817624;
        Mon, 01 Nov 2021 18:00:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzD7PnHVKMz7h9Z0UpYUE8xMGzEYA8Lczl6K/7vmadppf2eOVuhLMPCE3YXIuvK/dKSafMPew==
X-Received: by 2002:a05:6a00:1787:b0:481:1503:e631 with SMTP id s7-20020a056a00178700b004811503e631mr7460340pfg.6.1635814817123;
        Mon, 01 Nov 2021 18:00:17 -0700 (PDT)
Received: from [10.72.12.190] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z2sm17688591pfh.135.2021.11.01.18.00.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 18:00:16 -0700 (PDT)
Subject: Re: [PATCH v4] ceph: return the real size read when we it hits EOF
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211030051640.2402573-1-xiubli@redhat.com>
 <d33fc96c42be28d8e1aa330b6624c6dbc6ba788b.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c0e18da7-95df-bede-48f7-f24eac5bff3f@redhat.com>
Date:   Tue, 2 Nov 2021 09:00:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d33fc96c42be28d8e1aa330b6624c6dbc6ba788b.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/1/21 7:58 PM, Jeff Layton wrote:
> On Sat, 2021-10-30 at 13:16 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Currently, if we end up reading more from the last object in the file
>> than the i_size indicates then we'll end up returning the wrong length.
>> Ensure that we cap the returned length and pos at the EOF.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> Changed in V4:
>> - move the i_size_read() into the while loop and use the lastest i_size
>>    read to do the check at the end of ceph_sync_read().
>>
>>
>>   fs/ceph/file.c | 13 ++++++++-----
>>   1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 91173d3aa161..6005b430f6f7 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -847,6 +847,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>>   	ssize_t ret;
>>   	u64 off = iocb->ki_pos;
>>   	u64 len = iov_iter_count(to);
>> +	u64 i_size;
>>   
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
>> @@ -953,11 +953,14 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>>   	}
>>   
>>   	if (off > iocb->ki_pos) {
>> -		if (ret >= 0 &&
>> -		    iov_iter_count(to) > 0 && off >= i_size_read(inode))
>> +		if (off >= i_size) {
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
> Thanks, looks good. I dropped the two patches I had merged for this on
> Friday and merged this one instead.

Cool, thanks.



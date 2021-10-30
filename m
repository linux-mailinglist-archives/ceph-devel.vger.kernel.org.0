Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11131440778
	for <lists+ceph-devel@lfdr.de>; Sat, 30 Oct 2021 06:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhJ3Eh6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 30 Oct 2021 00:37:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:25388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229606AbhJ3Eh5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 00:37:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635568527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=knUTV09vcOgVhy4iDewDhlaMr89SbCFHqw8SbUqMW6c=;
        b=C9qmf/pKMJy8aviphOMwBxEj0D+G85txuvYenL2wQl1oHE4ccN2i/ZbA8bzoPe6EYwmLpx
        HsO5spGH5ZxQCGSWvPdwb9ln2kOPZZCzMzDY+cbAtLnkkQMNEvdCNyeM1n3jo2EwsXaqSG
        MyQzyy5QHVtMFnPqkDvMdmDIbJCCN5I=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-07p04AyVPw-b3Fdyuha-ew-1; Sat, 30 Oct 2021 00:35:25 -0400
X-MC-Unique: 07p04AyVPw-b3Fdyuha-ew-1
Received: by mail-pj1-f72.google.com with SMTP id mn13-20020a17090b188d00b001a64f277c1eso1060971pjb.2
        for <ceph-devel@vger.kernel.org>; Fri, 29 Oct 2021 21:35:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=knUTV09vcOgVhy4iDewDhlaMr89SbCFHqw8SbUqMW6c=;
        b=3/lrSl5Qf2JkGdgz8RlCV9aKJwWP9m0tLyclcVvB+UGZq4DY/K2qQlnKzt0RHc9H+o
         Sgg2GfR7g1kaGHPbd2QQ/9q6dkaDRPgzbf/wa1HL7kulnb15DSCAkls2BLODPzZTuaFV
         HGfT440SJOmreMBDzw2OAuRFp/Q9tl3EBE10MZ4SdhkH+hAQvcKhX2YgWJ5Gor+4dcNO
         Dim5PNJnLxlgddm9Z+Wo/CwSKMZMO3dlz3YWEs/ib/h4XOGVDSnO2751uf1wXQFZbz93
         IjbjIvNS/2CvP8YgP76IAlyQfx0sj9T8cbg/XMpBfuLe0UmiKPquCHSHWeSknwTCN+pY
         Uo7g==
X-Gm-Message-State: AOAM532j7AOmmJOL2ohD+3ikFmdHxMTa+5Eg7QRX5fdzMao02ZlGjKSy
        3x+lcwWQs5e9NyW39IGjKkrhtJKLX8pe4Th68lhqU7S0Kmr8afTBZc5CQCQcQON41rLyc+hpblU
        04srL8r6W4d3I7WgyG/Msq2jO6hrQO8szabIQJHjs/TTzAg19SwUV282gV/ykNMR5O44YYMo=
X-Received: by 2002:a63:131c:: with SMTP id i28mr11153078pgl.396.1635568523872;
        Fri, 29 Oct 2021 21:35:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcZMkJG3+NlJ4z62TKPCX4WvC0ZGjLY2EBLMukqqyZD0gp4CxuAk4/p8moltZX6artnnDH2A==
X-Received: by 2002:a63:131c:: with SMTP id i28mr11153055pgl.396.1635568523517;
        Fri, 29 Oct 2021 21:35:23 -0700 (PDT)
Received: from [10.72.12.190] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x13sm6766893pgt.80.2021.10.29.21.35.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 21:35:23 -0700 (PDT)
Subject: Re: [PATCH v3 3/4] ceph: return the real size readed when hit EOF
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211028091438.21402-1-xiubli@redhat.com>
 <20211028091438.21402-4-xiubli@redhat.com>
 <22c0b605e1423cd0e884d87a8538278902dc91c1.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <214ae105-5eb7-5a24-6923-7e6bae084d79@redhat.com>
Date:   Sat, 30 Oct 2021 12:35:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <22c0b605e1423cd0e884d87a8538278902dc91c1.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/29/21 2:11 AM, Jeff Layton wrote:
> On Thu, 2021-10-28 at 17:14 +0800, xiubli@redhat.com wrote:
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
> I wonder a little about removing this i_size fetch. Then again, the
> i_size could change any time after we fetch it so it doesn't seem
> worthwhile to do so.

I checked the code again. There has 2 ways to change the inode size, 
which are writing a file and truncating the size. Both this are safe by 
protecting by 'inode->i_rwsem' and FILE caps.

If there has no any other will do this in MDS side, such as when doing a 
file recovery, which I don't think it will.

I will add it back for now.

>
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
> I think I'll go ahead and pull this patch into the testing branch, since
> it seems to be correct.
>
> Thanks!


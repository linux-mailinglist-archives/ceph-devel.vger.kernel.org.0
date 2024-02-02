Return-Path: <ceph-devel+bounces-794-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 27385846521
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Feb 2024 01:45:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D3E31C2404E
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Feb 2024 00:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4ECD46AA;
	Fri,  2 Feb 2024 00:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TDIFwc9e"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE93453A1
	for <ceph-devel@vger.kernel.org>; Fri,  2 Feb 2024 00:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706834727; cv=none; b=bRF0EMPEoH+yyadcUbRx+cRF80xjXVcGmt0gtt8srmvWZHUKc3VysaZxxdDt+Y0u4OORFxMQ/RIJaixZxctCUB4F1tbzSV8dfYxlhhc2fnUBG2epSDIVP0fbzEyhOd6KtPUJ7stRv0+d9IMQv4o36ZWlZG4F259LR7GmfnH6rLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706834727; c=relaxed/simple;
	bh=KAnZTezKPNqTAaQ74YI69Ct86u4wacl4z+jLTtzc2fc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O06heTCu1EGJ/LKTl1A36e7rPFO+lEH5g8uo29QpKp9WfLe4iL14Qwi94gVMYNJf0zr/J3BLyQ2e/6W47gXrOkF3VhtWHJncKzwTq6DazPp3lbVnOCLrHXE9hyErY3+AU/UkIglXhjQCHjm+rl5Q8xUFGqEXVDK3EdktMRzmCxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TDIFwc9e; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706834721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bvXEfUrBBrxIlN/ouZLvOFJcZy2T71X1ec3DP8V0itE=;
	b=TDIFwc9eMcWbaaMP4/OdcgDVrycMK6xSXf61egN/CzD6C5D7Aof1Q8U3rMJ16043m6d1+2
	/BxncUikqYl6+N/4mE+NtxTObgJdLjkhuXURerbBpkFvFziXcEORTB1gdkf/S2CrRLIHrm
	1znCKzp0RrIPtOLCC1R9NPPTTJvbsJ8=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-pFYGE_dUNW2Cvu6oAnx7iQ-1; Thu, 01 Feb 2024 19:45:19 -0500
X-MC-Unique: pFYGE_dUNW2Cvu6oAnx7iQ-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-6ddcec40883so1457513b3a.2
        for <ceph-devel@vger.kernel.org>; Thu, 01 Feb 2024 16:45:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706834718; x=1707439518;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bvXEfUrBBrxIlN/ouZLvOFJcZy2T71X1ec3DP8V0itE=;
        b=m8POlDfkl6tWVVLutPLe1zRMC4reon9VjzrP87hd5U/lAF27lW0UQ0SIIwokclGp6f
         Px4KArNa+syQSxIeoxSSJ/G8eoQuo28Din4Xlz3eTm9F/fT2lhZL14zp2MYQKsi+bFuE
         m/ReXrl4ucp1946KqDzOSvvZQMWEEushCVBj7gSuu+zAf41kkhjlsnIB/0KWL7G7YWJt
         BZI8YfSOUhv14baiuijlHC2JYOd9XUUQC4Nxttm20G0gD95fZDUXsTS9S5VFWpkTeFFU
         bGzsxiF4k5KTrCdWinQfltNQbZ9xlUHZ71Nsbnl99ag8oXqrhMgAiVlD5o+PiZFG6raA
         mymA==
X-Gm-Message-State: AOJu0YwPkULLoentA9EsUFsuBD92qvnxz037dpJ+Nd2JPxXxSgZBhHDZ
	wMuK7e1lEXSS5I9YFTBMkvPt9KMr21/hLB1UT8Zc1yD45slvOPkDQURFjl9JNbZP3X9mOu9smzg
	RqpwqvHebXz7vrn8qKjR/xYWAU5UHCijC996fueU3R2mRbD3xSgvn0pufKjeG+DlOmws=
X-Received: by 2002:a62:ce04:0:b0:6df:b80c:8d8d with SMTP id y4-20020a62ce04000000b006dfb80c8d8dmr3527657pfg.28.1706834717817;
        Thu, 01 Feb 2024 16:45:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFABFug/5hoyUNxCxfcjAnJcCSUESiXQBBxKXa2iRdsV7fXFEeiobZ7ruJDnc/K0wQAAtvp4A==
X-Received: by 2002:a62:ce04:0:b0:6df:b80c:8d8d with SMTP id y4-20020a62ce04000000b006dfb80c8d8dmr3527645pfg.28.1706834717468;
        Thu, 01 Feb 2024 16:45:17 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXkeGuHABLBle3CRlX5T2UktWIwwNhH5tvhrsXroI2C+J8zhUYHLnJ3MMshiTQnVNqcgkYWLMFYOe4eJRjNbK08IQ6QGnqnIyFQwksJdqCElfKzDdRm3RtA44pq2spxwW+3Uy8ou/EuWRRsHb9cKB4UrWTNv/IrDYy0t0dgZ67V3l+R0TbbW7dwhYPvv2uUg9zhqQC6A26mSYhdp9dMpXU=
Received: from [10.72.112.116] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id r3-20020a62e403000000b006dfedc6a443sm349936pfh.133.2024.02.01.16.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 16:45:17 -0800 (PST)
Message-ID: <baa1d0ce-6555-417e-acb8-af506656c0d9@redhat.com>
Date: Fri, 2 Feb 2024 08:45:11 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ceph: increment refcount before usage
Content-Language: en-US
To: Jeff Layton <jlayton@kernel.org>, ridave@redhat.com,
 ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com, vshankar@redhat.com, mchangir@redhat.com,
 rishabhddave@gmail.com
References: <20240201113716.27131-1-ridave@redhat.com>
 <91639fbcae958dc096db91c29848681293572686.camel@kernel.org>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <91639fbcae958dc096db91c29848681293572686.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/1/24 21:57, Jeff Layton wrote:
> On Thu, 2024-02-01 at 17:07 +0530, ridave@redhat.com wrote:
>> From: Rishabh Dave <ridave@redhat.com>
>>
>> In fs/ceph/caps.c, in "encode_cap_msg()", "use after free" error was
>> caught by KASAN at this line - 'ceph_buffer_get(arg->xattr_buf);'. This
>> implies before the refcount could be increment here, it was freed.
>>
>> In same file, in "handle_cap_grant()" refcount is decremented by this
>> line - "ceph_buffer_put(ci->i_xattrs.blob);". It appears that a race
>> occurred and resource was freed by the latter line before the former
>> line
>> could increment it.
>>
>> encode_cap_msg() is called by __send_cap() and __send_cap() is called by
>> ceph_check_caps() after calling __prep_cap(). __prep_cap() is where
>> "arg->xattr_buf" is assigned to "ci->i_xattrs.blob" . This is the spot
>> where the refcount must be increased to prevent "use after free" error.
>>
>> URL: https://tracker.ceph.com/issues/59259
>> Signed-off-by: Rishabh Dave <ridave@redhat.com>
>> ---
>>   fs/ceph/caps.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 5501c86b337d..0ca7dce48172 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -1452,7 +1452,7 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
>>   	if (flushing & CEPH_CAP_XATTR_EXCL) {
>>   		arg->old_xattr_buf = __ceph_build_xattrs_blob(ci);
>>   		arg->xattr_version = ci->i_xattrs.version;
>> -		arg->xattr_buf = ci->i_xattrs.blob;
>> +		arg->xattr_buf = ceph_buffer_get(ci->i_xattrs.blob);
>>   	} else {
>>   		arg->xattr_buf = NULL;
>>   		arg->old_xattr_buf = NULL;
>> @@ -1553,6 +1553,7 @@ static void __send_cap(struct cap_msg_args *arg, struct ceph_inode_info *ci)
>>   	encode_cap_msg(msg, arg);
>>   	ceph_con_send(&arg->session->s_con, msg);
>>   	ceph_buffer_put(arg->old_xattr_buf);
>> +	ceph_buffer_put(arg->xattr_buf);
>>   	if (arg->wake)
>>   		wake_up_all(&ci->i_cap_wq);
>>   }

Looks good to me.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


> Nice catch!
>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
>
Thanks Jeff.

- Xiubo




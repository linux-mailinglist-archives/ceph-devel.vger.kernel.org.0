Return-Path: <ceph-devel+bounces-658-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B307383B6F9
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jan 2024 03:01:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E59D31C225EF
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jan 2024 02:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F09FE139C;
	Thu, 25 Jan 2024 02:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ansQRHzR"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EED817C2
	for <ceph-devel@vger.kernel.org>; Thu, 25 Jan 2024 02:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706148093; cv=none; b=CsurEaregsd3eiopnQOUUk5LAaYeuFiv4DuEcp69uwTD3GNuiOGwPXn6bEfSvqL2l644Sg4y7Prp4FZCn4jTC3TMEb2nZBeOKIfTMGM7d4iyZduKSDwtW+fvciqgzT0z4abKjY+wORnmzRWNVZi/0gLazCPNAozAydaW0KvcXg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706148093; c=relaxed/simple;
	bh=n8GEHUdf4wsm8ufFP5L+4yFPXnHIsNh5JKTC5cCIkTM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I/q/Ihm58Q1+ahzfwix5qdyCU1VfcpwtvydOgzFbn4+T+UTgC7I3nvUT2h3mr2H5kOtugWrvl/Msf2lbFZzqpwEL0PZBbkB1DsY7H988LZNH4+Sobp7Pao4xyMfn6ykqPa4Vf1uQ2GfSKVtYMtna3Wse2V3xIPMtJ7YFCYdjVMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ansQRHzR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706148090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bgaYjQP1v6vE0SUPFnXtmi7bMTdYgV89YYO7/n9rhgk=;
	b=ansQRHzREA6aB0y6VF2d13AGtZrdogbSSlYnioKSbSeCmvmrOeegeYpNHoU/uMpuVOJPnq
	x18hFpGyKsU/xD+alu7x5/DzKazGNeuPXu+SyZ40jT1x/o/ZFGHoDLbUoLkz9kHKsDMjgU
	BExG6OsM7b+AH/bAcfyNE8yLbItBpQc=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-l8HQUt15MZmgEu8JAeMEQw-1; Wed, 24 Jan 2024 21:01:27 -0500
X-MC-Unique: l8HQUt15MZmgEu8JAeMEQw-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-290f607c1dfso889712a91.3
        for <ceph-devel@vger.kernel.org>; Wed, 24 Jan 2024 18:01:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706148086; x=1706752886;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bgaYjQP1v6vE0SUPFnXtmi7bMTdYgV89YYO7/n9rhgk=;
        b=MRryotRKsyLZFQOKN4RrbIATdRaVVp9pDjnnzPSlojjRS0q00dthew21vptzf0kQRM
         C6c1WOpWAjtbK0nEaO8EQXjFk6GLwzmh89TTf2z4dsjaxbsTwFoAvpvih/jTOhfWs/lV
         peM+ksKTXS8LcEFZToD7SOIFGBF14uUt1Z905qjXugrZ9wPvNqLZ8Y6vUGRYHxuvw0KK
         aTt69YyWi2bhZkqitAM6vkoSmHn4UTXDNLKgJWoASsI0c6qiozGzvwKXXvKwiGO2H8Ma
         GwhG64fJa9/fLPyTCKFp2kilOYCxHiy8Q8ov3fp9AYpMmHuXg/7fud1AqDqpEmCNYif9
         Ed3A==
X-Gm-Message-State: AOJu0YxPZITyQ0/9S/MxncNCaTztdf2W6jLSJZtoZb7wvQxZ343tXTgf
	AubPxaBhjPCtI0cdYAfinONopwLWAojytUR3c4tOQFCj01cPlvPKOj75WvG4n2xtmCp2n18qzOC
	0YdE7huYcvujSyYqnFQuwKjiEsB3qGiWFO2K6Wr2C8BOD/+fDR61PiGiBTAg=
X-Received: by 2002:a17:90a:fd02:b0:290:91b8:d146 with SMTP id cv2-20020a17090afd0200b0029091b8d146mr77226pjb.68.1706148086556;
        Wed, 24 Jan 2024 18:01:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEoWFOoNuC5mzL6wKnPUwmC7u5FH3FH6RgvsJH1YFJmleNCS/MZo9JYNO6ezViWWpvOFCw4Sw==
X-Received: by 2002:a17:90a:fd02:b0:290:91b8:d146 with SMTP id cv2-20020a17090afd0200b0029091b8d146mr77218pjb.68.1706148086224;
        Wed, 24 Jan 2024 18:01:26 -0800 (PST)
Received: from [10.72.112.211] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d11-20020a17090ac24b00b00290f8c708d0sm318090pjx.57.2024.01.24.18.01.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jan 2024 18:01:25 -0800 (PST)
Message-ID: <cedd83f2-de68-4733-92bb-5514440b40a2@redhat.com>
Date: Thu, 25 Jan 2024 10:01:20 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ceph: always set the initial i_blkbits to
 CEPH_FSCRYPT_BLOCK_SHIFT
Content-Language: en-US
To: Eric Biggers <ebiggers@kernel.org>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org,
 vshankar@redhat.com, mchangir@redhat.com
References: <20240118080404.783677-1-xiubli@redhat.com>
 <20240125015305.GG1088@sol.localdomain>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240125015305.GG1088@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/25/24 09:53, Eric Biggers wrote:
> On Thu, Jan 18, 2024 at 04:04:04PM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The fscrypt code will use i_blkbits to setup the 'ci_data_unit_bits'
>> when allocating the new inode, but ceph will initiate i_blkbits
>> ater when filling the inode, which is too late. Since the
>> 'ci_data_unit_bits' will only be used by the fscrypt framework so
>> initiating i_blkbits with CEPH_FSCRYPT_BLOCK_SHIFT is safe.
>>
>> Fixes: commit 5b1188847180 ("fscrypt: support crypto data unit size
>>         less than filesystem block size")
> The Fixes line should be one line, and the word "commit" should not be there

Sure, I will fix it.

>> URL: https://tracker.ceph.com/issues/64035
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/inode.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index 62af452cdba4..d96d97b31f68 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -79,6 +79,8 @@ struct inode *ceph_new_inode(struct inode *dir, struct dentry *dentry,
>>   	if (!inode)
>>   		return ERR_PTR(-ENOMEM);
>>   
>> +	inode->i_blkbits = CEPH_FSCRYPT_BLOCK_SHIFT;
>> +
>>   	if (!S_ISLNK(*mode)) {
>>   		err = ceph_pre_init_acls(dir, mode, as_ctx);
>>   		if (err < 0)
> Looks good, you can add:
>
>      Reviewed-by: Eric Biggers <ebiggers@google.com>
>
> Sorry for the trouble; I need to start running xfstests on CephFS!
Thanks Eric, no worry, this will only be seen when the 
'test_dummy_encryption' is enabled.
> In the future please also Cc the fscrypt mailing list on things like this.

Sure, I meant to Cc you but I think I forgot that. Sorry.

> Maybe you'd like to also send a patch that updates the comment for
> fscrypt_prepare_new_inode() to clarify that i_blkbits needs to be set first?

Will fix it.

Thanks Eric.

- Xiubo


> - Eric
>



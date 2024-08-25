Return-Path: <ceph-devel+bounces-1762-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A95795E5E0
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Aug 2024 01:54:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC2B4B20B8E
	for <lists+ceph-devel@lfdr.de>; Sun, 25 Aug 2024 23:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AA6E81AB1;
	Sun, 25 Aug 2024 23:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O4N6uRRR"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC9780BF8
	for <ceph-devel@vger.kernel.org>; Sun, 25 Aug 2024 23:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724630039; cv=none; b=qNPg1wl/RgmEztE6H/dGVYvycTa5oH3jnN771phpBZFJkIwV+FS8u/NwzmEPjVDcrqTLIBmW2LcPId70xtNFUkl2cksVAyp7C57wmzbmlQzWSe2en0zWwBc9hvDUsI79632USRItZ310wEPJCFnWJAdN4S3t10rjWpDfP2zPU8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724630039; c=relaxed/simple;
	bh=/jfi1UGgEAx2E3NPgZPiSFl8NXLitbux5PTBNSOGt3o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M2/0qrULmvIJPz+2if4YSANbw8UOZSxTuUa1ZujbHqdNLmDs9GMe/CryEZfR6EjKnj/juExBP9ObwNUniK5kfHCxFOSe6E5x4uMqNw7+arXubhV1gBkRBbxOssbHCVbX12pP6RW+SXBdIDvII3yUJsP3tTulj0qihjs2Rp3PcW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O4N6uRRR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724630035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FW18elXa1PhYvbUZkR95eV9DtxD/XfPxDPcUtrQxbZE=;
	b=O4N6uRRR/LW3i+nlERxDO6+qLjF92A4GzJNShBWBPprKNXWA7r/KzWBG4ypmFr5vhprbKc
	ye6jDjBXpSX995LiCuwYRNMvhb0s4d5wLtOngxZIsVVtcLakvYzlO90w3N7WfK27Tc4s6W
	ZqS9Qx3W8adwwNhy4Rii74F1CF2styM=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-ZAsIHSPcMe2MJzWgIsWP4Q-1; Sun, 25 Aug 2024 19:53:49 -0400
X-MC-Unique: ZAsIHSPcMe2MJzWgIsWP4Q-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-7144c67e3d0so1877022b3a.0
        for <ceph-devel@vger.kernel.org>; Sun, 25 Aug 2024 16:53:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724630029; x=1725234829;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FW18elXa1PhYvbUZkR95eV9DtxD/XfPxDPcUtrQxbZE=;
        b=UzOvl2+Cdzzm6sOOd60TIUre/+JLMGYua0yiBEd8MOtLFJix6FyLgDDXd8as2cUxcU
         dl+T33c09S63lnkB1c3A7hYx32BTnN/ph53mkSSlvTBXuK8CsKFjScx2xai2jKTFg8ud
         NWlK4a/IJ3IPnyvDz35w1gF9DQC/bcfKYP4MiwrRDOeQAr6OleVPJQVarUSlHqdg2mZS
         1gEfxBkwR5ouT0RrIZgP6+/u/zHYHo/SLk1zGbvIXyiedaIlmBX9lDvm3bPBkDEWBkLP
         4AzyiMAqOfh92OzHyVzODhQ6FntCE5gUcojss0cGiJjnpkirsbMWh4vRC+jSZnx3uRs8
         aJNA==
X-Forwarded-Encrypted: i=1; AJvYcCUZSV8KELBIqNJlH1O/GbaqoCyobv/PMJA1rXvEfG/83V2PWVHANstkOFpuoCr1Mp3/rYFMPNXqjd2m@vger.kernel.org
X-Gm-Message-State: AOJu0YxdPutNDOMbBNVNNVM89fM0Y5XH7mOBqF08mgbB9ujFG8j+JVuH
	mReEmYa75gQZ+DGZSwcTouU0FxmlWCrg+reMPyKdTOeKHGjs4d7ZzzPCpsjZ3CokCRj0SOWVl47
	/3uW3ksPdkAHNK+ivK21EuAGGHo89TacpuGSuFt6ImTrsRPip7SXUxqIjkXg=
X-Received: by 2002:a05:6a00:2d0b:b0:714:1fc3:79fb with SMTP id d2e1a72fcca58-7144540ab0cmr7515861b3a.0.1724630028764;
        Sun, 25 Aug 2024 16:53:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGiv9eNyjz/UETJQTU03gyC94z2vtKnzutSo7W0XpyfUyN2ZZAGiHRtFYSZYJBE/zl6rX3jJA==
X-Received: by 2002:a05:6a00:2d0b:b0:714:1fc3:79fb with SMTP id d2e1a72fcca58-7144540ab0cmr7515856b3a.0.1724630028267;
        Sun, 25 Aug 2024 16:53:48 -0700 (PDT)
Received: from [10.72.116.17] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-714342ffde2sm6304421b3a.145.2024.08.25.16.53.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Aug 2024 16:53:47 -0700 (PDT)
Message-ID: <d1668ff4-0aac-4727-9886-2f04c5f1104f@redhat.com>
Date: Mon, 26 Aug 2024 07:53:43 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] ceph: fix out-of-bound array access when doing a file
 read
To: Luis Henriques <luis.henriques@linux.dev>
Cc: Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240822150113.14274-1-luis.henriques@linux.dev>
 <0205e0b6-fad9-4519-adec-f1d1b30d9ef9@redhat.com> <87ikvrhfa7.fsf@linux.dev>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <87ikvrhfa7.fsf@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/23/24 15:25, Luis Henriques wrote:
> On Fri, Aug 23 2024, Xiubo Li wrote:
>
>> On 8/22/24 23:01, Luis Henriques (SUSE) wrote:
>>> If, while doing a read, the inode is updated and the size is set to zero,
>>> __ceph_sync_read() may not be able to handle it.  It is thus easy to hit a
>>> NULL pointer dereferrence by continuously reading a file while, on another
>>> client, we keep truncating and writing new data into it.
>>>
>>> This patch fixes the issue by adding extra checks to avoid integer overflows
>>> for the case of a zero size inode.  This will prevent the loop doing page
>>> copies from running and thus accessing the pages[] array beyond num_pages.
>>>
>>> Link: https://tracker.ceph.com/issues/67524
>>> Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
>>> ---
>>> Hi!
>>>
>>> Please note that this patch is only lightly tested and, to be honest, I'm
>>> not sure if this is the correct way to fix this bug.  For example, if the
>>> inode size is 0, then maybe ceph_osdc_wait_request() should have returned
>>> 0 and the problem would be solved.  However, it seems to be returning the
>>> size of the reply message and that's not something easy to change.  Or maybe
>>> I'm just reading it wrong.  Anyway, this is just an RFC to see if there's
>>> other ideas.
>>>
>>> Also, the tracker contains a simple testcase for crashing the client.
>>>
>>>    fs/ceph/file.c | 7 ++++---
>>>    1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>> index 4b8d59ebda00..dc23d5e5b11e 100644
>>> --- a/fs/ceph/file.c
>>> +++ b/fs/ceph/file.c
>>> @@ -1200,9 +1200,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>>>    		}
>>>      		idx = 0;
>>> -		if (ret <= 0)
>>> +		if ((ret <= 0) || (i_size == 0))
>> Hi Luis,
>>
>> This change looks incorrect to me.
>>
>> As I mentioned before when the 'IFILE' lock is in MIX state the 'Frw' caps could
>> be issued to multiple clients at the same time. Which means the file could be
>> updated by another client and the local 'i_size' may haven't been changed in
>> time. So in this case the 'ret' will be larger than '0' and the 'i_size' could
>> be '0'.
>>
>>
>>>    			left = 0;
>>> -		else if (off + ret > i_size)
>>> +		else if ((i_size >= off) && (off + ret > i_size))
>> And the 'off' also could equal to little than the 'i_size'.
>>
>> BTW, could you reproduce the crash issue ?
> Yes, 100% reproducible :-)
>
> See https://tracker.ceph.com/issues/67524

Okay, Let me have a try about this.

Thanks


>
> Cheers,



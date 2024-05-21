Return-Path: <ceph-devel+bounces-1155-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 219248CA95F
	for <lists+ceph-devel@lfdr.de>; Tue, 21 May 2024 09:52:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBF822842A9
	for <lists+ceph-devel@lfdr.de>; Tue, 21 May 2024 07:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 222D650246;
	Tue, 21 May 2024 07:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TsvZHtbM"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC54A42056
	for <ceph-devel@vger.kernel.org>; Tue, 21 May 2024 07:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716277913; cv=none; b=QAWkbHxsv4sNrnmm02O6Y9lKKBbfUsj7cDUgvLzA5sjylCgUtaf+xMesTljzphVT2lphr1asRYZuwwdPTlrglo1qD77u0553E6HZR6zsv4yKNCKsR4v42Qu9FMJWVifRA4K2xDkZ9zQbrmwnuqeT3c0TAjoBm1fjhsCVkMOz74o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716277913; c=relaxed/simple;
	bh=P5S+dDc7FjqNXA/Znt5awnRWFyBolxLKR0nbj+a8NKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iTFwfEU/n4heocgPcZs9gthNTk6D4+x8CzDTX77hOkMmEIQ1+oP1ZRA7SG9hFoMfCY/G2i2YbTHwLHEnU7SMNG4E1Tqztysy5b3aZdFdCMfVsBKl06/yW/2h6Yjw+q62P/tV/JIrD8Zem67VA5Zb9uGakMUmqi3eWM6LBPMN5E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TsvZHtbM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716277910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l2lN89T+kEMbDN3A3E/nvo4OKezgH7lzxlXGE3HYScA=;
	b=TsvZHtbMnvLQmTwQ8TELKt8HRz5Ao4R0NP+C9XH/mHgKboH0QlV/3zJ1Y7MD0AhFTV1RyC
	sUrsheH2xWipnmWmTxG4LXbF4fStek1Xm+2W3xgOF5c//zq33+ZsrG3I1GvhVfhZBF9WRD
	g6CMmhzT9Q60jYcGb7y6/ICX+Radu8U=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-EQ-Z4KKwOOig-B760q8WTg-1; Tue, 21 May 2024 03:51:49 -0400
X-MC-Unique: EQ-Z4KKwOOig-B760q8WTg-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1ee0caec57fso117693815ad.3
        for <ceph-devel@vger.kernel.org>; Tue, 21 May 2024 00:51:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716277908; x=1716882708;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l2lN89T+kEMbDN3A3E/nvo4OKezgH7lzxlXGE3HYScA=;
        b=Ma8sHV04ooAeXYZP298nNCY/nBCrF52+X+2IsGDirbEgUb39Ep4rg0A0GObipWVc/R
         kh0Thzjfge4mJYaoZsHP7LMyuTTRp8L2BBNGO/e/NpzmU4akfaa2boc/yJl/R/TBcW0m
         yTLs8hmyfyffqxdBVmd5IVj2k9UpTQVJaFUs9Qow3oBmCrwzUic3y5WVRrWNPxkKJ31l
         fI5j1qsqb4qGTy2bzi7gsoBd2Z0CZYq9yPgKusprMfuZmbU0bxwNkV/OvU0NIZri8Ja+
         pYgqSHTm8e7ZbvJYgnu+pd/XjPlbINSuH781CCCJpj1f788TupJ580ITYwSpmyUWpZjW
         Gqrg==
X-Gm-Message-State: AOJu0YxWGQYSXNhT+Y37DA/bW2k27ju+Td51N3fbCFPJrDax3/WNPtjE
	I5ewNVeZ+B9Zmqgn4DwDJUvuZS+UvFNh5mS5pPnC8QyLz6ZsC5Gy1FarQXb+ipGJYKQXJbHGdc8
	nynZZmOMsQ8hkroSJncSjbomzPFcQrK8IdoHkWU+kGqrMdwen3w0X8IrrEAg=
X-Received: by 2002:a17:902:e5ce:b0:1f2:fbf7:959f with SMTP id d9443c01a7336-1f2fbf797f5mr64762085ad.14.1716277908012;
        Tue, 21 May 2024 00:51:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWS3xfpLGyvosTTG1/z001SCm8TFTMxm/tM7XESYmsA+kwDBEuA9ixUlJhk+OAHLaji0j/Lg==
X-Received: by 2002:a17:902:e5ce:b0:1f2:fbf7:959f with SMTP id d9443c01a7336-1f2fbf797f5mr64761925ad.14.1716277907598;
        Tue, 21 May 2024 00:51:47 -0700 (PDT)
Received: from [10.72.116.32] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0bad6386sm215668625ad.80.2024.05.21.00.51.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 May 2024 00:51:47 -0700 (PDT)
Message-ID: <257ce582-a2f2-4ed8-bdc9-9c9ffa1032d9@redhat.com>
Date: Tue, 21 May 2024 15:51:43 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ceph: make the ceph-cap workqueue UNBOUND
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com,
 mchangir@redhat.com, Stefan Kooman <stefan@bit.nl>
References: <20240321021536.64693-1-xiubli@redhat.com>
 <CAOi1vP-RdbfmBAku9j104osphc3tk4zgbG-=eQ5yTz1a9s4e=g@mail.gmail.com>
 <56c20af2-bf22-4cc2-b0db-637a51511c12@redhat.com>
 <CAOi1vP9V0hnoFnH_yKxPnPTHqZdxX=Y--QkGr_28C7075pMxFQ@mail.gmail.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP9V0hnoFnH_yKxPnPTHqZdxX=Y--QkGr_28C7075pMxFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 5/21/24 15:39, Ilya Dryomov wrote:
> On Tue, May 21, 2024 at 5:37 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 5/21/24 03:37, Ilya Dryomov wrote:
>>
>> On Thu, Mar 21, 2024 at 3:18 AM <xiubli@redhat.com> wrote:
>>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> There is not harm to mark the ceph-cap workqueue unbounded, just
>> like we do in ceph-inode workqueue.
>>
>> URL: https://www.spinics.net/lists/ceph-users/msg78775.html
>> URL: https://tracker.ceph.com/issues/64977
>> Reported-by: Stefan Kooman <stefan@bit.nl>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/super.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index 4dcbbaa297f6..0bfe4f8418fd 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -851,7 +851,7 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
>>          fsc->inode_wq = alloc_workqueue("ceph-inode", WQ_UNBOUND, 0);
>>          if (!fsc->inode_wq)
>>                  goto fail_client;
>> -       fsc->cap_wq = alloc_workqueue("ceph-cap", 0, 1);
>> +       fsc->cap_wq = alloc_workqueue("ceph-cap", WQ_UNBOUND, 1);
>>
>> Hi Xiubo,
>>
>> You wrote that there is no harm in making ceph-cap workqueue unbound,
>> but, if it's made unbound, it would be almost the same as ceph-inode
>> workqueue.  The only difference would be that max_active parameter for
>> ceph-cap workqueue is 1 instead of 0 (i.e. some default which is pretty
>> high).  Given that max_active is interpreted as a per-CPU number even
>> for unbound workqueues, up to $NUM_CPUS work items submitted to
>> ceph-cap workqueue could still be active in a system.
>>
>> Does CephFS need/rely on $NUM_CPUS limit sowewhere?  If not, how about
>> removing ceph-cap workqueue and submitting its work items to ceph-inode
>> workqueue instead?
>>
>> Checked it again and found that an UNBOUND and max_active==1 combo has a special meaning:
>>
>> Some users depend on the strict execution ordering of ST wq. The combination of @max_active of 1 and WQ_UNBOUND is used to achieve this behavior. Work items on such wq are always queued to the unbound worker-pools and only one work item can be active at any given time thus achieving the same ordering property as ST wq.
> This hasn't been true for 10 years, see commit
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3bc1e711c26bff01d41ad71145ecb8dcb4412576

Okay, I found the doc I read is out of date.

- Xiubo

> Thanks,
>
>                  Ilya
>



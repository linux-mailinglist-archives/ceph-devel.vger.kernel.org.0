Return-Path: <ceph-devel+bounces-98-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B6E77ED9D7
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Nov 2023 04:07:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6DD61C208CA
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Nov 2023 03:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DC215686;
	Thu, 16 Nov 2023 03:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KsxV6tlc"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC52A199
	for <ceph-devel@vger.kernel.org>; Wed, 15 Nov 2023 19:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700104019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m0gSEf7JiRv42BybUzT0POwhSlpfuDNjghSiOqfLdfM=;
	b=KsxV6tlcKM+07/hn/yKn450ue1V3KKcGU7nsXIWhIi4KodlxT8aea5TNx3kTPawZYJunqA
	g2qaMW83Ng7ZGrWAke3Mb9EVn5IWAzoVf3WtMJoFh6qL3blKUS7FD0OiqxjlA0b0j7FAFN
	9jziQMfSbqQQ/cBHcTDL1AhlO+CwT8g=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-ZVbb7Bz9Ms-7qu0aNtkZ1A-1; Wed, 15 Nov 2023 22:06:58 -0500
X-MC-Unique: ZVbb7Bz9Ms-7qu0aNtkZ1A-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-589d544dc87so336874eaf.1
        for <ceph-devel@vger.kernel.org>; Wed, 15 Nov 2023 19:06:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700104018; x=1700708818;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m0gSEf7JiRv42BybUzT0POwhSlpfuDNjghSiOqfLdfM=;
        b=Q7DdN5myiqCl8E+tYflZxJ5MO1HPkLr5iFYOJ4uHBJ+2cEW/yvKgmyo9czX2lS66yY
         PxDF2Z4/79kI8DdR/r/YMCyzYyBO6XG2Varvp4vv2768tgg2R9RfJKx2nloCtaiEokIO
         lqBzOTqBI91mwxFvkNVI2cmDB4XkD2ORfyxacn/hXhrKAnuBbCULxnNAeIhEJ9n6dIuV
         mL7uLB6OItABWUPwoECWfvCL3FCR2n3UD7Yw96mjL7AjLZqaCCLvFakc3KU/OTjZK/va
         5bO4l4/jYSzo/8Bt3muJQbuBA6x99Eoet7B0BDM3GWzMFMMpaAVjyo6kfKd3O13oXK3F
         6FFw==
X-Gm-Message-State: AOJu0YxJ4grlAaKnAt+szyKbu6UQOP/k7nRiiq/6PizHi/au/HapqNKT
	UT3QLuhOuzGH4pQth5k7ySbXGF4oXHO7BG3PaVgA5PqdEjh1yHQ1bJWoqwXrrK8sGHBDfvi1OV2
	kicOVSdbrLGvHZZuZTDFrnCBxU0y2neB4
X-Received: by 2002:a05:6870:6b0a:b0:1eb:192b:e75a with SMTP id mt10-20020a0568706b0a00b001eb192be75amr18651328oab.22.1700104017771;
        Wed, 15 Nov 2023 19:06:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IErzNsGbCi7cjJQfz8wbVjXhVOQ0dECg1zpdO2r2Bt7c8VxU6b+geNP4XQVFJ78DQarXuGJFQ==
X-Received: by 2002:a05:6870:6b0a:b0:1eb:192b:e75a with SMTP id mt10-20020a0568706b0a00b001eb192be75amr18651319oab.22.1700104017506;
        Wed, 15 Nov 2023 19:06:57 -0800 (PST)
Received: from [10.72.112.63] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d15-20020a17090a110f00b0028018af8dc2sm625368pja.23.2023.11.15.19.06.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Nov 2023 19:06:57 -0800 (PST)
Message-ID: <6824ece2-33ee-63f4-2c7a-7033556325cb@redhat.com>
Date: Thu, 16 Nov 2023 11:06:52 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ceph: quota: Fix invalid pointer access in
To: Wenchao Hao <haowenchao2@huawei.com>, Ilya Dryomov <idryomov@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org, louhongxiang@huawei.com
References: <20231114153108.1932884-1-haowenchao2@huawei.com>
 <af8549c8-a468-6505-6dd1-3589fc76be8e@redhat.com>
 <CAOi1vP9TnF+BWiEauddskmTO_+V2uvHiqpEg5EoxzZPKb0oEAQ@mail.gmail.com>
 <aeb8b9e7-c2ce-e758-1b45-67572e686e2c@redhat.com>
 <CAOi1vP-H9zHJEthzocxv7D7m6XX67sE2Dy1Aq=hP9GQRN+qj_g@mail.gmail.com>
 <5a1766c6-d923-a4e5-c5be-15b953372ef5@redhat.com>
 <5eb54f3e-3438-ba47-3d43-baf6b27aad0e@huawei.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <5eb54f3e-3438-ba47-3d43-baf6b27aad0e@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/16/23 10:54, Wenchao Hao wrote:
> On 2023/11/15 21:34, Xiubo Li wrote:
>>
>> On 11/15/23 21:25, Ilya Dryomov wrote:
>>> On Wed, Nov 15, 2023 at 2:17 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>>
>>>> On 11/15/23 20:32, Ilya Dryomov wrote:
>>>>> On Wed, Nov 15, 2023 at 1:35 AM Xiubo Li <xiubli@redhat.com> wrote:
>>>>>> On 11/14/23 23:31, Wenchao Hao wrote:
>>>>>>> This issue is reported by smatch, get_quota_realm() might return
>>>>>>> ERR_PTR, so we should using IS_ERR_OR_NULL here to check the return
>>>>>>> value.
>>>>>>>
>>>>>>> Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
>>>>>>> ---
>>>>>>>     fs/ceph/quota.c | 2 +-
>>>>>>>     1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
>>>>>>> index 9d36c3532de1..c4b2929c6a83 100644
>>>>>>> --- a/fs/ceph/quota.c
>>>>>>> +++ b/fs/ceph/quota.c
>>>>>>> @@ -495,7 +495,7 @@ bool ceph_quota_update_statfs(struct 
>>>>>>> ceph_fs_client *fsc, struct kstatfs *buf)
>>>>>>>         realm = get_quota_realm(mdsc, d_inode(fsc->sb->s_root),
>>>>>>>                                 QUOTA_GET_MAX_BYTES, true);
>>>>>>>         up_read(&mdsc->snap_rwsem);
>>>>>>> -     if (!realm)
>>>>>>> +     if (IS_ERR_OR_NULL(realm))
>>>>>>>                 return false;
>>>>>>>
>>>>>>> spin_lock(&realm->inodes_with_caps_lock);
>>>>>> Good catch.
>>>>>>
>>>>>> Reviewed-by: Xiubo Li <xiubli@redhat.com>
>>>>>>
>>>>>> We should CC the stable mail list.
>>>>> Hi Xiubo,
>>>>>
>>>>> What exactly is being fixed here?  get_quota_realm() is called with
>>>>> retry=true, which means that no errors can be returned -- EAGAIN, the
>>>>> only error that get_quota_realm() can otherwise generate, would be
>>>>> handled internally by retrying.
>>>> Yeah, that's true.
>>>>
>>>>> Am I missing something that makes this qualify for stable?
>>>> Actually it's just for the smatch check for now.
>>>>
>>>> IMO we shouldn't depend on the 'retry', just potentially for new 
>>>> changes
>>>> in future could return a ERR_PTR and cause potential bugs.
>>> At present, ceph_quota_is_same_realm() also depends on it -- note how
>>> old_realm isn't checked for errors at all and new_realm is only checked
>>> for EAGAIN there.
>>>
>>>> If that's not worth to make it for stable, let's remove it.
>>> Yes, let's remove it.  Please update the commit message as well, so
>>> that it's clear that this is squashing a static checker warning and
>>> doesn't actually fix any immediate bug.
>>
>> WenChao,
>>
>> Could update the commit comment and send the V2 ?
>>
>
> OK, I would update the commit comment as following:
>
> This issue is reported by smatch, get_quota_realm() might return
> ERR_PTR. It's not a immediate bug because get_quota_realm() is called
> with 'retry=true', no errors can be returned.
>
> While we still should check the return value of get_quota_realm() with
> IS_ERR_OR_NULL to avoid potential bugs if get_quota_realm() is changed
> to return other ERR_PTR in future.
>
> What's more, should I change the ceph_quota_is_same_realm() too?
>
Yeah, please. Let's fix them all.

Thanks

- Xiubo


> Thanks
>
>> Thanks
>>
>> - Xiubo
>>
>>
>>> Thanks,
>>>
>>>                  Ilya
>>>
>>
>



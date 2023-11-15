Return-Path: <ceph-devel+bounces-96-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D0BE7EC3BF
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Nov 2023 14:35:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 799EB281318
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Nov 2023 13:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A5501A5BE;
	Wed, 15 Nov 2023 13:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gazJH08V"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0AA199CE
	for <ceph-devel@vger.kernel.org>; Wed, 15 Nov 2023 13:35:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A3E9B
	for <ceph-devel@vger.kernel.org>; Wed, 15 Nov 2023 05:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700055303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C5Wd1lbN9UwH8wwz4rHuiEBNarPN7m4x8APn6ZM32KA=;
	b=gazJH08V6Qncus2zWF1VJtEzD8Ci7zygoTXOW/k5bKBuw0hba5Wb31DVOg7crQf5vRHbL2
	hCoPA88JcoH0LA6v0tKtl+1oU4mI/5G7iIxllVgK9Wr+xRpNRND0ivU3Nw2yPN2OG7GaYN
	5MouAg5IPPe0AR4x+ZusS0AvcSGunEI=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-tg9g5pFyPr2X2Sbqnh-PIA-1; Wed, 15 Nov 2023 08:35:01 -0500
X-MC-Unique: tg9g5pFyPr2X2Sbqnh-PIA-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6bcefd3b248so8935216b3a.3
        for <ceph-devel@vger.kernel.org>; Wed, 15 Nov 2023 05:35:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700055301; x=1700660101;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C5Wd1lbN9UwH8wwz4rHuiEBNarPN7m4x8APn6ZM32KA=;
        b=VZuzOsZNPwcuv6GKh7VAqcqPpUg7b/vcz2fNGAiFVLUygHo7fNWlhSNPJVCcUW1N/Z
         ShHVipW+jmgxB+5skkEq591nenM9ruYe1YJwcQnUn2xq1FCQAPIPsZOh0jzDUR+8EVVN
         B/2muJIJmkrr02fiJ0lS3ApDa+D2oeV4PQGYzHjz7DO9br384oWnqYgZ3ggu0BASmb2u
         zmAuhfyAcplWWMKFIaw6PXvkdhx3K/wF4Ru/5aqQIJ/RLlLlv+koVdehKXXPLOonaq4e
         j90Br6FubvNiYgKyePsjedSNDrnOk1ZsHNhnJjGCmUky8PX2GuJ7kTEucQH9nhJRlUAW
         XEZw==
X-Gm-Message-State: AOJu0YwRXEuy3mbcN4Xhd49rJs08isjW2ogQvVqKGbvUGaoGnhMWfhlv
	Kw5CwKUm30sdE4wEk0hIqjd8TIJkqg1rCRxZi0WvoCiYCBr/iAkZydjdnPWhs/vCIhiNjZ7/36f
	0DqCALErTB/yWMEGTN2LYJQ==
X-Received: by 2002:aa7:8816:0:b0:690:fa09:61d3 with SMTP id c22-20020aa78816000000b00690fa0961d3mr12496417pfo.15.1700055300712;
        Wed, 15 Nov 2023 05:35:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFV0xAg6w3slKf/hsLSWfwMemwWRQ/ao1u2QENn9rUHeBxEkEiPk3CaXPzANGIt7t1i7kGs2g==
X-Received: by 2002:aa7:8816:0:b0:690:fa09:61d3 with SMTP id c22-20020aa78816000000b00690fa0961d3mr12496392pfo.15.1700055300321;
        Wed, 15 Nov 2023 05:35:00 -0800 (PST)
Received: from [10.72.112.63] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j1-20020aa78d01000000b00694fee1011asm2778075pfe.208.2023.11.15.05.34.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Nov 2023 05:34:59 -0800 (PST)
Message-ID: <5a1766c6-d923-a4e5-c5be-15b953372ef5@redhat.com>
Date: Wed, 15 Nov 2023 21:34:54 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ceph: quota: Fix invalid pointer access in
Content-Language: en-US
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Wenchao Hao <haowenchao2@huawei.com>, Jeff Layton <jlayton@kernel.org>,
 ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 louhongxiang@huawei.com
References: <20231114153108.1932884-1-haowenchao2@huawei.com>
 <af8549c8-a468-6505-6dd1-3589fc76be8e@redhat.com>
 <CAOi1vP9TnF+BWiEauddskmTO_+V2uvHiqpEg5EoxzZPKb0oEAQ@mail.gmail.com>
 <aeb8b9e7-c2ce-e758-1b45-67572e686e2c@redhat.com>
 <CAOi1vP-H9zHJEthzocxv7D7m6XX67sE2Dy1Aq=hP9GQRN+qj_g@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP-H9zHJEthzocxv7D7m6XX67sE2Dy1Aq=hP9GQRN+qj_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/15/23 21:25, Ilya Dryomov wrote:
> On Wed, Nov 15, 2023 at 2:17 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 11/15/23 20:32, Ilya Dryomov wrote:
>>> On Wed, Nov 15, 2023 at 1:35 AM Xiubo Li <xiubli@redhat.com> wrote:
>>>> On 11/14/23 23:31, Wenchao Hao wrote:
>>>>> This issue is reported by smatch, get_quota_realm() might return
>>>>> ERR_PTR, so we should using IS_ERR_OR_NULL here to check the return
>>>>> value.
>>>>>
>>>>> Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
>>>>> ---
>>>>>     fs/ceph/quota.c | 2 +-
>>>>>     1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
>>>>> index 9d36c3532de1..c4b2929c6a83 100644
>>>>> --- a/fs/ceph/quota.c
>>>>> +++ b/fs/ceph/quota.c
>>>>> @@ -495,7 +495,7 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
>>>>>         realm = get_quota_realm(mdsc, d_inode(fsc->sb->s_root),
>>>>>                                 QUOTA_GET_MAX_BYTES, true);
>>>>>         up_read(&mdsc->snap_rwsem);
>>>>> -     if (!realm)
>>>>> +     if (IS_ERR_OR_NULL(realm))
>>>>>                 return false;
>>>>>
>>>>>         spin_lock(&realm->inodes_with_caps_lock);
>>>> Good catch.
>>>>
>>>> Reviewed-by: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> We should CC the stable mail list.
>>> Hi Xiubo,
>>>
>>> What exactly is being fixed here?  get_quota_realm() is called with
>>> retry=true, which means that no errors can be returned -- EAGAIN, the
>>> only error that get_quota_realm() can otherwise generate, would be
>>> handled internally by retrying.
>> Yeah, that's true.
>>
>>> Am I missing something that makes this qualify for stable?
>> Actually it's just for the smatch check for now.
>>
>> IMO we shouldn't depend on the 'retry', just potentially for new changes
>> in future could return a ERR_PTR and cause potential bugs.
> At present, ceph_quota_is_same_realm() also depends on it -- note how
> old_realm isn't checked for errors at all and new_realm is only checked
> for EAGAIN there.
>
>> If that's not worth to make it for stable, let's remove it.
> Yes, let's remove it.  Please update the commit message as well, so
> that it's clear that this is squashing a static checker warning and
> doesn't actually fix any immediate bug.

WenChao,

Could update the commit comment and send the V2 ?

Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>



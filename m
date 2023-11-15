Return-Path: <ceph-devel+bounces-94-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AFDE07EC376
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Nov 2023 14:17:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 648A51F26E37
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Nov 2023 13:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C4CA1A261;
	Wed, 15 Nov 2023 13:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g9CbQwFf"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABFB199A7
	for <ceph-devel@vger.kernel.org>; Wed, 15 Nov 2023 13:17:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E64A7
	for <ceph-devel@vger.kernel.org>; Wed, 15 Nov 2023 05:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700054258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F+dllCLAEC41jq93R276OiytSCxqMBHKzTo25Nwd4Ng=;
	b=g9CbQwFfJoZuiPRiWenH9Cmh2vNtLJsyoyENhtptbrZQTWzgavKQ/JZsQsJn0QV5sFI4nI
	qF/kYmHe5wU18lnEEh4er9PDk9mELp9y74IofrdRkR4yKwQ+FfrfFYffOJctxZJ7JSSco+
	nASwyUdtbi5zkYeD30VF/IWCIaYpc9w=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-Bx6O7AMqOEu5AGMwZW-fzw-1; Wed, 15 Nov 2023 08:17:34 -0500
X-MC-Unique: Bx6O7AMqOEu5AGMwZW-fzw-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1cc40eb7d54so72961155ad.2
        for <ceph-devel@vger.kernel.org>; Wed, 15 Nov 2023 05:17:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700054253; x=1700659053;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F+dllCLAEC41jq93R276OiytSCxqMBHKzTo25Nwd4Ng=;
        b=XgkwGhy3f/t86HpNISscWzwPt2n3gip4BqnN68WS8iLxaJiEy1fluPbEFjGQGtrCXe
         5KMcg7fsuDNNcncqKqfKVO+h+QgrQ1BnAtV55DHDTj1VkpTu0BkUjaocu5OADK6D3Ruh
         RLRhpCsA2ZU4EnEYAJYX10kfcTz7DwyBt8UQKE89SecLzlXe0o8mRrAr1vyLF2q2AUKz
         qw/TIyXvjReBa+PKR5GcgAphT6eso9HKTV2taTs+bXvZTyP+takkCIbx9/GQZ2kv7Q8a
         mEKakPIZajHB9djDKFUWXTV4ATCtvpiCCJP++7RicKDRSE1ZH2nJTEi3mky4bQH12h0G
         oSCA==
X-Gm-Message-State: AOJu0YyJK3QBbxAhOEgP8lidfueCEiZFQjTpRyuP+JoegJfiSP3BLSUO
	p1Xe9ZeFi2uxaocUVt8V+gPGimnh3Zh5Ju4+1s6ARpr4jXclBhGqCU+E83P5Maut7x4csSgAp2J
	agyvxCE2oU9y9QjY5Uz9TWA==
X-Received: by 2002:a17:903:230f:b0:1ce:8ed:237f with SMTP id d15-20020a170903230f00b001ce08ed237fmr6445229plh.5.1700054252928;
        Wed, 15 Nov 2023 05:17:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGlZR40mClyMi1gSrSdJNEiVzxlAuJuvn3BeShwoTTpKy/1jUow+38BXlhUZB25T3Jxdc3WUQ==
X-Received: by 2002:a17:903:230f:b0:1ce:8ed:237f with SMTP id d15-20020a170903230f00b001ce08ed237fmr6445204plh.5.1700054252587;
        Wed, 15 Nov 2023 05:17:32 -0800 (PST)
Received: from [10.72.112.63] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id jd7-20020a170903260700b001ca222edc16sm7329376plb.135.2023.11.15.05.17.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Nov 2023 05:17:32 -0800 (PST)
Message-ID: <aeb8b9e7-c2ce-e758-1b45-67572e686e2c@redhat.com>
Date: Wed, 15 Nov 2023 21:17:28 +0800
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
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP9TnF+BWiEauddskmTO_+V2uvHiqpEg5EoxzZPKb0oEAQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/15/23 20:32, Ilya Dryomov wrote:
> On Wed, Nov 15, 2023 at 1:35 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 11/14/23 23:31, Wenchao Hao wrote:
>>> This issue is reported by smatch, get_quota_realm() might return
>>> ERR_PTR, so we should using IS_ERR_OR_NULL here to check the return
>>> value.
>>>
>>> Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
>>> ---
>>>    fs/ceph/quota.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
>>> index 9d36c3532de1..c4b2929c6a83 100644
>>> --- a/fs/ceph/quota.c
>>> +++ b/fs/ceph/quota.c
>>> @@ -495,7 +495,7 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
>>>        realm = get_quota_realm(mdsc, d_inode(fsc->sb->s_root),
>>>                                QUOTA_GET_MAX_BYTES, true);
>>>        up_read(&mdsc->snap_rwsem);
>>> -     if (!realm)
>>> +     if (IS_ERR_OR_NULL(realm))
>>>                return false;
>>>
>>>        spin_lock(&realm->inodes_with_caps_lock);
>> Good catch.
>>
>> Reviewed-by: Xiubo Li <xiubli@redhat.com>
>>
>> We should CC the stable mail list.
> Hi Xiubo,
>
> What exactly is being fixed here?  get_quota_realm() is called with
> retry=true, which means that no errors can be returned -- EAGAIN, the
> only error that get_quota_realm() can otherwise generate, would be
> handled internally by retrying.

Yeah, that's true.

> Am I missing something that makes this qualify for stable?

Actually it's just for the smatch check for now.

IMO we shouldn't depend on the 'retry', just potentially for new changes 
in future could return a ERR_PTR and cause potential bugs.

If that's not worth to make it for stable, let's remove it.

Thanks

- Xiubo

>
> Thanks,
>
>                  Ilya
>



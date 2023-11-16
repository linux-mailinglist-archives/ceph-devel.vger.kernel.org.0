Return-Path: <ceph-devel+bounces-97-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 192897ED9CA
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Nov 2023 03:54:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5767AB20C98
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Nov 2023 02:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6EDA8F56;
	Thu, 16 Nov 2023 02:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: ceph-devel@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2CB197;
	Wed, 15 Nov 2023 18:54:33 -0800 (PST)
Received: from kwepemm000012.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4SW4PL0XcczvQjR;
	Thu, 16 Nov 2023 10:54:14 +0800 (CST)
Received: from [10.174.178.220] (10.174.178.220) by
 kwepemm000012.china.huawei.com (7.193.23.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 16 Nov 2023 10:54:30 +0800
Message-ID: <5eb54f3e-3438-ba47-3d43-baf6b27aad0e@huawei.com>
Date: Thu, 16 Nov 2023 10:54:29 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] ceph: quota: Fix invalid pointer access in
To: Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
CC: Jeff Layton <jlayton@kernel.org>, <ceph-devel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <louhongxiang@huawei.com>
References: <20231114153108.1932884-1-haowenchao2@huawei.com>
 <af8549c8-a468-6505-6dd1-3589fc76be8e@redhat.com>
 <CAOi1vP9TnF+BWiEauddskmTO_+V2uvHiqpEg5EoxzZPKb0oEAQ@mail.gmail.com>
 <aeb8b9e7-c2ce-e758-1b45-67572e686e2c@redhat.com>
 <CAOi1vP-H9zHJEthzocxv7D7m6XX67sE2Dy1Aq=hP9GQRN+qj_g@mail.gmail.com>
 <5a1766c6-d923-a4e5-c5be-15b953372ef5@redhat.com>
Content-Language: en-US
From: Wenchao Hao <haowenchao2@huawei.com>
In-Reply-To: <5a1766c6-d923-a4e5-c5be-15b953372ef5@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm000012.china.huawei.com (7.193.23.142)
X-CFilter-Loop: Reflected

On 2023/11/15 21:34, Xiubo Li wrote:
> 
> On 11/15/23 21:25, Ilya Dryomov wrote:
>> On Wed, Nov 15, 2023 at 2:17 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>
>>> On 11/15/23 20:32, Ilya Dryomov wrote:
>>>> On Wed, Nov 15, 2023 at 1:35 AM Xiubo Li <xiubli@redhat.com> wrote:
>>>>> On 11/14/23 23:31, Wenchao Hao wrote:
>>>>>> This issue is reported by smatch, get_quota_realm() might return
>>>>>> ERR_PTR, so we should using IS_ERR_OR_NULL here to check the return
>>>>>> value.
>>>>>>
>>>>>> Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
>>>>>> ---
>>>>>>     fs/ceph/quota.c | 2 +-
>>>>>>     1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
>>>>>> index 9d36c3532de1..c4b2929c6a83 100644
>>>>>> --- a/fs/ceph/quota.c
>>>>>> +++ b/fs/ceph/quota.c
>>>>>> @@ -495,7 +495,7 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
>>>>>>         realm = get_quota_realm(mdsc, d_inode(fsc->sb->s_root),
>>>>>>                                 QUOTA_GET_MAX_BYTES, true);
>>>>>>         up_read(&mdsc->snap_rwsem);
>>>>>> -     if (!realm)
>>>>>> +     if (IS_ERR_OR_NULL(realm))
>>>>>>                 return false;
>>>>>>
>>>>>>         spin_lock(&realm->inodes_with_caps_lock);
>>>>> Good catch.
>>>>>
>>>>> Reviewed-by: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> We should CC the stable mail list.
>>>> Hi Xiubo,
>>>>
>>>> What exactly is being fixed here?  get_quota_realm() is called with
>>>> retry=true, which means that no errors can be returned -- EAGAIN, the
>>>> only error that get_quota_realm() can otherwise generate, would be
>>>> handled internally by retrying.
>>> Yeah, that's true.
>>>
>>>> Am I missing something that makes this qualify for stable?
>>> Actually it's just for the smatch check for now.
>>>
>>> IMO we shouldn't depend on the 'retry', just potentially for new changes
>>> in future could return a ERR_PTR and cause potential bugs.
>> At present, ceph_quota_is_same_realm() also depends on it -- note how
>> old_realm isn't checked for errors at all and new_realm is only checked
>> for EAGAIN there.
>>
>>> If that's not worth to make it for stable, let's remove it.
>> Yes, let's remove it.  Please update the commit message as well, so
>> that it's clear that this is squashing a static checker warning and
>> doesn't actually fix any immediate bug.
> 
> WenChao,
> 
> Could update the commit comment and send the V2 ?
> 

OK, I would update the commit comment as following:

This issue is reported by smatch, get_quota_realm() might return
ERR_PTR. It's not a immediate bug because get_quota_realm() is called
with 'retry=true', no errors can be returned.

While we still should check the return value of get_quota_realm() with
IS_ERR_OR_NULL to avoid potential bugs if get_quota_realm() is changed
to return other ERR_PTR in future.

What's more, should I change the ceph_quota_is_same_realm() too?

Thanks

> Thanks
> 
> - Xiubo
> 
> 
>> Thanks,
>>
>>                  Ilya
>>
> 



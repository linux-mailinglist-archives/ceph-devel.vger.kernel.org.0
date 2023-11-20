Return-Path: <ceph-devel+bounces-176-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48FDD7F0A1B
	for <lists+ceph-devel@lfdr.de>; Mon, 20 Nov 2023 01:34:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C2331C20831
	for <lists+ceph-devel@lfdr.de>; Mon, 20 Nov 2023 00:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB6971855;
	Mon, 20 Nov 2023 00:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZH9anaXq"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A36107
	for <ceph-devel@vger.kernel.org>; Sun, 19 Nov 2023 16:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700440456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XNfWXEP/apLkYJ5kDOZzif17+mooB5QMPG/cU/xbSKw=;
	b=ZH9anaXqOFU3NQAhQY4w7+WSsGoYKlm/+8kyyt5lTmmkyCM4UFeicoQY7efsldpbBilNEY
	E65RTbrJrm4OC8m7PKnL2OFG31N9/sV/k3j0kKsnztYFazt9QIDcEzvUELn9Y+AmomKfpm
	NsAzERML4wxA/xtnpg9qTiEHXuK5fLg=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-140-HcFxhAk8MkyPtBWOUiJ8Tw-1; Sun, 19 Nov 2023 19:34:15 -0500
X-MC-Unique: HcFxhAk8MkyPtBWOUiJ8Tw-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-1ef4f8d294eso3691470fac.1
        for <ceph-devel@vger.kernel.org>; Sun, 19 Nov 2023 16:34:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700440454; x=1701045254;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XNfWXEP/apLkYJ5kDOZzif17+mooB5QMPG/cU/xbSKw=;
        b=INQK+EQ2qxohMPayP2hEPXkIVN5Sgi/M9/bSPDsG9D6yjgbnapXV3BRSB3e+1gp3ZP
         DxeNI1KOs4SVmstVXRBdXNZAk7b5cut8P/h4Dke5vxtkdfeFfHnl4vAyznWPzAFrSGKc
         oHtH3cOs0ztCQXxU4MRDxUejWvOhPhziq0WgfZ+mtv0kksggH4x5AD61OuQjyS71L1r2
         cCWCkvE07JZ8kg2eBjWaNj6oOKeSBx2fRuNxEZZmI773bKhTUDcMnsCvoDDzlNu0szqf
         wWHfRRaKdUO7raLgHpn4WoJHuduZ+4yc1uogia19hkRJFC8Qfk3O+lPcGOJC7it2LG8r
         be+Q==
X-Gm-Message-State: AOJu0Yxi2LgOmBnJ5Glb/1FeqviODVutHa3ttL3R7FmMjupbGOMjbeX2
	XetXmZ3QO/mKwXGGPk0Bg58Za6Ki2YWWezfPAHInKAgO9QoNID8DIe0CkScxV0jZe4J0Smo7wAW
	CyiazLkhNnulAqeH5xPHKWg==
X-Received: by 2002:a05:6870:71d3:b0:1ea:cdcb:5a2b with SMTP id p19-20020a05687071d300b001eacdcb5a2bmr8235927oag.54.1700440454636;
        Sun, 19 Nov 2023 16:34:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFtHLuLayagUcBCN6b6x5+5DzP5Ner32mX1Dz5DlA/0uSqJLZJcmLBnW1dXmKqlDUeEwMBMqg==
X-Received: by 2002:a05:6870:71d3:b0:1ea:cdcb:5a2b with SMTP id p19-20020a05687071d300b001eacdcb5a2bmr8235913oag.54.1700440454313;
        Sun, 19 Nov 2023 16:34:14 -0800 (PST)
Received: from [10.72.112.63] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id fd13-20020a056a002e8d00b006baa1cf561dsm4853765pfb.0.2023.11.19.16.34.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Nov 2023 16:34:13 -0800 (PST)
Message-ID: <932fdd76-b726-3e1c-90d6-28ec39eaf5e4@redhat.com>
Date: Mon, 20 Nov 2023 08:34:11 +0800
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
 <6824ece2-33ee-63f4-2c7a-7033556325cb@redhat.com>
 <3a0b72e0-0784-0882-c18b-6178ed597670@huawei.com>
 <31d14ae5-8d79-6e79-2e29-203d4062de7e@redhat.com>
 <edb131d8-691a-359a-09c6-a949f9dd7bf4@huawei.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <edb131d8-691a-359a-09c6-a949f9dd7bf4@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/17/23 16:53, Wenchao Hao wrote:
> On 2023/11/17 14:14, Xiubo Li wrote:
>>
>> On 11/16/23 15:09, Wenchao Hao wrote:
>>> On 2023/11/16 11:06, Xiubo Li wrote:
>>>>
>>>> On 11/16/23 10:54, Wenchao Hao wrote:
>>>>> On 2023/11/15 21:34, Xiubo Li wrote:
>>>>>>
>>>>>> On 11/15/23 21:25, Ilya Dryomov wrote:
>>>>>>> On Wed, Nov 15, 2023 at 2:17 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>>>>>>
>>>>>>>> On 11/15/23 20:32, Ilya Dryomov wrote:
>>>>>>>>> On Wed, Nov 15, 2023 at 1:35 AM Xiubo Li <xiubli@redhat.com> 
>>>>>>>>> wrote:
>>>>>>>>>> On 11/14/23 23:31, Wenchao Hao wrote:
>>>>>>>>>>> This issue is reported by smatch, get_quota_realm() might 
>>>>>>>>>>> return
>>>>>>>>>>> ERR_PTR, so we should using IS_ERR_OR_NULL here to check the 
>>>>>>>>>>> return
>>>>>>>>>>> value.
>>>>>>>>>>>
>>>>>>>>>>> Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
>>>>>>>>>>> ---
>>>>>>>>>>>     fs/ceph/quota.c | 2 +-
>>>>>>>>>>>     1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
>>>>>>>>>>> index 9d36c3532de1..c4b2929c6a83 100644
>>>>>>>>>>> --- a/fs/ceph/quota.c
>>>>>>>>>>> +++ b/fs/ceph/quota.c
>>>>>>>>>>> @@ -495,7 +495,7 @@ bool ceph_quota_update_statfs(struct 
>>>>>>>>>>> ceph_fs_client *fsc, struct kstatfs *buf)
>>>>>>>>>>>         realm = get_quota_realm(mdsc, d_inode(fsc->sb->s_root),
>>>>>>>>>>> QUOTA_GET_MAX_BYTES, true);
>>>>>>>>>>>         up_read(&mdsc->snap_rwsem);
>>>>>>>>>>> -     if (!realm)
>>>>>>>>>>> +     if (IS_ERR_OR_NULL(realm))
>>>>>>>>>>>                 return false;
>>>>>>>>>>>
>>>>>>>>>>> spin_lock(&realm->inodes_with_caps_lock);
>>>>>>>>>> Good catch.
>>>>>>>>>>
>>>>>>>>>> Reviewed-by: Xiubo Li <xiubli@redhat.com>
>>>>>>>>>>
>>>>>>>>>> We should CC the stable mail list.
>>>>>>>>> Hi Xiubo,
>>>>>>>>>
>>>>>>>>> What exactly is being fixed here? get_quota_realm() is called 
>>>>>>>>> with
>>>>>>>>> retry=true, which means that no errors can be returned -- 
>>>>>>>>> EAGAIN, the
>>>>>>>>> only error that get_quota_realm() can otherwise generate, 
>>>>>>>>> would be
>>>>>>>>> handled internally by retrying.
>>>>>>>> Yeah, that's true.
>>>>>>>>
>>>>>>>>> Am I missing something that makes this qualify for stable?
>>>>>>>> Actually it's just for the smatch check for now.
>>>>>>>>
>>>>>>>> IMO we shouldn't depend on the 'retry', just potentially for 
>>>>>>>> new changes
>>>>>>>> in future could return a ERR_PTR and cause potential bugs.
>>>>>>> At present, ceph_quota_is_same_realm() also depends on it -- 
>>>>>>> note how
>>>>>>> old_realm isn't checked for errors at all and new_realm is only 
>>>>>>> checked
>>>>>>> for EAGAIN there.
>>>>>>>
>>>>>>>> If that's not worth to make it for stable, let's remove it.
>>>>>>> Yes, let's remove it.  Please update the commit message as well, so
>>>>>>> that it's clear that this is squashing a static checker warning and
>>>>>>> doesn't actually fix any immediate bug.
>>>>>>
>>>>>> WenChao,
>>>>>>
>>>>>> Could update the commit comment and send the V2 ?
>>>>>>
>>>>>
>>>>> OK, I would update the commit comment as following:
>>>>>
>>>>> This issue is reported by smatch, get_quota_realm() might return
>>>>> ERR_PTR. It's not a immediate bug because get_quota_realm() is called
>>>>> with 'retry=true', no errors can be returned.
>>>>>
>>>>> While we still should check the return value of get_quota_realm() 
>>>>> with
>>>>> IS_ERR_OR_NULL to avoid potential bugs if get_quota_realm() is 
>>>>> changed
>>>>> to return other ERR_PTR in future.
>>>>>
>>>>> What's more, should I change the ceph_quota_is_same_realm() too?
>>>>>
>>>> Yeah, please. Let's fix them all.
>>>>
>>>
>>> is_same is return as true if both old_realm and new_realm are NULL, 
>>> I do not
>>> want to change the origin logic except add check for ERR_PTR, so 
>>> following
>>> is my change:
>>>
>>> 1. make sure xxx_realm is valid before calling ceph_put_snap_realm.
>>> 2. return false if new_realm or old_realm is ERR_PTR, this is newly 
>>> added
>>>    and now we would always run with the else branch.
>>>
>>> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
>>> index c4b2929c6a83..8da9ffb05395 100644
>>> --- a/fs/ceph/quota.c
>>> +++ b/fs/ceph/quota.c
>>> @@ -290,16 +290,20 @@ bool ceph_quota_is_same_realm(struct inode 
>>> *old, struct inode *new)
>>>         new_realm = get_quota_realm(mdsc, new, QUOTA_GET_ANY, false);
>>>         if (PTR_ERR(new_realm) == -EAGAIN) {
>>>                 up_read(&mdsc->snap_rwsem);
>>> -               if (old_realm)
>>> +               if (!IS_ERR_OR_NULL(old_realm))
>>>                         ceph_put_snap_realm(mdsc, old_realm);
>>>                 goto restart;
>>>         }
>>> -       is_same = (old_realm == new_realm);
>>>         up_read(&mdsc->snap_rwsem);
>>>
>>> -       if (old_realm)
>>> +       if (IS_ERR(new_realm))
>>> +               is_same = false;
>>> +       else
>>> +               is_same = (old_realm == new_realm);
>>> +
>>> +       if (!IS_ERR_OR_NULL(old_realm))
>>>                 ceph_put_snap_realm(mdsc, old_realm);
>>> -       if (new_realm)
>>> +       if (!IS_ERR_OR_NULL(new_realm))
>>>                 ceph_put_snap_realm(mdsc, new_realm);
>>>
>>>         return is_same;
>>>
>> If we just to fix the smatch check, how about make get_quota_realm() 
>> to return a 'int' type value and at the same time add a 'realmp' 
>> parameter ?  And just return '-EAGAIN' or '0' always.
>>
>> Then it will be something likes:
>>
>>
>> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
>> index c4b2929c6a83..f37f5324b6a1 100644
>> --- a/fs/ceph/quota.c
>> +++ b/fs/ceph/quota.c
>> @@ -211,10 +211,9 @@ void ceph_cleanup_quotarealms_inodes(struct 
>> ceph_mds_client *mdsc)
>>    * this function will return -EAGAIN; otherwise, the snaprealms 
>> walk-through
>>    * will be restarted.
>>    */
>> -static struct ceph_snap_realm *get_quota_realm(struct 
>> ceph_mds_client *mdsc,
>> -                                              struct inode *inode,
>> -                                              enum quota_get_realm 
>> which_quota,
>> -                                              bool retry)
>> +static int get_quota_realm(struct ceph_mds_client *mdsc, struct 
>> inode *inode,
>> +                          enum quota_get_realm which_quota,
>> +                          struct ceph_snap_realm **realmp, bool retry)
>>   {
>>          struct ceph_client *cl = mdsc->fsc->client;
>>          struct ceph_inode_info *ci = NULL;
>> @@ -222,8 +221,10 @@ static struct ceph_snap_realm 
>> *get_quota_realm(struct ceph_mds_client *mdsc,
>>          struct inode *in;
>>          bool has_quota;
>>
>> +       if (realmp)
>> +               *realmp = NULL;
>>          if (ceph_snap(inode) != CEPH_NOSNAP)
>> -               return NULL;
>> +               return 0;
>>
>>   restart:
>>          realm = ceph_inode(inode)->i_snap_realm;
>> @@ -250,7 +251,7 @@ static struct ceph_snap_realm 
>> *get_quota_realm(struct ceph_mds_client *mdsc,
>>                                  break;
>>                          ceph_put_snap_realm(mdsc, realm);
>>                          if (!retry)
>> -                               return ERR_PTR(-EAGAIN);
>> +                               return -EAGAIN;
>>                          goto restart;
>>                  }
>>
>> @@ -259,8 +260,11 @@ static struct ceph_snap_realm 
>> *get_quota_realm(struct ceph_mds_client *mdsc,
>>                  iput(in);
>>
>>                  next = realm->parent;
>> -               if (has_quota || !next)
>> -                      return realm;
>> +               if (has_quota || !next) {
>> +                       if (realmp)
>> +                               *realmp = realm;
>> +                      return 0;
>> +               }
>>
>>                  ceph_get_snap_realm(mdsc, next);
>>                  ceph_put_snap_realm(mdsc, realm);
>> @@ -269,14 +273,15 @@ static struct ceph_snap_realm 
>> *get_quota_realm(struct ceph_mds_client *mdsc,
>>          if (realm)
>>                  ceph_put_snap_realm(mdsc, realm);
>>
>> -       return NULL;
>> +       return 0;
>>   }
>>
>>   bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
>>   {
>>          struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(old->i_sb);
>> -       struct ceph_snap_realm *old_realm, *new_realm;
>> +       struct ceph_snap_realm *old_realm = NULL, *new_realm = NULL;
>>          bool is_same;
>> +       int ret;
>>
>>   restart:
>>          /*
>> @@ -286,9 +291,9 @@ bool ceph_quota_is_same_realm(struct inode *old, 
>> struct inode *new)
>>           * dropped and we can then restart the whole operation.
>>           */
>>          down_read(&mdsc->snap_rwsem);
>> -       old_realm = get_quota_realm(mdsc, old, QUOTA_GET_ANY, true);
>> -       new_realm = get_quota_realm(mdsc, new, QUOTA_GET_ANY, false);
>> -       if (PTR_ERR(new_realm) == -EAGAIN) {
>> +       get_quota_realm(mdsc, old, QUOTA_GET_ANY, &old_relam, true);
>> +       ret = get_quota_realm(mdsc, new, QUOTA_GET_ANY, &new_realm, 
>> false);
>> +       if (ret == -EAGAIN) {
>>                  up_read(&mdsc->snap_rwsem);
>>                  if (old_realm)
>>                          ceph_put_snap_realm(mdsc, old_realm);
>>
>>
>> Won't be this better ?
>>
>
> Yes, it looks better.
>
> Would you post a patch to address it? Or should I apply your changes and
> send a V2?
>
The above just a draft patch.

Please send a V2 for it and I will review and test it.

Thanks

- Xiubo


>> Thanks
>>
>> - Xiubo
>>
>>
>>
>>
>>>
>>>> Thanks
>>>>
>>>> - Xiubo
>>>>
>>>>
>>>>> Thanks
>>>>>
>>>>>> Thanks
>>>>>>
>>>>>> - Xiubo
>>>>>>
>>>>>>
>>>>>>> Thanks,
>>>>>>>
>>>>>>>                  Ilya
>>>>>>>
>>>>>>
>>>>>
>>>>
>>>>
>>>
>>
>



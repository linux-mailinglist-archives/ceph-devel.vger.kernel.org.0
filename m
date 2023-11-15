Return-Path: <ceph-devel+bounces-91-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5225B7EC13B
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Nov 2023 12:25:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C781E1F22493
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Nov 2023 11:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5BC6168A2;
	Wed, 15 Nov 2023 11:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FlwLYe6k"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18788156E4
	for <ceph-devel@vger.kernel.org>; Wed, 15 Nov 2023 11:25:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864A0E9
	for <ceph-devel@vger.kernel.org>; Wed, 15 Nov 2023 03:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700047508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wqbAxW2GAT8nJitK9StpM8khtVuzEK0iC8oZKl6SFWw=;
	b=FlwLYe6kdXCkOkGNAF56/7dHi/aHRYR7QmOK8np7Uf8phjYgnKIYaJW5hCrFB1KSbRG6O/
	8Dsc9/UpD/QtOgc9sbFHwJaYrEsPr+QEDWGa5P9r7I5crJ6Y9Xtg8pix3oP/6qfyPUggHg
	nKpprKlFGq+mq4FAjD83IejYgMFuYFY=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-BzKSxnTdOxqUrCNVnPRJaA-1; Wed, 15 Nov 2023 06:25:07 -0500
X-MC-Unique: BzKSxnTdOxqUrCNVnPRJaA-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-1e9949499edso6536668fac.0
        for <ceph-devel@vger.kernel.org>; Wed, 15 Nov 2023 03:25:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700047506; x=1700652306;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wqbAxW2GAT8nJitK9StpM8khtVuzEK0iC8oZKl6SFWw=;
        b=WJGyVS0M9Taoi6jLTYpIF565z5DCe3xExdqvLVdSaNqLtK8oKImRzpLxQZ6+SitgYv
         DUCll60CEQi3OfwY1Z+LdjK/LFlJUkeDkaYyRNn2xtAELHIfp/5DuXFVUwsimn19ylPr
         BH1g2P5PxibmODk3F6P2mqZw2+m8hebz/yYlhWsAgFmOTQkYXsWmsXLOBJu4efv0E76p
         Vp1nOWnN8nhXaaCXNXQt69bLSATFWHrCdMy+9Ly9wpukhdTY/o6N3jH3aA0APvO26stH
         uDQlg15k5iven5v2e+yCV2AgJy//jj8LXnl/JYJpuGbToV4if71O8BVkt9zhveQf+cbK
         k/nQ==
X-Gm-Message-State: AOJu0Yz00WQWXoyt+wqhpJ3x/DdMPDbmmwCA+1tyACV6QRt7aALL8XHg
	J7h5aLGJ5WqDuYKAGPG9JfrwhXeUx5APJa8hG3NrNlfnWjd7Heg+CAyFyZXWdVeMvacrojbM36+
	GiPl5YkotsdbEpzG06aNfUw==
X-Received: by 2002:a05:6870:7f0e:b0:1e9:e063:ca6b with SMTP id xa14-20020a0568707f0e00b001e9e063ca6bmr14402552oab.32.1700047506527;
        Wed, 15 Nov 2023 03:25:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFY82T2RMO59Te4c7OF3TdHRYkC0Lhptd39Gk4hWYviUMnyR0+TL9x/XCnEtJ/DZqFORMiVdg==
X-Received: by 2002:a05:6870:7f0e:b0:1e9:e063:ca6b with SMTP id xa14-20020a0568707f0e00b001e9e063ca6bmr14402537oab.32.1700047506288;
        Wed, 15 Nov 2023 03:25:06 -0800 (PST)
Received: from [10.72.112.63] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j16-20020a056a00131000b006c4d2479bf8sm2636454pfu.51.2023.11.15.03.25.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Nov 2023 03:25:05 -0800 (PST)
Message-ID: <93f049f1-f409-0759-f2a9-0c32d88130fd@redhat.com>
Date: Wed, 15 Nov 2023 19:25:01 +0800
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
To: Luis Henriques <lhenriques@suse.de>, Wenchao Hao <haowenchao2@huawei.com>
Cc: Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>,
 ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 louhongxiang@huawei.com
References: <20231114153108.1932884-1-haowenchao2@huawei.com>
 <875y238drx.fsf@suse.de>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <875y238drx.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/15/23 19:19, Luis Henriques wrote:
> Wenchao Hao <haowenchao2@huawei.com> writes:
>
>> This issue is reported by smatch, get_quota_realm() might return
>> ERR_PTR, so we should using IS_ERR_OR_NULL here to check the return
>> value.
>>
>> Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
>> ---
>>   fs/ceph/quota.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
>> index 9d36c3532de1..c4b2929c6a83 100644
>> --- a/fs/ceph/quota.c
>> +++ b/fs/ceph/quota.c
>> @@ -495,7 +495,7 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
>>   	realm = get_quota_realm(mdsc, d_inode(fsc->sb->s_root),
>>   				QUOTA_GET_MAX_BYTES, true);
>>   	up_read(&mdsc->snap_rwsem);
>> -	if (!realm)
>> +	if (IS_ERR_OR_NULL(realm))
>>   		return false;
>>   
>>   	spin_lock(&realm->inodes_with_caps_lock);
>> -- 
>>
>> 2.32.0
>>
> This looks right to me, the issue was introduced by commit 0c44a8e0fc55
> ("ceph: quota: fix quota subdir mounts").  FWIW:
>
> Reviewed-by: Luis Henriques <lhenriques@suse.de>

Thanks Luis. I have updated the testing branch.

- Xiubo


> Cheers,



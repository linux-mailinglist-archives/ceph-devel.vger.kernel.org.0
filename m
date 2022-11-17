Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CF462D912
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Nov 2022 12:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbiKQLKX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Nov 2022 06:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239897AbiKQLJN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Nov 2022 06:09:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7188558B
        for <ceph-devel@vger.kernel.org>; Thu, 17 Nov 2022 03:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668683289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3hJFMcIT53QnK3wZUol6C7JAYb+pXC+Uh295TWzYK8g=;
        b=ikAtOoafChWFZAAYRLLOxUwH6phkj1VCB9lxdu+Y74yuXvwpeZT/zR7v783uYb3Um9hgK9
        g9RkXqvlNdJdbTBjaOjKeVeE9433xNeUcLl/rnSh5hOuxdTLbFyB9Fli0G5PeSeKKhEUPa
        6yCbo5dQu6CWUDupxuhEqIWYBtXyqmk=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-253-SqjBoH63M-W-uAlWUNCPow-1; Thu, 17 Nov 2022 06:08:08 -0500
X-MC-Unique: SqjBoH63M-W-uAlWUNCPow-1
Received: by mail-pl1-f200.google.com with SMTP id k15-20020a170902c40f00b001887cd71fe6so1203479plk.5
        for <ceph-devel@vger.kernel.org>; Thu, 17 Nov 2022 03:08:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:references:cc:to:from:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3hJFMcIT53QnK3wZUol6C7JAYb+pXC+Uh295TWzYK8g=;
        b=RFC+hDb5LAPDQxgV7HoaS2cHvTV9PlbmeuVsCc9zODXBqONnop3vNDX+iHy0Rk24Hy
         PgUqPJG2e9jZyAa90bJVuYkxXZhja3gkg21qtTtJHJBuCV8jg6iYg1kjgiARN4BhuSbT
         FUdt+BNTQfBdki3xsZVwbU3st+EI6OExKcgjwb6u1nybGZEBe19tTRVEK+NVWYEidCtY
         ncZAKrYTlWjQtH3S7LuU2W6cdQYP1yqPcadOEPWUwd8VM1g2GH9HOAQLurLoB5K6wHbw
         4e432fU/PR13v6bqA3xi8u1J6FqEnIioleApOHwzE6CLk4Q5QbG8ruspg1zrWj4XkdEV
         tOrw==
X-Gm-Message-State: ANoB5pkVrCpFq1wbHrbDfwiLHp59qBEp8tFM3Hhmdjx5sQ5z5/eJOMrU
        +LK9ivxc+TNQ1TBYZf8LdwYn/pOeopF/avsLYzXIrMeUvjJSAj4yQyhF0kv4Kfg5j6i0mjraLWa
        0M2dyuK8iJ6wDNgFgIwmywA==
X-Received: by 2002:a17:903:2ce:b0:17f:8a20:d9b5 with SMTP id s14-20020a17090302ce00b0017f8a20d9b5mr2278804plk.76.1668683287533;
        Thu, 17 Nov 2022 03:08:07 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7Aqgbfk1NNZoVWMG2j8mJu0XUHx0gOZFjXhj6xB3w7YNJtRnuIV8CRlIjpnEZ3Kh2u+d8EQA==
X-Received: by 2002:a17:903:2ce:b0:17f:8a20:d9b5 with SMTP id s14-20020a17090302ce00b0017f8a20d9b5mr2278784plk.76.1668683287253;
        Thu, 17 Nov 2022 03:08:07 -0800 (PST)
Received: from [10.72.12.148] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n25-20020a63a519000000b0046ec057243asm762689pgf.12.2022.11.17.03.08.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 03:08:06 -0800 (PST)
Subject: Re: [PATCH] ceph: make sure directories aren't complete after setting
 crypt context
From:   Xiubo Li <xiubli@redhat.com>
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221116153703.27292-1-lhenriques@suse.de>
 <5de0ae69-5e3d-2ccb-64a3-971db66477f8@redhat.com>
Message-ID: <41710b3d-b37f-8c65-d55d-c4137a366efd@redhat.com>
Date:   Thu, 17 Nov 2022 19:08:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5de0ae69-5e3d-2ccb-64a3-971db66477f8@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 17/11/2022 16:03, Xiubo Li wrote:
>
> On 16/11/2022 23:37, Luís Henriques wrote:
>> When setting a directory's crypt context, __ceph_dir_clear_complete() 
>> needs
>> to be used otherwise, if it was complete before, any old dentry 
>> that's still
>> around will be valid.
>>
>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>> ---
>> Hi!
>>
>> Here's a simple way to trigger the bug this patch is fixing:
>>
>> # cd /cephfs
>> # ls mydir
>> nKRhofOAVNsAwVLvDw7a0c9ypsjbZfK3n0Npnmni6j0
>> # ls mydir/nKRhofOAVNsAwVLvDw7a0c9ypsjbZfK3n0Npnmni6j0/
>> Cyuer5xT+kBlEPgtwAqSj0WK2taEljP5vHZ,D8VXCJ8 
>> u+46b2XVCt7Obpz0gznZyNLRj79Q2l4KmkwbKOzdQKw
>> # fscrypt unlock mydir
>> # touch /mnt/test/mydir/mysubdir/file
>> touch: cannot touch '/mnt/test/mydir/mysubdir/file': No such file or 
>> directory
>>
>>   fs/ceph/crypto.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
>> index 35a2ccfe6899..dc1557967032 100644
>> --- a/fs/ceph/crypto.c
>> +++ b/fs/ceph/crypto.c
>> @@ -87,6 +87,10 @@ static int ceph_crypt_get_context(struct inode 
>> *inode, void *ctx, size_t len)
>>           return -ERANGE;
>>         memcpy(ctx, cfa->cfa_blob, ctxlen);
>> +
>> +    /* Directory isn't complete anymore */
>> +    if (S_ISDIR(inode->i_mode) && __ceph_dir_is_complete(ci))
>> +        __ceph_dir_clear_complete(ci);
>
> Hi Luis,
>
> Good catch!
>
> BTW, why do this in the ceph_crypt_get_context() ? As my understanding 
> is that we should mark 'mydir' as incomplete when unlocking it. While 
> as I remembered the unlock operation will do:
>
>
> Step1: get_encpolicy via 'mydir' as ctx
> Step2: rm_enckey of ctx from the superblock
>
Sorry, it should be add_enckey.
>
> Since I am still running the test cases for the file lock patches, so 
> I didn't catch logs to confirm the above steps yet.
>
> If I am right IMO then we should mark the dir as incomplete in the 
> Step2 instead, because for non-unlock operations they may also do the 
> Step1.
>
Your patch will work. But probably we should do this just around 
__fscrypt_prepare_readdir() or fscrypt_prepare_readdir() instead ? We 
need to detect that once the 'inode->i_crypt_info' changed then mark the 
dir as incomplete.

For now for the lock operation it will evict the inode, which will help 
do this for us already. But for unlock case, we need to handle it by 
ourself.

Thanks!

- Xiubo


> Thanks!
>
> - Xiubo
>
>>       return ctxlen;
>>   }
>>


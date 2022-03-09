Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1164D2EAA
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Mar 2022 13:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbiCIMGT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Mar 2022 07:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiCIMGQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Mar 2022 07:06:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F334172251
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 04:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646827516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zK0rHTm7GvinAxjXqiUVa246YKg1D+hx4a2IrpzADzs=;
        b=T/T5wI9lmqiWX47cH3Vw939gA1pfRiY6/Bayf5zXrVoNjhOn97+/dHHEE96pkSe5nW2SIC
        EFLkOFpMSilbjnHvu6jnF+VLctL6ZdcSBHOx/qDDFdzS/oDay+us3Rpvrde1UfLNe2pFz+
        26GMZ7ZcdUoGW+FOEpADhJ9F8PAWAWw=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-gUsAAKTDM2qjpI1EpclAFQ-1; Wed, 09 Mar 2022 07:05:15 -0500
X-MC-Unique: gUsAAKTDM2qjpI1EpclAFQ-1
Received: by mail-pf1-f200.google.com with SMTP id y2-20020a623202000000b004f6c2892ffeso1437350pfy.12
        for <ceph-devel@vger.kernel.org>; Wed, 09 Mar 2022 04:05:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=zK0rHTm7GvinAxjXqiUVa246YKg1D+hx4a2IrpzADzs=;
        b=b/szHZugPWOMSUq0L49gzLBYbNyXCE0wDGJa1MixXmQ1O1nLbYi+OTR7YOTTnfr4J4
         Owg2eU3OsfJ1HW2krqzXeaPJB8Myw4JW/7lXQpNEylbt8mzD+8WmX4b0CjbMxfBUdy6N
         IVewA5Co46TD2YXBK5XwEKPNtqga71gjKBFSSJbAUHms4NOpxt6VsWFGJ2Jf0QWOARuh
         2EPYcZuIMqFFmRByYkomSQh6bF5TMSM7D/Yod7LEZOOec3NmobPnY+5nBiL8D8QuxO92
         vP0xlh0ogPcBjZKNP1JZ/VxoNvJwp3bByoX0Tdm1+cW15wVgPOQcZZSgLkgoMEuPczDl
         VmXQ==
X-Gm-Message-State: AOAM5304xFZV9B7cAVxklbgLWaHWD2LU//jROlRgZ+kqGk96ba8yUA0C
        LRQthS3Hdm/FJNnb568/RrkTEU0geNRgnIWsCxtfFpTBfZV8BZvOcISZiFpgbRQuzC0UzRyg4Ek
        nkmMpLVl6PSXw+kCd1MT7xivBcBUG+BeJrfnsnIMp7SHVZq8HbeV3ndYwzKnJj57a9twGBFA=
X-Received: by 2002:a17:90a:f286:b0:1bf:9a1e:8f83 with SMTP id fs6-20020a17090af28600b001bf9a1e8f83mr6418607pjb.7.1646827513907;
        Wed, 09 Mar 2022 04:05:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJziFSOrZwchP8PboBMDgmc3B8SfmgPxwS/u3mtxf4SWP9tlAJPFaImPnbrUhS+ZuungQKiAaQ==
X-Received: by 2002:a17:90a:f286:b0:1bf:9a1e:8f83 with SMTP id fs6-20020a17090af28600b001bf9a1e8f83mr6418573pjb.7.1646827513446;
        Wed, 09 Mar 2022 04:05:13 -0800 (PST)
Received: from [10.72.12.86] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 63-20020a630942000000b00372a99c1821sm2201309pgj.21.2022.03.09.04.05.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 04:05:12 -0800 (PST)
Subject: Re: [PATCH v5] ceph: do not dencrypt the dentry name twice for
 readdir
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
References: <20220305122527.1102109-1-xiubli@redhat.com>
 <87h788z67y.fsf@brahms.olymp>
 <a5d1050b-c922-e5a8-8cee-4b74b4695b73@redhat.com>
 <87v8wn78jq.fsf@brahms.olymp>
 <84fc2bde-2fe8-ec78-1145-2cc010259f38@redhat.com>
 <87r17b72yf.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c2fc4a64-e3fe-ff44-1da4-efacd8aabd22@redhat.com>
Date:   Wed, 9 Mar 2022 20:05:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87r17b72yf.fsf@brahms.olymp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/9/22 7:58 PM, Luís Henriques wrote:
> Xiubo Li <xiubli@redhat.com> writes:
>
>> On 3/9/22 5:57 PM, Luís Henriques wrote:
>>> Xiubo Li <xiubli@redhat.com> writes:
>>>
>>>> On 3/9/22 1:47 AM, Luís Henriques wrote:
>>>>> xiubli@redhat.com writes:
>>>>>
>>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>>
>>>>>> For the readdir request the dentries will be pasred and dencrypted
>>>>>> in ceph_readdir_prepopulate(). And in ceph_readdir() we could just
>>>>>> get the dentry name from the dentry cache instead of parsing and
>>>>>> dencrypting them again. This could improve performance.
>>>>>>
>>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>>> ---
>>>>>>
>>>>>> V5:
>>>>>> - fix typo of CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro
>>>>>> - release the rde->dentry in destroy_reply_info
>>>>>>
>>>>>>
>>>>>>     fs/ceph/crypto.h     |  8 ++++++
>>>>>>     fs/ceph/dir.c        | 59 +++++++++++++++++++++-----------------------
>>>>>>     fs/ceph/inode.c      |  7 ++++++
>>>>>>     fs/ceph/mds_client.c |  2 ++
>>>>>>     fs/ceph/mds_client.h |  1 +
>>>>>>     5 files changed, 46 insertions(+), 31 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
>>>>>> index 1e08f8a64ad6..c85cb8c8bd79 100644
>>>>>> --- a/fs/ceph/crypto.h
>>>>>> +++ b/fs/ceph/crypto.h
>>>>>> @@ -83,6 +83,14 @@ static inline u32 ceph_fscrypt_auth_len(struct ceph_fscrypt_auth *fa)
>>>>>>      */
>>>>>>     #define CEPH_NOHASH_NAME_MAX (189 - SHA256_DIGEST_SIZE)
>>>>>>     +/*
>>>>>> + * The encrypted long snap name will be in format of
>>>>>> + * "_${ENCRYPTED-LONG-SNAP-NAME}_${INODE-NUM}". And will set the max longth
>>>>>> + * to sizeof('_') + NAME_MAX + sizeof('_') + max of sizeof(${INO}) + extra 7
>>>>>> + * bytes to align the total size to 8 bytes.
>>>>>> + */
>>>>>> +#define CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX (1 + 255 + 1 + 16 + 7)
>>>>>> +
>>>>> I think this constant needs to be defined in a different way and we need
>>>>> to keep the snapshots names length a bit shorter than NAME_MAX.  And I'm
>>>>> not talking just about the encrypted snapshots.
>>>>>
>>>>> Right now, ceph PR#45192 fixes an MDS limitation that is keeping long
>>>>> snapshot names smaller than 80 characters.  With this limitation we would
>>>>> need to keep the snapshot names < 64:
>>>>>
>>>>>       '_' + <name> + '_' + '<inode#>' '\0'
>>>>>        1  +   64   +  1  +    12     +  1 = 80
>>>>>
>>>>> Note however that currently clients *do* allow to create snapshots with
>>>>> bigger names.  And if we do that we'll get an error when doing an LSSNAP
>>>>> on a .snap subdirectory that will contain the corresponding long name:
>>>>>
>>>>>      # mkdir a/.snap/123456qwertasdfgzxcvb7890yuiophjklnm123456qwertasdfgzxcvb78912345
>>>>>      # ls -li a/b/.snap
>>>>>      ls: a/b/.snap/_123456qwertasdfgzxcvb7890yuiophjklnm123456qwertasdfgzxcvb78912345_109951162777: No such file or directory
>>>>>
>>>>> We can limit the snapshot names on creation, but this should probably be
>>>>> handled on the MDS side (so that old clients won't break anything).  Does
>>>>> this make sense?  I can work on an MDS patch for this but... to which
>>>>> length should names be limited? NAME_MAX - (2*'_' + <inode len>)?  Or
>>>>> should we take base64-encoded names already into account?
>>>>>
>>>>> (Sorry, I'm jumping around between PRs and patches, and trying to make any
>>>>> sense out of the snapshots code :-/ )
>>>> For fscrypt case I think it's okay, because the max len of the encrypted name
>>>> will be 189 bytes, so even plusing the extra 2 * sizeof('_') - sizeof(<inode#>)
>>>> == 15 bytes with ceph PR#41592 it should work well.
>>> Is it really 189 bytes, or 252, which is the result of base64 encoding 189
>>> bytes?
>> Yeah, you are right, I misread that. The 252 is from 189 * 4 / 3, which will be
>> the base64 encoded name.
>>
>> So, I think you should fix this to make the totally of base64 encode name won't
>> bigger than 240 = 255 - 15. So the CEPH_NOHASH_NAME_MAX should be:
>>
>> #define CEPH_NOHASH_NAME_MAX (180 - SHA256_DIGEST_SIZE)
>>
>> ?
> That could be done, but maybe it's not worth it if the MDS returns -EINVAL
> when creating a snapshot with a name that breaks this rule.  Thus, we can
> still have regular file with 189 bytes names and only the snapshots will
> have this extra limitation.  (I've already created PR#45312 for this.)
>
> But I'm OK either way.

IMO your PR will always make sense no matter we will fix it in kclient side.

Will leave this to Jeff :-)

- Xiubo


> Cheers,


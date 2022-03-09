Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82C04D27B9
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Mar 2022 05:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbiCIDW6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 22:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbiCIDW5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 22:22:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB5F415AF22
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 19:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646796118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Wq4xvWxBRiCC/tuaXNwlLSiMAVLJzfGzMfCjYZ/yOM=;
        b=Z8EgN5jkgiAlx/rop3bIgFQim74lDLf4OF3dnADYy3oLCoid/+X+4kwhOkbymt8/62fiV4
        e/iZ2Kcvf6MJbZS0HhpxDMBXZMS5SqiQxezUnmAsHPFk2CrYCgcE1pmrbrjWiFnq3zwnlt
        c1OHnT7mvcBQsh7q32fOCSz4s8gSpyQ=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-Uoh2vQQgPA6Sn5ikdNAUgw-1; Tue, 08 Mar 2022 22:21:57 -0500
X-MC-Unique: Uoh2vQQgPA6Sn5ikdNAUgw-1
Received: by mail-pj1-f72.google.com with SMTP id t10-20020a17090a5d8a00b001bed9556134so2917904pji.5
        for <ceph-devel@vger.kernel.org>; Tue, 08 Mar 2022 19:21:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=3Wq4xvWxBRiCC/tuaXNwlLSiMAVLJzfGzMfCjYZ/yOM=;
        b=xhFEHSmTt6pFvRmoPxEZ7r03atUM9vvs5axSK9EXEuFskHk9inOPPAh0/IzD0mVevA
         uNXOPrIfjtyH6b9hAoxQY88XfXEt2loO4KFBvZfQhqc8JcBBo/N4xdOnX5Yh8hyPM1G0
         CJI43eDM1jtzz+GGKw0zYLA6cVWDGdMkwGHoe2vqhyT1kkzi/6s7fuS12VklKxxiblNS
         T9PzkPNQGnueaoRofk5+MiMMtqDK69GVYp6gA412FFF2wuPQIXNjJhWCR8ENhi8kM32n
         mm2bbfmt6nSPm4v8Ef2XNRU+28HZ6fPIhTsBkMoxr5fD+9IilLaQAmjwrnrtgB1Yo9Gd
         kGrw==
X-Gm-Message-State: AOAM531eBtKTBkuizJauK0BaqdoQ9fFL33tmXFzlAj6fKv1ffNz8ST0G
        9BvCROEypkzfc2BaOemWxQWvOBCj/dJhgXg30ASgeaAe+isrWGoH8GreuhEdUlB5GsXe79KfXIg
        ZwNRbMPVZpCwy0NvkItaEaESTVCuYM+XN+PTWFt23TEPxeb5upm0tENCaTHFc09oAf7IqHNw=
X-Received: by 2002:a17:90b:17ca:b0:1bf:6188:cb5e with SMTP id me10-20020a17090b17ca00b001bf6188cb5emr8091747pjb.89.1646796116270;
        Tue, 08 Mar 2022 19:21:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxwG3kXMbl2f2vSkJHOxSPF2Nory8QW15OiyEb8OfPRd8w9f2jRiSPCDLatV3uEBzo7ZFzymQ==
X-Received: by 2002:a17:90b:17ca:b0:1bf:6188:cb5e with SMTP id me10-20020a17090b17ca00b001bf6188cb5emr8091726pjb.89.1646796115819;
        Tue, 08 Mar 2022 19:21:55 -0800 (PST)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g28-20020a63111c000000b00374646abc42sm493607pgl.36.2022.03.08.19.21.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 19:21:54 -0800 (PST)
Subject: Re: [PATCH v5] ceph: do not dencrypt the dentry name twice for
 readdir
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
References: <20220305122527.1102109-1-xiubli@redhat.com>
 <87h788z67y.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <a5d1050b-c922-e5a8-8cee-4b74b4695b73@redhat.com>
Date:   Wed, 9 Mar 2022 11:21:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87h788z67y.fsf@brahms.olymp>
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


On 3/9/22 1:47 AM, Luís Henriques wrote:
> xiubli@redhat.com writes:
>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> For the readdir request the dentries will be pasred and dencrypted
>> in ceph_readdir_prepopulate(). And in ceph_readdir() we could just
>> get the dentry name from the dentry cache instead of parsing and
>> dencrypting them again. This could improve performance.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V5:
>> - fix typo of CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro
>> - release the rde->dentry in destroy_reply_info
>>
>>
>>   fs/ceph/crypto.h     |  8 ++++++
>>   fs/ceph/dir.c        | 59 +++++++++++++++++++++-----------------------
>>   fs/ceph/inode.c      |  7 ++++++
>>   fs/ceph/mds_client.c |  2 ++
>>   fs/ceph/mds_client.h |  1 +
>>   5 files changed, 46 insertions(+), 31 deletions(-)
>>
>> diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
>> index 1e08f8a64ad6..c85cb8c8bd79 100644
>> --- a/fs/ceph/crypto.h
>> +++ b/fs/ceph/crypto.h
>> @@ -83,6 +83,14 @@ static inline u32 ceph_fscrypt_auth_len(struct ceph_fscrypt_auth *fa)
>>    */
>>   #define CEPH_NOHASH_NAME_MAX (189 - SHA256_DIGEST_SIZE)
>>   
>> +/*
>> + * The encrypted long snap name will be in format of
>> + * "_${ENCRYPTED-LONG-SNAP-NAME}_${INODE-NUM}". And will set the max longth
>> + * to sizeof('_') + NAME_MAX + sizeof('_') + max of sizeof(${INO}) + extra 7
>> + * bytes to align the total size to 8 bytes.
>> + */
>> +#define CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX (1 + 255 + 1 + 16 + 7)
>> +
> I think this constant needs to be defined in a different way and we need
> to keep the snapshots names length a bit shorter than NAME_MAX.  And I'm
> not talking just about the encrypted snapshots.
>
> Right now, ceph PR#45192 fixes an MDS limitation that is keeping long
> snapshot names smaller than 80 characters.  With this limitation we would
> need to keep the snapshot names < 64:
>
>     '_' + <name> + '_' + '<inode#>' '\0'
>      1  +   64   +  1  +    12     +  1 = 80
>
> Note however that currently clients *do* allow to create snapshots with
> bigger names.  And if we do that we'll get an error when doing an LSSNAP
> on a .snap subdirectory that will contain the corresponding long name:
>
>    # mkdir a/.snap/123456qwertasdfgzxcvb7890yuiophjklnm123456qwertasdfgzxcvb78912345
>    # ls -li a/b/.snap
>    ls: a/b/.snap/_123456qwertasdfgzxcvb7890yuiophjklnm123456qwertasdfgzxcvb78912345_109951162777: No such file or directory
>
> We can limit the snapshot names on creation, but this should probably be
> handled on the MDS side (so that old clients won't break anything).  Does
> this make sense?  I can work on an MDS patch for this but... to which
> length should names be limited? NAME_MAX - (2*'_' + <inode len>)?  Or
> should we take base64-encoded names already into account?
>
> (Sorry, I'm jumping around between PRs and patches, and trying to make any
> sense out of the snapshots code :-/ )

For fscrypt case I think it's okay, because the max len of the encrypted 
name will be 189 bytes, so even plusing the extra 2 * sizeof('_') - 
sizeof(<inode#>)  == 15 bytes with ceph PR#41592 it should work well.

But for none fscrypt case, we must limit the max len to NAME_MAX - 2 * 
sizeof('_') - sizeof(<inode#>) == 255 - 2 - 13 == 240. So fixing this in 
MDS side makes sense IMO.

- Xiubo

> Cheers,


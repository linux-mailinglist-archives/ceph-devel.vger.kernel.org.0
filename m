Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCFE4D2CDC
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Mar 2022 11:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiCIKMj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Mar 2022 05:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiCIKMj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Mar 2022 05:12:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8EF916A591
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 02:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646820696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cbfb366ZkDSzxZK5jYsxwTNE/kSKHXFjtV5zW8Uhs+w=;
        b=iAE7svMQJrdnSIZ02b5SBFSfEXDTzfaiwAYZvdDaha33bY+5115ASBplDPqJdJeuCkajdA
        7n1U6tp7qx6ETJw0uGv5bAE7MmWWE6NRXxYkFKDMoznt+/ghlDtvRK7gbpFN6UfLeoqwi9
        4XCtUMOgnho+cZdUwYb9aMHu+cvOiK4=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-NALdZ9j-P7SuZ8xxvZxaYA-1; Wed, 09 Mar 2022 05:11:35 -0500
X-MC-Unique: NALdZ9j-P7SuZ8xxvZxaYA-1
Received: by mail-pj1-f71.google.com with SMTP id e14-20020a17090a684e00b001bf09ac2385so1300960pjm.1
        for <ceph-devel@vger.kernel.org>; Wed, 09 Mar 2022 02:11:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Cbfb366ZkDSzxZK5jYsxwTNE/kSKHXFjtV5zW8Uhs+w=;
        b=xmJiswAzEXrs7kw0UpJdPLevc98isaHVL77XEvo1DHH7v3Q4K1jZBAp8pKGRtWD3+8
         /scMeSNrkjMzx0i983wFrb7L26/Jv3CNGR5mpf9WgTxgGXXbKjq6565Q+yCiHQyD46f3
         9ai7TmTjp93mhNfWWXmVQ3ldWgJYKZB/h9EAnQMU3a2VUzgwLEKOxc4otzeHvj0EVgwl
         zI/FBoK7LIrwyjsUi44Es7fnBfVCvoRydPZWB0MABulAa5aT9YAGeG2MoYI9ZfsWcDPv
         /jNA72s8NoX98lPKQRem0+JOSsfdnPXTOtZ2qtsgnTQWtqZhNur9MuvIJJQ3D5PKZ2pJ
         pcVQ==
X-Gm-Message-State: AOAM533qTvZ9evuL2Uj3fvowGL4/b3S0/0Gi0ToXXyfchT8+FA35evtP
        Zc1Y+ytPoyXsNQDNLQuHpYnbY8RyNxbwKlnbLQTQ1qIYVp8d63aTts7f1OnVLXPwygstzZktkNp
        NZ+g5Vcr2BdSJPVRvaE0kZ/+NvzFWhSn2zEczxJYJ2AdXdmptAMAXlT1ogoZ9NgBRB3qO/MM=
X-Received: by 2002:a05:6a00:2402:b0:4e1:3df2:5373 with SMTP id z2-20020a056a00240200b004e13df25373mr22489189pfh.40.1646820693961;
        Wed, 09 Mar 2022 02:11:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxmbXGZ+9ncuZD1NDPes+76iDkr13m8C2jdbHJQ7FK7zBuFf9uHKe8neY2OK3NHbv+P44M5gQ==
X-Received: by 2002:a05:6a00:2402:b0:4e1:3df2:5373 with SMTP id z2-20020a056a00240200b004e13df25373mr22489148pfh.40.1646820693553;
        Wed, 09 Mar 2022 02:11:33 -0800 (PST)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a00115000b004f6ff260c9esm2181671pfm.207.2022.03.09.02.11.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 02:11:31 -0800 (PST)
Subject: Re: [PATCH v5] ceph: do not dencrypt the dentry name twice for
 readdir
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
References: <20220305122527.1102109-1-xiubli@redhat.com>
 <87h788z67y.fsf@brahms.olymp>
 <a5d1050b-c922-e5a8-8cee-4b74b4695b73@redhat.com>
 <87v8wn78jq.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <84fc2bde-2fe8-ec78-1145-2cc010259f38@redhat.com>
Date:   Wed, 9 Mar 2022 18:11:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87v8wn78jq.fsf@brahms.olymp>
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


On 3/9/22 5:57 PM, Luís Henriques wrote:
> Xiubo Li <xiubli@redhat.com> writes:
>
>> On 3/9/22 1:47 AM, Luís Henriques wrote:
>>> xiubli@redhat.com writes:
>>>
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> For the readdir request the dentries will be pasred and dencrypted
>>>> in ceph_readdir_prepopulate(). And in ceph_readdir() we could just
>>>> get the dentry name from the dentry cache instead of parsing and
>>>> dencrypting them again. This could improve performance.
>>>>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>
>>>> V5:
>>>> - fix typo of CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro
>>>> - release the rde->dentry in destroy_reply_info
>>>>
>>>>
>>>>    fs/ceph/crypto.h     |  8 ++++++
>>>>    fs/ceph/dir.c        | 59 +++++++++++++++++++++-----------------------
>>>>    fs/ceph/inode.c      |  7 ++++++
>>>>    fs/ceph/mds_client.c |  2 ++
>>>>    fs/ceph/mds_client.h |  1 +
>>>>    5 files changed, 46 insertions(+), 31 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
>>>> index 1e08f8a64ad6..c85cb8c8bd79 100644
>>>> --- a/fs/ceph/crypto.h
>>>> +++ b/fs/ceph/crypto.h
>>>> @@ -83,6 +83,14 @@ static inline u32 ceph_fscrypt_auth_len(struct ceph_fscrypt_auth *fa)
>>>>     */
>>>>    #define CEPH_NOHASH_NAME_MAX (189 - SHA256_DIGEST_SIZE)
>>>>    +/*
>>>> + * The encrypted long snap name will be in format of
>>>> + * "_${ENCRYPTED-LONG-SNAP-NAME}_${INODE-NUM}". And will set the max longth
>>>> + * to sizeof('_') + NAME_MAX + sizeof('_') + max of sizeof(${INO}) + extra 7
>>>> + * bytes to align the total size to 8 bytes.
>>>> + */
>>>> +#define CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX (1 + 255 + 1 + 16 + 7)
>>>> +
>>> I think this constant needs to be defined in a different way and we need
>>> to keep the snapshots names length a bit shorter than NAME_MAX.  And I'm
>>> not talking just about the encrypted snapshots.
>>>
>>> Right now, ceph PR#45192 fixes an MDS limitation that is keeping long
>>> snapshot names smaller than 80 characters.  With this limitation we would
>>> need to keep the snapshot names < 64:
>>>
>>>      '_' + <name> + '_' + '<inode#>' '\0'
>>>       1  +   64   +  1  +    12     +  1 = 80
>>>
>>> Note however that currently clients *do* allow to create snapshots with
>>> bigger names.  And if we do that we'll get an error when doing an LSSNAP
>>> on a .snap subdirectory that will contain the corresponding long name:
>>>
>>>     # mkdir a/.snap/123456qwertasdfgzxcvb7890yuiophjklnm123456qwertasdfgzxcvb78912345
>>>     # ls -li a/b/.snap
>>>     ls: a/b/.snap/_123456qwertasdfgzxcvb7890yuiophjklnm123456qwertasdfgzxcvb78912345_109951162777: No such file or directory
>>>
>>> We can limit the snapshot names on creation, but this should probably be
>>> handled on the MDS side (so that old clients won't break anything).  Does
>>> this make sense?  I can work on an MDS patch for this but... to which
>>> length should names be limited? NAME_MAX - (2*'_' + <inode len>)?  Or
>>> should we take base64-encoded names already into account?
>>>
>>> (Sorry, I'm jumping around between PRs and patches, and trying to make any
>>> sense out of the snapshots code :-/ )
>> For fscrypt case I think it's okay, because the max len of the encrypted name
>> will be 189 bytes, so even plusing the extra 2 * sizeof('_') - sizeof(<inode#>)
>> == 15 bytes with ceph PR#41592 it should work well.
> Is it really 189 bytes, or 252, which is the result of base64 encoding 189
> bytes?

Yeah, you are right, I misread that. The 252 is from 189 * 4 / 3, which 
will be the base64 encoded name.

So, I think you should fix this to make the totally of base64 encode 
name won't bigger than 240 = 255 - 15. So the CEPH_NOHASH_NAME_MAX 
should be:

#define CEPH_NOHASH_NAME_MAX (180 - SHA256_DIGEST_SIZE)

?


>   Reading the documentation in the CEPH_NOHASH_NAME_MAX definition
> it seems to be 252.  And in that case we need to limit the names length
> even further.
>
>> But for none fscrypt case, we must limit the max len to NAME_MAX - 2 *
>> sizeof('_') - sizeof(<inode#>) == 255 - 2 - 13 == 240. So fixing this in
>> MDS side makes sense IMO.
> Yeah, I suppose this makes sense.  I can send out a PR soon with this, and
> try to document it somewhere.  But it may make sense to merge both PRs at
> the same time and *backport* them to older releases.

Yeah, make sense.

- Xiubo

> Cheers,


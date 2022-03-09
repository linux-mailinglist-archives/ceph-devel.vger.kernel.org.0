Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93204D2CF3
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Mar 2022 11:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiCIKS3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Mar 2022 05:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiCIKSZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Mar 2022 05:18:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E40916A5BC
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 02:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646821044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Mb3Dzv4PuVTfwuOZ3U/bZUkm14X1FBnu7l0ZDO/Cy0=;
        b=gAryzCgyiWywmhVcoRxHl8+YllhGUmeL/6bsUI3IG1U7tuD7oz4Q0nHpUxPAkmfuP1CLG1
        mHi6PdcpHqWwRRjY/OusWs93SBcO0n3ZFKriMgeS3jOQaqICP23AruA5ai/u7RwlY443fV
        z66mOlK7Ls7k4RPEaYD1vql0SRykxkk=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-MQ_3_PhqPeC51U19K9KYuw-1; Wed, 09 Mar 2022 05:17:23 -0500
X-MC-Unique: MQ_3_PhqPeC51U19K9KYuw-1
Received: by mail-pl1-f199.google.com with SMTP id p20-20020a170902e35400b00151c5d5a3b6so915091plc.9
        for <ceph-devel@vger.kernel.org>; Wed, 09 Mar 2022 02:17:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5Mb3Dzv4PuVTfwuOZ3U/bZUkm14X1FBnu7l0ZDO/Cy0=;
        b=MV5WtBVEv1w77AGFz7sBwDb0uwhzFI4knW/4mIF8EA1lcltUplzJziaDb1fkVx//lr
         mWL1ZM2hMXMTcqB2pv26C6tNr0JJ6b/gDfTvg4IL7Sgb/EP084KPeDetrioLN/w8W7vK
         TiVrGzjHPOeEbPs5MtFaW38oARu8Y4T9+oYozWEsy0d3cTv1WGuy2nfX+QCmuCbMixR7
         Z6E4O8SY8aeDmBsa3D3neClN/zCUrKhqrc2ra5nnaZP/5UZXGmqiV++cw4EHVDUZt4qm
         xQ4++d+dN3A2X8KtkcT4n8z8g69kkCfsWeZLXqH9G5dllI/bXxR0fqMMAx5kMbruOZ3i
         SZFQ==
X-Gm-Message-State: AOAM5331kOUFByVEpR738su20DJc2VNi6dObFV0enPdAxSwMuBuXKkxO
        WBpiGDXu+gsYgTqgBShJ6R87XVBGc94dmC/Y1oTd0VyMBnOLM8PQzs1EhyK+FTZ46x0lZ4TPDBc
        Wa2CdMEIBVIcNsG2CHeA4VA1yfSQmJ274sxWjhh5XZKsVrAXfjY2jnpvLuP6jRalpra2w7GQ=
X-Received: by 2002:a63:85c8:0:b0:380:3444:d682 with SMTP id u191-20020a6385c8000000b003803444d682mr13008330pgd.163.1646821040793;
        Wed, 09 Mar 2022 02:17:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzwcQDWydB1CqP76vtExp63A1lmJ5LN5wX8ochf7jnTPs5QQHfCT++SyVA/3uSHWf6z9ddPYQ==
X-Received: by 2002:a63:85c8:0:b0:380:3444:d682 with SMTP id u191-20020a6385c8000000b003803444d682mr13008308pgd.163.1646821040405;
        Wed, 09 Mar 2022 02:17:20 -0800 (PST)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h2-20020a056a00218200b004f6519ce666sm2376908pfi.170.2022.03.09.02.17.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 02:17:19 -0800 (PST)
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
Message-ID: <6db10915-ed91-08fe-2887-50f4d418628b@redhat.com>
Date:   Wed, 9 Mar 2022 18:17:13 +0800
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

So for this the max length of the long snap name shouldn't exceed 
NAME_MAX in both cases, I will remove this macro and use NAME_MAX 
directly instead.

- Xiubo



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
> bytes?  Reading the documentation in the CEPH_NOHASH_NAME_MAX definition
> it seems to be 252.  And in that case we need to limit the names length
> even further.
>
>> But for none fscrypt case, we must limit the max len to NAME_MAX - 2 *
>> sizeof('_') - sizeof(<inode#>) == 255 - 2 - 13 == 240. So fixing this in
>> MDS side makes sense IMO.
> Yeah, I suppose this makes sense.  I can send out a PR soon with this, and
> try to document it somewhere.  But it may make sense to merge both PRs at
> the same time and *backport* them to older releases.
>
> Cheers,


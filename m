Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1980260EDDB
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Oct 2022 04:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbiJ0CUD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Oct 2022 22:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233917AbiJ0CUB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Oct 2022 22:20:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710E417A90
        for <ceph-devel@vger.kernel.org>; Wed, 26 Oct 2022 19:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666837197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ySawee8Z+CugvTjjXC6Vf4C7DjJBU7mCotA9cvVRhZo=;
        b=fawimPVWzroHAtu8ceQ61UnvgPOy0gaQvmT7mFelAUSlD2yf8cgRDZqD3T+mmDGEtOfr2h
        YljNAgTk9ArjTes1pjodbg6FCc5iYlm2Ge8yOpyPJBnWa73jYaU10n42o1HB6n5K3blDEb
        O2F3cV5VLBpdgXR11rfWZ6lI5cY6fho=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-572-o9Yk3DlnNsKVAbhSjnpMCw-1; Wed, 26 Oct 2022 22:19:53 -0400
X-MC-Unique: o9Yk3DlnNsKVAbhSjnpMCw-1
Received: by mail-pf1-f197.google.com with SMTP id cb7-20020a056a00430700b00561b86e0265so28835pfb.13
        for <ceph-devel@vger.kernel.org>; Wed, 26 Oct 2022 19:19:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ySawee8Z+CugvTjjXC6Vf4C7DjJBU7mCotA9cvVRhZo=;
        b=6bv1CdHZwVL8iO+9QldFSZ7kFDtcPs5sBtGkPAywQOL9Lema8bTz/0izrA712p4f0w
         MyAx/LCpQYw+OGvmYsQxEcEKnW3COfxKLpdmN8Tz6/SFqSNDWtmVhXnZDEKTWW+EGOUo
         jKQWYajYwDCCRQ2yH4PmJmgvfsCjReHt4+ix924tg3fuCEXDlmP7DyU8KjVC9A+o5sfs
         xSaae2DizNvLbRx51b/Hnc5lfwNKgklgEW59YYyOBnZoc0J412nAU+DYKQTg9dEBZDLS
         dLH0aFtH9yD9U4A5K6pbLuFPGvO6r+gLUI65AJazuWviY9pv68x0CRLGU2KYg23i3hMo
         o/3g==
X-Gm-Message-State: ACrzQf2TukeT7+lZWz0/1BgRrZh2BPXmVE4q7VcZ9i/OR8/ASVJJMEjs
        DsIpvSoi4oZlDiCe+3BuMPkJ/oCjRDfklipcOrKe0esA2BI6M9t/aVs/+DYya2mdkj7Fn8nXOM4
        b5pNNzGVWp1xDbdqWxZLg7A==
X-Received: by 2002:a17:902:b907:b0:178:9d11:c978 with SMTP id bf7-20020a170902b90700b001789d11c978mr47276140plb.90.1666837192452;
        Wed, 26 Oct 2022 19:19:52 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM57ICXUOgaxjGPEgrbs3nj7m1L27wU7D3gyCicm0Ta//pD2JpNhy1sk4ZOZMezrNJJF8QaOMw==
X-Received: by 2002:a17:902:b907:b0:178:9d11:c978 with SMTP id bf7-20020a170902b90700b001789d11c978mr47276122plb.90.1666837192198;
        Wed, 26 Oct 2022 19:19:52 -0700 (PDT)
Received: from [10.72.12.170] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bd13-20020a656e0d000000b0043c9da02729sm4044pgb.6.2022.10.26.19.19.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 19:19:51 -0700 (PDT)
Subject: Re: [PATCH 1/2] encrypt: rename _scratch_mkfs_encrypted to
 _scratch_check_encrypted
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, david@fromorbit.com, djwong@kernel.org,
        lhenriques@suse.de, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com
References: <20221026070418.259351-1-xiubli@redhat.com>
 <20221026070418.259351-2-xiubli@redhat.com>
 <20221026140444.6br63mundxivfsnn@zlang-mailbox>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c2796b1a-ed80-2951-c690-74a05aefbb3e@redhat.com>
Date:   Thu, 27 Oct 2022 10:19:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20221026140444.6br63mundxivfsnn@zlang-mailbox>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 26/10/2022 22:04, Zorro Lang wrote:
> On Wed, Oct 26, 2022 at 03:04:17PM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> For ceph we couldn't check the encryption feature by mkfs, we need
>> to mount it first and then check the 'get_encpolicy' ioctl cmd.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
> This patch only does an *incomplete* function rename, without any change
> on that function body, that doesn't make sense, and even will bring in
> regression, due to lots of cases depend on this common function. If you
> really need to change a common function, please "grep" [1] this function
> in xfstests-dev/ to find out and check all places use it at least.
>
> The _scratch_mkfs_encrypted is a "mkfs" function, likes _scratch_mkfs. I
> think we shouldn't change its name. If you want to check if encryption
> feature is supported by ceph, I think you might hope to do that in
> _require_* functions, or you even can have a ceph specific function in
> common/ceph. Just not the way you did in this patchset.

Okay, make sense and will do that.

Thanks Zorro.

- Xiubo

>
> Thanks,
> Zorro
>
> [1]
> $ grep -rsn _scratch_mkfs_encrypted .
> ./common/encrypt:32:    if ! _scratch_mkfs_encrypted &>>$seqres.full; then
> ./common/encrypt:146:_scratch_mkfs_encrypted()
> ./common/encrypt:174:# Like _scratch_mkfs_encrypted(), but add -O stable_inodes if applicable for the
> ./common/encrypt:186:           _scratch_mkfs_encrypted
> ./common/encrypt:926:           _scratch_mkfs_encrypted &>> $seqres.full
> ./common/verity:178:_scratch_mkfs_encrypted_verity()
> ./common/verity:190:            _notrun "$FSTYP not supported in _scratch_mkfs_encrypted_verity"
> ./tests/ext4/024:36:_scratch_mkfs_encrypted &>>$seqres.full
> ./tests/generic/395:22:_scratch_mkfs_encrypted &>> $seqres.full
> ./tests/generic/396:21:_scratch_mkfs_encrypted &>> $seqres.full
> ./tests/generic/580:23:_scratch_mkfs_encrypted &>> $seqres.full
> ./tests/generic/581:36:_scratch_mkfs_encrypted &>> $seqres.full
> ./tests/generic/595:35:_scratch_mkfs_encrypted &>> $seqres.full
> ./tests/generic/613:29:_scratch_mkfs_encrypted &>> $seqres.full
> ./tests/generic/621:57:_scratch_mkfs_encrypted &>> $seqres.full
> ./tests/generic/429:36:_scratch_mkfs_encrypted &>> $seqres.full
> ./tests/generic/397:28:_scratch_mkfs_encrypted &>> $seqres.full
> ./tests/generic/398:28:_scratch_mkfs_encrypted &>> $seqres.full
> ./tests/generic/421:24:_scratch_mkfs_encrypted &>> $seqres.full
> ./tests/generic/440:29:_scratch_mkfs_encrypted &>> $seqres.full
> ./tests/generic/419:29:_scratch_mkfs_encrypted &>> $seqres.full
> ./tests/generic/435:33:_scratch_mkfs_encrypted &>> $seqres.full
> ./tests/generic/593:24:_scratch_mkfs_encrypted &>> $seqres.full
> ./tests/generic/576:34:_scratch_mkfs_encrypted_verity &>> $seqres.full
>
>
>
>>   common/encrypt | 10 +++++-----
>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/common/encrypt b/common/encrypt
>> index 45ce0954..fd620c41 100644
>> --- a/common/encrypt
>> +++ b/common/encrypt
>> @@ -29,7 +29,7 @@ _require_scratch_encryption()
>>   	# Make a filesystem on the scratch device with the encryption feature
>>   	# enabled.  If this fails then probably the userspace tools (e.g.
>>   	# e2fsprogs or f2fs-tools) are too old to understand encryption.
>> -	if ! _scratch_mkfs_encrypted &>>$seqres.full; then
>> +	if ! _scratch_check_encrypted &>>$seqres.full; then
>>   		_notrun "$FSTYP userspace tools do not support encryption"
>>   	fi
>>   
>> @@ -143,7 +143,7 @@ _require_encryption_policy_support()
>>   	rm -r $dir
>>   }
>>   
>> -_scratch_mkfs_encrypted()
>> +_scratch_check_encrypted()
>>   {
>>   	case $FSTYP in
>>   	ext4|f2fs)
>> @@ -171,7 +171,7 @@ _scratch_mkfs_sized_encrypted()
>>   	esac
>>   }
>>   
>> -# Like _scratch_mkfs_encrypted(), but add -O stable_inodes if applicable for the
>> +# Like _scratch_check_encrypted(), but add -O stable_inodes if applicable for the
>>   # filesystem type.  This is necessary for using encryption policies that include
>>   # the inode number in the IVs, e.g. policies with the IV_INO_LBLK_64 flag set.
>>   _scratch_mkfs_stable_inodes_encrypted()
>> @@ -183,7 +183,7 @@ _scratch_mkfs_stable_inodes_encrypted()
>>   		fi
>>   		;;
>>   	*)
>> -		_scratch_mkfs_encrypted
>> +		_scratch_check_encrypted
>>   		;;
>>   	esac
>>   }
>> @@ -923,7 +923,7 @@ _verify_ciphertext_for_encryption_policy()
>>   			      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) )); then
>>   		_scratch_mkfs_stable_inodes_encrypted &>> $seqres.full
>>   	else
>> -		_scratch_mkfs_encrypted &>> $seqres.full
>> +		_scratch_check_encrypted &>> $seqres.full
>>   	fi
>>   	_scratch_mount
>>   
>> -- 
>> 2.31.1
>>


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30EB16106EA
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Oct 2022 02:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbiJ1Ajb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Oct 2022 20:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbiJ1Aja (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Oct 2022 20:39:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EEEA3F42
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 17:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666917520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4ADIEZawkcx3YtMdsZXuloTuGk1wcgplOQXuegEEig8=;
        b=PP7coB7twla0V+buo/t58bcIKGDHBBxC7A80QvWK6/UajY2RJWX7alVxkOUKJ1512P+9HP
        f4nFvj5Ws9xhXwJGtqS4+Kgpzr+Luehw9wcR8OHxn3jUPR0HP03eRQfp/35jgP13cJoVtZ
        V3drSgWgofRZ62jIyVs+QamCQcgudL8=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-122-Lo3nNu6yOt-BfU6-DdMypQ-1; Thu, 27 Oct 2022 20:38:39 -0400
X-MC-Unique: Lo3nNu6yOt-BfU6-DdMypQ-1
Received: by mail-pl1-f200.google.com with SMTP id m11-20020a170902db0b00b00186d72ea4b8so2188149plx.23
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 17:38:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ADIEZawkcx3YtMdsZXuloTuGk1wcgplOQXuegEEig8=;
        b=5dIvF/IGneHwMIncgKwPwUFa6wt4ncIja1K1LrJlvtbjV48rVE8JOSWvVPxdxm1et9
         vh7w6fx2tOwZCWA0mxZ7QlVfmMlzQ/79jGMM+RbT0TpMTIlIJfinLOHJGu4h+5StuAtt
         mIBSAXjRXwhZhSxGbQiJqNBVDYpKnsi1sr65trnoDSftiiVCivoMuGGYENRgxnXIOZ6G
         j4Neziqgln0pmUHH5IvyQwiFexYHg4/CdjSL5xfeCGTvY+xb5ju2y/oVLVsC/rRpW1AT
         duv12sJSppZEHcCsPgLhfOgCdL6eA0yMNLZAW1CBa8mYwi294WbeuVBSVv9jutjdVMx1
         UzZQ==
X-Gm-Message-State: ACrzQf303k6kOrIpDeUATuMYJ0QqJxTLkqPOju0ywnN+XP+xBeLVWTja
        yUEKlTgMWKoNO9zy83QqWhYjyl554zRPevp6xSt4kHvkUFrJznlPzRq2mX8HhqV1z5HplDJW/Fv
        TuBM5y5xY/rLOHQlcJTNxjg==
X-Received: by 2002:a63:4f15:0:b0:455:ede1:d8c9 with SMTP id d21-20020a634f15000000b00455ede1d8c9mr45050179pgb.452.1666917518316;
        Thu, 27 Oct 2022 17:38:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6BhyVlPedjo8ASk8uEp5ZufY7KRAkPkiHjLX5rcdFmU/X1TnXhsYnio4NbEqA/h0bAcn4S2Q==
X-Received: by 2002:a63:4f15:0:b0:455:ede1:d8c9 with SMTP id d21-20020a634f15000000b00455ede1d8c9mr45050163pgb.452.1666917518023;
        Thu, 27 Oct 2022 17:38:38 -0700 (PDT)
Received: from [10.72.13.65] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 184-20020a6217c1000000b0056bb0357f5bsm1700931pfx.192.2022.10.27.17.38.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 17:38:37 -0700 (PDT)
Subject: Re: [PATCH v2] encrypt: add ceph support
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, david@fromorbit.com, djwong@kernel.org,
        lhenriques@suse.de, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com
References: <20221027030021.296548-1-xiubli@redhat.com>
 <20221027032023.6arvnrkl7fymdjqj@zlang-mailbox>
 <e5c876ce-8f0d-c51e-bb04-78c49ebf79c9@redhat.com>
 <20221027124904.ibx62eqbyyqghdjm@zlang-mailbox>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b2f811ee-b927-d448-1c1a-85af4fc7e42f@redhat.com>
Date:   Fri, 28 Oct 2022 08:38:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20221027124904.ibx62eqbyyqghdjm@zlang-mailbox>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 27/10/2022 20:49, Zorro Lang wrote:
> On Thu, Oct 27, 2022 at 05:49:08PM +0800, Xiubo Li wrote:
>> On 27/10/2022 11:20, Zorro Lang wrote:
>>> On Thu, Oct 27, 2022 at 11:00:21AM +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    common/encrypt | 3 +++
>>>>    1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/common/encrypt b/common/encrypt
>>>> index 45ce0954..1a77e23b 100644
>>>> --- a/common/encrypt
>>>> +++ b/common/encrypt
>>>> @@ -153,6 +153,9 @@ _scratch_mkfs_encrypted()
>>>>    		# erase the UBI volume; reformated automatically on next mount
>>>>    		$UBIUPDATEVOL_PROG ${SCRATCH_DEV} -t
>>>>    		;;
>>>> +	ceph)
>>>> +		_scratch_cleanup_files
>> Here I just skip ceph and it is enough. Because the
>> _require_scratch_encryption() will do the same thing as I did in my V1's 2/2
>> patch.
> Great, actually that's what I hope to know. So the ceph encryption testing
> can be supported naturally by just enabling ceph in _scratch_mkfs_encrypted.
>
> And from the testing output you showed in last patch, it looks good on testing
> ceph encryption. So I think this patch works as expected. I'll merger this
> patch if no more review points from ceph list. And feel free to improve cases
> in encrypt group later if someone fails on ceph.

Sure. Thanks very much Zorro!

- Xiubo


> Thanks,
> Zorro
>
>> - Xiubo
>>
>>>> +		;;
>>> Any commits about that?
>>>
>>> Sorry I'm not familar with cephfs, is this patch enough to help ceph to test
>>> encrypted ceph? Due to you tried to do some "checking" job last time.
>>>
>>> Can "./check -g encrypt" work on ceph? May you paste this test result to help
>>> to review? And welcome review points from ceph list.
>>>
>>> Thanks,
>>> Zorro
>>>
>>> [1]
>>> $ grep -rsn _scratch_mkfs_encrypted tests/generic/
>>> tests/generic/395:22:_scratch_mkfs_encrypted &>> $seqres.full
>>> tests/generic/396:21:_scratch_mkfs_encrypted &>> $seqres.full
>>> tests/generic/580:23:_scratch_mkfs_encrypted &>> $seqres.full
>>> tests/generic/581:36:_scratch_mkfs_encrypted &>> $seqres.full
>>> tests/generic/595:35:_scratch_mkfs_encrypted &>> $seqres.full
>>> tests/generic/613:29:_scratch_mkfs_encrypted &>> $seqres.full
>>> tests/generic/621:57:_scratch_mkfs_encrypted &>> $seqres.full
>>> tests/generic/429:36:_scratch_mkfs_encrypted &>> $seqres.full
>>> tests/generic/397:28:_scratch_mkfs_encrypted &>> $seqres.full
>>> tests/generic/398:28:_scratch_mkfs_encrypted &>> $seqres.full
>>> tests/generic/421:24:_scratch_mkfs_encrypted &>> $seqres.full
>>> tests/generic/440:29:_scratch_mkfs_encrypted &>> $seqres.full
>>> tests/generic/419:29:_scratch_mkfs_encrypted &>> $seqres.full
>>> tests/generic/435:33:_scratch_mkfs_encrypted &>> $seqres.full
>>> tests/generic/593:24:_scratch_mkfs_encrypted &>> $seqres.full
>>> tests/generic/576:34:_scratch_mkfs_encrypted_verity &>> $seqres.full
>>>
>>>>    	*)
>>>>    		_notrun "No encryption support for $FSTYP"
>>>>    		;;
>>>> -- 
>>>> 2.31.1
>>>>


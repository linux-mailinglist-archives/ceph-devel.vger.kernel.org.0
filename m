Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C1960EDE1
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Oct 2022 04:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbiJ0CW2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Oct 2022 22:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbiJ0CW1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Oct 2022 22:22:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745CE76562
        for <ceph-devel@vger.kernel.org>; Wed, 26 Oct 2022 19:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666837345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MRQCDKG424hoLQ3Rdxsb+LxJnRBxQa3n1cGyU6McfhA=;
        b=XIvq598KFo9JQ2wm95MRtG5zmyLnb2sTAXsvPukkK6D4gyc9M2RgazUoN432KNc9jgrtjL
        sOrwki2xQoOQIs0GXY3d58hEmevSvB443r0kQN/+zIpSi7Kf3p0u5+dWvnTWkCELQh3b5W
        oJphG5HvpyfIWgJicrc6kifG3ahoQPI=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-456-J5ZDXCFANKmm8gCiYOpGaQ-1; Wed, 26 Oct 2022 22:22:22 -0400
X-MC-Unique: J5ZDXCFANKmm8gCiYOpGaQ-1
Received: by mail-pl1-f198.google.com with SMTP id l16-20020a170902f69000b001865f863784so8455plg.2
        for <ceph-devel@vger.kernel.org>; Wed, 26 Oct 2022 19:22:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MRQCDKG424hoLQ3Rdxsb+LxJnRBxQa3n1cGyU6McfhA=;
        b=eNKRiW9oY7taXk9t3Rm3Py4Eh5vSvGo/12NSGF0Co/Yts49LYN+hSkXHgyw9f2yuFr
         fH1dipe930VtitbOdBbw/XRpQEf/ZYoRtX6eyKlZfk0oYc/SB/5sDO7bNegTA1GJhgQX
         dfDV32Y6Ah0o1Ui2BJVOJgrHwq8cNlyWFBQ3oWtTjAm3ZC6pSMsnp6vvaTZ2x1QWwc22
         lLOtGAzYKTVoM3iSz0n8W4WWa+8Q3ZoAr5ognj2V8GWhMTLRO2lmxVybZ1MODrx6DHDW
         28gR8aJgLlTe9+5XNBf+3cCZH8KwKuvqoD77t+rO+5inF/ZRLT9+RW41vGjLOu3GINOG
         komg==
X-Gm-Message-State: ACrzQf2cjSkj2GK172+sVhjFYbIftp0aImfvMof/P8Zy3CzCo8u5SuGh
        3diTmlrYqiM0ux8cBTpBqThlkcHaNZj6eQ275dZLaRi6Auj82EeJjJeP8S7mfxqZBlULCtcG6Ey
        i4bAVH47AnvxREKe1zcjoVg==
X-Received: by 2002:a17:902:ab8f:b0:185:46d3:8c96 with SMTP id f15-20020a170902ab8f00b0018546d38c96mr49098126plr.136.1666837341864;
        Wed, 26 Oct 2022 19:22:21 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7VRZx5hSUV7wk7J0FKi6HlR2ODkTc9vbFPVMfuEepb7CT5kCIkMxcDY4t7fd9cbF2Lee22AA==
X-Received: by 2002:a17:902:ab8f:b0:185:46d3:8c96 with SMTP id f15-20020a170902ab8f00b0018546d38c96mr49098110plr.136.1666837341593;
        Wed, 26 Oct 2022 19:22:21 -0700 (PDT)
Received: from [10.72.12.170] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mv10-20020a17090b198a00b00212c27abcaesm1739516pjb.17.2022.10.26.19.22.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 19:22:20 -0700 (PDT)
Subject: Re: [PATCH 2/2] encrypt: add ceph support
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, david@fromorbit.com, djwong@kernel.org,
        lhenriques@suse.de, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com
References: <20221026070418.259351-1-xiubli@redhat.com>
 <20221026070418.259351-3-xiubli@redhat.com>
 <20221026141218.wg2h3ganvo2dx7hb@zlang-mailbox>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <9a8eaafa-fb5e-72dc-359e-edfb7cf5b954@redhat.com>
Date:   Thu, 27 Oct 2022 10:22:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20221026141218.wg2h3ganvo2dx7hb@zlang-mailbox>
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


On 26/10/2022 22:12, Zorro Lang wrote:
> On Wed, Oct 26, 2022 at 03:04:18PM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> For ceph we couldn't use the mkfs to check whether the encryption
>> is support or not, we need to mount it first and then check the
>> 'set_encpolicy', etc.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   common/encrypt | 17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
>>
>> diff --git a/common/encrypt b/common/encrypt
>> index fd620c41..e837c9de 100644
>> --- a/common/encrypt
>> +++ b/common/encrypt
>> @@ -153,6 +153,23 @@ _scratch_check_encrypted()
>>   		# erase the UBI volume; reformated automatically on next mount
>>   		$UBIUPDATEVOL_PROG ${SCRATCH_DEV} -t
>>   		;;
>> +	ceph)
>> +		# Try to mount the filesystem. We need to check whether the encryption
>> +		# is support or not via the ioctl cmd, such as 'set_encpolicy'.
>> +		if ! _try_scratch_mount &>>$seqres.full; then
>> +			_notrun "kernel is unaware of $FSTYP encryption feature," \
>> +				"or mkfs options are not compatible with encryption"
>> +		fi
>> +
>> +		mkdir $SCRATCH_MNT/tmpdir
>> +		if _set_encpolicy $SCRATCH_MNT/tmpdir 2>&1 >>$seqres.full | \
>> +			grep -Eq 'Inappropriate ioctl for device|Operation not supported'
>> +		then
>> +			_notrun "kernel does not support $FSTYP encryption"
>> +		fi
>> +		rmdir $SCRATCH_MNT/tmpdir
>> +		_scratch_unmount
> As I replied in patch 1/2, this function is a mkfs function, if ceph need a
> specific mkfs way, you can do it in this function, or you even can keep it
> empty
>
>    ceph)
> 	;;
>
> Or does a simple cleanup
>
>    ceph)
> 	_scratch_cleanup_files
> 	...
> 	;;
>
> I'm not familar with ceph, that depends on you. But the change in this patch is
> not "mkfs", it's a checking, checking if the current $SCRATCH_MNT supports
> encryption, you should do it in other function which does that checking job, not
> change a mkfs function to be a check function.

Sounds good. Let me check how to that.

Thanks Zorro again.

- Xiubo


> Thanks,
> Zorro
>
>> +		;;
>>   	*)
>>   		_notrun "No encryption support for $FSTYP"
>>   		;;
>> -- 
>> 2.31.1
>>


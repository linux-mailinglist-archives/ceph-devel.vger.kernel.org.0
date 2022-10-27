Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938E660F3FE
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Oct 2022 11:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbiJ0JtV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Oct 2022 05:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233968AbiJ0JtU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Oct 2022 05:49:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9114196393
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 02:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666864158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JPnMJUFSiZja4F5PXIOoRcecDoK9y1I2PLfiYl/xC7A=;
        b=hZxKmVGorKCUG+UGNAOvvYawY/qfU4a9+ZmBs3FNa/DCfzlIGg7fL/diniOVyNEbGObuFB
        WelN1pCBRf5geFjSg/Av+Bnu6A62kz/aiIFyFPnFIEbNLaaUApjmoTuq7xEO0A3I6s3uFE
        jxIqJfujbAYjGJnOTwN//1K2rupFJAA=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-168-lDByIMRLNCqXz_JqSD_-0Q-1; Thu, 27 Oct 2022 05:49:17 -0400
X-MC-Unique: lDByIMRLNCqXz_JqSD_-0Q-1
Received: by mail-pl1-f197.google.com with SMTP id l16-20020a170902f69000b001865f863784so731716plg.2
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 02:49:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JPnMJUFSiZja4F5PXIOoRcecDoK9y1I2PLfiYl/xC7A=;
        b=R34rCTqknuhCioKSH2cErRBWnnu7F42z8Tl9+bW0IDLCSEIZLeF4wm0jElCIwJMnLq
         NrZGsHtAUPzhzcbvK+qP7QVAjw/O+I4eWPLbivZMpMJVLaVq/zvcyWnuytNI3izVpjbC
         5ZZnaqopLCeRf/pd1wg8RmoKSWJD+G1ZdM8WzT+iabsyRXsnm4BsXGJNP9nIG4t05FeA
         4GnVYR/BGWbGu1EwAJN52mrlInsUo49iVoNWG3Be4tAPeRI69fryovbX3fmR6huPCLdV
         sHpTsfzO2uMTAX+cVTV8kHhD+GBHpY7WKiSlB6s4cfhmr19v8YlIi+lOrZ49kvCPAVgw
         r5qw==
X-Gm-Message-State: ACrzQf34Yg3Vj/ZO72Rzfes7QfsagNeCXomJmc4XEVrE2p9tFo1vbZ/q
        NIiw5JLTj1V3W5BE3L0UYnS2N1yTx9Gg0MZWYDN+b6TTHxn4Mi/LUvjPB55eYm+YQ6toTF7HqOZ
        RfjD4PHrqsOf4Qs1N5Bwdyw==
X-Received: by 2002:a17:903:230d:b0:183:7f57:b5fe with SMTP id d13-20020a170903230d00b001837f57b5femr49344267plh.27.1666864156381;
        Thu, 27 Oct 2022 02:49:16 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6hKJISB1PmUit6j6Yll83nz76x0HJF9bmIZcRUTQWuovCdkHShh8xFbstuycBkXuQBen0mCw==
X-Received: by 2002:a17:903:230d:b0:183:7f57:b5fe with SMTP id d13-20020a170903230d00b001837f57b5femr49344246plh.27.1666864156151;
        Thu, 27 Oct 2022 02:49:16 -0700 (PDT)
Received: from [10.72.13.65] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d125-20020a623683000000b0056c0b472c09sm797687pfa.211.2022.10.27.02.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 02:49:15 -0700 (PDT)
Subject: Re: [PATCH v2] encrypt: add ceph support
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, david@fromorbit.com, djwong@kernel.org,
        lhenriques@suse.de, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com
References: <20221027030021.296548-1-xiubli@redhat.com>
 <20221027032023.6arvnrkl7fymdjqj@zlang-mailbox>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e5c876ce-8f0d-c51e-bb04-78c49ebf79c9@redhat.com>
Date:   Thu, 27 Oct 2022 17:49:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20221027032023.6arvnrkl7fymdjqj@zlang-mailbox>
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


On 27/10/2022 11:20, Zorro Lang wrote:
> On Thu, Oct 27, 2022 at 11:00:21AM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   common/encrypt | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/common/encrypt b/common/encrypt
>> index 45ce0954..1a77e23b 100644
>> --- a/common/encrypt
>> +++ b/common/encrypt
>> @@ -153,6 +153,9 @@ _scratch_mkfs_encrypted()
>>   		# erase the UBI volume; reformated automatically on next mount
>>   		$UBIUPDATEVOL_PROG ${SCRATCH_DEV} -t
>>   		;;
>> +	ceph)
>> +		_scratch_cleanup_files

Here I just skip ceph and it is enough. Because the 
_require_scratch_encryption() will do the same thing as I did in my V1's 
2/2 patch.

- Xiubo

>> +		;;
> Any commits about that?
>
> Sorry I'm not familar with cephfs, is this patch enough to help ceph to test
> encrypted ceph? Due to you tried to do some "checking" job last time.
>
> Can "./check -g encrypt" work on ceph? May you paste this test result to help
> to review? And welcome review points from ceph list.
>
> Thanks,
> Zorro
>
> [1]
> $ grep -rsn _scratch_mkfs_encrypted tests/generic/
> tests/generic/395:22:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/396:21:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/580:23:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/581:36:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/595:35:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/613:29:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/621:57:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/429:36:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/397:28:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/398:28:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/421:24:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/440:29:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/419:29:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/435:33:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/593:24:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/576:34:_scratch_mkfs_encrypted_verity &>> $seqres.full
>
>>   	*)
>>   		_notrun "No encryption support for $FSTYP"
>>   		;;
>> -- 
>> 2.31.1
>>


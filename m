Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBCE69FFCD
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Feb 2023 00:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbjBVX7B (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Feb 2023 18:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjBVX67 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 22 Feb 2023 18:58:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76568FF38
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 15:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677110293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dXV8Ai9JbcuZGMK5QaH8UsVqX+xW1BVGo9JkWTVbj98=;
        b=gOHsadBqzWVq30bMCfRSV35PYxfcghM68PqUJ7GoXY5LHNrurqCerts5R+59swOd/4e3BT
        UWAR0IrTvJ0NCrnLINjH0Pj5yEnm3L+ZlSp3V9K74+n8cHLtFLjTiQKEjcWYqOiUQV9ehj
        TJxVw27jBbtHdglEwDe8LqsD1TgghX8=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-482-QHCoanTsOpqxuItR9BeBLA-1; Wed, 22 Feb 2023 18:58:12 -0500
X-MC-Unique: QHCoanTsOpqxuItR9BeBLA-1
Received: by mail-pl1-f199.google.com with SMTP id j20-20020a170902759400b0019ace17fa33so4563759pll.7
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 15:58:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dXV8Ai9JbcuZGMK5QaH8UsVqX+xW1BVGo9JkWTVbj98=;
        b=EiH8iGLy+l5MkoGHR1VL0ArmF/lfkSCkN85E3+6bYiViJSttCMR4XiA2AyV/EM/Uwo
         CCISqWqMEkWy5sKEKIC4ZrL9CbH5WOyvI25LDS1d0ElbpgOXFpbcxAn8IaqjDpTsildQ
         ty0NEKHcNnFPFD68rTjkJJzlRF9Yff8oCX5GnVhZQ+Ozt5fI2J233FoTPZ1OFRusjHUo
         xsieRfXrEkWnVrg+OaRCrZjE+zupj7GdZg2t6KgwNofXTH0diryRUCqxI1tMyIVmQ1QK
         6mx4AapwiqaP8em0nRRCbWyGDk9Cc0lIT5fdhLPfjVMthIEgaSng5hTiIhs3Dn6KZoKI
         ewuA==
X-Gm-Message-State: AO0yUKXrUpcKI2tMWBbQIm4CH0LpapaiPp/vEMCHSBPPht1unV1mlL0r
        o3YwgjLPiz7R7Cp0i4blDUz+ZmUT7EPHCCRmNdWMEwgR08z5tkztWZDAGGMicFFKIqrSChrPIz6
        uPIxPKogHDP48iStv+thJhUPH4DbQcw==
X-Received: by 2002:a17:90b:1988:b0:229:4dcd:ff61 with SMTP id mv8-20020a17090b198800b002294dcdff61mr11778848pjb.28.1677110290704;
        Wed, 22 Feb 2023 15:58:10 -0800 (PST)
X-Google-Smtp-Source: AK7set8RfTAtj8z6vzJ4vIFeaKXrlhekJ1syCglrFj0SuMP2NlkemLkwmKN8Rst524azC/Cqv2zbjA==
X-Received: by 2002:a17:90b:1988:b0:229:4dcd:ff61 with SMTP id mv8-20020a17090b198800b002294dcdff61mr11778837pjb.28.1677110290353;
        Wed, 22 Feb 2023 15:58:10 -0800 (PST)
Received: from [10.72.12.152] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x7-20020a17090a294700b00234899c65e7sm5459666pjf.28.2023.02.22.15.58.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 15:58:09 -0800 (PST)
Message-ID: <718381b5-c36b-2398-6e22-43a6143957ae@redhat.com>
Date:   Thu, 23 Feb 2023 07:58:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] generic/020: fix really long attr test failure for ceph
Content-Language: en-US
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>
References: <20230217124558.555027-1-xiubli@redhat.com>
 <Y++0t8qxK8et8fTg@magnolia> <20230218060436.534bnbs5znio5pd7@zlang-mailbox>
 <Y/UZ2mwahyPzYSMj@magnolia> <20230222141526.hgrewr3ezkohukk4@zlang-mailbox>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230222141526.hgrewr3ezkohukk4@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 22/02/2023 22:15, Zorro Lang wrote:
> On Tue, Feb 21, 2023 at 11:22:02AM -0800, Darrick J. Wong wrote:
>> On Sat, Feb 18, 2023 at 02:04:36PM +0800, Zorro Lang wrote:
>>> On Fri, Feb 17, 2023 at 09:09:11AM -0800, Darrick J. Wong wrote:
>>>> On Fri, Feb 17, 2023 at 08:45:58PM +0800, xiubli@redhat.com wrote:
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> If the CONFIG_CEPH_FS_SECURITY_LABEL is enabled the kernel ceph
>>>>> itself will set the security.selinux extended attribute to MDS.
>>>>> And it will also eat some space of the total size.
>>>>>
>>>>> Fixes: https://tracker.ceph.com/issues/58742
>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>> ---
>>>>>   tests/generic/020 | 6 ++++--
>>>>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/tests/generic/020 b/tests/generic/020
>>>>> index be5cecad..594535b5 100755
>>>>> --- a/tests/generic/020
>>>>> +++ b/tests/generic/020
>>>>> @@ -150,9 +150,11 @@ _attr_get_maxval_size()
>>>>>   		# it imposes a maximum size for the full set of xattrs
>>>>>   		# names+values, which by default is 64K.  Compute the maximum
>>>>>   		# taking into account the already existing attributes
>>>>> -		max_attrval_size=$(getfattr --dump -e hex $filename 2>/dev/null | \
>>>>> +		size=$(getfattr --dump -e hex $filename 2>/dev/null | \
>>>>>   			awk -F "=0x" '/^user/ {len += length($1) + length($2) / 2} END {print len}')
>>>>> -		max_attrval_size=$((65536 - $max_attrval_size - $max_attrval_namelen))
>>>>> +		selinux_size=$(getfattr -n 'security.selinux' --dump -e hex $filename 2>/dev/null | \
>>>>> +			awk -F "=0x" '/^security/ {len += length($1) + length($2) / 2} END {print len}')
>>>>> +		max_attrval_size=$((65536 - $size - $selinux_size - $max_attrval_namelen))
> The max_attrval_size isn't a local variable, due to we need it to be global.
> But the "size" and "selinux_size" look like not global variable, so better
> to be *local*.
>
>>>> If this is a ceph bug, then why is the change being applied to the
>>>> section for FSTYP=ext* ?  Why not create a case statement for ceph?
>>> Hi Darrick,
>>>
>>> Looks like this change is in ceph section [1], did you hit any errors when
>>> you merge it?
>> ahahaa, diff tried to merge that hunk into _attr_get_max and not
>> _attr_get_maxval_size, and I didn't notice.  Question withdrawn
>> with apologies. :/
> Never mind. If there's not objection from you or ceph list, I'll merge this
> patch after it changes as above :)

Sure. Thanks Zorro.

- Xiubo


> Thanks,
> Zorro
>
>> --D
>>
>>> Thanks,
>>> Zorro
>>>
>>> [1]
>>> _attr_get_maxval_size()
>>> {
>>>          local max_attrval_namelen="$1"
>>>          local filename="$2"
>>>
>>>          # Set max attr value size in bytes based on fs type
>>>          case "$FSTYP" in
>>>          ...
>>>          ...
>>>          ceph)
>>>                  # CephFS does not have a maximum value for attributes.  Instead,
>>>                  # it imposes a maximum size for the full set of xattrs
>>>                  # names+values, which by default is 64K.  Compute the maximum
>>>                  # taking into account the already existing attributes
>>> ====>           max_attrval_size=$(getfattr --dump -e hex $filename 2>/dev/null | \
>>>                          awk -F "=0x" '/^user/ {len += length($1) + length($2) / 2} END {print len}')
>>> ====>           max_attrval_size=$((65536 - $max_attrval_size - $max_attrval_namelen))
>>>
>>>
>>>
>>>> --D
>>>>
>>>>>   		;;
>>>>>   	*)
>>>>>   		# Assume max ~1 block of attrs
>>>>> -- 
>>>>> 2.31.1
>>>>>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li


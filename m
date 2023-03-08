Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EBA6AFD2D
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Mar 2023 04:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjCHDBT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Mar 2023 22:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCHDBQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Mar 2023 22:01:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11EEAA254
        for <ceph-devel@vger.kernel.org>; Tue,  7 Mar 2023 19:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678244405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A7MD8U0/zV1Ogpc98sokCMyOL/bqsJ0/Z7A65mt9ZQc=;
        b=B8xPltkz8/2CALqDbCx8C04IAdGOE3YF2fAmBZV0XPPir6KPnZZOfJ9zf8IEP03dzTdmmN
        SSwpCxFQxpsH6GcKXpJzSm0J6nYLHsMylIR/rbSWIA+IxwrcpJNqCsElB9i316cvvXju5E
        zHB3OCVfs/DfrMDs6hEHe4DfU5WORXo=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-lAa0VxepNv278QsSmeZVNg-1; Tue, 07 Mar 2023 22:00:05 -0500
X-MC-Unique: lAa0VxepNv278QsSmeZVNg-1
Received: by mail-pg1-f200.google.com with SMTP id t2-20020a632d02000000b005075b896422so1351957pgt.19
        for <ceph-devel@vger.kernel.org>; Tue, 07 Mar 2023 19:00:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678244404;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A7MD8U0/zV1Ogpc98sokCMyOL/bqsJ0/Z7A65mt9ZQc=;
        b=MI0HYPmAEZ3z81WcZTuyO/fk9k9PZYE63NLgKz+bD1kekBwzIiHGVSPcil9j1l/9cL
         j8bLoEW6Uq6ILJs+objuxFLGjihN1q3g5R2th3Q4A/JdyZKJP9q2Felk/+uURP2xMBoO
         ZuNTJbGZWMCOP0ETa1qLvN/FORWWr9lhDhxLLYTZGufVup9lM0CMjD2ZNMk0SobHCArR
         yZGjBo/ZC9f9yDjgUoz4BkP0nLASAG99k6KSdHzrCCoqWT3/005fPAI+4+Ud3liHTkBl
         TIqFgvPqLzIgMSvgO/QBu8dpno/oDHA6MgycIBeO5ce7xc+RmTtN1I9/wQTLxEMof03Q
         fV5g==
X-Gm-Message-State: AO0yUKWWJX0L6hUBSxRa8MCB4Q7u8o8UFIQaIsFcG1lurKTj78v5qKCw
        wLhRS9Er+naD0eR4/AA1YeDEA5h8P4H3e63ee2J39K3XPzh773tOLz9utiMZHWkB/LnuPBVVZtg
        egkrtdUXpAWY3n7YZon4JCw==
X-Received: by 2002:a62:6305:0:b0:5a9:cb6b:7839 with SMTP id x5-20020a626305000000b005a9cb6b7839mr15987963pfb.1.1678244403404;
        Tue, 07 Mar 2023 19:00:03 -0800 (PST)
X-Google-Smtp-Source: AK7set+JyLZzq5ZVnPBaSXKAaTyXDomTMm1WRbExOZDAecnOo+ElwPbLlW6nZci0fPAN4SAhHjNM+A==
X-Received: by 2002:a62:6305:0:b0:5a9:cb6b:7839 with SMTP id x5-20020a626305000000b005a9cb6b7839mr15987949pfb.1.1678244403093;
        Tue, 07 Mar 2023 19:00:03 -0800 (PST)
Received: from [10.72.12.78] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x16-20020aa784d0000000b005e06234e70esm8481870pfn.59.2023.03.07.18.59.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 19:00:02 -0800 (PST)
Message-ID: <8baedccc-d070-28c3-2754-3ad92a50b468@redhat.com>
Date:   Wed, 8 Mar 2023 10:59:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] generic/{075,112}: fix printing the incorrect return
 value of fsx
Content-Language: en-US
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, david@fromorbit.com, djwong@kernel.org,
        ceph-devel@vger.kernel.org, vshankar@redhat.com
References: <20230301030620.137153-1-xiubli@redhat.com>
 <20230302153837.w23cw5gbedmudwuk@zlang-mailbox>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230302153837.w23cw5gbedmudwuk@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 02/03/2023 23:38, Zorro Lang wrote:
> On Wed, Mar 01, 2023 at 11:06:20AM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> We need to save the result of the 'fsx' temporarily.
>>
>> Fixes: https://tracker.ceph.com/issues/58834
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
> Hmm... how did you generate this patch? Did you change something before you
> send this patch out? I can't merge it simply, always got below errors [1] [2].
> May you help to generate this patch again purely?

Hi Zorro,

Sorry I missed this.

Actually this will depend on the previous patch:

"generic/075: no need to move the .fsxlog to the same directory"

I forgot to mention that.

Thanks

- Xiubo


> (Of course you can keep the RVB of Darrick)
>
> Thanks,
> Zorro
>
> [1]
> $ git am ./20230301_xiubli_generic_075_112_fix_printing_the_incorrect_return_value_of_fsx.mbx
> Applying: generic/{075,112}: fix printing the incorrect return value of fsx
> error: patch failed: tests/generic/075:53
> error: tests/generic/075: patch does not apply
> Patch failed at 0001 generic/{075,112}: fix printing the incorrect return value of fsx
> hint: Use 'git am --show-current-patch=diff' to see the failed patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".
>
> [2]
> $ git am -3 ./20230301_xiubli_generic_075_112_fix_printing_the_incorrect_return_value_of_fsx.mbx
> Applying: generic/{075,112}: fix printing the incorrect return value of fsx
> error: sha1 information is lacking or useless (tests/generic/075).
> error: could not build fake ancestor
> Patch failed at 0001 generic/{075,112}: fix printing the incorrect return value of fsx
> hint: Use 'git am --show-current-patch=diff' to see the failed patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".
>
>>   tests/generic/075 | 6 ++++--
>>   tests/generic/112 | 6 ++++--
>>   2 files changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/tests/generic/075 b/tests/generic/075
>> index 03a394a6..bc3a11c7 100755
>> --- a/tests/generic/075
>> +++ b/tests/generic/075
>> @@ -53,9 +53,11 @@ _do_test()
>>   
>>       # This cd and use of -P gets full debug on "$RESULT_DIR" (not TEST_DEV)
>>       cd $out
>> -    if ! $here/ltp/fsx $_param -P "$RESULT_DIR" $seq.$_n $FSX_AVOID &>/dev/null
>> +    $here/ltp/fsx $_param -P "$RESULT_DIR" $seq.$_n $FSX_AVOID &>/dev/null
>> +    local res=$?
>> +    if [ $res -ne 0 ]
>>       then
>> -	echo "    fsx ($_param) failed, $? - compare $seqres.$_n.{good,bad,fsxlog}"
>> +	echo "    fsx ($_param) failed, $res - compare $seqres.$_n.{good,bad,fsxlog}"
>>   	mv $out/$seq.$_n $seqres.$_n.full
>>   	od -xAx $seqres.$_n.full > $seqres.$_n.bad
>>   	od -xAx "$RESULT_DIR"/$seq.$_n.fsxgood > $seqres.$_n.good
>> diff --git a/tests/generic/112 b/tests/generic/112
>> index 971d0467..0e08cbf9 100755
>> --- a/tests/generic/112
>> +++ b/tests/generic/112
>> @@ -53,9 +53,11 @@ _do_test()
>>   
>>       # This cd and use of -P gets full debug on "$RESULT_DIR" (not TEST_DEV)
>>       cd $out
>> -    if ! $here/ltp/fsx $_param -P "$RESULT_DIR" $FSX_AVOID $seq.$_n &>/dev/null
>> +    $here/ltp/fsx $_param -P "$RESULT_DIR" $FSX_AVOID $seq.$_n &>/dev/null
>> +    local res=$?
>> +    if [ $res -ne 0 ]
>>       then
>> -	echo "    fsx ($_param) returned $? - see $seq.$_n.full"
>> +	echo "    fsx ($_param) returned $res - see $seq.$_n.full"
>>   	mv "$RESULT_DIR"/$seq.$_n.fsxlog $seqres.$_n.full
>>   	status=1
>>   	exit
>> -- 
>> 2.31.1
>>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li


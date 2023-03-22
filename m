Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094A06C4055
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Mar 2023 03:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjCVCZg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Mar 2023 22:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjCVCZf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 21 Mar 2023 22:25:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42595A1AC
        for <ceph-devel@vger.kernel.org>; Tue, 21 Mar 2023 19:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679451886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s6oMSGUJAZpBPKFcO2fZJsIWmoX+5e2Lx0/usfbhCWE=;
        b=ciVTJClB/bAYARWjukep2RlFgmN82T9PEgozPcexrSbfGX7Oe8LBbOmyRKLgdQeqqUtofr
        cpN0DVKWUnfBnTt4KwqVRE745xknAH6n0doK958k+0PA8xpgi9jnc9BBLdBLp6OhZR2LYN
        CtKecnwKv2bFD4WwjndTi/ixadGXKxQ=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-VWJGYdoMOh68gzk-6jfIew-1; Tue, 21 Mar 2023 22:24:44 -0400
X-MC-Unique: VWJGYdoMOh68gzk-6jfIew-1
Received: by mail-pj1-f72.google.com with SMTP id o10-20020a17090ac08a00b0023f3196fa6fso6076468pjs.2
        for <ceph-devel@vger.kernel.org>; Tue, 21 Mar 2023 19:24:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679451883;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s6oMSGUJAZpBPKFcO2fZJsIWmoX+5e2Lx0/usfbhCWE=;
        b=5GSEIBiuhEcLumBglNVLbjS+uCaFXoVAOC2it2OnINEW4AYaKXHstfA71lVajOfFoV
         63yAG87qopMJHxMcBTj7Ibo8a1VAbzoziU15q8hPhDagnpf7opL1wXfZTvANhc1+JxaX
         djYg6reie3UAibhJgga2ZWnayEtwxWDo5NDjZeKxPaGj8ABrvEmid5r8gWlkpTEUuG7f
         J/rLGcrJM2Qq3SvCTKxBlev0rSIIo13lG42sYyP8QVYyHO+8fS0ELrUidgJRbpd7cuNc
         jCnrhjZVLRSXyG5/UM39g3xAv3P/JC0dU1tP8wIvmSqbB1sVXqvNwq6fvCjHb/umA1Gw
         N6hw==
X-Gm-Message-State: AO0yUKVqlHcWLh9Ygu3T/jsmmEU8Sh2muX40eTqWLsP+5OxDwerfwhLY
        y87BlaUbJz57Tc3crMb1D8g1KYE8kZeUroK0ca2tKmS4sknIzh3cWD71lXKhHIazXv0dv/uIs81
        aBZheWfX9gVnr9qs0oN2jAL2Kkh+YrhrA
X-Received: by 2002:a05:6a20:b72a:b0:da:eabf:eec2 with SMTP id fg42-20020a056a20b72a00b000daeabfeec2mr2458789pzb.48.1679451883312;
        Tue, 21 Mar 2023 19:24:43 -0700 (PDT)
X-Google-Smtp-Source: AK7set8YARSWpxNdxlY+7LJCN/GQYk3RwnttToqtb+dUv2NSZUziLQhzwSi+UsZuWzBOjJOxq2Mf2Q==
X-Received: by 2002:a05:6a20:b72a:b0:da:eabf:eec2 with SMTP id fg42-20020a056a20b72a00b000daeabfeec2mr2458776pzb.48.1679451882962;
        Tue, 21 Mar 2023 19:24:42 -0700 (PDT)
Received: from [10.72.12.98] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c3-20020aa78e03000000b00593c1c5bd0esm5260611pfr.164.2023.03.21.19.24.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 19:24:42 -0700 (PDT)
Message-ID: <829cd072-271b-b22a-4ab3-74a786d41e58@redhat.com>
Date:   Wed, 22 Mar 2023 10:24:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] generic/075: no need to move the .fsxlog to the same
 directory
Content-Language: en-US
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, david@fromorbit.com, djwong@kernel.org,
        ceph-devel@vger.kernel.org, vshankar@redhat.com
References: <20230301020730.92354-1-xiubli@redhat.com>
 <20230320143703.dv5ab4tnwrs5cnwl@zlang-mailbox>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230320143703.dv5ab4tnwrs5cnwl@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 20/03/2023 22:37, Zorro Lang wrote:
> On Wed, Mar 01, 2023 at 10:07:30AM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Actually it was trying to move the '075.$_n.fsxlog' from results
>> directory to the same results directory.
>>
>> Fixes: https://tracker.ceph.com/issues/58834
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   tests/generic/075 | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/tests/generic/075 b/tests/generic/075
>> index 9f24ad41..03a394a6 100755
>> --- a/tests/generic/075
>> +++ b/tests/generic/075
>> @@ -57,7 +57,6 @@ _do_test()
>>       then
>>   	echo "    fsx ($_param) failed, $? - compare $seqres.$_n.{good,bad,fsxlog}"
>>   	mv $out/$seq.$_n $seqres.$_n.full
>> -	mv "$RESULT_DIR"/$seq.$_n.fsxlog $seqres.$_n.fsxlog
> Hmm... Thoese $seq, $seqnum, $seqres, $RESULT_DIR and $REPORT_DIR are mess for
> me too :-D
>
>  From the logic of xfstests/check:
>
>    if $OPTIONS_HAVE_SECTIONS; then
>            export RESULT_DIR=`echo $group | sed -e "s;$SRC_DIR;${RESULT_BASE}/$section;"`
>            REPORT_DIR="$RESULT_BASE/$section"
>    else
>            export RESULT_DIR=`echo $group | sed -e "s;$SRC_DIR;$RESULT_BASE;"`
>            REPORT_DIR="$RESULT_BASE"
>    fi
>    seqres="$REPORT_DIR/$seqnum"
>
>
> I think "$RESULT_DIR"/$seq equal to "$seqres", so this change makes sense to me.
> (Not sure if there're some special situations which I don't know :)
>
> The generic/075 is too old, lots of code in it can be removed or refactored, so
> I think it's not worth changing it bit by bit, I can refactor it totally, or if
> you'd like, you can do that.

Yeah, I can do that later, but not recently.

I may add some more tests in future and then I can improve this together.

Thanks Zorro,

- Xiubo

> Thanks,
> Zorro
>
>>   	od -xAx $seqres.$_n.full > $seqres.$_n.bad
>>   	od -xAx "$RESULT_DIR"/$seq.$_n.fsxgood > $seqres.$_n.good
>>   	rm -f "$RESULT_DIR"/$seq.$_n.fsxgood
>> -- 
>> 2.31.1
>>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li


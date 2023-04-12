Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4061D6DF1D5
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Apr 2023 12:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbjDLKT3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Apr 2023 06:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjDLKT1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Apr 2023 06:19:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4911830FF
        for <ceph-devel@vger.kernel.org>; Wed, 12 Apr 2023 03:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681294719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nPyQPfaNN+sf88g3slpkLhQhHFgF3CYsy4xPUf4VNLM=;
        b=YvckAkJeZLW6kDEuBouOr3seP8PknZKdZuq9dZ2FYqsqqGJCuYwba1iaxO9pIwQl+zhKVh
        UYgSRL8Ev3xrUJkPHXKVmBqS0iSVLTGB/qoyJvBuI9TgryO1gbzKH1GJCEUi4y+ecvE0uE
        amUUVClmGqlzQ9rGc6TqPkGjPHqe0t4=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-1IJyy_SrMteRxuC9uGbsFw-1; Wed, 12 Apr 2023 06:18:37 -0400
X-MC-Unique: 1IJyy_SrMteRxuC9uGbsFw-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1a526ad6f96so9137085ad.2
        for <ceph-devel@vger.kernel.org>; Wed, 12 Apr 2023 03:18:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681294717; x=1683886717;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nPyQPfaNN+sf88g3slpkLhQhHFgF3CYsy4xPUf4VNLM=;
        b=hhMs8y5TcmZ+k3Vr3vBxLiJcKXgZeK1TKo/IdQs/qt+9iP3mwwKgcgBep5hdFEliYN
         vXcWlsrU1+1DU1vJLsHHp4fSxtw8AnMlr4OUOaMELDA9PBdil1icVlNdly0jpbatiNWf
         BhDkaCGmBQHbrkfUHhb0kJTZ9qyo43n9p86V3OTLyQlJCKCxxKOTd0UU0BkJMo7jfKwe
         R1b+UrELLRbZbwSxiyeoMGOs7UyY003UxEqm2INBvopD0VdgG3Qn/Yqb/pSs8N01xHLp
         HLU07L5QTueT/sWuWx6QkUA/9wyq7e9CbTCIrr5Awl+jtzlhoRapXZcsGwKfDxH7BPvF
         dM+g==
X-Gm-Message-State: AAQBX9eLg2ydOX/7gzayCuMDrqiL2crzeoGAExJ9a71We1Uatmo0Q6V4
        fshv8MXQoM0YvLem2yDDLdjsV9g0GbibIrCy/lZ8Ro2la/Nd4+ayHz4evkBSrzK111/s47YaQnb
        NnIICEAogrO9b8/Fksp98Sw==
X-Received: by 2002:aa7:9883:0:b0:623:e4d2:d13e with SMTP id r3-20020aa79883000000b00623e4d2d13emr2338181pfl.34.1681294716943;
        Wed, 12 Apr 2023 03:18:36 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z8HP0H+6EWqFi4BlrlhhQ1c40zlI6WZZTQE+hR4JnQo+bjMFzVGpXXTienRQLW20aRKcG42g==
X-Received: by 2002:aa7:9883:0:b0:623:e4d2:d13e with SMTP id r3-20020aa79883000000b00623e4d2d13emr2338166pfl.34.1681294716687;
        Wed, 12 Apr 2023 03:18:36 -0700 (PDT)
Received: from [10.72.12.131] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t10-20020a63dd0a000000b00517aab725bdsm6961739pgg.92.2023.04.12.03.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 03:18:36 -0700 (PDT)
Message-ID: <d0725148-0aa8-1e4d-8d94-a04549e6a71f@redhat.com>
Date:   Wed, 12 Apr 2023 18:18:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v17 00/71] ceph+fscrypt: full support
Content-Language: en-US
To:     Venky Shankar <vshankar@redhat.com>
Cc:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com
References: <20230323065525.201322-1-xiubli@redhat.com>
 <87wn2t3uqz.fsf@suse.de> <b1512c60-bd87-769a-2402-1c33618d2709@redhat.com>
 <CACPzV1=r4Tm=hr46r1dhXVND7j1AVLKvjnjQ8sUj9XRSdLXXFg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CACPzV1=r4Tm=hr46r1dhXVND7j1AVLKvjnjQ8sUj9XRSdLXXFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/12/23 16:43, Venky Shankar wrote:
> On Tue, Apr 4, 2023 at 6:12 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 4/3/23 22:28, Luís Henriques wrote:
>>> xiubli@redhat.com writes:
>>>
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> This patch series is based on Jeff Layton's previous great work and effort
>>>> on this and all the patches bas been in the testing branch since this
>>>> Monday(20 Mar)
>>> I've been going through this new rev[1] in the last few days and I
>>> couldn't find any issues with it.  The rebase on top of 6.3 added minor
>>> changes since last version (for example, there's no need to call
>>> fscrypt_add_test_dummy_key() anymore), but everything seems to be fine.
>>>
>>> So, FWIW, feel free to add my:
>>>
>>> Tested-by: Luís Henriques <lhenriques@suse.de>
>>> Reviewed-by: Luís Henriques <lhenriques@suse.de>
>>>
>>> to the whole series.
>>>
>>> And, again, thanks a lot for your work on this!
>>>
>>> [1] Actually, I've looked into what's currently in the 'testing' branch,
>>> which is already slightly different from this v17.
>> Yeah, as we discussed in another thread, I have fixed one patch and push
>> it to the testing branch, this should be the difference.
>>
>> Thanks Luis very much.
>>
>> - Xiubo
>>
>>
>>> Cheers,
> Tested-by: Venky Shankar <vshankar@redhat.com>
>
Thanks Venky, I will update the testing branch.

- Xiubo



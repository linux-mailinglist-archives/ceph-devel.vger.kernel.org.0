Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F794FB82B
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Apr 2022 11:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344729AbiDKJvg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 11 Apr 2022 05:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344727AbiDKJvV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 11 Apr 2022 05:51:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3393D424AF
        for <ceph-devel@vger.kernel.org>; Mon, 11 Apr 2022 02:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649670479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8RqoKL5QrYcVojZCwprN4zXhrFoO2z+lpwk1KWVW+LQ=;
        b=HpojbO69kPys6Y4wxvrQew1NJ4BsDlI4N/6xl1Y2PRCvDAq+67StqIZ2ztEtLiSHi76nVh
        wprtzZyMG5/eZWR0uA5UfE82Kiz6GJQjgPZq/60a3o3yCwbjwQhAtUDed6lTyjc6CyVz3Y
        RpmLscRLAEEvDhObXfQDCISjt9B2DGw=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-YNDy2ga4OaSOA9WBLRksTQ-1; Mon, 11 Apr 2022 05:47:58 -0400
X-MC-Unique: YNDy2ga4OaSOA9WBLRksTQ-1
Received: by mail-pg1-f200.google.com with SMTP id r15-20020a63fc4f000000b0039d0f8f0793so4027844pgk.22
        for <ceph-devel@vger.kernel.org>; Mon, 11 Apr 2022 02:47:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=8RqoKL5QrYcVojZCwprN4zXhrFoO2z+lpwk1KWVW+LQ=;
        b=C+r0ZLbnr/k51i7buukKKXz9OVCXChB97CzmQzh+c4XD5VqypxqzVmebpwzLMaZbWv
         Z36i4xIR+9mrCacxZoh4fFaTHq/lJyvKf8uwXHIQ6xY8b23hS1ypAnFFGO9uIlxySFCg
         j5Swh1h4Dz41mJpyOOV762m+0NV/RqDtUALM63ohCGGrRr9QT9YqCljbwrA9G+4nxTBq
         23eyJw3jWQCahr+WQdDuA9Vf+snRR/UQ/h2WhXPsKKbxdYqbeJZZpWV03BU3ynHaNzvu
         G44I2qOSJvkiF9cOddX6UF/8SKpbdw6b7s3nVqdYHwgTWCTnMNqyMOCrs752m1ghKIUl
         z2LA==
X-Gm-Message-State: AOAM530FoROh7/dGxkebmdSot2gxzJDNG/bvN47qoUJhPTyrQc0sHYPo
        qCjgUq2mn3CXcloX9QeaRTVGqXWqPfOHm/z4VZAJK07XrK3BYovA7RmK626sWsJ5J1ly+7KipeE
        l3KpLi01dkupMJ6VHtAp0xQS4ihy3s36KcM+ofFWWWya+d95+gUhilpfmI4tduqZgjz+ruS4=
X-Received: by 2002:a63:4523:0:b0:399:1124:1574 with SMTP id s35-20020a634523000000b0039911241574mr25090936pga.609.1649670476920;
        Mon, 11 Apr 2022 02:47:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqaeiv5Q3caS7yT9eC9OaTdth9boN2xwvUjFBa434e3HSZ+i3ucfle4UNNGLcXRPttiaYTcg==
X-Received: by 2002:a63:4523:0:b0:399:1124:1574 with SMTP id s35-20020a634523000000b0039911241574mr25090913pga.609.1649670476535;
        Mon, 11 Apr 2022 02:47:56 -0700 (PDT)
Received: from [10.72.12.194] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k15-20020a63ab4f000000b00381eef69bfbsm28876988pgp.3.2022.04.11.02.47.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 02:47:56 -0700 (PDT)
Subject: Re: [RFC PATCH] ceph: fix statx AT_STATX_DONT_SYNC vs
 AT_STATX_FORCE_SYNC check
To:     David Howells <dhowells@redhat.com>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
References: <20220411021207.268351-1-xiubli@redhat.com>
 <1082021.1649670188@warthog.procyon.org.uk>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <6b3db444-82c3-98a2-4e18-eabfa4701409@redhat.com>
Date:   Mon, 11 Apr 2022 17:47:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1082021.1649670188@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/11/22 5:43 PM, David Howells wrote:
> xiubli@redhat.com wrote:
>
>>  From the posix and the initial statx supporting commit comments,
>> the AT_STATX_DONT_SYNC is a lightweight stat flag and the
>> AT_STATX_FORCE_SYNC is a heaverweight one.
> They're not flags.  It's an enumeration overlain on the at_flags parameter
> because syscalls have a limited number of parameters.
Okay, will fix this.
>> And also checked all
>> the other current usage about these two flags they are all doing
>> the same, that is only when the AT_STATX_FORCE_SYNC is not set
>> and the AT_STATX_DONT_SYNC is set will they skip sync retriving
>> the attributes from storage.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> Reviewed-by: David Howells <dhowells@redhat.com>

Thanks David.

-- Xiubo


>


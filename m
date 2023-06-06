Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7783723C97
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 11:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjFFJKH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jun 2023 05:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235596AbjFFJKD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jun 2023 05:10:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA8F10F
        for <ceph-devel@vger.kernel.org>; Tue,  6 Jun 2023 02:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686042560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xT3FtTuXOZh2gFlg/QjL1h9tCu+HpRgCYjn4r1n82g4=;
        b=f60w3/NRAAMKp1EIwJ1MWQNm4Bd6jpqbIhXD81t8nMSdMQc7Kkw8zK7MJj3wdmWDagnWmM
        5AcgzyjGST3WecOQLn4PS1YbsN3BeKfRe+HQwADOpuS7XhqjBMd8RvTT150J+9rl+RUILr
        uS3zLAeOdItGCD8vhR8Sj/1oB8ql5dY=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-PI_YkY69MY6wnaaK81Qs_A-1; Tue, 06 Jun 2023 05:09:19 -0400
X-MC-Unique: PI_YkY69MY6wnaaK81Qs_A-1
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-bb2202e0108so7252639276.1
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jun 2023 02:09:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686042559; x=1688634559;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xT3FtTuXOZh2gFlg/QjL1h9tCu+HpRgCYjn4r1n82g4=;
        b=Tc/lr1UyTAGwxVTM92VUVpIOTKqInIHLAldnVSEgHc7HzeCSFi3OzIqk84cCSL8pG1
         MTjr8qw/yBJlaFgQKhrpys0GiY6IBXjZSTtY04caLxp9KgIjCwmBldjDyd/lOAi1aBFf
         hsf8lSoi/i4irn92eHisnrydHZyHJ8NA+x0ySGIaqb9qCmW1UGigg1w4kgDtyK6HrRFj
         3n7QyN8E7WckgrE2oOsr2vT9GlGvoClEdKqIXchjTErluD6xCKH6NiAQFIphyy5fik6f
         zd0wMP4tnxLvdwTJaz3NuRYmrZumkWKNZSk3oFjw1SazKT1wEvItntcY7eJse41U3ZWA
         6Lmg==
X-Gm-Message-State: AC+VfDzhBbeo0RqIRILtmsT3Ctoi+08Ya5ZrLUT/KIv4iHAQ5MzOeuha
        c5BvXe1t4IzJeSefBFSTmB0n97JPb+5dyRFSr2FQc6gtjwOKJSWg0qDeReKZAs8eGCiyhdhk/s7
        L3yyT7a+fGYI1COd79Ppu9w==
X-Received: by 2002:a25:84c9:0:b0:ba9:6b90:e551 with SMTP id x9-20020a2584c9000000b00ba96b90e551mr1640719ybm.50.1686042559081;
        Tue, 06 Jun 2023 02:09:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5pfFB2amUhPaBDRt6y4glRHK804SEOvOD9hcMEEgfwXx1CDIsu6o9c1qgs8bSz8AoDRF64yw==
X-Received: by 2002:a25:84c9:0:b0:ba9:6b90:e551 with SMTP id x9-20020a2584c9000000b00ba96b90e551mr1640699ybm.50.1686042558807;
        Tue, 06 Jun 2023 02:09:18 -0700 (PDT)
Received: from [10.72.12.128] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c16-20020a6566d0000000b00543e9e17207sm962067pgw.30.2023.06.06.02.09.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 02:09:18 -0700 (PDT)
Message-ID: <c429d60f-9219-5ccf-84d4-97083c6e4019@redhat.com>
Date:   Tue, 6 Jun 2023 17:09:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v19 69/70] ceph: switch ceph_open() to use new fscrypt
 helper
Content-Language: en-US
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     Milind Changire <mchangir@redhat.com>, idryomov@gmail.com,
        ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com
References: <20230417032654.32352-1-xiubli@redhat.com>
 <20230417032654.32352-70-xiubli@redhat.com>
 <CAED=hWACph6FJwKfE-qBr9hL5NGmr9iSoKSHPsOjVxWE=4+6GQ@mail.gmail.com>
 <0d27c653-7b32-c9d2-764f-08fb82f1ca51@redhat.com> <87zg5d7yfl.fsf@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <87zg5d7yfl.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/6/23 17:05, Luís Henriques wrote:
> Xiubo Li <xiubli@redhat.com> writes:
>
>> On 6/6/23 14:25, Milind Changire wrote:
>>> nit:
>>> the commit title refers to ceph_open() but the code changes are
>>> pertaining to ceph_lookup()
>> Good catch.
>>
>> I couldn't remember why we didn't fix this before as I remembered I have found
>> this.
> Yeah, it's really odd we didn't catch this before.  I had to go look at
> old email: this helper was initially used in ceph_atomic_open() only, but
> then in v3 it was made more generic so that it could also be used in
> ceph_lookup().
>
> Xiubo, do you want me to send out a new version of this patch, or are you
> OK simply updating the subject, using 'ceph_lookup' instead of
> 'ceph_open'?

No worry, I have fixed this in the 'testing' branch and I will send out 
the v20 for this whole series later.

Thank

- Xiubo

> Cheers,


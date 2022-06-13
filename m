Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8C95489FA
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Jun 2022 18:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242438AbiFMKZG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Jun 2022 06:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244907AbiFMKYO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Jun 2022 06:24:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D42C0CE20
        for <ceph-devel@vger.kernel.org>; Mon, 13 Jun 2022 03:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655115502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Y6LBLP8vGdThcd/wDGDotPfVgo/e++F7Hh97I/WkOw=;
        b=V6p6rb/tpWizEzp60c5twPiBjWQ8d9endZ8dUuMPrc5DIt5BrxuUlLR7UFNgTaeYgWjbW6
        5jGm+V9lEPLn9Qvno1WGfE/koEumpZwMnw68kfRZI8/zR4pf3WyOeykkfe5dApbn0Z+iEs
        Q4qgWCm5zOdy/YXcksaoIkvvHs03jqQ=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-fYN72yTNPqSbDkzcC29maA-1; Mon, 13 Jun 2022 06:18:17 -0400
X-MC-Unique: fYN72yTNPqSbDkzcC29maA-1
Received: by mail-pf1-f200.google.com with SMTP id 206-20020a6218d7000000b0051893ee2888so2133980pfy.16
        for <ceph-devel@vger.kernel.org>; Mon, 13 Jun 2022 03:18:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6Y6LBLP8vGdThcd/wDGDotPfVgo/e++F7Hh97I/WkOw=;
        b=jJZYAYdWYB9ULaAu1V6ZJzLXPg66xHRl9VvO7Q8+FjlP0O/UUP7Zj2Fj0o7jqby1xM
         o/mjacYaSLYPzyNWkd8H7qCtu1PGrb+63xXlOfBzxhqvtCInqh2jpPqNYoycQN3IUD0y
         XbxorWNZgLqIQNQd0uNG9sDqNTBMthz4ZUCq5ZkYpJUmKycUM7ogWbmdPuER/bcivwjI
         Xgj8Ia7gyKjiPJFAYcY+yCnh/wGVHPl5adoxlYUR3fpq74d66vucvsbdm9o5x/vB6aAs
         D/dlQd4Q7opWDw8AMsWk/rv5d9FYubhhHgso4Ey5pGgygQQa8/Wa0ScKjXPHTK0TOskE
         Dzjw==
X-Gm-Message-State: AOAM530/rZGmwuHaEEIlPURCnNOYTYKP9hPcjfgH2obYaoyf23WMcArw
        Br2hIe06QgIavPQLtx5nKExAyWsOEgzQmzjdN1UmeEBnrYmJR+rp6Gkm2SQWtOPVHjOpMSe58q4
        LOPX71j4H/c7MYjis9EM87w==
X-Received: by 2002:a63:2d82:0:b0:3fd:fb59:d086 with SMTP id t124-20020a632d82000000b003fdfb59d086mr28986651pgt.334.1655115493839;
        Mon, 13 Jun 2022 03:18:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7a684auUil9oReuJ0aODWZ3lLKHHtKayRBZJltuNdJQInz3zbXqBZHYoTxCnZuhJVJwYFYg==
X-Received: by 2002:a63:2d82:0:b0:3fd:fb59:d086 with SMTP id t124-20020a632d82000000b003fdfb59d086mr28986627pgt.334.1655115493476;
        Mon, 13 Jun 2022 03:18:13 -0700 (PDT)
Received: from [10.72.12.41] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x4-20020a170902820400b00163fbb1eec5sm4681348pln.229.2022.06.13.03.18.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 03:18:12 -0700 (PDT)
Subject: Re: [ceph-client:testing 7/9] lib/iov_iter.c:1464:9: warning:
 comparison of distinct pointer types ('typeof (nr * ((1UL) << (12)) - offset)
 *' (aka 'unsigned long *') and 'typeof (maxsize) *' (aka 'unsigned int *'))
To:     David Howells <dhowells@redhat.com>
Cc:     kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
        kbuild-all@lists.01.org, ceph-devel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>
References: <a1a3edde-7b44-eb09-6695-e7c57356b96e@redhat.com>
 <202206112305.4DdsErK8-lkp@intel.com>
 <1069138.1655106723@warthog.procyon.org.uk>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0453285b-cf3e-9b98-3327-a835619619ca@redhat.com>
Date:   Mon, 13 Jun 2022 18:18:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1069138.1655106723@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/13/22 3:52 PM, David Howells wrote:
> Xiubo Li <xiubli@redhat.com> wrote:
>
>> Thanks for the warning report.
>>
>> These was introduced by one DO NOT MEGE patch, which should go into mainline
>> via David Howells's tree IMO.
> That appears to have been fixed upstream.
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1c27f1fc1549f0e470429f5497a76ad28a37f21a

Yeah, this will fix it.

Thanks David.

-- Xiubo


>
> David
>


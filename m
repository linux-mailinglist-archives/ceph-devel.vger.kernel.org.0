Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAEAA560FAB
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Jun 2022 05:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiF3Dd5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Jun 2022 23:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiF3Ddl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 Jun 2022 23:33:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE1A021E11
        for <ceph-devel@vger.kernel.org>; Wed, 29 Jun 2022 20:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656559999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vMk9SJ1N8Td6RMIF91DosH+5aimulwnLJQU2QhtSWzo=;
        b=dLLwrgzGuVaVge95O9Jl13/yv2OzRJHLwiDbdFnCSTr9THABSAQhsUREw6VNOay9inlBj9
        x2MXZPPCXtNlNxxKOp2wo/82X8DlrD/CUOshJt2gCVhR3rYKHYEsYgxWuWW6Ov481AgXLF
        E+I+FvRodMKmwWmdm6GUNaPHLFUQjoc=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-BpGoVOjANtuSBDkKSpq1Ig-1; Wed, 29 Jun 2022 23:33:18 -0400
X-MC-Unique: BpGoVOjANtuSBDkKSpq1Ig-1
Received: by mail-pg1-f198.google.com with SMTP id h13-20020a63e14d000000b0040df75eaa2eso5489840pgk.21
        for <ceph-devel@vger.kernel.org>; Wed, 29 Jun 2022 20:33:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=vMk9SJ1N8Td6RMIF91DosH+5aimulwnLJQU2QhtSWzo=;
        b=4TF3QmeSzLqfVUN2rcvu7jQTm+EwgQfWdYOMz73NFPw/1dumnPQFQizk6dbiXt6ZRj
         m2fKrtQ5APbA0FQcIACK5p+R3bPjULz1FjKXbX2YcRrYXjMBK2rZ4zj1BFKBMRo8+7qb
         TuEI92+si5ORrESxpiySFdkCnwKsB71aIPmF7iLhWPzy7ktYzX3EnIDW805Y2XNgLkd1
         lgBUibQEH/U0EIikXMZ9ltBEX6MIP2nHHc7sEtZkSi+0JxJM1xzX3/365OV5P7z5wyWN
         HJE2OG4SwrrbLTAEj70HcWV9CWGzvkzf2OEC+WOMruQB/+kZzs2TpfjrTkGqjGv6L7EU
         C9uA==
X-Gm-Message-State: AJIora/QY5QJY1kFFeMRYC4pS4idK8PhStVXb4d8BnZH+MbAv2OFd1Ea
        kTGeTebjG5P+iKd4dUIdYE+SW/pSI1xo+yVp0Ia3H/9BHjFLv2eHi9vN3HMxne9/2xBP8JmVmlF
        wfRRzo0HmcADivGFlygCNioDfAcDyO8e6luCKaTD8xan5qm8MGHnvDcF8OdMV8L2ZtihbrXw=
X-Received: by 2002:a17:90b:1982:b0:1ec:988f:e133 with SMTP id mv2-20020a17090b198200b001ec988fe133mr9646740pjb.211.1656559996884;
        Wed, 29 Jun 2022 20:33:16 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uf1hfNs5wa3BF2oTyOKw4vRbuvinupvmpBYmXGcFb0zDkq7FZ9B0hsJ6/9kWnSjwJON0j9LQ==
X-Received: by 2002:a17:90b:1982:b0:1ec:988f:e133 with SMTP id mv2-20020a17090b198200b001ec988fe133mr9646697pjb.211.1656559996447;
        Wed, 29 Jun 2022 20:33:16 -0700 (PDT)
Received: from [10.72.12.186] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 17-20020a056a00073100b0051b6091c452sm12187363pfm.70.2022.06.29.20.33.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 20:33:15 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] ceph: switch to 4KB block size if quota size is
 not aligned to 4MB
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Luis Henriques <lhenriques@suse.de>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <20220627020203.173293-1-xiubli@redhat.com>
 <CAAM7YA=CcNA8HigAG4wAedUN+1dDDB8G7qXiub=+5B7nN5bjFg@mail.gmail.com>
 <04405a13-5d9e-232a-58fe-ef22783f4881@redhat.com>
 <CAAM7YAkBiMyYW8uZo8JB9Yn_8N4DH0H7Yr2013Yb4oQ7btss0w@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <63452834-c9f8-0ed6-2f88-81541b11fced@redhat.com>
Date:   Thu, 30 Jun 2022 11:33:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAM7YAkBiMyYW8uZo8JB9Yn_8N4DH0H7Yr2013Yb4oQ7btss0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/30/22 11:30 AM, Yan, Zheng wrote:
> On Thu, Jun 30, 2022 at 11:05 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 6/30/22 10:39 AM, Yan, Zheng wrote:
>>> NACK,  this change will significantly increase mds load. Inaccuracy is
>>> inherent in current quota design.
>> Yeah, I was also thinking could we just allow the quota size to be
>> aligned to 4KB if it < 4MB, or must be aligned to 4MB ?
>>
>> Any idea ?
> make sense

Cool, Thanks Zheng.

I will work on that.

-- Xiubo


>> - Xiubo
>>
>>
>>> On Mon, Jun 27, 2022 at 10:06 AM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> V2:
>>>> - Switched to IS_ALIGNED() macro
>>>> - Added CEPH_4K_BLOCK_SIZE macro
>>>> - Rename CEPH_BLOCK to CEPH_BLOCK_SIZE
>>>>
>>>> Xiubo Li (3):
>>>>     ceph: make f_bsize always equal to f_frsize
>>>>     ceph: switch to use CEPH_4K_BLOCK_SHIFT macro
>>>>     ceph: switch to 4KB block size if quota size is not aligned to 4MB
>>>>
>>>>    fs/ceph/quota.c | 32 ++++++++++++++++++++------------
>>>>    fs/ceph/super.c | 28 ++++++++++++++--------------
>>>>    fs/ceph/super.h |  5 +++--
>>>>    3 files changed, 37 insertions(+), 28 deletions(-)
>>>>
>>>> --
>>>> 2.36.0.rc1
>>>>


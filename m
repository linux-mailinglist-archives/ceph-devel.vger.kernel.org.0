Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB6A4DD497
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Mar 2022 07:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbiCRGEk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 18 Mar 2022 02:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbiCRGEi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 18 Mar 2022 02:04:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA6E4674D9
        for <ceph-devel@vger.kernel.org>; Thu, 17 Mar 2022 23:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647583398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fmFalPzK6JUaQQpOZ25rYPlnmBsXnYpj9zq1v6bIaiE=;
        b=aB18Ke5GUene037nAp9VIJJoZKLZ7Qif3pXFGj04NpYnnuBH6KNqOFOjfcTPSR/v090ZQQ
        3swD2DZy2765+S+fjXFfEKB+1+VcvxOh+AFmwJfXqyynPwNkp25mMyMz/CYxGY4kKG0CI1
        pmLbii7rR+dPvIkP2oBQn3GDziwi+Sg=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-m1nl3BVlOu64Ld8ZG9MGUg-1; Fri, 18 Mar 2022 02:03:17 -0400
X-MC-Unique: m1nl3BVlOu64Ld8ZG9MGUg-1
Received: by mail-pg1-f200.google.com with SMTP id q13-20020a638c4d000000b003821725ad66so1610125pgn.23
        for <ceph-devel@vger.kernel.org>; Thu, 17 Mar 2022 23:03:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=fmFalPzK6JUaQQpOZ25rYPlnmBsXnYpj9zq1v6bIaiE=;
        b=QGXb0WJWgX/IwfESX6W37yrvYppBNKHHSalG/mLlUXkHQdTnbZ+YoroFz+fHRXp8oL
         xQQNiwawpyHINpp1CDveeOGNWssHQICOpT4MFkz4nacHMMgud0yTx80cjrWuZfdoNJWp
         4ibEipPuKf5LEEq9bSMeL/9YREXXBj6tq2pEZ509dtqloKz4o89SAL3xm9bV+D3pTr4Z
         AHbmnVN6xOyHOvfDjd/bwlfNbncq8lucv62276SryRX5lmQEkzkc0WBd70tmIjzi267e
         w9rtzMw9CZZAaT6IK+YFsmbEKxAgqOJLQE9qsI5SFKz88eVDyZKbNZWxbKNclGogdCut
         yj4g==
X-Gm-Message-State: AOAM532JeBFgzx+9DaNeMDm7o4hj/93KX9luUBAyD/DXc+cLIGo8fMK/
        0WRdW/7hMe/c6MIKcns6xpebhRPm2GNhcTeG0eAv5Lu1X7aNgpG/jmAiXNbyQHy5JnHGWLJ7MrS
        KxkyhkyKvJFuaMjkzOcCIe6TO3H3NZnbPWSwhPeA38GeaMaO/AKZY7iIsyGhoLtX2kHWgjB8=
X-Received: by 2002:a17:90b:4a44:b0:1bf:8deb:9435 with SMTP id lb4-20020a17090b4a4400b001bf8deb9435mr20390885pjb.16.1647583395627;
        Thu, 17 Mar 2022 23:03:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQN/GI1LJ9H0OGt33KzjULIrUsOBD6QqA4jAPzNAzPdnWz1rGRibdH4zdRdnYg59Hbx8CKXA==
X-Received: by 2002:a17:90b:4a44:b0:1bf:8deb:9435 with SMTP id lb4-20020a17090b4a4400b001bf8deb9435mr20390859pjb.16.1647583395222;
        Thu, 17 Mar 2022 23:03:15 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j18-20020a633c12000000b0038204629cc9sm3344525pga.10.2022.03.17.23.03.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 23:03:14 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix the buf size and use NAME_SIZE instead
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
References: <20220316035100.68406-1-xiubli@redhat.com>
 <8ee63a9ada6574932a66821b11eb91c491543754.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ed3117ba-cd20-e385-3b4c-a94cd329c5a0@redhat.com>
Date:   Fri, 18 Mar 2022 14:03:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <8ee63a9ada6574932a66821b11eb91c491543754.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/16/22 7:50 PM, Jeff Layton wrote:
> On Wed, 2022-03-16 at 11:51 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Since the base64_encrypted file name shouldn't exceed the NAME_SIZE,
>> no need to allocate a buffer from the stack that long.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> Jeff, you can just squash this into the previous commit.
>>
>>
>>   fs/ceph/mds_client.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index c51b07ec72cf..cd0c780a6f84 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -2579,7 +2579,7 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase, int for
>>   			parent = dget_parent(cur);
>>   		} else {
>>   			int len, ret;
>> -			char buf[FSCRYPT_BASE64URL_CHARS(NAME_MAX)];
>> +			char buf[NAME_MAX];
>>   
>>   			/*
>>   			 * Proactively copy name into buf, in case we need to present
> Thanks Xiubo. I folded this into:
>
>      ceph: add encrypted fname handling to ceph_mdsc_build_path
>
> ...and merged in the other patches you sent earlier today.
>
> I also went ahead and squashed down the readdir patches that you sent
> yesterday, so that we could get rid of the interim readdir handling that
> I had originally written.
>
> It might need a bit more cleanup -- some of the deltas in the merged
> patch probably belong in earlier commits, but it should be ok for now.
>
> Please take a look and make sure I didn't miss anything there.

I have gone through the wip-fscrypt, all these look fine.

-- Xiubo



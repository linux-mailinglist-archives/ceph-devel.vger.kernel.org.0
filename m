Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22394DBBFF
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Mar 2022 02:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240840AbiCQBBZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Mar 2022 21:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236207AbiCQBBY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Mar 2022 21:01:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 854CA13E31
        for <ceph-devel@vger.kernel.org>; Wed, 16 Mar 2022 18:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647478808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jdc7+/zoeQZ/umjX1ZgOUUo+m9bpze5R20d4mqOyMGw=;
        b=M3S+nxl9DoABKStPh24NK2nAr4in1iNmC8hYP/qkmaQiW1bPwsxmrICpOJgejMcmf6IGzM
        wpclWrQUR4yeK8Bpsa/bJgKDgeqrvvI7dhww6MiKA4yDkYZjFILV+Faqm4rzNaxvmvOcP3
        a1lU9iNdXT0TaZhT9YNJOBBBRDitLvE=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-YD_qV_J_PFGtzV9yUrkMlw-1; Wed, 16 Mar 2022 21:00:07 -0400
X-MC-Unique: YD_qV_J_PFGtzV9yUrkMlw-1
Received: by mail-pf1-f199.google.com with SMTP id f18-20020a623812000000b004f6a259bbf4so2625214pfa.7
        for <ceph-devel@vger.kernel.org>; Wed, 16 Mar 2022 18:00:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Jdc7+/zoeQZ/umjX1ZgOUUo+m9bpze5R20d4mqOyMGw=;
        b=rYtaP5xNvPQr5/RJRf45lUwqxrOS/i/uX7xLCh3NHejq9JGeNo+nPK4LnWVLHgLeCf
         HjkaEKHuP8hzweaVtIt3Mpbcssen6UKKz27exfeHUEcJ7SjOmkhRGZm1mNGN/qI/fqEQ
         qNn0wgMyV/3RcpHuLbgQgd1fDPRCS1U9Hmwkql/A9Eoi8wJYJajw5QIy3076mNC5dnlD
         f70PdEMWIidBnCCArtPKsdwgP3L7ehUuUb+WqVeiOQsK09LCEuSyqQ3AZOle0wJx6CU1
         m/FNkXwHcRwMUG6ySFBP47/P4bHn+EhX9uesu+EdPEL063PydEqwk9YACWTvF6XHkzWa
         F9Hw==
X-Gm-Message-State: AOAM532/oDuIooWOssRL3ZyJWwnUsHiE4cmKf4Ev6/a7guxpwVmG2lHb
        qUq2QSSSpbTpfKBtiQ7gqhEghJSmwer9GEpmxuWxDawRTRu5GQnsoZX3AWgnm6BvPXDUP/1Fc9q
        ol8uS6EQzBvof3jp4N3APRBiHZfx+sgHWe3NZJ5RJcKhPRnlt2uj+IoyK1snFfqwUWOoApVs=
X-Received: by 2002:a17:902:7002:b0:14d:76b9:2303 with SMTP id y2-20020a170902700200b0014d76b92303mr2543825plk.155.1647478805950;
        Wed, 16 Mar 2022 18:00:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6b1g5/p/L/qJXXDAJNpi9g5vSSsoDiHq3k0TK2jvag6ghQ3nPSzobtcU4jKi0iGUE1sS7AA==
X-Received: by 2002:a17:902:7002:b0:14d:76b9:2303 with SMTP id y2-20020a170902700200b0014d76b92303mr2543790plk.155.1647478805568;
        Wed, 16 Mar 2022 18:00:05 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e6-20020a63aa06000000b00380c8bed5a6sm3918492pgf.46.2022.03.16.18.00.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 18:00:05 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix the buf size and use NAME_SIZE instead
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
References: <20220316035100.68406-1-xiubli@redhat.com>
 <8ee63a9ada6574932a66821b11eb91c491543754.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <bd306053-8c9c-0550-7ff1-d0d7aa25e518@redhat.com>
Date:   Thu, 17 Mar 2022 09:00:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <8ee63a9ada6574932a66821b11eb91c491543754.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
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

Sure, will check it today.

- Xiubo



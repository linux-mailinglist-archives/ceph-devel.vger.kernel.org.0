Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7DF6A7970
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Mar 2023 03:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjCBCUn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Mar 2023 21:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCBCUm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 Mar 2023 21:20:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975E15328A
        for <ceph-devel@vger.kernel.org>; Wed,  1 Mar 2023 18:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677723594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dWZgyA1HWsAha7bzZoO1xP10Gw4rBTI1UXsZ3cZm+YQ=;
        b=Tgzw94Uf0ZW8kbQizr27sX/9moDXimskyOgSULYOzJSRaT51aDMBR7DbhQyD0igGOaVsve
        mNF5nvT19OLP975/VblPlhEjhc8x9VqFvOi9CktA7ZT7oHIfHBZS20CPQ2Y0r/G3EVHuEn
        UnvtoYeG8lpEeapHUgy0jDg0ddKOOuk=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-648-fejsncEJPRSdoZ3psVp2jg-1; Wed, 01 Mar 2023 21:19:53 -0500
X-MC-Unique: fejsncEJPRSdoZ3psVp2jg-1
Received: by mail-pg1-f199.google.com with SMTP id d22-20020a63d716000000b00502e3fb8ff3so5057298pgg.10
        for <ceph-devel@vger.kernel.org>; Wed, 01 Mar 2023 18:19:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677723592;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dWZgyA1HWsAha7bzZoO1xP10Gw4rBTI1UXsZ3cZm+YQ=;
        b=5XXM6vtFi/Vccv9kikC5bD6VgBqsf+HA+TK7BZJwn1X/TNUIiyIxHzoN6UcfUB6z39
         V1Zje87Cz5mqOYrkE3eSLFJ/+p3+tGdhBkoAtQZxoXRjNll+HSUZzxdHeyYSOgNo+0wD
         pkqhlZ6b8WIz1FhoS8iSHi0zqaOIcdfGXyiFZikH710puIMEb0o/9gEh4BGsv65epRiU
         g3wnLEFdiuVI9S6EjhkoDAhDEXCOC1lQWBgYW4PTfjaJoZtyIhnHNNIuVDzjWbslmacI
         Wl0hcbij522UawrpIR7PcqHYtS2QQeS5yjISzjyvnB5E0fRVq9YI6a8f7O0aRtvzyMhT
         nizw==
X-Gm-Message-State: AO0yUKX6nOKCXDilhNn6BcOubfyTkJ2JxLgYj0bRktJzW5lKsph3vG7t
        /81gu6aTgEu/gV4DD5nM06uFLsmvXRxFPEk63sD/eKIsEw7qj3Z5KDrHhrq4SgwNupIOaBhrk6c
        vAeyTxrUKBiT90hJ5L0QWgA==
X-Received: by 2002:a17:902:e54f:b0:19d:ab83:ec70 with SMTP id n15-20020a170902e54f00b0019dab83ec70mr10236908plf.45.1677723592480;
        Wed, 01 Mar 2023 18:19:52 -0800 (PST)
X-Google-Smtp-Source: AK7set9Af82dngybkI+6/rqJHkqK8CxpHzin5Bu0VijckfAh+RlSTmk78DY/55d70DgDg49eBfq4/w==
X-Received: by 2002:a17:902:e54f:b0:19d:ab83:ec70 with SMTP id n15-20020a170902e54f00b0019dab83ec70mr10236895plf.45.1677723592181;
        Wed, 01 Mar 2023 18:19:52 -0800 (PST)
Received: from [10.72.12.72] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c4-20020a170902d90400b00198ac2769aesm9000332plz.135.2023.03.01.18.19.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 18:19:51 -0800 (PST)
Message-ID: <6627386e-0f7e-c23f-0589-cd5b22384e43@redhat.com>
Date:   Thu, 2 Mar 2023 10:19:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] ceph: do not print the whole xattr value if it's too
 long
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org, lhenriques@suse.de,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
References: <20230301011918.64629-1-xiubli@redhat.com>
 <CAOi1vP8i6EY-m-bGDNp5QhmHDepvgCAQ1FTnySVg7Bb=6h5uqw@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP8i6EY-m-bGDNp5QhmHDepvgCAQ1FTnySVg7Bb=6h5uqw@mail.gmail.com>
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


On 01/03/2023 19:54, Ilya Dryomov wrote:
> On Wed, Mar 1, 2023 at 2:19 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> If the xattr's value size is long enough the kernel will warn and
>> then will fail the xfstests test case.
>>
>> Just print part of the value string if it's too long.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://tracker.ceph.com/issues/58404
> Hi Xiubo,
>
> Does this really need to go to stable kernels?  None of the douts are
> printed by default.

Ilya,

That's okay, not a must.

>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V2:
>> - switch to use min() from Jeff's comment
>> - s/XATTR_MAX_VAL/MAX_XATTR_VAL/g
>>
>>
>>   fs/ceph/xattr.c | 12 ++++++++----
>>   1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
>> index b10d459c2326..887a65279fcf 100644
>> --- a/fs/ceph/xattr.c
>> +++ b/fs/ceph/xattr.c
>> @@ -561,6 +561,7 @@ static struct ceph_vxattr *ceph_match_vxattr(struct inode *inode,
>>          return NULL;
>>   }
>>
>> +#define MAX_XATTR_VAL 256
> Perhaps MAX_XATTR_VAL_PRINT_LEN?  Also, I'd add a blank like after the
> define -- it's used by more than one function.

Looks better.

I will revise this.

Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li


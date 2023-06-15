Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40DC4730CE1
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Jun 2023 03:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240118AbjFOBui (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Jun 2023 21:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239341AbjFOBuZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 14 Jun 2023 21:50:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB4AEB
        for <ceph-devel@vger.kernel.org>; Wed, 14 Jun 2023 18:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686793777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9J0zMZ4ioy5F1j0kHX/OnyuCLm22iPg2Z99sO+eAiqs=;
        b=bzQr8TaymXKKCi5she1gRny/w4FS0Ke019XL0zJap/tpuENVFghiKC0Ts3YMpJwIzcDQIJ
        tfzDkM8MtMSUA4ijbwusNKV09ZNS2fihZDEXU7B7HQdnOvOTRfgKzvFpwwRhORA7B8hkgi
        oCUVPUxEyQeXORHgJVzTg7V7Lkx1QtE=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-3l_g9pYCMQWGoAO06far3A-1; Wed, 14 Jun 2023 21:49:36 -0400
X-MC-Unique: 3l_g9pYCMQWGoAO06far3A-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-55b66249733so1019195eaf.0
        for <ceph-devel@vger.kernel.org>; Wed, 14 Jun 2023 18:49:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686793775; x=1689385775;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9J0zMZ4ioy5F1j0kHX/OnyuCLm22iPg2Z99sO+eAiqs=;
        b=Yi+IIPuCXAQsS9iQbDJBBlJiOaDo25qQcjP16qfb2itOWgY2A7y45fLxG2MSNmcBcL
         Bbw8A9g3rjZu4BocPX717trHH0+vNxorhef1XineCgHYBfdQVPXsOmfUQnRuYILPp6/0
         Fq92nAtRTAiQ2i68+gI3+pErCLgbMXb4u5UnEK7JzPmTY5/Ax4mB11si8OZeAD91aXaW
         D4Sh81vMHzikZ95k5xj2grjgCWx0PU8686aEuFWSXW2f2JTstnrA5v+Lni6RVPPr5mnm
         W2ROT+LbYCD9W6FJkLPFHF9aRJqF5bteMZq+hJ3CjS50EfsNU/Ou+dbqV5gi2EKq6b1L
         qcDQ==
X-Gm-Message-State: AC+VfDz86A8D/sfaIg+RvUZWTvSxJlCe8C0zloXzWBt7hSnl/dA6KodV
        fDr7QOrP4jxsucCCbHvrEg7UdZjVPIa4fJ/d4faQVYynaCmIek5hh4PxCcDkqUx5wKfNzg/mpWw
        b/BgT6A49+ZIVMQ+ZrPtMDA==
X-Received: by 2002:a05:6808:3014:b0:39a:ac4c:8f3e with SMTP id ay20-20020a056808301400b0039aac4c8f3emr13385254oib.2.1686793775583;
        Wed, 14 Jun 2023 18:49:35 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4BFiUEzPjfpO5A5bqsZVUym1yQywbimjpQEDeZnbyU5mgkrHFGeZjAV8YOjtDnsCt2DfULsQ==
X-Received: by 2002:a05:6808:3014:b0:39a:ac4c:8f3e with SMTP id ay20-20020a056808301400b0039aac4c8f3emr13385250oib.2.1686793775337;
        Wed, 14 Jun 2023 18:49:35 -0700 (PDT)
Received: from [10.72.12.155] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 1-20020a17090a034100b0025c07a79629sm4643244pjf.57.2023.06.14.18.49.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 18:49:34 -0700 (PDT)
Message-ID: <52379a5b-9480-1117-2bb6-91dbd967c2be@redhat.com>
Date:   Thu, 15 Jun 2023 09:49:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v3 1/6] ceph: add the *_client debug macros support
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, khiremat@redhat.com,
        pdonnell@redhat.com
References: <20230614013025.291314-1-xiubli@redhat.com>
 <20230614013025.291314-2-xiubli@redhat.com>
 <CAOi1vP-zgScbF0uoshqtgMToCZ8bkSaa6B2FYs0qvVrEKMDKaA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP-zgScbF0uoshqtgMToCZ8bkSaa6B2FYs0qvVrEKMDKaA@mail.gmail.com>
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


On 6/14/23 16:21, Ilya Dryomov wrote:
> On Wed, Jun 14, 2023 at 3:33 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will help print the fsid and client's global_id in debug logs,
>> and also print the function names.
>>
>> URL: https://tracker.ceph.com/issues/61590
>> Cc: Patrick Donnelly <pdonnell@redhat.com>
>> Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   include/linux/ceph/ceph_debug.h | 44 ++++++++++++++++++++++++++++++++-
>>   1 file changed, 43 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_debug.h
>> index d5a5da838caf..26b9212bf359 100644
>> --- a/include/linux/ceph/ceph_debug.h
>> +++ b/include/linux/ceph/ceph_debug.h
>> @@ -19,12 +19,22 @@
>>          pr_debug("%.*s %12.12s:%-4d : " fmt,                            \
>>                   8 - (int)sizeof(KBUILD_MODNAME), "    ",               \
>>                   kbasename(__FILE__), __LINE__, ##__VA_ARGS__)
>> +#  define dout_client(client, fmt, ...)                                        \
>> +       pr_debug("%.*s %12.12s:%-4d : [%pU %lld] " fmt,                 \
>> +                8 - (int)sizeof(KBUILD_MODNAME), "    ",               \
>> +                kbasename(__FILE__), __LINE__,                         \
>> +                &client->fsid, client->monc.auth->global_id,           \
>> +                ##__VA_ARGS__)
>>   # else
>>   /* faux printk call just to see any compiler warnings. */
>>   #  define dout(fmt, ...)       do {                            \
>>                  if (0)                                          \
>>                          printk(KERN_DEBUG fmt, ##__VA_ARGS__);  \
>>          } while (0)
>> +#  define dout_client(client, fmt, ...)        do {                    \
>> +               if (0)                                          \
>> +                       printk(KERN_DEBUG fmt, ##__VA_ARGS__);  \
>> +       } while (0)
>>   # endif
>>
>>   #else
>> @@ -33,7 +43,39 @@
>>    * or, just wrap pr_debug
>>    */
>>   # define dout(fmt, ...)        pr_debug(" " fmt, ##__VA_ARGS__)
>> -
>> +# define dout_client(client, fmt, ...)                                 \
>> +       pr_debug("[%pU %lld] %s: " fmt, &client->fsid,                  \
>> +                client->monc.auth->global_id, __func__,                \
>> +                ##__VA_ARGS__)
>>   #endif
>>
>> +# define pr_notice_client(client, fmt, ...)                            \
>> +       pr_notice("[%pU %lld] %s: " fmt, &client->fsid,                 \
>> +                 client->monc.auth->global_id, __func__,               \
>> +                 ##__VA_ARGS__)
> Hi Xiubo,
>
> We definitely don't want the framework to include function names in
> user-facing messages (i.e. in pr_* messages).  In the example that
> spawned this series ("ceph: mds3 session blocklisted"), it's really
> irrelevant to the user which function happens to detect blocklisting.
>
> It's a bit less clear-cut for dout() messages, but honestly I don't
> think it's needed there either.  I know that we include it manually in
> many places but most of the time it's actually redundant.

The function name will include the most info needed in the log messages, 
before almost all the log messages will add that explicitly or will add 
one function name directly. Which may make the length of the 'fmt' 
string exceeded 80 chars.

If this doesn't make sense I will remove this from the framework.

Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>


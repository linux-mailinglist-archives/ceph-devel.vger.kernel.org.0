Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B149A73195A
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Jun 2023 14:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244822AbjFOM6a (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 15 Jun 2023 08:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244837AbjFOM6R (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 15 Jun 2023 08:58:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3B61BC9
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jun 2023 05:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686833855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dMmSPHubhqgaf/ktQ62Cj3UBKHdfs0tkH23sXnpHnBk=;
        b=Rkr6pKOJp4bXtgUE4R/2N0s0A1TmSI/6tlZYO/+uLi6wGjGtgdRer62YeDFDD/1QCGJNou
        ajKIspcQfKCfPZguMPcT6E60OUdHWiFkWR1X3A9Np88crsApD9dLLnPh4qsvRJARTeV3h9
        RRRboxyb+m9DGA1yKsDV9bbYeypZqCY=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-454-EUjglA_kMEq6GefWji52Ww-1; Thu, 15 Jun 2023 08:57:32 -0400
X-MC-Unique: EUjglA_kMEq6GefWji52Ww-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-54fb5dd787aso470185a12.0
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jun 2023 05:57:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686833851; x=1689425851;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dMmSPHubhqgaf/ktQ62Cj3UBKHdfs0tkH23sXnpHnBk=;
        b=gmMpm5RsY9li7u2V9F9Fj1lkq0VqrhuqA6j3+p7EEO6PZSJabfeTLpq5WTQkjIPau4
         MxAhRx5kx/tP2e90a43PIhRLcQ6nS75QnAzDmZletxWX7S2Jwwfbi8m3PW/It2DeHZcl
         2sODkRnVsPdpXy1D4Cq/KmdOqW+OsSeu6V4mFWdA8m2O3jQQgj7IHlAE9ZUyAUnTPvhD
         Xx9r0he+Gakv+F3/ALdECJ9c3h/9f4YHgOmquqT4IAk5khQ5qPfhY5Kqi7GBegNHY2rN
         DQkjpI0JsK3yBBleQB6fhCw41mqCfnuuNbLeC5kRaI4HkPT4Th5j6oonYXAYYWnpYC8/
         pBaA==
X-Gm-Message-State: AC+VfDxzorBrcVQnOWbii6w59RBJbkfXNzsmiarKhEf2+P3q8dwkAbLn
        Vbz/qwoiVTwcqZTQgFmtd/PPE57XtS7EAvAqX6XbMaaArfKDfNFGh8NzNAc5475HoMCWQL/R3oW
        E4Q3Rhw6CrBhh8fmaOrxebA==
X-Received: by 2002:a17:902:da8a:b0:1b5:1adb:f43c with SMTP id j10-20020a170902da8a00b001b51adbf43cmr1871957plx.23.1686833851615;
        Thu, 15 Jun 2023 05:57:31 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ447kw38vQNCgaRQX7SZMHUKTsjl+72ooy+Pm2kvTVo8IWRMQKWUg9mAGduhuOIikcp8RGaGQ==
X-Received: by 2002:a17:902:da8a:b0:1b5:1adb:f43c with SMTP id j10-20020a170902da8a00b001b51adbf43cmr1871941plx.23.1686833851302;
        Thu, 15 Jun 2023 05:57:31 -0700 (PDT)
Received: from [10.72.12.155] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id io18-20020a17090312d200b001b022f2aa12sm14040062plb.239.2023.06.15.05.57.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 05:57:30 -0700 (PDT)
Message-ID: <bd7acf07-f04f-a2f0-2a23-24e0de20e508@redhat.com>
Date:   Thu, 15 Jun 2023 20:57:24 +0800
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
 <52379a5b-9480-1117-2bb6-91dbd967c2be@redhat.com>
 <CAOi1vP_aqnO0vCed8Uwh8tMpVdjr0RTcR9BuoMRXY4E0p6bG9g@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_aqnO0vCed8Uwh8tMpVdjr0RTcR9BuoMRXY4E0p6bG9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/15/23 20:50, Ilya Dryomov wrote:
> On Thu, Jun 15, 2023 at 3:49 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 6/14/23 16:21, Ilya Dryomov wrote:
>>> On Wed, Jun 14, 2023 at 3:33 AM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> This will help print the fsid and client's global_id in debug logs,
>>>> and also print the function names.
>>>>
>>>> URL: https://tracker.ceph.com/issues/61590
>>>> Cc: Patrick Donnelly <pdonnell@redhat.com>
>>>> Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    include/linux/ceph/ceph_debug.h | 44 ++++++++++++++++++++++++++++++++-
>>>>    1 file changed, 43 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_debug.h
>>>> index d5a5da838caf..26b9212bf359 100644
>>>> --- a/include/linux/ceph/ceph_debug.h
>>>> +++ b/include/linux/ceph/ceph_debug.h
>>>> @@ -19,12 +19,22 @@
>>>>           pr_debug("%.*s %12.12s:%-4d : " fmt,                            \
>>>>                    8 - (int)sizeof(KBUILD_MODNAME), "    ",               \
>>>>                    kbasename(__FILE__), __LINE__, ##__VA_ARGS__)
>>>> +#  define dout_client(client, fmt, ...)                                        \
>>>> +       pr_debug("%.*s %12.12s:%-4d : [%pU %lld] " fmt,                 \
>>>> +                8 - (int)sizeof(KBUILD_MODNAME), "    ",               \
>>>> +                kbasename(__FILE__), __LINE__,                         \
>>>> +                &client->fsid, client->monc.auth->global_id,           \
>>>> +                ##__VA_ARGS__)
>>>>    # else
>>>>    /* faux printk call just to see any compiler warnings. */
>>>>    #  define dout(fmt, ...)       do {                            \
>>>>                   if (0)                                          \
>>>>                           printk(KERN_DEBUG fmt, ##__VA_ARGS__);  \
>>>>           } while (0)
>>>> +#  define dout_client(client, fmt, ...)        do {                    \
>>>> +               if (0)                                          \
>>>> +                       printk(KERN_DEBUG fmt, ##__VA_ARGS__);  \
>>>> +       } while (0)
>>>>    # endif
>>>>
>>>>    #else
>>>> @@ -33,7 +43,39 @@
>>>>     * or, just wrap pr_debug
>>>>     */
>>>>    # define dout(fmt, ...)        pr_debug(" " fmt, ##__VA_ARGS__)
>>>> -
>>>> +# define dout_client(client, fmt, ...)                                 \
>>>> +       pr_debug("[%pU %lld] %s: " fmt, &client->fsid,                  \
>>>> +                client->monc.auth->global_id, __func__,                \
>>>> +                ##__VA_ARGS__)
>>>>    #endif
>>>>
>>>> +# define pr_notice_client(client, fmt, ...)                            \
>>>> +       pr_notice("[%pU %lld] %s: " fmt, &client->fsid,                 \
>>>> +                 client->monc.auth->global_id, __func__,               \
>>>> +                 ##__VA_ARGS__)
>>> Hi Xiubo,
>>>
>>> We definitely don't want the framework to include function names in
>>> user-facing messages (i.e. in pr_* messages).  In the example that
>>> spawned this series ("ceph: mds3 session blocklisted"), it's really
>>> irrelevant to the user which function happens to detect blocklisting.
>>>
>>> It's a bit less clear-cut for dout() messages, but honestly I don't
>>> think it's needed there either.  I know that we include it manually in
>>> many places but most of the time it's actually redundant.
>> The function name will include the most info needed in the log messages,
>> before almost all the log messages will add that explicitly or will add
>> one function name directly. Which may make the length of the 'fmt'
>> string exceeded 80 chars.
>>
>> If this doesn't make sense I will remove this from the framework.
> I'm fine with keeping it for dout() messages.  To further help with
> line lengths, how about naming the new macro doutc()?  Since it takes
> an extra argument before the format string, it feels distinctive enough
> despite it being just a single character.

What about the others macros ? Such as for the 'pr_info_client()',etc ?

Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A960473193F
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Jun 2023 14:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238984AbjFOMyR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 15 Jun 2023 08:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236407AbjFOMyQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 15 Jun 2023 08:54:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEE31BC9
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jun 2023 05:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686833610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y3HdwOz+tKJd4BdL6E9G9Z+xHtJRD0P07EmhA+N2gdM=;
        b=JBFWHfT6jWOqmNlT2EcAk6xppp3pAtOLIzTs2bR21i9rjdiEcKdUPdjjQ3TUhcDd5gSKe3
        fg5Gia5YB4ZaljT/CxSoGtj9LQnjDYWB3xxb3BTa/HFvXefCW+YPRo8TpqWFsasLeKqoDJ
        JPZFRWvqXGRO4V/dZG8NpAUM7TJVwNk=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-eQnqsRY8Mwiw8eoUb8u3mw-1; Thu, 15 Jun 2023 08:53:29 -0400
X-MC-Unique: eQnqsRY8Mwiw8eoUb8u3mw-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-53fa2d0c2ebso3816063a12.1
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jun 2023 05:53:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686833608; x=1689425608;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y3HdwOz+tKJd4BdL6E9G9Z+xHtJRD0P07EmhA+N2gdM=;
        b=errvslMtIf4b0OB0lcNUjPE1elUcCdBrNEIYAXwZsQcaop3GKSgBZ4u0O3G8WRPu/S
         odGjde7UTR6CTR5PRcUTXafEyBavO/7UTt56NGPdzNlDnZ6CvMDXdsDcIcaSctBz1g0n
         FsOTHOUEML1ebIOCHd9L1XTzjIubkMMHcBtOHOB6PpL2tVVMRfVOCLBRUMorqxYxemzk
         w/g42Yw80rZUl4+PgKIZ1Fjk3daRF3ncO6HK3BBZa9aHWMcxXLb2++vt2rwR4dDbH8zP
         F4SNFaO2tYEBkXKUV8XYmVck1y6mR5GWS+qWLGgnwXqE6GhKwyRhZtulef+IXxkjnXyg
         NobA==
X-Gm-Message-State: AC+VfDwy1Ago1H+pClzjgtW8ejOEcqG+6Th8UgMglZ7n2++uGc1+zTxO
        Tnc7AziY1CYg4Ta+CcAh8nAsj+iFbWbpLVfdhh4jskcwCP2Hp2tC/Blp1ozEDnrz6Vnco5lY4A8
        S7Gim+D5BhQ3ZNQv1tTVxSw==
X-Received: by 2002:a17:903:25d4:b0:1b3:bfd0:7499 with SMTP id jc20-20020a17090325d400b001b3bfd07499mr10100157plb.58.1686833608435;
        Thu, 15 Jun 2023 05:53:28 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5cx1CqQ4NmVbd2D32Y2W5r97w4FTvg9s6tBYugHjOyQ0P/K6b3D3PbXHc/cYYY4hEPd+6iBw==
X-Received: by 2002:a17:903:25d4:b0:1b3:bfd0:7499 with SMTP id jc20-20020a17090325d400b001b3bfd07499mr10100145plb.58.1686833608112;
        Thu, 15 Jun 2023 05:53:28 -0700 (PDT)
Received: from [10.72.12.155] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s14-20020a170902b18e00b001b246dcffb7sm14001586plr.300.2023.06.15.05.53.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 05:53:27 -0700 (PDT)
Message-ID: <65231c0f-cbf6-64f5-4d1b-07cf86534d06@redhat.com>
Date:   Thu, 15 Jun 2023 20:53:22 +0800
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
> I'm fine with keeping it for dout() messages.
Okay.
>    To further help with
> line lengths, how about naming the new macro doutc()?  Since it takes
> an extra argument before the format string, it feels distinctive enough
> despite it being just a single character.

Yeah, this looks much better.

Will fix this.

Thanks

- Xiubo

> Thanks,
>
>                  Ilya
>


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB01B731B33
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Jun 2023 16:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344721AbjFOOWq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 15 Jun 2023 10:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345035AbjFOOWn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 15 Jun 2023 10:22:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA5A1FFA
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jun 2023 07:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686838913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xJNsMlcddwt0ip2oYX0nMSuZu7ofPkFz9rL5Hlqm86g=;
        b=J8w4co2XOPQr6Qry2ULhRT9/oAV+q/60LDIYxQ4vG38XHZYbpFdmobp5G3Sp2ztxjZ+Rvg
        CTQfKhoMWGPGQNhaDc16azYXwhcCKWdPVw9AbkP/Ne/E6lYYrrziq2c0HR9O6UGEWcKZaS
        oPoNN7Y7fffShUcXsZJB7L1yD/WSGOk=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-qRvfEaH5M3qMstrZQnvceQ-1; Thu, 15 Jun 2023 10:21:52 -0400
X-MC-Unique: qRvfEaH5M3qMstrZQnvceQ-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1b3bb3dd181so30761925ad.3
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jun 2023 07:21:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686838911; x=1689430911;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xJNsMlcddwt0ip2oYX0nMSuZu7ofPkFz9rL5Hlqm86g=;
        b=bW1Huh9wuuiWXvsVgpjSMDKCJlbZV3e4HEWBbVStKVJS4MxdlIaw2TMN6EgMDt62fd
         J4Tea45tlsLvhuQ0KTNPwRqg9BFu2GgCjgUjjVm0itr9t9pTqCgtCWN7dR7v96M9uaQ1
         /pqQobbnvTgUhtbjOlKWo+3Sov7+VzIHrD1pR8oYfASIh8EFHlWxvf2hbQl2UU+Od6h1
         2z9T7EneRM5TJxKgQy0TXyU5713mCEM2EtuGoe+jb9evgm1KGhppXce4FoQp9hAxfiMA
         nAKvJ4bXP/U6vwp1RYgtMprxPTHwPAeavHyom4PhriHgYj3WgxqQdg7MtDE/fPEIonmc
         /EoA==
X-Gm-Message-State: AC+VfDykQyf2OCJgV+quUCWZ8QMmHKKakfN0+4yHlXelp/a6wtL1+PaR
        +W1oZcDC6aocPJ31FP+jJR3EmpusURHv5XUWRO0ygpNn+A0qk0ari+eVJhtv/+zBwRATjKM3vGY
        u+KM1BqVoMDKrcG+vhJGqWQ==
X-Received: by 2002:a17:902:e74d:b0:1b1:dfbd:a18c with SMTP id p13-20020a170902e74d00b001b1dfbda18cmr17310460plf.39.1686838911448;
        Thu, 15 Jun 2023 07:21:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7D6LyxGoEk4gngmWXFSn4M6KjpgIez4hrn03H5w7it6eftD82zYdGzNHoUUOB/4LMJEYR8Ug==
X-Received: by 2002:a17:902:e74d:b0:1b1:dfbd:a18c with SMTP id p13-20020a170902e74d00b001b1dfbda18cmr17310439plf.39.1686838911090;
        Thu, 15 Jun 2023 07:21:51 -0700 (PDT)
Received: from [10.72.12.62] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id iz22-20020a170902ef9600b001b3f809e7e4sm2543940plb.36.2023.06.15.07.21.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 07:21:50 -0700 (PDT)
Message-ID: <9d7b13f8-8fe7-7c11-5629-8f36818ce220@redhat.com>
Date:   Thu, 15 Jun 2023 22:21:45 +0800
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
 <bd7acf07-f04f-a2f0-2a23-24e0de20e508@redhat.com>
 <CAOi1vP_mfWoCX6-r6+kB2Cpg_moXQjAheq5FfV-CmJtfKv7hQQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_mfWoCX6-r6+kB2Cpg_moXQjAheq5FfV-CmJtfKv7hQQ@mail.gmail.com>
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


On 6/15/23 21:44, Ilya Dryomov wrote:
> On Thu, Jun 15, 2023 at 2:57 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 6/15/23 20:50, Ilya Dryomov wrote:
>>> On Thu, Jun 15, 2023 at 3:49 AM Xiubo Li <xiubli@redhat.com> wrote:
>>>> On 6/14/23 16:21, Ilya Dryomov wrote:
>>>>> On Wed, Jun 14, 2023 at 3:33 AM <xiubli@redhat.com> wrote:
>>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>>
>>>>>> This will help print the fsid and client's global_id in debug logs,
>>>>>> and also print the function names.
>>>>>>
>>>>>> URL: https://tracker.ceph.com/issues/61590
>>>>>> Cc: Patrick Donnelly <pdonnell@redhat.com>
>>>>>> Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
>>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>>> ---
>>>>>>     include/linux/ceph/ceph_debug.h | 44 ++++++++++++++++++++++++++++++++-
>>>>>>     1 file changed, 43 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_debug.h
>>>>>> index d5a5da838caf..26b9212bf359 100644
>>>>>> --- a/include/linux/ceph/ceph_debug.h
>>>>>> +++ b/include/linux/ceph/ceph_debug.h
>>>>>> @@ -19,12 +19,22 @@
>>>>>>            pr_debug("%.*s %12.12s:%-4d : " fmt,                            \
>>>>>>                     8 - (int)sizeof(KBUILD_MODNAME), "    ",               \
>>>>>>                     kbasename(__FILE__), __LINE__, ##__VA_ARGS__)
>>>>>> +#  define dout_client(client, fmt, ...)                                        \
>>>>>> +       pr_debug("%.*s %12.12s:%-4d : [%pU %lld] " fmt,                 \
>>>>>> +                8 - (int)sizeof(KBUILD_MODNAME), "    ",               \
>>>>>> +                kbasename(__FILE__), __LINE__,                         \
>>>>>> +                &client->fsid, client->monc.auth->global_id,           \
>>>>>> +                ##__VA_ARGS__)
>>>>>>     # else
>>>>>>     /* faux printk call just to see any compiler warnings. */
>>>>>>     #  define dout(fmt, ...)       do {                            \
>>>>>>                    if (0)                                          \
>>>>>>                            printk(KERN_DEBUG fmt, ##__VA_ARGS__);  \
>>>>>>            } while (0)
>>>>>> +#  define dout_client(client, fmt, ...)        do {                    \
>>>>>> +               if (0)                                          \
>>>>>> +                       printk(KERN_DEBUG fmt, ##__VA_ARGS__);  \
>>>>>> +       } while (0)
>>>>>>     # endif
>>>>>>
>>>>>>     #else
>>>>>> @@ -33,7 +43,39 @@
>>>>>>      * or, just wrap pr_debug
>>>>>>      */
>>>>>>     # define dout(fmt, ...)        pr_debug(" " fmt, ##__VA_ARGS__)
>>>>>> -
>>>>>> +# define dout_client(client, fmt, ...)                                 \
>>>>>> +       pr_debug("[%pU %lld] %s: " fmt, &client->fsid,                  \
>>>>>> +                client->monc.auth->global_id, __func__,                \
>>>>>> +                ##__VA_ARGS__)
>>>>>>     #endif
>>>>>>
>>>>>> +# define pr_notice_client(client, fmt, ...)                            \
>>>>>> +       pr_notice("[%pU %lld] %s: " fmt, &client->fsid,                 \
>>>>>> +                 client->monc.auth->global_id, __func__,               \
>>>>>> +                 ##__VA_ARGS__)
>>>>> Hi Xiubo,
>>>>>
>>>>> We definitely don't want the framework to include function names in
>>>>> user-facing messages (i.e. in pr_* messages).  In the example that
>>>>> spawned this series ("ceph: mds3 session blocklisted"), it's really
>>>>> irrelevant to the user which function happens to detect blocklisting.
>>>>>
>>>>> It's a bit less clear-cut for dout() messages, but honestly I don't
>>>>> think it's needed there either.  I know that we include it manually in
>>>>> many places but most of the time it's actually redundant.
>>>> The function name will include the most info needed in the log messages,
>>>> before almost all the log messages will add that explicitly or will add
>>>> one function name directly. Which may make the length of the 'fmt'
>>>> string exceeded 80 chars.
>>>>
>>>> If this doesn't make sense I will remove this from the framework.
>>> I'm fine with keeping it for dout() messages.  To further help with
>>> line lengths, how about naming the new macro doutc()?  Since it takes
>>> an extra argument before the format string, it feels distinctive enough
>>> despite it being just a single character.
>> What about the others macros ? Such as for the 'pr_info_client()',etc ?
> pr_info() and friends are used throughout the kernel, so the name is
> very recognizable.  We also have a lot fewer of them compared to douts,
> so I would stick with pr_info_client() (i.e. no shorthands).

Okay. Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>


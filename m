Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C876E3D13
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Apr 2023 03:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjDQBFz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Apr 2023 21:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDQBFy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Apr 2023 21:05:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FBD213D
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 18:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681693506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0VRTNMwnJjJ1FE7k2ZW/Etymh/blQrGubsTAZ5xP+zo=;
        b=M2uK5d4Qbd+/Gh/BjjLY5Q3JsS8I7UohMwek0YozVOVJdopMhjCNcN3D6S7oHb2ren/obz
        +gsJpVtnH8uI6ouvJwf3S61GFeyfgbAIvr/KqORF58BH++jTz5Zeav6o3510jK9C1/e0ka
        PpMeL4dtd9exfsfdpPXE+v1aKRssHMs=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523-QeV0QrIeMPi9mrB2yZcyjw-1; Sun, 16 Apr 2023 21:05:04 -0400
X-MC-Unique: QeV0QrIeMPi9mrB2yZcyjw-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-513f8b391f8so664965a12.1
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 18:05:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681693503; x=1684285503;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0VRTNMwnJjJ1FE7k2ZW/Etymh/blQrGubsTAZ5xP+zo=;
        b=G6d8gOZ4koWn1MftceRRk5LtQpWI3YuQe9iBw9weZNLnPpVI+xeGw6fSc2moTJ+oLA
         bP1kiLzfEMToEpqCRxWJ6Xkc6v2n6hHO224qaYyNlfVZ1akFHSwnzX/kdwrYY5mQw6Vl
         ldjMiVeIx3yVmjmF+MrNmdHtfSsluU/+4Y91YnPP3By3A9R3G+KopIGES/DAkbMsJixj
         lnNf9MK+gzWCvLrZL+3cT48ExntdzS+T9P6FNmZXMd6khn7zLx+jadfSGCsmwXsvilWi
         no2FnMBQyT7SJ20sQj1gkJoiQU+cYePEFwXUDg1PMlN7GXxFxo/zTO1EZqGhAZXmAm7B
         YCJQ==
X-Gm-Message-State: AAQBX9fZG1EsJMM0FLlfFmFxo5SoXLkcY/16uU5XcXbXrRdFtrB+LB4o
        ORsrpiDt9op2VoY5K+yyFdS++mXtPrSSTdQWVoWn94nACqLaAg5Qi6w7fJ3gMYBiQnMHWyZ/B7V
        Kcb2InJgretmiyCi/0sIvbg==
X-Received: by 2002:a05:6a00:1948:b0:63b:646d:9175 with SMTP id s8-20020a056a00194800b0063b646d9175mr14627823pfk.4.1681693503504;
        Sun, 16 Apr 2023 18:05:03 -0700 (PDT)
X-Google-Smtp-Source: AKy350YUu6+HTLowqcsdJ7K4z4ZXBUaiqhyMiSCo4LJ9ZJdqVXBu4ptm+j4XhljZJqPAG4U0So8SCg==
X-Received: by 2002:a05:6a00:1948:b0:63b:646d:9175 with SMTP id s8-20020a056a00194800b0063b646d9175mr14627802pfk.4.1681693503187;
        Sun, 16 Apr 2023 18:05:03 -0700 (PDT)
Received: from [10.72.12.181] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v4-20020aa78504000000b0063b675526eesm4536530pfn.46.2023.04.16.18.04.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Apr 2023 18:05:02 -0700 (PDT)
Message-ID: <ee059b09-a5c2-c882-1647-9403eea46cd4@redhat.com>
Date:   Mon, 17 Apr 2023 09:04:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v18 48/71] ceph: add infrastructure for file encryption
 and decryption
Content-Language: en-US
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, vshankar@redhat.com,
        mchangir@redhat.com, lhenriques@suse.de
References: <20230412110930.176835-1-xiubli@redhat.com>
 <20230412110930.176835-49-xiubli@redhat.com>
 <CAOi1vP-tVvBCEfu_3ofdwHaEoZr7qo102cZ8BPy8q67DDk-2tw@mail.gmail.com>
 <5636b031b3aea17ea3913fea2f76f94703008ea3.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <5636b031b3aea17ea3913fea2f76f94703008ea3.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/17/23 05:10, Jeff Layton wrote:
> On Sun, 2023-04-16 at 22:01 +0200, Ilya Dryomov wrote:
>> On Wed, Apr 12, 2023 at 1:13 PM <xiubli@redhat.com> wrote:
[...]
>>>   #endif
>>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>>> index b9dd2fa36d8b..4b0a070d5c6d 100644
>>> --- a/fs/ceph/super.c
>>> +++ b/fs/ceph/super.c
>>> @@ -591,6 +591,12 @@ static int ceph_parse_mount_param(struct fs_context *fc,
>>>                  break;
>>>          case Opt_test_dummy_encryption:
>>>   #ifdef CONFIG_FS_ENCRYPTION
>>> +               /* HACK: allow for cleartext "encryption" in files for testing */
>>> +               if (param->string && !strcmp(param->string, "clear")) {
>>> +                       fsopt->flags |= CEPH_MOUNT_OPT_DUMMY_ENC_CLEAR;
>> I really wonder whether this is still needed?  Having a mount option
>> that causes everything to be automatically encrypted with a dummy key
>> for testing purposes makes total sense.  Making it possible to disable
>> encryption through the same -- not so much.
>>
>> Does any other fscrypt-enabled filesystem in mainline do this?
>>
> I doubt it. It was totally a hack that I had in place to help debugging
> when I was developing this. My intention was always to remove this
> before merging it. I think doing that now would be a good idea.

Yeah, no this for other FSs and I will remove this option.

Thanks

- Xiubo


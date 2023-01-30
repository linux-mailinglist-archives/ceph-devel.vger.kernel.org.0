Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51CB680B91
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Jan 2023 12:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236587AbjA3LEQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Jan 2023 06:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236412AbjA3LD2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 30 Jan 2023 06:03:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2DA2E0D2
        for <ceph-devel@vger.kernel.org>; Mon, 30 Jan 2023 03:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675076565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xrhkYxUg1sVS4wjJEVeX59jr7DaVZyuaAbdOXs//pmg=;
        b=OorlzCxmGH8GI10mjsyXtvNX1+idf2x/h4SpDEMzfKhfxNO0spKgAwYqatmoj/ymaaScQ6
        zA4eFrzZcmULfiWNwHm8rmnD4JFih4b8lM7RaKshtadYGCQwm/1+Acry2xv0okRRGuh4k2
        ycsL9Ac+XRAhDTYUoJM7GPtsaTXFhB4=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-621-2aBJdMnuNyKvH0wWzC4_Tw-1; Mon, 30 Jan 2023 06:02:44 -0500
X-MC-Unique: 2aBJdMnuNyKvH0wWzC4_Tw-1
Received: by mail-pg1-f198.google.com with SMTP id e11-20020a63d94b000000b0048988ed9a6cso5002213pgj.1
        for <ceph-devel@vger.kernel.org>; Mon, 30 Jan 2023 03:02:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xrhkYxUg1sVS4wjJEVeX59jr7DaVZyuaAbdOXs//pmg=;
        b=dyDPg/a1+Wc/zpalxjs+Cc2peJ3Szt7V7eD2E/7yE/YJSSZo5eWix4Cahy8t2lvkZs
         Akzs6tK4/1XxGaaXqSAqzKGgjbnw9I4ytZeA1uwN92iO5q54ReJdIGWLovr53QJ9pwxC
         BTLwXBcKkYK6dq23PXVLoin2zx640CpS9CyF6rb9jzcconQZWXTvA7RvGNScQERbc453
         eeQs7IqYasvXua90KgK43wIqSJF7o0BuLEpwE3nEuTOb0131+kolU/eR71J/zMuV4y0i
         gTC52uHoBXfPAP5CGjjTzcbEbIVVaiSTPv7qTCdastZfpkrVd27wEAaQmQK8av26SoO7
         WfWA==
X-Gm-Message-State: AO0yUKVkBuI+AvtmHzAxrrghkUl8535+IV3jPTDTFn+lytZ819C63E6D
        GR6Gukl106wp6clR5OQAkffmhQjkKSl8drK4nCX2UYlPqWmCMKU4Nh0GPLI+2FkXRvObuPxdjT2
        IdgD6zDyd3onp1+f14OFO9Q==
X-Received: by 2002:a62:1c10:0:b0:57d:56f1:6ae7 with SMTP id c16-20020a621c10000000b0057d56f16ae7mr15159712pfc.33.1675076563477;
        Mon, 30 Jan 2023 03:02:43 -0800 (PST)
X-Google-Smtp-Source: AK7set8m0RyNEgR5f3rWVe/zyRzEpNVx5HRq7H5Jqo8RJzxw0tWURGyor8eTfAhfNe5T/TppLaH6lA==
X-Received: by 2002:a62:1c10:0:b0:57d:56f1:6ae7 with SMTP id c16-20020a621c10000000b0057d56f16ae7mr15159693pfc.33.1675076563241;
        Mon, 30 Jan 2023 03:02:43 -0800 (PST)
Received: from [10.72.13.217] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p6-20020a056a000a0600b00581013fcbe1sm7105092pfh.159.2023.01.30.03.02.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 03:02:42 -0800 (PST)
Message-ID: <2afdde92-d0b1-0a24-dc2f-22da2e3d369d@redhat.com>
Date:   Mon, 30 Jan 2023 19:02:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v6] ceph: blocklist the kclient when receiving corrupted
 snap trace
To:     Venky Shankar <vshankar@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, stable@vger.kernel.org
References: <20230112085602.14583-1-xiubli@redhat.com>
 <CACPzV1k_KMTPLmTxjH39OqHAb63=WHo8GPGM9SuZA6N_d4FhWQ@mail.gmail.com>
Content-Language: en-US
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CACPzV1k_KMTPLmTxjH39OqHAb63=WHo8GPGM9SuZA6N_d4FhWQ@mail.gmail.com>
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


On 30/01/2023 18:01, Venky Shankar wrote:
> On Thu, Jan 12, 2023 at 2:26 PM <xiubli@redhat.com> wrote:
[...]
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index ec1edfae20a0..22086f78732f 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -111,6 +111,7 @@ enum {
>>          CEPH_MOUNT_UNMOUNTED,
>>          CEPH_MOUNT_SHUTDOWN,
>>          CEPH_MOUNT_RECOVER,
>> +       CEPH_MOUNT_FENCE_IO,
>>   };
>>
>>   #define CEPH_ASYNC_CREATE_CONFLICT_BITS 8
>> --
>> 2.31.1
>>
> Looks good.
>
> Tested-by: Venky Shankar <vshankar@redhat.com>
>
Thanks Venky.


-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li


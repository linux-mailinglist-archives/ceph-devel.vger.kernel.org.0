Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3597D6FBC95
	for <lists+ceph-devel@lfdr.de>; Tue,  9 May 2023 03:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbjEIBl0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 May 2023 21:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjEIBlY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 May 2023 21:41:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC364215
        for <ceph-devel@vger.kernel.org>; Mon,  8 May 2023 18:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683596437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6vzuoOvCSy9g37eFis76J7DOks7Zln6eFn1xjdPAIc4=;
        b=TXkat2maYZvK5M7xvpIMcFM+3njzppxyX87LyYtHO+4+Wdln9Z6vGOrnJ5sNUgoW6KV7ut
        Y0d1T94iSuSe5VqusbozsNFSAM/Pm5GFI4QUEKn75SRJTI9Qptluohy350/RfHOA3PBwpP
        fCwGKnMKihsmgLIPRJyE5PPH5Q3DSWg=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-PnTRHCLIMsC7yKs7CkR4rQ-1; Mon, 08 May 2023 21:40:35 -0400
X-MC-Unique: PnTRHCLIMsC7yKs7CkR4rQ-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-6439df91d81so2350863b3a.3
        for <ceph-devel@vger.kernel.org>; Mon, 08 May 2023 18:40:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683596435; x=1686188435;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6vzuoOvCSy9g37eFis76J7DOks7Zln6eFn1xjdPAIc4=;
        b=OxjXOBaxI8CxflXQBMJC4kto3wrR2la3ySShyg670T6Qe93taZv4IKofgVYzc/Vg/h
         r+zgxXeEnRjRsiQd05fjn8hBlcJHlofgCs5eH3VW6L5Or2vJRME7SUn4V0rdQlxQBCJk
         EeLsInnzn20txmFXK0jM3cQAtwbCT+/XI/Hv/eWWDN14fDJUH4WdyTqGg+DlEr+MoOhF
         HFToSTvOIW9RVE045AfjStYWYClZUR/MItcWoS1AXyrBDjnjanB53Z48nbwjn65LLSWg
         nmc+cYJhNNd8HIn/81EARsQp+G20jGOGUaIWHqWM47sSAat3rQoyp+ey7bDk9q+AsoCd
         SkdA==
X-Gm-Message-State: AC+VfDxX4QNSlTz8Qaz4YY47JV6K48qQ70rcYzufs/Ml1fMv3WaHm4ZG
        EKLXcjpztO5+QvohdQYAd605vBtvSeUDvYzLoQ4cuU+TYMPxR1v70AiwJbrw/HDyN5rBVIi14jR
        5t+h//U/zxLDvI6sDUQrrvg==
X-Received: by 2002:a05:6a00:24cf:b0:63d:3411:f9e3 with SMTP id d15-20020a056a0024cf00b0063d3411f9e3mr17888573pfv.19.1683596434907;
        Mon, 08 May 2023 18:40:34 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7NDtGk1VnQ/GsthIDF99qsqaBGSMB/NlLueYGoRPwpzEQM8qyuUIk9/BRc/qQDK51+RSfQrQ==
X-Received: by 2002:a05:6a00:24cf:b0:63d:3411:f9e3 with SMTP id d15-20020a056a0024cf00b0063d3411f9e3mr17888559pfv.19.1683596434602;
        Mon, 08 May 2023 18:40:34 -0700 (PDT)
Received: from [10.72.12.156] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l21-20020a62be15000000b006259beddb63sm589137pff.44.2023.05.08.18.40.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 18:40:34 -0700 (PDT)
Message-ID: <ed6d4ae8-98af-4cca-9c2d-4d172b622988@redhat.com>
Date:   Tue, 9 May 2023 09:40:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/3] ceph: refactor mds_namespace comparing
Content-Language: en-US
From:   Xiubo Li <xiubli@redhat.com>
To:     Hu Weiwen <huww98@outlook.com>, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Venky Shankar <vshankar@redhat.com>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
References: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <TYCP286MB2066C89FCBD9FB30AFDF2D70C0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <ce388c9d-97f1-57fb-4ed2-745596e1bd5f@redhat.com>
In-Reply-To: <ce388c9d-97f1-57fb-4ed2-745596e1bd5f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/9/23 09:04, Xiubo Li wrote:
>
> On 5/8/23 01:55, Hu Weiwen wrote:
>> From: Hu Weiwen <sehuww@mail.scut.edu.cn>
>>
>> Same logic, slightly less code.  Make the following changes easier.
>>
>> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
>> ---
>>   fs/ceph/super.c | 34 ++++++++++++++--------------------
>>   1 file changed, 14 insertions(+), 20 deletions(-)
>>
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index 3fc48b43cab0..4e1f4031e888 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -235,18 +235,10 @@ static void canonicalize_path(char *path)
>>       path[j] = '\0';
>>   }
>>   -/*
>> - * Check if the mds namespace in ceph_mount_options matches
>> - * the passed in namespace string. First time match (when
>> - * ->mds_namespace is NULL) is treated specially, since
>> - * ->mds_namespace needs to be initialized by the caller.
>> - */
>> -static int namespace_equals(struct ceph_mount_options *fsopt,
>> -                const char *namespace, size_t len)
>> +/* check if s1 (null terminated) equals to s2 (with length len2) */
>> +static int strstrn_equals(const char *s1, const char *s2, size_t len2)
>>   {
>> -    return !(fsopt->mds_namespace &&
>> -         (strlen(fsopt->mds_namespace) != len ||
>> -          strncmp(fsopt->mds_namespace, namespace, len)));
>> +    return !strncmp(s1, s2, len2) && strlen(s1) == len2;
>>   }
>
> Could this helper be defined as inline explicitly ?
>
Please ignore this, I misreaded and it's not in the header file.


>>     static int ceph_parse_old_source(const char *dev_name, const char 
>> *dev_name_end,
>> @@ -297,12 +289,13 @@ static int ceph_parse_new_source(const char 
>> *dev_name, const char *dev_name_end,
>>       ++fs_name_start; /* start of file system name */
>>       len = dev_name_end - fs_name_start;
>>   -    if (!namespace_equals(fsopt, fs_name_start, len))
>> +    if (!fsopt->mds_namespace) {
>> +        fsopt->mds_namespace = kstrndup(fs_name_start, len, 
>> GFP_KERNEL);
>> +        if (!fsopt->mds_namespace)
>> +            return -ENOMEM;
>> +    } else if (!strstrn_equals(fsopt->mds_namespace, fs_name_start, 
>> len)) {
>>           return invalfc(fc, "Mismatching mds_namespace");
>> -    kfree(fsopt->mds_namespace);
>> -    fsopt->mds_namespace = kstrndup(fs_name_start, len, GFP_KERNEL);
>> -    if (!fsopt->mds_namespace)
>> -        return -ENOMEM;
>> +    }
>>       dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
>>         fsopt->new_dev_syntax = true;
>> @@ -417,11 +410,12 @@ static int ceph_parse_mount_param(struct 
>> fs_context *fc,
>>           param->string = NULL;
>>           break;
>>       case Opt_mds_namespace:
>> -        if (!namespace_equals(fsopt, param->string, 
>> strlen(param->string)))
>> +        if (!fsopt->mds_namespace) {
>> +            fsopt->mds_namespace = param->string;
>> +            param->string = NULL;
>> +        } else if (strcmp(fsopt->mds_namespace, param->string)) {
>>               return invalfc(fc, "Mismatching mds_namespace");
>> -        kfree(fsopt->mds_namespace);
>> -        fsopt->mds_namespace = param->string;
>> -        param->string = NULL;
>> +        }
>>           break;
>>       case Opt_recover_session:
>>           mode = result.uint_32;


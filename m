Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6984DC461
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Mar 2022 12:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbiCQLEB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Mar 2022 07:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbiCQLEB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Mar 2022 07:04:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C8DF31DFDF6
        for <ceph-devel@vger.kernel.org>; Thu, 17 Mar 2022 04:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647514963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cXeXA633cVJ0LM/fTbIriWK2KPHFVHlaSXmXHmrJHuE=;
        b=TjzAJVdhmUSdDo8GVziUW68lFde70vSx1FlmW532Z1pq9bT7zobyokhWgb38frgNxw2dYL
        n31avcjucisQCoj8RFksEhpf3QnBc7AyC3HWCypinI132GiDkhP4Swy8grYI9py47074S2
        DYsIKDTQm4r7BoqJudg+qiCvYM6Z6ws=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-159-9NiNWcQIOtGw4TLtlO0yNg-1; Thu, 17 Mar 2022 07:02:42 -0400
X-MC-Unique: 9NiNWcQIOtGw4TLtlO0yNg-1
Received: by mail-pj1-f72.google.com with SMTP id q21-20020a17090a2e1500b001c44f70fd38so3183320pjd.6
        for <ceph-devel@vger.kernel.org>; Thu, 17 Mar 2022 04:02:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=cXeXA633cVJ0LM/fTbIriWK2KPHFVHlaSXmXHmrJHuE=;
        b=2GM2cp/boCda0IRaLbwXmjcZuNZKFzXRxbujDMkVh7kGH7TgmBCSzZk7tH+cn/sHym
         LuyAsCJG75Zs8RuIcvY/JHUaKaAfG19JXM00aEs5J2objfiiIg9nP4sKLa1L6cZLLDTS
         ss33/FjiRNzuBWDpYksfarXwoUV2O2Lpjf1J9gae6WMmBrk4M3Q9w/82rfDyMgVX/eox
         8pvNiGmOQ5gP2AZWvwwZjy0MSOq9KgMXkjzKoqp1L3IIqptKO3PIgHPlPvBVYnr7dVDM
         cYoMyDFS+qRUQaznYOevWLRwB5XeQ8FvQcLcyBTE6vH4V4BMeLKMJV42fZoj3tSqWhZM
         0OZA==
X-Gm-Message-State: AOAM531bbytZ7JiFle7og9crXzes8f8fMGNln4tDalRJYaL4IrHly98k
        gsz/jjOQ5DtKQv/r9ahIlrRCfhzHYpGN6a3uyVLHuw3X91yAR5NkIaz1+NSjFfJG/J1KGN4XaoF
        JoI92cr+S1j+aZ4MiyUYeTw==
X-Received: by 2002:a05:6a00:2182:b0:4f6:5051:61db with SMTP id h2-20020a056a00218200b004f6505161dbmr4330477pfi.40.1647514961134;
        Thu, 17 Mar 2022 04:02:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxffglap+v5MUI+kVmbnqT1uzfdTGAL3EPrbxLZLqztCmhYGIklsmmjv87OoBNqs7vKc8TCVg==
X-Received: by 2002:a05:6a00:2182:b0:4f6:5051:61db with SMTP id h2-20020a056a00218200b004f6505161dbmr4330445pfi.40.1647514960792;
        Thu, 17 Mar 2022 04:02:40 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id kk12-20020a17090b4a0c00b001bed1ff3717sm5549766pjb.6.2022.03.17.04.02.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 04:02:40 -0700 (PDT)
Subject: Re: [RFC PATCH v2 0/3] ceph: add support for snapshot names
 encryption
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <20220315161959.19453-1-lhenriques@suse.de>
 <5b53e812-d49b-45f0-1219-3dbc96febbc1@redhat.com>
 <87bky4j36l.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <64d590ad-ae0c-21c2-f24d-1be3e7662578@redhat.com>
Date:   Thu, 17 Mar 2022 19:02:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87bky4j36l.fsf@brahms.olymp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
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


On 3/17/22 6:14 PM, Luís Henriques wrote:
> Xiubo Li <xiubli@redhat.com> writes:
>
>> Hi Luis,
>>
>> There has another issue you need to handle at the same time.
>>
>> Currently only the empty directory could be enabled the file encryption, such as
>> for the following command:
>>
>> $ fscrypt encrypt mydir/
>>
>> But should we also make sure that the mydir/.snap/ is empty ?
>>
>> Here the 'empty' is not totally empty, which allows it should allow long snap
>> names exist.
>>
>> Make sense ?
> Right, actually I had came across that question in the past but completely
> forgot about it.
>
> Right now we simply check the dir stats to ensure a directory is empty.
> We could add an extra check in ceph_crypt_empty_dir() to ensure that there
> are no snapshots _above_ that directory (i.e. that there are no
> "mydir/.snap/_name_xxxxx").
>
> Unfortunately, I don't know enough of snapshots implementation details to
> understand if it's a problem to consider a directory as being empty (in
> the fscrypt context) when there are these '_name_xxx' directories.  My
> feeling is that this is not a problem but I really don't know.
>
> Do you (or anyone) have any ideas/suggestions?

There is no need to care about the long snap names in .snap, because 
they are all from the parent snaprealms.

What you need to make sure is that there shouldn't have any local 
snapshot before encrypting the directory.

If we don't make sure about this then when encrypting/decrypting the 
snapshot names you will hit errors in theory.

But I didn't test this yet, you can try.

-- Xiubo

> Cheers,


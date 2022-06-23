Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71141557A17
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Jun 2022 14:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbiFWMQG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Jun 2022 08:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiFWMQF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Jun 2022 08:16:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 05DA62DA84
        for <ceph-devel@vger.kernel.org>; Thu, 23 Jun 2022 05:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655986563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V43FwghGJqT/GtmLVt9pCxCOUD0u8LcXiCuZWMPzwwg=;
        b=DJtR/XkLCUfHB7AzE43MtCTQ1Tf/xlDq4i+9MrryipB/IaZ+mSmTlNL/Hb13Z/5gAVJSZh
        CoN4103IShuk438Mnt2lSr5bjYjTGtHO1bAqW0yYZe5EjS7cB4F4MikF+6BJQeJmZmygWU
        KR/YtLcvzqiYez7tL5/4CbLyESkJVLg=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-F58pmqjwNQmbmfltPJPH5A-1; Thu, 23 Jun 2022 08:16:02 -0400
X-MC-Unique: F58pmqjwNQmbmfltPJPH5A-1
Received: by mail-pg1-f200.google.com with SMTP id q8-20020a632a08000000b00402de053ef9so10526217pgq.3
        for <ceph-devel@vger.kernel.org>; Thu, 23 Jun 2022 05:16:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=V43FwghGJqT/GtmLVt9pCxCOUD0u8LcXiCuZWMPzwwg=;
        b=q1F4iKh2JiJMwhEk2RrpMeshDSqBeXbgl9Mr4GhIkKJUcS2gTRtlHceSLVnWWFKTqF
         PtK5KZ5AafT9e0z/jqgB2hISZE2vk4k03FY6hH3SAswPJ9w4XTaupfXm9LKRqA7Fo6Ug
         uh0pOqtkVue3FW2zTGri3X2MgL3itAgaJpUyPQpcGdYZiHbU9G6T95nX3nEM93bAzoVu
         wXzI8b6UMSVJolGlaqBcgreS2N351yrElDk29PL0m/loiaCJfEmouvpbskMNYmjX7rD+
         h+B9YQJubSLD6YM3NmTCiBnPT3rCNcWEf7Le/lkA1Ti6gHOnebZP3EFCnGxx4dI3NBgk
         XWBA==
X-Gm-Message-State: AJIora9Xclp4QHTv0JbV2A3O02MBgvZLSpNYDylKknxpoXHx2KFMzp2U
        r5n922aixPBuAqk1oFqwT77a8kfivIj/FJXffW4C/ogjatOneWlFjymgO7wAnxd3+uYDw3YFEyz
        n5/7nFIYmgxtcm/v/XcGpT622DNK/FhCF+o5S8opaFoFmyCFVHTvesF3+APGrtTUlBmZLcIU=
X-Received: by 2002:a63:2344:0:b0:3fd:fd53:5fd1 with SMTP id u4-20020a632344000000b003fdfd535fd1mr7396003pgm.478.1655986561207;
        Thu, 23 Jun 2022 05:16:01 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vOC0tRpIfF3WWOHX/RUGL9hwqpb+m1uWlsc7f+YlBSxdVc097Jh5NpOmsXf7O284r5tfvCMQ==
X-Received: by 2002:a63:2344:0:b0:3fd:fd53:5fd1 with SMTP id u4-20020a632344000000b003fdfd535fd1mr7395976pgm.478.1655986560903;
        Thu, 23 Jun 2022 05:16:00 -0700 (PDT)
Received: from [10.72.12.43] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z27-20020aa79e5b000000b0052553215444sm1858396pfq.101.2022.06.23.05.15.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 05:16:00 -0700 (PDT)
Subject: Re: [PATCH] ceph: flush the dirty caps immediatelly when quota is
 approaching
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20220623095238.874126-1-xiubli@redhat.com>
 <87pmizk6b1.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d06888c5-50d0-9fbb-17bc-e84b9ef50036@redhat.com>
Date:   Thu, 23 Jun 2022 20:15:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87pmizk6b1.fsf@brahms.olymp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/23/22 6:44 PM, Luís Henriques wrote:
> xiubli@redhat.com writes:
>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When the quota is approaching we need to notify it to the MDS as
>> soon as possible, or the client could write to the directory more
>> than expected.
>>
>> This will flush the dirty caps without delaying after each write,
>> though this couldn't prevent the real size of a directory exceed
>> the quota but could prevent it as soon as possible.
> Nice, looks good.  Unfortunately, the real problem can't probably be
> solved without a complete re-design of the cephfs quotas.  Oh well...

Yeah, correct. Currently this is what we can do.

Thanks Luis!

> Reviewed-by: Luís Henriques <lhenriques@suse.de>
>
> Cheers,


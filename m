Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3324CB3F5
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Mar 2022 02:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiCCBIz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Mar 2022 20:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbiCCBIy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Mar 2022 20:08:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E2851BCAE
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 17:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646269689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zMDdelzRBEh58lDq5ja6GrU4Nat4ZVadVHaQCYhtdYI=;
        b=Y+S1XmzaLjbMBz2bbjWEECU2FHf8A4k6aFJHew401edsDHj+dw9qxOVN8M8pRBA8BUVrvk
        QqgKkyvWhLGs7EbGOhvv6SPyT3UTFIHUpu5Il/fAJEntKNhlj1WVAEwDrB4uIrXsR78iJ6
        Ug4EPzzF/lzFJ+FgJalqSQZUPHikyNY=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-s98FEOYTO_WtyALWH2KOag-1; Wed, 02 Mar 2022 20:08:08 -0500
X-MC-Unique: s98FEOYTO_WtyALWH2KOag-1
Received: by mail-pg1-f198.google.com with SMTP id t18-20020a63dd12000000b00342725203b5so1895597pgg.16
        for <ceph-devel@vger.kernel.org>; Wed, 02 Mar 2022 17:08:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=zMDdelzRBEh58lDq5ja6GrU4Nat4ZVadVHaQCYhtdYI=;
        b=3hsTas4Tej4v7UsMuA2WTE9dxd9J3SBfUK+lnIC11hDHQ/aWZMZGKTfE6fAgvgSjJJ
         9g6Zb/QqkBkedbOrVyg41QLLgSFt0dAMoeuef23jM19xg14cP8IR0wArSuKjupmUjR9m
         pZeMEdVIO7d84FFVGBB7nzEN5i679xBirGEoDK4IyqFTsPsV8qYQJWgF5hVPHYuG4acZ
         WvIuUFzPYRtC0SisGSZWl4sKlxWBoOwo5ERq3YAvB6u0qWwc9Vfeq2ivfWINWbHGYeqK
         v5v+WeEkYOwIA4HkZvBB8ti39qZtzUpkxa6poc0sRieivGqVnJvTj+XPDiFdR3hV2X8m
         ExVw==
X-Gm-Message-State: AOAM532A04xHwX0Om44mQ5OSnSNvJlGvLDrQsfUxjDRi1Vdjl47cDHCN
        GemD6wmGMPUGu5y4fT7dqKyAdx8G/YCaKgRGIpDqHHlldGAFVWxx2uJ/XJsJUxSzctvYVnyEBTQ
        jlUhm7ylkeCfq1raCxVaFj2zUNSf7pnZap5ViTRlEgKwXtU/HgxZGCgTaqdh2YKBd9+cxXyM=
X-Received: by 2002:a63:788c:0:b0:374:87b6:a9d2 with SMTP id t134-20020a63788c000000b0037487b6a9d2mr28086188pgc.303.1646269686411;
        Wed, 02 Mar 2022 17:08:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyUUkZw6Cee+oTvXWReKSmDPsLkbNaWbRUe9Ta6JZpyQyHVioOfqcf/P+ovCwVJm8p3kutLuQ==
X-Received: by 2002:a63:788c:0:b0:374:87b6:a9d2 with SMTP id t134-20020a63788c000000b0037487b6a9d2mr28086154pgc.303.1646269685897;
        Wed, 02 Mar 2022 17:08:05 -0800 (PST)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l2-20020a056a0016c200b004e10af156adsm383356pfc.190.2022.03.02.17.08.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 17:08:04 -0800 (PST)
Subject: Re: [PATCH 2/2] ceph: fix a NULL pointer dereference in
 ceph_handle_caps()
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220302085402.64740-1-xiubli@redhat.com>
 <20220302085402.64740-3-xiubli@redhat.com>
 <18af03fd35eadc2fb34ef2df62194785f073a956.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0b19e1b6-3c88-2aff-c4d1-92c7f8a87fe0@redhat.com>
Date:   Thu, 3 Mar 2022 09:08:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <18af03fd35eadc2fb34ef2df62194785f073a956.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/2/22 10:06 PM, Jeff Layton wrote:
> On Wed, 2022-03-02 at 16:54 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The ceph_find_inode() may will fail and return NULL.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 0b36020207fd..0762b55fdbcb 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -4303,7 +4303,6 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>>   
>>   	/* lookup ino */
>>   	inode = ceph_find_inode(mdsc->fsc->sb, vino);
>> -	ci = ceph_inode(inode);
>>   	dout(" op %s ino %llx.%llx inode %p\n", ceph_cap_op_name(op), vino.ino,
>>   	     vino.snap, inode);
>>   
>> @@ -4333,6 +4332,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>>   		}
>>   		goto flush_cap_releases;
>>   	}
>> +	ci = ceph_inode(inode);
>>   
>>   	/* these will work even if we don't have a cap yet */
>>   	switch (op) {
> I don't think this is an actual bug. We're just assigning "ci" here and
> that doesn't involve a dereference of inode. If "inode" is NULL, then ci
> will be close to NULL, but it doesn't get used in that case.

Right, I misread the code.

> Assigning this lower in the function is fine though, and it discourages
> anyone trying to use ci when they shouldn't, so you can add my ack, but
> maybe fix the patch description since there is no dereference here.
>
> Acked-by: Jeff Layton <jlayton@kernel.org>

Sure, thanks.



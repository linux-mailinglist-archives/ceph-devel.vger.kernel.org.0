Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19245504ED8
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 12:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237694AbiDRK2K (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Apr 2022 06:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237692AbiDRK2I (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Apr 2022 06:28:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5353E101DF
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650277526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H0KF/UlRziKcI4teQ0d5RKjJlOS1s/4Cw537YrUTNoA=;
        b=RqhBqTlCUEO0lK8mrDTu3AhG0E4ExDfpM5JYM5k8Qpe7dMvtqiCQhzmRX7ncP/67E/3L8O
        foxWOHfXoXv9JsQGh3LTciDP+Lc3SaV+j+ZXVfiV+lLFzpMVDsQypWrxfVLNVEVvsv6l46
        sMfQUkGImlULvG04cf6NQRyb+KhLJyM=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-36-PmCwkYWgN4WUQsu4bpcNJA-1; Mon, 18 Apr 2022 06:25:25 -0400
X-MC-Unique: PmCwkYWgN4WUQsu4bpcNJA-1
Received: by mail-pg1-f199.google.com with SMTP id u3-20020a632343000000b0039cac94652aso8752567pgm.11
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:25:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=H0KF/UlRziKcI4teQ0d5RKjJlOS1s/4Cw537YrUTNoA=;
        b=beke8sLQ0M1Z/vVMEnc8/l/Fr9fabIlSKUe/xBgB3LltY3E0SVetmoqz7R30RMqPV/
         9KVHdstLcbH2HOzJn/Lrx/Fi2nxJ8fUZRCGo0tenJwoT1rBv2a/C4KGKFngInEGJqKgZ
         thGpBRxoAt2ztKYBJraSNYOHB7r5nTG+pZ5VjgdgUVcjGwWMB7HpiUkbhgNntdKO5nIc
         6BDP3/lKWbPJ0A+MeCbb+K8V+AppmyZfD83dW7O3E5kBawV2fnxVXkTALCUwCmJEAliV
         QeRYHtQ0Bsx4YCijp+IlLnwCM4h4f6jfEzgNVYrbv8ztDfXLfsfAFTUDz1reXxqY+8d0
         CyTw==
X-Gm-Message-State: AOAM532ghLFwF6+E3PJStSr2iR4LECLDydJ1qlzx4fa5hFLzhISVhv4p
        OUr6baoPjn3QPsd4J86EE76eQm0eXj7jGLZVxB1BLUmxPX9jbLAPo31IrSrk8iQSsgxS2lw9vaq
        zNl+c+bcBmc71JaHSNm7oOavUjPp+5Lg7agq3wEgCpU7kab+U+1lcx0bLUomPruPoTE51pe0=
X-Received: by 2002:a17:90a:3e48:b0:1cd:34ec:c72f with SMTP id t8-20020a17090a3e4800b001cd34ecc72fmr17656034pjm.65.1650277524004;
        Mon, 18 Apr 2022 03:25:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzK1zzq5Qn164zsgK2YM9vkwuuE4eay5xkp02YhI3GmLDiFqJmQl/80EsAtYAUMuTaBFDO+/Q==
X-Received: by 2002:a17:90a:3e48:b0:1cd:34ec:c72f with SMTP id t8-20020a17090a3e4800b001cd34ecc72fmr17655938pjm.65.1650277523037;
        Mon, 18 Apr 2022 03:25:23 -0700 (PDT)
Received: from [10.72.12.77] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o2-20020a17090a55c200b001ce0843e0d9sm12453337pjm.38.2022.04.18.03.25.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 03:25:22 -0700 (PDT)
Subject: Re: [RFC resend PATCH] ceph: fix statx AT_STATX_DONT_SYNC vs
 AT_STATX_FORCE_SYNC check
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, dhowells@redhat.com,
        ceph-devel@vger.kernel.org
References: <20220411093405.301667-1-xiubli@redhat.com>
 <c013aafd233d4ec303238425b11f6c96c8a3b7a7.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b38b37bc-faa7-cbae-ce3a-f10c0818a293@redhat.com>
Date:   Mon, 18 Apr 2022 18:25:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c013aafd233d4ec303238425b11f6c96c8a3b7a7.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/18/22 6:15 PM, Jeff Layton wrote:
> On Mon, 2022-04-11 at 17:34 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>>  From the posix and the initial statx supporting commit comments,
>> the AT_STATX_DONT_SYNC is a lightweight stat flag and the
>> AT_STATX_FORCE_SYNC is a heaverweight one. And also checked all
>> the other current usage about these two flags they are all doing
>> the same, that is only when the AT_STATX_FORCE_SYNC is not set
>> and the AT_STATX_DONT_SYNC is set will they skip sync retriving
>> the attributes from storage.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/inode.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index 6788a1f88eb6..1ee6685def83 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -2887,7 +2887,7 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
>>   		return -ESTALE;
>>   
>>   	/* Skip the getattr altogether if we're asked not to sync */
>> -	if (!(flags & AT_STATX_DONT_SYNC)) {
>> +	if ((flags & AT_STATX_SYNC_TYPE) != AT_STATX_DONT_SYNC) {
>>   		err = ceph_do_getattr(inode,
>>   				statx_to_caps(request_mask, inode->i_mode),
>>   				flags & AT_STATX_FORCE_SYNC);
> I don't get it.
>
> The only way I can see that this is a problem is if someone sent down a
> mask with both DONT_SYNC and FORCE_SYNC set in it, and in that case I
> don't see that ignoring FORCE_SYNC would be wrong...
>
There has 3 cases for the flags:

case1: flags & AT_STATX_SYNC_TYPE == 0

case2: flags & AT_STATX_SYNC_TYPE == AT_STATX_DONT_SYNC

case3: flags & AT_STATX_SYNC_TYPE == AT_STATX_DONT_SYNC | 
AT_STATX_FORCE_SYNC


Only in case2, which is only the DONT_SYNC bit is set, will ignore 
calling ceph_do_getattr() here. And for case3 it will ignore the 
DONT_SYNC bit.

-- Xiubo





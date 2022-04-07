Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527074F87AF
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Apr 2022 21:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236148AbiDGTIj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 15:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiDGTIi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 15:08:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6189E1BB7B1
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 12:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649358396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ZV2RySNApBdYVtXrSmI6wP4y8RQlqeNfGW1VSPNSu0=;
        b=LI0OSUKdX8X9Yd2+CTcM82lw+1EEpOsqgvNzE4JtcciOYG/uxZsL08/LrEMH8O7PBjgq7O
        qyTZwqTgW2mq/EWgXYDiCMveQhbHe+1owEemdGcqysp7YGBNPFummitVZvPmbReTsmlsV2
        o9m9yhEDFB/QrUnxXT5r50aaIUYbHOk=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-yPh18uGhMP-GXsbVbxTUsQ-1; Thu, 07 Apr 2022 15:06:35 -0400
X-MC-Unique: yPh18uGhMP-GXsbVbxTUsQ-1
Received: by mail-pf1-f197.google.com with SMTP id b6-20020a62a106000000b0050564d6fd75so1888483pff.22
        for <ceph-devel@vger.kernel.org>; Thu, 07 Apr 2022 12:06:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5ZV2RySNApBdYVtXrSmI6wP4y8RQlqeNfGW1VSPNSu0=;
        b=K/LB/6tXLOjSRoS+JKA91HZEhmVU8ubyfyeKYFyXZjQLUd8QqLX3ItlgHeIXtkr1vY
         YxtyHTPGb/rH8NWqoMEfg9f7brbsAkoAQ8DSlOrwQ7mpsxTYwTm+pQqqcwp6Rh+wkcHn
         D0OW0yCOH6F0k4+X1s34UAR4kAot51XVb4QKVcjzycKJNZfAUbZ2o0HhwC1x0lXgKNoa
         YrWZ028nF4HNqjPqquuTEzfsS2dtMeHg25THu1QFtSt8SVz1YAAo+eJc8nuQJfgLAarA
         NyqZgbrTRMP/vrcqgQTkBL7fyOSEnNobR7Swu+0BiBXsuDcsAelSXs/k3evfrHe9QMHm
         HWRA==
X-Gm-Message-State: AOAM530nYdCWNI3JeTsvMlswMgu5HalSNT2nsDaJacc2TZ0szS5cExXu
        JXE2t9TGjswINGSZNytMvZu8u/5eYPJ7sduMtxDdwXqwbomZmH98qlxLVOSmLdp8+TKEXPgdW1k
        AeXjNgf6YmsAHOcFe8bpgFa47j04nRpr38YFOQlzYDRrvqRJKUYFzzbNi/Dw7ikny57/XCsg=
X-Received: by 2002:a17:903:2302:b0:157:1c5f:14f0 with SMTP id d2-20020a170903230200b001571c5f14f0mr1451076plh.138.1649358394251;
        Thu, 07 Apr 2022 12:06:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwg2HtGqj92nalUZR6QwZIPwIgy+XtVEscCyuzmzutrW5PROlnPHhfkfP5F/E/qCAB9fE2rXg==
X-Received: by 2002:a17:903:2302:b0:157:1c5f:14f0 with SMTP id d2-20020a170903230200b001571c5f14f0mr1451045plh.138.1649358393934;
        Thu, 07 Apr 2022 12:06:33 -0700 (PDT)
Received: from [10.72.12.194] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090a3fc600b001ca88b0bdfesm9804021pjm.13.2022.04.07.12.06.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 12:06:33 -0700 (PDT)
Subject: Re: [PATCH 1/2] ceph: flush small range instead of the whole map for
 truncate
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
References: <20220407144112.8455-1-xiubli@redhat.com>
 <20220407144112.8455-2-xiubli@redhat.com>
 <1677074117b56ecfb96e2eef7b9760e6d8cde581.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <258737bd-abef-8f32-ef91-696a9c1f6c57@redhat.com>
Date:   Fri, 8 Apr 2022 03:06:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1677074117b56ecfb96e2eef7b9760e6d8cde581.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/7/22 11:45 PM, Jeff Layton wrote:
> On Thu, 2022-04-07 at 22:41 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/inode.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index 45ca4e598ef0..f4059d73edd5 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -2275,8 +2275,12 @@ static int fill_fscrypt_truncate(struct inode *inode,
>>   	     ceph_cap_string(issued));
>>   
>>   	/* Try to writeback the dirty pagecaches */
>> -	if (issued & (CEPH_CAP_FILE_BUFFER))
>> -		filemap_write_and_wait(inode->i_mapping);
>> +	if (issued & (CEPH_CAP_FILE_BUFFER)) {
>> +		ret = filemap_write_and_wait_range(inode->i_mapping,
>> +						   orig_pos, LLONG_MAX);
>> +		if (ret < 0)
>> +			goto out;
>> +	}
>>
>>
>
> Not much point in writing back blocks we're just going to truncate away
> anyhow. Maybe this should be writing with this range?
>
>      orig_pos, orig_pos + CEPH_FSCRYPT_BLOCK_SIZE - 1

We need to make sure the last block is not buffered in pagecache, 
because we will aways sync read that from Rados.

Yeah, this looks much better.

I will fix and test it again.

Thanks


>>   
>>   	page = __page_cache_alloc(GFP_KERNEL);
>>   	if (page == NULL) {


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3004C9DAF
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Mar 2022 07:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239679AbiCBGSz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Mar 2022 01:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236520AbiCBGSx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Mar 2022 01:18:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4FC350076
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 22:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646201887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/mBUph4Mlme2juFe/bzfZQIjOmO0r20tk6393bgsgwI=;
        b=Ah/6QgQHQlYplFEMTUXrKTymNxv7R3GXwQ6cIfBpDZK1hwuQimnZEKUxEVDYDlJr76F4Vu
        uFbOItsXGodeEuXyy8n3vgmKIrV0hkIcteIhn4f9CE2Hlyz9ZYulBRaL9+vLyzbuk+Fp6u
        joLBYSTES0uMa3M7q1wIKoTMazbo1QM=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-QozWncGxN1qtcxFkC81e_g-1; Wed, 02 Mar 2022 01:18:05 -0500
X-MC-Unique: QozWncGxN1qtcxFkC81e_g-1
Received: by mail-pj1-f72.google.com with SMTP id b9-20020a17090aa58900b001b8b14b4aabso660498pjq.9
        for <ceph-devel@vger.kernel.org>; Tue, 01 Mar 2022 22:18:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/mBUph4Mlme2juFe/bzfZQIjOmO0r20tk6393bgsgwI=;
        b=VkZHH8Yk2SbCkijIfs2NvwvJWu5kcU9d/MAihG3+7tMqoRXOFMm8AZFFxeFeRo675n
         xvFTIIkI8LnHQAUTFtTDd6wV52rDUXuYkuds8rKVmonRFp475JUoz8CCtwV9qRqj8RfI
         heNVBiqvyNB79yFO52qESVV3K6VIjc2BrmgQbDlMdE2bMau/yA89zWtoduhQTtD78Znl
         2aO0mpSwC2fy7V/CMlK2vMucrWqpxbf1BGcUJMWnwJtdLpyBnCpdQHdCwPTuZbB4aGrZ
         ZyN9YgIG1vCPAKHSLo2jNVtmvhDZsV3ZjS5FvK+aKN2D0THrlxOiM6rcx1pSEuzcAVhV
         W9Lg==
X-Gm-Message-State: AOAM5334R8g++BCyQ5ozmUxpWfdmuRKdiIZUtwc4PZWTcr6mc16aiOiX
        g8n0Lm/2AoqOCjNdgiGoC9x5XMzG/+8++AsXAJTp8Y8Icz3hCtAyzbgK7UOLhCFu169v8Vx5pqM
        LWOs8yhJ8cHPwxQXQ0LmOiUQ2eM6YH1Z8JE0sY8jg35aUwzm2X1okvCD8cxjh23v97bExoVQ=
X-Received: by 2002:a63:514e:0:b0:342:7457:69a4 with SMTP id r14-20020a63514e000000b00342745769a4mr6101178pgl.410.1646201883309;
        Tue, 01 Mar 2022 22:18:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJziBhAfZdnSqpZen6qxv5hokc87lUXCbCC77wJtRJK1zQyJlTUtpgVQTdiX1E8+FeRqn9OckA==
X-Received: by 2002:a63:514e:0:b0:342:7457:69a4 with SMTP id r14-20020a63514e000000b00342745769a4mr6101163pgl.410.1646201882933;
        Tue, 01 Mar 2022 22:18:02 -0800 (PST)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q2-20020a056a00084200b004f0fea7d3c8sm19869971pfk.26.2022.03.01.22.17.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 22:18:02 -0800 (PST)
Subject: Re: [PATCH v3] ceph: skip the memories when received a higher version
 of message
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220301143927.513492-1-xiubli@redhat.com>
 <5c32c1228db8bd8916665e02c0bf70d70ba89e4e.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <116ea64c-5cbe-d080-bb8a-6885f6080e5e@redhat.com>
Date:   Wed, 2 Mar 2022 14:17:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5c32c1228db8bd8916665e02c0bf70d70ba89e4e.camel@kernel.org>
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


On 3/1/22 10:43 PM, Jeff Layton wrote:
> On Tue, 2022-03-01 at 22:39 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> We should skip the extra memories which are from the higher version
>> just likes the libcephfs client does.
>>
>> URL: https://tracker.ceph.com/issues/54430
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 94b4c6508044..608d077f2eeb 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -313,6 +313,7 @@ static int parse_reply_info_lease(void **p, void *end,
>>   {
>>   	u8 struct_v;
>>   	u32 struct_len;
>> +	void *lend;
>>   
>>   	if (features == (u64)-1) {
>>   		u8 struct_compat;
>> @@ -332,6 +333,7 @@ static int parse_reply_info_lease(void **p, void *end,
>>   		*altname = NULL;
>>   	}
>>   
>> +	lend = *p + struct_len;
>>   	ceph_decode_need(p, end, struct_len, bad);
>>   	*lease = *p;
>>   	*p += sizeof(**lease);
>> @@ -347,6 +349,7 @@ static int parse_reply_info_lease(void **p, void *end,
>>   			*altname_len = 0;
>>   		}
>>   	}
>> +	*p = lend;
>>   	return 0;
>>   bad:
>>   	return -EIO;
> Feel free to fold this into the appropriate patch in wip-fscrypt if you
> like...
>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>

Hi Jeff,

Done and I also have rebased wip-fscrypt branch to the testing branch. 
Since I need some patches from testing branch to continue my another 
snapshot related patch series.

- Xiubo


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5053A4C8E1C
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Mar 2022 15:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235267AbiCAOqJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Mar 2022 09:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235290AbiCAOqD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Mar 2022 09:46:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE45A37A27
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 06:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646145919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a+UQuMKt3eo9XaMDKw8yfdOOdPKwiEO4QPqaMFjqAco=;
        b=C5ZnG800WoI3yBCc7WbvAPpgl8K6TAJH2fw+AchoRA5I6mx+uwxW0uNi6Tfx1kAGhT3vhT
        1mnSoFMZJRDJ3N/Ns/HIIh7Ep+5wx2K2HPbnY4rLFRjGGR11Z41dEGXCKr/Urjex/WSK3q
        lJPZ7TokNgU9Tf4YZSDoygS5rvfi1uk=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-KKyhdMvzM6SLOZRNu-g9zg-1; Tue, 01 Mar 2022 09:45:18 -0500
X-MC-Unique: KKyhdMvzM6SLOZRNu-g9zg-1
Received: by mail-pj1-f72.google.com with SMTP id t10-20020a17090a5d8a00b001bed9556134so1531139pji.5
        for <ceph-devel@vger.kernel.org>; Tue, 01 Mar 2022 06:45:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=a+UQuMKt3eo9XaMDKw8yfdOOdPKwiEO4QPqaMFjqAco=;
        b=zIELKkn1slhp1AFq8uFxloEzQONI3PP0rIAFo0g+q9/8E4UskVJTgHLGXctHR0ctrq
         cozfcVC4z571VkKImIkCJ1rksF5jH9GRVwrfsIfr+mVhYWvIN4KoNLUcKXHOIcy05/VA
         xVWCel8OmYl8oMvH9N3cj6CbbACNTwNAWbkLF/asgB3pji5vcPZj10Y7prdHaaigCTLX
         K+NAMeExb4rNo4VDemJEBbWrDqgfsvScmWAKMqtgzqjEB+TKZRGmHhra+7jLiGPFMj2R
         EjUfu72wPXLSaYbdFPIEFII5y+3OR0K8WsqOFp84YXoc0+ShAKLg3cFb2O+XDnsV2P8T
         RzLA==
X-Gm-Message-State: AOAM530S2jgkCbpDbWxx3+eokhPloB/BYxwHwC2BG8M8W08rzzPVcoWI
        84hRW8o4AZOf2/ZUw25d1uERIoMB0ZEsIteYyMBU9rq6cMsjRCLZ6JJrLJ2+KousYTQxe9nOr/Y
        EJDUH7HKKznrGm598Wxw8n8QEtCURvgSXFDN9X1nFYxQ7hvRtqC+HJ4Or1Tu5gTG1TsUHQUs=
X-Received: by 2002:a17:902:e302:b0:14f:d360:afe3 with SMTP id q2-20020a170902e30200b0014fd360afe3mr26138796plc.171.1646145917039;
        Tue, 01 Mar 2022 06:45:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyPeaEUaKCOdX9Cael1amPjIk614TmiVsfIqvdCVlSsYnyXIyAHvwkF/EZc951s9tUjTg3rFg==
X-Received: by 2002:a17:902:e302:b0:14f:d360:afe3 with SMTP id q2-20020a170902e30200b0014fd360afe3mr26138761plc.171.1646145916666;
        Tue, 01 Mar 2022 06:45:16 -0800 (PST)
Received: from [10.72.12.87] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c34-20020a630d22000000b0034cb89e4695sm13591961pgl.28.2022.03.01.06.45.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 06:45:16 -0800 (PST)
Subject: Re: [PATCH v3] ceph: skip the memories when received a higher version
 of message
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220301143927.513492-1-xiubli@redhat.com>
 <5c32c1228db8bd8916665e02c0bf70d70ba89e4e.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <afe903ae-9d94-4005-e376-6612ba07e6a7@redhat.com>
Date:   Tue, 1 Mar 2022 22:45:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5c32c1228db8bd8916665e02c0bf70d70ba89e4e.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
>
Sure.


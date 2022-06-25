Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB28F55A5AD
	for <lists+ceph-devel@lfdr.de>; Sat, 25 Jun 2022 03:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiFYA7H (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 Jun 2022 20:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiFYA7G (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 24 Jun 2022 20:59:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1ED575DC28
        for <ceph-devel@vger.kernel.org>; Fri, 24 Jun 2022 17:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656118745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pstp9T6OHsanhnGs41hO5y8xSOZjhfTfl2yr7npWZDc=;
        b=Goxwh4FTFgNSBAtBh9yJnGXR5itm0qKtnDCbL4hOHRNwOd0e9fWFBGEnGuxBN59uWxgvvR
        ahClSqkxotIWeLeSkmQZGGbb8970Z5gR0HfZDEXTJQC7Jqs7RFgfta0t8phc1YhJeuQaVU
        86mNZSv5nxdB/M0VgZDcudBcD/gli1o=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-KvUvAsZzNFy9x7p1CBquKg-1; Fri, 24 Jun 2022 20:59:04 -0400
X-MC-Unique: KvUvAsZzNFy9x7p1CBquKg-1
Received: by mail-pl1-f200.google.com with SMTP id k11-20020a170902ce0b00b0016a15fe2627so2039413plg.22
        for <ceph-devel@vger.kernel.org>; Fri, 24 Jun 2022 17:59:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=pstp9T6OHsanhnGs41hO5y8xSOZjhfTfl2yr7npWZDc=;
        b=sWlWY4tlfN/uyAe5TmLtyT1vBr+YQifWVItyqdQIE/Uaic8mKW4yWnPQfzYVvrv8tI
         PWTeMkqH1t+uyRINtmmrp3i+twrum5pskxSQU+O2wQfdJkrMevX7Y5iGAg38e//u9llE
         h+1MzX3aW9qtDNIrKPiDnDV+lUcznPYWbejUmZptcP+rpx369SMFTkUcCAQ/zzf4HhAp
         KT0ykfiPYTZ1MeDCudiThJla+meWc5OaX+Jw+PLp3oylCenCBSav+PoxPsXEBo/7McwD
         wDxCwoaz9LtFhf6NO+UjfoqyU8uZEYABO5Cm8+mkkJv2l6958RILigwM7hetfgHHN9XJ
         /Lbg==
X-Gm-Message-State: AJIora9bu2vt/c/hv/eNXFXfYG6OMCBgRgcrmkzZpFf30LREZD1kGF7y
        ksWCi1YNb39OBZ9mdIRseuhIOAxYqDycNaqt7rDTEftecnf+eMClt32LQLl2x9taEqrOQMculmI
        fQKTjspRfYUtKThiyHzUK5tFvjS2qMcfHTysyAvlffNW5vgnKBfoR/bJzO1QMmDWiOn5wacw=
X-Received: by 2002:a63:f952:0:b0:40d:7553:1717 with SMTP id q18-20020a63f952000000b0040d75531717mr1403689pgk.395.1656118742560;
        Fri, 24 Jun 2022 17:59:02 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u2/FjB9LYYo79iLyWDcxRC23UH+dOPDhV6I60izxyUCJyPBa9vKt9zYB0IwjpkCA0HNxovXg==
X-Received: by 2002:a63:f952:0:b0:40d:7553:1717 with SMTP id q18-20020a63f952000000b0040d75531717mr1403660pgk.395.1656118742051;
        Fri, 24 Jun 2022 17:59:02 -0700 (PDT)
Received: from [10.72.12.43] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s21-20020a056a00179500b0051c4ecb0e3dsm2365583pfg.193.2022.06.24.17.58.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 17:59:01 -0700 (PDT)
Subject: Re: [PATCH 2/2] ceph: switch to 4KB block size if quota size is not
 aligned to 4MB
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20220624093730.8564-1-xiubli@redhat.com>
 <20220624093730.8564-3-xiubli@redhat.com> <87k096jezd.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c21d145f-39ed-e028-68a7-73e7d9346f1b@redhat.com>
Date:   Sat, 25 Jun 2022 08:58:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87k096jezd.fsf@brahms.olymp>
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


On 6/24/22 10:47 PM, Luís Henriques wrote:
> xiubli@redhat.com writes:
>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> If the quota size is larger than but not aligned to 4MB, the statfs
>> will always set the block size to 4MB and round down the fragment
>> size. For exmaple if the quota size is 6MB, the `df` will always
>> show 4MB capacity.
>>
>> Make the block size to 4KB as default if quota size is set unless
>> the quota size is larger than or equals to 4MB and at the same time
>> it aligns to 4MB.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/quota.c | 31 ++++++++++++++++++++-----------
>>   1 file changed, 20 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
>> index 64592adfe48f..c50527151913 100644
>> --- a/fs/ceph/quota.c
>> +++ b/fs/ceph/quota.c
>> @@ -483,6 +483,7 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
>>   	struct inode *in;
>>   	u64 total = 0, used, free;
>>   	bool is_updated = false;
>> +	u32 block_shift = CEPH_4K_BLOCK_SHIFT;
>>   
>>   	down_read(&mdsc->snap_rwsem);
>>   	realm = get_quota_realm(mdsc, d_inode(fsc->sb->s_root),
>> @@ -498,21 +499,29 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
>>   		ci = ceph_inode(in);
>>   		spin_lock(&ci->i_ceph_lock);
>>   		if (ci->i_max_bytes) {
>> -			total = ci->i_max_bytes >> CEPH_BLOCK_SHIFT;
>> -			used = ci->i_rbytes >> CEPH_BLOCK_SHIFT;
>> -			/* For quota size less than 4MB, use 4KB block size */
>> -			if (!total) {
>> -				total = ci->i_max_bytes >> CEPH_4K_BLOCK_SHIFT;
>> -				used = ci->i_rbytes >> CEPH_4K_BLOCK_SHIFT;
>> -	                        buf->f_frsize = 1 << CEPH_4K_BLOCK_SHIFT;
>> -			}
>> -			/* It is possible for a quota to be exceeded.
>> +			/*
>> +			 * Switch to 4MB block size if quota size is
>> +			 * larger than or equals to 4MB and at the
>> +			 * same time is aligned to 4MB.
>> +			 */
>> +			if (ci->i_max_bytes >= (1 << CEPH_BLOCK_SHIFT) &&
>> +			    !(ci->i_max_bytes % (1 << CEPH_BLOCK_SHIFT)))
> Maybe worth replacing this 2nd condition with the IS_ALIGNED() macro.
> Other than this, these patches look good.

Sure, will fix it.

> I do have question though: is it possible that this will behaviour may
> break some user-space programs that expect more deterministic values for
> these fields (buf->f_frsize and buf->f_bsize)?  Because the same
> filesystem will report different values depending on which dir you mount.

Yeah, I was also thinking about this, but haven't found which use case 
could be broke yet.

> Obviously, this isn't a problem with this particular patch, as this
> behaviour is already present.

Till now this works well and no test case complains it.

-- Xiubo

> Cheers,


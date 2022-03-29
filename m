Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A664EABFE
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Mar 2022 13:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235585AbiC2LOw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Mar 2022 07:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbiC2LOu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Mar 2022 07:14:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A93035DF0
        for <ceph-devel@vger.kernel.org>; Tue, 29 Mar 2022 04:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648552386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u3qXaB7IFLEN2+D2vtJDjg2aiIspQYWZIf/m0ShqwnE=;
        b=ZQWks85tEV1LqT/Y/lu2oBpCF4+UF3rk8woiN+T5B2a7Oz+WP55ORuoGf7RLR0upI9YPTQ
        savzxN7W+zhc1/kxbxbLFX1dkr9edPVBUvF7RXyvw7IVPvKv1CZXxTqWufNeOZee0jmrzV
        DFZaNK2pGFFWBtfmMXnv3ja1dWpECX4=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-ZJAxGorhODuNtTYqV58MDA-1; Tue, 29 Mar 2022 07:13:05 -0400
X-MC-Unique: ZJAxGorhODuNtTYqV58MDA-1
Received: by mail-pj1-f72.google.com with SMTP id om8-20020a17090b3a8800b001c68e7ccd5fso1302181pjb.9
        for <ceph-devel@vger.kernel.org>; Tue, 29 Mar 2022 04:13:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=u3qXaB7IFLEN2+D2vtJDjg2aiIspQYWZIf/m0ShqwnE=;
        b=moqLFwg/67rqlZc1Ls5fipmqxMyr60wpf5nJ+wO4fxhesTdnO/MUBruh70xKjWW3m3
         rCeAMWmRNt2i771bUczKOW8uq4h7Lb8uW7fZJDggC31ydpBGdKSilMJyiJucp5LKp8Qu
         PRMM/Z1KIKJ7GOtXmrBxqL1woW4ad7J3msX3eZPGCo2kn1LbFm19u8uj0v1l2Xe8SH72
         h2isUpdZUp99sZxj1CiZx1rCgMlroL7nTRsmAQB/HRC15+HlAw4ugChWPbHSOh6bsxWw
         4Pyowx8KEuy/DI+D3H1Mg4AOvkdbZpUURop/Rwpe5Xi4kTuxGFbH5tV3zKHY63dAqMDZ
         AyGQ==
X-Gm-Message-State: AOAM530GzzqhD8n7xT0BPHYAPokAgXBFu+0XkZr6g6IhbBunzM6pPIvj
        ggni7O9njt7V0O6gv/meUTQYi5OJGiEDCutu3kmCulQOxOsSxXufnE7YNoiG/eJTrX5InWZrW7m
        BDMar+wvPHg8BxAAoOEtCkK1xvbbVft3r9NPxKsTxoiOAOPvuwvn7/lfkTWwrHskktaeZChk=
X-Received: by 2002:a17:902:d4c1:b0:153:d493:3f1 with SMTP id o1-20020a170902d4c100b00153d49303f1mr30125695plg.102.1648552383942;
        Tue, 29 Mar 2022 04:13:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFOXICZ4RkXaon/JFCDSsezkpNzkKV3uitUT1DOq33tDeuK83JWUz6m57o7pKjcEFfhqk/9Q==
X-Received: by 2002:a17:902:d4c1:b0:153:d493:3f1 with SMTP id o1-20020a170902d4c100b00153d49303f1mr30125663plg.102.1648552383551;
        Tue, 29 Mar 2022 04:13:03 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j22-20020a637a56000000b003984be1f515sm5732051pgn.69.2022.03.29.04.13.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 04:13:02 -0700 (PDT)
Subject: Re: [PATCH] ceph: stop forwarding the request when exceeding 256
 times
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        gfarnum@redhat.com, ceph-devel@vger.kernel.org
References: <20220329080608.14667-1-xiubli@redhat.com>
 <87fsn1qe39.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <a568c0c0-6620-e369-2e14-b6d06a9f4340@redhat.com>
Date:   Tue, 29 Mar 2022 19:12:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87fsn1qe39.fsf@brahms.olymp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/29/22 5:53 PM, Luís Henriques wrote:
> xiubli@redhat.com writes:
>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The type of 'num_fwd' in ceph 'MClientRequestForward' is 'int32_t',
>> while in 'ceph_mds_request_head' the type is '__u8'. So in case
>> the request bounces between MDSes exceeding 256 times, the client
>> will get stuck.
>>
>> In this case it's ususally a bug in MDS and continue bouncing the
>> request makes no sense.
> Ouch.  Nice catch.  This patch looks OK to me, just 2 minor comments
> bellow.
>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 31 ++++++++++++++++++++++++++++---
>>   1 file changed, 28 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index a89ee866ebbb..0bb6e7bc499c 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -3293,6 +3293,7 @@ static void handle_forward(struct ceph_mds_client *mdsc,
>>   	int err = -EINVAL;
>>   	void *p = msg->front.iov_base;
>>   	void *end = p + msg->front.iov_len;
>> +	bool aborted = false;
>>   
>>   	ceph_decode_need(&p, end, 2*sizeof(u32), bad);
>>   	next_mds = ceph_decode_32(&p);
>> @@ -3309,8 +3310,28 @@ static void handle_forward(struct ceph_mds_client *mdsc,
>>   		dout("forward tid %llu aborted, unregistering\n", tid);
>>   		__unregister_request(mdsc, req);
>>   	} else if (fwd_seq <= req->r_num_fwd) {
>> -		dout("forward tid %llu to mds%d - old seq %d <= %d\n",
>> -		     tid, next_mds, req->r_num_fwd, fwd_seq);
>> +		/*
>> +		 * The type of 'num_fwd' in ceph 'MClientRequestForward'
>> +		 * is 'int32_t', while in 'ceph_mds_request_head' the
>> +		 * type is '__u8'. So in case the request bounces between
>> +		 * MDSes exceeding 256 times, the client will get stuck.
>> +		 *
>> +		 * In this case it's ususally a bug in MDS and continue
>> +		 * bouncing the request makes no sense.
>> +		 */
>> +		if (req->r_num_fwd == 256) {
>> +			mutex_lock(&req->r_fill_mutex);
>> +			req->r_err = -EIO;
> Not sure -EIO is the most appropriate.  Maybe -E2BIG... although not quite
> it either.
>
Yeah, I also not very sure here.

Jeff ?


>> +			set_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags);
>> +			mutex_unlock(&req->r_fill_mutex);
>> +			aborted = true;
>> +			dout("forward tid %llu to mds%d - seq overflowed %d <= %d\n",
>> +			     tid, next_mds, req->r_num_fwd, fwd_seq);
>> +			goto out;
> This 'goto' statement can be dropped, but one before (when the
> lookup_get_request() fails) needs to be adjusted, otherwise
> ceph_mdsc_put_request() may be called with a NULL pointer.

Yeah, will fix it.

Thanks.

-- Xiubo


> Cheers,


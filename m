Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05EFB4EB743
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Mar 2022 01:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238531AbiC2X7x (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Mar 2022 19:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235624AbiC2X7w (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Mar 2022 19:59:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A646B879
        for <ceph-devel@vger.kernel.org>; Tue, 29 Mar 2022 16:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648598287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0lHuWLR0A0axcW9vAThToZhWlrn6GkjFD4BkIf+hz/U=;
        b=KrgcukY+ZgeonI8FDAxQWu4jP5qnw94crP1Ht56vtFscVeGTDlPodlKKb5ziI4i13ig129
        uIgzoadPlL+RR5kF1hS+lq9YWO9er+yUPBHQOTwF1v72fJVbFNQu1qSNIfgYQkJCn6bHal
        yraZw0PEty2ljYVNsX8ABPiYksJyNZ4=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-DbmjiOz2OUOgGAtXtHNJiQ-1; Tue, 29 Mar 2022 19:58:06 -0400
X-MC-Unique: DbmjiOz2OUOgGAtXtHNJiQ-1
Received: by mail-pg1-f200.google.com with SMTP id s188-20020a6377c5000000b003825c503580so9303167pgc.13
        for <ceph-devel@vger.kernel.org>; Tue, 29 Mar 2022 16:58:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=0lHuWLR0A0axcW9vAThToZhWlrn6GkjFD4BkIf+hz/U=;
        b=YWz//roJSZx7leRON54daUZ7rc/UprSRvxST91KmNztCZLbljJTWaaUSoeyCpyItQu
         AdFshsURW++7UvIwQU4JOtTVnV9jnc6b0FDiCYLNPWfTFE44okiXjFGcaptNLgUzFTTe
         1IdZ2b5EFjts3PRsEIgXSP32ZEHkWmwIWZrBEXGU6QVUArOc8Ggk/iL6BbujzC0z1qH2
         4xysAJ+CbtBqYw6r4XeP+DLZvHBe7UtgT9x9m/HQY2QBTuSd70ZcHc2si6fDwJ0Oqlti
         zP+hgKXvpvWo+T8vt/+JATf8sCsEGHrUvsI0u1KCOIlzmQ/y6+bdACyMcJQB3SV9hOl3
         iYHg==
X-Gm-Message-State: AOAM531rU2MsohkdbfzOrywe6cnbyTtfmgB/RAxe6OEuu+GEe42W8wKo
        hL0bb55Du+IEHE3qyqMWM52o/nDfMu1VEMKvKy6S8s0RgqIYTQHFgh3TNV66xJ37iolITxj/7aa
        7l/Z7zZ5lN4VIR2mJNjGylocMMcC0t9RGDSShnntoYpmYuP5ynl+63dlxIuxpyZHIb/JJCAU=
X-Received: by 2002:a17:902:ec89:b0:153:f480:5089 with SMTP id x9-20020a170902ec8900b00153f4805089mr31989326plg.166.1648598284697;
        Tue, 29 Mar 2022 16:58:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0LAjEADJpiZLK9fodhgr82lz1h1SUUntDyZk0y3aXB2pFvQx2UvRHr7qx29EbC66O7DiDGA==
X-Received: by 2002:a17:902:ec89:b0:153:f480:5089 with SMTP id x9-20020a170902ec8900b00153f4805089mr31989298plg.166.1648598284298;
        Tue, 29 Mar 2022 16:58:04 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d10-20020a056a0024ca00b004fd90388a86sm2739066pfv.173.2022.03.29.16.58.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 16:58:03 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: stop forwarding the request when exceeding 256
 times
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, gfarnum@redhat.com,
        lhenriques@suse.de, ceph-devel@vger.kernel.org
References: <20220329122003.77740-1-xiubli@redhat.com>
 <e3fdf3bcf7ed44d9a0b3f84351f2b72826db15bf.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <5b592840-bb60-9c28-dc40-5ae903b4572a@redhat.com>
Date:   Wed, 30 Mar 2022 07:57:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <e3fdf3bcf7ed44d9a0b3f84351f2b72826db15bf.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/29/22 10:48 PM, Jeff Layton wrote:
> On Tue, 2022-03-29 at 20:20 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The type of 'num_fwd' in ceph 'MClientRequestForward' is 'int32_t',
>> while in 'ceph_mds_request_head' the type is '__u8'. So in case
>> the request bounces between MDSes exceeding 256 times, the client
>> will get stuck.
>>
>> In this case it's ususally a bug in MDS and continue bouncing the
>> request makes no sense.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V2:
>> - s/EIO/EMULTIHOP/
>> - Fixed dereferencing NULL seq bug
>> - Removed the out lable
>>
>>
>>   fs/ceph/mds_client.c | 34 +++++++++++++++++++++++++++++-----
>>   1 file changed, 29 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index a89ee866ebbb..82c1f783feba 100644
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
>> @@ -3301,16 +3302,36 @@ static void handle_forward(struct ceph_mds_client *mdsc,
>>   	mutex_lock(&mdsc->mutex);
>>   	req = lookup_get_request(mdsc, tid);
>>   	if (!req) {
>> +		mutex_unlock(&mdsc->mutex);
>>   		dout("forward tid %llu to mds%d - req dne\n", tid, next_mds);
>> -		goto out;  /* dup reply? */
>> +		return;  /* dup reply? */
>>   	}
>>   
>>   	if (test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags)) {
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
> Can you also fix this to be expressed as "> UCHAR_MAX"? Or preferably,
> if you have a way to get to the ceph_mds_request_head from here, then
> express it in terms of sizeof() the field that limits this.

Sure, let me try the second one first.

-- Xiubo

>> +			mutex_lock(&req->r_fill_mutex);
>> +			req->r_err = -EMULTIHOP;
>> +			set_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags);
>> +			mutex_unlock(&req->r_fill_mutex);
>> +			aborted = true;
>> +			pr_warn_ratelimited("forward tid %llu seq overflow\n",
>> +					    tid);
>> +		} else {
>> +			dout("forward tid %llu to mds%d - old seq %d <= %d\n",
>> +			     tid, next_mds, req->r_num_fwd, fwd_seq);
>> +		}
>>   	} else {
>>   		/* resend. forward race not possible; mds would drop */
>>   		dout("forward tid %llu to mds%d (we resend)\n", tid, next_mds);
>> @@ -3322,9 +3343,12 @@ static void handle_forward(struct ceph_mds_client *mdsc,
>>   		put_request_session(req);
>>   		__do_request(mdsc, req);
>>   	}
>> -	ceph_mdsc_put_request(req);
>> -out:
>>   	mutex_unlock(&mdsc->mutex);
>> +
>> +	/* kick calling process */
>> +	if (aborted)
>> +		complete_request(mdsc, req);
>> +	ceph_mdsc_put_request(req);
>>   	return;
>>   
>>   bad:
> The code looks fine otherwise though...


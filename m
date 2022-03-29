Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3D74EAD11
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Mar 2022 14:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbiC2MZ4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Mar 2022 08:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236131AbiC2MZ4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Mar 2022 08:25:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 317F74AE0B
        for <ceph-devel@vger.kernel.org>; Tue, 29 Mar 2022 05:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648556652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GkzgM+OHrHFwjK7gkHLITtaTb7x27Zk/9zqk2v9DuxY=;
        b=JUYuci39SJiUJsFdmdZxDLfrvR9s6lxv5z/jMiRJx8v3I0FDeGUQI0Xw7n3L2nQMdqyrVP
        GLIaXqBGClvdxepKc6DuzQf1fVOY5rDHT2KXVbJiDrAA2C09GnD53+eviRqP4TaCReOVmW
        80eZ3g1YH342w3sbAoCHP9VaX/zn7y8=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-_WoN7S7WOM6S_66sTz847A-1; Tue, 29 Mar 2022 08:24:10 -0400
X-MC-Unique: _WoN7S7WOM6S_66sTz847A-1
Received: by mail-pj1-f70.google.com with SMTP id ob7-20020a17090b390700b001c692ec6de4so1394393pjb.7
        for <ceph-devel@vger.kernel.org>; Tue, 29 Mar 2022 05:24:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=GkzgM+OHrHFwjK7gkHLITtaTb7x27Zk/9zqk2v9DuxY=;
        b=SRubdcklOXhF8gXnZdBmeG0Ft1ykyOykdQM0WKnkq02y0RUZSxrHdfKnlCqU8SAejC
         DomG4TaF9/H08A/8ja16H8DMVXxABbynuUDfmZ/GoZohxOiV0sP37d+nWtGfv0mEU5UO
         pWvX8qS0GCynqO7celx5t9s7Czozd0lFeBUruNZWouNGLNTYGEaO9AATagsquFXX3522
         0LtAlp8Qh38Ch87yqnu1KpbAwH7l60zD8qZwHVe4dTvRaBNKORJhq4mlu8EZiTQaKB7q
         Yc3mVmwMm5ZIxCsp67rFWNksiI9xLQSh3vtD3AItNgeZ6+4nHEPI6OQJjwNg9y3TDCT9
         Axyg==
X-Gm-Message-State: AOAM533/WqQiSxanYI2YxfOXPRmKnT3ugLWO/6atqNgL2HZ9wsZ2IOEU
        kaHT+ovNXgr9q2TNS82ijsdS75/jiULIEMCGg2riT73rr+nT5gJs6mfkOO6zFlFnZB2QoxF3DaX
        Z5J4taZQgvT/lT/fC97O/Oix3fiQflRiIzpqT2jTdl1cYY3GbpdrNBMlQt3O3gGI1+nBTDnc=
X-Received: by 2002:a17:902:b694:b0:153:1d9a:11a5 with SMTP id c20-20020a170902b69400b001531d9a11a5mr30135927pls.151.1648556648967;
        Tue, 29 Mar 2022 05:24:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9Jh6U0ZFhbMhrDeYI9NeQy52BHcEiu3dcf3zlh8cNEckwssXVplXyBqmvGYfs3ArqL9YE2A==
X-Received: by 2002:a17:902:b694:b0:153:1d9a:11a5 with SMTP id c20-20020a170902b69400b001531d9a11a5mr30135895pls.151.1648556648500;
        Tue, 29 Mar 2022 05:24:08 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k14-20020aa7820e000000b004f7134a70cdsm19025419pfi.61.2022.03.29.05.24.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 05:24:07 -0700 (PDT)
Subject: Re: [PATCH] ceph: stop forwarding the request when exceeding 256
 times
To:     Jeff Layton <jlayton@kernel.org>,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     idryomov@gmail.com, vshankar@redhat.com, gfarnum@redhat.com,
        ceph-devel@vger.kernel.org
References: <20220329080608.14667-1-xiubli@redhat.com>
 <87fsn1qe39.fsf@brahms.olymp>
 <a568c0c0-6620-e369-2e14-b6d06a9f4340@redhat.com>
 <6e83064bc5dc81721a2058bda95ae0f12584b2bf.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <9f994421-0962-d39f-f232-c896d6b99143@redhat.com>
Date:   Tue, 29 Mar 2022 20:24:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <6e83064bc5dc81721a2058bda95ae0f12584b2bf.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
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


On 3/29/22 7:28 PM, Jeff Layton wrote:
> On Tue, 2022-03-29 at 19:12 +0800, Xiubo Li wrote:
>> On 3/29/22 5:53 PM, Luís Henriques wrote:
>>> xiubli@redhat.com writes:
>>>
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> The type of 'num_fwd' in ceph 'MClientRequestForward' is 'int32_t',
>>>> while in 'ceph_mds_request_head' the type is '__u8'. So in case
>>>> the request bounces between MDSes exceeding 256 times, the client
>>>> will get stuck.
>>>>
>>>> In this case it's ususally a bug in MDS and continue bouncing the
>>>> request makes no sense.
>>> Ouch.  Nice catch.  This patch looks OK to me, just 2 minor comments
>>> bellow.
>>>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/mds_client.c | 31 ++++++++++++++++++++++++++++---
>>>>    1 file changed, 28 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>> index a89ee866ebbb..0bb6e7bc499c 100644
>>>> --- a/fs/ceph/mds_client.c
>>>> +++ b/fs/ceph/mds_client.c
>>>> @@ -3293,6 +3293,7 @@ static void handle_forward(struct ceph_mds_client *mdsc,
>>>>    	int err = -EINVAL;
>>>>    	void *p = msg->front.iov_base;
>>>>    	void *end = p + msg->front.iov_len;
>>>> +	bool aborted = false;
>>>>    
>>>>    	ceph_decode_need(&p, end, 2*sizeof(u32), bad);
>>>>    	next_mds = ceph_decode_32(&p);
>>>> @@ -3309,8 +3310,28 @@ static void handle_forward(struct ceph_mds_client *mdsc,
>>>>    		dout("forward tid %llu aborted, unregistering\n", tid);
>>>>    		__unregister_request(mdsc, req);
>>>>    	} else if (fwd_seq <= req->r_num_fwd) {
>>>> -		dout("forward tid %llu to mds%d - old seq %d <= %d\n",
>>>> -		     tid, next_mds, req->r_num_fwd, fwd_seq);
>>>> +		/*
>>>> +		 * The type of 'num_fwd' in ceph 'MClientRequestForward'
>>>> +		 * is 'int32_t', while in 'ceph_mds_request_head' the
>>>> +		 * type is '__u8'. So in case the request bounces between
>>>> +		 * MDSes exceeding 256 times, the client will get stuck.
>>>> +		 *
>>>> +		 * In this case it's ususally a bug in MDS and continue
>>>> +		 * bouncing the request makes no sense.
>>>> +		 */
>>>> +		if (req->r_num_fwd == 256) {
>>>> +			mutex_lock(&req->r_fill_mutex);
>>>> +			req->r_err = -EIO;
>>> Not sure -EIO is the most appropriate.  Maybe -E2BIG... although not quite
>>> it either.
>>>
>> Yeah, I also not very sure here.
>>
>> Jeff ?
>>
> Matching errors like this really comes down to a judgement call.  E2BIG
> usually means that some buffer was sized too small, so you'll have users
> trying to figure out what they passed in wrong if you return that here.
>
> -EIO is the usual "default" when you don't know what else to use.
> There's also -EREMOTEIO which may be closer here since this is
> indicative of MDS problems. Given that, it may also be a good idea to
> log a pr_warn or pr_notice message at the same time explaining what
> happened.

As discussed in IRC, have switched to EMULTIHOP instead.

Thanks Jeff.

-- Xiubo

>
>>>> +			set_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags);
>>>> +			mutex_unlock(&req->r_fill_mutex);
>>>> +			aborted = true;
>>>> +			dout("forward tid %llu to mds%d - seq overflowed %d <= %d\n",
>>>> +			     tid, next_mds, req->r_num_fwd, fwd_seq);
>>>> +			goto out;
>>> This 'goto' statement can be dropped, but one before (when the
>>> lookup_get_request() fails) needs to be adjusted, otherwise
>>> ceph_mdsc_put_request() may be called with a NULL pointer.
>> Yeah, will fix it.
>>
>> Thanks.
>>
>> -- Xiubo
>>
>>
>>> Cheers,


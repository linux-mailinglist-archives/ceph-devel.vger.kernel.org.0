Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423556F695E
	for <lists+ceph-devel@lfdr.de>; Thu,  4 May 2023 12:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjEDK7C (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 May 2023 06:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjEDK6z (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 May 2023 06:58:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE9CE8
        for <ceph-devel@vger.kernel.org>; Thu,  4 May 2023 03:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683197895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pPSC2+Y4eWIZApfFEddK032qSXpg8Sj71WuAT6JpXkk=;
        b=c82F5PfyJ5ynomSlyi+zGW/K1lA555yhi5qLFarQGZEEKrDq0l08SHCRSQ1a6GyVrELW1O
        GX0rJKJwEGNNKJodz2wOqf4RDkMAH4OsokjsPmvAJvRm/H/U/oTO1T8hbvvYdcoxkc9sMz
        g5gr1TosIerjDnzgkeOvvmjtYPbTTNQ=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-PTN2x_lNN1mNhHqvk7v5tA-1; Thu, 04 May 2023 06:58:14 -0400
X-MC-Unique: PTN2x_lNN1mNhHqvk7v5tA-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-24e43240e9fso169976a91.3
        for <ceph-devel@vger.kernel.org>; Thu, 04 May 2023 03:58:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683197894; x=1685789894;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pPSC2+Y4eWIZApfFEddK032qSXpg8Sj71WuAT6JpXkk=;
        b=ctJ7gOSLyYe2ttd3jSHpjVrVXx3LBLI3Y3vZRifELQUtkfPCOPc4bsJEtYwwltp37c
         6QAj8I1oeqnjpgVEpfFirL7jSxGPVFy+HmoTUqBiD8IwcdQ9uqnWIFQDhQEYQHXvySEU
         wAafha4gf/bw9i5QrwjUYu5NhD7iAIwtV2EkuGCuxVAfvPg7b+R5QYgPS0K6zL22a59C
         C8XDCdqjM0QYwY7Y8iCYOepwXrcX2mEzpE8ExNfHmYGmChd4KdWIYYHkXKGkxLs152c0
         4ZKc8MB/Qp9TKwNSFFdl5rcQSdCav/bXO0MdPnLjhrXKmE9ESA7mjEj3oXeNHObzeUh+
         ziag==
X-Gm-Message-State: AC+VfDyvcSOHFvhA1RZ9zwRv2vDDcv7GbXCXbEsbnjLWsoZhmzF2Ut4c
        vQXw6sfw6vgQInIBX+wQMFigT/k1tjRRxS+BbgpunRPk/2AJqnJn87hkkKboOS0gWZfaWOr8uXr
        wDWyvfU9kY4WiRDSCGe26Buaq+vWFOxlD
X-Received: by 2002:a17:90b:4b86:b0:24e:69e:71f with SMTP id lr6-20020a17090b4b8600b0024e069e071fmr1687725pjb.7.1683197893753;
        Thu, 04 May 2023 03:58:13 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4CWrqExPO2k5ct2nqCdwQDWZiyNx6eKDekaIAc8mLTrmZdcDXgP7/BRuVmotXXEPA25RXpGQ==
X-Received: by 2002:a17:90b:4b86:b0:24e:69e:71f with SMTP id lr6-20020a17090b4b8600b0024e069e071fmr1687703pjb.7.1683197893417;
        Thu, 04 May 2023 03:58:13 -0700 (PDT)
Received: from [10.72.12.151] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s24-20020a17090a441800b00246ea338c96sm2827280pjg.53.2023.05.04.03.58.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 May 2023 03:58:12 -0700 (PDT)
Message-ID: <b0fc2aa7-544a-afab-28c5-85c0642e917d@redhat.com>
Date:   Thu, 4 May 2023 18:58:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2] ceph: fix blindly expanding the readahead windows
Content-Language: en-US
To:     =?UTF-8?B?6IOh546u5paH?= <huww98@outlook.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, lhenriques@suse.de, mchangir@redhat.com
References: <20230504052306.405208-1-xiubli@redhat.com>
 <TYCP286MB20667D76B7353C3E409849AFC06D9@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <TYCP286MB20667D76B7353C3E409849AFC06D9@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/4/23 18:12, 胡玮文 wrote:
> Hi Xiubo,
>
> I just send a patch to solve the same issue[1].  My patch bound the
> request by i_size, which is orthogonal to your changes. To incorporate
> both, I propose the following patch.
>
> Also, since this is a performance regression, I think we should backport
> it to stable versions?
>
> Another comment inline.
>
> Hu Weiwen
>
> [1]: https://lore.kernel.org/ceph-devel/20230504082510.247-1-sehuww@mail.scut.edu.cn/
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 6bb251a4d613..d1d8e2562182 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -187,16 +187,30 @@ static void ceph_netfs_expand_readahead(struct netfs_io_request *rreq)
>   	struct inode *inode = rreq->inode;
>   	struct ceph_inode_info *ci = ceph_inode(inode);
>   	struct ceph_file_layout *lo = &ci->i_layout;
> +	unsigned long max_pages = inode->i_sb->s_bdi->ra_pages;
> +	unsigned long max_len = max_pages << PAGE_SHIFT;
> +	loff_t end = rreq->start + rreq->len, new_end;
>   	u32 blockoff;
>   	u64 blockno;
>
> -	/* Expand the start downward */
> -	blockno = div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
> -	rreq->start = blockno * lo->stripe_unit;
> -	rreq->len += blockoff;
> +	/* Readahead is disabled */
> +	if (!max_pages)
> +		return;
> +
> +	/* Try to expand the length forward by rounding up it to the next block */
> +	new_end = round_up(end, lo->stripe_unit);
> +	/* But do not exceed the file size,
> +	 * unless the original request already exceeds it. */
> +	new_end = min(new_end, rreq->i_size);
> +	if (new_end > end && new_end <= rreq->start + max_len)
> +		rreq->len = new_end - rreq->start;
>
> -	/* Now, round up the length to the next block */
> -	rreq->len = roundup(rreq->len, lo->stripe_unit);
> +	/* Try to expand the start downward */
> +	blockno = div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
> +	if (rreq->len + blockoff <= max_len) {
> +		rreq->start = blockno * lo->stripe_unit;
> +		rreq->len += blockoff;
> +	}
>   }
>
>   static bool ceph_netfs_clamp_length(struct netfs_io_subrequest *subreq)
>
>
> On Thu, May 04, 2023 at 01:23:06PM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Blindly expanding the readahead windows will cause unneccessary
>> pagecache thrashing and also will introdue the network workload.
>> We should disable expanding the windows if the readahead is disabled
>> and also shouldn't expand the windows too much.
>>
>> Expanding forward firstly instead of expanding backward for possible
>> sequential reads.
>>
>> URL: https://www.spinics.net/lists/ceph-users/msg76183.html
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V2:
>> - fix possible cross-block issue pointed out by Ilya.
>>
>>
>>   fs/ceph/addr.c | 24 ++++++++++++++++++------
>>   1 file changed, 18 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index ca4dc6450887..03a326da8fd8 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -188,16 +188,28 @@ static void ceph_netfs_expand_readahead(struct netfs_io_request *rreq)
>>   	struct inode *inode = rreq->inode;
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>>   	struct ceph_file_layout *lo = &ci->i_layout;
>> +	unsigned long max_pages = inode->i_sb->s_bdi->ra_pages;
>> +	unsigned long max_len = max_pages << PAGE_SHIFT;
>> +	unsigned long len;
>>   	u32 blockoff;
>>   	u64 blockno;
>>   
>> -	/* Expand the start downward */
>> -	blockno = div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
>> -	rreq->start = blockno * lo->stripe_unit;
>> -	rreq->len += blockoff;
>> +	/* Readahead is disabled */
>> +	if (!max_pages)
>> +		return;
>> +
>> +	/* Try to expand the length forward by rounding up it to the next block */
>> +	div_u64_rem(rreq->start + rreq->len, lo->stripe_unit, &blockoff);
>> +	len = lo->stripe_unit - blockoff;
> This would expand the request by a whole block, if the original request
> is already aligned (blockoff == 0).

Hi 胡玮文

Good catch.

The above patch looks better and I will revise it.

Thanks

- Xiubo

>> +	if (rreq->len + len <= max_len)
>> +		rreq->len += len;
>>   
>> -	/* Now, round up the length to the next block */
>> -	rreq->len = roundup(rreq->len, lo->stripe_unit);
>> +	/* Try to expand the start downward */
>> +	blockno = div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
>> +	if (rreq->len + blockoff <= max_len) {
>> +		rreq->start = blockno * lo->stripe_unit;
>> +		rreq->len += blockoff;
>> +	}
>>   }
>>   
>>   static bool ceph_netfs_clamp_length(struct netfs_io_subrequest *subreq)
>> -- 
>> 2.40.0
>>


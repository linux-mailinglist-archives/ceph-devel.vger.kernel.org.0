Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C05A721F62
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jun 2023 09:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjFEHTG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Jun 2023 03:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjFEHTE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Jun 2023 03:19:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE1ABD
        for <ceph-devel@vger.kernel.org>; Mon,  5 Jun 2023 00:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685949496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7F656ugRgdTn+ecAEtEyIDUabqlEKXFiaPRs71udAPE=;
        b=J3jgSDVLaYRQquZSrmGx0dyQ/Hb96FNU0fA/RkdrUxaW9E9kcqOYyoFI8Bd6I9ZITSxpFo
        nODFfCzTO9ooudc2Cu+x7zLfLM8DBYUDW0fp8TwwwZIqmjlpfmfVbI0J5ZhhCrVDv3OgQ/
        xkQRB2+js8giFBEaviG8NitisABrJMI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-260-wOJYGPXcNGmtFEZ3_bsPNg-1; Mon, 05 Jun 2023 03:18:15 -0400
X-MC-Unique: wOJYGPXcNGmtFEZ3_bsPNg-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-25667878a53so1451367a91.3
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jun 2023 00:18:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685949494; x=1688541494;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7F656ugRgdTn+ecAEtEyIDUabqlEKXFiaPRs71udAPE=;
        b=VqU28bvPMuhrFsDpmiIu+RNdDW3z81a+BOkY1MEPnRs85vmtAOWUbZuchdOMml7A3A
         k/ImQ7kMq+2DE7sKslyot7fnY29/VHCeD6MYa6qeYgmRwAeVgJCi5OUcfVHsZ9bxvPze
         Qhj4sN3j/TtKp/xBK78xyzJkpWOxCdJsKYO/jU22ZelQ1CTk1ebJvrF/zfij4P+cDThT
         YFznnCOM1Yh3fZdvAMoOA848iO9iJnVwgoToqqQMQWcNve75vgK5NhEAzxsMEK48bCUa
         vL7bvKYe4oTRw0dIfRA/d5iIvYzSROUY7TRhz1sAyPGh7mWMjOPu0xL1E12/uODwJ7/H
         d4WA==
X-Gm-Message-State: AC+VfDy9bacf5s22KdqCMz3WQ6LbLiZRJ6YRs4hvEjlFgQOMMjy+C/lp
        PkFxZ3dQBSAK4xW0Yc72I9vkVvh+ydXr8IGfrd8D0v4nJ/rbVvvEOX2F/fJBro/29UMRq4IIvmk
        HhnS6XrrLoa306CM9miehPQ==
X-Received: by 2002:a17:90a:4bcc:b0:256:2518:fb26 with SMTP id u12-20020a17090a4bcc00b002562518fb26mr3313996pjl.27.1685949494023;
        Mon, 05 Jun 2023 00:18:14 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6SOfti4BCpWK8MDo/yD36CdBBMZOnawtgCVLwM6GL2s7QY3iKk+Z+OwB/G63NuehfLkRuGwQ==
X-Received: by 2002:a17:90a:4bcc:b0:256:2518:fb26 with SMTP id u12-20020a17090a4bcc00b002562518fb26mr3313989pjl.27.1685949493662;
        Mon, 05 Jun 2023 00:18:13 -0700 (PDT)
Received: from [10.72.12.216] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c13-20020a17090a674d00b0024dee5cbe29sm5210364pjm.27.2023.06.05.00.18.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 00:18:13 -0700 (PDT)
Message-ID: <622cae19-a856-ef9f-d272-22e80ce53d56@redhat.com>
Date:   Mon, 5 Jun 2023 15:18:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 2/2] ceph: fix blindly expanding the readahead windows
Content-Language: en-US
To:     =?UTF-8?B?6IOh546u5paH?= <huww98@outlook.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, sehuww@mail.scut.edu.cn,
        stable@vger.kernel.org
References: <20230515012044.98096-1-xiubli@redhat.com>
 <20230515012044.98096-3-xiubli@redhat.com>
 <TYCP286MB206692566DDEE50F7AD00A49C04DA@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <TYCP286MB206692566DDEE50F7AD00A49C04DA@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/5/23 14:56, 胡玮文 wrote:
> On Mon, May 15, 2023 at 09:20:44AM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Blindly expanding the readahead windows will cause unneccessary
>> pagecache thrashing and also will introdue the network workload.
> s/introdue/introduce/

Will fix it.


>> We should disable expanding the windows if the readahead is disabled
>> and also shouldn't expand the windows too much.
>>
>> Expanding forward firstly instead of expanding backward for possible
>> sequential reads.
>>
>> Bound `rreq->len` to the actual file size to restore the previous page
>> cache usage.
>>
>> The posix_fadvise may change the maximum size of a file readahead.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 49870056005c ("ceph: convert ceph_readpages to ceph_readahead")
>> URL: https://lore.kernel.org/ceph-devel/20230504082510.247-1-sehuww@mail.scut.edu.cn
>> URL: https://www.spinics.net/lists/ceph-users/msg76183.html
>> Cc: Hu Weiwen <sehuww@mail.scut.edu.cn>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/addr.c | 40 +++++++++++++++++++++++++++++++++-------
>>   1 file changed, 33 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index 93fff1a7373f..4b29777c01d7 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -188,16 +188,42 @@ static void ceph_netfs_expand_readahead(struct netfs_io_request *rreq)
>>   	struct inode *inode = rreq->inode;
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>>   	struct ceph_file_layout *lo = &ci->i_layout;
>> +	unsigned long max_pages = inode->i_sb->s_bdi->ra_pages;
>> +	loff_t end = rreq->start + rreq->len, new_end;
>> +	struct ceph_netfs_request_data *priv = rreq->netfs_priv;
>> +	unsigned long max_len;
>>   	u32 blockoff;
>> -	u64 blockno;
>>   
>> -	/* Expand the start downward */
>> -	blockno = div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
>> -	rreq->start = blockno * lo->stripe_unit;
>> -	rreq->len += blockoff;
>> +	if (priv) {
>> +		/* Readahead is disabled by posix_fadvise POSIX_FADV_RANDOM */
>> +		if (priv->file_ra_disabled)
>> +			max_pages = 0;
>> +		else
>> +			max_pages = priv->file_ra_pages;
>> +
>> +	}
>> +
>> +	/* Readahead is disabled */
>> +	if (!max_pages)
>> +		return;
>>   
>> -	/* Now, round up the length to the next block */
>> -	rreq->len = roundup(rreq->len, lo->stripe_unit);
>> +	max_len = max_pages << PAGE_SHIFT;
>> +
>> +	/*
>> +	 * Try to expand the length forward by rounding  up it to the next
> An extra space between "rounding  up".

Will fix it.


> Apart from above two typo, LGTM.
>
> Reviewed-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
>
> I also tested this patch with our workload. Reading the first 16k images
> from ImageNet dataset (1.69GiB) takes about 1.8Gi page cache (as
> reported by `free -h'). This is expected.
>
> For the fadvise use-case, I use `fio' to do the test:
> $ fio --name=rand --size=32M --fadvise_hint=1 --ioengine=libaio --iodepth=128 --rw=randread --bs=4k --filesize=2G
>
> after the test, page cache increased by about 35Mi, which is expected.
> So if appropriate:
>
> Tested-by: Hu Weiwen <sehuww@mail.scut.edu.cn>

Thanks for your tests and reviewing.

> However, also note random reading to a large file without fadvise still
> suffers from degradation. e.g., this test:
> $ fio --name=rand --size=32M --fadvise_hint=0 --ioengine=libaio --iodepth=128 --rw=randread --bs=4k --filesize=2G
>
> will load nearly every page of the 2Gi test file into page cache,
> although I only need 32Mi of them.

This is another issue since this patch just to fix blindly expanding 
readahead windows, please send one following patch to fix it.

Thanks

- Xiubo


>> +	 * block, but do not exceed the file size, unless the original
>> +	 * request already exceeds it.
>> +	 */
>> +	new_end = min(round_up(end, lo->stripe_unit), rreq->i_size);
>> +	if (new_end > end && new_end <= rreq->start + max_len)
>> +		rreq->len = new_end - rreq->start;
>> +
>> +	/* Try to expand the start downward */
>> +	div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
>> +	if (rreq->len + blockoff <= max_len) {
>> +		rreq->start -= blockoff;
>> +		rreq->len += blockoff;
>> +	}
>>   }
>>   
>>   static bool ceph_netfs_clamp_length(struct netfs_io_subrequest *subreq)
>> -- 
>> 2.40.1
>>


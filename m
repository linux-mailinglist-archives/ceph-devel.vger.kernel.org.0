Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70626FDCDA
	for <lists+ceph-devel@lfdr.de>; Wed, 10 May 2023 13:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236278AbjEJLhj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 May 2023 07:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236681AbjEJLhi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 10 May 2023 07:37:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B0461B0
        for <ceph-devel@vger.kernel.org>; Wed, 10 May 2023 04:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683718592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l/HaDYCzkd2AEz06wBgc3bIlPsg0QPKHrPvIoEzzDwY=;
        b=dvjHsdur9c0s8+1yOLMiSTF2dXX+k5O40hnmW40KWrc/8aR36i41kYM1ulDlVStHhh5hvS
        E0ldrvCpcSe/BDUQsFsYbqau9VRlM498XIeUjFBVHBx8R+/Jiabwq9pWST6mUMPjV5Cdy0
        C9K1fPIAun7DIgcWJY6BhqIUaOzYwXg=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-FgBFwzFtMr-XOi0V0b27wg-1; Wed, 10 May 2023 07:36:31 -0400
X-MC-Unique: FgBFwzFtMr-XOi0V0b27wg-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1ab0b96498cso72337455ad.1
        for <ceph-devel@vger.kernel.org>; Wed, 10 May 2023 04:36:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683718590; x=1686310590;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l/HaDYCzkd2AEz06wBgc3bIlPsg0QPKHrPvIoEzzDwY=;
        b=W1/gS7YtWtmSSQPvfnqRttzVANjJ4CPcgmslWbQuumFmiDe6RM64sL9NZsjXEKWu7+
         e34ZcBNnHt6AOHYdtwyJ3r5LZqLZBNiGK4Zl0axWPRfU9KEvnZDNnASGv3NKE2VZXnqT
         4l70SX/Pr4Lzqv9H+o/fDhuD8Dk83lP4Mo25VbbIrGXLb4CfkTefBhpl/3foBbgiXbBu
         VXxTKkIFmcUVRETXEjb5PnzFSgnoeRYkSEjfULLFJEYuUSdT6XKrtPSTGwlK7NZT5MsK
         DYLwxO6uvjyntME3jV5YgiEoPxgP17oIaVzd/EpeLhCc17hRTGaDVX9GIih1OL9qTRfK
         ZGCA==
X-Gm-Message-State: AC+VfDychNOGMT5riFcAkXWH1FGUnosH6Zk5J6ZbO8TYQDqYiixsTfOZ
        UyNEZ012YsicwYU/apWrhd1siWXVagiGGAYvD05iH/SEQtpp7N3FW6aRTPyLTHVaRq9S1eiEqtD
        5jlAv58FWZAr0C1lqpgu46g==
X-Received: by 2002:a17:903:41d0:b0:1ac:4412:bd9 with SMTP id u16-20020a17090341d000b001ac44120bd9mr21397780ple.3.1683718590056;
        Wed, 10 May 2023 04:36:30 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7zXJwIXKOZpoh6ptTjXyY0CgtNX3JOiSA91fMaWONOaeHAqVtbEleJppftp+ntKiw205NODw==
X-Received: by 2002:a17:903:41d0:b0:1ac:4412:bd9 with SMTP id u16-20020a17090341d000b001ac44120bd9mr21397757ple.3.1683718589727;
        Wed, 10 May 2023 04:36:29 -0700 (PDT)
Received: from [10.72.12.156] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id az7-20020a170902a58700b001a212a93295sm3531031plb.189.2023.05.10.04.36.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 04:36:29 -0700 (PDT)
Message-ID: <5f3c6853-cc1d-a46e-3422-b39a1666eb9c@redhat.com>
Date:   Wed, 10 May 2023 19:36:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4] ceph: fix blindly expanding the readahead windows
Content-Language: en-US
To:     =?UTF-8?B?6IOh546u5paH?= <huww98@outlook.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, stable@vger.kernel.org,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
References: <20230509005703.155321-1-xiubli@redhat.com>
 <TYCP286MB2066E72A82760E96D328A420C0779@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <TYCP286MB2066E72A82760E96D328A420C0779@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/10/23 18:01, 胡玮文 wrote:
> On Tue, May 09, 2023 at 08:57:03AM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Blindly expanding the readahead windows will cause unneccessary
>> pagecache thrashing and also will introdue the network workload.
>                                      ^^^^^^^^
>                                      introduce
>
>> We should disable expanding the windows if the readahead is disabled
>> and also shouldn't expand the windows too much.
>>
>> Expanding forward firstly instead of expanding backward for possible
>> sequential reads.
>>
>> Bound `rreq->len` to the actual file size to restore the previous page
>> cache usage.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 49870056005c ("ceph: convert ceph_readpages to ceph_readahead")
>> URL: https://lore.kernel.org/ceph-devel/20230504082510.247-1-sehuww@mail.scut.edu.cn
>> URL: https://www.spinics.net/lists/ceph-users/msg76183.html
>> Cc: Hu Weiwen <sehuww@mail.scut.edu.cn>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V4:
>> - two small cleanup from Ilya's comments. Thanks
>>
>>
>>   fs/ceph/addr.c | 28 +++++++++++++++++++++-------
>>   1 file changed, 21 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index ca4dc6450887..683ba9fbd590 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -188,16 +188,30 @@ static void ceph_netfs_expand_readahead(struct netfs_io_request *rreq)
>>   	struct inode *inode = rreq->inode;
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>>   	struct ceph_file_layout *lo = &ci->i_layout;
>> +	unsigned long max_pages = inode->i_sb->s_bdi->ra_pages;
> I think it is better to use `ractl->ra->ra_pages' instead of
> `inode->i_sb->s_bdi->ra_pages'.  So that we can consider per-request ra
> size config, e.g., posix_fadvise(POSIX_FADV_SEQUENTIAL) will double the
> ra_pages.

Yeah, good catch.

> But `ractl' is not passed to this function.  Can we just add this
> argument?  ceph seems to be the only implementation of expand_readahead,
> so it should be easy.  Or since this patch will be backported, maybe we
> should keep it simple, and write another patch for this?

I think we should fix it together with this. It should be easy.

We can just store the "file->f_ra->ra_pages" in ceph_init_request() 
instead, because each rreq will be related to a dedicated file.


>> +	unsigned long max_len = max_pages << PAGE_SHIFT;
>> +	loff_t end = rreq->start + rreq->len, new_end;
>>   	u32 blockoff;
>> -	u64 blockno;
>>   
>> -	/* Expand the start downward */
>> -	blockno = div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
>> -	rreq->start = blockno * lo->stripe_unit;
>> -	rreq->len += blockoff;
>> +	/* Readahead is disabled */
>> +	if (!max_pages)
>> +		return;
> If we have access to ractl here, we can also skip expanding on
> `ractl->file->f_mode & FMODE_RANDOM', which is set by
> `posix_fadvise(POSIX_FADV_RANDOM)'.

Correct, because the "page_cache_sync_ra()' will do the right thing and 
we can skip expanding it here in ceph.

Thanks

- Xiubo

>
>>   
>> -	/* Now, round up the length to the next block */
>> -	rreq->len = roundup(rreq->len, lo->stripe_unit);
>> +	/*
>> +	 * Try to expand the length forward by rounding  up it to the next
>                                                         ^^ an extra space
>
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
>> 2.40.0
>>


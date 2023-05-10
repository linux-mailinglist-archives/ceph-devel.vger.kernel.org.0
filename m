Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E0F6FD359
	for <lists+ceph-devel@lfdr.de>; Wed, 10 May 2023 02:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235277AbjEJAtB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 May 2023 20:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbjEJAs7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 May 2023 20:48:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F21A3C3B
        for <ceph-devel@vger.kernel.org>; Tue,  9 May 2023 17:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683679688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IUlmLxewQnA5t6Uct6qjSQ492sWEhcYEuNWusO9nnWo=;
        b=HhYGl/B0B4v8fSdIdRGihUuMCrmIAMT6iVDRbzcC/uPMum6EviJuzfQnCTVQVvGiphd+jV
        CZ+x9UgxDO4//b7X1PvKxKy/eugPIkRRjolb/H9UmPjcRIjlgST1diqosgVpAiikk91hJ+
        fCfID+04yBWdkuF1JWm3W+f/Oy69Q38=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-LiL63KsBNiWlHOxtRvWrAA-1; Tue, 09 May 2023 20:48:07 -0400
X-MC-Unique: LiL63KsBNiWlHOxtRvWrAA-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1ab23e1c1aeso37903945ad.0
        for <ceph-devel@vger.kernel.org>; Tue, 09 May 2023 17:48:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683679686; x=1686271686;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IUlmLxewQnA5t6Uct6qjSQ492sWEhcYEuNWusO9nnWo=;
        b=OPqzPmmjeuaCA5+XYMokWEcn1mzCP6B2AmIaFJLQVC+Z4g+pSK2ZewR3uQYrc88GGr
         22BJqevNwbXKNZQqjozlHBIjNx5nEJqxSGc8cca8OX5up1n5WOCkEPzJrO5DCzpoSZ4n
         i4Q7wwRqobAHZrFfUir/WbuCOZz6+swGy3a+oFdbCTEyGRMeAlXroQgtNg0b7tXk1FG+
         zwO5NMtdtdAoRRyPvzatw4+X9BY8lkU1es2R0rtYVcby1HR56BjFs+0XKKDHGQVlbHB1
         W/yZKE630+wGuBo9L2ZZ9z9KlX+V3kf0r6LtcrUzXxxcWIF4FtADQNxBj3JIW0DbS+/F
         HJtw==
X-Gm-Message-State: AC+VfDzQly1LQ002CvmbYjk9mm1ZkkqPmhXLI8HgD1RMUYs5GeypyDV7
        eOFagB+uap7WO16ZengpQPaqJ5RSNQqUL08iTVx3sHTD0KBMYWzBskcgwXlxRL8uhulqqADbfuO
        o2wyyfijDZVfkye5OceLpeA==
X-Received: by 2002:a17:903:183:b0:1ac:7260:80a7 with SMTP id z3-20020a170903018300b001ac726080a7mr11707951plg.43.1683679686565;
        Tue, 09 May 2023 17:48:06 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4ydhvVqLzzfvBrUNeksOjcabN8gKbQe9F9EETh9Jfu/ci6MqbGIFdSu+Eok48hB62s17QS6g==
X-Received: by 2002:a17:903:183:b0:1ac:7260:80a7 with SMTP id z3-20020a170903018300b001ac726080a7mr11707934plg.43.1683679686226;
        Tue, 09 May 2023 17:48:06 -0700 (PDT)
Received: from [10.72.12.156] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m24-20020a170902bb9800b001a217a7a11csm2276628pls.131.2023.05.09.17.48.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 17:48:05 -0700 (PDT)
Message-ID: <6fd925c2-e5a1-45a3-304a-54e6096c3f91@redhat.com>
Date:   Wed, 10 May 2023 08:48:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4] ceph: fix blindly expanding the readahead windows
Content-Language: en-US
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        ceph-devel@vger.kernel.org
Cc:     vshankar@redhat.com, stable@vger.kernel.org,
        Hu Weiwen <sehuww@mail.scut.edu.cn>,
        Steve French <smfrench@gmail.com>
References: <20230509005703.155321-1-xiubli@redhat.com>
 <abac46a83389b33d352e9d6fa35ea2b386e4cea2.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <abac46a83389b33d352e9d6fa35ea2b386e4cea2.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/9/23 22:18, Jeff Layton wrote:
> On Tue, 2023-05-09 at 08:57 +0800, xiubli@redhat.com wrote:
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
> (cc'ing Steve French since he was asking me about ceph readahead
> yesterday)
>
> FWIW, the original idea here was to try to read whole OSD objects when
> we can. I can see that that may have been overzealous though, so
> ramping up the size more slowly makes sense.
>
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
>>   
>> -	/* Now, round up the length to the next block */
>> -	rreq->len = roundup(rreq->len, lo->stripe_unit);
>> +	/*
>> +	 * Try to expand the length forward by rounding  up it to the next
>> +	 * block, but do not exceed the file size, unless the original
>> +	 * request already exceeds it.
>> +	 */

Hi Jeff,


> Do you really need to clamp this to the i_size? Is it ever possible for
> the client to be out of date as to the real file size? If so then you
> might end up with a short read when there is actually more data.
>
> I guess by doing this, you're trying to avoid having to call the OSD
> back after a short read and get a zero-length read when the file is
> shorter than the requested read?

This is folded from Weiwen's another fix 
https://patchwork.kernel.org/project/ceph-devel/patch/20230504082510.247-1-sehuww@mail.scut.edu.cn/.

For small files use case this may really could cause unnecessary network 
workload and inefficient usage of the page cache.

Thanks

- Xiubo

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


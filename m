Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E27954A353
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jun 2022 02:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbiFNAzR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Jun 2022 20:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiFNAzQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Jun 2022 20:55:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B2DF631211
        for <ceph-devel@vger.kernel.org>; Mon, 13 Jun 2022 17:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655168114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tUUFJ/1W4INlRQ6ZOmFreL33gB3/RqHhEXzUA+i9NG8=;
        b=XsxgDr5ADqODTdlalHBtjMVOGMpWqxdH18003Dy73aqyKV7oyemLAWBzaCOEaIHLR7Bq2F
        e4WThT2USFSeiD9Lzydv0T0lQ50Nh54kF3CVu6KgFOb/4pXdJWjIvD3OK3XaSzCJVqM0w0
        vaSRT+waZNV2vb4R34FMFLXz9ctAzTQ=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-z37qW5PZNYS1aKA8kePDVA-1; Mon, 13 Jun 2022 20:55:13 -0400
X-MC-Unique: z37qW5PZNYS1aKA8kePDVA-1
Received: by mail-pj1-f71.google.com with SMTP id q9-20020a17090a1b0900b001e87ad1beadso7206670pjq.1
        for <ceph-devel@vger.kernel.org>; Mon, 13 Jun 2022 17:55:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tUUFJ/1W4INlRQ6ZOmFreL33gB3/RqHhEXzUA+i9NG8=;
        b=F5/H/m1m/P+74JneJC4neHDcgygJhMGm0TZ31bNB/9Zv+SjLW1/hy1MFiUXN4CEgLW
         smavQLHVgSVvtsiroJKRdTrEWMdyLxiiJxww4k/3H5cjHfSh4FBz7hwqu1fga0QrqPI/
         x+kc13iH882XG8jozbkAKOa8LlEx/5g7nnDtuu91mSIFOftBUd3/iQfqkiOhXnW0EC70
         1YuqqMeJN3OFqs25QH+t0aXuLvmpGDHz97G+yb2bjXs1f5mJzix6E04r7bOtXjnYuan9
         sxhpu0U/WtPma61n76TzPUqXlPtpJKRyqkBdPhyHs4bKC3vWIsnl/GyjBok9OHihtPrN
         k2Jg==
X-Gm-Message-State: AJIora+kNi38ugrOHqPCYj07njIt4QOOLBsUdcWt/9axYCKcdC1gWXPO
        flaa1cahzZMkE9G3pGfBUGwlaJyURRfiDL9kVEoNOpJppLZoIjIdJsKISQGwyUk3DkLYJXqSHl3
        bw8NPEUrtEjrrX7w7sVjWtfXbNAa4x6w7Z43SuNyUN585EgaRe5n/fjpHVliX3+FtoBQOXzY=
X-Received: by 2002:a17:90b:180b:b0:1e3:25f6:6475 with SMTP id lw11-20020a17090b180b00b001e325f66475mr1586164pjb.208.1655168112261;
        Mon, 13 Jun 2022 17:55:12 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vfKXF0HMpw7SewRD+5jnQskKAdDsaUQEf2+ma3d2ORwLsJBSNhWHEHfV27tEuTiLxmsSDDJw==
X-Received: by 2002:a17:90b:180b:b0:1e3:25f6:6475 with SMTP id lw11-20020a17090b180b00b001e325f66475mr1586138pjb.208.1655168111879;
        Mon, 13 Jun 2022 17:55:11 -0700 (PDT)
Received: from [10.72.12.41] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f20-20020a17090a639400b001ea75a02805sm8075353pjj.52.2022.06.13.17.55.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 17:55:11 -0700 (PDT)
Subject: Re: [PATCH 2/2] ceph: update the auth cap when the async create req
 is forwarded
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
References: <20220610043140.642501-1-xiubli@redhat.com>
 <20220610043140.642501-3-xiubli@redhat.com> <87r13seed5.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4eb44a0b-f7e9-683d-8317-15cf959a570a@redhat.com>
Date:   Tue, 14 Jun 2022 08:55:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87r13seed5.fsf@brahms.olymp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/14/22 12:07 AM, Luís Henriques wrote:
> Xiubo Li <xiubli@redhat.com> writes:
>
>> For async create we will always try to choose the auth MDS of frag
>> the dentry belonged to of the parent directory to send the request
>> and ususally this works fine, but if the MDS migrated the directory
>> to another MDS before it could be handled the request will be
>> forwarded. And then the auth cap will be changed.
>>
>> We need to update the auth cap in this case before the request is
>> forwarded.
>>
>> URL: https://tracker.ceph.com/issues/55857
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/file.c       | 12 +++++++++
>>   fs/ceph/mds_client.c | 58 ++++++++++++++++++++++++++++++++++++++++++++
>>   fs/ceph/super.h      |  2 ++
>>   3 files changed, 72 insertions(+)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 0e82a1c383ca..54acf76c5e9b 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -613,6 +613,7 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
>>   	struct ceph_mds_reply_inode in = { };
>>   	struct ceph_mds_reply_info_in iinfo = { .in = &in };
>>   	struct ceph_inode_info *ci = ceph_inode(dir);
>> +	struct ceph_dentry_info *di = ceph_dentry(dentry);
>>   	struct timespec64 now;
>>   	struct ceph_string *pool_ns;
>>   	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
>> @@ -709,6 +710,12 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
>>   		file->f_mode |= FMODE_CREATED;
>>   		ret = finish_open(file, dentry, ceph_open);
>>   	}
>> +
>> +	spin_lock(&dentry->d_lock);
>> +	di->flags &= ~CEPH_DENTRY_ASYNC_CREATE;
>> +	wake_up_bit(&di->flags, CEPH_DENTRY_ASYNC_CREATE_BIT);
>> +	spin_unlock(&dentry->d_lock);
> Question: shouldn't we initialise 'di' *after* grabbing ->d_lock?  Ceph
> code doesn't seem to be consistent with this regard, but my understanding
> is that doing it this way is racy.  And if so, some other places may need
> fixing.

Yeah, it should be.

BTW, do you mean some where like this:

if (!test_bit(CEPH_DENTRY_ASYNC_UNLINK_BIT, &di->flags))

?

If so, it's okay and no issue here.

-- Xiubo


> Cheers,


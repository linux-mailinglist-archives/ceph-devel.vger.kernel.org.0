Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80ADF4B7BEC
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Feb 2022 01:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245077AbiBPA3y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 19:29:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245094AbiBPA3w (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 19:29:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 651D9F70F8
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 16:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644971377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=la+KujOkddm/k61pgM5A6+oWW02wS9/RzRVsg5yCujA=;
        b=EKjxO3HTbEX16NJzHX1LZXvfecFQ50ZTOEW2p6klr+PMbRxsBNQ2XFhKubAuUrp81OwSKo
        swT0Cl3PjMxqm01fT2c4NtPDiV0wzd7+ifxYEHGV433bkbV4S1biK63SAUX0lM873x1pc2
        jCj4MxONO0/L7zxqPVECJS7Eo/B7WRY=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-dwDkjt3uOyO3chxeAt5oIw-1; Tue, 15 Feb 2022 19:29:36 -0500
X-MC-Unique: dwDkjt3uOyO3chxeAt5oIw-1
Received: by mail-pj1-f70.google.com with SMTP id o5-20020a17090a4e8500b001b9c3948dd2so3555444pjh.3
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 16:29:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=la+KujOkddm/k61pgM5A6+oWW02wS9/RzRVsg5yCujA=;
        b=QF4wYBTW4Zc5dV4BwF+R2nUpZylGFZfThSfuVf45BxU2NkBfcEFcFtCg68Z46k993a
         EOTO0CEpCYUdKSjz2zMH6RsQR6vT/sZv6nAtjv0RVExADgBRf78ZQgHAqnPtuEY49z9G
         lhMrKqD2QT3U3h1/YfEpqnR1q/sJFdwajhiIy5LdCPGwG2AHWXoaaIZ7Ij1vjd9RyDEm
         pQ/zFcRm62L2Uk/q2rcBt2o0WnHZoaQfJ3IOVRhvlr1dAjau8aoBBDJ4xWU6Q+D8RxMD
         2wngMuoKy1QOeh9yXpXbm+kfE5VShMfDP1g3yvkM6ohWGsY7u6sR7NNL/GrBDuR+tvuy
         +gqg==
X-Gm-Message-State: AOAM533+1Ef4l5pySX65LS9cREPfy1cyE2qDystARToxW3glLYrBvwVH
        GqeSYJWAsskZlYixw8auAwq1NTYYYfUXxQOjoOKrEx42Hn27dlg+YTwJIoUiq0Kot1QaIHb2xSe
        DG65eKUHUBdphEzNaX9aVokKfpIQKewdsfg6gOs3nvS1wZRonHb/cTswoB2/C+MAltKb8pXw=
X-Received: by 2002:a17:90a:52:b0:1b9:bda3:1105 with SMTP id 18-20020a17090a005200b001b9bda31105mr7177968pjb.19.1644971374602;
        Tue, 15 Feb 2022 16:29:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyyvm7xEP2j7aEvdJz8XVjQ7fSUHp4z0E2nWR1Rj6G7pVRQm51g4QhDQQVuN21en8+B6lqdgQ==
X-Received: by 2002:a17:90a:52:b0:1b9:bda3:1105 with SMTP id 18-20020a17090a005200b001b9bda31105mr7177936pjb.19.1644971374197;
        Tue, 15 Feb 2022 16:29:34 -0800 (PST)
Received: from [10.72.12.153] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f12sm41323969pfv.30.2022.02.15.16.29.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 16:29:33 -0800 (PST)
Subject: Re: [PATCH 2/3] ceph: move kzalloc under i_ceph_lock with GFP_ATOMIC
 flag
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220215122316.7625-1-xiubli@redhat.com>
 <20220215122316.7625-3-xiubli@redhat.com>
 <7239f8b4e48ce1e0fcba850ae183c5225f6e774b.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <568a7ecc-0f21-6726-0ab7-57ffb377f023@redhat.com>
Date:   Wed, 16 Feb 2022 08:29:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <7239f8b4e48ce1e0fcba850ae183c5225f6e774b.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/16/22 12:57 AM, Jeff Layton wrote:
> On Tue, 2022-02-15 at 20:23 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> There has one case that the snaprealm has been updated and then
>> it will iterate all the inode under it and try to queue a cap
>> snap for it. But in some case there has millions of subdirectries
>> or files under it and most of them no any Fw or dirty pages and
>> then will just be skipped.
>>
>> URL: https://tracker.ceph.com/issues/44100
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/snap.c | 37 +++++++++++++++++++++++++++----------
>>   1 file changed, 27 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index c787775eaf2a..d075d3ce5f6d 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -477,19 +477,21 @@ static bool has_new_snaps(struct ceph_snap_context *o,
>>   static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
>>   {
>>   	struct inode *inode = &ci->vfs_inode;
>> -	struct ceph_cap_snap *capsnap;
>> +	struct ceph_cap_snap *capsnap = NULL;
>>   	struct ceph_snap_context *old_snapc, *new_snapc;
>>   	struct ceph_buffer *old_blob = NULL;
>>   	int used, dirty;
>> -
>> -	capsnap = kmem_cache_alloc(ceph_cap_snap_cachep, GFP_NOFS);
>> -	if (!capsnap) {
>> -		pr_err("ENOMEM allocating ceph_cap_snap on %p\n", inode);
>> -		return;
>> +	bool need_flush = false;
>> +	bool atomic_alloc_mem_failed = false;
>> +
>> +retry:
>> +	if (unlikely(atomic_alloc_mem_failed)) {
>> +	        capsnap = kmem_cache_alloc(ceph_cap_snap_cachep, GFP_NOFS);
>> +		if (!capsnap) {
>> +			pr_err("ENOMEM allocating ceph_cap_snap on %p\n", inode);
>> +			return;
>> +		}
>>   	}
>> -	capsnap->cap_flush.is_capsnap = true;
>> -	INIT_LIST_HEAD(&capsnap->cap_flush.i_list);
>> -	INIT_LIST_HEAD(&capsnap->cap_flush.g_list);
>>   
>>   	spin_lock(&ci->i_ceph_lock);
>>   	used = __ceph_caps_used(ci);
>> @@ -532,7 +534,7 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
>>   	 */
>>   	if (has_new_snaps(old_snapc, new_snapc)) {
>>   		if (dirty & (CEPH_CAP_ANY_EXCL|CEPH_CAP_FILE_WR))
>> -			capsnap->need_flush = true;
>> +			need_flush = true;
>>   	} else {
>>   		if (!(used & CEPH_CAP_FILE_WR) &&
>>   		    ci->i_wrbuffer_ref_head == 0) {
>> @@ -542,6 +544,21 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
>>   		}
>>   	}
>>   
>> +	if (!capsnap) {
>> +	        capsnap = kmem_cache_alloc(ceph_cap_snap_cachep, GFP_ATOMIC);
>> +		if (unlikely(!capsnap)) {
>> +			pr_err("ENOMEM atomic allocating ceph_cap_snap on %p\n",
>> +			       inode);
>> +			spin_unlock(&ci->i_ceph_lock);
>> +			atomic_alloc_mem_failed = true;
>> +			goto retry;
>> +		}
>> +	}
>> +	capsnap->need_flush = need_flush;
>> +	capsnap->cap_flush.is_capsnap = true;
>> +	INIT_LIST_HEAD(&capsnap->cap_flush.i_list);
>> +	INIT_LIST_HEAD(&capsnap->cap_flush.g_list);
>> +
>>   	dout("queue_cap_snap %p cap_snap %p queuing under %p %s %s\n",
>>   	     inode, capsnap, old_snapc, ceph_cap_string(dirty),
>>   	     capsnap->need_flush ? "" : "no_flush");
> I'm not so thrilled with this patch.
>
> First, are you sure you want GFP_ATOMIC here? Something like GFP_NOWAIT
> may be better since you have a fallback so the kernel can still make
> forward progress on reclaim if this returns NULL.
>
> That said, this is pretty kludgey. I'd much prefer to see something that
> didn't require this sort of hack. Maybe instead you could have
> queue_realm_cap_snaps do the allocation and pass a (struct ceph_cap_snap
> **) pointer in, and it can set the thing to NULL if it ends up using it?

Sounds good, I will switch to this approach in V2.

Thanks.


> That way, we still don't do the allocation under spinlock and you only
> end up allocating the number you need (plus maybe one or two on the
> edges).
>


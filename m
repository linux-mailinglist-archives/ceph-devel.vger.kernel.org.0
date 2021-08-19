Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646263F1997
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Aug 2021 14:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237068AbhHSMk4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Aug 2021 08:40:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54432 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230505AbhHSMkz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 08:40:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629376819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mzEtEXNxa+2kfTAmfSlbUCotTlLshAyNAZ8oVZ5BtRk=;
        b=WJvfVgeUQ0D8R3JkCVuHgVdKwgsWPqdd2l7yAMICFFezgZs2GyisIlPlqdTPwOX/z7reeB
        nRhfkGthkHcR2jLtHbtW9QMK88qNQkCS/3hB48sIpRjrMXc/lOnnq6nMoOfzmM481vGSvw
        Zyop06SdDlQG3ok1l9asIfqo5AhBn58=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-6KzUnC8KNrK8uA21ZHlYfw-1; Thu, 19 Aug 2021 08:40:18 -0400
X-MC-Unique: 6KzUnC8KNrK8uA21ZHlYfw-1
Received: by mail-pf1-f199.google.com with SMTP id z127-20020a6265850000b029039e815e04d6so2979758pfb.3
        for <ceph-devel@vger.kernel.org>; Thu, 19 Aug 2021 05:40:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=mzEtEXNxa+2kfTAmfSlbUCotTlLshAyNAZ8oVZ5BtRk=;
        b=I0eD734tgiAjg9x4WR9IKIUOWKd559Eibvti25dBaZNYr/aHUgB1e5rPjGHUvFIv2J
         9VpayG8ZdstIj/9tBHRAsVCRT+97sI6TiLwWQI+j60LySfezRCur91DBJGMI+zzSnuLQ
         qNUCsHVn34AsfG6xwgt1kCYKHUN5ryqiI1dEhmTu0XmfiJIOiuq5PVV+Ht8Ul1pKfLs2
         0hnnjw11VY6YHDWTHIq7oBJDfEuaJ2FE0tYcRxqH6bZAZV0VG+zMhjLxR3hLsCse6kZd
         nACTfL4n4wE9FYMfpwsc9F9jVvHlH4z5lIHzaAX/IH6+MZO+r3LbiaHsP0zSGX2rNWoD
         ATIg==
X-Gm-Message-State: AOAM533LtIcBiXxYM4CFIlpDFeNKp+Z7cOf30/Tblk5D73C0L9wK212e
        cf6cBTHOmeuV92MmX+pQ9rc9/a7UwcWHjTSOyZB+brAwGGSv+WxdKEj9GvREWEQ8AXbO7nQtr+W
        hB6ldXmoTs/c+U3U9UHJPqCTAZ6tj6IbZ/1jn2CadfjEx/6JWDnQP4oZkntJknTMhNjUXowQ=
X-Received: by 2002:a17:90a:29a5:: with SMTP id h34mr11187027pjd.69.1629376816785;
        Thu, 19 Aug 2021 05:40:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxLq3UAjliT+UBKj1inBaXYLJ524gwwJCFkvYa1Gr/MlZdzkbyDR+BU+pvgjLDqwun78VvqQ==
X-Received: by 2002:a17:90a:29a5:: with SMTP id h34mr11187006pjd.69.1629376816487;
        Thu, 19 Aug 2021 05:40:16 -0700 (PDT)
Received: from [10.72.12.40] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q3sm4077443pgl.23.2021.08.19.05.40.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 05:40:16 -0700 (PDT)
Subject: Re: [PATCH v4] ceph: correctly release memory from capsnap
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210818133842.15993-1-xiubli@redhat.com>
 <007becbddbb928e7cb52feb5ffafb4f254dd5ba0.camel@kernel.org>
 <f2bf8537-41a5-c406-ec11-c11a40d79a42@redhat.com>
 <e290f32319721d894b1d44c4be37b5b617a18780.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b79d3b90-49e8-8244-d22b-dc25a97e2ea5@redhat.com>
Date:   Thu, 19 Aug 2021 20:40:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <e290f32319721d894b1d44c4be37b5b617a18780.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/19/21 6:59 PM, Jeff Layton wrote:
> On Thu, 2021-08-19 at 07:43 +0800, Xiubo Li wrote:
>> On 8/19/21 12:06 AM, Jeff Layton wrote:
>>> On Wed, 2021-08-18 at 21:38 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> When force umounting, it will try to remove all the session caps.
>>>> If there has any capsnap is in the flushing list, the remove session
>>>> caps callback will try to release the capsnap->flush_cap memory to
>>>> "ceph_cap_flush_cachep" slab cache, while which is allocated from
>>>> kmalloc-256 slab cache.
>>>>
>>>> At the same time switch to list_del_init() because just in case the
>>>> force umount has removed it from the lists and the
>>>> handle_cap_flushsnap_ack() comes then the seconds list_del_init()
>>>> won't crash the kernel.
>>>>
>>>> URL: https://tracker.ceph.com/issues/52283
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>
>>>> Changed in V4:
>>>> - add a new is_capsnap field in ceph_cap_flush struct.
>>>>
>>>>
>>>>    fs/ceph/caps.c       | 19 ++++++++++++-------
>>>>    fs/ceph/mds_client.c |  7 ++++---
>>>>    fs/ceph/snap.c       |  1 +
>>>>    fs/ceph/super.h      |  3 ++-
>>>>    4 files changed, 19 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>> index 4663ab830614..52c7026fd0d1 100644
>>>> --- a/fs/ceph/caps.c
>>>> +++ b/fs/ceph/caps.c
>>>> @@ -1712,7 +1712,11 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
>>>>    
>>>>    struct ceph_cap_flush *ceph_alloc_cap_flush(void)
>>>>    {
>>>> -	return kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
>>>> +	struct ceph_cap_flush *cf;
>>>> +
>>>> +	cf = kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
>>>> +	cf->is_capsnap = false;
>>>> +	return cf;
>>>>    }
>>>>    
>>>>    void ceph_free_cap_flush(struct ceph_cap_flush *cf)
>>>> @@ -1747,7 +1751,7 @@ static bool __detach_cap_flush_from_mdsc(struct ceph_mds_client *mdsc,
>>>>    		prev->wake = true;
>>>>    		wake = false;
>>>>    	}
>>>> -	list_del(&cf->g_list);
>>>> +	list_del_init(&cf->g_list);
>>>>    	return wake;
>>>>    }
>>>>    
>>>> @@ -1762,7 +1766,7 @@ static bool __detach_cap_flush_from_ci(struct ceph_inode_info *ci,
>>>>    		prev->wake = true;
>>>>    		wake = false;
>>>>    	}
>>>> -	list_del(&cf->i_list);
>>>> +	list_del_init(&cf->i_list);
>>>>    	return wake;
>>>>    }
>>>>    
>>>> @@ -2400,7 +2404,7 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
>>>>    	ci->i_ceph_flags &= ~CEPH_I_KICK_FLUSH;
>>>>    
>>>>    	list_for_each_entry_reverse(cf, &ci->i_cap_flush_list, i_list) {
>>>> -		if (!cf->caps) {
>>>> +		if (cf->is_capsnap) {
>>>>    			last_snap_flush = cf->tid;
>>>>    			break;
>>>>    		}
>>>> @@ -2419,7 +2423,7 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
>>>>    
>>>>    		first_tid = cf->tid + 1;
>>>>    
>>>> -		if (cf->caps) {
>>>> +		if (!cf->is_capsnap) {
>>>>    			struct cap_msg_args arg;
>>>>    
>>>>    			dout("kick_flushing_caps %p cap %p tid %llu %s\n",
>>>> @@ -3568,7 +3572,7 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
>>>>    			cleaned = cf->caps;
>>>>    
>>>>    		/* Is this a capsnap? */
>>>> -		if (cf->caps == 0)
>>>> +		if (cf->is_capsnap)
>>>>    			continue;
>>>>    
>>>>    		if (cf->tid <= flush_tid) {
>>>> @@ -3642,7 +3646,8 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
>>>>    		cf = list_first_entry(&to_remove,
>>>>    				      struct ceph_cap_flush, i_list);
>>>>    		list_del(&cf->i_list);
>>>> -		ceph_free_cap_flush(cf);
>>>> +		if (!cf->is_capsnap)
>>>> +			ceph_free_cap_flush(cf);
>>>>    	}
>>>>    
>>>>    	if (wake_ci)
>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>> index dcb5f34a084b..b9e6a69cc058 100644
>>>> --- a/fs/ceph/mds_client.c
>>>> +++ b/fs/ceph/mds_client.c
>>>> @@ -1656,7 +1656,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>>>    		spin_lock(&mdsc->cap_dirty_lock);
>>>>    
>>>>    		list_for_each_entry(cf, &to_remove, i_list)
>>>> -			list_del(&cf->g_list);
>>>> +			list_del_init(&cf->g_list);
>>>>    
>>>>    		if (!list_empty(&ci->i_dirty_item)) {
>>>>    			pr_warn_ratelimited(
>>>> @@ -1710,8 +1710,9 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>>>    		struct ceph_cap_flush *cf;
>>>>    		cf = list_first_entry(&to_remove,
>>>>    				      struct ceph_cap_flush, i_list);
>>>> -		list_del(&cf->i_list);
>>>> -		ceph_free_cap_flush(cf);
>>>> +		list_del_init(&cf->i_list);
>>>> +		if (!cf->is_capsnap)
>>>> +			ceph_free_cap_flush(cf);
>>>>    	}
>>>>    
>>>>    	wake_up_all(&ci->i_cap_wq);
>>>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>>>> index af502a8245f0..62fab59bbf96 100644
>>>> --- a/fs/ceph/snap.c
>>>> +++ b/fs/ceph/snap.c
>>>> @@ -487,6 +487,7 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
>>>>    		pr_err("ENOMEM allocating ceph_cap_snap on %p\n", inode);
>>>>    		return;
>>>>    	}
>>>> +	capsnap->cap_flush.is_capsnap = true;
>>>>    
>>>>    	spin_lock(&ci->i_ceph_lock);
>>>>    	used = __ceph_caps_used(ci);
>>>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>>>> index 106ddfd1ce92..336350861791 100644
>>>> --- a/fs/ceph/super.h
>>>> +++ b/fs/ceph/super.h
>>>> @@ -186,8 +186,9 @@ struct ceph_cap {
>>>>    
>>>>    struct ceph_cap_flush {
>>>>    	u64 tid;
>>>> -	int caps; /* 0 means capsnap */
>>>> +	int caps;
>>>>    	bool wake; /* wake up flush waiters when finish ? */
>>>> +	bool is_capsnap; /* true means capsnap */
>>>>    	struct list_head g_list; // global
>>>>    	struct list_head i_list; // per inode
>>>>    	struct ceph_inode_info *ci;
>>> Looks good, Xiubo. I'll merge into testing after a bit of local testing
>>> on my part.
>>>
>>> I'll plan to mark this one for stable too, but I'll need to look at the
>>> prerequisites as there may be merge conflicts with earlier kernels.
>> I tried it but not all, for some old kernels it may conflict with the
>> code only in `__detach_cap_flush_from_mdsc()` and
>> `__detach_cap_flush_from_ci()`, which will fold these two funcs into
>> __finish_cap_flush().
>>
> Yeah, there are quite a few merge conflicts on older kernels and pulling
> in earlier patches to eliminate them just brings in more conflicts. We
> may have to do a custom backport on this one for some of the older
> stable kernels.
>
Yeah, agree.



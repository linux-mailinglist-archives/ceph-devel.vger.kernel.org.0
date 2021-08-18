Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBF63F0EC3
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Aug 2021 01:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbhHRXob (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 19:44:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55118 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234950AbhHRXob (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 19:44:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629330235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZlbzK3TZpyKF+QWYyT/IizSGD+uz8NJwpDFbb4HbiI8=;
        b=cz/qDJ95cLd9emftrmHxUHsZsnaII8Xk5gRU+Slh8kmcIl9K4C2FONz4YnUPNz9zwWXKo6
        YdwEO9gNHMtgPCuEQOz+E3dq7+NZSwL5pYTlEVCHJ4+WRUfugyXe8yXxoLINlUVSOp1r0N
        j4ohT3fiQdBNfQED7DmUfum1I3nbruw=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-denb18uSPTWolL1kMSF5aw-1; Wed, 18 Aug 2021 19:43:54 -0400
X-MC-Unique: denb18uSPTWolL1kMSF5aw-1
Received: by mail-pg1-f198.google.com with SMTP id u3-20020a6323430000b029023ba96595fdso2365479pgm.7
        for <ceph-devel@vger.kernel.org>; Wed, 18 Aug 2021 16:43:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZlbzK3TZpyKF+QWYyT/IizSGD+uz8NJwpDFbb4HbiI8=;
        b=ShC/bV21iUWxkgBlxVPQTR3pZ0r4yIhjknxKt0PBE2u8+UiBr0UDysXwF+XLBgO742
         pTTSAxeo2UawuZXFt9KljrHW5goOAfFY8mXDClfG1Jes+nC/Cy9UyYofWWdLBOiC6LoP
         GycFgmfRKQ4vv3OLLafJezsRX3JoGPisVGbGgYynGP2TlvpuTMll3VxZSnHvsKU6KUUy
         guwVzaeTRUlrNcl0rR0B2vUFjm2gkDfp0gENhIlpU3eyFT9gKm/BYa7d0uYlzZEp7pK+
         yuT8gjtubuaQXyzR7MXJXHCA0mpN+9SF85DJ6C63wEKjlNAQwyDGL4DhNsrI5yVrXucg
         jGjg==
X-Gm-Message-State: AOAM531lmm5iDltWKQHXDNubgqYuzLd022qQFI1M20nYwCtlEuVc6GOm
        Vn9lR4sz6Jd+6bzw2AGNbmofGDzfazexq+MIPDZ7QZih8wVMghLU3lOeOhNPmGL4XW3Kbximxtz
        j2ztkZyCynC0liQoU5OZujeW1mXON4x0+3Slwc4Ougn6sYvxxEer3XtQC6H1oHaNa3Q6TUmA=
X-Received: by 2002:a62:e90f:0:b029:307:8154:9ff7 with SMTP id j15-20020a62e90f0000b029030781549ff7mr11583176pfh.79.1629330233035;
        Wed, 18 Aug 2021 16:43:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0/rWKJ/eDPQdCG7lEY6yuV6xV/HDvH/rAUGfEMZgXQ2Q0fiNHvql7VVDl8FTmH9PoTeut9g==
X-Received: by 2002:a62:e90f:0:b029:307:8154:9ff7 with SMTP id j15-20020a62e90f0000b029030781549ff7mr11583155pfh.79.1629330232704;
        Wed, 18 Aug 2021 16:43:52 -0700 (PDT)
Received: from [10.72.12.133] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b9sm913026pfo.175.2021.08.18.16.43.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 16:43:52 -0700 (PDT)
Subject: Re: [PATCH v4] ceph: correctly release memory from capsnap
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210818133842.15993-1-xiubli@redhat.com>
 <007becbddbb928e7cb52feb5ffafb4f254dd5ba0.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f2bf8537-41a5-c406-ec11-c11a40d79a42@redhat.com>
Date:   Thu, 19 Aug 2021 07:43:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <007becbddbb928e7cb52feb5ffafb4f254dd5ba0.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/19/21 12:06 AM, Jeff Layton wrote:
> On Wed, 2021-08-18 at 21:38 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When force umounting, it will try to remove all the session caps.
>> If there has any capsnap is in the flushing list, the remove session
>> caps callback will try to release the capsnap->flush_cap memory to
>> "ceph_cap_flush_cachep" slab cache, while which is allocated from
>> kmalloc-256 slab cache.
>>
>> At the same time switch to list_del_init() because just in case the
>> force umount has removed it from the lists and the
>> handle_cap_flushsnap_ack() comes then the seconds list_del_init()
>> won't crash the kernel.
>>
>> URL: https://tracker.ceph.com/issues/52283
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> Changed in V4:
>> - add a new is_capsnap field in ceph_cap_flush struct.
>>
>>
>>   fs/ceph/caps.c       | 19 ++++++++++++-------
>>   fs/ceph/mds_client.c |  7 ++++---
>>   fs/ceph/snap.c       |  1 +
>>   fs/ceph/super.h      |  3 ++-
>>   4 files changed, 19 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 4663ab830614..52c7026fd0d1 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -1712,7 +1712,11 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
>>   
>>   struct ceph_cap_flush *ceph_alloc_cap_flush(void)
>>   {
>> -	return kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
>> +	struct ceph_cap_flush *cf;
>> +
>> +	cf = kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
>> +	cf->is_capsnap = false;
>> +	return cf;
>>   }
>>   
>>   void ceph_free_cap_flush(struct ceph_cap_flush *cf)
>> @@ -1747,7 +1751,7 @@ static bool __detach_cap_flush_from_mdsc(struct ceph_mds_client *mdsc,
>>   		prev->wake = true;
>>   		wake = false;
>>   	}
>> -	list_del(&cf->g_list);
>> +	list_del_init(&cf->g_list);
>>   	return wake;
>>   }
>>   
>> @@ -1762,7 +1766,7 @@ static bool __detach_cap_flush_from_ci(struct ceph_inode_info *ci,
>>   		prev->wake = true;
>>   		wake = false;
>>   	}
>> -	list_del(&cf->i_list);
>> +	list_del_init(&cf->i_list);
>>   	return wake;
>>   }
>>   
>> @@ -2400,7 +2404,7 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
>>   	ci->i_ceph_flags &= ~CEPH_I_KICK_FLUSH;
>>   
>>   	list_for_each_entry_reverse(cf, &ci->i_cap_flush_list, i_list) {
>> -		if (!cf->caps) {
>> +		if (cf->is_capsnap) {
>>   			last_snap_flush = cf->tid;
>>   			break;
>>   		}
>> @@ -2419,7 +2423,7 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
>>   
>>   		first_tid = cf->tid + 1;
>>   
>> -		if (cf->caps) {
>> +		if (!cf->is_capsnap) {
>>   			struct cap_msg_args arg;
>>   
>>   			dout("kick_flushing_caps %p cap %p tid %llu %s\n",
>> @@ -3568,7 +3572,7 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
>>   			cleaned = cf->caps;
>>   
>>   		/* Is this a capsnap? */
>> -		if (cf->caps == 0)
>> +		if (cf->is_capsnap)
>>   			continue;
>>   
>>   		if (cf->tid <= flush_tid) {
>> @@ -3642,7 +3646,8 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
>>   		cf = list_first_entry(&to_remove,
>>   				      struct ceph_cap_flush, i_list);
>>   		list_del(&cf->i_list);
>> -		ceph_free_cap_flush(cf);
>> +		if (!cf->is_capsnap)
>> +			ceph_free_cap_flush(cf);
>>   	}
>>   
>>   	if (wake_ci)
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index dcb5f34a084b..b9e6a69cc058 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -1656,7 +1656,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>   		spin_lock(&mdsc->cap_dirty_lock);
>>   
>>   		list_for_each_entry(cf, &to_remove, i_list)
>> -			list_del(&cf->g_list);
>> +			list_del_init(&cf->g_list);
>>   
>>   		if (!list_empty(&ci->i_dirty_item)) {
>>   			pr_warn_ratelimited(
>> @@ -1710,8 +1710,9 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>   		struct ceph_cap_flush *cf;
>>   		cf = list_first_entry(&to_remove,
>>   				      struct ceph_cap_flush, i_list);
>> -		list_del(&cf->i_list);
>> -		ceph_free_cap_flush(cf);
>> +		list_del_init(&cf->i_list);
>> +		if (!cf->is_capsnap)
>> +			ceph_free_cap_flush(cf);
>>   	}
>>   
>>   	wake_up_all(&ci->i_cap_wq);
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index af502a8245f0..62fab59bbf96 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -487,6 +487,7 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
>>   		pr_err("ENOMEM allocating ceph_cap_snap on %p\n", inode);
>>   		return;
>>   	}
>> +	capsnap->cap_flush.is_capsnap = true;
>>   
>>   	spin_lock(&ci->i_ceph_lock);
>>   	used = __ceph_caps_used(ci);
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index 106ddfd1ce92..336350861791 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -186,8 +186,9 @@ struct ceph_cap {
>>   
>>   struct ceph_cap_flush {
>>   	u64 tid;
>> -	int caps; /* 0 means capsnap */
>> +	int caps;
>>   	bool wake; /* wake up flush waiters when finish ? */
>> +	bool is_capsnap; /* true means capsnap */
>>   	struct list_head g_list; // global
>>   	struct list_head i_list; // per inode
>>   	struct ceph_inode_info *ci;
> Looks good, Xiubo. I'll merge into testing after a bit of local testing
> on my part.
>
> I'll plan to mark this one for stable too, but I'll need to look at the
> prerequisites as there may be merge conflicts with earlier kernels.

I tried it but not all, for some old kernels it may conflict with the 
code only in `__detach_cap_flush_from_mdsc()` and 
`__detach_cap_flush_from_ci()`, which will fold these two funcs into 
__finish_cap_flush().

Thanks

BRs



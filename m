Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE9C3EF783
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 03:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbhHRB3a (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Aug 2021 21:29:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233027AbhHRB3a (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 21:29:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629250135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7zuifkLWAxvryOnEVB1K7jCWdbzhmuENiDgkRwZqhKU=;
        b=H8VSBLazZcb2tS8q+4lJ1uUsOgw3nWYCCeKilhUuc5YPRYMoFpfeI3L/2AGlYdGaVO6aF0
        89L+50CkTFCP0ixe6ZRPWcVtOjHs4U97m04lXF4hMpWMkCGlMPaOQqPeY6qPAONLRFHZDv
        aGO0FaVOGHrkVhAQtnwZKz4P67Rpdfg=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-tLoU4dy_MTqZIsV3a65aUw-1; Tue, 17 Aug 2021 21:28:54 -0400
X-MC-Unique: tLoU4dy_MTqZIsV3a65aUw-1
Received: by mail-pl1-f198.google.com with SMTP id h3-20020a170902f54300b0012e31e334c0so356992plf.4
        for <ceph-devel@vger.kernel.org>; Tue, 17 Aug 2021 18:28:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=7zuifkLWAxvryOnEVB1K7jCWdbzhmuENiDgkRwZqhKU=;
        b=M4zwd2tWVIi+yn8ZAcswBWAnOzZhLbR89hmege7s3+HNY+LFfqqdN7sBjOwK1hRSNY
         Mr4ahtsSh07345prgQ+WN7cKah02XoioHe21xjzs5A7cgHIxMFwT1+yFeImtw+L86WRn
         CULwzenei/4N8UDc+VhkbZj7cLVBVjFFh88+QKNFWepqREeH5iCKYr3/7xCxf2q47IMH
         IetzYkZo1A8j7QE1cvl1R9FJWNNfwmqYaHLwCbiBY6oEvgWR5AOA0+G4EDuqdQQALIg+
         KZ1NIP/phR644YI3+x9KBwTf8UBgUBbUJx7N33CQBwfKaWW+i0DM7hEDzeF07rfvD+L7
         MEdQ==
X-Gm-Message-State: AOAM530grk9xnquC5cn2aqoW4DqWjRvRYgfFFn7EAWKdaAYIUfXbxd45
        +8Rac1V8yJ4d6cLVeaAjPVIQIIJDf/FFvPuIQD941lstUnfHTduJSGHDYSs4yaILyF6du07f78a
        xrTQbtTDCsnqGcgHbcnG0dO4BzSzAC643xy8acfdyg0PSN07t3d2NhlWoqU7dp5CiVE5QLjE=
X-Received: by 2002:a63:fd12:: with SMTP id d18mr6270027pgh.129.1629250133517;
        Tue, 17 Aug 2021 18:28:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/XIdNE5RYb0a+A+VfCDG4xvhv6YD/psZh6EPJ2MSHsYcStXyExsSKFi5h55EHdgFYcGVYFw==
X-Received: by 2002:a63:fd12:: with SMTP id d18mr6269999pgh.129.1629250133238;
        Tue, 17 Aug 2021 18:28:53 -0700 (PDT)
Received: from [10.72.12.44] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 11sm3648153pfl.41.2021.08.17.18.28.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 18:28:52 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: correctly release memory from capsnap
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210817123517.15764-1-xiubli@redhat.com>
 <25dd85fdb777f9b260392ceeda41fc5e62018ddd.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <a45660db-0125-ffa7-6c94-345ecafab075@redhat.com>
Date:   Wed, 18 Aug 2021 09:28:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <25dd85fdb777f9b260392ceeda41fc5e62018ddd.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/17/21 10:03 PM, Jeff Layton wrote:
> On Tue, 2021-08-17 at 20:35 +0800, xiubli@redhat.com wrote:
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
>> - Only to resolve the crash issue.
>> - s/list_del/list_del_init/
>>
>>
>>   fs/ceph/caps.c       | 18 ++++++++++++++----
>>   fs/ceph/mds_client.c |  7 ++++---
>>   2 files changed, 18 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 990258cbd836..4ee0ef87130a 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -1667,7 +1667,16 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
>>   
>>   struct ceph_cap_flush *ceph_alloc_cap_flush(void)
>>   {
>> -	return kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
>> +	struct ceph_cap_flush *cf;
>> +
>> +	cf = kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
>> +	/*
>> +	 * caps == 0 always means for the capsnap
>> +	 * caps > 0 means dirty caps being flushed
>> +	 * caps == -1 means preallocated, not used yet
>> +	 */
>> +	cf->caps = -1;
>> +	return cf;
>>   }
>>   
>>   void ceph_free_cap_flush(struct ceph_cap_flush *cf)
>> @@ -1704,14 +1713,14 @@ static bool __finish_cap_flush(struct ceph_mds_client *mdsc,
>>   			prev->wake = true;
>>   			wake = false;
>>   		}
>> -		list_del(&cf->g_list);
>> +		list_del_init(&cf->g_list);
>>   	} else if (ci) {
>>   		if (wake && cf->i_list.prev != &ci->i_cap_flush_list) {
>>   			prev = list_prev_entry(cf, i_list);
>>   			prev->wake = true;
>>   			wake = false;
>>   		}
>> -		list_del(&cf->i_list);
>> +		list_del_init(&cf->i_list);
>>   	} else {
>>   		BUG_ON(1);
>>   	}
>> @@ -3398,7 +3407,8 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
>>   		cf = list_first_entry(&to_remove,
>>   				      struct ceph_cap_flush, i_list);
>>   		list_del(&cf->i_list);
>> -		ceph_free_cap_flush(cf);
>> +		if (cf->caps)
>> +			ceph_free_cap_flush(cf);
>>   	}
>>   
>>   	if (wake_ci)
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 2c3d762c7973..dc30f56115fa 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -1226,7 +1226,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>   		spin_lock(&mdsc->cap_dirty_lock);
>>   
>>   		list_for_each_entry(cf, &to_remove, i_list)
>> -			list_del(&cf->g_list);
>> +			list_del_init(&cf->g_list);
>>   
>>   		if (!list_empty(&ci->i_dirty_item)) {
>>   			pr_warn_ratelimited(
>> @@ -1266,8 +1266,9 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>   		struct ceph_cap_flush *cf;
>>   		cf = list_first_entry(&to_remove,
>>   				      struct ceph_cap_flush, i_list);
>> -		list_del(&cf->i_list);
>> -		ceph_free_cap_flush(cf);
>> +		list_del_init(&cf->i_list);
>> +		if (cf->caps)
>> +			ceph_free_cap_flush(cf);
>>   	}
>>   
>>   	wake_up_all(&ci->i_cap_wq);
> This patch doesn't seem to apply to the current testing branch. Is it
> against an older tree?

I was trying to test the old tags and forgot to switch it back.

Have send out the V3 to fix it.

Thanks



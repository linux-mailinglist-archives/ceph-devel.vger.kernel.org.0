Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8D73D0E6D
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Jul 2021 14:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238666AbhGULWR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 21 Jul 2021 07:22:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42243 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238559AbhGULOF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 21 Jul 2021 07:14:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626868480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=byHYymt/EuiSOCS7mDU8w77nOjIdTuHzkEmHB+3KFKI=;
        b=IdqxeSHy1fVHznxJOMzXixNH0G4Rxj7ImVyE+NI6KM5dP0PZgVeTof5fWzgpd65yGRPe8f
        iy3BN7SsCcifyCRa17DZ6P7aVceKdQpoXadb3f98phuN0qCZ1/4YFh6ZgnGqJ3rTif3Ze7
        8bXoP4vQMTV01b0kx+TJHj9CcdgPpLk=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-0wl_IEu0Ogq2Smv2ewB_gQ-1; Wed, 21 Jul 2021 07:54:38 -0400
X-MC-Unique: 0wl_IEu0Ogq2Smv2ewB_gQ-1
Received: by mail-pj1-f71.google.com with SMTP id k23-20020a17090a5917b02901739510b17fso1542887pji.6
        for <ceph-devel@vger.kernel.org>; Wed, 21 Jul 2021 04:54:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=byHYymt/EuiSOCS7mDU8w77nOjIdTuHzkEmHB+3KFKI=;
        b=Yg6l5QFhp1WXZhe/1+5dbWam/+TeTpABf2GM4ftia6QmNUciqWDG2zrGtkr8v+Bu12
         kp9hbQvJJNydt151zXFiaiS3xVp3PmJi/H+AibdERTvNUqJw+2+w8RvYpLT3IgKXkoiD
         Gp68KrdT2OPlC+DvkcPvrQ7ASivptAD4h6hkVRVr3zCiEb/QgkgyR3WOhNqmKVJyc3kv
         ptJstlnpNYOi2JF25CD5PlVAjsT3VRx7k8davDfMqjkpF9nehxeWY1e8bcB2Kszl5R13
         chb68l55TNOIgMDFMUikEx34BqAe+EcRExIdluX+184Mltxdw+fnQu0fJcoOwEWmd6nq
         /njA==
X-Gm-Message-State: AOAM532evOwHAaEj7upFb6NuNPrHY0b5lEVZ2blodJhUhLiqDETB9VCX
        MHwEFyk+v8827Vv/DIvnoemCGRH6beAR7xruUltha91Frbzal0ElX7lXcESU3HqktnnJ095fMK6
        xZk+/+OMtgLnKDPbp1ThpdLJqpUDFe2LrzCfJhbs3TIiEmH8Y4NEkgcm0mXZMJ6FgtDSVZgM=
X-Received: by 2002:a17:90a:2906:: with SMTP id g6mr34367198pjd.100.1626868477662;
        Wed, 21 Jul 2021 04:54:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwH1/yVG2AabrYy3467gf5AzcNmKB6NH2sWSlssCgA609xUnv9EbDcLxeeZGPLAIB/sfxZ0dQ==
X-Received: by 2002:a17:90a:2906:: with SMTP id g6mr34367167pjd.100.1626868477330;
        Wed, 21 Jul 2021 04:54:37 -0700 (PDT)
Received: from [10.72.12.121] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x10sm27864696pfd.175.2021.07.21.04.54.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 04:54:37 -0700 (PDT)
Subject: Re: [PATCH RFC] ceph: flush the delayed caps in time
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210721082720.110202-1-xiubli@redhat.com>
 <a2ab96c71ac875bd98efef4f7cb4590fbfae3b82.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <072b68bd-cb8d-b6a6-cca5-4ca20cfcde99@redhat.com>
Date:   Wed, 21 Jul 2021 19:54:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a2ab96c71ac875bd98efef4f7cb4590fbfae3b82.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/21/21 7:23 PM, Jeff Layton wrote:
> On Wed, 2021-07-21 at 16:27 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The delayed_work will be executed per 5 seconds, during this time
>> the cap_delay_list may accumulate thounsands of caps need to flush,
>> this will make the MDS's dispatch queue be full and need a very long
>> time to handle them. And if there has some other operations, likes
>> a rmdir request, it will be add in the tail of dispath queue and
>> need to wait for several or tens of seconds.
>>
>> In client side we shouldn't queue to many of the cap requests and
>> flush them if there has more than 100 items.
>>
> Why 100? My inclination is to say NAK on this.

This just from my test that around 100 client_caps requests queued will 
work fine in most cases, which won't take too long to handle. Some times 
the client will send thousands of requests in a short time, that will be 
a problem.

>
> I'm not a fan of this sort of arbitrary throttling in order to alleviate
> a scalability problem in the MDS. The cap delay logic is already
> horrifically complex as well, and this just makes it worse. If the MDS
> happens to be processing requests from a lot of clients, this may not
> help at all.

Yeah, right, in that case the mds dispatch queue possibly will have more 
in a short time.


>> URL: https://tracker.ceph.com/issues/51734
> The core problem sounds like the MDS got a call and just took way too
> long to get to it. Shouldn't we be addressing this in the MDS instead?
> It sounds like it needs to do a better job of parallelizing cap flushes.

The problem is that almost all the requests need to acquire the global 
'mds_lock', so the parallelizing won't improve much.

Currently all the client side requests will have the priority of 
CEPH_MSG_PRIO_DEFAULT:

m->hdr.priority = cpu_to_le16(CEPH_MSG_PRIO_DEFAULT);

Not sure whether can we just make the cap flushing request a lower 
priority ? If this won't introduce other potential issue, that will work 
because in the MDS dispatch queue it will handle high priority requests 
first.

Thanks




>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c       | 21 ++++++++++++++++++++-
>>   fs/ceph/mds_client.c |  3 ++-
>>   fs/ceph/mds_client.h |  3 +++
>>   3 files changed, 25 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 4b966c29d9b5..064865761d2b 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -507,6 +507,8 @@ static void __cap_set_timeouts(struct ceph_mds_client *mdsc,
>>   static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
>>   				struct ceph_inode_info *ci)
>>   {
>> +	int num = 0;
>> +
>>   	dout("__cap_delay_requeue %p flags 0x%lx at %lu\n", &ci->vfs_inode,
>>   	     ci->i_ceph_flags, ci->i_hold_caps_max);
>>   	if (!mdsc->stopping) {
>> @@ -515,12 +517,19 @@ static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
>>   			if (ci->i_ceph_flags & CEPH_I_FLUSH)
>>   				goto no_change;
>>   			list_del_init(&ci->i_cap_delay_list);
>> +			mdsc->num_cap_delay--;
>>   		}
>>   		__cap_set_timeouts(mdsc, ci);
>>   		list_add_tail(&ci->i_cap_delay_list, &mdsc->cap_delay_list);
>> +		num = ++mdsc->num_cap_delay;
>>   no_change:
>>   		spin_unlock(&mdsc->cap_delay_lock);
>>   	}
>> +
>> +	if (num > 100) {
>> +		flush_delayed_work(&mdsc->delayed_work);
>> +		schedule_delayed(mdsc);
>> +	}
>>   }
>>   
>>   /*
>> @@ -531,13 +540,23 @@ static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
>>   static void __cap_delay_requeue_front(struct ceph_mds_client *mdsc,
>>   				      struct ceph_inode_info *ci)
>>   {
>> +	int num;
>> +
>>   	dout("__cap_delay_requeue_front %p\n", &ci->vfs_inode);
>>   	spin_lock(&mdsc->cap_delay_lock);
>>   	ci->i_ceph_flags |= CEPH_I_FLUSH;
>> -	if (!list_empty(&ci->i_cap_delay_list))
>> +	if (!list_empty(&ci->i_cap_delay_list)) {
>>   		list_del_init(&ci->i_cap_delay_list);
>> +		mdsc->num_cap_delay--;
>> +	}
>>   	list_add(&ci->i_cap_delay_list, &mdsc->cap_delay_list);
>> +	num = ++mdsc->num_cap_delay;
>>   	spin_unlock(&mdsc->cap_delay_lock);
>> +
>> +	if (num > 100) {
>> +		flush_delayed_work(&mdsc->delayed_work);
>> +		schedule_delayed(mdsc);
>> +	}
>>   }
>>   
>>   /*
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 79aa4ce3a388..14e44de05812 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4514,7 +4514,7 @@ void inc_session_sequence(struct ceph_mds_session *s)
>>   /*
>>    * delayed work -- periodically trim expired leases, renew caps with mds
>>    */
>> -static void schedule_delayed(struct ceph_mds_client *mdsc)
>> +void schedule_delayed(struct ceph_mds_client *mdsc)
>>   {
>>   	int delay = 5;
>>   	unsigned hz = round_jiffies_relative(HZ * delay);
>> @@ -4616,6 +4616,7 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>>   	mdsc->request_tree = RB_ROOT;
>>   	INIT_DELAYED_WORK(&mdsc->delayed_work, delayed_work);
>>   	mdsc->last_renew_caps = jiffies;
>> +	mdsc->num_cap_delay = 0;
>>   	INIT_LIST_HEAD(&mdsc->cap_delay_list);
>>   	INIT_LIST_HEAD(&mdsc->cap_wait_list);
>>   	spin_lock_init(&mdsc->cap_delay_lock);
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index a7af09257382..b4289b8d23ec 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -423,6 +423,7 @@ struct ceph_mds_client {
>>   	struct rb_root         request_tree;  /* pending mds requests */
>>   	struct delayed_work    delayed_work;  /* delayed work */
>>   	unsigned long    last_renew_caps;  /* last time we renewed our caps */
>> +	unsigned long    num_cap_delay;    /* caps in the cap_delay_list */
>>   	struct list_head cap_delay_list;   /* caps with delayed release */
>>   	spinlock_t       cap_delay_lock;   /* protects cap_delay_list */
>>   	struct list_head snap_flush_list;  /* cap_snaps ready to flush */
>> @@ -568,6 +569,8 @@ extern int ceph_trim_caps(struct ceph_mds_client *mdsc,
>>   			  struct ceph_mds_session *session,
>>   			  int max_caps);
>>   
>> +extern void schedule_delayed(struct ceph_mds_client *mdsc);
>> +
>>   static inline int ceph_wait_on_async_create(struct inode *inode)
>>   {
>>   	struct ceph_inode_info *ci = ceph_inode(inode);


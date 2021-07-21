Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22883D0FCE
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Jul 2021 15:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238407AbhGUNC7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 21 Jul 2021 09:02:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40322 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238585AbhGUNCT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 21 Jul 2021 09:02:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626874975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u3iRI6G2PmV2NVzeJOI9b2gH+9mDn8JHQ+/7RFM7IbY=;
        b=HNu9+Qr19qKd0QjQsrNo38ErkPPKeroMN6A1n5u0r+SA94D+JhEb+1cVmD1Fu4IXgMI5lm
        e/WrkBwvJ5hbQpZvVCNv2ClpZlHSir4yC4UvoOszkFQaVl4PVlAwGViK9AgxUw2RST9Q2h
        NPt5MEsL5q4hdS6ka+egN2/1IE+gUHc=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-vBjiOsB8Odide-_P5UHktg-1; Wed, 21 Jul 2021 09:42:53 -0400
X-MC-Unique: vBjiOsB8Odide-_P5UHktg-1
Received: by mail-pf1-f198.google.com with SMTP id d8-20020a056a001988b02903468678ce14so1789556pfl.22
        for <ceph-devel@vger.kernel.org>; Wed, 21 Jul 2021 06:42:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=u3iRI6G2PmV2NVzeJOI9b2gH+9mDn8JHQ+/7RFM7IbY=;
        b=sQInEc+TDT24OwjpboseAGS/wtlT6B6qUBlyYPkLrRdFiyFLcPcDpJgxkRvnEBeTVH
         hIebHBvrLJGd4YUn/FqgcLzzim9wOkzBAh7bBJ34+/g6evgT4LsH4ZaK1Hop5eWsNgbS
         SEdgGFlyZeJMvYUhMIMQdw0wsNDF3GVV9MAtY7fie0Nossh2VaTHEPjQ+RLMa9BOT8Xt
         XctBtEhYDAzdk7iQYZ/owSOpJfLxAXLtAocFr5dW0GBu2SSeQ6UhAoyq0mZ9kD020Hbs
         PNLdjsjhwyvRYahWTv2F5Y2C1cvRcP7ZeeyKobjKUahJgjYpFaHKQMV8vbNX9XKbKqHj
         Lc8g==
X-Gm-Message-State: AOAM530AiMbDSiBLhdpRP8AcK/KeMxkxJTJh8gWuXMvvdrYJlKHpHREJ
        XOnBGL2YDwKp02L3foc04FGi97p5CKH0QQVLAtTsf3MY1uy0n7wBZhZJ7RrbWq9kQZPZpblVyJe
        3UnyXuG2vBX6oxIsmlndrp0do2PlE7TuWoZMgRXz0B06DS39fe1GIWuQjB9uvln5NMHvPnMU=
X-Received: by 2002:a63:e205:: with SMTP id q5mr35878615pgh.404.1626874972637;
        Wed, 21 Jul 2021 06:42:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzijGVTfwkfdeC5J+hRxbjuNOiLN2UZilpusqEKhC7Zaedh/TzwYtVsMk0XrwCI/yshK8C8tA==
X-Received: by 2002:a63:e205:: with SMTP id q5mr35878579pgh.404.1626874972241;
        Wed, 21 Jul 2021 06:42:52 -0700 (PDT)
Received: from [10.72.12.121] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c2sm29566320pgh.82.2021.07.21.06.42.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 06:42:51 -0700 (PDT)
Subject: Re: [PATCH RFC] ceph: flush the delayed caps in time
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210721082720.110202-1-xiubli@redhat.com>
 <a2ab96c71ac875bd98efef4f7cb4590fbfae3b82.camel@kernel.org>
 <072b68bd-cb8d-b6a6-cca5-4ca20cfcde99@redhat.com>
 <55730c8c12a60453a8bdb1fc9f9dda0c43f01695.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <da884af8-771a-0eb0-41bc-24239ca3c34e@redhat.com>
Date:   Wed, 21 Jul 2021 21:42:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <55730c8c12a60453a8bdb1fc9f9dda0c43f01695.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/21/21 8:57 PM, Jeff Layton wrote:
> On Wed, 2021-07-21 at 19:54 +0800, Xiubo Li wrote:
>> On 7/21/21 7:23 PM, Jeff Layton wrote:
>>> On Wed, 2021-07-21 at 16:27 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> The delayed_work will be executed per 5 seconds, during this time
>>>> the cap_delay_list may accumulate thounsands of caps need to flush,
>>>> this will make the MDS's dispatch queue be full and need a very long
>>>> time to handle them. And if there has some other operations, likes
>>>> a rmdir request, it will be add in the tail of dispath queue and
>>>> need to wait for several or tens of seconds.
>>>>
>>>> In client side we shouldn't queue to many of the cap requests and
>>>> flush them if there has more than 100 items.
>>>>
>>> Why 100? My inclination is to say NAK on this.
>> This just from my test that around 100 client_caps requests queued will
>> work fine in most cases, which won't take too long to handle. Some times
>> the client will send thousands of requests in a short time, that will be
>> a problem.
> What may be a better approach is to figure out why we're holding on to
> so many caps and trying to flush them all at once. Maybe if we were to
> more aggressively flush sooner, we'd not end up with such a backlog?

Yeah, I am still working on this.

 From my analysis, some fixing or improvement like this will help reduce it:

commit e64f44a884657358812e6c057957be546db03cbe
Author: Xiubo Li <xiubli@redhat.com>
Date:   Wed May 27 09:09:27 2020 -0400

     ceph: skip checking caps when session reconnecting and releasing reqs

     It make no sense to check the caps when reconnecting to mds. And
     for the async dirop caps, they will be put by its _cb() function,
     so when releasing the requests, it will make no sense too.

 From the test result, it seems that some caps related requests were 
still pending in the cap_delay_list even after the rmdir requests were 
already sent out and finished for the previous directories. I am still 
confirming this.



>
>>> I'm not a fan of this sort of arbitrary throttling in order to alleviate
>>> a scalability problem in the MDS. The cap delay logic is already
>>> horrifically complex as well, and this just makes it worse. If the MDS
>>> happens to be processing requests from a lot of clients, this may not
>>> help at all.
>> Yeah, right, in that case the mds dispatch queue possibly will have more
>> in a short time.
>>
>>
>>>> URL: https://tracker.ceph.com/issues/51734
>>> The core problem sounds like the MDS got a call and just took way too
>>> long to get to it. Shouldn't we be addressing this in the MDS instead?
>>> It sounds like it needs to do a better job of parallelizing cap flushes.
>> The problem is that almost all the requests need to acquire the global
>> 'mds_lock', so the parallelizing won't improve much.
>>
> Yuck. That sounds like the root cause right there. For the record, I'm
> against papering over that with client patches.
>
>> Currently all the client side requests will have the priority of
>> CEPH_MSG_PRIO_DEFAULT:
>>
>> m->hdr.priority = cpu_to_le16(CEPH_MSG_PRIO_DEFAULT);
>>
>> Not sure whether can we just make the cap flushing request a lower
>> priority ? If this won't introduce other potential issue, that will work
>> because in the MDS dispatch queue it will handle high priority requests
>> first.
>>
> Tough call. You might mark it for lower priority, but then someone calls
> fsync() and suddenly you need it to finish sooner. I think that sort of
> change might backfire in some cases.

Yeah, I am also worrying about this.


>
> Usually when faced with this sort of issue, the right answer is to try
> to work ahead of the "spikes" in activity so that you don't have quite
> such a backlog when you do need to flush everything out. I'm not sure
> how possible that is here.
>
> One underlying issue may be that some of the client's background
> activity is currently driven by arbitrary timers (e.g. the delayed_work
> timer). When the timer pops, it suddenly has to do a bunch of work, when
> some of it could have been done earlier so that the load was spread out.
>
>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/caps.c       | 21 ++++++++++++++++++++-
>>>>    fs/ceph/mds_client.c |  3 ++-
>>>>    fs/ceph/mds_client.h |  3 +++
>>>>    3 files changed, 25 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>> index 4b966c29d9b5..064865761d2b 100644
>>>> --- a/fs/ceph/caps.c
>>>> +++ b/fs/ceph/caps.c
>>>> @@ -507,6 +507,8 @@ static void __cap_set_timeouts(struct ceph_mds_client *mdsc,
>>>>    static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
>>>>    				struct ceph_inode_info *ci)
>>>>    {
>>>> +	int num = 0;
>>>> +
>>>>    	dout("__cap_delay_requeue %p flags 0x%lx at %lu\n", &ci->vfs_inode,
>>>>    	     ci->i_ceph_flags, ci->i_hold_caps_max);
>>>>    	if (!mdsc->stopping) {
>>>> @@ -515,12 +517,19 @@ static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
>>>>    			if (ci->i_ceph_flags & CEPH_I_FLUSH)
>>>>    				goto no_change;
>>>>    			list_del_init(&ci->i_cap_delay_list);
>>>> +			mdsc->num_cap_delay--;
>>>>    		}
>>>>    		__cap_set_timeouts(mdsc, ci);
>>>>    		list_add_tail(&ci->i_cap_delay_list, &mdsc->cap_delay_list);
>>>> +		num = ++mdsc->num_cap_delay;
>>>>    no_change:
>>>>    		spin_unlock(&mdsc->cap_delay_lock);
>>>>    	}
>>>> +
>>>> +	if (num > 100) {
>>>> +		flush_delayed_work(&mdsc->delayed_work);
>>>> +		schedule_delayed(mdsc);
>>>> +	}
>>>>    }
>>>>    
>>>>    /*
>>>> @@ -531,13 +540,23 @@ static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
>>>>    static void __cap_delay_requeue_front(struct ceph_mds_client *mdsc,
>>>>    				      struct ceph_inode_info *ci)
>>>>    {
>>>> +	int num;
>>>> +
>>>>    	dout("__cap_delay_requeue_front %p\n", &ci->vfs_inode);
>>>>    	spin_lock(&mdsc->cap_delay_lock);
>>>>    	ci->i_ceph_flags |= CEPH_I_FLUSH;
>>>> -	if (!list_empty(&ci->i_cap_delay_list))
>>>> +	if (!list_empty(&ci->i_cap_delay_list)) {
>>>>    		list_del_init(&ci->i_cap_delay_list);
>>>> +		mdsc->num_cap_delay--;
>>>> +	}
>>>>    	list_add(&ci->i_cap_delay_list, &mdsc->cap_delay_list);
>>>> +	num = ++mdsc->num_cap_delay;
>>>>    	spin_unlock(&mdsc->cap_delay_lock);
>>>> +
>>>> +	if (num > 100) {
>>>> +		flush_delayed_work(&mdsc->delayed_work);
>>>> +		schedule_delayed(mdsc);
>>>> +	}
>>>>    }
>>>>    
>>>>    /*
>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>> index 79aa4ce3a388..14e44de05812 100644
>>>> --- a/fs/ceph/mds_client.c
>>>> +++ b/fs/ceph/mds_client.c
>>>> @@ -4514,7 +4514,7 @@ void inc_session_sequence(struct ceph_mds_session *s)
>>>>    /*
>>>>     * delayed work -- periodically trim expired leases, renew caps with mds
>>>>     */
>>>> -static void schedule_delayed(struct ceph_mds_client *mdsc)
>>>> +void schedule_delayed(struct ceph_mds_client *mdsc)
>>>>    {
>>>>    	int delay = 5;
>>>>    	unsigned hz = round_jiffies_relative(HZ * delay);
>>>> @@ -4616,6 +4616,7 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>>>>    	mdsc->request_tree = RB_ROOT;
>>>>    	INIT_DELAYED_WORK(&mdsc->delayed_work, delayed_work);
>>>>    	mdsc->last_renew_caps = jiffies;
>>>> +	mdsc->num_cap_delay = 0;
>>>>    	INIT_LIST_HEAD(&mdsc->cap_delay_list);
>>>>    	INIT_LIST_HEAD(&mdsc->cap_wait_list);
>>>>    	spin_lock_init(&mdsc->cap_delay_lock);
>>>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>>>> index a7af09257382..b4289b8d23ec 100644
>>>> --- a/fs/ceph/mds_client.h
>>>> +++ b/fs/ceph/mds_client.h
>>>> @@ -423,6 +423,7 @@ struct ceph_mds_client {
>>>>    	struct rb_root         request_tree;  /* pending mds requests */
>>>>    	struct delayed_work    delayed_work;  /* delayed work */
>>>>    	unsigned long    last_renew_caps;  /* last time we renewed our caps */
>>>> +	unsigned long    num_cap_delay;    /* caps in the cap_delay_list */
>>>>    	struct list_head cap_delay_list;   /* caps with delayed release */
>>>>    	spinlock_t       cap_delay_lock;   /* protects cap_delay_list */
>>>>    	struct list_head snap_flush_list;  /* cap_snaps ready to flush */
>>>> @@ -568,6 +569,8 @@ extern int ceph_trim_caps(struct ceph_mds_client *mdsc,
>>>>    			  struct ceph_mds_session *session,
>>>>    			  int max_caps);
>>>>    
>>>> +extern void schedule_delayed(struct ceph_mds_client *mdsc);
>>>> +
>>>>    static inline int ceph_wait_on_async_create(struct inode *inode)
>>>>    {
>>>>    	struct ceph_inode_info *ci = ceph_inode(inode);


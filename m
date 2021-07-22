Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758463D20FE
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Jul 2021 11:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhGVI4I (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 22 Jul 2021 04:56:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40266 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230232AbhGVI4I (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 22 Jul 2021 04:56:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626946603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vb0BUhpQdyjENZUWE67+C0eX67Y5m9BNJn9AjZ8nr04=;
        b=Df2F0jrseSkhOwZUk/revJ+LGQYDznVq4D/1To/uTIAKv2kBE0bJdMheB0c/5cW7aoP6s8
        /eHwhvc9cOniefAcPQkC5//POGGDSSPkzJ4eMlaHTsY3gbcBe02odYn1RO967wMz+yDPCC
        2tDaPcKgvqXj6y4JxRlBH4lycdZsFIM=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-9wQemnmrPceVxZVLK0-7QQ-1; Thu, 22 Jul 2021 05:36:42 -0400
X-MC-Unique: 9wQemnmrPceVxZVLK0-7QQ-1
Received: by mail-pl1-f199.google.com with SMTP id t10-20020a170902b20ab029011b9ceafaafso2469174plr.11
        for <ceph-devel@vger.kernel.org>; Thu, 22 Jul 2021 02:36:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=vb0BUhpQdyjENZUWE67+C0eX67Y5m9BNJn9AjZ8nr04=;
        b=f+drBalw2PnEC06ztXTHfBuxbcrFAXi5LPTSLwscz2XkPPnDU/Dg1nvT065/0GCtzE
         q+B+pdL9O7C4u0B3Pn9KtrW0SwSq798gjbsN++Cz//yv9Tp7uUTIGCExs2W9RgJuP0Z7
         SlRHjrD7Hjdd9GXpzq3GhmsrV/hGknF6MyZTHVIHx9E8eGGst7UQdDdaHX3feFXh64Cf
         DMxnCTJUTYvTeoeP12ot9ruXi6/tMuhhDQpc0nsfeEo2mg+IQkfcnQx9ntTFpqQp2SbE
         yRXcgWEdC3LD6hs8QCR/SBXV2HDpOHs5pKwCWBCzPAn9SdENef/LLf0GmRlY6NmeJzyH
         /IBQ==
X-Gm-Message-State: AOAM531EzIzLNRJUvpqRAOhDmrTIQ1UzAkqYYZiVBOvF4EEpbdGBL6pe
        pC+r0TvHRN9j/FEh5PaL0y10sMJZC7O6GPKZV1WcqmqA0/hBCtouoIgdI8PDAFT6GhvyTJ7IteT
        uwGJvzp3oPNDhbcavBxZda2m3sNOCc9++T+LbhjionIxJ2yj0WcANoBzvRfZcLhXv7QyglIc=
X-Received: by 2002:a17:903:22d0:b029:12b:1215:5e73 with SMTP id y16-20020a17090322d0b029012b12155e73mr31214320plg.60.1626946600576;
        Thu, 22 Jul 2021 02:36:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMLCnJAZgZjEwkoa5BHw58ZidnuVfLD84s8nz5rQhgjW05XOukKJncIggCoO14PXATUixphQ==
X-Received: by 2002:a17:903:22d0:b029:12b:1215:5e73 with SMTP id y16-20020a17090322d0b029012b12155e73mr31214292plg.60.1626946600128;
        Thu, 22 Jul 2021 02:36:40 -0700 (PDT)
Received: from [10.72.12.71] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t71sm9758569pgd.7.2021.07.22.02.36.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 02:36:39 -0700 (PDT)
Subject: Re: [PATCH RFC] ceph: flush the delayed caps in time
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210721082720.110202-1-xiubli@redhat.com>
 <a2ab96c71ac875bd98efef4f7cb4590fbfae3b82.camel@kernel.org>
 <072b68bd-cb8d-b6a6-cca5-4ca20cfcde99@redhat.com>
 <55730c8c12a60453a8bdb1fc9f9dda0c43f01695.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e4312917-5bd2-99f8-fb8d-d022ec2daedd@redhat.com>
Date:   Thu, 22 Jul 2021 17:36:34 +0800
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

  881912 Jul 22 10:36:14 lxbceph1 kernel: ceph:  00000000f7ee4ccf mode 
040755 uid.gid 0.0
  881913 Jul 22 10:36:14 lxbceph1 kernel: ceph:  size 0 -> 0
  881914 Jul 22 10:36:14 lxbceph1 kernel: ceph:  truncate_seq 0 -> 1
  881915 Jul 22 10:36:14 lxbceph1 kernel: ceph:  truncate_size 0 -> 
18446744073709551615
  881916 Jul 22 10:36:14 lxbceph1 kernel: ceph:  add_cap 
00000000f7ee4ccf mds0 cap 152d pAsxLsXsxFsx seq 1
  881917 Jul 22 10:36:14 lxbceph1 kernel: ceph:  lookup_snap_realm 1 
0000000095ff27ff
  881918 Jul 22 10:36:14 lxbceph1 kernel: ceph:  get_realm 
0000000095ff27ff 5421 -> 5422
  881919 Jul 22 10:36:14 lxbceph1 kernel: ceph:  __ceph_caps_issued 
00000000f7ee4ccf cap 000000003c8bc134 issued -
  881920 Jul 22 10:36:14 lxbceph1 kernel: ceph:   marking 
00000000f7ee4ccf NOT complete
  881921 Jul 22 10:36:14 lxbceph1 kernel: ceph:   issued pAsxLsXsxFsx, 
mds wanted -, actual -, queueing
  881922 Jul 22 10:36:14 lxbceph1 kernel: ceph:  __cap_set_timeouts 
00000000f7ee4ccf min 5036 max 60036
  881923 Jul 22 10:36:14 lxbceph1 kernel: ceph: __cap_delay_requeue 
00000000f7ee4ccf flags 0 at 4294896928
  881924 Jul 22 10:36:14 lxbceph1 kernel: ceph:  add_cap inode 
00000000f7ee4ccf (1000000152a.fffffffffffffffe) cap 000000003c8bc134 
pAsxLsXsxFsx now pAsxLsXsxFsx seq 1 mds0
  881925 Jul 22 10:36:14 lxbceph1 kernel: ceph:   marking 
00000000f7ee4ccf complete (empty)
  881926 Jul 22 10:36:14 lxbceph1 kernel: ceph:  dn 0000000079fd7e04 
attached to 00000000f7ee4ccf ino 1000000152a.fffffffffffffffe
  881927 Jul 22 10:36:14 lxbceph1 kernel: ceph: update_dentry_lease 
0000000079fd7e04 duration 30000 ms ttl 4294866888
  881928 Jul 22 10:36:14 lxbceph1 kernel: ceph:  dentry_lru_touch 
000000006fddf4b0 0000000079fd7e04 'removalC.test01806' (offset 0)


 From the kernel logs, some of these delayed caps are from previous 
thousands of 'mkdir' requests, after the mkdir requests get replied and 
when creating new caps, since the MDS has issued extra caps that they 
don't want, then these caps are added to the delay queue, and in 5 
seconds the delay list could accumulate up to several thousands of caps.

And most of them come from stale dentries.

So 5 seconds later when the delayed_queue is fired, all this client_caps 
requests are queued in the MDS dispatch queue.

The following commit could improve the performance very much:

commit 37c4efc1ddf98ba8b234d116d863a9464445901e
Author: Yan, Zheng <zyan@redhat.com>
Date:   Thu Jan 31 16:55:51 2019 +0800

     ceph: periodically trim stale dentries

     Previous commit make VFS delete stale dentry when last reference is
     dropped. Lease also can become invalid when corresponding dentry has
     no reference. This patch make cephfs periodically scan lease list,
     delete corresponding dentry if lease is invalid.

     There are two types of lease, dentry lease and dir lease. dentry lease
     has life time and applies to singe dentry. Dentry lease is added to 
tail
     of a list when it's updated, leases at front of the list will expire
     first. Dir lease is CEPH_CAP_FILE_SHARED on directory inode, it applies
     to all dentries in the directory. Dentries have dir leases are added to
     another list. Dentries in the list are periodically checked in a round
     robin manner.

With this commit, it will take 3~4 minutes to finish my test:

real    3m33.998s
user    0m0.644s
sys    0m2.341s
[1]   Done                    ( cd /mnt/kcephfs.$i && time strace -Tv -o 
~/removal${i}.log -- rm -rf removal$i* )
real    3m34.028s
user    0m0.620s
sys    0m2.342s
[2]-  Done                    ( cd /mnt/kcephfs.$i && time strace -Tv -o 
~/removal${i}.log -- rm -rf removal$i* )
real    3m34.049s
user    0m0.638s
sys    0m2.315s
[3]+  Done                    ( cd /mnt/kcephfs.$i && time strace -Tv -o 
~/removal${i}.log -- rm -rf removal$i* )

Without this it will take more than 12 minutes for above 3 'rm' threads.

Thanks.





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


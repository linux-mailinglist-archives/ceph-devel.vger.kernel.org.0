Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5D63F0410
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 14:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbhHRM7L (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 08:59:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36601 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233634AbhHRM7I (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 08:59:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629291513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GbJ5RtS3mZZStZDIhP81jrL+6qmuwlP7pNwlTNUqn4Y=;
        b=FV9r+gtOdPv4uA9OolTCag8WHA9Aln2QZdhOAQnidEWd01u3aDRCLgNipvx+SIEQBfhFFb
        TFAvdlLqa3AOgcjnGxz38rf7t+DUKqjKDnFTmPWXHEVhA43CT+YH6mgSLDkcd1cNS6TtzQ
        eZqpxUiUgzK+uqiz2YrmA4M+NKvkZbQ=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-gh2r_shZM3Wy5RSHgSGl8Q-1; Wed, 18 Aug 2021 08:58:32 -0400
X-MC-Unique: gh2r_shZM3Wy5RSHgSGl8Q-1
Received: by mail-pj1-f69.google.com with SMTP id v3-20020a17090ac903b029017912733966so4655033pjt.2
        for <ceph-devel@vger.kernel.org>; Wed, 18 Aug 2021 05:58:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=GbJ5RtS3mZZStZDIhP81jrL+6qmuwlP7pNwlTNUqn4Y=;
        b=m5KBn0GS0MNxElFSUS/PcY6vln2MR0IyFP8pVyjocw+Ef1PfZtwfiTEGVzt+ZD1kEh
         PSPQFxULeA3pVJ5lgtX6PqFXbDUCSnb8scuAYopJzcVE5uybc235tUedI6zwsjsq/OpE
         aGdH8+cxTGQRItCkfkcthnoSuqopsc4hkOWaqKgHYhZuXyL6Khm94/MO8h3eWqllSLXX
         2P15oSFY531g24GwEWvSbgd10SAVlgSNSOcHLO5PyibHNx01wBh4fFtZUxFNjG1tTCjX
         tdd54GuaTUkjyUNv3+GstD80O565g1osZXhPHq/vIsDbLq4braHNTxb4y+n4rq/BZL+c
         nyeg==
X-Gm-Message-State: AOAM533qKu0jolGdRbVZO728jtxRrDH92YbfVMASdYZkqiETlzxH12HC
        Vs4X2yL7mQ0vOTkh9p3yrqgsqpQ8W95wqd8Yv0dkktvj/TrcqleyqmZ8CtV3Whv6dPgVowCPFfj
        Cupi/+0VOjKJPsJKVH0uFP7stP4ye0VbcNxLqs02ufQHBUUA1B6wdK9Pf/KgoG2S9nNlfZys=
X-Received: by 2002:aa7:8653:0:b0:3e2:edf3:60d with SMTP id a19-20020aa78653000000b003e2edf3060dmr2473111pfo.36.1629291510826;
        Wed, 18 Aug 2021 05:58:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTaxlMcFei99R9X+tPTKmb6Qu532SZpcHcfRHctDBfyeWzIFpjcA7Z9uB/9ds8elgTJMlniw==
X-Received: by 2002:aa7:8653:0:b0:3e2:edf3:60d with SMTP id a19-20020aa78653000000b003e2edf3060dmr2473085pfo.36.1629291510510;
        Wed, 18 Aug 2021 05:58:30 -0700 (PDT)
Received: from [10.72.12.133] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o24sm5385585pjs.49.2021.08.18.05.58.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 05:58:30 -0700 (PDT)
Subject: Re: [PATCH v3] ceph: correctly release memory from capsnap
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20210818012515.64564-1-xiubli@redhat.com>
 <CAOi1vP96mWo_pOyRX__t6gNhPofdY_HTqe+b8ekM40vjoEmShg@mail.gmail.com>
 <b4209c59c4ab68b7f98e32f82a900aabd888aebb.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0de93788-0f2b-aebb-9808-35dd6e9870f8@redhat.com>
Date:   Wed, 18 Aug 2021 20:58:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <b4209c59c4ab68b7f98e32f82a900aabd888aebb.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/18/21 8:41 PM, Jeff Layton wrote:
> On Wed, 2021-08-18 at 13:18 +0200, Ilya Dryomov wrote:
>> On Wed, Aug 18, 2021 at 3:25 AM <xiubli@redhat.com> wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> When force umounting, it will try to remove all the session caps.
>>> If there has any capsnap is in the flushing list, the remove session
>>> caps callback will try to release the capsnap->flush_cap memory to
>>> "ceph_cap_flush_cachep" slab cache, while which is allocated from
>>> kmalloc-256 slab cache.
>>>
>>> At the same time switch to list_del_init() because just in case the
>>> force umount has removed it from the lists and the
>>> handle_cap_flushsnap_ack() comes then the seconds list_del_init()
>>> won't crash the kernel.
>>>
>>> URL: https://tracker.ceph.com/issues/52283
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>
>>> V3:
>>> - rebase to the upstream
>>>
>>>
>>>   fs/ceph/caps.c       | 18 ++++++++++++++----
>>>   fs/ceph/mds_client.c |  7 ++++---
>>>   2 files changed, 18 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>> index 1b9ca437da92..e239f06babbc 100644
>>> --- a/fs/ceph/caps.c
>>> +++ b/fs/ceph/caps.c
>>> @@ -1712,7 +1712,16 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
>>>
>>>   struct ceph_cap_flush *ceph_alloc_cap_flush(void)
>>>   {
>>> -       return kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
>>> +       struct ceph_cap_flush *cf;
>>> +
>>> +       cf = kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
>>> +       /*
>>> +        * caps == 0 always means for the capsnap
>>> +        * caps > 0 means dirty caps being flushed
>>> +        * caps == -1 means preallocated, not used yet
>>> +        */
>> Hi Xiubo,
>>
>> This comment should be in super.h, on struct ceph_cap_flush
>> definition.
>>
>> But more importantly, are you sure that overloading cf->caps this way
>> is safe?  For example, __kick_flushing_caps() tests for cf->caps != 0
>> and cf->caps == -1 would be interpreted as a cue to call __prep_cap().
>>
>> Thanks,
>>
>>                  Ilya
>>
> The cf->caps field should get set to a sane value when it goes onto the
> i_cap_flush_list, and I don't see how we'd get into testing against the
> ->caps field before that point. That said, this mechanism does seem a
> bit fragile and subject to later breakage, and the caps code is anything
> but clear and easy to follow.
>
> pahole says that there is a 3 byte hole just after the "wake" field in
> ceph_cap_flush on x86_64, and that's probably true on other arches as
> well. Rather than overloading the caps field with this info, you could
> add a new bool there to indicate whether it's embedded or not.

Okay, this also sounds good to me.

I will do that and sent out the V4 later.

Thanks


>
>>> +       cf->caps = -1;
>>> +       return cf;
>>>   }
>>>
>>>   void ceph_free_cap_flush(struct ceph_cap_flush *cf)
>>> @@ -1747,7 +1756,7 @@ static bool __detach_cap_flush_from_mdsc(struct ceph_mds_client *mdsc,
>>>                  prev->wake = true;
>>>                  wake = false;
>>>          }
>>> -       list_del(&cf->g_list);
>>> +       list_del_init(&cf->g_list);
>>>          return wake;
>>>   }
>>>
>>> @@ -1762,7 +1771,7 @@ static bool __detach_cap_flush_from_ci(struct ceph_inode_info *ci,
>>>                  prev->wake = true;
>>>                  wake = false;
>>>          }
>>> -       list_del(&cf->i_list);
>>> +       list_del_init(&cf->i_list);
>>>          return wake;
>>>   }
>>>
>>> @@ -3642,7 +3651,8 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
>>>                  cf = list_first_entry(&to_remove,
>>>                                        struct ceph_cap_flush, i_list);
>>>                  list_del(&cf->i_list);
>>> -               ceph_free_cap_flush(cf);
>>> +               if (cf->caps)
>>> +                       ceph_free_cap_flush(cf);
>>>          }
>>>
>>>          if (wake_ci)
>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>> index 1e013fb09d73..a44adbd1841b 100644
>>> --- a/fs/ceph/mds_client.c
>>> +++ b/fs/ceph/mds_client.c
>>> @@ -1636,7 +1636,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>>                  spin_lock(&mdsc->cap_dirty_lock);
>>>
>>>                  list_for_each_entry(cf, &to_remove, i_list)
>>> -                       list_del(&cf->g_list);
>>> +                       list_del_init(&cf->g_list);
>>>
>>>                  if (!list_empty(&ci->i_dirty_item)) {
>>>                          pr_warn_ratelimited(
>>> @@ -1688,8 +1688,9 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>>                  struct ceph_cap_flush *cf;
>>>                  cf = list_first_entry(&to_remove,
>>>                                        struct ceph_cap_flush, i_list);
>>> -               list_del(&cf->i_list);
>>> -               ceph_free_cap_flush(cf);
>>> +               list_del_init(&cf->i_list);
>>> +               if (cf->caps)
>>> +                       ceph_free_cap_flush(cf);
>>>          }
>>>
>>>          wake_up_all(&ci->i_cap_wq);
>>> --
>>> 2.27.0
>>>


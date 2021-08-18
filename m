Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50DD53F03D0
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 14:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235731AbhHRMkW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 08:40:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234948AbhHRMkU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 08:40:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629290383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hnAjFLemqygjlmpMlpTX+43i6v2QTY9szGyOXTcZVOI=;
        b=foQ87BUDJOoezvTytHmYultVZKuRg7pxz+egyv1s92yF10qToV8siiqYScADhkwHP0hWeq
        HcVEL5scvcPVLrLjmMBKl//4y3YqAhNXKd23Hu8UNMUpJ121Ds9JUua2SUpivcuhBOuN2P
        LENttcSK07WrB4hiDE+F36he2DqIjVM=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-c9S4-tWZNjiFZteBGsWCwg-1; Wed, 18 Aug 2021 08:39:43 -0400
X-MC-Unique: c9S4-tWZNjiFZteBGsWCwg-1
Received: by mail-pg1-f198.google.com with SMTP id 1-20020a630e41000000b002528846c9f2so1353806pgo.12
        for <ceph-devel@vger.kernel.org>; Wed, 18 Aug 2021 05:39:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hnAjFLemqygjlmpMlpTX+43i6v2QTY9szGyOXTcZVOI=;
        b=VYGum3uywkoofdL8qKF8oRXSJYHS7C+Y+DBh07rk+OL1n2IlklwlUA8LyHvNc9FsJn
         J/dQ4MR1L4Udby6vQIo4pRzSZwAx3UFv7ADeBJyLgyPaqVC1fLfhdUjwD+ER/z7gOlYG
         Ae/NsKFQtKH5maUyA69QG67ODrklZjNvBxNd7FLuwJoVGPN+9LA4JdG64V7PZBr0doUZ
         YLB11ZKKyo1NbAwavHcQisd5rMEGW4T4t04hdDM+kREzq90WWxdFoHEh5g2+fks8AX+V
         GxNv47dqjZnp3/S4zI3bQCxeQMFHs+rFeP1BXkiQwjUa+dszWZltCzKB0ukLyY2do2Tm
         5osQ==
X-Gm-Message-State: AOAM5336OrXK2ir3UDUNLyvho7OXVQ6U5+LDHfg+S6JcNuf32zcRDsjr
        +9As4SDq+5nLd8/LcBxseTU0OpiuoyJ3oaPtDayADkGO5KANZkFZSggFmyveU014Cud558TsIFO
        MqboWeLXDi8jJ6lwskU3cwy7dt4cMGjLT2xW1+L0mNDe3nDB4iorPhxBCnZzvs1hnYk5bvww=
X-Received: by 2002:a65:670f:: with SMTP id u15mr8652442pgf.205.1629290381784;
        Wed, 18 Aug 2021 05:39:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/F1L54jRhSq4ys1RV3EQJZcsN0Fa/oPqdQNKt8ysIEDoCZRG7Arqp9uPz1ER/7pVlbgnyjA==
X-Received: by 2002:a65:670f:: with SMTP id u15mr8652425pgf.205.1629290381520;
        Wed, 18 Aug 2021 05:39:41 -0700 (PDT)
Received: from [10.72.12.44] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z8sm6311445pfa.113.2021.08.18.05.39.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 05:39:41 -0700 (PDT)
Subject: Re: [PATCH v3] ceph: correctly release memory from capsnap
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20210818012515.64564-1-xiubli@redhat.com>
 <CAOi1vP96mWo_pOyRX__t6gNhPofdY_HTqe+b8ekM40vjoEmShg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c81d217b-622f-51ff-46c5-2283bd9aa960@redhat.com>
Date:   Wed, 18 Aug 2021 20:39:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP96mWo_pOyRX__t6gNhPofdY_HTqe+b8ekM40vjoEmShg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/18/21 7:18 PM, Ilya Dryomov wrote:
> On Wed, Aug 18, 2021 at 3:25 AM <xiubli@redhat.com> wrote:
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
>> V3:
>> - rebase to the upstream
>>
>>
>>   fs/ceph/caps.c       | 18 ++++++++++++++----
>>   fs/ceph/mds_client.c |  7 ++++---
>>   2 files changed, 18 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 1b9ca437da92..e239f06babbc 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -1712,7 +1712,16 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
>>
>>   struct ceph_cap_flush *ceph_alloc_cap_flush(void)
>>   {
>> -       return kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
>> +       struct ceph_cap_flush *cf;
>> +
>> +       cf = kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
>> +       /*
>> +        * caps == 0 always means for the capsnap
>> +        * caps > 0 means dirty caps being flushed
>> +        * caps == -1 means preallocated, not used yet
>> +        */
> Hi Xiubo,
>
> This comment should be in super.h, on struct ceph_cap_flush
> definition.
>
> But more importantly, are you sure that overloading cf->caps this way
> is safe?  For example, __kick_flushing_caps() tests for cf->caps != 0
> and cf->caps == -1 would be interpreted as a cue to call __prep_cap().

Hi Ilya,

Yeah, I think it's safe, because once the cf is added into the 
ci->i_cap_flush_list in __mark_caps_flushing(), it will be guaranteed 
that the cf->caps will be set some dirty caps, which must be > 0 or it 
will trigger BUG_ON().

Here in this patch in remove_session_caps_cb() below, the to_remove list 
will not only pick cf from ci->i_cap_flush_list but also from the 
ci->i_prealloc_cap_flush, which hasn't been initialized and added to the 
ci->i_cap_flush_list yet.

Thanks

BRs


>
> Thanks,
>
>                  Ilya
>
>> +       cf->caps = -1;
>> +       return cf;
>>   }
>>
>>   void ceph_free_cap_flush(struct ceph_cap_flush *cf)
>> @@ -1747,7 +1756,7 @@ static bool __detach_cap_flush_from_mdsc(struct ceph_mds_client *mdsc,
>>                  prev->wake = true;
>>                  wake = false;
>>          }
>> -       list_del(&cf->g_list);
>> +       list_del_init(&cf->g_list);
>>          return wake;
>>   }
>>
>> @@ -1762,7 +1771,7 @@ static bool __detach_cap_flush_from_ci(struct ceph_inode_info *ci,
>>                  prev->wake = true;
>>                  wake = false;
>>          }
>> -       list_del(&cf->i_list);
>> +       list_del_init(&cf->i_list);
>>          return wake;
>>   }
>>
>> @@ -3642,7 +3651,8 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
>>                  cf = list_first_entry(&to_remove,
>>                                        struct ceph_cap_flush, i_list);
>>                  list_del(&cf->i_list);
>> -               ceph_free_cap_flush(cf);
>> +               if (cf->caps)
>> +                       ceph_free_cap_flush(cf);
>>          }
>>
>>          if (wake_ci)
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 1e013fb09d73..a44adbd1841b 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -1636,7 +1636,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>                  spin_lock(&mdsc->cap_dirty_lock);
>>
>>                  list_for_each_entry(cf, &to_remove, i_list)
>> -                       list_del(&cf->g_list);
>> +                       list_del_init(&cf->g_list);
>>
>>                  if (!list_empty(&ci->i_dirty_item)) {
>>                          pr_warn_ratelimited(
>> @@ -1688,8 +1688,9 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>                  struct ceph_cap_flush *cf;
>>                  cf = list_first_entry(&to_remove,
>>                                        struct ceph_cap_flush, i_list);
>> -               list_del(&cf->i_list);
>> -               ceph_free_cap_flush(cf);
>> +               list_del_init(&cf->i_list);
>> +               if (cf->caps)
>> +                       ceph_free_cap_flush(cf);
>>          }
>>
>>          wake_up_all(&ci->i_cap_wq);
>> --
>> 2.27.0
>>


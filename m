Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC1B6E874B
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Apr 2023 03:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbjDTBO6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Apr 2023 21:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbjDTBO4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Apr 2023 21:14:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAC0D8
        for <ceph-devel@vger.kernel.org>; Wed, 19 Apr 2023 18:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681953250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7XVCvmRPit900z+QjOlBzTUwvEXe9E0Kdsol8E7jXzQ=;
        b=dG8w2kZiUOMQttfTdfOD2KEQ65J1CQIORpCyn5lU9yTSerU8SUrb0LVyrDg0jUJqt1sxT3
        Wq+9/gQEY5zD+mcPbOwwwZF0bVfxm7CwfuO+PAub7peEz0Eo/cfgN/mQsa9KG0MUFx2rkq
        BZFvJUA7eds9h3GlPSTdcUq2bN2CF8A=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-JjJx2wKSOhqRt37G7v0mGA-1; Wed, 19 Apr 2023 21:14:09 -0400
X-MC-Unique: JjJx2wKSOhqRt37G7v0mGA-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-63d30b08700so2212610b3a.1
        for <ceph-devel@vger.kernel.org>; Wed, 19 Apr 2023 18:14:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681953248; x=1684545248;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7XVCvmRPit900z+QjOlBzTUwvEXe9E0Kdsol8E7jXzQ=;
        b=EW/o7wBNi0D5Iwu05XKvZ6Xgv8G3SzkWcdEBVOE1jL9olLW/rIMFjZKRDsZb8JLGMH
         X1S91keYg75u76y4GTE1lLF/08mjFla6Jh1875N6bAPinpIDPCoH3eGm19zs0uu3SpQB
         9FerHMoOX9DZPqPsirdxZWhYyNOjgrcFEy5n/v9AazX5pyywxENeK6noyZiF6dG5Z1GM
         3ELqVGcidLdrtU1sOd4LuJoqXu7ramkxkLbBogzvSkfT/rs5iVd/9xoRoJ4JS9wyDrij
         ZNENQzODEmgoCStvlIUWwrsvyft7awZ5lji71spQYtoLgQ9DAJh6Rd7dN6W2jmg9owa8
         lzzg==
X-Gm-Message-State: AAQBX9dLEUY7CuQe6Sdoj+QmurP98ukgt9cRKdkbMsZW65ebPfga+E8H
        xNYEEd5NupCgi9DIl8ApXi/uw8uVTqmuItnWn4h0/AsHgEGe5Xg3kyEl1o0dppmoO7EaKYqi26e
        1CCMMQFtrTBKdv+Z0pjmyNw==
X-Received: by 2002:a17:902:ceca:b0:1a6:8527:8e0f with SMTP id d10-20020a170902ceca00b001a685278e0fmr4945341plg.10.1681953248114;
        Wed, 19 Apr 2023 18:14:08 -0700 (PDT)
X-Google-Smtp-Source: AKy350Yt5woG/7dSpx2NzmXB56IpjhXPvL1jdNYT5qub0b73QVwC7EglrGMdVSjrT40Ld5QwbA9GAw==
X-Received: by 2002:a17:902:ceca:b0:1a6:8527:8e0f with SMTP id d10-20020a170902ceca00b001a685278e0fmr4945317plg.10.1681953247782;
        Wed, 19 Apr 2023 18:14:07 -0700 (PDT)
Received: from [10.72.12.132] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t1-20020a1709028c8100b001a80d7c6954sm53219plo.288.2023.04.19.18.14.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 18:14:07 -0700 (PDT)
Message-ID: <346282c2-6ea8-b19c-07bf-133ef228e988@redhat.com>
Date:   Thu, 20 Apr 2023 09:14:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v3] ceph: fix potential use-after-free bug when trimming
 caps
Content-Language: en-US
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
References: <20230418014506.95428-1-xiubli@redhat.com>
 <877cu9w9ti.fsf@brahms.olymp>
 <008bc17d-d5fb-107e-4405-ebacc1568890@redhat.com>
 <87r0sgt39x.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <87r0sgt39x.fsf@brahms.olymp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/19/23 21:22, Luís Henriques wrote:
> Xiubo Li <xiubli@redhat.com> writes:
>
>> On 4/18/23 22:20, Luís Henriques wrote:
>>> xiubli@redhat.com writes:
>>>
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> When trimming the caps and just after the 'session->s_cap_lock' is
>>>> released in ceph_iterate_session_caps() the cap maybe removed by
>>>> another thread, and when using the stale cap memory in the callbacks
>>>> it will trigger use-after-free crash.
>>>>
>>>> We need to check the existence of the cap just after the 'ci->i_ceph_lock'
>>>> being acquired. And do nothing if it's already removed.
>>> Your patch seems to be OK, but I'll be honest: the locking is *so* complex
>>> that I can say for sure it really solves any problem :-(
>>>
>>> ceph_put_cap() uses mdsc->caps_list_lock to protect the list, but I can't
>>> be sure that holding ci->i_ceph_lock will protect a race in the case
>>> you're trying to solve.
>> The 'mdsc->caps_list_lock' will protect the members in mdsc:
>>
>>          /*
>>           * Cap reservations
>>           *
>>           * Maintain a global pool of preallocated struct ceph_caps, referenced
>>           * by struct ceph_caps_reservations.  This ensures that we preallocate
>>           * memory needed to successfully process an MDS response. (If an MDS
>>           * sends us cap information and we fail to process it, we will have
>>           * problems due to the client and MDS being out of sync.)
>>           *
>>           * Reservations are 'owned' by a ceph_cap_reservation context.
>>           */
>>          spinlock_t      caps_list_lock;
>>          struct          list_head caps_list; /* unused (reserved or
>>                                                  unreserved) */
>>          struct          list_head cap_wait_list;
>>          int             caps_total_count;    /* total caps allocated */
>>          int             caps_use_count;      /* in use */
>>          int             caps_use_max;        /* max used caps */
>>          int             caps_reserve_count;  /* unused, reserved */
>>          int             caps_avail_count;    /* unused, unreserved */
>>          int             caps_min_count;      /* keep at least this many
>>
>> Not protecting the cap list in session or inode.
>>
>>
>> And the racy is between the session's cap list and inode's cap rbtree and both
>> are holding the same 'cap' reference.
>>
>> So in 'ceph_iterate_session_caps()' after getting the 'cap' and releasing the
>> 'session->s_cap_lock', just before passing the 'cap' to _cb() another thread
>> could continue and release the 'cap'. Then the 'cap' should be stale now and
>> after being passed to _cb() the 'cap' when dereferencing it will crash the
>> kernel.
>>
>> And if the 'cap' is stale, it shouldn't exist in the inode's cap rbtree. Please
>> note the lock order will be:
>>
>> 1, spin_lock(&ci->i_ceph_lock)
>>
>> 2, spin_lock(&session->s_cap_lock)
>>
>>
>> Before:
>>
>> ThreadA: ThreadB:
>>
>> __ceph_remove_caps() -->
>>
>>      spin_lock(&ci->i_ceph_lock)
>>
>>      ceph_remove_cap() --> ceph_iterate_session_caps() -->
>>
>>          __ceph_remove_cap() --> spin_lock(&session->s_cap_lock);
>>
>> cap = list_entry(p, struct ceph_cap, session_caps);
>>
>> spin_unlock(&session->s_cap_lock);
>>
>>              spin_lock(&session->s_cap_lock);
>>
>>              // remove it from the session's cap list
>>
>>              list_del_init(&cap->session_caps);
>>
>>              spin_unlock(&session->s_cap_lock);
>>
>>              ceph_put_cap()
>>
>> trim_caps_cb('cap') -->   // the _cb() could be deferred after ThreadA finished
>> 'ceph_put_cap()'
>>
>> spin_unlock(&ci->i_ceph_lock) dreference cap->xxx will trigger crash
>>
>>
>>
>> With this patch:
>>
>> ThreadA: ThreadB:
>>
>> __ceph_remove_caps() -->
>>
>>      spin_lock(&ci->i_ceph_lock)
>>
>>      ceph_remove_cap() --> ceph_iterate_session_caps() -->
>>
>>          __ceph_remove_cap() --> spin_lock(&session->s_cap_lock);
>>
>> cap = list_entry(p, struct ceph_cap, session_caps);
>>
>> ci_node = &cap->ci_node;
>>
>> spin_unlock(&session->s_cap_lock);
>>
>>              spin_lock(&session->s_cap_lock);
>>
>>              // remove it from the session's cap list
>>
>>              list_del_init(&cap->session_caps);
>>
>>              spin_unlock(&session->s_cap_lock);
>>
>>              ceph_put_cap()
>>
>> trim_caps_cb('ci_node') -->
>>
>> spin_unlock(&ci->i_ceph_lock)
>>
>> spin_lock(&ci->i_ceph_lock)
>>
>> cap = rb_entry(ci_node, struct ceph_cap, ci_node);    // This is buggy in this
>> version, we should use the 'mds' instead and I will fix it.
>>
>> if (!cap)  { release the spin lock and return directly }
>>
>> spin_unlock(&ci->i_ceph_lock)
> Thanks a lot for taking the time to explain all of this.  Much
> appreciated.  It all seems to make sense, and, again, I don't have any
> real objection to your patch.  It's just that I still find the whole
> locking to be too complex, and every change that is made to it looks like
> walking on a mine field :-)

Yeah, it's very complex for the locking in this case, this is why I 
generated one false v1 patch, which fixed nothing :-(

Thanks Luis for your feedback and it helped me a lot to find the bug in V3.

- Xiubo

>
>> While we should switch to use the 'mds' of the cap instead of the 'ci_node',
>> which is buggy. I will fix it in next version.
> Yeah, I've took a quick look at v4 and it looks like it fixes this.
>
>>> Is the issue in that bugzilla reproducible, or was that a one-time thing?
>> No, I don't think so. Locally I have tried by turning the mds options to trigger
>> the cap reclaiming more frequently, but still couldn't reproduce it. It should
>> be very corner case.
> Yeah, too bad.  It would help to gain some extra confidence on the patch.
>
> Cheers,


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B286E711E
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Apr 2023 04:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjDSC3G (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Apr 2023 22:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbjDSC3F (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Apr 2023 22:29:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F443A92
        for <ceph-devel@vger.kernel.org>; Tue, 18 Apr 2023 19:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681871299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iYE8v9vdk38kqwJcRkm8e7sfoLIoXWTzCCR8k6I2pj0=;
        b=fqpqjqJTmX65/rS80s/0SUI1hAwOuGdl8z/mObFeHqxghvP0jzSQ3tXgeYFeJLCoe7lfXH
        JLvzjsavn6oU6WwYXwRgDtc/65qi9HMJB+ZMliYgsqTU9eBgVPO8QAbYheQEey62qBXSgM
        aQNUbKnxT05U6Xn+1lPw8scQ4FOBMC8=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-x_xlWOtxMz-Au6SMQWGHOw-1; Tue, 18 Apr 2023 22:28:18 -0400
X-MC-Unique: x_xlWOtxMz-Au6SMQWGHOw-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-63b679e4c09so1667156b3a.0
        for <ceph-devel@vger.kernel.org>; Tue, 18 Apr 2023 19:28:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681871297; x=1684463297;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iYE8v9vdk38kqwJcRkm8e7sfoLIoXWTzCCR8k6I2pj0=;
        b=b9Xocn0YE+vGRsdTFCSGFUS2EVmlfGK564S3aMJ+P+yi1CtN+kLKrzPuQM9LBoBj14
         0/bnqjaGLxPwEslGH+Fji/eO81o4FDAKGDS5GOhKYidyLQkXSf+da+29oRShiI2r+XN+
         x2rPpPGwbMMQ1KPEDghh+Ctc+K/WOjz7RL0MqWSIyos+8/FC4JjDs1iR4KWglEm7DKyD
         a95SowzmSsD+5fm6WIWEQgbYQO9FEn5eog89sr0AfVvLLxEiVXtERqAlkudyBmjGIO5x
         0i5ySxJiBkKb9eF46M1VYa1P+vUk9FtdGa8UgcI6GJAC1n9rJQgzLPO3cTnVGN5IYkQW
         B3zg==
X-Gm-Message-State: AAQBX9doViB2aNHfaZvJQl7MqnqYgol35Wyy3ziseeDCYLKktojf81xN
        PaW9ExapF7rG7titN+jhbjF0eJ+od4ms0ldKd3PiLJVnIomWKPryUs9UnS324YLFu6mXQKZPmie
        ZAdhctgT4qa2MvnkVse/SqTTD9gL2Q2DtizA=
X-Received: by 2002:a05:6a00:2392:b0:623:5880:98cd with SMTP id f18-20020a056a00239200b00623588098cdmr2053343pfc.5.1681871296915;
        Tue, 18 Apr 2023 19:28:16 -0700 (PDT)
X-Google-Smtp-Source: AKy350bvxCS4LaVNEpZG8QkWJFXeq2iq3wFkTtD2+va9XLRH1LqyjD9zDPSad4l37ZevXykHZEB9kA==
X-Received: by 2002:a05:6a00:2392:b0:623:5880:98cd with SMTP id f18-20020a056a00239200b00623588098cdmr2053321pfc.5.1681871296486;
        Tue, 18 Apr 2023 19:28:16 -0700 (PDT)
Received: from [10.72.12.132] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q20-20020a62e114000000b0063b17b58822sm6156619pfh.74.2023.04.18.19.28.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 19:28:15 -0700 (PDT)
Message-ID: <008bc17d-d5fb-107e-4405-ebacc1568890@redhat.com>
Date:   Wed, 19 Apr 2023 10:28:11 +0800
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
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <877cu9w9ti.fsf@brahms.olymp>
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


On 4/18/23 22:20, Luís Henriques wrote:
> xiubli@redhat.com writes:
>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When trimming the caps and just after the 'session->s_cap_lock' is
>> released in ceph_iterate_session_caps() the cap maybe removed by
>> another thread, and when using the stale cap memory in the callbacks
>> it will trigger use-after-free crash.
>>
>> We need to check the existence of the cap just after the 'ci->i_ceph_lock'
>> being acquired. And do nothing if it's already removed.
> Your patch seems to be OK, but I'll be honest: the locking is *so* complex
> that I can say for sure it really solves any problem :-(
>
> ceph_put_cap() uses mdsc->caps_list_lock to protect the list, but I can't
> be sure that holding ci->i_ceph_lock will protect a race in the case
> you're trying to solve.

The 'mdsc->caps_list_lock' will protect the members in mdsc:

         /*
          * Cap reservations
          *
          * Maintain a global pool of preallocated struct ceph_caps, 
referenced
          * by struct ceph_caps_reservations.  This ensures that we 
preallocate
          * memory needed to successfully process an MDS response. (If 
an MDS
          * sends us cap information and we fail to process it, we will have
          * problems due to the client and MDS being out of sync.)
          *
          * Reservations are 'owned' by a ceph_cap_reservation context.
          */
         spinlock_t      caps_list_lock;
         struct          list_head caps_list; /* unused (reserved or
                                                 unreserved) */
         struct          list_head cap_wait_list;
         int             caps_total_count;    /* total caps allocated */
         int             caps_use_count;      /* in use */
         int             caps_use_max;        /* max used caps */
         int             caps_reserve_count;  /* unused, reserved */
         int             caps_avail_count;    /* unused, unreserved */
         int             caps_min_count;      /* keep at least this many

Not protecting the cap list in session or inode.


And the racy is between the session's cap list and inode's cap rbtree 
and both are holding the same 'cap' reference.

So in 'ceph_iterate_session_caps()' after getting the 'cap' and 
releasing the 'session->s_cap_lock', just before passing the 'cap' to 
_cb() another thread could continue and release the 'cap'. Then the 
'cap' should be stale now and after being passed to _cb() the 'cap' when 
dereferencing it will crash the kernel.

And if the 'cap' is stale, it shouldn't exist in the inode's cap rbtree. 
Please note the lock order will be:

1, spin_lock(&ci->i_ceph_lock)

2, spin_lock(&session->s_cap_lock)


Before:

ThreadA: ThreadB:

__ceph_remove_caps() -->

     spin_lock(&ci->i_ceph_lock)

     ceph_remove_cap() --> ceph_iterate_session_caps() -->

         __ceph_remove_cap() --> spin_lock(&session->s_cap_lock);

cap = list_entry(p, struct ceph_cap, session_caps);

spin_unlock(&session->s_cap_lock);

             spin_lock(&session->s_cap_lock);

             // remove it from the session's cap list

             list_del_init(&cap->session_caps);

             spin_unlock(&session->s_cap_lock);

             ceph_put_cap()

trim_caps_cb('cap') -->   // the _cb() could be deferred after ThreadA 
finished 'ceph_put_cap()'

spin_unlock(&ci->i_ceph_lock) dreference cap->xxx will trigger crash



With this patch:

ThreadA: ThreadB:

__ceph_remove_caps() -->

     spin_lock(&ci->i_ceph_lock)

     ceph_remove_cap() --> ceph_iterate_session_caps() -->

         __ceph_remove_cap() --> spin_lock(&session->s_cap_lock);

cap = list_entry(p, struct ceph_cap, session_caps);

ci_node = &cap->ci_node;

spin_unlock(&session->s_cap_lock);

             spin_lock(&session->s_cap_lock);

             // remove it from the session's cap list

             list_del_init(&cap->session_caps);

             spin_unlock(&session->s_cap_lock);

             ceph_put_cap()

trim_caps_cb('ci_node') -->

spin_unlock(&ci->i_ceph_lock)

spin_lock(&ci->i_ceph_lock)

cap = rb_entry(ci_node, struct ceph_cap, ci_node);    // This is buggy 
in this version, we should use the 'mds' instead and I will fix it.

if (!cap)  { release the spin lock and return directly }

spin_unlock(&ci->i_ceph_lock)



While we should switch to use the 'mds' of the cap instead of the 
'ci_node', which is buggy. I will fix it in next version.


> Is the issue in that bugzilla reproducible, or was that a one-time thing?

No, I don't think so. Locally I have tried by turning the mds options to 
trigger the cap reclaiming more frequently, but still couldn't reproduce 
it. It should be very corner case.

Thanks

- Xiubo

> Cheers,


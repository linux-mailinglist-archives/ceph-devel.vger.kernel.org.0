Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104694BAF3A
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Feb 2022 02:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiBRBrO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Feb 2022 20:47:14 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbiBRBrJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Feb 2022 20:47:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5EA129399F
        for <ceph-devel@vger.kernel.org>; Thu, 17 Feb 2022 17:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645148813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lCKUONowoFsEclYeIZIDSQTbBnMXiIZOLmMxluutS9Y=;
        b=ONGM8x0R4T+ZplkLi/z1QI8x3Y7UwhYSZDPIJRCovrNTwloPIKEf7wZDAetzbmAeZjCRs8
        IXSIoMBOS2zsdT0UfbnuR+a6qk0L+rSQCZGfDjr0RmjgVM7oR99Cs2D7Po98TA1wJ/Fn/j
        yA7HqOTCwS8zou5MGO+5owWZ9jOASaQ=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-213-juvBAs62NFivmKQt67Amtw-1; Thu, 17 Feb 2022 20:46:51 -0500
X-MC-Unique: juvBAs62NFivmKQt67Amtw-1
Received: by mail-pj1-f72.google.com with SMTP id g19-20020a17090a579300b001b9d80f3714so4454391pji.7
        for <ceph-devel@vger.kernel.org>; Thu, 17 Feb 2022 17:46:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=lCKUONowoFsEclYeIZIDSQTbBnMXiIZOLmMxluutS9Y=;
        b=QQL7sNvuAhA9NI+A9Wk9Zh0V86prPgJDouLgvbtBWoTB9Qgtf9HaPpPjqJuIv8i5wf
         2QdvsVuHnLC9BNRY9v3/edxAvy9aSTKOzgVSs1//S5/SWj544woegohmumsRrWG8wM21
         puVyQmHhsE7bhwfVMpSbgq+94XRwefiILVrsgO8eueE+HnajR4DiF32pWzWqJZLshwQo
         XBHY1sH1MaFCt/tdqN/Rel5+XAJkXxlt/80nw536rvWq1xQrVuRhGJOD0gAsrIpSKGEv
         cs5evv/845eP3CyoobEWZMiDcXwAa6Vpst45m9WE3A+YOcYT/aU+6mzANld10hSspeHL
         gYVQ==
X-Gm-Message-State: AOAM531F10l1rc5vT4QR2MNmgBAW/6MWrU3n+gA5BZ+HdXDaY9nfvb8l
        4a70gWzYuFmPPa9cA1ljEryScVbQF55F7gvbhjRKA6JTgcHgBIqTCDauhEPESzVu81yazVVxR8E
        hKaNeYte4kJVtR4Uh3ZqIap6ASUD+N8Y7VQdCCyjEX2NcRG7TsaH/tsAqTguRgSqk9se4Syg=
X-Received: by 2002:a17:902:bf04:b0:149:c5a5:5323 with SMTP id bi4-20020a170902bf0400b00149c5a55323mr5482311plb.97.1645148810157;
        Thu, 17 Feb 2022 17:46:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJznBF0IeNNTWL3hwhO+ogekZl9pRxERc1BtddRi6ZnvNF9VCutPpxFlgSp7j29HeMPKDnUxig==
X-Received: by 2002:a17:902:bf04:b0:149:c5a5:5323 with SMTP id bi4-20020a170902bf0400b00149c5a55323mr5482283plb.97.1645148809744;
        Thu, 17 Feb 2022 17:46:49 -0800 (PST)
Received: from [10.72.12.153] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ip8sm2779616pjb.6.2022.02.17.17.46.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 17:46:48 -0800 (PST)
Subject: Re: [PATCH 3/3] ceph: do no update snapshot context when there is no
 new snapshot
To:     "Yan, Zheng" <ukernel@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <20220215122316.7625-1-xiubli@redhat.com>
 <20220215122316.7625-4-xiubli@redhat.com>
 <CAAM7YAn8QtZZORXbczE4cLdvGrrEW=AeaAM22f9EK4YNopo+qg@mail.gmail.com>
 <896b780d82a37a04e0533b69049c0112d4327055.camel@kernel.org>
 <CAAM7YAnfs0eiJKGoHv_UjDi9D7U1vc3oEFuujeviCfAf_DXjfQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0e6f54c8-1677-dd22-8a3b-6b3bd9188659@redhat.com>
Date:   Fri, 18 Feb 2022 09:46:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAM7YAnfs0eiJKGoHv_UjDi9D7U1vc3oEFuujeviCfAf_DXjfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/17/22 11:28 PM, Yan, Zheng wrote:
> On Thu, Feb 17, 2022 at 6:55 PM Jeff Layton <jlayton@kernel.org> wrote:
>> On Thu, 2022-02-17 at 11:03 +0800, Yan, Zheng wrote:
>>> On Tue, Feb 15, 2022 at 11:04 PM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> No need to update snapshot context when any of the following two
>>>> cases happens:
>>>> 1: if my context seq matches realm's seq and realm has no parent.
>>>> 2: if my context seq equals or is larger than my parent's, this
>>>>     works because we rebuild_snap_realms() works _downward_ in
>>>>     hierarchy after each update.
>>>>
>>>> This fix will avoid those inodes which accidently calling
>>>> ceph_queue_cap_snap() and make no sense, for exmaple:
>>>>
>>>> There have 6 directories like:
>>>>
>>>> /dir_X1/dir_X2/dir_X3/
>>>> /dir_Y1/dir_Y2/dir_Y3/
>>>>
>>>> Firstly, make a snapshot under /dir_X1/dir_X2/.snap/snap_X2, then
>>>> make a root snapshot under /.snap/root_snap. And every time when
>>>> we make snapshots under /dir_Y1/..., the kclient will always try
>>>> to rebuild the snap context for snap_X2 realm and finally will
>>>> always try to queue cap snaps for dir_Y2 and dir_Y3, which makes
>>>> no sense.
>>>>
>>>> That's because the snap_X2's seq is 2 and root_snap's seq is 3.
>>>> So when creating a new snapshot under /dir_Y1/... the new seq
>>>> will be 4, and then the mds will send kclient a snapshot backtrace
>>>> in _downward_ in hierarchy: seqs 4, 3. Then in ceph_update_snap_trace()
>>>> it will always rebuild the from the last realm, that's the root_snap.
>>>> So later when rebuilding the snap context it will always rebuild
>>>> the snap_X2 realm and then try to queue cap snaps for all the inodes
>>>> related in snap_X2 realm, and we are seeing the logs like:
>>>>
>>>> "ceph:  queue_cap_snap 00000000a42b796b nothing dirty|writing"
>>>>
>>>> URL: https://tracker.ceph.com/issues/44100
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>   fs/ceph/snap.c | 16 +++++++++-------
>>>>   1 file changed, 9 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>>>> index d075d3ce5f6d..1f24a5de81e7 100644
>>>> --- a/fs/ceph/snap.c
>>>> +++ b/fs/ceph/snap.c
>>>> @@ -341,14 +341,16 @@ static int build_snap_context(struct ceph_snap_realm *realm,
>>>>                  num += parent->cached_context->num_snaps;
>>>>          }
>>>>
>>>> -       /* do i actually need to update?  not if my context seq
>>>> -          matches realm seq, and my parents' does to.  (this works
>>>> -          because we rebuild_snap_realms() works _downward_ in
>>>> -          hierarchy after each update.) */
>>>> +       /* do i actually need to update? No need when any of the following
>>>> +        * two cases:
>>>> +        * #1: if my context seq matches realm's seq and realm has no parent.
>>>> +        * #2: if my context seq equals or is larger than my parent's, this
>>>> +        *     works because we rebuild_snap_realms() works _downward_ in
>>>> +        *     hierarchy after each update.
>>>> +        */
>>>>          if (realm->cached_context &&
>>>> -           realm->cached_context->seq == realm->seq &&
>>>> -           (!parent ||
>>>> -            realm->cached_context->seq >= parent->cached_context->seq)) {
>>>> +           ((realm->cached_context->seq == realm->seq && !parent) ||
>>>> +            (parent && realm->cached_context->seq >= parent->cached_context->seq))) {
>>> With this change. When you mksnap on  /dir_Y1/, its snap context keeps
>>> unchanged. In ceph_update_snap_trace, reset the 'invalidate' variable
>>> for each realm should fix this issue.
>>>
Thanks Zheng for your feedback.

Yeah, there has one case this will happen. Your approach is simpler I 
will post a V2 for this.

-- Xiubo






>> This comment is terribly vague. "invalidate" is a local variable in that
>> function and isn't set on a per-realm basis.
>>
>> Could you suggest a patch on top of Xiubo's patch instead?
>>
> something like this (not tested)
>
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index af502a8245f0..6ef41764008b 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -704,7 +704,8 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>          __le64 *prior_parent_snaps;        /* encoded */
>          struct ceph_snap_realm *realm = NULL;
>          struct ceph_snap_realm *first_realm = NULL;
> -       int invalidate = 0;
> +       struct ceph_snap_realm *realm_to_inval = NULL;
> +       int invalidate;
>          int err = -ENOMEM;
>          LIST_HEAD(dirty_realms);
>
> @@ -712,6 +713,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>
>          dout("update_snap_trace deletion=%d\n", deletion);
>   more:
> +       invalidate = 0;
>          ceph_decode_need(&p, e, sizeof(*ri), bad);
>          ri = p;
>          p += sizeof(*ri);
> @@ -774,8 +776,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>               realm, invalidate, p, e);
>
>          /* invalidate when we reach the _end_ (root) of the trace */
> -       if (invalidate && p >= e)
> -               rebuild_snap_realms(realm, &dirty_realms);
> +       if (invalidate)
> +               realm_to_inval = realm;
> +       if (realm_to_inval && p >= e)
> +               rebuild_snap_realms(realm_to_inval, &dirty_realms);
>
>          if (!first_realm)
>                  first_realm = realm;
>
>
>
>>>>                  dout("build_snap_context %llx %p: %p seq %lld (%u snaps),
>>>>                       " (unchanged)\n",
>>>>                       realm->ino, realm, realm->cached_context,
>>>> --
>>>> 2.27.0
>>>>
>> --
>> Jeff Layton <jlayton@kernel.org>


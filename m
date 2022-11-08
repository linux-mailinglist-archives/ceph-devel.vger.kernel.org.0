Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E45F621168
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Nov 2022 13:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbiKHMuq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Nov 2022 07:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234147AbiKHMup (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Nov 2022 07:50:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76E65FAA
        for <ceph-devel@vger.kernel.org>; Tue,  8 Nov 2022 04:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667911787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zhegZUP2EEmKpS3FsAWA8bxUa3MAFW9QpPJOd2wIhxY=;
        b=Q/VLqwjiNDBavlx61v5kd/AyhdMpvAdlbMoI+KfKc7WZcn+efaV5gA20J/lZ/PlNbThZqV
        opMPAasc/dr0ep1NyFPXp828OESYoklK+kcAXvBvcM42YWhLxyybA9IArBmrULUMXVK6U1
        AII8wPeV8CihbNjf30GVj4zhq31jAQo=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-360-xoBQAdRuPea4nJBsGoESZQ-1; Tue, 08 Nov 2022 07:49:46 -0500
X-MC-Unique: xoBQAdRuPea4nJBsGoESZQ-1
Received: by mail-pg1-f199.google.com with SMTP id i19-20020a63e913000000b004705d1506a6so4283653pgh.13
        for <ceph-devel@vger.kernel.org>; Tue, 08 Nov 2022 04:49:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zhegZUP2EEmKpS3FsAWA8bxUa3MAFW9QpPJOd2wIhxY=;
        b=DaSQzGAvIPT9V7Ef6vbWxInx/ZUmngPqk6z0wmyW0YWy4IWhfc3rDgAxaxF7eWm8Hb
         sswweNTX9fP1apEo2MYLv4TBq5zPg+IWh4hlJpXzkELBV4u3VTsMkjOOe/4F/shwmM+D
         s/xsitJxwDo3iTfKWL73Ox26JADb+ZyP2dks917RQXPoQ64mhzz5NagVqpYuUiHGGJDU
         Jw2MtY0hn2YQr4YCAXuaNk/MZXMtkinvVA6El66FCbRzr/8rTN+5PqXfy9VkxLysckik
         Zs7fpf0Gu13JPJ6vBDoUFn1x2vNDudVXYkbrdZZlz5W53l3Qyj1bL/C+Wwlq8rjThmAw
         tPIA==
X-Gm-Message-State: ACrzQf10KuKRsMpRu9pXTr1GqM/+1qW6VqbzibbbDkJeHV11tl+OenRX
        +x05GIqo4l7Lt6eRm/jDBU/h3KdlQl6EZ7K7b5+ElRtZVvMF45cD5twJu8MeHXsFvd9FgUXB5hx
        S6pPGDl9Vgy36EvGIgWKJCA==
X-Received: by 2002:a62:6489:0:b0:56e:55de:985a with SMTP id y131-20020a626489000000b0056e55de985amr28003892pfb.34.1667911784847;
        Tue, 08 Nov 2022 04:49:44 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4eytsiRET/Xc1EyrVmW3kP/RaybwUUmfeKDBMlHb8eSMKQv8pKmBqy0xPRAf59PuJ5z/J13w==
X-Received: by 2002:a62:6489:0:b0:56e:55de:985a with SMTP id y131-20020a626489000000b0056e55de985amr28003875pfb.34.1667911784552;
        Tue, 08 Nov 2022 04:49:44 -0800 (PST)
Received: from [10.72.12.88] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id i184-20020a6254c1000000b0053e468a78a8sm6279817pfb.158.2022.11.08.04.49.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 04:49:44 -0800 (PST)
Subject: Re: [PATCH v2] ceph: fix NULL pointer dereference for req->r_session
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, lhenriques@suse.de, jlayton@kernel.org,
        mchangir@redhat.com, stable@vger.kernel.org
References: <20221108054954.307554-1-xiubli@redhat.com>
 <CAOi1vP8C20dU+jNqLw92N20mOyAecZWeK4QOX4WD=e-GZBb32Q@mail.gmail.com>
 <8ba8c0bc-28b6-590e-7b77-b805ee7ae8f6@redhat.com>
 <CAOi1vP-WCc2sixM3hAQGGwtuCL6OhO9Etn6sdPp-uar5q2WN=A@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <05d61ee5-92e2-bc84-0653-091fe43a5bdb@redhat.com>
Date:   Tue, 8 Nov 2022 20:49:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-WCc2sixM3hAQGGwtuCL6OhO9Etn6sdPp-uar5q2WN=A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 08/11/2022 20:44, Ilya Dryomov wrote:
> On Tue, Nov 8, 2022 at 1:38 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 08/11/2022 18:50, Ilya Dryomov wrote:
>>> On Tue, Nov 8, 2022 at 6:50 AM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> The request's r_session maybe changed when it was forwarded or
>>>> resent.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> URL: https://bugzilla.redhat.com/show_bug.cgi?id=2137955
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/caps.c | 88 +++++++++++++++++++-------------------------------
>>>>    1 file changed, 33 insertions(+), 55 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>> index 894adfb4a092..172f18f7459d 100644
>>>> --- a/fs/ceph/caps.c
>>>> +++ b/fs/ceph/caps.c
>>>> @@ -2297,8 +2297,9 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>>>           struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>>>>           struct ceph_inode_info *ci = ceph_inode(inode);
>>>>           struct ceph_mds_request *req1 = NULL, *req2 = NULL;
>>>> +       struct ceph_mds_session *s, **sessions = NULL;
>>> Hi Xiubo,
>>>
>>> Nit: mixing pointers and double pointers coupled with differing
>>> initialization is generally frowned upon.  Keep it on two lines as
>>> before:
>>>
>>>       struct ceph_mds_session **sessions = NULL;
>>>       struct ceph_mds_session *s;
>> Sure, will fix it.
>>
>>>>           unsigned int max_sessions;
>>>> -       int ret, err = 0;
>>>> +       int i, ret, err = 0;
>>>>
>>>>           spin_lock(&ci->i_unsafe_lock);
>>>>           if (S_ISDIR(inode->i_mode) && !list_empty(&ci->i_unsafe_dirops)) {
>>>> @@ -2315,31 +2316,22 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>>>           }
>>>>           spin_unlock(&ci->i_unsafe_lock);
>>>>
>>>> -       /*
>>>> -        * The mdsc->max_sessions is unlikely to be changed
>>>> -        * mostly, here we will retry it by reallocating the
>>>> -        * sessions array memory to get rid of the mdsc->mutex
>>>> -        * lock.
>>>> -        */
>>>> -retry:
>>>> -       max_sessions = mdsc->max_sessions;
>>>> -
>>>>           /*
>>>>            * Trigger to flush the journal logs in all the relevant MDSes
>>>>            * manually, or in the worst case we must wait at most 5 seconds
>>>>            * to wait the journal logs to be flushed by the MDSes periodically.
>>>>            */
>>>> +       mutex_lock(&mdsc->mutex);
>>>> +       max_sessions = mdsc->max_sessions;
>>>> +       sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
>>>> +       if (!sessions) {
>>>> +               mutex_unlock(&mdsc->mutex);
>>>> +               err = -ENOMEM;
>>>> +               goto out;
>>>> +       }
>>>> +
>>>>           if ((req1 || req2) && likely(max_sessions)) {
>>> Just curious, when can max_sessions be zero here?
>> Checked the code again, just before registering the first session, and
>> this is monotone increasing. It should be safe to remove this here.
>>
>>
>>>> -               struct ceph_mds_session **sessions = NULL;
>>>> -               struct ceph_mds_session *s;
>>>>                   struct ceph_mds_request *req;
>>>> -               int i;
>>>> -
>>>> -               sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
>>>> -               if (!sessions) {
>>>> -                       err = -ENOMEM;
>>>> -                       goto out;
>>>> -               }
>>>>
>>>>                   spin_lock(&ci->i_unsafe_lock);
>>>>                   if (req1) {
>>>> @@ -2348,16 +2340,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>>>                                   s = req->r_session;
>>>>                                   if (!s)
>>>>                                           continue;
>>>> -                               if (unlikely(s->s_mds >= max_sessions)) {
>>>> -                                       spin_unlock(&ci->i_unsafe_lock);
>>>> -                                       for (i = 0; i < max_sessions; i++) {
>>>> -                                               s = sessions[i];
>>>> -                                               if (s)
>>>> -                                                       ceph_put_mds_session(s);
>>>> -                                       }
>>>> -                                       kfree(sessions);
>>>> -                                       goto retry;
>>>> -                               }
>>>> +                               if (unlikely(s->s_mds >= max_sessions))
>>>> +                                       continue;
>>> Nit: this could be combined with the previous condition:
>>>
>>>       if (!s || unlikely(s->s_mds >= max_sessions))
>>>               continue;
>> Sure.
>>
>>
>>>>                                   if (!sessions[s->s_mds]) {
>>>>                                           s = ceph_get_mds_session(s);
>>>>                                           sessions[s->s_mds] = s;
>>>> @@ -2370,16 +2354,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>>>                                   s = req->r_session;
>>>>                                   if (!s)
>>>>                                           continue;
>>>> -                               if (unlikely(s->s_mds >= max_sessions)) {
>>>> -                                       spin_unlock(&ci->i_unsafe_lock);
>>>> -                                       for (i = 0; i < max_sessions; i++) {
>>>> -                                               s = sessions[i];
>>>> -                                               if (s)
>>>> -                                                       ceph_put_mds_session(s);
>>>> -                                       }
>>>> -                                       kfree(sessions);
>>>> -                                       goto retry;
>>>> -                               }
>>>> +                               if (unlikely(s->s_mds >= max_sessions))
>>>> +                                       continue;
>>> ditto
>>>
>>>>                                   if (!sessions[s->s_mds]) {
>>>>                                           s = ceph_get_mds_session(s);
>>>>                                           sessions[s->s_mds] = s;
>>>> @@ -2387,25 +2363,26 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>>>                           }
>>>>                   }
>>>>                   spin_unlock(&ci->i_unsafe_lock);
>>>> +       }
>>>> +       mutex_unlock(&mdsc->mutex);
>>>>
>>>> -               /* the auth MDS */
>>>> -               spin_lock(&ci->i_ceph_lock);
>>>> -               if (ci->i_auth_cap) {
>>>> -                     s = ci->i_auth_cap->session;
>>>> -                     if (!sessions[s->s_mds])
>>>> -                             sessions[s->s_mds] = ceph_get_mds_session(s);
>>>> -               }
>>>> -               spin_unlock(&ci->i_ceph_lock);
>>>> +       /* the auth MDS */
>>>> +       spin_lock(&ci->i_ceph_lock);
>>> Why was this "auth MDS" block moved outside of max_sessions > 0
>>> branch?  Logically, it very much belongs there.  Is there a problem
>>> with taking ci->i_ceph_lock under mdsc->mutex?
>> I will remove the 'likely(max_session)' and there is no any problem for
>> this.
>>
>>>> +       if (ci->i_auth_cap) {
>>>> +               s = ci->i_auth_cap->session;
>>>> +               if (!sessions[s->s_mds] &&
>>>> +                   likely(s->s_mds < max_sessions))
>>> This is wrong: s->s_mds must be checked against max_sessions before
>>> indexing into sessions array.  Also, the entire condition should fit on
>>> a single line.
>> I am moving it to the if(req1 || req2) {} scope and it will exceed 80
>> chars. And will keep it in two lines.
> If you are removing max_session > 0 condition, I don't see a need to
> move this to "if (req1 || req2)" scope.  I suggested that only because
> existing code was explicitly guarding against max_session == 0.

I checked old code again, I think we should move it to this scope. 
Because only when both req1 and req2 are not NULL will it make sense to 
send the mdlog flushing request to MDS.

Thanks!

- Xiubo

> Thanks,
>
>                  Ilya
>


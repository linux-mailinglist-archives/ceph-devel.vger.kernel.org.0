Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48386243A6
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Nov 2022 14:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiKJNyA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Nov 2022 08:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbiKJNx5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Nov 2022 08:53:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69133178A4
        for <ceph-devel@vger.kernel.org>; Thu, 10 Nov 2022 05:52:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668088378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8FWT9TyrBpCw16hoPVklgzSvxya7R9n4dXybApYg9Xs=;
        b=V/VYjBc+S4HxzQW9LQHvinyeaZP6dGVkOylMd2rT6k7D8y4/4PB7tkdoHPv9WqbVV896k6
        aKiE72wBwhUrsTKF6yxfBqzF/VGn5IVTkYiOgdg7pO+qpRXbhhnrBVFQyDU/8okuaWb7cx
        jJnM/vRogEG+y6iaKOdPmHUQ7EGsRBA=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-73-6HtuA9Y-Ocq1HPMlXyPwqw-1; Thu, 10 Nov 2022 08:52:57 -0500
X-MC-Unique: 6HtuA9Y-Ocq1HPMlXyPwqw-1
Received: by mail-pf1-f198.google.com with SMTP id k131-20020a628489000000b0056b3e1a9629so1070730pfd.8
        for <ceph-devel@vger.kernel.org>; Thu, 10 Nov 2022 05:52:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8FWT9TyrBpCw16hoPVklgzSvxya7R9n4dXybApYg9Xs=;
        b=71Wh1cRekkGDYx28ESjoZ+s8nk4WYzRVrTIgTIgW9pMz8SPrq6Hb2VJG7ckm3FaIGh
         lkeoyXgEd3ucbjBG1CfLUStzgvsb7mquca3LqIatUIO7SQI1foBN8Cr4JHpSYtWfsLsV
         pnkvGDg+q9SjuW7UhCKWDO7+m0qbqv0JBQQmqMTOyh5Knc8e05U94Wx5TIQZvT0nsDrM
         fGSAVapj82hhMjkNzm3o1Sy8pKMHu176D17Fy/2i9m0fO17PFoO8ma1f1VtDt6JCyEgk
         hWNksAAbStK0YzDKcz8wcDkwvkus80D35mBmReN6DpLiLAheRra3G5ONqfs4kgysO6Nw
         n1GA==
X-Gm-Message-State: ACrzQf0pmo6jrN+fHSIljGL3VruKOnUMdwCk9TlPobQBNg/aUIZHse4z
        Pt8i3/sljyQOlRZzyBDljsmQGgOuKqgbwtPJBMPigERPjjpAm/6/yxQFh63oRh0nYi79nrIcv1H
        sFnB2R+OwIGG4yEdOrWTCww==
X-Received: by 2002:a62:6502:0:b0:56c:12c0:aaf1 with SMTP id z2-20020a626502000000b0056c12c0aaf1mr2676179pfb.50.1668088376278;
        Thu, 10 Nov 2022 05:52:56 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4M6tvQVkMUDbtPrTjA7NFgPmODC8PpLgiBHLE8BihURFhUw3gCYZ1RYGREBmxjiuKgfPBmDA==
X-Received: by 2002:a62:6502:0:b0:56c:12c0:aaf1 with SMTP id z2-20020a626502000000b0056c12c0aaf1mr2676171pfb.50.1668088375968;
        Thu, 10 Nov 2022 05:52:55 -0800 (PST)
Received: from [10.72.12.148] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y18-20020a170902b49200b001769206a766sm11152484plr.307.2022.11.10.05.52.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 05:52:55 -0800 (PST)
Subject: Re: [PATCH v5] ceph: fix NULL pointer dereference for req->r_session
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, lhenriques@suse.de, jlayton@kernel.org,
        mchangir@redhat.com, stable@vger.kernel.org
References: <20221110130159.33319-1-xiubli@redhat.com>
 <CAOi1vP-Evz+q7XU2EKNRaqCWOVHm8pm0WVp6No21=q55tDdGag@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <5a9b784c-8c94-c083-a8fb-8548edffebbe@redhat.com>
Date:   Thu, 10 Nov 2022 21:52:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-Evz+q7XU2EKNRaqCWOVHm8pm0WVp6No21=q55tDdGag@mail.gmail.com>
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


On 10/11/2022 21:48, Ilya Dryomov wrote:
> On Thu, Nov 10, 2022 at 2:02 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The request's r_session maybe changed when it was forwarded or
>> resent. Both the forwarding and resending cases the requests will
>> be protected by the mdsc->mutex.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://bugzilla.redhat.com/show_bug.cgi?id=2137955
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> Changed in V5:
>> - simplify the code by removing the "unlikely(s->s_mds >= max_sessions)" check.
>>
>> Changed in V4:
>> - move mdsc->mutex acquisition and max_sessions assignment into "if (req1 || req2)" branch
>>
>>
>>
>>   fs/ceph/caps.c | 48 ++++++++++++------------------------------------
>>   1 file changed, 12 insertions(+), 36 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 894adfb4a092..065e9311b607 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -2297,7 +2297,6 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>          struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>>          struct ceph_inode_info *ci = ceph_inode(inode);
>>          struct ceph_mds_request *req1 = NULL, *req2 = NULL;
>> -       unsigned int max_sessions;
>>          int ret, err = 0;
>>
>>          spin_lock(&ci->i_unsafe_lock);
>> @@ -2315,28 +2314,24 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>          }
>>          spin_unlock(&ci->i_unsafe_lock);
>>
>> -       /*
>> -        * The mdsc->max_sessions is unlikely to be changed
>> -        * mostly, here we will retry it by reallocating the
>> -        * sessions array memory to get rid of the mdsc->mutex
>> -        * lock.
>> -        */
>> -retry:
>> -       max_sessions = mdsc->max_sessions;
>> -
>>          /*
>>           * Trigger to flush the journal logs in all the relevant MDSes
>>           * manually, or in the worst case we must wait at most 5 seconds
>>           * to wait the journal logs to be flushed by the MDSes periodically.
>>           */
>> -       if ((req1 || req2) && likely(max_sessions)) {
>> -               struct ceph_mds_session **sessions = NULL;
>> -               struct ceph_mds_session *s;
>> +       if (req1 || req2) {
>>                  struct ceph_mds_request *req;
>> +               struct ceph_mds_session **sessions;
>> +               struct ceph_mds_session *s;
>> +               unsigned int max_sessions;
>>                  int i;
>>
>> +               mutex_lock(&mdsc->mutex);
>> +               max_sessions = mdsc->max_sessions;
>> +
>>                  sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
>>                  if (!sessions) {
>> +                       mutex_unlock(&mdsc->mutex);
>>                          err = -ENOMEM;
>>                          goto out;
>>                  }
>> @@ -2348,16 +2343,6 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>                                  s = req->r_session;
>>                                  if (!s)
>>                                          continue;
>> -                               if (unlikely(s->s_mds >= max_sessions)) {
>> -                                       spin_unlock(&ci->i_unsafe_lock);
>> -                                       for (i = 0; i < max_sessions; i++) {
>> -                                               s = sessions[i];
>> -                                               if (s)
>> -                                                       ceph_put_mds_session(s);
>> -                                       }
>> -                                       kfree(sessions);
>> -                                       goto retry;
>> -                               }
>>                                  if (!sessions[s->s_mds]) {
>>                                          s = ceph_get_mds_session(s);
>>                                          sessions[s->s_mds] = s;
>> @@ -2370,16 +2355,6 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>                                  s = req->r_session;
>>                                  if (!s)
>>                                          continue;
>> -                               if (unlikely(s->s_mds >= max_sessions)) {
>> -                                       spin_unlock(&ci->i_unsafe_lock);
>> -                                       for (i = 0; i < max_sessions; i++) {
>> -                                               s = sessions[i];
>> -                                               if (s)
>> -                                                       ceph_put_mds_session(s);
>> -                                       }
>> -                                       kfree(sessions);
>> -                                       goto retry;
>> -                               }
>>                                  if (!sessions[s->s_mds]) {
>>                                          s = ceph_get_mds_session(s);
>>                                          sessions[s->s_mds] = s;
>> @@ -2391,11 +2366,12 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>                  /* the auth MDS */
>>                  spin_lock(&ci->i_ceph_lock);
>>                  if (ci->i_auth_cap) {
>> -                     s = ci->i_auth_cap->session;
>> -                     if (!sessions[s->s_mds])
>> -                             sessions[s->s_mds] = ceph_get_mds_session(s);
>> +                       s = ci->i_auth_cap->session;
>> +                       if (!sessions[s->s_mds])
>> +                               sessions[s->s_mds] = ceph_get_mds_session(s);
>>                  }
>>                  spin_unlock(&ci->i_ceph_lock);
>> +               mutex_unlock(&mdsc->mutex);
>>
>>                  /* send flush mdlog request to MDSes */
>>                  for (i = 0; i < max_sessions; i++) {
>> --
>> 2.31.1
>>
> Reviewed-by: Ilya Dryomov <idryomov@gmail.com>

Thanks Ilya!

- Xiubo


>
> Thanks,
>
>                  Ilya
>


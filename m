Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9675622D46
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Nov 2022 15:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiKIONx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Nov 2022 09:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiKIONn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Nov 2022 09:13:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC301758D
        for <ceph-devel@vger.kernel.org>; Wed,  9 Nov 2022 06:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668003165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+nGG4v/WAw5mpHEwda50iPfq2lYerQhkZgDOA8RIUjM=;
        b=YLYEUwWmF1qhdXhabT/dHOuuNDTde9CDBSLI44IkI3z+QVPVRs8euUBnFTNz8sYvgTrcJd
        mohpLDWebyrq42otJj8bIzCvUBMPhrmRllND1JYs83PtuPMb7ySuE1D/zaf+NSkGBSesWC
        ZLsrWIu1OaCIlASlQfw2DHkS8H93pp0=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-216-3grTxadzOzKfzNXX27Ybgw-1; Wed, 09 Nov 2022 09:12:43 -0500
X-MC-Unique: 3grTxadzOzKfzNXX27Ybgw-1
Received: by mail-pf1-f199.google.com with SMTP id e12-20020a62aa0c000000b0056c12c0aadeso9052467pff.21
        for <ceph-devel@vger.kernel.org>; Wed, 09 Nov 2022 06:12:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+nGG4v/WAw5mpHEwda50iPfq2lYerQhkZgDOA8RIUjM=;
        b=eoweswWTTx0I36PcQbS6FHinUvfGQd+G9BKnTOCP7il0gn1NUhqG0LU0nrjVAD93Nu
         qa+zRqAWIzAhjvAkRUld+qpv3YRhZoNrpsNxRPxrEhj9XA9frcVJTU4lLEm5p61QnjnU
         m1Z/kjw3k2+7FJIO4DHgPxgrOAkbXNfl6WZaun8keX19rxBxPtul9I/JE8VqEC3u3tQ0
         7QoabmgAwMlpMIrrQJwtRvEMvkXL6j8jeBD1Aj0yVbHqDnpkwpxN3cwqlQncqIkIAEaD
         SoieJuNOs3Ee2V/AKUure1bFY55hE3BYFN/2HOr/+wJwhEK26EoqMN8XxzJegC7/KKeL
         j7yQ==
X-Gm-Message-State: ACrzQf2SyVcCr5Z42uNCwcpIqb9y9lLGl7bLKcRlF1tvaVq8qryO1Mun
        JMA5AXGv3qzMDD5abUJ+wH3qZIKQFAvIx/G7W3W7orbtgpD0Ya/NieEvGKujgZ4BfKFixDxq51L
        AiAibplsFZ9Euj9CTyT1wDA==
X-Received: by 2002:a62:b411:0:b0:56c:5afe:649f with SMTP id h17-20020a62b411000000b0056c5afe649fmr60958007pfn.60.1668003162778;
        Wed, 09 Nov 2022 06:12:42 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5zqYewGRUUdifmTIbXQYtRpPGH2Rm9/2eLSeOIeYnpt9b+GReraPAU//VfM7aTX62ZodYLSw==
X-Received: by 2002:a62:b411:0:b0:56c:5afe:649f with SMTP id h17-20020a62b411000000b0056c5afe649fmr60957976pfn.60.1668003162378;
        Wed, 09 Nov 2022 06:12:42 -0800 (PST)
Received: from [10.72.12.148] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t7-20020a635f07000000b0046a1c832e9fsm7579388pgb.34.2022.11.09.06.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 06:12:41 -0800 (PST)
Subject: Re: [PATCH v3] ceph: fix NULL pointer dereference for req->r_session
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, lhenriques@suse.de, jlayton@kernel.org,
        mchangir@redhat.com, stable@vger.kernel.org
References: <20221108135554.558278-1-xiubli@redhat.com>
 <CAOi1vP8Fkzq542St9od7G_JnQyS93=BgLLRUE86-E-Zw4MEt3g@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c905be56-ba74-9a86-1aff-3fb17a157932@redhat.com>
Date:   Wed, 9 Nov 2022 22:12:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP8Fkzq542St9od7G_JnQyS93=BgLLRUE86-E-Zw4MEt3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 09/11/2022 20:56, Ilya Dryomov wrote:
> On Tue, Nov 8, 2022 at 2:56 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The request's r_session maybe changed when it was forwarded or
>> resent.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://bugzilla.redhat.com/show_bug.cgi?id=2137955
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c | 60 ++++++++++++++++----------------------------------
>>   1 file changed, 19 insertions(+), 41 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 894adfb4a092..83f9e18e3169 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -2297,8 +2297,10 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>          struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>>          struct ceph_inode_info *ci = ceph_inode(inode);
>>          struct ceph_mds_request *req1 = NULL, *req2 = NULL;
>> +       struct ceph_mds_session **sessions = NULL;
>> +       struct ceph_mds_session *s;
>>          unsigned int max_sessions;
>> -       int ret, err = 0;
>> +       int i, ret, err = 0;
>>
>>          spin_lock(&ci->i_unsafe_lock);
>>          if (S_ISDIR(inode->i_mode) && !list_empty(&ci->i_unsafe_dirops)) {
>> @@ -2315,28 +2317,19 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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
>> +       mutex_lock(&mdsc->mutex);
>> +       max_sessions = mdsc->max_sessions;
>> +       if (req1 || req2) {
>>                  struct ceph_mds_request *req;
>> -               int i;
>>
>>                  sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
>>                  if (!sessions) {
>> +                       mutex_unlock(&mdsc->mutex);
>>                          err = -ENOMEM;
>>                          goto out;
>>                  }
>> @@ -2346,18 +2339,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>                          list_for_each_entry(req, &ci->i_unsafe_dirops,
>>                                              r_unsafe_dir_item) {
>>                                  s = req->r_session;
>> -                               if (!s)
>> +                               if (!s || unlikely(s->s_mds >= max_sessions))
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
>> @@ -2368,18 +2351,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>                          list_for_each_entry(req, &ci->i_unsafe_iops,
>>                                              r_unsafe_target_item) {
>>                                  s = req->r_session;
>> -                               if (!s)
>> +                               if (!s || unlikely(s->s_mds >= max_sessions))
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
>> @@ -2391,13 +2364,18 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>                  /* the auth MDS */
>>                  spin_lock(&ci->i_ceph_lock);
>>                  if (ci->i_auth_cap) {
>> -                     s = ci->i_auth_cap->session;
>> -                     if (!sessions[s->s_mds])
>> -                             sessions[s->s_mds] = ceph_get_mds_session(s);
>> +                       s = ci->i_auth_cap->session;
>> +                       if (likely(s->s_mds < max_sessions)
>> +                           && !sessions[s->s_mds]) {
> Hi Xiubo,
>
> Nit: keep && on the previous line for style consistency.

Sure. Will fix it.


>
>> +                               sessions[s->s_mds] = ceph_get_mds_session(s);
>> +                       }
>>                  }
>>                  spin_unlock(&ci->i_ceph_lock);
>> +       }
>> +       mutex_unlock(&mdsc->mutex);
>>
>> -               /* send flush mdlog request to MDSes */
>> +       /* send flush mdlog request to MDSes */
>> +       if (sessions) {
> Since mdlog is flushed only in "if (req1 || req2)" case, why not keep
> max_sessions loop there and avoid sessions != NULL check?

This is because I must drop the mdsc->mutex before calling 
"send_flush_mdlog()" in the max_sessions loop.

Thanks!

- Xiubo


>
> Then, you could also move mdsc->mutex acquisition and max_sessions
> assignment into "if (req1 || req2)" branch and keep sessions, s and
> i declarations where there are today.
>
> Thanks,
>
>                  Ilya
>


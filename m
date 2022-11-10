Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2FA7624283
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Nov 2022 13:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiKJMpL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Nov 2022 07:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKJMpK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Nov 2022 07:45:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA30E6BDE9
        for <ceph-devel@vger.kernel.org>; Thu, 10 Nov 2022 04:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668084256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9dhCz5G8/0fI3499uvX3FIy/HgpHJm4zK6RIYrkwv5U=;
        b=cZBCYjdGivED3pAZEsFRofB0t6/cVrQ1i9s1N1/N5cqY8lJ+pI6HOsr0kRNTMuLHKGCidI
        ussBp/FvuFXgsg1X/ghP6fO9V40b+NQ7YiCBL9jKN1duEqaM8FNBSQLN2Ze4LstI4pNvXL
        OFvFsLwFbDwvWpE/fqhnHKIwpIy3WvU=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-520-5OK2lE90NNuIZH5TMnj3Xg-1; Thu, 10 Nov 2022 07:44:15 -0500
X-MC-Unique: 5OK2lE90NNuIZH5TMnj3Xg-1
Received: by mail-pl1-f197.google.com with SMTP id n12-20020a170902e54c00b00188515e81a6so1302359plf.23
        for <ceph-devel@vger.kernel.org>; Thu, 10 Nov 2022 04:44:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9dhCz5G8/0fI3499uvX3FIy/HgpHJm4zK6RIYrkwv5U=;
        b=7C0FqncCxbvaw7T6FAHsIlyEaCa8b8xN42jgOYtQzn8lNdk7yaHngNRVlgCB9Vxc/d
         1qU7J7/tKAVyLtqiQlzShsQ7pcR3PY8sHtETQViMjzE/nSZvv9pqspexJfdiicppspa9
         /p1JZ/2V5N8zKbbPxGa/fz3qPaMiECRjfuABY/g8upOuAght7ILs0Q1eJ6LJM5f6yapv
         YvPXhdX91n4czSoq+QIw35uNtt5nYOW+xok/+sOr1I5VFNo4PNwWo1S5nmUAg+/qR9OJ
         hbbukRn6sC4EikJb7yqWZntcpPdJmShvJTMCElTVKBywV8vz6nv8/nETrzB34YdE1+Bu
         Qtfw==
X-Gm-Message-State: ACrzQf34fROCPFhSfpSeqqjPDIIRTpqGoW8kXhezn+O/7ZApHGjfo3P1
        ipap5YKe983OhWL9khwKdAHYkNgbQL9shgYaXbNGqG/l8uKFgPHqeyIyFq/2AKxryu52zw2sZBJ
        6TDK1zJozepEdM0qr6NAxoQ==
X-Received: by 2002:a17:902:7607:b0:186:5df5:a4a0 with SMTP id k7-20020a170902760700b001865df5a4a0mr1358629pll.104.1668084254321;
        Thu, 10 Nov 2022 04:44:14 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6HN4XfEuqVZc0HeNb+3+T8WWRRJWzJS7Iz/QC79CRUxh7iA1ztPB7mt++ecaoTEk1Ie+vSZg==
X-Received: by 2002:a17:902:7607:b0:186:5df5:a4a0 with SMTP id k7-20020a170902760700b001865df5a4a0mr1358627pll.104.1668084253971;
        Thu, 10 Nov 2022 04:44:13 -0800 (PST)
Received: from [10.72.12.148] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a19-20020aa794b3000000b0056c2e497ad6sm10407805pfl.93.2022.11.10.04.44.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 04:44:13 -0800 (PST)
Subject: Re: [PATCH v4] ceph: fix NULL pointer dereference for req->r_session
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, lhenriques@suse.de, jlayton@kernel.org,
        mchangir@redhat.com, stable@vger.kernel.org
References: <20221110020828.1899393-1-xiubli@redhat.com>
 <CAOi1vP9CtZdJ7tx4-WHhiHxB4WPqx-i6EjXwMHCOeBcxMxAndA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f19cc77a-c1ea-eebd-c2d2-95f9088a23ff@redhat.com>
Date:   Thu, 10 Nov 2022 20:44:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP9CtZdJ7tx4-WHhiHxB4WPqx-i6EjXwMHCOeBcxMxAndA@mail.gmail.com>
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


On 10/11/2022 19:49, Ilya Dryomov wrote:
> On Thu, Nov 10, 2022 at 3:08 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The request's r_session maybe changed when it was forwarded or
>> resent.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://bugzilla.redhat.com/show_bug.cgi?id=2137955
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> Changed in V4:
>> - move mdsc->mutex acquisition and max_sessions assignment into "if (req1 || req2)" branch
>>
>>   fs/ceph/caps.c | 54 +++++++++++++++-----------------------------------
>>   1 file changed, 16 insertions(+), 38 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 894adfb4a092..1c84be839087 100644
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
>> @@ -2346,18 +2341,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>>                          list_for_each_entry(req, &ci->i_unsafe_dirops,
>>                                              r_unsafe_dir_item) {
>>                                  s = req->r_session;
>> -                               if (!s)
>> +                               if (!s || unlikely(s->s_mds >= max_sessions))
> Hi Xiubo,
>
> I would be fine with this patch as is but I'm wondering if it can be
> simplified further.  Now that mdsc->mutex is held while sessions array
> is populated, is checking s->s_mds against max_sessions actually
> needed?  Is it possible for some req->r_session on one of the unsafe
> lists to have an "out of bounds" s_mds under mdsc->mutex?

Yeah, this can be simplified.

Let me do that.

Thanks!

- Xiubo


>
> Thanks,
>
>                  Ilya
>


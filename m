Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5676FA00B
	for <lists+ceph-devel@lfdr.de>; Mon,  8 May 2023 08:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbjEHGm7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 May 2023 02:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbjEHGm6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 May 2023 02:42:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1857E659C
        for <ceph-devel@vger.kernel.org>; Sun,  7 May 2023 23:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683528132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VRyFQsEkPeLlxmqVt8CqtoqYAZHX/at91wsz5Kw1Qbw=;
        b=JeHg7HSOl8OmGpiGQYE0VyvUw821qAea4G4W3BRGiYeEp+mpectfy4EBLvqjP94TqCrVVL
        r2vy/A+72OIDLrvCN38by9abbAl8uIIbKb3EOkv59fTPZ8zS91z790yDkQHc7Bcr4tSs0p
        6NZ2nuHqIeDrHdfDWWXGVzpfXaXIt0Q=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-R4YralwbNpWUoPKRhvWknA-1; Mon, 08 May 2023 02:42:10 -0400
X-MC-Unique: R4YralwbNpWUoPKRhvWknA-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1ab0527b01bso22163345ad.1
        for <ceph-devel@vger.kernel.org>; Sun, 07 May 2023 23:42:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683528129; x=1686120129;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VRyFQsEkPeLlxmqVt8CqtoqYAZHX/at91wsz5Kw1Qbw=;
        b=dpgixZfrCZ6o8V+huYo8ZSpIZ0QZf/cUfOm8+/Aw7x1F6h+7lbqEEJ3a6VDrS+kz6R
         tOz83Enva7X96+ocjf+0aK7kxJmzcO1vDFkyQcaC9YUY3yidKsVtLxNsCY5WJeriFd8y
         64AeC+8varBdCiZVaoMQtIYoRy0oFUS3/HZyecljBaS1qe5CdeIbItmjJeASD5RwwvAI
         Vru8Kwck2EcIWhB4jHQ5j1fgvdifhjRH4XLws5F0NJ7MTgYYYIqBkVNHhZHaKzMzg1e3
         oHKzr8O0wCZRaS8wV0xgVlDQcxwiQ73S/lJg/GaqJVRq6XxufkOoeqx/FZi3G5ctAG4/
         S2Cw==
X-Gm-Message-State: AC+VfDwa2ojUTfh5ygWYF1iv7A4/ryFxpqQb1tzzkI04ZmWvc02x1kNU
        Fl70GvSI0hpBweyx/J6lZRyvXPTpf7nw8NeMdQJHcWePYjztJ27C3i+o5qyONXs1cJwfoivRIQp
        NNmam/bi4ZEkpbcEqffOqDA==
X-Received: by 2002:a17:902:e5cf:b0:1ac:807b:deb1 with SMTP id u15-20020a170902e5cf00b001ac807bdeb1mr1419228plf.38.1683528129516;
        Sun, 07 May 2023 23:42:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6oSMPnN2VE4J9p6apamL4yHby8sYGeKTCJ5pQbjKXMsEMye+AJy7QFKULvdj96K6eZ2OowMA==
X-Received: by 2002:a17:902:e5cf:b0:1ac:807b:deb1 with SMTP id u15-20020a170902e5cf00b001ac807bdeb1mr1419221plf.38.1683528129167;
        Sun, 07 May 2023 23:42:09 -0700 (PDT)
Received: from [10.72.12.156] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902eccd00b00186a2274382sm6334137plh.76.2023.05.07.23.42.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 May 2023 23:42:08 -0700 (PDT)
Message-ID: <f93d0525-d533-e7b1-0433-20c6433e5fc8@redhat.com>
Date:   Mon, 8 May 2023 14:42:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [bug report] ceph: fix potential use-after-free bug when trimming
 caps
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     ceph-devel@vger.kernel.org
References: <9e074e4b-9519-42e2-819a-7089564d6158@kili.mountain>
 <937dc7c7-1907-5511-d691-7f531e72bd8f@redhat.com>
 <43a81ea0-c24f-4a27-a313-0da1abd41004@kili.mountain>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <43a81ea0-c24f-4a27-a313-0da1abd41004@kili.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/6/23 15:13, Dan Carpenter wrote:
> On Sat, May 06, 2023 at 09:32:30AM +0800, Xiubo Li wrote:
>> Hi Dan,
>>
>> On 5/5/23 17:21, Dan Carpenter wrote:
>>> Hello Xiubo Li,
>>>
>>> The patch aaf67de78807: "ceph: fix potential use-after-free bug when
>>> trimming caps" from Apr 19, 2023, leads to the following Smatch
>>> static checker warning:
>>>
>>> 	fs/ceph/mds_client.c:3968 reconnect_caps_cb()
>>> 	warn: missing error code here? '__get_cap_for_mds()' failed. 'err' = '0'
>>>
>>> fs/ceph/mds_client.c
>>>       3933 static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
>>>       3934 {
>>>       3935         union {
>>>       3936                 struct ceph_mds_cap_reconnect v2;
>>>       3937                 struct ceph_mds_cap_reconnect_v1 v1;
>>>       3938         } rec;
>>>       3939         struct ceph_inode_info *ci = ceph_inode(inode);
>>>       3940         struct ceph_reconnect_state *recon_state = arg;
>>>       3941         struct ceph_pagelist *pagelist = recon_state->pagelist;
>>>       3942         struct dentry *dentry;
>>>       3943         struct ceph_cap *cap;
>>>       3944         char *path;
>>>       3945         int pathlen = 0, err = 0;
>>>       3946         u64 pathbase;
>>>       3947         u64 snap_follows;
>>>       3948
>>>       3949         dentry = d_find_primary(inode);
>>>       3950         if (dentry) {
>>>       3951                 /* set pathbase to parent dir when msg_version >= 2 */
>>>       3952                 path = ceph_mdsc_build_path(dentry, &pathlen, &pathbase,
>>>       3953                                             recon_state->msg_version >= 2);
>>>       3954                 dput(dentry);
>>>       3955                 if (IS_ERR(path)) {
>>>       3956                         err = PTR_ERR(path);
>>>       3957                         goto out_err;
>>>       3958                 }
>>>       3959         } else {
>>>       3960                 path = NULL;
>>>       3961                 pathbase = 0;
>>>       3962         }
>>>       3963
>>>       3964         spin_lock(&ci->i_ceph_lock);
>>>       3965         cap = __get_cap_for_mds(ci, mds);
>>>       3966         if (!cap) {
>>>       3967                 spin_unlock(&ci->i_ceph_lock);
>>> --> 3968                 goto out_err;
>>>
>>> Set an error code?
>> This was intended, the 'err' was initialized as '0' in line 3945.
>>
>> It's no harm to skip this _cb() for current cap, so just succeeds it.
>>
> Smatch considers it intentional of the "ret = 0;" assignment is within
> 4 or 5 (I forget) lines of the goto.  Otherwise adding a comment would
> help reviewers.

Yeah, I will revise this to dismiss the warning.

Thanks

- Xiubo


> regards,
> dan carpenter
>


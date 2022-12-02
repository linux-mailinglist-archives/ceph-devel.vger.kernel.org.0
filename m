Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA9C63FDD3
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Dec 2022 02:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbiLBBuy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Dec 2022 20:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiLBBux (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 1 Dec 2022 20:50:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFCEBA626
        for <ceph-devel@vger.kernel.org>; Thu,  1 Dec 2022 17:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669945798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jwbMJDqnJxv2Quj81KxN4K0a8BO/7oa6jmElPP0CjUM=;
        b=C4PiP+8KPJK0eaw69vJbeAu/Dkufoa8pB3O35OhcI9szNMTGDWZ9fdytjalW6/o2LXu/pG
        fsYmFjggcowL9hrmQBw5g3X+t8jPs78YZ/2084pEb6gS2rlzJXng4T5jR4bSST2U4Sb6me
        UlQubBdOC6GeP8kYaam0rLlAMgLgIX4=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-79-5w7q3Zz0MEK-gAXUqtD8RA-1; Thu, 01 Dec 2022 20:49:57 -0500
X-MC-Unique: 5w7q3Zz0MEK-gAXUqtD8RA-1
Received: by mail-pl1-f200.google.com with SMTP id u9-20020a170902e80900b0018939ccbeedso4423134plg.20
        for <ceph-devel@vger.kernel.org>; Thu, 01 Dec 2022 17:49:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jwbMJDqnJxv2Quj81KxN4K0a8BO/7oa6jmElPP0CjUM=;
        b=QG5Ckcubm0ZbI7e/yuDQOsvWnX9CtygKeSQf9NjnrrfUPJZrg1HMwLLo37VIHkrspk
         PBAkMt9kVPOc4gtHJp8jkk9cz1nggZsKMqISgeiZnyYqIe2D8SgWbiheoOBdi8/fNcbA
         Vi5PUvX+3oB+xXy8q6AZxzVl7+ZeVHWWNhyC9chwvc+Jsla7aHyqh2/mJcbh6oZWS9Hn
         CuKIi00F69TxCJWo+OR2HRA78SwCgQZvay9gcZS83DubrahqX2Vf8F9Y7B7Q8iRJsTu+
         DFIxtsj1OLDPhaMlwE77ioV49ldHQq0pVfIqaqTqOZd9QlXC0OoxomdpqNoF3sKxNFko
         5CVQ==
X-Gm-Message-State: ANoB5pnE3W9v/LUKHfHGIWcYRXYzNOaO7dgrRuwkqLoIH//cceYrTbg+
        LJefe/JueQBtbhjcYH3vh+iGpt5TmUNp1mFokx0OLdG96Y5ChIOeh3Io03u3gb/z+dKD2eSdUxP
        Ib4FZ+5PwP1I0XQrs6TH+pw==
X-Received: by 2002:a62:ee0f:0:b0:56c:8dbc:f83e with SMTP id e15-20020a62ee0f000000b0056c8dbcf83emr48964848pfi.41.1669945795816;
        Thu, 01 Dec 2022 17:49:55 -0800 (PST)
X-Google-Smtp-Source: AA0mqf72mDzA6v/CjPCh9kJ87Ey1URLEEDUXYiampsjj/jt5qsEMerxAVHEqSoW6zKK0KnBfb8GzzQ==
X-Received: by 2002:a62:ee0f:0:b0:56c:8dbc:f83e with SMTP id e15-20020a62ee0f000000b0056c8dbcf83emr48964831pfi.41.1669945795545;
        Thu, 01 Dec 2022 17:49:55 -0800 (PST)
Received: from [10.72.12.244] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l11-20020a170903244b00b0017f592a7eccsm4268308pls.298.2022.12.01.17.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 17:49:55 -0800 (PST)
Subject: Re: [PATCH] ceph: make sure all the files successfully put before
 unmounting
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        khiremat@redhat.com, linux-fscrypt@vger.kernel.org
References: <20221201065800.18149-1-xiubli@redhat.com>
 <Y4j+Ccqzi6JxWchv@sol.localdomain> <Y4kYN8FPeq6NDe5i@gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b30e579d-6919-d35b-aaa5-b71129a32810@redhat.com>
Date:   Fri, 2 Dec 2022 09:49:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Y4kYN8FPeq6NDe5i@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 02/12/2022 05:10, Eric Biggers wrote:
> On Thu, Dec 01, 2022 at 11:18:33AM -0800, Eric Biggers wrote:
>> On Thu, Dec 01, 2022 at 02:58:00PM +0800, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> When close a file it will be deferred to call the fput(), which
>>> will hold the inode's i_count. And when unmounting the mountpoint
>>> the evict_inodes() may skip evicting some inodes.
>>>
>>> If encrypt is enabled the kernel generate a warning when removing
>>> the encrypt keys when the skipped inodes still hold the keyring:
>> This does not make sense.  Unmounting is only possible once all the files on the
>> filesystem have been closed.
>>
> Specifically, __fput() puts the reference to the dentry (and thus the inode)
> *before* it puts the reference to the mount.  And an unmount cannot be done
> while the mount still has references.  So there should not be any issue here.

Eric,

When I unmounting I can see the following logs, which I added a debug 
log in the evcit_inodes():

diff --git a/fs/inode.c b/fs/inode.c
index b608528efd3a..f6e69b778d9c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -716,8 +716,11 @@ void evict_inodes(struct super_block *sb)
  again:
         spin_lock(&sb->s_inode_list_lock);
         list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
-               if (atomic_read(&inode->i_count))
+               if (atomic_read(&inode->i_count)) {
+                       printk("evict_inodes inode %p, i_count = %d, was 
skipped!\n",
+                              inode, atomic_read(&inode->i_count));
                         continue;
+               }

                 spin_lock(&inode->i_lock);
                 if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {

The logs:

<4>[   95.977395] evict_inodes inode 00000000f90aab7b, i_count = 1, was 
skipped!

Any reason could cause this ? Since the inode couldn't be evicted in 
time and then when removing the master keys it will print this warning.

Thanks

- Xiubo


> - Eric
>


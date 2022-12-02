Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A4D6400D9
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Dec 2022 08:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbiLBHFy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Dec 2022 02:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLBHFy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Dec 2022 02:05:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5871841987
        for <ceph-devel@vger.kernel.org>; Thu,  1 Dec 2022 23:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669964706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ywjUkxDk68xBaDXV19jmqPCrfdHbQq1/CxC+D56LHc0=;
        b=do9eLfPtiFuvxOsGmI+Rg94q4b7Kk/N+iqfoM9W2mhE5ffClAN0CbvnGu1fqc477nDBTx6
        HPmAaQJDBAs/u/rEbplVh987NFr5YQv9hJTsXPXXNOB3TpxhClWwUHZfopowP+WKVkRHWj
        bRTLWEdZQVzRQGrixd5ye6YRaQlpmtc=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-108-jVZJEXy_MqyJnq4GpQiwTA-1; Fri, 02 Dec 2022 02:05:04 -0500
X-MC-Unique: jVZJEXy_MqyJnq4GpQiwTA-1
Received: by mail-pf1-f198.google.com with SMTP id g13-20020a056a000b8d00b0056e28b15757so4282315pfj.1
        for <ceph-devel@vger.kernel.org>; Thu, 01 Dec 2022 23:05:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ywjUkxDk68xBaDXV19jmqPCrfdHbQq1/CxC+D56LHc0=;
        b=0UEXUzbelLXaJLIzp1Dexkpeoe6cjqQxVvnN3ushfdp/pNHqBMyhqaYXAC4df17dq0
         1Wg/NQGCpLMqo55oDbSQ+8YRYA2cUQ+cncr+lXVw6yuTtQzrTUFCDNisghhD3T1cgmJ+
         l6KY9sbkBNxVWykagM4MJGWAohsM5M6nxK1bW0rv22UzCHdvtEO4OoRiKwPFUeWKe+Ot
         8AKZdxzzP2Ms/WmRJF1br/7rslq0HiMRiBGoMe6s2fjXawSj8Q/wS3otIYkXan8wnQs4
         4pfggVnwoPoeE3xzCV8Qz3u+ncYKtk6b9eHVCYfecoOVKvZbqVmiSpyjxcw5NtEtittc
         koNA==
X-Gm-Message-State: ANoB5pnRPREY7EtVNhT7cugIc7z6wNux2wIIH7uqONSm2RzxPV13iIvv
        ngtZyoBZ1pxvElEYZzi5Tmn7Jw4NUA0aQoav4CrYqFq04LGKcmoec7S0hzJW6cqSvRxECtNrWAw
        1eETKS+Q1Th3YSKKV6KQ1GA==
X-Received: by 2002:aa7:988b:0:b0:574:c00f:7df4 with SMTP id r11-20020aa7988b000000b00574c00f7df4mr34335302pfl.49.1669964703757;
        Thu, 01 Dec 2022 23:05:03 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6+uOPbsV0aKVJWVBn/VPtaF7qkmBZAZgVT8Fwp1K6n4GRw4u+9BljLZ+yDyj8wuyl3DTDEPQ==
X-Received: by 2002:aa7:988b:0:b0:574:c00f:7df4 with SMTP id r11-20020aa7988b000000b00574c00f7df4mr34335288pfl.49.1669964703486;
        Thu, 01 Dec 2022 23:05:03 -0800 (PST)
Received: from [10.72.12.244] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a14-20020a170902ecce00b00186b1bfbe79sm4832643plh.66.2022.12.01.23.05.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 23:05:03 -0800 (PST)
Subject: Re: [PATCH] ceph: make sure all the files successfully put before
 unmounting
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        khiremat@redhat.com, linux-fscrypt@vger.kernel.org
References: <20221201065800.18149-1-xiubli@redhat.com>
 <Y4j+Ccqzi6JxWchv@sol.localdomain> <Y4kYN8FPeq6NDe5i@gmail.com>
 <b30e579d-6919-d35b-aaa5-b71129a32810@redhat.com>
 <Y4l8vDmKIpypc8I3@sol.localdomain>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c0925b4f-ef5f-31fc-1bd0-05fa097b6b34@redhat.com>
Date:   Fri, 2 Dec 2022 15:04:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Y4l8vDmKIpypc8I3@sol.localdomain>
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


On 02/12/2022 12:19, Eric Biggers wrote:
> On Fri, Dec 02, 2022 at 09:49:49AM +0800, Xiubo Li wrote:
>> On 02/12/2022 05:10, Eric Biggers wrote:
>>> On Thu, Dec 01, 2022 at 11:18:33AM -0800, Eric Biggers wrote:
>>>> On Thu, Dec 01, 2022 at 02:58:00PM +0800, xiubli@redhat.com wrote:
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> When close a file it will be deferred to call the fput(), which
>>>>> will hold the inode's i_count. And when unmounting the mountpoint
>>>>> the evict_inodes() may skip evicting some inodes.
>>>>>
>>>>> If encrypt is enabled the kernel generate a warning when removing
>>>>> the encrypt keys when the skipped inodes still hold the keyring:
>>>> This does not make sense.  Unmounting is only possible once all the files on the
>>>> filesystem have been closed.
>>>>
>>> Specifically, __fput() puts the reference to the dentry (and thus the inode)
>>> *before* it puts the reference to the mount.  And an unmount cannot be done
>>> while the mount still has references.  So there should not be any issue here.
>> Eric,
>>
>> When I unmounting I can see the following logs, which I added a debug log in
>> the evcit_inodes():
>>
>> diff --git a/fs/inode.c b/fs/inode.c
>> index b608528efd3a..f6e69b778d9c 100644
>> --- a/fs/inode.c
>> +++ b/fs/inode.c
>> @@ -716,8 +716,11 @@ void evict_inodes(struct super_block *sb)
>>   again:
>>          spin_lock(&sb->s_inode_list_lock);
>>          list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
>> -               if (atomic_read(&inode->i_count))
>> +               if (atomic_read(&inode->i_count)) {
>> +                       printk("evict_inodes inode %p, i_count = %d, was
>> skipped!\n",
>> +                              inode, atomic_read(&inode->i_count));
>>                          continue;
>> +               }
>>
>>                  spin_lock(&inode->i_lock);
>>                  if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
>>
>> The logs:
>>
>> <4>[   95.977395] evict_inodes inode 00000000f90aab7b, i_count = 1, was
>> skipped!
>>
>> Any reason could cause this ? Since the inode couldn't be evicted in time
>> and then when removing the master keys it will print this warning.
>>
> It is expected for evict_inodes() to see some inodes with nonzero refcount, but
> they should only be filesystem internal inodes.  For example, with ext4 this
> happens with the journal inode.
>
> However, filesystem internal inodes cannot be encrypted, so they are irrelevant
> here.
>
> I'd guess that CephFS has a bug where it is leaking a reference to a user inode
> somewhere.

I also added some debug logs to tracker all the inodes in ceph, and all 
the requests has been finished.

I will debug it more to see whether it's leaking a reference here.

Thanks Eric.

- Xiubo


> (Based on the code, it might also be possible for evict_inodes() to also see
> nonzero refcount inodes due to fsnotify.  However, fsnotify_sb_delete() runs
> before fscrypt_destroy_keyring(), so likewise it seems irrelevant here.)
>
> - Eric
>


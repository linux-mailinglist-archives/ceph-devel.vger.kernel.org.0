Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C91694671
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Feb 2023 14:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjBMNA4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Feb 2023 08:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjBMNAz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Feb 2023 08:00:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737A4126D2
        for <ceph-devel@vger.kernel.org>; Mon, 13 Feb 2023 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676293205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wswbsgQlZ9iytax1REzyEwFKOHT3ydadeWDut02Lvio=;
        b=OiWR0aZbUolV3KmVAR1sjxW9sLnTC18HlIwtczZenqC8llYmxfprISltjW0h9WIkDyg/Hs
        1ujuqt5NPeEaHpjltZbQoQixPYLXj3JUA2/QNIIBf0O4nLqpZBeJ0YzpBBoJJEApDv6Ojg
        0T/bii2V+v06CCDhm5oXDCSguCzJ8UE=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-465-9Yr9Zb1CPzyBWxje_-6ctA-1; Mon, 13 Feb 2023 08:00:04 -0500
X-MC-Unique: 9Yr9Zb1CPzyBWxje_-6ctA-1
Received: by mail-pl1-f199.google.com with SMTP id h15-20020a170902f7cf00b0019a819e2d93so3953822plw.4
        for <ceph-devel@vger.kernel.org>; Mon, 13 Feb 2023 05:00:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wswbsgQlZ9iytax1REzyEwFKOHT3ydadeWDut02Lvio=;
        b=DH1nJ9jWJnoVejUagSj4zaygxiKWspV9AXjmNi+f0FvwZPDbgj04JuJwOgnaRie164
         PWoPam4eHSKJPgPpVStnWqU9RrLyXY/+wXh0Rc8p7lTGOsHsk0hdE3ZKMHB5HSofkSj3
         GmISnCkQc+qfuIU8luOxkKic6vPICPvKBowSZXv40qFf3b7a99GL6EJb8Y0z8Lf3+5vs
         3GnpnWaD4mQncSYc7XRpzU23gkNaV/+byC3hTUfJdrmhOyH4S0bsxsxpSAVA9ZAplAmO
         utWhcnLHd72Jkiih8+MYvJ7mv3YEu23dvKM0RIGGrW/yAR/PjG64b+EYFhMDYy+L4Hep
         aQRA==
X-Gm-Message-State: AO0yUKUxAfemyVtvCz5ND8FtUkdeCC3tQS6H2j/zn5JAcjiOX0ZMvxyh
        kRHLal1KlUXPgqJ51R46fHccOJFsgfuICeI5useUuzHhlkHY6Vtlw7rKUS+mMp67uQ7DPQjfkoc
        Hxlm9eLGoPVTsbXwyjt4cvQ==
X-Received: by 2002:a17:903:11d0:b0:196:704e:2c9a with SMTP id q16-20020a17090311d000b00196704e2c9amr30234616plh.22.1676293202034;
        Mon, 13 Feb 2023 05:00:02 -0800 (PST)
X-Google-Smtp-Source: AK7set+3aE1YrOaunac2oNSqgSUDRb7h0ekWO+C/yQh4em9x8+7nZCpwem1e9E13hhMJIcASJ1hnlg==
X-Received: by 2002:a17:903:11d0:b0:196:704e:2c9a with SMTP id q16-20020a17090311d000b00196704e2c9amr30234592plh.22.1676293201722;
        Mon, 13 Feb 2023 05:00:01 -0800 (PST)
Received: from [10.72.13.220] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id v14-20020a17090331ce00b0019625428cefsm3777917ple.281.2023.02.13.04.59.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 05:00:01 -0800 (PST)
Message-ID: <0700f314-63fa-9324-94d2-5815daca2734@redhat.com>
Date:   Mon, 13 Feb 2023 20:59:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] ceph: update the time stamps and try to drop the
 suid/sgid
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        Ceph Development <ceph-devel@vger.kernel.org>
Cc:     vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
References: <20230213111038.15021-1-xiubli@redhat.com>
 <732e55f69d06c4e0de3c5c7eee10f254253391f6.camel@kernel.org>
Content-Language: en-US
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <732e55f69d06c4e0de3c5c7eee10f254253391f6.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 13/02/2023 20:37, Jeff Layton wrote:
> On Mon, 2023-02-13 at 19:10 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The fallocate will try to clear the suid/sgid if a unprevileged user
>> changed the file.
>>
>> There is no Posix item requires that we should clear the suid/sgid
>> in fallocate code path but this is the default behaviour for most of
>> the filesystems and the VFS layer. And also the same for the write
>> code path, which have already support it.
>>
> Huh, you're right. It really doesn't say anything about the timestamps
> or setuid bits:
>
>      https://pubs.opengroup.org/onlinepubs/9699919799/functions/posix_fallocate.html
>
>
> That's arguably a bug in the spec. It really does need to do those
> things.

Yeah.

Also the kernel fuse code and libfuse also need to be improved to make 
ceph-fuse work.

Thanks Jeff.

- Xiubo

>> And also we need to update the time stamps since the fallocate will
>> change the file contents.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://tracker.ceph.com/issues/58054
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/file.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 903de296f0d3..dee3b445f415 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -2502,6 +2502,9 @@ static long ceph_fallocate(struct file *file, int mode,
>>   	loff_t endoff = 0;
>>   	loff_t size;
>>   
>> +	dout("%s %p %llx.%llx mode %x, offset %llu length %llu\n", __func__,
>> +	     inode, ceph_vinop(inode), mode, offset, length);
>> +
>>   	if (mode != (FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
>>   		return -EOPNOTSUPP;
>>   
>> @@ -2539,6 +2542,10 @@ static long ceph_fallocate(struct file *file, int mode,
>>   	if (ret < 0)
>>   		goto unlock;
>>   
>> +	ret = file_modified(file);
>> +	if (ret)
>> +		goto put_caps;
>> +
>>   	filemap_invalidate_lock(inode->i_mapping);
>>   	ceph_fscache_invalidate(inode, false);
>>   	ceph_zero_pagecache_range(inode, offset, length);
>> @@ -2554,6 +2561,7 @@ static long ceph_fallocate(struct file *file, int mode,
>>   	}
>>   	filemap_invalidate_unlock(inode->i_mapping);
>>   
>> +put_caps:
>>   	ceph_put_cap_refs(ci, got);
>>   unlock:
>>   	inode_unlock(inode);
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E094553EB
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Nov 2021 05:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242276AbhKREtt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 Nov 2021 23:49:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46704 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242143AbhKREts (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 23:49:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637210808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xA8OxhdwnkDN9JF42bFkZw+a/31LAXgeqsfQIL7DpyE=;
        b=AJPGyn64mwsHrHfHYtKPysQARt5R1kBqFh3Ft7zu97LnJVWxnoBti0pXmWxxq/3L27HsRr
        XXtriVnwfqtwBHbM5gRH4dfs7YoWZ9fmcOG7ab7yr+HJVPSq0yNJb8zbCjUOb1krLL9h3w
        SuKX+uhFPubnNwKsp1OLo9DFJ2c+fBI=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-303-071fNpTaPgqKuyenZbNf5w-1; Wed, 17 Nov 2021 23:46:47 -0500
X-MC-Unique: 071fNpTaPgqKuyenZbNf5w-1
Received: by mail-pg1-f200.google.com with SMTP id h35-20020a63f923000000b002d5262fdfc4so2103157pgi.2
        for <ceph-devel@vger.kernel.org>; Wed, 17 Nov 2021 20:46:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=xA8OxhdwnkDN9JF42bFkZw+a/31LAXgeqsfQIL7DpyE=;
        b=W8e06yN3qPBtRmHktAFwARmuE3AWBlbXh4o5VuzJ4B/FOLlUTCV92mEn0Sq/uuCKJ+
         Ctl22CGTAaAooiHAQPIVYJWlnbT5suVDy5shML7S+CVlkAKkijVqPQz6j1lnshkgoFtF
         jyfZEt19VngmmUKxecIWfQynB/pNrV7shbUIIRNhK8+jevHs8l7+8SZVyK+k64tXRBYQ
         y2YVqvyVKVg5h0RvE+xlixvYjdnTRYnTnsJf4dyBsc/cMJgGxRvWjzzPy4/eGb7D0b7N
         4d8tOWvAMKDDQB2qXQIY0Yi9cVzfXErRmd6w1VJVhFoT6vRvW0idTBWp3vUp513j6d12
         4Ibg==
X-Gm-Message-State: AOAM531hisu5fiwabwXSJGGQWpwpx5Cd2pdw7CX0xsRAIeiPYRPvJGtI
        SidNte1GMSGn3BaXQASyPVQK7WYRzyAe/4D5hps3Q132udn7glyD9E9fvP68HVhrpHJlekMZul4
        8+qFeESHGvW1ARJOOZzGngspsy9Id/mqSIWPvFKf8JKeuNra2P7evhrvfunSatYHHdzITRNI=
X-Received: by 2002:a63:2a8d:: with SMTP id q135mr9180389pgq.167.1637210805877;
        Wed, 17 Nov 2021 20:46:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwe3VaLoYTtmon5UZbl3ufQ76WhX3oXxOAkI5hh0AxY1EAXSn2Y/EABu+GoIHFDj3vorUePIA==
X-Received: by 2002:a63:2a8d:: with SMTP id q135mr9180360pgq.167.1637210805503;
        Wed, 17 Nov 2021 20:46:45 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l17sm1332562pfc.94.2021.11.17.20.46.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 20:46:44 -0800 (PST)
Subject: Re: [PATCH] ceph: do not truncate pagecache if truncate size doesn't
 change
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20211116092002.99439-1-xiubli@redhat.com>
 <e1e4365e92281675aad8cd9617e9111d7903564f.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <2d8dd70e-4f71-9dd8-3ec0-f8e0a5115449@redhat.com>
Date:   Thu, 18 Nov 2021 12:46:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <e1e4365e92281675aad8cd9617e9111d7903564f.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/18/21 5:10 AM, Jeff Layton wrote:
> On Tue, 2021-11-16 at 17:20 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> In case truncating a file to a smaller sizeA, the sizeA will be kept
>> in truncate_size. And if truncate the file to a bigger sizeB, the
>> MDS will only increase the truncate_seq, but still using the sizeA as
>> the truncate_size.
>>
>> So when filling the inode it will truncate the pagecache by using
>> truncate_sizeA again, which makes no sense and will trim the inocent
>> pages.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/inode.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index 1b4ce453d397..b4f784684e64 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -738,10 +738,11 @@ int ceph_fill_file_size(struct inode *inode, int issued,
>>   			 * don't hold those caps, then we need to check whether
>>   			 * the file is either opened or mmaped
>>   			 */
>> -			if ((issued & (CEPH_CAP_FILE_CACHE|
>> +			if (ci->i_truncate_size != truncate_size &&
>> +			    ((issued & (CEPH_CAP_FILE_CACHE|
>>   				       CEPH_CAP_FILE_BUFFER)) ||
>>   			    mapping_mapped(inode->i_mapping) ||
>> -			    __ceph_is_file_opened(ci)) {
>> +			    __ceph_is_file_opened(ci))) {
>>   				ci->i_truncate_pending++;
>>   				queue_trunc = 1;
>>   			}
>
> This patch causes xfstest generic/129 to hang at umount time, when
> applied on top of the testing branch, and run (w/o fscrypt being
> enabled). The call stack looks like this:
>
>          [<0>] wb_wait_for_completion+0xc3/0x120
>          [<0>] __writeback_inodes_sb_nr+0x151/0x190
>          [<0>] sync_filesystem+0x59/0x100
>          [<0>] generic_shutdown_super+0x44/0x1d0
>          [<0>] kill_anon_super+0x1e/0x40
>          [<0>] ceph_kill_sb+0x5f/0xc0 [ceph]
>          [<0>] deactivate_locked_super+0x5d/0xd0
>          [<0>] cleanup_mnt+0x1f4/0x260
>          [<0>] task_work_run+0x8b/0xc0
>          [<0>] exit_to_user_mode_prepare+0x267/0x270
>          [<0>] syscall_exit_to_user_mode+0x16/0x50
>          [<0>] do_syscall_64+0x48/0x90
>          [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>           
>
> I suspect this is causing dirty data to get stuck in the cache somehow,
> but I haven't tracked down the cause in detail.

BTW, could you reproduce this every time ?

I have tried this based the "ceph-client/wip-fscrypt-size" branch by 
both enabling and disabling the "test_dummy_encryption" for many times, 
all worked well for me.

And I also tried to test this patch based "testing" branch without 
fscrypt being enabled for many times, it also worked well for me:

[root@lxbceph1 xfstests]# date; ./check generic/129; date
Thu Nov 18 12:22:25 CST 2021
FSTYP         -- ceph
PLATFORM      -- Linux/x86_64 lxbceph1 5.15.0+
MKFS_OPTIONS  -- 10.72.7.17:40543:/testB
MOUNT_OPTIONS -- -o 
name=admin,secret=AQDS3IFhEtxvORAAxn1d4FVN2bRUsc/TZMpQvQ== -o 
context=system_u:object_r:root_t:s0 10.72.47.117:40543:/testB 
/mnt/kcephfs/testD

generic/129 648s ... 603s
Ran: generic/129
Passed all 1 tests

Thu Nov 18 12:32:33 CST 2021




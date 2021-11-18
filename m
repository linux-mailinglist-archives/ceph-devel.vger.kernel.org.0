Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF95345587A
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Nov 2021 11:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245433AbhKRKC4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 Nov 2021 05:02:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55525 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245301AbhKRKCk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 18 Nov 2021 05:02:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637229578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jEbNFwcEE1NGqsh8xaT9ebrNYGASk8g4vfRKcdSWoCc=;
        b=HsVPqloujj0iHyWyU51wYce+yGAhW/LVlZUGyxuDkNHI6M6UireeBEjpaZqvMNTe9AaGRx
        aYdlHgZ7vr4qnFoHdes73c//xsrKmIF7nFSZHevaGVxXbODotXF/R3EoQqVPuhRQTWxbrS
        VspmraF2J7YFc/uptWEGkrsjccpcs1A=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-585-JOU6eiUbMY2ZoO_2WnZ5pg-1; Thu, 18 Nov 2021 04:59:37 -0500
X-MC-Unique: JOU6eiUbMY2ZoO_2WnZ5pg-1
Received: by mail-pg1-f200.google.com with SMTP id p30-20020a63951e000000b002fc109f1c72so1387432pgd.3
        for <ceph-devel@vger.kernel.org>; Thu, 18 Nov 2021 01:59:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jEbNFwcEE1NGqsh8xaT9ebrNYGASk8g4vfRKcdSWoCc=;
        b=WR5z6lILbZNSO198UpSghXzgYaXrjbwEnjpwxr8Ym7+CNgxFhlI8s8IgDTkDOysgiJ
         k9o/Pa1mF26S5CUdWytPKoHXS/Jo/mchO11Dw7pD4vpXefa0Vt+6RA5kzlEu9/P+ZXmu
         54EYK2FH59jIzDQq3Pd6hMhDDLqw8IRKC36qzGRExQ+OaYTkUvh3cX68/vQ19C2pyYqC
         WfXnoFurBYnQf4Fsl3s7deZI1DKM0ncn1Q/c58JSRxCry0jPlehwWPtx/GCFdrgwqwUO
         A2bp2N7O2wtEDOpHj+DXihgTJ7YZGkS3aawZ7A3gzd4b+znScGryBETKa+oqULlAlvEc
         dyiQ==
X-Gm-Message-State: AOAM530dcOKKDSulaI/YndSyAXJRPeKJOagDzLqSk8u6DVLqlKtvcg44
        LGohIhX2CRPfHexcsSySNQ9HB4Hu0F6cArhLeF/NvEroFjt2n2ON8tmrJMwi9Oyzx9oVeKgrlfK
        gK8TcELO1H11SGli421fv+C+hSxw5Ods2K/0iUP6/8he6MGJQZSWTGid1RwcIOlspU5rKLMQ=
X-Received: by 2002:a17:90b:4a89:: with SMTP id lp9mr9103289pjb.6.1637229575771;
        Thu, 18 Nov 2021 01:59:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxTmGxGh/XM2kyfEZccfWZNx1gn+YwLUuBtRvzeXzQmxNd4P1HeCFDkAZWjCFt6nSydKCI3Dg==
X-Received: by 2002:a17:90b:4a89:: with SMTP id lp9mr9103256pjb.6.1637229575452;
        Thu, 18 Nov 2021 01:59:35 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id lj15sm2171395pjb.12.2021.11.18.01.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 01:59:34 -0800 (PST)
Subject: Re: [PATCH] ceph: do not truncate pagecache if truncate size doesn't
 change
From:   Xiubo Li <xiubli@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20211116092002.99439-1-xiubli@redhat.com>
 <e1e4365e92281675aad8cd9617e9111d7903564f.camel@kernel.org>
 <2d8dd70e-4f71-9dd8-3ec0-f8e0a5115449@redhat.com>
Message-ID: <4a8aa249-74f3-fd7c-e88b-c02518d8b931@redhat.com>
Date:   Thu, 18 Nov 2021 17:59:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <2d8dd70e-4f71-9dd8-3ec0-f8e0a5115449@redhat.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/18/21 12:46 PM, Xiubo Li wrote:
>
> On 11/18/21 5:10 AM, Jeff Layton wrote:
>> On Tue, 2021-11-16 at 17:20 +0800, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> In case truncating a file to a smaller sizeA, the sizeA will be kept
>>> in truncate_size. And if truncate the file to a bigger sizeB, the
>>> MDS will only increase the truncate_seq, but still using the sizeA as
>>> the truncate_size.
>>>
>>> So when filling the inode it will truncate the pagecache by using
>>> truncate_sizeA again, which makes no sense and will trim the inocent
>>> pages.
>>>
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   fs/ceph/inode.c | 5 +++--
>>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>>> index 1b4ce453d397..b4f784684e64 100644
>>> --- a/fs/ceph/inode.c
>>> +++ b/fs/ceph/inode.c
>>> @@ -738,10 +738,11 @@ int ceph_fill_file_size(struct inode *inode, 
>>> int issued,
>>>                * don't hold those caps, then we need to check whether
>>>                * the file is either opened or mmaped
>>>                */
>>> -            if ((issued & (CEPH_CAP_FILE_CACHE|
>>> +            if (ci->i_truncate_size != truncate_size &&
>>> +                ((issued & (CEPH_CAP_FILE_CACHE|
>>>                          CEPH_CAP_FILE_BUFFER)) ||
>>>                   mapping_mapped(inode->i_mapping) ||
>>> -                __ceph_is_file_opened(ci)) {
>>> +                __ceph_is_file_opened(ci))) {
>>>                   ci->i_truncate_pending++;
>>>                   queue_trunc = 1;
>>>               }
>>
>> This patch causes xfstest generic/129 to hang at umount time, when
>> applied on top of the testing branch, and run (w/o fscrypt being
>> enabled). The call stack looks like this:
>>
>>          [<0>] wb_wait_for_completion+0xc3/0x120
>>          [<0>] __writeback_inodes_sb_nr+0x151/0x190
>>          [<0>] sync_filesystem+0x59/0x100
>>          [<0>] generic_shutdown_super+0x44/0x1d0
>>          [<0>] kill_anon_super+0x1e/0x40
>>          [<0>] ceph_kill_sb+0x5f/0xc0 [ceph]
>>          [<0>] deactivate_locked_super+0x5d/0xd0
>>          [<0>] cleanup_mnt+0x1f4/0x260
>>          [<0>] task_work_run+0x8b/0xc0
>>          [<0>] exit_to_user_mode_prepare+0x267/0x270
>>          [<0>] syscall_exit_to_user_mode+0x16/0x50
>>          [<0>] do_syscall_64+0x48/0x90
>>          [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> I suspect this is causing dirty data to get stuck in the cache somehow,
>> but I haven't tracked down the cause in detail.
>
> BTW, could you reproduce this every time ?
>
> I have tried this based the "ceph-client/wip-fscrypt-size" branch by 
> both enabling and disabling the "test_dummy_encryption" for many 
> times, all worked well for me.
>
> And I also tried to test this patch based "testing" branch without 
> fscrypt being enabled for many times, it also worked well for me:
>
> [root@lxbceph1 xfstests]# date; ./check generic/129; date
> Thu Nov 18 12:22:25 CST 2021
> FSTYP         -- ceph
> PLATFORM      -- Linux/x86_64 lxbceph1 5.15.0+
> MKFS_OPTIONS  -- 10.72.7.17:40543:/testB
> MOUNT_OPTIONS -- -o 
> name=admin,secret=AQDS3IFhEtxvORAAxn1d4FVN2bRUsc/TZMpQvQ== -o 
> context=system_u:object_r:root_t:s0 10.72.47.117:40543:/testB 
> /mnt/kcephfs/testD
>
> generic/129 648s ... 603s
> Ran: generic/129
> Passed all 1 tests
>
> Thu Nov 18 12:32:33 CST 2021
>
>
Have run this for several hours, till now no stuck happens locally:

   $ while [ 1 ]; do date; ./check generic/129; date; done

Is it possible that you were still using the old binaries you built ?


Thanks

BRs

-- Xiubo




Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C714451AD
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Nov 2021 11:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhKDKsT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Nov 2021 06:48:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229809AbhKDKsT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 Nov 2021 06:48:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636022740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LXeimu/TXb/OUuMPdY3K1N+s5KMD54MSBvNS008LAes=;
        b=EU/t7vNKQWYPVw4ncdHOiJkuEWgHBec3EgIs2X63zZSQASqYVCPiyv8UF84LxYrfRofpAK
        e4WV0qkJnH3I30dlb3FofZmbqH9PXZGPOpjfedIrcAw/V/LAWYZeLoFB+6nUtnAk9qc844
        RR+KAfZIiR/JupluSFKQCPoHRMbJpGA=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-StuwDNADNI2MnO12Ph6lCA-1; Thu, 04 Nov 2021 06:45:39 -0400
X-MC-Unique: StuwDNADNI2MnO12Ph6lCA-1
Received: by mail-pl1-f199.google.com with SMTP id o6-20020a170902778600b0013c8ce59005so2977020pll.2
        for <ceph-devel@vger.kernel.org>; Thu, 04 Nov 2021 03:45:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=LXeimu/TXb/OUuMPdY3K1N+s5KMD54MSBvNS008LAes=;
        b=Zy0zH/P7eacej6k20zqdu2lPdRitXZOow0WHXGfyp7vbbPRpXfQfoKpvu8aKvOmyEZ
         VY9ih0biuYx5VIMTG9c2wX93wBVa5IpmC5U3lbD+xk/X5ZSjZZrThT2nNTn16AUI/8pY
         3FwwRGRD9cfR45CO3DgSHVEBUHpXawl4qNLMKA6guIbo6PaodMbI89AYZ1+doLoQOhLf
         oBEm8jrRDVMBUfg5+Q/OhM7QwOvUf3F4hb6PDpxX+vy0uiH8HOmJq4XXc6lDjvkNJNft
         G2UB6lIaTQDQVoXaZxoXMhleroYGE8hR+wAWehu6HUnv0Y1APDX8lvlobzDtyvqO0PIF
         Cjnw==
X-Gm-Message-State: AOAM530JcnxcCkOwm+QxObINaHvUTqYaRSI3EyhGOzQdPGASjP5oLlNt
        NTE6vSaqqGH/2xPD6XsgkDM7KFxOg3QFtYvI+i0PuVvNIbXSHEJboGj0YX2cxeCaklTmwmUt0El
        t4ypOh57bLbERoKT0M0fiLVsDZjRiz88NElJe/ve7Xv6/qp/ben0DMDUZpkpWEn98HUg2OLA=
X-Received: by 2002:a17:903:18d:b0:142:8ab:d11f with SMTP id z13-20020a170903018d00b0014208abd11fmr16913472plg.47.1636022738018;
        Thu, 04 Nov 2021 03:45:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsDWBOJTvxM0idw2JIf5ibiCh+Q/2jP7IGTxNkBRuOuFO6ipKUH6jKN0j/O8chg8DRup+8Ag==
X-Received: by 2002:a17:903:18d:b0:142:8ab:d11f with SMTP id z13-20020a170903018d00b0014208abd11fmr16913438plg.47.1636022737656;
        Thu, 04 Nov 2021 03:45:37 -0700 (PDT)
Received: from [10.72.12.174] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e8sm4815042pfv.183.2021.11.04.03.45.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 03:45:37 -0700 (PDT)
Subject: Re: [PATCH v6 0/9] ceph: size handling for the fscrypt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211104055248.190987-1-xiubli@redhat.com>
 <eafc91dc-c423-4400-e4f9-b1e031c1d19a@redhat.com>
 <2e0feabf7ff29708c3d2a9608041e3ca9e78acb9.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <7109c497-9963-7f20-2b33-eafa693bd0f3@redhat.com>
Date:   Thu, 4 Nov 2021 18:45:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <2e0feabf7ff29708c3d2a9608041e3ca9e78acb9.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/4/21 6:20 PM, Jeff Layton wrote:
> Thanks. I'm now seeing a MDS crash when I run that test, but my MDS
> branch isn't quite up to date with yours. I'll rebuild that and re-test.

I didn't hit the crash today, you need to update that branch.

Let me know if you still can see it after that.

Thanks.

> Thanks,
> Jeff
>
> On Thu, 2021-11-04 at 14:00 +0800, Xiubo Li wrote:
>> The xfstests generic/014 test passed:
>>
>> [root@ceph1 xfstests]# pwd
>> /mnt/kcephfs/xfstests
>> [root@ceph1 xfstests]# cat ./local.config
>> export FSTYP=ceph
>> export TEST_DEV=10.72.49.127:40084:/test
>> export TEST_DIR=/mnt/kcephfs/test/_brpcfnn
>> export TEST_FS_MOUNT_OPTS="-o
>> test_dummy_encryption,name=admin,secret=AQDS3IFhEtxvORAAxn1d4FVN2bRUsc/TZMpQvQ=="
>>
>> [root@ceph1 xfstests]# ./check generic/014
>>
>> FSTYP         -- ceph
>> PLATFORM      -- Linux/x86_64 ceph1 5.15.0-rc6+
>>
>> generic/014 533s ... 558s
>> Ran: generic/014
>> Passed all 1 tests
>>
>>
>>
>>
>> On 11/4/21 1:52 PM, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> This patch series is based on the "wip-fscrypt-fnames" branch in
>>> repo https://github.com/ceph/ceph-client.git.
>>>
>>> And I have picked up 5 patches from the "ceph-fscrypt-size-experimental"
>>> branch in repo
>>> https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git.
>>>
>>> ====
>>>
>>> This approach is based on the discussion from V1 and V2, which will
>>> pass the encrypted last block contents to MDS along with the truncate
>>> request.
>>>
>>> This will send the encrypted last block contents to MDS along with
>>> the truncate request when truncating to a smaller size and at the
>>> same time new size does not align to BLOCK SIZE.
>>>
>>> The MDS side patch is raised in PR
>>> https://github.com/ceph/ceph/pull/43588, which is also based Jeff's
>>> previous great work in PR https://github.com/ceph/ceph/pull/41284.
>>>
>>> The MDS will use the filer.write_trunc(), which could update and
>>> truncate the file in one shot, instead of filer.truncate().
>>>
>>> This just assume kclient won't support the inline data feature, which
>>> will be remove soon, more detail please see:
>>> https://tracker.ceph.com/issues/52916
>>>
>>>
>>> Changed in V6:
>>> - Fixed the file hole bug, also have updated the MDS side PR.
>>> - Add add object version support for sync read in #8.
>>>
>>>
>>> Changed in V5:
>>> - Rebase to "wip-fscrypt-fnames" branch in ceph-client.git repo.
>>> - Pick up 5 patches from Jeff's "ceph-fscrypt-size-experimental" branch
>>>     in linux.git repo.
>>> - Add "i_truncate_pagecache_size" member support in ceph_inode_info
>>>     struct, this will be used to truncate the pagecache only in kclient
>>>     side, because the "i_truncate_size" will always be aligned to BLOCK
>>>     SIZE. In fscrypt case we need to use the real size to truncate the
>>>     pagecache.
>>>
>>>
>>> Changed in V4:
>>> - Retry the truncate request by 20 times before fail it with -EAGAIN.
>>> - Remove the "fill_last_block" label and move the code to else branch.
>>> - Remove the #3 patch, which has already been sent out separately, in
>>>     V3 series.
>>> - Improve some comments in the code.
>>>
>>>
>>> Changed in V3:
>>> - Fix possibly corrupting the file just before the MDS acquires the
>>>     xlock for FILE lock, another client has updated it.
>>> - Flush the pagecache buffer before reading the last block for the
>>>     when filling the truncate request.
>>> - Some other minore fixes.
>>>
>>>
>>>
>>> Jeff Layton (5):
>>>     libceph: add CEPH_OSD_OP_ASSERT_VER support
>>>     ceph: size handling for encrypted inodes in cap updates
>>>     ceph: fscrypt_file field handling in MClientRequest messages
>>>     ceph: get file size from fscrypt_file when present in inode traces
>>>     ceph: handle fscrypt fields in cap messages from MDS
>>>
>>> Xiubo Li (4):
>>>     ceph: add __ceph_get_caps helper support
>>>     ceph: add __ceph_sync_read helper support
>>>     ceph: add object version support for sync read
>>>     ceph: add truncate size handling support for fscrypt
>>>
>>>    fs/ceph/caps.c                  | 136 ++++++++++++++----
>>>    fs/ceph/crypto.h                |   4 +
>>>    fs/ceph/dir.c                   |   3 +
>>>    fs/ceph/file.c                  |  76 ++++++++--
>>>    fs/ceph/inode.c                 | 243 +++++++++++++++++++++++++++++---
>>>    fs/ceph/mds_client.c            |   9 +-
>>>    fs/ceph/mds_client.h            |   2 +
>>>    fs/ceph/super.h                 |  25 ++++
>>>    include/linux/ceph/crypto.h     |  28 ++++
>>>    include/linux/ceph/osd_client.h |   6 +-
>>>    include/linux/ceph/rados.h      |   4 +
>>>    net/ceph/osd_client.c           |   5 +
>>>    12 files changed, 482 insertions(+), 59 deletions(-)
>>>    create mode 100644 include/linux/ceph/crypto.h
>>>


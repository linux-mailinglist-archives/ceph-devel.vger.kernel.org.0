Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB2E444E95
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Nov 2021 07:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhKDGDd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Nov 2021 02:03:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55236 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229968AbhKDGDb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 Nov 2021 02:03:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636005653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=22dLfARZ9cdOpl2vt0JbGYZdpnNfGqH+W6NHYwLxFdY=;
        b=EQTq3reXYtC4JYZbwyLsw7Hq4Ji9oqXkPhb1szp6y9p3kA1uM7KTjbO8YwMvhI1S646HmK
        qO0Yv6QxJ4HUQekKb0VsBRwugr5h/xYgXglnk9rOW21Z7ZCJpeGwnX0vDEwxasM3rro1Ae
        QK980hWp9moeOwgmvEl2nyjhu2oEWUk=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-kxPdE-_WPe64Jb9prxWWkQ-1; Thu, 04 Nov 2021 02:00:52 -0400
X-MC-Unique: kxPdE-_WPe64Jb9prxWWkQ-1
Received: by mail-pl1-f200.google.com with SMTP id q2-20020a170902dac200b001422673d86fso1559574plx.20
        for <ceph-devel@vger.kernel.org>; Wed, 03 Nov 2021 23:00:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=22dLfARZ9cdOpl2vt0JbGYZdpnNfGqH+W6NHYwLxFdY=;
        b=EKMY0T42jf0BCxRFebr2xZJI4hWmFYHeZYOXTBRJCYXRSpdulhiZ1CwqwxhOtm8ZFP
         hqAwVjn9zXjNOIojHzJYv4TbfOg8GLWhB6pwJGwjNlJo0OC7G6rGCwZ6PWOBdu5TTrdI
         nlYr+1IeeFlDPuvOMpScK9wjF14IdoQlLFZosaLRr6cdxiAK50QI6Goz/wYQjVMOmrEh
         srwnVJ1ZKaW5biSzefCkUFc8iRGU9Me8zPmFJGsezUZ04sR0lynj2ciAyRwYMAjs4IK3
         FrO8ivFxcCWSpdy/fkzvZrRjZYpPpZK2diVCguUpNpJQUQzVh/lnjM+e7OvYYJ9kD13c
         TIfg==
X-Gm-Message-State: AOAM530jI5KEUlsrYqYZKna6MSbB/fam2D0NVGglbVKS13QrWj6o8T5F
        4pcrwcUYkV+jYPKhNqNXlKTwpI9c/pQZ99o/S9P1BClvsYVI+CIViL7LZXqqBdYPKfGkqaGWIds
        /KA/7q7+d4fKvUSyWGv3n4LGYBBRdtyN5vjWeKEtDwAZ9zoLt+VStWsoxIfofKqKQFCGPWH4=
X-Received: by 2002:a05:6a00:a23:b0:43d:e856:a3d4 with SMTP id p35-20020a056a000a2300b0043de856a3d4mr50053105pfh.17.1636005650692;
        Wed, 03 Nov 2021 23:00:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwucSxY0m5QcSDxrpGgNkPFYG9sRHXBaVafbqNKde95ndnqlZh69F1VRSNLTn1pdIVfPGdgrA==
X-Received: by 2002:a05:6a00:a23:b0:43d:e856:a3d4 with SMTP id p35-20020a056a000a2300b0043de856a3d4mr50053063pfh.17.1636005650310;
        Wed, 03 Nov 2021 23:00:50 -0700 (PDT)
Received: from [10.72.12.174] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t13sm3194346pgn.94.2021.11.03.23.00.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 23:00:49 -0700 (PDT)
Subject: Re: [PATCH v6 0/9] ceph: size handling for the fscrypt
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211104055248.190987-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <eafc91dc-c423-4400-e4f9-b1e031c1d19a@redhat.com>
Date:   Thu, 4 Nov 2021 14:00:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211104055248.190987-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The xfstests generic/014 test passed:

[root@ceph1 xfstests]# pwd
/mnt/kcephfs/xfstests
[root@ceph1 xfstests]# cat ./local.config
export FSTYP=ceph
export TEST_DEV=10.72.49.127:40084:/test
export TEST_DIR=/mnt/kcephfs/test/_brpcfnn
export TEST_FS_MOUNT_OPTS="-o 
test_dummy_encryption,name=admin,secret=AQDS3IFhEtxvORAAxn1d4FVN2bRUsc/TZMpQvQ=="

[root@ceph1 xfstests]# ./check generic/014

FSTYP         -- ceph
PLATFORM      -- Linux/x86_64 ceph1 5.15.0-rc6+

generic/014 533s ... 558s
Ran: generic/014
Passed all 1 tests




On 11/4/21 1:52 PM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> This patch series is based on the "wip-fscrypt-fnames" branch in
> repo https://github.com/ceph/ceph-client.git.
>
> And I have picked up 5 patches from the "ceph-fscrypt-size-experimental"
> branch in repo
> https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git.
>
> ====
>
> This approach is based on the discussion from V1 and V2, which will
> pass the encrypted last block contents to MDS along with the truncate
> request.
>
> This will send the encrypted last block contents to MDS along with
> the truncate request when truncating to a smaller size and at the
> same time new size does not align to BLOCK SIZE.
>
> The MDS side patch is raised in PR
> https://github.com/ceph/ceph/pull/43588, which is also based Jeff's
> previous great work in PR https://github.com/ceph/ceph/pull/41284.
>
> The MDS will use the filer.write_trunc(), which could update and
> truncate the file in one shot, instead of filer.truncate().
>
> This just assume kclient won't support the inline data feature, which
> will be remove soon, more detail please see:
> https://tracker.ceph.com/issues/52916
>
>
> Changed in V6:
> - Fixed the file hole bug, also have updated the MDS side PR.
> - Add add object version support for sync read in #8.
>
>
> Changed in V5:
> - Rebase to "wip-fscrypt-fnames" branch in ceph-client.git repo.
> - Pick up 5 patches from Jeff's "ceph-fscrypt-size-experimental" branch
>    in linux.git repo.
> - Add "i_truncate_pagecache_size" member support in ceph_inode_info
>    struct, this will be used to truncate the pagecache only in kclient
>    side, because the "i_truncate_size" will always be aligned to BLOCK
>    SIZE. In fscrypt case we need to use the real size to truncate the
>    pagecache.
>
>
> Changed in V4:
> - Retry the truncate request by 20 times before fail it with -EAGAIN.
> - Remove the "fill_last_block" label and move the code to else branch.
> - Remove the #3 patch, which has already been sent out separately, in
>    V3 series.
> - Improve some comments in the code.
>
>
> Changed in V3:
> - Fix possibly corrupting the file just before the MDS acquires the
>    xlock for FILE lock, another client has updated it.
> - Flush the pagecache buffer before reading the last block for the
>    when filling the truncate request.
> - Some other minore fixes.
>
>
>
> Jeff Layton (5):
>    libceph: add CEPH_OSD_OP_ASSERT_VER support
>    ceph: size handling for encrypted inodes in cap updates
>    ceph: fscrypt_file field handling in MClientRequest messages
>    ceph: get file size from fscrypt_file when present in inode traces
>    ceph: handle fscrypt fields in cap messages from MDS
>
> Xiubo Li (4):
>    ceph: add __ceph_get_caps helper support
>    ceph: add __ceph_sync_read helper support
>    ceph: add object version support for sync read
>    ceph: add truncate size handling support for fscrypt
>
>   fs/ceph/caps.c                  | 136 ++++++++++++++----
>   fs/ceph/crypto.h                |   4 +
>   fs/ceph/dir.c                   |   3 +
>   fs/ceph/file.c                  |  76 ++++++++--
>   fs/ceph/inode.c                 | 243 +++++++++++++++++++++++++++++---
>   fs/ceph/mds_client.c            |   9 +-
>   fs/ceph/mds_client.h            |   2 +
>   fs/ceph/super.h                 |  25 ++++
>   include/linux/ceph/crypto.h     |  28 ++++
>   include/linux/ceph/osd_client.h |   6 +-
>   include/linux/ceph/rados.h      |   4 +
>   net/ceph/osd_client.c           |   5 +
>   12 files changed, 482 insertions(+), 59 deletions(-)
>   create mode 100644 include/linux/ceph/crypto.h
>


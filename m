Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B097CEF3A
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Oct 2023 07:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbjJSFoR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Oct 2023 01:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbjJSFno (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 19 Oct 2023 01:43:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46D0D7E
        for <ceph-devel@vger.kernel.org>; Wed, 18 Oct 2023 22:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697694138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G8zlbwxHt/Z5FNamSi38lGFeu7P9bZdQbePaDRiKQHM=;
        b=ZkscqJ7dKMgULFyHjwteA5277zmIyUJD7KM5L9zYVF1pYg6FN1cTKYx3BulxBzDQ0HEhSW
        lbmyrleXTCCnd4o9xMT13ctEdFwil9wB14Z67caSDh0IGtqtVlZz8nNLx0ESPcSZQzBXqJ
        5VCV5iHOt+WJ/8bOOVOp6/AurT4Ok8I=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-YB5DygeGOWKAwM52KbXYMQ-1; Thu, 19 Oct 2023 01:42:01 -0400
X-MC-Unique: YB5DygeGOWKAwM52KbXYMQ-1
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-d9a581346c4so10369424276.0
        for <ceph-devel@vger.kernel.org>; Wed, 18 Oct 2023 22:42:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697694121; x=1698298921;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G8zlbwxHt/Z5FNamSi38lGFeu7P9bZdQbePaDRiKQHM=;
        b=sYNFZ2VXLgU3gk+0eYyGfDPuW+trziyP6tmkmmmBLJdnlKXhXQmfU5EFChlbjYCvt4
         EanUicFP6KEYZLYbz514AKeZCY/5WfGDn8zXy875ixMyTvbRzk5TPiNwVITBXZLgh4o7
         Rxe70fbK4CQ1T7PTXL/SmKMYN+wHB4nTk5aVAx7CWVceicR2xIMG3QaQH2DGXXWq4g8c
         sUkPxCytl6PpQLqbRfE1CO4km6SWQbDhB1alLzaeECXu66p/QVAFBQ0D0GxgPMlg9FUM
         Cz2E97K0cwI8a6bfGxREQIBZPOuEg9cJ3YogK5BgrQh3xL6StSPu/lKN0sDCX1cfhd4G
         MIFQ==
X-Gm-Message-State: AOJu0Yzztk3uYolxzUO4YMJDYudOc7wIjVPwA9RsMsCvNNUTJws1so7v
        G1Ih7PwFgzt7ZaY3QHFTHsDfUoWWNGz1//VZgoZ69TeJYQl7Dx+bg4w9CLMA1hREHyPfdXppKB5
        ADcpD6k9G8Ah9iG9/xfUNhg==
X-Received: by 2002:a25:ada4:0:b0:d9a:4da4:b793 with SMTP id z36-20020a25ada4000000b00d9a4da4b793mr1564611ybi.62.1697694121144;
        Wed, 18 Oct 2023 22:42:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCNQVHtH5NQePLf/mryPHNotjCD6ykcxpSyVnw+PbqaUg1QNJxPMsBktrXdoWdFZJ4nLLCQQ==
X-Received: by 2002:a25:ada4:0:b0:d9a:4da4:b793 with SMTP id z36-20020a25ada4000000b00d9a4da4b793mr1564597ybi.62.1697694120763;
        Wed, 18 Oct 2023 22:42:00 -0700 (PDT)
Received: from [10.72.112.127] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q22-20020a62ae16000000b00688c733fe92sm4250661pff.215.2023.10.18.22.41.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Oct 2023 22:42:00 -0700 (PDT)
Message-ID: <772a6282-d690-b299-6cf4-c96dd20792fa@redhat.com>
Date:   Thu, 19 Oct 2023 13:41:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 00/12] ceph: support idmapped mounts
To:     Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230807132626.182101-1-aleksandr.mikhalitsyn@canonical.com>
 <bcda164b-e4b7-1c16-2714-13e3c6514b47@redhat.com>
 <CAEivzxf-W1-q=BkG1UndFcX_AbzH-HtHX7p6j4iAwVbKnPn+sQ@mail.gmail.com>
Content-Language: en-US
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAEivzxf-W1-q=BkG1UndFcX_AbzH-HtHX7p6j4iAwVbKnPn+sQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/17/23 17:20, Aleksandr Mikhalitsyn wrote:
> On Tue, Aug 8, 2023 at 2:45 AM Xiubo Li <xiubli@redhat.com> wrote:
>> LGTM.
>>
>> Reviewed-by: Xiubo Li <xiubli@redhat.com>
>>
>> I will queue this to the 'testing' branch and then we will run ceph qa
>> tests.
>>
>> Thanks Alex.
>>
>> - Xiubo
> Hi Xiubo,
>
> will this series be landed to 6.6?
>
> Userspace part was backported and merged to the Ceph Quincy release
> (https://github.com/ceph/ceph/pull/53139)
> And waiting to be tested and merged to the Ceph reef and pacific releases.
> But the kernel part is still in the testing branch.

This changes have been in the 'testing' branch for more than two mounts 
and well test, till now we haven't seen any issue.

IMO it should be ready.

Ilya ?

Thanks

- Xiubo


> Kind regards,
> Alex
>
>> On 8/7/23 21:26, Alexander Mikhalitsyn wrote:
>>> Dear friends,
>>>
>>> This patchset was originally developed by Christian Brauner but I'll continue
>>> to push it forward. Christian allowed me to do that :)
>>>
>>> This feature is already actively used/tested with LXD/LXC project.
>>>
>>> Git tree (based on https://github.com/ceph/ceph-client.git testing):
>>> v10: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v10
>>> current: https://github.com/mihalicyn/linux/tree/fs.idmapped.ceph
>>>
>>> In the version 3 I've changed only two commits:
>>> - fs: export mnt_idmap_get/mnt_idmap_put
>>> - ceph: allow idmapped setattr inode op
>>> and added a new one:
>>> - ceph: pass idmap to __ceph_setattr
>>>
>>> In the version 4 I've reworked the ("ceph: stash idmapping in mdsc request")
>>> commit. Now we take idmap refcounter just in place where req->r_mnt_idmap
>>> is filled. It's more safer approach and prevents possible refcounter underflow
>>> on error paths where __register_request wasn't called but ceph_mdsc_release_request is
>>> called.
>>>
>>> Changelog for version 5:
>>> - a few commits were squashed into one (as suggested by Xiubo Li)
>>> - started passing an idmapping everywhere (if possible), so a caller
>>> UID/GID-s will be mapped almost everywhere (as suggested by Xiubo Li)
>>>
>>> Changelog for version 6:
>>> - rebased on top of testing branch
>>> - passed an idmapping in a few places (readdir, ceph_netfs_issue_op_inline)
>>>
>>> Changelog for version 7:
>>> - rebased on top of testing branch
>>> - this thing now requires a new cephfs protocol extension CEPHFS_FEATURE_HAS_OWNER_UIDGID
>>> https://github.com/ceph/ceph/pull/52575
>>>
>>> Changelog for version 8:
>>> - rebased on top of testing branch
>>> - added enable_unsafe_idmap module parameter to make idmapped mounts
>>> work with old MDS server versions
>>> - properly handled case when old MDS used with new kernel client
>>>
>>> Changelog for version 9:
>>> - added "struct_len" field in struct ceph_mds_request_head as requested by Xiubo Li
>>>
>>> Changelog for version 10:
>>> - fill struct_len field properly (use cpu_to_le32)
>>> - add extra checks IS_CEPH_MDS_OP_NEWINODE(..) as requested by Xiubo to match
>>>     userspace client behavior
>>> - do not set req->r_mnt_idmap for MKSNAP operation
>>> - atomic_open: set req->r_mnt_idmap only for CEPH_MDS_OP_CREATE as userspace client does
>>>
>>> I can confirm that this version passes xfstests and
>>> tested with old MDS (without CEPHFS_FEATURE_HAS_OWNER_UIDGID)
>>> and with recent MDS version.
>>>
>>> Links to previous versions:
>>> v1: https://lore.kernel.org/all/20220104140414.155198-1-brauner@kernel.org/
>>> v2: https://lore.kernel.org/lkml/20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com/
>>> tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v2
>>> v3: https://lore.kernel.org/lkml/20230607152038.469739-1-aleksandr.mikhalitsyn@canonical.com/#t
>>> v4: https://lore.kernel.org/lkml/20230607180958.645115-1-aleksandr.mikhalitsyn@canonical.com/#t
>>> tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v4
>>> v5: https://lore.kernel.org/lkml/20230608154256.562906-1-aleksandr.mikhalitsyn@canonical.com/#t
>>> tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v5
>>> v6: https://lore.kernel.org/lkml/20230609093125.252186-1-aleksandr.mikhalitsyn@canonical.com/
>>> tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v6
>>> v7: https://lore.kernel.org/all/20230726141026.307690-1-aleksandr.mikhalitsyn@canonical.com/
>>> tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v7
>>> v8: https://lore.kernel.org/all/20230803135955.230449-1-aleksandr.mikhalitsyn@canonical.com/
>>> tree: -
>>> v9: https://lore.kernel.org/all/20230804084858.126104-1-aleksandr.mikhalitsyn@canonical.com/
>>> tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v9
>>>
>>> Kind regards,
>>> Alex
>>>
>>> Original description from Christian:
>>> ========================================================================
>>> This patch series enables cephfs to support idmapped mounts, i.e. the
>>> ability to alter ownership information on a per-mount basis.
>>>
>>> Container managers such as LXD support sharaing data via cephfs between
>>> the host and unprivileged containers and between unprivileged containers.
>>> They may all use different idmappings. Idmapped mounts can be used to
>>> create mounts with the idmapping used for the container (or a different
>>> one specific to the use-case).
>>>
>>> There are in fact more use-cases such as remapping ownership for
>>> mountpoints on the host itself to grant or restrict access to different
>>> users or to make it possible to enforce that programs running as root
>>> will write with a non-zero {g,u}id to disk.
>>>
>>> The patch series is simple overall and few changes are needed to cephfs.
>>> There is one cephfs specific issue that I would like to discuss and
>>> solve which I explain in detail in:
>>>
>>> [PATCH 02/12] ceph: handle idmapped mounts in create_request_message()
>>>
>>> It has to do with how to handle mds serves which have id-based access
>>> restrictions configured. I would ask you to please take a look at the
>>> explanation in the aforementioned patch.
>>>
>>> The patch series passes the vfs and idmapped mount testsuite as part of
>>> xfstests. To run it you will need a config like:
>>>
>>> [ceph]
>>> export FSTYP=ceph
>>> export TEST_DIR=/mnt/test
>>> export TEST_DEV=10.103.182.10:6789:/
>>> export TEST_FS_MOUNT_OPTS="-o name=admin,secret=$password
>>>
>>> and then simply call
>>>
>>> sudo ./check -g idmapped
>>>
>>> ========================================================================
>>>
>>> Alexander Mikhalitsyn (3):
>>>     fs: export mnt_idmap_get/mnt_idmap_put
>>>     ceph: add enable_unsafe_idmap module parameter
>>>     ceph: pass idmap to __ceph_setattr
>>>
>>> Christian Brauner (9):
>>>     ceph: stash idmapping in mdsc request
>>>     ceph: handle idmapped mounts in create_request_message()
>>>     ceph: pass an idmapping to mknod/symlink/mkdir
>>>     ceph: allow idmapped getattr inode op
>>>     ceph: allow idmapped permission inode op
>>>     ceph: allow idmapped setattr inode op
>>>     ceph/acl: allow idmapped set_acl inode op
>>>     ceph/file: allow idmapped atomic_open inode op
>>>     ceph: allow idmapped mounts
>>>
>>>    fs/ceph/acl.c                 |  6 +--
>>>    fs/ceph/crypto.c              |  2 +-
>>>    fs/ceph/dir.c                 |  4 ++
>>>    fs/ceph/file.c                | 11 ++++-
>>>    fs/ceph/inode.c               | 29 +++++++------
>>>    fs/ceph/mds_client.c          | 78 ++++++++++++++++++++++++++++++++---
>>>    fs/ceph/mds_client.h          |  8 +++-
>>>    fs/ceph/super.c               |  7 +++-
>>>    fs/ceph/super.h               |  3 +-
>>>    fs/mnt_idmapping.c            |  2 +
>>>    include/linux/ceph/ceph_fs.h  | 10 ++++-
>>>    include/linux/mnt_idmapping.h |  3 ++
>>>    12 files changed, 136 insertions(+), 27 deletions(-)
>>>


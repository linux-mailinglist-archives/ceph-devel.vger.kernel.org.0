Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C0875F7BF
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Jul 2023 15:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjGXNEN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Jul 2023 09:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjGXNDz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Jul 2023 09:03:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1343C0A
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jul 2023 06:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690203704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yjB4tGi6o4PfDn54ouHRenkMsxu+4jFrKVnM/Niz5tQ=;
        b=GSFtuYp//Kuj/vu9eg2n50dkkCHugZb0GpYGKs/eDTJTmVOcg2IfPMUhznCbuhUo/BKHog
        d9uWKgM6yvMd08/WuMOFX5PHbwLSfPA2XmfLmhYWDUJWnQ2nwJYYWtYML0Yt+oVBdTTTEF
        jDOiRxha+OFFx/H8reugjI8F7qKYheg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-eoUUDE1pMbGGG8S94UKCPQ-1; Mon, 24 Jul 2023 09:01:42 -0400
X-MC-Unique: eoUUDE1pMbGGG8S94UKCPQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-978a991c3f5so386237766b.0
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jul 2023 06:01:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690203702; x=1690808502;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yjB4tGi6o4PfDn54ouHRenkMsxu+4jFrKVnM/Niz5tQ=;
        b=CaUKLdQCxKB/3Ka3pLsYgKliUcBkyTO/Z3s9PgiQd+X7Kn5+OiRGVh7vTIlsHMzoFB
         DIBvsu74q+43rBlQNKHBf/qXylbqg5ZhJqocfSPdvfCwMpxpIVa4ajBoazxuBtAoxb1R
         tBg1cZkGJZW8FYw/e/bnwmzs+C3bXuGB5mtxoqf0XlI9zAKZhI60EGrVUiMfTZqvPQcH
         EWdW9Pa9x7uxNPytwvrAIH4orSJmZZSACRFV5ff1t8sLmmKjMja4vRmBJRQWZ1bHgXDn
         1E82CQ1lHmiQdX6XSVClNkGGJ6jR7mFO88fXFYIelb6ObrDFK8BJuMn9+flK/Yzj4D1w
         18Zw==
X-Gm-Message-State: ABy/qLZAwph/CthOX32mBM6cPBBBVtQrxVPZV7kWSVC917bJpwYZB9td
        tieyTvophKlYefa1wcoVoxzn5VmPDnWKYkDI+yD63AUlak23lDiFAs517c1y5EJQzzwijCzDrar
        xpil4fuX4k+NQGAQjQjZt0stooZBiTJJ+0qCQmA==
X-Received: by 2002:a17:906:53d0:b0:994:4e16:d430 with SMTP id p16-20020a17090653d000b009944e16d430mr11055164ejo.20.1690203701882;
        Mon, 24 Jul 2023 06:01:41 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGGeZ5HD1U5teFVaanTO6MLVChQWedOqRw6odcsNkl6ZZPpQA3QcpLvj1wYB84ssjZz+7ZhKuaynKRpjeqwhUk=
X-Received: by 2002:a17:906:53d0:b0:994:4e16:d430 with SMTP id
 p16-20020a17090653d000b009944e16d430mr11055141ejo.20.1690203701592; Mon, 24
 Jul 2023 06:01:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230613052424.254540-1-xiubli@redhat.com>
In-Reply-To: <20230613052424.254540-1-xiubli@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Mon, 24 Jul 2023 18:31:05 +0530
Message-ID: <CAED=hWA0zaCTtNnOvYS20=kZDMbxd9HDne6+wCiaDbvndQ+E+w@mail.gmail.com>
Subject: Re: [PATCH v20 00/71] ceph+fscrypt: full support
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, lhenriques@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Looks good to me.

Reviewed-by: Milind Changire <mchangir@redhat.com>

On Tue, Jun 13, 2023 at 10:56=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
>
> This patch series is based on Jeff Layton's previous great work and effor=
t
> on this and all the patches have been in the testing branch and well test=
ed:
>
> The qa teuthology tests results:
> https://pulpito.ceph.com/xiubli-2023-06-09_03:59:14-fs:fscrypt-wip-lxb-fs=
crypt-20230607-0901-distro-default-smithi/
>
>
> Since v15 we have added the ceph qa teuthology test cases for this [1][2]=
,
> which will test both the file name and contents encryption features and a=
t
> the same time they will also test the IO benchmarks.
>
> To support the fscrypt we also have some other work in ceph [3][4][5][6][=
7][8][9]:
>
> [1] https://github.com/ceph/ceph/pull/48628
> [2] https://github.com/ceph/ceph/pull/49934
> [3] https://github.com/ceph/ceph/pull/43588
> [4] https://github.com/ceph/ceph/pull/37297
> [5] https://github.com/ceph/ceph/pull/45192
> [6] https://github.com/ceph/ceph/pull/45312
> [7] https://github.com/ceph/ceph/pull/40828
> [8] https://github.com/ceph/ceph/pull/45224
> [9] https://github.com/ceph/ceph/pull/45073
>
> The [9] is still undering testing and will soon be merged after that. All
> the others had been merged.
>
>
> The main changes since v19:
>
> - s/ceph_open/ceph_lookup/ for [PATCH v20 70/71].
> - Updated the patches to fix use-after-free bug for fscrypt_destroy_keyri=
ng,
>   the link https://patchwork.kernel.org/project/ceph-devel/list/?series=
=3D755131.
>   These new changes have been
>
>
>
> Jeff Layton (47):
>   libceph: add spinlock around osd->o_requests
>   libceph: define struct ceph_sparse_extent and add some helpers
>   libceph: add sparse read support to msgr2 crc state machine
>   libceph: add sparse read support to OSD client
>   libceph: support sparse reads on msgr2 secure codepath
>   libceph: add sparse read support to msgr1
>   ceph: add new mount option to enable sparse reads
>   ceph: preallocate inode for ops that may create one
>   ceph: make ceph_msdc_build_path use ref-walk
>   libceph: add new iov_iter-based ceph_msg_data_type and
>     ceph_osd_data_type
>   ceph: use osd_req_op_extent_osd_iter for netfs reads
>   ceph: fscrypt_auth handling for ceph
>   ceph: ensure that we accept a new context from MDS for new inodes
>   ceph: add support for fscrypt_auth/fscrypt_file to cap messages
>   ceph: implement -o test_dummy_encryption mount option
>   ceph: decode alternate_name in lease info
>   ceph: add fscrypt ioctls
>   ceph: add encrypted fname handling to ceph_mdsc_build_path
>   ceph: send altname in MClientRequest
>   ceph: encode encrypted name in dentry release
>   ceph: properly set DCACHE_NOKEY_NAME flag in lookup
>   ceph: set DCACHE_NOKEY_NAME in atomic open
>   ceph: make d_revalidate call fscrypt revalidator for encrypted
>     dentries
>   ceph: add helpers for converting names for userland presentation
>   ceph: add fscrypt support to ceph_fill_trace
>   ceph: create symlinks with encrypted and base64-encoded targets
>   ceph: make ceph_get_name decrypt filenames
>   ceph: add a new ceph.fscrypt.auth vxattr
>   ceph: add some fscrypt guardrails
>   libceph: add CEPH_OSD_OP_ASSERT_VER support
>   ceph: size handling for encrypted inodes in cap updates
>   ceph: fscrypt_file field handling in MClientRequest messages
>   ceph: handle fscrypt fields in cap messages from MDS
>   ceph: update WARN_ON message to pr_warn
>   ceph: add infrastructure for file encryption and decryption
>   libceph: allow ceph_osdc_new_request to accept a multi-op read
>   ceph: disable fallocate for encrypted inodes
>   ceph: disable copy offload on encrypted inodes
>   ceph: don't use special DIO path for encrypted inodes
>   ceph: align data in pages in ceph_sync_write
>   ceph: add read/modify/write to ceph_sync_write
>   ceph: plumb in decryption during sync reads
>   ceph: add fscrypt decryption support to ceph_netfs_issue_op
>   ceph: set i_blkbits to crypto block size for encrypted inodes
>   ceph: add encryption support to writepage
>   ceph: fscrypt support for writepages
>   ceph: report STATX_ATTR_ENCRYPTED on encrypted inodes
>
> Lu=C3=ADs Henriques (11):
>   ceph: add base64 endcoding routines for encrypted names
>   ceph: allow encrypting a directory while not having Ax caps
>   ceph: mark directory as non-complete after loading key
>   ceph: don't allow changing layout on encrypted files/directories
>   ceph: invalidate pages when doing direct/sync writes
>   ceph: add support for encrypted snapshot names
>   ceph: add support for handling encrypted snapshot names
>   ceph: update documentation regarding snapshot naming limitations
>   ceph: prevent snapshots to be created in encrypted locked directories
>   ceph: switch ceph_lookup() to use new fscrypt helper
>   ceph: switch ceph_open_atomic() to use the new fscrypt helper
>
> Xiubo Li (13):
>   ceph: make the ioctl cmd more readable in debug log
>   ceph: fix base64 encoded name's length check in ceph_fname_to_usr()
>   ceph: pass the request to parse_reply_info_readdir()
>   ceph: add ceph_encode_encrypted_dname() helper
>   ceph: add support to readdir for encrypted filenames
>   ceph: get file size from fscrypt_file when present in inode traces
>   ceph: add __ceph_get_caps helper support
>   ceph: add __ceph_sync_read helper support
>   ceph: add object version support for sync read
>   ceph: add truncate size handling support for fscrypt
>   ceph: drop the messages from MDS when unmounting
>   ceph: just wait the osd requests' callbacks to finish when unmounting
>   ceph: fix updating the i_truncate_pagecache_size for fscrypt
>
>  Documentation/filesystems/ceph.rst |  10 +
>  fs/ceph/Makefile                   |   1 +
>  fs/ceph/acl.c                      |   4 +-
>  fs/ceph/addr.c                     | 192 +++++++--
>  fs/ceph/caps.c                     | 227 ++++++++--
>  fs/ceph/crypto.c                   | 659 +++++++++++++++++++++++++++++
>  fs/ceph/crypto.h                   | 270 ++++++++++++
>  fs/ceph/dir.c                      | 188 ++++++--
>  fs/ceph/export.c                   |  44 +-
>  fs/ceph/file.c                     | 593 ++++++++++++++++++++++----
>  fs/ceph/inode.c                    | 613 ++++++++++++++++++++++++---
>  fs/ceph/ioctl.c                    | 126 +++++-
>  fs/ceph/mds_client.c               | 479 +++++++++++++++++----
>  fs/ceph/mds_client.h               |  29 +-
>  fs/ceph/quota.c                    |  14 +-
>  fs/ceph/snap.c                     |  10 +-
>  fs/ceph/super.c                    | 191 ++++++++-
>  fs/ceph/super.h                    |  46 +-
>  fs/ceph/xattr.c                    |  29 ++
>  include/linux/ceph/ceph_fs.h       |  21 +-
>  include/linux/ceph/messenger.h     |  40 ++
>  include/linux/ceph/osd_client.h    |  93 +++-
>  include/linux/ceph/rados.h         |   4 +
>  net/ceph/messenger.c               |  79 ++++
>  net/ceph/messenger_v1.c            |  98 ++++-
>  net/ceph/messenger_v2.c            | 286 ++++++++++++-
>  net/ceph/osd_client.c              | 332 ++++++++++++++-
>  27 files changed, 4261 insertions(+), 417 deletions(-)
>  create mode 100644 fs/ceph/crypto.c
>  create mode 100644 fs/ceph/crypto.h
>
> --
> 2.40.1
>


--=20
Milind


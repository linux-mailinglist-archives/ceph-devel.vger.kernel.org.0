Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F226D4871
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Apr 2023 16:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbjDCO2n (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Apr 2023 10:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233393AbjDCO2l (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Apr 2023 10:28:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCD6312BA
        for <ceph-devel@vger.kernel.org>; Mon,  3 Apr 2023 07:28:38 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 637AF1FFD1;
        Mon,  3 Apr 2023 14:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680532117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z4DrhU1vIqsRp5e/cr51j2KZETI6/BncIVSKLOd+f4E=;
        b=YyLK2mHzfgblsGWo8Qo5RtPpLgMvYPmw0EAzsCrLJNkEN5e6GA8bhAaqpwNMRmpLWfnL4Z
        whi/ZN8SBZco26yKwCw8ho2i5CTlLBM/vz4bUKJmOX+7V9UvLUod535SAFjO3eig3hLyOU
        fJhZXShmpfhbXxe1C3lvlnNgVCz468Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680532117;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z4DrhU1vIqsRp5e/cr51j2KZETI6/BncIVSKLOd+f4E=;
        b=ynSdn78EduTUT5AlMNXBmQuOaWo3A6Bdw3Kgx26t7hW6fVLiZk+ERpqBH0fIFDHFVC8NFx
        l4NxBcjjRUHp15BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E9CC113416;
        Mon,  3 Apr 2023 14:28:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZKHNNZTiKmQNGQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 03 Apr 2023 14:28:36 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 67e1a4f7;
        Mon, 3 Apr 2023 14:28:36 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com
Subject: Re: [PATCH v17 00/71] ceph+fscrypt: full support
References: <20230323065525.201322-1-xiubli@redhat.com>
Date:   Mon, 03 Apr 2023 15:28:36 +0100
In-Reply-To: <20230323065525.201322-1-xiubli@redhat.com> (xiubli@redhat.com's
        message of "Thu, 23 Mar 2023 14:54:14 +0800")
Message-ID: <87wn2t3uqz.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

xiubli@redhat.com writes:

> From: Xiubo Li <xiubli@redhat.com>
>
> This patch series is based on Jeff Layton's previous great work and effort
> on this and all the patches bas been in the testing branch since this
> Monday(20 Mar)

I've been going through this new rev[1] in the last few days and I
couldn't find any issues with it.  The rebase on top of 6.3 added minor
changes since last version (for example, there's no need to call
fscrypt_add_test_dummy_key() anymore), but everything seems to be fine.

So, FWIW, feel free to add my:

Tested-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
Reviewed-by: Lu=C3=ADs Henriques <lhenriques@suse.de>

to the whole series.

And, again, thanks a lot for your work on this!

[1] Actually, I've looked into what's currently in the 'testing' branch,
which is already slightly different from this v17.

Cheers,
--=20
Lu=C3=ADs


> Since v15 we have added the ceph qa teuthology test cases for this [1][2],
> which will test both the file name and contents encryption features and at
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
> This will depend on Eric's [10] which is a [DO NOT MERGE] patch in the
> ceph-client's testing branch temporarily.
>
> [10] https://git.kernel.org/pub/scm/fs/fscrypt/linux.git/log/?h=3Dfor-nex=
t,
>
> The main changes since v16:
>
> - rebased onto v6.3 rc3
>
> - An bug fix for size truncating, which will cause the pagecaches to be
>   incorrectly truncated.
> - Luis fixed atomic open bug for encrypted directories
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
>   ceph: switch ceph_open() to use new fscrypt helper
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
>   libceph: defer removing the req from osdc just after req->r_callback
>   ceph: drop the messages from MDS when unmounting
>   ceph: fix updating the i_truncate_pagecache_size for fscrypt
>
>  Documentation/filesystems/ceph.rst |  10 +
>  fs/ceph/Makefile                   |   1 +
>  fs/ceph/acl.c                      |   4 +-
>  fs/ceph/addr.c                     | 182 ++++++--
>  fs/ceph/caps.c                     | 226 ++++++++--
>  fs/ceph/crypto.c                   | 669 +++++++++++++++++++++++++++++
>  fs/ceph/crypto.h                   | 270 ++++++++++++
>  fs/ceph/dir.c                      | 188 ++++++--
>  fs/ceph/export.c                   |  44 +-
>  fs/ceph/file.c                     | 593 +++++++++++++++++++++----
>  fs/ceph/inode.c                    | 613 +++++++++++++++++++++++---
>  fs/ceph/ioctl.c                    | 126 +++++-
>  fs/ceph/mds_client.c               | 477 +++++++++++++++++---
>  fs/ceph/mds_client.h               |  29 +-
>  fs/ceph/quota.c                    |   4 +
>  fs/ceph/snap.c                     |   6 +
>  fs/ceph/super.c                    | 162 ++++++-
>  fs/ceph/super.h                    |  44 +-
>  fs/ceph/xattr.c                    |  29 ++
>  include/linux/ceph/ceph_fs.h       |  21 +-
>  include/linux/ceph/messenger.h     |  40 ++
>  include/linux/ceph/osd_client.h    |  93 +++-
>  include/linux/ceph/rados.h         |   4 +
>  net/ceph/messenger.c               |  79 ++++
>  net/ceph/messenger_v1.c            |  98 ++++-
>  net/ceph/messenger_v2.c            | 286 +++++++++++-
>  net/ceph/osd_client.c              | 369 +++++++++++++++-
>  27 files changed, 4260 insertions(+), 407 deletions(-)
>  create mode 100644 fs/ceph/crypto.c
>  create mode 100644 fs/ceph/crypto.h
>
> --=20
> 2.31.1
>

Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A306A397B
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 04:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjB0D3O (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 22:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjB0D3N (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 22:29:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED89B758
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 19:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677468505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wZPzmliCNLQCa8CTI9kuMKJ4ddG35bQjL478qSC2ifE=;
        b=gQWjcCyzLWQDQBr7wjezGPFIBYdxgzkwOfRw1wwuXiagz+evF/E4P5B5AI5qT865oITrH2
        6wAMcrmnzDI7KRiYU8LdX5ehPQm8NOrkO6WrztJ6AS9zNf2DfG5ShUIkW/oiSnaChZ9BUF
        kZ7XthK5yjFERlLWI6LtTJuYhVKyYsM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-uELjl_duMTWwNBCP9uM6tg-1; Sun, 26 Feb 2023 22:28:22 -0500
X-MC-Unique: uELjl_duMTWwNBCP9uM6tg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 114F129AA3B1;
        Mon, 27 Feb 2023 03:28:22 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E67B18EC2;
        Mon, 27 Feb 2023 03:28:18 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v16 00/68] ceph+fscrypt: full support
Date:   Mon, 27 Feb 2023 11:27:05 +0800
Message-Id: <20230227032813.337906-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This patch series is based on Jeff Layton's previous great work and effort
on this.

Since v15 we have added the ceph qa teuthology test cases for this [1][2],
which will test both the file name and contents encryption features and at
the same time they will also test the IO benchmarks.

To support the fscrypt we also have some other work in ceph [3][4][5][6][7][8]:

[1] https://github.com/ceph/ceph/pull/48628
[2] https://github.com/ceph/ceph/pull/49934
[3] https://github.com/ceph/ceph/pull/43588
[4] https://github.com/ceph/ceph/pull/37297
[5] https://github.com/ceph/ceph/pull/45192
[6] https://github.com/ceph/ceph/pull/45312
[7] https://github.com/ceph/ceph/pull/40828
[8] https://github.com/ceph/ceph/pull/45224
[9] https://github.com/ceph/ceph/pull/45073

The [8] and [9] are still undering testing and will soon be merged after
that. All the others had been merged long time ago.

The main changes since v15:

- rebased onto v6.2

- some minor cleanups and revises reported by:
  kernel test robot <lkp@intel.com>
  Milind Changire <mchangir@redhat.com>
  Ilya Dryomov <idryomov@gmail.com>

- Luis' fixes:
  ceph: mark directory as non-complete complete after loading key
  ceph: fix memory leak in mount error path when using test_dummy_encryption
  ceph: allow encrypting a directory while not having Ax caps

  NOTE: the second one has been folded into a previous commit.

- fixed a sequence bug to make sure the osd req->r_callback()s are
  called before removing the reqs from the osdc, which will cause
  a warning in fscrypt_destroy_keyring() and potential use-after-free
  crash bugs in other places.




Jeff Layton (47):
  libceph: add spinlock around osd->o_requests
  libceph: define struct ceph_sparse_extent and add some helpers
  libceph: add sparse read support to msgr2 crc state machine
  libceph: add sparse read support to OSD client
  libceph: support sparse reads on msgr2 secure codepath
  libceph: add sparse read support to msgr1
  ceph: add new mount option to enable sparse reads
  ceph: preallocate inode for ops that may create one
  ceph: make ceph_msdc_build_path use ref-walk
  libceph: add new iov_iter-based ceph_msg_data_type and
    ceph_osd_data_type
  ceph: use osd_req_op_extent_osd_iter for netfs reads
  ceph: fscrypt_auth handling for ceph
  ceph: ensure that we accept a new context from MDS for new inodes
  ceph: add support for fscrypt_auth/fscrypt_file to cap messages
  ceph: implement -o test_dummy_encryption mount option
  ceph: decode alternate_name in lease info
  ceph: add fscrypt ioctls
  ceph: add encrypted fname handling to ceph_mdsc_build_path
  ceph: send altname in MClientRequest
  ceph: encode encrypted name in dentry release
  ceph: properly set DCACHE_NOKEY_NAME flag in lookup
  ceph: set DCACHE_NOKEY_NAME in atomic open
  ceph: make d_revalidate call fscrypt revalidator for encrypted
    dentries
  ceph: add helpers for converting names for userland presentation
  ceph: add fscrypt support to ceph_fill_trace
  ceph: create symlinks with encrypted and base64-encoded targets
  ceph: make ceph_get_name decrypt filenames
  ceph: add a new ceph.fscrypt.auth vxattr
  ceph: add some fscrypt guardrails
  libceph: add CEPH_OSD_OP_ASSERT_VER support
  ceph: size handling for encrypted inodes in cap updates
  ceph: fscrypt_file field handling in MClientRequest messages
  ceph: handle fscrypt fields in cap messages from MDS
  ceph: update WARN_ON message to pr_warn
  ceph: add infrastructure for file encryption and decryption
  libceph: allow ceph_osdc_new_request to accept a multi-op read
  ceph: disable fallocate for encrypted inodes
  ceph: disable copy offload on encrypted inodes
  ceph: don't use special DIO path for encrypted inodes
  ceph: align data in pages in ceph_sync_write
  ceph: add read/modify/write to ceph_sync_write
  ceph: plumb in decryption during sync reads
  ceph: add fscrypt decryption support to ceph_netfs_issue_op
  ceph: set i_blkbits to crypto block size for encrypted inodes
  ceph: add encryption support to writepage
  ceph: fscrypt support for writepages
  ceph: report STATX_ATTR_ENCRYPTED on encrypted inodes

Luís Henriques (9):
  ceph: add base64 endcoding routines for encrypted names
  ceph: allow encrypting a directory while not having Ax caps
  ceph: mark directory as non-complete after loading key
  ceph: don't allow changing layout on encrypted files/directories
  ceph: invalidate pages when doing direct/sync writes
  ceph: add support for encrypted snapshot names
  ceph: add support for handling encrypted snapshot names
  ceph: update documentation regarding snapshot naming limitations
  ceph: prevent snapshots to be created in encrypted locked directories

Xiubo Li (12):
  ceph: make the ioctl cmd more readable in debug log
  ceph: fix base64 encoded name's length check in ceph_fname_to_usr()
  ceph: pass the request to parse_reply_info_readdir()
  ceph: add ceph_encode_encrypted_dname() helper
  ceph: add support to readdir for encrypted filenames
  ceph: get file size from fscrypt_file when present in inode traces
  ceph: add __ceph_get_caps helper support
  ceph: add __ceph_sync_read helper support
  ceph: add object version support for sync read
  ceph: add truncate size handling support for fscrypt
  libceph: defer removing the req from osdc just after req->r_callback
  ceph: drop the messages from MDS when unmounting

 Documentation/filesystems/ceph.rst |  10 +
 fs/ceph/Makefile                   |   1 +
 fs/ceph/acl.c                      |   4 +-
 fs/ceph/addr.c                     | 182 ++++++--
 fs/ceph/caps.c                     | 222 ++++++++--
 fs/ceph/crypto.c                   | 669 +++++++++++++++++++++++++++++
 fs/ceph/crypto.h                   | 270 ++++++++++++
 fs/ceph/dir.c                      | 187 ++++++--
 fs/ceph/export.c                   |  44 +-
 fs/ceph/file.c                     | 595 +++++++++++++++++++++----
 fs/ceph/inode.c                    | 580 +++++++++++++++++++++++--
 fs/ceph/ioctl.c                    | 126 +++++-
 fs/ceph/mds_client.c               | 477 +++++++++++++++++---
 fs/ceph/mds_client.h               |  29 +-
 fs/ceph/quota.c                    |   4 +
 fs/ceph/snap.c                     |   6 +
 fs/ceph/super.c                    | 169 +++++++-
 fs/ceph/super.h                    |  44 +-
 fs/ceph/xattr.c                    |  29 ++
 include/linux/ceph/ceph_fs.h       |  21 +-
 include/linux/ceph/messenger.h     |  40 ++
 include/linux/ceph/osd_client.h    |  93 +++-
 include/linux/ceph/rados.h         |   4 +
 net/ceph/messenger.c               |  79 ++++
 net/ceph/messenger_v1.c            |  98 ++++-
 net/ceph/messenger_v2.c            | 286 +++++++++++-
 net/ceph/osd_client.c              | 369 +++++++++++++++-
 27 files changed, 4243 insertions(+), 395 deletions(-)
 create mode 100644 fs/ceph/crypto.c
 create mode 100644 fs/ceph/crypto.h

-- 
2.31.1


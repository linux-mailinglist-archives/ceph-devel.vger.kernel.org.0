Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F275122A6
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbiD0T2X (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232613AbiD0TTL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF6CE11
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14968B8291B
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6116CC385A9;
        Wed, 27 Apr 2022 19:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086796;
        bh=rkIkDljVKYVp1JS9RmEE3Q3+p4fJ4zqOl9syu7BSNk8=;
        h=From:To:Cc:Subject:Date:From;
        b=X2AVhqsNXUnsjE1zOWW4x8fqrAIrWKbiYU3S/7TPKtmLE3DDUtSF9Fzze4yX1UiV2
         J/MsfPAktKmSejo6DFRTzNPBQcFWlAH0Uwv8fmwyzxLI6o2yaRp+YLeFQKhmAPc1K4
         aANss492jxwBBi5HGPjB5ufidWDY1Zd5OjlBDMBhJG8hQuUTre+VleDFHmyXn+QYBY
         6uFv8qcV+jA4dC2Co0dV/IFMUjoaSa4AJ/AVs34Xwz9s3F5GratwkdDRfH9utdhdTX
         BMhJ2Fb8f1KI2bXspm26rBI6axgZItpYluKSp22Ox14xz18yDxNY+EJeHXydIpdARu
         HU5YIacG6rW9w==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 00/64] ceph+fscrypt: full support
Date:   Wed, 27 Apr 2022 15:12:10 -0400
Message-Id: <20220427191314.222867-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Yet another ceph+fscrypt posting. The main changes since v13:

- rebased onto v5.18-rc4 + ceph testing branch patches, fixed up minor
  merge conflicts, and squashed a few patches together

- squashed in a number of patches from Xiubo to fix issues with
  truncation handling

- incorporated Luís' patches to encrypt snapshot names

- dropped a patch to export fscrypt's base64 implementation, since Luís'
  snapshot implementation added a new variant that we need to use.

At this point, I'm mainly waiting on Al to merge this patch into -next
and eventually into v5.19:

    fs: change test in inode_insert5 for adding to the sb list

Once that's in, it should clear the way for us to start merging the
rest of the pile (though probably not all at once).

There are also some mysterious failures that have cropped up in testing
with teuthology, particularly with thrash testing. We'll need to get to
the bottom of that before we can merge the bulk of these patches.

I've updated the wip-fscrypt branch in the ceph tree with this pile for
now. Help with testing would be welcome!

Jeff Layton (48):
  libceph: add spinlock around osd->o_requests
  libceph: define struct ceph_sparse_extent and add some helpers
  libceph: add sparse read support to msgr2 crc state machine
  libceph: add sparse read support to OSD client
  libceph: support sparse reads on msgr2 secure codepath
  libceph: add sparse read support to msgr1
  ceph: add new mount option to enable sparse reads
  fs: change test in inode_insert5 for adding to the sb list
  fscrypt: export fscrypt_fname_encrypt and fscrypt_fname_encrypted_size
  fscrypt: add fscrypt_context_for_new_inode
  ceph: preallocate inode for ops that may create one
  ceph: fscrypt_auth handling for ceph
  ceph: ensure that we accept a new context from MDS for new inodes
  ceph: add support for fscrypt_auth/fscrypt_file to cap messages
  ceph: implement -o test_dummy_encryption mount option
  ceph: decode alternate_name in lease info
  ceph: add fscrypt ioctls
  ceph: make ceph_msdc_build_path use ref-walk
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
  ceph: get file size from fscrypt_file when present in inode traces
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

Luís Henriques (7):
  ceph: add base64 endcoding routines for encrypted names
  ceph: don't allow changing layout on encrypted files/directories
  ceph: invalidate pages when doing direct/sync writes
  ceph: add support for encrypted snapshot names
  ceph: add support for handling encrypted snapshot names
  ceph: update documentation regarding snapshot naming limitations
  ceph: prevent snapshots to be created in encrypted locked directories

Xiubo Li (9):
  ceph: make the ioctl cmd more readable in debug log
  ceph: fix base64 encoded name's length check in ceph_fname_to_usr()
  ceph: pass the request to parse_reply_info_readdir()
  ceph: add ceph_encode_encrypted_dname() helper
  ceph: add support to readdir for encrypted filenames
  ceph: add __ceph_get_caps helper support
  ceph: add __ceph_sync_read helper support
  ceph: add object version support for sync read
  ceph: add truncate size handling support for fscrypt

 Documentation/filesystems/ceph.rst |  10 +
 fs/ceph/Makefile                   |   1 +
 fs/ceph/acl.c                      |   4 +-
 fs/ceph/addr.c                     | 136 ++++--
 fs/ceph/caps.c                     | 219 ++++++++--
 fs/ceph/crypto.c                   | 638 +++++++++++++++++++++++++++++
 fs/ceph/crypto.h                   | 264 ++++++++++++
 fs/ceph/dir.c                      | 187 +++++++--
 fs/ceph/export.c                   |  44 +-
 fs/ceph/file.c                     | 598 ++++++++++++++++++++++-----
 fs/ceph/inode.c                    | 579 +++++++++++++++++++++++---
 fs/ceph/ioctl.c                    | 126 +++++-
 fs/ceph/mds_client.c               | 465 +++++++++++++++++----
 fs/ceph/mds_client.h               |  24 +-
 fs/ceph/super.c                    | 107 ++++-
 fs/ceph/super.h                    |  43 +-
 fs/ceph/xattr.c                    |  29 ++
 fs/crypto/fname.c                  |  36 +-
 fs/crypto/fscrypt_private.h        |   9 +-
 fs/crypto/hooks.c                  |   6 +-
 fs/crypto/policy.c                 |  35 +-
 fs/inode.c                         |  11 +-
 include/linux/ceph/ceph_fs.h       |  21 +-
 include/linux/ceph/messenger.h     |  32 ++
 include/linux/ceph/osd_client.h    |  89 +++-
 include/linux/ceph/rados.h         |   4 +
 include/linux/fscrypt.h            |   5 +
 net/ceph/messenger.c               |   1 +
 net/ceph/messenger_v1.c            |  98 ++++-
 net/ceph/messenger_v2.c            | 287 ++++++++++++-
 net/ceph/osd_client.c              | 306 +++++++++++++-
 31 files changed, 4009 insertions(+), 405 deletions(-)
 create mode 100644 fs/ceph/crypto.c
 create mode 100644 fs/ceph/crypto.h

-- 
2.35.1


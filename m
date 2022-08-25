Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940735A1238
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242278AbiHYNbh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237455AbiHYNbh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:31:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E16724087
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:31:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECEC961CC8
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BDDC433D6;
        Thu, 25 Aug 2022 13:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434294;
        bh=QC7PgopXjY+hvTbtT7CzHbY4+apjAywl2T0jGBiiOA8=;
        h=From:To:Cc:Subject:Date:From;
        b=pVvw11u5Jqsx67b/LtUBx7Qwu/JSG4oF0VN3R5y4S5MDZtGdf+HVtoTJtgzjhkh0Z
         yP+FTxFZI101hhj6YF4ow7TwhjNGs98bIPha6RR09hmeVfExdeEimboLqQO6r4Sd1g
         E+huqz1OOSGF3mQaMATBgzSLVgNWDj72ZJdGwn75uWNucp0e7nFKSb3pm2NUwj4PNF
         FtDT/s1VKd0KAsUVnE44Oaws65j5c5CIzLuYUCS0VMI+OdndYTdG80LzIGbxhZ6nQp
         7eG+QG4cdTv+MBMtSqTofJrGPPMR3MZ9uF9Qwe7ug/m6h+jna3uk1VHNTW6fkK2gVP
         G/M7JDQIDWgGw==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 00/29] ceph: remaining patches for fscrypt support
Date:   Thu, 25 Aug 2022 09:31:03 -0400
Message-Id: <20220825133132.153657-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

v15: rebase onto current ceph/testing branch
     add some missing ceph_osdc_wait_request calls

This patchset represents the remaining patches to add fscrypt support,
rebased on top of today's "testing" branch.  They're all ceph changes as
the vfs and fscrypt patches are now merged!

Note that the current ceph-client/wip-fscrypt branch is broken. It's
still based on v5.19-rc6 and has some missing calls to
ceph_osdc_wait_request that cause panics. This set fixes that.

These are currently in my ceph-fscrypt branch:

   https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git/log/?h=ceph-fscrypt

It would be good to update the wip-fscrypt branch with this pile.

Jeff Layton (19):
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
  ceph: report STATX_ATTR_ENCRYPTED on encrypted inodes

Luís Henriques (6):
  ceph: don't allow changing layout on encrypted files/directories
  ceph: invalidate pages when doing direct/sync writes
  ceph: add support for encrypted snapshot names
  ceph: add support for handling encrypted snapshot names
  ceph: update documentation regarding snapshot naming limitations
  ceph: prevent snapshots to be created in encrypted locked directories

Xiubo Li (4):
  ceph: add __ceph_get_caps helper support
  ceph: add __ceph_sync_read helper support
  ceph: add object version support for sync read
  ceph: add truncate size handling support for fscrypt

 Documentation/filesystems/ceph.rst |  10 +
 fs/ceph/addr.c                     | 164 ++++++++--
 fs/ceph/caps.c                     | 143 +++++++--
 fs/ceph/crypto.c                   | 367 +++++++++++++++++++++--
 fs/ceph/crypto.h                   | 118 +++++++-
 fs/ceph/dir.c                      |   8 +
 fs/ceph/file.c                     | 467 +++++++++++++++++++++++++----
 fs/ceph/inode.c                    | 282 +++++++++++++++--
 fs/ceph/ioctl.c                    |   4 +
 fs/ceph/mds_client.c               |   9 +-
 fs/ceph/mds_client.h               |   2 +
 fs/ceph/super.c                    |   6 +
 fs/ceph/super.h                    |  11 +
 include/linux/ceph/osd_client.h    |   6 +-
 include/linux/ceph/rados.h         |   4 +
 net/ceph/osd_client.c              |  32 +-
 16 files changed, 1454 insertions(+), 179 deletions(-)

-- 
2.37.2


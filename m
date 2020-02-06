Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7430154162
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Feb 2020 10:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgBFJtE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Feb 2020 04:49:04 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36682 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727920AbgBFJtE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 6 Feb 2020 04:49:04 -0500
Received: by mail-wr1-f65.google.com with SMTP id z3so6334705wru.3;
        Thu, 06 Feb 2020 01:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TCOg76gZEf5aGKusRnngC0egDce6KXsYvvLSLgFFftc=;
        b=gbX3fTwJcF+rRBZ+RekGAqw+9X9tTY6kob4vePsGK6RiNsT72KNyK6pBPapLuclSvi
         0ieyZsvM+z0PWv/7LXOeU/cAD/lr1yeMskOx1/WT357qW35ePqskcYf5ZuqLAMPtiAg8
         QFspw6/PZ13ZxtpQGmi2DVlCwpCUbOqZa5LkOb9aUhFPp1ZMKl9pRuBBY2vlustDlXJF
         N1EtLd5CJG0nbRT378AjsX64VLvAq1D7UouB/v/DRU8sxTj4zVXIaRAHw4qCda2frMWw
         ysH6ylRLx9KpKvY8mnRk+VDafB7C1eULjU2n8qTPjolvmFt5A8JqcGQYIVDpo82CZ4bS
         p+Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TCOg76gZEf5aGKusRnngC0egDce6KXsYvvLSLgFFftc=;
        b=ruDxCScPMpI/G/crAZWwNZSw/IIg5FiKgK7/Sxz9eNZjx2omkK7Id+vQDAVVLgW+io
         NEz/Z8+rgG1B6ZUGXs2dKZPVn39ePOuKZXTIvcrCxqMDOEDUP2VOoA3g8zpYxd2nl7sD
         jNhO6Ekr8RvFQOAgx5HP1FJgzz5vEjfu2zsPrHWdPYF0S3T9VDU60VaEFbzXKDMngAz6
         BXAaxJRkjL/TNq4Zn15j7JerBsPsY1Ozo5mlp+fq5rSLzpksl5v28iTETVc2kk4ErjAO
         BLiSknw+lOlLkgbNahQaAd4mMRzZ/F4MdYYQ12AF2ystel02v877a1h/r2CiZIL6C3PP
         qAYw==
X-Gm-Message-State: APjAAAXepjuFuvlWKVHtOOnqUueXm/tlIgfyqK/hHV1RcS7ZRF+zO1j3
        PkLn+0PxPXoSvEUpaKorT1VxIrQxOJ8=
X-Google-Smtp-Source: APXvYqwUcEYJNPgAEoAG73w/3OeLPhtXeOQ9k00YX4XZWoxRRSUUW9UjeiIKsWaI+GPiL86wSWV2zA==
X-Received: by 2002:adf:fa87:: with SMTP id h7mr3095876wrr.172.1580982542350;
        Thu, 06 Feb 2020 01:49:02 -0800 (PST)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id p11sm3490267wrn.40.2020.02.06.01.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 01:49:01 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 5.6-rc1
Date:   Thu,  6 Feb 2020 10:48:04 +0100
Message-Id: <20200206094804.29473-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit d5226fa6dbae0569ee43ecfc08bdcd6770fc4755:

  Linux 5.5 (2020-01-26 16:23:03 -0800)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.6-rc1

for you to fetch changes up to 3325322f773bae68b20d8fa0e9e8ebb005271db5:

  rbd: set the 'device' link in sysfs (2020-01-27 16:53:40 +0100)

----------------------------------------------------------------
We have:

- a set of patches that fixes various corner cases in mount and umount
  code (Xiubo Li).  This has to do with choosing an MDS, distinguishing
  between laggy and down MDSes and parsing the server path.

- inode initialization fixes (Jeff Layton).  The one included here
  mostly concerns things like open_by_handle() and there is another
  one that will come through Al.

- copy_file_range() now uses the new copy-from2 op (Luis Henriques).
  The existing copy-from op turned out to be infeasible for generic
  filesystem use; we disable the copy offload if OSDs don't support
  copy-from2.

- a patch to link "rbd" and "block" devices together in sysfs (Hannes
  Reinecke)

And a smattering of cleanups from Xiubo, Jeff and Chengguang.

----------------------------------------------------------------
Arnd Bergmann (1):
      rbd: work around -Wuninitialized warning

Chengguang Xu (2):
      ceph: delete redundant douts in con_get/put()
      ceph: remove unnecessary assignment in ceph_pre_init_acls()

Hannes Reinecke (1):
      rbd: set the 'device' link in sysfs

Jeff Layton (6):
      ceph: drop unused ttl_from parameter from fill_inode
      ceph: ensure we have a new cap before continuing in fill_inode
      ceph: don't clear I_NEW until inode metadata is fully populated
      ceph: close holes in structs ceph_mds_session and ceph_mds_request
      ceph: print name of xattr in __ceph_{get,set}xattr() douts
      ceph: move net/ceph/ceph_fs.c to fs/ceph/util.c

Luis Henriques (1):
      ceph: use copy-from2 op in copy_file_range

Xiubo Li (14):
      ceph: fix mdsmap cluster available check based on laggy number
      ceph: only choose one MDS who is in up:active state without laggy
      ceph: fix possible long time wait during umount
      ceph: add __send_request helper
      ceph: keep the session state until it is released
      ceph: check availability of mds cluster on mount after wait timeout
      ceph: retry the same mds later after the new session is opened
      ceph: only touch the caps which have the subset mask requested
      ceph: print dentry offset in hex and fix xattr_version type
      ceph: add possible_max_rank and make the code more readable
      ceph: remove the extra slashes in the server path
      ceph: rename get_session and switch to use ceph_get_mds_session
      ceph: allocate the correct amount of extra bytes for the session features
      ceph: print r_direct_hash in hex in __choose_mds() dout

 drivers/block/rbd.c                  |   4 +-
 fs/ceph/Makefile                     |   2 +-
 fs/ceph/acl.c                        |   4 +-
 fs/ceph/caps.c                       |   3 +-
 fs/ceph/debugfs.c                    |   2 +-
 fs/ceph/dir.c                        |   4 +-
 fs/ceph/file.c                       |  11 ++-
 fs/ceph/inode.c                      |  47 +++++++---
 fs/ceph/mds_client.c                 | 171 ++++++++++++++++++++---------------
 fs/ceph/mds_client.h                 |  39 ++++----
 fs/ceph/mdsmap.c                     |  91 +++++++++++--------
 fs/ceph/super.c                      | 128 ++++++++++++++++++++++----
 fs/ceph/super.h                      |   2 +
 net/ceph/ceph_fs.c => fs/ceph/util.c |   4 -
 fs/ceph/xattr.c                      |   7 +-
 include/linux/ceph/mdsmap.h          |  11 ++-
 include/linux/ceph/osd_client.h      |   1 +
 include/linux/ceph/rados.h           |   2 +
 net/ceph/Makefile                    |   2 +-
 net/ceph/osd_client.c                |  18 ++--
 20 files changed, 360 insertions(+), 193 deletions(-)
 rename net/ceph/ceph_fs.c => fs/ceph/util.c (94%)

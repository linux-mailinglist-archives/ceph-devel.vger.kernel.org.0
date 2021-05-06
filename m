Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8CF3755B8
	for <lists+ceph-devel@lfdr.de>; Thu,  6 May 2021 16:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234901AbhEFOeN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 May 2021 10:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234485AbhEFOeM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 6 May 2021 10:34:12 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0867BC061574;
        Thu,  6 May 2021 07:33:14 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id y124-20020a1c32820000b029010c93864955so5426617wmy.5;
        Thu, 06 May 2021 07:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MQSKGPpDeg5IBUffP4uoiRdtBRjKmwAiguuNo92yskc=;
        b=WUj/k97DXc4e4L5vP5Bf69+pNXQNA0smtIO8k3gWM5qOpsw/wGBV9kwWm8shtOn0Wl
         3PP1rpzoQ0nDfEo6BtQFofBd3hE63Xq0kdePmYMtj34HLoMSfk9wobGfZCnQvM2btL30
         AZ8Z8VC0bTMPJCsiitVLbT2MzzC7YShfW3vDmvU8hH2Suf6dkgm59oi6YyO+3Kcx0fZz
         jwwWOyrM5SzZDIsgxNnTvKIFI2c9xZc/KF25QgzHfejN53v1Ng8flBPCpialcyhPKrt4
         kxL095aImh6HN4lH+3jTidEAvy4W27kwoB5GB55eX7Yluorl4cABt0c+8vWduG7tdtKg
         Hr5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MQSKGPpDeg5IBUffP4uoiRdtBRjKmwAiguuNo92yskc=;
        b=qGmzbCZsY4+qbFaTE0VnqP1k8hRH+2utHSem/GOGWE6Ish5F5GKrhcHrSqNKoC3v16
         42reuH9R0SJscUCHr1iXUCTTIQFYL3TuNnfaleWd4m/ZSqYWPqEtCoHc0UfpENN8EmOj
         FgtW5vdR7ZsLn7+fdKh9LWGjXGf46H1/hkB59ft+/ufq7bm8/b7Nu5dcjwzC4Mew9Oky
         xewEvHHUEI3iD6oFnq7xtcFlhPWmrRDOsdIPYUcWbB7qxwbr4tiDowC1C1ThlM9ZMItk
         4M1fYe/AscJAy2cOA4GbK40Ml6IfTUXk4ilfeBZskluDotFbmEbEdbUyi+m7XUblugyQ
         qufA==
X-Gm-Message-State: AOAM532C7AAcZiXWoJfzdOSxlcq5HHo1+aftPuf9yDr1ZtZbFEr3nnJV
        tuq7vjIoPH9W6OR3PTS1o5+mjuctgZksOQ==
X-Google-Smtp-Source: ABdhPJwkClpEg4vbYTmAlWwlabyXOS6LiFNR84dM56Rj9o5pUo6tHJlcrGXCTI7iE1wMofRUVB2g1A==
X-Received: by 2002:a1c:3d44:: with SMTP id k65mr4191046wma.121.1620311592749;
        Thu, 06 May 2021 07:33:12 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id b20sm4455702wmj.3.2021.05.06.07.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 07:33:12 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 5.13-rc1
Date:   Thu,  6 May 2021 16:33:12 +0200
Message-Id: <20210506143312.22281-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 9f4ad9e425a1d3b6a34617b8ea226d56a119a717:

  Linux 5.12 (2021-04-25 13:49:08 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.13-rc1

for you to fetch changes up to 3f1c6f2122fc780560f09735b6d1dbf39b44eb0f:

  libceph: allow addrvecs with a single NONE/blank address (2021-05-04 16:06:15 +0200)

There is a merge conflict in fs/ceph/dir.c because Jeff's inode
type handling patch went through the vfs tree together with Al's
inode_wrong_type() helper.  for-linus-merged has the resolution.

----------------------------------------------------------------
Notable items here are a series to take advantage of David Howells'
netfs helper library from Jeff, three new filesystem client metrics
from Xiubo, ceph.dir.rsnaps vxattr from Yanhu and two auth-related
fixes from myself, marked for stable.  Interspersed is a smattering
of assorted fixes and cleanups across the filesystem.

----------------------------------------------------------------
Gustavo A. R. Silva (1):
      ceph: fix fall-through warnings for Clang

Ilya Dryomov (4):
      Merge remote-tracking branch 'dhowells/netfs-lib'
      libceph: bump CephXAuthenticate encoding version
      libceph: don't set global_id until we get an auth ticket
      libceph: allow addrvecs with a single NONE/blank address

Jeff Layton (16):
      ceph: rip out old fscache readpage handling
      ceph: rework PageFsCache handling
      ceph: fix fscache invalidation
      ceph: convert ceph_readpage to netfs_readpage
      ceph: convert ceph_write_begin to netfs_write_begin
      ceph: convert ceph_readpages to ceph_readahead
      ceph: don't clobber i_snap_caps on non-I_NEW inode
      ceph: don't use d_add in ceph_handle_snapdir
      ceph: use attach/detach_page_private for tracking snap context
      ceph: fix kerneldoc copypasta over ceph_start_io_direct
      ceph: only check pool permissions for regular files
      ceph: fix inode leak on getattr error in __fh_to_dentry
      ceph: drop pinned_page parameter from ceph_get_caps
      ceph: convert some PAGE_SIZE invocations to thp_size()
      ceph: fix up some bare fetches of i_size
      ceph: don't allow access to MDS-private inodes

Xiubo Li (3):
      ceph: rename the metric helpers
      ceph: avoid counting the same request twice or more
      ceph: send opened files/pinned caps/opened inodes metrics to MDS daemon

Yanhu Cao (1):
      ceph: support getting ceph.dir.rsnaps vxattr

 fs/ceph/Kconfig      |   1 +
 fs/ceph/addr.c       | 626 +++++++++++++++++++++------------------------------
 fs/ceph/cache.c      | 125 ----------
 fs/ceph/cache.h      | 101 ++-------
 fs/ceph/caps.c       |  27 +--
 fs/ceph/debugfs.c    |  12 +-
 fs/ceph/dir.c        |  32 ++-
 fs/ceph/export.c     |  12 +-
 fs/ceph/file.c       |  52 ++---
 fs/ceph/inode.c      |  36 +--
 fs/ceph/io.c         |   2 +-
 fs/ceph/mds_client.c |  20 +-
 fs/ceph/mds_client.h |   1 +
 fs/ceph/metric.c     |  62 +++--
 fs/ceph/metric.h     |  56 ++++-
 fs/ceph/snap.c       |   2 +-
 fs/ceph/super.h      |  32 ++-
 fs/ceph/xattr.c      |   7 +
 net/ceph/auth.c      |  36 +--
 net/ceph/auth_x.c    |   2 +-
 net/ceph/decode.c    |  20 +-
 21 files changed, 562 insertions(+), 702 deletions(-)

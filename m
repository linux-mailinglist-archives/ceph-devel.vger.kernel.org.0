Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6F8A20B6E
	for <lists+ceph-devel@lfdr.de>; Thu, 16 May 2019 17:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfEPPkT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 May 2019 11:40:19 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:36265 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbfEPPkT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 16 May 2019 11:40:19 -0400
Received: by mail-wr1-f41.google.com with SMTP id s17so3966269wru.3;
        Thu, 16 May 2019 08:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5xSbdCo2088ZqCPrSF9g7xEVEzDABY2YcRLKAXfPGSI=;
        b=d8eJIIagruGv9s64K44RXN03oOtaC1VRjIV+RWUlOr1Kx9ptga/FXxIkPCQJxqLsN1
         vdX4qqXEz/dwFnmylryABoqw+opB/JhDZu+27N5F1dsg4WuE77dWtxSx3qJtKdkqYuFD
         JH84BYrUIXCqxgrJsMxmeAzllEGsd8BlpS0FJLGmB4/BDJliSZ7xNBp+nXN2MkHR+UiL
         6VNPSII+YeSt7H4AmHrKMD9bqCZSYMbURP05mFMLb4CsR7lRGcgVbyjwgMpXUfu7o5QE
         0LNDsROWXWQjPE08iTUrlpeNEQLQZukIOt+XISWmqdsaPD9/3R1Nm34LSbw5pkdYTKKC
         ZSgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5xSbdCo2088ZqCPrSF9g7xEVEzDABY2YcRLKAXfPGSI=;
        b=fyo0OMvBqKavHAJsuzpAGWSvu0mLo96oAebmoiBjTip8cXNeJHCmYnUUm1wO63jvoL
         38FvN1fC5F/ibYoh5867AX+O0HP9/m8YBy8S1u0ebuHrJAvOaBSQrmBBMQrPI3Abuz70
         nUc/EAQw6PynqEc+iwTOCxYyM4b8D72aZfl1almWff2CoOU4/yeHsSXH60F9aya/w8GW
         oiWieYISHt8iRnm1AHL9KqWr7Eer5kkUmSseJVm5eb74s4LvJ5axMWQs1fESi10dV2hO
         xrS7KzUd5FHufcyU6uLvHXQikgT8GEZ8HS+BSW+4fbnNwCR+ZjCf85BQR4X+teD2v1Nw
         ZEJA==
X-Gm-Message-State: APjAAAUlYV+/+L0upHkHcPHWMW/ggUVaRoyFOPkAiHEhdepxvRRpgrmg
        Fho6jUJkzj53suNONt+OP+QG0P5L
X-Google-Smtp-Source: APXvYqzHj0gHAVGWXDe4xZb3o/fP+SYr4nrHJmnNwgjUnI1lnNWjTeWwxAL19PVV2SHDhogCuMRNLA==
X-Received: by 2002:adf:b612:: with SMTP id f18mr30404470wre.236.1558021217141;
        Thu, 16 May 2019 08:40:17 -0700 (PDT)
Received: from kwango.redhat.com (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id q24sm5887339wmc.18.2019.05.16.08.40.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 May 2019 08:40:16 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 5.2-rc1
Date:   Thu, 16 May 2019 17:40:05 +0200
Message-Id: <20190516154005.22583-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit e93c9c99a629c61837d5a7fc2120cd2b6c70dbdd:

  Linux 5.1 (2019-05-05 17:42:58 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.2-rc1

for you to fetch changes up to 00abf69dd24f4444d185982379c5cc3bb7b6d1fc:

  ceph: flush dirty inodes before proceeding with remount (2019-05-07 19:43:05 +0200)

----------------------------------------------------------------
On the filesystem side we have:

- a fix to enforce quotas set above the mount point (Luis Henriques)

- support for exporting snapshots through NFS (Zheng Yan)

- proper statx implementation (Jeff Layton).  statx flags are mapped
  to MDS caps, with AT_STATX_{DONT,FORCE}_SYNC taken into account.

- some follow-up dentry name handling fixes, in particular elimination
  of our hand-rolled helper and the switch to __getname() as suggested
  by Al (Jeff Layton)

- a set of MDS client cleanups in preparation for async MDS requests
  in the future (Jeff Layton)

- a fix to sync the filesystem before remounting (Jeff Layton)

On the rbd side, work is on-going on object-map and fast-diff image
features.

----------------------------------------------------------------
Arnd Bergmann (3):
      rbd: avoid clang -Wuninitialized warning
      rbd: convert all rbd_assert(0) to BUG()
      libceph: fix clang warning for CEPH_DEFINE_OID_ONSTACK

Ilya Dryomov (2):
      rbd: client_mutex is never nested
      rbd: don't assert on writes to snapshots

Jeff Layton (20):
      ceph: remove superfluous inode_lock in ceph_fsync
      ceph: properly handle granular statx requests
      ceph: fix NULL pointer deref when debugging is enabled
      ceph: make iterate_session_caps a public symbol
      ceph: dump granular cap info in "caps" debugfs file
      ceph: fix potential use-after-free in ceph_mdsc_build_path
      ceph: use ceph_mdsc_build_path instead of clone_dentry_name
      ceph: use __getname/__putname in ceph_mdsc_build_path
      ceph: use pathlen values returned by set_request_path_attr
      ceph: after an MDS request, do callback and completions
      ceph: have ceph_mdsc_do_request call ceph_mdsc_submit_request
      ceph: move wait for mds request into helper function
      ceph: fix comment over ceph_drop_caps_for_unlink
      ceph: simplify arguments and return semantics of try_get_cap_refs
      ceph: just call get_session in __ceph_lookup_mds_session
      ceph: print inode number in __caps_issued_mask debugging messages
      libceph: fix unaligned accesses in ceph_entity_addr handling
      libceph: make ceph_pr_addr take an struct ceph_entity_addr pointer
      ceph: fix unaligned access in ceph_send_cap_releases
      ceph: flush dirty inodes before proceeding with remount

Luis Henriques (2):
      ceph: factor out ceph_lookup_inode()
      ceph: quota: fix quota subdir mounts

Yan, Zheng (1):
      ceph: snapshot nfs re-export

Zhi Zhang (1):
      ceph: remove duplicated filelock ref increase

 drivers/block/rbd.c            |  24 +--
 fs/ceph/caps.c                 |  93 +++++------
 fs/ceph/debugfs.c              |  40 ++++-
 fs/ceph/export.c               | 356 ++++++++++++++++++++++++++++++++++++++---
 fs/ceph/file.c                 |   2 +-
 fs/ceph/inode.c                |  85 ++++++----
 fs/ceph/locks.c                |  13 --
 fs/ceph/mds_client.c           | 205 ++++++++++--------------
 fs/ceph/mds_client.h           |  33 +++-
 fs/ceph/mdsmap.c               |   2 +-
 fs/ceph/quota.c                | 177 ++++++++++++++++++--
 fs/ceph/super.c                |   7 +
 fs/ceph/super.h                |   2 +
 include/linux/ceph/ceph_fs.h   |   6 +
 include/linux/ceph/messenger.h |   3 +-
 include/linux/ceph/osdmap.h    |  13 +-
 net/ceph/cls_lock_client.c     |   2 +-
 net/ceph/debugfs.c             |   4 +-
 net/ceph/messenger.c           | 121 +++++++-------
 net/ceph/mon_client.c          |   6 +-
 net/ceph/osd_client.c          |   2 +-
 21 files changed, 845 insertions(+), 351 deletions(-)

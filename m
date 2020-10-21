Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500D3294DB2
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Oct 2020 15:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410309AbgJUNhn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 21 Oct 2020 09:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410096AbgJUNhn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 21 Oct 2020 09:37:43 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AEFC0613CE;
        Wed, 21 Oct 2020 06:37:42 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id x1so2638545eds.1;
        Wed, 21 Oct 2020 06:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=45aC3rTsEhmk30k5J9dX/iwdZ2Yvj9W2pU9MupQKvp8=;
        b=FSL/MunJ9oduMmUQw7nsehTphMC6L1EzRqhTrQAx9FX92S5VdYp1hsLJqPr08yScC8
         RNdFZyrT/+BAtxdS0efL5hBHx69rX7Nh4FsysO8BE+00PBZpAvazYnrUSIZxIGiXqXlN
         s5QA0dFWuBW67p7MOYwHgcqbt43tibLPjZQi3VHHfjxEZR1cxNL/GpiyJ6JqgOKUEwvt
         vV7r7LTk6CABrHRVOsO+VeI+ZsFzb17J+/Fn+L0JJen2OPRQfJuRwCwgmMEKpVNLo/VY
         TNzilSzUcFK+ntcPSW0PwhTnDfIbEO+PYaS+aEOSda28gCgsLQ2yPjvO7fAaF/VnkBJF
         3++A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=45aC3rTsEhmk30k5J9dX/iwdZ2Yvj9W2pU9MupQKvp8=;
        b=VRNKJBkw4Yfy5A8GpZP85/1Z9qez+VH6SPxwWT3+fHBJrYfbemrXvqlKTNDkROV62V
         5Vd8jy7EIVA3qlRGP/zfODH36vu8wKU4mAPzcvnUQIalRfNuGpBKD0rXtrTPLxdr6M2Q
         I4x4n5PMOHtwIm5Vd+FmVARHIH/8L/rT9lTUpNeAmYnMYsOt+KMGxEsHuVtHZTI+UuP3
         XiDKXG/MhEJeGNnMR7YTbOU/UBnkMnu5pGIjAqTeQEcs7vok7qoRR2XIto7S9cFyxPNR
         ifli+Bj7IgFHvJq/g7xrsiJYkIvEXOTG6QzEFE+aVgEMFOrmNoaNLZ497hkJjjqUKlOx
         UcQg==
X-Gm-Message-State: AOAM530cHI1bDMf9hEWWzze2MN/KKwwwGZSVvCLsCs1BuoytU3SfY7Iz
        5+/SkjDn0w1MOMxhU2OvII1Uy30MQm0=
X-Google-Smtp-Source: ABdhPJyp6OU6dRJi4afEq5K94EJocXXl69vjZ+cqkdTDtZaTBf33Dk3hYo5kuoVobUn/ujx/Sdl3uA==
X-Received: by 2002:aa7:c305:: with SMTP id l5mr3022875edq.364.1603287461558;
        Wed, 21 Oct 2020 06:37:41 -0700 (PDT)
Received: from kwango.local (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id p24sm2078761edq.35.2020.10.21.06.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 06:37:40 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 5.10-rc1
Date:   Wed, 21 Oct 2020 15:37:33 +0200
Message-Id: <20201021133733.22298-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit bbf5c979011a099af5dc76498918ed7df445635b:

  Linux 5.9 (2020-10-11 14:15:50 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.10-rc1

for you to fetch changes up to 28e1581c3b4ea5f98530064a103c6217bedeea73:

  libceph: clear con->out_msg on Policy::stateful_server faults (2020-10-12 15:29:27 +0200)

----------------------------------------------------------------
We have:

- a patch that removes crush_workspace_mutex (myself).  CRUSH
  computations are no longer serialized and can run in parallel.

- a couple new filesystem client metrics for "ceph fs top" command
  (Xiubo Li)

- a fix for a very old messenger bug that affected the filesystem,
  marked for stable (myself)

- assorted fixups and cleanups throughout the codebase from Jeff
  and others.

----------------------------------------------------------------
Ilya Dryomov (9):
      libceph: multiple workspaces for CRUSH computations
      libceph, rbd, ceph: "blacklist" -> "blocklist"
      libceph: switch to the new "osd blocklist add" command
      ceph: add a note explaining session reject error string
      ceph: mark ceph_fmt_xattr() as printf-like for better type checking
      libceph: move a dout in queue_con_delay()
      libceph: fix ENTITY_NAME format suggestion
      libceph: format ceph_entity_addr nonces as unsigned
      libceph: clear con->out_msg on Policy::stateful_server faults

Jeff Layton (12):
      ceph: drop special-casing for ITER_PIPE in ceph_sync_read
      ceph: use kill_anon_super helper
      ceph: have ceph_writepages_start call pagevec_lookup_range_tag
      ceph: break out writeback of incompatible snap context to separate function
      ceph: don't call ceph_update_writeable_page from page_mkwrite
      ceph: fold ceph_sync_readpages into ceph_readpage
      ceph: fold ceph_sync_writepages into writepage_nounlock
      ceph: fold ceph_update_writeable_page into ceph_write_begin
      ceph: don't SetPageError on readpage errors
      ceph: drop separate mdsc argument from __send_cap
      ceph: break up send_cap_msg
      ceph: comment cleanups and clarifications

Luis Henriques (1):
      ceph: remove unnecessary return in switch statement

Matthew Wilcox (Oracle) (1):
      ceph: promote to unsigned long long before shifting

Xiubo Li (2):
      ceph: add ceph_sb_to_mdsc helper support to parse the mdsc
      ceph: metrics for opened files, pinned caps and opened inodes

Yan, Zheng (1):
      ceph: encode inodes' parent/d_name in cap reconnect message

Yanhu Cao (1):
      ceph: add column 'mds' to show caps in more user friendly

 Documentation/filesystems/ceph.rst |   6 +-
 drivers/block/rbd.c                |   8 +-
 fs/ceph/addr.c                     | 416 +++++++++++++++++--------------------
 fs/ceph/caps.c                     | 128 ++++++++----
 fs/ceph/debugfs.c                  |  18 +-
 fs/ceph/dir.c                      |  20 +-
 fs/ceph/file.c                     |  85 +++-----
 fs/ceph/inode.c                    |  10 +-
 fs/ceph/locks.c                    |   2 +-
 fs/ceph/mds_client.c               | 109 ++++++----
 fs/ceph/mds_client.h               |   2 +-
 fs/ceph/metric.c                   |  14 ++
 fs/ceph/metric.h                   |   7 +
 fs/ceph/quota.c                    |  10 +-
 fs/ceph/snap.c                     |   2 +-
 fs/ceph/super.c                    |   8 +-
 fs/ceph/super.h                    |  13 +-
 fs/ceph/xattr.c                    |   3 +-
 include/linux/ceph/messenger.h     |   2 +-
 include/linux/ceph/mon_client.h    |   2 +-
 include/linux/ceph/osdmap.h        |  14 +-
 include/linux/ceph/rados.h         |   2 +-
 include/linux/crush/crush.h        |   3 +
 net/ceph/messenger.c               |  13 +-
 net/ceph/mon_client.c              |  69 ++++--
 net/ceph/osdmap.c                  | 166 +++++++++++++--
 26 files changed, 689 insertions(+), 443 deletions(-)

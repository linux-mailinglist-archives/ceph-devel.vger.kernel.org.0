Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7465C1A28B9
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Apr 2020 20:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgDHSaq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Apr 2020 14:30:46 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:41742 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgDHSaq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Apr 2020 14:30:46 -0400
Received: by mail-wr1-f47.google.com with SMTP id h9so9018639wrc.8;
        Wed, 08 Apr 2020 11:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7ZBrTsWHmyC1d0UWFrbZBnZibup3HzRLEyFXJCjcQQY=;
        b=a6qweAAbLT7fxKtpvIoXTiOGfvKdvU4itE2OBrQ86ulNAzk1PcLnlBEzLwCw+o8giY
         +E0vLo83Pu4OIFcqSbEI2V3p/YWxavyotQqURXmZDt4TxxD8Wdpm6VdnOypnyBea0jLv
         K1C73gPlrYV1zCuFUP0pfsT39EiCPuQewF98sb0TFqMT8KLjh1eNWANyXKrDR2oiAMjT
         tUGPsuT+sp8kcN/MyrNR13tkTubFH+Z0seZmTzZKptcCxaT2as36XSJkKEGL4OxAswhK
         muAl1SRgHQ2e9iLN+CMBjdCmXciG7/dg6LzXY3JOEQOeK5mV4bsrvrHVtbsPSLvIvhpc
         Qjjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7ZBrTsWHmyC1d0UWFrbZBnZibup3HzRLEyFXJCjcQQY=;
        b=Y/+QI8OHY9ieMj9hsWCKccRQqBxZ7o8eLjnICc5bYy/gajBxUC9GaNXlXu+uMT4tZ5
         TAJ49l1NlL0C188sz063nTDy36DjcNOWcf768dxDH+EOES4107Tb0MdtdKVuaMzdBCuX
         UHWlP1OXsBKYUP9bDKh9CSkN/gyIAeOfYgX7aSGbPKwTd812H4ILf6IAg1F68YgULq0J
         U9joA0uOG++N+0d4C7x6wHSrQ4vOxPH4/Duwj0izVNWymQIWI/+pJkWSp9bRuPZxi97u
         jb7b8lTsqiduiSDgO9Eu9Cfoud3bc4mC5zaADLtmcSky8fKxOFeVChcAVVZiKlaA26uP
         8N9g==
X-Gm-Message-State: AGi0PuaZbZ2+GP6zu1THdJ/pOlfauaQDjiCWqrjy9DT7r+uJNlh/bcz5
        c7mONkcsqEV/8tNh0m/dAgDyFErPysnjrg==
X-Google-Smtp-Source: APiQypL1fZONj7KezOz6uH7x6jatK5+3Awp3SuR6Wnqp3eJm0zC/bbUKLaS/7w3WU/Vk72KTfHWPdw==
X-Received: by 2002:adf:fe89:: with SMTP id l9mr10080356wrr.263.1586370644188;
        Wed, 08 Apr 2020 11:30:44 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id g8sm419559wmk.29.2020.04.08.11.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 11:30:43 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 5.7-rc1
Date:   Wed,  8 Apr 2020 20:30:07 +0200
Message-Id: <20200408183007.19305-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 7111951b8d4973bda27ff663f2cf18b663d15b48:

  Linux 5.6 (2020-03-29 15:25:41 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.7-rc1

for you to fetch changes up to ef9157259fb7bb3bc2c61df227e36f1b861a4753:

  ceph: fix snapshot directory timestamps (2020-03-30 12:42:43 +0200)

----------------------------------------------------------------
The main items are:

- support for asynchronous create and unlink (Jeff Layton).  Creates
  and unlinks are satisfied locally, without waiting for a reply from
  the MDS, provided the client has been granted appropriate caps (new
  in v15.y.z ("Octopus") release).  This can be a big help for metadata
  heavy workloads such as tar and rsync.  Opt-in with the new nowsync
  mount option.

- multiple blk-mq queues for rbd (Hannes Reinecke and myself).  When
  the driver was converted to blk-mq, we settled on a single blk-mq
  queue because of a global lock in libceph and some other technical
  debt.  These have since been addressed, so allocate a queue per CPU
  to enhance parallelism.

- don't hold onto caps that aren't actually needed (Zheng Yan).  This
  has been our long-standing behavior, but it causes issues with some
  active/standby applications (synchronous I/O, stalls if the standby
  goes down, etc).

- .snap directory timestamps consistent with ceph-fuse (Luis Henriques)

----------------------------------------------------------------
Andreas Gruenbacher (1):
      ceph: switch to page_mkwrite_check_truncate in ceph_page_mkwrite

Gustavo A. R. Silva (1):
      ceph: replace zero-length array with flexible-array member

Hannes Reinecke (2):
      rbd: kill img_request kref
      rbd: enable multiple blk-mq queues

Ilya Dryomov (7):
      libceph: drop CEPH_DEFINE_SHOW_FUNC
      rbd: remove barriers from img_request_layered_{set,clear,test}()
      rbd: get rid of img_request_layered_clear()
      rbd: acquire header_rwsem just once in rbd_queue_workfn()
      rbd: embed image request in blk-mq pdu
      libceph: simplify ceph_monc_handle_map()
      libceph: directly skip to the end of redirect reply

Jeff Layton (18):
      ceph: register MDS request with dir inode from the start
      ceph: add refcounting for Fx caps
      ceph: don't ClearPageChecked in ceph_invalidatepage()
      ceph: reorganize fields in ceph_mds_request
      ceph: move to a dedicated slabcache for mds requests
      ceph: clean up kick_flushing_inode_caps()
      ceph: more caps.c lockdep assertions
      ceph: add flag to designate that a request is asynchronous
      ceph: track primary dentry link
      ceph: add infrastructure for waiting for async create to complete
      ceph: make __take_cap_refs non-static
      ceph: cap tracking for async directory operations
      ceph: perform asynchronous unlink if we have sufficient caps
      ceph: make ceph_fill_inode non-static
      ceph: decode interval_sets for delegated inos
      ceph: add new MDS req field to hold delegated inode number
      ceph: cache layout in parent dir on first sync create
      ceph: attempt to do async create when possible

Luis Henriques (2):
      ceph: re-org copy_file_range and fix some error paths
      ceph: fix snapshot directory timestamps

Qiujun Huang (1):
      ceph: return ceph_mdsc_do_request() errors from __get_parent()

Xiubo Li (3):
      ceph: move ceph_osdc_{read,write}pages to ceph.ko
      ceph: fix description of some mount options
      ceph: return ETIMEDOUT errno to userland when request timed out

Yan, Zheng (14):
      ceph: check inode type for CEPH_CAP_FILE_{CACHE,RD,REXTEND,LAZYIO}
      ceph: check if file lock exists before sending unlock request
      ceph: don't take refs to want mask unless we have all bits
      ceph: update dentry lease for async create
      ceph: always renew caps if mds_wanted is insufficient
      ceph: consider inode's last read/write when calculating wanted caps
      ceph: remove delay check logic from ceph_check_caps()
      ceph: simplify calling of ceph_get_fmode()
      ceph: update i_requested_max_size only when sending cap msg to auth mds
      ceph: check all mds' caps after page writeback
      ceph: cleanup return error of try_get_cap_refs()
      ceph: request new max size only when there is auth cap
      ceph: don't skip updating wanted caps when cap is stale
      ceph: wait for async creating inode before requesting new max size

 Documentation/filesystems/ceph.txt |   6 +-
 drivers/block/rbd.c                | 215 ++++++---------
 fs/ceph/addr.c                     |  90 ++++++-
 fs/ceph/cache.c                    |   2 +-
 fs/ceph/caps.c                     | 536 ++++++++++++++++++++-----------------
 fs/ceph/debugfs.c                  |  16 +-
 fs/ceph/dir.c                      | 132 ++++++++-
 fs/ceph/export.c                   |   5 +
 fs/ceph/file.c                     | 486 +++++++++++++++++++++++++--------
 fs/ceph/inode.c                    |  84 +++---
 fs/ceph/ioctl.c                    |   2 +
 fs/ceph/locks.c                    |  31 ++-
 fs/ceph/mds_client.c               | 240 ++++++++++++++---
 fs/ceph/mds_client.h               |  30 ++-
 fs/ceph/super.c                    |  28 ++
 fs/ceph/super.h                    |  70 +++--
 include/linux/ceph/ceph_fs.h       |  18 +-
 include/linux/ceph/debugfs.h       |  14 -
 include/linux/ceph/libceph.h       |   1 +
 include/linux/ceph/osd_client.h    |  17 --
 net/ceph/debugfs.c                 |  20 +-
 net/ceph/mon_client.c              |   8 +-
 net/ceph/osd_client.c              |  82 ------
 23 files changed, 1380 insertions(+), 753 deletions(-)

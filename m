Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993F61F1D7E
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Jun 2020 18:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730567AbgFHQg3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Jun 2020 12:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730383AbgFHQg2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Jun 2020 12:36:28 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08BCC08C5C2;
        Mon,  8 Jun 2020 09:36:26 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id j10so18123067wrw.8;
        Mon, 08 Jun 2020 09:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3stWFcqpZacdXnYKEcQBZXFbyXJauSreLLB+1339PuE=;
        b=QVsWop8TvbeU+82QPebxlev1TVdNdtCPSmWxkC03+UP9maAAepadnsvPzIo5qatEkS
         cbRVAKES/f+scM2Kbapn8dNUBq7HOMMI9NOPmdPtZw6cq70fqWwOdU5VueI82Qt80g76
         E5vtg6O6d1Ovr2NhL0tPDN9xRiaER0fMQnbui4CCZW/0LFG+4EiX9hQ6an78c7ifU7L3
         uItV5TAcskznFIMfyQur9MdKstNtVbyS/vtThgsn4eJQJUJ2m1E4ITecAPM/OFC/g4zt
         F4WwhB7C8YprZFcd/OKMlMxXWxkagFlcrO3t8JpGrcSnLym9nOAalcpKT96eLUqhk2uT
         B9FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3stWFcqpZacdXnYKEcQBZXFbyXJauSreLLB+1339PuE=;
        b=L5i0RXxAXVxtF8GigZHRifLmFYIRvob7GIOAAQuq/q5rsxTpEE4WkxmCEuky4t2SV0
         0HuZHc7xaHwfqgL9vzLmXmsCAubyC7sJH4mN8l9YV5ZbwYOFdJsK5yJljlEff+zaAReH
         tasz3DJbg/g1ErKgm7E5xiqY7q+H7wGwpLLraOOurChS6gCZRuUXbd8A81P//zBzGUX0
         z1qh3LEAYXAMA/AKC7bFBkMPoI/5YTE6mHZwhIWKoc1WEVG+KndJI0KOj8Y4iyujInHk
         zdCXeUfyiqXINfEkpXw+iGfscUOhOF6jmOedrpG2E5bsosg/gJVxoNNoqW6inw7GM03B
         P/sA==
X-Gm-Message-State: AOAM531nUP54geJKgPiyOOs0EMmD5XLb+lS34JXhB/8abLoZWH8BWAQl
        ObZ/VK0criy9QbmtADTAMl96mMhXDpU=
X-Google-Smtp-Source: ABdhPJz5v+//ef9firCDrVujLSIV8U1MSYCLUa7XmsEihy92XMWl4dCyIk+RbgCTn4vad+Do9wQDfQ==
X-Received: by 2002:adf:fd4b:: with SMTP id h11mr23749652wrs.209.1591634185217;
        Mon, 08 Jun 2020 09:36:25 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id v19sm101069wml.26.2020.06.08.09.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 09:36:24 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 5.8-rc1
Date:   Mon,  8 Jun 2020 18:36:26 +0200
Message-Id: <20200608163626.7339-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 3d77e6a8804abcc0504c904bd6e5cdf3a5cf8162:

  Linux 5.7 (2020-05-31 16:49:15 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.8-rc1

for you to fetch changes up to dc1dad8e1a612650b1e786e992cb0c6e101e226a:

  rbd: compression_hint option (2020-06-01 23:32:35 +0200)

----------------------------------------------------------------
The highlights are:

- OSD/MDS latency and caps cache metrics infrastructure for the
  filesytem (Xiubo Li).  Currently available through debugfs and
  will be periodically sent to the MDS in the future.

- support for replica reads (balanced and localized reads) for
  rbd and the filesystem (myself).  The default remains to always
  read from primary, users can opt-in with the new crush_location
  and read_from_replica options.  Note that reading from replica
  is safe for general use only since Octopus.

- support for RADOS allocation hint flags (myself).  Currently
  used by rbd to propagate the compressible/incompressible hint
  given with the new compression_hint map option and ready for
  passing on more advanced hints, e.g. based on fadvise() from
  the filesystem.

- support for efficient cross-quota-realm renames (Luis Henriques)

- assorted cap handling improvements and cleanups, particularly
  untangling some of the locking (Jeff Layton)

----------------------------------------------------------------
Gustavo A. R. Silva (1):
      libceph, rbd: replace zero-length array with flexible-array

Ilya Dryomov (7):
      libceph: add non-asserting rbtree insertion helper
      libceph: decode CRUSH device/bucket types and names
      libceph: crush_location infrastructure
      libceph: support for balanced and localized reads
      libceph: read_from_replica option
      libceph: support for alloc hint flags
      rbd: compression_hint option

Jeff Layton (11):
      ceph: reorganize __send_cap for less spinlock abuse
      ceph: split up __finish_cap_flush
      ceph: add comments for handle_cap_flush_ack logic
      ceph: don't release i_ceph_lock in handle_cap_trunc
      ceph: don't take i_ceph_lock in handle_cap_import
      ceph: document what protects i_dirty_item and i_flushing_item
      ceph: fix potential race in ceph_check_caps
      ceph: throw a warning if we destroy session with mutex still locked
      ceph: convert mdsc->cap_dirty to a per-session list
      ceph: request expedited service on session's last cap flush
      ceph: ceph_kick_flushing_caps needs the s_mutex

Luis Henriques (3):
      ceph: normalize 'delta' parameter usage in check_quota_exceeded
      ceph: allow rename operation under different quota realms
      ceph: don't return -ESTALE if there's still an open file

Xiubo Li (6):
      ceph: add dentry lease metric support
      ceph: add caps perf metric for each superblock
      ceph: add read/write latency metric support
      ceph: add metadata perf metric support
      ceph: make sure mdsc->mutex is nested in s->s_mutex to fix dead lock
      ceph: skip checking caps when session reconnecting and releasing reqs

Yan, Zheng (1):
      ceph: reset i_requested_max_size if file write is not wanted

 drivers/block/rbd.c             |  44 ++++-
 drivers/block/rbd_types.h       |   2 +-
 fs/ceph/Makefile                |   2 +-
 fs/ceph/acl.c                   |   2 +-
 fs/ceph/addr.c                  |  20 ++
 fs/ceph/caps.c                  | 425 ++++++++++++++++++++++++++--------------
 fs/ceph/debugfs.c               | 100 +++++++++-
 fs/ceph/dir.c                   |  26 ++-
 fs/ceph/export.c                |   9 +-
 fs/ceph/file.c                  |  30 +++
 fs/ceph/inode.c                 |   4 +-
 fs/ceph/mds_client.c            |  48 ++++-
 fs/ceph/mds_client.h            |  15 +-
 fs/ceph/metric.c                | 148 ++++++++++++++
 fs/ceph/metric.h                |  62 ++++++
 fs/ceph/quota.c                 |  62 +++++-
 fs/ceph/super.h                 |  34 +++-
 fs/ceph/xattr.c                 |   4 +-
 include/linux/ceph/libceph.h    |  13 +-
 include/linux/ceph/mon_client.h |   2 +-
 include/linux/ceph/osd_client.h |   8 +-
 include/linux/ceph/osdmap.h     |  19 +-
 include/linux/ceph/rados.h      |  14 ++
 include/linux/crush/crush.h     |  14 +-
 net/ceph/ceph_common.c          |  75 +++++++
 net/ceph/crush/crush.c          |   3 +-
 net/ceph/debugfs.c              |   6 +-
 net/ceph/osd_client.c           | 103 +++++++++-
 net/ceph/osdmap.c               | 363 +++++++++++++++++++++++++++++-----
 29 files changed, 1405 insertions(+), 252 deletions(-)
 create mode 100644 fs/ceph/metric.c
 create mode 100644 fs/ceph/metric.h

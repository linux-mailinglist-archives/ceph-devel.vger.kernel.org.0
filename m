Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A333C1A34
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jul 2021 21:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhGHT6F (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Jul 2021 15:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhGHT6E (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Jul 2021 15:58:04 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B652C061574;
        Thu,  8 Jul 2021 12:55:22 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id p8so9031223wrr.1;
        Thu, 08 Jul 2021 12:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZVo23KZnDC8iUPrcpol9t9l4wxIzahSXw1DrIBqF6BM=;
        b=Xr1xBmTxCNcGR5I2u4OrDLLS74w6ftZVqYCld0TkV5QGBzJFcS8ESlj2vng1ham6qm
         zaGt53U0+5jNUpJDX0Ueyo4jFPCIiquxLs1UHJKxBgDY2Dk6iSfNKGTLUEqTRl0KQKck
         yVyt5wmIkNZC4aLFdcAdI6mjS9J5o2MaT/qVrujkjyYz67DS9fkSITbyuIssD7wf+QPN
         mn14SOLihJ9uflakuwDb6udWF0MyoHnoaXdxvTMB5Hg0RLsf2lkf3ttz9EuJzhBG7Bp8
         LLss45v3q2kjMGNhNb2CHyPvMym/6bh0RChD7wDe9d2RQ9X4aFW4oP/DrJclNsTHQpNz
         kmQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZVo23KZnDC8iUPrcpol9t9l4wxIzahSXw1DrIBqF6BM=;
        b=nYTLHUD0rFdadAL1S/5JAbtdyeT2rxEZErBRcMX+fMc4jGo7m4Wk0Ui+4wM/gJIUHx
         i1gq1i3USuijKXELEwBtX6jMq4ZMT+22WXVJekh5vg/EfwM3AZe70KO7JDbhoiqiU5wl
         jdMiKklfEmO0wT29KGgx7hMQRG6NKciY8bqrT5o4XfQF6D+sehT8ImZe/B6pfVFlCn03
         7H5t8bpuiXeeIsjbYc/adrtTjjgPjUWUn6N92HAOrxU+TFVLHVcgv+C2zAurrbZOTb+J
         rAgXvDZdA1pUq3fLY1NRLZ/rEn9s2sI/yIqsMhCD1WTQOIq17BS2ltneOFIQga4nR+4P
         6bQA==
X-Gm-Message-State: AOAM531654O/mmf4OQWEQ5U/MUBjJWh/JdFt9q4mK/XM+TBRRMj0Sp8j
        zOEQcf5DMMTgOJlzHJ3iL44=
X-Google-Smtp-Source: ABdhPJzNsn9kAtw79Z+FqEjzQ/551osI2VZTove4KEPonT0zS7FV69MrQrt+gh+zBivNUewI/P4tPQ==
X-Received: by 2002:a5d:4527:: with SMTP id j7mr5426375wra.137.1625774121203;
        Thu, 08 Jul 2021 12:55:21 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id j4sm3251253wra.1.2021.07.08.12.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 12:55:20 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 5.14-rc1
Date:   Thu,  8 Jul 2021 21:54:58 +0200
Message-Id: <20210708195458.14317-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 62fb9874f5da54fdb243003b386128037319b219:

  Linux 5.13 (2021-06-27 15:21:11 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.14-rc1

for you to fetch changes up to 4c18347238ab5a4ee0e71ca765460d84c75a26b5:

  ceph: take reference to req->r_parent at point of assignment (2021-06-29 00:15:52 +0200)

----------------------------------------------------------------
We have new filesystem client metrics for reporting I/O sizes from
Xiubo, two patchsets from Jeff that begin to untangle some heavyweight
blocking locks in the filesystem and a bunch of code cleanups.

----------------------------------------------------------------
Baokun Li (1):
      libceph: fix doc warnings in cls_lock_client.c

Ilya Dryomov (1):
      libceph: kill ceph_none_authorizer::reply_buf

Jeff Layton (12):
      ceph: remove bogus checks and WARN_ONs from ceph_set_page_dirty
      ceph: make ceph_queue_cap_snap static
      ceph: decoding error in ceph_update_snap_realm should return -EIO
      ceph: add some lockdep assertions around snaprealm handling
      ceph: clean up locking annotation for ceph_get_snap_realm and __lookup_snap_realm
      ceph: allow ceph_put_mds_session to take NULL or ERR_PTR
      ceph: eliminate session->s_gen_ttl_lock
      ceph: don't take s_mutex or snap_rwsem in ceph_check_caps
      ceph: don't take s_mutex in try_flush_caps
      ceph: don't take s_mutex in ceph_flush_snaps
      ceph: eliminate ceph_async_iput()
      ceph: take reference to req->r_parent at point of assignment

Wei Yongjun (1):
      ceph: make ceph_netfs_read_ops static

Xiubo Li (3):
      ceph: simplify the metrics struct
      ceph: update and rename __update_latency helper to __update_stdev
      ceph: add IO size metrics support

Zheng Yongjun (1):
      libceph: fix some spelling mistakes

zuoqilin (1):
      libceph: remove unnecessary ret variable in ceph_auth_init()

 fs/ceph/addr.c             |  26 +++----
 fs/ceph/caps.c             | 125 +++++++--------------------------
 fs/ceph/debugfs.c          |  37 ++++++++--
 fs/ceph/dir.c              |  16 +++--
 fs/ceph/export.c           |   1 +
 fs/ceph/file.c             |  24 +++----
 fs/ceph/inode.c            |  38 ++---------
 fs/ceph/mds_client.c       |  54 ++++++---------
 fs/ceph/mds_client.h       |   6 +-
 fs/ceph/metric.c           | 167 +++++++++++++++++++++++++++++----------------
 fs/ceph/metric.h           |  89 +++++++++++-------------
 fs/ceph/quota.c            |   9 +--
 fs/ceph/snap.c             |  45 ++++++------
 fs/ceph/super.h            |   3 -
 net/ceph/auth.c            |   7 +-
 net/ceph/auth_none.c       |   4 +-
 net/ceph/auth_none.h       |   1 -
 net/ceph/auth_x_protocol.h |   2 +-
 net/ceph/cls_lock_client.c |  12 +++-
 net/ceph/mon_client.c      |   2 +-
 net/ceph/osdmap.c          |   4 +-
 21 files changed, 316 insertions(+), 356 deletions(-)

Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50086242DF8
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Aug 2020 19:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgHLRUR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Aug 2020 13:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgHLRUQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Aug 2020 13:20:16 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA5CC061383;
        Wed, 12 Aug 2020 10:20:15 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id c10so2113819edk.6;
        Wed, 12 Aug 2020 10:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KTzNshNFSy3Sj5/6W3lHtq1l8S1Rm80+RX34NkgS2vs=;
        b=CPaqRHS0ziOIE8hr2T9PgGbEUe8oipmtVe59P+3K1crSiuXahhb6nIBX/BEj1Igz2r
         Ieh/5B6RPosM+sjACYkq3e2k0pOFbE9Vn2l3m1booZAhbx3n35LqsPm9j6xtzKFjcaFN
         8FmLbA0D1gwI9GdL5ZutyF56i6imw7xwFiJm5q5mPAGSoeW4X1NtrIxRLUmRR9qnCZZL
         DRjUpXlsegGWAVRT+eDQsA4m2y3MLxPGD819RvlMupUgffiX1YJw3pw6duLbN2VxG6Yn
         Aj36t6/nddxjQgxwG7Syp0h+l/NBtH+mAChwPyokBWQFzxkKD5w3kUb3vBrmpYS43s+h
         xKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KTzNshNFSy3Sj5/6W3lHtq1l8S1Rm80+RX34NkgS2vs=;
        b=qFZF5cFDLUFMTcbst7xw1AhUdxvvkZnrIDvkYxm96ch7bzvvCYmJzFVbFzUcalFqLM
         rTYK4DnfdUG2R6GaV79SOhZV12yipHFELx9yDml9e8Ni+j2UKBYiqvCq88798hCKIRuh
         glpZoFGJQ471zYTCnY+N+VMJKyWYEqNOBvZn01OOlgCl8FMoyQbmGNFQIeyNjIDyr69o
         ndYPOWQsI9fYBDaRKZbbIJzOhkkYoskVqm8PBr35XoXdfhubjswRnI/ptfFjLwOBUhX2
         NbnXAeaAqqzWVANMidcMldSInnE4XLAUTtKZ79iIg8SsyTJbgJ7Sam6716stO8o3e3Yv
         0gQA==
X-Gm-Message-State: AOAM531ZFlqBpse+EIcrkFtRqawpB6iTpCHQaM4bLrJ1GmIY0LcjOFxe
        FltRuO0lnSfLOJFP/jKH8uE=
X-Google-Smtp-Source: ABdhPJw4bW+/sUNFbW7N+ztyYZhCCni4CXIKianTP1pfv6Gjx0cMbOD9RiLTAcxw0Z+eAOXZ4y++9A==
X-Received: by 2002:a50:e109:: with SMTP id h9mr924787edl.47.1597252814430;
        Wed, 12 Aug 2020 10:20:14 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id g9sm1697619edk.97.2020.08.12.10.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2020 10:20:13 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 5.9-rc1
Date:   Wed, 12 Aug 2020 19:19:49 +0200
Message-Id: <20200812171949.2882-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit bcf876870b95592b52519ed4aafcf9d95999bc9c:

  Linux 5.8 (2020-08-02 14:21:45 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.9-rc1

for you to fetch changes up to 02e37571f9e79022498fd0525c073b07e9d9ac69:

  ceph: handle zero-length feature mask in session messages (2020-08-05 17:47:07 +0200)

----------------------------------------------------------------
Xiubo has completed his work on filesystem client metrics, they are
sent to all available MDSes once per second now.  Other than that, we
have a lot of fixes and cleanups all around the filesystem, including
a tweak to cut down on MDS request resends in multi-MDS setups from
Yanhu and fixups for SELinux symlink labeling and MClientSession
message decoding from Jeff.

----------------------------------------------------------------
Alexander A. Klimov (1):
      libceph: replace HTTP links with HTTPS ones

Colin Ian King (1):
      ceph: remove redundant initialization of variable mds

Ilya Dryomov (2):
      libceph: use target_copy() in send_linger()
      libceph: dump class and method names on method calls

Jeff Layton (5):
      ceph: clean up and optimize ceph_check_delayed_caps()
      libceph: just have osd_req_op_init() return a pointer
      ceph: set sec_context xattr on symlink creation
      ceph: move sb->wb_pagevec_pool to be a global mempool
      ceph: handle zero-length feature mask in session messages

Jia Yang (1):
      ceph: remove unused variables in ceph_mdsmap_decode()

Randy Dunlap (1):
      ceph: delete repeated words in fs/ceph/

Xiubo Li (9):
      ceph: add check_session_state() helper and make it global
      ceph: add global total_caps to count the mdsc's total caps number
      ceph: switch to WARN_ON_ONCE in encode_supported_features()
      ceph: fix potential mdsc use-after-free crash
      ceph: do not access the kiocb after aio requests
      ceph: check the sesion state and return false in case it is closed
      ceph: periodically send perf metrics to MDSes
      ceph: send client provided metric flags in client metadata
      ceph: fix use-after-free for fsc->mdsc

Xu Wang (1):
      ceph: remove unnecessary cast in kfree()

Yanhu Cao (1):
      ceph: use frag's MDS in either mode

 fs/ceph/Kconfig                    |   2 +-
 fs/ceph/addr.c                     |  23 +++--
 fs/ceph/caps.c                     |  12 +--
 fs/ceph/debugfs.c                  |  16 +---
 fs/ceph/dir.c                      |   4 +
 fs/ceph/file.c                     |   5 +-
 fs/ceph/mds_client.c               | 184 +++++++++++++++++++++++++++++--------
 fs/ceph/mds_client.h               |   7 +-
 fs/ceph/mdsmap.c                   |  10 +-
 fs/ceph/metric.c                   | 149 ++++++++++++++++++++++++++++++
 fs/ceph/metric.h                   |  91 ++++++++++++++++++
 fs/ceph/super.c                    |  64 ++++++++++---
 fs/ceph/super.h                    |   6 +-
 fs/ceph/xattr.c                    |  12 +--
 include/linux/ceph/ceph_features.h |   2 +-
 include/linux/ceph/ceph_fs.h       |   1 +
 include/linux/ceph/libceph.h       |   1 +
 include/linux/ceph/osd_client.h    |   2 +-
 include/linux/crush/crush.h        |   2 +-
 net/ceph/Kconfig                   |   2 +-
 net/ceph/ceph_hash.c               |   2 +-
 net/ceph/crush/hash.c              |   2 +-
 net/ceph/crush/mapper.c            |   2 +-
 net/ceph/debugfs.c                 |   3 +
 net/ceph/osd_client.c              |  43 ++++-----
 25 files changed, 511 insertions(+), 136 deletions(-)

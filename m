Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746202DD53A
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Dec 2020 17:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbgLQQ2m (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Dec 2020 11:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728158AbgLQQ2m (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Dec 2020 11:28:42 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A78C0617A7;
        Thu, 17 Dec 2020 08:28:01 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id 6so24105629ejz.5;
        Thu, 17 Dec 2020 08:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sJFhm3RQkTNMKCjOmfOCz4d8sIcm5gLv4h4+TrNZmYY=;
        b=fuwgNKJmqer0Kmk/ijFVsOUg3ijjwCJCQ5JLroj0pzJI3ubHwv2RrAof+0i2sC375p
         exSoEfwjCnTMi56emN8ANXhhtoE1u1oe+xplS2fDmcsxY6sSVgPUKFpddZ6nQ8YHSvk2
         yu4d/PTkPM+r6sbp742/zPKitX95E8xVCrgt0oBqe87nIKgTr3kZDKha+oxWffybN2Ae
         aj/zeMAIg617luDd4VQW8gdbv4sSSrNR4/TsVonlVIg6qU5351fo08Bh4P0P4TnYE4m7
         fc2Ds48ecDKVb5dSImdrgDl3Q1hH+TA8fOX1Z0r1W82M4daDnkp+6UAaNPvSdy8Ep/Ls
         G5ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sJFhm3RQkTNMKCjOmfOCz4d8sIcm5gLv4h4+TrNZmYY=;
        b=qn9atDc9jAEPmUnD7MDjCOG4fTBPvneVoFIL0BJX1xKsplzZmPR8c82FyLbtZjcGuL
         SodCxvihZpJvHfnZ3PSZtDI8s7r1CoLASYZElDu9m5MhHd/t+D9wFCT0Dpli3Jtmyc9C
         eaWzxw9Z7WuXSoKGAvJw801v0/hddS+6AakswZ65tfF+6jYhte5WheO+g+cnccgM9+dG
         Wg8VkLXNJ3j19V1o7/GpUqwzF+MBBrLsCF21Eh0/ja2RWCoJEYwE20kkhPar4ea3qsoZ
         M3wNebsSo6oqSWw7blhJJiBrlTtUOk/O/Z5TlgYgtrTmAB0elYQVBoceTPaX9qS6yl7p
         qwRQ==
X-Gm-Message-State: AOAM531AJfe30+yoO6qSBJGnCMQbT5vbDSrJ8xEZcsnBhXkFb9uGLsgF
        QRd4vORgfXpo93d2FyVGaWUK3j0t5w8=
X-Google-Smtp-Source: ABdhPJzBIz7qKV3iOQh4tkpS4X5GQ4lp8sNHWu1qxYF5dyHiFlbjAlBvv+ECUCRBXlJjUsid0LSbRg==
X-Received: by 2002:a17:906:518a:: with SMTP id y10mr36732221ejk.323.1608222480537;
        Thu, 17 Dec 2020 08:28:00 -0800 (PST)
Received: from kwango.redhat.com (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id da9sm23535188edb.84.2020.12.17.08.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 08:27:59 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 5.11-rc1
Date:   Thu, 17 Dec 2020 17:27:49 +0100
Message-Id: <20201217162749.18811-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 2c85ebc57b3e1817b6ce1a6b703928e113a90442:

  Linux 5.10 (2020-12-13 14:41:30 -0800)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.11-rc1

for you to fetch changes up to 2f0df6cfa325d7106b8a65bc0e02db1086e3f73b:

  libceph: drop ceph_auth_{create,update}_authorizer() (2020-12-14 23:21:50 +0100)

There is a build conflict caused by the split of crypto/sha.h into
crypto/sha1.h and crypto/sha2.h that affects net/ceph/messenger_v2.c.
The resolution is to include the latter, done in for-linus-merged
just in case.

----------------------------------------------------------------
The big ticket item here is support for msgr2 on-wire protocol, which
adds the option of full in-transit encryption using AES-GCM algorithm
(myself).  On top of that we have a series to avoid intermittent
errors during recovery with recover_session=clean and some MDS request
encoding work from Jeff, a cap handling fix and assorted observability
improvements from Luis and Xiubo and a good number of cleanups.  Luis
also ran into a corner case with quotas which sadly means that we are
back to denying cross-quota-realm renames.

----------------------------------------------------------------
Colin Ian King (1):
      ceph: remove redundant assignment to variable i

Ilya Dryomov (34):
      libceph: include middle_len in process_message() dout
      libceph: lower exponential backoff delay
      libceph: don't call reset_connection() on version/feature mismatches
      libceph: split protocol reset bits out of reset_connection()
      libceph: rename reset_connection() to ceph_con_reset_session()
      libceph: clear con->peer_global_seq on RESETSESSION
      libceph: remove redundant session reset log message
      libceph: drop msg->ack_stamp field
      libceph: handle discarding acked and requeued messages separately
      libceph: change ceph_msg_data_cursor_init() to take cursor
      libceph: change ceph_con_in_msg_alloc() to take hdr
      libceph: factor out ceph_con_get_out_msg()
      libceph: make sure our addr->port is zero and addr->nonce is non-zero
      libceph: don't export ceph_messenger_{init_fini}() to modules
      libceph: make con->state an int
      libceph: rename and export con->state states
      libceph: rename and export con->flags bits
      libceph: export zero_page
      libceph: export remaining protocol independent infrastructure
      libceph: separate msgr1 protocol implementation
      libceph: move msgr1 protocol implementation to its own file
      libceph: move msgr1 protocol specific fields to its own struct
      libceph: more insight into ticket expiry and invalidation
      libceph: safer en/decoding of cephx requests and replies
      libceph, ceph: incorporate nautilus cephx changes
      libceph: amend cephx init_protocol() and build_request()
      libceph: drop ac->ops->name field
      libceph: factor out finish_auth()
      libceph, ceph: get and handle cluster maps with addrvecs
      libceph, rbd: ignore addr->type while comparing in some cases
      libceph: introduce connection modes and ms_mode option
      libceph, ceph: implement msgr2.1 protocol (crc and secure modes)
      libceph, ceph: make use of __ceph_auth_get_authorizer() in msgr1
      libceph: drop ceph_auth_{create,update}_authorizer()

Jeff Layton (15):
      ceph: don't WARN when removing caps due to blocklisting
      ceph: make fsc->mount_state an int
      ceph: add new RECOVER mount_state when recovering session
      ceph: remove timeout on allowing reconnect after blocklisting
      ceph: queue MDS requests to REJECTED sessions when CLEANRECOVER is set
      ceph: fix up some warnings on W=1 builds
      ceph: acquire Fs caps when getting dir stats
      ceph: ensure we have Fs caps when fetching dir link count
      ceph: pass down the flags to grab_cache_page_write_begin
      ceph: fix inode refcount leak when ceph_fill_inode on non-I_NEW inode fails
      ceph: when filling trace, call ceph_get_inode outside of mutexes
      ceph: don't reach into request header for readdir info
      ceph: take a cred reference instead of tracking individual uid/gid
      ceph: clean up argument lists to __prepare_send_request and __send_request
      ceph: implement updated ceph_mds_request_head structure

Liu, Changcheng (1):
      libceph: remove unused port macros

Luis Henriques (4):
      ceph: fix race in concurrent __ceph_remove_cap invocations
      ceph: downgrade warning from mdsmap decode to debug
      Revert "ceph: allow rename operation under different quota realms"
      ceph: add ceph.caps vxattr

Xiubo Li (4):
      ceph: send dentry lease metrics to MDS daemon
      ceph: add status debugfs file
      ceph: add ceph.{cluster_fsid/client_id} vxattrs
      ceph: set osdmap epoch for setxattr

 drivers/block/rbd.c                |    8 +-
 fs/ceph/addr.c                     |    6 +-
 fs/ceph/caps.c                     |   27 +-
 fs/ceph/debugfs.c                  |   20 +
 fs/ceph/dir.c                      |    9 +-
 fs/ceph/inode.c                    |   41 +-
 fs/ceph/locks.c                    |    8 +-
 fs/ceph/mds_client.c               |  280 ++-
 fs/ceph/mds_client.h               |    3 +-
 fs/ceph/mdsmap.c                   |   25 +-
 fs/ceph/metric.c                   |   18 +-
 fs/ceph/metric.h                   |   14 +
 fs/ceph/quota.c                    |   58 +-
 fs/ceph/super.c                    |   14 +-
 fs/ceph/super.h                    |    7 +-
 fs/ceph/xattr.c                    |   81 +-
 include/linux/ceph/auth.h          |   68 +-
 include/linux/ceph/ceph_features.h |   11 +-
 include/linux/ceph/ceph_fs.h       |   44 +-
 include/linux/ceph/decode.h        |    8 +
 include/linux/ceph/libceph.h       |   11 +-
 include/linux/ceph/mdsmap.h        |    2 +-
 include/linux/ceph/messenger.h     |  285 ++-
 include/linux/ceph/msgr.h          |   66 +-
 include/linux/ceph/osdmap.h        |    4 +-
 net/ceph/Kconfig                   |    3 +
 net/ceph/Makefile                  |    3 +-
 net/ceph/auth.c                    |  408 ++++-
 net/ceph/auth_none.c               |    5 +-
 net/ceph/auth_x.c                  |  298 +++-
 net/ceph/auth_x_protocol.h         |    3 +-
 net/ceph/ceph_common.c             |   63 +
 net/ceph/ceph_strings.c            |   28 +
 net/ceph/crypto.h                  |    3 +
 net/ceph/decode.c                  |  101 ++
 net/ceph/messenger.c               | 2252 +++++------------------
 net/ceph/messenger_v1.c            | 1506 ++++++++++++++++
 net/ceph/messenger_v2.c            | 3443 ++++++++++++++++++++++++++++++++++++
 net/ceph/mon_client.c              |  320 +++-
 net/ceph/osd_client.c              |  111 +-
 net/ceph/osdmap.c                  |   45 +-
 41 files changed, 7371 insertions(+), 2339 deletions(-)
 create mode 100644 net/ceph/messenger_v1.c
 create mode 100644 net/ceph/messenger_v2.c

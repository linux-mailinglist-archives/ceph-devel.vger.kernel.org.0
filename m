Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05508403E13
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Sep 2021 19:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352361AbhIHREb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Sep 2021 13:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235666AbhIHREa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Sep 2021 13:04:30 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A797BC061575;
        Wed,  8 Sep 2021 10:03:22 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id me10so5543565ejb.11;
        Wed, 08 Sep 2021 10:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pFZQZP6SBUQcSO4Xl8lHY2eIg5EWdq+cWHjbXAwPeek=;
        b=K9Nt38iL9uqIB/blizmHJoFPGhRn6fduNNr0fKn3SJPJLtTc15CaVCN/mMV+bCJsr8
         2UhhujJO7g/jIPFyE/ksVBtnF64pT3jkjL6cL8dQF0BLTdA4LqUfm+mx0DUNRtHAUm3/
         8uD7D+As9Ls0CTCXmZ3qbJHa7SF+TClTScI/2DZFwudjMKjTpfyvZ7b7J+9i+e0dKG2O
         XGfAPn+o/cMnMnPVbiEaq/juYKX9MSIL52w22DJgSul9sEtUWM9q9NByVIjtTMDD56+2
         a/YeO549Dv/TLXvAZoPgSL7Q/omvHtkuBPOo88RXqWZLKB/l0bWWu8CwCwCBX4ejKbvP
         UN2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pFZQZP6SBUQcSO4Xl8lHY2eIg5EWdq+cWHjbXAwPeek=;
        b=tLlu8UZBg5i4X8mTF3KwhzUjBiaRMHL33bqzRW0ehAO59H8rWvOwlhHKeIB/oiG8Q9
         oiUuqeIoLyBVJYtbwr588oIXpxmmf6i9rPUPXXbSKVwkIHgV7PXOlXS8dTb+g/xtQbuI
         pJ2GqKSGu1Iaaed1Osy18mZfcGnXeDGdewchS56T7M7tWR9emctdvZMUUst70KAX/2LL
         TsOjxXfd+EVJkMcs9Rz4sZY6fqR7+WD5XJKhbNWQS11H+hrhWUG+A0l9GlK1mCVL/ntl
         zFIvsjdFySVedA+h15zWyLVtyhlnw76S1rpOe0ZGg2+QV0X8g31wuukXkwRzeoQ1e0yJ
         rXCA==
X-Gm-Message-State: AOAM532FXNyBLAT9qcGR8hivzCWLz1PoTyry67Zv95x7HfStQifZUTM7
        rGUdtll2JnbQY+0j6l6M7yw=
X-Google-Smtp-Source: ABdhPJzN2N4LNWd+P/4FKysGkFbBUKYeltUmWMptS3lVHukXEHx4CFZZCMbH6h0UaEDXposS6YzK9w==
X-Received: by 2002:a17:906:c416:: with SMTP id u22mr843426ejz.543.1631120601141;
        Wed, 08 Sep 2021 10:03:21 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-171-183.net.upcbroadband.cz. [94.112.171.183])
        by smtp.gmail.com with ESMTPSA id w9sm1034950edr.20.2021.09.08.10.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 10:03:20 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 5.15-rc1
Date:   Wed,  8 Sep 2021 19:02:57 +0200
Message-Id: <20210908170257.18646-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 7d2a07b769330c34b4deabeed939325c77a7ec2f:

  Linux 5.14 (2021-08-29 15:04:50 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.15-rc1

for you to fetch changes up to 05a444d3f90a3c3e6362e88a1bf13e1a60f8cace:

  ceph: fix dereference of null pointer cf (2021-09-03 10:55:51 +0200)

----------------------------------------------------------------
We have:

- a set of patches to address fsync stalls caused by depending on
  periodic rather than triggered MDS journal flushes in some cases
  (Xiubo Li)

- a fix for mtime effectively not getting updated in case of competing
  writers (Jeff Layton)

- a couple of fixes for inode reference leaks and various WARNs after
  "umount -f" (Xiubo Li)

- a new ceph.auth_mds extended attribute (Jeff Layton)

- a smattering of fixups and cleanups from Jeff, Xiubo and Colin.

----------------------------------------------------------------
Colin Ian King (1):
      ceph: fix dereference of null pointer cf

Jeff Layton (11):
      ceph: fix memory leak on decode error in ceph_handle_caps
      ceph: fix comment about short copies in ceph_write_end
      ceph: remove some defunct forward declarations
      ceph: add a new vxattr to return auth mds for an inode
      ceph: cancel delayed work instead of flushing on mdsc teardown
      ceph: remove redundant initializations from mdsc and session
      ceph: add ceph_change_snap_realm() helper
      ceph: print more information when we can't find snaprealm
      ceph: request Fw caps before updating the mtime in ceph_write_iter
      ceph: lockdep annotations for try_nonblocking_invalidate
      ceph: drop the mdsc_get_session/put_session dout messages

Xiubo Li (8):
      ceph: make ceph_create_session_msg a global symbol
      ceph: make iterate_sessions a global symbol
      ceph: flush mdlog before umounting
      ceph: flush the mdlog before waiting on unsafe reqs
      ceph: reconnect to the export targets on new mdsmaps
      ceph: remove the capsnaps when removing caps
      ceph: don't WARN if we're force umounting
      ceph: don't WARN if we're forcibly removing the session caps

 fs/ceph/addr.c               |   2 +-
 fs/ceph/cache.h              |   6 -
 fs/ceph/caps.c               | 266 ++++++++++++++++++++++++++++---------------
 fs/ceph/file.c               |  32 +++---
 fs/ceph/inode.c              |  11 +-
 fs/ceph/mds_client.c         | 218 +++++++++++++++++++++++++----------
 fs/ceph/mds_client.h         |   5 +
 fs/ceph/mdsmap.c             |  12 +-
 fs/ceph/metric.c             |   4 +-
 fs/ceph/snap.c               |  59 ++++++----
 fs/ceph/strings.c            |   1 +
 fs/ceph/super.h              |   9 +-
 fs/ceph/xattr.c              |  19 ++++
 include/linux/ceph/ceph_fs.h |   1 +
 14 files changed, 438 insertions(+), 207 deletions(-)

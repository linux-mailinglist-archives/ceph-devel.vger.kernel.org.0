Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08692559F1
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Aug 2020 14:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729295AbgH1MUz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 28 Aug 2020 08:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729155AbgH1MUv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 28 Aug 2020 08:20:51 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB50C061264;
        Fri, 28 Aug 2020 05:20:50 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id q9so746345wmj.2;
        Fri, 28 Aug 2020 05:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DswbaMj/Bj1Mp+CWdbqZUrOpy/lT5pA9OVV1Y7BBtYc=;
        b=IXGhWjL+558q5uFEaQWoqCmIjUxWT1MrEw9a+vtBiZzOfbsu+hOEVIICiolEe7jPnr
         a/CJOjKSrBzqo+EP53sSivOSwLG+y926qcaRDpVVnzjJCmPSiVO/h3i0dIuzrUugBsbn
         Ul+EefVaU68ADbgxvDbfMm9hIp3tFBOXrs1fuvaUy7jqGRFxnEAl2g2F6ZHsah25oyLi
         XP8Iv6sgo2Ejfdz1P/u6M6+75lKQ0RyT/XtESRNuS7j2oSGs6JMk2PHxKyQIpJ/9tsVX
         OO2oJiee87bDSLLqdkb8/8dO7dC1xxKcbMpt/rUKlmnZZmguYyvVnm3euUkuzEHa36Ce
         p34w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DswbaMj/Bj1Mp+CWdbqZUrOpy/lT5pA9OVV1Y7BBtYc=;
        b=RXkUfu9JPKD4Dh4UCVhMAINbwZUsQLO6PpdfwM2gZvMKmnaslSd5mcGeVRJM8gpzEx
         XDhU1YySnQO/1bFeKQa5Y1lFb/e91DiEP4nuqSyDwMaCzoHoOPBKnhZtQB6TRuyvAUVZ
         gMEjyiRRND3rksoz1hixaBJ9D1gxoVochhdq80y+6jlxUbzOBih97Tau7iOmD7pvscKR
         o64xP3xJY9h1xMG0pa/JV7PcwLLJWnEGDE+LrSJo2jtcAb8wKVS3lYGCtL10zLez7Odh
         KONQQ7VXptattt55cyvW0Gv6grc286RkVfutP7x46B6vJtpPJ/SinVfgciieUSVcC+R5
         v6CA==
X-Gm-Message-State: AOAM531Kvagi59lFzYjUMh3LBwwN/8LpUpZKM9dbubetn0Ah1kitSSCY
        VVIxdRhj8Rt6G9fyJDhROYRGBZGPJRA2Gw==
X-Google-Smtp-Source: ABdhPJxexWmSahaBBbihQMWO+/wYsUSqZ8HV7J8bS8l3I/ThCASE+Yo+ExfGHoxVH9vbOSv5i/rNgA==
X-Received: by 2002:a1c:a746:: with SMTP id q67mr1467443wme.128.1598617249374;
        Fri, 28 Aug 2020 05:20:49 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id o2sm1734980wrj.21.2020.08.28.05.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 05:20:48 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.9-rc3
Date:   Fri, 28 Aug 2020 14:20:00 +0200
Message-Id: <20200828122000.1422-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit d012a7190fc1fd72ed48911e77ca97ba4521bccd:

  Linux 5.9-rc2 (2020-08-23 14:08:43 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.9-rc3

for you to fetch changes up to 496ceaf12432b3d136dcdec48424312e71359ea7:

  ceph: don't allow setlease on cephfs (2020-08-24 20:06:54 +0200)

----------------------------------------------------------------
We have an inode number handling change, prompted by s390x which is
a 64-bit architecture with a 32-bit ino_t, a patch to disallow leases
to avoid potential data integrity issues when CephFS is re-exported
via NFS or CIFS and a fix for the bulk of W=1 compilation warnings.

----------------------------------------------------------------
Ilya Dryomov (1):
      libceph: add __maybe_unused to DEFINE_CEPH_FEATURE

Jeff Layton (2):
      ceph: fix inode number handling on arches with 32-bit ino_t
      ceph: don't allow setlease on cephfs

 fs/ceph/caps.c                     | 14 ++++----
 fs/ceph/debugfs.c                  |  4 +--
 fs/ceph/dir.c                      | 31 +++++++---------
 fs/ceph/file.c                     |  5 +--
 fs/ceph/inode.c                    | 19 +++++-----
 fs/ceph/mds_client.h               |  2 +-
 fs/ceph/quota.c                    |  4 +--
 fs/ceph/super.h                    | 73 ++++++++++++++++++++------------------
 include/linux/ceph/ceph_features.h |  8 ++---
 9 files changed, 79 insertions(+), 81 deletions(-)

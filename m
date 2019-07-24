Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C55372EAF
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2019 14:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbfGXMVZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Jul 2019 08:21:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44664 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728123AbfGXMVZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 08:21:25 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7F39E307D965
        for <ceph-devel@vger.kernel.org>; Wed, 24 Jul 2019 12:21:25 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-93.pek2.redhat.com [10.72.12.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 383F160BEC;
        Wed, 24 Jul 2019 12:21:22 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 0/9 v2] ceph: auto reconnect after blacklisted
Date:   Wed, 24 Jul 2019 20:21:11 +0800
Message-Id: <20190724122120.17438-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 24 Jul 2019 12:21:25 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This series add support for auto reconnect after blacklisted.

Auto reconnect is controlled by recover_session=<clean|no> mount option.
So far only clean mode is supported and it is the default mode. In this
mode, client drops any dirty data/metadata, invalidates page caches and
invalidates all writable file handles. After reconnect, file locks become
stale because MDS lose track of them. If an inode contains any stale file
lock, read/write on the indoe are not allowed until all stale file locks
are released by applications.

v2: remove force_remount mount option
    no enabled auto reconnect by default
    remove unfinished recover_session=brute code

Yan, Zheng (9):
  libceph: add function that reset client's entity addr
  libceph: add function that clears osd client's abort_err
  ceph: allow closing session in restarting/reconnect state
  ceph: track and report error of async metadata operation
  ceph: pass filp to ceph_get_caps()
  ceph: add helper function that forcibly reconnects to ceph cluster.
  ceph: return -EIO if read/write against filp that lost file locks
  ceph: invalidate all write mode filp after reconnect
  ceph: auto reconnect after blacklisted

 Documentation/filesystems/ceph.txt | 10 ++++
 fs/ceph/addr.c                     | 37 ++++++++----
 fs/ceph/caps.c                     | 93 +++++++++++++++++++++---------
 fs/ceph/file.c                     | 50 +++++++++-------
 fs/ceph/inode.c                    |  2 +
 fs/ceph/locks.c                    |  8 ++-
 fs/ceph/mds_client.c               | 89 ++++++++++++++++++++++------
 fs/ceph/mds_client.h               |  6 +-
 fs/ceph/super.c                    | 45 ++++++++++++++-
 fs/ceph/super.h                    | 21 +++++--
 include/linux/ceph/libceph.h       |  1 +
 include/linux/ceph/messenger.h     |  1 +
 include/linux/ceph/mon_client.h    |  1 +
 include/linux/ceph/osd_client.h    |  2 +
 net/ceph/ceph_common.c             |  8 +++
 net/ceph/messenger.c               |  5 ++
 net/ceph/mon_client.c              |  7 +++
 net/ceph/osd_client.c              | 24 ++++++++
 18 files changed, 324 insertions(+), 86 deletions(-)

-- 
2.20.1


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A48125E429
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 14:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfGCMor (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 08:44:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56148 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCMor (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 08:44:47 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CF9903086203
        for <ceph-devel@vger.kernel.org>; Wed,  3 Jul 2019 12:44:46 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-77.pek2.redhat.com [10.72.12.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E429D17B40;
        Wed,  3 Jul 2019 12:44:44 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 0/9] ceph: auto reconnect after blacklisted 
Date:   Wed,  3 Jul 2019 20:44:33 +0800
Message-Id: <20190703124442.6614-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 03 Jul 2019 12:44:46 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This series add support for auto reconnect after blacklisted.

Auto reconnect is controlled by recover_session=<clean|no> mount option.
Clean mode is enabled by default. In this mode, client drops dirty date
and dirty metadata, All writable file handles are invalidated. Read-only
file handles continue to work and caches are dropped if necessary.

If an inode contains any lost file lock, read and write are not allowed.
until all lost file locks are released.

Yan, Zheng (9):
  libceph: add function that reset client's entity addr
  libceph: add function that clears osd client's abort_err
  ceph: allow closing session in restarting/reconnect state
  ceph: track and report error of async metadata operation
  ceph: pass filp to ceph_get_caps()
  ceph: return -EIO if read/write against filp that lost file locks
  ceph: add 'force_reconnect' option for remount
  ceph: invalidate all write mode filp after reconnect
  ceph: auto reconnect after blacklisted

 fs/ceph/addr.c                  | 30 +++++++----
 fs/ceph/caps.c                  | 84 ++++++++++++++++++++----------
 fs/ceph/file.c                  | 50 ++++++++++--------
 fs/ceph/inode.c                 |  2 +
 fs/ceph/locks.c                 |  8 ++-
 fs/ceph/mds_client.c            | 92 ++++++++++++++++++++++++++-------
 fs/ceph/mds_client.h            |  6 +--
 fs/ceph/super.c                 | 91 ++++++++++++++++++++++++++++++--
 fs/ceph/super.h                 | 23 +++++++--
 include/linux/ceph/libceph.h    |  1 +
 include/linux/ceph/messenger.h  |  1 +
 include/linux/ceph/mon_client.h |  1 +
 include/linux/ceph/osd_client.h |  2 +
 net/ceph/ceph_common.c          | 38 +++++++++-----
 net/ceph/messenger.c            |  5 ++
 net/ceph/mon_client.c           |  7 +++
 net/ceph/osd_client.c           | 24 +++++++++
 17 files changed, 365 insertions(+), 100 deletions(-)

-- 
2.20.1


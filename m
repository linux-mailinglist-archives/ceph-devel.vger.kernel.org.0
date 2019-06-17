Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE2ED48331
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 14:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfFQMze (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 08:55:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37008 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfFQMze (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 08:55:34 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EBB64821E5
        for <ceph-devel@vger.kernel.org>; Mon, 17 Jun 2019 12:55:33 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-92.pek2.redhat.com [10.72.12.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7173E7D66B;
        Mon, 17 Jun 2019 12:55:31 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 0/8] ceph: remount aborted mount
Date:   Mon, 17 Jun 2019 20:55:21 +0800
Message-Id: <20190617125529.6230-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 17 Jun 2019 12:55:33 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This series add support for remounting aborted cephfs mount. This
feature can be used for recovering from blacklisted. For example:

umount -f /ceph; mount -o remount /ceph

When aborting cephfs mount, dirty caps, unsafe requests, dirty data
file locks are dropped. After remounting, errors of dropping dirty
data/metadata are reported/cleared by fsync(2) on corresponding
inodes.

For file descriptor opened before abort, read works as nornal. write is
not allowed if any dirty data was dropped and the error is not cleared
by fsync(2). 

If an inode contains any lost file lock, read and write are not allowed.
until all lost file locks are released.

Yan, Zheng (8):
  libceph: add function that reset client's entity addr
  libceph: add function that clears osd client's abort_err
  ceph: allow closing session in restarting/reconnect state
  ceph: allow remounting aborted mount
  ceph: track and report error of async metadata operation
  ceph: pass filp to ceph_get_caps()
  ceph: check page writeback error during write
  ceph: return -EIO if read/write against filp that lost file locks

 fs/ceph/addr.c                  | 15 +++---
 fs/ceph/caps.c                  | 88 +++++++++++++++++++++++----------
 fs/ceph/file.c                  | 41 +++++++--------
 fs/ceph/inode.c                 |  2 +
 fs/ceph/locks.c                 |  8 ++-
 fs/ceph/mds_client.c            | 56 +++++++++++++++------
 fs/ceph/mds_client.h            |  6 +--
 fs/ceph/super.c                 | 23 ++++++++-
 fs/ceph/super.h                 | 11 +++--
 include/linux/ceph/libceph.h    |  1 +
 include/linux/ceph/messenger.h  |  1 +
 include/linux/ceph/mon_client.h |  1 +
 include/linux/ceph/osd_client.h |  2 +
 net/ceph/ceph_common.c          |  8 +++
 net/ceph/messenger.c            |  5 ++
 net/ceph/mon_client.c           |  7 +++
 net/ceph/osd_client.c           | 24 +++++++++
 17 files changed, 221 insertions(+), 78 deletions(-)

-- 
2.17.2


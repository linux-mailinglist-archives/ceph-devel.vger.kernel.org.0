Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E959144520
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Jan 2020 20:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgAUT3c (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Jan 2020 14:29:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:40080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbgAUT3b (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Jan 2020 14:29:31 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96BE12073A;
        Tue, 21 Jan 2020 19:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579634971;
        bh=5Ya4MnG+TC+9umSQmJn45eENRYdof5dK7joItookw9Y=;
        h=From:To:Cc:Subject:Date:From;
        b=abP9qZiw6qH+gqozw73peHS0X9o3X9DAP4Tz6XLbyALOoX7NBxV9C7xMXyzR9VRfW
         dHyDT1iezyHRUV/+nOc4BoiYNd1xiMSHGhnvbK48ISC0vhllkKoPTJZ/SHF4RHWk13
         3iez6JlUr/18/DIn73HArerfogG4ag4nTw4q5ICg=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idridryomov@gmail.com, sage@redhat.com, zyan@redhat.com
Subject: [RFC PATCH v3 00/10] ceph: asynchronous file create support
Date:   Tue, 21 Jan 2020 14:29:18 -0500
Message-Id: <20200121192928.469316-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

v3:
- move some cephfs-specific code into ceph.ko
- present and track inode numbers as u64 values
- fix up check for dentry and cap eligibility checks
- set O_CEPH_EXCL on async creates
- attempt to handle errors better on async create (invalidate dentries
  and dir completeness).
- ensure that fsync waits for async create to complete

v2:
- move cached layout to dedicated field in inode
- protect cached layout with i_ceph_lock
- wipe cached layout in __check_cap_issue
- set max_size of file to layout.stripe_unit
- set truncate_size to (u64)-1
- use dedicated CephFS feature bit instead of CEPHFS_FEATURE_OCTOPUS
- set cap_id to 1 in async created inode
- allocate inode number before submitting request
- rework the prep for an async create to be more efficient
- don't allow MDS or cap messages involving an inode until we get async
  create reply

Still not quite ready for merge, but I've cleaned up a number of warts
in the v2 set. Performance numbers still look about the same.

There is definitely still a race of some sort that causes the client to
try to asynchronously create a dentry that already exists. I'm still
working on tracking that down.

Jeff Layton (10):
  ceph: move net/ceph/ceph_fs.c to fs/ceph/util.c
  ceph: make ceph_fill_inode non-static
  ceph: make dentry_lease_is_valid non-static
  ceph: make __take_cap_refs non-static
  ceph: decode interval_sets for delegated inos
  ceph: add flag to designate that a request is asynchronous
  ceph: add infrastructure for waiting for async create to complete
  ceph: add new MDS req field to hold delegated inode number
  ceph: cache layout in parent dir on first sync create
  ceph: attempt to do async create when possible

 fs/ceph/Makefile                     |   2 +-
 fs/ceph/caps.c                       |  38 +++--
 fs/ceph/dir.c                        |  13 +-
 fs/ceph/file.c                       | 240 +++++++++++++++++++++++++--
 fs/ceph/inode.c                      |  50 +++---
 fs/ceph/mds_client.c                 | 123 ++++++++++++--
 fs/ceph/mds_client.h                 |  17 +-
 fs/ceph/super.h                      |  16 +-
 net/ceph/ceph_fs.c => fs/ceph/util.c |   4 -
 include/linux/ceph/ceph_fs.h         |   8 +-
 net/ceph/Makefile                    |   2 +-
 11 files changed, 443 insertions(+), 70 deletions(-)
 rename net/ceph/ceph_fs.c => fs/ceph/util.c (94%)

-- 
2.24.1


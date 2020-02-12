Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8133E15AEA5
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Feb 2020 18:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbgBLR1c (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Feb 2020 12:27:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:35474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbgBLR1c (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 Feb 2020 12:27:32 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3BBF2082F;
        Wed, 12 Feb 2020 17:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581528451;
        bh=F+EbaGkal7eK4Fi2g3GmOVg6jfN1jYPB2J+DYVyTeyA=;
        h=From:To:Cc:Subject:Date:From;
        b=AMJFz/pytLcLNCcqrZAPRr4CnboKs/28CGk0DOK73gE+daIdjerFxobeOql4T5D8b
         pRURV5Z5uLJjzLmuKSqJZKP0Thg0JYElkRIgPJu15qY7sKMvmaFISI+G0WCp4nQFjS
         +xZ2h4iRFaG3VxFMK4JDeJpAK9q7AfeF30QNz180=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idridryomov@gmail.com, sage@redhat.com, zyan@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH v4 0/9] ceph: add support for asynchronous directory operations
Date:   Wed, 12 Feb 2020 12:27:20 -0500
Message-Id: <20200212172729.260752-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I've dropped the async unlink patch from testing branch and am
resubmitting it here along with the rest of the create patches.

Zheng had pointed out that DIR_* caps should be cleared when the session
is reconnected. The underlying submission code needed changes to
handle that so it needed a bit of rework (along with the create code).

Since v3:
- rework async request submission to never queue the request when the
  session isn't open
- clean out DIR_* caps, layouts and delegated inodes when session goes down
- better ordering for dependent requests
- new mount options (wsync/nowsync) instead of module option
- more comprehensive error handling

Jeff Layton (9):
  ceph: add flag to designate that a request is asynchronous
  ceph: perform asynchronous unlink if we have sufficient caps
  ceph: make ceph_fill_inode non-static
  ceph: make __take_cap_refs non-static
  ceph: decode interval_sets for delegated inos
  ceph: add infrastructure for waiting for async create to complete
  ceph: add new MDS req field to hold delegated inode number
  ceph: cache layout in parent dir on first sync create
  ceph: attempt to do async create when possible

 fs/ceph/caps.c               |  73 +++++++---
 fs/ceph/dir.c                | 101 +++++++++++++-
 fs/ceph/file.c               | 253 +++++++++++++++++++++++++++++++++--
 fs/ceph/inode.c              |  58 ++++----
 fs/ceph/mds_client.c         | 156 +++++++++++++++++++--
 fs/ceph/mds_client.h         |  17 ++-
 fs/ceph/super.c              |  20 +++
 fs/ceph/super.h              |  21 ++-
 include/linux/ceph/ceph_fs.h |  17 ++-
 9 files changed, 637 insertions(+), 79 deletions(-)

-- 
2.24.1


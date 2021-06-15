Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A913A8370
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Jun 2021 16:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhFOO7g (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Jun 2021 10:59:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230298AbhFOO7g (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 15 Jun 2021 10:59:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CA8B6145D;
        Tue, 15 Jun 2021 14:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623769051;
        bh=DQ+4ABM2n0lVZJj0FAvRnKc/ypecTPX3Bq++k3Q6Tw0=;
        h=From:To:Cc:Subject:Date:From;
        b=O9g/8EnYj/sdkbp1ySQwBLedcScwJ7A6v+YMdUF0cudJUtjmIjHZSqAxttDIOM6xx
         BGiIrUvz9Jv46usDYU1DRT4o9pvN5Vor1ZEsevFie4iH3xdzj+cyfcuwFdZKBCzr24
         EGyAxw7ofHStLuarQH4lQoNTnjOoaDM1p/ByfDSfqCwltv3j7VsWk4vfy2jkoUowkg
         +mmeNYHKYhoiLDx2tG748u7sVBPWKCrCwx3kEWrLQ6kOqSNfm1OK1/hO6aALs+n0M3
         tc673nPgs3yW2Ra6GN28l9YE0WDiYlOJg1EvdqPNSbSLWoUTvjIbLClzshZpqIqY9E
         nTAxFd4MEjETw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, ukernel@gmail.com, idryomov@gmail.com,
        xiubli@redhat.com
Subject: [RFC PATCH 0/6] ceph: remove excess mutex locking from cap/snap flushing codepaths
Date:   Tue, 15 Jun 2021 10:57:24 -0400
Message-Id: <20210615145730.21952-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tldr: I'm hoping we can greatly simplify the locking in the cap sending
codepath, which should clean some some ugliness around iput and
unmounting.

For a long time, ceph has required the s_mutex and (to a lesser degree)
the snap_rwsem in the cap sending codepath. At least, it's been
documentd this way, but what these locks are intended to protect has
never been made clear.

I posted a query about requiring the s_mutex during cap/snap messages a
week or so ago, and have spent the last week going over that code. My
conclusion is that it's not actually necessary and we can just not
require it in many codepaths.

The problem with them is that we often want to call things like
ceph_check_caps after releasing references, but we may already hold
these same mutexes because we're in a reply handler causing a deadlock.

This has prompted things like the lock inversion loops in
ceph_check_caps and ceph_async_iput, which will queue the final inode
cleanup to a workqueue. That works reasonably well, but has problems
when we go to unmount. We can end up queueing these jobs after the point
where the workqueue is flushed.

I think the better fix for this is to just simplify the locking in these
codepaths, and make it unnecessary to take these mutexes in the first
place. The caps themselves are generally protected by the i_ceph_lock,
and nothing else seems to require that we take and hold these locks.

There _might_ be an argument to be made that we need to hold the
session->s_state constant when marshalling up the call, but it's hard to
see why. A mutex is a very heavyweight way to do this, and the s_state
field isn't consistently protected by it anyway.

I've tested this pretty heavily on my local test rig and it seems to
have done well. What I'd like to do next is put this into the testing
kernel and see if any bugs shake out. If any do, we can just revert the
set and figure out what went wrong.

Thoughts?

Jeff Layton (6):
  ceph: allow ceph_put_mds_session to take NULL or ERR_PTR
  ceph: eliminate session->s_gen_ttl_lock
  ceph: don't take s_mutex or snap_rwsem in ceph_check_caps
  ceph: don't take s_mutex in try_flush_caps
  ceph: don't take s_mutex in ceph_flush_snaps
  ceph: eliminate ceph_async_iput()

 fs/ceph/caps.c       | 106 ++++++++-----------------------------------
 fs/ceph/dir.c        |   7 +--
 fs/ceph/inode.c      |  35 +++-----------
 fs/ceph/mds_client.c |  45 +++++++++---------
 fs/ceph/mds_client.h |   6 +--
 fs/ceph/metric.c     |   3 +-
 fs/ceph/quota.c      |   6 +--
 fs/ceph/snap.c       |  14 +++---
 fs/ceph/super.h      |   2 -
 9 files changed, 61 insertions(+), 163 deletions(-)

-- 
2.31.1


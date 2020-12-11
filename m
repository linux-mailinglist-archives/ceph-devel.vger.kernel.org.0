Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4E82D75C7
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Dec 2020 13:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395210AbgLKMkU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Dec 2020 07:40:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:38960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436533AbgLKMjl (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 07:39:41 -0500
From:   Jeff Layton <jlayton@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, idryomov@gmail.com
Subject: [PATCH 0/3] ceph: don't call ceph_check_caps in page_mkwrite
Date:   Fri, 11 Dec 2020 07:38:55 -0500
Message-Id: <20201211123858.7522-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I've been working on the fscache rework, and have hit some rather
complex lockdep circular locking warnings. Most of them involve two
filesystems (cephfs and the local cachefiles fs), so it's not clear
to me whether they are false positives.

They do involve the mmap_lock though, which is taken up in the vfs. I
think it would probably be best to not do the ceph_check_caps call with
that lock held if we can avoid it.

The first patch in this series fixes what looks like a probable bug to
me. If we want to avoid checking caps in some cases, then we probably
also want to avoid flushing the snaps too since that involves the same
locks.

The second patch replaces the patch that I sent a few weeks ago to add
a queue_inode_work helper.

The last patch extends some work that Xiubo did earlier to allow skipping
the caps check after putting references. It adds a new "flavor" when
putting caps that instead has the inode work do the check or flush after
the refcounts have been decremented.

Jeff Layton (3):
  ceph: fix flush_snap logic after putting caps
  ceph: clean up inode work queueing
  ceph: allow queueing cap/snap handling after putting cap references

 fs/ceph/addr.c  |  2 +-
 fs/ceph/caps.c  | 36 +++++++++++++++++++++++------
 fs/ceph/inode.c | 61 ++++++++++---------------------------------------
 fs/ceph/super.h | 40 +++++++++++++++++++++++++++-----
 4 files changed, 76 insertions(+), 63 deletions(-)

-- 
2.29.2


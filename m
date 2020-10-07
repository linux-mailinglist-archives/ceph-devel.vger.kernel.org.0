Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2060C285EE6
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Oct 2020 14:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgJGMRE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Oct 2020 08:17:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727978AbgJGMRE (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 7 Oct 2020 08:17:04 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56B1F20789;
        Wed,  7 Oct 2020 12:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602073023;
        bh=KAJ2KjUQK645O4fGggZ4lKiZp6Q8jpGKXvQEWUL6Ngo=;
        h=From:To:Cc:Subject:Date:From;
        b=vsiuU01PmeYR/DIkw7orLKJwyoofkBt1Pbq9neLpkqsTRuBXK89TWNuholT/9qGLG
         XAeG6HUSoh8PI2m6R7uA7F3sBbp7XArzzhkq1T5e4PX0v3cf6Ust4p2EDIdWdUQf7L
         wXGttnasZki/mzZLKU+D3lTNT8+DMnmB9GefCVTs=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com
Subject: [PATCH v4 0/5] ceph: fix spurious recover_session=clean errors
Date:   Wed,  7 Oct 2020 08:16:55 -0400
Message-Id: <20201007121700.10489-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

v4: test for CEPH_MOUNT_RECOVER in more places
v3: add RECOVER mount_state and allow dumping pagecache when it's set
    shrink size of mount_state field
v2: fix handling of async requests in patch to queue requests

This is the fourth revision of this patchset. The main difference from
v3 is that this one converts more "==" tests for SHUTDOWN state into
">=", so that the RECOVER state is treated the same way.

Original cover letter:

Ilya noticed that he would get spurious EACCES errors on calls done just
after blocklisting the client on mounts with recover_session=clean. The
session would get marked as REJECTED and that caused in-flight calls to
die with EACCES. This patchset seems to smooth over the problem, but I'm
not fully convinced it's the right approach.

The potential issue I see is that the client could take cap references to
do a call on a session that has been blocklisted. We then queue the
message and reestablish the session, but we may not have been granted
the same caps by the MDS at that point.

If this is a problem, then we probably need to rework it so that we
return a distinct error code in this situation and have the upper layers
issue a completely new mds request (with new cap refs, etc.)

Obviously, that's a much more invasive approach though, so it would be
nice to avoid that if this would suffice.

Jeff Layton (5):
  ceph: don't WARN when removing caps due to blocklisting
  ceph: make fsc->mount_state an int
  ceph: add new RECOVER mount_state when recovering session
  ceph: remove timeout on allowing reconnect after blocklisting
  ceph: queue MDS requests to REJECTED sessions when CLEANRECOVER is set

 fs/ceph/addr.c               |  4 ++--
 fs/ceph/caps.c               |  4 ++--
 fs/ceph/inode.c              |  2 +-
 fs/ceph/mds_client.c         | 27 ++++++++++++++++-----------
 fs/ceph/super.c              | 14 ++++++++++----
 fs/ceph/super.h              |  3 +--
 include/linux/ceph/libceph.h |  1 +
 7 files changed, 33 insertions(+), 22 deletions(-)

-- 
2.26.2


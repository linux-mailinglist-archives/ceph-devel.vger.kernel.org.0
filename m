Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF0E16454A
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 14:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgBSNZ2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Feb 2020 08:25:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:33602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgBSNZ2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 19 Feb 2020 08:25:28 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A99F124654;
        Wed, 19 Feb 2020 13:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582118728;
        bh=dBb3IxuxmNE8l02AwJ97SFNsPSd8HB3llUd6N4WqMtM=;
        h=From:To:Cc:Subject:Date:From;
        b=BNV43IfcBGhd+k9E5k+fuHgMS1kMDrY5044ZYgFABWSCT7mieeqMhtzXJKCiI5FXa
         xLITHsipb6dL6p3/7crQ+10U3GPOlp2xk8tO2pnzgp3f/VNhMo5tZUoKxJag/NyrG2
         Z3Z2mFtOSNnbU7FLvzCvwcDVub4rt/FStoXNc5R0=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com, zyan@redhat.com,
        pdonnell@redhat.com, xiubli@redhat.com
Subject: [PATCH v5 00/12] ceph: async directory operations support
Date:   Wed, 19 Feb 2020 08:25:14 -0500
Message-Id: <20200219132526.17590-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

A lot of changes in this set -- some highlights:

v5: reorganize patchset for easier review and better bisectability
    rework how dir caps are acquired and tracked in requests
    preemptively release cap refs when reconnecting session
    restore inode number back to pool when fall back to sync create
    rework unlink cap acquisition to be lighter weight
    new "nowsync" mount opt, patterned after xfs "wsync" mount opt

Performance is on par with earlier sets.

I previously pulled the async unlink patch from ceph-client/testing, so
this set includes a revised version of that as well, and orders it
some other changes. I also broke that one up into several patches.

This should (hopefully) address Zheng's concerns about releasing the
caps when the session is lost. Those are preemptively released now
when the session is reconnected. 

This adds a new mount option too. xfs has a "wsync" mount option which
makes it wait for namespaced directory operations to be journalled
before returning. This patchset adds "wsync" and "nowsync" options, so
it can now be enabled/disabled on a per-sb-basis.

The default for xfs is "nowsync". For ceph though, I'm leaving it as
"wsync" for now, so you need to mount with "nowsync" to enable async
dirops.

We may not actually need patch #6 here. Zheng had that delta in one
of the earlier patches, but I'm not sure it's really needed now. It
may make sense to just take it on its own merits though.

Comments and suggestions welcome.

Jeff Layton (11):
  ceph: add flag to designate that a request is asynchronous
  ceph: track primary dentry link
  ceph: add infrastructure for waiting for async create to complete
  ceph: make __take_cap_refs non-static
  ceph: cap tracking for async directory operations
  ceph: perform asynchronous unlink if we have sufficient caps
  ceph: make ceph_fill_inode non-static
  ceph: decode interval_sets for delegated inos
  ceph: add new MDS req field to hold delegated inode number
  ceph: cache layout in parent dir on first sync create
  ceph: attempt to do async create when possible

Yan, Zheng (1):
  ceph: don't take refs to want mask unless we have all bits

 fs/ceph/caps.c               |  72 +++++++---
 fs/ceph/dir.c                | 106 +++++++++++++-
 fs/ceph/file.c               | 270 +++++++++++++++++++++++++++++++++--
 fs/ceph/inode.c              |  58 ++++----
 fs/ceph/mds_client.c         | 196 ++++++++++++++++++++++---
 fs/ceph/mds_client.h         |  24 +++-
 fs/ceph/super.c              |  20 +++
 fs/ceph/super.h              |  21 ++-
 include/linux/ceph/ceph_fs.h |  17 ++-
 9 files changed, 701 insertions(+), 83 deletions(-)

-- 
2.24.1


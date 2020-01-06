Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA7D1314E3
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jan 2020 16:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgAFPfX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jan 2020 10:35:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbgAFPfW (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 10:35:22 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD4442081E;
        Mon,  6 Jan 2020 15:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578324922;
        bh=U9JEGm/5O4YT080+YBVx8vkmXIz7lYuuk89CwL6guB0=;
        h=From:To:Cc:Subject:Date:From;
        b=sL006RFPpivkg6zaBNo3ps7UlVxcXZB8Z5D9QwfDyQT9stH9hSqOgI3nWZfeXtNCW
         74Kz8CvCoskH+QiuzICRw/vsCHXOInq8Yb/O86hN7irMXrpiCkgGSFpFU+xIIZNrwB
         bertBxDmj//ar3f1r0BbfXMABryJVAbzgxvB5/Ig=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH 0/6] ceph: asynchronous unlink support
Date:   Mon,  6 Jan 2020 10:35:14 -0500
Message-Id: <20200106153520.307523-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I sent an initial RFC set for this around 10 months ago. Since then,
the requisite patches for the MDS have been merged for the octopus
release. This adds support to the kclient to take advantage of
asynchronous unlinks.

In earlier testing (with a vstart cluster backed by a rotating HDD), I
saw roughly a 2x speedup when doing an rmdir on a directory with 10000
files in it. When testing with a cluster backed by an NVMe SSD though,
I only saw about a 20% speedup.

I'd like to put this in the testing branch now, so that it's ready for
merge in the upcoming v5.6 merge window. Once this is in, asynchronous
create support will be the next step.

Jeff Layton (4):
  ceph: close holes in struct ceph_mds_session
  ceph: hold extra reference to r_parent over life of request
  ceph: register MDS request with dir inode from the start
  ceph: add refcounting for Fx caps

Yan, Zheng (2):
  ceph: check inode type for CEPH_CAP_FILE_{CACHE,RD,REXTEND,LAZYIO}
  ceph: perform asynchronous unlink if we have sufficient caps

 fs/ceph/caps.c               | 84 ++++++++++++++++++++++++++----------
 fs/ceph/dir.c                | 70 ++++++++++++++++++++++++++++--
 fs/ceph/inode.c              |  9 +++-
 fs/ceph/mds_client.c         | 27 ++++++------
 fs/ceph/mds_client.h         |  2 +-
 fs/ceph/super.c              |  4 ++
 fs/ceph/super.h              | 17 +++-----
 include/linux/ceph/ceph_fs.h |  9 ++++
 8 files changed, 169 insertions(+), 53 deletions(-)

-- 
2.24.1


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7AF2AD5D1
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 13:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbgKJMDF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 07:03:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:59200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbgKJMDF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 07:03:05 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EA46206B2;
        Tue, 10 Nov 2020 12:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605009784;
        bh=QK4PYKiA6EWtL1Tvjyh8lXLo9Iq956oRlJeY2nf8uDQ=;
        h=From:To:Cc:Subject:Date:From;
        b=hEQdcGyXMv0/Vx7kDZLclfGdJDErp8be3m81H/smsV0gTSgYwy6DMcQZCZ5EWSsCV
         EgweZGu04TkawFpukf0KKiUMAFgmgsCuUg4bg2IiyqPTcntUfeq8prawBZNM86WK42
         e3El169Fn7AZwVY3InhpFmgE1P0ypkhz/i6eNJ7M=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com
Subject: [PATCH] ceph: ensure we have Fs caps when fetching dir link count
Date:   Tue, 10 Nov 2020 07:03:02 -0500
Message-Id: <20201110120302.13992-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The link count for a directory is defined as inode->i_subdirs + 2,
(for "." and ".."). i_subdirs is only populated when Fs caps are held.
Ensure we grab Fs caps when fetching the link count for a directory.

URL: https://tracker.ceph.com/issues/48125
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 7c22bc2ea076..9ba15ca6b010 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2343,15 +2343,22 @@ int ceph_permission(struct inode *inode, int mask)
 }
 
 /* Craft a mask of needed caps given a set of requested statx attrs. */
-static int statx_to_caps(u32 want)
+static int statx_to_caps(u32 want, umode_t mode)
 {
 	int mask = 0;
 
 	if (want & (STATX_MODE|STATX_UID|STATX_GID|STATX_CTIME|STATX_BTIME))
 		mask |= CEPH_CAP_AUTH_SHARED;
 
-	if (want & (STATX_NLINK|STATX_CTIME))
+	if (want & (STATX_NLINK|STATX_CTIME)) {
 		mask |= CEPH_CAP_LINK_SHARED;
+		/*
+		 * The link count for directories depends on inode->i_subdirs,
+		 * and that is only updated when Fs caps are held.
+		 */
+		if (S_ISDIR(mode))
+			mask |= CEPH_CAP_FILE_SHARED;
+	}
 
 	if (want & (STATX_ATIME|STATX_MTIME|STATX_CTIME|STATX_SIZE|
 		    STATX_BLOCKS))
@@ -2377,7 +2384,7 @@ int ceph_getattr(const struct path *path, struct kstat *stat,
 
 	/* Skip the getattr altogether if we're asked not to sync */
 	if (!(flags & AT_STATX_DONT_SYNC)) {
-		err = ceph_do_getattr(inode, statx_to_caps(request_mask),
+		err = ceph_do_getattr(inode, statx_to_caps(request_mask, inode->i_mode),
 				      flags & AT_STATX_FORCE_SYNC);
 		if (err)
 			return err;
-- 
2.28.0


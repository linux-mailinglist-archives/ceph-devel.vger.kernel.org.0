Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804642ADC2F
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 17:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgKJQaz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 11:30:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:56420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgKJQaz (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 11:30:55 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36A1220780;
        Tue, 10 Nov 2020 16:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605025854;
        bh=Rqs5o3XgIXE7AY9WudOzSXYDCnnjEDVKMCUdxW7dN2k=;
        h=From:To:Cc:Subject:Date:From;
        b=r5vkpjM8ppavpgL0lxfqPaF+a64qOZapIh3v4/S3tIFBViOHst8KRl6ZiPQWMo+0u
         V+fN/yIVd1cA6S5UD+hi8eXH5GseIbKRJjyT32KFVi4I9nF9Z+kzo9eFd+L9EgHn20
         bxpmQWp2ChETuanPNt73Ez3ctOJylZ1W1UWntByY=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com
Subject: [PATCH v2] ceph: ensure we have Fs caps when fetching dir link count
Date:   Tue, 10 Nov 2020 11:30:52 -0500
Message-Id: <20201110163052.482965-1-jlayton@kernel.org>
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
 fs/ceph/inode.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 7c22bc2ea076..ab02966ef0a4 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2343,15 +2343,23 @@ int ceph_permission(struct inode *inode, int mask)
 }
 
 /* Craft a mask of needed caps given a set of requested statx attrs. */
-static int statx_to_caps(u32 want)
+static int statx_to_caps(u32 want, umode_t mode)
 {
 	int mask = 0;
 
 	if (want & (STATX_MODE|STATX_UID|STATX_GID|STATX_CTIME|STATX_BTIME))
 		mask |= CEPH_CAP_AUTH_SHARED;
 
-	if (want & (STATX_NLINK|STATX_CTIME))
-		mask |= CEPH_CAP_LINK_SHARED;
+	if (want & (STATX_NLINK|STATX_CTIME)) {
+		/*
+		 * The link count for directories depends on inode->i_subdirs,
+		 * and that is only updated when Fs caps are held.
+		 */
+		if (S_ISDIR(mode))
+			mask |= CEPH_CAP_FILE_SHARED;
+		else
+			mask |= CEPH_CAP_LINK_SHARED;
+	}
 
 	if (want & (STATX_ATIME|STATX_MTIME|STATX_CTIME|STATX_SIZE|
 		    STATX_BLOCKS))
@@ -2377,7 +2385,7 @@ int ceph_getattr(const struct path *path, struct kstat *stat,
 
 	/* Skip the getattr altogether if we're asked not to sync */
 	if (!(flags & AT_STATX_DONT_SYNC)) {
-		err = ceph_do_getattr(inode, statx_to_caps(request_mask),
+		err = ceph_do_getattr(inode, statx_to_caps(request_mask, inode->i_mode),
 				      flags & AT_STATX_FORCE_SYNC);
 		if (err)
 			return err;
-- 
2.28.0


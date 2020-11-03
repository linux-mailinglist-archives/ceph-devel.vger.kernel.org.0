Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB322A4FBE
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Nov 2020 20:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgKCTLB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Nov 2020 14:11:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:56358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727688AbgKCTLA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 3 Nov 2020 14:11:00 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31F492072C;
        Tue,  3 Nov 2020 19:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604430660;
        bh=VE9t/rdXDSag8z+rKeFIND20BwrBbUavTeMFudzECoQ=;
        h=From:To:Cc:Subject:Date:From;
        b=WIwmsNtW17QY5qkUWWMekcPPAaqbdpOpcouoXRPpuNmoEhzbi3gfUzPFIerBS2D9p
         WMrKGH231ed+jZ9ZzmdZKjKk+XoxeSm36Mk5fQzSeDQQX4b7DC2Wy3m8vekg80xrDL
         p0hCLmw/BOzIVWsBgobFBq5VNW2OCtVvVSZrvuAs=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com
Subject: [RFC PATCH] ceph: acquire Fs caps when getting dir stats
Date:   Tue,  3 Nov 2020 14:10:58 -0500
Message-Id: <20201103191058.1019442-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We only update the inode's dirstats when we have Fs caps from the MDS.

Declare a new VXATTR_FLAG_DIRSTAT that we set on all dirstats, and have
the vxattr handling code acquire Fs caps when it's set.

URL: https://tracker.ceph.com/issues/48104
Reported-by: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/xattr.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 197cb1234341..0fd05d3d4399 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -42,6 +42,7 @@ struct ceph_vxattr {
 #define VXATTR_FLAG_READONLY		(1<<0)
 #define VXATTR_FLAG_HIDDEN		(1<<1)
 #define VXATTR_FLAG_RSTAT		(1<<2)
+#define VXATTR_FLAG_DIRSTAT		(1<<3)
 
 /* layouts */
 
@@ -347,9 +348,9 @@ static struct ceph_vxattr ceph_dir_vxattrs[] = {
 	XATTR_LAYOUT_FIELD(dir, layout, object_size),
 	XATTR_LAYOUT_FIELD(dir, layout, pool),
 	XATTR_LAYOUT_FIELD(dir, layout, pool_namespace),
-	XATTR_NAME_CEPH(dir, entries, 0),
-	XATTR_NAME_CEPH(dir, files, 0),
-	XATTR_NAME_CEPH(dir, subdirs, 0),
+	XATTR_NAME_CEPH(dir, entries, VXATTR_FLAG_DIRSTAT),
+	XATTR_NAME_CEPH(dir, files, VXATTR_FLAG_DIRSTAT),
+	XATTR_NAME_CEPH(dir, subdirs, VXATTR_FLAG_DIRSTAT),
 	XATTR_RSTAT_FIELD(dir, rentries),
 	XATTR_RSTAT_FIELD(dir, rfiles),
 	XATTR_RSTAT_FIELD(dir, rsubdirs),
@@ -837,6 +838,8 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 		int mask = 0;
 		if (vxattr->flags & VXATTR_FLAG_RSTAT)
 			mask |= CEPH_STAT_RSTAT;
+		if (vxattr->flags & VXATTR_FLAG_DIRSTAT)
+			mask |= CEPH_CAP_FILE_SHARED;
 		err = ceph_do_getattr(inode, mask, true);
 		if (err)
 			return err;
-- 
2.28.0


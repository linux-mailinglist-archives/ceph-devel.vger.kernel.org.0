Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF86CF56F
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Apr 2019 13:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfD3LWi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Apr 2019 07:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbfD3LWi (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 07:22:38 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77DDA20675;
        Tue, 30 Apr 2019 11:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556623358;
        bh=VbgqbpAl8u0brqdnS7SRFDEiUHlJGErd4Mw29LtP5q4=;
        h=From:To:Cc:Subject:Date:From;
        b=Hcd86SahSZ4K0upSvNEs9mgAGECW+C5kJvrGAGD/RDkxjb7+yH/OBwsJltWONZJj4
         q5u/lwvdz7gTo9fXv/+7ERl0stZLU8TqUkU+78tejL3Eg8mAnf89OXpqrOOvcJHmKi
         ALsXcMuRAQXrtkNMu4eWZxRYl1gHgfPQevxUe05g=
From:   Jeff Layton <jlayton@kernel.org>
To:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: print inode number in __caps_issued_mask debugging messages
Date:   Tue, 30 Apr 2019 07:22:34 -0400
Message-Id: <20190430112236.14162-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

To make it easier to correlate with MDS logs.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 9e0b464d374f..72f8e1311392 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -892,8 +892,8 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
 	int have = ci->i_snap_caps;
 
 	if ((have & mask) == mask) {
-		dout("__ceph_caps_issued_mask %p snap issued %s"
-		     " (mask %s)\n", &ci->vfs_inode,
+		dout("__ceph_caps_issued_mask ino 0x%lx snap issued %s"
+		     " (mask %s)\n", ci->vfs_inode.i_ino,
 		     ceph_cap_string(have),
 		     ceph_cap_string(mask));
 		return 1;
@@ -904,8 +904,8 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
 		if (!__cap_is_valid(cap))
 			continue;
 		if ((cap->issued & mask) == mask) {
-			dout("__ceph_caps_issued_mask %p cap %p issued %s"
-			     " (mask %s)\n", &ci->vfs_inode, cap,
+			dout("__ceph_caps_issued_mask ino 0x%lx cap %p issued %s"
+			     " (mask %s)\n", ci->vfs_inode.i_ino, cap,
 			     ceph_cap_string(cap->issued),
 			     ceph_cap_string(mask));
 			if (touch)
@@ -916,8 +916,8 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
 		/* does a combination of caps satisfy mask? */
 		have |= cap->issued;
 		if ((have & mask) == mask) {
-			dout("__ceph_caps_issued_mask %p combo issued %s"
-			     " (mask %s)\n", &ci->vfs_inode,
+			dout("__ceph_caps_issued_mask ino 0x%lx combo issued %s"
+			     " (mask %s)\n", ci->vfs_inode.i_ino,
 			     ceph_cap_string(cap->issued),
 			     ceph_cap_string(mask));
 			if (touch) {
-- 
2.20.1


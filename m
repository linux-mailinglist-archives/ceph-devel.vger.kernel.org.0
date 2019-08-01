Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4C937E40D
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Aug 2019 22:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfHAU0N (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Aug 2019 16:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbfHAU0M (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 16:26:12 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 733C22080C;
        Thu,  1 Aug 2019 20:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564691171;
        bh=wYlo91P18uNQg93VeUntHLaTeRzcuNYhpTby8BQNZhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPJEgqQ8mZmn5Xd+qzaLiNbrUJhBMPRyFgCAoFYFVRhkUqIqoBR3lCmuzDpeUtxYk
         NK2qk44X7LyBWZfsYLjj58I+NtGJj6T06az9UtLBX4UePz2AoKclhVHRhHuZElq1+T
         +o31hYSD3phwpJtk0Fay0o0Vh2XPQibXPGITxfKk=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH 4/9] ceph: add refcounting for Fx caps
Date:   Thu,  1 Aug 2019 16:26:00 -0400
Message-Id: <20190801202605.18172-5-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801202605.18172-1-jlayton@kernel.org>
References: <20190801202605.18172-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c  | 7 +++++++
 fs/ceph/inode.c | 1 +
 fs/ceph/super.h | 2 +-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index d3b9c9d5c1bd..c8a677ddedd8 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -964,6 +964,8 @@ int __ceph_caps_used(struct ceph_inode_info *ci)
 		used |= CEPH_CAP_FILE_WR;
 	if (ci->i_wb_ref || ci->i_wrbuffer_ref)
 		used |= CEPH_CAP_FILE_BUFFER;
+	if (ci->i_fx_ref)
+		used |= CEPH_CAP_FILE_EXCL;
 	return used;
 }
 
@@ -2503,6 +2505,8 @@ static void __take_cap_refs(struct ceph_inode_info *ci, int got,
 		ci->i_rd_ref++;
 	if (got & CEPH_CAP_FILE_CACHE)
 		ci->i_rdcache_ref++;
+	if (got & CEPH_CAP_FILE_EXCL)
+		ci->i_fx_ref++;
 	if (got & CEPH_CAP_FILE_WR) {
 		if (ci->i_wr_ref == 0 && !ci->i_head_snapc) {
 			BUG_ON(!snap_rwsem_locked);
@@ -2897,6 +2901,9 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
 	if (had & CEPH_CAP_FILE_CACHE)
 		if (--ci->i_rdcache_ref == 0)
 			last++;
+	if (had & CEPH_CAP_FILE_EXCL)
+		if (--ci->i_fx_ref == 0)
+			last++;
 	if (had & CEPH_CAP_FILE_BUFFER) {
 		if (--ci->i_wb_ref == 0) {
 			last++;
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 9f135624ae47..c844bd7f5f37 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -494,6 +494,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 	ci->i_rdcache_ref = 0;
 	ci->i_wr_ref = 0;
 	ci->i_wb_ref = 0;
+	ci->i_fx_ref = 0;
 	ci->i_wrbuffer_ref = 0;
 	ci->i_wrbuffer_ref_head = 0;
 	atomic_set(&ci->i_filelock_ref, 0);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 4cd60f58d690..a9aa3e358226 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -373,7 +373,7 @@ struct ceph_inode_info {
 
 	/* held references to caps */
 	int i_pin_ref;
-	int i_rd_ref, i_rdcache_ref, i_wr_ref, i_wb_ref;
+	int i_rd_ref, i_rdcache_ref, i_wr_ref, i_wb_ref, i_fx_ref;
 	int i_wrbuffer_ref, i_wrbuffer_ref_head;
 	atomic_t i_filelock_ref;
 	atomic_t i_shared_gen;       /* increment each time we get FILE_SHARED */
-- 
2.21.0


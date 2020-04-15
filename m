Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9E11AA8DE
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Apr 2020 15:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370719AbgDONji (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 Apr 2020 09:39:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731246AbgDONjc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 15 Apr 2020 09:39:32 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D99A2206F9;
        Wed, 15 Apr 2020 13:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586957971;
        bh=R0ZGVy8JtoqPx/ZWUnx6LG+WTHtMF7Vs7WGXGiHG2Wc=;
        h=From:To:Cc:Subject:Date:From;
        b=1xWVFhzgng9WlXIH18LKpyi8BC9uUPMgRqIrbf9G4tVt2KasjmywrSVjJ33vy19Pt
         /FJ7XOwuVMiXSvk+2XQyvDv651KVgmGIXVbQIsCcy49fiZAkPRUygFfU+uQiXgCqNX
         VegFz29MQrz1d3M70BsOm259g3g8XdpS3yDqUx8s=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, dan.carpenter@oracle.com
Subject: [PATCH v2] ceph: fix potential bad pointer deref in async dirops cb's
Date:   Wed, 15 Apr 2020 09:39:29 -0400
Message-Id: <20200415133929.234033-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The new async dirops callback routines can pass ERR_PTR values to
ceph_mdsc_free_path, which could cause an oops.

Given that ceph_mdsc_build_path returns ERR_PTR values, it makes sense
to just have ceph_mdsc_free_path ignore them. Also, clean up the error
handling a bit in mdsc_show, and ensure that the pr_warn messages look
sane even if ceph_mdsc_build_path fails.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/debugfs.c    | 8 ++------
 fs/ceph/dir.c        | 4 ++--
 fs/ceph/file.c       | 4 ++--
 fs/ceph/mds_client.h | 2 +-
 4 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index eebbce7c3b0c..3baec3a896ee 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -83,13 +83,11 @@ static int mdsc_show(struct seq_file *s, void *p)
 		} else if (req->r_dentry) {
 			path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
 						    &pathbase, 0);
-			if (IS_ERR(path))
-				path = NULL;
 			spin_lock(&req->r_dentry->d_lock);
 			seq_printf(s, " #%llx/%pd (%s)",
 				   ceph_ino(d_inode(req->r_dentry->d_parent)),
 				   req->r_dentry,
-				   path ? path : "");
+				   IS_ERR(path) ? "" : path);
 			spin_unlock(&req->r_dentry->d_lock);
 			ceph_mdsc_free_path(path, pathlen);
 		} else if (req->r_path1) {
@@ -102,14 +100,12 @@ static int mdsc_show(struct seq_file *s, void *p)
 		if (req->r_old_dentry) {
 			path = ceph_mdsc_build_path(req->r_old_dentry, &pathlen,
 						    &pathbase, 0);
-			if (IS_ERR(path))
-				path = NULL;
 			spin_lock(&req->r_old_dentry->d_lock);
 			seq_printf(s, " #%llx/%pd (%s)",
 				   req->r_old_dentry_dir ?
 				   ceph_ino(req->r_old_dentry_dir) : 0,
 				   req->r_old_dentry,
-				   path ? path : "");
+				   IS_ERR(path) ? "" : path);
 			spin_unlock(&req->r_old_dentry->d_lock);
 			ceph_mdsc_free_path(path, pathlen);
 		} else if (req->r_path2 && req->r_op != CEPH_MDS_OP_SYMLINK) {
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 9d02d4feb693..39f5311404b0 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1057,8 +1057,8 @@ static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
 
 	/* If op failed, mark everyone involved for errors */
 	if (result) {
-		int pathlen;
-		u64 base;
+		int pathlen = 0;
+		u64 base = 0;
 		char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
 						  &base, 0);
 
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 3a1bd13de84f..160644ddaeed 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -529,8 +529,8 @@ static void ceph_async_create_cb(struct ceph_mds_client *mdsc,
 
 	if (result) {
 		struct dentry *dentry = req->r_dentry;
-		int pathlen;
-		u64 base;
+		int pathlen = 0;
+		u64 base = 0;
 		char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
 						  &base, 0);
 
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 1b40f30e0a8e..43111e408fa2 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -531,7 +531,7 @@ extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
 
 static inline void ceph_mdsc_free_path(char *path, int len)
 {
-	if (path)
+	if (!IS_ERR_OR_NULL(path))
 		__putname(path - (PATH_MAX - 1 - len));
 }
 
-- 
2.25.2


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4A041A23F0
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Apr 2020 16:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgDHOV2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Apr 2020 10:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbgDHOV2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 8 Apr 2020 10:21:28 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2A3420787;
        Wed,  8 Apr 2020 14:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586355688;
        bh=ln9w5lPzSQ9Lhj8c7C9BfvxWDbQV0VA1ULTuhh7a39I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0u+G5mXljCtsAKFoM0p7HQ8sN2R5P7Mjcnz0iLHMvQzOMOciPwNcTJxGIQ/wR6/8Y
         UKApDH6QIudH8S3kLz7WyJnOTbMzth2N86X4Ft9QRXpUzX5gJJAdkDINksYytWGkPa
         sQxNi+/dLM50txV6gmU4M1v2yZsQo8IlIqCLpyRs=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, dan.carpenter@oracle.com, sage@redhat.com
Subject: [PATCH 1/2] ceph: have ceph_mdsc_free_path ignore ERR_PTR values
Date:   Wed,  8 Apr 2020 10:21:24 -0400
Message-Id: <20200408142125.52908-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200408142125.52908-1-jlayton@kernel.org>
References: <20200408142125.52908-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This makes the error handling simpler in some callers, and fixes a
couple of bugs in the new async dirops callback code.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/debugfs.c    | 4 ----
 fs/ceph/mds_client.c | 6 ++----
 fs/ceph/mds_client.h | 2 +-
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index eebbce7c3b0c..3a198e40f100 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -83,8 +83,6 @@ static int mdsc_show(struct seq_file *s, void *p)
 		} else if (req->r_dentry) {
 			path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
 						    &pathbase, 0);
-			if (IS_ERR(path))
-				path = NULL;
 			spin_lock(&req->r_dentry->d_lock);
 			seq_printf(s, " #%llx/%pd (%s)",
 				   ceph_ino(d_inode(req->r_dentry->d_parent)),
@@ -102,8 +100,6 @@ static int mdsc_show(struct seq_file *s, void *p)
 		if (req->r_old_dentry) {
 			path = ceph_mdsc_build_path(req->r_old_dentry, &pathlen,
 						    &pathbase, 0);
-			if (IS_ERR(path))
-				path = NULL;
 			spin_lock(&req->r_old_dentry->d_lock);
 			seq_printf(s, " #%llx/%pd (%s)",
 				   req->r_old_dentry_dir ?
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a8a5b98148ec..e25ee9fe0ee8 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2535,11 +2535,9 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
 	msg->hdr.data_off = cpu_to_le16(0);
 
 out_free2:
-	if (freepath2)
-		ceph_mdsc_free_path((char *)path2, pathlen2);
+	ceph_mdsc_free_path((char *)path2, pathlen2);
 out_free1:
-	if (freepath1)
-		ceph_mdsc_free_path((char *)path1, pathlen1);
+	ceph_mdsc_free_path((char *)path1, pathlen1);
 out:
 	return msg;
 }
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


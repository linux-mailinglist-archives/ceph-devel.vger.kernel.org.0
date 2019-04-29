Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC2B7EACF
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Apr 2019 21:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbfD2TZ5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Apr 2019 15:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729191AbfD2TZ5 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 29 Apr 2019 15:25:57 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D88682067D;
        Mon, 29 Apr 2019 19:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556565956;
        bh=qva5Gmr0BVvS13tzsQT4dNSKugR0laPHOKSIeKJoyuQ=;
        h=From:To:Cc:Subject:Date:From;
        b=pkedSwLAcSXkjxO7rDqkZUQOFZ+cky0fsY7xW6jdgqxOicYXjMap92hRMh2rMA47j
         iHZTvCqyfpERSJgOMlYuHpbkJcUUD2qEOM6zRmhNgEwbXOuo8hDGxLnUx52ldzv1t7
         ARZcYs2W4T9lv0l+7mek65VHZYZTe9YsBdgFU2VE=
From:   Jeff Layton <jlayton@kernel.org>
To:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: [PATCH 1/2] ceph: use ceph_mdsc_build_path instead of clone_dentry_name
Date:   Mon, 29 Apr 2019 15:25:53 -0400
Message-Id: <20190429192554.30833-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

While it may be slightly more efficient, it's probably not worthwhile to
optimize for the case that clone_dentry_name handles. We can get the
same result by just calling ceph_mdsc_build_path when the parent isn't
locked, with less code duplication.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 41 +++--------------------------------------
 1 file changed, 3 insertions(+), 38 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 74cb3078ea63..e8245df09691 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2170,55 +2170,20 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
 	return path;
 }
 
-/* Duplicate the dentry->d_name.name safely */
-static int clone_dentry_name(struct dentry *dentry, const char **ppath,
-			     int *ppathlen)
-{
-	u32 len;
-	char *name;
-retry:
-	len = READ_ONCE(dentry->d_name.len);
-	name = kmalloc(len + 1, GFP_NOFS);
-	if (!name)
-		return -ENOMEM;
-
-	spin_lock(&dentry->d_lock);
-	if (dentry->d_name.len != len) {
-		spin_unlock(&dentry->d_lock);
-		kfree(name);
-		goto retry;
-	}
-	memcpy(name, dentry->d_name.name, len);
-	spin_unlock(&dentry->d_lock);
-
-	name[len] = '\0';
-	*ppath = name;
-	*ppathlen = len;
-	return 0;
-}
-
 static int build_dentry_path(struct dentry *dentry, struct inode *dir,
 			     const char **ppath, int *ppathlen, u64 *pino,
 			     bool *pfreepath, bool parent_locked)
 {
-	int ret;
 	char *path;
 
 	rcu_read_lock();
 	if (!dir)
 		dir = d_inode_rcu(dentry->d_parent);
-	if (dir && ceph_snap(dir) == CEPH_NOSNAP) {
+	if (dir && parent_locked && ceph_snap(dir) == CEPH_NOSNAP) {
 		*pino = ceph_ino(dir);
 		rcu_read_unlock();
-		if (parent_locked) {
-			*ppath = dentry->d_name.name;
-			*ppathlen = dentry->d_name.len;
-		} else {
-			ret = clone_dentry_name(dentry, ppath, ppathlen);
-			if (ret)
-				return ret;
-			*pfreepath = true;
-		}
+		*ppath = dentry->d_name.name;
+		*ppathlen = dentry->d_name.len;
 		return 0;
 	}
 	rcu_read_unlock();
-- 
2.20.1


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 683F6EAD0
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Apr 2019 21:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbfD2TZ6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Apr 2019 15:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729191AbfD2TZ5 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 29 Apr 2019 15:25:57 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4EE1215EA;
        Mon, 29 Apr 2019 19:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556565957;
        bh=YX5i9x2PCrilqW1kWez51IMNwCrV5EQcbtPTM9SupIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZL0deVUtqx2odfyTDrDwQbLapGfRhWGLnZLY7IfH8/635LzGRxBwYjqyEG68bepn+
         OQva2Y0/QyKMMo1YHQUKFVbRp5EgCtGLhWrT/dH09G4xfvT+BPdzf06vI5tswxWXDa
         XiUyg7Xotoksb8qFnnQON2S7sUkR2JDYVTAApFvU=
From:   Jeff Layton <jlayton@kernel.org>
To:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: [PATCH 2/2] ceph: use __getname/__putname in ceph_mdsc_build_path
Date:   Mon, 29 Apr 2019 15:25:54 -0400
Message-Id: <20190429192554.30833-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190429192554.30833-1-jlayton@kernel.org>
References: <20190429192554.30833-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Al suggested we get rid of the kmalloc here and just use __getname
and __putname to get a full PATH_MAX pathname buffer.

Since we build the path in reverse, we continue to return a pointer
to the beginning of the string and the length, and add a new helper
to free the thing at the end.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/debugfs.c    |  4 +--
 fs/ceph/mds_client.c | 58 ++++++++++++++++----------------------------
 fs/ceph/mds_client.h |  6 +++++
 3 files changed, 29 insertions(+), 39 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 777f6ceb5259..b014fc7d4e3c 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -88,7 +88,7 @@ static int mdsc_show(struct seq_file *s, void *p)
 				   req->r_dentry,
 				   path ? path : "");
 			spin_unlock(&req->r_dentry->d_lock);
-			kfree(path);
+			ceph_mdsc_free_path(path, pathlen);
 		} else if (req->r_path1) {
 			seq_printf(s, " #%llx/%s", req->r_ino1.ino,
 				   req->r_path1);
@@ -108,7 +108,7 @@ static int mdsc_show(struct seq_file *s, void *p)
 				   req->r_old_dentry,
 				   path ? path : "");
 			spin_unlock(&req->r_old_dentry->d_lock);
-			kfree(path);
+			ceph_mdsc_free_path(path, pathlen);
 		} else if (req->r_path2 && req->r_op != CEPH_MDS_OP_SYMLINK) {
 			if (req->r_ino2.ino)
 				seq_printf(s, " #%llx/%s", req->r_ino2.ino,
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index e8245df09691..92372fc647c7 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2092,39 +2092,24 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
 {
 	struct dentry *temp;
 	char *path;
-	int len, pos;
+	int pos;
 	unsigned seq;
 	u64 base;
 
 	if (!dentry)
 		return ERR_PTR(-EINVAL);
 
-retry:
-	len = 0;
-	seq = read_seqbegin(&rename_lock);
-	rcu_read_lock();
-	for (temp = dentry; !IS_ROOT(temp);) {
-		struct inode *inode = d_inode(temp);
-		if (inode && ceph_snap(inode) == CEPH_SNAPDIR)
-			len++;  /* slash only */
-		else if (stop_on_nosnap && inode &&
-			 ceph_snap(inode) == CEPH_NOSNAP)
-			break;
-		else
-			len += 1 + temp->d_name.len;
-		temp = temp->d_parent;
-	}
-	rcu_read_unlock();
-	if (len)
-		len--;  /* no leading '/' */
-
-	path = kmalloc(len+1, GFP_NOFS);
+	path = __getname();
 	if (!path)
 		return ERR_PTR(-ENOMEM);
-	pos = len;
-	path[pos] = 0;	/* trailing null */
+retry:
+	pos = PATH_MAX - 1;
+	path[pos] = '\0';
+
+	seq = read_seqbegin(&rename_lock);
 	rcu_read_lock();
-	for (temp = dentry; !IS_ROOT(temp) && pos != 0; ) {
+	temp = dentry;
+	for (;;) {
 		struct inode *inode;
 
 		spin_lock(&temp->d_lock);
@@ -2142,32 +2127,31 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
 				spin_unlock(&temp->d_lock);
 				break;
 			}
-			strncpy(path + pos, temp->d_name.name,
-				temp->d_name.len);
+			memcpy(path + pos, temp->d_name.name, temp->d_name.len);
 		}
 		spin_unlock(&temp->d_lock);
-		if (pos)
-			path[--pos] = '/';
 		temp = temp->d_parent;
+		if (IS_ROOT(temp))
+			break;
+		path[--pos] = '/';
 	}
 	base = ceph_ino(d_inode(temp));
 	rcu_read_unlock();
-	if (pos != 0 || read_seqretry(&rename_lock, seq)) {
+	if (pos < 0 || read_seqretry(&rename_lock, seq)) {
 		pr_err("build_path did not end path lookup where "
-		       "expected, namelen is %d, pos is %d\n", len, pos);
+		       "expected, pos is %d\n", pos);
 		/* presumably this is only possible if racing with a
 		   rename of one of the parent directories (we can not
 		   lock the dentries above us to prevent this, but
 		   retrying should be harmless) */
-		kfree(path);
 		goto retry;
 	}
 
 	*pbase = base;
-	*plen = len;
+	*plen = PATH_MAX - 1 - pos;
 	dout("build_path on %p %d built %llx '%.*s'\n",
-	     dentry, d_count(dentry), base, len, path);
-	return path;
+	     dentry, d_count(dentry), base, *plen, path+pos);
+	return path + pos;
 }
 
 static int build_dentry_path(struct dentry *dentry, struct inode *dir,
@@ -2374,10 +2358,10 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
 
 out_free2:
 	if (freepath2)
-		kfree((char *)path2);
+		ceph_mdsc_free_path((char *)path2, pathlen2);
 out_free1:
 	if (freepath1)
-		kfree((char *)path1);
+		ceph_mdsc_free_path((char *)path1, pathlen1);
 out:
 	return msg;
 }
@@ -3449,7 +3433,7 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		ceph_pagelist_encode_string(pagelist, path, pathlen);
 		ceph_pagelist_append(pagelist, &rec, sizeof(rec.v1));
 out_freepath:
-		kfree(path);
+		ceph_mdsc_free_path(path, pathlen);
 	}
 
 out_err:
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 0d1f673a5689..ebcad5afc87b 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -492,6 +492,12 @@ extern int ceph_iterate_session_caps(struct ceph_mds_session *session,
 				     void *arg);
 extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
 
+static inline void ceph_mdsc_free_path(char *path, int len)
+{
+	if (path)
+		__putname(path - (PATH_MAX - 1 - len));
+}
+
 extern char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *base,
 				  int stop_on_nosnap);
 
-- 
2.20.1


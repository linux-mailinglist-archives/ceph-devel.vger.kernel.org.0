Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B397335C7F8
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Apr 2021 15:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238881AbhDLNwn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Apr 2021 09:52:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237043AbhDLNwl (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 12 Apr 2021 09:52:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7F1F6109F;
        Mon, 12 Apr 2021 13:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618235543;
        bh=Mr3ohmxIvXbPU4KZEo324xFcCclKa8cKtMBQrVktpME=;
        h=From:To:Cc:Subject:Date:From;
        b=ANUybJPmDyZYgzOQec5t0N5isQX96z8oENuNH1FKSceOXm/hZml3KwS/zenDTfaLu
         VaWsI5KdFiJ4XLZA1rrXvQh7OBUU2GMD3NIBRCL7h55hGcfRQYgwoaq8NSYy7vQ6Sk
         afqpRUcVqblCtKKIQDbVmlhHRBGsr4+deahzY7HtBz2KWNikvcWTBB2QSJk4xdb/Lg
         RDm1P79ub7lRcCmWffTs0FjYcIhR6xEatmzsFsrHdhEXenzxrHp6oz3eoKsqICDIfy
         rLhbL9HEcfeBLIDMy1v0sxO78x/nxwuCg8o3qvSs+wYY0WBbFsmC9Uz2NVjueVxQh/
         iJLRdUhLmX/Jg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Subject: [PATCH] ceph: fix up some bare fetches of i_size
Date:   Mon, 12 Apr 2021 09:52:21 -0400
Message-Id: <20210412135221.42894-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

It's cleaner to use i_size_read, which properly handles the torn read
case on 32-bit arches.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c       |  6 +++---
 fs/ceph/inode.c      | 22 +++++++++++-----------
 fs/ceph/mds_client.c |  2 +-
 fs/ceph/snap.c       |  2 +-
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index e712826ea3f1..a5e93b185515 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1390,7 +1390,7 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
 	arg->flush_tid = flush_tid;
 	arg->oldest_flush_tid = oldest_flush_tid;
 
-	arg->size = inode->i_size;
+	arg->size = i_size_read(inode);
 	ci->i_reported_size = arg->size;
 	arg->max_size = ci->i_wanted_max_size;
 	if (cap == ci->i_auth_cap) {
@@ -1885,7 +1885,7 @@ static int try_nonblocking_invalidate(struct inode *inode)
 
 bool __ceph_should_report_size(struct ceph_inode_info *ci)
 {
-	loff_t size = ci->vfs_inode.i_size;
+	loff_t size = i_size_read(&ci->vfs_inode);
 	/* mds will adjust max size according to the reported size */
 	if (ci->i_flushing_caps & CEPH_CAP_FILE_WR)
 		return false;
@@ -3299,7 +3299,7 @@ static void handle_cap_grant(struct inode *inode,
 	dout("handle_cap_grant inode %p cap %p mds%d seq %d %s\n",
 	     inode, cap, session->s_mds, seq, ceph_cap_string(newcaps));
 	dout(" size %llu max_size %llu, i_size %llu\n", size, max_size,
-		inode->i_size);
+		i_size_read(inode));
 
 
 	/*
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index b1911d04bc23..e1c63adb196d 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -632,10 +632,11 @@ int ceph_fill_file_size(struct inode *inode, int issued,
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	int queue_trunc = 0;
+	loff_t isize = i_size_read(inode);
 
 	if (ceph_seq_cmp(truncate_seq, ci->i_truncate_seq) > 0 ||
-	    (truncate_seq == ci->i_truncate_seq && size > inode->i_size)) {
-		dout("size %lld -> %llu\n", inode->i_size, size);
+	    (truncate_seq == ci->i_truncate_seq && size > isize)) {
+		dout("size %lld -> %llu\n", isize, size);
 		if (size > 0 && S_ISDIR(inode->i_mode)) {
 			pr_err("fill_file_size non-zero size for directory\n");
 			size = 0;
@@ -1823,7 +1824,7 @@ bool ceph_inode_set_size(struct inode *inode, loff_t size)
 	bool ret;
 
 	spin_lock(&ci->i_ceph_lock);
-	dout("set_size %p %llu -> %llu\n", inode, inode->i_size, size);
+	dout("set_size %p %llu -> %llu\n", inode, i_size_read(inode), size);
 	i_size_write(inode, size);
 	inode->i_blocks = calc_inode_blocks(size);
 
@@ -2130,20 +2131,19 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr)
 		}
 	}
 	if (ia_valid & ATTR_SIZE) {
-		dout("setattr %p size %lld -> %lld\n", inode,
-		     inode->i_size, attr->ia_size);
-		if ((issued & CEPH_CAP_FILE_EXCL) &&
-		    attr->ia_size > inode->i_size) {
+		loff_t isize = i_size_read(inode);
+
+		dout("setattr %p size %lld -> %lld\n", inode, isize, attr->ia_size);
+		if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size > isize) {
 			i_size_write(inode, attr->ia_size);
 			inode->i_blocks = calc_inode_blocks(attr->ia_size);
 			ci->i_reported_size = attr->ia_size;
 			dirtied |= CEPH_CAP_FILE_EXCL;
 			ia_valid |= ATTR_MTIME;
 		} else if ((issued & CEPH_CAP_FILE_SHARED) == 0 ||
-			   attr->ia_size != inode->i_size) {
+			   attr->ia_size != isize) {
 			req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
-			req->r_args.setattr.old_size =
-				cpu_to_le64(inode->i_size);
+			req->r_args.setattr.old_size = cpu_to_le64(isize);
 			mask |= CEPH_SETATTR_SIZE;
 			release |= CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL |
 				   CEPH_CAP_FILE_RD | CEPH_CAP_FILE_WR;
@@ -2253,7 +2253,7 @@ int ceph_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 		return err;
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
-	    attr->ia_size > max(inode->i_size, fsc->max_file_size))
+	    attr->ia_size > max(i_size_read(inode), fsc->max_file_size))
 		return -EFBIG;
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d2fd4843c9cc..e5af591d3bd4 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3794,7 +3794,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		rec.v1.cap_id = cpu_to_le64(cap->cap_id);
 		rec.v1.wanted = cpu_to_le32(__ceph_caps_wanted(ci));
 		rec.v1.issued = cpu_to_le32(cap->issued);
-		rec.v1.size = cpu_to_le64(inode->i_size);
+		rec.v1.size = cpu_to_le64(i_size_read(inode));
 		ceph_encode_timespec64(&rec.v1.mtime, &inode->i_mtime);
 		ceph_encode_timespec64(&rec.v1.atime, &inode->i_atime);
 		rec.v1.snaprealm = cpu_to_le64(ci->i_snap_realm->ino);
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index c0fbbb56b259..5955ce1aae0e 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -606,7 +606,7 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
 
 	BUG_ON(capsnap->writing);
-	capsnap->size = inode->i_size;
+	capsnap->size = i_size_read(inode);
 	capsnap->mtime = inode->i_mtime;
 	capsnap->atime = inode->i_atime;
 	capsnap->ctime = inode->i_ctime;
-- 
2.30.2


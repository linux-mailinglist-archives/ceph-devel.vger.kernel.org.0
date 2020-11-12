Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F962B08AE
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Nov 2020 16:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgKLPn4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Nov 2020 10:43:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:37336 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728230AbgKLPnz (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 10:43:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E4D65AE13;
        Thu, 12 Nov 2020 15:43:52 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 1391d1b9;
        Thu, 12 Nov 2020 15:23:22 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.de>
Subject: [PATCH] Revert "ceph: allow rename operation under different quota realms"
Date:   Thu, 12 Nov 2020 15:23:21 +0000
Message-Id: <20201112152321.32491-1-lhenriques@suse.de>
In-Reply-To: <87ft5ed3gj.fsf@suse.de>
References: <87ft5ed3gj.fsf@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This reverts commit dffdcd71458e699e839f0bf47c3d42d64210b939.

When doing a rename across quota realms, there's a corner case that isn't
handled correctly.  Here's a testcase:

  mkdir files limit
  truncate files/file -s 10G
  setfattr limit -n ceph.quota.max_bytes -v 1000000
  mv files limit/

The above will succeed because ftruncate(2) won't immediately notify the
MDSs with the new file size, and thus the quota realms stats won't be
updated.

Since the possible fixes for this issue would have a huge performance impact,
the solution for now is to simply revert to returning -EXDEV when doing a cross
quota realms rename.

URL: https://tracker.ceph.com/issues/48203
Signed-off-by: Luis Henriques <lhenriques@suse.de>
---
 fs/ceph/dir.c   |  9 ++++----
 fs/ceph/quota.c | 58 +------------------------------------------------
 fs/ceph/super.h |  3 +--
 3 files changed, 6 insertions(+), 64 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index a4d48370b2b3..858ee7362ff5 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1202,12 +1202,11 @@ static int ceph_rename(struct inode *old_dir, struct dentry *old_dentry,
 			op = CEPH_MDS_OP_RENAMESNAP;
 		else
 			return -EROFS;
-	} else if (old_dir != new_dir) {
-		err = ceph_quota_check_rename(mdsc, d_inode(old_dentry),
-					      new_dir);
-		if (err)
-			return err;
 	}
+	/* don't allow cross-quota renames */
+	if ((old_dir != new_dir) &&
+	    (!ceph_quota_is_same_realm(old_dir, new_dir)))
+		return -EXDEV;
 
 	dout("rename dir %p dentry %p to dir %p dentry %p\n",
 	     old_dir, old_dentry, new_dir, new_dentry);
diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index 9b785f11e95a..4e32c9600ecc 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -264,7 +264,7 @@ static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
 	return NULL;
 }
 
-static bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
+bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
 {
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(old->i_sb);
 	struct ceph_snap_realm *old_realm, *new_realm;
@@ -516,59 +516,3 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
 	return is_updated;
 }
 
-/*
- * ceph_quota_check_rename - check if a rename can be executed
- * @mdsc:	MDS client instance
- * @old:	inode to be copied
- * @new:	destination inode (directory)
- *
- * This function verifies if a rename (e.g. moving a file or directory) can be
- * executed.  It forces an rstat update in the @new target directory (and in the
- * source @old as well, if it's a directory).  The actual check is done both for
- * max_files and max_bytes.
- *
- * This function returns 0 if it's OK to do the rename, or, if quotas are
- * exceeded, -EXDEV (if @old is a directory) or -EDQUOT.
- */
-int ceph_quota_check_rename(struct ceph_mds_client *mdsc,
-			    struct inode *old, struct inode *new)
-{
-	struct ceph_inode_info *ci_old = ceph_inode(old);
-	int ret = 0;
-
-	if (ceph_quota_is_same_realm(old, new))
-		return 0;
-
-	/*
-	 * Get the latest rstat for target directory (and for source, if a
-	 * directory)
-	 */
-	ret = ceph_do_getattr(new, CEPH_STAT_RSTAT, false);
-	if (ret)
-		return ret;
-
-	if (S_ISDIR(old->i_mode)) {
-		ret = ceph_do_getattr(old, CEPH_STAT_RSTAT, false);
-		if (ret)
-			return ret;
-		ret = check_quota_exceeded(new, QUOTA_CHECK_MAX_BYTES_OP,
-					   ci_old->i_rbytes);
-		if (!ret)
-			ret = check_quota_exceeded(new,
-						   QUOTA_CHECK_MAX_FILES_OP,
-						   ci_old->i_rfiles +
-						   ci_old->i_rsubdirs);
-		if (ret)
-			ret = -EXDEV;
-	} else {
-		ret = check_quota_exceeded(new, QUOTA_CHECK_MAX_BYTES_OP,
-					   i_size_read(old));
-		if (!ret)
-			ret = check_quota_exceeded(new,
-						   QUOTA_CHECK_MAX_FILES_OP, 1);
-		if (ret)
-			ret = -EDQUOT;
-	}
-
-	return ret;
-}
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 482473e4cce1..8dbb0babddea 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1222,14 +1222,13 @@ extern void ceph_handle_quota(struct ceph_mds_client *mdsc,
 			      struct ceph_mds_session *session,
 			      struct ceph_msg *msg);
 extern bool ceph_quota_is_max_files_exceeded(struct inode *inode);
+extern bool ceph_quota_is_same_realm(struct inode *old, struct inode *new);
 extern bool ceph_quota_is_max_bytes_exceeded(struct inode *inode,
 					     loff_t newlen);
 extern bool ceph_quota_is_max_bytes_approaching(struct inode *inode,
 						loff_t newlen);
 extern bool ceph_quota_update_statfs(struct ceph_fs_client *fsc,
 				     struct kstatfs *buf);
-extern int ceph_quota_check_rename(struct ceph_mds_client *mdsc,
-				   struct inode *old, struct inode *new);
 extern void ceph_cleanup_quotarealms_inodes(struct ceph_mds_client *mdsc);
 
 #endif /* _FS_CEPH_SUPER_H */

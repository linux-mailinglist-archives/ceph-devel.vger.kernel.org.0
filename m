Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AA93DDF9D
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Aug 2021 20:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhHBSvm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Aug 2021 14:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhHBSvl (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 14:51:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF43460551;
        Mon,  2 Aug 2021 18:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627930292;
        bh=i6kKE9i3oObjC7zW494aGCiC4CVzauzeVz8DoyO50XE=;
        h=From:To:Cc:Subject:Date:From;
        b=kCV0J3q5IAzpqMUYVuFEr2jR8IaTjOykj5qLjbTOEq3PxLRZYVmJZzZA2Fn0oEFi2
         vnmEWZyxnSae3Qw+O1aqbGSLxJ0ZJHhtMHb+gW8FqIVVY7VucAdB3n4GEe6Urs2/bp
         tLOoiw77QR8LLqpi4LfrpZAjVcQjAoHHGkSey5wLSqKj0OHs2QjH9AhM17gUi4JnDF
         qPQKkN+g+pqKBAixWp4UyNEzAGWont5qCZ2moHFI9vtvjUnWqeEakQjTjumEjnw28T
         UsSKCJs4cKnZMoGWcuurF39z9BQy8Kjqi6So7UdyfimqNkJ8Y8rhyPvdtMYj3CRI9/
         RR22XlII1d6wA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH] ceph: new helper - ceph_change_snap_realm
Date:   Mon,  2 Aug 2021 14:51:30 -0400
Message-Id: <20210802185130.94783-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Consolidate some fiddly code for changing an inode's snap_realm
into a new helper function, and change the callers to use it.

While we're in here, nothing uses the i_snap_realm_counter field, so
remove that from the inode.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c  | 36 +++---------------------------
 fs/ceph/inode.c | 11 ++-------
 fs/ceph/snap.c  | 59 ++++++++++++++++++++++++++++++++-----------------
 fs/ceph/super.h |  2 +-
 4 files changed, 45 insertions(+), 63 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index cb551c9e5867..cecd4f66a60d 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -704,23 +704,7 @@ void ceph_add_cap(struct inode *inode,
 		struct ceph_snap_realm *realm = ceph_lookup_snap_realm(mdsc,
 							       realmino);
 		if (realm) {
-			struct ceph_snap_realm *oldrealm = ci->i_snap_realm;
-			if (oldrealm) {
-				spin_lock(&oldrealm->inodes_with_caps_lock);
-				list_del_init(&ci->i_snap_realm_item);
-				spin_unlock(&oldrealm->inodes_with_caps_lock);
-			}
-
-			spin_lock(&realm->inodes_with_caps_lock);
-			list_add(&ci->i_snap_realm_item,
-				 &realm->inodes_with_caps);
-			ci->i_snap_realm = realm;
-			if (realm->ino == ci->i_vino.ino)
-				realm->inode = inode;
-			spin_unlock(&realm->inodes_with_caps_lock);
-
-			if (oldrealm)
-				ceph_put_snap_realm(mdsc, oldrealm);
+			ceph_change_snap_realm(inode, realm);
 		} else {
 			pr_err("ceph_add_cap: couldn't find snap realm %llx\n",
 			       realmino);
@@ -1112,20 +1096,6 @@ int ceph_is_any_caps(struct inode *inode)
 	return ret;
 }
 
-static void drop_inode_snap_realm(struct ceph_inode_info *ci)
-{
-	struct ceph_snap_realm *realm = ci->i_snap_realm;
-	spin_lock(&realm->inodes_with_caps_lock);
-	list_del_init(&ci->i_snap_realm_item);
-	ci->i_snap_realm_counter++;
-	ci->i_snap_realm = NULL;
-	if (realm->ino == ci->i_vino.ino)
-		realm->inode = NULL;
-	spin_unlock(&realm->inodes_with_caps_lock);
-	ceph_put_snap_realm(ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc,
-			    realm);
-}
-
 /*
  * Remove a cap.  Take steps to deal with a racing iterate_session_caps.
  *
@@ -1201,7 +1171,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 		 * keep i_snap_realm.
 		 */
 		if (ci->i_wr_ref == 0 && ci->i_snap_realm)
-			drop_inode_snap_realm(ci);
+			ceph_change_snap_realm(&ci->vfs_inode, NULL);
 
 		__cap_delay_cancel(mdsc, ci);
 	}
@@ -3083,7 +3053,7 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 			}
 			/* see comment in __ceph_remove_cap() */
 			if (!__ceph_is_any_real_caps(ci) && ci->i_snap_realm)
-				drop_inode_snap_realm(ci);
+				ceph_change_snap_realm(inode, NULL);
 		}
 	}
 	if (check_flushsnaps && __ceph_have_pending_cap_snap(ci)) {
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 84e4f112fc45..61ecf81ed875 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -582,16 +582,9 @@ void ceph_evict_inode(struct inode *inode)
 	 */
 	if (ci->i_snap_realm) {
 		if (ceph_snap(inode) == CEPH_NOSNAP) {
-			struct ceph_snap_realm *realm = ci->i_snap_realm;
 			dout(" dropping residual ref to snap realm %p\n",
-			     realm);
-			spin_lock(&realm->inodes_with_caps_lock);
-			list_del_init(&ci->i_snap_realm_item);
-			ci->i_snap_realm = NULL;
-			if (realm->ino == ci->i_vino.ino)
-				realm->inode = NULL;
-			spin_unlock(&realm->inodes_with_caps_lock);
-			ceph_put_snap_realm(mdsc, realm);
+			     ci->i_snap_realm);
+			ceph_change_snap_realm(inode, NULL);
 		} else {
 			ceph_put_snapid_map(mdsc, ci->i_snapid_map);
 			ci->i_snap_realm = NULL;
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 4ac0606dcbd4..9dbc92cfda38 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -846,6 +846,43 @@ static void flush_snaps(struct ceph_mds_client *mdsc)
 	dout("flush_snaps done\n");
 }
 
+/**
+ * ceph_change_snap_realm - change the snap_realm for an inode
+ * @inode: inode to move to new snap realm
+ * @realm: new realm to move inode into (may be NULL)
+ *
+ * Detach an inode from its old snaprealm (if any) and attach it to
+ * the new snaprealm (if any). The old snap realm reference held by
+ * the inode is put. If realm is non-NULL, then the caller's reference
+ * to it is taken over by the inode.
+ */
+void ceph_change_snap_realm(struct inode *inode, struct ceph_snap_realm *realm)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
+	struct ceph_snap_realm *oldrealm = ci->i_snap_realm;
+
+	lockdep_assert_held(&ci->i_ceph_lock);
+
+	if (oldrealm) {
+		spin_lock(&oldrealm->inodes_with_caps_lock);
+		list_del_init(&ci->i_snap_realm_item);
+		if (oldrealm->ino == ci->i_vino.ino)
+			oldrealm->inode = NULL;
+		spin_unlock(&oldrealm->inodes_with_caps_lock);
+		ceph_put_snap_realm(mdsc, oldrealm);
+	}
+
+	ci->i_snap_realm = realm;
+
+	if (realm) {
+		spin_lock(&realm->inodes_with_caps_lock);
+		list_add(&ci->i_snap_realm_item, &realm->inodes_with_caps);
+		if (realm->ino == ci->i_vino.ino)
+			realm->inode = inode;
+		spin_unlock(&realm->inodes_with_caps_lock);
+	}
+}
 
 /*
  * Handle a snap notification from the MDS.
@@ -932,7 +969,6 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 			};
 			struct inode *inode = ceph_find_inode(sb, vino);
 			struct ceph_inode_info *ci;
-			struct ceph_snap_realm *oldrealm;
 
 			if (!inode)
 				continue;
@@ -957,27 +993,10 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 			}
 			dout(" will move %p to split realm %llx %p\n",
 			     inode, realm->ino, realm);
-			/*
-			 * Move the inode to the new realm
-			 */
-			oldrealm = ci->i_snap_realm;
-			spin_lock(&oldrealm->inodes_with_caps_lock);
-			list_del_init(&ci->i_snap_realm_item);
-			spin_unlock(&oldrealm->inodes_with_caps_lock);
-
-			spin_lock(&realm->inodes_with_caps_lock);
-			list_add(&ci->i_snap_realm_item,
-				 &realm->inodes_with_caps);
-			ci->i_snap_realm = realm;
-			if (realm->ino == ci->i_vino.ino)
-                                realm->inode = inode;
-			spin_unlock(&realm->inodes_with_caps_lock);
-
-			spin_unlock(&ci->i_ceph_lock);
 
 			ceph_get_snap_realm(mdsc, realm);
-			ceph_put_snap_realm(mdsc, oldrealm);
-
+			ceph_change_snap_realm(inode, realm);
+			spin_unlock(&ci->i_ceph_lock);
 			iput(inode);
 			continue;
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index d51d42a00f33..389b45ac291b 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -422,7 +422,6 @@ struct ceph_inode_info {
 		struct ceph_snap_realm *i_snap_realm; /* snap realm (if caps) */
 		struct ceph_snapid_map *i_snapid_map; /* snapid -> dev_t */
 	};
-	int i_snap_realm_counter; /* snap realm (if caps) */
 	struct list_head i_snap_realm_item;
 	struct list_head i_snap_flush_item;
 	struct timespec64 i_btime;
@@ -933,6 +932,7 @@ extern void ceph_put_snap_realm(struct ceph_mds_client *mdsc,
 extern int ceph_update_snap_trace(struct ceph_mds_client *m,
 				  void *p, void *e, bool deletion,
 				  struct ceph_snap_realm **realm_ret);
+void ceph_change_snap_realm(struct inode *inode, struct ceph_snap_realm *realm);
 extern void ceph_handle_snap(struct ceph_mds_client *mdsc,
 			     struct ceph_mds_session *session,
 			     struct ceph_msg *msg);
-- 
2.31.1


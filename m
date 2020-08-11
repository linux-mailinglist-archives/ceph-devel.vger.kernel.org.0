Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1362524171A
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Aug 2020 09:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgHKHXM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 11 Aug 2020 03:23:12 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26573 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726421AbgHKHXM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 11 Aug 2020 03:23:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597130590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ay0b1WTBWMvnZtCbau2iXHzmJbFinCeAdnzadVuGXmo=;
        b=Mn+kYOY1Rgxv+S9Of8M0QVQ0iLr3tCfRPwkF9beF0wOtetOJTKi2szD5uOTMpLbCyEosfQ
        jZbxsknhOIKv8MVlj8/rJxDBaOtwaFAFUZxt6JmUAK4UNh+HACInmLpPEiC9BJGNRaWVZq
        4R5eFLLTeNMp7KDpxv5DM+5AKlbqhfs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-5vMQRnAwMuuG97GnBVOgFQ-1; Tue, 11 Aug 2020 03:23:07 -0400
X-MC-Unique: 5vMQRnAwMuuG97GnBVOgFQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2D2919057A0;
        Tue, 11 Aug 2020 07:23:06 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-13-161.pek2.redhat.com [10.72.13.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4856D7C0F5;
        Tue, 11 Aug 2020 07:23:05 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org, jlayton@kernel.org
Cc:     "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH] ceph: encode inodes' parent/d_name in cap reconnect message
Date:   Tue, 11 Aug 2020 15:23:03 +0800
Message-Id: <20200811072303.24322-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Since nautilus, MDS tracks dirfrags whose child inodes have caps in open
file table. When MDS recovers, it prefetches all of these dirfrags. This
avoids using backtrace to load inodes. But dirfrags prefetch may load
lots of useless inodes into cache, and make MDS run out of memory.

Recent MDS adds an option that disables dirfrags prefetch. When dirfrags
prefetch is disabled. Recovering MDS only prefetches corresponding dir
inodes. Including inodes' parent/d_name in cap reconnect message can
help MDS to load inodes into its cache.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/mds_client.c | 89 ++++++++++++++++++++++++++++++--------------
 1 file changed, 61 insertions(+), 28 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 9a09d12569bd..4eaed12b4b4c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3553,6 +3553,39 @@ static int send_reconnect_partial(struct ceph_reconnect_state *recon_state)
 	return err;
 }
 
+static struct dentry* d_find_primary(struct inode *inode)
+{
+	struct dentry *alias, *dn = NULL;
+
+	if (hlist_empty(&inode->i_dentry))
+		return NULL;
+
+	spin_lock(&inode->i_lock);
+	if (hlist_empty(&inode->i_dentry))
+		goto out_unlock;
+
+	if (S_ISDIR(inode->i_mode)) {
+		alias = hlist_entry(inode->i_dentry.first, struct dentry, d_u.d_alias);
+		if (!IS_ROOT(alias))
+			dn = dget(alias);
+		goto out_unlock;
+	}
+
+	hlist_for_each_entry(alias, &inode->i_dentry, d_u.d_alias) {
+		spin_lock(&alias->d_lock);
+		if (!d_unhashed(alias) &&
+		    (ceph_dentry(alias)->flags & CEPH_DENTRY_PRIMARY_LINK)) {
+			dn = dget_dlock(alias);
+		}
+		spin_unlock(&alias->d_lock);
+		if (dn)
+			break;
+	}
+out_unlock:
+	spin_unlock(&inode->i_lock);
+	return dn;
+}
+
 /*
  * Encode information about a cap for a reconnect with the MDS.
  */
@@ -3566,13 +3599,32 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	struct ceph_inode_info *ci = cap->ci;
 	struct ceph_reconnect_state *recon_state = arg;
 	struct ceph_pagelist *pagelist = recon_state->pagelist;
-	int err;
+	struct dentry *dentry;
+	char *path;
+	int pathlen, err;
+	u64 pathbase;
 	u64 snap_follows;
 
 	dout(" adding %p ino %llx.%llx cap %p %lld %s\n",
 	     inode, ceph_vinop(inode), cap, cap->cap_id,
 	     ceph_cap_string(cap->issued));
 
+	dentry = d_find_primary(inode);
+	if (dentry) {
+		/* set pathbase to parent dir when msg_version >= 2 */
+		path = ceph_mdsc_build_path(dentry, &pathlen, &pathbase,
+					    recon_state->msg_version >= 2);
+		dput(dentry);
+		if (IS_ERR(path)) {
+			err = PTR_ERR(path);
+			goto out_err;
+		}
+	} else {
+		path = NULL;
+		pathlen = 0;
+		pathbase = 0;
+	}
+
 	spin_lock(&ci->i_ceph_lock);
 	cap->seq = 0;        /* reset cap seq */
 	cap->issue_seq = 0;  /* and issue_seq */
@@ -3593,7 +3645,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		rec.v2.wanted = cpu_to_le32(__ceph_caps_wanted(ci));
 		rec.v2.issued = cpu_to_le32(cap->issued);
 		rec.v2.snaprealm = cpu_to_le64(ci->i_snap_realm->ino);
-		rec.v2.pathbase = 0;
+		rec.v2.pathbase = cpu_to_le64(pathbase);
 		rec.v2.flock_len = (__force __le32)
 			((ci->i_ceph_flags & CEPH_I_ERROR_FILELOCK) ? 0 : 1);
 	} else {
@@ -3604,7 +3656,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		ceph_encode_timespec64(&rec.v1.mtime, &inode->i_mtime);
 		ceph_encode_timespec64(&rec.v1.atime, &inode->i_atime);
 		rec.v1.snaprealm = cpu_to_le64(ci->i_snap_realm->ino);
-		rec.v1.pathbase = 0;
+		rec.v1.pathbase = cpu_to_le64(pathbase);
 	}
 
 	if (list_empty(&ci->i_cap_snaps)) {
@@ -3666,7 +3718,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 			    sizeof(struct ceph_filelock);
 		rec.v2.flock_len = cpu_to_le32(struct_len);
 
-		struct_len += sizeof(u32) + sizeof(rec.v2);
+		struct_len += sizeof(u32) + pathlen + sizeof(rec.v2);
 
 		if (struct_v >= 2)
 			struct_len += sizeof(u64); /* snap_follows */
@@ -3690,7 +3742,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 			ceph_pagelist_encode_8(pagelist, 1);
 			ceph_pagelist_encode_32(pagelist, struct_len);
 		}
-		ceph_pagelist_encode_string(pagelist, NULL, 0);
+		ceph_pagelist_encode_string(pagelist, path, pathlen);
 		ceph_pagelist_append(pagelist, &rec, sizeof(rec.v2));
 		ceph_locks_to_pagelist(flocks, pagelist,
 				       num_fcntl_locks, num_flock_locks);
@@ -3699,39 +3751,20 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 out_freeflocks:
 		kfree(flocks);
 	} else {
-		u64 pathbase = 0;
-		int pathlen = 0;
-		char *path = NULL;
-		struct dentry *dentry;
-
-		dentry = d_find_alias(inode);
-		if (dentry) {
-			path = ceph_mdsc_build_path(dentry,
-						&pathlen, &pathbase, 0);
-			dput(dentry);
-			if (IS_ERR(path)) {
-				err = PTR_ERR(path);
-				goto out_err;
-			}
-			rec.v1.pathbase = cpu_to_le64(pathbase);
-		}
-
 		err = ceph_pagelist_reserve(pagelist,
 					    sizeof(u64) + sizeof(u32) +
 					    pathlen + sizeof(rec.v1));
-		if (err) {
-			goto out_freepath;
-		}
+		if (err)
+			goto out_err;
 
 		ceph_pagelist_encode_64(pagelist, ceph_ino(inode));
 		ceph_pagelist_encode_string(pagelist, path, pathlen);
 		ceph_pagelist_append(pagelist, &rec, sizeof(rec.v1));
-out_freepath:
-		ceph_mdsc_free_path(path, pathlen);
 	}
 
 out_err:
-	if (err >= 0)
+	ceph_mdsc_free_path(path, pathlen);
+	if (!err)
 		recon_state->nr_caps++;
 	return err;
 }
-- 
2.26.2


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5544C277C5
	for <lists+ceph-devel@lfdr.de>; Thu, 23 May 2019 10:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729949AbfEWIOI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 May 2019 04:14:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48170 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727708AbfEWIOI (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 23 May 2019 04:14:08 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0A1A33079B76
        for <ceph-devel@vger.kernel.org>; Thu, 23 May 2019 08:14:08 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-163.pek2.redhat.com [10.72.12.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3FB060C44;
        Thu, 23 May 2019 08:14:05 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 7/8] ceph: ensure d_name/d_parent stability in ceph_mdsc_lease_send_msg()
Date:   Thu, 23 May 2019 16:13:44 +0800
Message-Id: <20190523081345.20410-7-zyan@redhat.com>
In-Reply-To: <20190523081345.20410-1-zyan@redhat.com>
References: <20190523081345.20410-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 23 May 2019 08:14:08 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/dir.c        |  7 +++----
 fs/ceph/mds_client.c | 24 +++++++++++++-----------
 fs/ceph/mds_client.h |  1 -
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 1271024a3797..72efad28857c 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1433,8 +1433,7 @@ static bool __dentry_lease_is_valid(struct ceph_dentry_info *di)
 	return false;
 }
 
-static int dentry_lease_is_valid(struct dentry *dentry, unsigned int flags,
-				 struct inode *dir)
+static int dentry_lease_is_valid(struct dentry *dentry, unsigned int flags)
 {
 	struct ceph_dentry_info *di;
 	struct ceph_mds_session *session = NULL;
@@ -1466,7 +1465,7 @@ static int dentry_lease_is_valid(struct dentry *dentry, unsigned int flags,
 	spin_unlock(&dentry->d_lock);
 
 	if (session) {
-		ceph_mdsc_lease_send_msg(session, dir, dentry,
+		ceph_mdsc_lease_send_msg(session, dentry,
 					 CEPH_MDS_LEASE_RENEW, seq);
 		ceph_put_mds_session(session);
 	}
@@ -1566,7 +1565,7 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
 		   ceph_snap(d_inode(dentry)) == CEPH_SNAPDIR) {
 		valid = 1;
 	} else {
-		valid = dentry_lease_is_valid(dentry, flags, dir);
+		valid = dentry_lease_is_valid(dentry, flags);
 		if (valid == -ECHILD)
 			return valid;
 		if (valid || dir_lease_is_valid(dir, dentry)) {
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 870754e9d572..98c500dbec3f 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3941,31 +3941,33 @@ static void handle_lease(struct ceph_mds_client *mdsc,
 }
 
 void ceph_mdsc_lease_send_msg(struct ceph_mds_session *session,
-			      struct inode *inode,
 			      struct dentry *dentry, char action,
 			      u32 seq)
 {
 	struct ceph_msg *msg;
 	struct ceph_mds_lease *lease;
-	int len = sizeof(*lease) + sizeof(u32);
-	int dnamelen = 0;
+	struct inode *dir;
+	int len = sizeof(*lease) + sizeof(u32) + NAME_MAX;
 
-	dout("lease_send_msg inode %p dentry %p %s to mds%d\n",
-	     inode, dentry, ceph_lease_op_name(action), session->s_mds);
-	dnamelen = dentry->d_name.len;
-	len += dnamelen;
+	dout("lease_send_msg identry %p %s to mds%d\n",
+	     dentry, ceph_lease_op_name(action), session->s_mds);
 
 	msg = ceph_msg_new(CEPH_MSG_CLIENT_LEASE, len, GFP_NOFS, false);
 	if (!msg)
 		return;
 	lease = msg->front.iov_base;
 	lease->action = action;
-	lease->ino = cpu_to_le64(ceph_vino(inode).ino);
-	lease->first = lease->last = cpu_to_le64(ceph_vino(inode).snap);
 	lease->seq = cpu_to_le32(seq);
-	put_unaligned_le32(dnamelen, lease + 1);
-	memcpy((void *)(lease + 1) + 4, dentry->d_name.name, dnamelen);
 
+	spin_lock(&dentry->d_lock);
+	dir = d_inode(dentry->d_parent);
+	lease->ino = cpu_to_le64(ceph_inode(dir)->i_vino.ino);
+	lease->first = lease->last = cpu_to_le64(ceph_inode(dir)->i_vino.snap);
+
+	put_unaligned_le32(dentry->d_name.len, lease + 1);
+	memcpy((void *)(lease + 1) + 4,
+	       dentry->d_name.name, dentry->d_name.len);
+	spin_unlock(&dentry->d_lock);
 	/*
 	 * if this is a preemptive lease RELEASE, no need to
 	 * flush request stream, since the actual request will
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 9c28b86abcf4..330769ecb601 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -505,7 +505,6 @@ extern char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *base,
 
 extern void __ceph_mdsc_drop_dentry_lease(struct dentry *dentry);
 extern void ceph_mdsc_lease_send_msg(struct ceph_mds_session *session,
-				     struct inode *inode,
 				     struct dentry *dentry, char action,
 				     u32 seq);
 
-- 
2.17.2


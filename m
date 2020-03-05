Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77A2717A526
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Mar 2020 13:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgCEMVQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Mar 2020 07:21:16 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56731 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725989AbgCEMVP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Mar 2020 07:21:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583410874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hf1vRJvCgYfsq1g5/dPAEzorWPRby8P9fBBpvMPs+rc=;
        b=D1VgZsL86/DarZM/aCIJsz71nGolumC17YRpzWhAH73Aw8o7Wu3tZZQRbMw3WvDElADZXM
        2X+G7MEUMj0ROVfRCgCXmZY+15hoKptVGeReIPuLIp1gz7oTK7QM2b4TRDDlHwGfwo994J
        0MZTxp9+SthLjoRoxEAIeCjBw7DSRzc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-Q5ONgjtwPTuQadeXRGw4gA-1; Thu, 05 Mar 2020 07:21:12 -0500
X-MC-Unique: Q5ONgjtwPTuQadeXRGw4gA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C86A4800D6C;
        Thu,  5 Mar 2020 12:21:11 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-47.pek2.redhat.com [10.72.12.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 350331CB;
        Thu,  5 Mar 2020 12:21:09 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH v5 1/7] ceph: always renew caps if mds_wanted is insufficient
Date:   Thu,  5 Mar 2020 20:20:59 +0800
Message-Id: <20200305122105.69184-2-zyan@redhat.com>
In-Reply-To: <20200305122105.69184-1-zyan@redhat.com>
References: <20200305122105.69184-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Original code only renews caps for inodes with CEPH_I_CAP_DROPPED flag,
which indicates that mds has closed the session and caps were dropped.
Remove this flag in preparation for not requesting caps for idle open
files.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c       | 36 +++++++++++++++---------------------
 fs/ceph/mds_client.c |  5 -----
 fs/ceph/super.h      | 13 ++++++-------
 3 files changed, 21 insertions(+), 33 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index be85225b962c..a75e5eb3740e 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2686,6 +2686,7 @@ static int try_get_cap_refs(struct inode *inode, in=
t need, int want,
 		}
 	} else {
 		int session_readonly =3D false;
+		int mds_wanted;
 		if (ci->i_auth_cap &&
 		    (need & (CEPH_CAP_FILE_WR | CEPH_CAP_FILE_EXCL))) {
 			struct ceph_mds_session *s =3D ci->i_auth_cap->session;
@@ -2694,32 +2695,27 @@ static int try_get_cap_refs(struct inode *inode, =
int need, int want,
 			spin_unlock(&s->s_cap_lock);
 		}
 		if (session_readonly) {
-			dout("get_cap_refs %p needed %s but mds%d readonly\n",
+			dout("get_cap_refs %p need %s but mds%d readonly\n",
 			     inode, ceph_cap_string(need), ci->i_auth_cap->mds);
 			ret =3D -EROFS;
 			goto out_unlock;
 		}
=20
-		if (ci->i_ceph_flags & CEPH_I_CAP_DROPPED) {
-			int mds_wanted;
-			if (READ_ONCE(mdsc->fsc->mount_state) =3D=3D
-			    CEPH_MOUNT_SHUTDOWN) {
-				dout("get_cap_refs %p forced umount\n", inode);
-				ret =3D -EIO;
-				goto out_unlock;
-			}
-			mds_wanted =3D __ceph_caps_mds_wanted(ci, false);
-			if (need & ~(mds_wanted & need)) {
-				dout("get_cap_refs %p caps were dropped"
-				     " (session killed?)\n", inode);
-				ret =3D -ESTALE;
-				goto out_unlock;
-			}
-			if (!(file_wanted & ~mds_wanted))
-				ci->i_ceph_flags &=3D ~CEPH_I_CAP_DROPPED;
+		if (READ_ONCE(mdsc->fsc->mount_state) =3D=3D CEPH_MOUNT_SHUTDOWN) {
+			dout("get_cap_refs %p forced umount\n", inode);
+			ret =3D -EIO;
+			goto out_unlock;
+		}
+		mds_wanted =3D __ceph_caps_mds_wanted(ci, false);
+		if (need & ~mds_wanted) {
+			dout("get_cap_refs %p need %s > mds_wanted %s\n",
+			     inode, ceph_cap_string(need),
+			     ceph_cap_string(mds_wanted));
+			ret =3D -ESTALE;
+			goto out_unlock;
 		}
=20
-		dout("get_cap_refs %p have %s needed %s\n", inode,
+		dout("get_cap_refs %p have %s need %s\n", inode,
 		     ceph_cap_string(have), ceph_cap_string(need));
 	}
 out_unlock:
@@ -3678,8 +3674,6 @@ static void handle_cap_export(struct inode *inode, =
struct ceph_mds_caps *ex,
 		goto out_unlock;
=20
 	if (target < 0) {
-		if (cap->mds_wanted | cap->issued)
-			ci->i_ceph_flags |=3D CEPH_I_CAP_DROPPED;
 		__ceph_remove_cap(cap, false);
 		goto out_unlock;
 	}
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 177acb9f456b..68b8afded466 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1514,8 +1514,6 @@ static int remove_session_caps_cb(struct inode *ino=
de, struct ceph_cap *cap,
 	dout("removing cap %p, ci is %p, inode is %p\n",
 	     cap, ci, &ci->vfs_inode);
 	spin_lock(&ci->i_ceph_lock);
-	if (cap->mds_wanted | cap->issued)
-		ci->i_ceph_flags |=3D CEPH_I_CAP_DROPPED;
 	__ceph_remove_cap(cap, false);
 	if (!ci->i_auth_cap) {
 		struct ceph_cap_flush *cf;
@@ -1681,9 +1679,6 @@ static int wake_up_session_cb(struct inode *inode, =
struct ceph_cap *cap,
 			/* mds did not re-issue stale cap */
 			spin_lock(&ci->i_ceph_lock);
 			cap->issued =3D cap->implemented =3D CEPH_CAP_PIN;
-			/* make sure mds knows what we want */
-			if (__ceph_caps_file_wanted(ci) & ~cap->mds_wanted)
-				ci->i_ceph_flags |=3D CEPH_I_CAP_DROPPED;
 			spin_unlock(&ci->i_ceph_lock);
 		}
 	} else if (ev =3D=3D FORCE_RO) {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 22b89eaeaad4..356ad7b46b85 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -522,13 +522,12 @@ static inline struct inode *ceph_find_inode(struct =
super_block *sb,
 #define CEPH_I_POOL_RD		(1 << 4)  /* can read from pool */
 #define CEPH_I_POOL_WR		(1 << 5)  /* can write to pool */
 #define CEPH_I_SEC_INITED	(1 << 6)  /* security initialized */
-#define CEPH_I_CAP_DROPPED	(1 << 7)  /* caps were forcibly dropped */
-#define CEPH_I_KICK_FLUSH	(1 << 8)  /* kick flushing caps */
-#define CEPH_I_FLUSH_SNAPS	(1 << 9)  /* need flush snapss */
-#define CEPH_I_ERROR_WRITE	(1 << 10) /* have seen write errors */
-#define CEPH_I_ERROR_FILELOCK	(1 << 11) /* have seen file lock errors */
-#define CEPH_I_ODIRECT		(1 << 12) /* inode in direct I/O mode */
-#define CEPH_ASYNC_CREATE_BIT	(13)	  /* async create in flight for this =
*/
+#define CEPH_I_KICK_FLUSH	(1 << 7)  /* kick flushing caps */
+#define CEPH_I_FLUSH_SNAPS	(1 << 8)  /* need flush snapss */
+#define CEPH_I_ERROR_WRITE	(1 << 9) /* have seen write errors */
+#define CEPH_I_ERROR_FILELOCK	(1 << 10) /* have seen file lock errors */
+#define CEPH_I_ODIRECT		(1 << 11) /* inode in direct I/O mode */
+#define CEPH_ASYNC_CREATE_BIT	(12)	  /* async create in flight for this =
*/
 #define CEPH_I_ASYNC_CREATE	(1 << CEPH_ASYNC_CREATE_BIT)
=20
 /*
--=20
2.21.1


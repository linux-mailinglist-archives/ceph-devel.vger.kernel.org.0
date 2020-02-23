Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1041816977D
	for <lists+ceph-devel@lfdr.de>; Sun, 23 Feb 2020 13:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgBWMS1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 23 Feb 2020 07:18:27 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22179 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726023AbgBWMS1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 07:18:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582460306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZfAG+uJGkwV0Blha/dkC8GuMyD25cKvXigIn5ZfNFR0=;
        b=Hss0w3RAqJPRgG4/3vQXqbjEgyfoOyVfzXnVw9RIeMSLPKyRpp/NQ0kHe4jG/ltZ9q0Yp5
        eZ4GM+bUoT56s8jzfxNR/JHI9R+1+OHg0T0jc73kmuOnxwPBErs02yc+kJzjl4sMEN3ypO
        dy7JMHa+/uLeXFGjyQIR5/IIiXGCu+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-O3MSaTvtNQ2tcBd-PPXc1w-1; Sun, 23 Feb 2020 07:18:20 -0500
X-MC-Unique: O3MSaTvtNQ2tcBd-PPXc1w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08E588017DF;
        Sun, 23 Feb 2020 12:18:19 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-139.pek2.redhat.com [10.72.12.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C86DA5D9CA;
        Sun, 23 Feb 2020 12:18:13 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: show more detail logs during mount
Date:   Sun, 23 Feb 2020 07:18:08 -0500
Message-Id: <20200223121808.5584-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Return -ETIMEDOUT when the requests are timed out instead of -EIO
to make it cleaner for the userland. And just print the logs in
error level to give a helpful hint.

URL: https://tracker.ceph.com/issues/44215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c   |  4 ++--
 fs/ceph/super.c        | 28 ++++++++++++++++++++--------
 net/ceph/ceph_common.c |  7 +++++--
 net/ceph/mon_client.c  |  1 +
 4 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 82f63ef2694c..0dfea8cdb50a 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2578,7 +2578,7 @@ static void __do_request(struct ceph_mds_client *md=
sc,
 	if (req->r_timeout &&
 	    time_after_eq(jiffies, req->r_started + req->r_timeout)) {
 		dout("do_request timed out\n");
-		err =3D -EIO;
+		err =3D -ETIMEDOUT;
 		goto finish;
 	}
 	if (READ_ONCE(mdsc->fsc->mount_state) =3D=3D CEPH_MOUNT_SHUTDOWN) {
@@ -2752,7 +2752,7 @@ static int ceph_mdsc_wait_request(struct ceph_mds_c=
lient *mdsc,
 		if (timeleft > 0)
 			err =3D 0;
 		else if (!timeleft)
-			err =3D -EIO;  /* timed out */
+			err =3D -ETIMEDOUT;  /* timed out */
 		else
 			err =3D timeleft;  /* killed */
 	}
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 31acb4fe1f2c..6778f2a7d6d4 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -849,11 +849,13 @@ static struct dentry *open_root_dentry(struct ceph_=
fs_client *fsc,
 {
 	struct ceph_mds_client *mdsc =3D fsc->mdsc;
 	struct ceph_mds_request *req =3D NULL;
+	struct ceph_mds_session *session;
 	int err;
 	struct dentry *root;
+	char buf[32] =3D {0};
=20
 	/* open dir */
-	dout("open_root_inode opening '%s'\n", path);
+	dout("mount open_root_inode opening '%s'\n", path);
 	req =3D ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE_ANY_MDS=
);
 	if (IS_ERR(req))
 		return ERR_CAST(req);
@@ -873,18 +875,26 @@ static struct dentry *open_root_dentry(struct ceph_=
fs_client *fsc,
 	if (err =3D=3D 0) {
 		struct inode *inode =3D req->r_target_inode;
 		req->r_target_inode =3D NULL;
-		dout("open_root_inode success\n");
 		root =3D d_make_root(inode);
 		if (!root) {
 			root =3D ERR_PTR(-ENOMEM);
 			goto out;
 		}
-		dout("open_root_inode success, root dentry is %p\n", root);
+		dout(" root dentry is %p\n", root);
 	} else {
 		root =3D ERR_PTR(err);
 	}
 out:
+	session =3D ceph_get_mds_session(req->r_session);
+	if (session)
+		snprintf(buf, 32, " on mds%d", session->s_mds);
+
 	ceph_mdsc_put_request(req);
+	if (!IS_ERR(root))
+		dout("mount open_root_inode success%s\n", buf[0] ? buf : "");
+	else
+		pr_err("mount open_root_inode fail %ld%s\n", PTR_ERR(root),
+		       buf[0] ? buf : "");
 	return root;
 }
=20
@@ -937,6 +947,7 @@ static struct dentry *ceph_real_mount(struct ceph_fs_=
client *fsc,
=20
 out:
 	mutex_unlock(&fsc->client->mount_mutex);
+	pr_err("mount fail\n");
 	return ERR_PTR(err);
 }
=20
@@ -1028,7 +1039,7 @@ static int ceph_get_tree(struct fs_context *fc)
 		ceph_compare_super;
 	int err;
=20
-	dout("ceph_get_tree\n");
+	dout("ceph_get_tree start\n");
=20
 	if (!fc->source)
 		return invalfc(fc, "No source");
@@ -1073,14 +1084,15 @@ static int ceph_get_tree(struct fs_context *fc)
 		err =3D PTR_ERR(res);
 		goto out_splat;
 	}
-	dout("root %p inode %p ino %llx.%llx\n", res,
-	     d_inode(res), ceph_vinop(d_inode(res)));
+        dout(" root %p inode %p ino %llx.%llx\n",
+	     res, d_inode(res), ceph_vinop(d_inode(res)));
 	fc->root =3D fsc->sb->s_root;
+	dout("ceph_get_tree success\n");
 	return 0;
=20
 out_splat:
 	if (!ceph_mdsmap_is_cluster_available(fsc->mdsc->mdsmap)) {
-		pr_info("No mds server is up or the cluster is laggy\n");
+		pr_err("No mds server is up or the cluster is laggy\n");
 		err =3D -EHOSTUNREACH;
 	}
=20
@@ -1091,7 +1103,7 @@ static int ceph_get_tree(struct fs_context *fc)
 out:
 	destroy_fs_client(fsc);
 out_final:
-	dout("ceph_get_tree fail %d\n", err);
+	pr_err("ceph_get_tree fail %d\n", err);
 	return err;
 }
=20
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index a0e97f6c1072..5971a815fb8e 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -700,11 +700,14 @@ int __ceph_open_session(struct ceph_client *client,=
 unsigned long started)
 		return err;
=20
 	while (!have_mon_and_osd_map(client)) {
-		if (timeout && time_after_eq(jiffies, started + timeout))
+		if (timeout && time_after_eq(jiffies, started + timeout)) {
+			pr_err("mount wating for mon/osd maps timed out on mon%d\n",
+			       client->monc.cur_mon);
 			return -ETIMEDOUT;
+		}
=20
 		/* wait */
-		dout("mount waiting for mon_map\n");
+		dout("mount waiting for mon/osd maps\n");
 		err =3D wait_event_interruptible_timeout(client->auth_wq,
 			have_mon_and_osd_map(client) || (client->auth_err < 0),
 			ceph_timeout_jiffies(timeout));
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 9d9e4e4ea600..8f09df9c3aee 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1179,6 +1179,7 @@ static void handle_auth_reply(struct ceph_mon_clien=
t *monc,
=20
 	if (ret < 0) {
 		monc->client->auth_err =3D ret;
+		pr_err("mon%d session auth failed %d\n", monc->cur_mon, ret);
 	} else if (!was_auth && ceph_auth_is_authenticated(monc->auth)) {
 		dout("authenticated, starting session\n");
=20
--=20
2.21.0


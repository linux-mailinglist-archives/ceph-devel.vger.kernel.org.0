Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2D216B811
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Feb 2020 04:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgBYDac (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Feb 2020 22:30:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20735 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726962AbgBYDac (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Feb 2020 22:30:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582601431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dF1ChXd5U63/468pJyUFB+yTZZS+ZwjugNjr/qlstnM=;
        b=cpZn+miVPzBG8XYgBUVSGrvcgAJf8qgO8kMvTBguz5RmzweMNWhtlXFB4rY48L4o14O3Je
        rNHJxq5od8v/4Ul5I9E2IFDhPt9EXZ0ZGeOeQGUGooLVOo5DQV1EdhJqtkhY6jczxiywJl
        Jqfr5qbpdzrwtmQemYrUWZD3df41pO8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-oyHnEUmDNDKK8vehukl6ew-1; Mon, 24 Feb 2020 22:30:25 -0500
X-MC-Unique: oyHnEUmDNDKK8vehukl6ew-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77E8AA27C5;
        Tue, 25 Feb 2020 03:30:24 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-161.pek2.redhat.com [10.72.12.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0ABA60BF7;
        Tue, 25 Feb 2020 03:30:18 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: show more detail logs during mount
Date:   Mon, 24 Feb 2020 22:30:13 -0500
Message-Id: <20200225033013.4832-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Print the logs in error level to give a helpful hint to make it
more user-friendly to debug.

URL: https://tracker.ceph.com/issues/44215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/super.c       | 8 ++++++--
 net/ceph/mon_client.c | 2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index c7f150686a53..e33c2f86647b 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -905,8 +905,10 @@ static struct dentry *ceph_real_mount(struct ceph_fs=
_client *fsc,
 				     fsc->mount_options->server_path + 1 : "";
=20
 		err =3D __ceph_open_session(fsc->client, started);
-		if (err < 0)
+		if (err < 0) {
+			pr_err("mount joining the ceph cluster fail %d\n", err);
 			goto out;
+		}
=20
 		/* setup fscache */
 		if (fsc->mount_options->flags & CEPH_MOUNT_OPT_FSCACHE) {
@@ -922,6 +924,8 @@ static struct dentry *ceph_real_mount(struct ceph_fs_=
client *fsc,
 		root =3D open_root_dentry(fsc, path, started);
 		if (IS_ERR(root)) {
 			err =3D PTR_ERR(root);
+			pr_err("mount opening the root directory fail %d\n",
+			       err);
 			goto out;
 		}
 		fsc->sb->s_root =3D dget(root);
@@ -1079,7 +1083,7 @@ static int ceph_get_tree(struct fs_context *fc)
=20
 out_splat:
 	if (!ceph_mdsmap_is_cluster_available(fsc->mdsc->mdsmap)) {
-		pr_info("No mds server is up or the cluster is laggy\n");
+		pr_err("No mds server is up or the cluster is laggy\n");
 		err =3D -EHOSTUNREACH;
 	}
=20
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 9d9e4e4ea600..6f1372f5f2a7 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1179,6 +1179,8 @@ static void handle_auth_reply(struct ceph_mon_clien=
t *monc,
=20
 	if (ret < 0) {
 		monc->client->auth_err =3D ret;
+		pr_err("authenticate fail on mon%d %s\n", monc->cur_mon,
+			ceph_pr_addr(&monc->con.peer_addr));
 	} else if (!was_auth && ceph_auth_is_authenticated(monc->auth)) {
 		dout("authenticated, starting session\n");
=20
--=20
2.21.0


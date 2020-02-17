Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE327161118
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Feb 2020 12:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgBQL20 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Feb 2020 06:28:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26958 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726558AbgBQL20 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Feb 2020 06:28:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581938904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vRw6vpKXpIKpjElkbaSefS/lz15Tq8jRDhEVlI5oZEo=;
        b=RpSEWkDkYfUfeCiHZfXU4lYyHJqKlpsDL4BrqTE4QVRCIJV/owN9KQZZzdP4jL93su4OJo
        NDuiTuAPbT3vlyZ0++OF4d66RsWBsh1ou86A7NZlQ4wX8vn8ouViBw2Gi7i0cBFaQK8F5S
        QfDr5YapimHva0X5mHJKnlXyqOniDfU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-QeBvhM_LMS6euyZuRQ3_fA-1; Mon, 17 Feb 2020 06:28:22 -0500
X-MC-Unique: QeBvhM_LMS6euyZuRQ3_fA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABDB0801E76;
        Mon, 17 Feb 2020 11:28:21 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-166.pek2.redhat.com [10.72.12.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A157B1001B3F;
        Mon, 17 Feb 2020 11:28:16 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix dout logs for null pointers
Date:   Mon, 17 Feb 2020 06:28:06 -0500
Message-Id: <20200217112806.30738-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

For example, if dentry and inode is NULL, the log will be:
ceph:  lookup result=3D000000007a1ca695
ceph:  submit_request on 0000000041d5070e for inode 000000007a1ca695

The will be confusing without checking the corresponding code carefully.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/dir.c        | 2 +-
 fs/ceph/mds_client.c | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index ffeaff5bf211..245a262ec198 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -798,7 +798,7 @@ static struct dentry *ceph_lookup(struct inode *dir, =
struct dentry *dentry,
 	err =3D ceph_handle_snapdir(req, dentry, err);
 	dentry =3D ceph_finish_lookup(req, dentry, err);
 	ceph_mdsc_put_request(req);  /* will dput(dentry) */
-	dout("lookup result=3D%p\n", dentry);
+	dout("lookup result=3D%d\n", err);
 	return dentry;
 }
=20
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index b6aa357f7c61..e34f159d262b 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2772,7 +2772,11 @@ int ceph_mdsc_submit_request(struct ceph_mds_clien=
t *mdsc, struct inode *dir,
 		ceph_get_cap_refs(ceph_inode(req->r_old_dentry_dir),
 				  CEPH_CAP_PIN);
=20
-	dout("submit_request on %p for inode %p\n", req, dir);
+	if (dir)
+		dout("submit_request on %p for inode %p\n", req, dir);
+	else
+		dout("submit_request on %p\n", req);
+
 	mutex_lock(&mdsc->mutex);
 	__register_request(mdsc, req, dir);
 	__do_request(mdsc, req);
--=20
2.21.0


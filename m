Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E23715D3D6
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Feb 2020 09:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbgBNIcl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Feb 2020 03:32:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34899 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728779AbgBNIck (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 Feb 2020 03:32:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581669160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1OxTtMu0cxg+c19swd1BYtnnWitDZnJpLOA5rAs7AE8=;
        b=fCMVLF1WUx9eP9l2g5DGscZyjJ/fdHjFsvSu4ua90mpnZTbzXfoNxOQDhWp0CR2eZX7kRt
        AJcDEhtgn9G3hji1EBGivGyompWVCsc264BWz4DY3l/cOpJTasp1Y3/pjqsCF99DRIKxvX
        ghjbFQ2b16hcWwaDEePSnKiemy4TQSI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-GIkYSM5EO0WjSiK31EPrBQ-1; Fri, 14 Feb 2020 03:32:37 -0500
X-MC-Unique: GIkYSM5EO0WjSiK31EPrBQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90224107ACCD;
        Fri, 14 Feb 2020 08:32:36 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-209.pek2.redhat.com [10.72.12.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6AFF35C1C3;
        Fri, 14 Feb 2020 08:32:31 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: switch to ceph_test_mount_opt helper
Date:   Fri, 14 Feb 2020 03:32:25 -0500
Message-Id: <20200214083225.2804-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Clean up the code.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 3 +--
 fs/ceph/super.c      | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 451c3727cd0b..8a8aaa20699c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2643,8 +2643,7 @@ static void __do_request(struct ceph_mds_client *md=
sc,
 			list_add(&req->r_wait, &mdsc->waiting_for_map);
 			return;
 		}
-		if (!(mdsc->fsc->mount_options->flags &
-		      CEPH_MOUNT_OPT_MOUNTWAIT) &&
+		if (!ceph_test_mount_opt(mdsc->fsc, MOUNTWAIT) &&
 		    !ceph_mdsmap_is_cluster_available(mdsc->mdsmap)) {
 			err =3D -EHOSTUNREACH;
 			goto finish;
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index abdf61909879..c494351e3cc8 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -992,7 +992,7 @@ static struct dentry *ceph_real_mount(struct ceph_fs_=
client *fsc,
 			goto out;
=20
 		/* setup fscache */
-		if (fsc->mount_options->flags & CEPH_MOUNT_OPT_FSCACHE) {
+		if (ceph_test_mount_opt(fsc, FSCACHE)) {
 			err =3D ceph_fscache_register_fs(fsc, fc);
 			if (err < 0)
 				goto out;
--=20
2.21.0


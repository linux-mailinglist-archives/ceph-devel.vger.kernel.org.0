Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3871158A1D
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Feb 2020 07:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgBKGxu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 11 Feb 2020 01:53:50 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27730 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727805AbgBKGxu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 11 Feb 2020 01:53:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581404028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=o5gn4Laao0JfZliH1Vw8een2HbOTQg5GUUgVFqH+GTE=;
        b=Vq55Dhzs/VIbxuqszCeKEEUjgnLoBdsn6nD/C/HNbRtIGHif3wQcdmoKSpJeXUGuxnkhdI
        bGm+f2lGXaYBMab86sY9PI3cQGiedbHlMCe8STVdyi5vZi165h2KLTzFIy4I5Vp6QFGf5+
        Lve233RyR2z785DISu/DrQdfidD5VmQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203--6HAihtGMwiK8BBmzpunqg-1; Tue, 11 Feb 2020 01:53:47 -0500
X-MC-Unique: -6HAihtGMwiK8BBmzpunqg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E12E1005502;
        Tue, 11 Feb 2020 06:53:46 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FAC55D9CA;
        Tue, 11 Feb 2020 06:53:39 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, dhowells@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: fix posix acl couldn't be settable
Date:   Tue, 11 Feb 2020 01:53:16 -0500
Message-Id: <20200211065316.59091-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

For the old mount API, the module parameters parseing function will
be called in ceph_mount() and also just after the default posix acl
flag set, so we can control to enable/disable it via the mount option.

But for the new mount API, it will call the module parameters
parseing function before ceph_get_tree(), so the posix acl will always
be enabled.

Fixes: 82995cc6c5ae ("libceph, rbd, ceph: convert to use the new mount AP=
I")
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

Changed in V2:
- move default fc->sb_flags setting to ceph_init_fs_context().

 fs/ceph/super.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 5fef4f59e13e..c3d9ac768cec 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1089,10 +1089,6 @@ static int ceph_get_tree(struct fs_context *fc)
 	if (!fc->source)
 		return invalf(fc, "ceph: No source");
=20
-#ifdef CONFIG_CEPH_FS_POSIX_ACL
-	fc->sb_flags |=3D SB_POSIXACL;
-#endif
-
 	/* create client (which we may/may not use) */
 	fsc =3D create_fs_client(pctx->opts, pctx->copts);
 	pctx->opts =3D NULL;
@@ -1215,6 +1211,10 @@ static int ceph_init_fs_context(struct fs_context =
*fc)
 	fsopt->max_readdir_bytes =3D CEPH_MAX_READDIR_BYTES_DEFAULT;
 	fsopt->congestion_kb =3D default_congestion_kb();
=20
+#ifdef CONFIG_CEPH_FS_POSIX_ACL
+	fc->sb_flags |=3D SB_POSIXACL;
+#endif
+
 	fc->fs_private =3D pctx;
 	fc->ops =3D &ceph_context_ops;
 	return 0;
--=20
2.21.0


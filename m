Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54881157CEB
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Feb 2020 14:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgBJN7A (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 Feb 2020 08:59:00 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28552 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726846AbgBJN67 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 08:58:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581343138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2Z0czRzjgR650BcH+yzUx/QjY3CDBjrtslyt/S21Atc=;
        b=DOfQo9a5UqIyI7tKfkCXlg2Q0fsx6nVTCXJq40u4ZBZhp32xzWSGs7toaXjbv0keXf2xzl
        qsuoZlVw5SGXl0FZAeK6zQ4bTksTBL5Qx6dIBLTm2fnDZ6zCu7c6YXicG6n8Cu443LBL7C
        mXOumbebu6vxkaJ77N8em8Lvo3Ak9AE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-vWI5ij4hN1GG1b8hnekbLg-1; Mon, 10 Feb 2020 08:58:56 -0500
X-MC-Unique: vWI5ij4hN1GG1b8hnekbLg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06ED319251A1;
        Mon, 10 Feb 2020 13:58:55 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B37E92656A;
        Mon, 10 Feb 2020 13:58:49 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, dhowells@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix posix acl couldn't be settable
Date:   Mon, 10 Feb 2020 08:58:41 -0500
Message-Id: <20200210135841.21177-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
 fs/ceph/super.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 5fef4f59e13e..69fa498391dc 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -341,6 +341,10 @@ static int ceph_parse_mount_param(struct fs_context =
*fc,
 	unsigned int mode;
 	int token, ret;
=20
+#ifdef CONFIG_CEPH_FS_POSIX_ACL
+	fc->sb_flags |=3D SB_POSIXACL;
+#endif
+
 	ret =3D ceph_parse_param(param, pctx->copts, fc);
 	if (ret !=3D -ENOPARAM)
 		return ret;
@@ -1089,10 +1093,6 @@ static int ceph_get_tree(struct fs_context *fc)
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
--=20
2.21.0


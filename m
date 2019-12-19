Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C603E125985
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Dec 2019 03:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfLSCPb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Dec 2019 21:15:31 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27459 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726760AbfLSCPb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 21:15:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576721730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZtBxUiT3pZ91N57+Nx4jO+gVAlFEIOd37pxPqjFqbhc=;
        b=W1Vmvy2Z3XpDtcsPnHc/igbc4S6b44K6oZXVfKhC6pPX+7vvHHtg7f0gI8xhn0CH2cvNMN
        mS2ToQS8aQYhwe7wqheTtgjs+/p6SxWaUafZvVFfkdS96slIlJ/rD8eP+i17r5ySZ7dDZR
        mo2ZdzNH34sTabP0enu0la9x0pUzivc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-U2-DIBY2MBaAgSABAzD5xg-1; Wed, 18 Dec 2019 21:15:28 -0500
X-MC-Unique: U2-DIBY2MBaAgSABAzD5xg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3D3E1005502;
        Thu, 19 Dec 2019 02:15:27 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2B7019C58;
        Thu, 19 Dec 2019 02:15:22 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: cleanup the dir debug log and xattr_version
Date:   Wed, 18 Dec 2019 21:15:18 -0500
Message-Id: <20191219021518.60891-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

In the debug logs about the di->offset or ctx->pos it is in hex
format, but some others are using the dec format. It is a little
hard to read.

For the xattr version, it is u64 type, using a shorter type may
truncate it.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/dir.c   | 4 ++--
 fs/ceph/xattr.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 5c97bdbb0772..8d14a2867e7c 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1192,7 +1192,7 @@ void __ceph_dentry_dir_lease_touch(struct ceph_dent=
ry_info *di)
 	struct dentry *dn =3D di->dentry;
 	struct ceph_mds_client *mdsc;
=20
-	dout("dentry_dir_lease_touch %p %p '%pd' (offset %lld)\n",
+	dout("dentry_dir_lease_touch %p %p '%pd' (offset %llx)\n",
 	     di, dn, dn, di->offset);
=20
 	if (!list_empty(&di->lease_list)) {
@@ -1577,7 +1577,7 @@ static int ceph_d_revalidate(struct dentry *dentry,=
 unsigned int flags)
=20
 	mdsc =3D ceph_sb_to_client(dir->i_sb)->mdsc;
=20
-	dout("d_revalidate %p '%pd' inode %p offset %lld\n", dentry,
+	dout("d_revalidate %p '%pd' inode %p offset %llx\n", dentry,
 	     dentry, inode, ceph_dentry(dentry)->offset);
=20
 	/* always trust cached snapped dentries, snapdir dentry */
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 6e5e145d51d1..c8609dfd6b37 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -655,7 +655,7 @@ static int __build_xattrs(struct inode *inode)
 	u32 len;
 	const char *name, *val;
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
-	int xattr_version;
+	u64 xattr_version;
 	struct ceph_inode_xattr **xattrs =3D NULL;
 	int err =3D 0;
 	int i;
--=20
2.21.0


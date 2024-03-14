Return-Path: <ceph-devel+bounces-974-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAEF587B8A7
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Mar 2024 08:41:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87C36286749
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Mar 2024 07:41:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2557F5C8E4;
	Thu, 14 Mar 2024 07:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PboQHTMn"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1766C5C8E1
	for <ceph-devel@vger.kernel.org>; Thu, 14 Mar 2024 07:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710402106; cv=none; b=dR0yWLiupd3xudkmOMTPLiTTlsPXey7oJnktdJv98t5Zo5kzbIZvP39em5qowK/sknnSfe+OUdhbqK9Gkis1dhXh+GGvfeGf4FbpNybbfgXaXRcbH5Imt1bObHPJWi6kAy2Kg7VlEHtuOKPu3m6HnZCSYdAwDDa3nD5bh8XWl50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710402106; c=relaxed/simple;
	bh=ACAE15DGce74ymN7kX5QViBV047C0DWXuIh/f+2E7PU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pzbh6oMJhIeWCaZXzP/iqssd0RAvHGmWaqqLNoDWChEx1YbSWeBIaUkce626gTmeo70QvIGCEAhSI1eMimafiEUl9ryten0q8AsQoNUqOQzfHOzuFW6+9CJaecuQK569htcLnoIB79eoYh+CER07Fgv+2nTg+tIVimjKJb0f5Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PboQHTMn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710402103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lLcCgoq+mcIMktiDLj535CzSfinLkeeA6WRnJOxV608=;
	b=PboQHTMnFDprhhv24L54SiPp7zTDvOAHnflNfDGXKCUrwdsKlSMFMrrjzip1EdLM2I2dUk
	aAGxD9Gw1uDMZ3LYuHiqWjFLNiLVAmcYtDatsFjwyIfigcc/QHDUNBe1S/ayD8U8cPU7+1
	g2Q9jNruov8LzhHHg34z2ZRX8PDFrKs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-554-rsEzxMXwNbaQ901BwW-EjQ-1; Thu,
 14 Mar 2024 03:41:40 -0400
X-MC-Unique: rsEzxMXwNbaQ901BwW-EjQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CF67383009C;
	Thu, 14 Mar 2024 07:41:40 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.32])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 12EBA492BD0;
	Thu, 14 Mar 2024 07:41:36 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3] ceph: return -ENODATA when xattr doesn't exist for removexattr
Date: Thu, 14 Mar 2024 15:39:15 +0800
Message-ID: <20240314073915.844541-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

From: Xiubo Li <xiubli@redhat.com>

The POSIX says we should return -ENODATA when the corresponding
attribute doesn't exist when removing it. While there is one
exception for the acl ones in the local filesystems, for exmaple
for xfs, which will treat it as success.

While in the MDS side there have two ways to remove the xattr:
sending a CEPH_MDS_OP_SETXATTR request by setting the 'flags' with
CEPH_XATTR_REMOVE and just issued a CEPH_MDS_OP_RMXATTR request
directly.

For the first one it will always return 0 when the corresponding
xattr doesn't exist, while for the later one it will return
-ENODATA instead, this should be fixed in MDS to make them to be
consistent.

And at the same time added a new flags CEPH_XATTR_REMOVE2 and in
MDS side it will return -ENODATA when the xattr doesn't exist.
While the CEPH_XATTR_REMOVE will be kept to be compatible with
old cephs.

Please note this commit also fixed a bug, which is that even when
the ACL xattrs don't exist the ctime/mode still will be updated.

URL: https://tracker.ceph.com/issues/64679
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V3:
- Fixed failure in
https://pulpito.ceph.com/vshankar-2024-03-13_13:59:32-fs-wip-vshankar-testing-20240307.013758-testing-default-smithi/7596711/.

V2:
- Fixed the test faiures in
https://tracker.ceph.com/issues/64679#note-4.
- Added a new CEPH_XATTR_REMOVE2 flags.



 fs/ceph/acl.c                | 5 +++++
 fs/ceph/xattr.c              | 7 +++----
 include/linux/ceph/ceph_fs.h | 1 +
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index 1564eacc253d..c0634347746f 100644
--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -148,6 +148,11 @@ int ceph_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	}
 
 	ret = __ceph_setxattr(inode, name, value, size, 0);
+	/*
+	 * If the attribute didn't exist to start with that's fine.
+	 */
+	if (!acl && ret == -ENODATA)
+		ret = 0;
 	if (ret) {
 		if (new_mode != old_mode) {
 			newattrs.ia_ctime = old_ctime;
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index e066a556eccb..a39189484100 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -613,11 +613,10 @@ static int __set_xattr(struct ceph_inode_info *ci,
 			return err;
 		}
 		if (update_xattr < 0) {
-			if (xattr)
-				__remove_xattr(ci, xattr);
+			err = __remove_xattr(ci, xattr);
 			kfree(name);
 			kfree(*newxattr);
-			return 0;
+			return err;
 		}
 	}
 
@@ -1131,7 +1130,7 @@ static int ceph_sync_setxattr(struct inode *inode, const char *name,
 		if (flags & CEPH_XATTR_REPLACE)
 			op = CEPH_MDS_OP_RMXATTR;
 		else
-			flags |= CEPH_XATTR_REMOVE;
+			flags |= CEPH_XATTR_REMOVE | CEPH_XATTR_REMOVE2;
 	}
 
 	doutc(cl, "name %s value size %zu\n", name, size);
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index ee1d0e5f9789..c1d9c5f6ff1b 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -383,6 +383,7 @@ extern const char *ceph_mds_op_name(int op);
  */
 #define CEPH_XATTR_CREATE  (1 << 0)
 #define CEPH_XATTR_REPLACE (1 << 1)
+#define CEPH_XATTR_REMOVE2 (1 << 30)
 #define CEPH_XATTR_REMOVE  (1 << 31)
 
 /*
-- 
2.39.1



Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C012AD87C
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 15:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730897AbgKJORe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 09:17:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37724 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729898AbgKJORe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 09:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605017853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g0S7dlhTFpiv+f4w34Qu/HSTIHq7vT+/VCQkR7YXGFg=;
        b=U3eZcIi0T4XMksdwazkTjvZMq5UfvqBCIaU6QADvMqFwdOhGNq4DVHmP7EgyZPQv/IvmX7
        +KFp55JXz3cBBn1PH6cp3LxmVnz8l8Bo0l7cKx+O3U7nhLhp6bJfhCr6mncNs1Q4KCUULk
        NOgR6AEETPLN9C/gYKl3wWodwlHhi8A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-Zilzw0rxN4a6AdGekHNQuA-1; Tue, 10 Nov 2020 09:17:29 -0500
X-MC-Unique: Zilzw0rxN4a6AdGekHNQuA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FEDF11BD35B;
        Tue, 10 Nov 2020 14:17:27 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC9996198D;
        Tue, 10 Nov 2020 14:17:23 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 2/2] ceph: add ceph.{clusterid/clientid} vxattrs suppport
Date:   Tue, 10 Nov 2020 22:17:03 +0800
Message-Id: <20201110141703.414211-3-xiubli@redhat.com>
In-Reply-To: <20201110141703.414211-1-xiubli@redhat.com>
References: <20201110141703.414211-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

These two vxattrs will only exist in local client side, with which
we can easily know which mountpoint the file belongs to and also
they can help locate the debugfs path quickly.

URL: https://tracker.ceph.com/issues/48057
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/xattr.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 0fd05d3d4399..4a41db46e191 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -304,6 +304,23 @@ static ssize_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
 				ci->i_snap_btime.tv_nsec);
 }
 
+static ssize_t ceph_vxattrcb_clusterid(struct ceph_inode_info *ci,
+				       char *val, size_t size)
+{
+	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
+
+	return ceph_fmt_xattr(val, size, "%pU", &fsc->client->fsid);
+}
+
+static ssize_t ceph_vxattrcb_clientid(struct ceph_inode_info *ci,
+				      char *val, size_t size)
+{
+	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
+
+	return ceph_fmt_xattr(val, size, "client%lld",
+			      ceph_client_gid(fsc->client));
+}
+
 #define CEPH_XATTR_NAME(_type, _name)	XATTR_CEPH_PREFIX #_type "." #_name
 #define CEPH_XATTR_NAME2(_type, _name, _name2)	\
 	XATTR_CEPH_PREFIX #_type "." #_name "." #_name2
@@ -407,6 +424,24 @@ static struct ceph_vxattr ceph_file_vxattrs[] = {
 	{ .name = NULL, 0 }	/* Required table terminator */
 };
 
+static struct ceph_vxattr ceph_vxattrs[] = {
+	{
+		.name = "ceph.clusterid",
+		.name_size = sizeof("ceph.clusterid"),
+		.getxattr_cb = ceph_vxattrcb_clusterid,
+		.exists_cb = NULL,
+		.flags = VXATTR_FLAG_READONLY,
+	},
+	{
+		.name = "ceph.clientid",
+		.name_size = sizeof("ceph.clientid"),
+		.getxattr_cb = ceph_vxattrcb_clientid,
+		.exists_cb = NULL,
+		.flags = VXATTR_FLAG_READONLY,
+	},
+	{ .name = NULL, 0 }	/* Required table terminator */
+};
+
 static struct ceph_vxattr *ceph_inode_vxattrs(struct inode *inode)
 {
 	if (S_ISDIR(inode->i_mode))
@@ -429,6 +464,13 @@ static struct ceph_vxattr *ceph_match_vxattr(struct inode *inode,
 		}
 	}
 
+	vxattr = ceph_vxattrs;
+	while (vxattr->name) {
+		if (!strcmp(vxattr->name, name))
+			return vxattr;
+		vxattr++;
+	}
+
 	return NULL;
 }
 
-- 
2.27.0


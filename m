Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AEB2AE5D8
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Nov 2020 02:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732432AbgKKB37 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 20:29:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727275AbgKKB37 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 20:29:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605058198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m6L/RvGXgemD6E0+5c1DAaQqtcKS7s16lfu9iIXk0eY=;
        b=doEBYeQT1QvOD4c/KtBkKCZD5eil0XRm7EY53VPzpnLEKg9vuv+6cQxtJzm43ga8/3kZ09
        F23EucGPVncEm4vfpyW9IwoX4IFvNp0xfqZ6pSJcpZZXjxSD29YlYYWAMPBG48yGp5csZ8
        LeOjlTZJmfDiLB6G2l3gLkh/QmGxcBM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-7iMWNiZqP5-srASrzb1VvQ-1; Tue, 10 Nov 2020 20:29:53 -0500
X-MC-Unique: 7iMWNiZqP5-srASrzb1VvQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D7D910074BF;
        Wed, 11 Nov 2020 01:29:52 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A13A7512B;
        Wed, 11 Nov 2020 01:29:50 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 2/2] ceph: add ceph.{cluster_fsid/client_id} vxattrs suppport
Date:   Wed, 11 Nov 2020 09:29:40 +0800
Message-Id: <20201111012940.468289-3-xiubli@redhat.com>
In-Reply-To: <20201111012940.468289-1-xiubli@redhat.com>
References: <20201111012940.468289-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
index 0fd05d3d4399..e89750a1f039 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -304,6 +304,23 @@ static ssize_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
 				ci->i_snap_btime.tv_nsec);
 }
 
+static ssize_t ceph_vxattrcb_cluster_fsid(struct ceph_inode_info *ci,
+					  char *val, size_t size)
+{
+	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
+
+	return ceph_fmt_xattr(val, size, "%pU", &fsc->client->fsid);
+}
+
+static ssize_t ceph_vxattrcb_client_id(struct ceph_inode_info *ci,
+				       char *val, size_t size)
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
 
+static struct ceph_vxattr ceph_common_vxattrs[] = {
+	{
+		.name = "ceph.cluster_fsid",
+		.name_size = sizeof("ceph.cluster_fsid"),
+		.getxattr_cb = ceph_vxattrcb_cluster_fsid,
+		.exists_cb = NULL,
+		.flags = VXATTR_FLAG_READONLY,
+	},
+	{
+		.name = "ceph.client_id",
+		.name_size = sizeof("ceph.client_id"),
+		.getxattr_cb = ceph_vxattrcb_client_id,
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
 
+	vxattr = ceph_common_vxattrs;
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


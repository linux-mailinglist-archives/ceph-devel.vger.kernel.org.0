Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0785E2C0E3C
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Nov 2020 15:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbgKWOw7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Nov 2020 09:52:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:56218 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728649AbgKWOw6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Nov 2020 09:52:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 15D20AE42;
        Mon, 23 Nov 2020 14:52:57 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 0e0ab320;
        Mon, 23 Nov 2020 14:53:13 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.de>
Subject: [RFC PATCH] ceph: add ceph.caps vxattr
Date:   Mon, 23 Nov 2020 14:53:11 +0000
Message-Id: <20201123145311.13588-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add a new vxattr that allows userspace to list the caps for a specific
directory or file.

Signed-off-by: Luis Henriques <lhenriques@suse.de>
---
 fs/ceph/xattr.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 197cb1234341..996512e05513 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -303,6 +303,18 @@ static ssize_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
 				ci->i_snap_btime.tv_nsec);
 }
 
+static ssize_t ceph_vxattrcb_caps(struct ceph_inode_info *ci, char *val,
+					size_t size)
+{
+	int issued;
+
+	spin_lock(&ci->i_ceph_lock);
+	issued = __ceph_caps_issued(ci, NULL);
+	spin_unlock(&ci->i_ceph_lock);
+
+	return ceph_fmt_xattr(val, size, "%s", ceph_cap_string(issued));
+}
+
 #define CEPH_XATTR_NAME(_type, _name)	XATTR_CEPH_PREFIX #_type "." #_name
 #define CEPH_XATTR_NAME2(_type, _name, _name2)	\
 	XATTR_CEPH_PREFIX #_type "." #_name "." #_name2
@@ -378,6 +390,13 @@ static struct ceph_vxattr ceph_dir_vxattrs[] = {
 		.exists_cb = ceph_vxattrcb_snap_btime_exists,
 		.flags = VXATTR_FLAG_READONLY,
 	},
+	{
+		.name = "ceph.caps",
+		.name_size = sizeof("ceph.caps"),
+		.getxattr_cb = ceph_vxattrcb_caps,
+		.exists_cb = NULL,
+		.flags = VXATTR_FLAG_HIDDEN,
+	},
 	{ .name = NULL, 0 }	/* Required table terminator */
 };
 
@@ -403,6 +422,13 @@ static struct ceph_vxattr ceph_file_vxattrs[] = {
 		.exists_cb = ceph_vxattrcb_snap_btime_exists,
 		.flags = VXATTR_FLAG_READONLY,
 	},
+	{
+		.name = "ceph.caps",
+		.name_size = sizeof("ceph.caps"),
+		.getxattr_cb = ceph_vxattrcb_caps,
+		.exists_cb = NULL,
+		.flags = VXATTR_FLAG_HIDDEN,
+	},
 	{ .name = NULL, 0 }	/* Required table terminator */
 };
 

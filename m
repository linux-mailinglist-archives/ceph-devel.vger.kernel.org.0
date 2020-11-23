Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503102C122A
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Nov 2020 18:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390425AbgKWRid (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Nov 2020 12:38:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:36950 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390423AbgKWRid (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Nov 2020 12:38:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E611AAECB;
        Mon, 23 Nov 2020 17:38:31 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 714ec47b;
        Mon, 23 Nov 2020 17:38:47 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.de>
Subject: [PATCH v2] ceph: add ceph.caps vxattr
Date:   Mon, 23 Nov 2020 17:38:46 +0000
Message-Id: <20201123173846.15045-1-lhenriques@suse.de>
In-Reply-To: <a12a732b67245cc02344405f7dd9fef4f3b47fbc.camel@kernel.org>
References: <a12a732b67245cc02344405f7dd9fef4f3b47fbc.camel@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add a new vxattr that allows userspace to list the caps for a specific
directory or file.

Signed-off-by: Luis Henriques <lhenriques@suse.de>
---
Hi!

Here's a version that also shows the caps in hexadecimal format, as
suggested by Jeff.  IMO the parenthesis and the '0x' prefix help the
readability, but they may make it a bit harder for scripts to parsing the
output.  I'm OK dropping those.

Cheers,
-- 
Luis

fs/ceph/xattr.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 197cb1234341..aec9bd5c8e77 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -303,6 +303,19 @@ static ssize_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
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
+	return ceph_fmt_xattr(val, size, "%s (0x%x)",
+			      ceph_cap_string(issued), issued);
+}
+
 #define CEPH_XATTR_NAME(_type, _name)	XATTR_CEPH_PREFIX #_type "." #_name
 #define CEPH_XATTR_NAME2(_type, _name, _name2)	\
 	XATTR_CEPH_PREFIX #_type "." #_name "." #_name2
@@ -378,6 +391,13 @@ static struct ceph_vxattr ceph_dir_vxattrs[] = {
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
 
@@ -403,6 +423,13 @@ static struct ceph_vxattr ceph_file_vxattrs[] = {
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
 

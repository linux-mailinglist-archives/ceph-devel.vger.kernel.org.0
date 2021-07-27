Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2EE3D7468
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Jul 2021 13:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236498AbhG0LfM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Jul 2021 07:35:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231781AbhG0LfL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 07:35:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB62661A03;
        Tue, 27 Jul 2021 11:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627385712;
        bh=HZXHvh4hZpuq2IxEUPmZRLSj6Oq91iYrE6mAowKZEQc=;
        h=From:To:Cc:Subject:Date:From;
        b=anMifJIAfSK7v/PbrjfN6OCGebBxDzG/cBW6eXTIs159DDdaWn0Rtk4p+zDF5TmAb
         j16vNioHOwZvq53LhTn5HeE2vSI07zl5bpGjl4X5cXDbadzDXHZMBHsUqrgCLuP6Ww
         FS4Sx9lCA+DLyLX3m1r9X3tfS2UvwiyvXBZ8Y8Pb4ya7cHx9DP4RY9+G1W4npQdmyl
         weNV07CGA+yBlBIrFg1PQlX87fN6k4ykSRPqdaKFF/cJ+dJj2YpUB0haGfHhtI8FDg
         fYeNZae8FkjgndaRsafKXJ9TQcgI9mJnFZSEdoWA/yMqKpX9hZmQzNq1FOqtgyu02W
         1iaDje7T/Hxbw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH] ceph: add a new vxattr to return auth mds for an inode
Date:   Tue, 27 Jul 2021 07:35:09 -0400
Message-Id: <20210727113509.7714-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add a new vxattr that shows what MDS is authoritative for an inode (if
we happen to have auth caps). If we don't have an auth cap for the inode
then just return -1.

URL: https://tracker.ceph.com/issues/1276
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/xattr.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 1242db8d3444..70664a19b8dc 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -340,6 +340,15 @@ static ssize_t ceph_vxattrcb_caps(struct ceph_inode_info *ci, char *val,
 			      ceph_cap_string(issued), issued);
 }
 
+static ssize_t ceph_vxattrcb_auth_mds(struct ceph_inode_info *ci,
+				       char *val, size_t size)
+{
+	/* return -1 if we don't have auth caps (and thus can't tell) */
+	if (!ci->i_auth_cap)
+		return ceph_fmt_xattr(val, size, "-1");
+	return ceph_fmt_xattr(val, size, "%d", ci->i_auth_cap->session->s_mds);
+}
+
 #define CEPH_XATTR_NAME(_type, _name)	XATTR_CEPH_PREFIX #_type "." #_name
 #define CEPH_XATTR_NAME2(_type, _name, _name2)	\
 	XATTR_CEPH_PREFIX #_type "." #_name "." #_name2
@@ -473,6 +482,13 @@ static struct ceph_vxattr ceph_common_vxattrs[] = {
 		.exists_cb = NULL,
 		.flags = VXATTR_FLAG_READONLY,
 	},
+	{
+		.name = "ceph.auth_mds",
+		.name_size = sizeof("ceph.auth_mds"),
+		.getxattr_cb = ceph_vxattrcb_auth_mds,
+		.exists_cb = NULL,
+		.flags = VXATTR_FLAG_READONLY,
+	},
 	{ .name = NULL, 0 }	/* Required table terminator */
 };
 
-- 
2.31.1


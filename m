Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D522B3D7DE1
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Jul 2021 20:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhG0Sm4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Jul 2021 14:42:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229727AbhG0Smz (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 14:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 126D860F93;
        Tue, 27 Jul 2021 18:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627411375;
        bh=KeANW148t/VgFZbGZ3BVod86At5j/3A2/wbF6XnFzSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OwTo7jvO+FO+GWBAMj37mz1c6btE4nMQ5H8bRr5APo6tWm1oZc7HhAkw8vZvyVVbN
         guJ/BTl9ercWn2PAmtW4bGXL5LVBjzxUAmgcZV1ionKtLx+7+8mbb3kgwrLKoX0zoA
         GSM/dcQdDqVDVHZC5uGWFVnfryMsusI0d7KFQjQHUnIEau8Mq/a3rVVSHCH5ZCu1ob
         PnQr2KsdoubefPRnhl6k3CQ6IC9WUz5UC6pw8qWwnICSH/2HquaoSJwegiQ+TR1S+R
         s6/QoUzDwaag5dqyd4ViMd1W80ORxAJMIRzgnL0Yil7QPvXmCn4JEQinXm7MC9v1Bb
         5B8WundHGVrFA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com, lhenriques@suse.de
Subject: [PATCH v2] ceph: add a new vxattr to return auth mds for an inode
Date:   Tue, 27 Jul 2021 14:42:53 -0400
Message-Id: <20210727184253.171816-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210727113509.7714-1-jlayton@kernel.org>
References: <20210727113509.7714-1-jlayton@kernel.org>
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
 fs/ceph/xattr.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

v2: ensure we hold the i_ceph_lock when working with the i_auth_cap.

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 1242db8d3444..159a1ffa4f4b 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -340,6 +340,18 @@ static ssize_t ceph_vxattrcb_caps(struct ceph_inode_info *ci, char *val,
 			      ceph_cap_string(issued), issued);
 }
 
+static ssize_t ceph_vxattrcb_auth_mds(struct ceph_inode_info *ci,
+				       char *val, size_t size)
+{
+	int ret;
+
+	spin_lock(&ci->i_ceph_lock);
+	ret = ceph_fmt_xattr(val, size, "%d",
+			     ci->i_auth_cap ? ci->i_auth_cap->session->s_mds : -1);
+	spin_unlock(&ci->i_ceph_lock);
+	return ret;
+}
+
 #define CEPH_XATTR_NAME(_type, _name)	XATTR_CEPH_PREFIX #_type "." #_name
 #define CEPH_XATTR_NAME2(_type, _name, _name2)	\
 	XATTR_CEPH_PREFIX #_type "." #_name "." #_name2
@@ -473,6 +485,13 @@ static struct ceph_vxattr ceph_common_vxattrs[] = {
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


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2727C4842FD
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jan 2022 15:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbiADOEy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jan 2022 09:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233985AbiADOEx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jan 2022 09:04:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942A1C061761
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jan 2022 06:04:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EF52B81617
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jan 2022 14:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B33C36AE9;
        Tue,  4 Jan 2022 14:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641305091;
        bh=PkL7itq8IKrlXxkxDwbpH1sqm7ijEaREyjdj2CLwggo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CYsNUQDpaR2QfPpdzQuFhGJvecnARlukzVxu3SxNZ6RSuPeFr3kwL3VgLH3P58SBs
         wptvBPiN0mThXvvi1oSv4OGvs4TeoWhaFb+WdzTVLEoB463Mz2be1BaLH8qq+mO0BV
         Z1mNzbHWIs/f348fbQ+WbJOwPW+mmvB5qJYmShIiNOYUtNiGJbrwKanHx3RG0G18h3
         LHpi+bNpEhJvz4a2CwBn4eULRYtq+qGIHsiJqtMthAF3RGpu+rDFGNOEhGgsKpbnE3
         236+EjuI5oEYYlPmwpMKgctnC9rEuIWttvPRlgyhv+CjSyv4TRUMwXRZSUXU8cyYxZ
         MULImZHADLV+g==
From:   Christian Brauner <brauner@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 09/12] ceph: allow idmapped setattr inode op
Date:   Tue,  4 Jan 2022 15:04:11 +0100
Message-Id: <20220104140414.155198-10-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220104140414.155198-1-brauner@kernel.org>
References: <20220104140414.155198-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1717; h=from:subject; bh=BuD1MJMUOh7v5cDpM3Y1/1bmbAQmKMSk00dcBJnaxBI=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSReCd6Uzx1dyq7IdXdGUo2lXbjWbxfuLyt+p5R2F82tdFh4 8N/DjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInM2M3IsL+kzD+Zz8o2u7As4rCtcV kNi9quGVqPGA9OYwiODe3qYvgrksfzRG/D1eKH3kV2b5+Gvrq4TmLy9IvW+Rb2D3bnfL/IAQA=
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Enable __ceph_setattr() to handle idmapped mounts. This is just a matter
of passing down the mount's idmapping.

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ceph/inode.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index d5cecc3519fa..658b620efd50 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2032,6 +2032,13 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr)
 
 	dout("setattr %p issued %s\n", inode, ceph_cap_string(issued));
 
+	/*
+	 * The attr->ia_{g,u}id members contain the target {g,u}id we're
+	 * sending over the wire. The mount idmapping only matters when we
+	 * create new filesystem objects based on the caller's mapped
+	 * fs{g,u}id.
+	 */
+	req->mnt_userns = &init_user_ns;
 	if (ia_valid & ATTR_UID) {
 		dout("setattr %p uid %d -> %d\n", inode,
 		     from_kuid(&init_user_ns, inode->i_uid),
@@ -2222,7 +2229,7 @@ int ceph_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 	if (ceph_inode_is_shutdown(inode))
 		return -ESTALE;
 
-	err = setattr_prepare(&init_user_ns, dentry, attr);
+	err = setattr_prepare(mnt_userns, dentry, attr);
 	if (err != 0)
 		return err;
 
@@ -2237,7 +2244,7 @@ int ceph_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 	err = __ceph_setattr(inode, attr);
 
 	if (err >= 0 && (attr->ia_valid & ATTR_MODE))
-		err = posix_acl_chmod(&init_user_ns, inode, attr->ia_mode);
+		err = posix_acl_chmod(mnt_userns, inode, attr->ia_mode);
 
 	return err;
 }
-- 
2.32.0


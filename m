Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFA37E40A
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Aug 2019 22:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfHAU0J (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Aug 2019 16:26:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbfHAU0J (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 16:26:09 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAA502084C;
        Thu,  1 Aug 2019 20:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564691168;
        bh=T7ShJQd5gV3+K8ARj1JPvIb8bpDsUEpH5CHeVaJ3C4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GlYdY4SiYbv5QTKpf36KVHO7xCO8KkndHyXEqssInwLnzSWtvkGF1FlwKRKwcu3qB
         lq2MbYkpisHin96Z306M78Bg4ssVT1rTJyivyo6WIyTFf3B2Df7zys4AgLS0anoILc
         u3rYJAQQCPeI7drboBvUdASOg/duyGd3Cej1qD0I=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH 1/9] ceph: make several helper accessors take const pointers
Date:   Thu,  1 Aug 2019 16:25:57 -0400
Message-Id: <20190801202605.18172-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801202605.18172-1-jlayton@kernel.org>
References: <20190801202605.18172-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

None of these helper functions change anything in memory, so we can
declare their arguments as const.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/super.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 28404b3adcd2..4cd60f58d690 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -406,22 +406,26 @@ struct ceph_inode_info {
 	struct inode vfs_inode; /* at end */
 };
 
-static inline struct ceph_inode_info *ceph_inode(struct inode *inode)
+static inline struct ceph_inode_info *
+ceph_inode(const struct inode *inode)
 {
 	return container_of(inode, struct ceph_inode_info, vfs_inode);
 }
 
-static inline struct ceph_fs_client *ceph_inode_to_client(struct inode *inode)
+static inline struct ceph_fs_client *
+ceph_inode_to_client(const struct inode *inode)
 {
 	return (struct ceph_fs_client *)inode->i_sb->s_fs_info;
 }
 
-static inline struct ceph_fs_client *ceph_sb_to_client(struct super_block *sb)
+static inline struct ceph_fs_client *
+ceph_sb_to_client(const struct super_block *sb)
 {
 	return (struct ceph_fs_client *)sb->s_fs_info;
 }
 
-static inline struct ceph_vino ceph_vino(struct inode *inode)
+static inline struct ceph_vino
+ceph_vino(const struct inode *inode)
 {
 	return ceph_inode(inode)->i_vino;
 }
-- 
2.21.0


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B708C60A08
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Jul 2019 18:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbfGEQPA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 Jul 2019 12:15:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:35894 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727346AbfGEQO7 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 12:14:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 810E9AC8E;
        Fri,  5 Jul 2019 16:14:58 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>
Subject: [PATCH] ceph: use generic_delete_inode() for ->drop_inode
Date:   Fri,  5 Jul 2019 17:14:56 +0100
Message-Id: <20190705161456.5138-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

ceph_drop_inode() implementation is not any different from the generic
function, thus there's no point in keeping it around.

Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 fs/ceph/inode.c | 10 ----------
 fs/ceph/super.c |  2 +-
 fs/ceph/super.h |  1 -
 3 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 761451f36e2d..211140e6ef9c 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -578,16 +578,6 @@ void ceph_destroy_inode(struct inode *inode)
 	ceph_put_string(rcu_dereference_raw(ci->i_layout.pool_ns));
 }
 
-int ceph_drop_inode(struct inode *inode)
-{
-	/*
-	 * Positve dentry and corresponding inode are always accompanied
-	 * in MDS reply. So no need to keep inode in the cache after
-	 * dropping all its aliases.
-	 */
-	return 1;
-}
-
 static inline blkcnt_t calc_inode_blocks(u64 size)
 {
 	return (size + (1<<9) - 1) >> 9;
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index d57fa60dcd43..b4a4772756cb 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -843,7 +843,7 @@ static const struct super_operations ceph_super_ops = {
 	.destroy_inode	= ceph_destroy_inode,
 	.free_inode	= ceph_free_inode,
 	.write_inode    = ceph_write_inode,
-	.drop_inode	= ceph_drop_inode,
+	.drop_inode	= generic_delete_inode,
 	.sync_fs        = ceph_sync_fs,
 	.put_super	= ceph_put_super,
 	.remount_fs	= ceph_remount,
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 5f27e1f7f2d6..622e6c96c960 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -878,7 +878,6 @@ extern const struct inode_operations ceph_file_iops;
 extern struct inode *ceph_alloc_inode(struct super_block *sb);
 extern void ceph_destroy_inode(struct inode *inode);
 extern void ceph_free_inode(struct inode *inode);
-extern int ceph_drop_inode(struct inode *inode);
 
 extern struct inode *ceph_get_inode(struct super_block *sb,
 				    struct ceph_vino vino);

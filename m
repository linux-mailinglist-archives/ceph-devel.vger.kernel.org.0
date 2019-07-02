Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE345C6A2
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Jul 2019 03:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfGBBdB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 21:33:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59722 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbfGBBdB (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 21:33:01 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 411A530833B5
        for <ceph-devel@vger.kernel.org>; Tue,  2 Jul 2019 01:33:01 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-170.pek2.redhat.com [10.72.12.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2672D60C43;
        Tue,  2 Jul 2019 01:32:56 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com
Subject: [PATCH] ceph: use ceph_evict_inode to cleanup inode's resource
Date:   Tue,  2 Jul 2019 09:32:54 +0800
Message-Id: <20190702013254.21028-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 02 Jul 2019 01:33:01 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

remove_session_caps() relies on __wait_on_freeing_inode(), to wait for
freeing inode to remove its caps. But VFS wakes freeing inode waiters
before calling destroy_inode().

Link: https://tracker.ceph.com/issues/40102
Cc: stable@vger.kernel.org
Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/inode.c | 7 +++++--
 fs/ceph/super.c | 2 +-
 fs/ceph/super.h | 2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 2c49eb831c6f..a565ab124282 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -526,13 +526,16 @@ void ceph_free_inode(struct inode *inode)
 	kmem_cache_free(ceph_inode_cachep, ci);
 }
 
-void ceph_destroy_inode(struct inode *inode)
+void ceph_evict_inode(struct inode *inode)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_inode_frag *frag;
 	struct rb_node *n;
 
-	dout("destroy_inode %p ino %llx.%llx\n", inode, ceph_vinop(inode));
+	dout("evict_inode %p ino %llx.%llx\n", inode, ceph_vinop(inode));
+
+	truncate_inode_pages_final(&inode->i_data);
+	clear_inode(inode);
 
 	ceph_fscache_unregister_inode_cookie(ci);
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index c21201a951ce..5f0c950ca966 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -840,10 +840,10 @@ static int ceph_remount(struct super_block *sb, int *flags, char *data)
 
 static const struct super_operations ceph_super_ops = {
 	.alloc_inode	= ceph_alloc_inode,
-	.destroy_inode	= ceph_destroy_inode,
 	.free_inode	= ceph_free_inode,
 	.write_inode    = ceph_write_inode,
 	.drop_inode	= ceph_drop_inode,
+	.evict_inode	= ceph_evict_inode,
 	.sync_fs        = ceph_sync_fs,
 	.put_super	= ceph_put_super,
 	.remount_fs	= ceph_remount,
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index a592d4a8266c..30e9a4e415cc 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -884,7 +884,7 @@ static inline bool __ceph_have_pending_cap_snap(struct ceph_inode_info *ci)
 extern const struct inode_operations ceph_file_iops;
 
 extern struct inode *ceph_alloc_inode(struct super_block *sb);
-extern void ceph_destroy_inode(struct inode *inode);
+extern void ceph_evict_inode(struct inode *inode);
 extern void ceph_free_inode(struct inode *inode);
 extern int ceph_drop_inode(struct inode *inode);
 
-- 
2.20.1


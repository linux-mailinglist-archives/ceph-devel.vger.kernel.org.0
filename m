Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9950E1648B
	for <lists+ceph-devel@lfdr.de>; Tue,  7 May 2019 15:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfEGN1s (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 May 2019 09:27:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbfEGN1s (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 7 May 2019 09:27:48 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D8B12053B;
        Tue,  7 May 2019 13:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557235668;
        bh=jFSxzYzfvF9J3IyBvPzCc5+dA9k//hmC24Q+ehoUpNk=;
        h=From:To:Cc:Subject:Date:From;
        b=FMq9GvnMQzMMwZ5jAXxQ5Ci8+4hpuok5SPnjauRspyQzGmqDDn6t1fQPMykdLOfYZ
         mBwK8iapN4HlWNvLJ+plV/c85Lvy9DBVRPH3ZKR19cbIGfat4D50icZut9wilOfkC+
         NkNasiD8T5hIrD/mA0TnvzLFXiNdhKP7V8jKjBwM=
From:   Jeff Layton <jlayton@kernel.org>
To:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: flush dirty inodes before proceeding with remount
Date:   Tue,  7 May 2019 09:27:46 -0400
Message-Id: <20190507132746.27493-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

xfstest generic/452 was triggering a "Busy inodes after umount" warning.
ceph was allowing the mount to go read-only without first flushing out
dirty inodes in the cache. Ensure we sync out the filesystem before
allowing a remount to proceed.

Cc: stable@vger.kernel.org
Fixes: http://tracker.ceph.com/issues/39571
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/super.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 6d5bb2f74612..01113c86e469 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -845,6 +845,12 @@ static void ceph_umount_begin(struct super_block *sb)
 	return;
 }
 
+static int ceph_remount(struct super_block *sb, int *flags, char *data)
+{
+	sync_filesystem(sb);
+	return 0;
+}
+
 static const struct super_operations ceph_super_ops = {
 	.alloc_inode	= ceph_alloc_inode,
 	.destroy_inode	= ceph_destroy_inode,
@@ -852,6 +858,7 @@ static const struct super_operations ceph_super_ops = {
 	.drop_inode	= ceph_drop_inode,
 	.sync_fs        = ceph_sync_fs,
 	.put_super	= ceph_put_super,
+	.remount_fs	= ceph_remount,
 	.show_options   = ceph_show_options,
 	.statfs		= ceph_statfs,
 	.umount_begin   = ceph_umount_begin,
-- 
2.21.0


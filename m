Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E818643C9BD
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Oct 2021 14:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241928AbhJ0Md4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Oct 2021 08:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240109AbhJ0Mdy (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 08:33:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC44B60F5A;
        Wed, 27 Oct 2021 12:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635337889;
        bh=OmYFo1JF3E4Io5q7hqgkLayTbLVPkqa12s9ZXqRFLN4=;
        h=From:To:Cc:Subject:Date:From;
        b=mpffKuTMIaFmF5JbCVB3446FdFvJmxjMbInYtwvYHB9G1oblSdi8Q5LluMABdm30B
         RiRO5QDixH6qpVGUb4h8C7ShXSKbnTcrO9rw0s11NEaMbwPMLr98KQ3iyTthte+iDp
         pevE9Nq7wuZ2ZyBTb5eRUc9oJJZHrZKsTVev45gMUbxLiGRWy2ji+5QyIE+U81kQiG
         ODS7Oj+f+TrdN7ADVGfnNEw3eqaUIvvcePIgDgpJcHNhMo93Bs5klO/K1Fst2Uy6xf
         WM6QiF7lW7Hfl4usnV6LeOm9+FJXTZkjs+BLtEvBDosmn/TfbEgoXLQpkPRdUFjdMh
         tnJihUGdPJ+hg==
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de
Subject: [RFC PATCH] ceph: add a "client_shutdown" fault-injection file to debugfs
Date:   Wed, 27 Oct 2021 08:31:27 -0400
Message-Id: <20211027123127.11020-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Writing a non-zero value to this file will trigger spurious shutdown of
the client, simulating the effect of receiving a bad mdsmap or fsmap.

Note that this effect cannot be reversed. The only remedy is to unmount.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/debugfs.c | 28 ++++++++++++++++++++++++++++
 fs/ceph/super.h   |  1 +
 2 files changed, 29 insertions(+)

I used this patch to do some fault injection testing before I proposed
the patch recently to shut down the mount on receipt of a bad fsmap or
mdsmap.

Is this something we should consider for mainline kernels?

We could put it behind a new Kconfig option if we're worried about
footguns in production kernels. Maybe we could call the new file
"fault_inject", and allow writing a mask value to it? We could roll
tests for teuthology that use this too.

There are a lot of possibilities.

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 55426514491b..57a72f267f6e 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -401,11 +401,32 @@ DEFINE_SIMPLE_ATTRIBUTE(congestion_kb_fops, congestion_kb_get,
 			congestion_kb_set, "%llu\n");
 
 
+static int client_shutdown_set(void *data, u64 val)
+{
+	struct ceph_fs_client *fsc = (struct ceph_fs_client *)data;
+
+	if (val)
+		ceph_umount_begin(fsc->sb);
+	return 0;
+}
+
+static int client_shutdown_get(void *data, u64 *val)
+{
+	struct ceph_fs_client *fsc = (struct ceph_fs_client *)data;
+
+	*val = (u64)(fsc->mount_state == CEPH_MOUNT_SHUTDOWN);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(client_shutdown_fops, client_shutdown_get,
+			client_shutdown_set, "%llu\n");
+
 void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
 {
 	dout("ceph_fs_debugfs_cleanup\n");
 	debugfs_remove(fsc->debugfs_bdi);
 	debugfs_remove(fsc->debugfs_congestion_kb);
+	debugfs_remove(fsc->debugfs_client_shutdown);
 	debugfs_remove(fsc->debugfs_mdsmap);
 	debugfs_remove(fsc->debugfs_mds_sessions);
 	debugfs_remove(fsc->debugfs_caps);
@@ -426,6 +447,13 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 				    fsc,
 				    &congestion_kb_fops);
 
+	fsc->debugfs_client_shutdown =
+		debugfs_create_file("client_shutdown",
+				    0600,
+				    fsc->client->debugfs_dir,
+				    fsc,
+				    &client_shutdown_fops);
+
 	snprintf(name, sizeof(name), "../../bdi/%s",
 		 bdi_dev_name(fsc->sb->s_bdi));
 	fsc->debugfs_bdi =
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index ed51e04739c4..e5d0ad5c6135 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -135,6 +135,7 @@ struct ceph_fs_client {
 	struct dentry *debugfs_status;
 	struct dentry *debugfs_mds_sessions;
 	struct dentry *debugfs_metrics_dir;
+	struct dentry *debugfs_client_shutdown;
 #endif
 
 #ifdef CONFIG_CEPH_FSCACHE
-- 
2.31.1


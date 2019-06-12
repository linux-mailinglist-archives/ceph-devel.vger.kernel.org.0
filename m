Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72DE942A02
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Jun 2019 16:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409364AbfFLOzl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Jun 2019 10:55:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409361AbfFLOzl (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 10:55:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFB2B20866;
        Wed, 12 Jun 2019 14:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560351340;
        bh=LsO8w2kfXBBDKAFJ3tsyGxwx4tgP7CtyjSJzLFsJc5U=;
        h=Date:From:To:Cc:Subject:From;
        b=1uh4XVKpH7aoL9kTULLbIwt5jsJMe8uxoay3iPPRvfpkf+27hceDfBWQKQlBLRYnN
         EySGuZ1eLgfv+1vmI5uVRVwsMSVlFhudZdrKJTqPRiIqj6LprDSKWIXFXPYxP0U9O1
         msr/+IYVOsfm8e03tVmn6uhogYdrLDNlRLMN+0x4=
Date:   Wed, 12 Jun 2019 16:55:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: no need to check return value of debugfs_create
 functions
Message-ID: <20190612145538.GA18772@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

This cleanup allows the return value of the functions to be made void,
as no logic should care if these files succeed or not.

Cc: "Yan, Zheng" <zyan@redhat.com>
Cc: Sage Weil <sage@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/debugfs.c            | 24 ++----------------------
 fs/ceph/super.c              |  4 +---
 fs/ceph/super.h              |  2 +-
 include/linux/ceph/debugfs.h |  4 ++--
 net/ceph/ceph_common.c       |  5 +----
 net/ceph/debugfs.c           | 33 ++++-----------------------------
 6 files changed, 11 insertions(+), 61 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index b3fc5fe26a1a..83cd41fa2b01 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -245,21 +245,17 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
 	debugfs_remove(fsc->debugfs_mdsc);
 }
 
-int ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
+void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 {
 	char name[100];
-	int err = -ENOMEM;
 
 	dout("ceph_fs_debugfs_init\n");
-	BUG_ON(!fsc->client->debugfs_dir);
 	fsc->debugfs_congestion_kb =
 		debugfs_create_file("writeback_congestion_kb",
 				    0600,
 				    fsc->client->debugfs_dir,
 				    fsc,
 				    &congestion_kb_fops);
-	if (!fsc->debugfs_congestion_kb)
-		goto out;
 
 	snprintf(name, sizeof(name), "../../bdi/%s",
 		 dev_name(fsc->sb->s_bdi->dev));
@@ -267,52 +263,36 @@ int ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 		debugfs_create_symlink("bdi",
 				       fsc->client->debugfs_dir,
 				       name);
-	if (!fsc->debugfs_bdi)
-		goto out;
 
 	fsc->debugfs_mdsmap = debugfs_create_file("mdsmap",
 					0400,
 					fsc->client->debugfs_dir,
 					fsc,
 					&mdsmap_show_fops);
-	if (!fsc->debugfs_mdsmap)
-		goto out;
 
 	fsc->debugfs_mds_sessions = debugfs_create_file("mds_sessions",
 					0400,
 					fsc->client->debugfs_dir,
 					fsc,
 					&mds_sessions_show_fops);
-	if (!fsc->debugfs_mds_sessions)
-		goto out;
 
 	fsc->debugfs_mdsc = debugfs_create_file("mdsc",
 						0400,
 						fsc->client->debugfs_dir,
 						fsc,
 						&mdsc_show_fops);
-	if (!fsc->debugfs_mdsc)
-		goto out;
 
 	fsc->debugfs_caps = debugfs_create_file("caps",
 						   0400,
 						   fsc->client->debugfs_dir,
 						   fsc,
 						   &caps_show_fops);
-	if (!fsc->debugfs_caps)
-		goto out;
-
-	return 0;
-
-out:
-	ceph_fs_debugfs_cleanup(fsc);
-	return err;
 }
 
 
 #else  /* CONFIG_DEBUG_FS */
 
-int ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
+void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 {
 	return 0;
 }
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 01be7c1bc4c6..273c94b61a3d 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -951,9 +951,7 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc)
 			dout("mount opening path %s\n", path);
 		}
 
-		err = ceph_fs_debugfs_init(fsc);
-		if (err < 0)
-			goto out;
+		ceph_fs_debugfs_init(fsc);
 
 		root = open_root_dentry(fsc, path, started);
 		if (IS_ERR(root)) {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 6edab9a750f8..ac1e17853278 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1099,7 +1099,7 @@ extern int ceph_locks_to_pagelist(struct ceph_filelock *flocks,
 				  int num_fcntl_locks, int num_flock_locks);
 
 /* debugfs.c */
-extern int ceph_fs_debugfs_init(struct ceph_fs_client *client);
+extern void ceph_fs_debugfs_init(struct ceph_fs_client *client);
 extern void ceph_fs_debugfs_cleanup(struct ceph_fs_client *client);
 
 /* quota.c */
diff --git a/include/linux/ceph/debugfs.h b/include/linux/ceph/debugfs.h
index fa5f9b7f5dbb..cf5e840eec71 100644
--- a/include/linux/ceph/debugfs.h
+++ b/include/linux/ceph/debugfs.h
@@ -19,9 +19,9 @@ static const struct file_operations name##_fops = {			\
 };
 
 /* debugfs.c */
-extern int ceph_debugfs_init(void);
+extern void ceph_debugfs_init(void);
 extern void ceph_debugfs_cleanup(void);
-extern int ceph_debugfs_client_init(struct ceph_client *client);
+extern void ceph_debugfs_client_init(struct ceph_client *client);
 extern void ceph_debugfs_client_cleanup(struct ceph_client *client);
 
 #endif
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 1c811c74bfc0..4eeea4d5c3ef 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -776,9 +776,7 @@ static int __init init_ceph_lib(void)
 {
 	int ret = 0;
 
-	ret = ceph_debugfs_init();
-	if (ret < 0)
-		goto out;
+	ceph_debugfs_init();
 
 	ret = ceph_crypto_init();
 	if (ret < 0)
@@ -803,7 +801,6 @@ static int __init init_ceph_lib(void)
 	ceph_crypto_shutdown();
 out_debugfs:
 	ceph_debugfs_cleanup();
-out:
 	return ret;
 }
 
diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
index 63aef9915f75..7cb992e55475 100644
--- a/net/ceph/debugfs.c
+++ b/net/ceph/debugfs.c
@@ -389,12 +389,9 @@ CEPH_DEFINE_SHOW_FUNC(monc_show)
 CEPH_DEFINE_SHOW_FUNC(osdc_show)
 CEPH_DEFINE_SHOW_FUNC(client_options_show)
 
-int __init ceph_debugfs_init(void)
+void __init ceph_debugfs_init(void)
 {
 	ceph_debugfs_dir = debugfs_create_dir("ceph", NULL);
-	if (!ceph_debugfs_dir)
-		return -ENOMEM;
-	return 0;
 }
 
 void ceph_debugfs_cleanup(void)
@@ -402,9 +399,8 @@ void ceph_debugfs_cleanup(void)
 	debugfs_remove(ceph_debugfs_dir);
 }
 
-int ceph_debugfs_client_init(struct ceph_client *client)
+void ceph_debugfs_client_init(struct ceph_client *client)
 {
-	int ret = -ENOMEM;
 	char name[80];
 
 	snprintf(name, sizeof(name), "%pU.client%lld", &client->fsid,
@@ -412,56 +408,37 @@ int ceph_debugfs_client_init(struct ceph_client *client)
 
 	dout("ceph_debugfs_client_init %p %s\n", client, name);
 
-	BUG_ON(client->debugfs_dir);
 	client->debugfs_dir = debugfs_create_dir(name, ceph_debugfs_dir);
-	if (!client->debugfs_dir)
-		goto out;
 
 	client->monc.debugfs_file = debugfs_create_file("monc",
 						      0400,
 						      client->debugfs_dir,
 						      client,
 						      &monc_show_fops);
-	if (!client->monc.debugfs_file)
-		goto out;
 
 	client->osdc.debugfs_file = debugfs_create_file("osdc",
 						      0400,
 						      client->debugfs_dir,
 						      client,
 						      &osdc_show_fops);
-	if (!client->osdc.debugfs_file)
-		goto out;
 
 	client->debugfs_monmap = debugfs_create_file("monmap",
 					0400,
 					client->debugfs_dir,
 					client,
 					&monmap_show_fops);
-	if (!client->debugfs_monmap)
-		goto out;
 
 	client->debugfs_osdmap = debugfs_create_file("osdmap",
 					0400,
 					client->debugfs_dir,
 					client,
 					&osdmap_show_fops);
-	if (!client->debugfs_osdmap)
-		goto out;
 
 	client->debugfs_options = debugfs_create_file("client_options",
 					0400,
 					client->debugfs_dir,
 					client,
 					&client_options_show_fops);
-	if (!client->debugfs_options)
-		goto out;
-
-	return 0;
-
-out:
-	ceph_debugfs_client_cleanup(client);
-	return ret;
 }
 
 void ceph_debugfs_client_cleanup(struct ceph_client *client)
@@ -477,18 +454,16 @@ void ceph_debugfs_client_cleanup(struct ceph_client *client)
 
 #else  /* CONFIG_DEBUG_FS */
 
-int __init ceph_debugfs_init(void)
+void __init ceph_debugfs_init(void)
 {
-	return 0;
 }
 
 void ceph_debugfs_cleanup(void)
 {
 }
 
-int ceph_debugfs_client_init(struct ceph_client *client)
+void ceph_debugfs_client_init(struct ceph_client *client)
 {
-	return 0;
 }
 
 void ceph_debugfs_client_cleanup(struct ceph_client *client)
-- 
2.22.0


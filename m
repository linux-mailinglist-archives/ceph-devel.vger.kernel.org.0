Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64CE23F6EFE
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Aug 2021 07:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbhHYFvo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Aug 2021 01:51:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234606AbhHYFvn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 01:51:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629870657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cRbBAW///ySXACHT5hNwP0nJzYbbqyY1XHHqBrEY5dY=;
        b=Gxy06HxZNCy0M9mOyp969JvdmTlGw6f7Nw3SuNjHj95trYuZLOBSllHeNX1ppSOUpNGPFV
        BRK7nuSGJqW3nkAeUAvG++voqgrzXEJE6Y62srNG7x9RgkOHFV6QcVx+5dKQO37C6sxPFg
        3uT/jVYwuu1HShbATUsnbBa6TiRUcTM=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-DnOqSh1EPcKKOKlPO-Pyng-1; Wed, 25 Aug 2021 01:50:54 -0400
X-MC-Unique: DnOqSh1EPcKKOKlPO-Pyng-1
Received: by mail-pj1-f71.google.com with SMTP id mm23-20020a17090b359700b00185945eae0eso3883949pjb.3
        for <ceph-devel@vger.kernel.org>; Tue, 24 Aug 2021 22:50:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cRbBAW///ySXACHT5hNwP0nJzYbbqyY1XHHqBrEY5dY=;
        b=pEiVf6cCX7/as4eAipTf9fkV4pLue62E4gp/FhtWG3gDq+doLewWXqFx+ZviS1a7Vn
         7VLA6xDQQ6/Mznc4U2ej1qXvNdB2foWac2+93WhmBmnzgHDCP+zsUnfuo4YGkO7/+KC5
         UfNpDQVzS83jGek1U45HiLFA3KC+xPluCOrFbHX2w7Z2+/OmlXXXcpBwcilFB9urhaSl
         0oNvQgbFNcz/hAM00lg3AkoykvRr/eJMl0OP9xO6bUXvmE6KRkYXGnanP3yhzwz3jhLa
         WYgI1hGY+Sq0E1E7BSIo4ooG6hFEr8v8hjWzLoYG5euyrm8EIzwPLEES0mly0EGBG286
         0p5g==
X-Gm-Message-State: AOAM530MnSc4v2laqPvThs65G3QGcc/yUpSP4LN3lWsUO3MDlPjRcQHo
        eygy1B369UysFX7s/pB46QIoIdzjIMToda1kpjjy0wsllGWfOPiI2yV3DuhIrDl5+MKcKtonIiu
        yMJyWPClt4pap9C7x8MqtjA==
X-Received: by 2002:a05:6a00:cc2:b0:3ee:20e0:1f20 with SMTP id b2-20020a056a000cc200b003ee20e01f20mr6400609pfv.7.1629870653057;
        Tue, 24 Aug 2021 22:50:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvHYsOY3t6sEtr0Xy1HJYwMhfVw/QT43cbQcLSRgQzU7VCCtCIW7a4UaSRH/hdLLy3N/dOWQ==
X-Received: by 2002:a05:6a00:cc2:b0:3ee:20e0:1f20 with SMTP id b2-20020a056a000cc200b003ee20e01f20mr6400598pfv.7.1629870652769;
        Tue, 24 Aug 2021 22:50:52 -0700 (PDT)
Received: from localhost.localdomain ([49.207.198.118])
        by smtp.gmail.com with ESMTPSA id w4sm960362pjj.15.2021.08.24.22.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 22:50:52 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v2 2/2] ceph: add debugfs entries for mount syntax support
Date:   Wed, 25 Aug 2021 11:20:35 +0530
Message-Id: <20210825055035.306043-3-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210825055035.306043-1-vshankar@redhat.com>
References: <20210825055035.306043-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/debugfs.c | 36 ++++++++++++++++++++++++++++++++++++
 fs/ceph/super.c   |  3 +++
 fs/ceph/super.h   |  2 ++
 3 files changed, 41 insertions(+)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 66989c880adb..f9ff70704423 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -22,6 +22,14 @@
 #include "mds_client.h"
 #include "metric.h"
 
+#define CLIENT_FEATURES_DIR_NAME   "client_features"
+#define MOUNT_DEVICE_V1_SUPPORT_FILE_NAME "v1_mount_syntax"
+#define MOUNT_DEVICE_V2_SUPPORT_FILE_NAME "v2_mount_syntax"
+
+static struct dentry *ceph_client_features_dir;
+static struct dentry *ceph_mount_device_v1_support;
+static struct dentry *ceph_mount_device_v2_support;
+
 static int mdsmap_show(struct seq_file *s, void *p)
 {
 	int i;
@@ -416,6 +424,26 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 						  &status_fops);
 }
 
+void ceph_fs_debugfs_client_features_init(void)
+{
+	ceph_client_features_dir = debugfs_create_dir(CLIENT_FEATURES_DIR_NAME,
+						      ceph_debugfs_dir);
+	ceph_mount_device_v1_support = debugfs_create_file(MOUNT_DEVICE_V1_SUPPORT_FILE_NAME,
+							   0400,
+							   ceph_client_features_dir,
+							   NULL, NULL);
+	ceph_mount_device_v2_support = debugfs_create_file(MOUNT_DEVICE_V2_SUPPORT_FILE_NAME,
+							   0400,
+							   ceph_client_features_dir,
+							   NULL, NULL);
+}
+
+void ceph_fs_debugfs_client_features_cleanup(void)
+{
+	debugfs_remove(ceph_mount_device_v1_support);
+	debugfs_remove(ceph_mount_device_v2_support);
+	debugfs_remove(ceph_client_features_dir);
+}
 
 #else  /* CONFIG_DEBUG_FS */
 
@@ -427,4 +455,12 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
 {
 }
 
+void ceph_fs_debugfs_client_features_init(void)
+{
+}
+
+void ceph_fs_debugfs_client_features_cleanup(void)
+{
+}
+
 #endif  /* CONFIG_DEBUG_FS */
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 609ffc8c2d78..21d59deb042d 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1404,6 +1404,8 @@ static int __init init_ceph(void)
 	if (ret)
 		goto out_caches;
 
+	ceph_fs_debugfs_client_features_init();
+
 	pr_info("loaded (mds proto %d)\n", CEPH_MDSC_PROTOCOL);
 
 	return 0;
@@ -1417,6 +1419,7 @@ static int __init init_ceph(void)
 static void __exit exit_ceph(void)
 {
 	dout("exit_ceph\n");
+	ceph_fs_debugfs_client_features_cleanup();
 	unregister_filesystem(&ceph_fs_type);
 	destroy_caches();
 }
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 8f71184b7c85..7e7b140cab5d 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1231,6 +1231,8 @@ extern int ceph_locks_to_pagelist(struct ceph_filelock *flocks,
 /* debugfs.c */
 extern void ceph_fs_debugfs_init(struct ceph_fs_client *client);
 extern void ceph_fs_debugfs_cleanup(struct ceph_fs_client *client);
+extern void ceph_fs_debugfs_client_features_init(void);
+extern void ceph_fs_debugfs_client_features_cleanup(void);
 
 /* quota.c */
 static inline bool __ceph_has_any_quota(struct ceph_inode_info *ci)
-- 
2.27.0


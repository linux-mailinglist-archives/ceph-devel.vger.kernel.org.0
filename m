Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A93A3EFA89
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 08:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237997AbhHRGC0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 02:02:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53344 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237998AbhHRGCZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 02:02:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629266511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XcnZULfvRaZaSxsgM256TjfSITYnqvCQsiXUNryFrYk=;
        b=CFckpjVp0uqKE5zeNUiHbQnFf9dAxwgBkeUg8JfJnhwPPUv1f+W/RJe5vK2bKt8ifcCCQL
        b5CaSPuvl8pOSmtZor/QkWRV8/QukvDqU+VqX4P8a9p5R7+ybQ72yICFNRZO2+yd6QLTf+
        +XvMWb7FFwfPAY2m4uz//ahYB8CkOXw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-ojsvZnvcMOCMPgAqiLsjIA-1; Wed, 18 Aug 2021 02:01:49 -0400
X-MC-Unique: ojsvZnvcMOCMPgAqiLsjIA-1
Received: by mail-pj1-f69.google.com with SMTP id t16-20020a17090ae510b0290178bb9f2f04so1049976pjy.1
        for <ceph-devel@vger.kernel.org>; Tue, 17 Aug 2021 23:01:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XcnZULfvRaZaSxsgM256TjfSITYnqvCQsiXUNryFrYk=;
        b=uNaWDML/XVpL1uB4BKwRRlrQRECDeDAUBe9u7iqm2b5KSwqW28NGXcC9PyV1WQyhK5
         wSZhvY2Q82RHRCZNc9b2G8LBRiz9JwpEve4eJd1vW+KlJ8Wnyt3hRlBlnDLajEPpnGjL
         ejKodNI98nAGYfDuCuL6s8AgyFQi3WtkgbxFDx65Vq2NOfxMU9RY4zsw5Gqw0mKSGucm
         HQpOrCaxIy0wsho3tcysXPAfwgbVETiXensaQgNx4nPkSoHreWzMEOmytX9PYsP1zYyW
         8dL067lV5cFY3zRjnE1GnYOLShoVvbbvZnYpmQeEG7h+yFQmZqandpT+f1MVfmzF0iQT
         wyGw==
X-Gm-Message-State: AOAM532l17dl8Zx/p1qeL3HG5dE3S0vCiwcnfV2QDfZ1ZMybCzsiGSF8
        YcYkauRFZeEI8BRB3gU697cLYa/SqTluwHoOORFouS6PvPPx9dRQJLA9aWAw58KFVAEoMQQIxCH
        nBzzNDHfLOW5/brAw1FsRjw==
X-Received: by 2002:a17:902:bd98:b029:12c:9106:b54f with SMTP id q24-20020a170902bd98b029012c9106b54fmr5881689pls.40.1629266508027;
        Tue, 17 Aug 2021 23:01:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxdV0r+bRcCIFvfEJqs6M8QPTNh3UXBiE8iK0SRbO7O/p5Kct3oN7ILoGjBIL5ZRX5rB0/U9w==
X-Received: by 2002:a17:902:bd98:b029:12c:9106:b54f with SMTP id q24-20020a170902bd98b029012c9106b54fmr5881676pls.40.1629266507843;
        Tue, 17 Aug 2021 23:01:47 -0700 (PDT)
Received: from localhost.localdomain ([49.207.198.118])
        by smtp.gmail.com with ESMTPSA id m28sm5865111pgl.9.2021.08.17.23.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:01:47 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [RFC 2/2] ceph: add debugfs entries for v2 (new) mount syntax support
Date:   Wed, 18 Aug 2021 11:31:34 +0530
Message-Id: <20210818060134.208546-3-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818060134.208546-1-vshankar@redhat.com>
References: <20210818060134.208546-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/debugfs.c | 28 ++++++++++++++++++++++++++++
 fs/ceph/super.c   |  3 +++
 fs/ceph/super.h   |  2 ++
 3 files changed, 33 insertions(+)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 66989c880adb..d19f15ace781 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -22,6 +22,12 @@
 #include "mds_client.h"
 #include "metric.h"
 
+#define MNT_DEV_SUPPORT_DIR   "dev_support"
+#define MNT_DEV_V2_FILE  "v2"
+
+static struct dentry *ceph_mnt_dev_support_dir;
+static struct dentry *ceph_mnt_dev_v2_file;
+
 static int mdsmap_show(struct seq_file *s, void *p)
 {
 	int i;
@@ -416,6 +422,20 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 						  &status_fops);
 }
 
+void ceph_fs_debugfs_mnt_dev_init(void)
+{
+	ceph_mnt_dev_support_dir = ceph_debugfs_create_subdir(MNT_DEV_SUPPORT_DIR);
+	ceph_mnt_dev_v2_file = debugfs_create_file(MNT_DEV_V2_FILE,
+						   0400,
+						   ceph_mnt_dev_support_dir,
+						   NULL, NULL);
+}
+
+void ceph_fs_debugfs_mnt_dev_cleanup(void)
+{
+	debugfs_remove(ceph_mnt_dev_v2_file);
+	ceph_debugfs_cleanup_subdir(ceph_mnt_dev_support_dir);
+}
 
 #else  /* CONFIG_DEBUG_FS */
 
@@ -427,4 +447,12 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
 {
 }
 
+void ceph_fs_debugfs_mnt_dev_init(void)
+{
+}
+
+void ceph_fs_debugfs_mnt_dev_cleanup(void)
+{
+}
+
 #endif  /* CONFIG_DEBUG_FS */
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 609ffc8c2d78..21e4a8249afd 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1404,6 +1404,8 @@ static int __init init_ceph(void)
 	if (ret)
 		goto out_caches;
 
+	ceph_fs_debugfs_mnt_dev_init();
+
 	pr_info("loaded (mds proto %d)\n", CEPH_MDSC_PROTOCOL);
 
 	return 0;
@@ -1417,6 +1419,7 @@ static int __init init_ceph(void)
 static void __exit exit_ceph(void)
 {
 	dout("exit_ceph\n");
+	ceph_fs_debugfs_mnt_dev_cleanup();
 	unregister_filesystem(&ceph_fs_type);
 	destroy_caches();
 }
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 8f71184b7c85..3c63c1adcfaa 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1231,6 +1231,8 @@ extern int ceph_locks_to_pagelist(struct ceph_filelock *flocks,
 /* debugfs.c */
 extern void ceph_fs_debugfs_init(struct ceph_fs_client *client);
 extern void ceph_fs_debugfs_cleanup(struct ceph_fs_client *client);
+extern void ceph_fs_debugfs_mnt_dev_init(void);
+extern void ceph_fs_debugfs_mnt_dev_cleanup(void);
 
 /* quota.c */
 static inline bool __ceph_has_any_quota(struct ceph_inode_info *ci)
-- 
2.27.0


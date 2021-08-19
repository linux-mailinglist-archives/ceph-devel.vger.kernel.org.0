Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7093F1314
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Aug 2021 08:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhHSGH4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Aug 2021 02:07:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35601 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230396AbhHSGHx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 02:07:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629353236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XcnZULfvRaZaSxsgM256TjfSITYnqvCQsiXUNryFrYk=;
        b=cBn2xmP886TogvzqLYdMU3WxQRoVDBdr5D2nEg7Oc9ZcGNdA3P+4yuqBOWaXJI4y/ZIPbK
        RhCsxtpLYUSyWRiNktpLNlmQ/qS/kK7gWC2FHGepLySkkxiH1EuUrqZmPvVOtoBdiPRbWb
        njhU5Xy9N7/09KoNR1L4fZB4kT8SvrU=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-KYnlDkfKNSmQ50tEYEbbgg-1; Thu, 19 Aug 2021 02:07:14 -0400
X-MC-Unique: KYnlDkfKNSmQ50tEYEbbgg-1
Received: by mail-pl1-f197.google.com with SMTP id y3-20020a17090322c3b029012d433951c9so1253205plg.1
        for <ceph-devel@vger.kernel.org>; Wed, 18 Aug 2021 23:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XcnZULfvRaZaSxsgM256TjfSITYnqvCQsiXUNryFrYk=;
        b=HXcfmayiwcdherxcxpAIsPHHMG6xLV2ad8vonT8kOALbpHX4zzBQilHZD5sAXjp4ZX
         dkqpuW3YF0TiDzllgOB+pfGipFr/9S3VOCCZQcXs5XxQPYtk3kizc87xhX989R29XoDr
         qA7BExYb9zGyeiGSjssVpG68uCBobodzmw56/f19fbgXUlDrdnWdNgs8OR04lLHkAa5X
         e32zU3+OQANoh2z5Oxo7I4wmrZ7c/si224wANUqTz61lD53SwK4o23fLjfwxcK+mY4tu
         iJG1T59hedjns5Fk30M3mLId/avn5pc9qR+z+LmBWQUQ+EFnYyA/bAx65ywPyupenuux
         /loA==
X-Gm-Message-State: AOAM532vynIY7/HgKXA7gUyb0yUFQwAz9eXq1zhyTYlx2PZYgNZ2nx9c
        RijyzjY4nukVkyQek0oVMJAbVKhpIRPgDY0Xa0INirJ08YWjV0Q07K1PLOqooGnh7nBw4bLSAUf
        14ORjgHb+Zz+tk3cTj0/K5Q==
X-Received: by 2002:a17:90a:fa89:: with SMTP id cu9mr12638523pjb.5.1629353233725;
        Wed, 18 Aug 2021 23:07:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYiIDS6FDAEjlSKrUHFUJocLc3rI/E1Ef7PDZQtUSWTz4I7RhPUdo9dRcSHrFDtDFz66BiYQ==
X-Received: by 2002:a17:90a:fa89:: with SMTP id cu9mr12638507pjb.5.1629353233513;
        Wed, 18 Aug 2021 23:07:13 -0700 (PDT)
Received: from localhost.localdomain ([49.207.198.118])
        by smtp.gmail.com with ESMTPSA id o24sm1663100pjs.49.2021.08.18.23.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 23:07:12 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH 2/2] ceph: add debugfs entries for v2 (new) mount syntax support
Date:   Thu, 19 Aug 2021 11:37:01 +0530
Message-Id: <20210819060701.25486-3-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210819060701.25486-1-vshankar@redhat.com>
References: <20210819060701.25486-1-vshankar@redhat.com>
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


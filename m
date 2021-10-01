Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D557841E704
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Oct 2021 07:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351928AbhJAFCj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 1 Oct 2021 01:02:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41102 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230397AbhJAFCi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 1 Oct 2021 01:02:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633064454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yIv0dHQYBDLB+/l/xSVTr/5PzjLi1sZMuJjAXldYU2c=;
        b=A6/7oivDmIVmCpVPqwg01EtuAN+a4hKwleaTLtJGtyyi0/rE7GRFNtMA9RrYTpPFW73Eon
        WQPGM5XGc07P4e+wijG1H8cnSU0989IzeGInfO7MSGZUQdFnbmsQUHLTRWVZy6YSdnwZEs
        ENx9JyXI4Zk4QczDBEdyv80K1keOsgQ=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-qoCsplZSPPCNtinohx35Fg-1; Fri, 01 Oct 2021 01:00:53 -0400
X-MC-Unique: qoCsplZSPPCNtinohx35Fg-1
Received: by mail-pj1-f70.google.com with SMTP id v10-20020a17090abb8a00b0019f1a066f81so5505022pjr.9
        for <ceph-devel@vger.kernel.org>; Thu, 30 Sep 2021 22:00:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yIv0dHQYBDLB+/l/xSVTr/5PzjLi1sZMuJjAXldYU2c=;
        b=DuvVbLZ2rILLSreQWA8/OkYw/AF7IJcfloksS4FWfLY9zwZB/m8aUQRiYmmrwReyK+
         hnCKwagoKuF/9Tb0XHTMPduCPFyXNPYu9KCAPe7I5ID6Am6F2yzf55W4u/pKzEyYlUAs
         wslZOxMJKkUiOVyr1yVa0ha7cC2s2uHlzLuHs55Po0SGZTodgrMBUCdApIaq/ErjA2Zl
         YtuV4yPRt0FDppn8y2OP43dTErcnTPNC6BfW04yshsurubqCNwN9kHhQvbVEf5cPZbYo
         YiOak4fDuGbViDegaKchbfrQNljBA3lMmCljzd8RKnEyI+ZZbM9lBRNaiosvqKWsAdJp
         67IQ==
X-Gm-Message-State: AOAM5303qBQVXyJlmq/RJDCiK5M/U+ot/AeSXx+YDkPmjhsg2MjpGmW1
        K1x07EXGs+59idssLmFF6TWhxJNoRjAZPS1munYPTkn7zY0RLhr/kS9d/XAZVrKrYFXuaBuUUW3
        VHx6YDFCyV761y0d3h6nh1g==
X-Received: by 2002:a17:90a:bd04:: with SMTP id y4mr10929188pjr.9.1633064452182;
        Thu, 30 Sep 2021 22:00:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYYrkLdXRXhRkDFD6dHxyCEJo4umhl98AOrzMByGEHXiQxkYoQ6SgTiGib2NUN7CzaOANYzw==
X-Received: by 2002:a17:90a:bd04:: with SMTP id y4mr10929165pjr.9.1633064451954;
        Thu, 30 Sep 2021 22:00:51 -0700 (PDT)
Received: from localhost.localdomain ([49.207.221.217])
        by smtp.gmail.com with ESMTPSA id s3sm6377485pjr.1.2021.09.30.22.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 22:00:51 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v4 2/2] ceph: add debugfs entries for mount syntax support
Date:   Fri,  1 Oct 2021 10:30:37 +0530
Message-Id: <20211001050037.497199-3-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001050037.497199-1-vshankar@redhat.com>
References: <20211001050037.497199-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/debugfs.c | 41 +++++++++++++++++++++++++++++++++++++++++
 fs/ceph/super.c   |  3 +++
 fs/ceph/super.h   |  2 ++
 3 files changed, 46 insertions(+)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 66989c880adb..d1610393c213 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -22,6 +22,16 @@
 #include "mds_client.h"
 #include "metric.h"
 
+#define META_INFO_DIR_NAME         "meta"
+#define CLIENT_FEATURES_DIR_NAME   "client_features"
+#define MOUNT_DEVICE_V1_SUPPORT_FILE_NAME "mount_syntax_v1"
+#define MOUNT_DEVICE_V2_SUPPORT_FILE_NAME "mount_syntax_v2"
+
+static struct dentry *ceph_client_meta_dir;
+static struct dentry *ceph_client_features_dir;
+static struct dentry *ceph_mount_device_v1_support;
+static struct dentry *ceph_mount_device_v2_support;
+
 static int mdsmap_show(struct seq_file *s, void *p)
 {
 	int i;
@@ -416,6 +426,29 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 						  &status_fops);
 }
 
+void ceph_fs_debugfs_client_features_init(void)
+{
+	ceph_client_meta_dir = debugfs_create_dir(META_INFO_DIR_NAME,
+						  ceph_debugfs_dir);
+	ceph_client_features_dir = debugfs_create_dir(CLIENT_FEATURES_DIR_NAME,
+						      ceph_client_meta_dir);
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
+	debugfs_remove(ceph_client_meta_dir);
+}
 
 #else  /* CONFIG_DEBUG_FS */
 
@@ -427,4 +460,12 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
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


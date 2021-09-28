Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F1B41A8A9
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Sep 2021 08:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238835AbhI1GJe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Sep 2021 02:09:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239810AbhI1GIi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 28 Sep 2021 02:08:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632809218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PRUxXwd6+j8xL0TRZvlF8Y7vcqbw+NN59p0+IJCCfhY=;
        b=TzMGoxdZ/dqhU87lADuRhRB2+Jv8dOXwkC4rllcz399kaHcPhn+DZ8PysV93+gHT3+tpEw
        ZkcA57SmsFFjQHIXT8CYKKPVGM+6trpaKpEWbJ9T/CbTFLa9MMGUxt4wJ7fNZ/NTNbe1+S
        8PuMwBMEkuz3l7GkIzwkL5szirHEPtE=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-pmKeeX1TOXKj-tui2YOfYg-1; Tue, 28 Sep 2021 02:06:54 -0400
X-MC-Unique: pmKeeX1TOXKj-tui2YOfYg-1
Received: by mail-pf1-f197.google.com with SMTP id j199-20020a6280d0000000b004448b89ab5eso13774325pfd.12
        for <ceph-devel@vger.kernel.org>; Mon, 27 Sep 2021 23:06:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PRUxXwd6+j8xL0TRZvlF8Y7vcqbw+NN59p0+IJCCfhY=;
        b=KeMfFLm2oIVcHHJ5NcA3pMP3wWYDzCCpBVjwIFhSW3d6WleoIZWzpUkok2PlzfLXYx
         2nSuKyfG/dlQ5d5azm3V60i9JJIe3C3HDazgnBViyvtHsSTNdZ8lIi74Xpxzn89x6lDd
         tYbEFNVzdEW823LnF9fuv7T3Hn7VRmT0oqKtx8H7FeZkHsuoj4PGyG1wWrN7q3AFehVD
         wxLHZM/iHmmkjMVY7ZnRqcFkYQBOb6oI21llacvroEt8TpMxaeGxI+ho1L45MbouxKPZ
         inmZIeTxbwbx4nlJIIfrmV3yzO9Krk8vUArkrx/l0Bx2tPYuPdGYncHXhA9mis+wJGY1
         UUMQ==
X-Gm-Message-State: AOAM5323zXRVY9SkONBdHTTQM0yQVkUIVBSUanaBuilGUADJKnoH1I8U
        gXYCkMddvoN+M2/GXieQVdu0aygyM5PUFXE1tIwIypvwuocXDH/oSIvnP9GlvhahT6MSuSVnIsp
        JL5WYVopDoSWeVg6ULv3Ixw==
X-Received: by 2002:a17:902:9009:b0:13b:9cae:5dd7 with SMTP id a9-20020a170902900900b0013b9cae5dd7mr3203512plp.53.1632809213700;
        Mon, 27 Sep 2021 23:06:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpfRBZF+sNHVIES80kEKmK4CYOeA6aoDBkVwIcMyNmoHYpTMoecXHHV/ZMigszmg6VniuxKA==
X-Received: by 2002:a17:902:9009:b0:13b:9cae:5dd7 with SMTP id a9-20020a170902900900b0013b9cae5dd7mr3203500plp.53.1632809213463;
        Mon, 27 Sep 2021 23:06:53 -0700 (PDT)
Received: from localhost.localdomain ([49.207.212.118])
        by smtp.gmail.com with ESMTPSA id v6sm18855862pfv.83.2021.09.27.23.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 23:06:53 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v3 2/2] ceph: add debugfs entries for mount syntax support
Date:   Tue, 28 Sep 2021 11:36:33 +0530
Message-Id: <20210928060633.349231-3-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928060633.349231-1-vshankar@redhat.com>
References: <20210928060633.349231-1-vshankar@redhat.com>
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
index 66989c880adb..e61004ec0207 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -22,6 +22,16 @@
 #include "mds_client.h"
 #include "metric.h"
 
+#define META_INFO_DIR_NAME         "meta"
+#define CLIENT_FEATURES_DIR_NAME   "client_features"
+#define MOUNT_DEVICE_V1_SUPPORT_FILE_NAME "v1"
+#define MOUNT_DEVICE_V2_SUPPORT_FILE_NAME "v2"
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


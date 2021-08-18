Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696953EFA88
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 08:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237962AbhHRGCW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 02:02:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55534 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237984AbhHRGCW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 02:02:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629266507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Txdk+Z9WcFuAe77116wHEI/E4dD4MCi85B9Czbih7K0=;
        b=UYH2IAuweRJ9gajdsEK6P7HvMzbL1YDeNwjjpGTB6TPMAIOaBixZ862LEghlM6OyYrLVQb
        UMnGkAHNMo4KVuKKJODjJND2S3TeThUUgmpL9q7BtpuISCLt1lHfYl8QvvgpGe3Ib+k0dp
        9i8/WXT+sq7dRuMd9DG+8M4A5/153AQ=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-_FORBV98MmyoS1WPVhG4OQ-1; Wed, 18 Aug 2021 02:01:46 -0400
X-MC-Unique: _FORBV98MmyoS1WPVhG4OQ-1
Received: by mail-pg1-f199.google.com with SMTP id t28-20020a63461c000000b00252078b83e4so797129pga.15
        for <ceph-devel@vger.kernel.org>; Tue, 17 Aug 2021 23:01:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Txdk+Z9WcFuAe77116wHEI/E4dD4MCi85B9Czbih7K0=;
        b=j6yzmNR9HptUGz7w6xmPBrbykb805TIvfS6RCA+QnUFRsQguXQAWVCMwbtg1t1BJXY
         jVbtcXxYYe3r4YqSUWBzidMP1MHFezTlpu39oVW1LdtK1IWDDshwq06MqiUeYiZrA1no
         SX1dvovpnj4Ee8fL06zlzZ+getLp0UuEyZQvmYCwRtDH3lt4iogG6yqda+MTNJVw8dLZ
         vymQTpbb0Sz0GCFrrpMYJUBBn77HFi5soPsaKYC5Wa0NndJpjYue++1wVGD/FdFRe2Gp
         XNTHCG4GCb6zdP+6sfy+ChtuIp8l3a4EdnV8F0ZTDfKFA/dnIOZ/wSG6UJQmkZXoWKHm
         TCMw==
X-Gm-Message-State: AOAM5329egXZMlfoFkP7srKgf9V2shdq5i/MlrHb3dkyEMXPHhBggUom
        1PrZ8aQ/uasIbSK1RTzS5oLF01FhcwKksqUWHminnRRACTJP0rzTSXgKrqYdDItnWCspp1inobL
        h0WI7AeJ25DfQ1h1aZRMymQ==
X-Received: by 2002:a17:90a:a390:: with SMTP id x16mr7912258pjp.197.1629266505294;
        Tue, 17 Aug 2021 23:01:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvhtkie6FkTg4Ev6ppggEsvjNmGr3tRI+PRHMHs2R1bOcRy9ozhtg8szPk5SU/UYUkzhpbuA==
X-Received: by 2002:a17:90a:a390:: with SMTP id x16mr7912247pjp.197.1629266505128;
        Tue, 17 Aug 2021 23:01:45 -0700 (PDT)
Received: from localhost.localdomain ([49.207.198.118])
        by smtp.gmail.com with ESMTPSA id m28sm5865111pgl.9.2021.08.17.23.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:01:44 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [RFC 1/2] ceph: add helpers to create/cleanup debugfs sub-directories under "ceph" directory
Date:   Wed, 18 Aug 2021 11:31:33 +0530
Message-Id: <20210818060134.208546-2-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818060134.208546-1-vshankar@redhat.com>
References: <20210818060134.208546-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Callers can use this helper to create a subdirectory under
"ceph" directory in debugfs to place custom files for exporting
information to userspace.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 include/linux/ceph/debugfs.h |  3 +++
 net/ceph/debugfs.c           | 26 ++++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/ceph/debugfs.h b/include/linux/ceph/debugfs.h
index 8b3a1a7a953a..c372e6cb8aae 100644
--- a/include/linux/ceph/debugfs.h
+++ b/include/linux/ceph/debugfs.h
@@ -10,5 +10,8 @@ extern void ceph_debugfs_cleanup(void);
 extern void ceph_debugfs_client_init(struct ceph_client *client);
 extern void ceph_debugfs_client_cleanup(struct ceph_client *client);
 
+extern struct dentry *ceph_debugfs_create_subdir(const char *subdir);
+extern void ceph_debugfs_cleanup_subdir(struct dentry *subdir_dentry);
+
 #endif
 
diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
index 2110439f8a24..eabac20b3ff4 100644
--- a/net/ceph/debugfs.c
+++ b/net/ceph/debugfs.c
@@ -404,6 +404,18 @@ void ceph_debugfs_cleanup(void)
 	debugfs_remove(ceph_debugfs_dir);
 }
 
+struct dentry *ceph_debugfs_create_subdir(const char *subdir)
+{
+	return debugfs_create_dir(subdir, ceph_debugfs_dir);
+}
+EXPORT_SYMBOL(ceph_debugfs_create_subdir);
+
+void ceph_debugfs_cleanup_subdir(struct dentry *subdir_dentry)
+{
+	debugfs_remove(subdir_dentry);
+}
+EXPORT_SYMBOL(ceph_debugfs_cleanup_subdir);
+
 void ceph_debugfs_client_init(struct ceph_client *client)
 {
 	char name[80];
@@ -413,7 +425,7 @@ void ceph_debugfs_client_init(struct ceph_client *client)
 
 	dout("ceph_debugfs_client_init %p %s\n", client, name);
 
-	client->debugfs_dir = debugfs_create_dir(name, ceph_debugfs_dir);
+	client->debugfs_dir = ceph_debugfs_create_subdir(name);
 
 	client->monc.debugfs_file = debugfs_create_file("monc",
 						      0400,
@@ -454,7 +466,7 @@ void ceph_debugfs_client_cleanup(struct ceph_client *client)
 	debugfs_remove(client->debugfs_monmap);
 	debugfs_remove(client->osdc.debugfs_file);
 	debugfs_remove(client->monc.debugfs_file);
-	debugfs_remove(client->debugfs_dir);
+	ceph_debugfs_cleanup_subdir(client->debugfs_dir);
 }
 
 #else  /* CONFIG_DEBUG_FS */
@@ -475,4 +487,14 @@ void ceph_debugfs_client_cleanup(struct ceph_client *client)
 {
 }
 
+struct dentry *ceph_debugfs_create_subdir(const char *subdir)
+{
+}
+EXPORT_SYMBOL(ceph_debugfs_create_subdir);
+
+void ceph_debugfs_cleanup_subdir(struct dentry *subdir_dentry)
+{
+}
+EXPORT_SYMBOL(ceph_debugfs_cleanup_subdir);
+
 #endif  /* CONFIG_DEBUG_FS */
-- 
2.27.0


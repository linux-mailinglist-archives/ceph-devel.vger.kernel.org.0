Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA303F1313
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Aug 2021 08:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhHSGHu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Aug 2021 02:07:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229782AbhHSGHt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 02:07:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629353233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fhcGlGyrC8iczV+ic2cEiLl4/K7tUkqIxxdqyXLf2G0=;
        b=h+IzeVwlPeQ/3uzP8SpY9w6wlVEZW9s4MkZkP6SfBrsSD4+UON7eG2ZEP9+geKN4GgoKww
        chc7Yhra0OuMRJhjeF3H4P7j48uQ/D2AEuDkTQ8deFArDwz1R9a3QTmF2Swd2s2q66Dhca
        XHFNdy4/3g1RtavMRuWuzjo6vXZHIXA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-1E4rigVQPLCBq2FVWgYLBQ-1; Thu, 19 Aug 2021 02:07:12 -0400
X-MC-Unique: 1E4rigVQPLCBq2FVWgYLBQ-1
Received: by mail-pj1-f71.google.com with SMTP id 2-20020a17090a1742b0290178de0ca331so2210530pjm.1
        for <ceph-devel@vger.kernel.org>; Wed, 18 Aug 2021 23:07:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fhcGlGyrC8iczV+ic2cEiLl4/K7tUkqIxxdqyXLf2G0=;
        b=GVqEYa/ZBCLw2akZYIQKvIeznoEDt3l0p8zRDQpRdYgj8ZWDnAC9IzxoWwr3ERwQPP
         W/b4seSRAHtszdRtUOpVCtiATbU0AoyKfgLQ78PLD3KLpCZpSCsJk+g0wBPrHzQ/gXFB
         PPRGO5G5+kuC1VjhokxsBGRqAFlAjw/81y01g1laSMCIor10m+rVJu2ewo7N6nKqBkWQ
         WegUML78L4H6lRZJDVIRWLawRIrEqD8eAtIAk3ajvIp2gw2OYkQKTo/J/uddTX9n5P89
         Zl7h+UTSvOFSv8PFtBgUmSpTqBGkf/Ywp6tuKCq8V3pQqumKqPoBpgFhDjnMX5vP7Ihe
         vTNw==
X-Gm-Message-State: AOAM532qo3ODEYj8cUaHFXLNtTpD4KlI3AuHbVFGYmbC8uivOOneQkQY
        RD3v+D4+Z2/mQrXgZKHsC22cscQtrlWHPyDPPI947N+a6sOkS0nJeiDGZ4Os3bbCRTF3U7II3MH
        FT1XXoDTpAXWsPMjvfBSZ7g==
X-Received: by 2002:a17:90a:940e:: with SMTP id r14mr13278578pjo.41.1629353231245;
        Wed, 18 Aug 2021 23:07:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxP5wQS/uKaQdKBtaPeVJ/CPAkooiaxJHDqQpTTkOWBVYe3r7+d2lmx41Y0VBOf6u9vNTGusQ==
X-Received: by 2002:a17:90a:940e:: with SMTP id r14mr13278565pjo.41.1629353231089;
        Wed, 18 Aug 2021 23:07:11 -0700 (PDT)
Received: from localhost.localdomain ([49.207.198.118])
        by smtp.gmail.com with ESMTPSA id o24sm1663100pjs.49.2021.08.18.23.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 23:07:10 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH 1/2] ceph: add helpers to create/cleanup debugfs sub-directories under "ceph" directory
Date:   Thu, 19 Aug 2021 11:37:00 +0530
Message-Id: <20210819060701.25486-2-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210819060701.25486-1-vshankar@redhat.com>
References: <20210819060701.25486-1-vshankar@redhat.com>
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
 net/ceph/debugfs.c           | 27 +++++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

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
index 2110439f8a24..cd6f69dd97fa 100644
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
@@ -475,4 +487,15 @@ void ceph_debugfs_client_cleanup(struct ceph_client *client)
 {
 }
 
+struct dentry *ceph_debugfs_create_subdir(const char *subdir)
+{
+	return NULL;
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


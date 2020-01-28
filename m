Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDC1314C176
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jan 2020 21:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgA1UNW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Jan 2020 15:13:22 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37744 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgA1UNW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 Jan 2020 15:13:22 -0500
Received: by mail-wr1-f67.google.com with SMTP id w15so17614013wru.4
        for <ceph-devel@vger.kernel.org>; Tue, 28 Jan 2020 12:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FJPhYYuMGsCBqs596JAEZWo51K+bs/O1V8cDpq3y4Fk=;
        b=E8xkbZNXimpq646F1BdcfHaJCuSivNtO5YRUw57riiIcvNcQFtCSoFwd78n0GCN04o
         m+56T1HjSp8K4jVA/XbtCXMnCPvJN4Jg7V7olK1BNr22GUZxSYCgoyWXOnmOHzjudO4b
         EQBdOqL4hh4sRM2R2oL7z/biDd8NymNOkM5mbQEpVjh1PxXNYIDbHpHgFc3IF6rA6RkV
         CuhJ5c22b8qEltfQgQMn54j6Wq3vgOB2hfyQQ5JGNiYIFA1h7HS4BdirFrasJ2YB06uc
         uafGxWvNj+aXw84lSkUczyMKUMZP1O5SbbpIDAaVhny9ihvqb/WRz1X6YmMA6bZMfxkn
         iG3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FJPhYYuMGsCBqs596JAEZWo51K+bs/O1V8cDpq3y4Fk=;
        b=lVKoJ1mb6IQe/fNv2IL3/ossZ7vLdqckvVpQsGHihSLhyjERlp6fQCV36tCnufDaqy
         wwZj6XZFUq8ZBlW5qE8kXC1wDKwTaplK/g0LsG9lIyt3mnR1GrHFKlzKEL3BHS7bkaaB
         ikg9l7DVeVf7n/huqXtj2CMEdC9ArteB2oMFcAX8jrEjcK9cGfonOoAykhG1/3lPOdAS
         wUNA1TdbWgALp2zJmxy8Y3Xcgjr77zSVko6m90Jt9nBRuNuLoALKsgoOlnQAudCkAfHy
         6Uz3wbGHertxDpFcN+bwUq+Xa8v4XnrdVZ1nkkVsZNtS0gHgqj554UpEhmxU9CbrzOTW
         idoQ==
X-Gm-Message-State: APjAAAUjGa0nx18wDT5r5awEwZvd054Imh7ui2sQcRIcj9UXwcQXmsUq
        1Bl4X8MZTar8JmXRJ5xImtvY59HAMb4=
X-Google-Smtp-Source: APXvYqzw1AcwOwxihsp+Jzx3zE8C+ohmKXhD+fPxHYiYGlSHd5iVG5VcdlRzB9bVcQtlFZjbT6W2tA==
X-Received: by 2002:a5d:6089:: with SMTP id w9mr30512892wrt.228.1580242400132;
        Tue, 28 Jan 2020 12:13:20 -0800 (PST)
Received: from kwango.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id r3sm2203234wrn.34.2020.01.28.12.13.18
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2020 12:13:18 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] libceph: drop CEPH_DEFINE_SHOW_FUNC
Date:   Tue, 28 Jan 2020 21:13:03 +0100
Message-Id: <20200128201303.16352-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Although CEPH_DEFINE_SHOW_FUNC is much older, it now duplicates
DEFINE_SHOW_ATTRIBUTE from linux/seq_file.h.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/ceph/debugfs.c            | 16 ++++++++--------
 include/linux/ceph/debugfs.h | 14 --------------
 net/ceph/debugfs.c           | 20 ++++++++++----------
 3 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index fb7cabd98e7b..481ac97b4d25 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -218,10 +218,10 @@ static int mds_sessions_show(struct seq_file *s, void *ptr)
 	return 0;
 }
 
-CEPH_DEFINE_SHOW_FUNC(mdsmap_show)
-CEPH_DEFINE_SHOW_FUNC(mdsc_show)
-CEPH_DEFINE_SHOW_FUNC(caps_show)
-CEPH_DEFINE_SHOW_FUNC(mds_sessions_show)
+DEFINE_SHOW_ATTRIBUTE(mdsmap);
+DEFINE_SHOW_ATTRIBUTE(mdsc);
+DEFINE_SHOW_ATTRIBUTE(caps);
+DEFINE_SHOW_ATTRIBUTE(mds_sessions);
 
 
 /*
@@ -281,25 +281,25 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 					0400,
 					fsc->client->debugfs_dir,
 					fsc,
-					&mdsmap_show_fops);
+					&mdsmap_fops);
 
 	fsc->debugfs_mds_sessions = debugfs_create_file("mds_sessions",
 					0400,
 					fsc->client->debugfs_dir,
 					fsc,
-					&mds_sessions_show_fops);
+					&mds_sessions_fops);
 
 	fsc->debugfs_mdsc = debugfs_create_file("mdsc",
 						0400,
 						fsc->client->debugfs_dir,
 						fsc,
-						&mdsc_show_fops);
+						&mdsc_fops);
 
 	fsc->debugfs_caps = debugfs_create_file("caps",
 						   0400,
 						   fsc->client->debugfs_dir,
 						   fsc,
-						   &caps_show_fops);
+						   &caps_fops);
 }
 
 
diff --git a/include/linux/ceph/debugfs.h b/include/linux/ceph/debugfs.h
index cf5e840eec71..8b3a1a7a953a 100644
--- a/include/linux/ceph/debugfs.h
+++ b/include/linux/ceph/debugfs.h
@@ -2,22 +2,8 @@
 #ifndef _FS_CEPH_DEBUGFS_H
 #define _FS_CEPH_DEBUGFS_H
 
-#include <linux/ceph/ceph_debug.h>
 #include <linux/ceph/types.h>
 
-#define CEPH_DEFINE_SHOW_FUNC(name)					\
-static int name##_open(struct inode *inode, struct file *file)		\
-{									\
-	return single_open(file, name, inode->i_private);		\
-}									\
-									\
-static const struct file_operations name##_fops = {			\
-	.open		= name##_open,					\
-	.read		= seq_read,					\
-	.llseek		= seq_lseek,					\
-	.release	= single_release,				\
-};
-
 /* debugfs.c */
 extern void ceph_debugfs_init(void);
 extern void ceph_debugfs_cleanup(void);
diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
index 7cb992e55475..1344f232ecc5 100644
--- a/net/ceph/debugfs.c
+++ b/net/ceph/debugfs.c
@@ -383,11 +383,11 @@ static int client_options_show(struct seq_file *s, void *p)
 	return 0;
 }
 
-CEPH_DEFINE_SHOW_FUNC(monmap_show)
-CEPH_DEFINE_SHOW_FUNC(osdmap_show)
-CEPH_DEFINE_SHOW_FUNC(monc_show)
-CEPH_DEFINE_SHOW_FUNC(osdc_show)
-CEPH_DEFINE_SHOW_FUNC(client_options_show)
+DEFINE_SHOW_ATTRIBUTE(monmap);
+DEFINE_SHOW_ATTRIBUTE(osdmap);
+DEFINE_SHOW_ATTRIBUTE(monc);
+DEFINE_SHOW_ATTRIBUTE(osdc);
+DEFINE_SHOW_ATTRIBUTE(client_options);
 
 void __init ceph_debugfs_init(void)
 {
@@ -414,31 +414,31 @@ void ceph_debugfs_client_init(struct ceph_client *client)
 						      0400,
 						      client->debugfs_dir,
 						      client,
-						      &monc_show_fops);
+						      &monc_fops);
 
 	client->osdc.debugfs_file = debugfs_create_file("osdc",
 						      0400,
 						      client->debugfs_dir,
 						      client,
-						      &osdc_show_fops);
+						      &osdc_fops);
 
 	client->debugfs_monmap = debugfs_create_file("monmap",
 					0400,
 					client->debugfs_dir,
 					client,
-					&monmap_show_fops);
+					&monmap_fops);
 
 	client->debugfs_osdmap = debugfs_create_file("osdmap",
 					0400,
 					client->debugfs_dir,
 					client,
-					&osdmap_show_fops);
+					&osdmap_fops);
 
 	client->debugfs_options = debugfs_create_file("client_options",
 					0400,
 					client->debugfs_dir,
 					client,
-					&client_options_show_fops);
+					&client_options_fops);
 }
 
 void ceph_debugfs_client_cleanup(struct ceph_client *client)
-- 
2.19.2


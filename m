Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C7D158C23
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Feb 2020 10:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgBKJxM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 11 Feb 2020 04:53:12 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34058 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728031AbgBKJxM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 11 Feb 2020 04:53:12 -0500
Received: by mail-wr1-f68.google.com with SMTP id t2so11469343wrr.1
        for <ceph-devel@vger.kernel.org>; Tue, 11 Feb 2020 01:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bf1C+vzUFPb2bJYRCJri6mEYZDUlCQUbiAceo+ucGtk=;
        b=WRo5+c4kZSvVNOd3MIhpiofylVKmakqPOgPYkruZY7+5SVfa2EyW9jemgfMZE8eN1S
         msxB266IoowKOcKWARkkXB0+xRC9gLs6PZVx4qs4DWe1Q6zcez1/dvwdevNs+rPv1Eyb
         Y2/tgqoUN9WHTUcYuJ5mBGEueSsMUwN8zpyHzqU08be6YakJxRmTWhjbApkNY63yolBF
         vbBNs3vPxJh5D1CWyHmx7icUYB7RfeVbsavZxwOYhQpmn9GW3LgR7eV0Ezu5FAG7q4XU
         unwlOMDa5C8cpVXlSXZ/Mcvn8ZDf0Au22x+pW/A3PnxiX6tfRDwBCp+AvxCkbLo9B959
         TbVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bf1C+vzUFPb2bJYRCJri6mEYZDUlCQUbiAceo+ucGtk=;
        b=V/YZlX5yNetX7AZPV1NJ7rYdhn315cZQLygV85n6zfLpe2aQfzqRPyQ15pUxAl6Avk
         h7RHQozWr93RDjhd6ZDu8zfiwdPvjYCBidZy8ZpBDv/7G6lthqfEJ+0uHiWmXjPWdRFi
         lIzhqRkMXKFpq7JQRg37uGBU+EZq+upJf+xbjh62gjKlHxfg7srJzLVwfbFkW0VHH+rP
         QQP14fJqZISmNA83gp3vknU6466HkZpxm3VRHyG0uCOqt7ohagkvSRftN3TRgPn5GlvD
         yIy7wdaYsIB8vq0TD4jVhd7YE4qDubL0twkr8bcSek0lajBmEjHbYSlX356vgSAmPWPk
         T7cQ==
X-Gm-Message-State: APjAAAULLoVmoF47w8w5cYAzu4JQigoArGHufe9pPshTuUOhkMw+Bfxb
        faKkk4gZ1ID2L+QaBGPZJvd/kGzj780=
X-Google-Smtp-Source: APXvYqyY6QaxgTorZsJkXZmn13lJsMIZaaL/erDyYqkSQwQE4Hjwe7rC6fUuWLhj8xKGlZVmcQPt7w==
X-Received: by 2002:adf:f8c8:: with SMTP id f8mr7612018wrq.331.1581414787318;
        Tue, 11 Feb 2020 01:53:07 -0800 (PST)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id c74sm3216305wmd.26.2020.02.11.01.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 01:53:06 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: canonicalize server path in place
Date:   Tue, 11 Feb 2020 10:53:14 +0100
Message-Id: <20200211095314.28931-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

syzbot reported that 4fbc0c711b24 ("ceph: remove the extra slashes in
the server path") had caused a regression where an allocation could be
done under a spinlock -- compare_mount_options() is called by sget_fc()
with sb_lock held.

We don't really need the supplied server path, so canonicalize it
in place and compare it directly.  To make this work, the leading
slash is kept around and the logic in ceph_real_mount() to skip it
is restored.  CEPH_MSG_CLIENT_SESSION now reports the same (i.e.
canonicalized) path, with the leading slash of course.

Fixes: 4fbc0c711b24 ("ceph: remove the extra slashes in the server path")
Reported-by: syzbot+98704a51af8e3d9425a9@syzkaller.appspotmail.com
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/ceph/super.c | 121 +++++++++++-------------------------------------
 fs/ceph/super.h |   2 +-
 2 files changed, 29 insertions(+), 94 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 1d9f083b8a11..64ea34ac330b 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -202,6 +202,26 @@ struct ceph_parse_opts_ctx {
 	struct ceph_mount_options	*opts;
 };
 
+/*
+ * Remove adjacent slashes and then the trailing slash, unless it is
+ * the only remaining character.
+ *
+ * E.g. "//dir1////dir2///" --> "/dir1/dir2", "///" --> "/".
+ */
+static void canonicalize_path(char *path)
+{
+	int i, j = 0;
+
+	for (i = 0; path[i] != '\0'; i++) {
+		if (path[i] != '/' || j < 1 || path[j - 1] != '/')
+			path[j++] = path[i];
+	}
+
+	if (j > 1 && path[j - 1] == '/')
+		j--;
+	path[j] = '\0';
+}
+
 /*
  * Parse the source parameter.  Distinguish the server list from the path.
  *
@@ -224,15 +244,16 @@ static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
 
 	dev_name_end = strchr(dev_name, '/');
 	if (dev_name_end) {
-		kfree(fsopt->server_path);
-
 		/*
 		 * The server_path will include the whole chars from userland
 		 * including the leading '/'.
 		 */
+		kfree(fsopt->server_path);
 		fsopt->server_path = kstrdup(dev_name_end, GFP_KERNEL);
 		if (!fsopt->server_path)
 			return -ENOMEM;
+
+		canonicalize_path(fsopt->server_path);
 	} else {
 		dev_name_end = dev_name + strlen(dev_name);
 	}
@@ -456,73 +477,6 @@ static int strcmp_null(const char *s1, const char *s2)
 	return strcmp(s1, s2);
 }
 
-/**
- * path_remove_extra_slash - Remove the extra slashes in the server path
- * @server_path: the server path and could be NULL
- *
- * Return NULL if the path is NULL or only consists of "/", or a string
- * without any extra slashes including the leading slash(es) and the
- * slash(es) at the end of the server path, such as:
- * "//dir1////dir2///" --> "dir1/dir2"
- */
-static char *path_remove_extra_slash(const char *server_path)
-{
-	const char *path = server_path;
-	const char *cur, *end;
-	char *buf, *p;
-	int len;
-
-	/* if the server path is omitted */
-	if (!path)
-		return NULL;
-
-	/* remove all the leading slashes */
-	while (*path == '/')
-		path++;
-
-	/* if the server path only consists of slashes */
-	if (*path == '\0')
-		return NULL;
-
-	len = strlen(path);
-
-	buf = kmalloc(len + 1, GFP_KERNEL);
-	if (!buf)
-		return ERR_PTR(-ENOMEM);
-
-	end = path + len;
-	p = buf;
-	do {
-		cur = strchr(path, '/');
-		if (!cur)
-			cur = end;
-
-		len = cur - path;
-
-		/* including one '/' */
-		if (cur != end)
-			len += 1;
-
-		memcpy(p, path, len);
-		p += len;
-
-		while (cur <= end && *cur == '/')
-			cur++;
-		path = cur;
-	} while (path < end);
-
-	*p = '\0';
-
-	/*
-	 * remove the last slash if there has and just to make sure that
-	 * we will get something like "dir1/dir2"
-	 */
-	if (*(--p) == '/')
-		*p = '\0';
-
-	return buf;
-}
-
 static int compare_mount_options(struct ceph_mount_options *new_fsopt,
 				 struct ceph_options *new_opt,
 				 struct ceph_fs_client *fsc)
@@ -530,7 +484,6 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
 	struct ceph_mount_options *fsopt1 = new_fsopt;
 	struct ceph_mount_options *fsopt2 = fsc->mount_options;
 	int ofs = offsetof(struct ceph_mount_options, snapdir_name);
-	char *p1, *p2;
 	int ret;
 
 	ret = memcmp(fsopt1, fsopt2, ofs);
@@ -540,21 +493,12 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
 	ret = strcmp_null(fsopt1->snapdir_name, fsopt2->snapdir_name);
 	if (ret)
 		return ret;
+
 	ret = strcmp_null(fsopt1->mds_namespace, fsopt2->mds_namespace);
 	if (ret)
 		return ret;
 
-	p1 = path_remove_extra_slash(fsopt1->server_path);
-	if (IS_ERR(p1))
-		return PTR_ERR(p1);
-	p2 = path_remove_extra_slash(fsopt2->server_path);
-	if (IS_ERR(p2)) {
-		kfree(p1);
-		return PTR_ERR(p2);
-	}
-	ret = strcmp_null(p1, p2);
-	kfree(p1);
-	kfree(p2);
+	ret = strcmp_null(fsopt1->server_path, fsopt2->server_path);
 	if (ret)
 		return ret;
 
@@ -957,7 +901,9 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
 	mutex_lock(&fsc->client->mount_mutex);
 
 	if (!fsc->sb->s_root) {
-		const char *path, *p;
+		const char *path = fsc->mount_options->server_path ?
+				     fsc->mount_options->server_path + 1 : "";
+
 		err = __ceph_open_session(fsc->client, started);
 		if (err < 0)
 			goto out;
@@ -969,22 +915,11 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
 				goto out;
 		}
 
-		p = path_remove_extra_slash(fsc->mount_options->server_path);
-		if (IS_ERR(p)) {
-			err = PTR_ERR(p);
-			goto out;
-		}
-		/* if the server path is omitted or just consists of '/' */
-		if (!p)
-			path = "";
-		else
-			path = p;
 		dout("mount opening path '%s'\n", path);
 
 		ceph_fs_debugfs_init(fsc);
 
 		root = open_root_dentry(fsc, path, started);
-		kfree(p);
 		if (IS_ERR(root)) {
 			err = PTR_ERR(root);
 			goto out;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 1e456a9011bb..037cdfb2ad4f 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -91,7 +91,7 @@ struct ceph_mount_options {
 
 	char *snapdir_name;   /* default ".snap" */
 	char *mds_namespace;  /* default NULL */
-	char *server_path;    /* default  "/" */
+	char *server_path;    /* default NULL (means "/") */
 	char *fscache_uniq;   /* default NULL */
 };
 
-- 
2.19.2


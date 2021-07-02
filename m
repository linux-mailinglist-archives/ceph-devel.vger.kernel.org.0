Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAD83B9C52
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jul 2021 08:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhGBGvH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Jul 2021 02:51:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32791 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230023AbhGBGvH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Jul 2021 02:51:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625208515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WKNZAU5queF8fQ46T77fEfBottUlScrcMFaauzrSZ/c=;
        b=NyFa4WgSMzOtEW6LNT2y7zHfudJNXtfy08zVKPmWKR8bHYBVUXmqAFB8LE3ai2Rdpc3D/8
        Ffx6dgRZ0FTP1d5X8Ur4c/igGr+i0AVKdiECJ3LJSY05rr/MbTtdnu9GPi4zT9J1NxWwQH
        Pk3uDJHiDk62VEVET6hk/OSRQqaKy9w=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-MQ3wxm7jOYiYl5GQsyVszA-1; Fri, 02 Jul 2021 02:48:33 -0400
X-MC-Unique: MQ3wxm7jOYiYl5GQsyVszA-1
Received: by mail-pf1-f200.google.com with SMTP id g17-20020a6252110000b029030423e1ef64so5648095pfb.18
        for <ceph-devel@vger.kernel.org>; Thu, 01 Jul 2021 23:48:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WKNZAU5queF8fQ46T77fEfBottUlScrcMFaauzrSZ/c=;
        b=P7vBGUsc9dTQvUUPSJRBLf5ZScJ0PKGtZuUh68LZRp1wlIwhuAq0cZHGAgZu4lZKo+
         8m7NQgOFWm0gmsVBh+IRd9IRbkhF9vzAaxn0u5wJLb8AeWuukoOmfhipaLGHFSIUcm31
         b08PRJ0H9tf+FQK92FNYjVFs+DxwrGt89ksmzNPgxH+Q6Uh5r6IDoAq4P1qyMcYph5Jl
         S3LLjw8fyKiPFN62I4dtyjaJn8cnaJkwRJpjTpCAMbjnYd2lqPfTt/dbO8tflcoa4Vlm
         oaeSj1GZuV2bBf55mHeeHdxdTQy0Fxz9jFaTEY0wBqdqqCGu7U0fzN3iQ2Qq9IbG5p4y
         mRkQ==
X-Gm-Message-State: AOAM530cOMM5PZ2O4eWW4uBVxe+BAwCUp1QZKc/m4qkxz6m3bkAPPBnA
        J25HwIFE1fADBXzNL21+edOaZ1fOb5KFJu2jqLu7pD4Gge416wQ/X3iCl115gRQS5iRntsSds5/
        dq84RAAPbXVNUVKk5u+2qMw==
X-Received: by 2002:a17:90a:8407:: with SMTP id j7mr14030598pjn.13.1625208512202;
        Thu, 01 Jul 2021 23:48:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8BgwFG52D5VVtUy0iBhUuKHQbkH88KzM4YDqw6bi4ZwuIeh6BM+ZkIeOiluNZEQL05fP5VQ==
X-Received: by 2002:a17:90a:8407:: with SMTP id j7mr14030580pjn.13.1625208511957;
        Thu, 01 Jul 2021 23:48:31 -0700 (PDT)
Received: from localhost.localdomain ([49.207.212.118])
        by smtp.gmail.com with ESMTPSA id o34sm2394364pgm.6.2021.07.01.23.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 23:48:31 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com, lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v2 1/4] ceph: new device mount syntax
Date:   Fri,  2 Jul 2021 12:18:18 +0530
Message-Id: <20210702064821.148063-2-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210702064821.148063-1-vshankar@redhat.com>
References: <20210702064821.148063-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Old mount device syntax (source) has the following problems:

- mounts to the same cluster but with different fsnames
  and/or creds have identical device string which can
  confuse xfstests.

- Userspace mount helper tool resolves monitor addresses
  and fill in mon addrs automatically, but that means the
  device shown in /proc/mounts is different than what was
  used for mounting.

New device syntax is as follows:

  cephuser@fsid.mycephfs2=/path

Note, there is no "monitor address" in the device string.
That gets passed in as mount option. This keeps the device
string same when monitor addresses change (on remounts).

Also note that the userspace mount helper tool is backward
compatible. I.e., the mount helper will fallback to using
old syntax after trying to mount with the new syntax.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/super.c | 122 ++++++++++++++++++++++++++++++++++++++++++++----
 fs/ceph/super.h |   3 ++
 2 files changed, 115 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 9b1b7f4cfdd4..0b324e43c9f4 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -145,6 +145,7 @@ enum {
 	Opt_mds_namespace,
 	Opt_recover_session,
 	Opt_source,
+	Opt_mon_addr,
 	/* string args above */
 	Opt_dirstat,
 	Opt_rbytes,
@@ -196,6 +197,7 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
 	fsparam_u32	("rsize",			Opt_rsize),
 	fsparam_string	("snapdirname",			Opt_snapdirname),
 	fsparam_string	("source",			Opt_source),
+	fsparam_string	("mon_addr",			Opt_mon_addr),
 	fsparam_u32	("wsize",			Opt_wsize),
 	fsparam_flag_no	("wsync",			Opt_wsync),
 	{}
@@ -226,10 +228,70 @@ static void canonicalize_path(char *path)
 	path[j] = '\0';
 }
 
+static int ceph_parse_old_source(const char *dev_name, const char *dev_name_end,
+				 struct fs_context *fc)
+{
+	int r;
+	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
+	struct ceph_mount_options *fsopt = pctx->opts;
+
+	if (*dev_name_end != ':')
+		return invalfc(fc, "separator ':' missing in source");
+
+	r = ceph_parse_mon_ips(dev_name, dev_name_end - dev_name,
+			       pctx->copts, fc->log.log);
+	if (r)
+		return r;
+
+	fsopt->new_dev_syntax = false;
+	return 0;
+}
+
+static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
+				 struct fs_context *fc)
+{
+	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
+	struct ceph_mount_options *fsopt = pctx->opts;
+	char *fsid_start, *fs_name_start;
+
+	if (*dev_name_end != '=') {
+		dout("separator '=' missing in source");
+		return -EINVAL;
+	}
+
+	fsid_start = strchr(dev_name, '@');
+	if (!fsid_start)
+		return invalfc(fc, "missing cluster fsid");
+	++fsid_start; /* start of cluster fsid */
+
+	fs_name_start = strchr(fsid_start, '.');
+	if (!fs_name_start)
+		return invalfc(fc, "missing file system name");
+
+	++fs_name_start; /* start of file system name */
+	fsopt->mds_namespace = kstrndup(fs_name_start,
+					dev_name_end - fs_name_start, GFP_KERNEL);
+	if (!fsopt->mds_namespace)
+		return -ENOMEM;
+	dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
+
+	fsopt->new_dev_syntax = true;
+	return 0;
+}
+
 /*
- * Parse the source parameter.  Distinguish the server list from the path.
+ * Parse the source parameter for new device format. Distinguish the device
+ * spec from the path. Try parsing new device format and fallback to old
+ * format if needed.
  *
- * The source will look like:
+ * New device syntax will looks like:
+ *     <device_spec>=/<path>
+ * where
+ *     <device_spec> is name@fsid.fsname
+ *     <path> is optional, but if present must begin with '/'
+ * (monitor addresses are passed via mount option)
+ *
+ * Old device syntax is:
  *     <server_spec>[,<server_spec>...]:[<path>]
  * where
  *     <server_spec> is <ip>[:<port>]
@@ -262,22 +324,48 @@ static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
 		dev_name_end = dev_name + strlen(dev_name);
 	}
 
-	dev_name_end--;		/* back up to ':' separator */
-	if (dev_name_end < dev_name || *dev_name_end != ':')
-		return invalfc(fc, "No path or : separator in source");
+	dev_name_end--;		/* back up to separator */
+	if (dev_name_end < dev_name)
+		return invalfc(fc, "path missing in source");
 
 	dout("device name '%.*s'\n", (int)(dev_name_end - dev_name), dev_name);
 	if (fsopt->server_path)
 		dout("server path '%s'\n", fsopt->server_path);
 
-	ret = ceph_parse_mon_ips(param->string, dev_name_end - dev_name,
-				 pctx->copts, fc->log.log);
+	dout("trying new device syntax");
+	ret = ceph_parse_new_source(dev_name, dev_name_end, fc);
+	if (ret == 0)
+		goto done;
+
+	dout("trying old device syntax");
+	ret = ceph_parse_old_source(dev_name, dev_name_end, fc);
 	if (ret)
-		return ret;
+		goto out;
 
+ done:
 	fc->source = param->string;
 	param->string = NULL;
-	return 0;
+ out:
+	return ret;
+}
+
+static int ceph_parse_mon_addr(struct fs_parameter *param,
+			       struct fs_context *fc)
+{
+	int r;
+	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
+	struct ceph_mount_options *fsopt = pctx->opts;
+
+	kfree(fsopt->mon_addr);
+	fsopt->mon_addr = param->string;
+	param->string = NULL;
+
+	strreplace(fsopt->mon_addr, '/', ',');
+	r = ceph_parse_mon_ips(fsopt->mon_addr, strlen(fsopt->mon_addr),
+			       pctx->copts, fc->log.log);
+        // since its used in ceph_show_options()
+	strreplace(fsopt->mon_addr, ',', '/');
+	return r;
 }
 
 static int ceph_parse_mount_param(struct fs_context *fc,
@@ -322,6 +410,8 @@ static int ceph_parse_mount_param(struct fs_context *fc,
 		if (fc->source)
 			return invalfc(fc, "Multiple sources specified");
 		return ceph_parse_source(param, fc);
+	case Opt_mon_addr:
+		return ceph_parse_mon_addr(param, fc);
 	case Opt_wsize:
 		if (result.uint_32 < PAGE_SIZE ||
 		    result.uint_32 > CEPH_MAX_WRITE_SIZE)
@@ -473,6 +563,7 @@ static void destroy_mount_options(struct ceph_mount_options *args)
 	kfree(args->mds_namespace);
 	kfree(args->server_path);
 	kfree(args->fscache_uniq);
+	kfree(args->mon_addr);
 	kfree(args);
 }
 
@@ -516,6 +607,10 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
 	if (ret)
 		return ret;
 
+	ret = strcmp_null(fsopt1->mon_addr, fsopt2->mon_addr);
+	if (ret)
+		return ret;
+
 	return ceph_compare_options(new_opt, fsc->client);
 }
 
@@ -571,9 +666,13 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
 	if ((fsopt->flags & CEPH_MOUNT_OPT_NOCOPYFROM) == 0)
 		seq_puts(m, ",copyfrom");
 
-	if (fsopt->mds_namespace)
+	/* dump mds_namespace when old device syntax is in use */
+	if (fsopt->mds_namespace && !fsopt->new_dev_syntax)
 		seq_show_option(m, "mds_namespace", fsopt->mds_namespace);
 
+	if (fsopt->mon_addr)
+		seq_printf(m, ",mon_addr=%s", fsopt->mon_addr);
+
 	if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
 		seq_show_option(m, "recover_session", "clean");
 
@@ -1048,6 +1147,7 @@ static int ceph_setup_bdi(struct super_block *sb, struct ceph_fs_client *fsc)
 static int ceph_get_tree(struct fs_context *fc)
 {
 	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
+	struct ceph_mount_options *fsopt = pctx->opts;
 	struct super_block *sb;
 	struct ceph_fs_client *fsc;
 	struct dentry *res;
@@ -1059,6 +1159,8 @@ static int ceph_get_tree(struct fs_context *fc)
 
 	if (!fc->source)
 		return invalfc(fc, "No source");
+	if (fsopt->new_dev_syntax && !fsopt->mon_addr)
+		return invalfc(fc, "No monitor address");
 
 	/* create client (which we may/may not use) */
 	fsc = create_fs_client(pctx->opts, pctx->copts);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index c48bb30c8d70..8f71184b7c85 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -87,6 +87,8 @@ struct ceph_mount_options {
 	unsigned int max_readdir;       /* max readdir result (entries) */
 	unsigned int max_readdir_bytes; /* max readdir result (bytes) */
 
+	bool new_dev_syntax;
+
 	/*
 	 * everything above this point can be memcmp'd; everything below
 	 * is handled in compare_mount_options()
@@ -96,6 +98,7 @@ struct ceph_mount_options {
 	char *mds_namespace;  /* default NULL */
 	char *server_path;    /* default NULL (means "/") */
 	char *fscache_uniq;   /* default NULL */
+	char *mon_addr;
 };
 
 struct ceph_fs_client {
-- 
2.27.0


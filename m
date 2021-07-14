Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD843C8269
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jul 2021 12:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239068AbhGNKJK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Jul 2021 06:09:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37556 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239059AbhGNKJJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 14 Jul 2021 06:09:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626257177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0jwwixyvWLE/tYvJDMsiIgPP8h/eQ5+rOZUun6nPm4w=;
        b=Ys7VkEniwIoSBvNcDbq9AsJP98JjGQvoSOWyK0s3CMJq7Aa9YFUauvZwCjM56lY8YGlmht
        S6pzcCMC2dvJgeaJcNZzyxeRkO+XajKwemGW+h7X4PS8cbiCe+1NOa2VbskNE++ZQreNEP
        U52WHjX4gQPcjyZ7iF3UexNeCRAAf8Y=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-YhX3WOGrPuusT6UTmO-XrA-1; Wed, 14 Jul 2021 06:06:16 -0400
X-MC-Unique: YhX3WOGrPuusT6UTmO-XrA-1
Received: by mail-pj1-f70.google.com with SMTP id p22-20020a17090a9316b029016a0aced749so970821pjo.9
        for <ceph-devel@vger.kernel.org>; Wed, 14 Jul 2021 03:06:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0jwwixyvWLE/tYvJDMsiIgPP8h/eQ5+rOZUun6nPm4w=;
        b=Tl5asdLYPtjCXEBmg0oSYxhoWWcxHseoXH1mLJNW1jx+qW/KrxnX6WIrYbenKV3iRT
         T0ViLVxnXgHHhSB4tzKesfrqh5uPURpT815CvsQYaDqp6kgU2BnNafuQg2SidRWpxGo4
         qFElgQfQkpRaK15brb8wTjeLPXVQPSfBFGIX+YbmwqHkHhrLggs32PtI0BObU/Bo7ELn
         7FfOX4uEupvLBggXGPmVy74XqWv1uqtuHTXpcz2YxUjzlSND1j7s+GPA5C1LX9wkvdTJ
         cg2hQ8H41RGK6luUCZq+qaAaHUn6OrnTuaOuWz2/9AmC62pv3197zzBx0PAPONlwk4Nl
         h/Bg==
X-Gm-Message-State: AOAM533iZq4KdmwKlTPdMcZHgHQ0J8b0eKwLt7Nbhyw119y7gkQwyG3s
        7Ln5aP97au0dQCtawu68B7PiA9+gBiAEiLnZjU2olhDfoFcqmxhGMlnGDtJaSYl2NhtnT6jOoEY
        R8rrpA6zuM/vtfMUB0WvPTA==
X-Received: by 2002:a17:90b:fd1:: with SMTP id gd17mr4836974pjb.41.1626257175346;
        Wed, 14 Jul 2021 03:06:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyN0o0Cgy+D8SXd8I3hEDRUz3sCsmh2P8HFLvul3JMGz1K9irjpZ15YUdQfh7RazFIdueDafQ==
X-Received: by 2002:a17:90b:fd1:: with SMTP id gd17mr4836950pjb.41.1626257175078;
        Wed, 14 Jul 2021 03:06:15 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.217.185])
        by smtp.gmail.com with ESMTPSA id 125sm2227030pfg.52.2021.07.14.03.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 03:06:14 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com, lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v4 3/5] ceph: new device mount syntax
Date:   Wed, 14 Jul 2021 15:35:52 +0530
Message-Id: <20210714100554.85978-4-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714100554.85978-1-vshankar@redhat.com>
References: <20210714100554.85978-1-vshankar@redhat.com>
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
 fs/ceph/super.c | 145 ++++++++++++++++++++++++++++++++++++++++++++----
 fs/ceph/super.h |   3 +
 2 files changed, 137 insertions(+), 11 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 039775553a88..d8c6168b7fcd 100644
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
@@ -227,9 +229,93 @@ static void canonicalize_path(char *path)
 }
 
 /*
- * Parse the source parameter.  Distinguish the server list from the path.
+ * Check if the mds namespace in ceph_mount_options matches
+ * the passed in namespace string. First time match (when
+ * ->mds_namespace is NULL) is treated specially, since
+ * ->mds_namespace needs to be initialized by the caller.
+ */
+static int namespace_equals(struct ceph_mount_options *fsopt,
+			    const char *namespace, size_t len)
+{
+	return !(fsopt->mds_namespace &&
+		 (strlen(fsopt->mds_namespace) != len ||
+		  strncmp(fsopt->mds_namespace, namespace, len)));
+}
+
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
+			       pctx->copts, fc->log.log,
+			       CEPH_ADDR_PARSE_DEFAULT_DELIM);
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
+	size_t len;
+	struct ceph_fsid fsid;
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
+	if (ceph_parse_fsid(fsid_start, &fsid))
+		return invalfc(fc, "Invalid FSID");
+
+	++fs_name_start; /* start of file system name */
+	len = dev_name_end - fs_name_start;
+
+	if (!namespace_equals(fsopt, fs_name_start, len))
+		return invalfc(fc, "Mismatching mds_namespace");
+	kfree(fsopt->mds_namespace);
+	fsopt->mds_namespace = kstrndup(fs_name_start, len, GFP_KERNEL);
+	if (!fsopt->mds_namespace)
+		return -ENOMEM;
+	dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
+
+	fsopt->new_dev_syntax = true;
+	return 0;
+}
+
+/*
+ * Parse the source parameter for new device format. Distinguish the device
+ * spec from the path. Try parsing new device format and fallback to old
+ * format if needed.
+ *
+ * New device syntax will looks like:
+ *     <device_spec>=/<path>
+ * where
+ *     <device_spec> is name@fsid.fsname
+ *     <path> is optional, but if present must begin with '/'
+ * (monitor addresses are passed via mount option)
  *
- * The source will look like:
+ * Old device syntax is:
  *     <server_spec>[,<server_spec>...]:[<path>]
  * where
  *     <server_spec> is <ip>[:<port>]
@@ -262,25 +348,46 @@ static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
 		dev_name_end = dev_name + strlen(dev_name);
 	}
 
-	dev_name_end--;		/* back up to ':' separator */
-	if (dev_name_end < dev_name || *dev_name_end != ':')
-		return invalfc(fc, "No path or : separator in source");
+	dev_name_end--;		/* back up to separator */
+	if (dev_name_end < dev_name)
+		return invalfc(fc, "Path missing in source");
 
 	dout("device name '%.*s'\n", (int)(dev_name_end - dev_name), dev_name);
 	if (fsopt->server_path)
 		dout("server path '%s'\n", fsopt->server_path);
 
-	ret = ceph_parse_mon_ips(param->string, dev_name_end - dev_name,
-				 pctx->copts, fc->log.log,
-				 CEPH_ADDR_PARSE_DEFAULT_DELIM);
-	if (ret)
-		return ret;
+	dout("trying new device syntax");
+	ret = ceph_parse_new_source(dev_name, dev_name_end, fc);
+	if (ret) {
+		if (ret != -EINVAL)
+			return ret;
+		dout("trying old device syntax");
+		ret = ceph_parse_old_source(dev_name, dev_name_end, fc);
+		if (ret)
+			return ret;
+	}
 
 	fc->source = param->string;
 	param->string = NULL;
 	return 0;
 }
 
+#define CEPH_MON_ADDR_MNTOPT_DELIM '/'
+static int ceph_parse_mon_addr(struct fs_parameter *param,
+			       struct fs_context *fc)
+{
+	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
+	struct ceph_mount_options *fsopt = pctx->opts;
+
+	kfree(fsopt->mon_addr);
+	fsopt->mon_addr = param->string;
+	param->string = NULL;
+
+	return ceph_parse_mon_ips(fsopt->mon_addr, strlen(fsopt->mon_addr),
+				  pctx->copts, fc->log.log,
+				  CEPH_MON_ADDR_MNTOPT_DELIM);
+}
+
 static int ceph_parse_mount_param(struct fs_context *fc,
 				  struct fs_parameter *param)
 {
@@ -306,6 +413,8 @@ static int ceph_parse_mount_param(struct fs_context *fc,
 		param->string = NULL;
 		break;
 	case Opt_mds_namespace:
+		if (!namespace_equals(fsopt, param->string, strlen(param->string)))
+			return invalfc(fc, "Mismatching mds_namespace");
 		kfree(fsopt->mds_namespace);
 		fsopt->mds_namespace = param->string;
 		param->string = NULL;
@@ -323,6 +432,8 @@ static int ceph_parse_mount_param(struct fs_context *fc,
 		if (fc->source)
 			return invalfc(fc, "Multiple sources specified");
 		return ceph_parse_source(param, fc);
+	case Opt_mon_addr:
+		return ceph_parse_mon_addr(param, fc);
 	case Opt_wsize:
 		if (result.uint_32 < PAGE_SIZE ||
 		    result.uint_32 > CEPH_MAX_WRITE_SIZE)
@@ -474,6 +585,7 @@ static void destroy_mount_options(struct ceph_mount_options *args)
 	kfree(args->mds_namespace);
 	kfree(args->server_path);
 	kfree(args->fscache_uniq);
+	kfree(args->mon_addr);
 	kfree(args);
 }
 
@@ -517,6 +629,10 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
 	if (ret)
 		return ret;
 
+	ret = strcmp_null(fsopt1->mon_addr, fsopt2->mon_addr);
+	if (ret)
+		return ret;
+
 	return ceph_compare_options(new_opt, fsc->client);
 }
 
@@ -572,9 +688,13 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
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
 
@@ -1049,6 +1169,7 @@ static int ceph_setup_bdi(struct super_block *sb, struct ceph_fs_client *fsc)
 static int ceph_get_tree(struct fs_context *fc)
 {
 	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
+	struct ceph_mount_options *fsopt = pctx->opts;
 	struct super_block *sb;
 	struct ceph_fs_client *fsc;
 	struct dentry *res;
@@ -1060,6 +1181,8 @@ static int ceph_get_tree(struct fs_context *fc)
 
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


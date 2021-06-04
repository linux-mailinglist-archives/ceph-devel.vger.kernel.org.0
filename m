Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0954C39B1CF
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Jun 2021 07:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhFDFHV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Jun 2021 01:07:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229826AbhFDFHV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 4 Jun 2021 01:07:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622783135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uBzG35ilP/bpTLtz/YegyzZWkOpHHA+iNvg+Mvv6+dk=;
        b=gFTcfgFfAqtIODd9aFnMOlG6oqefNzfvToDYqX+z2MwGEl5+joHIQUKTlDxTG6iicCeTb3
        8Ng3A+BD/7rz/nHazF62LhEMjEIF25wI2B+12fQf1UrAnvA6xvoh8qWoM5NCapwPcR5Vaw
        O/NoLrFB98wdKKWs7Y9lpLXUfDvXbrQ=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-wMqmLKt7N_2-0mcb99fp3w-1; Fri, 04 Jun 2021 01:05:34 -0400
X-MC-Unique: wMqmLKt7N_2-0mcb99fp3w-1
Received: by mail-pg1-f198.google.com with SMTP id 135-20020a63038d0000b0290220201658a7so5312678pgd.21
        for <ceph-devel@vger.kernel.org>; Thu, 03 Jun 2021 22:05:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uBzG35ilP/bpTLtz/YegyzZWkOpHHA+iNvg+Mvv6+dk=;
        b=VOujyHOyCQ+++cUBtOKwahpCfXaC24hivnK13JRmDLvTNnu7/eyQv7EgaEVZlUAbgg
         A3gnjt3Td4xe7xaP8U07fql7TrfGgvksWwfig/4iQRbuYgRWpAJDDiTHV9AyxSaD5upE
         bU/zawnoZ2lymgj01b9W4e3sFkz4lmUl8bZ0RVOV9WkZnGXtUb07xu31kGI9QnlBBKFO
         1FskeSpayT/b18tg12Y9dFkMrDy56Ep4RIshzV/PnONmsmpIIOok1/wsZ9B9KIS0wwv7
         XjDGC7oTjXU93iDJJB2v+L2UkUo3a8qO/537WqRbR3jGaMC2ygmzz8wafTx9gx4MgXO1
         Ru+Q==
X-Gm-Message-State: AOAM532PV8Jcl95xc3A5aVD624fWpDLOtGysZ/ARyMtYq1M6ggncrL7C
        dbpGIU3Y2AwD51FIgg9xV+TuvpVmMVWqdON1xyt9r+40SpVC3MYjXtPa3tMiM3g/F3onWrkzx9n
        ujAzjgJ+TmbHG3ALnUImsIQ==
X-Received: by 2002:a05:6a00:1685:b029:2da:df4b:b8b with SMTP id k5-20020a056a001685b02902dadf4b0b8bmr2706431pfc.16.1622783133127;
        Thu, 03 Jun 2021 22:05:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYYtohy3Q4o8jTXcyVb2KIRFblZntGJjeJlBAOBC8ExfqrQyVNOPUvKdMtiBMQb4UiSATosQ==
X-Received: by 2002:a05:6a00:1685:b029:2da:df4b:b8b with SMTP id k5-20020a056a001685b02902dadf4b0b8bmr2706415pfc.16.1622783132884;
        Thu, 03 Jun 2021 22:05:32 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.207.151])
        by smtp.gmail.com with ESMTPSA id s20sm3634897pjn.23.2021.06.03.22.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 22:05:32 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@kernel.org
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH 1/3] ceph: new device mount syntax
Date:   Fri,  4 Jun 2021 10:35:10 +0530
Message-Id: <20210604050512.552649-2-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604050512.552649-1-vshankar@redhat.com>
References: <20210604050512.552649-1-vshankar@redhat.com>
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

  cephuser@mycephfs2=/path

Note, there is no "monitor address" in the device string.
That gets passed in as mount option. This keeps the device
string same when monitor addresses change (on remounts).

Also note that the userspace mount helper tool is backward
compatible. I.e., the mount helper will fallback to using
old syntax after trying to mount with the new syntax.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/super.c | 69 +++++++++++++++++++++++++++++++++----------------
 fs/ceph/super.h |  1 +
 2 files changed, 48 insertions(+), 22 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 9b1b7f4cfdd4..e273eabb0397 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -142,9 +142,9 @@ enum {
 	Opt_congestion_kb,
 	/* int args above */
 	Opt_snapdirname,
-	Opt_mds_namespace,
 	Opt_recover_session,
 	Opt_source,
+	Opt_mon_addr,
 	/* string args above */
 	Opt_dirstat,
 	Opt_rbytes,
@@ -184,7 +184,6 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
 	fsparam_flag_no	("fsc",				Opt_fscache), // fsc|nofsc
 	fsparam_string	("fsc",				Opt_fscache), // fsc=...
 	fsparam_flag_no ("ino32",			Opt_ino32),
-	fsparam_string	("mds_namespace",		Opt_mds_namespace),
 	fsparam_flag_no ("poolperm",			Opt_poolperm),
 	fsparam_flag_no ("quotadf",			Opt_quotadf),
 	fsparam_u32	("rasize",			Opt_rasize),
@@ -196,6 +195,7 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
 	fsparam_u32	("rsize",			Opt_rsize),
 	fsparam_string	("snapdirname",			Opt_snapdirname),
 	fsparam_string	("source",			Opt_source),
+	fsparam_string	("mon_addr",			Opt_mon_addr),
 	fsparam_u32	("wsize",			Opt_wsize),
 	fsparam_flag_no	("wsync",			Opt_wsync),
 	{}
@@ -227,12 +227,12 @@ static void canonicalize_path(char *path)
 }
 
 /*
- * Parse the source parameter.  Distinguish the server list from the path.
+ * Parse the source parameter.  Distinguish the device spec from the path.
  *
  * The source will look like:
- *     <server_spec>[,<server_spec>...]:[<path>]
+ *     <device_spec>=/<path>
  * where
- *     <server_spec> is <ip>[:<port>]
+ *     <device_spec> is name@fsname
  *     <path> is optional, but if present must begin with '/'
  */
 static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
@@ -240,12 +240,17 @@ static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
 	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
 	struct ceph_mount_options *fsopt = pctx->opts;
 	char *dev_name = param->string, *dev_name_end;
-	int ret;
+	char *fs_name_start;
 
 	dout("%s '%s'\n", __func__, dev_name);
 	if (!dev_name || !*dev_name)
 		return invalfc(fc, "Empty source");
 
+	fs_name_start = strchr(dev_name, '@');
+	if (!fs_name_start)
+		return invalfc(fc, "Missing file system name");
+	++fs_name_start; /* start of file system name */
+
 	dev_name_end = strchr(dev_name, '/');
 	if (dev_name_end) {
 		/*
@@ -262,24 +267,42 @@ static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
 		dev_name_end = dev_name + strlen(dev_name);
 	}
 
-	dev_name_end--;		/* back up to ':' separator */
-	if (dev_name_end < dev_name || *dev_name_end != ':')
-		return invalfc(fc, "No path or : separator in source");
+	dev_name_end--;		/* back up to '=' separator */
+	if (dev_name_end < dev_name || *dev_name_end != '=')
+		return invalfc(fc, "No path or = separator in source");
 
 	dout("device name '%.*s'\n", (int)(dev_name_end - dev_name), dev_name);
-	if (fsopt->server_path)
-		dout("server path '%s'\n", fsopt->server_path);
 
-	ret = ceph_parse_mon_ips(param->string, dev_name_end - dev_name,
-				 pctx->copts, fc->log.log);
-	if (ret)
-		return ret;
+	fsopt->mds_namespace = kstrndup(fs_name_start,
+					dev_name_end - fs_name_start, GFP_KERNEL);
+	dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
 
+	if (fsopt->server_path)
+		dout("server path '%s'\n", fsopt->server_path);
 	fc->source = param->string;
 	param->string = NULL;
 	return 0;
 }
 
+static int ceph_parse_mon_addr(struct fs_parameter *param,
+			       struct fs_context *fc)
+{
+	int r;
+	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
+	struct ceph_mount_options *fsopt = pctx->opts;
+
+	kfree(fsopt->mon_addr);
+	fsopt->mon_addr = kstrdup(param->string, GFP_KERNEL);
+	if (!fsopt->mon_addr)
+		return -ENOMEM;
+
+	strreplace(param->string, '/', ',');
+	r = ceph_parse_mon_ips(param->string, strlen(param->string),
+			       pctx->copts, fc->log.log);
+	param->string = NULL;
+	return r;
+}
+
 static int ceph_parse_mount_param(struct fs_context *fc,
 				  struct fs_parameter *param)
 {
@@ -304,11 +327,6 @@ static int ceph_parse_mount_param(struct fs_context *fc,
 		fsopt->snapdir_name = param->string;
 		param->string = NULL;
 		break;
-	case Opt_mds_namespace:
-		kfree(fsopt->mds_namespace);
-		fsopt->mds_namespace = param->string;
-		param->string = NULL;
-		break;
 	case Opt_recover_session:
 		mode = result.uint_32;
 		if (mode == ceph_recover_session_no)
@@ -322,6 +340,8 @@ static int ceph_parse_mount_param(struct fs_context *fc,
 		if (fc->source)
 			return invalfc(fc, "Multiple sources specified");
 		return ceph_parse_source(param, fc);
+	case Opt_mon_addr:
+		return ceph_parse_mon_addr(param, fc);
 	case Opt_wsize:
 		if (result.uint_32 < PAGE_SIZE ||
 		    result.uint_32 > CEPH_MAX_WRITE_SIZE)
@@ -473,6 +493,7 @@ static void destroy_mount_options(struct ceph_mount_options *args)
 	kfree(args->mds_namespace);
 	kfree(args->server_path);
 	kfree(args->fscache_uniq);
+	kfree(args->mon_addr);
 	kfree(args);
 }
 
@@ -516,6 +537,10 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
 	if (ret)
 		return ret;
 
+	ret = strcmp_null(fsopt1->mon_addr, fsopt2->mon_addr);
+	if (ret)
+		return ret;
+
 	return ceph_compare_options(new_opt, fsc->client);
 }
 
@@ -571,8 +596,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
 	if ((fsopt->flags & CEPH_MOUNT_OPT_NOCOPYFROM) == 0)
 		seq_puts(m, ",copyfrom");
 
-	if (fsopt->mds_namespace)
-		seq_show_option(m, "mds_namespace", fsopt->mds_namespace);
+	if (fsopt->mon_addr)
+		seq_printf(m, ",mon_addr=%s", fsopt->mon_addr);
 
 	if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
 		seq_show_option(m, "recover_session", "clean");
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index db80d89556b1..ead73dfb8804 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -97,6 +97,7 @@ struct ceph_mount_options {
 	char *mds_namespace;  /* default NULL */
 	char *server_path;    /* default NULL (means "/") */
 	char *fscache_uniq;   /* default NULL */
+	char *mon_addr;
 };
 
 struct ceph_fs_client {
-- 
2.27.0


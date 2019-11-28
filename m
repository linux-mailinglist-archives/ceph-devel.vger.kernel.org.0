Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C92710C694
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Nov 2019 11:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfK1KVn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Nov 2019 05:21:43 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39965 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfK1KVn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Nov 2019 05:21:43 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so5785937wrn.7
        for <ceph-devel@vger.kernel.org>; Thu, 28 Nov 2019 02:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QJVLJ4AWJ2/V8E0Ym/WzNB7FNSccL6i5wfGgIV2IS9w=;
        b=F5iHl06ya1vh36xi18vohni1tsRUrgJ1WkmQVIUul177/pEw/aSdXLLaqIl05sGPIg
         svBtsQbMX6dnavoP22Z/dBl9AuAFDfIwGmDDvp5llVxbGgd9Wnbidxvo64BhvXLeYCHW
         arGz8V2RWkYXSY8YrZtPxT+ktAXXrwT4OYuB76x5pkRNZAKcFN2O1sM5riiYiFhVAYbW
         QE+2p33Qb2RvWqnULKEnLsGAWKQTf+cfnGWYwxwM9k2kL8tNSKRSqzBNuETJj8YB45zY
         k5J6eOdnNwuPtFMIutVRZatIowtWDzyIxAT/SnZQwpByj8iAfAJbVycWd7xkhl1e8gTC
         x3zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QJVLJ4AWJ2/V8E0Ym/WzNB7FNSccL6i5wfGgIV2IS9w=;
        b=mzLM/V6m8v3uVeXbFBPREaJmx8QsRzcH9pinWa835tQkp/xeJbnlAAGoLgTNB49lQb
         sK8KyeOrH1NCy8F13+ZLw1RoRnaHgPT84sohGKc9iCXQYZhlDf9lelQvB7Eff9XMu+TT
         xlMHyMbXe0f60LxuQaMUr4c1RIsrHtePNmbv0C2tzRKmSCbqQlofZZdX+9k8L1XnRKFe
         F9Was62unNCuY7S00r2gFaho8+Kx5Jk6DyB4jP/yjUW8EgJDmfe0kI5mr9T/dnUl1/Du
         HfHXS2DClg44yupxeY56DWokUDuwkeEdiI5hZ8+Yp9fJLaddL2WtkUpgcX1UqBpo/RoI
         dIyQ==
X-Gm-Message-State: APjAAAUeSa+jf3rXRzO3Gp3w54g9FjEJ1TsKNIGVsuXg+3vpTdHHnXU7
        GhLrGcMoErgwdsP3A0z2ZDBKemgoVdE=
X-Google-Smtp-Source: APXvYqxXT5MXCELfbcaITguE5iLvzMaAyZb+830zZCv3bwkhfGp0qqYDI9TkZGzUvwcquYwTL18MoQ==
X-Received: by 2002:adf:f80c:: with SMTP id s12mr12251176wrp.1.1574936495046;
        Thu, 28 Nov 2019 02:21:35 -0800 (PST)
Received: from kwango.local (ip-94-112-128-92.net.upcbroadband.cz. [94.112.128.92])
        by smtp.gmail.com with ESMTPSA id y67sm10282036wmy.31.2019.11.28.02.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 02:21:34 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH] libceph, rbd, ceph: convert to use the new mount API
Date:   Thu, 28 Nov 2019 11:21:21 +0100
Message-Id: <20191128102121.22747-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Convert the ceph filesystem to the new internal mount API as the old
one will be obsoleted and removed.  This allows greater flexibility in
communication of mount parameters between userspace, the VFS and the
filesystem.

See Documentation/filesystems/mount_api.txt for more information.

[ Numerous string handling, leak and regression fixes; rbd conversion
  was particularly broken and had to be redone almost from scratch. ]

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c          | 262 ++++++++------
 fs/ceph/cache.c              |   9 +-
 fs/ceph/cache.h              |   5 +-
 fs/ceph/super.c              | 646 ++++++++++++++++++-----------------
 fs/ceph/super.h              |   1 -
 include/linux/ceph/libceph.h |  10 +-
 net/ceph/ceph_common.c       | 419 +++++++++++------------
 net/ceph/messenger.c         |   2 -
 8 files changed, 681 insertions(+), 673 deletions(-)

Based on last posting by Jeff (v4?):
- replace rbd_parse_monolithic() as it was still going off into
  invalid memory on some configuration strings
- back out unrelated changes to next_token(), dup_token() and
  rbd_add_parse_args()
- back out dubious changes to source (aka dev_name) parsing logic,
  create_fs_client() and ceph_real_mount()
- fix memory leaks in ceph_get_tree(), fc->s_fs_info doesn't own fsc
  anymore
- make some parsing failures fatal again (monitor ip(s), etc)
- bring back osdtimeout case to avoid crashes when it's specified
- update log messages for fc-style logging
- propagate fc to more functions for logging (get_secret(), etc)
- remove ceph_config_context
- make parsing behaviour and naming consistent across all three modules

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 8798c89a4dc5..77a6b0f87975 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -34,7 +34,7 @@
 #include <linux/ceph/cls_lock_client.h>
 #include <linux/ceph/striper.h>
 #include <linux/ceph/decode.h>
-#include <linux/parser.h>
+#include <linux/fs_parser.h>
 #include <linux/bsearch.h>
 
 #include <linux/kernel.h>
@@ -838,34 +838,34 @@ enum {
 	Opt_queue_depth,
 	Opt_alloc_size,
 	Opt_lock_timeout,
-	Opt_last_int,
 	/* int args above */
 	Opt_pool_ns,
-	Opt_last_string,
 	/* string args above */
 	Opt_read_only,
 	Opt_read_write,
 	Opt_lock_on_read,
 	Opt_exclusive,
 	Opt_notrim,
-	Opt_err
 };
 
-static match_table_t rbd_opts_tokens = {
-	{Opt_queue_depth, "queue_depth=%d"},
-	{Opt_alloc_size, "alloc_size=%d"},
-	{Opt_lock_timeout, "lock_timeout=%d"},
-	/* int args above */
-	{Opt_pool_ns, "_pool_ns=%s"},
-	/* string args above */
-	{Opt_read_only, "read_only"},
-	{Opt_read_only, "ro"},		/* Alternate spelling */
-	{Opt_read_write, "read_write"},
-	{Opt_read_write, "rw"},		/* Alternate spelling */
-	{Opt_lock_on_read, "lock_on_read"},
-	{Opt_exclusive, "exclusive"},
-	{Opt_notrim, "notrim"},
-	{Opt_err, NULL}
+static const struct fs_parameter_spec rbd_param_specs[] = {
+	fsparam_u32	("alloc_size",			Opt_alloc_size),
+	fsparam_flag	("exclusive",			Opt_exclusive),
+	fsparam_flag	("lock_on_read",		Opt_lock_on_read),
+	fsparam_u32	("lock_timeout",		Opt_lock_timeout),
+	fsparam_flag	("notrim",			Opt_notrim),
+	fsparam_string	("_pool_ns",			Opt_pool_ns),
+	fsparam_u32	("queue_depth",			Opt_queue_depth),
+	fsparam_flag	("read_only",			Opt_read_only),
+	fsparam_flag	("read_write",			Opt_read_write),
+	fsparam_flag	("ro",				Opt_read_only),
+	fsparam_flag	("rw",				Opt_read_write),
+	{}
+};
+
+static const struct fs_parameter_description rbd_parameters = {
+	.name		= "rbd",
+	.specs		= rbd_param_specs,
 };
 
 struct rbd_options {
@@ -886,87 +886,12 @@ struct rbd_options {
 #define RBD_EXCLUSIVE_DEFAULT	false
 #define RBD_TRIM_DEFAULT	true
 
-struct parse_rbd_opts_ctx {
+struct rbd_parse_opts_ctx {
 	struct rbd_spec		*spec;
+	struct ceph_options	*copts;
 	struct rbd_options	*opts;
 };
 
-static int parse_rbd_opts_token(char *c, void *private)
-{
-	struct parse_rbd_opts_ctx *pctx = private;
-	substring_t argstr[MAX_OPT_ARGS];
-	int token, intval, ret;
-
-	token = match_token(c, rbd_opts_tokens, argstr);
-	if (token < Opt_last_int) {
-		ret = match_int(&argstr[0], &intval);
-		if (ret < 0) {
-			pr_err("bad option arg (not int) at '%s'\n", c);
-			return ret;
-		}
-		dout("got int token %d val %d\n", token, intval);
-	} else if (token > Opt_last_int && token < Opt_last_string) {
-		dout("got string token %d val %s\n", token, argstr[0].from);
-	} else {
-		dout("got token %d\n", token);
-	}
-
-	switch (token) {
-	case Opt_queue_depth:
-		if (intval < 1) {
-			pr_err("queue_depth out of range\n");
-			return -EINVAL;
-		}
-		pctx->opts->queue_depth = intval;
-		break;
-	case Opt_alloc_size:
-		if (intval < SECTOR_SIZE) {
-			pr_err("alloc_size out of range\n");
-			return -EINVAL;
-		}
-		if (!is_power_of_2(intval)) {
-			pr_err("alloc_size must be a power of 2\n");
-			return -EINVAL;
-		}
-		pctx->opts->alloc_size = intval;
-		break;
-	case Opt_lock_timeout:
-		/* 0 is "wait forever" (i.e. infinite timeout) */
-		if (intval < 0 || intval > INT_MAX / 1000) {
-			pr_err("lock_timeout out of range\n");
-			return -EINVAL;
-		}
-		pctx->opts->lock_timeout = msecs_to_jiffies(intval * 1000);
-		break;
-	case Opt_pool_ns:
-		kfree(pctx->spec->pool_ns);
-		pctx->spec->pool_ns = match_strdup(argstr);
-		if (!pctx->spec->pool_ns)
-			return -ENOMEM;
-		break;
-	case Opt_read_only:
-		pctx->opts->read_only = true;
-		break;
-	case Opt_read_write:
-		pctx->opts->read_only = false;
-		break;
-	case Opt_lock_on_read:
-		pctx->opts->lock_on_read = true;
-		break;
-	case Opt_exclusive:
-		pctx->opts->exclusive = true;
-		break;
-	case Opt_notrim:
-		pctx->opts->trim = false;
-		break;
-	default:
-		/* libceph prints "bad option" msg */
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static char* obj_op_name(enum obj_operation_type op_type)
 {
 	switch (op_type) {
@@ -6423,6 +6348,122 @@ static inline char *dup_token(const char **buf, size_t *lenp)
 	return dup;
 }
 
+static int rbd_parse_param(struct fs_parameter *param,
+			    struct rbd_parse_opts_ctx *pctx)
+{
+	struct rbd_options *opt = pctx->opts;
+	struct fs_parse_result result;
+	int token, ret;
+
+	ret = ceph_parse_param(param, pctx->copts, NULL);
+	if (ret != -ENOPARAM)
+		return ret;
+
+	token = fs_parse(NULL, &rbd_parameters, param, &result);
+	dout("%s fs_parse '%s' token %d\n", __func__, param->key, token);
+	if (token < 0) {
+		if (token == -ENOPARAM) {
+			return invalf(NULL, "rbd: Unknown parameter '%s'",
+				      param->key);
+		}
+		return token;
+	}
+
+	switch (token) {
+	case Opt_queue_depth:
+		if (result.uint_32 < 1)
+			goto out_of_range;
+		opt->queue_depth = result.uint_32;
+		break;
+	case Opt_alloc_size:
+		if (result.uint_32 < SECTOR_SIZE)
+			goto out_of_range;
+		if (!is_power_of_2(result.uint_32)) {
+			return invalf(NULL, "rbd: alloc_size must be a power of 2");
+		}
+		opt->alloc_size = result.uint_32;
+		break;
+	case Opt_lock_timeout:
+		/* 0 is "wait forever" (i.e. infinite timeout) */
+		if (result.uint_32 > INT_MAX / 1000)
+			goto out_of_range;
+		opt->lock_timeout = msecs_to_jiffies(result.uint_32 * 1000);
+		break;
+	case Opt_pool_ns:
+		kfree(pctx->spec->pool_ns);
+		pctx->spec->pool_ns = param->string;
+		param->string = NULL;
+		break;
+	case Opt_read_only:
+		opt->read_only = true;
+		break;
+	case Opt_read_write:
+		opt->read_only = false;
+		break;
+	case Opt_lock_on_read:
+		opt->lock_on_read = true;
+		break;
+	case Opt_exclusive:
+		opt->exclusive = true;
+		break;
+	case Opt_notrim:
+		opt->trim = false;
+		break;
+	default:
+		BUG();
+	}
+
+	return 0;
+
+out_of_range:
+	return invalf(NULL, "rbd: %s out of range", param->key);
+}
+
+/*
+ * This duplicates most of generic_parse_monolithic(), untying it from
+ * fs_context and skipping standard superblock and security options.
+ */
+static int rbd_parse_options(char *options, struct rbd_parse_opts_ctx *pctx)
+{
+	char *key;
+	int ret = 0;
+
+	dout("%s '%s'\n", __func__, options);
+	while ((key = strsep(&options, ",")) != NULL) {
+		if (*key) {
+			struct fs_parameter param = {
+				.key	= key,
+				.type	= fs_value_is_string,
+			};
+			char *value = strchr(key, '=');
+			size_t v_len = 0;
+
+			if (value) {
+				if (value == key)
+					continue;
+				*value++ = 0;
+				v_len = strlen(value);
+			}
+
+
+			if (v_len > 0) {
+				param.string = kmemdup_nul(value, v_len,
+							   GFP_KERNEL);
+				if (!param.string)
+					return -ENOMEM;
+			}
+			param.size = v_len;
+
+			ret = rbd_parse_param(&param, pctx);
+			kfree(param.string);
+			if (ret)
+				break;
+		}
+	}
+
+	return ret;
+}
+
 /*
  * Parse the options provided for an "rbd add" (i.e., rbd image
  * mapping) request.  These arrive via a write to /sys/bus/rbd/add,
@@ -6474,8 +6515,7 @@ static int rbd_add_parse_args(const char *buf,
 	const char *mon_addrs;
 	char *snap_name;
 	size_t mon_addrs_size;
-	struct parse_rbd_opts_ctx pctx = { 0 };
-	struct ceph_options *copts;
+	struct rbd_parse_opts_ctx pctx = { 0 };
 	int ret;
 
 	/* The first four tokens are required */
@@ -6486,7 +6526,7 @@ static int rbd_add_parse_args(const char *buf,
 		return -EINVAL;
 	}
 	mon_addrs = buf;
-	mon_addrs_size = len + 1;
+	mon_addrs_size = len;
 	buf += len;
 
 	ret = -EINVAL;
@@ -6536,6 +6576,10 @@ static int rbd_add_parse_args(const char *buf,
 	*(snap_name + len) = '\0';
 	pctx.spec->snap_name = snap_name;
 
+	pctx.copts = ceph_alloc_options();
+	if (!pctx.copts)
+		goto out_mem;
+
 	/* Initialize all rbd options to the defaults */
 
 	pctx.opts = kzalloc(sizeof(*pctx.opts), GFP_KERNEL);
@@ -6550,27 +6594,27 @@ static int rbd_add_parse_args(const char *buf,
 	pctx.opts->exclusive = RBD_EXCLUSIVE_DEFAULT;
 	pctx.opts->trim = RBD_TRIM_DEFAULT;
 
-	copts = ceph_parse_options(options, mon_addrs,
-				   mon_addrs + mon_addrs_size - 1,
-				   parse_rbd_opts_token, &pctx);
-	if (IS_ERR(copts)) {
-		ret = PTR_ERR(copts);
+	ret = ceph_parse_mon_ips(mon_addrs, mon_addrs_size, pctx.copts, NULL);
+	if (ret)
 		goto out_err;
-	}
-	kfree(options);
 
-	*ceph_opts = copts;
+	ret = rbd_parse_options(options, &pctx);
+	if (ret)
+		goto out_err;
+
+	*ceph_opts = pctx.copts;
 	*opts = pctx.opts;
 	*rbd_spec = pctx.spec;
-
+	kfree(options);
 	return 0;
+
 out_mem:
 	ret = -ENOMEM;
 out_err:
 	kfree(pctx.opts);
+	ceph_destroy_options(pctx.copts);
 	rbd_spec_put(pctx.spec);
 	kfree(options);
-
 	return ret;
 }
 
diff --git a/fs/ceph/cache.c b/fs/ceph/cache.c
index b2ec29eeb4c4..73f24f307a4a 100644
--- a/fs/ceph/cache.c
+++ b/fs/ceph/cache.c
@@ -8,6 +8,7 @@
 
 #include <linux/ceph/ceph_debug.h>
 
+#include <linux/fs_context.h>
 #include "super.h"
 #include "cache.h"
 
@@ -49,7 +50,7 @@ void ceph_fscache_unregister(void)
 	fscache_unregister_netfs(&ceph_cache_netfs);
 }
 
-int ceph_fscache_register_fs(struct ceph_fs_client* fsc)
+int ceph_fscache_register_fs(struct ceph_fs_client* fsc, struct fs_context *fc)
 {
 	const struct ceph_fsid *fsid = &fsc->client->fsid;
 	const char *fscache_uniq = fsc->mount_options->fscache_uniq;
@@ -66,8 +67,8 @@ int ceph_fscache_register_fs(struct ceph_fs_client* fsc)
 		if (uniq_len && memcmp(ent->uniquifier, fscache_uniq, uniq_len))
 			continue;
 
-		pr_err("fscache cookie already registered for fsid %pU\n", fsid);
-		pr_err("  use fsc=%%s mount option to specify a uniquifier\n");
+		errorf(fc, "ceph: fscache cookie already registered for fsid %pU, use fsc=<uniquifier> option",
+		       fsid);
 		err = -EBUSY;
 		goto out_unlock;
 	}
@@ -95,7 +96,7 @@ int ceph_fscache_register_fs(struct ceph_fs_client* fsc)
 		list_add_tail(&ent->list, &ceph_fscache_list);
 	} else {
 		kfree(ent);
-		pr_err("unable to register fscache cookie for fsid %pU\n",
+		errorf(fc, "ceph: unable to register fscache cookie for fsid %pU",
 		       fsid);
 		/* all other fs ignore this error */
 	}
diff --git a/fs/ceph/cache.h b/fs/ceph/cache.h
index e486fac3434d..89dbdd1eb14a 100644
--- a/fs/ceph/cache.h
+++ b/fs/ceph/cache.h
@@ -16,7 +16,7 @@ extern struct fscache_netfs ceph_cache_netfs;
 int ceph_fscache_register(void);
 void ceph_fscache_unregister(void);
 
-int ceph_fscache_register_fs(struct ceph_fs_client* fsc);
+int ceph_fscache_register_fs(struct ceph_fs_client* fsc, struct fs_context *fc);
 void ceph_fscache_unregister_fs(struct ceph_fs_client* fsc);
 
 void ceph_fscache_register_inode_cookie(struct inode *inode);
@@ -88,7 +88,8 @@ static inline void ceph_fscache_unregister(void)
 {
 }
 
-static inline int ceph_fscache_register_fs(struct ceph_fs_client* fsc)
+static inline int ceph_fscache_register_fs(struct ceph_fs_client* fsc,
+					   struct fs_context *fc)
 {
 	return 0;
 }
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index b47f43fc2d68..9c9a7c68eea3 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -9,7 +9,8 @@
 #include <linux/in6.h>
 #include <linux/module.h>
 #include <linux/mount.h>
-#include <linux/parser.h>
+#include <linux/fs_context.h>
+#include <linux/fs_parser.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
@@ -138,280 +139,308 @@ enum {
 	Opt_readdir_max_entries,
 	Opt_readdir_max_bytes,
 	Opt_congestion_kb,
-	Opt_last_int,
 	/* int args above */
 	Opt_snapdirname,
 	Opt_mds_namespace,
-	Opt_fscache_uniq,
 	Opt_recover_session,
-	Opt_last_string,
+	Opt_source,
 	/* string args above */
 	Opt_dirstat,
-	Opt_nodirstat,
 	Opt_rbytes,
-	Opt_norbytes,
 	Opt_asyncreaddir,
-	Opt_noasyncreaddir,
 	Opt_dcache,
-	Opt_nodcache,
 	Opt_ino32,
-	Opt_noino32,
 	Opt_fscache,
-	Opt_nofscache,
 	Opt_poolperm,
-	Opt_nopoolperm,
 	Opt_require_active_mds,
-	Opt_norequire_active_mds,
-#ifdef CONFIG_CEPH_FS_POSIX_ACL
 	Opt_acl,
-#endif
-	Opt_noacl,
 	Opt_quotadf,
-	Opt_noquotadf,
 	Opt_copyfrom,
-	Opt_nocopyfrom,
 };
 
-static match_table_t fsopt_tokens = {
-	{Opt_wsize, "wsize=%d"},
-	{Opt_rsize, "rsize=%d"},
-	{Opt_rasize, "rasize=%d"},
-	{Opt_caps_wanted_delay_min, "caps_wanted_delay_min=%d"},
-	{Opt_caps_wanted_delay_max, "caps_wanted_delay_max=%d"},
-	{Opt_caps_max, "caps_max=%d"},
-	{Opt_readdir_max_entries, "readdir_max_entries=%d"},
-	{Opt_readdir_max_bytes, "readdir_max_bytes=%d"},
-	{Opt_congestion_kb, "write_congestion_kb=%d"},
-	/* int args above */
-	{Opt_snapdirname, "snapdirname=%s"},
-	{Opt_mds_namespace, "mds_namespace=%s"},
-	{Opt_recover_session, "recover_session=%s"},
-	{Opt_fscache_uniq, "fsc=%s"},
-	/* string args above */
-	{Opt_dirstat, "dirstat"},
-	{Opt_nodirstat, "nodirstat"},
-	{Opt_rbytes, "rbytes"},
-	{Opt_norbytes, "norbytes"},
-	{Opt_asyncreaddir, "asyncreaddir"},
-	{Opt_noasyncreaddir, "noasyncreaddir"},
-	{Opt_dcache, "dcache"},
-	{Opt_nodcache, "nodcache"},
-	{Opt_ino32, "ino32"},
-	{Opt_noino32, "noino32"},
-	{Opt_fscache, "fsc"},
-	{Opt_nofscache, "nofsc"},
-	{Opt_poolperm, "poolperm"},
-	{Opt_nopoolperm, "nopoolperm"},
-	{Opt_require_active_mds, "require_active_mds"},
-	{Opt_norequire_active_mds, "norequire_active_mds"},
-#ifdef CONFIG_CEPH_FS_POSIX_ACL
-	{Opt_acl, "acl"},
-#endif
-	{Opt_noacl, "noacl"},
-	{Opt_quotadf, "quotadf"},
-	{Opt_noquotadf, "noquotadf"},
-	{Opt_copyfrom, "copyfrom"},
-	{Opt_nocopyfrom, "nocopyfrom"},
-	{-1, NULL}
+enum ceph_recover_session_mode {
+	ceph_recover_session_no,
+	ceph_recover_session_clean
+};
+
+static const struct fs_parameter_enum ceph_mount_param_enums[] = {
+	{ Opt_recover_session,	"no",		ceph_recover_session_no },
+	{ Opt_recover_session,	"clean",	ceph_recover_session_clean },
+	{}
+};
+
+static const struct fs_parameter_spec ceph_mount_param_specs[] = {
+	fsparam_flag_no ("acl",				Opt_acl),
+	fsparam_flag_no ("asyncreaddir",		Opt_asyncreaddir),
+	fsparam_u32	("caps_max",			Opt_caps_max),
+	fsparam_u32	("caps_wanted_delay_max",	Opt_caps_wanted_delay_max),
+	fsparam_u32	("caps_wanted_delay_min",	Opt_caps_wanted_delay_min),
+	fsparam_s32	("write_congestion_kb",		Opt_congestion_kb),
+	fsparam_flag_no ("copyfrom",			Opt_copyfrom),
+	fsparam_flag_no ("dcache",			Opt_dcache),
+	fsparam_flag_no ("dirstat",			Opt_dirstat),
+	__fsparam	(fs_param_is_string, "fsc",	Opt_fscache,
+			 fs_param_neg_with_no | fs_param_v_optional),
+	fsparam_flag_no ("ino32",			Opt_ino32),
+	fsparam_string	("mds_namespace",		Opt_mds_namespace),
+	fsparam_flag_no ("poolperm",			Opt_poolperm),
+	fsparam_flag_no ("quotadf",			Opt_quotadf),
+	fsparam_u32	("rasize",			Opt_rasize),
+	fsparam_flag_no ("rbytes",			Opt_rbytes),
+	fsparam_s32	("readdir_max_bytes",		Opt_readdir_max_bytes),
+	fsparam_s32	("readdir_max_entries",		Opt_readdir_max_entries),
+	fsparam_enum	("recover_session",		Opt_recover_session),
+	fsparam_flag_no ("require_active_mds",		Opt_require_active_mds),
+	fsparam_u32	("rsize",			Opt_rsize),
+	fsparam_string	("snapdirname",			Opt_snapdirname),
+	fsparam_string	("source",			Opt_source),
+	fsparam_u32	("wsize",			Opt_wsize),
+	{}
+};
+
+static const struct fs_parameter_description ceph_mount_parameters = {
+	.name           = "ceph",
+	.specs          = ceph_mount_param_specs,
+	.enums		= ceph_mount_param_enums,
 };
 
-static int parse_fsopt_token(char *c, void *private)
+struct ceph_parse_opts_ctx {
+	struct ceph_options		*copts;
+	struct ceph_mount_options	*opts;
+};
+
+/*
+ * Parse the source parameter.  Distinguish the server list from the path.
+ * Internally we do not include the leading '/' in the path.
+ *
+ * The source will look like:
+ *     <server_spec>[,<server_spec>...]:[<path>]
+ * where
+ *     <server_spec> is <ip>[:<port>]
+ *     <path> is optional, but if present must begin with '/'
+ */
+static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
 {
-	struct ceph_mount_options *fsopt = private;
-	substring_t argstr[MAX_OPT_ARGS];
-	int token, intval, ret;
+	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
+	struct ceph_mount_options *fsopt = pctx->opts;
+	char *dev_name = param->string, *dev_name_end;
+	int ret;
 
-	token = match_token((char *)c, fsopt_tokens, argstr);
-	if (token < 0)
-		return -EINVAL;
+	dout("%s '%s'\n", __func__, dev_name);
+	if (!dev_name || !*dev_name)
+		return invalf(fc, "ceph: Empty source");
 
-	if (token < Opt_last_int) {
-		ret = match_int(&argstr[0], &intval);
-		if (ret < 0) {
-			pr_err("bad option arg (not int) at '%s'\n", c);
-			return ret;
+	dev_name_end = strchr(dev_name, '/');
+	if (dev_name_end) {
+		if (strlen(dev_name_end) > 1) {
+			kfree(fsopt->server_path);
+			fsopt->server_path = kstrdup(dev_name_end, GFP_KERNEL);
+			if (!fsopt->server_path)
+				return -ENOMEM;
 		}
-		dout("got int token %d val %d\n", token, intval);
-	} else if (token > Opt_last_int && token < Opt_last_string) {
-		dout("got string token %d val %s\n", token,
-		     argstr[0].from);
 	} else {
-		dout("got token %d\n", token);
+		dev_name_end = dev_name + strlen(dev_name);
 	}
 
+	dev_name_end--;		/* back up to ':' separator */
+	if (dev_name_end < dev_name || *dev_name_end != ':')
+		return invalf(fc, "ceph: No path or : separator in source");
+
+	dout("device name '%.*s'\n", (int)(dev_name_end - dev_name), dev_name);
+	if (fsopt->server_path)
+		dout("server path '%s'\n", fsopt->server_path);
+
+	ret = ceph_parse_mon_ips(param->string, dev_name_end - dev_name,
+				 pctx->copts, fc);
+	if (ret)
+		return ret;
+
+	fc->source = param->string;
+	param->string = NULL;
+	return 0;
+}
+
+static int ceph_parse_mount_param(struct fs_context *fc,
+				  struct fs_parameter *param)
+{
+	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
+	struct ceph_mount_options *fsopt = pctx->opts;
+	struct fs_parse_result result;
+	unsigned int mode;
+	int token, ret;
+
+	ret = ceph_parse_param(param, pctx->copts, fc);
+	if (ret != -ENOPARAM)
+		return ret;
+
+	token = fs_parse(fc, &ceph_mount_parameters, param, &result);
+	dout("%s fs_parse '%s' token %d\n", __func__, param->key, token);
+	if (token < 0)
+		return token;
+
 	switch (token) {
 	case Opt_snapdirname:
 		kfree(fsopt->snapdir_name);
-		fsopt->snapdir_name = kstrndup(argstr[0].from,
-					       argstr[0].to-argstr[0].from,
-					       GFP_KERNEL);
-		if (!fsopt->snapdir_name)
-			return -ENOMEM;
+		fsopt->snapdir_name = param->string;
+		param->string = NULL;
 		break;
 	case Opt_mds_namespace:
 		kfree(fsopt->mds_namespace);
-		fsopt->mds_namespace = kstrndup(argstr[0].from,
-						argstr[0].to-argstr[0].from,
-						GFP_KERNEL);
-		if (!fsopt->mds_namespace)
-			return -ENOMEM;
+		fsopt->mds_namespace = param->string;
+		param->string = NULL;
 		break;
 	case Opt_recover_session:
-		if (!strncmp(argstr[0].from, "no",
-			     argstr[0].to - argstr[0].from)) {
+		mode = result.uint_32;
+		if (mode == ceph_recover_session_no)
 			fsopt->flags &= ~CEPH_MOUNT_OPT_CLEANRECOVER;
-		} else if (!strncmp(argstr[0].from, "clean",
-				    argstr[0].to - argstr[0].from)) {
+		else if (mode == ceph_recover_session_clean)
 			fsopt->flags |= CEPH_MOUNT_OPT_CLEANRECOVER;
-		} else {
-			return -EINVAL;
-		}
-		break;
-	case Opt_fscache_uniq:
-#ifdef CONFIG_CEPH_FSCACHE
-		kfree(fsopt->fscache_uniq);
-		fsopt->fscache_uniq = kstrndup(argstr[0].from,
-					       argstr[0].to-argstr[0].from,
-					       GFP_KERNEL);
-		if (!fsopt->fscache_uniq)
-			return -ENOMEM;
-		fsopt->flags |= CEPH_MOUNT_OPT_FSCACHE;
+		else
+			BUG();
 		break;
-#else
-		pr_err("fscache support is disabled\n");
-		return -EINVAL;
-#endif
+	case Opt_source:
+		if (fc->source)
+			return invalf(fc, "ceph: Multiple sources specified");
+		return ceph_parse_source(param, fc);
 	case Opt_wsize:
-		if (intval < (int)PAGE_SIZE || intval > CEPH_MAX_WRITE_SIZE)
-			return -EINVAL;
-		fsopt->wsize = ALIGN(intval, PAGE_SIZE);
+		if (result.uint_32 < PAGE_SIZE ||
+		    result.uint_32 > CEPH_MAX_WRITE_SIZE)
+			goto out_of_range;
+		fsopt->wsize = ALIGN(result.uint_32, PAGE_SIZE);
 		break;
 	case Opt_rsize:
-		if (intval < (int)PAGE_SIZE || intval > CEPH_MAX_READ_SIZE)
-			return -EINVAL;
-		fsopt->rsize = ALIGN(intval, PAGE_SIZE);
+		if (result.uint_32 < PAGE_SIZE ||
+		    result.uint_32 > CEPH_MAX_READ_SIZE)
+			goto out_of_range;
+		fsopt->rsize = ALIGN(result.uint_32, PAGE_SIZE);
 		break;
 	case Opt_rasize:
-		if (intval < 0)
-			return -EINVAL;
-		fsopt->rasize = ALIGN(intval, PAGE_SIZE);
+		fsopt->rasize = ALIGN(result.uint_32, PAGE_SIZE);
 		break;
 	case Opt_caps_wanted_delay_min:
-		if (intval < 1)
-			return -EINVAL;
-		fsopt->caps_wanted_delay_min = intval;
+		if (result.uint_32 < 1)
+			goto out_of_range;
+		fsopt->caps_wanted_delay_min = result.uint_32;
 		break;
 	case Opt_caps_wanted_delay_max:
-		if (intval < 1)
-			return -EINVAL;
-		fsopt->caps_wanted_delay_max = intval;
+		if (result.uint_32 < 1)
+			goto out_of_range;
+		fsopt->caps_wanted_delay_max = result.uint_32;
 		break;
 	case Opt_caps_max:
-		if (intval < 0)
-			return -EINVAL;
-		fsopt->caps_max = intval;
+		fsopt->caps_max = result.uint_32;
 		break;
 	case Opt_readdir_max_entries:
-		if (intval < 1)
-			return -EINVAL;
-		fsopt->max_readdir = intval;
+		if (result.uint_32 < 1)
+			goto out_of_range;
+		fsopt->max_readdir = result.uint_32;
 		break;
 	case Opt_readdir_max_bytes:
-		if (intval < (int)PAGE_SIZE && intval != 0)
-			return -EINVAL;
-		fsopt->max_readdir_bytes = intval;
+		if (result.uint_32 < PAGE_SIZE && result.uint_32 != 0)
+			goto out_of_range;
+		fsopt->max_readdir_bytes = result.uint_32;
 		break;
 	case Opt_congestion_kb:
-		if (intval < 1024) /* at least 1M */
-			return -EINVAL;
-		fsopt->congestion_kb = intval;
+		if (result.uint_32 < 1024) /* at least 1M */
+			goto out_of_range;
+		fsopt->congestion_kb = result.uint_32;
 		break;
 	case Opt_dirstat:
-		fsopt->flags |= CEPH_MOUNT_OPT_DIRSTAT;
-		break;
-	case Opt_nodirstat:
-		fsopt->flags &= ~CEPH_MOUNT_OPT_DIRSTAT;
+		if (!result.negated)
+			fsopt->flags |= CEPH_MOUNT_OPT_DIRSTAT;
+		else
+			fsopt->flags &= ~CEPH_MOUNT_OPT_DIRSTAT;
 		break;
 	case Opt_rbytes:
-		fsopt->flags |= CEPH_MOUNT_OPT_RBYTES;
-		break;
-	case Opt_norbytes:
-		fsopt->flags &= ~CEPH_MOUNT_OPT_RBYTES;
+		if (!result.negated)
+			fsopt->flags |= CEPH_MOUNT_OPT_RBYTES;
+		else
+			fsopt->flags &= ~CEPH_MOUNT_OPT_RBYTES;
 		break;
 	case Opt_asyncreaddir:
-		fsopt->flags &= ~CEPH_MOUNT_OPT_NOASYNCREADDIR;
-		break;
-	case Opt_noasyncreaddir:
-		fsopt->flags |= CEPH_MOUNT_OPT_NOASYNCREADDIR;
+		if (!result.negated)
+			fsopt->flags &= ~CEPH_MOUNT_OPT_NOASYNCREADDIR;
+		else
+			fsopt->flags |= CEPH_MOUNT_OPT_NOASYNCREADDIR;
 		break;
 	case Opt_dcache:
-		fsopt->flags |= CEPH_MOUNT_OPT_DCACHE;
-		break;
-	case Opt_nodcache:
-		fsopt->flags &= ~CEPH_MOUNT_OPT_DCACHE;
+		if (!result.negated)
+			fsopt->flags |= CEPH_MOUNT_OPT_DCACHE;
+		else
+			fsopt->flags &= ~CEPH_MOUNT_OPT_DCACHE;
 		break;
 	case Opt_ino32:
-		fsopt->flags |= CEPH_MOUNT_OPT_INO32;
-		break;
-	case Opt_noino32:
-		fsopt->flags &= ~CEPH_MOUNT_OPT_INO32;
+		if (!result.negated)
+			fsopt->flags |= CEPH_MOUNT_OPT_INO32;
+		else
+			fsopt->flags &= ~CEPH_MOUNT_OPT_INO32;
 		break;
+
 	case Opt_fscache:
 #ifdef CONFIG_CEPH_FSCACHE
-		fsopt->flags |= CEPH_MOUNT_OPT_FSCACHE;
 		kfree(fsopt->fscache_uniq);
 		fsopt->fscache_uniq = NULL;
+		if (result.negated) {
+			fsopt->flags &= ~CEPH_MOUNT_OPT_FSCACHE;
+		} else {
+			fsopt->flags |= CEPH_MOUNT_OPT_FSCACHE;
+			fsopt->fscache_uniq = param->string;
+			param->string = NULL;
+		}
 		break;
 #else
-		pr_err("fscache support is disabled\n");
-		return -EINVAL;
+		return invalf(fc, "ceph: fscache support is disabled");
 #endif
-	case Opt_nofscache:
-		fsopt->flags &= ~CEPH_MOUNT_OPT_FSCACHE;
-		kfree(fsopt->fscache_uniq);
-		fsopt->fscache_uniq = NULL;
-		break;
 	case Opt_poolperm:
-		fsopt->flags &= ~CEPH_MOUNT_OPT_NOPOOLPERM;
-		break;
-	case Opt_nopoolperm:
-		fsopt->flags |= CEPH_MOUNT_OPT_NOPOOLPERM;
+		if (!result.negated)
+			fsopt->flags &= ~CEPH_MOUNT_OPT_NOPOOLPERM;
+		else
+			fsopt->flags |= CEPH_MOUNT_OPT_NOPOOLPERM;
 		break;
 	case Opt_require_active_mds:
-		fsopt->flags &= ~CEPH_MOUNT_OPT_MOUNTWAIT;
-		break;
-	case Opt_norequire_active_mds:
-		fsopt->flags |= CEPH_MOUNT_OPT_MOUNTWAIT;
+		if (!result.negated)
+			fsopt->flags &= ~CEPH_MOUNT_OPT_MOUNTWAIT;
+		else
+			fsopt->flags |= CEPH_MOUNT_OPT_MOUNTWAIT;
 		break;
 	case Opt_quotadf:
-		fsopt->flags &= ~CEPH_MOUNT_OPT_NOQUOTADF;
-		break;
-	case Opt_noquotadf:
-		fsopt->flags |= CEPH_MOUNT_OPT_NOQUOTADF;
+		if (!result.negated)
+			fsopt->flags &= ~CEPH_MOUNT_OPT_NOQUOTADF;
+		else
+			fsopt->flags |= CEPH_MOUNT_OPT_NOQUOTADF;
 		break;
 	case Opt_copyfrom:
-		fsopt->flags &= ~CEPH_MOUNT_OPT_NOCOPYFROM;
-		break;
-	case Opt_nocopyfrom:
-		fsopt->flags |= CEPH_MOUNT_OPT_NOCOPYFROM;
+		if (!result.negated)
+			fsopt->flags &= ~CEPH_MOUNT_OPT_NOCOPYFROM;
+		else
+			fsopt->flags |= CEPH_MOUNT_OPT_NOCOPYFROM;
 		break;
-#ifdef CONFIG_CEPH_FS_POSIX_ACL
 	case Opt_acl:
-		fsopt->sb_flags |= SB_POSIXACL;
-		break;
+		if (!result.negated) {
+#ifdef CONFIG_CEPH_FS_POSIX_ACL
+			fc->sb_flags |= SB_POSIXACL;
+#else
+			return invalf(fc, "ceph: POSIX ACL support is disabled");
 #endif
-	case Opt_noacl:
-		fsopt->sb_flags &= ~SB_POSIXACL;
+		} else {
+			fc->sb_flags &= ~SB_POSIXACL;
+		}
 		break;
 	default:
-		BUG_ON(token);
+		BUG();
 	}
 	return 0;
+
+out_of_range:
+	return invalf(fc, "ceph: %s out of range", param->key);
 }
 
 static void destroy_mount_options(struct ceph_mount_options *args)
 {
 	dout("destroy_mount_options %p\n", args);
+	if (!args)
+		return;
+
 	kfree(args->snapdir_name);
 	kfree(args->mds_namespace);
 	kfree(args->server_path);
@@ -459,91 +488,6 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
 	return ceph_compare_options(new_opt, fsc->client);
 }
 
-static int parse_mount_options(struct ceph_mount_options **pfsopt,
-			       struct ceph_options **popt,
-			       int flags, char *options,
-			       const char *dev_name)
-{
-	struct ceph_mount_options *fsopt;
-	const char *dev_name_end;
-	int err;
-
-	if (!dev_name || !*dev_name)
-		return -EINVAL;
-
-	fsopt = kzalloc(sizeof(*fsopt), GFP_KERNEL);
-	if (!fsopt)
-		return -ENOMEM;
-
-	dout("parse_mount_options %p, dev_name '%s'\n", fsopt, dev_name);
-
-	fsopt->sb_flags = flags;
-	fsopt->flags = CEPH_MOUNT_OPT_DEFAULT;
-
-	fsopt->wsize = CEPH_MAX_WRITE_SIZE;
-	fsopt->rsize = CEPH_MAX_READ_SIZE;
-	fsopt->rasize = CEPH_RASIZE_DEFAULT;
-	fsopt->snapdir_name = kstrdup(CEPH_SNAPDIRNAME_DEFAULT, GFP_KERNEL);
-	if (!fsopt->snapdir_name) {
-		err = -ENOMEM;
-		goto out;
-	}
-
-	fsopt->caps_wanted_delay_min = CEPH_CAPS_WANTED_DELAY_MIN_DEFAULT;
-	fsopt->caps_wanted_delay_max = CEPH_CAPS_WANTED_DELAY_MAX_DEFAULT;
-	fsopt->max_readdir = CEPH_MAX_READDIR_DEFAULT;
-	fsopt->max_readdir_bytes = CEPH_MAX_READDIR_BYTES_DEFAULT;
-	fsopt->congestion_kb = default_congestion_kb();
-
-	/*
-	 * Distinguish the server list from the path in "dev_name".
-	 * Internally we do not include the leading '/' in the path.
-	 *
-	 * "dev_name" will look like:
-	 *     <server_spec>[,<server_spec>...]:[<path>]
-	 * where
-	 *     <server_spec> is <ip>[:<port>]
-	 *     <path> is optional, but if present must begin with '/'
-	 */
-	dev_name_end = strchr(dev_name, '/');
-	if (dev_name_end) {
-		if (strlen(dev_name_end) > 1) {
-			fsopt->server_path = kstrdup(dev_name_end, GFP_KERNEL);
-			if (!fsopt->server_path) {
-				err = -ENOMEM;
-				goto out;
-			}
-		}
-	} else {
-		dev_name_end = dev_name + strlen(dev_name);
-	}
-	err = -EINVAL;
-	dev_name_end--;		/* back up to ':' separator */
-	if (dev_name_end < dev_name || *dev_name_end != ':') {
-		pr_err("device name is missing path (no : separator in %s)\n",
-				dev_name);
-		goto out;
-	}
-	dout("device name '%.*s'\n", (int)(dev_name_end - dev_name), dev_name);
-	if (fsopt->server_path)
-		dout("server path '%s'\n", fsopt->server_path);
-
-	*popt = ceph_parse_options(options, dev_name, dev_name_end,
-				 parse_fsopt_token, (void *)fsopt);
-	if (IS_ERR(*popt)) {
-		err = PTR_ERR(*popt);
-		goto out;
-	}
-
-	/* success */
-	*pfsopt = fsopt;
-	return 0;
-
-out:
-	destroy_mount_options(fsopt);
-	return err;
-}
-
 /**
  * ceph_show_options - Show mount options in /proc/mounts
  * @m: seq_file to write to
@@ -587,7 +531,7 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
 		seq_puts(m, ",noquotadf");
 
 #ifdef CONFIG_CEPH_FS_POSIX_ACL
-	if (fsopt->sb_flags & SB_POSIXACL)
+	if (root->d_sb->s_flags & SB_POSIXACL)
 		seq_puts(m, ",acl");
 	else
 		seq_puts(m, ",noacl");
@@ -860,12 +804,6 @@ static void ceph_umount_begin(struct super_block *sb)
 	fsc->filp_gen++; // invalidate open files
 }
 
-static int ceph_remount(struct super_block *sb, int *flags, char *data)
-{
-	sync_filesystem(sb);
-	return 0;
-}
-
 static const struct super_operations ceph_super_ops = {
 	.alloc_inode	= ceph_alloc_inode,
 	.free_inode	= ceph_free_inode,
@@ -874,7 +812,6 @@ static const struct super_operations ceph_super_ops = {
 	.evict_inode	= ceph_evict_inode,
 	.sync_fs        = ceph_sync_fs,
 	.put_super	= ceph_put_super,
-	.remount_fs	= ceph_remount,
 	.show_options   = ceph_show_options,
 	.statfs		= ceph_statfs,
 	.umount_begin   = ceph_umount_begin,
@@ -935,7 +872,8 @@ static struct dentry *open_root_dentry(struct ceph_fs_client *fsc,
 /*
  * mount: join the ceph cluster, and open root directory.
  */
-static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc)
+static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
+				      struct fs_context *fc)
 {
 	int err;
 	unsigned long started = jiffies;  /* note the start time */
@@ -952,7 +890,7 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc)
 
 		/* setup fscache */
 		if (fsc->mount_options->flags & CEPH_MOUNT_OPT_FSCACHE) {
-			err = ceph_fscache_register_fs(fsc);
+			err = ceph_fscache_register_fs(fsc, fc);
 			if (err < 0)
 				goto out;
 		}
@@ -987,18 +925,16 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc)
 	return ERR_PTR(err);
 }
 
-static int ceph_set_super(struct super_block *s, void *data)
+static int ceph_set_super(struct super_block *s, struct fs_context *fc)
 {
-	struct ceph_fs_client *fsc = data;
+	struct ceph_fs_client *fsc = s->s_fs_info;
 	int ret;
 
-	dout("set_super %p data %p\n", s, data);
+	dout("set_super %p\n", s);
 
-	s->s_flags = fsc->mount_options->sb_flags;
 	s->s_maxbytes = MAX_LFS_FILESIZE;
 
 	s->s_xattr = ceph_xattr_handlers;
-	s->s_fs_info = fsc;
 	fsc->sb = s;
 	fsc->max_file_size = 1ULL << 40; /* temp value until we get mdsmap */
 
@@ -1010,24 +946,18 @@ static int ceph_set_super(struct super_block *s, void *data)
 	s->s_time_min = 0;
 	s->s_time_max = U32_MAX;
 
-	ret = set_anon_super(s, NULL);  /* what is that second arg for? */
+	ret = set_anon_super_fc(s, fc);
 	if (ret != 0)
-		goto fail;
-
-	return ret;
-
-fail:
-	s->s_fs_info = NULL;
-	fsc->sb = NULL;
+		fsc->sb = NULL;
 	return ret;
 }
 
 /*
  * share superblock if same fs AND options
  */
-static int ceph_compare_super(struct super_block *sb, void *data)
+static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
 {
-	struct ceph_fs_client *new = data;
+	struct ceph_fs_client *new = fc->s_fs_info;
 	struct ceph_mount_options *fsopt = new->mount_options;
 	struct ceph_options *opt = new->client->options;
 	struct ceph_fs_client *other = ceph_sb_to_client(sb);
@@ -1043,7 +973,7 @@ static int ceph_compare_super(struct super_block *sb, void *data)
 		dout("fsid doesn't match\n");
 		return 0;
 	}
-	if (fsopt->sb_flags != other->mount_options->sb_flags) {
+	if (fc->sb_flags != (sb->s_flags & ~SB_BORN)) {
 		dout("flags differ\n");
 		return 0;
 	}
@@ -1073,46 +1003,46 @@ static int ceph_setup_bdi(struct super_block *sb, struct ceph_fs_client *fsc)
 	return 0;
 }
 
-static struct dentry *ceph_mount(struct file_system_type *fs_type,
-		       int flags, const char *dev_name, void *data)
+static int ceph_get_tree(struct fs_context *fc)
 {
+	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
 	struct super_block *sb;
 	struct ceph_fs_client *fsc;
 	struct dentry *res;
+	int (*compare_super)(struct super_block *, struct fs_context *) =
+		ceph_compare_super;
 	int err;
-	int (*compare_super)(struct super_block *, void *) = ceph_compare_super;
-	struct ceph_mount_options *fsopt = NULL;
-	struct ceph_options *opt = NULL;
 
-	dout("ceph_mount\n");
+	dout("ceph_get_tree\n");
+
+	if (!fc->source)
+		return invalf(fc, "ceph: No source");
 
 #ifdef CONFIG_CEPH_FS_POSIX_ACL
-	flags |= SB_POSIXACL;
+	fc->sb_flags |= SB_POSIXACL;
 #endif
-	err = parse_mount_options(&fsopt, &opt, flags, data, dev_name);
-	if (err < 0) {
-		res = ERR_PTR(err);
-		goto out_final;
-	}
 
 	/* create client (which we may/may not use) */
-	fsc = create_fs_client(fsopt, opt);
+	fsc = create_fs_client(pctx->opts, pctx->copts);
+	pctx->opts = NULL;
+	pctx->copts = NULL;
 	if (IS_ERR(fsc)) {
-		res = ERR_CAST(fsc);
+		err = PTR_ERR(fsc);
 		goto out_final;
 	}
 
 	err = ceph_mdsc_init(fsc);
-	if (err < 0) {
-		res = ERR_PTR(err);
+	if (err < 0)
 		goto out;
-	}
 
 	if (ceph_test_opt(fsc->client, NOSHARE))
 		compare_super = NULL;
-	sb = sget(fs_type, compare_super, ceph_set_super, flags, fsc);
+
+	fc->s_fs_info = fsc;
+	sb = sget_fc(fc, compare_super, ceph_set_super);
+	fc->s_fs_info = NULL;
 	if (IS_ERR(sb)) {
-		res = ERR_CAST(sb);
+		err = PTR_ERR(sb);
 		goto out;
 	}
 
@@ -1123,18 +1053,19 @@ static struct dentry *ceph_mount(struct file_system_type *fs_type,
 	} else {
 		dout("get_sb using new client %p\n", fsc);
 		err = ceph_setup_bdi(sb, fsc);
-		if (err < 0) {
-			res = ERR_PTR(err);
+		if (err < 0)
 			goto out_splat;
-		}
 	}
 
-	res = ceph_real_mount(fsc);
-	if (IS_ERR(res))
+	res = ceph_real_mount(fsc, fc);
+	if (IS_ERR(res)) {
+		err = PTR_ERR(res);
 		goto out_splat;
+	}
 	dout("root %p inode %p ino %llx.%llx\n", res,
 	     d_inode(res), ceph_vinop(d_inode(res)));
-	return res;
+	fc->root = fsc->sb->s_root;
+	return 0;
 
 out_splat:
 	ceph_mdsc_close_sessions(fsc->mdsc);
@@ -1144,8 +1075,79 @@ static struct dentry *ceph_mount(struct file_system_type *fs_type,
 out:
 	destroy_fs_client(fsc);
 out_final:
-	dout("ceph_mount fail %ld\n", PTR_ERR(res));
-	return res;
+	dout("ceph_get_tree fail %d\n", err);
+	return err;
+}
+
+static void ceph_free_fc(struct fs_context *fc)
+{
+	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
+
+	if (pctx) {
+		destroy_mount_options(pctx->opts);
+		ceph_destroy_options(pctx->copts);
+		kfree(pctx);
+	}
+}
+
+static int ceph_reconfigure_fc(struct fs_context *fc)
+{
+	sync_filesystem(fc->root->d_sb);
+	return 0;
+}
+
+static const struct fs_context_operations ceph_context_ops = {
+	.free		= ceph_free_fc,
+	.parse_param	= ceph_parse_mount_param,
+	.get_tree	= ceph_get_tree,
+	.reconfigure	= ceph_reconfigure_fc,
+};
+
+/*
+ * Set up the filesystem mount context.
+ */
+static int ceph_init_fs_context(struct fs_context *fc)
+{
+	struct ceph_parse_opts_ctx *pctx;
+	struct ceph_mount_options *fsopt;
+
+	pctx = kzalloc(sizeof(*pctx), GFP_KERNEL);
+	if (!pctx)
+		return -ENOMEM;
+
+	pctx->copts = ceph_alloc_options();
+	if (!pctx->copts)
+		goto nomem;
+
+	pctx->opts = kzalloc(sizeof(*pctx->opts), GFP_KERNEL);
+	if (!pctx->opts)
+		goto nomem;
+
+	fsopt = pctx->opts;
+	fsopt->flags = CEPH_MOUNT_OPT_DEFAULT;
+
+	fsopt->wsize = CEPH_MAX_WRITE_SIZE;
+	fsopt->rsize = CEPH_MAX_READ_SIZE;
+	fsopt->rasize = CEPH_RASIZE_DEFAULT;
+	fsopt->snapdir_name = kstrdup(CEPH_SNAPDIRNAME_DEFAULT, GFP_KERNEL);
+	if (!fsopt->snapdir_name)
+		goto nomem;
+
+	fsopt->caps_wanted_delay_min = CEPH_CAPS_WANTED_DELAY_MIN_DEFAULT;
+	fsopt->caps_wanted_delay_max = CEPH_CAPS_WANTED_DELAY_MAX_DEFAULT;
+	fsopt->max_readdir = CEPH_MAX_READDIR_DEFAULT;
+	fsopt->max_readdir_bytes = CEPH_MAX_READDIR_BYTES_DEFAULT;
+	fsopt->congestion_kb = default_congestion_kb();
+
+	fc->fs_private = pctx;
+	fc->ops = &ceph_context_ops;
+	return 0;
+
+nomem:
+	destroy_mount_options(pctx->opts);
+	ceph_destroy_options(pctx->copts);
+	kfree(pctx);
+	return -ENOMEM;
 }
 
 static void ceph_kill_sb(struct super_block *s)
@@ -1172,7 +1174,7 @@ static void ceph_kill_sb(struct super_block *s)
 static struct file_system_type ceph_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "ceph",
-	.mount		= ceph_mount,
+	.init_fs_context = ceph_init_fs_context,
 	.kill_sb	= ceph_kill_sb,
 	.fs_flags	= FS_RENAME_DOES_D_MOVE,
 };
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index e31c0177fcc6..f0f9cb7447ac 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -74,7 +74,6 @@
 
 struct ceph_mount_options {
 	int flags;
-	int sb_flags;
 
 	int wsize;            /* max write size */
 	int rsize;            /* max read size */
diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index b9dbda1c26aa..8fe9b80e80a5 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -280,10 +280,12 @@ extern const char *ceph_msg_type_name(int type);
 extern int ceph_check_fsid(struct ceph_client *client, struct ceph_fsid *fsid);
 extern void *ceph_kvmalloc(size_t size, gfp_t flags);
 
-extern struct ceph_options *ceph_parse_options(char *options,
-			      const char *dev_name, const char *dev_name_end,
-			      int (*parse_extra_token)(char *c, void *private),
-			      void *private);
+struct fs_parameter;
+struct ceph_options *ceph_alloc_options(void);
+int ceph_parse_mon_ips(const char *buf, size_t len, struct ceph_options *opt,
+		       struct fs_context *fc);
+int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
+		     struct fs_context *fc);
 int ceph_print_client_options(struct seq_file *m, struct ceph_client *client,
 			      bool show_all);
 extern void ceph_destroy_options(struct ceph_options *opt);
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 2d568246803f..a9d6c97b5b0d 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -11,7 +11,7 @@
 #include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/nsproxy.h>
-#include <linux/parser.h>
+#include <linux/fs_parser.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
 #include <linux/seq_file.h>
@@ -254,58 +254,77 @@ enum {
 	Opt_mount_timeout,
 	Opt_osd_idle_ttl,
 	Opt_osd_request_timeout,
-	Opt_last_int,
 	/* int args above */
 	Opt_fsid,
 	Opt_name,
 	Opt_secret,
 	Opt_key,
 	Opt_ip,
-	Opt_last_string,
 	/* string args above */
 	Opt_share,
-	Opt_noshare,
 	Opt_crc,
-	Opt_nocrc,
 	Opt_cephx_require_signatures,
-	Opt_nocephx_require_signatures,
 	Opt_cephx_sign_messages,
-	Opt_nocephx_sign_messages,
 	Opt_tcp_nodelay,
-	Opt_notcp_nodelay,
 	Opt_abort_on_full,
 };
 
-static match_table_t opt_tokens = {
-	{Opt_osdtimeout, "osdtimeout=%d"},
-	{Opt_osdkeepalivetimeout, "osdkeepalive=%d"},
-	{Opt_mount_timeout, "mount_timeout=%d"},
-	{Opt_osd_idle_ttl, "osd_idle_ttl=%d"},
-	{Opt_osd_request_timeout, "osd_request_timeout=%d"},
-	/* int args above */
-	{Opt_fsid, "fsid=%s"},
-	{Opt_name, "name=%s"},
-	{Opt_secret, "secret=%s"},
-	{Opt_key, "key=%s"},
-	{Opt_ip, "ip=%s"},
-	/* string args above */
-	{Opt_share, "share"},
-	{Opt_noshare, "noshare"},
-	{Opt_crc, "crc"},
-	{Opt_nocrc, "nocrc"},
-	{Opt_cephx_require_signatures, "cephx_require_signatures"},
-	{Opt_nocephx_require_signatures, "nocephx_require_signatures"},
-	{Opt_cephx_sign_messages, "cephx_sign_messages"},
-	{Opt_nocephx_sign_messages, "nocephx_sign_messages"},
-	{Opt_tcp_nodelay, "tcp_nodelay"},
-	{Opt_notcp_nodelay, "notcp_nodelay"},
-	{Opt_abort_on_full, "abort_on_full"},
-	{-1, NULL}
+static const struct fs_parameter_spec ceph_param_specs[] = {
+	fsparam_flag	("abort_on_full",		Opt_abort_on_full),
+	fsparam_flag_no ("cephx_require_signatures",	Opt_cephx_require_signatures),
+	fsparam_flag_no ("cephx_sign_messages",		Opt_cephx_sign_messages),
+	fsparam_flag_no ("crc",				Opt_crc),
+	fsparam_string	("fsid",			Opt_fsid),
+	fsparam_string	("ip",				Opt_ip),
+	fsparam_string	("key",				Opt_key),
+	fsparam_u32	("mount_timeout",		Opt_mount_timeout),
+	fsparam_string	("name",			Opt_name),
+	fsparam_u32	("osd_idle_ttl",		Opt_osd_idle_ttl),
+	fsparam_u32	("osd_request_timeout",		Opt_osd_request_timeout),
+	fsparam_u32	("osdkeepalive",		Opt_osdkeepalivetimeout),
+	__fsparam	(fs_param_is_s32, "osdtimeout", Opt_osdtimeout,
+			 fs_param_deprecated),
+	fsparam_string	("secret",			Opt_secret),
+	fsparam_flag_no ("share",			Opt_share),
+	fsparam_flag_no ("tcp_nodelay",			Opt_tcp_nodelay),
+	{}
+};
+
+static const struct fs_parameter_description ceph_parameters = {
+        .name           = "libceph",
+        .specs          = ceph_param_specs,
 };
 
+struct ceph_options *ceph_alloc_options(void)
+{
+	struct ceph_options *opt;
+
+	opt = kzalloc(sizeof(*opt), GFP_KERNEL);
+	if (!opt)
+		return NULL;
+
+	opt->mon_addr = kcalloc(CEPH_MAX_MON, sizeof(*opt->mon_addr),
+				GFP_KERNEL);
+	if (!opt->mon_addr) {
+		kfree(opt);
+		return NULL;
+	}
+
+	opt->flags = CEPH_OPT_DEFAULT;
+	opt->osd_keepalive_timeout = CEPH_OSD_KEEPALIVE_DEFAULT;
+	opt->mount_timeout = CEPH_MOUNT_TIMEOUT_DEFAULT;
+	opt->osd_idle_ttl = CEPH_OSD_IDLE_TTL_DEFAULT;
+	opt->osd_request_timeout = CEPH_OSD_REQUEST_TIMEOUT_DEFAULT;
+	return opt;
+}
+EXPORT_SYMBOL(ceph_alloc_options);
+
 void ceph_destroy_options(struct ceph_options *opt)
 {
 	dout("destroy_options %p\n", opt);
+	if (!opt)
+		return;
+
 	kfree(opt->name);
 	if (opt->key) {
 		ceph_crypto_key_destroy(opt->key);
@@ -317,7 +336,9 @@ void ceph_destroy_options(struct ceph_options *opt)
 EXPORT_SYMBOL(ceph_destroy_options);
 
 /* get secret from key store */
-static int get_secret(struct ceph_crypto_key *dst, const char *name) {
+static int get_secret(struct ceph_crypto_key *dst, const char *name,
+		      struct fs_context *fc)
+{
 	struct key *ukey;
 	int key_err;
 	int err = 0;
@@ -330,20 +351,20 @@ static int get_secret(struct ceph_crypto_key *dst, const char *name) {
 		key_err = PTR_ERR(ukey);
 		switch (key_err) {
 		case -ENOKEY:
-			pr_warn("ceph: Mount failed due to key not found: %s\n",
-				name);
+			errorf(fc, "libceph: Failed due to key not found: %s",
+			       name);
 			break;
 		case -EKEYEXPIRED:
-			pr_warn("ceph: Mount failed due to expired key: %s\n",
-				name);
+			errorf(fc, "libceph: Failed due to expired key: %s",
+			       name);
 			break;
 		case -EKEYREVOKED:
-			pr_warn("ceph: Mount failed due to revoked key: %s\n",
-				name);
+			errorf(fc, "libceph: Failed due to revoked key: %s",
+			       name);
 			break;
 		default:
-			pr_warn("ceph: Mount failed due to unknown key error %d: %s\n",
-				key_err, name);
+			errorf(fc, "libceph: Failed due to key error %d: %s",
+			       key_err, name);
 		}
 		err = -EPERM;
 		goto out;
@@ -361,217 +382,157 @@ static int get_secret(struct ceph_crypto_key *dst, const char *name) {
 	return err;
 }
 
-struct ceph_options *
-ceph_parse_options(char *options, const char *dev_name,
-			const char *dev_name_end,
-			int (*parse_extra_token)(char *c, void *private),
-			void *private)
+int ceph_parse_mon_ips(const char *buf, size_t len, struct ceph_options *opt,
+		       struct fs_context *fc)
 {
-	struct ceph_options *opt;
-	const char *c;
-	int err = -ENOMEM;
-	substring_t argstr[MAX_OPT_ARGS];
-
-	opt = kzalloc(sizeof(*opt), GFP_KERNEL);
-	if (!opt)
-		return ERR_PTR(-ENOMEM);
-	opt->mon_addr = kcalloc(CEPH_MAX_MON, sizeof(*opt->mon_addr),
-				GFP_KERNEL);
-	if (!opt->mon_addr)
-		goto out;
-
-	dout("parse_options %p options '%s' dev_name '%s'\n", opt, options,
-	     dev_name);
-
-	/* start with defaults */
-	opt->flags = CEPH_OPT_DEFAULT;
-	opt->osd_keepalive_timeout = CEPH_OSD_KEEPALIVE_DEFAULT;
-	opt->mount_timeout = CEPH_MOUNT_TIMEOUT_DEFAULT;
-	opt->osd_idle_ttl = CEPH_OSD_IDLE_TTL_DEFAULT;
-	opt->osd_request_timeout = CEPH_OSD_REQUEST_TIMEOUT_DEFAULT;
+	int ret;
 
-	/* get mon ip(s) */
 	/* ip1[:port1][,ip2[:port2]...] */
-	err = ceph_parse_ips(dev_name, dev_name_end, opt->mon_addr,
-			     CEPH_MAX_MON, &opt->num_mon);
-	if (err < 0)
-		goto out;
+	ret = ceph_parse_ips(buf, buf + len, opt->mon_addr, CEPH_MAX_MON,
+			     &opt->num_mon);
+	if (ret) {
+		errorf(fc, "libceph: Failed to parse monitor IPs: %d", ret);
+		return ret;
+	}
 
-	/* parse mount options */
-	while ((c = strsep(&options, ",")) != NULL) {
-		int token, intval;
-		if (!*c)
-			continue;
-		err = -EINVAL;
-		token = match_token((char *)c, opt_tokens, argstr);
-		if (token < 0 && parse_extra_token) {
-			/* extra? */
-			err = parse_extra_token((char *)c, private);
-			if (err < 0) {
-				pr_err("bad option at '%s'\n", c);
-				goto out;
-			}
-			continue;
-		}
-		if (token < Opt_last_int) {
-			err = match_int(&argstr[0], &intval);
-			if (err < 0) {
-				pr_err("bad option arg (not int) at '%s'\n", c);
-				goto out;
-			}
-			dout("got int token %d val %d\n", token, intval);
-		} else if (token > Opt_last_int && token < Opt_last_string) {
-			dout("got string token %d val %s\n", token,
-			     argstr[0].from);
-		} else {
-			dout("got token %d\n", token);
+	return 0;
+}
+EXPORT_SYMBOL(ceph_parse_mon_ips);
+
+int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
+		     struct fs_context *fc)
+{
+	struct fs_parse_result result;
+	int token, err;
+
+	token = fs_parse(fc, &ceph_parameters, param, &result);
+	dout("%s fs_parse '%s' token %d\n", __func__, param->key, token);
+	if (token < 0)
+		return token;
+
+	switch (token) {
+	case Opt_ip:
+		err = ceph_parse_ips(param->string,
+				     param->string + param->size,
+				     &opt->my_addr,
+				     1, NULL);
+		if (err) {
+			errorf(fc, "libceph: Failed to parse ip: %d", err);
+			return err;
 		}
-		switch (token) {
-		case Opt_ip:
-			err = ceph_parse_ips(argstr[0].from,
-					     argstr[0].to,
-					     &opt->my_addr,
-					     1, NULL);
-			if (err < 0)
-				goto out;
-			opt->flags |= CEPH_OPT_MYIP;
-			break;
+		opt->flags |= CEPH_OPT_MYIP;
+		break;
 
-		case Opt_fsid:
-			err = parse_fsid(argstr[0].from, &opt->fsid);
-			if (err == 0)
-				opt->flags |= CEPH_OPT_FSID;
-			break;
-		case Opt_name:
-			kfree(opt->name);
-			opt->name = kstrndup(argstr[0].from,
-					      argstr[0].to-argstr[0].from,
-					      GFP_KERNEL);
-			if (!opt->name) {
-				err = -ENOMEM;
-				goto out;
-			}
-			break;
-		case Opt_secret:
-			ceph_crypto_key_destroy(opt->key);
-			kfree(opt->key);
-
-		        opt->key = kzalloc(sizeof(*opt->key), GFP_KERNEL);
-			if (!opt->key) {
-				err = -ENOMEM;
-				goto out;
-			}
-			err = ceph_crypto_key_unarmor(opt->key, argstr[0].from);
-			if (err < 0)
-				goto out;
-			break;
-		case Opt_key:
-			ceph_crypto_key_destroy(opt->key);
-			kfree(opt->key);
-
-		        opt->key = kzalloc(sizeof(*opt->key), GFP_KERNEL);
-			if (!opt->key) {
-				err = -ENOMEM;
-				goto out;
-			}
-			err = get_secret(opt->key, argstr[0].from);
-			if (err < 0)
-				goto out;
-			break;
+	case Opt_fsid:
+		err = parse_fsid(param->string, &opt->fsid);
+		if (err) {
+			errorf(fc, "libceph: Failed to parse fsid: %d", err);
+			return err;
+		}
+		opt->flags |= CEPH_OPT_FSID;
+		break;
+	case Opt_name:
+		kfree(opt->name);
+		opt->name = param->string;
+		param->string = NULL;
+		break;
+	case Opt_secret:
+		ceph_crypto_key_destroy(opt->key);
+		kfree(opt->key);
 
-			/* misc */
-		case Opt_osdtimeout:
-			pr_warn("ignoring deprecated osdtimeout option\n");
-			break;
-		case Opt_osdkeepalivetimeout:
-			/* 0 isn't well defined right now, reject it */
-			if (intval < 1 || intval > INT_MAX / 1000) {
-				pr_err("osdkeepalive out of range\n");
-				err = -EINVAL;
-				goto out;
-			}
-			opt->osd_keepalive_timeout =
-					msecs_to_jiffies(intval * 1000);
-			break;
-		case Opt_osd_idle_ttl:
-			/* 0 isn't well defined right now, reject it */
-			if (intval < 1 || intval > INT_MAX / 1000) {
-				pr_err("osd_idle_ttl out of range\n");
-				err = -EINVAL;
-				goto out;
-			}
-			opt->osd_idle_ttl = msecs_to_jiffies(intval * 1000);
-			break;
-		case Opt_mount_timeout:
-			/* 0 is "wait forever" (i.e. infinite timeout) */
-			if (intval < 0 || intval > INT_MAX / 1000) {
-				pr_err("mount_timeout out of range\n");
-				err = -EINVAL;
-				goto out;
-			}
-			opt->mount_timeout = msecs_to_jiffies(intval * 1000);
-			break;
-		case Opt_osd_request_timeout:
-			/* 0 is "wait forever" (i.e. infinite timeout) */
-			if (intval < 0 || intval > INT_MAX / 1000) {
-				pr_err("osd_request_timeout out of range\n");
-				err = -EINVAL;
-				goto out;
-			}
-			opt->osd_request_timeout = msecs_to_jiffies(intval * 1000);
-			break;
+		opt->key = kzalloc(sizeof(*opt->key), GFP_KERNEL);
+		if (!opt->key)
+			return -ENOMEM;
+		err = ceph_crypto_key_unarmor(opt->key, param->string);
+		if (err) {
+			errorf(fc, "libceph: Failed to parse secret: %d", err);
+			return err;
+		}
+		break;
+	case Opt_key:
+		ceph_crypto_key_destroy(opt->key);
+		kfree(opt->key);
 
-		case Opt_share:
+		opt->key = kzalloc(sizeof(*opt->key), GFP_KERNEL);
+		if (!opt->key)
+			return -ENOMEM;
+		return get_secret(opt->key, param->string, fc);
+
+	case Opt_osdtimeout:
+		warnf(fc, "libceph: Ignoring osdtimeout");
+		break;
+	case Opt_osdkeepalivetimeout:
+		/* 0 isn't well defined right now, reject it */
+		if (result.uint_32 < 1 || result.uint_32 > INT_MAX / 1000)
+			goto out_of_range;
+		opt->osd_keepalive_timeout =
+		    msecs_to_jiffies(result.uint_32 * 1000);
+		break;
+	case Opt_osd_idle_ttl:
+		/* 0 isn't well defined right now, reject it */
+		if (result.uint_32 < 1 || result.uint_32 > INT_MAX / 1000)
+			goto out_of_range;
+		opt->osd_idle_ttl = msecs_to_jiffies(result.uint_32 * 1000);
+		break;
+	case Opt_mount_timeout:
+		/* 0 is "wait forever" (i.e. infinite timeout) */
+		if (result.uint_32 > INT_MAX / 1000)
+			goto out_of_range;
+		opt->mount_timeout = msecs_to_jiffies(result.uint_32 * 1000);
+		break;
+	case Opt_osd_request_timeout:
+		/* 0 is "wait forever" (i.e. infinite timeout) */
+		if (result.uint_32 > INT_MAX / 1000)
+			goto out_of_range;
+		opt->osd_request_timeout =
+		    msecs_to_jiffies(result.uint_32 * 1000);
+		break;
+
+	case Opt_share:
+		if (!result.negated)
 			opt->flags &= ~CEPH_OPT_NOSHARE;
-			break;
-		case Opt_noshare:
+		else
 			opt->flags |= CEPH_OPT_NOSHARE;
-			break;
-
-		case Opt_crc:
+		break;
+	case Opt_crc:
+		if (!result.negated)
 			opt->flags &= ~CEPH_OPT_NOCRC;
-			break;
-		case Opt_nocrc:
+		else
 			opt->flags |= CEPH_OPT_NOCRC;
-			break;
-
-		case Opt_cephx_require_signatures:
+		break;
+	case Opt_cephx_require_signatures:
+		if (!result.negated)
 			opt->flags &= ~CEPH_OPT_NOMSGAUTH;
-			break;
-		case Opt_nocephx_require_signatures:
+		else
 			opt->flags |= CEPH_OPT_NOMSGAUTH;
-			break;
-		case Opt_cephx_sign_messages:
+		break;
+	case Opt_cephx_sign_messages:
+		if (!result.negated)
 			opt->flags &= ~CEPH_OPT_NOMSGSIGN;
-			break;
-		case Opt_nocephx_sign_messages:
+		else
 			opt->flags |= CEPH_OPT_NOMSGSIGN;
-			break;
-
-		case Opt_tcp_nodelay:
+		break;
+	case Opt_tcp_nodelay:
+		if (!result.negated)
 			opt->flags |= CEPH_OPT_TCP_NODELAY;
-			break;
-		case Opt_notcp_nodelay:
+		else
 			opt->flags &= ~CEPH_OPT_TCP_NODELAY;
-			break;
+		break;
 
-		case Opt_abort_on_full:
-			opt->flags |= CEPH_OPT_ABORT_ON_FULL;
-			break;
+	case Opt_abort_on_full:
+		opt->flags |= CEPH_OPT_ABORT_ON_FULL;
+		break;
 
-		default:
-			BUG_ON(token);
-		}
+	default:
+		BUG();
 	}
 
-	/* success */
-	return opt;
+	return 0;
 
-out:
-	ceph_destroy_options(opt);
-	return ERR_PTR(err);
+out_of_range:
+	return invalf(fc, "libceph: %s out of range", param->key);
 }
-EXPORT_SYMBOL(ceph_parse_options);
+EXPORT_SYMBOL(ceph_parse_param);
 
 int ceph_print_client_options(struct seq_file *m, struct ceph_client *client,
 			      bool show_all)
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index e4cb3db2ee77..5b4bd8261002 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2004,10 +2004,8 @@ int ceph_parse_ips(const char *c, const char *end,
 	return 0;
 
 bad:
-	pr_err("parse_ips bad ip '%.*s'\n", (int)(end - c), c);
 	return ret;
 }
-EXPORT_SYMBOL(ceph_parse_ips);
 
 static int process_banner(struct ceph_connection *con)
 {
-- 
2.19.2


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9036724DF81
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Aug 2020 20:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgHUS2i (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Aug 2020 14:28:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbgHUS2T (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 21 Aug 2020 14:28:19 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45DA0230FF;
        Fri, 21 Aug 2020 18:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598034498;
        bh=1DfYOxWFy3g7yCl/mAi33qZBVTOj8rAn6OxzkU4ZsS4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LkY7/ZKNOhyfpbRNHxLBiFlaa39u0w9SR0KbZREfMlRAQHj4+F14beybhRfhfqxOh
         R2rvAUQ+dGM2c0VHXLnKo16dy/d/iZcucIuEw0hCe/TEDDHoTohddpvmx+m5ffRjs7
         pAIjrHrsOJGV37fzNZDh1IQCUlDcH3TwBWdgsdJk=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 07/14] ceph: crypto context handling for ceph
Date:   Fri, 21 Aug 2020 14:28:06 -0400
Message-Id: <20200821182813.52570-8-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200821182813.52570-1-jlayton@kernel.org>
References: <20200821182813.52570-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Eventually, we'll probably want to store the crypto context in a
dedicated field in the inode, but for now it's stored in a (plain)
xattr.

Also add support for "dummy" encryption (useful for testing with
automated test harnesses like xfstests).

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/Makefile |  1 +
 fs/ceph/crypto.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/crypto.h | 26 ++++++++++++++++++
 fs/ceph/inode.c  |  3 +++
 fs/ceph/super.c  | 37 ++++++++++++++++++++++++++
 fs/ceph/super.h  |  6 ++++-
 6 files changed, 141 insertions(+), 1 deletion(-)
 create mode 100644 fs/ceph/crypto.c
 create mode 100644 fs/ceph/crypto.h

diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
index 50c635dc7f71..1f77ca04c426 100644
--- a/fs/ceph/Makefile
+++ b/fs/ceph/Makefile
@@ -12,3 +12,4 @@ ceph-y := super.o inode.o dir.o file.o locks.o addr.o ioctl.o \
 
 ceph-$(CONFIG_CEPH_FSCACHE) += cache.o
 ceph-$(CONFIG_CEPH_FS_POSIX_ACL) += acl.o
+ceph-$(CONFIG_FS_ENCRYPTION) += crypto.o
diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
new file mode 100644
index 000000000000..22a09d422b72
--- /dev/null
+++ b/fs/ceph/crypto.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/ceph/ceph_debug.h>
+#include <linux/xattr.h>
+#include <linux/fscrypt.h>
+
+#include "super.h"
+#include "crypto.h"
+
+static int ceph_crypt_get_context(struct inode *inode, void *ctx, size_t len)
+{
+	int ret = __ceph_getxattr(inode, CEPH_XATTR_NAME_ENCRYPTION_CONTEXT, ctx, len);
+
+	if (ret > 0)
+		inode_set_flags(inode, S_ENCRYPTED, S_ENCRYPTED);
+	return ret;
+}
+
+static int ceph_crypt_set_context(struct inode *inode, const void *ctx, size_t len, void *fs_data)
+{
+	int ret;
+
+	WARN_ON_ONCE(fs_data);
+	ret = __ceph_setxattr(inode, CEPH_XATTR_NAME_ENCRYPTION_CONTEXT, ctx, len, XATTR_CREATE);
+	if (ret == 0)
+		inode_set_flags(inode, S_ENCRYPTED, S_ENCRYPTED);
+	return ret;
+}
+
+static bool ceph_crypt_empty_dir(struct inode *inode)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+
+	return ci->i_rsubdirs + ci->i_rfiles == 1;
+}
+
+static const union fscrypt_context *
+ceph_get_dummy_context(struct super_block *sb)
+{
+	return ceph_sb_to_client(sb)->dummy_enc_ctx.ctx;
+}
+
+static struct fscrypt_operations ceph_fscrypt_ops = {
+	.key_prefix		= "ceph:",
+	.get_context		= ceph_crypt_get_context,
+	.set_context		= ceph_crypt_set_context,
+	.get_dummy_context	= ceph_get_dummy_context,
+	.empty_dir		= ceph_crypt_empty_dir,
+	.max_namelen		= NAME_MAX,
+};
+
+int ceph_fscrypt_set_ops(struct super_block *sb)
+{
+	struct ceph_fs_client *fsc = sb->s_fs_info;
+
+	fscrypt_set_ops(sb, &ceph_fscrypt_ops);
+
+	if (ceph_test_mount_opt(fsc, TEST_DUMMY_ENC)) {
+		substring_t arg = { };
+
+		/* Ewwwwwwww */
+		if (fsc->mount_options->test_dummy_encryption) {
+			arg.from = fsc->mount_options->test_dummy_encryption;
+			arg.to = arg.from + strlen(arg.from) - 1;
+		}
+
+		return fscrypt_set_test_dummy_encryption(sb, &arg, &fsc->dummy_enc_ctx);
+	}
+	return 0;
+}
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
new file mode 100644
index 000000000000..309925b345fc
--- /dev/null
+++ b/fs/ceph/crypto.h
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Ceph fscrypt functionality
+ */
+
+#ifndef _CEPH_CRYPTO_H
+#define _CEPH_CRYPTO_H
+
+#ifdef CONFIG_FS_ENCRYPTION
+
+#define DUMMY_ENCRYPTION_ENABLED(fsc) ((fsc)->dummy_enc_ctx.ctx != NULL)
+
+int ceph_fscrypt_set_ops(struct super_block *sb);
+
+#else /* CONFIG_FS_ENCRYPTION */
+
+#define DUMMY_ENCRYPTION_ENABLED(fsc) (0)
+
+static inline int ceph_fscrypt_set_ops(struct super_block *sb)
+{
+	return 0;
+}
+
+#endif /* CONFIG_FS_ENCRYPTION */
+
+#endif
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 156b98bda6aa..877bdda40db8 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -532,6 +532,8 @@ void ceph_free_inode(struct inode *inode)
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
 	kfree(ci->i_symlink);
+	// FIXME: only call this once we have symlink support
+	// fscrypt_free_inode(inode);
 	kmem_cache_free(ceph_inode_cachep, ci);
 }
 
@@ -543,6 +545,7 @@ void ceph_evict_inode(struct inode *inode)
 
 	dout("evict_inode %p ino %llx.%llx\n", inode, ceph_vinop(inode));
 
+	fscrypt_put_encryption_info(inode);
 	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 7ec0e6d03d10..95f5a7cf60f2 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -20,6 +20,7 @@
 #include "super.h"
 #include "mds_client.h"
 #include "cache.h"
+#include "crypto.h"
 
 #include <linux/ceph/ceph_features.h>
 #include <linux/ceph/decode.h>
@@ -44,6 +45,7 @@ static void ceph_put_super(struct super_block *s)
 	struct ceph_fs_client *fsc = ceph_sb_to_client(s);
 
 	dout("put_super\n");
+	fscrypt_free_dummy_context(&fsc->dummy_enc_ctx);
 	ceph_mdsc_close_sessions(fsc->mdsc);
 }
 
@@ -159,6 +161,7 @@ enum {
 	Opt_quotadf,
 	Opt_copyfrom,
 	Opt_wsync,
+	Opt_test_dummy_encryption,
 };
 
 enum ceph_recover_session_mode {
@@ -197,6 +200,8 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
 	fsparam_u32	("rsize",			Opt_rsize),
 	fsparam_string	("snapdirname",			Opt_snapdirname),
 	fsparam_string	("source",			Opt_source),
+	fsparam_flag_no ("test_dummy_encryption",	Opt_test_dummy_encryption),
+	fsparam_string	("test_dummy_encryption",	Opt_test_dummy_encryption),
 	fsparam_u32	("wsize",			Opt_wsize),
 	fsparam_flag_no	("wsync",			Opt_wsync),
 	{}
@@ -455,6 +460,21 @@ static int ceph_parse_mount_param(struct fs_context *fc,
 		else
 			fsopt->flags |= CEPH_MOUNT_OPT_ASYNC_DIROPS;
 		break;
+	case Opt_test_dummy_encryption:
+		kfree(fsopt->test_dummy_encryption);
+		fsopt->test_dummy_encryption = NULL;
+		if (!result.negated) {
+#ifdef CONFIG_FS_ENCRYPTION
+			fsopt->test_dummy_encryption = param->string;
+			param->string = NULL;
+			fsopt->flags |= CEPH_MOUNT_OPT_TEST_DUMMY_ENC;
+#else
+			return warnfc(fc, "FS encryption not supported: test_dummy_encryption mount option ignored");
+#endif
+		} else {
+			fsopt->flags &= ~CEPH_MOUNT_OPT_TEST_DUMMY_ENC;
+		}
+		break;
 	default:
 		BUG();
 	}
@@ -474,6 +494,7 @@ static void destroy_mount_options(struct ceph_mount_options *args)
 	kfree(args->mds_namespace);
 	kfree(args->server_path);
 	kfree(args->fscache_uniq);
+	kfree(args->test_dummy_encryption);
 	kfree(args);
 }
 
@@ -581,6 +602,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
 	if (fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS)
 		seq_puts(m, ",nowsync");
 
+	fscrypt_show_test_dummy_encryption(m, ',', root->d_sb);
+
 	if (fsopt->wsize != CEPH_MAX_WRITE_SIZE)
 		seq_printf(m, ",wsize=%u", fsopt->wsize);
 	if (fsopt->rsize != CEPH_MAX_READ_SIZE)
@@ -984,7 +1007,12 @@ static int ceph_set_super(struct super_block *s, struct fs_context *fc)
 	s->s_time_min = 0;
 	s->s_time_max = U32_MAX;
 
+	ret = ceph_fscrypt_set_ops(s);
+	if (ret)
+		goto out;
+
 	ret = set_anon_super_fc(s, fc);
+out:
 	if (ret != 0)
 		fsc->sb = NULL;
 	return ret;
@@ -1140,6 +1168,15 @@ static int ceph_reconfigure_fc(struct fs_context *fc)
 	else
 		ceph_clear_mount_opt(fsc, ASYNC_DIROPS);
 
+	/* Don't allow test_dummy_encryption to change on remount */
+	if (fsopt->flags & CEPH_MOUNT_OPT_TEST_DUMMY_ENC) {
+		if (!ceph_test_mount_opt(fsc, TEST_DUMMY_ENC))
+			return -EEXIST;
+	} else {
+		if (ceph_test_mount_opt(fsc, TEST_DUMMY_ENC))
+			return -EEXIST;
+	}
+
 	sync_filesystem(fc->root->d_sb);
 	return 0;
 }
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index b3aa2395b66e..6327b5739286 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -44,6 +44,7 @@
 #define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in statfs */
 #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-from' op */
 #define CEPH_MOUNT_OPT_ASYNC_DIROPS    (1<<15) /* allow async directory ops */
+#define CEPH_MOUNT_OPT_TEST_DUMMY_ENC  (1<<16) /* enable dummy encryption (for testing) */
 
 #define CEPH_MOUNT_OPT_DEFAULT			\
 	(CEPH_MOUNT_OPT_DCACHE |		\
@@ -96,6 +97,7 @@ struct ceph_mount_options {
 	char *mds_namespace;  /* default NULL */
 	char *server_path;    /* default NULL (means "/") */
 	char *fscache_uniq;   /* default NULL */
+	char *test_dummy_encryption;	/* default NULL */
 };
 
 struct ceph_fs_client {
@@ -135,9 +137,11 @@ struct ceph_fs_client {
 #ifdef CONFIG_CEPH_FSCACHE
 	struct fscache_cookie *fscache;
 #endif
+#ifdef CONFIG_FS_ENCRYPTION
+	struct fscrypt_dummy_context dummy_enc_ctx;
+#endif
 };
 
-
 /*
  * File i/o capability.  This tracks shared state with the metadata
  * server that allows us to cache or writeback attributes or to read
-- 
2.26.2


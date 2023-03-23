Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8095B6C601D
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Mar 2023 07:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjCWG5c (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Mar 2023 02:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjCWG51 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Mar 2023 02:57:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F002DE74
        for <ceph-devel@vger.kernel.org>; Wed, 22 Mar 2023 23:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679554595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OfW//8ssRMndwW9/Sgr5S7/cA1cTP0iQYiqJ3Paitf4=;
        b=IyWts7HSdVAWuAsq7sygwZ+ytbOAipkUezxyw7C6ymGc4NcaCQlHrmsoNBdBjrUVdAC6Mz
        JQrxUCfaOYwPFsthWZJdWUfm3VXqNNwX6fKbpWgf/HOEw3EL9e1Nfn9je+9fjFTAwf4DNp
        iRARWZw2Gw39COqaSKOTAf7dW9onx0s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-V_YGMCPHP2yIAjpWbSlapw-1; Thu, 23 Mar 2023 02:56:31 -0400
X-MC-Unique: V_YGMCPHP2yIAjpWbSlapw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F315855304;
        Thu, 23 Mar 2023 06:56:31 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92280492B01;
        Thu, 23 Mar 2023 06:56:28 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v17 15/71] ceph: implement -o test_dummy_encryption mount option
Date:   Thu, 23 Mar 2023 14:54:29 +0800
Message-Id: <20230323065525.201322-16-xiubli@redhat.com>
In-Reply-To: <20230323065525.201322-1-xiubli@redhat.com>
References: <20230323065525.201322-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Add support for the test_dummy_encryption mount option. This allows us
to test the encrypted codepaths in ceph without having to manually set
keys, etc.

Luís Henriques has fixed a potential 'fsc->fsc_dummy_enc_policy' memory
leak bug in mount error path.

Cc: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/crypto.c | 53 ++++++++++++++++++++++++++++++
 fs/ceph/crypto.h | 26 +++++++++++++++
 fs/ceph/inode.c  | 10 ++++--
 fs/ceph/super.c  | 85 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/ceph/super.h  |  9 ++++-
 fs/ceph/xattr.c  |  3 ++
 6 files changed, 180 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index a513ff373b13..fd3192917e8d 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -4,6 +4,7 @@
 #include <linux/fscrypt.h>
 
 #include "super.h"
+#include "mds_client.h"
 #include "crypto.h"
 
 static int ceph_crypt_get_context(struct inode *inode, void *ctx, size_t len)
@@ -64,9 +65,15 @@ static bool ceph_crypt_empty_dir(struct inode *inode)
 	return ci->i_rsubdirs + ci->i_rfiles == 1;
 }
 
+static const union fscrypt_policy *ceph_get_dummy_policy(struct super_block *sb)
+{
+	return ceph_sb_to_client(sb)->fsc_dummy_enc_policy.policy;
+}
+
 static struct fscrypt_operations ceph_fscrypt_ops = {
 	.get_context		= ceph_crypt_get_context,
 	.set_context		= ceph_crypt_set_context,
+	.get_dummy_policy	= ceph_get_dummy_policy,
 	.empty_dir		= ceph_crypt_empty_dir,
 };
 
@@ -74,3 +81,49 @@ void ceph_fscrypt_set_ops(struct super_block *sb)
 {
 	fscrypt_set_ops(sb, &ceph_fscrypt_ops);
 }
+
+void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc)
+{
+	fscrypt_free_dummy_policy(&fsc->fsc_dummy_enc_policy);
+}
+
+int ceph_fscrypt_prepare_context(struct inode *dir, struct inode *inode,
+				 struct ceph_acl_sec_ctx *as)
+{
+	int ret, ctxsize;
+	bool encrypted = false;
+	struct ceph_inode_info *ci = ceph_inode(inode);
+
+	ret = fscrypt_prepare_new_inode(dir, inode, &encrypted);
+	if (ret)
+		return ret;
+	if (!encrypted)
+		return 0;
+
+	as->fscrypt_auth = kzalloc(sizeof(*as->fscrypt_auth), GFP_KERNEL);
+	if (!as->fscrypt_auth)
+		return -ENOMEM;
+
+	ctxsize = fscrypt_context_for_new_inode(as->fscrypt_auth->cfa_blob, inode);
+	if (ctxsize < 0)
+		return ctxsize;
+
+	as->fscrypt_auth->cfa_version = cpu_to_le32(CEPH_FSCRYPT_AUTH_VERSION);
+	as->fscrypt_auth->cfa_blob_len = cpu_to_le32(ctxsize);
+
+	WARN_ON_ONCE(ci->fscrypt_auth);
+	kfree(ci->fscrypt_auth);
+	ci->fscrypt_auth_len = ceph_fscrypt_auth_len(as->fscrypt_auth);
+	ci->fscrypt_auth = kmemdup(as->fscrypt_auth, ci->fscrypt_auth_len, GFP_KERNEL);
+	if (!ci->fscrypt_auth)
+		return -ENOMEM;
+
+	inode->i_flags |= S_ENCRYPTED;
+
+	return 0;
+}
+
+void ceph_fscrypt_as_ctx_to_req(struct ceph_mds_request *req, struct ceph_acl_sec_ctx *as)
+{
+	swap(req->r_fscrypt_auth, as->fscrypt_auth);
+}
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index 6dca674f79b8..cb00fe42d5b7 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -8,6 +8,10 @@
 
 #include <linux/fscrypt.h>
 
+struct ceph_fs_client;
+struct ceph_acl_sec_ctx;
+struct ceph_mds_request;
+
 struct ceph_fscrypt_auth {
 	__le32	cfa_version;
 	__le32	cfa_blob_len;
@@ -25,12 +29,34 @@ static inline u32 ceph_fscrypt_auth_len(struct ceph_fscrypt_auth *fa)
 #ifdef CONFIG_FS_ENCRYPTION
 void ceph_fscrypt_set_ops(struct super_block *sb);
 
+void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc);
+
+int ceph_fscrypt_prepare_context(struct inode *dir, struct inode *inode,
+				 struct ceph_acl_sec_ctx *as);
+void ceph_fscrypt_as_ctx_to_req(struct ceph_mds_request *req, struct ceph_acl_sec_ctx *as);
+
 #else /* CONFIG_FS_ENCRYPTION */
 
 static inline void ceph_fscrypt_set_ops(struct super_block *sb)
 {
 }
 
+static inline void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc)
+{
+}
+
+static inline int ceph_fscrypt_prepare_context(struct inode *dir, struct inode *inode,
+						struct ceph_acl_sec_ctx *as)
+{
+	if (IS_ENCRYPTED(dir))
+		return -EOPNOTSUPP;
+	return 0;
+}
+
+static inline void ceph_fscrypt_as_ctx_to_req(struct ceph_mds_request *req,
+						struct ceph_acl_sec_ctx *as_ctx)
+{
+}
 #endif /* CONFIG_FS_ENCRYPTION */
 
 #endif
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 36ab0bb56a07..8b6b12a5a5e2 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -83,12 +83,17 @@ struct inode *ceph_new_inode(struct inode *dir, struct dentry *dentry,
 			goto out_err;
 	}
 
+	inode->i_state = 0;
+	inode->i_mode = *mode;
+
 	err = ceph_security_init_secctx(dentry, *mode, as_ctx);
 	if (err < 0)
 		goto out_err;
 
-	inode->i_state = 0;
-	inode->i_mode = *mode;
+	err = ceph_fscrypt_prepare_context(dir, inode, as_ctx);
+	if (err)
+		goto out_err;
+
 	return inode;
 out_err:
 	iput(inode);
@@ -101,6 +106,7 @@ void ceph_as_ctx_to_req(struct ceph_mds_request *req, struct ceph_acl_sec_ctx *a
 		req->r_pagelist = as_ctx->pagelist;
 		as_ctx->pagelist = NULL;
 	}
+	ceph_fscrypt_as_ctx_to_req(req, as_ctx);
 }
 
 /**
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 88e3f3bacc4e..b9dd2fa36d8b 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -47,6 +47,7 @@ static void ceph_put_super(struct super_block *s)
 	struct ceph_fs_client *fsc = ceph_sb_to_client(s);
 
 	dout("put_super\n");
+	ceph_fscrypt_free_dummy_policy(fsc);
 	ceph_mdsc_close_sessions(fsc->mdsc);
 }
 
@@ -152,6 +153,7 @@ enum {
 	Opt_recover_session,
 	Opt_source,
 	Opt_mon_addr,
+	Opt_test_dummy_encryption,
 	/* string args above */
 	Opt_dirstat,
 	Opt_rbytes,
@@ -194,6 +196,7 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
 	fsparam_string	("fsc",				Opt_fscache), // fsc=...
 	fsparam_flag_no ("ino32",			Opt_ino32),
 	fsparam_string	("mds_namespace",		Opt_mds_namespace),
+	fsparam_string	("mon_addr",			Opt_mon_addr),
 	fsparam_flag_no ("poolperm",			Opt_poolperm),
 	fsparam_flag_no ("quotadf",			Opt_quotadf),
 	fsparam_u32	("rasize",			Opt_rasize),
@@ -205,7 +208,8 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
 	fsparam_u32	("rsize",			Opt_rsize),
 	fsparam_string	("snapdirname",			Opt_snapdirname),
 	fsparam_string	("source",			Opt_source),
-	fsparam_string	("mon_addr",			Opt_mon_addr),
+	fsparam_flag	("test_dummy_encryption",	Opt_test_dummy_encryption),
+	fsparam_string	("test_dummy_encryption",	Opt_test_dummy_encryption),
 	fsparam_u32	("wsize",			Opt_wsize),
 	fsparam_flag_no	("wsync",			Opt_wsync),
 	fsparam_flag_no	("pagecache",			Opt_pagecache),
@@ -585,6 +589,23 @@ static int ceph_parse_mount_param(struct fs_context *fc,
 		else
 			fsopt->flags |= CEPH_MOUNT_OPT_SPARSEREAD;
 		break;
+	case Opt_test_dummy_encryption:
+#ifdef CONFIG_FS_ENCRYPTION
+		fscrypt_free_dummy_policy(&fsopt->dummy_enc_policy);
+		ret = fscrypt_parse_test_dummy_encryption(param,
+						&fsopt->dummy_enc_policy);
+		if (ret == -EINVAL) {
+			warnfc(fc, "Value of option \"%s\" is unrecognized",
+			       param->key);
+		} else if (ret == -EEXIST) {
+			warnfc(fc, "Conflicting test_dummy_encryption options");
+			ret = -EINVAL;
+		}
+#else
+		warnfc(fc,
+		       "FS encryption not supported: test_dummy_encryption mount option ignored");
+#endif
+		break;
 	default:
 		BUG();
 	}
@@ -605,6 +626,7 @@ static void destroy_mount_options(struct ceph_mount_options *args)
 	kfree(args->server_path);
 	kfree(args->fscache_uniq);
 	kfree(args->mon_addr);
+	fscrypt_free_dummy_policy(&args->dummy_enc_policy);
 	kfree(args);
 }
 
@@ -724,6 +746,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
 	if (fsopt->flags & CEPH_MOUNT_OPT_SPARSEREAD)
 		seq_puts(m, ",sparseread");
 
+	fscrypt_show_test_dummy_encryption(m, ',', root->d_sb);
+
 	if (fsopt->wsize != CEPH_MAX_WRITE_SIZE)
 		seq_printf(m, ",wsize=%u", fsopt->wsize);
 	if (fsopt->rsize != CEPH_MAX_READ_SIZE)
@@ -1062,6 +1086,50 @@ static struct dentry *open_root_dentry(struct ceph_fs_client *fsc,
 	return root;
 }
 
+#ifdef CONFIG_FS_ENCRYPTION
+static int ceph_apply_test_dummy_encryption(struct super_block *sb,
+					    struct fs_context *fc,
+					    struct ceph_mount_options *fsopt)
+{
+	struct ceph_fs_client *fsc = sb->s_fs_info;
+
+	if (!fscrypt_is_dummy_policy_set(&fsopt->dummy_enc_policy))
+		return 0;
+
+	/* No changing encryption context on remount. */
+	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE &&
+	    !fscrypt_is_dummy_policy_set(&fsc->fsc_dummy_enc_policy)) {
+		if (fscrypt_dummy_policies_equal(&fsopt->dummy_enc_policy,
+						 &fsc->fsc_dummy_enc_policy))
+			return 0;
+		errorfc(fc, "Can't set test_dummy_encryption on remount");
+		return -EINVAL;
+	}
+
+	/* Also make sure fsopt doesn't contain a conflicting value. */
+	if (fscrypt_is_dummy_policy_set(&fsc->fsc_dummy_enc_policy)) {
+		if (fscrypt_dummy_policies_equal(&fsopt->dummy_enc_policy,
+						 &fsc->fsc_dummy_enc_policy))
+			return 0;
+		errorfc(fc, "Conflicting test_dummy_encryption options");
+		return -EINVAL;
+	}
+
+	fsc->fsc_dummy_enc_policy = fsopt->dummy_enc_policy;
+	memset(&fsopt->dummy_enc_policy, 0, sizeof(fsopt->dummy_enc_policy));
+
+	warnfc(fc, "test_dummy_encryption mode enabled");
+	return 0;
+}
+#else
+static int ceph_apply_test_dummy_encryption(struct super_block *sb,
+					    struct fs_context *fc,
+					    struct ceph_mount_options *fsopt)
+{
+	return 0;
+}
+#endif
+
 /*
  * mount: join the ceph cluster, and open root directory.
  */
@@ -1090,6 +1158,10 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
 				goto out;
 		}
 
+		err = ceph_apply_test_dummy_encryption(fsc->sb, fc, fsc->mount_options);
+		if (err)
+			goto out;
+
 		dout("mount opening path '%s'\n", path);
 
 		ceph_fs_debugfs_init(fsc);
@@ -1111,6 +1183,7 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
 
 out:
 	mutex_unlock(&fsc->client->mount_mutex);
+	ceph_fscrypt_free_dummy_policy(fsc);
 	return ERR_PTR(err);
 }
 
@@ -1299,9 +1372,15 @@ static void ceph_free_fc(struct fs_context *fc)
 
 static int ceph_reconfigure_fc(struct fs_context *fc)
 {
+	int err;
 	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
 	struct ceph_mount_options *fsopt = pctx->opts;
-	struct ceph_fs_client *fsc = ceph_sb_to_client(fc->root->d_sb);
+	struct super_block *sb = fc->root->d_sb;
+	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
+
+	err = ceph_apply_test_dummy_encryption(sb, fc, fsopt);
+	if (err)
+		return err;
 
 	if (fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS)
 		ceph_set_mount_opt(fsc, ASYNC_DIROPS);
@@ -1320,7 +1399,7 @@ static int ceph_reconfigure_fc(struct fs_context *fc)
 		pr_notice("ceph: monitor addresses recorded, but not used for reconnection");
 	}
 
-	sync_filesystem(fc->root->d_sb);
+	sync_filesystem(sb);
 	return 0;
 }
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 8d4984a8b15b..355701a1ac70 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -22,6 +22,7 @@
 #include <linux/hashtable.h>
 
 #include <linux/ceph/libceph.h>
+#include "crypto.h"
 
 /* large granularity for statfs utilization stats to facilitate
  * large volume sizes on 32-bit machines. */
@@ -99,6 +100,7 @@ struct ceph_mount_options {
 	char *server_path;    /* default NULL (means "/") */
 	char *fscache_uniq;   /* default NULL */
 	char *mon_addr;
+	struct fscrypt_dummy_policy dummy_enc_policy;
 };
 
 /* mount state */
@@ -155,9 +157,11 @@ struct ceph_fs_client {
 #ifdef CONFIG_CEPH_FSCACHE
 	struct fscache_volume *fscache;
 #endif
+#ifdef CONFIG_FS_ENCRYPTION
+	struct fscrypt_dummy_policy fsc_dummy_enc_policy;
+#endif
 };
 
-
 /*
  * File i/o capability.  This tracks shared state with the metadata
  * server that allows us to cache or writeback attributes or to read
@@ -1106,6 +1110,9 @@ struct ceph_acl_sec_ctx {
 #ifdef CONFIG_CEPH_FS_SECURITY_LABEL
 	void *sec_ctx;
 	u32 sec_ctxlen;
+#endif
+#ifdef CONFIG_FS_ENCRYPTION
+	struct ceph_fscrypt_auth *fscrypt_auth;
 #endif
 	struct ceph_pagelist *pagelist;
 };
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index f65b07cc33a2..d2242d7b082e 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -1401,6 +1401,9 @@ void ceph_release_acl_sec_ctx(struct ceph_acl_sec_ctx *as_ctx)
 #endif
 #ifdef CONFIG_CEPH_FS_SECURITY_LABEL
 	security_release_secctx(as_ctx->sec_ctx, as_ctx->sec_ctxlen);
+#endif
+#ifdef CONFIG_FS_ENCRYPTION
+	kfree(as_ctx->fscrypt_auth);
 #endif
 	if (as_ctx->pagelist)
 		ceph_pagelist_release(as_ctx->pagelist);
-- 
2.31.1


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEEC15A409
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Feb 2020 09:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgBLIz1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Feb 2020 03:55:27 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60422 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728574AbgBLIz1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 Feb 2020 03:55:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581497724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xHK2Ugb2SFUtA4vaCL+TrskjREH+D5LcZNcJI+8BsMQ=;
        b=Vm3t4UF9eKTuaPDaPVyDzw+/L4J4/AnnR/ekPgtrpUnjiGx/f6cWvZB9ekTwtOXV0ktxrk
        FeMg4LAmMJHiUnhzx3KHox9hzat93QA8FCprnWshoXZxzAXaFNmrXq4O49gTj6MFpjEGzU
        Bbyf6j2SylTpWqHDOfih2pD87j1cbKE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-Plopxq5-MNWxgI6zCRjGjQ-1; Wed, 12 Feb 2020 03:55:17 -0500
X-MC-Unique: Plopxq5-MNWxgI6zCRjGjQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F005800E21;
        Wed, 12 Feb 2020 08:55:16 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-209.pek2.redhat.com [10.72.12.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E21810001AE;
        Wed, 12 Feb 2020 08:55:00 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fs add reconfiguring superblock parameters support
Date:   Wed, 12 Feb 2020 03:54:54 -0500
Message-Id: <20200212085454.35665-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will enable the remount and reconfiguring superblock params
for the fs. Currently some mount options are not allowed to be
reconfigured.

It will working like:
$ mount.ceph :/ /mnt/cephfs -o remount,mount_timeout=3D100

URL:https://tracker.ceph.com/issues/44071
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 block/bfq-cgroup.c           |   1 +
 drivers/block/rbd.c          |   2 +-
 fs/ceph/caps.c               |   2 +
 fs/ceph/mds_client.c         |   5 +-
 fs/ceph/super.c              | 126 +++++++++++++++++++++++++++++------
 fs/ceph/super.h              |   2 +
 include/linux/ceph/libceph.h |   4 +-
 net/ceph/ceph_common.c       |  83 ++++++++++++++++++++---
 8 files changed, 192 insertions(+), 33 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index e1419edde2ec..b3d42200182e 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -12,6 +12,7 @@
 #include <linux/ioprio.h>
 #include <linux/sbitmap.h>
 #include <linux/delay.h>
+#include <linux/rbtree.h>
=20
 #include "bfq-iosched.h"
=20
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 4e494d5600cc..470de27cf809 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -6573,7 +6573,7 @@ static int rbd_add_parse_args(const char *buf,
 	*(snap_name + len) =3D '\0';
 	pctx.spec->snap_name =3D snap_name;
=20
-	pctx.copts =3D ceph_alloc_options();
+	pctx.copts =3D ceph_alloc_options(NULL);
 	if (!pctx.copts)
 		goto out_mem;
=20
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index b4f122eb74bb..020f83186f94 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -491,10 +491,12 @@ static void __cap_set_timeouts(struct ceph_mds_clie=
nt *mdsc,
 {
 	struct ceph_mount_options *opt =3D mdsc->fsc->mount_options;
=20
+	spin_lock(&opt->ceph_opt_lock);
 	ci->i_hold_caps_min =3D round_jiffies(jiffies +
 					    opt->caps_wanted_delay_min * HZ);
 	ci->i_hold_caps_max =3D round_jiffies(jiffies +
 					    opt->caps_wanted_delay_max * HZ);
+	spin_unlock(&opt->ceph_opt_lock);
 	dout("__cap_set_timeouts %p min %lu max %lu\n", &ci->vfs_inode,
 	     ci->i_hold_caps_min - jiffies, ci->i_hold_caps_max - jiffies);
 }
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 376e7cf1685f..451c3727cd0b 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2099,6 +2099,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds=
_request *req,
 	struct ceph_inode_info *ci =3D ceph_inode(dir);
 	struct ceph_mds_reply_info_parsed *rinfo =3D &req->r_reply_info;
 	struct ceph_mount_options *opt =3D req->r_mdsc->fsc->mount_options;
+	unsigned int max_readdir =3D opt->max_readdir;
 	size_t size =3D sizeof(struct ceph_mds_reply_dir_entry);
 	unsigned int num_entries;
 	int order;
@@ -2107,7 +2108,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds=
_request *req,
 	num_entries =3D ci->i_files + ci->i_subdirs;
 	spin_unlock(&ci->i_ceph_lock);
 	num_entries =3D max(num_entries, 1U);
-	num_entries =3D min(num_entries, opt->max_readdir);
+	num_entries =3D min(num_entries, max_readdir);
=20
 	order =3D get_order(size * num_entries);
 	while (order >=3D 0) {
@@ -2122,7 +2123,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds=
_request *req,
 		return -ENOMEM;
=20
 	num_entries =3D (PAGE_SIZE << order) / size;
-	num_entries =3D min(num_entries, opt->max_readdir);
+	num_entries =3D min(num_entries, max_readdir);
=20
 	rinfo->dir_buf_size =3D PAGE_SIZE << order;
 	req->r_num_caps =3D num_entries + 1;
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 9a21054059f2..8df506dd9039 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1175,7 +1175,57 @@ static void ceph_free_fc(struct fs_context *fc)
=20
 static int ceph_reconfigure_fc(struct fs_context *fc)
 {
-	sync_filesystem(fc->root->d_sb);
+	struct super_block *sb =3D fc->root->d_sb;
+	struct ceph_fs_client *fsc =3D ceph_sb_to_client(sb);
+	struct ceph_mount_options *fsopt =3D fsc->mount_options;
+	struct ceph_parse_opts_ctx *pctx =3D fc->fs_private;
+	struct ceph_mount_options *new_fsopt =3D pctx->opts;
+	int ret;
+
+	sync_filesystem(sb);
+
+	ret =3D ceph_reconfigure_copts(fc, pctx->copts, fsc->client->options);
+	if (ret)
+		return ret;
+
+	if (new_fsopt->snapdir_name !=3D fsopt->snapdir_name)
+		return invalf(fc, "ceph: reconfiguration of snapdir_name not allowed")=
;
+
+	if (new_fsopt->mds_namespace !=3D fsopt->mds_namespace)
+		return invalf(fc, "ceph: reconfiguration of mds_namespace not allowed"=
);
+
+	if (new_fsopt->wsize !=3D fsopt->wsize)
+		return invalf(fc, "ceph: reconfiguration of wsize not allowed");
+	if (new_fsopt->rsize !=3D fsopt->rsize)
+		return invalf(fc, "ceph: reconfiguration of rsize not allowed");
+	if (new_fsopt->rasize !=3D fsopt->rasize)
+		return invalf(fc, "ceph: reconfiguration of rasize not allowed");
+
+#ifdef CONFIG_CEPH_FSCACHE
+	if (strcmp_null(new_fsopt->fscache_uniq, fsopt->fscache_uniq))
+		return invalf(fc, "ceph: reconfiguration of fscache not allowed");
+#endif
+
+	fsopt->flags =3D new_fsopt->flags;
+
+	spin_lock(&fsopt->ceph_opt_lock);
+	fsopt->caps_wanted_delay_min =3D new_fsopt->caps_wanted_delay_min;
+	fsopt->caps_wanted_delay_max =3D new_fsopt->caps_wanted_delay_max;
+	spin_unlock(&fsopt->ceph_opt_lock);
+
+	fsopt->max_readdir_bytes =3D new_fsopt->max_readdir_bytes;
+	fsopt->congestion_kb =3D new_fsopt->congestion_kb;
+
+	fsopt->caps_max =3D new_fsopt->caps_max;
+	fsopt->max_readdir =3D new_fsopt->max_readdir;
+	ceph_adjust_caps_max_min(fsc->mdsc, fsopt);
+
+#ifdef CONFIG_CEPH_FS_POSIX_ACL
+	if (fc->sb_flags & SB_POSIXACL)
+		sb->s_flags |=3D SB_POSIXACL;
+	else
+		sb->s_flags &=3D ~SB_POSIXACL;
+#endif
 	return 0;
 }
=20
@@ -1193,38 +1243,77 @@ static int ceph_init_fs_context(struct fs_context=
 *fc)
 {
 	struct ceph_parse_opts_ctx *pctx;
 	struct ceph_mount_options *fsopt;
+	struct ceph_options *copts =3D NULL;
=20
 	pctx =3D kzalloc(sizeof(*pctx), GFP_KERNEL);
 	if (!pctx)
 		return -ENOMEM;
=20
-	pctx->copts =3D ceph_alloc_options();
-	if (!pctx->copts)
-		goto nomem;
-
 	pctx->opts =3D kzalloc(sizeof(*pctx->opts), GFP_KERNEL);
 	if (!pctx->opts)
 		goto nomem;
=20
 	fsopt =3D pctx->opts;
-	fsopt->flags =3D CEPH_MOUNT_OPT_DEFAULT;
=20
-	fsopt->wsize =3D CEPH_MAX_WRITE_SIZE;
-	fsopt->rsize =3D CEPH_MAX_READ_SIZE;
-	fsopt->rasize =3D CEPH_RASIZE_DEFAULT;
-	fsopt->snapdir_name =3D kstrdup(CEPH_SNAPDIRNAME_DEFAULT, GFP_KERNEL);
-	if (!fsopt->snapdir_name)
-		goto nomem;
+#ifdef CONFIG_CEPH_FS_POSIX_ACL
+	fc->sb_flags |=3D SB_POSIXACL;
+#endif
+
+	if (fc->purpose =3D=3D FS_CONTEXT_FOR_RECONFIGURE) {
+		struct super_block *sb =3D fc->root->d_sb;
+		struct ceph_fs_client *fsc =3D ceph_sb_to_client(sb);
+		struct ceph_mount_options *old =3D fsc->mount_options;
+
+		copts =3D fsc->client->options;
+
+		fsopt->flags =3D old->flags;
=20
-	fsopt->caps_wanted_delay_min =3D CEPH_CAPS_WANTED_DELAY_MIN_DEFAULT;
-	fsopt->caps_wanted_delay_max =3D CEPH_CAPS_WANTED_DELAY_MAX_DEFAULT;
-	fsopt->max_readdir =3D CEPH_MAX_READDIR_DEFAULT;
-	fsopt->max_readdir_bytes =3D CEPH_MAX_READDIR_BYTES_DEFAULT;
-	fsopt->congestion_kb =3D default_congestion_kb();
+		fsopt->wsize =3D old->wsize;
+		fsopt->rsize =3D old->rsize;
+		fsopt->rasize =3D old->rasize;
+
+		fsopt->fscache_uniq =3D kstrdup(old->fscache_uniq, GFP_KERNEL);
+		if (!fsopt->fscache_uniq)
+			goto nomem;
+
+		fsopt->snapdir_name =3D kstrdup(old->snapdir_name, GFP_KERNEL);
+		if (!fsopt->snapdir_name)
+			goto nomem;
+
+		fsopt->caps_wanted_delay_min =3D old->caps_wanted_delay_min;
+		fsopt->caps_wanted_delay_max =3D old->caps_wanted_delay_max;
+		fsopt->max_readdir =3D old->max_readdir;
+		fsopt->max_readdir_bytes =3D old->max_readdir_bytes;
+		fsopt->congestion_kb =3D old->congestion_kb;
+		fsopt->caps_max =3D old->caps_max;
+		fsopt->max_readdir =3D old->max_readdir;
=20
 #ifdef CONFIG_CEPH_FS_POSIX_ACL
-	fc->sb_flags |=3D SB_POSIXACL;
+		if (!(sb->s_flags & SB_POSIXACL))
+			fc->sb_flags &=3D ~SB_POSIXACL;
 #endif
+	} else {
+		fsopt->flags =3D CEPH_MOUNT_OPT_DEFAULT;
+
+		fsopt->wsize =3D CEPH_MAX_WRITE_SIZE;
+		fsopt->rsize =3D CEPH_MAX_READ_SIZE;
+		fsopt->rasize =3D CEPH_RASIZE_DEFAULT;
+
+		fsopt->snapdir_name =3D kstrdup(CEPH_SNAPDIRNAME_DEFAULT, GFP_KERNEL);
+		if (!fsopt->snapdir_name)
+			goto nomem;
+
+		fsopt->caps_wanted_delay_min =3D CEPH_CAPS_WANTED_DELAY_MIN_DEFAULT;
+		fsopt->caps_wanted_delay_max =3D CEPH_CAPS_WANTED_DELAY_MAX_DEFAULT;
+		fsopt->max_readdir =3D CEPH_MAX_READDIR_DEFAULT;
+		fsopt->max_readdir_bytes =3D CEPH_MAX_READDIR_BYTES_DEFAULT;
+		fsopt->congestion_kb =3D default_congestion_kb();
+		spin_lock_init(&fsopt->ceph_opt_lock);
+	}
+
+	pctx->copts =3D ceph_alloc_options(copts);
+	if (!pctx->copts)
+		goto nomem;
=20
 	fc->fs_private =3D pctx;
 	fc->ops =3D &ceph_context_ops;
@@ -1232,7 +1321,6 @@ static int ceph_init_fs_context(struct fs_context *=
fc)
=20
 nomem:
 	destroy_mount_options(pctx->opts);
-	ceph_destroy_options(pctx->copts);
 	kfree(pctx);
 	return -ENOMEM;
 }
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 2acb09980432..ad44b98f3c3b 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -95,6 +95,8 @@ struct ceph_mount_options {
 	char *mds_namespace;  /* default NULL */
 	char *server_path;    /* default  "/" */
 	char *fscache_uniq;   /* default NULL */
+
+	spinlock_t ceph_opt_lock;
 };
=20
 struct ceph_fs_client {
diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 8fe9b80e80a5..407645adb2ad 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -281,11 +281,13 @@ extern int ceph_check_fsid(struct ceph_client *clie=
nt, struct ceph_fsid *fsid);
 extern void *ceph_kvmalloc(size_t size, gfp_t flags);
=20
 struct fs_parameter;
-struct ceph_options *ceph_alloc_options(void);
+struct ceph_options *ceph_alloc_options(struct ceph_options *old);
 int ceph_parse_mon_ips(const char *buf, size_t len, struct ceph_options =
*opt,
 		       struct fs_context *fc);
 int ceph_parse_param(struct fs_parameter *param, struct ceph_options *op=
t,
 		     struct fs_context *fc);
+int ceph_reconfigure_copts(struct fs_context *fc, struct ceph_options *n=
ew_opts,
+			   struct ceph_options *opts);
 int ceph_print_client_options(struct seq_file *m, struct ceph_client *cl=
ient,
 			      bool show_all);
 extern void ceph_destroy_options(struct ceph_options *opt);
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index a9d6c97b5b0d..39e628996595 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -295,7 +295,7 @@ static const struct fs_parameter_description ceph_par=
ameters =3D {
         .specs          =3D ceph_param_specs,
 };
=20
-struct ceph_options *ceph_alloc_options(void)
+struct ceph_options *ceph_alloc_options(struct ceph_options *old)
 {
 	struct ceph_options *opt;
=20
@@ -305,17 +305,49 @@ struct ceph_options *ceph_alloc_options(void)
=20
 	opt->mon_addr =3D kcalloc(CEPH_MAX_MON, sizeof(*opt->mon_addr),
 				GFP_KERNEL);
-	if (!opt->mon_addr) {
-		kfree(opt);
-		return NULL;
-	}
+	if (!opt->mon_addr)
+		goto err;
+
+	if (old) {
+		memcpy(&opt->my_addr, &old->my_addr, sizeof(opt->my_addr));
+		memcpy(&opt->fsid, &old->fsid, sizeof(opt->fsid));
+		if (old->name) {
+			opt->name =3D kstrdup(old->name, GFP_KERNEL);
+			if (!opt->name)
+				goto err;
+		}
=20
-	opt->flags =3D CEPH_OPT_DEFAULT;
-	opt->osd_keepalive_timeout =3D CEPH_OSD_KEEPALIVE_DEFAULT;
-	opt->mount_timeout =3D CEPH_MOUNT_TIMEOUT_DEFAULT;
-	opt->osd_idle_ttl =3D CEPH_OSD_IDLE_TTL_DEFAULT;
-	opt->osd_request_timeout =3D CEPH_OSD_REQUEST_TIMEOUT_DEFAULT;
+		if (old->key) {
+			opt->key =3D kmalloc(sizeof(*opt->key), GFP_KERNEL);
+			if (!opt->key)
+				goto err;
+
+			opt->key->type =3D old->key->type;
+			opt->key->created.tv_sec =3D old->key->created.tv_sec;
+			opt->key->created.tv_nsec =3D old->key->created.tv_nsec;
+			opt->key->len =3D old->key->len;
+			memcpy(opt->key->key, old->key->key, old->key->len);
+		}
+
+		opt->osd_keepalive_timeout =3D old->osd_keepalive_timeout;
+		opt->osd_idle_ttl =3D old->osd_idle_ttl;
+		opt->mount_timeout =3D old->mount_timeout;
+		opt->osd_request_timeout =3D old->osd_request_timeout;
+		opt->flags =3D old->flags;
+	} else {
+		opt->flags =3D CEPH_OPT_DEFAULT;
+		opt->osd_keepalive_timeout =3D CEPH_OSD_KEEPALIVE_DEFAULT;
+		opt->mount_timeout =3D CEPH_MOUNT_TIMEOUT_DEFAULT;
+		opt->osd_idle_ttl =3D CEPH_OSD_IDLE_TTL_DEFAULT;
+		opt->osd_request_timeout =3D CEPH_OSD_REQUEST_TIMEOUT_DEFAULT;
+	}
 	return opt;
+
+err:
+	kfree(opt->name);
+	kfree(opt->mon_addr);
+	kfree(opt);
+	return NULL;
 }
 EXPORT_SYMBOL(ceph_alloc_options);
=20
@@ -534,6 +566,37 @@ int ceph_parse_param(struct fs_parameter *param, str=
uct ceph_options *opt,
 }
 EXPORT_SYMBOL(ceph_parse_param);
=20
+int ceph_reconfigure_copts(struct fs_context *fc, struct ceph_options *n=
ew_opts,
+			   struct ceph_options *opts)
+{
+	if (memcmp(&new_opts->my_addr, &opts->my_addr,
+		   sizeof(opts->my_addr)))
+		return invalf(fc, "ceph: reconfiguration of ip not allowed");
+
+	if (memcmp(&new_opts->fsid, &opts->fsid, sizeof(opts->fsid)))
+		return invalf(fc, "ceph: reconfiguration of fsid not allowed");
+
+	if (strcmp_null(new_opts->name, opts->name))
+		return invalf(fc, "ceph: reconfiguration of name not allowed");
+
+	if (new_opts->key && (!opts->key ||
+		new_opts->key->type !=3D opts->key->type ||
+		new_opts->key->created.tv_sec !=3D opts->key->created.tv_sec ||
+		new_opts->key->created.tv_nsec !=3D opts->key->created.tv_nsec ||
+		new_opts->key->len !=3D opts->key->len ||
+		memcmp(new_opts->key->key, opts->key->key, opts->key->len)))
+		return invalf(fc, "ceph: reconfiguration of secret not allowed");
+
+	opts->osd_keepalive_timeout =3D new_opts->osd_keepalive_timeout;
+	opts->osd_idle_ttl =3D new_opts->osd_idle_ttl;
+	opts->mount_timeout =3D new_opts->mount_timeout;
+	opts->osd_request_timeout =3D new_opts->osd_request_timeout;
+	opts->flags =3D new_opts->flags;
+
+	return 0;
+}
+EXPORT_SYMBOL(ceph_reconfigure_copts);
+
 int ceph_print_client_options(struct seq_file *m, struct ceph_client *cl=
ient,
 			      bool show_all)
 {
--=20
2.21.0


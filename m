Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0635E15CFD8
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Feb 2020 03:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgBNCSs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 21:18:48 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53766 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728173AbgBNCSs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 13 Feb 2020 21:18:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581646726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QkQkaNlrRwVgRkQ/tIK4xRipsPgxeU3FlBJ0Hp9L9Hs=;
        b=YRydVwFhkZOfcfGjzMtBuhtSANmzg3OWhRNkyi/TLaG/tsT5OVOOZudd3VN3C3p5r+xKmU
        LRwnE0Mskc+Bdzx8JJi6/OZha7PoJywVmDFNdBWfQe9b7QF9N7yYnyMmGgEe35SUP29QVr
        A8Y2SlYkbTTwOch2GVIWoPOROhw1Ai8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-wKnLdRCNMp6vOqitjU108g-1; Thu, 13 Feb 2020 21:18:38 -0500
X-MC-Unique: wKnLdRCNMp6vOqitjU108g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DEEA1005516;
        Fri, 14 Feb 2020 02:18:37 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-209.pek2.redhat.com [10.72.12.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 017045C12E;
        Fri, 14 Feb 2020 02:18:31 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: fs add reconfiguring superblock parameters support
Date:   Thu, 13 Feb 2020 21:18:25 -0500
Message-Id: <20200214021825.1799-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

Changed in V2:
- remove low level options from reconfiguration.
- switch to seqlock

 fs/ceph/addr.c       |  10 +++-
 fs/ceph/caps.c       |  14 +++--
 fs/ceph/mds_client.c |   5 +-
 fs/ceph/super.c      | 137 ++++++++++++++++++++++++++++++++++++-------
 fs/ceph/super.h      |   2 +
 5 files changed, 138 insertions(+), 30 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index d14392b58f16..5c0e6c2d3fde 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -882,6 +882,7 @@ static int ceph_writepages_start(struct address_space=
 *mapping,
 	struct ceph_writeback_ctl ceph_wbc;
 	bool should_loop, range_whole =3D false;
 	bool done =3D false;
+	unsigned int seq;
=20
 	dout("writepages_start %p (mode=3D%s)\n", inode,
 	     wbc->sync_mode =3D=3D WB_SYNC_NONE ? "NONE" :
@@ -896,8 +897,13 @@ static int ceph_writepages_start(struct address_spac=
e *mapping,
 		mapping_set_error(mapping, -EIO);
 		return -EIO; /* we're in a forced umount, don't write! */
 	}
-	if (fsc->mount_options->wsize < wsize)
-		wsize =3D fsc->mount_options->wsize;
+
+	do {
+		seq =3D read_seqbegin(&fsc->mount_options->opt_seqlock);
+
+		if (fsc->mount_options->wsize < wsize)
+			wsize =3D fsc->mount_options->wsize;
+	} while (read_seqretry(&fsc->mount_options->opt_seqlock, seq));
=20
 	pagevec_init(&pvec);
=20
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index b4f122eb74bb..daa7eef13e3a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -490,11 +490,17 @@ static void __cap_set_timeouts(struct ceph_mds_clie=
nt *mdsc,
 			       struct ceph_inode_info *ci)
 {
 	struct ceph_mount_options *opt =3D mdsc->fsc->mount_options;
+	unsigned int seq;
+
+	do {
+		seq =3D read_seqbegin(&opt->opt_seqlock);
+
+		ci->i_hold_caps_min =3D round_jiffies(jiffies +
+					opt->caps_wanted_delay_min * HZ);
+		ci->i_hold_caps_max =3D round_jiffies(jiffies +
+					opt->caps_wanted_delay_max * HZ);
+	} while (read_seqretry(&opt->opt_seqlock, seq));
=20
-	ci->i_hold_caps_min =3D round_jiffies(jiffies +
-					    opt->caps_wanted_delay_min * HZ);
-	ci->i_hold_caps_max =3D round_jiffies(jiffies +
-					    opt->caps_wanted_delay_max * HZ);
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
index 7cb62d4cf812..500c0209041f 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -271,8 +271,14 @@ static int ceph_parse_mount_param(struct fs_context =
*fc,
 	int token, ret;
=20
 	ret =3D ceph_parse_param(param, pctx->copts, fc);
-	if (ret !=3D -ENOPARAM)
-		return ret;
+	if (ret !=3D -ENOPARAM) {
+		/* Low level options are not reconfigurable */
+		if (fc->purpose =3D=3D FS_CONTEXT_FOR_RECONFIGURE)
+			return invalf(fc, "ceph: reconfiguration of %s not allowed",
+				      param->key);
+		else
+			return ret;
+	}
=20
 	token =3D fs_parse(fc, &ceph_mount_parameters, param, &result);
 	dout("%s fs_parse '%s' token %d\n", __func__, param->key, token);
@@ -1070,14 +1076,17 @@ static int ceph_compare_super(struct super_block =
*sb, struct fs_context *fc)
  */
 static atomic_long_t bdi_seq =3D ATOMIC_LONG_INIT(0);
=20
-static int ceph_setup_bdi(struct super_block *sb, struct ceph_fs_client =
*fsc)
+static int ceph_setup_bdi(struct super_block *sb, struct ceph_fs_client =
*fsc,
+			  bool update)
 {
 	int err;
=20
-	err =3D super_setup_bdi_name(sb, "ceph-%ld",
-				   atomic_long_inc_return(&bdi_seq));
-	if (err)
-		return err;
+	if (!update) {
+		err =3D super_setup_bdi_name(sb, "ceph-%ld",
+					   atomic_long_inc_return(&bdi_seq));
+		if (err)
+			return err;
+	}
=20
 	/* set ra_pages based on rasize mount option? */
 	sb->s_bdi->ra_pages =3D fsc->mount_options->rasize >> PAGE_SHIFT;
@@ -1133,7 +1142,7 @@ static int ceph_get_tree(struct fs_context *fc)
 		dout("get_sb got existing client %p\n", fsc);
 	} else {
 		dout("get_sb using new client %p\n", fsc);
-		err =3D ceph_setup_bdi(sb, fsc);
+		err =3D ceph_setup_bdi(sb, fsc, false);
 		if (err < 0)
 			goto out_splat;
 	}
@@ -1178,7 +1187,52 @@ static void ceph_free_fc(struct fs_context *fc)
=20
 static int ceph_reconfigure_fc(struct fs_context *fc)
 {
-	sync_filesystem(fc->root->d_sb);
+	struct super_block *sb =3D fc->root->d_sb;
+	struct ceph_fs_client *fsc =3D ceph_sb_to_client(sb);
+	struct ceph_mount_options *fsopt =3D fsc->mount_options;
+	struct ceph_parse_opts_ctx *pctx =3D fc->fs_private;
+	struct ceph_mount_options *new_fsopt =3D pctx->opts;
+
+	sync_filesystem(sb);
+
+	if (strcmp_null(new_fsopt->snapdir_name, fsopt->snapdir_name))
+		return invalf(fc, "ceph: reconfiguration of snapdir_name not allowed")=
;
+
+	if (strcmp_null(new_fsopt->mds_namespace, fsopt->mds_namespace))
+		return invalf(fc, "ceph: reconfiguration of mds_namespace not allowed"=
);
+
+	fsopt->rsize =3D new_fsopt->rsize;
+	fsopt->rasize =3D new_fsopt->rasize;
+	ceph_setup_bdi(sb, fsc, true);
+
+	write_seqlock(&fsopt->opt_seqlock);
+	fsopt->wsize =3D new_fsopt->wsize;
+	fsopt->caps_wanted_delay_min =3D new_fsopt->caps_wanted_delay_min;
+	fsopt->caps_wanted_delay_max =3D new_fsopt->caps_wanted_delay_max;
+	write_sequnlock(&fsopt->opt_seqlock);
+
+#ifdef CONFIG_CEPH_FSCACHE
+	if (strcmp_null(new_fsopt->fscache_uniq, fsopt->fscache_uniq) ||
+	    ((new_fsopt->flags & CEPH_MOUNT_OPT_FSCACHE) !=3D
+	     (fsopt->flags & CEPH_MOUNT_OPT_FSCACHE)))
+		return invalf(fc, "ceph: reconfiguration of fscache not allowed");
+#endif
+
+	fsopt->flags =3D new_fsopt->flags;
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
@@ -1209,25 +1263,64 @@ static int ceph_init_fs_context(struct fs_context=
 *fc)
 	if (!pctx->opts)
 		goto nomem;
=20
+#ifdef CONFIG_CEPH_FS_POSIX_ACL
+	fc->sb_flags |=3D SB_POSIXACL;
+#endif
+
 	fsopt =3D pctx->opts;
-	fsopt->flags =3D CEPH_MOUNT_OPT_DEFAULT;
=20
-	fsopt->wsize =3D CEPH_MAX_WRITE_SIZE;
-	fsopt->rsize =3D CEPH_MAX_READ_SIZE;
-	fsopt->rasize =3D CEPH_RASIZE_DEFAULT;
-	fsopt->snapdir_name =3D kstrdup(CEPH_SNAPDIRNAME_DEFAULT, GFP_KERNEL);
-	if (!fsopt->snapdir_name)
-		goto nomem;
+	if (fc->purpose =3D=3D FS_CONTEXT_FOR_RECONFIGURE) {
+		struct super_block *sb =3D fc->root->d_sb;
+		struct ceph_fs_client *fsc =3D ceph_sb_to_client(sb);
+		struct ceph_mount_options *old =3D fsc->mount_options;
=20
-	fsopt->caps_wanted_delay_min =3D CEPH_CAPS_WANTED_DELAY_MIN_DEFAULT;
-	fsopt->caps_wanted_delay_max =3D CEPH_CAPS_WANTED_DELAY_MAX_DEFAULT;
-	fsopt->max_readdir =3D CEPH_MAX_READDIR_DEFAULT;
-	fsopt->max_readdir_bytes =3D CEPH_MAX_READDIR_BYTES_DEFAULT;
-	fsopt->congestion_kb =3D default_congestion_kb();
+		fsopt->flags =3D old->flags;
+
+		fsopt->wsize =3D old->wsize;
+		fsopt->rsize =3D old->rsize;
+		fsopt->rasize =3D old->rasize;
+
+		if (old->fscache_uniq) {
+			fsopt->fscache_uniq =3D kstrdup(old->fscache_uniq,
+						      GFP_KERNEL);
+			if (!fsopt->fscache_uniq)
+				goto nomem;
+		}
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
+		seqlock_init(&fsopt->opt_seqlock);
+	}
=20
 	fc->fs_private =3D pctx;
 	fc->ops =3D &ceph_context_ops;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 2acc9cc2d23a..aa0e7217a62f 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -96,6 +96,8 @@ struct ceph_mount_options {
 	char *mds_namespace;  /* default NULL */
 	char *server_path;    /* default  "/" */
 	char *fscache_uniq;   /* default NULL */
+
+	seqlock_t opt_seqlock;
 };
=20
 struct ceph_fs_client {
--=20
2.21.0


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C16B72D917
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 07:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240016AbjFMF23 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 01:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240020AbjFMF2S (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 01:28:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5A4E53
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 22:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686634037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KQvYdO/eBw2IVEzrl4YtgXQ2f0Mj5E6wej+dKVQawS8=;
        b=M/0RzoamHFISOgBcfDc2YxOGC6wOHC6ykFmk3xcTxaGeneT10EFWQ6DV+oWvncC7cJdCuI
        SnFmLrnGIjrrmmvIYxEqrpBYKXim0eiFh9Y+s8h11cxN9/UbSctTL46qhnzbAO1RbhAOrQ
        OHx96roP0LQG1zL45Jen+dSJuFVYKn0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-5YrvoXqdMkiAiVoTg1baIQ-1; Tue, 13 Jun 2023 01:27:15 -0400
X-MC-Unique: 5YrvoXqdMkiAiVoTg1baIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03CDA8032FE;
        Tue, 13 Jun 2023 05:27:15 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B9251121314;
        Tue, 13 Jun 2023 05:27:10 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v20 08/71] ceph: preallocate inode for ops that may create one
Date:   Tue, 13 Jun 2023 13:23:21 +0800
Message-Id: <20230613052424.254540-9-xiubli@redhat.com>
In-Reply-To: <20230613052424.254540-1-xiubli@redhat.com>
References: <20230613052424.254540-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

When creating a new inode, we need to determine the crypto context
before we can transmit the RPC. The fscrypt API has a routine for getting
a crypto context before a create occurs, but it requires an inode.

Change the ceph code to preallocate an inode in advance of a create of
any sort (open(), mknod(), symlink(), etc). Move the existing code that
generates the ACL and SELinux blobs into this routine since that's
mostly common across all the different codepaths.

In most cases, we just want to allow ceph_fill_trace to use that inode
after the reply comes in, so add a new field to the MDS request for it
(r_new_inode).

The async create codepath is a bit different though. In that case, we
want to hash the inode in advance of the RPC so that it can be used
before the reply comes in. If the call subsequently fails with
-EJUKEBOX, then just put the references and clean up the as_ctx. Note
that with this change, we now need to regenerate the as_ctx when this
occurs, but it's quite rare for it to happen.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c        | 70 ++++++++++++++++++++-----------------
 fs/ceph/file.c       | 59 ++++++++++++++++++-------------
 fs/ceph/inode.c      | 82 ++++++++++++++++++++++++++++++++++++++++----
 fs/ceph/mds_client.c | 13 +++++--
 fs/ceph/mds_client.h |  1 +
 fs/ceph/super.h      |  7 +++-
 6 files changed, 167 insertions(+), 65 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index cb67ac821f0e..0b8283611023 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -865,13 +865,6 @@ static int ceph_mknod(struct mnt_idmap *idmap, struct inode *dir,
 		goto out;
 	}
 
-	err = ceph_pre_init_acls(dir, &mode, &as_ctx);
-	if (err < 0)
-		goto out;
-	err = ceph_security_init_secctx(dentry, mode, &as_ctx);
-	if (err < 0)
-		goto out;
-
 	dout("mknod in dir %p dentry %p mode 0%ho rdev %d\n",
 	     dir, dentry, mode, rdev);
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_MKNOD, USE_AUTH_MDS);
@@ -879,6 +872,14 @@ static int ceph_mknod(struct mnt_idmap *idmap, struct inode *dir,
 		err = PTR_ERR(req);
 		goto out;
 	}
+
+	req->r_new_inode = ceph_new_inode(dir, dentry, &mode, &as_ctx);
+	if (IS_ERR(req->r_new_inode)) {
+		err = PTR_ERR(req->r_new_inode);
+		req->r_new_inode = NULL;
+		goto out_req;
+	}
+
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
 	req->r_parent = dir;
@@ -888,13 +889,13 @@ static int ceph_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	req->r_args.mknod.rdev = cpu_to_le32(rdev);
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
-	if (as_ctx.pagelist) {
-		req->r_pagelist = as_ctx.pagelist;
-		as_ctx.pagelist = NULL;
-	}
+
+	ceph_as_ctx_to_req(req, &as_ctx);
+
 	err = ceph_mdsc_do_request(mdsc, dir, req);
 	if (!err && !req->r_reply_info.head->is_dentry)
 		err = ceph_handle_notrace_create(dir, dentry);
+out_req:
 	ceph_mdsc_put_request(req);
 out:
 	if (!err)
@@ -917,6 +918,7 @@ static int ceph_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
 	struct ceph_mds_request *req;
 	struct ceph_acl_sec_ctx as_ctx = {};
+	umode_t mode = S_IFLNK | 0777;
 	int err;
 
 	if (ceph_snap(dir) != CEPH_NOSNAP)
@@ -931,21 +933,24 @@ static int ceph_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		goto out;
 	}
 
-	err = ceph_security_init_secctx(dentry, S_IFLNK | 0777, &as_ctx);
-	if (err < 0)
-		goto out;
-
 	dout("symlink in dir %p dentry %p to '%s'\n", dir, dentry, dest);
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_SYMLINK, USE_AUTH_MDS);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto out;
 	}
+
+	req->r_new_inode = ceph_new_inode(dir, dentry, &mode, &as_ctx);
+	if (IS_ERR(req->r_new_inode)) {
+		err = PTR_ERR(req->r_new_inode);
+		req->r_new_inode = NULL;
+		goto out_req;
+	}
+
 	req->r_path2 = kstrdup(dest, GFP_KERNEL);
 	if (!req->r_path2) {
 		err = -ENOMEM;
-		ceph_mdsc_put_request(req);
-		goto out;
+		goto out_req;
 	}
 	req->r_parent = dir;
 	ihold(dir);
@@ -955,13 +960,13 @@ static int ceph_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	req->r_num_caps = 2;
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
-	if (as_ctx.pagelist) {
-		req->r_pagelist = as_ctx.pagelist;
-		as_ctx.pagelist = NULL;
-	}
+
+	ceph_as_ctx_to_req(req, &as_ctx);
+
 	err = ceph_mdsc_do_request(mdsc, dir, req);
 	if (!err && !req->r_reply_info.head->is_dentry)
 		err = ceph_handle_notrace_create(dir, dentry);
+out_req:
 	ceph_mdsc_put_request(req);
 out:
 	if (err)
@@ -1002,13 +1007,6 @@ static int ceph_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 		goto out;
 	}
 
-	mode |= S_IFDIR;
-	err = ceph_pre_init_acls(dir, &mode, &as_ctx);
-	if (err < 0)
-		goto out;
-	err = ceph_security_init_secctx(dentry, mode, &as_ctx);
-	if (err < 0)
-		goto out;
 
 	req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
 	if (IS_ERR(req)) {
@@ -1016,6 +1014,14 @@ static int ceph_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 		goto out;
 	}
 
+	mode |= S_IFDIR;
+	req->r_new_inode = ceph_new_inode(dir, dentry, &mode, &as_ctx);
+	if (IS_ERR(req->r_new_inode)) {
+		err = PTR_ERR(req->r_new_inode);
+		req->r_new_inode = NULL;
+		goto out_req;
+	}
+
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
 	req->r_parent = dir;
@@ -1024,15 +1030,15 @@ static int ceph_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	req->r_args.mkdir.mode = cpu_to_le32(mode);
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
-	if (as_ctx.pagelist) {
-		req->r_pagelist = as_ctx.pagelist;
-		as_ctx.pagelist = NULL;
-	}
+
+	ceph_as_ctx_to_req(req, &as_ctx);
+
 	err = ceph_mdsc_do_request(mdsc, dir, req);
 	if (!err &&
 	    !req->r_reply_info.head->is_target &&
 	    !req->r_reply_info.head->is_dentry)
 		err = ceph_handle_notrace_create(dir, dentry);
+out_req:
 	ceph_mdsc_put_request(req);
 out:
 	if (!err)
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 1e2a306aafe4..e4dadad50f9b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -604,7 +604,8 @@ static void ceph_async_create_cb(struct ceph_mds_client *mdsc,
 	ceph_mdsc_release_dir_caps(req);
 }
 
-static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
+static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
+				    struct dentry *dentry,
 				    struct file *file, umode_t mode,
 				    struct ceph_mds_request *req,
 				    struct ceph_acl_sec_ctx *as_ctx,
@@ -616,7 +617,6 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 	struct ceph_mds_reply_info_in iinfo = { .in = &in };
 	struct ceph_inode_info *ci = ceph_inode(dir);
 	struct ceph_dentry_info *di = ceph_dentry(dentry);
-	struct inode *inode;
 	struct timespec64 now;
 	struct ceph_string *pool_ns;
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
@@ -625,10 +625,6 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 
 	ktime_get_real_ts64(&now);
 
-	inode = ceph_get_inode(dentry->d_sb, vino);
-	if (IS_ERR(inode))
-		return PTR_ERR(inode);
-
 	iinfo.inline_version = CEPH_INLINE_NONE;
 	iinfo.change_attr = 1;
 	ceph_encode_timespec64(&iinfo.btime, &now);
@@ -686,8 +682,7 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 		ceph_dir_clear_complete(dir);
 		if (!d_unhashed(dentry))
 			d_drop(dentry);
-		if (inode->i_state & I_NEW)
-			discard_new_inode(inode);
+		discard_new_inode(inode);
 	} else {
 		struct dentry *dn;
 
@@ -733,6 +728,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_mds_request *req;
+	struct inode *new_inode = NULL;
 	struct dentry *dn;
 	struct ceph_acl_sec_ctx as_ctx = {};
 	bool try_async = ceph_test_mount_opt(fsc, ASYNC_DIROPS);
@@ -755,15 +751,16 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	 */
 	flags &= ~O_TRUNC;
 
+retry:
 	if (flags & O_CREAT) {
 		if (ceph_quota_is_max_files_exceeded(dir))
 			return -EDQUOT;
-		err = ceph_pre_init_acls(dir, &mode, &as_ctx);
-		if (err < 0)
-			return err;
-		err = ceph_security_init_secctx(dentry, mode, &as_ctx);
-		if (err < 0)
+
+		new_inode = ceph_new_inode(dir, dentry, &mode, &as_ctx);
+		if (IS_ERR(new_inode)) {
+			err = PTR_ERR(new_inode);
 			goto out_ctx;
+		}
 		/* Async create can't handle more than a page of xattrs */
 		if (as_ctx.pagelist &&
 		    !list_is_singular(&as_ctx.pagelist->head))
@@ -772,7 +769,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		/* If it's not being looked up, it's negative */
 		return -ENOENT;
 	}
-retry:
+
 	/* do the open */
 	req = prepare_open_request(dir->i_sb, flags, mode);
 	if (IS_ERR(req)) {
@@ -793,32 +790,45 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 
 		req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
 		req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
-		if (as_ctx.pagelist) {
-			req->r_pagelist = as_ctx.pagelist;
-			as_ctx.pagelist = NULL;
-		}
-		if (try_async &&
-		    (req->r_dir_caps =
-		      try_prep_async_create(dir, dentry, &lo,
-					    &req->r_deleg_ino))) {
+
+		ceph_as_ctx_to_req(req, &as_ctx);
+
+		if (try_async && (req->r_dir_caps =
+				  try_prep_async_create(dir, dentry, &lo, &req->r_deleg_ino))) {
+			struct ceph_vino vino = { .ino = req->r_deleg_ino,
+						  .snap = CEPH_NOSNAP };
 			struct ceph_dentry_info *di = ceph_dentry(dentry);
 
 			set_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags);
 			req->r_args.open.flags |= cpu_to_le32(CEPH_O_EXCL);
 			req->r_callback = ceph_async_create_cb;
 
+			/* Hash inode before RPC */
+			new_inode = ceph_get_inode(dir->i_sb, vino, new_inode);
+			if (IS_ERR(new_inode)) {
+				err = PTR_ERR(new_inode);
+				new_inode = NULL;
+				goto out_req;
+			}
+			WARN_ON_ONCE(!(new_inode->i_state & I_NEW));
+
 			spin_lock(&dentry->d_lock);
 			di->flags |= CEPH_DENTRY_ASYNC_CREATE;
 			spin_unlock(&dentry->d_lock);
 
 			err = ceph_mdsc_submit_request(mdsc, dir, req);
 			if (!err) {
-				err = ceph_finish_async_create(dir, dentry,
+				err = ceph_finish_async_create(dir, new_inode, dentry,
 							file, mode, req,
 							&as_ctx, &lo);
+				new_inode = NULL;
 			} else if (err == -EJUKEBOX) {
 				restore_deleg_ino(dir, req->r_deleg_ino);
 				ceph_mdsc_put_request(req);
+				discard_new_inode(new_inode);
+				ceph_release_acl_sec_ctx(&as_ctx);
+				memset(&as_ctx, 0, sizeof(as_ctx));
+				new_inode = NULL;
 				try_async = false;
 				ceph_put_string(rcu_dereference_raw(lo.pool_ns));
 				goto retry;
@@ -829,6 +839,8 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	}
 
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
+	req->r_new_inode = new_inode;
+	new_inode = NULL;
 	err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, req);
 	if (err == -ENOENT) {
 		dentry = ceph_handle_snapdir(req, dentry);
@@ -869,6 +881,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	}
 out_req:
 	ceph_mdsc_put_request(req);
+	iput(new_inode);
 out_ctx:
 	ceph_release_acl_sec_ctx(&as_ctx);
 	dout("atomic_open result=%d\n", err);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 30ff541c919e..28ce848fcb4a 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -52,17 +52,85 @@ static int ceph_set_ino_cb(struct inode *inode, void *data)
 	return 0;
 }
 
-struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino)
+/**
+ * ceph_new_inode - allocate a new inode in advance of an expected create
+ * @dir: parent directory for new inode
+ * @dentry: dentry that may eventually point to new inode
+ * @mode: mode of new inode
+ * @as_ctx: pointer to inherited security context
+ *
+ * Allocate a new inode in advance of an operation to create a new inode.
+ * This allocates the inode and sets up the acl_sec_ctx with appropriate
+ * info for the new inode.
+ *
+ * Returns a pointer to the new inode or an ERR_PTR.
+ */
+struct inode *ceph_new_inode(struct inode *dir, struct dentry *dentry,
+			     umode_t *mode, struct ceph_acl_sec_ctx *as_ctx)
+{
+	int err;
+	struct inode *inode;
+
+	inode = new_inode(dir->i_sb);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	if (!S_ISLNK(*mode)) {
+		err = ceph_pre_init_acls(dir, mode, as_ctx);
+		if (err < 0)
+			goto out_err;
+	}
+
+	err = ceph_security_init_secctx(dentry, *mode, as_ctx);
+	if (err < 0)
+		goto out_err;
+
+	inode->i_state = 0;
+	inode->i_mode = *mode;
+	return inode;
+out_err:
+	iput(inode);
+	return ERR_PTR(err);
+}
+
+void ceph_as_ctx_to_req(struct ceph_mds_request *req, struct ceph_acl_sec_ctx *as_ctx)
+{
+	if (as_ctx->pagelist) {
+		req->r_pagelist = as_ctx->pagelist;
+		as_ctx->pagelist = NULL;
+	}
+}
+
+/**
+ * ceph_get_inode - find or create/hash a new inode
+ * @sb: superblock to search and allocate in
+ * @vino: vino to search for
+ * @newino: optional new inode to insert if one isn't found (may be NULL)
+ *
+ * Search for or insert a new inode into the hash for the given vino, and return a
+ * reference to it. If new is non-NULL, its reference is consumed.
+ */
+struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino, struct inode *newino)
 {
 	struct inode *inode;
 
 	if (ceph_vino_is_reserved(vino))
 		return ERR_PTR(-EREMOTEIO);
 
-	inode = iget5_locked(sb, (unsigned long)vino.ino, ceph_ino_compare,
-			     ceph_set_ino_cb, &vino);
-	if (!inode)
+	if (newino) {
+		inode = inode_insert5(newino, (unsigned long)vino.ino, ceph_ino_compare,
+					ceph_set_ino_cb, &vino);
+		if (inode != newino)
+			iput(newino);
+	} else {
+		inode = iget5_locked(sb, (unsigned long)vino.ino, ceph_ino_compare,
+				     ceph_set_ino_cb, &vino);
+	}
+
+	if (!inode) {
+		dout("No inode found for %llx.%llx\n", vino.ino, vino.snap);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	dout("get_inode on %llu=%llx.%llx got %p new %d\n", ceph_present_inode(inode),
 	     ceph_vinop(inode), inode, !!(inode->i_state & I_NEW));
@@ -78,7 +146,7 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 		.ino = ceph_ino(parent),
 		.snap = CEPH_SNAPDIR,
 	};
-	struct inode *inode = ceph_get_inode(parent->i_sb, vino);
+	struct inode *inode = ceph_get_inode(parent->i_sb, vino, NULL);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
 	if (IS_ERR(inode))
@@ -1552,7 +1620,7 @@ static int readdir_prepopulate_inodes_only(struct ceph_mds_request *req,
 		vino.ino = le64_to_cpu(rde->inode.in->ino);
 		vino.snap = le64_to_cpu(rde->inode.in->snapid);
 
-		in = ceph_get_inode(req->r_dentry->d_sb, vino);
+		in = ceph_get_inode(req->r_dentry->d_sb, vino, NULL);
 		if (IS_ERR(in)) {
 			err = PTR_ERR(in);
 			dout("new_inode badness got %d\n", err);
@@ -1754,7 +1822,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 		if (d_really_is_positive(dn)) {
 			in = d_inode(dn);
 		} else {
-			in = ceph_get_inode(parent->d_sb, tvino);
+			in = ceph_get_inode(parent->d_sb, tvino, NULL);
 			if (IS_ERR(in)) {
 				dout("new_inode badness\n");
 				d_drop(dn);
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 9cc84ae88832..feb511c29b9e 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -944,6 +944,7 @@ void ceph_mdsc_release_request(struct kref *kref)
 		iput(req->r_parent);
 	}
 	iput(req->r_target_inode);
+	iput(req->r_new_inode);
 	if (req->r_dentry)
 		dput(req->r_dentry);
 	if (req->r_old_dentry)
@@ -3385,13 +3386,21 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 
 	/* Must find target inode outside of mutexes to avoid deadlocks */
 	if ((err >= 0) && rinfo->head->is_target) {
-		struct inode *in;
+		struct inode *in = xchg(&req->r_new_inode, NULL);
 		struct ceph_vino tvino = {
 			.ino  = le64_to_cpu(rinfo->targeti.in->ino),
 			.snap = le64_to_cpu(rinfo->targeti.in->snapid)
 		};
 
-		in = ceph_get_inode(mdsc->fsc->sb, tvino);
+		/* If we ended up opening an existing inode, discard r_new_inode */
+		if (req->r_op == CEPH_MDS_OP_CREATE && !req->r_reply_info.has_create_ino) {
+			/* This should never happen on an async create */
+			WARN_ON_ONCE(req->r_deleg_ino);
+			iput(in);
+			in = NULL;
+		}
+
+		in = ceph_get_inode(mdsc->fsc->sb, tvino, in);
 		if (IS_ERR(in)) {
 			err = PTR_ERR(in);
 			mutex_lock(&session->s_mutex);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 724307ff89cd..9d020d86f75a 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -263,6 +263,7 @@ struct ceph_mds_request {
 
 	struct inode *r_parent;		    /* parent dir inode */
 	struct inode *r_target_inode;       /* resulting inode */
+	struct inode *r_new_inode;	    /* new inode (for creates) */
 
 #define CEPH_MDS_R_DIRECT_IS_HASH	(1) /* r_direct_hash is valid */
 #define CEPH_MDS_R_ABORTED		(2) /* call was aborted */
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 1b5cd3252cf9..24b0b7780399 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -988,6 +988,7 @@ static inline bool __ceph_have_pending_cap_snap(struct ceph_inode_info *ci)
 /* inode.c */
 struct ceph_mds_reply_info_in;
 struct ceph_mds_reply_dirfrag;
+struct ceph_acl_sec_ctx;
 
 extern const struct inode_operations ceph_file_iops;
 
@@ -995,8 +996,12 @@ extern struct inode *ceph_alloc_inode(struct super_block *sb);
 extern void ceph_evict_inode(struct inode *inode);
 extern void ceph_free_inode(struct inode *inode);
 
+struct inode *ceph_new_inode(struct inode *dir, struct dentry *dentry,
+			     umode_t *mode, struct ceph_acl_sec_ctx *as_ctx);
+void ceph_as_ctx_to_req(struct ceph_mds_request *req, struct ceph_acl_sec_ctx *as_ctx);
+
 extern struct inode *ceph_get_inode(struct super_block *sb,
-				    struct ceph_vino vino);
+				    struct ceph_vino vino, struct inode *newino);
 extern struct inode *ceph_get_snapdir(struct inode *parent);
 extern int ceph_fill_file_size(struct inode *inode, int issued,
 			       u32 truncate_seq, u64 truncate_size, u64 size);
-- 
2.40.1


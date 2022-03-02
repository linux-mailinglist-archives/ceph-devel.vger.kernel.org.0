Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094CD4CA483
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Mar 2022 13:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241704AbiCBMOe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Mar 2022 07:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241692AbiCBMOb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Mar 2022 07:14:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E6C053E38
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 04:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646223226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VcjOoiVC+H6rIcvT5vXhjXR5H6mSmUQtnXv97enbKuk=;
        b=UvCZ+NSJ0wi7TfFtn8nDx4H+ynCKN3iXV3972kYr41DDZnIMeID0c5Wo5saETwfLUx+LfZ
        csDnmwLREp1e1TP9SUSPZMrSOD30GH/44t0MpzD3G6M4k9aBG+nMBi5bZs+Qi3euBVHp9Q
        G/5V3um1x+OGZSMYACqb4197W43iiLA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-PgIF1ygzMhSGdbzvlS8PeQ-1; Wed, 02 Mar 2022 07:13:45 -0500
X-MC-Unique: PgIF1ygzMhSGdbzvlS8PeQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A24E835DE0;
        Wed,  2 Mar 2022 12:13:44 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46AE778203;
        Wed,  2 Mar 2022 12:13:42 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 6/6] ceph: try to encrypt/decrypt long snap name
Date:   Wed,  2 Mar 2022 20:13:23 +0800
Message-Id: <20220302121323.240432-7-xiubli@redhat.com>
In-Reply-To: <20220302121323.240432-1-xiubli@redhat.com>
References: <20220302121323.240432-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The child realm will inherit parents' snapshots, and the snapshot
names will be in long name format:

  "_${ENCRYPTED-SNAP-NAME}_${PARENT-INO}"

We need to parse the ${ENCRYPTED-NAME} and decrypt it for readdir
and when lookup a snapshot we also need to encrypt the real snapshot
name and then switch it to the long snap name to do the lookup in
MDS.

We will always use the parent inode of ".snap" directory to do the
encyrption/decryption.

When doing the lookup a snapshot we must retry it if the first try
failed in case:

There has a path of "/dir1/dir2/", if for the root '/' dir the
encryption is not enabled, while the 'dir2/' will. Then in 'dir2/'
we can get some thing like:

  $ fscrypt lock dir1
  $ ls dir1/.snap/
  7o5HEjlwwsWevZctd6Xtwpq8yg9fkLMOrl59PEaPQd0
  EbsAkJnyJbFVMtfvGmxNaY6hchRNEyDDFQBjW8r669g
  _root_snap1_1

  $ fscrypt unlock dir1
  $ ls dir1/.snap/
  dir1_snap1  dir1_snap2  _root_snap1_1
  $ ls dir1/dir2/.snap/
  _dir1_snap1_1099511640069  _dir1_snap2_1099511640069
  dir2_snap1  _root_snap1_1

For the '_root_snap1_1' snap name the lookup in 'dir1' will try twice,
since the 'dir1' encrypt is enabled and the first time it will try to
encrypt it and will fail, and the second time with long_snap_name=true
it will use root inode '1' to determine whether needs to encrypt it.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/crypto.c     | 95 +++++++++++++++++++++++++++++++++++++++++---
 fs/ceph/crypto.h     |  2 +-
 fs/ceph/dir.c        | 27 +++++++++++--
 fs/ceph/inode.c      | 86 ++++++++++++++++++++++++++++++++++++---
 fs/ceph/mds_client.c | 22 ++++++----
 fs/ceph/mds_client.h |  2 +
 fs/ceph/super.h      |  1 +
 7 files changed, 211 insertions(+), 24 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 5a87e7385d3f..ef682d81a78e 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -128,14 +128,79 @@ void ceph_fscrypt_as_ctx_to_req(struct ceph_mds_request *req, struct ceph_acl_se
 	swap(req->r_fscrypt_auth, as->fscrypt_auth);
 }
 
-int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentry, char *buf)
+int ceph_encode_encrypted_fname(struct inode *parent, struct dentry *dentry, char *buf)
 {
+	struct ceph_dentry_info *di = ceph_dentry(dentry);
+	struct qstr d_name = {.len = 0, .name = NULL};
+	struct inode *pinode = parent;
 	u32 len;
 	int elen;
 	int ret;
 	u8 *cryptbuf;
+	char *p;
+	unsigned char *last = NULL;
+
+	// The long snap name format is "_${SNAP-NAME}_{INO}"
+	if (di->long_snap_name) {
+		struct ceph_vino vino = { .snap = CEPH_NOSNAP };
+
+		/* The last will be "_${INO}" */
+		last = strrchr(dentry->d_name.name, '_');
+		if (!last)
+			return -EINVAL;
+
+		/* Parse the ino from the "${INO}" */
+		ret = kstrtou64(last + 1, 0, &vino.ino);
+		if (ret)
+			return ret;
+
+		/* Get the parent inode with "${INO}" */
+		pinode = ceph_get_inode(parent->i_sb, vino, NULL);
+		BUG_ON(!pinode);
+
+		/*
+		 * If the encrypt is not enabled just return
+		 * the dentry name.
+		 */
+		if (!IS_ENCRYPTED(pinode)) {
+			memcpy(buf, dentry->d_name.name, dentry->d_name.len);
+			buf[dentry->d_name.len] = '\0';
+			iput(pinode);
+			return dentry->d_name.len;
+		}
+
+		ret = __fscrypt_prepare_readdir(pinode);
+		if (ret < 0) {
+			iput(pinode);
+			return ret;
+		}
 
-	WARN_ON_ONCE(!fscrypt_has_encryption_key(parent));
+		/* If no key just copy the original dentry name back */
+		if (!fscrypt_has_encryption_key(pinode)) {
+			memcpy(buf, dentry->d_name.name, dentry->d_name.len);
+			buf[dentry->d_name.len] = '\0';
+			iput(pinode);
+			return dentry->d_name.len;
+		}
+
+		/* Parse the "${SNAP-NAME}" and the length */
+		d_name.len = last - dentry->d_name.name - 1;
+		d_name.name = kstrndup(dentry->d_name.name + 1,
+				       d_name.len, GFP_KERNEL);
+		if (!d_name.name)
+			return -ENOMEM;
+		p = buf + 1;
+		buf[0] = '_';
+		dout(" long_snap_name real snap name: %s, ino: %s\n",
+		     d_name.name, last + 1);
+	} else {
+		p = buf;
+		d_name.name = dentry->d_name.name;
+		d_name.len = dentry->d_name.len;
+		ihold(parent);
+	}
+
+	WARN_ON_ONCE(!fscrypt_has_encryption_key(pinode));
 
 	/*
 	 * convert cleartext dentry name to ciphertext
@@ -144,20 +209,31 @@ int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentr
 	 *
 	 * See: fscrypt_setup_filename
 	 */
-	if (!fscrypt_fname_encrypted_size(parent, dentry->d_name.len, NAME_MAX, &len))
+	if (!fscrypt_fname_encrypted_size(pinode, d_name.len, NAME_MAX, &len)) {
+		iput(pinode);
 		return -ENAMETOOLONG;
+	}
 
 	/* Allocate a buffer appropriate to hold the result */
 	cryptbuf = kmalloc(len > CEPH_NOHASH_NAME_MAX ? NAME_MAX : len, GFP_KERNEL);
-	if (!cryptbuf)
+	if (!cryptbuf) {
+		iput(pinode);
+		if (di->long_snap_name)
+			kfree(d_name.name);
 		return -ENOMEM;
+	}
 
-	ret = fscrypt_fname_encrypt(parent, &dentry->d_name, cryptbuf, len);
+	ret = fscrypt_fname_encrypt(pinode, &d_name, cryptbuf, len);
 	if (ret) {
+		iput(pinode);
 		kfree(cryptbuf);
+		if (di->long_snap_name)
+			kfree(d_name.name);
 		return ret;
 	}
 
+	iput(pinode);
+
 	/* hash the end if the name is long enough */
 	if (len > CEPH_NOHASH_NAME_MAX) {
 		u8 hash[SHA256_DIGEST_SIZE];
@@ -170,8 +246,15 @@ int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentr
 	}
 
 	/* base64 encode the encrypted name */
-	elen = fscrypt_base64url_encode(cryptbuf, len, buf);
+	elen = fscrypt_base64url_encode(cryptbuf, len, p);
 	kfree(cryptbuf);
+
+	/* The final name will be "_${ENCRYPTED-SNAP-NAME}_${INO}" */
+	if (di->long_snap_name) {
+		kfree(d_name.name);
+		strcpy(p + elen, last);
+		elen += 1 + strlen(last);
+	}
 	dout("base64-encoded ciphertext name = %.*s\n", elen, buf);
 	return elen;
 }
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index 9a00c60b8535..fe4065f8da53 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -98,7 +98,7 @@ void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc);
 int ceph_fscrypt_prepare_context(struct inode *dir, struct inode *inode,
 				 struct ceph_acl_sec_ctx *as);
 void ceph_fscrypt_as_ctx_to_req(struct ceph_mds_request *req, struct ceph_acl_sec_ctx *as);
-int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentry, char *buf);
+int ceph_encode_encrypted_fname(struct inode *parent, struct dentry *dentry, char *buf);
 
 static inline int ceph_fname_alloc_buffer(struct inode *parent, struct fscrypt_str *fname)
 {
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index e7cbb97df662..bb5ca23c86d9 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -50,6 +50,7 @@ static int ceph_d_init(struct dentry *dentry)
 	di->time = jiffies;
 	dentry->d_fsdata = di;
 	INIT_LIST_HEAD(&di->lease_list);
+	di->long_snap_name = false;
 
 	atomic64_inc(&mdsc->metric.total_dentries);
 
@@ -785,7 +786,9 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
+	struct ceph_dentry_info *di = ceph_dentry(dentry);
 	struct ceph_mds_request *req;
+	struct inode *pinode = dir;
 	int op;
 	int mask;
 	int err;
@@ -796,21 +799,22 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 	if (dentry->d_name.len > NAME_MAX)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	if (IS_ENCRYPTED(dir)) {
-		err = __fscrypt_prepare_readdir(dir);
+	pinode = ceph_get_snap_parent_inode(dir);
+	if (IS_ENCRYPTED(pinode)) {
+		err = __fscrypt_prepare_readdir(pinode);
 		if (err)
 			return ERR_PTR(err);
-		if (!fscrypt_has_encryption_key(dir)) {
+		if (!fscrypt_has_encryption_key(pinode)) {
 			spin_lock(&dentry->d_lock);
 			dentry->d_flags |= DCACHE_NOKEY_NAME;
 			spin_unlock(&dentry->d_lock);
 		}
 	}
+	iput(pinode);
 
 	/* can we conclude ENOENT locally? */
 	if (d_really_is_negative(dentry)) {
 		struct ceph_inode_info *ci = ceph_inode(dir);
-		struct ceph_dentry_info *di = ceph_dentry(dentry);
 
 		spin_lock(&ci->i_ceph_lock);
 		dout(" dir %p flags are 0x%lx\n", dir, ci->i_ceph_flags);
@@ -833,6 +837,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 
 	op = ceph_snap(dir) == CEPH_SNAPDIR ?
 		CEPH_MDS_OP_LOOKUPSNAP : CEPH_MDS_OP_LOOKUP;
+retry:
 	req = ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
 	if (IS_ERR(req))
 		return ERR_CAST(req);
@@ -851,6 +856,19 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 	if (err == -ENOENT) {
 		struct dentry *res;
 
+		/*
+		 * Try to find encrypted long snap name with the
+		 * format "_${ENCRYPTED-SNAP-NAME}_${INO}"
+		 */
+		if (IS_ENCRYPTED(pinode) && !di->long_snap_name &&
+		    op == CEPH_MDS_OP_LOOKUPSNAP &&
+		    dentry->d_name.name[0] == '_') {
+			di->long_snap_name = true;
+			ceph_mdsc_put_request(req);
+			dout("lookup retry with long snap name set.\n");
+			goto retry;
+		}
+
 		res = ceph_handle_snapdir(req, dentry);
 		if (IS_ERR(res)) {
 			err = PTR_ERR(res);
@@ -858,6 +876,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 			dentry = res;
 			err = 0;
 		}
+		di->long_snap_name = false;
 	}
 	dentry = ceph_finish_lookup(req, dentry, err);
 	ceph_mdsc_put_request(req);  /* will dput(dentry) */
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 2d4e5ee9a373..11f4417ffb6e 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1831,6 +1831,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 	struct ceph_readdir_cache_control cache_ctl = {};
 	struct fscrypt_str tname = FSTR_INIT(NULL, 0);
 	struct fscrypt_str oname = FSTR_INIT(NULL, 0);
+	char *long_snap_name = NULL;
 
 	if (test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags))
 		return readdir_prepopulate_inodes_only(req, session);
@@ -1892,23 +1893,93 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 	if (err < 0)
 		goto out;
 
+	long_snap_name = kzalloc(CEPH_ENCRPTED_LONG_SNAP_NAME_MAX, GFP_NOFS);
+	if (!long_snap_name) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	/* FIXME: release caps/leases if error occurs */
 	for (i = 0; i < rinfo->dir_nr; i++) {
 		bool is_nokey = false;
 		struct ceph_mds_reply_dir_entry *rde = rinfo->dir_entries + i;
 		struct ceph_vino tvino;
 		u32 olen = oname.len;
+		struct ceph_dentry_info *di;
 		struct ceph_fname fname = { .dir	= pinode,
 					    .name	= rde->name,
 					    .name_len	= rde->name_len,
 					    .ctext	= rde->altname,
 					    .ctext_len	= rde->altname_len };
 
-		err = ceph_fname_to_usr(&fname, &tname, &oname, &is_nokey);
-		if (err) {
-			pr_err("%s unable to decode %.*s, got %d\n", __func__,
-			       rde->name_len, rde->name, err);
-			goto out;
+		/* The long snap name will be "_${[ENCRYPTED-]SNAP-NAME}_${INO}" */
+		if (rde->long_snap_name) {
+			int len;
+			char *lsn, *last, ino_str[20]; /* max len of "${INO}" is 16 */
+			struct inode *_pinode;
+			struct ceph_vino vino = {
+				.snap = CEPH_NOSNAP,
+			};
+
+			/* Get the inode by using the "${INO}" */
+			memcpy(long_snap_name, rde->name, rde->name_len);
+			long_snap_name[rde->name_len] = '\0';
+			last = strrchr(long_snap_name, '_');
+			if (!last) {
+				pr_err("%s long snapshot name %.*s badness\n",
+				       __func__, rde->name_len, rde->name);
+				goto out;
+			}
+			last++;
+			len = rde->name_len - (last - long_snap_name);
+			memcpy(ino_str, last, len);
+			ino_str[len] = '\0';
+			err = kstrtou64(ino_str, 0, &vino.ino);
+			if (err)
+				goto out;
+			_pinode = ceph_find_inode(inode->i_sb, vino);
+			BUG_ON(!_pinode);
+
+			// is the inode of ${INO} encrypted ?
+			if (IS_ENCRYPTED(_pinode)) {
+				len = rde->name_len - 2 - len;
+				fname.dir = _pinode;
+				fname.name = rde->name + 1;
+				fname.name_len = len;
+
+				err = ceph_fname_to_usr(&fname, &tname, &oname,
+							&is_nokey);
+				if (err) {
+					pr_err("%s unable to decode %.*s, got %d\n",
+					       __func__, rde->name_len, rde->name,
+					       err);
+					iput(_pinode);
+					goto out;
+				}
+
+				/* Covert it back to "_${DENCRYPTED-SNAP-NAME}_${INO}" */
+				lsn = kasprintf(GFP_NOFS, "_%s_%s", oname.name,
+						ino_str);
+				if (!lsn) {
+					err = -ENOMEM;
+					iput(_pinode);
+					goto out;
+				}
+				len = strlen(lsn);
+				memcpy(oname.name, lsn, len);
+				oname.len = len;
+			} else {
+				memcpy(oname.name, fname.name, fname.name_len);
+				oname.len = fname.name_len;
+			}
+			iput(_pinode);
+		} else {
+			err = ceph_fname_to_usr(&fname, &tname, &oname, &is_nokey);
+			if (err) {
+				pr_err("%s unable to decode %.*s, got %d\n", __func__,
+				       rde->name_len, rde->name, err);
+				goto out;
+			}
 		}
 
 		rde->dentry = NULL;
@@ -1954,7 +2025,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 		} else if (d_really_is_positive(dn) &&
 			   (ceph_ino(d_inode(dn)) != tvino.ino ||
 			    ceph_snap(d_inode(dn)) != tvino.snap)) {
-			struct ceph_dentry_info *di = ceph_dentry(dn);
+			di = ceph_dentry(dn);
 			dout(" dn %p points to wrong inode %p\n",
 			     dn, d_inode(dn));
 
@@ -1977,6 +2048,8 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 		 * to avoid doing the dencrypt again there.
 		 */
 		rde->dentry = dget(dn);
+		di = ceph_dentry(dn);
+		di->long_snap_name = !!rde->long_snap_name;
 
 		/* inode */
 		if (d_really_is_positive(dn)) {
@@ -2056,6 +2129,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 	ceph_fname_free_buffer(pinode, &tname);
 	ceph_fname_free_buffer(pinode, &oname);
 	iput(pinode);
+	kfree(long_snap_name);
 	dout("readdir_prepopulate done\n");
 	return err;
 }
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index f8fd474f80cf..92adfaca0914 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -309,7 +309,8 @@ static int parse_reply_info_dir(void **p, void *end,
 
 static int parse_reply_info_lease(void **p, void *end,
 				  struct ceph_mds_reply_lease **lease,
-				  u64 features, u32 *altname_len, u8 **altname)
+				  u64 features, u32 *altname_len, u8 **altname,
+				  u8 *long_snap_name)
 {
 	u8 struct_v;
 	u32 struct_len;
@@ -339,14 +340,16 @@ static int parse_reply_info_lease(void **p, void *end,
 	*p += sizeof(**lease);
 
 	if (features == (u64)-1) {
+		*altname = NULL;
+		*altname_len = 0;
 		if (struct_v >= 2) {
 			ceph_decode_32_safe(p, end, *altname_len, bad);
 			ceph_decode_need(p, end, *altname_len, bad);
 			*altname = *p;
 			*p += *altname_len;
-		} else {
-			*altname = NULL;
-			*altname_len = 0;
+		}
+		if (struct_v >= 3) {
+			ceph_decode_8_safe(p, end, *long_snap_name, bad);
 		}
 	}
 	*p = lend;
@@ -380,7 +383,8 @@ static int parse_reply_info_trace(void **p, void *end,
 		*p += info->dname_len;
 
 		err = parse_reply_info_lease(p, end, &info->dlease, features,
-					     &info->altname_len, &info->altname);
+					     &info->altname_len, &info->altname,
+					     &info->long_snap_name);
 		if (err < 0)
 			goto out_bad;
 	}
@@ -448,7 +452,8 @@ static int parse_reply_info_readdir(void **p, void *end,
 
 		/* dentry lease */
 		err = parse_reply_info_lease(p, end, &rde->lease, features,
-					     &rde->altname_len, &rde->altname);
+					     &rde->altname_len, &rde->altname,
+					     &rde->long_snap_name);
 		if (err)
 			goto out_bad;
 
@@ -2511,7 +2516,7 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase, int for
 			spin_unlock(&cur->d_lock);
 		} else {
 			int len, ret;
-			char buf[FSCRYPT_BASE64URL_CHARS(NAME_MAX)];
+			char buf[FSCRYPT_BASE64URL_CHARS(NAME_MAX) + 20];
 
 			/*
 			 * Proactively copy name into buf, in case we need to present
@@ -2784,6 +2789,9 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	if (test_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags))
 		len += sizeof(__le64);
 
+	/* extra chars '_' and '_${INO}' for long snap names */
+	len += 60;
+
 	msg = ceph_msg_new2(CEPH_MSG_CLIENT_REQUEST, len, 1, GFP_NOFS, false);
 	if (!msg) {
 		msg = ERR_PTR(-ENOMEM);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 663d7754d57d..5068f85c7505 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -104,6 +104,7 @@ struct ceph_mds_reply_dir_entry {
 	struct ceph_mds_reply_lease   *lease;
 	struct ceph_mds_reply_info_in inode;
 	loff_t			      offset;
+	u8			      long_snap_name;
 };
 
 struct ceph_mds_reply_xattr {
@@ -129,6 +130,7 @@ struct ceph_mds_reply_info_parsed {
 	u32                           altname_len;
 	struct ceph_mds_reply_lease   *dlease;
 	struct ceph_mds_reply_xattr   xattr_info;
+	u8			      long_snap_name;
 
 	/* extra */
 	union {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index f0268a571621..2a96b4524a37 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -297,6 +297,7 @@ struct ceph_dentry_info {
 	unsigned long lease_renew_after, lease_renew_from;
 	unsigned long time;
 	u64 offset;
+	bool long_snap_name;
 };
 
 #define CEPH_DENTRY_REFERENCED		1
-- 
2.27.0


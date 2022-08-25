Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB775A1262
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242846AbiHYNcp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242843AbiHYNcW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:32:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77064B5E43
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:31:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 601E0B8290E
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94994C433C1;
        Thu, 25 Aug 2022 13:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434313;
        bh=ycDM4ZYpnKkGlUiDa9ULqAmwQ3hJkxNg6y/psJXgIEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q6VRpfprl9khoqFK2JnNlhUZ3Ru3QSLZJZSfzNju3DGlsIkKYJvuFiMjI7sSRYEGL
         Gi213Su6yReLYc1j0ZF8BPOhGk0L7qRkwYIiPj6CnY/aXe4ok+ek9uoFYu1S3Nnq4Z
         Pi0Q0Uueitulnn9mMBqaSUzR19EkETW3OU/luOByUI/e1B88NvUCJbp/jhNyJt1OcS
         6XPxxCQXT/bbXA9rlx4gmkfYxO12oMSgQ0IMcEtn4kW6e+DrrwlHxocYo8YL4Qd4Vz
         Xzlv4NBIbFeifTqRpAvgysT5HzvoV+GnL4O4zA51JRI073U1D17oYZ6dRLVhbGlz88
         Ky3EZC5h1+KNA==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 26/29] ceph: add support for handling encrypted snapshot names
Date:   Thu, 25 Aug 2022 09:31:29 -0400
Message-Id: <20220825133132.153657-27-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825133132.153657-1-jlayton@kernel.org>
References: <20220825133132.153657-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Luís Henriques <lhenriques@suse.de>

When creating a snapshot, the .snap directories for every subdirectory will
show the snapshot name in the "long format":

  # mkdir .snap/my-snap
  # ls my-dir/.snap/
  _my-snap_1099511627782

Encrypted snapshots will need to be able to handle these snapshot names by
encrypting/decrypting only the snapshot part of the string ('my-snap').

Also, since the MDS prevents snapshot names to be bigger than 240 characters
it is necessary to adapt CEPH_NOHASH_NAME_MAX to accommodate this extra
limitation.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/crypto.c | 190 ++++++++++++++++++++++++++++++++++++++++-------
 fs/ceph/crypto.h |   4 +-
 2 files changed, 165 insertions(+), 29 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 65c7c83db431..35a2ccfe6899 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -189,16 +189,100 @@ void ceph_fscrypt_as_ctx_to_req(struct ceph_mds_request *req, struct ceph_acl_se
 	swap(req->r_fscrypt_auth, as->fscrypt_auth);
 }
 
-int ceph_encode_encrypted_dname(const struct inode *parent, struct qstr *d_name, char *buf)
+/*
+ * User-created snapshots can't start with '_'.  Snapshots that start with this
+ * character are special (hint: there aren't real snapshots) and use the
+ * following format:
+ *
+ *   _<SNAPSHOT-NAME>_<INODE-NUMBER>
+ *
+ * where:
+ *  - <SNAPSHOT-NAME> - the real snapshot name that may need to be decrypted,
+ *  - <INODE-NUMBER> - the inode number (in decimal) for the actual snapshot
+ *
+ * This function parses these snapshot names and returns the inode
+ * <INODE-NUMBER>.  'name_len' will also bet set with the <SNAPSHOT-NAME>
+ * length.
+ */
+static struct inode *parse_longname(const struct inode *parent, const char *name,
+				    int *name_len)
+{
+	struct inode *dir = NULL;
+	struct ceph_vino vino = { .snap = CEPH_NOSNAP };
+	char *inode_number;
+	char *name_end;
+	int orig_len = *name_len;
+	int ret = -EIO;
+
+	/* Skip initial '_' */
+	name++;
+	name_end = strrchr(name, '_');
+	if (!name_end) {
+		dout("Failed to parse long snapshot name: %s\n", name);
+		return ERR_PTR(-EIO);
+	}
+	*name_len = (name_end - name);
+	if (*name_len <= 0) {
+		pr_err("Failed to parse long snapshot name\n");
+		return ERR_PTR(-EIO);
+	}
+
+	/* Get the inode number */
+	inode_number = kmemdup_nul(name_end + 1,
+				   orig_len - *name_len - 2,
+				   GFP_KERNEL);
+	if (!inode_number)
+		return ERR_PTR(-ENOMEM);
+	ret = kstrtou64(inode_number, 10, &vino.ino);
+	if (ret) {
+		dout("Failed to parse inode number: %s\n", name);
+		dir = ERR_PTR(ret);
+		goto out;
+	}
+
+	/* And finally the inode */
+	dir = ceph_find_inode(parent->i_sb, vino);
+	if (!dir) {
+		/* This can happen if we're not mounting cephfs on the root */
+		dir = ceph_get_inode(parent->i_sb, vino, NULL);
+		if (!dir)
+			dir = ERR_PTR(-ENOENT);
+	}
+	if (IS_ERR(dir))
+		dout("Can't find inode %s (%s)\n", inode_number, name);
+
+out:
+	kfree(inode_number);
+	return dir;
+}
+
+int ceph_encode_encrypted_dname(struct inode *parent, struct qstr *d_name, char *buf)
 {
+	struct inode *dir = parent;
+	struct qstr iname;
 	u32 len;
+	int name_len;
 	int elen;
 	int ret;
-	u8 *cryptbuf;
+	u8 *cryptbuf = NULL;
+
+	iname.name = d_name->name;
+	name_len = d_name->len;
+
+	/* Handle the special case of snapshot names that start with '_' */
+	if ((ceph_snap(dir) == CEPH_SNAPDIR) && (name_len > 0) &&
+	    (iname.name[0] == '_')) {
+		dir = parse_longname(parent, iname.name, &name_len);
+		if (IS_ERR(dir))
+			return PTR_ERR(dir);
+		iname.name++; /* skip initial '_' */
+	}
+	iname.len = name_len;
 
-	if (!fscrypt_has_encryption_key(parent)) {
+	if (!fscrypt_has_encryption_key(dir)) {
 		memcpy(buf, d_name->name, d_name->len);
-		return d_name->len;
+		elen = d_name->len;
+		goto out;
 	}
 
 	/*
@@ -207,18 +291,22 @@ int ceph_encode_encrypted_dname(const struct inode *parent, struct qstr *d_name,
 	 *
 	 * See: fscrypt_setup_filename
 	 */
-	if (!fscrypt_fname_encrypted_size(parent, d_name->len, NAME_MAX, &len))
-		return -ENAMETOOLONG;
+	if (!fscrypt_fname_encrypted_size(dir, iname.len, NAME_MAX, &len)) {
+		elen = -ENAMETOOLONG;
+		goto out;
+	}
 
 	/* Allocate a buffer appropriate to hold the result */
 	cryptbuf = kmalloc(len > CEPH_NOHASH_NAME_MAX ? NAME_MAX : len, GFP_KERNEL);
-	if (!cryptbuf)
-		return -ENOMEM;
+	if (!cryptbuf) {
+		elen = -ENOMEM;
+		goto out;
+	}
 
-	ret = fscrypt_fname_encrypt(parent, d_name, cryptbuf, len);
+	ret = fscrypt_fname_encrypt(dir, &iname, cryptbuf, len);
 	if (ret) {
-		kfree(cryptbuf);
-		return ret;
+		elen = ret;
+		goto out;
 	}
 
 	/* hash the end if the name is long enough */
@@ -234,12 +322,30 @@ int ceph_encode_encrypted_dname(const struct inode *parent, struct qstr *d_name,
 
 	/* base64 encode the encrypted name */
 	elen = ceph_base64_encode(cryptbuf, len, buf);
-	kfree(cryptbuf);
 	dout("base64-encoded ciphertext name = %.*s\n", elen, buf);
+
+	/* To understand the 240 limit, see CEPH_NOHASH_NAME_MAX comments */
+	WARN_ON(elen > 240);
+	if ((elen > 0) && (dir != parent)) {
+		char tmp_buf[NAME_MAX];
+
+		elen = snprintf(tmp_buf, sizeof(tmp_buf), "_%.*s_%ld",
+				elen, buf, dir->i_ino);
+		memcpy(buf, tmp_buf, elen);
+	}
+
+out:
+	kfree(cryptbuf);
+	if (dir != parent) {
+		if ((dir->i_state & I_NEW))
+			discard_new_inode(dir);
+		else
+			iput(dir);
+	}
 	return elen;
 }
 
-int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentry, char *buf)
+int ceph_encode_encrypted_fname(struct inode *parent, struct dentry *dentry, char *buf)
 {
 	WARN_ON_ONCE(!fscrypt_has_encryption_key(parent));
 
@@ -264,29 +370,42 @@ int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentr
 int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 		      struct fscrypt_str *oname, bool *is_nokey)
 {
-	int ret;
+	struct inode *dir = fname->dir;
 	struct fscrypt_str _tname = FSTR_INIT(NULL, 0);
 	struct fscrypt_str iname;
-
-	if (!IS_ENCRYPTED(fname->dir)) {
-		oname->name = fname->name;
-		oname->len = fname->name_len;
-		return 0;
-	}
+	char *name = fname->name;
+	int name_len = fname->name_len;
+	int ret;
 
 	/* Sanity check that the resulting name will fit in the buffer */
 	if (fname->name_len > NAME_MAX || fname->ctext_len > NAME_MAX)
 		return -EIO;
 
-	ret = __fscrypt_prepare_readdir(fname->dir);
+	/* Handle the special case of snapshot names that start with '_' */
+	if ((ceph_snap(dir) == CEPH_SNAPDIR) && (name_len > 0) &&
+	    (name[0] == '_')) {
+		dir = parse_longname(dir, name, &name_len);
+		if (IS_ERR(dir))
+			return PTR_ERR(dir);
+		name++; /* skip initial '_' */
+	}
+
+	if (!IS_ENCRYPTED(dir)) {
+		oname->name = fname->name;
+		oname->len = fname->name_len;
+		ret = 0;
+		goto out_inode;
+	}
+
+	ret = __fscrypt_prepare_readdir(dir);
 	if (ret)
-		return ret;
+		goto out_inode;
 
 	/*
 	 * Use the raw dentry name as sent by the MDS instead of
 	 * generating a nokey name via fscrypt.
 	 */
-	if (!fscrypt_has_encryption_key(fname->dir)) {
+	if (!fscrypt_has_encryption_key(dir)) {
 		if (fname->no_copy)
 			oname->name = fname->name;
 		else
@@ -294,7 +413,8 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 		oname->len = fname->name_len;
 		if (is_nokey)
 			*is_nokey = true;
-		return 0;
+		ret = 0;
+		goto out_inode;
 	}
 
 	if (fname->ctext_len == 0) {
@@ -303,11 +423,11 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 		if (!tname) {
 			ret = fscrypt_fname_alloc_buffer(NAME_MAX, &_tname);
 			if (ret)
-				return ret;
+				goto out_inode;
 			tname = &_tname;
 		}
 
-		declen = ceph_base64_decode(fname->name, fname->name_len, tname->name);
+		declen = ceph_base64_decode(name, name_len, tname->name);
 		if (declen <= 0) {
 			ret = -EIO;
 			goto out;
@@ -319,9 +439,25 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 		iname.len = fname->ctext_len;
 	}
 
-	ret = fscrypt_fname_disk_to_usr(fname->dir, 0, 0, &iname, oname);
+	ret = fscrypt_fname_disk_to_usr(dir, 0, 0, &iname, oname);
+	if (!ret && (dir != fname->dir)) {
+		char tmp_buf[CEPH_BASE64_CHARS(NAME_MAX)];
+
+		name_len = snprintf(tmp_buf, sizeof(tmp_buf), "_%.*s_%ld",
+				    oname->len, oname->name, dir->i_ino);
+		memcpy(oname->name, tmp_buf, name_len);
+		oname->len = name_len;
+	}
+
 out:
 	fscrypt_fname_free_buffer(&_tname);
+out_inode:
+	if ((dir != fname->dir) && !IS_ERR(dir)) {
+		if ((dir->i_state & I_NEW))
+			discard_new_inode(dir);
+		else
+			iput(dir);
+	}
 	return ret;
 }
 
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index d1726307bdb8..c6ee993f4ec8 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -101,8 +101,8 @@ void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc);
 int ceph_fscrypt_prepare_context(struct inode *dir, struct inode *inode,
 				 struct ceph_acl_sec_ctx *as);
 void ceph_fscrypt_as_ctx_to_req(struct ceph_mds_request *req, struct ceph_acl_sec_ctx *as);
-int ceph_encode_encrypted_dname(const struct inode *parent, struct qstr *d_name, char *buf);
-int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentry, char *buf);
+int ceph_encode_encrypted_dname(struct inode *parent, struct qstr *d_name, char *buf);
+int ceph_encode_encrypted_fname(struct inode *parent, struct dentry *dentry, char *buf);
 
 static inline int ceph_fname_alloc_buffer(struct inode *parent, struct fscrypt_str *fname)
 {
-- 
2.37.2


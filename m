Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5A76DF2FA
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Apr 2023 13:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjDLLRT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Apr 2023 07:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbjDLLRK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Apr 2023 07:17:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A835C7ABB
        for <ceph-devel@vger.kernel.org>; Wed, 12 Apr 2023 04:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681298097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3BAbATd1xJgJPUynNeS30f3WMP5FoE3ulAIRL1cQX/8=;
        b=Gr4s/2xCS9aLxxUVxG5y8oafpNZ/69aBkEPiI8hS6++TDy4KA1eMadfpAACi2TXTS2gKh9
        veVNgkF5Gl86wDZOqm0H8fP3RICZxqedYPPMvTVrO3Q2lk6jfGFSb7SrnX/8zGQTHsB/cg
        As6yz9MnPqeCimc9gYhpjU2lhTyIH0U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-81-96UOSXVNM8m0lpuE5sY8Yw-1; Wed, 12 Apr 2023 07:14:54 -0400
X-MC-Unique: 96UOSXVNM8m0lpuE5sY8Yw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A88C93813F3E;
        Wed, 12 Apr 2023 11:14:53 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFF4BC15BB8;
        Wed, 12 Apr 2023 11:14:49 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v18 63/71] ceph: add support for handling encrypted snapshot names
Date:   Wed, 12 Apr 2023 19:09:22 +0800
Message-Id: <20230412110930.176835-64-xiubli@redhat.com>
In-Reply-To: <20230412110930.176835-1-xiubli@redhat.com>
References: <20230412110930.176835-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/crypto.c | 192 ++++++++++++++++++++++++++++++++++++++++-------
 fs/ceph/crypto.h |   4 +-
 2 files changed, 166 insertions(+), 30 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 35e292045e9d..5bdd779217d8 100644
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
 
-	ret = ceph_fscrypt_prepare_readdir(fname->dir);
-	if (ret < 0)
-		return ret;
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
+	ret = ceph_fscrypt_prepare_readdir(dir);
+	if (ret)
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
index 0d0343906d29..d0e88f6d254d 100644
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
2.39.2


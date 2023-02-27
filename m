Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF07C6A399F
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 04:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjB0DcC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 22:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjB0Dbw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 22:31:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BAEC176
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 19:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677468616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oGm/6QipTWvuoofLkVOZ13944m7+cipCgzdeTLfK1hU=;
        b=czhcWHlfoNxsrsYyyFZCzW3+JMN0fcwuZWzn0MKHbICE9RxfeogKns8xnvz/fIC0ZuEuDD
        ni+12HHuDKvGu0fem9JL3bOd16c70m1QGodzuZFzQeYyc5Iz0cHGeT/v7W0CbxGh7Prtr7
        r1tNjsQ+CLfEqP7a+DyOYK6LGMGZn9w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-OYSvo5GZNnykf7iGGTcFnw-1; Sun, 26 Feb 2023 22:30:13 -0500
X-MC-Unique: OYSvo5GZNnykf7iGGTcFnw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A307B85A588;
        Mon, 27 Feb 2023 03:30:12 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D57D21731B;
        Mon, 27 Feb 2023 03:30:09 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v16 32/68] ceph: create symlinks with encrypted and base64-encoded targets
Date:   Mon, 27 Feb 2023 11:27:37 +0800
Message-Id: <20230227032813.337906-33-xiubli@redhat.com>
In-Reply-To: <20230227032813.337906-1-xiubli@redhat.com>
References: <20230227032813.337906-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

When creating symlinks in encrypted directories, encrypt and
base64-encode the target with the new inode's key before sending to the
MDS.

When filling a symlinked inode, base64-decode it into a buffer that
we'll keep in ci->i_symlink. When get_link is called, decrypt the buffer
into a new one that will hang off i_link.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/crypto.c |   2 +-
 fs/ceph/dir.c    |  51 +++++++++++++++++++---
 fs/ceph/inode.c  | 107 +++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 142 insertions(+), 18 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 1803ec7a69a9..5b807f8f4c69 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -306,7 +306,7 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 			tname = &_tname;
 		}
 
-		declen = fscrypt_base64url_decode(fname->name, fname->name_len, tname->name);
+		declen = ceph_base64_decode(fname->name, fname->name_len, tname->name);
 		if (declen <= 0) {
 			ret = -EIO;
 			goto out;
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 5b738226646d..3fb76a86241e 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -946,6 +946,40 @@ static int ceph_create(struct user_namespace *mnt_userns, struct inode *dir,
 	return ceph_mknod(mnt_userns, dir, dentry, mode, 0);
 }
 
+#if IS_ENABLED(CONFIG_FS_ENCRYPTION)
+static int prep_encrypted_symlink_target(struct ceph_mds_request *req, const char *dest)
+{
+	int err;
+	int len = strlen(dest);
+	struct fscrypt_str osd_link = FSTR_INIT(NULL, 0);
+
+	err = fscrypt_prepare_symlink(req->r_parent, dest, len, PATH_MAX, &osd_link);
+	if (err)
+		goto out;
+
+	err = fscrypt_encrypt_symlink(req->r_new_inode, dest, len, &osd_link);
+	if (err)
+		goto out;
+
+	req->r_path2 = kmalloc(CEPH_BASE64_CHARS(osd_link.len) + 1, GFP_KERNEL);
+	if (!req->r_path2) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	len = ceph_base64_encode(osd_link.name, osd_link.len, req->r_path2);
+	req->r_path2[len] = '\0';
+out:
+	fscrypt_fname_free_buffer(&osd_link);
+	return err;
+}
+#else
+static int prep_encrypted_symlink_target(struct ceph_mds_request *req, const char *dest)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 static int ceph_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 			struct dentry *dentry, const char *dest)
 {
@@ -981,14 +1015,21 @@ static int ceph_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 		goto out_req;
 	}
 
-	req->r_path2 = kstrdup(dest, GFP_KERNEL);
-	if (!req->r_path2) {
-		err = -ENOMEM;
-		goto out_req;
-	}
 	req->r_parent = dir;
 	ihold(dir);
 
+	if (IS_ENCRYPTED(req->r_new_inode)) {
+		err = prep_encrypted_symlink_target(req, dest);
+		if (err)
+			goto out_req;
+	} else {
+		req->r_path2 = kstrdup(dest, GFP_KERNEL);
+		if (!req->r_path2) {
+			err = -ENOMEM;
+			goto out_req;
+		}
+	}
+
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 24a19d1991ea..cec86aae24d8 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -35,6 +35,7 @@
  */
 
 static const struct inode_operations ceph_symlink_iops;
+static const struct inode_operations ceph_encrypted_symlink_iops;
 
 static void ceph_inode_work(struct work_struct *work);
 
@@ -639,6 +640,7 @@ void ceph_free_inode(struct inode *inode)
 #ifdef CONFIG_FS_ENCRYPTION
 	kfree(ci->fscrypt_auth);
 #endif
+	fscrypt_free_inode(inode);
 	kmem_cache_free(ceph_inode_cachep, ci);
 }
 
@@ -836,6 +838,34 @@ void ceph_fill_file_time(struct inode *inode, int issued,
 		     inode, time_warp_seq, ci->i_time_warp_seq);
 }
 
+#if IS_ENABLED(CONFIG_FS_ENCRYPTION)
+static int decode_encrypted_symlink(const char *encsym, int enclen, u8 **decsym)
+{
+	int declen;
+	u8 *sym;
+
+	sym = kmalloc(enclen + 1, GFP_NOFS);
+	if (!sym)
+		return -ENOMEM;
+
+	declen = ceph_base64_decode(encsym, enclen, sym);
+	if (declen < 0) {
+		pr_err("%s: can't decode symlink (%d). Content: %.*s\n",
+		       __func__, declen, enclen, encsym);
+		kfree(sym);
+		return -EIO;
+	}
+	sym[declen + 1] = '\0';
+	*decsym = sym;
+	return declen;
+}
+#else
+static int decode_encrypted_symlink(const char *encsym, int symlen, u8 **decsym)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 /*
  * Populate an inode based on info from mds.  May be called on new or
  * existing inodes.
@@ -1070,26 +1100,39 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 		inode->i_fop = &ceph_file_fops;
 		break;
 	case S_IFLNK:
-		inode->i_op = &ceph_symlink_iops;
 		if (!ci->i_symlink) {
 			u32 symlen = iinfo->symlink_len;
 			char *sym;
 
 			spin_unlock(&ci->i_ceph_lock);
 
-			if (symlen != i_size_read(inode)) {
-				pr_err("%s %llx.%llx BAD symlink "
-					"size %lld\n", __func__,
-					ceph_vinop(inode),
-					i_size_read(inode));
+			if (IS_ENCRYPTED(inode)) {
+				if (symlen != i_size_read(inode))
+					pr_err("%s %llx.%llx BAD symlink size %lld\n",
+						__func__, ceph_vinop(inode), i_size_read(inode));
+
+				err = decode_encrypted_symlink(iinfo->symlink, symlen, (u8 **)&sym);
+				if (err < 0) {
+					pr_err("%s decoding encrypted symlink failed: %d\n",
+						__func__, err);
+					goto out;
+				}
+				symlen = err;
 				i_size_write(inode, symlen);
 				inode->i_blocks = calc_inode_blocks(symlen);
-			}
+			} else {
+				if (symlen != i_size_read(inode)) {
+					pr_err("%s %llx.%llx BAD symlink size %lld\n",
+						__func__, ceph_vinop(inode), i_size_read(inode));
+					i_size_write(inode, symlen);
+					inode->i_blocks = calc_inode_blocks(symlen);
+				}
 
-			err = -ENOMEM;
-			sym = kstrndup(iinfo->symlink, symlen, GFP_NOFS);
-			if (!sym)
-				goto out;
+				err = -ENOMEM;
+				sym = kstrndup(iinfo->symlink, symlen, GFP_NOFS);
+				if (!sym)
+					goto out;
+			}
 
 			spin_lock(&ci->i_ceph_lock);
 			if (!ci->i_symlink)
@@ -1097,7 +1140,17 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 			else
 				kfree(sym); /* lost a race */
 		}
-		inode->i_link = ci->i_symlink;
+
+		if (IS_ENCRYPTED(inode)) {
+			/*
+			 * Encrypted symlinks need to be decrypted before we can
+			 * cache their targets in i_link. Don't touch it here.
+			 */
+			inode->i_op = &ceph_encrypted_symlink_iops;
+		} else {
+			inode->i_link = ci->i_symlink;
+			inode->i_op = &ceph_symlink_iops;
+		}
 		break;
 	case S_IFDIR:
 		inode->i_op = &ceph_dir_iops;
@@ -2125,6 +2178,29 @@ static void ceph_inode_work(struct work_struct *work)
 	iput(inode);
 }
 
+static const char *ceph_encrypted_get_link(struct dentry *dentry, struct inode *inode,
+					   struct delayed_call *done)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+
+	if (!dentry)
+		return ERR_PTR(-ECHILD);
+
+	return fscrypt_get_symlink(inode, ci->i_symlink, i_size_read(inode), done);
+}
+
+static int ceph_encrypted_symlink_getattr(struct user_namespace *mnt_userns,
+					  const struct path *path, struct kstat *stat,
+					  u32 request_mask, unsigned int query_flags)
+{
+	int ret;
+
+	ret = ceph_getattr(mnt_userns, path, stat, request_mask, query_flags);
+	if (ret)
+		return ret;
+	return fscrypt_symlink_getattr(path, stat);
+}
+
 /*
  * symlinks
  */
@@ -2135,6 +2211,13 @@ static const struct inode_operations ceph_symlink_iops = {
 	.listxattr = ceph_listxattr,
 };
 
+static const struct inode_operations ceph_encrypted_symlink_iops = {
+	.get_link = ceph_encrypted_get_link,
+	.setattr = ceph_setattr,
+	.getattr = ceph_encrypted_symlink_getattr,
+	.listxattr = ceph_listxattr,
+};
+
 int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *cia)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
-- 
2.31.1


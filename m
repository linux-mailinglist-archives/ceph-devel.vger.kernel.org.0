Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAFC36E3E13
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Apr 2023 05:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjDQDah (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Apr 2023 23:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjDQDaI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Apr 2023 23:30:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DA140DA
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 20:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681702144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lX1b/RaRECaI8BELE2d8boDRI3Jtm3wBPY/o5XCNihc=;
        b=eyjF+G/bWJ9edlFXFFp4mBA+rwXMAVHJl3X+iXmlCC7hSzpLGHlq4xeplyFmdASF6tvTGa
        9XIyweUBqLpZFMBcwjFirxEV8eXqOxtO2QJSMFZq1aILpO0YLiKDkCQPu8B9PYhmXCbMau
        Ee9l3r5aO4y7LO5XNagZDiBuFmkLPXc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-522-toFuRvnZPDaHhEqbXLG_zA-1; Sun, 16 Apr 2023 23:28:58 -0400
X-MC-Unique: toFuRvnZPDaHhEqbXLG_zA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66B981C07581;
        Mon, 17 Apr 2023 03:28:58 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECD872027144;
        Mon, 17 Apr 2023 03:28:53 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v19 20/70] ceph: add encrypted fname handling to ceph_mdsc_build_path
Date:   Mon, 17 Apr 2023 11:26:04 +0800
Message-Id: <20230417032654.32352-21-xiubli@redhat.com>
In-Reply-To: <20230417032654.32352-1-xiubli@redhat.com>
References: <20230417032654.32352-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Allow ceph_mdsc_build_path to encrypt and base64 encode the filename
when the parent is encrypted and we're sending the path to the MDS.

In most cases, we just encrypt the filenames and base64 encode them,
but when the name is longer than CEPH_NOHASH_NAME_MAX, we use a similar
scheme to fscrypt proper, and hash the remaning bits with sha256.

When doing this, we then send along the full crypttext of the name in
the new alternate_name field of the MClientRequest. The MDS can then
send that along in readdir responses and traces.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/crypto.c     | 47 ++++++++++++++++++++++++++
 fs/ceph/crypto.h     |  8 +++++
 fs/ceph/mds_client.c | 80 ++++++++++++++++++++++++++++++++++----------
 3 files changed, 117 insertions(+), 18 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 947ac98119aa..e54ea4c3e478 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -187,3 +187,50 @@ void ceph_fscrypt_as_ctx_to_req(struct ceph_mds_request *req, struct ceph_acl_se
 {
 	swap(req->r_fscrypt_auth, as->fscrypt_auth);
 }
+
+int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentry, char *buf)
+{
+	u32 len;
+	int elen;
+	int ret;
+	u8 *cryptbuf;
+
+	WARN_ON_ONCE(!fscrypt_has_encryption_key(parent));
+
+	/*
+	 * Convert cleartext d_name to ciphertext. If result is longer than
+	 * CEPH_NOHASH_NAME_MAX, sha256 the remaining bytes
+	 *
+	 * See: fscrypt_setup_filename
+	 */
+	if (!fscrypt_fname_encrypted_size(parent, dentry->d_name.len, NAME_MAX, &len))
+		return -ENAMETOOLONG;
+
+	/* Allocate a buffer appropriate to hold the result */
+	cryptbuf = kmalloc(len > CEPH_NOHASH_NAME_MAX ? NAME_MAX : len, GFP_KERNEL);
+	if (!cryptbuf)
+		return -ENOMEM;
+
+	ret = fscrypt_fname_encrypt(parent, &dentry->d_name, cryptbuf, len);
+	if (ret) {
+		kfree(cryptbuf);
+		return ret;
+	}
+
+	/* hash the end if the name is long enough */
+	if (len > CEPH_NOHASH_NAME_MAX) {
+		u8 hash[SHA256_DIGEST_SIZE];
+		u8 *extra = cryptbuf + CEPH_NOHASH_NAME_MAX;
+
+		/* hash the extra bytes and overwrite crypttext beyond that point with it */
+		sha256(extra, len - CEPH_NOHASH_NAME_MAX, hash);
+		memcpy(extra, hash, SHA256_DIGEST_SIZE);
+		len = CEPH_NOHASH_NAME_MAX + SHA256_DIGEST_SIZE;
+	}
+
+	/* base64 encode the encrypted name */
+	elen = ceph_base64_encode(cryptbuf, len, buf);
+	kfree(cryptbuf);
+	dout("base64-encoded ciphertext name = %.*s\n", elen, buf);
+	return elen;
+}
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index f5d38d8a1995..8abf10604722 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -6,6 +6,7 @@
 #ifndef _CEPH_CRYPTO_H
 #define _CEPH_CRYPTO_H
 
+#include <crypto/sha2.h>
 #include <linux/fscrypt.h>
 
 struct ceph_fs_client;
@@ -66,6 +67,7 @@ void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc);
 int ceph_fscrypt_prepare_context(struct inode *dir, struct inode *inode,
 				 struct ceph_acl_sec_ctx *as);
 void ceph_fscrypt_as_ctx_to_req(struct ceph_mds_request *req, struct ceph_acl_sec_ctx *as);
+int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentry, char *buf);
 
 #else /* CONFIG_FS_ENCRYPTION */
 
@@ -89,6 +91,12 @@ static inline void ceph_fscrypt_as_ctx_to_req(struct ceph_mds_request *req,
 						struct ceph_acl_sec_ctx *as_ctx)
 {
 }
+
+static inline int ceph_encode_encrypted_fname(const struct inode *parent,
+						struct dentry *dentry, char *buf)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_FS_ENCRYPTION */
 
 #endif
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d371e8bfe19d..a5e5349aac38 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -14,6 +14,7 @@
 #include <linux/bitmap.h>
 
 #include "super.h"
+#include "crypto.h"
 #include "mds_client.h"
 #include "crypto.h"
 
@@ -2469,18 +2470,27 @@ static inline  u64 __get_oldest_tid(struct ceph_mds_client *mdsc)
 	return mdsc->oldest_tid;
 }
 
-/*
- * Build a dentry's path.  Allocate on heap; caller must kfree.  Based
- * on build_path_from_dentry in fs/cifs/dir.c.
+/**
+ * ceph_mdsc_build_path - build a path string to a given dentry
+ * @dentry: dentry to which path should be built
+ * @plen: returned length of string
+ * @pbase: returned base inode number
+ * @for_wire: is this path going to be sent to the MDS?
+ *
+ * Build a string that represents the path to the dentry. This is mostly called
+ * for two different purposes:
  *
- * If @stop_on_nosnap, generate path relative to the first non-snapped
- * inode.
+ * 1) we need to build a path string to send to the MDS (for_wire == true)
+ * 2) we need a path string for local presentation (e.g. debugfs) (for_wire == false)
+ *
+ * The path is built in reverse, starting with the dentry. Walk back up toward
+ * the root, building the path until the first non-snapped inode is reached (for_wire)
+ * or the root inode is reached (!for_wire).
  *
  * Encode hidden .snap dirs as a double /, i.e.
  *   foo/.snap/bar -> foo//bar
  */
-char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
-			   int stop_on_nosnap)
+char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase, int for_wire)
 {
 	struct dentry *cur;
 	struct inode *inode;
@@ -2502,30 +2512,65 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
 	seq = read_seqbegin(&rename_lock);
 	cur = dget(dentry);
 	for (;;) {
-		struct dentry *temp;
+		struct dentry *parent;
 
 		spin_lock(&cur->d_lock);
 		inode = d_inode(cur);
 		if (inode && ceph_snap(inode) == CEPH_SNAPDIR) {
 			dout("build_path path+%d: %p SNAPDIR\n",
 			     pos, cur);
-		} else if (stop_on_nosnap && inode && dentry != cur &&
-			   ceph_snap(inode) == CEPH_NOSNAP) {
+			spin_unlock(&cur->d_lock);
+			parent = dget_parent(cur);
+		} else if (for_wire && inode && dentry != cur && ceph_snap(inode) == CEPH_NOSNAP) {
 			spin_unlock(&cur->d_lock);
 			pos++; /* get rid of any prepended '/' */
 			break;
-		} else {
+		} else if (!for_wire || !IS_ENCRYPTED(d_inode(cur->d_parent))) {
 			pos -= cur->d_name.len;
 			if (pos < 0) {
 				spin_unlock(&cur->d_lock);
 				break;
 			}
 			memcpy(path + pos, cur->d_name.name, cur->d_name.len);
+			spin_unlock(&cur->d_lock);
+			parent = dget_parent(cur);
+		} else {
+			int len, ret;
+			char buf[NAME_MAX];
+
+			/*
+			 * Proactively copy name into buf, in case we need to present
+			 * it as-is.
+			 */
+			memcpy(buf, cur->d_name.name, cur->d_name.len);
+			len = cur->d_name.len;
+			spin_unlock(&cur->d_lock);
+			parent = dget_parent(cur);
+
+			ret = __fscrypt_prepare_readdir(d_inode(parent));
+			if (ret < 0) {
+				dput(parent);
+				dput(cur);
+				return ERR_PTR(ret);
+			}
+
+			if (fscrypt_has_encryption_key(d_inode(parent))) {
+				len = ceph_encode_encrypted_fname(d_inode(parent), cur, buf);
+				if (len < 0) {
+					dput(parent);
+					dput(cur);
+					return ERR_PTR(len);
+				}
+			}
+			pos -= len;
+			if (pos < 0) {
+				dput(parent);
+				break;
+			}
+			memcpy(path + pos, buf, len);
 		}
-		temp = cur;
-		spin_unlock(&temp->d_lock);
-		cur = dget_parent(temp);
-		dput(temp);
+		dput(cur);
+		cur = parent;
 
 		/* Are we at the root? */
 		if (IS_ROOT(cur))
@@ -2549,8 +2594,7 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
 		 * A rename didn't occur, but somehow we didn't end up where
 		 * we thought we would. Throw a warning and try again.
 		 */
-		pr_warn("build_path did not end path lookup where "
-			"expected, pos is %d\n", pos);
+		pr_warn("build_path did not end path lookup where expected (pos = %d)\n", pos);
 		goto retry;
 	}
 
@@ -2570,7 +2614,7 @@ static int build_dentry_path(struct dentry *dentry, struct inode *dir,
 	rcu_read_lock();
 	if (!dir)
 		dir = d_inode_rcu(dentry->d_parent);
-	if (dir && parent_locked && ceph_snap(dir) == CEPH_NOSNAP) {
+	if (dir && parent_locked && ceph_snap(dir) == CEPH_NOSNAP && !IS_ENCRYPTED(dir)) {
 		*pino = ceph_ino(dir);
 		rcu_read_unlock();
 		*ppath = dentry->d_name.name;
-- 
2.39.1


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDDF6C6028
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Mar 2023 07:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbjCWG6c (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Mar 2023 02:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbjCWG61 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Mar 2023 02:58:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7762DE5A
        for <ceph-devel@vger.kernel.org>; Wed, 22 Mar 2023 23:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679554632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kfGOzdPxYW98Ogxw6Z20LP3ySflnoxd09JWjkrTL0BY=;
        b=C1j6Llsdxlli82PggcyrKabbIJ/xfSGfaSYLMeJDCviaPQmV6h+BiVRBrRhQY0ldkZw/ve
        48hcZ80IH1SuHLRTrTW8wZ3K3D2elaEZRv1RHPjMCyst67REamPQ3EEFOhFbnSaB0e5WsJ
        g16hn5XX1IZh5XsTmGqy8wk1b35STmM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-FhDKz6xXNNaJZX7d2eoKdg-1; Thu, 23 Mar 2023 02:57:09 -0400
X-MC-Unique: FhDKz6xXNNaJZX7d2eoKdg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFD09185A790;
        Thu, 23 Mar 2023 06:57:08 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 003E3492B03;
        Thu, 23 Mar 2023 06:57:05 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v17 26/71] ceph: add helpers for converting names for userland presentation
Date:   Thu, 23 Mar 2023 14:54:40 +0800
Message-Id: <20230323065525.201322-27-xiubli@redhat.com>
In-Reply-To: <20230323065525.201322-1-xiubli@redhat.com>
References: <20230323065525.201322-1-xiubli@redhat.com>
MIME-Version: 1.0
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

Define a new ceph_fname struct that we can use to carry information
about encrypted dentry names. Add helpers for working with these
objects, including ceph_fname_to_usr which formats an encrypted filename
for userland presentation.

[ xiubli: s/FSCRYPT_BASE64URL_CHARS/CEPH_BASE64_CHARS/ reported by
  kernel test robot <lkp@intel.com> ]

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/crypto.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/crypto.h | 41 ++++++++++++++++++++++++++
 2 files changed, 117 insertions(+)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index e54ea4c3e478..03f4b9e73884 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -234,3 +234,79 @@ int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentr
 	dout("base64-encoded ciphertext name = %.*s\n", elen, buf);
 	return elen;
 }
+
+/**
+ * ceph_fname_to_usr - convert a filename for userland presentation
+ * @fname: ceph_fname to be converted
+ * @tname: temporary name buffer to use for conversion (may be NULL)
+ * @oname: where converted name should be placed
+ * @is_nokey: set to true if key wasn't available during conversion (may be NULL)
+ *
+ * Given a filename (usually from the MDS), format it for presentation to
+ * userland. If @parent is not encrypted, just pass it back as-is.
+ *
+ * Otherwise, base64 decode the string, and then ask fscrypt to format it
+ * for userland presentation.
+ *
+ * Returns 0 on success or negative error code on error.
+ */
+int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
+		      struct fscrypt_str *oname, bool *is_nokey)
+{
+	int ret;
+	struct fscrypt_str _tname = FSTR_INIT(NULL, 0);
+	struct fscrypt_str iname;
+
+	if (!IS_ENCRYPTED(fname->dir)) {
+		oname->name = fname->name;
+		oname->len = fname->name_len;
+		return 0;
+	}
+
+	/* Sanity check that the resulting name will fit in the buffer */
+	if (fname->name_len > CEPH_BASE64_CHARS(NAME_MAX))
+		return -EIO;
+
+	ret = __fscrypt_prepare_readdir(fname->dir);
+	if (ret)
+		return ret;
+
+	/*
+	 * Use the raw dentry name as sent by the MDS instead of
+	 * generating a nokey name via fscrypt.
+	 */
+	if (!fscrypt_has_encryption_key(fname->dir)) {
+		memcpy(oname->name, fname->name, fname->name_len);
+		oname->len = fname->name_len;
+		if (is_nokey)
+			*is_nokey = true;
+		return 0;
+	}
+
+	if (fname->ctext_len == 0) {
+		int declen;
+
+		if (!tname) {
+			ret = fscrypt_fname_alloc_buffer(NAME_MAX, &_tname);
+			if (ret)
+				return ret;
+			tname = &_tname;
+		}
+
+		declen = fscrypt_base64url_decode(fname->name, fname->name_len, tname->name);
+		if (declen <= 0) {
+			ret = -EIO;
+			goto out;
+		}
+		iname.name = tname->name;
+		iname.len = declen;
+	} else {
+		iname.name = fname->ctext;
+		iname.len = fname->ctext_len;
+	}
+
+	ret = fscrypt_fname_disk_to_usr(fname->dir, 0, 0, &iname, oname);
+out:
+	fscrypt_fname_free_buffer(&_tname);
+	return ret;
+}
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index 8abf10604722..f231d6e3ba0f 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -13,6 +13,14 @@ struct ceph_fs_client;
 struct ceph_acl_sec_ctx;
 struct ceph_mds_request;
 
+struct ceph_fname {
+	struct inode	*dir;
+	char		*name;		// b64 encoded, possibly hashed
+	unsigned char	*ctext;		// binary crypttext (if any)
+	u32		name_len;	// length of name buffer
+	u32		ctext_len;	// length of crypttext
+};
+
 struct ceph_fscrypt_auth {
 	__le32	cfa_version;
 	__le32	cfa_blob_len;
@@ -69,6 +77,22 @@ int ceph_fscrypt_prepare_context(struct inode *dir, struct inode *inode,
 void ceph_fscrypt_as_ctx_to_req(struct ceph_mds_request *req, struct ceph_acl_sec_ctx *as);
 int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentry, char *buf);
 
+static inline int ceph_fname_alloc_buffer(struct inode *parent, struct fscrypt_str *fname)
+{
+	if (!IS_ENCRYPTED(parent))
+		return 0;
+	return fscrypt_fname_alloc_buffer(NAME_MAX, fname);
+}
+
+static inline void ceph_fname_free_buffer(struct inode *parent, struct fscrypt_str *fname)
+{
+	if (IS_ENCRYPTED(parent))
+		fscrypt_fname_free_buffer(fname);
+}
+
+int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
+			struct fscrypt_str *oname, bool *is_nokey);
+
 #else /* CONFIG_FS_ENCRYPTION */
 
 static inline void ceph_fscrypt_set_ops(struct super_block *sb)
@@ -97,6 +121,23 @@ static inline int ceph_encode_encrypted_fname(const struct inode *parent,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int ceph_fname_alloc_buffer(struct inode *parent, struct fscrypt_str *fname)
+{
+	return 0;
+}
+
+static inline void ceph_fname_free_buffer(struct inode *parent, struct fscrypt_str *fname)
+{
+}
+
+static inline int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
+				    struct fscrypt_str *oname, bool *is_nokey)
+{
+	oname->name = fname->name;
+	oname->len = fname->name_len;
+	return 0;
+}
 #endif /* CONFIG_FS_ENCRYPTION */
 
 #endif
-- 
2.31.1


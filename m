Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5909972D936
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 07:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240164AbjFMFbJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 01:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240165AbjFMFap (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 01:30:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60FB1BC6
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 22:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686634164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dkCYC9I9pGjs9OlnB70fMh7AYTeXATxhVSDntfNqPig=;
        b=EkggtdZHO1t4TS73MKOFAiei/DJ7JBSQ+VoJXt7zleLwp2dPuOqMXmZpPn+CF8g424HuzW
        f+J9mfC5kdBcDHNTukeKyU/YEik7KdmmnT3EBLoPS+EDRTHCM4dKoGZeF8WGhNDRclpAXP
        QCnixgvwAW+hEBcGZUVqyiGZOdZt2/Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-dRSq0ZLcO1mc0PhQysrgTQ-1; Tue, 13 Jun 2023 01:29:20 -0400
X-MC-Unique: dRSq0ZLcO1mc0PhQysrgTQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BC5A3814955;
        Tue, 13 Jun 2023 05:29:20 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7A951121314;
        Tue, 13 Jun 2023 05:29:16 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v20 37/71] ceph: mark directory as non-complete after loading key
Date:   Tue, 13 Jun 2023 13:23:50 +0800
Message-Id: <20230613052424.254540-38-xiubli@redhat.com>
In-Reply-To: <20230613052424.254540-1-xiubli@redhat.com>
References: <20230613052424.254540-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Luís Henriques <lhenriques@suse.de>

When setting a directory's crypt context, ceph_dir_clear_complete() needs to
be called otherwise if it was complete before, any existing (old) dentry will
still be valid.

This patch adds a wrapper around __fscrypt_prepare_readdir() which will
ensure a directory is marked as non-complete if key status changes.

[ xiubli: revise the commit title as Milind pointed out ]

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Signed-off-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/crypto.c     | 35 +++++++++++++++++++++++++++++++++--
 fs/ceph/crypto.h     |  6 ++++++
 fs/ceph/dir.c        |  8 ++++----
 fs/ceph/mds_client.c |  6 +++---
 4 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 5b807f8f4c69..fe47fbdaead9 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -277,8 +277,8 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 	if (fname->name_len > NAME_MAX || fname->ctext_len > NAME_MAX)
 		return -EIO;
 
-	ret = __fscrypt_prepare_readdir(fname->dir);
-	if (ret)
+	ret = ceph_fscrypt_prepare_readdir(fname->dir);
+	if (ret < 0)
 		return ret;
 
 	/*
@@ -323,3 +323,34 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 	fscrypt_fname_free_buffer(&_tname);
 	return ret;
 }
+
+/**
+ * ceph_fscrypt_prepare_readdir - simple __fscrypt_prepare_readdir() wrapper
+ * @dir: directory inode for readdir prep
+ *
+ * Simple wrapper around __fscrypt_prepare_readdir() that will mark directory as
+ * non-complete if this call results in having the directory unlocked.
+ *
+ * Returns:
+ *     1 - if directory was locked and key is now loaded (i.e. dir is unlocked)
+ *     0 - if directory is still locked
+ *   < 0 - if __fscrypt_prepare_readdir() fails
+ */
+int ceph_fscrypt_prepare_readdir(struct inode *dir)
+{
+	bool had_key = fscrypt_has_encryption_key(dir);
+	int err;
+
+	if (!IS_ENCRYPTED(dir))
+		return 0;
+
+	err = __fscrypt_prepare_readdir(dir);
+	if (err)
+		return err;
+	if (!had_key && fscrypt_has_encryption_key(dir)) {
+		/* directory just got unlocked, mark it as not complete */
+		ceph_dir_clear_complete(dir);
+		return 1;
+	}
+	return 0;
+}
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index 05db33f1a421..f8d5f33f708a 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -94,6 +94,7 @@ static inline void ceph_fname_free_buffer(struct inode *parent, struct fscrypt_s
 
 int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 			struct fscrypt_str *oname, bool *is_nokey);
+int ceph_fscrypt_prepare_readdir(struct inode *dir);
 
 #else /* CONFIG_FS_ENCRYPTION */
 
@@ -147,6 +148,11 @@ static inline int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscry
 	oname->len = fname->name_len;
 	return 0;
 }
+
+static inline int ceph_fscrypt_prepare_readdir(struct inode *dir)
+{
+	return 0;
+}
 #endif /* CONFIG_FS_ENCRYPTION */
 
 #endif
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index edd2763d279e..7d71366f87b7 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -343,8 +343,8 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 		ctx->pos = 2;
 	}
 
-	err = fscrypt_prepare_readdir(inode);
-	if (err)
+	err = ceph_fscrypt_prepare_readdir(inode);
+	if (err < 0)
 		return err;
 
 	spin_lock(&ci->i_ceph_lock);
@@ -784,8 +784,8 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 		return ERR_PTR(-ENAMETOOLONG);
 
 	if (IS_ENCRYPTED(dir)) {
-		err = __fscrypt_prepare_readdir(dir);
-		if (err)
+		err = ceph_fscrypt_prepare_readdir(dir);
+		if (err < 0)
 			return ERR_PTR(err);
 		if (!fscrypt_has_encryption_key(dir)) {
 			spin_lock(&dentry->d_lock);
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 383515e20a8f..886b80564d66 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2572,8 +2572,8 @@ static u8 *get_fscrypt_altname(const struct ceph_mds_request *req, u32 *plen)
 	if (!IS_ENCRYPTED(dir))
 		goto success;
 
-	ret = __fscrypt_prepare_readdir(dir);
-	if (ret)
+	ret = ceph_fscrypt_prepare_readdir(dir);
+	if (ret < 0)
 		return ERR_PTR(ret);
 
 	/* No key? Just ignore it. */
@@ -2689,7 +2689,7 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase, int for
 			spin_unlock(&cur->d_lock);
 			parent = dget_parent(cur);
 
-			ret = __fscrypt_prepare_readdir(d_inode(parent));
+			ret = ceph_fscrypt_prepare_readdir(d_inode(parent));
 			if (ret < 0) {
 				dput(parent);
 				dput(cur);
-- 
2.40.1


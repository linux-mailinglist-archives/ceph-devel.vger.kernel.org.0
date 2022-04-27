Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81DFA512252
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbiD0TUD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233430AbiD0TTS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBFCCE3
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 207D0B82929
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C4EC385AA;
        Wed, 27 Apr 2022 19:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086818;
        bh=/0CfgyAPUscvaYlX3rNncpXUN3aimP3LK9zqrBKh1zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DGd5k1cEP9A8qlOjPJU+qS5OTYQNPvgNVFSG1ZbXwJJgW19jpCn1TKiQttha6/Dec
         QxR9mIGQ8FffIueIoke/QKDwr3E10J4+edOXevqTTpylL+ARtr3etBKVHv4JZJdKnR
         eY5ZMFI1L5kbE+lSwHauJaCd05zbZBdN/RNEV855Gi1TdgRVMQuFtj+7PAno0REKrt
         z1xV35Lgt18PDUeAwtmK+3KvTJhGlIFhH9yiGzTxTMQKWLvjw7rNqZBqq8evF7fAxi
         kfTHAXN0hCqyWsa4Y0s6SDAWwM83N5r95PLEz9WGq6dG3ZUve/0BNnB3rU+skgMzfD
         fGVj/t7VDWoDQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 31/64] ceph: add ceph_encode_encrypted_dname() helper
Date:   Wed, 27 Apr 2022 15:12:41 -0400
Message-Id: <20220427191314.222867-32-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427191314.222867-1-jlayton@kernel.org>
References: <20220427191314.222867-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Add a new helper that basically calls ceph_encode_encrypted_fname, but
with a qstr pointer instead of a dentry pointer. This will make it
simpler to decrypt names in a readdir reply, before we have a dentry.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/crypto.c | 11 ++++++++---
 fs/ceph/crypto.h |  8 ++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 6fb2fd1a8af0..05498859eef5 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -188,7 +188,7 @@ void ceph_fscrypt_as_ctx_to_req(struct ceph_mds_request *req, struct ceph_acl_se
 	swap(req->r_fscrypt_auth, as->fscrypt_auth);
 }
 
-int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentry, char *buf)
+int ceph_encode_encrypted_dname(const struct inode *parent, struct qstr *d_name, char *buf)
 {
 	u32 len;
 	int elen;
@@ -203,7 +203,7 @@ int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentr
 	 *
 	 * See: fscrypt_setup_filename
 	 */
-	if (!fscrypt_fname_encrypted_size(parent, dentry->d_name.len, NAME_MAX, &len))
+	if (!fscrypt_fname_encrypted_size(parent, d_name->len, NAME_MAX, &len))
 		return -ENAMETOOLONG;
 
 	/* Allocate a buffer appropriate to hold the result */
@@ -211,7 +211,7 @@ int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentr
 	if (!cryptbuf)
 		return -ENOMEM;
 
-	ret = fscrypt_fname_encrypt(parent, &dentry->d_name, cryptbuf, len);
+	ret = fscrypt_fname_encrypt(parent, d_name, cryptbuf, len);
 	if (ret) {
 		kfree(cryptbuf);
 		return ret;
@@ -235,6 +235,11 @@ int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentr
 	return elen;
 }
 
+int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentry, char *buf)
+{
+	return ceph_encode_encrypted_dname(parent, &dentry->d_name, buf);
+}
+
 /**
  * ceph_fname_to_usr - convert a filename for userland presentation
  * @fname: ceph_fname to be converted
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index f231d6e3ba0f..704e5a0e96f7 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -75,6 +75,7 @@ void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc);
 int ceph_fscrypt_prepare_context(struct inode *dir, struct inode *inode,
 				 struct ceph_acl_sec_ctx *as);
 void ceph_fscrypt_as_ctx_to_req(struct ceph_mds_request *req, struct ceph_acl_sec_ctx *as);
+int ceph_encode_encrypted_dname(const struct inode *parent, struct qstr *d_name, char *buf);
 int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentry, char *buf);
 
 static inline int ceph_fname_alloc_buffer(struct inode *parent, struct fscrypt_str *fname)
@@ -116,6 +117,13 @@ static inline void ceph_fscrypt_as_ctx_to_req(struct ceph_mds_request *req,
 {
 }
 
+static inline int ceph_encode_encrypted_dname(const struct inode *parent,
+					      struct qstr *d_name, char *buf)
+{
+	memcpy(buf, d_name->name, d_name->len);
+	return d_name->len;
+}
+
 static inline int ceph_encode_encrypted_fname(const struct inode *parent,
 						struct dentry *dentry, char *buf)
 {
-- 
2.35.1


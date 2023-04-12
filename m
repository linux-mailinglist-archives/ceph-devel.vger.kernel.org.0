Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB686DF2CE
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Apr 2023 13:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjDLLOW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Apr 2023 07:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjDLLOL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Apr 2023 07:14:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA5D7EEA
        for <ceph-devel@vger.kernel.org>; Wed, 12 Apr 2023 04:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681297934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4PEAoAmsMrqjG/zsNSNYfaqUPJN5p349wjqQCgnwnWA=;
        b=W1WrDJY4wlMMDBmAp7CJKUcNSvSsvcQ2HuzxirPF86gkONVrlV2VrZFkyHfPz5eUIoawn8
        KyG9c1k8FiKflVwDrEgkVWJh8B+MzutG6G9EPITt160GBEG6A6tzH1ZtfGaTE25pkNQQ+W
        lkiyMkK3Crwyk3wJjrymyggWQQCghrE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-TTpAk4MVMxKVHjuao8nP3Q-1; Wed, 12 Apr 2023 07:12:13 -0400
X-MC-Unique: TTpAk4MVMxKVHjuao8nP3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1D94811E7C;
        Wed, 12 Apr 2023 11:12:12 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 259E7C15BC0;
        Wed, 12 Apr 2023 11:12:08 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v18 30/71] ceph: add ceph_encode_encrypted_dname() helper
Date:   Wed, 12 Apr 2023 19:08:49 +0800
Message-Id: <20230412110930.176835-31-xiubli@redhat.com>
In-Reply-To: <20230412110930.176835-1-xiubli@redhat.com>
References: <20230412110930.176835-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Add a new helper that basically calls ceph_encode_encrypted_fname, but
with a qstr pointer instead of a dentry pointer. This will make it
simpler to decrypt names in a readdir reply, before we have a dentry.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/crypto.c | 11 ++++++++---
 fs/ceph/crypto.h |  8 ++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 2222f4968f74..ee0e0db2cf0e 100644
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
2.39.2


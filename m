Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E64B4D795B
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Mar 2022 03:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235905AbiCNCaE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 13 Mar 2022 22:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235903AbiCNCaD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 13 Mar 2022 22:30:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 983DF1AD8B
        for <ceph-devel@vger.kernel.org>; Sun, 13 Mar 2022 19:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647224933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2sMZp3l3FTEeaYTa3OrJfkUTkj3WsizTdcqR4FdLtGQ=;
        b=amsw/xdHva8WYVR1OiWBtW/a0lE7+6BWR/eWn+gwb2Y4zmTHe4THocqcfgMAt9hHQcThk0
        WmWajDOsdyNTgchuvMa0Bv0v3TbTrUi7g6PGbYSwVEV6/pGFwtOp0vv3nlqpwkVcBGuTXE
        hJV+b+3JWihljqMTAsQPInNHs8nFrp0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-_MOA4ii-M2SDOdPViolYUA-1; Sun, 13 Mar 2022 22:28:50 -0400
X-MC-Unique: _MOA4ii-M2SDOdPViolYUA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E474811E78;
        Mon, 14 Mar 2022 02:28:50 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECDED145F971;
        Mon, 14 Mar 2022 02:28:47 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 2/4] ceph: add ceph_encode_encrypted_dname() helper
Date:   Mon, 14 Mar 2022 10:28:35 +0800
Message-Id: <20220314022837.32303-3-xiubli@redhat.com>
In-Reply-To: <20220314022837.32303-1-xiubli@redhat.com>
References: <20220314022837.32303-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/crypto.c | 13 +++++++++----
 fs/ceph/crypto.h |  1 +
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 560481b6c964..21bb0924bd2a 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -128,7 +128,7 @@ void ceph_fscrypt_as_ctx_to_req(struct ceph_mds_request *req, struct ceph_acl_se
 	swap(req->r_fscrypt_auth, as->fscrypt_auth);
 }
 
-int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentry, char *buf)
+int ceph_encode_encrypted_dname(const struct inode *parent, struct qstr *d_name, char *buf)
 {
 	u32 len;
 	int elen;
@@ -138,13 +138,13 @@ int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentr
 	WARN_ON_ONCE(!fscrypt_has_encryption_key(parent));
 
 	/*
-	 * convert cleartext dentry name to ciphertext
+	 * convert cleartext d_name to ciphertext
 	 * if result is longer than CEPH_NOKEY_NAME_MAX,
 	 * sha256 the remaining bytes
 	 *
 	 * See: fscrypt_setup_filename
 	 */
-	if (!fscrypt_fname_encrypted_size(parent, dentry->d_name.len, NAME_MAX, &len))
+	if (!fscrypt_fname_encrypted_size(parent, d_name->len, NAME_MAX, &len))
 		return -ENAMETOOLONG;
 
 	/* Allocate a buffer appropriate to hold the result */
@@ -152,7 +152,7 @@ int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentr
 	if (!cryptbuf)
 		return -ENOMEM;
 
-	ret = fscrypt_fname_encrypt(parent, &dentry->d_name, cryptbuf, len);
+	ret = fscrypt_fname_encrypt(parent, d_name, cryptbuf, len);
 	if (ret) {
 		kfree(cryptbuf);
 		return ret;
@@ -176,6 +176,11 @@ int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentr
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
index 1e08f8a64ad6..f462b96e119b 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -90,6 +90,7 @@ void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc);
 int ceph_fscrypt_prepare_context(struct inode *dir, struct inode *inode,
 				 struct ceph_acl_sec_ctx *as);
 void ceph_fscrypt_as_ctx_to_req(struct ceph_mds_request *req, struct ceph_acl_sec_ctx *as);
+int ceph_encode_encrypted_dname(const struct inode *parent, struct qstr *d_name, char *buf);
 int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentry, char *buf);
 
 static inline int ceph_fname_alloc_buffer(struct inode *parent, struct fscrypt_str *fname)
-- 
2.27.0


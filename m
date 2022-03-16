Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E55B4DA979
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Mar 2022 06:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353553AbiCPFFE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Mar 2022 01:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235942AbiCPFFD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Mar 2022 01:05:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C23D131DF3
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 22:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647407028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=052bdESq//KTqbwqw6SLggkcyMwnG9SJaUcOPrxBsJM=;
        b=YhAzSegoUJUawdEPt3aK/psHvZMUqFeSAAAT1aB1CoY27OMWIfBvppw4TrAnkNYuA38yoM
        DDXCledLeqyx7lHtN3HaiPnngKQG8ahTFcSYRdfNgp15JVG7vXNeYXrgSqqQ6vT5lorUgP
        HL6ycaREvmd+nPpl6Ke7TNRMehGcAac=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-156-C2pMkzzHPYOHhIXaNCiq0w-1; Wed, 16 Mar 2022 01:03:45 -0400
X-MC-Unique: C2pMkzzHPYOHhIXaNCiq0w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B30DC101AA57;
        Wed, 16 Mar 2022 05:03:44 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D9B7C23DB1;
        Wed, 16 Mar 2022 05:03:41 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: add more comments about the CEPH_NOHASH_NAME_MAX
Date:   Wed, 16 Mar 2022 13:03:38 +0800
Message-Id: <20220316050338.70386-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

We should make it clear where the 189 comes from and why, I almost
forgot why we discard the dirhash[2] in ceph, which we discussed it
months ago.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

Jeff, you can sqush this into prvious commit too.


 fs/ceph/crypto.c | 2 +-
 fs/ceph/crypto.h | 8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index c125a79019b3..73320edd32c0 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -142,7 +142,7 @@ int ceph_encode_encrypted_dname(const struct inode *parent, struct qstr *d_name,
 
 	/*
 	 * convert cleartext d_name to ciphertext
-	 * if result is longer than CEPH_NOKEY_NAME_MAX,
+	 * if result is longer than CEPH_NOHASH_NAME_MAX,
 	 * sha256 the remaining bytes
 	 *
 	 * See: fscrypt_setup_filename
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index 185fb4799a6d..62f0ddd30dee 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -76,7 +76,13 @@ static inline u32 ceph_fscrypt_auth_len(struct ceph_fscrypt_auth *fa)
  * smaller size. If the ciphertext name is longer than the value below, then
  * sha256 hash the remaining bytes.
  *
- * 189 bytes => 252 bytes base64-encoded, which is <= NAME_MAX (255)
+ * For the fscrypt_nokey_name struct the dirhash[2] member is useless in ceph
+ * so the corresponding struct will be:
+ *
+ * struct fscrypt_ceph_nokey_name {
+ *	u8 bytes[157];
+ *	u8 sha256[SHA256_DIGEST_SIZE];
+ * }; // 189 bytes => 252 bytes base64-encoded, which is <= NAME_MAX (255)
  *
  * Note that for long names that end up having their tail portion hashed, we
  * must also store the full encrypted name (in the dentry's alternate_name
-- 
2.27.0


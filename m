Return-Path: <ceph-devel+bounces-3342-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DA88B17661
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Jul 2025 21:03:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B438567C47
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Jul 2025 19:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B24E23B633;
	Thu, 31 Jul 2025 19:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mm8qhO3W"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E87221281;
	Thu, 31 Jul 2025 19:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753988624; cv=none; b=Jxk9aXkQFYJDuzS0T076hOYc6uXVr95PhmVDfEOhjxRrbP6EmyW+tDoLtw8Gef1eC3tQbYksQ13lTP931rDPLc6IHhPZjmdxCS2yJo0c2Kv0IBqtD7Be4DDMWWBXp92Vtnd4pUnwM/n/2kCx7ch++wnXHFfIB4BFCJ5U58NOzwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753988624; c=relaxed/simple;
	bh=YFiP6qQrxMm0GVcjzaOlOm6PdbjuANiHX9Je7MJjVbc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nSbK3IOp1ClfKbsbEjh7F+MFGMHo4q91zVRxOJhXVyJEcENyHHD+u9wAb3/LP7WdaSi4dcUXZ16FyGoNz55eJHg4YsPyZVYiQXTWizHTKCoy23Kh8IWlurYWb0/FCu80vmZew7tEZkU8UVvFS8fshLZ2M63xC/AIFuX2BND+J6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mm8qhO3W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF47C4CEEF;
	Thu, 31 Jul 2025 19:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753988621;
	bh=YFiP6qQrxMm0GVcjzaOlOm6PdbjuANiHX9Je7MJjVbc=;
	h=From:To:Cc:Subject:Date:From;
	b=mm8qhO3WqOTePCcYumwVapgT/NsSj247oWdjrtTUhxSUnQaTdrMJGtKRlMOJmFWSs
	 GRD1MsTdwK5Qs1M9R0Ef6p4iNdkK/YoXim/OrlGBBrS56SOFo2CTbWR1q61BCrQeX8
	 voCv8hnlsmewgsQ+Y8qDPXeE7wSo3J8tJ8X8HMJNvWxb25t8T1ml1Y6GgW+NSVs/XR
	 ellCmjYXdxBgO3JgqqKitbaWyM7oZuCWztvx2AlEgWHSVLW1PE6UKEZ+0D1xsmOxh/
	 SEEUX9b4D1l+9ySKcwCCM3FbS6ni8Guxkng8nhVMOvy5NxX2np9IsE5m05kKjJXnDm
	 GpKi95I1/6QZg==
From: Eric Biggers <ebiggers@kernel.org>
To: ceph-devel@vger.kernel.org,
	Ilya Dryomov <idryomov@gmail.com>,
	Xiubo Li <xiubli@redhat.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] libceph: Use HMAC-SHA256 library instead of crypto_shash
Date: Thu, 31 Jul 2025 12:02:27 -0700
Message-ID: <20250731190227.16187-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the HMAC-SHA256 library functions instead of crypto_shash.  This is
simpler and faster.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/linux/ceph/messenger.h |  4 +-
 net/ceph/Kconfig               |  3 +-
 net/ceph/messenger_v2.c        | 77 ++++++++++------------------------
 3 files changed, 26 insertions(+), 58 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 1717cc57cdacd..4b49592a738fc 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -1,9 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __FS_CEPH_MESSENGER_H
 #define __FS_CEPH_MESSENGER_H
 
+#include <crypto/sha2.h>
 #include <linux/bvec.h>
 #include <linux/crypto.h>
 #include <linux/kref.h>
 #include <linux/mutex.h>
 #include <linux/net.h>
@@ -410,11 +411,12 @@ struct ceph_connection_v2_info {
 
 	struct ceph_frame_desc in_desc;
 	struct ceph_msg_data_cursor in_cursor;
 	struct ceph_msg_data_cursor out_cursor;
 
-	struct crypto_shash *hmac_tfm;  /* post-auth signature */
+	struct hmac_sha256_key hmac_key;  /* post-auth signature */
+	bool hmac_key_set;
 	struct crypto_aead *gcm_tfm;  /* on-wire encryption */
 	struct aead_request *gcm_req;
 	struct crypto_wait gcm_wait;
 	struct ceph_gcm_nonce in_gcm_nonce;
 	struct ceph_gcm_nonce out_gcm_nonce;
diff --git a/net/ceph/Kconfig b/net/ceph/Kconfig
index 0aa21fcbf6ece..ea60e3ef08343 100644
--- a/net/ceph/Kconfig
+++ b/net/ceph/Kconfig
@@ -4,12 +4,11 @@ config CEPH_LIB
 	depends on INET
 	select CRC32
 	select CRYPTO_AES
 	select CRYPTO_CBC
 	select CRYPTO_GCM
-	select CRYPTO_HMAC
-	select CRYPTO_SHA256
+	select CRYPTO_LIB_SHA256
 	select CRYPTO
 	select KEYS
 	default n
 	help
 	  Choose Y or M here to include cephlib, which provides the
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index 5483b4eed94e1..c54c8b5a65261 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -707,11 +707,11 @@ static int setup_crypto(struct ceph_connection *con,
 	unsigned int noio_flag;
 	int ret;
 
 	dout("%s con %p con_mode %d session_key_len %d con_secret_len %d\n",
 	     __func__, con, con->v2.con_mode, session_key_len, con_secret_len);
-	WARN_ON(con->v2.hmac_tfm || con->v2.gcm_tfm || con->v2.gcm_req);
+	WARN_ON(con->v2.hmac_key_set || con->v2.gcm_tfm || con->v2.gcm_req);
 
 	if (con->v2.con_mode != CEPH_CON_MODE_CRC &&
 	    con->v2.con_mode != CEPH_CON_MODE_SECURE) {
 		pr_err("bad con_mode %d\n", con->v2.con_mode);
 		return -EINVAL;
@@ -721,26 +721,12 @@ static int setup_crypto(struct ceph_connection *con,
 		WARN_ON(con->v2.con_mode != CEPH_CON_MODE_CRC);
 		WARN_ON(con_secret_len);
 		return 0;  /* auth_none */
 	}
 
-	noio_flag = memalloc_noio_save();
-	con->v2.hmac_tfm = crypto_alloc_shash("hmac(sha256)", 0, 0);
-	memalloc_noio_restore(noio_flag);
-	if (IS_ERR(con->v2.hmac_tfm)) {
-		ret = PTR_ERR(con->v2.hmac_tfm);
-		con->v2.hmac_tfm = NULL;
-		pr_err("failed to allocate hmac tfm context: %d\n", ret);
-		return ret;
-	}
-
-	ret = crypto_shash_setkey(con->v2.hmac_tfm, session_key,
-				  session_key_len);
-	if (ret) {
-		pr_err("failed to set hmac key: %d\n", ret);
-		return ret;
-	}
+	hmac_sha256_preparekey(&con->v2.hmac_key, session_key, session_key_len);
+	con->v2.hmac_key_set = true;
 
 	if (con->v2.con_mode == CEPH_CON_MODE_CRC) {
 		WARN_ON(con_secret_len);
 		return 0;  /* auth_x, plain mode */
 	}
@@ -791,42 +777,30 @@ static int setup_crypto(struct ceph_connection *con,
 	       con_secret + CEPH_GCM_KEY_LEN + CEPH_GCM_IV_LEN,
 	       CEPH_GCM_IV_LEN);
 	return 0;  /* auth_x, secure mode */
 }
 
-static int ceph_hmac_sha256(struct ceph_connection *con,
-			    const struct kvec *kvecs, int kvec_cnt, u8 *hmac)
+static void ceph_hmac_sha256(struct ceph_connection *con,
+			     const struct kvec *kvecs, int kvec_cnt,
+			     u8 hmac[SHA256_DIGEST_SIZE])
 {
-	SHASH_DESC_ON_STACK(desc, con->v2.hmac_tfm);  /* tfm arg is ignored */
-	int ret;
+	struct hmac_sha256_ctx ctx;
 	int i;
 
-	dout("%s con %p hmac_tfm %p kvec_cnt %d\n", __func__, con,
-	     con->v2.hmac_tfm, kvec_cnt);
+	dout("%s con %p hmac_key_set %d kvec_cnt %d\n", __func__, con,
+	     con->v2.hmac_key_set, kvec_cnt);
 
-	if (!con->v2.hmac_tfm) {
+	if (!con->v2.hmac_key_set) {
 		memset(hmac, 0, SHA256_DIGEST_SIZE);
-		return 0;  /* auth_none */
+		return;  /* auth_none */
 	}
 
-	desc->tfm = con->v2.hmac_tfm;
-	ret = crypto_shash_init(desc);
-	if (ret)
-		goto out;
-
-	for (i = 0; i < kvec_cnt; i++) {
-		ret = crypto_shash_update(desc, kvecs[i].iov_base,
-					  kvecs[i].iov_len);
-		if (ret)
-			goto out;
-	}
-
-	ret = crypto_shash_final(desc, hmac);
-
-out:
-	shash_desc_zero(desc);
-	return ret;  /* auth_x, both plain and secure modes */
+	/* auth_x, both plain and secure modes */
+	hmac_sha256_init(&ctx, &con->v2.hmac_key);
+	for (i = 0; i < kvec_cnt; i++)
+		hmac_sha256_update(&ctx, kvecs[i].iov_base, kvecs[i].iov_len);
+	hmac_sha256_final(&ctx, hmac);
 }
 
 static void gcm_inc_nonce(struct ceph_gcm_nonce *nonce)
 {
 	u64 counter;
@@ -1453,21 +1427,18 @@ static int prepare_auth_request_more(struct ceph_connection *con,
 }
 
 static int prepare_auth_signature(struct ceph_connection *con)
 {
 	void *buf;
-	int ret;
 
 	buf = alloc_conn_buf(con, head_onwire_len(SHA256_DIGEST_SIZE,
 						  con_secure(con)));
 	if (!buf)
 		return -ENOMEM;
 
-	ret = ceph_hmac_sha256(con, con->v2.in_sign_kvecs,
-			       con->v2.in_sign_kvec_cnt, CTRL_BODY(buf));
-	if (ret)
-		return ret;
+	ceph_hmac_sha256(con, con->v2.in_sign_kvecs, con->v2.in_sign_kvec_cnt,
+			 CTRL_BODY(buf));
 
 	return prepare_control(con, FRAME_TAG_AUTH_SIGNATURE, buf,
 			       SHA256_DIGEST_SIZE);
 }
 
@@ -2458,14 +2429,12 @@ static int process_auth_signature(struct ceph_connection *con,
 	if (con->state != CEPH_CON_S_V2_AUTH_SIGNATURE) {
 		con->error_msg = "protocol error, unexpected auth_signature";
 		return -EINVAL;
 	}
 
-	ret = ceph_hmac_sha256(con, con->v2.out_sign_kvecs,
-			       con->v2.out_sign_kvec_cnt, hmac);
-	if (ret)
-		return ret;
+	ceph_hmac_sha256(con, con->v2.out_sign_kvecs, con->v2.out_sign_kvec_cnt,
+			 hmac);
 
 	ceph_decode_need(&p, end, SHA256_DIGEST_SIZE, bad);
 	if (crypto_memneq(p, hmac, SHA256_DIGEST_SIZE)) {
 		con->error_msg = "integrity error, bad auth signature";
 		return -EBADMSG;
@@ -3812,14 +3781,12 @@ void ceph_con_v2_reset_protocol(struct ceph_connection *con)
 
 	con->v2.con_mode = CEPH_CON_MODE_UNKNOWN;
 	memzero_explicit(&con->v2.in_gcm_nonce, CEPH_GCM_IV_LEN);
 	memzero_explicit(&con->v2.out_gcm_nonce, CEPH_GCM_IV_LEN);
 
-	if (con->v2.hmac_tfm) {
-		crypto_free_shash(con->v2.hmac_tfm);
-		con->v2.hmac_tfm = NULL;
-	}
+	memzero_explicit(&con->v2.hmac_key, sizeof(con->v2.hmac_key));
+	con->v2.hmac_key_set = false;
 	if (con->v2.gcm_req) {
 		aead_request_free(con->v2.gcm_req);
 		con->v2.gcm_req = NULL;
 	}
 	if (con->v2.gcm_tfm) {

base-commit: d6084bb815c453de27af8071a23163a711586a6c
-- 
2.50.1



Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8862E7B91
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Dec 2020 18:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgL3R27 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Dec 2020 12:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgL3R26 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Dec 2020 12:28:58 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30625C061799
        for <ceph-devel@vger.kernel.org>; Wed, 30 Dec 2020 09:28:18 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id d17so22664939ejy.9
        for <ceph-devel@vger.kernel.org>; Wed, 30 Dec 2020 09:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wA2k/FfFi9WaHybNTpwGH+ZRqF82eNw3ZENP0KPY5Og=;
        b=nK7Fw7jLa28HxWmakkzYdqtwnsU9VrX03zBMVoxy1vWwupF3d4AJZuVTOkZZyQ8cAi
         rP/aPojv3NHGNTPTPczP5L7hUX4WROfDz4UdlpJHidXAGrnrLLBbykJVIh4xQIvW/vjB
         iPdNtUpCqcyIN1Ipev95v9hYiHWFiBORLBvq3ZoLuR91wd6u+PnxximlJAmaW4mtPeot
         dMMox1acSpkmHLjevcOn2vsiUV7oJ48k/HGcC4Dc7ARX1b9Ei8sIaTYj2y1QVimtTHW6
         YlDVZxt1vD+pDeZWI3bEWG7YyzzXtgrtpxjba1FBJNkl38kpcBYUHG8FU8PPvr2ElIzF
         +uFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wA2k/FfFi9WaHybNTpwGH+ZRqF82eNw3ZENP0KPY5Og=;
        b=HjQ22aDYgOrvySOYWX6/cB2j+J76HtV3QNwY42LoO1b8Po+6Qx8MPQPJe3NcIdo1cP
         kWDjY9e1U/bclzF+J5kvOcPFkGUzsX3F5qeP0f5RlIHkf78ZlWuvQwLRMX01/uthixkQ
         C+Ef2yHcAN32d0Sh72XhY2UjyDij0omb+APxVTvn4UD2TYP/Sd0Uz2TqWCh3CJ1Y+0GD
         MPywnura7bunI0bURnXmzrq9L/jZKaA6ojJTbdSXdPy8MhzgBXC2ZWjXPmun0Qlin09s
         3x1EL85w0w2ZU9BLmzFTeprUh8BsWIg6DhzEBeskseguFVcBNRTa5aiIfu+eROwxVO8G
         VAgA==
X-Gm-Message-State: AOAM5307yr5ABhc4j/a8ShlHHntA1MtMJEA/RG9Y2j7Sh0C2h5LPwDhY
        QkJUIlsxW1McAtuek0cbadb8e7WhipE=
X-Google-Smtp-Source: ABdhPJwY6spPp45oe+r0rkB0gQXd/j90EoygIGTeR4KkRyZgx+nYLHhL7TX5OHJgZnCX9XBT3y46fg==
X-Received: by 2002:a17:906:4c4c:: with SMTP id d12mr50478133ejw.307.1609349296005;
        Wed, 30 Dec 2020 09:28:16 -0800 (PST)
Received: from kwango.local (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id m7sm39221127eds.73.2020.12.30.09.28.15
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 09:28:15 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] libceph: zero out session key and connection secret
Date:   Wed, 30 Dec 2020 18:27:20 +0100
Message-Id: <20201230172720.1715-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Try and avoid leaving bits and pieces of session key and connection
secret (gets split into GCM key and a pair of GCM IVs) around.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/auth_x.c       | 57 ++++++++++++++++++++++++-----------------
 net/ceph/crypto.c       |  3 ++-
 net/ceph/messenger_v2.c | 45 ++++++++++++++++++--------------
 3 files changed, 62 insertions(+), 43 deletions(-)

diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
index 9815cfe42af0..ca44c327bace 100644
--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -569,6 +569,34 @@ static int ceph_x_build_request(struct ceph_auth_client *ac,
 	return -ERANGE;
 }
 
+static int decode_con_secret(void **p, void *end, u8 *con_secret,
+			     int *con_secret_len)
+{
+	int len;
+
+	ceph_decode_32_safe(p, end, len, bad);
+	ceph_decode_need(p, end, len, bad);
+
+	dout("%s len %d\n", __func__, len);
+	if (con_secret) {
+		if (len > CEPH_MAX_CON_SECRET_LEN) {
+			pr_err("connection secret too big %d\n", len);
+			goto bad_memzero;
+		}
+		memcpy(con_secret, *p, len);
+		*con_secret_len = len;
+	}
+	memzero_explicit(*p, len);
+	*p += len;
+	return 0;
+
+bad_memzero:
+	memzero_explicit(*p, len);
+bad:
+	pr_err("failed to decode connection secret\n");
+	return -EINVAL;
+}
+
 static int handle_auth_session_key(struct ceph_auth_client *ac,
 				   void **p, void *end,
 				   u8 *session_key, int *session_key_len,
@@ -612,17 +640,9 @@ static int handle_auth_session_key(struct ceph_auth_client *ac,
 		dout("%s decrypted %d bytes\n", __func__, ret);
 		dend = dp + ret;
 
-		ceph_decode_32_safe(&dp, dend, len, e_inval);
-		if (len > CEPH_MAX_CON_SECRET_LEN) {
-			pr_err("connection secret too big %d\n", len);
-			return -EINVAL;
-		}
-
-		dout("%s connection secret len %d\n", __func__, len);
-		if (con_secret) {
-			memcpy(con_secret, dp, len);
-			*con_secret_len = len;
-		}
+		ret = decode_con_secret(&dp, dend, con_secret, con_secret_len);
+		if (ret)
+			return ret;
 	}
 
 	/* service tickets */
@@ -828,7 +848,6 @@ static int decrypt_authorizer_reply(struct ceph_crypto_key *secret,
 {
 	void *dp, *dend;
 	u8 struct_v;
-	int len;
 	int ret;
 
 	dp = *p + ceph_x_encrypt_offset();
@@ -843,17 +862,9 @@ static int decrypt_authorizer_reply(struct ceph_crypto_key *secret,
 	ceph_decode_64_safe(&dp, dend, *nonce_plus_one, e_inval);
 	dout("%s nonce_plus_one %llu\n", __func__, *nonce_plus_one);
 	if (struct_v >= 2) {
-		ceph_decode_32_safe(&dp, dend, len, e_inval);
-		if (len > CEPH_MAX_CON_SECRET_LEN) {
-			pr_err("connection secret too big %d\n", len);
-			return -EINVAL;
-		}
-
-		dout("%s connection secret len %d\n", __func__, len);
-		if (con_secret) {
-			memcpy(con_secret, dp, len);
-			*con_secret_len = len;
-		}
+		ret = decode_con_secret(&dp, dend, con_secret, con_secret_len);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index 4f75df40fb12..92d89b331645 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -96,6 +96,7 @@ int ceph_crypto_key_decode(struct ceph_crypto_key *key, void **p, void *end)
 	key->len = ceph_decode_16(p);
 	ceph_decode_need(p, end, key->len, bad);
 	ret = set_secret(key, *p);
+	memzero_explicit(*p, key->len);
 	*p += key->len;
 	return ret;
 
@@ -134,7 +135,7 @@ int ceph_crypto_key_unarmor(struct ceph_crypto_key *key, const char *inkey)
 void ceph_crypto_key_destroy(struct ceph_crypto_key *key)
 {
 	if (key) {
-		kfree(key->key);
+		kfree_sensitive(key->key);
 		key->key = NULL;
 		if (key->tfm) {
 			crypto_free_sync_skcipher(key->tfm);
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index c38d8de93836..cc40ce4e02fb 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -689,11 +689,10 @@ static int verify_epilogue_crcs(struct ceph_connection *con, u32 front_crc,
 }
 
 static int setup_crypto(struct ceph_connection *con,
-			u8 *session_key, int session_key_len,
-			u8 *con_secret, int con_secret_len)
+			const u8 *session_key, int session_key_len,
+			const u8 *con_secret, int con_secret_len)
 {
 	unsigned int noio_flag;
-	void *p;
 	int ret;
 
 	dout("%s con %p con_mode %d session_key_len %d con_secret_len %d\n",
@@ -751,15 +750,14 @@ static int setup_crypto(struct ceph_connection *con,
 		return ret;
 	}
 
-	p = con_secret;
-	WARN_ON((unsigned long)p & crypto_aead_alignmask(con->v2.gcm_tfm));
-	ret = crypto_aead_setkey(con->v2.gcm_tfm, p, CEPH_GCM_KEY_LEN);
+	WARN_ON((unsigned long)con_secret &
+		crypto_aead_alignmask(con->v2.gcm_tfm));
+	ret = crypto_aead_setkey(con->v2.gcm_tfm, con_secret, CEPH_GCM_KEY_LEN);
 	if (ret) {
 		pr_err("failed to set gcm key: %d\n", ret);
 		return ret;
 	}
 
-	p += CEPH_GCM_KEY_LEN;
 	WARN_ON(crypto_aead_ivsize(con->v2.gcm_tfm) != CEPH_GCM_IV_LEN);
 	ret = crypto_aead_setauthsize(con->v2.gcm_tfm, CEPH_GCM_TAG_LEN);
 	if (ret) {
@@ -777,8 +775,11 @@ static int setup_crypto(struct ceph_connection *con,
 	aead_request_set_callback(con->v2.gcm_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				  crypto_req_done, &con->v2.gcm_wait);
 
-	memcpy(&con->v2.in_gcm_nonce, p, CEPH_GCM_IV_LEN);
-	memcpy(&con->v2.out_gcm_nonce, p + CEPH_GCM_IV_LEN, CEPH_GCM_IV_LEN);
+	memcpy(&con->v2.in_gcm_nonce, con_secret + CEPH_GCM_KEY_LEN,
+	       CEPH_GCM_IV_LEN);
+	memcpy(&con->v2.out_gcm_nonce,
+	       con_secret + CEPH_GCM_KEY_LEN + CEPH_GCM_IV_LEN,
+	       CEPH_GCM_IV_LEN);
 	return 0;  /* auth_x, secure mode */
 }
 
@@ -800,7 +801,7 @@ static int hmac_sha256(struct ceph_connection *con, const struct kvec *kvecs,
 	desc->tfm = con->v2.hmac_tfm;
 	ret = crypto_shash_init(desc);
 	if (ret)
-		return ret;
+		goto out;
 
 	for (i = 0; i < kvec_cnt; i++) {
 		WARN_ON((unsigned long)kvecs[i].iov_base &
@@ -808,15 +809,14 @@ static int hmac_sha256(struct ceph_connection *con, const struct kvec *kvecs,
 		ret = crypto_shash_update(desc, kvecs[i].iov_base,
 					  kvecs[i].iov_len);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
 	ret = crypto_shash_final(desc, hmac);
-	if (ret)
-		return ret;
 
+out:
 	shash_desc_zero(desc);
-	return 0;  /* auth_x, both plain and secure modes */
+	return ret;  /* auth_x, both plain and secure modes */
 }
 
 static void gcm_inc_nonce(struct ceph_gcm_nonce *nonce)
@@ -2072,27 +2072,32 @@ static int process_auth_done(struct ceph_connection *con, void *p, void *end)
 	if (con->state != CEPH_CON_S_V2_AUTH) {
 		dout("%s con %p state changed to %d\n", __func__, con,
 		     con->state);
-		return -EAGAIN;
+		ret = -EAGAIN;
+		goto out;
 	}
 
 	dout("%s con %p handle_auth_done ret %d\n", __func__, con, ret);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = setup_crypto(con, session_key, session_key_len, con_secret,
 			   con_secret_len);
 	if (ret)
-		return ret;
+		goto out;
 
 	reset_out_kvecs(con);
 	ret = prepare_auth_signature(con);
 	if (ret) {
 		pr_err("prepare_auth_signature failed: %d\n", ret);
-		return ret;
+		goto out;
 	}
 
 	con->state = CEPH_CON_S_V2_AUTH_SIGNATURE;
-	return 0;
+
+out:
+	memzero_explicit(session_key_buf, sizeof(session_key_buf));
+	memzero_explicit(con_secret_buf, sizeof(con_secret_buf));
+	return ret;
 
 bad:
 	pr_err("failed to decode auth_done\n");
@@ -3436,6 +3441,8 @@ void ceph_con_v2_reset_protocol(struct ceph_connection *con)
 	}
 
 	con->v2.con_mode = CEPH_CON_MODE_UNKNOWN;
+	memzero_explicit(&con->v2.in_gcm_nonce, CEPH_GCM_IV_LEN);
+	memzero_explicit(&con->v2.out_gcm_nonce, CEPH_GCM_IV_LEN);
 
 	if (con->v2.hmac_tfm) {
 		crypto_free_shash(con->v2.hmac_tfm);
-- 
2.19.2


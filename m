Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0E06E3E12
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Apr 2023 05:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbjDQDad (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Apr 2023 23:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjDQDaE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Apr 2023 23:30:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5C83A80
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 20:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681702138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dH+/7eETTlEXDBL5MLSJD1iWMUpZ9BZ6fKrs3H0h5Iw=;
        b=N2qfGHduT4mmJCp68/d4WJKhWXScUhmBl8/hzIr04XWX+VW5z5P9hdn0/Os0INud4HAIxD
        yMPmNPx6LTPzd/zBrrq1mKkUvE3Wyo2Y5APyMXsnRYWJLwtdeg0Tso6OEkXGcjdUK6Nigd
        pEmR1D1FqoX6LMZKaiQ2CqDSdVcspcg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-_vtZvmJ5MY2luNpjB7eAmQ-1; Sun, 16 Apr 2023 23:28:53 -0400
X-MC-Unique: _vtZvmJ5MY2luNpjB7eAmQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1286A185A78F;
        Mon, 17 Apr 2023 03:28:53 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31AB12027144;
        Mon, 17 Apr 2023 03:28:46 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v19 19/70] ceph: add base64 endcoding routines for encrypted names
Date:   Mon, 17 Apr 2023 11:26:03 +0800
Message-Id: <20230417032654.32352-20-xiubli@redhat.com>
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

From: Luís Henriques <lhenriques@suse.de>

The base64url encoding used by fscrypt includes the '_' character, which
may cause problems in snapshot names (if the name starts with '_').
Thus, use the base64 encoding defined for IMAP mailbox names (RFC 3501),
which uses '+' and ',' instead of '-' and '_'.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/crypto.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/crypto.h | 32 ++++++++++++++++++++++++++
 2 files changed, 92 insertions(+)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index fd3192917e8d..947ac98119aa 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -1,4 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
+/*
+ * The base64 encode/decode code was copied from fscrypt:
+ * Copyright (C) 2015, Google, Inc.
+ * Copyright (C) 2015, Motorola Mobility
+ * Written by Uday Savagaonkar, 2014.
+ * Modified by Jaegeuk Kim, 2015.
+ */
 #include <linux/ceph/ceph_debug.h>
 #include <linux/xattr.h>
 #include <linux/fscrypt.h>
@@ -7,6 +14,59 @@
 #include "mds_client.h"
 #include "crypto.h"
 
+/*
+ * The base64url encoding used by fscrypt includes the '_' character, which may
+ * cause problems in snapshot names (which can not starts with '_').  Thus, we
+ * used the base64 encoding defined for IMAP mailbox names (RFC 3501) instead,
+ * which replaces '-' and '_' by '+' and ','.
+ */
+static const char base64_table[65] =
+        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,";
+
+int ceph_base64_encode(const u8 *src, int srclen, char *dst)
+{
+	u32 ac = 0;
+	int bits = 0;
+	int i;
+	char *cp = dst;
+
+	for (i = 0; i < srclen; i++) {
+		ac = (ac << 8) | src[i];
+		bits += 8;
+		do {
+			bits -= 6;
+			*cp++ = base64_table[(ac >> bits) & 0x3f];
+		} while (bits >= 6);
+	}
+	if (bits)
+		*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
+	return cp - dst;
+}
+
+int ceph_base64_decode(const char *src, int srclen, u8 *dst)
+{
+	u32 ac = 0;
+	int bits = 0;
+	int i;
+	u8 *bp = dst;
+
+	for (i = 0; i < srclen; i++) {
+		const char *p = strchr(base64_table, src[i]);
+
+		if (p == NULL || src[i] == 0)
+			return -1;
+		ac = (ac << 6) | (p - base64_table);
+		bits += 6;
+		if (bits >= 8) {
+			bits -= 8;
+			*bp++ = (u8)(ac >> bits);
+		}
+	}
+	if (ac & ((1 << bits) - 1))
+		return -1;
+	return bp - dst;
+}
+
 static int ceph_crypt_get_context(struct inode *inode, void *ctx, size_t len)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index cb00fe42d5b7..f5d38d8a1995 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -27,6 +27,38 @@ static inline u32 ceph_fscrypt_auth_len(struct ceph_fscrypt_auth *fa)
 }
 
 #ifdef CONFIG_FS_ENCRYPTION
+/*
+ * We want to encrypt filenames when creating them, but the encrypted
+ * versions of those names may have illegal characters in them. To mitigate
+ * that, we base64 encode them, but that gives us a result that can exceed
+ * NAME_MAX.
+ *
+ * Follow a similar scheme to fscrypt itself, and cap the filename to a
+ * smaller size. If the ciphertext name is longer than the value below, then
+ * sha256 hash the remaining bytes.
+ *
+ * For the fscrypt_nokey_name struct the dirhash[2] member is useless in ceph
+ * so the corresponding struct will be:
+ *
+ * struct fscrypt_ceph_nokey_name {
+ *	u8 bytes[157];
+ *	u8 sha256[SHA256_DIGEST_SIZE];
+ * }; // 180 bytes => 240 bytes base64-encoded, which is <= NAME_MAX (255)
+ *
+ * (240 bytes is the maximum size allowed for snapshot names to take into
+ *  account the format: '_<SNAPSHOT-NAME>_<INODE-NUMBER>'.)
+ *
+ * Note that for long names that end up having their tail portion hashed, we
+ * must also store the full encrypted name (in the dentry's alternate_name
+ * field).
+ */
+#define CEPH_NOHASH_NAME_MAX (180 - SHA256_DIGEST_SIZE)
+
+#define CEPH_BASE64_CHARS(nbytes) DIV_ROUND_UP((nbytes) * 4, 3)
+
+int ceph_base64_encode(const u8 *src, int srclen, char *dst);
+int ceph_base64_decode(const char *src, int srclen, u8 *dst);
+
 void ceph_fscrypt_set_ops(struct super_block *sb);
 
 void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc);
-- 
2.39.1


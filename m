Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58B496A39A5
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 04:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjB0DcR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 22:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjB0DcQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 22:32:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194ED1CF64
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 19:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677468643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rxbZwmbp6S87q1bfFnY6kP+yRAU/F5fMx+zKt3sXEKM=;
        b=EddNQ6bmiz7jUJrKOHM9xZypbHZMp5/UTLproeYVEW+nDpZfky6+BmwEPAhP81BJSvIbsO
        1PAowCvKc4UEd89iTIgJm4gwKVR6o/ywwVwuD88A9iLNm8BZLQ9vc/q73Oan42Ffabi/Zr
        uTF738ys/iDLBra+cx7K05KVssF5EjI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-aCId9BV5N261XbA9RwBHpg-1; Sun, 26 Feb 2023 22:30:40 -0500
X-MC-Unique: aCId9BV5N261XbA9RwBHpg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF207100F908;
        Mon, 27 Feb 2023 03:30:39 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D9A11731B;
        Mon, 27 Feb 2023 03:30:36 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v16 40/68] ceph: size handling for encrypted inodes in cap updates
Date:   Mon, 27 Feb 2023 11:27:45 +0800
Message-Id: <20230227032813.337906-41-xiubli@redhat.com>
In-Reply-To: <20230227032813.337906-1-xiubli@redhat.com>
References: <20230227032813.337906-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Transmit the rounded-up size as the normal size, and fill out the
fscrypt_file field with the real file size.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c   | 43 +++++++++++++++++++++++++------------------
 fs/ceph/crypto.h |  4 ++++
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index e7959804c908..fe3734ab1aa5 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1216,10 +1216,9 @@ struct cap_msg_args {
 	umode_t			mode;
 	bool			inline_data;
 	bool			wake;
+	bool			encrypted;
 	u32			fscrypt_auth_len;
-	u32			fscrypt_file_len;
 	u8			fscrypt_auth[sizeof(struct ceph_fscrypt_auth)]; // for context
-	u8			fscrypt_file[sizeof(u64)]; // for size
 };
 
 /* Marshal up the cap msg to the MDS */
@@ -1254,7 +1253,12 @@ static void encode_cap_msg(struct ceph_msg *msg, struct cap_msg_args *arg)
 	fc->ino = cpu_to_le64(arg->ino);
 	fc->snap_follows = cpu_to_le64(arg->follows);
 
-	fc->size = cpu_to_le64(arg->size);
+#if IS_ENABLED(CONFIG_FS_ENCRYPTION)
+	if (arg->encrypted)
+		fc->size = cpu_to_le64(round_up(arg->size, CEPH_FSCRYPT_BLOCK_SIZE));
+	else
+#endif
+		fc->size = cpu_to_le64(arg->size);
 	fc->max_size = cpu_to_le64(arg->max_size);
 	ceph_encode_timespec64(&fc->mtime, &arg->mtime);
 	ceph_encode_timespec64(&fc->atime, &arg->atime);
@@ -1314,11 +1318,17 @@ static void encode_cap_msg(struct ceph_msg *msg, struct cap_msg_args *arg)
 	ceph_encode_64(&p, 0);
 
 #if IS_ENABLED(CONFIG_FS_ENCRYPTION)
-	/* fscrypt_auth and fscrypt_file (version 12) */
+	/*
+	 * fscrypt_auth and fscrypt_file (version 12)
+	 *
+	 * fscrypt_auth holds the crypto context (if any). fscrypt_file
+	 * tracks the real i_size as an __le64 field (and we use a rounded-up
+	 * i_size in * the traditional size field).
+	 */
 	ceph_encode_32(&p, arg->fscrypt_auth_len);
 	ceph_encode_copy(&p, arg->fscrypt_auth, arg->fscrypt_auth_len);
-	ceph_encode_32(&p, arg->fscrypt_file_len);
-	ceph_encode_copy(&p, arg->fscrypt_file, arg->fscrypt_file_len);
+	ceph_encode_32(&p, sizeof(__le64));
+	ceph_encode_64(&p, arg->size);
 #else /* CONFIG_FS_ENCRYPTION */
 	ceph_encode_32(&p, 0);
 	ceph_encode_32(&p, 0);
@@ -1390,7 +1400,6 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
 	arg->follows = flushing ? ci->i_head_snapc->seq : 0;
 	arg->flush_tid = flush_tid;
 	arg->oldest_flush_tid = oldest_flush_tid;
-
 	arg->size = i_size_read(inode);
 	ci->i_reported_size = arg->size;
 	arg->max_size = ci->i_wanted_max_size;
@@ -1444,6 +1453,7 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
 		}
 	}
 	arg->flags = flags;
+	arg->encrypted = IS_ENCRYPTED(inode);
 #if IS_ENABLED(CONFIG_FS_ENCRYPTION)
 	if (ci->fscrypt_auth_len &&
 	    WARN_ON_ONCE(ci->fscrypt_auth_len > sizeof(struct ceph_fscrypt_auth))) {
@@ -1454,21 +1464,21 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
 		memcpy(arg->fscrypt_auth, ci->fscrypt_auth,
 			min_t(size_t, ci->fscrypt_auth_len, sizeof(arg->fscrypt_auth)));
 	}
-	/* FIXME: use this to track "real" size */
-	arg->fscrypt_file_len = 0;
 #endif /* CONFIG_FS_ENCRYPTION */
 }
 
+#if IS_ENABLED(CONFIG_FS_ENCRYPTION)
 #define CAP_MSG_FIXED_FIELDS (sizeof(struct ceph_mds_caps) + \
-		      4 + 8 + 4 + 4 + 8 + 4 + 4 + 4 + 8 + 8 + 4 + 8 + 8 + 4 + 4)
+		      4 + 8 + 4 + 4 + 8 + 4 + 4 + 4 + 8 + 8 + 4 + 8 + 8 + 4 + 4 + 8)
 
-#if IS_ENABLED(CONFIG_FS_ENCRYPTION)
 static inline int cap_msg_size(struct cap_msg_args *arg)
 {
-	return CAP_MSG_FIXED_FIELDS + arg->fscrypt_auth_len +
-			arg->fscrypt_file_len;
+	return CAP_MSG_FIXED_FIELDS + arg->fscrypt_auth_len;
 }
 #else
+#define CAP_MSG_FIXED_FIELDS (sizeof(struct ceph_mds_caps) + \
+		      4 + 8 + 4 + 4 + 8 + 4 + 4 + 4 + 8 + 8 + 4 + 8 + 8 + 4 + 4)
+
 static inline int cap_msg_size(struct cap_msg_args *arg)
 {
 	return CAP_MSG_FIXED_FIELDS;
@@ -1547,13 +1557,10 @@ static inline int __send_flush_snap(struct inode *inode,
 	arg.inline_data = capsnap->inline_data;
 	arg.flags = 0;
 	arg.wake = false;
+	arg.encrypted = IS_ENCRYPTED(inode);
 
-	/*
-	 * No fscrypt_auth changes from a capsnap. It will need
-	 * to update fscrypt_file on size changes (TODO).
-	 */
+	/* No fscrypt_auth changes from a capsnap.*/
 	arg.fscrypt_auth_len = 0;
-	arg.fscrypt_file_len = 0;
 
 	msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, cap_msg_size(&arg),
 			   GFP_NOFS, false);
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index f8d5f33f708a..80acb23d0bb4 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -9,6 +9,10 @@
 #include <crypto/sha2.h>
 #include <linux/fscrypt.h>
 
+#define CEPH_FSCRYPT_BLOCK_SHIFT   12
+#define CEPH_FSCRYPT_BLOCK_SIZE    (_AC(1, UL) << CEPH_FSCRYPT_BLOCK_SHIFT)
+#define CEPH_FSCRYPT_BLOCK_MASK	   (~(CEPH_FSCRYPT_BLOCK_SIZE-1))
+
 struct ceph_fs_client;
 struct ceph_acl_sec_ctx;
 struct ceph_mds_request;
-- 
2.31.1


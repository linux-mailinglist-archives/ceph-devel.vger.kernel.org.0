Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B99D4464C9
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Nov 2021 15:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbhKEOZ2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 Nov 2021 10:25:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233175AbhKEOZ1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 5 Nov 2021 10:25:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636122167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0/20CJKGnvhPB+yGgkURFvNkpAteBZndC3X+xrqtTmo=;
        b=BlaFjyaF4iuH85xlT42zViNu3sJPpPscbqMisnj2uOPgAKPHeAWEF7F1j5TsUl42vpFZvI
        LCqMQefnea1jCWwoVlx2lOdPG8+C/8kZPXBKwxUumcAGYhXF91+DeMVCOWR7uOXZnc6V2E
        k1AjvutZPBB36gk2YEIuOjV/+tUsL9I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-ceDEBfqwPt-JsJIBkVN5-w-1; Fri, 05 Nov 2021 10:22:45 -0400
X-MC-Unique: ceDEBfqwPt-JsJIBkVN5-w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 643F5871811;
        Fri,  5 Nov 2021 14:22:44 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 422592707D;
        Fri,  5 Nov 2021 14:22:42 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
Subject: [PATCH v7 2/9] ceph: size handling for encrypted inodes in cap updates
Date:   Fri,  5 Nov 2021 22:22:08 +0800
Message-Id: <20211105142215.345566-3-xiubli@redhat.com>
In-Reply-To: <20211105142215.345566-1-xiubli@redhat.com>
References: <20211105142215.345566-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Transmit the rounded-up size as the normal size, and fill out the
fscrypt_file field with the real file size.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c   | 43 +++++++++++++++++++++++++------------------
 fs/ceph/crypto.h |  4 ++++
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 80f521dd7254..fc367f42536a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1215,10 +1215,9 @@ struct cap_msg_args {
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
@@ -1253,7 +1252,12 @@ static void encode_cap_msg(struct ceph_msg *msg, struct cap_msg_args *arg)
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
@@ -1313,11 +1317,17 @@ static void encode_cap_msg(struct ceph_msg *msg, struct cap_msg_args *arg)
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
@@ -1389,7 +1399,6 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
 	arg->follows = flushing ? ci->i_head_snapc->seq : 0;
 	arg->flush_tid = flush_tid;
 	arg->oldest_flush_tid = oldest_flush_tid;
-
 	arg->size = i_size_read(inode);
 	ci->i_reported_size = arg->size;
 	arg->max_size = ci->i_wanted_max_size;
@@ -1443,6 +1452,7 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
 		}
 	}
 	arg->flags = flags;
+	arg->encrypted = IS_ENCRYPTED(inode);
 #if IS_ENABLED(CONFIG_FS_ENCRYPTION)
 	if (ci->fscrypt_auth_len &&
 	    WARN_ON_ONCE(ci->fscrypt_auth_len != sizeof(struct ceph_fscrypt_auth))) {
@@ -1453,21 +1463,21 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
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
@@ -1546,13 +1556,10 @@ static inline int __send_flush_snap(struct inode *inode,
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
index c2e0cbb5667b..ab27a7ed62c3 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -9,6 +9,10 @@
 #include <crypto/sha2.h>
 #include <linux/fscrypt.h>
 
+#define CEPH_FSCRYPT_BLOCK_SHIFT   12
+#define CEPH_FSCRYPT_BLOCK_SIZE    (_AC(1,UL) << CEPH_FSCRYPT_BLOCK_SHIFT)
+#define CEPH_FSCRYPT_BLOCK_MASK	   (~(CEPH_FSCRYPT_BLOCK_SIZE-1))
+
 struct ceph_fs_client;
 struct ceph_acl_sec_ctx;
 struct ceph_mds_request;
-- 
2.27.0


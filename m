Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0E06DF2BE
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Apr 2023 13:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjDLLMx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Apr 2023 07:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjDLLMw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Apr 2023 07:12:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2367DBD
        for <ceph-devel@vger.kernel.org>; Wed, 12 Apr 2023 04:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681297860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tASoPZoMDuH7DHvW5BfRz9fJSLuKVFwSChgwysDYxvE=;
        b=Jyl8f0Xa6uEGpQ+CeKYh5XWOUkseTgbnI90D8gaVtlgbGc3oJGhJQXqUn2kThCWXy6tYXy
        RapZ/FM+/CJ6m4rnlpCtI4n2f2SVn4uVvqU7PwJB4jMvfWAL3aBih6KopL1Qricw/CvZlH
        CrBaSp+HZOHp73yn+6MWqaI7t1UKLAM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-b49hcUAoPea61NI5B0fNCQ-1; Wed, 12 Apr 2023 07:10:55 -0400
X-MC-Unique: b49hcUAoPea61NI5B0fNCQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EB2828237CD;
        Wed, 12 Apr 2023 11:10:55 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C03FC15BB8;
        Wed, 12 Apr 2023 11:10:51 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v18 14/71] ceph: add support for fscrypt_auth/fscrypt_file to cap messages
Date:   Wed, 12 Apr 2023 19:08:33 +0800
Message-Id: <20230412110930.176835-15-xiubli@redhat.com>
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

From: Jeff Layton <jlayton@kernel.org>

Add support for new version 12 cap messages that carry the new
fscrypt_auth and fscrypt_file fields from the inode.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 76 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 63 insertions(+), 13 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index e02c5ea3f108..3cca23394769 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -14,6 +14,7 @@
 #include "super.h"
 #include "mds_client.h"
 #include "cache.h"
+#include "crypto.h"
 #include <linux/ceph/decode.h>
 #include <linux/ceph/messenger.h>
 
@@ -1216,15 +1217,12 @@ struct cap_msg_args {
 	umode_t			mode;
 	bool			inline_data;
 	bool			wake;
+	u32			fscrypt_auth_len;
+	u32			fscrypt_file_len;
+	u8			fscrypt_auth[sizeof(struct ceph_fscrypt_auth)]; // for context
+	u8			fscrypt_file[sizeof(u64)]; // for size
 };
 
-/*
- * cap struct size + flock buffer size + inline version + inline data size +
- * osd_epoch_barrier + oldest_flush_tid
- */
-#define CAP_MSG_SIZE (sizeof(struct ceph_mds_caps) + \
-		      4 + 8 + 4 + 4 + 8 + 4 + 4 + 4 + 8 + 8 + 4)
-
 /* Marshal up the cap msg to the MDS */
 static void encode_cap_msg(struct ceph_msg *msg, struct cap_msg_args *arg)
 {
@@ -1240,7 +1238,7 @@ static void encode_cap_msg(struct ceph_msg *msg, struct cap_msg_args *arg)
 	     arg->size, arg->max_size, arg->xattr_version,
 	     arg->xattr_buf ? (int)arg->xattr_buf->vec.iov_len : 0);
 
-	msg->hdr.version = cpu_to_le16(10);
+	msg->hdr.version = cpu_to_le16(12);
 	msg->hdr.tid = cpu_to_le64(arg->flush_tid);
 
 	fc = msg->front.iov_base;
@@ -1311,6 +1309,21 @@ static void encode_cap_msg(struct ceph_msg *msg, struct cap_msg_args *arg)
 
 	/* Advisory flags (version 10) */
 	ceph_encode_32(&p, arg->flags);
+
+	/* dirstats (version 11) - these are r/o on the client */
+	ceph_encode_64(&p, 0);
+	ceph_encode_64(&p, 0);
+
+#if IS_ENABLED(CONFIG_FS_ENCRYPTION)
+	/* fscrypt_auth and fscrypt_file (version 12) */
+	ceph_encode_32(&p, arg->fscrypt_auth_len);
+	ceph_encode_copy(&p, arg->fscrypt_auth, arg->fscrypt_auth_len);
+	ceph_encode_32(&p, arg->fscrypt_file_len);
+	ceph_encode_copy(&p, arg->fscrypt_file, arg->fscrypt_file_len);
+#else /* CONFIG_FS_ENCRYPTION */
+	ceph_encode_32(&p, 0);
+	ceph_encode_32(&p, 0);
+#endif /* CONFIG_FS_ENCRYPTION */
 }
 
 /*
@@ -1432,8 +1445,37 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
 		}
 	}
 	arg->flags = flags;
+#if IS_ENABLED(CONFIG_FS_ENCRYPTION)
+	if (ci->fscrypt_auth_len &&
+	    WARN_ON_ONCE(ci->fscrypt_auth_len > sizeof(struct ceph_fscrypt_auth))) {
+		/* Don't set this if it's too big */
+		arg->fscrypt_auth_len = 0;
+	} else {
+		arg->fscrypt_auth_len = ci->fscrypt_auth_len;
+		memcpy(arg->fscrypt_auth, ci->fscrypt_auth,
+			min_t(size_t, ci->fscrypt_auth_len, sizeof(arg->fscrypt_auth)));
+	}
+	/* FIXME: use this to track "real" size */
+	arg->fscrypt_file_len = 0;
+#endif /* CONFIG_FS_ENCRYPTION */
 }
 
+#define CAP_MSG_FIXED_FIELDS (sizeof(struct ceph_mds_caps) + \
+		      4 + 8 + 4 + 4 + 8 + 4 + 4 + 4 + 8 + 8 + 4 + 8 + 8 + 4 + 4)
+
+#if IS_ENABLED(CONFIG_FS_ENCRYPTION)
+static inline int cap_msg_size(struct cap_msg_args *arg)
+{
+	return CAP_MSG_FIXED_FIELDS + arg->fscrypt_auth_len +
+			arg->fscrypt_file_len;
+}
+#else
+static inline int cap_msg_size(struct cap_msg_args *arg)
+{
+	return CAP_MSG_FIXED_FIELDS;
+}
+#endif /* CONFIG_FS_ENCRYPTION */
+
 /*
  * Send a cap msg on the given inode.
  *
@@ -1444,7 +1486,7 @@ static void __send_cap(struct cap_msg_args *arg, struct ceph_inode_info *ci)
 	struct ceph_msg *msg;
 	struct inode *inode = &ci->netfs.inode;
 
-	msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, CAP_MSG_SIZE, GFP_NOFS, false);
+	msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, cap_msg_size(arg), GFP_NOFS, false);
 	if (!msg) {
 		pr_err("error allocating cap msg: ino (%llx.%llx) flushing %s tid %llu, requeuing cap.\n",
 		       ceph_vinop(inode), ceph_cap_string(arg->dirty),
@@ -1470,10 +1512,6 @@ static inline int __send_flush_snap(struct inode *inode,
 	struct cap_msg_args	arg;
 	struct ceph_msg		*msg;
 
-	msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, CAP_MSG_SIZE, GFP_NOFS, false);
-	if (!msg)
-		return -ENOMEM;
-
 	arg.session = session;
 	arg.ino = ceph_vino(inode).ino;
 	arg.cid = 0;
@@ -1511,6 +1549,18 @@ static inline int __send_flush_snap(struct inode *inode,
 	arg.flags = 0;
 	arg.wake = false;
 
+	/*
+	 * No fscrypt_auth changes from a capsnap. It will need
+	 * to update fscrypt_file on size changes (TODO).
+	 */
+	arg.fscrypt_auth_len = 0;
+	arg.fscrypt_file_len = 0;
+
+	msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, cap_msg_size(&arg),
+			   GFP_NOFS, false);
+	if (!msg)
+		return -ENOMEM;
+
 	encode_cap_msg(msg, &arg);
 	ceph_con_send(&arg.session->s_con, msg);
 	return 0;
-- 
2.39.2


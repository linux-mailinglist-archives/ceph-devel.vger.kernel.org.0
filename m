Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E991372D93D
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 07:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240120AbjFMFcM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 01:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240131AbjFMFbX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 01:31:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02B8171F
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 22:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686634194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OV8cYoaygKEWP7WpoKtHR87C7i6MhgOJdAWR0mdT1yk=;
        b=Jo+cHI6WZI1eAgBJDuDKWlhjfUOSP3ihdpsrLO7Gm21eGGhfCOXggsyB/fJ18Sa2W7aWhZ
        AScNGqnpsBFS+LxLPFmWtwLM7yKnUq+x2NRmrdWhB12ZsUmOXIVwkY0kTwEBpH+Of8c08J
        STwkuhDVyfbbd5q75saPSPCCIMPFwTE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-tIuIoZK9Nru-BUIN_tP7oQ-1; Tue, 13 Jun 2023 01:29:47 -0400
X-MC-Unique: tIuIoZK9Nru-BUIN_tP7oQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6DBD802E58;
        Tue, 13 Jun 2023 05:29:46 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43DCB1121314;
        Tue, 13 Jun 2023 05:29:42 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v20 43/71] ceph: handle fscrypt fields in cap messages from MDS
Date:   Tue, 13 Jun 2023 13:23:56 +0800
Message-Id: <20230613052424.254540-44-xiubli@redhat.com>
In-Reply-To: <20230613052424.254540-1-xiubli@redhat.com>
References: <20230613052424.254540-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Handle the new fscrypt_file and fscrypt_auth fields in cap messages. Use
them to populate new fields in cap_extra_info and update the inode with
those values.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 76 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 75dc5c91bc32..43d39a1ccc68 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3375,6 +3375,9 @@ struct cap_extra_info {
 	/* currently issued */
 	int issued;
 	struct timespec64 btime;
+	u8 *fscrypt_auth;
+	u32 fscrypt_auth_len;
+	u64 fscrypt_file_size;
 };
 
 /*
@@ -3407,6 +3410,14 @@ static void handle_cap_grant(struct inode *inode,
 	bool deleted_inode = false;
 	bool fill_inline = false;
 
+	/*
+	 * If there is at least one crypto block then we'll trust fscrypt_file_size.
+	 * If the real length of the file is 0, then ignore it (it has probably been
+	 * truncated down to 0 by the MDS).
+	 */
+	if (IS_ENCRYPTED(inode) && size)
+		size = extra_info->fscrypt_file_size;
+
 	dout("handle_cap_grant inode %p cap %p mds%d seq %d %s\n",
 	     inode, cap, session->s_mds, seq, ceph_cap_string(newcaps));
 	dout(" size %llu max_size %llu, i_size %llu\n", size, max_size,
@@ -3473,6 +3484,10 @@ static void handle_cap_grant(struct inode *inode,
 		dout("%p mode 0%o uid.gid %d.%d\n", inode, inode->i_mode,
 		     from_kuid(&init_user_ns, inode->i_uid),
 		     from_kgid(&init_user_ns, inode->i_gid));
+
+		WARN_ON_ONCE(ci->fscrypt_auth_len != extra_info->fscrypt_auth_len ||
+			     memcmp(ci->fscrypt_auth, extra_info->fscrypt_auth,
+				     ci->fscrypt_auth_len));
 	}
 
 	if ((newcaps & CEPH_CAP_LINK_SHARED) &&
@@ -3884,7 +3899,8 @@ static void handle_cap_flushsnap_ack(struct inode *inode, u64 flush_tid,
  */
 static bool handle_cap_trunc(struct inode *inode,
 			     struct ceph_mds_caps *trunc,
-			     struct ceph_mds_session *session)
+			     struct ceph_mds_session *session,
+			     struct cap_extra_info *extra_info)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	int mds = session->s_mds;
@@ -3901,6 +3917,14 @@ static bool handle_cap_trunc(struct inode *inode,
 
 	issued |= implemented | dirty;
 
+	/*
+	 * If there is at least one crypto block then we'll trust fscrypt_file_size.
+	 * If the real length of the file is 0, then ignore it (it has probably been
+	 * truncated down to 0 by the MDS).
+	 */
+	if (IS_ENCRYPTED(inode) && size)
+		size = extra_info->fscrypt_file_size;
+
 	dout("handle_cap_trunc inode %p mds%d seq %d to %lld seq %d\n",
 	     inode, mds, seq, truncate_size, truncate_seq);
 	queue_trunc = ceph_fill_file_size(inode, issued,
@@ -4122,6 +4146,49 @@ static void handle_cap_import(struct ceph_mds_client *mdsc,
 	*target_cap = cap;
 }
 
+#ifdef CONFIG_FS_ENCRYPTION
+static int parse_fscrypt_fields(void **p, void *end, struct cap_extra_info *extra)
+{
+	u32 len;
+
+	ceph_decode_32_safe(p, end, extra->fscrypt_auth_len, bad);
+	if (extra->fscrypt_auth_len) {
+		ceph_decode_need(p, end, extra->fscrypt_auth_len, bad);
+		extra->fscrypt_auth = kmalloc(extra->fscrypt_auth_len, GFP_KERNEL);
+		if (!extra->fscrypt_auth)
+			return -ENOMEM;
+		ceph_decode_copy_safe(p, end, extra->fscrypt_auth,
+					extra->fscrypt_auth_len, bad);
+	}
+
+	ceph_decode_32_safe(p, end, len, bad);
+	if (len >= sizeof(u64)) {
+		ceph_decode_64_safe(p, end, extra->fscrypt_file_size, bad);
+		len -= sizeof(u64);
+	}
+	ceph_decode_skip_n(p, end, len, bad);
+	return 0;
+bad:
+	return -EIO;
+}
+#else
+static int parse_fscrypt_fields(void **p, void *end, struct cap_extra_info *extra)
+{
+	u32 len;
+
+	/* Don't care about these fields unless we're encryption-capable */
+	ceph_decode_32_safe(p, end, len, bad);
+	if (len)
+		ceph_decode_skip_n(p, end, len, bad);
+	ceph_decode_32_safe(p, end, len, bad);
+	if (len)
+		ceph_decode_skip_n(p, end, len, bad);
+	return 0;
+bad:
+	return -EIO;
+}
+#endif
+
 /*
  * Handle a caps message from the MDS.
  *
@@ -4241,6 +4308,11 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 		ceph_decode_64_safe(&p, end, extra_info.nsubdirs, bad);
 	}
 
+	if (msg_version >= 12) {
+		if (parse_fscrypt_fields(&p, end, &extra_info))
+			goto bad;
+	}
+
 	/* lookup ino */
 	inode = ceph_find_inode(mdsc->fsc->sb, vino);
 	dout(" op %s ino %llx.%llx inode %p\n", ceph_cap_op_name(op), vino.ino,
@@ -4341,7 +4413,8 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 		break;
 
 	case CEPH_CAP_OP_TRUNC:
-		queue_trunc = handle_cap_trunc(inode, h, session);
+		queue_trunc = handle_cap_trunc(inode, h, session,
+						&extra_info);
 		spin_unlock(&ci->i_ceph_lock);
 		if (queue_trunc)
 			ceph_queue_vmtruncate(inode);
@@ -4364,6 +4437,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	if (close_sessions)
 		ceph_mdsc_close_sessions(mdsc);
 
+	kfree(extra_info.fscrypt_auth);
 	return;
 
 flush_cap_releases:
-- 
2.40.1


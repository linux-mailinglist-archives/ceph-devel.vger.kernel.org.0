Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9936E3E29
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Apr 2023 05:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjDQDdW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Apr 2023 23:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjDQDcy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Apr 2023 23:32:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83684221
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 20:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681702253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CsnuEcjBl3Kb6xcz/8zOORlvduJyUrh5CWb1GIYJ+bk=;
        b=S3Yq6T+1S15IKWUe6yPkK5ZBhB0c6KbU7rI7C450j3PjZdX44GeqHbuLSk2GZoHFTDMo+i
        McK7bEwYc/pbeJKyLJwi/u2SEdrMQBEu6b0pJ1nCAPlYSnbbYpbI4BvDigR5VWoWxkAbZm
        Td2BeFjdtfR84q7sV0PcwW6bvetqkc8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-522-IdDP8hK_NZ2-krBBErNypQ-1; Sun, 16 Apr 2023 23:30:44 -0400
X-MC-Unique: IdDP8hK_NZ2-krBBErNypQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1789A1C07546;
        Mon, 17 Apr 2023 03:30:44 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75ADD2027062;
        Mon, 17 Apr 2023 03:30:40 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v19 41/70] ceph: fscrypt_file field handling in MClientRequest messages
Date:   Mon, 17 Apr 2023 11:26:25 +0800
Message-Id: <20230417032654.32352-42-xiubli@redhat.com>
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

From: Jeff Layton <jlayton@kernel.org>

For encrypted inodes, transmit a rounded-up size to the MDS as the
normal file size and send the real inode size in fscrypt_file field.

Also, fix up creates and truncates to also transmit fscrypt_file.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c        |  3 +++
 fs/ceph/file.c       |  1 +
 fs/ceph/inode.c      | 18 ++++++++++++++++--
 fs/ceph/mds_client.c |  9 ++++++++-
 fs/ceph/mds_client.h |  2 ++
 5 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 4746e53bdf51..98a9b1592ba6 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -914,6 +914,9 @@ static int ceph_mknod(struct mnt_idmap *idmap, struct inode *dir,
 		goto out_req;
 	}
 
+	if (S_ISREG(mode) && IS_ENCRYPTED(dir))
+		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
+
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
 	req->r_parent = dir;
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index e5c01cd634eb..f869ab31685a 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -790,6 +790,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	req->r_parent = dir;
 	ihold(dir);
 	if (IS_ENCRYPTED(dir)) {
+		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
 		if (!fscrypt_has_encryption_key(dir)) {
 			spin_lock(&dentry->d_lock);
 			dentry->d_flags |= DCACHE_NOKEY_NAME;
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index e88335e05b74..4c5ced950821 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2378,11 +2378,25 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 			}
 		} else if ((issued & CEPH_CAP_FILE_SHARED) == 0 ||
 			   attr->ia_size != isize) {
-			req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
-			req->r_args.setattr.old_size = cpu_to_le64(isize);
 			mask |= CEPH_SETATTR_SIZE;
 			release |= CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL |
 				   CEPH_CAP_FILE_RD | CEPH_CAP_FILE_WR;
+			if (IS_ENCRYPTED(inode) && attr->ia_size) {
+				set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
+				mask |= CEPH_SETATTR_FSCRYPT_FILE;
+				req->r_args.setattr.size =
+					cpu_to_le64(round_up(attr->ia_size,
+							     CEPH_FSCRYPT_BLOCK_SIZE));
+				req->r_args.setattr.old_size =
+					cpu_to_le64(round_up(isize,
+							     CEPH_FSCRYPT_BLOCK_SIZE));
+				req->r_fscrypt_file = attr->ia_size;
+				/* FIXME: client must zero out any partial blocks! */
+			} else {
+				req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
+				req->r_args.setattr.old_size = cpu_to_le64(isize);
+				req->r_fscrypt_file = 0;
+			}
 		}
 	}
 	if (ia_valid & ATTR_MTIME) {
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d1dcd6cfaeba..85d639f75ea1 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2836,7 +2836,12 @@ static void encode_mclientrequest_tail(void **p, const struct ceph_mds_request *
 	} else {
 		ceph_encode_32(p, 0);
 	}
-	ceph_encode_32(p, 0); // fscrypt_file for now
+	if (test_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags)) {
+		ceph_encode_32(p, sizeof(__le64));
+		ceph_encode_64(p, req->r_fscrypt_file);
+	} else {
+		ceph_encode_32(p, 0);
+	}
 }
 
 /*
@@ -2922,6 +2927,8 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 
 	/* fscrypt_file */
 	len += sizeof(u32);
+	if (test_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags))
+		len += sizeof(__le64);
 
 	msg = ceph_msg_new2(CEPH_MSG_CLIENT_REQUEST, len, 1, GFP_NOFS, false);
 	if (!msg) {
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 728b7d72bf76..81a1f9a4ac3b 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -282,6 +282,7 @@ struct ceph_mds_request {
 #define CEPH_MDS_R_DID_PREPOPULATE	(6) /* prepopulated readdir */
 #define CEPH_MDS_R_PARENT_LOCKED	(7) /* is r_parent->i_rwsem wlocked? */
 #define CEPH_MDS_R_ASYNC		(8) /* async request */
+#define CEPH_MDS_R_FSCRYPT_FILE		(9) /* must marshal fscrypt_file field */
 	unsigned long	r_req_flags;
 
 	struct mutex r_fill_mutex;
@@ -289,6 +290,7 @@ struct ceph_mds_request {
 	union ceph_mds_request_args r_args;
 
 	struct ceph_fscrypt_auth *r_fscrypt_auth;
+	u64	r_fscrypt_file;
 
 	u8 *r_altname;		    /* fscrypt binary crypttext for long filenames */
 	u32 r_altname_len;	    /* length of r_altname */
-- 
2.39.1


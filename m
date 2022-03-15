Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8FE4D97CB
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Mar 2022 10:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346692AbiCOJjQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Mar 2022 05:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240794AbiCOJjL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Mar 2022 05:39:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D06BAE0F1
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 02:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647337077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=eEW/3nWsX1ooocGCyramOrhPAmoJvRVfdQmcqJ9/yLI=;
        b=MKC7QXF+ChC8djAOsumWBwHdWRPQgfWEtB3zCzqWtQTE4NfAhMwJRnxi3IPmbAPXdrK7hM
        WEJ8vRRg2VZ3ucgHAnep5XC7AAvaMMRIJHvZI6w6DEAENMXIUcqdk8aFbHszE24VcLlS4D
        xRma88TbjqqkjZznTxIbL7jL3NdClIk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-kWCGouJEOXq-gMJiQdgXwg-1; Tue, 15 Mar 2022 05:37:54 -0400
X-MC-Unique: kWCGouJEOXq-gMJiQdgXwg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2771780281B;
        Tue, 15 Mar 2022 09:37:54 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3F4E7CB832;
        Tue, 15 Mar 2022 09:37:51 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: send the fscrypt_auth to MDS via request
Date:   Tue, 15 Mar 2022 17:37:41 +0800
Message-Id: <20220315093741.25664-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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

Currently when creating new files or directories the kclient will
create a new inode and fill the fscrypt auth locally, without sending
it to MDS via requests. Then the MDS reply with it to empty too.
And the kclient will update it later together with the cap update
requests.

It's buggy if just after the create requests succeeds but the kclient
crash and reboot, then in MDS side the fscrypt_auth will keep empty.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V2:
- Fix the compile errors without CONFIG_FS_ENCRYPTION enabled.



 fs/ceph/dir.c  | 43 +++++++++++++++++++++++++++++++++++++++++--
 fs/ceph/file.c | 17 ++++++++++++++++-
 2 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 5ae5cb778389..8675898a4336 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -904,8 +904,22 @@ static int ceph_mknod(struct user_namespace *mnt_userns, struct inode *dir,
 		goto out_req;
 	}
 
-	if (S_ISREG(mode) && IS_ENCRYPTED(dir))
-		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
+	if (IS_ENCRYPTED(dir)) {
+#ifdef CONFIG_FS_ENCRYPTION
+		struct ceph_inode_info *ci = ceph_inode(req->r_new_inode);
+
+		req->r_fscrypt_auth = kmemdup(ci->fscrypt_auth,
+					      ci->fscrypt_auth_len,
+					      GFP_KERNEL);
+		if (!req->r_fscrypt_auth) {
+			err = -ENOMEM;
+			goto out_req;
+		}
+#endif
+
+		if (S_ISREG(mode))
+			set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
+	}
 
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
@@ -1008,6 +1022,18 @@ static int ceph_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 	ihold(dir);
 
 	if (IS_ENCRYPTED(req->r_new_inode)) {
+#ifdef CONFIG_FS_ENCRYPTION
+		struct ceph_inode_info *ci = ceph_inode(req->r_new_inode);
+
+		req->r_fscrypt_auth = kmemdup(ci->fscrypt_auth,
+					      ci->fscrypt_auth_len,
+					      GFP_KERNEL);
+		if (!req->r_fscrypt_auth) {
+			err = -ENOMEM;
+			goto out_req;
+		}
+#endif
+
 		err = prep_encrypted_symlink_target(req, dest);
 		if (err)
 			goto out_req;
@@ -1081,6 +1107,19 @@ static int ceph_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 		goto out_req;
 	}
 
+#ifdef CONFIG_FS_ENCRYPTION
+	if (IS_ENCRYPTED(dir)) {
+		struct ceph_inode_info *ci = ceph_inode(req->r_new_inode);
+
+		req->r_fscrypt_auth = kmemdup(ci->fscrypt_auth,
+					      ci->fscrypt_auth_len,
+					      GFP_KERNEL);
+		if (!req->r_fscrypt_auth) {
+			err = -ENOMEM;
+			goto out_req;
+		}
+	}
+#endif
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
 	req->r_parent = dir;
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 61ffbda5b934..70ac41d6e0d4 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -771,9 +771,24 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	req->r_args.open.mask = cpu_to_le32(mask);
 	req->r_parent = dir;
 	ihold(dir);
-	if (IS_ENCRYPTED(dir))
+	if (IS_ENCRYPTED(dir)) {
 		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
 
+#ifdef CONFIG_FS_ENCRYPTION
+		if (new_inode) {
+			struct ceph_inode_info *ci = ceph_inode(new_inode);
+
+			req->r_fscrypt_auth = kmemdup(ci->fscrypt_auth,
+						      ci->fscrypt_auth_len,
+						      GFP_KERNEL);
+			if (!req->r_fscrypt_auth) {
+				err = -ENOMEM;
+				goto out_req;
+			}
+		}
+#endif
+	}
+
 	if (flags & O_CREAT) {
 		struct ceph_file_layout lo;
 
-- 
2.27.0


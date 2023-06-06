Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792917235DA
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 05:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbjFFDmD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Jun 2023 23:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbjFFDmC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Jun 2023 23:42:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6241B7
        for <ceph-devel@vger.kernel.org>; Mon,  5 Jun 2023 20:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686022870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ATyjqZjx5JgBQ3Yv12KhBm1daa1o2ysOI21ZvxMcgdI=;
        b=TYfRJ0QNeaz/iQxjPbBKHEEEjgJg9AeIKdbUAf0OQl70meHxnno6zzA+kQG5oHg5qf0C+x
        SkP3EcgcWbAL2NC50emM0W2JKuJuP5sL9pQB7KGgyoBwnafadiK+q6RFmNWDN0LSUVEj7p
        m93GTGw1rewc5TGvJT7bPBRgmiBcTKg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-HZjOe1IwPL6c-B0KIVcEgg-1; Mon, 05 Jun 2023 23:41:09 -0400
X-MC-Unique: HZjOe1IwPL6c-B0KIVcEgg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 560DE8030D2;
        Tue,  6 Jun 2023 03:41:09 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-128.pek2.redhat.com [10.72.12.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E4132166B25;
        Tue,  6 Jun 2023 03:41:05 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: voluntarily drop Xx caps for requests those touch parent mtime
Date:   Tue,  6 Jun 2023 11:38:50 +0800
Message-Id: <20230606033850.1069497-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

For write requests the parent's mtime will be updated correspondingly.
And if the 'Xx' caps is issued and when releasing other caps together
with the write requests the MDS Locker will try to eval the xattr lock,
which need to change the locker state excl --> sync and need to do Xx
caps revocation.

Just voluntarily dropping CEPH_CAP_XATTR_EXCL caps to avoid a cap
revoke message, which could cause the mtime will be overwrote by stale
one.

URL: https://tracker.ceph.com/issues/61584
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/dir.c  | 14 +++++++-------
 fs/ceph/file.c |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 09bbd0ffbf4f..1b46f2b998c3 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -925,7 +925,7 @@ static int ceph_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 	req->r_args.mknod.mode = cpu_to_le32(mode);
 	req->r_args.mknod.rdev = cpu_to_le32(rdev);
-	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
+	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL | CEPH_CAP_XATTR_EXCL;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
 
 	ceph_as_ctx_to_req(req, &as_ctx);
@@ -1037,7 +1037,7 @@ static int ceph_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
-	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
+	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL | CEPH_CAP_XATTR_EXCL;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
 
 	ceph_as_ctx_to_req(req, &as_ctx);
@@ -1112,7 +1112,7 @@ static int ceph_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	ihold(dir);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 	req->r_args.mkdir.mode = cpu_to_le32(mode);
-	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
+	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL | CEPH_CAP_XATTR_EXCL;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
 
 	ceph_as_ctx_to_req(req, &as_ctx);
@@ -1173,7 +1173,7 @@ static int ceph_link(struct dentry *old_dentry, struct inode *dir,
 	req->r_parent = dir;
 	ihold(dir);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
-	req->r_dentry_drop = CEPH_CAP_FILE_SHARED;
+	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_XATTR_EXCL;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
 	/* release LINK_SHARED on source inode (mds will lock it) */
 	req->r_old_inode_drop = CEPH_CAP_LINK_SHARED | CEPH_CAP_LINK_EXCL;
@@ -1312,7 +1312,7 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
 	req->r_num_caps = 2;
 	req->r_parent = dir;
 	ihold(dir);
-	req->r_dentry_drop = CEPH_CAP_FILE_SHARED;
+	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_XATTR_EXCL;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
 	req->r_inode_drop = ceph_drop_caps_for_unlink(inode);
 
@@ -1418,9 +1418,9 @@ static int ceph_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	req->r_parent = new_dir;
 	ihold(new_dir);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
-	req->r_old_dentry_drop = CEPH_CAP_FILE_SHARED;
+	req->r_old_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_XATTR_EXCL;
 	req->r_old_dentry_unless = CEPH_CAP_FILE_EXCL;
-	req->r_dentry_drop = CEPH_CAP_FILE_SHARED;
+	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_XATTR_EXCL;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
 	/* release LINK_RDCACHE on source inode (mds will lock it) */
 	req->r_old_inode_drop = CEPH_CAP_LINK_SHARED | CEPH_CAP_LINK_EXCL;
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 9e74ed673f93..e878a462c7c3 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -799,7 +799,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	if (flags & O_CREAT) {
 		struct ceph_file_layout lo;
 
-		req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
+		req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL | CEPH_CAP_XATTR_EXCL;
 		req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
 
 		ceph_as_ctx_to_req(req, &as_ctx);
-- 
2.40.1


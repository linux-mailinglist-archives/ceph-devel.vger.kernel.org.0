Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650334AE36C
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Feb 2022 23:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386226AbiBHWV6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Feb 2022 17:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386229AbiBHTqw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Feb 2022 14:46:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBC9C0613CB
        for <ceph-devel@vger.kernel.org>; Tue,  8 Feb 2022 11:46:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED70E615D4
        for <ceph-devel@vger.kernel.org>; Tue,  8 Feb 2022 19:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9FEC004E1;
        Tue,  8 Feb 2022 19:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644349610;
        bh=CctA91sa5uH2GNrRF2GSZlnDNJ6hZRl2jlYC1vAJyHU=;
        h=From:To:Cc:Subject:Date:From;
        b=IlKjSeuQdUtKNrntmRP9rUNtYIxhw5SkFv/QHcOFuGvobP8H84/G3njoShLh5S0wN
         b1WmcvmUp3LEkLzLiL03WbW4roqEoB5LO6vpcNR4vyPJIZuHVRLWh6xo5CD/c57a2V
         aXb9vn3erANwVpGkcOfrjUnv4H/iCWK4ZvHCwX9IGqRTMhKq9ZfwrSnxyaeWx7X0Xu
         IkOjA5BgkdGry60XMj6ck9LaDLUo/smlO7yMyNKyI18jPwGd7u0w9yJ7sdOJW/ODHn
         HhJg8XjZEc4XpvS/Ogu4SuFEj+HjFW7IG+yGIe8LOE+UJShGkcxMX0FbZ19QMHlYQv
         mIOtE1Ktku8Dw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, ridave@redhat.com
Subject: [PATCH] ceph: wake waiters after failed async create
Date:   Tue,  8 Feb 2022 14:46:48 -0500
Message-Id: <20220208194648.190652-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently, we only wake the waiters if we got a req->r_target_inode
out of the reply. In the case where the create fails though, we may not
have one.

If there is a non-zero result from the create, then ensure that we wake
anything waiting on the inode after we shut it down.

URL: https://tracker.ceph.com/issues/54067
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 51 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 18 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 22ca724aef36..feb75eb1cd82 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -532,52 +532,67 @@ static void restore_deleg_ino(struct inode *dir, u64 ino)
 	}
 }
 
+static void wake_async_create_waiters(struct inode *inode,
+				      struct ceph_mds_session *session)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+
+	spin_lock(&ci->i_ceph_lock);
+	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
+		ci->i_ceph_flags &= ~CEPH_I_ASYNC_CREATE;
+		wake_up_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT);
+	}
+	ceph_kick_flushing_inode_caps(session, ci);
+	spin_unlock(&ci->i_ceph_lock);
+}
+
 static void ceph_async_create_cb(struct ceph_mds_client *mdsc,
                                  struct ceph_mds_request *req)
 {
+	struct dentry *dentry = req->r_dentry;
+	struct inode *dinode = d_inode(dentry);
+	struct inode *tinode = req->r_target_inode;
 	int result = req->r_err ? req->r_err :
 			le32_to_cpu(req->r_reply_info.head->result);
 
+	WARN_ON_ONCE(dinode && tinode && dinode != tinode);
+
+	/* MDS changed -- caller must resubmit */
 	if (result == -EJUKEBOX)
 		goto out;
 
 	mapping_set_error(req->r_parent->i_mapping, result);
 
 	if (result) {
-		struct dentry *dentry = req->r_dentry;
-		struct inode *inode = d_inode(dentry);
 		int pathlen = 0;
 		u64 base = 0;
 		char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
 						  &base, 0);
 
+		pr_warn("ceph: async create failure path=(%llx)%s result=%d!\n",
+			base, IS_ERR(path) ? "<<bad>>" : path, result);
+		ceph_mdsc_free_path(path, pathlen);
+
 		ceph_dir_clear_complete(req->r_parent);
 		if (!d_unhashed(dentry))
 			d_drop(dentry);
 
-		ceph_inode_shutdown(inode);
-
-		pr_warn("ceph: async create failure path=(%llx)%s result=%d!\n",
-			base, IS_ERR(path) ? "<<bad>>" : path, result);
-		ceph_mdsc_free_path(path, pathlen);
+		if (dinode) {
+			mapping_set_error(dinode->i_mapping, result);
+			ceph_inode_shutdown(dinode);
+			wake_async_create_waiters(dinode, req->r_session);
+		}
 	}
 
-	if (req->r_target_inode) {
-		struct ceph_inode_info *ci = ceph_inode(req->r_target_inode);
-		u64 ino = ceph_vino(req->r_target_inode).ino;
+	if (tinode) {
+		u64 ino = ceph_vino(tinode).ino;
 
 		if (req->r_deleg_ino != ino)
 			pr_warn("%s: inode number mismatch! err=%d deleg_ino=0x%llx target=0x%llx\n",
 				__func__, req->r_err, req->r_deleg_ino, ino);
-		mapping_set_error(req->r_target_inode->i_mapping, result);
 
-		spin_lock(&ci->i_ceph_lock);
-		if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
-			ci->i_ceph_flags &= ~CEPH_I_ASYNC_CREATE;
-			wake_up_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT);
-		}
-		ceph_kick_flushing_inode_caps(req->r_session, ci);
-		spin_unlock(&ci->i_ceph_lock);
+		mapping_set_error(tinode->i_mapping, result);
+		wake_async_create_waiters(tinode, req->r_session);
 	} else if (!result) {
 		pr_warn("%s: no req->r_target_inode for 0x%llx\n", __func__,
 			req->r_deleg_ino);
-- 
2.34.1


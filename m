Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611615A1260
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236545AbiHYNci (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242794AbiHYNcG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:32:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F49B5A7D
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:31:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DB4D2CE286B
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D969BC43470;
        Thu, 25 Aug 2022 13:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434312;
        bh=A17Ix50GhOKPja+MQGqEXiOQ09LlHVxBdH0kL4lVNk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJRaO/jNt4K4jV+LkMw+WqqKfGZULSHCwR14mecqx4xH9ywryMC0Hol2b04R0jeWI
         mqOZxfKWiEQJKaMloVzJBHFAhXBkvglM+n8mhZZVwHRYkZPz0gMvh2MEBLH2tLVS5S
         Hnhb5cNIszH5xCOtVI5py/Vv/kQwcvuCGLLrSXYGYWRiiCSL+YtI/bZifvclCW6D01
         sJScxdfjM5nYSgKA1ZVqsF40lCu+eOAwswH7j9eRbTYZmbKS6f5PGhNWjVdqmh+X8D
         6mnq6A3AqKqNCDrA5ddPJhaROwtfz7wLRnTNeVbfEYu96lkFN0A3krULlZBwdTeNBl
         Tf+HaFDXcH6GA==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 25/29] ceph: add support for encrypted snapshot names
Date:   Thu, 25 Aug 2022 09:31:28 -0400
Message-Id: <20220825133132.153657-26-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825133132.153657-1-jlayton@kernel.org>
References: <20220825133132.153657-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Luís Henriques <lhenriques@suse.de>

Since filenames in encrypted directories are already encrypted and shown
as a base64-encoded string when the directory is locked, snapshot names
should show a similar behaviour.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 6cb791bc8701..a8a6e55252c0 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -92,9 +92,15 @@ struct inode *ceph_new_inode(struct inode *dir, struct dentry *dentry,
 	if (err < 0)
 		goto out_err;
 
-	err = ceph_fscrypt_prepare_context(dir, inode, as_ctx);
-	if (err)
-		goto out_err;
+	/*
+	 * We'll skip setting fscrypt context for snapshots, leaving that for
+	 * the handle_reply().
+	 */
+	if (ceph_snap(dir) != CEPH_SNAPDIR) {
+		err = ceph_fscrypt_prepare_context(dir, inode, as_ctx);
+		if (err)
+			goto out_err;
+	}
 
 	return inode;
 out_err:
@@ -158,6 +164,7 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 	};
 	struct inode *inode = ceph_get_inode(parent->i_sb, vino, NULL);
 	struct ceph_inode_info *ci = ceph_inode(inode);
+	int ret = -ENOTDIR;
 
 	if (IS_ERR(inode))
 		return inode;
@@ -183,6 +190,24 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 	ci->i_rbytes = 0;
 	ci->i_btime = ceph_inode(parent)->i_btime;
 
+#ifdef CONFIG_FS_ENCRYPTION
+	/* if encrypted, just borrow fscrypt_auth from parent */
+	if (IS_ENCRYPTED(parent)) {
+		struct ceph_inode_info *pci = ceph_inode(parent);
+
+		ci->fscrypt_auth = kmemdup(pci->fscrypt_auth,
+					   pci->fscrypt_auth_len,
+					   GFP_KERNEL);
+		if (ci->fscrypt_auth) {
+			inode->i_flags |= S_ENCRYPTED;
+			ci->fscrypt_auth_len = pci->fscrypt_auth_len;
+		} else {
+			dout("Failed to alloc snapdir fscrypt_auth\n");
+			ret = -ENOMEM;
+			goto err;
+		}
+	}
+#endif
 	if (inode->i_state & I_NEW) {
 		inode->i_op = &ceph_snapdir_iops;
 		inode->i_fop = &ceph_snapdir_fops;
@@ -196,7 +221,7 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 		discard_new_inode(inode);
 	else
 		iput(inode);
-	return ERR_PTR(-ENOTDIR);
+	return ERR_PTR(ret);
 }
 
 const struct inode_operations ceph_file_iops = {
-- 
2.37.2


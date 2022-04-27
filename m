Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0ECF51226F
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbiD0TVB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbiD0TTj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBC55640C
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:14:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BBD2619D0
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535BCC385AA;
        Wed, 27 Apr 2022 19:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086839;
        bh=A7kETN+JY5E4nL65vstmtUK+OqjWmTWqevzjKSn4JFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nT+G3u7b8f7UxFtop52KOzzmijwdhVxSXxbXB+uf8C6d2OmCtaGZzzAuAHyl2fZr/
         xOFIwXV5kbuypLthnrLenKKkFjS41ziwZdXZyZaq62+xB1yqoQWiI9CjRGEBiqzPoX
         Thx6yYGmcdITPK76vtTj2RfC9cgbGCjSth2lPUtjh7fUoIAancUsvDVJ9UoQNztteS
         krU2cGBLnxysHe0hG6a0fMELgIqFCIvLhugqwcESqgxNd159aOoRa2uO+djZJHHv8I
         HQ1gmMEJeH/Riajq8V3SxHcoNgM8Jy2Xd/ipbKv1Yrti/Yo5OU/dgTvZcjLAvxWs6f
         pAlkb9nJkKm4w==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 61/64] ceph: add support for encrypted snapshot names
Date:   Wed, 27 Apr 2022 15:13:11 -0400
Message-Id: <20220427191314.222867-62-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427191314.222867-1-jlayton@kernel.org>
References: <20220427191314.222867-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Luís Henriques <lhenriques@suse.de>

Since filenames in encrypted directories are already encrypted and shown
as a base64-encoded string when the directory is locked, snapshot names
should show a similar behaviour.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 021638fb85f9..71894ea6f9ae 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -91,9 +91,15 @@ struct inode *ceph_new_inode(struct inode *dir, struct dentry *dentry,
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
@@ -157,6 +163,7 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 	};
 	struct inode *inode = ceph_get_inode(parent->i_sb, vino, NULL);
 	struct ceph_inode_info *ci = ceph_inode(inode);
+	int ret = -ENOTDIR;
 
 	if (IS_ERR(inode))
 		return inode;
@@ -182,6 +189,24 @@ struct inode *ceph_get_snapdir(struct inode *parent)
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
@@ -195,7 +220,7 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 		discard_new_inode(inode);
 	else
 		iput(inode);
-	return ERR_PTR(-ENOTDIR);
+	return ERR_PTR(ret);
 }
 
 const struct inode_operations ceph_file_iops = {
-- 
2.35.1


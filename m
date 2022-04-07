Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6324E4F7E8A
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Apr 2022 14:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238439AbiDGMEd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 08:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231937AbiDGMEa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 08:04:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EB18BF01
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 05:02:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9221FB82191
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 12:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AA9C385A0;
        Thu,  7 Apr 2022 12:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649332948;
        bh=8M9PvelXpi/voVPfiWCg+hio8GT7wj8QBNTnPOOTN74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qyFERYgofFl/JOiNSPPaicLx2qwdtKSwvbpUuzwaCzpjMJaYo1pgMKu244BID/1KP
         2liV/tlI0Do7q5HUsk79Lof5PVXuF04p2cK6E9v3aQLTZRBYPfGW24n4dG8GPkqveH
         KEfrUDqH+f/yKYZCq59sgMSl8XCNxES9uQ9GoUjUyBpzUE+6cc+RXS7CjdLzYupP+u
         h35kzFf974YZ94BlpD3IiOZ1tGLywIJVrmPGH1equ9fv9IDAexB3GHROOTHizzVQxU
         FWsCVIda+rgt2bBn30riwmVeuncMpi95DHpxosMwjgZq7AxuQRNgqiFcrUBp5Rd6SE
         N2HgRCt1pXrUw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, dhowells@redhat.com
Cc:     idryomov@gmail.com, xiubli@redhat.com, linux-cachefs@redhat.com
Subject: [RFC PATCH 2/5] ceph: set rsize in netfs_i_context from mount options
Date:   Thu,  7 Apr 2022 08:02:21 -0400
Message-Id: <20220407120224.76156-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407120224.76156-1-jlayton@kernel.org>
References: <20220407120224.76156-1-jlayton@kernel.org>
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

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 1dad69a0ab70..8ea1b53b6ce9 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -450,6 +450,7 @@ static int ceph_fill_fragtree(struct inode *inode,
  */
 struct inode *ceph_alloc_inode(struct super_block *sb)
 {
+	struct ceph_mount_options *fsopt = ceph_sb_to_client(sb)->mount_options;
 	struct ceph_inode_info *ci;
 	struct netfs_i_context *ctx;
 	int i;
@@ -463,7 +464,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 	/* Set parameters for the netfs library */
 	ctx = netfs_i_context(&ci->vfs_inode);
 	netfs_i_context_init(&ci->vfs_inode, &ceph_netfs_ops);
-	ctx->rsize = 1024 * 1024;
+	ctx->rsize = fsopt->rsize;
 
 	spin_lock_init(&ci->i_ceph_lock);
 
-- 
2.35.1


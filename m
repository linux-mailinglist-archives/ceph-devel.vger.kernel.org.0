Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E75E51224B
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbiD0TTm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbiD0TTN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0622F2C13F
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB9F1619FC
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51CCC385AE;
        Wed, 27 Apr 2022 19:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086806;
        bh=5zFRUKmjXvvstcTiF+tAA1/QKJtXVH1q8ZRNbJAoGs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZViOCwUZB7yY9jnLX0DtZB5gRL7ONYTpLCS8miODH18eAdWB5DjsEtNr8C8GJV9s
         asaNLA1Ora4XFxhRwNRP2ZL7lRL5ZAuDmgPgWoqHWoLADbwp9p34vUcISCwNwz6yXV
         z+c18mFqb7FLQChllfRvg4jdVt5n/SkZlVKVJXDA6YN86roPgImlniHWhovEswk8vc
         gEAm+BhBtGEZEe6gN37Lr/CcHARiJkj1MEroFlOWn3RWi6Xrnm/ylDT+T4leg7QcCd
         LKgLc27Q7fLMYuWhBqNkdwNyIEttr0LbtzPN3MgX2+M8fyK5VAvu4y5RIxMyiXlR9O
         6Eb7Z8gilpJ2Q==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 13/64] ceph: ensure that we accept a new context from MDS for new inodes
Date:   Wed, 27 Apr 2022 15:12:23 -0400
Message-Id: <20220427191314.222867-14-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427191314.222867-1-jlayton@kernel.org>
References: <20220427191314.222867-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 74e428b22683..2fb7481060cd 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -944,6 +944,17 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 
 	__ceph_update_quota(ci, iinfo->max_bytes, iinfo->max_files);
 
+#ifdef CONFIG_FS_ENCRYPTION
+	if (iinfo->fscrypt_auth_len && (inode->i_state & I_NEW)) {
+		kfree(ci->fscrypt_auth);
+		ci->fscrypt_auth_len = iinfo->fscrypt_auth_len;
+		ci->fscrypt_auth = iinfo->fscrypt_auth;
+		iinfo->fscrypt_auth = NULL;
+		iinfo->fscrypt_auth_len = 0;
+		inode_set_flags(inode, S_ENCRYPTED, S_ENCRYPTED);
+	}
+#endif
+
 	if ((new_version || (new_issued & CEPH_CAP_AUTH_SHARED)) &&
 	    (issued & CEPH_CAP_AUTH_EXCL) == 0) {
 		inode->i_mode = mode;
@@ -1033,16 +1044,6 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 		xattr_blob = NULL;
 	}
 
-#ifdef CONFIG_FS_ENCRYPTION
-	if (iinfo->fscrypt_auth_len && !ci->fscrypt_auth) {
-		ci->fscrypt_auth_len = iinfo->fscrypt_auth_len;
-		ci->fscrypt_auth = iinfo->fscrypt_auth;
-		iinfo->fscrypt_auth = NULL;
-		iinfo->fscrypt_auth_len = 0;
-		inode_set_flags(inode, S_ENCRYPTED, S_ENCRYPTED);
-	}
-#endif
-
 	/* finally update i_version */
 	if (le64_to_cpu(info->version) > ci->i_version)
 		ci->i_version = le64_to_cpu(info->version);
-- 
2.35.1


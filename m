Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F5B4E7CBE
	for <lists+ceph-devel@lfdr.de>; Sat, 26 Mar 2022 01:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiCYTR2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 25 Mar 2022 15:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiCYTRZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 25 Mar 2022 15:17:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A19A1D7898
        for <ceph-devel@vger.kernel.org>; Fri, 25 Mar 2022 11:58:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C38C0B82865
        for <ceph-devel@vger.kernel.org>; Fri, 25 Mar 2022 18:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF96C004DD;
        Fri, 25 Mar 2022 18:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648233648;
        bh=hSw7t/ht1ptPxvtAHJ/BGfbHvZ5GZjT8xRe9LoN4BSQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ajHU0Rl0HUmXadKVltiMoEK/x9CUbQDgfGu9kwQvdhjjBc2/c7C0Dtkt/ZqFDmGJT
         6ETR0kG0dQ8NpGH6np97y/i8ul2+VbuvbfHiGEmr5BUF9fiB1k7JMtKELtOVdH/uXL
         pNxhYFsa8TYHiNPM0Up/oBy13X/Jk4Ovj0bPm2L8WKXwwox/zPW4M6Tebhp+JequU9
         kFgKimUngMiFcd5NPiN5cU7bB7t4DNYG8WgdYf1M1OyWLUcVjWZkLVd5oTtSM+ttJX
         IIj93dDwe/DaCEqB3xt29rwww+4xRFbMobgu94ZTaA6PwzmUYPpfS3l7vy42V3toFe
         P4ZRrzjZ7zrtw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, xiubli@redhat.com,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH] ceph: add a has_stable_inodes operation for ceph
Date:   Fri, 25 Mar 2022 14:40:46 -0400
Message-Id: <20220325184046.236663-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

...and just have it return true. It should never change inode numbers
out from under us, as they are baked into the object names.

Reported-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/crypto.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 2a8f95885e7d..3a9214b1e8b3 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -59,6 +59,11 @@ static int ceph_crypt_set_context(struct inode *inode, const void *ctx, size_t l
 	return ret;
 }
 
+static const union fscrypt_policy *ceph_get_dummy_policy(struct super_block *sb)
+{
+	return ceph_sb_to_client(sb)->dummy_enc_policy.policy;
+}
+
 static bool ceph_crypt_empty_dir(struct inode *inode)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
@@ -66,14 +71,9 @@ static bool ceph_crypt_empty_dir(struct inode *inode)
 	return ci->i_rsubdirs + ci->i_rfiles == 1;
 }
 
-void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc)
+static bool ceph_crypt_has_stable_inodes(struct super_block *sb)
 {
-	fscrypt_free_dummy_policy(&fsc->dummy_enc_policy);
-}
-
-static const union fscrypt_policy *ceph_get_dummy_policy(struct super_block *sb)
-{
-	return ceph_sb_to_client(sb)->dummy_enc_policy.policy;
+	return true;
 }
 
 static struct fscrypt_operations ceph_fscrypt_ops = {
@@ -82,6 +82,7 @@ static struct fscrypt_operations ceph_fscrypt_ops = {
 	.set_context		= ceph_crypt_set_context,
 	.get_dummy_policy	= ceph_get_dummy_policy,
 	.empty_dir		= ceph_crypt_empty_dir,
+	.has_stable_inodes	= ceph_crypt_has_stable_inodes,
 };
 
 void ceph_fscrypt_set_ops(struct super_block *sb)
@@ -89,6 +90,11 @@ void ceph_fscrypt_set_ops(struct super_block *sb)
 	fscrypt_set_ops(sb, &ceph_fscrypt_ops);
 }
 
+void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc)
+{
+	fscrypt_free_dummy_policy(&fsc->dummy_enc_policy);
+}
+
 int ceph_fscrypt_prepare_context(struct inode *dir, struct inode *inode,
 				 struct ceph_acl_sec_ctx *as)
 {
-- 
2.35.1


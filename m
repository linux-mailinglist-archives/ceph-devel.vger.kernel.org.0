Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5D451225F
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbiD0TU0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbiD0TTP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444AA89CC9
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D077D619FE
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372AAC385AE;
        Wed, 27 Apr 2022 19:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086814;
        bh=U24PxxvQ6v89QmCZ/efk298RUKYN48wbTknFX6iZrs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OK4AiQp58XCNd7IZouSyoTZXpOhHCJWEC3jIGZWk0e3zUSei9T8BBKK1w8MpkqeVi
         rCSkBIIkrmWwgoSbTK0a64u3RApE0QOF+JGS/8jVr2JM0JpE7tVkbcDgfOS/z/zJXm
         ajGmUdke2nTBqGs1tfHwCkH6JHhWAITB+I6vjdBSwsbSZPXCR6LLYW7YIfX+iy9Ysy
         YPspRk/tVk0okBaogXixj9CakNbGsCZovOxpAyVfZNAJtmYzt+3r9cGCDNdNILQ+pI
         s+Ajzc/5cMMcrV/vV+k003V4CIhSXaXulsCnChyaUPCqqv1JYadazoT+frfFLOrSpl
         0vBALL+0t9I+A==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 25/64] ceph: set DCACHE_NOKEY_NAME in atomic open
Date:   Wed, 27 Apr 2022 15:12:35 -0400
Message-Id: <20220427191314.222867-26-jlayton@kernel.org>
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

Atomic open can act as a lookup if handed a dentry that is negative on
the MDS. Ensure that we set DCACHE_NOKEY_NAME on the dentry in
atomic_open, if we don't have the key for the parent. Otherwise, we can
end up validating the dentry inappropriately if someone later adds a
key.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 391de38fa489..a519218ef942 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -768,6 +768,13 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	req->r_args.open.mask = cpu_to_le32(mask);
 	req->r_parent = dir;
 	ihold(dir);
+	if (IS_ENCRYPTED(dir)) {
+		if (!fscrypt_has_encryption_key(dir)) {
+			spin_lock(&dentry->d_lock);
+			dentry->d_flags |= DCACHE_NOKEY_NAME;
+			spin_unlock(&dentry->d_lock);
+		}
+	}
 
 	if (flags & O_CREAT) {
 		struct ceph_file_layout lo;
-- 
2.35.1


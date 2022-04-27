Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038C851229C
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbiD0T17 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbiD0TTO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA90E2F392
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8723D619FC
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81530C385A9;
        Wed, 27 Apr 2022 19:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086814;
        bh=40bz7fgcSkfmSJmWJDKxd9JZxineBbUvX30XOIb7qbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dOWgDtv0+nQoiWl8y/5F2vwnlkkxU6B/29IonJe4l1yS6C+u6rokdRdI8avgo+BRO
         fJ7xrcOuheBR9SZ0ZuBgrRPajyHmng3TU3hLmojFe14m2m8ILeIfmN4W4QAzMd35gi
         h+jWhsMCRQfcFQkoOikX+CaU8487SYXiXj9Iu0mIIJBboatQkJ9wKc4IHHilHvNf7y
         hmrhcXYuLtCjDiMhdTl4I6GF6r+XZao1p8y6I8iSWBKjSmsGcn7NeUQugLqzrskslm
         +aMg5+hTR1bVFbReZxrKK8hb77qPnh15y7q7V+xgFLR2IsCZpCFJ70boMPRsjTIUJT
         2tcgLHhQIp4aQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 24/64] ceph: properly set DCACHE_NOKEY_NAME flag in lookup
Date:   Wed, 27 Apr 2022 15:12:34 -0400
Message-Id: <20220427191314.222867-25-jlayton@kernel.org>
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

This is required so that we know to invalidate these dentries when the
directory is unlocked.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 8cc7a49ee508..897f8618151b 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -760,6 +760,17 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 	if (dentry->d_name.len > NAME_MAX)
 		return ERR_PTR(-ENAMETOOLONG);
 
+	if (IS_ENCRYPTED(dir)) {
+		err = __fscrypt_prepare_readdir(dir);
+		if (err)
+			return ERR_PTR(err);
+		if (!fscrypt_has_encryption_key(dir)) {
+			spin_lock(&dentry->d_lock);
+			dentry->d_flags |= DCACHE_NOKEY_NAME;
+			spin_unlock(&dentry->d_lock);
+		}
+	}
+
 	/* can we conclude ENOENT locally? */
 	if (d_really_is_negative(dentry)) {
 		struct ceph_inode_info *ci = ceph_inode(dir);
-- 
2.35.1


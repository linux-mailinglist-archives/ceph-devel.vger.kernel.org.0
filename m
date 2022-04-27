Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99CE512290
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbiD0T1s (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbiD0TTU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3447C3FDAC
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C636D619D0
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE31C385AE;
        Wed, 27 Apr 2022 19:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086827;
        bh=KdIltuAp7wZhOcrwU+gef/tKzLkjw6Cm7Gyvf8JBJww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doelbarFkDoE2J/VpKORFnAvuKSxDUwTsYtw2SHrSgUqYLgAYgbMzirPLUk3BvDeV
         /hmssPmJWF/i9X3HGJGc11pK26apq44VkkoCW6iixKKdDG8+5cVEPVDCQUm/qk5/Ub
         6LpCfmUaldmSW8x1MzlCjViYAZ++dJLWxUhaw6WkRMw5p0nknXy5oE3s8OzUIck0OH
         4Uli4fBBcRoGqYuv/qTPAuh+gN/NQR5FeEMOVZSrDBxwNUc5mo3PDdPu1lNbrD+PCM
         TywPxfM53d2a8JwfdTuqo3WNNnpyNfROP8f/g6tthJ2JsuRU3a61Iz4ULYr1UHNM59
         S0aSoLekuxI7w==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 43/64] ceph: update WARN_ON message to pr_warn
Date:   Wed, 27 Apr 2022 15:12:53 -0400
Message-Id: <20220427191314.222867-44-jlayton@kernel.org>
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

Give some more helpful info

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c931290e5f1a..876f1698e911 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3477,10 +3477,13 @@ static void handle_cap_grant(struct inode *inode,
 		dout("%p mode 0%o uid.gid %d.%d\n", inode, inode->i_mode,
 		     from_kuid(&init_user_ns, inode->i_uid),
 		     from_kgid(&init_user_ns, inode->i_gid));
-
-		WARN_ON_ONCE(ci->fscrypt_auth_len != extra_info->fscrypt_auth_len ||
-			     memcmp(ci->fscrypt_auth, extra_info->fscrypt_auth,
-				     ci->fscrypt_auth_len));
+#if IS_ENABLED(CONFIG_FS_ENCRYPTION)
+		if (ci->fscrypt_auth_len != extra_info->fscrypt_auth_len ||
+		    memcmp(ci->fscrypt_auth, extra_info->fscrypt_auth,
+			   ci->fscrypt_auth_len))
+			pr_warn_ratelimited("%s: cap grant attempt to change fscrypt_auth on non-I_NEW inode (old len %d new len %d)\n",
+				__func__, ci->fscrypt_auth_len, extra_info->fscrypt_auth_len);
+#endif
 	}
 
 	if ((newcaps & CEPH_CAP_LINK_SHARED) &&
-- 
2.35.1


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5DC75A123E
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242744AbiHYNbt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241609AbiHYNbn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:31:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1366B14DF
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:31:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97D87B829C1
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74FCC433B5;
        Thu, 25 Aug 2022 13:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434299;
        bh=81rPHGnOO/YZTjmemrMzzO3lxPX5A36FISmuWbYvtb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDkphbV2rfwQph51LB50P0MW7fQsXZfu1vxc6ZHAGKkHPeYGhRCAJ4EUo/okDzPjl
         iRaZWF/qQPbYV4pTwB8v8gzsZ2e/wvG/d0PLXgL9hw8wwyEu18kgfEw2pFaym2L5/X
         GLbFBjtHu67Mdid/PlN5FTUNtO81Zn05M4eR48TCF0/4MUDVgtPccsvViPtPCLDJGs
         xbQ0MBaYdZwUKZM1pvxIbdbrPg1m6UUVlqeroo/wmjjHk4znTHGc0O74+W47TiPv4w
         lXWmBC/6JLnoTK0z3hJZFxjxjo3WeDK1VGwGfbV/s0JTJSDmI2ZHSmr7ON13Ux3KLa
         ifQiOHMeVnbYA==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 07/29] ceph: update WARN_ON message to pr_warn
Date:   Thu, 25 Aug 2022 09:31:10 -0400
Message-Id: <20220825133132.153657-8-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825133132.153657-1-jlayton@kernel.org>
References: <20220825133132.153657-1-jlayton@kernel.org>
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

Give some more helpful info

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 448125edd76b..e09bc49809cf 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3503,10 +3503,13 @@ static void handle_cap_grant(struct inode *inode,
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
2.37.2


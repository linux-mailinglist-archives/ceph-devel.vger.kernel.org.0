Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9056A39A9
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 04:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjB0Dc2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 22:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjB0DcZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 22:32:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFA11CAF7
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 19:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677468657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZXe4TKQ2Vfm5AlJjSCqG3vfhH6vBoA7zW/q47Bd3YiE=;
        b=c9M82AWY71HpXAM+VVACS+3RaoAA/rP65rdaDqM1ksCpcVJtBeahjjDGt50MtgLyZJ2Uwh
        gBLHH2J3L+AEX0AQFWYy9lEwZqhSiLaBzLGLxcGOtZB6RwC3TQCuAKw7zUyBvW9gVYVk7r
        bPLIdx5f63Y18kPMRukirKK/oNJu3w0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-BQ4zhpmZPAKbr_hGqr08Ew-1; Sun, 26 Feb 2023 22:30:53 -0500
X-MC-Unique: BQ4zhpmZPAKbr_hGqr08Ew-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83314185A7A4;
        Mon, 27 Feb 2023 03:30:53 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B49EA1731B;
        Mon, 27 Feb 2023 03:30:50 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v16 44/68] ceph: update WARN_ON message to pr_warn
Date:   Mon, 27 Feb 2023 11:27:49 +0800
Message-Id: <20230227032813.337906-45-xiubli@redhat.com>
In-Reply-To: <20230227032813.337906-1-xiubli@redhat.com>
References: <20230227032813.337906-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Give some more helpful info

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index b950eaf7d86b..81ba8ee3e023 100644
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
2.31.1


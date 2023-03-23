Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34D76C6039
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Mar 2023 07:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbjCWG7g (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Mar 2023 02:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjCWG7d (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Mar 2023 02:59:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38044C0D
        for <ceph-devel@vger.kernel.org>; Wed, 22 Mar 2023 23:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679554695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fZ961ayb9GPLMEUCRzO+unAVjA7mfpEfmHlb/el2VnE=;
        b=DwXbQWV3unDazbs7LT9co/6RTgx3WxEeeyc39MP6LQLXqF2vwG6IX9hS6DN5kBJJ/eTkHg
        hdJ8WUBPq5JJlcbsn99z9SetMkdnlGRtFCSbrfKABw+wmBKo4N8BV4wSPlA/Lry4/7mVbB
        0R7sgN+iW3vV49IynUPHLTfCeP7DvuY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-jXLNGBKaMJa_YtIT50ExIA-1; Thu, 23 Mar 2023 02:58:11 -0400
X-MC-Unique: jXLNGBKaMJa_YtIT50ExIA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CE00380607D;
        Thu, 23 Mar 2023 06:58:11 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51750492B01;
        Thu, 23 Mar 2023 06:58:08 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v17 44/71] ceph: update WARN_ON message to pr_warn
Date:   Thu, 23 Mar 2023 14:54:58 +0800
Message-Id: <20230323065525.201322-45-xiubli@redhat.com>
In-Reply-To: <20230323065525.201322-1-xiubli@redhat.com>
References: <20230323065525.201322-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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
index a0601a00b9d3..10e69857f692 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3478,10 +3478,13 @@ static void handle_cap_grant(struct inode *inode,
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


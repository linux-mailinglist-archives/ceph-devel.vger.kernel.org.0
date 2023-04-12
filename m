Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767756DF2C0
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Apr 2023 13:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjDLLM4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Apr 2023 07:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjDLLMx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Apr 2023 07:12:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE8B7DAF
        for <ceph-devel@vger.kernel.org>; Wed, 12 Apr 2023 04:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681297854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fJNQmz6TG0r6TqL5bOlAsY4mrqtq1/xQMMNlSZVeYV0=;
        b=CEt/ivzKign3KIh7tmiUC1dIeGlkL6zLJskvt1NH3tmSUV1FQ5H2MiaPd0CkE7bP6/TDWO
        dTQa53u8k8gmx2yD6O45duyEsJO7kRUnMr5QYkvPCYMn6EpiFywQmY+P+zbtXPPxQdC15o
        BI1LdVjD4Zal/fc2WDD4+UojrKHsLIQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-XU4G6uxsNsC5hgIhcwY_KQ-1; Wed, 12 Apr 2023 07:10:51 -0400
X-MC-Unique: XU4G6uxsNsC5hgIhcwY_KQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B786800B23;
        Wed, 12 Apr 2023 11:10:50 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14A8CC15BB8;
        Wed, 12 Apr 2023 11:10:46 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v18 13/71] ceph: ensure that we accept a new context from MDS for new inodes
Date:   Wed, 12 Apr 2023 19:08:32 +0800
Message-Id: <20230412110930.176835-14-xiubli@redhat.com>
In-Reply-To: <20230412110930.176835-1-xiubli@redhat.com>
References: <20230412110930.176835-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 5884e20ec4f0..36ab0bb56a07 100644
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
2.39.2


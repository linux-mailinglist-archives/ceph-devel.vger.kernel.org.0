Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 606D76A3989
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 04:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjB0DaG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 22:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjB0DaC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 22:30:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C77913DDF
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 19:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677468551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6TO8I592qYuYSzoKGI8ikPIqIBz47GHob7F+85XQvTA=;
        b=axo0MWAMaJ0f/jlqjVESdAzm3xN3b2tO8zf+m/fzOky2JPQlHFvKGHhSoEHmE+u/bB0Wf1
        9Ldc2HRyjiANLCLVPEAcBsR6MqnYfyKJTZk8echuY3sgKF3Ans1sirP1U8n8ryivdl9sFW
        eOF9acW/QcnNPrR+D5nN1Whlsf/RaY4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-84-0mXHjlwZMTK7Fh83Am9zsg-1; Sun, 26 Feb 2023 22:29:08 -0500
X-MC-Unique: 0mXHjlwZMTK7Fh83Am9zsg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD87285CBE0;
        Mon, 27 Feb 2023 03:29:07 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EEDDA35454;
        Mon, 27 Feb 2023 03:29:04 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v16 13/68] ceph: ensure that we accept a new context from MDS for new inodes
Date:   Mon, 27 Feb 2023 11:27:18 +0800
Message-Id: <20230227032813.337906-14-xiubli@redhat.com>
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

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index cbdb65c530f0..0991647ba6c2 100644
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
2.31.1


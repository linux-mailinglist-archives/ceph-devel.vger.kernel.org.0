Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62934DD3F3
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Mar 2022 05:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbiCREbN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 18 Mar 2022 00:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbiCREbK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 18 Mar 2022 00:31:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9C0E818D291
        for <ceph-devel@vger.kernel.org>; Thu, 17 Mar 2022 21:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647577791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QFrN9f1K2OCZCr09pp+JW2/LnMyGpWACrFRKyEyvvfE=;
        b=ItQ/0YhJAhJNWMZh0h2++aAGPkzGRExApU+QLiLOBxMBZ9rCduhzzKtCRhNvDtxmWO48w6
        45eBTpNqQOg3zK7OfB7pCGcqTOJNVLYzYg3seX8CsG01CBYShCJznXENAqGA0UA9H8/boW
        DxIqr+lofc6dzUZNoIvxALxc7R5uHJw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-0bGgiPEQNS20zjh6WmMUng-1; Fri, 18 Mar 2022 00:29:47 -0400
X-MC-Unique: 0bGgiPEQNS20zjh6WmMUng-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A668101A54C;
        Fri, 18 Mar 2022 04:29:47 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0296112C08E;
        Fri, 18 Mar 2022 04:29:44 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: inherit exactly the encryption info from parent for subdirs
Date:   Fri, 18 Mar 2022 12:29:41 +0800
Message-Id: <20220318042941.329752-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

There is no need to create new nonce for the subdirs, since the
encyrption will be used to encrypt/dencrypt the dentry name only.
And later in the request reply it will fill the encryption info
which is exactly inherit from the parent.

This could help us simplify the snapshot supporting. And no need
to parse the inode from a long snap name and search it from the
cache, which may not exist.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

This depends on the ceph PR:
https://github.com/ceph/ceph/pull/45516

And mds will always send the parent's encryption info back when
creating directories.


 fs/ceph/inode.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 7b670e2405c1..f005213fe48b 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -91,9 +91,15 @@ struct inode *ceph_new_inode(struct inode *dir, struct dentry *dentry,
 	if (err < 0)
 		goto out_err;
 
-	err = ceph_fscrypt_prepare_context(dir, inode, as_ctx);
-	if (err)
-		goto out_err;
+	/*
+	 * For subdirs they will inherit the whole encrytion info
+	 * from their parent.
+	 */
+	if (!S_ISDIR(*mode)) {
+		err = ceph_fscrypt_prepare_context(dir, inode, as_ctx);
+		if (err)
+			goto out_err;
+	}
 
 	return inode;
 out_err:
-- 
2.27.0


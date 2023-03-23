Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8826C604D
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Mar 2023 08:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjCWHBk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Mar 2023 03:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjCWHBX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Mar 2023 03:01:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2818C22A24
        for <ceph-devel@vger.kernel.org>; Thu, 23 Mar 2023 00:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679554755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nJd/OjcX9iZm+pjIbQdpIb47K0X6jqpH/2O5LNWDrMc=;
        b=bEx1XLJTKzuH9m/j0Kd8p95giln8y4N7yz3QKbTlhGqv1odDphxCzca6Sir9LtOhEnEyXo
        3+HrTsD+HH4LxzemREl+M6N36iYgOsUvx0/2cwjBzp0MIutnRWd9WYyR9hrkEEwtlFpgcE
        CxM6HPeJOI029i3BINEApPCICKDlcJM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-ZoomD7DKM6ewUdUmegfbag-1; Thu, 23 Mar 2023 02:59:14 -0400
X-MC-Unique: ZoomD7DKM6ewUdUmegfbag-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D41652823804;
        Thu, 23 Mar 2023 06:59:13 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13C38492B01;
        Thu, 23 Mar 2023 06:59:10 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v17 62/71] ceph: add support for encrypted snapshot names
Date:   Thu, 23 Mar 2023 14:55:16 +0800
Message-Id: <20230323065525.201322-63-xiubli@redhat.com>
In-Reply-To: <20230323065525.201322-1-xiubli@redhat.com>
References: <20230323065525.201322-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Luís Henriques <lhenriques@suse.de>

Since filenames in encrypted directories are already encrypted and shown
as a base64-encoded string when the directory is locked, snapshot names
should show a similar behaviour.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index bf05110f8532..be3936b28f57 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -91,9 +91,15 @@ struct inode *ceph_new_inode(struct inode *dir, struct dentry *dentry,
 	if (err < 0)
 		goto out_err;
 
-	err = ceph_fscrypt_prepare_context(dir, inode, as_ctx);
-	if (err)
-		goto out_err;
+	/*
+	 * We'll skip setting fscrypt context for snapshots, leaving that for
+	 * the handle_reply().
+	 */
+	if (ceph_snap(dir) != CEPH_SNAPDIR) {
+		err = ceph_fscrypt_prepare_context(dir, inode, as_ctx);
+		if (err)
+			goto out_err;
+	}
 
 	return inode;
 out_err:
@@ -157,6 +163,7 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 	};
 	struct inode *inode = ceph_get_inode(parent->i_sb, vino, NULL);
 	struct ceph_inode_info *ci = ceph_inode(inode);
+	int ret = -ENOTDIR;
 
 	if (IS_ERR(inode))
 		return inode;
@@ -182,6 +189,24 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 	ci->i_rbytes = 0;
 	ci->i_btime = ceph_inode(parent)->i_btime;
 
+#ifdef CONFIG_FS_ENCRYPTION
+	/* if encrypted, just borrow fscrypt_auth from parent */
+	if (IS_ENCRYPTED(parent)) {
+		struct ceph_inode_info *pci = ceph_inode(parent);
+
+		ci->fscrypt_auth = kmemdup(pci->fscrypt_auth,
+					   pci->fscrypt_auth_len,
+					   GFP_KERNEL);
+		if (ci->fscrypt_auth) {
+			inode->i_flags |= S_ENCRYPTED;
+			ci->fscrypt_auth_len = pci->fscrypt_auth_len;
+		} else {
+			dout("Failed to alloc snapdir fscrypt_auth\n");
+			ret = -ENOMEM;
+			goto err;
+		}
+	}
+#endif
 	if (inode->i_state & I_NEW) {
 		inode->i_op = &ceph_snapdir_iops;
 		inode->i_fop = &ceph_snapdir_fops;
@@ -195,7 +220,7 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 		discard_new_inode(inode);
 	else
 		iput(inode);
-	return ERR_PTR(-ENOTDIR);
+	return ERR_PTR(ret);
 }
 
 const struct inode_operations ceph_file_iops = {
-- 
2.31.1


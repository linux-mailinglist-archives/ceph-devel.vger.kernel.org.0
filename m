Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019174C8ACC
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Mar 2022 12:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234575AbiCALcN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Mar 2022 06:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbiCALcN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Mar 2022 06:32:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A03C4756D
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 03:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646134291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ygLpJpFvbsvZc/yCqCvDynfqe5ZVGFqHKCCR9n+1pwY=;
        b=YO+f/k3gvzf63bX5MJ/nKjbKgiQ2FJzDrvDuW0M5qUuIaVJ0ZnugSJHEuccOsR3HlxboxX
        wJhH+dA2d9LvsfVrF9FPdfQhOLJs8+btuBibfgNaFK2uUhBfayoExEIrgezhdpUDxzMv7F
        8v/yr0WlL2I3To96RnRim+EclZ3fvmw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-VgqCIChiNQ2vnkuEwMQUeQ-1; Tue, 01 Mar 2022 06:31:28 -0500
X-MC-Unique: VgqCIChiNQ2vnkuEwMQUeQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0538D1854E26;
        Tue,  1 Mar 2022 11:31:27 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 499CB842CB;
        Tue,  1 Mar 2022 11:31:22 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 6/7] ceph: use the parent inode of '.snap' to encrypt name to build path
Date:   Tue,  1 Mar 2022 19:30:14 +0800
Message-Id: <20220301113015.498041-7-xiubli@redhat.com>
In-Reply-To: <20220301113015.498041-1-xiubli@redhat.com>
References: <20220301113015.498041-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The inode for '.snap' directory will always with no key setup, so
we can use the parent inode to do this.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 3dea96df4769..5433e6050563 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2465,8 +2465,8 @@ static u8 *get_fscrypt_altname(const struct ceph_mds_request *req, u32 *plen)
  */
 char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase, int for_wire)
 {
-	struct dentry *cur;
-	struct inode *inode;
+	struct dentry *cur, *parent;
+	struct inode *inode, *pinode;
 	char *path;
 	int pos;
 	unsigned seq;
@@ -2479,13 +2479,16 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase, int for
 	if (!path)
 		return ERR_PTR(-ENOMEM);
 retry:
+	pinode = NULL;
+	parent = NULL;
 	pos = PATH_MAX - 1;
 	path[pos] = '\0';
 
 	seq = read_seqbegin(&rename_lock);
 	cur = dget(dentry);
 	for (;;) {
-		struct dentry *parent;
+		parent = dget_parent(cur);
+		pinode = ceph_get_snap_parent_inode(d_inode(parent));
 
 		spin_lock(&cur->d_lock);
 		inode = d_inode(cur);
@@ -2493,12 +2496,11 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase, int for
 			dout("build_path path+%d: %p SNAPDIR\n",
 			     pos, cur);
 			spin_unlock(&cur->d_lock);
-			parent = dget_parent(cur);
 		} else if (for_wire && inode && dentry != cur && ceph_snap(inode) == CEPH_NOSNAP) {
 			spin_unlock(&cur->d_lock);
 			pos++; /* get rid of any prepended '/' */
 			break;
-		} else if (!for_wire || !IS_ENCRYPTED(d_inode(cur->d_parent))) {
+		} else if (!for_wire || !IS_ENCRYPTED(pinode)) {
 			pos -= cur->d_name.len;
 			if (pos < 0) {
 				spin_unlock(&cur->d_lock);
@@ -2506,7 +2508,6 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase, int for
 			}
 			memcpy(path + pos, cur->d_name.name, cur->d_name.len);
 			spin_unlock(&cur->d_lock);
-			parent = dget_parent(cur);
 		} else {
 			int len, ret;
 			char buf[FSCRYPT_BASE64URL_CHARS(NAME_MAX)];
@@ -2518,32 +2519,32 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase, int for
 			memcpy(buf, cur->d_name.name, cur->d_name.len);
 			len = cur->d_name.len;
 			spin_unlock(&cur->d_lock);
-			parent = dget_parent(cur);
 
-			ret = __fscrypt_prepare_readdir(d_inode(parent));
+			ret = __fscrypt_prepare_readdir(pinode);
 			if (ret < 0) {
 				dput(parent);
 				dput(cur);
+				iput(pinode);
 				return ERR_PTR(ret);
 			}
 
-			if (fscrypt_has_encryption_key(d_inode(parent))) {
-				len = ceph_encode_encrypted_fname(d_inode(parent), cur, buf);
+			if (fscrypt_has_encryption_key(pinode)) {
+				len = ceph_encode_encrypted_fname(pinode, cur, buf);
 				if (len < 0) {
 					dput(parent);
 					dput(cur);
+					iput(pinode);
 					return ERR_PTR(len);
 				}
 			}
 			pos -= len;
-			if (pos < 0) {
-				dput(parent);
+			if (pos < 0)
 				break;
-			}
 			memcpy(path + pos, buf, len);
 		}
 		dput(cur);
 		cur = parent;
+		parent = NULL;
 
 		/* Are we at the root? */
 		if (IS_ROOT(cur))
@@ -2554,7 +2555,13 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase, int for
 			break;
 
 		path[pos] = '/';
+		iput(pinode);
+		pinode = NULL;
 	}
+	if (pinode)
+		iput(pinode);
+	if (parent)
+		dput(parent);
 	inode = d_inode(cur);
 	base = inode ? ceph_ino(inode) : 0;
 	dput(cur);
-- 
2.27.0


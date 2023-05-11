Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD176FE9FE
	for <lists+ceph-devel@lfdr.de>; Thu, 11 May 2023 05:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236303AbjEKDFD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 May 2023 23:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbjEKDEt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 10 May 2023 23:04:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853C81FD4
        for <ceph-devel@vger.kernel.org>; Wed, 10 May 2023 20:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683774241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ktUbjEDf5Wn1PbdBVjPbkgnDNXsBVDrb3DarTTCVHY4=;
        b=JDkXI2hu+Fru6NhILpxDC8fS9PNLMDebUwZaEC2N07uFHPGytUz6I3i7bOdz+E+6Qozp0Y
        BsMhKURDEaq43YAtke3DExySCJg4zbCzrOaLMXZjhax78seD3dvBrnWfl3TOHjKxXqXbPn
        Z31V1uMpMqcPjp+s6mdtziMGWUGJJh8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-_wWyVcUSMhmhT-VoBjRO9A-1; Wed, 10 May 2023 23:03:58 -0400
X-MC-Unique: _wWyVcUSMhmhT-VoBjRO9A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB125870820;
        Thu, 11 May 2023 03:03:57 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-156.pek2.redhat.com [10.72.12.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 521AD492C13;
        Thu, 11 May 2023 03:03:53 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, sehuww@mail.scut.edu.cn,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v5 1/2] ceph: add a dedicated private data for netfs rreq
Date:   Thu, 11 May 2023 11:03:34 +0800
Message-Id: <20230511030335.337094-2-xiubli@redhat.com>
In-Reply-To: <20230511030335.337094-1-xiubli@redhat.com>
References: <20230511030335.337094-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

We need to save the 'f_ra.ra_pages' to expand the readahead window
later.

Cc: stable@vger.kernel.org
Fixes: 49870056005c ("ceph: convert ceph_readpages to ceph_readahead")
URL: https://lore.kernel.org/ceph-devel/20230504082510.247-1-sehuww@mail.scut.edu.cn
URL: https://www.spinics.net/lists/ceph-users/msg76183.html
Cc: Hu Weiwen <sehuww@mail.scut.edu.cn>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c  | 43 ++++++++++++++++++++++++++++++++-----------
 fs/ceph/super.h | 13 +++++++++++++
 2 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 3b20873733af..db55fce13324 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -404,18 +404,27 @@ static int ceph_init_request(struct netfs_io_request *rreq, struct file *file)
 {
 	struct inode *inode = rreq->inode;
 	int got = 0, want = CEPH_CAP_FILE_CACHE;
+	struct ceph_netfs_request_data *priv;
 	int ret = 0;
 
 	if (rreq->origin != NETFS_READAHEAD)
 		return 0;
 
+	priv = kzalloc(sizeof(*priv), GFP_NOFS);
+	if (!priv)
+		return -ENOMEM;
+
 	if (file) {
 		struct ceph_rw_context *rw_ctx;
 		struct ceph_file_info *fi = file->private_data;
 
 		rw_ctx = ceph_find_rw_context(fi);
-		if (rw_ctx)
+		if (rw_ctx) {
+			kfree(priv);
 			return 0;
+		}
+		priv->file_ra_pages = file->f_ra.ra_pages;
+		priv->file_ra_disabled = !!(file->f_mode & FMODE_RANDOM);
 	}
 
 	/*
@@ -425,27 +434,39 @@ static int ceph_init_request(struct netfs_io_request *rreq, struct file *file)
 	ret = ceph_try_get_caps(inode, CEPH_CAP_FILE_RD, want, true, &got);
 	if (ret < 0) {
 		dout("start_read %p, error getting cap\n", inode);
-		return ret;
+		goto out;
 	}
 
 	if (!(got & want)) {
 		dout("start_read %p, no cache cap\n", inode);
-		return -EACCES;
+		ret = -EACCES;
+		goto out;
+	}
+	if (ret == 0) {
+		ret = -EACCES;
+		goto out;
 	}
-	if (ret == 0)
-		return -EACCES;
 
-	rreq->netfs_priv = (void *)(uintptr_t)got;
-	return 0;
+	priv->caps = got;
+	rreq->netfs_priv = priv;
+
+out:
+	if (ret)
+		kfree(priv);
+
+	return ret;
 }
 
 static void ceph_netfs_free_request(struct netfs_io_request *rreq)
 {
-	struct ceph_inode_info *ci = ceph_inode(rreq->inode);
-	int got = (uintptr_t)rreq->netfs_priv;
+	struct ceph_netfs_request_data *priv = rreq->netfs_priv;
+
+	if (!priv)
+		return;
 
-	if (got)
-		ceph_put_cap_refs(ci, got);
+	ceph_put_cap_refs(ceph_inode(rreq->inode), priv->caps);
+	kfree(priv);
+	rreq->netfs_priv = NULL;
 }
 
 const struct netfs_request_ops ceph_netfs_ops = {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index a226d36b3ecb..1233f53f6e0b 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -470,6 +470,19 @@ struct ceph_inode_info {
 #endif
 };
 
+struct ceph_netfs_request_data {
+	int caps;
+
+	/*
+	 * Maximum size of a file readahead request.
+	 * The posix_fadvise could update the bdi's default ra_pages.
+	 */
+	unsigned int file_ra_pages;
+
+	/* Set it if posix_fadvise disables file readahead entirely */
+	bool file_ra_disabled;
+};
+
 static inline struct ceph_inode_info *
 ceph_inode(const struct inode *inode)
 {
-- 
2.40.0


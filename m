Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A92702116
	for <lists+ceph-devel@lfdr.de>; Mon, 15 May 2023 03:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238069AbjEOBWI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 14 May 2023 21:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237940AbjEOBWG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 14 May 2023 21:22:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F6A10F4
        for <ceph-devel@vger.kernel.org>; Sun, 14 May 2023 18:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684113685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q2vil5fNHPh3ahW/PrS375FoKsDzccFBDF2qhT3I+4M=;
        b=EYLOh2jrQNQZ+0cZqwyTEgDIS+9M479yQ34hYBFg5/9qLhsETY/WXn9mXibpNwKEFNxwR9
        VmBUL7gPY8PXn1htxbUeJv/3PtWrB8FbwdwfZ/zJecWcoeWROItAXi0eodzMlInyOaBj5l
        atC51lEJvuJXqNp7uvq/6pDDiwy23oY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-258-Rq6qWJZSO1qqML0XoYcgNg-1; Sun, 14 May 2023 21:21:22 -0400
X-MC-Unique: Rq6qWJZSO1qqML0XoYcgNg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FF973813F23;
        Mon, 15 May 2023 01:21:22 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-56.pek2.redhat.com [10.72.12.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E754D63F8B;
        Mon, 15 May 2023 01:21:17 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, sehuww@mail.scut.edu.cn,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v6 1/2] ceph: add a dedicated private data for netfs rreq
Date:   Mon, 15 May 2023 09:20:43 +0800
Message-Id: <20230515012044.98096-2-xiubli@redhat.com>
In-Reply-To: <20230515012044.98096-1-xiubli@redhat.com>
References: <20230515012044.98096-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 fs/ceph/addr.c  | 45 ++++++++++++++++++++++++++++++++++-----------
 fs/ceph/super.h | 13 +++++++++++++
 2 files changed, 47 insertions(+), 11 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 3b20873733af..93fff1a7373f 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -404,18 +404,28 @@ static int ceph_init_request(struct netfs_io_request *rreq, struct file *file)
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
 
+		priv->file_ra_pages = file->f_ra.ra_pages;
+		priv->file_ra_disabled = file->f_mode & FMODE_RANDOM;
+
 		rw_ctx = ceph_find_rw_context(fi);
-		if (rw_ctx)
+		if (rw_ctx) {
+			rreq->netfs_priv = priv;
 			return 0;
+		}
 	}
 
 	/*
@@ -425,27 +435,40 @@ static int ceph_init_request(struct netfs_io_request *rreq, struct file *file)
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
+	if (ret < 0)
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
+	if (priv->caps)
+		ceph_put_cap_refs(ceph_inode(rreq->inode), priv->caps);
+	kfree(priv);
+	rreq->netfs_priv = NULL;
 }
 
 const struct netfs_request_ops ceph_netfs_ops = {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index a226d36b3ecb..3a24b7974d46 100644
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
+	 * The fadvise could update the bdi's default ra_pages.
+	 */
+	unsigned int file_ra_pages;
+
+	/* Set it if fadvise disables file readahead entirely */
+	bool file_ra_disabled;
+};
+
 static inline struct ceph_inode_info *
 ceph_inode(const struct inode *inode)
 {
-- 
2.40.1


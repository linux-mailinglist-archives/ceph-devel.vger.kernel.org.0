Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4C472D91B
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 07:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240099AbjFMF2g (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 01:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240037AbjFMF2Y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 01:28:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B5D10EA
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 22:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686634049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=axmGMMfk5GQjzHYnABZJfgYNxZowEvmmFc+u0yl5oCY=;
        b=WXuSLvUxgY76+L+3ApuL6IhIo9laiw6TeYVGab78qPaKeZ28zMb3psu65dGllHyQEioF9q
        QSWr0J9CgtQezOFMSeQJlcOPYNbND4KgpMc3PUN1vWumqrck5ONuP7BfNTuqhndpvgcD3N
        4kYrs5S5SMQBPYCTmRPVscmGSKVgxkk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-2RmGMYlQMAmpctCAvcPi-w-1; Tue, 13 Jun 2023 01:27:28 -0400
X-MC-Unique: 2RmGMYlQMAmpctCAvcPi-w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1BFD28EC10E;
        Tue, 13 Jun 2023 05:27:27 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CA141121314;
        Tue, 13 Jun 2023 05:27:23 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v20 11/71] ceph: use osd_req_op_extent_osd_iter for netfs reads
Date:   Tue, 13 Jun 2023 13:23:24 +0800
Message-Id: <20230613052424.254540-12-xiubli@redhat.com>
In-Reply-To: <20230613052424.254540-1-xiubli@redhat.com>
References: <20230613052424.254540-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

The netfs layer has already pinned the pages involved before calling
issue_op, so we can just pass down the iter directly instead of calling
iov_iter_get_pages_alloc.

Instead of having to allocate a page array, use CEPH_MSG_DATA_ITER and
pass it the iov_iter directly to clone.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index d686d56c6b96..3c80afa9d0e8 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -220,7 +220,6 @@ static void finish_netfs_read(struct ceph_osd_request *req)
 	struct ceph_osd_data *osd_data = osd_req_op_extent_osd_data(req, 0);
 	struct netfs_io_subrequest *subreq = req->r_priv;
 	struct ceph_osd_req_op *op = &req->r_ops[0];
-	int num_pages;
 	int err = req->r_result;
 	bool sparse = (op->op == CEPH_OSD_OP_SPARSE_READ);
 
@@ -242,9 +241,6 @@ static void finish_netfs_read(struct ceph_osd_request *req)
 		__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
 
 	netfs_subreq_terminated(subreq, err, false);
-
-	num_pages = calc_pages_for(osd_data->alignment, osd_data->length);
-	ceph_put_page_vector(osd_data->pages, num_pages, false);
 	iput(req->r_inode);
 }
 
@@ -312,8 +308,6 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	struct ceph_osd_request *req = NULL;
 	struct ceph_vino vino = ceph_vino(inode);
 	struct iov_iter iter;
-	struct page **pages;
-	size_t page_off;
 	int err = 0;
 	u64 len = subreq->len;
 	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
@@ -344,18 +338,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 
 	dout("%s: pos=%llu orig_len=%zu len=%llu\n", __func__, subreq->start, subreq->len, len);
 	iov_iter_xarray(&iter, ITER_DEST, &rreq->mapping->i_pages, subreq->start, len);
-	err = iov_iter_get_pages_alloc2(&iter, &pages, len, &page_off);
-	if (err < 0) {
-		dout("%s: iov_ter_get_pages_alloc returned %d\n", __func__, err);
-		goto out;
-	}
-
-	/* should always give us a page-aligned read */
-	WARN_ON_ONCE(page_off);
-	len = err;
-	err = 0;
-
-	osd_req_op_extent_osd_data_pages(req, 0, pages, len, 0, false, false);
+	osd_req_op_extent_osd_iter(req, 0, &iter);
 	req->r_callback = finish_netfs_read;
 	req->r_priv = subreq;
 	req->r_inode = inode;
-- 
2.40.1


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2D86C6018
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Mar 2023 07:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjCWG5I (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Mar 2023 02:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjCWG5G (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Mar 2023 02:57:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFEF2D178
        for <ceph-devel@vger.kernel.org>; Wed, 22 Mar 2023 23:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679554581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GXpwHE/O/oeBROV4vxeHPIrplu+sheoiYVZFXE+vGmw=;
        b=P+BTCbElMvb0N+mJDAc89g1f8pkbeKnbJ7CixYfsAWG5OHHK4T+SgNnlW5Z4CqXp8Rqp0t
        OdJUv+WJpfTvIpgcEeCRECl+HXFT6Z7T3YcsI9vXWqZLIi8VZjVrtEQ2n5uWRmIcoIhUsj
        83fjovAXpZ1eU10afsorOzVSMq7nBYA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-5nTETdbZNI6X8f5kcCMpRQ-1; Thu, 23 Mar 2023 02:56:18 -0400
X-MC-Unique: 5nTETdbZNI6X8f5kcCMpRQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE7BD185A78F;
        Thu, 23 Mar 2023 06:56:17 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F284C492B01;
        Thu, 23 Mar 2023 06:56:14 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v17 11/71] ceph: use osd_req_op_extent_osd_iter for netfs reads
Date:   Thu, 23 Mar 2023 14:54:25 +0800
Message-Id: <20230323065525.201322-12-xiubli@redhat.com>
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

The netfs layer has already pinned the pages involved before calling
issue_op, so we can just pass down the iter directly instead of calling
iov_iter_get_pages_alloc.

Instead of having to allocate a page array, use CEPH_MSG_DATA_ITER and
pass it the iov_iter directly to clone.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 7e6abec82be8..5dca574e7f05 100644
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
2.31.1


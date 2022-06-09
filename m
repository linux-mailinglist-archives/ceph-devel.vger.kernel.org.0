Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8403F545507
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 21:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbiFITeb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jun 2022 15:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbiFITe2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jun 2022 15:34:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7675A208B0B
        for <ceph-devel@vger.kernel.org>; Thu,  9 Jun 2022 12:34:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 135F361E54
        for <ceph-devel@vger.kernel.org>; Thu,  9 Jun 2022 19:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042E3C341C0;
        Thu,  9 Jun 2022 19:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654803266;
        bh=g3pVqOmvJ+ZQkqHBu4jtgHEcFjYNnUWgklNmhzmO2RE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENFkEx0IrqBROyFO8PuOle13Zde5jDbKUApOpI+tMD5Bc5enQ1JZ69sBwvT5UPfCN
         vFm9CxsY91fuo8X1J1VwWsFwgKWl2apQETBmnSYG0ST75O7D40G90aMyaNSyYB9xQn
         Wmv275E3mZ4jtPIlNPYWfT0yxpo2N+dWN9CjnvcKg3ICB1Q3ZPFU4ezGiNbN1SAJHk
         xE93dgWv5axYH+woSMbvV9i/B/kWrnAsGhdAYjZHhHoj4p+fn5iuWgPw2XE8uoyLxV
         DjWHm0tdj/cQzhZfsqfixO146kQSytGxmwgzNxP0LFw8LnUskDDevoN94rSdJ/xIBB
         skY5sKArb+clw==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, dhowells@redhat.com, ceph-devel@vger.kernel.org
Subject: [PATCH 2/2] ceph: use osd_req_op_extent_osd_iter for netfs reads
Date:   Thu,  9 Jun 2022 15:34:23 -0400
Message-Id: <20220609193423.167942-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220609193423.167942-1-jlayton@kernel.org>
References: <20220609193423.167942-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The netfs layer has already pinned the pages involved before calling
issue_op, so we can just pass down the iter directly instead of calling
iov_iter_get_pages_alloc.

Instead of having to allocate a page array, use CEPH_MSG_DATA_ITER and
pass it the iov_iter directly to clone.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 988d6115cbc1..b43cc01a61db 100644
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
 	struct ceph_osd_request *req;
 	struct ceph_vino vino = ceph_vino(inode);
 	struct iov_iter iter;
-	struct page **pages;
-	size_t page_off;
 	int err = 0;
 	u64 len = subreq->len;
 	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
@@ -342,17 +336,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 
 	dout("%s: pos=%llu orig_len=%zu len=%llu\n", __func__, subreq->start, subreq->len, len);
 	iov_iter_xarray(&iter, READ, &rreq->mapping->i_pages, subreq->start, len);
-	err = iov_iter_get_pages_alloc(&iter, &pages, len, &page_off);
-	if (err < 0) {
-		dout("%s: iov_ter_get_pages_alloc returned %d\n", __func__, err);
-		goto out;
-	}
-
-	/* should always give us a page-aligned read */
-	WARN_ON_ONCE(page_off);
-	len = err;
-
-	osd_req_op_extent_osd_data_pages(req, 0, pages, len, 0, false, false);
+	osd_req_op_extent_osd_iter(req, 0, &iter);
 	req->r_callback = finish_netfs_read;
 	req->r_priv = subreq;
 	req->r_inode = inode;
-- 
2.36.1


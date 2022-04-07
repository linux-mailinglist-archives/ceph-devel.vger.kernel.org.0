Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600054F7E8C
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Apr 2022 14:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239477AbiDGMEf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 08:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238937AbiDGMEd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 08:04:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C224D7DE10
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 05:02:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 31A5CCE2763
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 12:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2115CC385A8;
        Thu,  7 Apr 2022 12:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649332950;
        bh=fQoER+BnVliRbv0vPbyAzdmog57KftKQyE6WVVuuulY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKbwtugKGOPf54xEjtBQkOHsEi1inRAJdiMFLT2GQwV9NWm+qzmKWzYWbMitoOYu/
         U4GXNmhNJu4fvkbLN0AZZPgDg0xMY/MCdqIDOCGfrnlDhb/wHUqiboT3AZjqzes1r8
         2Igqchp7oFxFPXC1gwD9kezJ+vHGikQ0fN0luhCoKPtBTlb6elSWGenevNdJuILvtt
         NdRufst+z9WcNZihA5o4sIZ6IdQYtgiFR0PL3N6kmTq7S3ZGQbMrj3mI6UTx1nVBFz
         h0rcKXljyZKCq9YrPYxapl1OrroM9xC2CqhpnYBgq9zTqC6eUCs+iqioMJrXTfc7gB
         1b6UCJ8i5PbOA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, dhowells@redhat.com
Cc:     idryomov@gmail.com, xiubli@redhat.com, linux-cachefs@redhat.com
Subject: [RFC PATCH 5/5] ceph: switch to netfs_direct_read_iter
Date:   Thu,  7 Apr 2022 08:02:24 -0400
Message-Id: <20220407120224.76156-6-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407120224.76156-1-jlayton@kernel.org>
References: <20220407120224.76156-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 41 +++++++++++++++++++++++++++++------------
 fs/ceph/file.c |  3 +--
 2 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 0726494a0981..bc575bbbf8b7 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -201,7 +201,6 @@ static void finish_netfs_read(struct ceph_osd_request *req)
 	struct ceph_fs_client *fsc = ceph_inode_to_client(req->r_inode);
 	struct ceph_osd_data *osd_data = osd_req_op_extent_osd_data(req, 0);
 	struct netfs_io_subrequest *subreq = req->r_priv;
-	int num_pages;
 	int err = req->r_result;
 
 	ceph_update_read_metrics(&fsc->mdsc->metric, req->r_start_latency,
@@ -216,13 +215,18 @@ static void finish_netfs_read(struct ceph_osd_request *req)
 	else if (err == -EBLOCKLISTED)
 		fsc->blocklisted = true;
 
-	if (err >= 0 && err < subreq->len)
-		__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
+	if (err >= 0) {
+		if (err < subreq->len)
+			__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
+		iov_iter_advance(&subreq->iter, err);
+	}
+	if (!iov_iter_is_bvec(&subreq->iter))
+		ceph_put_page_vector(osd_data->pages,
+				     calc_pages_for(osd_data->alignment,
+				     osd_data->length),
+				     false);
 
 	netfs_subreq_terminated(subreq, err, true);
-
-	num_pages = calc_pages_for(osd_data->alignment, osd_data->length);
-	ceph_put_page_vector(osd_data->pages, num_pages, false);
 	iput(req->r_inode);
 }
 
@@ -285,6 +289,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_osd_request *req;
 	struct ceph_vino vino = ceph_vino(inode);
+	struct iov_iter *iter = &subreq->iter;
 	struct page **pages;
 	size_t page_off;
 	int err = 0;
@@ -308,16 +313,28 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 		__func__, subreq->start, subreq->len, len, rreq->debug_id,
 		subreq->debug_index, iov_iter_count(&subreq->iter));
 
-	err = iov_iter_get_pages_alloc(&subreq->iter, &pages, len, &page_off);
-	if (err < 0) {
-		dout("%s: iov_ter_get_pages_alloc returned %d\n", __func__, err);
-		goto out;
+	if (iov_iter_is_bvec(iter)) {
+		/*
+		 * FIXME: remove force cast, ideally by plumbing an IOV_ITER osd_data
+		 * 	  variant.
+		 */
+		osd_req_op_extent_osd_data_bvecs(req, 0, (__force struct bio_vec *)iter->bvec,
+				iter->nr_segs, len);
+		goto submit;
 	}
 
-	/* FIXME: adjust the len in req downward if necessary */
-	len = err;
+	err = iov_iter_get_pages_alloc(&subreq->iter, &pages, len, &page_off);
+	if (err < len) {
+		if (err < 0) {
+			dout("%s: iov_ter_get_pages_alloc returned %d\n", __func__, err);
+			goto out;
+		}
+		len = err;
+		req->r_ops[0].extent.length = err;
+	}
 
 	osd_req_op_extent_osd_data_pages(req, 0, pages, len, 0, false, false);
+submit:
 	req->r_callback = finish_netfs_read;
 	req->r_priv = subreq;
 	req->r_inode = inode;
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 6c9e837aa1d3..8271459b36dc 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1624,8 +1624,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 		if (ci->i_inline_version == CEPH_INLINE_NONE) {
 			if (!retry_op && (iocb->ki_flags & IOCB_DIRECT)) {
-				ret = ceph_direct_read_write(iocb, to,
-							     NULL, NULL);
+				ret = netfs_direct_read_iter(iocb, to);
 				if (ret >= 0 && ret < len)
 					retry_op = CHECK_EOF;
 			} else {
-- 
2.35.1


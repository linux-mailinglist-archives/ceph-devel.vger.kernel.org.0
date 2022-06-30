Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9073562410
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Jun 2022 22:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbiF3UVz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Jun 2022 16:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiF3UVy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 Jun 2022 16:21:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFF022BEA
        for <ceph-devel@vger.kernel.org>; Thu, 30 Jun 2022 13:21:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0356F62304
        for <ceph-devel@vger.kernel.org>; Thu, 30 Jun 2022 20:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050D1C34115;
        Thu, 30 Jun 2022 20:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656620512;
        bh=r+lBxkeroRUmflgo60bM9+fjUoOgTjHwCj7hus5OVSQ=;
        h=From:To:Cc:Subject:Date:From;
        b=P+mRDWM/LiGy9w1cfN7tBF94pIHSLESzR7IMWVI0Rq6ZO1wyBtVAZdgNcE7iXrIBr
         cO74NbmgDY1WSRe24h/9M9JHSMuZ3LxYNcFBbp5/JzS9PEyyaFtS6bSxB1IAxBfTNc
         BMnsTr5WsgnQ9S1/fCKG/k1mi3ltrTFTYjUeaq9fIWi8keXMB2Lzd06OFeCdoCqva2
         qNHwnezdybj/a/l6NZnlcYMxQ0dpRVkRpAn4VRYoUVsiHu/GEgdKw9uIvpXyqEJvR+
         eNjbrspNDz1zmqxyPm/2fubBKp/o5FqG39us23QTvIn3srZjNnGA88q8dwiGCYsZUm
         iaXeM0Yh1WWKA==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
Subject: [PATCH] libceph: clean up ceph_osdc_start_request prototype
Date:   Thu, 30 Jun 2022 16:21:50 -0400
Message-Id: <20220630202150.653547-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This function always returns 0, and ignores the nofail boolean. Drop the
nofail argument, make the function void return and fix up the callers.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/block/rbd.c             |  6 +++---
 fs/ceph/addr.c                  | 32 ++++++++++++--------------------
 fs/ceph/file.c                  | 32 +++++++++++++-------------------
 include/linux/ceph/osd_client.h |  5 ++---
 net/ceph/osd_client.c           | 15 ++++++---------
 5 files changed, 36 insertions(+), 54 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 91e541aa1f64..a8af0329ab77 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1297,7 +1297,7 @@ static void rbd_osd_submit(struct ceph_osd_request *osd_req)
 	dout("%s osd_req %p for obj_req %p objno %llu %llu~%llu\n",
 	     __func__, osd_req, obj_req, obj_req->ex.oe_objno,
 	     obj_req->ex.oe_off, obj_req->ex.oe_len);
-	ceph_osdc_start_request(osd_req->r_osdc, osd_req, false);
+	ceph_osdc_start_request(osd_req->r_osdc, osd_req);
 }
 
 /*
@@ -2081,7 +2081,7 @@ static int rbd_object_map_update(struct rbd_obj_request *obj_req, u64 snap_id,
 	if (ret)
 		return ret;
 
-	ceph_osdc_start_request(osdc, req, false);
+	ceph_osdc_start_request(osdc, req);
 	return 0;
 }
 
@@ -4768,7 +4768,7 @@ static int rbd_obj_read_sync(struct rbd_device *rbd_dev,
 	if (ret)
 		goto out_req;
 
-	ceph_osdc_start_request(osdc, req, false);
+	ceph_osdc_start_request(osdc, req);
 	ret = ceph_osdc_wait_request(osdc, req);
 	if (ret >= 0)
 		ceph_copy_from_page_vector(pages, buf, 0, ret);
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index fe6147f20dee..66dc7844fcc6 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -357,9 +357,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	req->r_inode = inode;
 	ihold(inode);
 
-	err = ceph_osdc_start_request(req->r_osdc, req, false);
-	if (err)
-		iput(inode);
+	ceph_osdc_start_request(req->r_osdc, req);
 out:
 	ceph_osdc_put_request(req);
 	if (err)
@@ -633,9 +631,8 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 	dout("writepage %llu~%llu (%llu bytes)\n", page_off, len, len);
 
 	req->r_mtime = inode->i_mtime;
-	err = ceph_osdc_start_request(osdc, req, true);
-	if (!err)
-		err = ceph_osdc_wait_request(osdc, req);
+	ceph_osdc_start_request(osdc, req);
+	err = ceph_osdc_wait_request(osdc, req);
 
 	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
 				  req->r_end_latency, len, err);
@@ -1163,8 +1160,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 		}
 
 		req->r_mtime = inode->i_mtime;
-		rc = ceph_osdc_start_request(&fsc->client->osdc, req, true);
-		BUG_ON(rc);
+		ceph_osdc_start_request(&fsc->client->osdc, req);
 		req = NULL;
 
 		wbc->nr_to_write -= i;
@@ -1707,9 +1703,8 @@ int ceph_uninline_data(struct file *file)
 	}
 
 	req->r_mtime = inode->i_mtime;
-	err = ceph_osdc_start_request(&fsc->client->osdc, req, false);
-	if (!err)
-		err = ceph_osdc_wait_request(&fsc->client->osdc, req);
+	ceph_osdc_start_request(&fsc->client->osdc, req);
+	err = ceph_osdc_wait_request(&fsc->client->osdc, req);
 	ceph_osdc_put_request(req);
 	if (err < 0)
 		goto out_unlock;
@@ -1750,9 +1745,8 @@ int ceph_uninline_data(struct file *file)
 	}
 
 	req->r_mtime = inode->i_mtime;
-	err = ceph_osdc_start_request(&fsc->client->osdc, req, false);
-	if (!err)
-		err = ceph_osdc_wait_request(&fsc->client->osdc, req);
+	ceph_osdc_start_request(&fsc->client->osdc, req);
+	err = ceph_osdc_wait_request(&fsc->client->osdc, req);
 
 	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
 				  req->r_end_latency, len, err);
@@ -1923,15 +1917,13 @@ static int __ceph_pool_perm_get(struct ceph_inode_info *ci,
 
 	osd_req_op_raw_data_in_pages(rd_req, 0, pages, PAGE_SIZE,
 				     0, false, true);
-	err = ceph_osdc_start_request(&fsc->client->osdc, rd_req, false);
+	ceph_osdc_start_request(&fsc->client->osdc, rd_req);
 
 	wr_req->r_mtime = ci->netfs.inode.i_mtime;
-	err2 = ceph_osdc_start_request(&fsc->client->osdc, wr_req, false);
+	ceph_osdc_start_request(&fsc->client->osdc, wr_req);
 
-	if (!err)
-		err = ceph_osdc_wait_request(&fsc->client->osdc, rd_req);
-	if (!err2)
-		err2 = ceph_osdc_wait_request(&fsc->client->osdc, wr_req);
+	err = ceph_osdc_wait_request(&fsc->client->osdc, rd_req);
+	err2 = ceph_osdc_wait_request(&fsc->client->osdc, wr_req);
 
 	if (err >= 0 || err == -ENOENT)
 		have |= POOL_READ;
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 0eb4a02175ad..296fd1c7ece8 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1008,9 +1008,8 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 			}
 		}
 
-		ret = ceph_osdc_start_request(osdc, req, false);
-		if (!ret)
-			ret = ceph_osdc_wait_request(osdc, req);
+		ceph_osdc_start_request(osdc, req);
+		ret = ceph_osdc_wait_request(osdc, req);
 
 		ceph_update_read_metrics(&fsc->mdsc->metric,
 					 req->r_start_latency,
@@ -1282,7 +1281,7 @@ static void ceph_aio_retry_work(struct work_struct *work)
 	req->r_inode = inode;
 	req->r_priv = aio_req;
 
-	ret = ceph_osdc_start_request(req->r_osdc, req, false);
+	ceph_osdc_start_request(req->r_osdc, req);
 out:
 	if (ret < 0) {
 		req->r_result = ret;
@@ -1429,9 +1428,8 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 			continue;
 		}
 
-		ret = ceph_osdc_start_request(req->r_osdc, req, false);
-		if (!ret)
-			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
+		ceph_osdc_start_request(req->r_osdc, req);
+		ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
 
 		if (write)
 			ceph_update_write_metrics(metric, req->r_start_latency,
@@ -1497,8 +1495,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 					       r_private_item);
 			list_del_init(&req->r_private_item);
 			if (ret >= 0)
-				ret = ceph_osdc_start_request(req->r_osdc,
-							      req, false);
+				ceph_osdc_start_request(req->r_osdc, req);
 			if (ret < 0) {
 				req->r_result = ret;
 				ceph_aio_complete_req(req);
@@ -1611,9 +1608,8 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 						false, true);
 
 		req->r_mtime = mtime;
-		ret = ceph_osdc_start_request(&fsc->client->osdc, req, false);
-		if (!ret)
-			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
+		ceph_osdc_start_request(&fsc->client->osdc, req);
+		ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
 
 		ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
 					  req->r_end_latency, len, ret);
@@ -2077,12 +2073,10 @@ static int ceph_zero_partial_object(struct inode *inode,
 	}
 
 	req->r_mtime = inode->i_mtime;
-	ret = ceph_osdc_start_request(&fsc->client->osdc, req, false);
-	if (!ret) {
-		ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
-		if (ret == -ENOENT)
-			ret = 0;
-	}
+	ceph_osdc_start_request(&fsc->client->osdc, req);
+	ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
+	if (ret == -ENOENT)
+		ret = 0;
 	ceph_osdc_put_request(req);
 
 out:
@@ -2384,7 +2378,7 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
 		if (IS_ERR(req))
 			ret = PTR_ERR(req);
 		else {
-			ceph_osdc_start_request(osdc, req, false);
+			ceph_osdc_start_request(osdc, req);
 			ret = ceph_osdc_wait_request(osdc, req);
 			ceph_update_copyfrom_metrics(&fsc->mdsc->metric,
 						     req->r_start_latency,
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 6ec3cb2ac457..8cfa650def2c 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -572,9 +572,8 @@ static inline int ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op)
 extern void ceph_osdc_get_request(struct ceph_osd_request *req);
 extern void ceph_osdc_put_request(struct ceph_osd_request *req);
 
-extern int ceph_osdc_start_request(struct ceph_osd_client *osdc,
-				   struct ceph_osd_request *req,
-				   bool nofail);
+void ceph_osdc_start_request(struct ceph_osd_client *osdc,
+				struct ceph_osd_request *req);
 extern void ceph_osdc_cancel_request(struct ceph_osd_request *req);
 extern int ceph_osdc_wait_request(struct ceph_osd_client *osdc,
 				  struct ceph_osd_request *req);
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 75761537c644..fe674c4e943f 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -4615,15 +4615,12 @@ static void handle_watch_notify(struct ceph_osd_client *osdc,
 /*
  * Register request, send initial attempt.
  */
-int ceph_osdc_start_request(struct ceph_osd_client *osdc,
-			    struct ceph_osd_request *req,
-			    bool nofail)
+void ceph_osdc_start_request(struct ceph_osd_client *osdc,
+			     struct ceph_osd_request *req)
 {
 	down_read(&osdc->lock);
 	submit_request(req, false);
 	up_read(&osdc->lock);
-
-	return 0;
 }
 EXPORT_SYMBOL(ceph_osdc_start_request);
 
@@ -4793,7 +4790,7 @@ int ceph_osdc_unwatch(struct ceph_osd_client *osdc,
 	if (ret)
 		goto out_put_req;
 
-	ceph_osdc_start_request(osdc, req, false);
+	ceph_osdc_start_request(osdc, req);
 	linger_cancel(lreq);
 	linger_put(lreq);
 	ret = wait_request_timeout(req, opts->mount_timeout);
@@ -4864,7 +4861,7 @@ int ceph_osdc_notify_ack(struct ceph_osd_client *osdc,
 	if (ret)
 		goto out_put_req;
 
-	ceph_osdc_start_request(osdc, req, false);
+	ceph_osdc_start_request(osdc, req);
 	ret = ceph_osdc_wait_request(osdc, req);
 
 out_put_req:
@@ -5080,7 +5077,7 @@ int ceph_osdc_list_watchers(struct ceph_osd_client *osdc,
 	if (ret)
 		goto out_put_req;
 
-	ceph_osdc_start_request(osdc, req, false);
+	ceph_osdc_start_request(osdc, req);
 	ret = ceph_osdc_wait_request(osdc, req);
 	if (ret >= 0) {
 		void *p = page_address(pages[0]);
@@ -5157,7 +5154,7 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
 	if (ret)
 		goto out_put_req;
 
-	ceph_osdc_start_request(osdc, req, false);
+	ceph_osdc_start_request(osdc, req);
 	ret = ceph_osdc_wait_request(osdc, req);
 	if (ret >= 0) {
 		ret = req->r_ops[0].rval;
-- 
2.36.1


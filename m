Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3364349A9
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 16:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfFDOA5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jun 2019 10:00:57 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39975 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727182AbfFDOA5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jun 2019 10:00:57 -0400
Received: by mail-pg1-f196.google.com with SMTP id d30so10414027pgm.7
        for <ceph-devel@vger.kernel.org>; Tue, 04 Jun 2019 07:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PF0uH+ZRXAix2LXwWj0DN3BUmVkQ4lCiIRhcLbCoz3w=;
        b=MY/eSF0V2FDC/zXaZlqRx4KDKPPGFTOXYJkcyF1aTHxL8L7ptc7DD2/cpK/2vrjgmP
         /y0TxlnBLpxA9ssFnUzLIDfb/OXwOtlUqxOxdy/Ten9vwquh4JDxaWvzmFO7T6GmqMLz
         jHkWpNeIjBWgJ2dVUvkyceGC8p/Fr/WmHTcm8vb8TI3QopPX+UZjIH29ryez9MsJopIZ
         8w2QMXtLERQ55lOLJgy3xUos2y3CLHkFkU0OqABAmLPsFltlCjLg9c16/Jh5NQT/IGiZ
         ElQo//5+Zo63kuRMgGwSYicU5YWgmL8KVeJSio34tHqpGPE8YRGjnEm/ATf0IXbadQXU
         Y3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PF0uH+ZRXAix2LXwWj0DN3BUmVkQ4lCiIRhcLbCoz3w=;
        b=Bex5Nn86CwJSsMU3nwAcKiqFjqJhBnjjW0sshg7AcBWlVxkVNlL1qRCBe/64UF2Z0/
         pG1fpi8yeiv+x2RyW3ip0c/KesbXE9xDr6ebjLgueSiFGWHBXKtE16v3emVtpnScBVuo
         XWUpPt6YuiiZJ5wEJ46ApZY4+eaQxjUEzZEUBjeaMMuMoHzpPxJb/4bw82Xw56meUgau
         WKev/4W1BLBB0xPpYEYnALr/5P4kO2kxLYgh14rucit8KP/LKn7LmVliFyzGPiMgazUP
         8MVYkcgZpUkhbzc5w9F2HCT1VpSysuip4ecMn6Y2ZSHF7s1WxPPYJvNnrtYyiDn0+wS0
         jYLg==
X-Gm-Message-State: APjAAAUf48IqaivKaduql1DE2IU/hwIROmTJRZxU1HdBTkGxya09+Bp4
        yBUs96JIpaiEq8rPkx+aRzBV7A3/O2n4jg==
X-Google-Smtp-Source: APXvYqydIAFaSMnnNw9WmmtLV4KYlibxg2pgIKe8IJp4IYDanBegbWBSGwzu3s7WCpCuJZZHiYvrZw==
X-Received: by 2002:a63:ef0e:: with SMTP id u14mr33634830pgh.295.1559656856314;
        Tue, 04 Jun 2019 07:00:56 -0700 (PDT)
Received: from localhost.localdomain ([104.192.108.10])
        by smtp.gmail.com with ESMTPSA id v23sm19746154pff.185.2019.06.04.07.00.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 07:00:55 -0700 (PDT)
From:   xxhdx1985126@gmail.com
To:     idryomov@gmail.com, ukernel@gmail.com, ceph-devel@vger.kernel.org
Cc:     Xuehan Xu <xuxuehan@360.cn>
Subject: [PATCH 2/2] ceph: use the ceph-specific blkcg policy to limit ceph client ops
Date:   Tue,  4 Jun 2019 21:51:18 +0800
Message-Id: <20190604135119.8109-3-xxhdx1985126@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190604135119.8109-1-xxhdx1985126@gmail.com>
References: <20190604135119.8109-1-xxhdx1985126@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xuehan Xu <xuxuehan@360.cn>

Signed-off-by: Xuehan Xu <xuxuehan@360.cn>
---
 fs/ceph/addr.c         | 156 +++++++++++++++++++++++++++++++++++++++++
 fs/ceph/file.c         | 110 +++++++++++++++++++++++++++++
 fs/ceph/mds_client.c   |  26 +++++++
 fs/ceph/mds_client.h   |   7 ++
 fs/ceph/super.c        |  12 ++++
 net/ceph/ceph_common.c |  13 ----
 6 files changed, 311 insertions(+), 13 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index a47c541f8006..ae759057dbd0 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -193,6 +193,27 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
 	int err = 0;
 	u64 off = page_offset(page);
 	u64 len = PAGE_SIZE;
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	struct ceph_group_data* cephgd_p =
+		blkcg_to_cephgd(css_to_blkcg(blkcg_css()));
+	struct queue_item qitem;
+
+	err = queue_item_init(&qitem, &cephgd_p->data_ops_throttle,
+			      DATA_OPS_TB_NUM);
+	if (err < 0)
+		return err;
+
+	qitem.tokens_requested[DATA_OPS_IOPS_IDX] = 1;
+	qitem.tokens_requested[DATA_OPS_BAND_IDX] = len;
+	dout("%s: tokens_requested: %p, tb_item_num: %d\n", __func__,
+	     qitem.tokens_requested, qitem.tb_item_num);
+
+	err = get_token_bucket_throttle(&cephgd_p->data_ops_throttle,
+					&qitem);
+	queue_item_free(&qitem);
+	if (err < 0)
+		return err;
+#endif
 
 	if (off >= i_size_read(inode)) {
 		zero_user_segment(page, 0, PAGE_SIZE);
@@ -317,6 +338,16 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
 	int nr_pages = 0;
 	int got = 0;
 	int ret = 0;
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	struct ceph_group_data* cephgd_p =
+		blkcg_to_cephgd(css_to_blkcg(blkcg_css()));
+	struct queue_item qitem;
+
+	ret = queue_item_init(&qitem, &cephgd_p->data_ops_throttle,
+			      DATA_OPS_TB_NUM);
+	if (ret < 0)
+		return ret;
+#endif
 
 	if (!rw_ctx) {
 		/* caller of readpages does not hold buffer and read caps
@@ -401,6 +432,17 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
 	req->r_callback = finish_read;
 	req->r_inode = inode;
 
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	qitem.tokens_requested[DATA_OPS_IOPS_IDX] = 1;
+	qitem.tokens_requested[DATA_OPS_BAND_IDX] = len;
+	dout("%s: tokens_requested: %p, tb_item_num: %d\n", __func__,
+	     qitem.tokens_requested, qitem.tb_item_num);
+	ret = get_token_bucket_throttle(&cephgd_p->data_ops_throttle,
+					&qitem);
+	if (ret < 0)
+		goto out_pages;
+#endif
+
 	dout("start_read %p starting %p %lld~%lld\n", inode, req, off, len);
 	ret = ceph_osdc_start_request(osdc, req, false);
 	if (ret < 0)
@@ -411,6 +453,9 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
 	 * So we can drop our cap refs. */
 	if (got)
 		ceph_put_cap_refs(ci, got);
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	queue_item_free(&qitem);
+#endif
 
 	return nr_pages;
 
@@ -423,6 +468,10 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
 out_put:
 	ceph_osdc_put_request(req);
 out:
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	queue_item_free(&qitem);
+#endif
+
 	if (got)
 		ceph_put_cap_refs(ci, got);
 	return ret;
@@ -580,6 +629,36 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 	loff_t page_off = page_offset(page);
 	int err, len = PAGE_SIZE;
 	struct ceph_writeback_ctl ceph_wbc;
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	struct ceph_group_data* cephgd_p = NULL;
+	struct queue_item qitem;
+
+#ifdef CONFIG_CGROUP_WRITEBACK
+	if (wbc->wb)
+		cephgd_p = blkcg_to_cephgd(css_to_blkcg(wbc->wb->blkcg_css));
+	else
+		cephgd_p = blkcg_to_cephgd(css_to_blkcg(blkcg_css()));
+#else
+	cephgd_p = blkcg_to_cephgd(css_to_blkcg(blkcg_css()));
+#endif
+
+	err = queue_item_init(&qitem, &cephgd_p->data_ops_throttle,
+			      DATA_OPS_TB_NUM);
+	if (err < 0)
+		return err;
+
+	qitem.tokens_requested[DATA_OPS_IOPS_IDX] = 1;
+	qitem.tokens_requested[DATA_OPS_BAND_IDX] = len;
+	dout("%s: tokens_requested: %p, tb_item_num: %d\n", __func__,
+	     qitem.tokens_requested, qitem.tb_item_num);
+
+	err = get_token_bucket_throttle(&cephgd_p->data_ops_throttle,
+					&qitem);
+	queue_item_free(&qitem);
+	if (err < 0)
+		return err;
+
+#endif
 
 	dout("writepage %p idx %lu\n", page, page->index);
 
@@ -801,6 +880,24 @@ static int ceph_writepages_start(struct address_space *mapping,
 	struct ceph_writeback_ctl ceph_wbc;
 	bool should_loop, range_whole = false;
 	bool done = false;
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	struct ceph_group_data* cephgd_p = NULL;
+	struct queue_item qitem;
+
+#ifdef CONFIG_CGROUP_WRITEBACK
+	if (wbc->wb)
+		cephgd_p = blkcg_to_cephgd(css_to_blkcg(wbc->wb->blkcg_css));
+	else
+		cephgd_p = blkcg_to_cephgd(css_to_blkcg(blkcg_css()));
+#else
+	cephgd_p = blkcg_to_cephgd(css_to_blkcg(blkcg_css()));
+#endif
+
+	rc = queue_item_init(&qitem, &cephgd_p->data_ops_throttle,
+			      DATA_OPS_TB_NUM);
+	if (rc < 0)
+		return rc;
+#endif
 
 	dout("writepages_start %p (mode=%s)\n", inode,
 	     wbc->sync_mode == WB_SYNC_NONE ? "NONE" :
@@ -1132,6 +1229,21 @@ static int ceph_writepages_start(struct address_space *mapping,
 		}
 
 		req->r_mtime = inode->i_mtime;
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+		qitem.tokens_requested[DATA_OPS_IOPS_IDX] = req->r_num_ops;
+		qitem.tokens_requested[DATA_OPS_BAND_IDX] = 0;
+
+		for (i = 0; i < req->r_num_ops; i++)
+			if (req->r_ops[i].op == CEPH_OSD_OP_WRITE)
+				qitem.tokens_requested[DATA_OPS_BAND_IDX] +=
+					req->r_ops[i].extent.length;
+
+		dout("%s: tokens_requested: %p, tb_item_num: %d\n", __func__,
+		     qitem.tokens_requested, qitem.tb_item_num);
+		rc = get_token_bucket_throttle(&cephgd_p->data_ops_throttle,
+						&qitem);
+		BUG_ON(rc);
+#endif
 		rc = ceph_osdc_start_request(&fsc->client->osdc, req, true);
 		BUG_ON(rc);
 		req = NULL;
@@ -1191,6 +1303,9 @@ static int ceph_writepages_start(struct address_space *mapping,
 		mapping->writeback_index = index;
 
 out:
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	queue_item_free(&qitem);
+#endif
 	ceph_osdc_put_request(req);
 	ceph_put_snap_context(last_snapc);
 	dout("writepages dend - startone, rc = %d\n", rc);
@@ -1671,6 +1786,16 @@ int ceph_uninline_data(struct file *filp, struct page *locked_page)
 	u64 len, inline_version;
 	int err = 0;
 	bool from_pagecache = false;
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	struct ceph_group_data* cephgd_p =
+		blkcg_to_cephgd(css_to_blkcg(blkcg_css()));
+	struct queue_item qitem;
+
+	err = queue_item_init(&qitem, &cephgd_p->data_ops_throttle,
+			      DATA_OPS_TB_NUM);
+	if (err < 0)
+		goto out;
+#endif
 
 	spin_lock(&ci->i_ceph_lock);
 	inline_version = ci->i_inline_version;
@@ -1731,6 +1856,20 @@ int ceph_uninline_data(struct file *filp, struct page *locked_page)
 	}
 
 	req->r_mtime = inode->i_mtime;
+
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	qitem.tokens_requested[DATA_OPS_IOPS_IDX] = 1;
+	qitem.tokens_requested[DATA_OPS_BAND_IDX] = 0;
+	dout("%s: tokens_requested: %p, tb_item_num: %d\n", __func__,
+	     qitem.tokens_requested, qitem.tb_item_num);
+
+	err = get_token_bucket_throttle(&cephgd_p->data_ops_throttle,
+					&qitem);
+	if (err < 0) {
+		goto out_put;
+	}
+#endif
+
 	err = ceph_osdc_start_request(&fsc->client->osdc, req, false);
 	if (!err)
 		err = ceph_osdc_wait_request(&fsc->client->osdc, req);
@@ -1772,6 +1911,19 @@ int ceph_uninline_data(struct file *filp, struct page *locked_page)
 			goto out_put;
 	}
 
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	qitem.tokens_requested[DATA_OPS_IOPS_IDX] = 3;
+	qitem.tokens_requested[DATA_OPS_BAND_IDX] = len;
+	dout("%s: tokens_requested: %p, tb_item_num: %d\n", __func__,
+	     qitem.tokens_requested, qitem.tb_item_num);
+
+	err = get_token_bucket_throttle(&cephgd_p->data_ops_throttle,
+					&qitem);
+	if (err < 0) {
+		goto out_put;
+	}
+#endif
+
 	req->r_mtime = inode->i_mtime;
 	err = ceph_osdc_start_request(&fsc->client->osdc, req, false);
 	if (!err)
@@ -1781,6 +1933,10 @@ int ceph_uninline_data(struct file *filp, struct page *locked_page)
 	if (err == -ECANCELED)
 		err = 0;
 out:
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	queue_item_free(&qitem);
+#endif
+
 	if (page && page != locked_page) {
 		if (from_pagecache) {
 			unlock_page(page);
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 305daf043eb0..0f2b0f1e5acc 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -10,6 +10,9 @@
 #include <linux/namei.h>
 #include <linux/writeback.h>
 #include <linux/falloc.h>
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+#include <linux/ceph/ceph_io_policy.h>
+#endif
 
 #include "super.h"
 #include "mds_client.h"
@@ -579,6 +582,11 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 	ssize_t ret;
 	u64 off = iocb->ki_pos;
 	u64 len = iov_iter_count(to);
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	struct ceph_group_data* cephgd_p =
+		blkcg_to_cephgd(css_to_blkcg(blkcg_css()));
+	struct queue_item qitem;
+#endif
 
 	dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
 	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
@@ -597,6 +605,12 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 		return ret;
 
 	ret = 0;
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	ret = queue_item_init(&qitem, &cephgd_p->data_ops_throttle,
+			      DATA_OPS_TB_NUM);
+	if (ret < 0)
+		return ret;
+#endif
 	while ((len = iov_iter_count(to)) > 0) {
 		struct ceph_osd_request *req;
 		struct page **pages;
@@ -642,6 +656,19 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 			}
 		}
 
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+		qitem.tokens_requested[DATA_OPS_IOPS_IDX] = 1;
+		qitem.tokens_requested[DATA_OPS_BAND_IDX] = len;
+		dout("%s: tokens_requested: %p, tb_item_num: %d\n", __func__,
+		     qitem.tokens_requested, qitem.tb_item_num);
+		ret = get_token_bucket_throttle(&cephgd_p->data_ops_throttle,
+						&qitem);
+		if (ret < 0) {
+			ceph_osdc_put_request(req);
+			break;
+		}
+#endif
+
 		osd_req_op_extent_osd_data_pages(req, 0, pages, len, page_off,
 						 false, false);
 		ret = ceph_osdc_start_request(osdc, req, false);
@@ -703,6 +730,10 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 		iocb->ki_pos = off;
 	}
 
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	queue_item_free(&qitem);
+#endif
+
 	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);
 	return ret;
 }
@@ -923,6 +954,17 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 	loff_t pos = iocb->ki_pos;
 	bool write = iov_iter_rw(iter) == WRITE;
 	bool should_dirty = !write && iter_is_iovec(iter);
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	struct ceph_group_data* cephgd_p =
+		blkcg_to_cephgd(css_to_blkcg(blkcg_css()));
+	struct queue_item qitem;
+
+	ret = queue_item_init(&qitem, &cephgd_p->data_ops_throttle,
+			      DATA_OPS_TB_NUM);
+	if (ret < 0)
+		return ret;
+
+#endif
 
 	if (write && ceph_snap(file_inode(file)) != CEPH_NOSNAP)
 		return -EROFS;
@@ -978,6 +1020,20 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 			ret = len;
 			break;
 		}
+
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+		qitem.tokens_requested[DATA_OPS_IOPS_IDX] = 1;
+		qitem.tokens_requested[DATA_OPS_BAND_IDX] = len;
+		dout("%s: tokens_requested: %p, tb_item_num: %d\n", __func__,
+		     qitem.tokens_requested, qitem.tb_item_num);
+		ret = get_token_bucket_throttle(&cephgd_p->data_ops_throttle,
+						&qitem);
+		if (ret < 0) {
+			ceph_osdc_put_request(req);
+			break;
+		}
+#endif
+
 		if (len != size)
 			osd_req_op_extent_update(req, 0, len);
 
@@ -1099,6 +1155,9 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 		ret = pos - iocb->ki_pos;
 		iocb->ki_pos = pos;
 	}
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	queue_item_free(&qitem);
+#endif
 	return ret;
 }
 
@@ -1128,6 +1187,11 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 	bool check_caps = false;
 	struct timespec64 mtime = current_time(inode);
 	size_t count = iov_iter_count(from);
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	struct ceph_group_data* cephgd_p =
+		blkcg_to_cephgd(css_to_blkcg(blkcg_css()));
+	struct queue_item qitem;
+#endif
 
 	if (ceph_snap(file_inode(file)) != CEPH_NOSNAP)
 		return -EROFS;
@@ -1148,6 +1212,13 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 
 	flags = /* CEPH_OSD_FLAG_ORDERSNAP | */ CEPH_OSD_FLAG_WRITE;
 
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	ret = queue_item_init(&qitem, &cephgd_p->data_ops_throttle,
+			      DATA_OPS_TB_NUM);
+	if (ret < 0)
+		return ret;
+#endif
+
 	while ((len = iov_iter_count(from)) > 0) {
 		size_t left;
 		int n;
@@ -1192,6 +1263,17 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 			goto out;
 		}
 
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+		qitem.tokens_requested[DATA_OPS_IOPS_IDX] = 1;
+		qitem.tokens_requested[DATA_OPS_BAND_IDX] = len;
+		dout("%s: tokens_requested: %p, tb_item_num: %d\n", __func__,
+		     qitem.tokens_requested, qitem.tb_item_num);
+		ret = get_token_bucket_throttle(&cephgd_p->data_ops_throttle,
+						&qitem);
+		if (ret < 0)
+			goto out;
+#endif
+
 		req->r_inode = inode;
 
 		osd_req_op_extent_osd_data_pages(req, 0, pages, len, 0,
@@ -1226,6 +1308,11 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 		ret = written;
 		iocb->ki_pos = pos;
 	}
+
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	queue_item_free(&qitem);
+#endif
+
 	return ret;
 }
 
@@ -1648,6 +1735,16 @@ static int ceph_zero_partial_object(struct inode *inode,
 	int ret = 0;
 	loff_t zero = 0;
 	int op;
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	struct ceph_group_data* cephgd_p =
+		blkcg_to_cephgd(css_to_blkcg(blkcg_css()));
+	struct queue_item qitem;
+
+	ret = queue_item_init(&qitem, &cephgd_p->data_ops_throttle,
+			      DATA_OPS_TB_NUM);
+	if (ret < 0)
+		goto out;
+#endif
 
 	if (!length) {
 		op = offset ? CEPH_OSD_OP_DELETE : CEPH_OSD_OP_TRUNCATE;
@@ -1656,6 +1753,16 @@ static int ceph_zero_partial_object(struct inode *inode,
 		op = CEPH_OSD_OP_ZERO;
 	}
 
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	qitem.tokens_requested[DATA_OPS_IOPS_IDX] = 1;
+	qitem.tokens_requested[DATA_OPS_BAND_IDX] = *length;
+	dout("%s: tokens_requested: %p, tb_item_num: %d\n", __func__,
+	     qitem.tokens_requested, qitem.tb_item_num);
+	ret = get_token_bucket_throttle(&cephgd_p->data_ops_throttle,
+					&qitem);
+	if (ret < 0)
+		goto out;
+#endif
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
 					ceph_vino(inode),
 					offset, length,
@@ -1677,6 +1784,9 @@ static int ceph_zero_partial_object(struct inode *inode,
 	ceph_osdc_put_request(req);
 
 out:
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	queue_item_free(&qitem);
+#endif
 	return ret;
 }
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 959b1bf7c327..d60f33c58778 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -19,6 +19,9 @@
 #include <linux/ceph/pagelist.h>
 #include <linux/ceph/auth.h>
 #include <linux/ceph/debugfs.h>
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+#include <linux/ceph/ceph_io_policy.h>
+#endif
 
 #define RECONNECT_MAX_SIZE (INT_MAX - PAGE_SIZE)
 
@@ -683,6 +686,9 @@ void ceph_mdsc_release_request(struct kref *kref)
 	struct ceph_mds_request *req = container_of(kref,
 						    struct ceph_mds_request,
 						    r_kref);
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	kfree(req->qitem.tokens_requested);
+#endif
 	destroy_reply_info(&req->r_reply_info);
 	if (req->r_request)
 		ceph_msg_put(req->r_request);
@@ -2030,6 +2036,10 @@ ceph_mdsc_create_request(struct ceph_mds_client *mdsc, int op, int mode)
 {
 	struct ceph_mds_request *req = kzalloc(sizeof(*req), GFP_NOFS);
 	struct timespec64 ts;
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	struct ceph_group_data* cephgd_p =
+		blkcg_to_cephgd(css_to_blkcg(blkcg_css()));
+#endif
 
 	if (!req)
 		return ERR_PTR(-ENOMEM);
@@ -2053,6 +2063,10 @@ ceph_mdsc_create_request(struct ceph_mds_client *mdsc, int op, int mode)
 
 	req->r_op = op;
 	req->r_direct_mode = mode;
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	queue_item_init(&req->qitem, &cephgd_p->meta_ops_throttle,
+			META_OPS_TB_NUM);
+#endif
 	return req;
 }
 
@@ -2703,13 +2717,25 @@ int ceph_mdsc_do_request(struct ceph_mds_client *mdsc,
 			 struct ceph_mds_request *req)
 {
 	int err;
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	struct ceph_group_data* cephgd_p =
+		blkcg_to_cephgd(css_to_blkcg(blkcg_css()));
+#endif
 
 	dout("do_request on %p\n", req);
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	req->qitem.tokens_requested[META_OPS_IOPS_IDX] = 1;
+	err = get_token_bucket_throttle(&cephgd_p->meta_ops_throttle,
+					&req->qitem);
+	if (err)
+		goto out;
+#endif
 
 	/* issue */
 	err = ceph_mdsc_submit_request(mdsc, dir, req);
 	if (!err)
 		err = ceph_mdsc_wait_request(mdsc, req);
+out:
 	dout("do_request %p done, result %d\n", req, err);
 	return err;
 }
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index a83f28bc2387..f3fe33529b2e 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -15,6 +15,9 @@
 #include <linux/ceph/messenger.h>
 #include <linux/ceph/mdsmap.h>
 #include <linux/ceph/auth.h>
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+#include <linux/ceph/ceph_io_policy.h>
+#endif
 
 /* The first 8 bits are reserved for old ceph releases */
 #define CEPHFS_FEATURE_MIMIC		8
@@ -284,6 +287,10 @@ struct ceph_mds_request {
 	/* unsafe requests that modify the target inode */
 	struct list_head r_unsafe_target_item;
 
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	/* requests that blocked by the token bucket throttle*/
+	struct queue_item qitem;
+#endif
 	struct ceph_mds_session *r_session;
 
 	int               r_attempts;   /* resend attempts */
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 01be7c1bc4c6..aedc8c122e74 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -25,6 +25,9 @@
 #include <linux/ceph/mon_client.h>
 #include <linux/ceph/auth.h>
 #include <linux/ceph/debugfs.h>
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+#include <linux/ceph/ceph_io_policy.h>
+#endif
 
 /*
  * Ceph superblock operations
@@ -1174,6 +1177,12 @@ static int __init init_ceph(void)
 	if (ret)
 		goto out;
 
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	ret = ceph_io_policy_init();
+	if (ret < 0)
+		goto out;
+#endif
+
 	ceph_flock_init();
 	ceph_xattr_init();
 	ret = register_filesystem(&ceph_fs_type);
@@ -1194,6 +1203,9 @@ static int __init init_ceph(void)
 static void __exit exit_ceph(void)
 {
 	dout("exit_ceph\n");
+#ifdef CONFIG_CEPH_LIB_IO_POLICY
+	ceph_io_policy_release();
+#endif
 	unregister_filesystem(&ceph_fs_type);
 	ceph_xattr_exit();
 	destroy_caches();
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 05c6e7b89c42..1c811c74bfc0 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -26,9 +26,6 @@
 #include <linux/ceph/decode.h>
 #include <linux/ceph/mon_client.h>
 #include <linux/ceph/auth.h>
-#ifdef CONFIG_CEPH_LIB_IO_POLICY
-#include <linux/ceph/ceph_io_policy.h>
-#endif
 #include "crypto.h"
 
 
@@ -779,12 +776,6 @@ static int __init init_ceph_lib(void)
 {
 	int ret = 0;
 
-#ifdef CONFIG_CEPH_LIB_IO_POLICY
-	ret = ceph_io_policy_init();
-	if (ret < 0)
-		goto out;
-#endif
-
 	ret = ceph_debugfs_init();
 	if (ret < 0)
 		goto out;
@@ -821,10 +812,6 @@ static void __exit exit_ceph_lib(void)
 	dout("exit_ceph_lib\n");
 	WARN_ON(!ceph_strings_empty());
 
-#ifdef CONFIG_CEPH_LIB_IO_POLICY
-	ceph_io_policy_release();
-#endif
-
 	ceph_osdc_cleanup();
 	ceph_msgr_exit();
 	ceph_crypto_shutdown();
-- 
2.21.0


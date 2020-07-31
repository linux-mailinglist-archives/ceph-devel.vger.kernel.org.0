Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB8F234685
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jul 2020 15:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732374AbgGaNE3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Jul 2020 09:04:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730217AbgGaNE1 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 Jul 2020 09:04:27 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D911422B3F;
        Fri, 31 Jul 2020 13:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596200667;
        bh=cKhYgcorXvf8Uopt2GYpEFEbce+AFte8k1CeDoaqgdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mhkSkF1nV6j8KIZPQn11YdPS65f1Oh4MixaG56X4GE8hoUdkpXVvts0DyBblwpxjS
         ocQmDUo8FKUXoAtq1YRyFY9IgcRlO341uNQwu3bDl2w6ReC0g3k1XhmNcZd4mmN2Nd
         a4HZQgY9iJj8Ygy4m0tNP/YX6zJu3JEe+878aVnc=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     linux-cachefs@redhat.com, idryomov@gmail.com
Subject: [RFC PATCH v2 07/11] ceph: convert readpage to fscache read helper
Date:   Fri, 31 Jul 2020 09:04:17 -0400
Message-Id: <20200731130421.127022-8-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200731130421.127022-1-jlayton@kernel.org>
References: <20200731130421.127022-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Create a new ceph_fscache_req structure that holds a fscache_io_request
and a refcount_t. Change the readpage code to use the new
infrastructure. Have KConfig select CONFIG_FSCACHE_SERVICES and
CONFIG_FSCACHE_READ_HELPER so that this will still work even when
FSCache proper is disabled.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/Kconfig |   2 +
 fs/ceph/addr.c  | 204 +++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 196 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
index e955a38be3c8..432aa34b63e7 100644
--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@ -6,6 +6,8 @@ config CEPH_FS
 	select LIBCRC32C
 	select CRYPTO_AES
 	select CRYPTO
+	select FSCACHE_SERVICES
+	select FSCACHE_READ_HELPER
 	default n
 	help
 	  Choose Y or M here to include support for mounting the
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e005c32270f5..75cdd35f1d2e 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -12,6 +12,7 @@
 #include <linux/signal.h>
 #include <linux/iversion.h>
 #include <linux/ktime.h>
+#include <linux/fscache.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -182,6 +183,199 @@ static int ceph_releasepage(struct page *page, gfp_t g)
 	return 1;
 }
 
+struct ceph_fscache_req {
+	struct fscache_io_request	fscache_req;
+	refcount_t			ref;
+};
+
+static struct ceph_fscache_req *ceph_fsreq_alloc(void)
+{
+	struct ceph_fscache_req *req = kzalloc(sizeof(*req), GFP_NOFS);
+
+	if (req)
+		refcount_set(&req->ref, 1);
+	return req;
+}
+
+static void ceph_fsreq_done(struct fscache_io_request *fsreq)
+{
+}
+
+static void ceph_fsreq_get(struct fscache_io_request *fsreq)
+{
+	struct ceph_fscache_req *req = container_of(fsreq, struct ceph_fscache_req, fscache_req);
+
+	refcount_inc(&req->ref);
+}
+
+static void ceph_fsreq_put(struct fscache_io_request *fsreq)
+{
+	struct ceph_fscache_req *req = container_of(fsreq, struct ceph_fscache_req, fscache_req);
+
+	if (refcount_dec_and_test(&req->ref)) {
+		fscache_free_io_request(fsreq);
+		kfree(req);
+	}
+}
+
+static void ceph_fsreq_reshape(struct fscache_io_request *fsreq,
+			       struct fscache_request_shape *shape)
+{
+	struct inode *inode = fsreq->mapping->host;
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	u64 objno, objoff;
+	u32 xlen;
+
+	/* Truncate the extent at the end of the current object */
+	ceph_calc_file_object_mapping(&ci->i_layout, shape->actual_start << PAGE_SHIFT,
+				      shape->actual_nr_pages << PAGE_SHIFT, &objno, &objoff, &xlen);
+	shape->actual_nr_pages = xlen >> PAGE_SHIFT;
+}
+
+static void finish_fsreq_read(struct ceph_osd_request *req)
+{
+	struct ceph_fs_client *fsc = ceph_inode_to_client(req->r_inode);
+	struct ceph_osd_data *osd_data = osd_req_op_extent_osd_data(req, 0);
+	struct fscache_io_request *fsreq = req->r_priv;
+	int num_pages;
+	int err = req->r_result;
+
+	ceph_update_read_latency(&fsc->mdsc->metric, req->r_start_latency,
+				 req->r_end_latency, err);
+
+	/* no object means success but no data */
+	if (err == -ENOENT)
+		err = 0;
+	else if (err == -EBLACKLISTED)
+		fsc->blacklisted = true;
+
+	dout("%s: result %d\n", __func__, err);
+	if (err >= 0)
+		fsreq->transferred = err;
+	else
+		fsreq->error = err;
+
+	if (fsreq->io_done)
+		fsreq->io_done(fsreq);
+
+	num_pages = calc_pages_for(osd_data->alignment, osd_data->length);
+	ceph_put_page_vector(osd_data->pages, num_pages, false);
+	ceph_fsreq_put(fsreq);
+	iput(req->r_inode);
+}
+
+static void ceph_fsreq_issue_op(struct fscache_io_request *fsreq)
+{
+	struct inode *inode = fsreq->mapping->host;
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
+	struct ceph_osd_request *req = NULL;
+	struct ceph_vino vino = ceph_vino(inode);
+	struct iov_iter iter;
+	struct page **pages;
+	size_t page_off;
+	int err = 0;
+	u64 len = fsreq->len;
+
+	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout, vino, fsreq->pos, &len,
+			0, 1, CEPH_OSD_OP_READ,
+			CEPH_OSD_FLAG_READ | fsc->client->osdc.client->options->read_from_replica,
+			NULL, ci->i_truncate_seq, ci->i_truncate_size, false);
+	if (IS_ERR(req)) {
+		err = PTR_ERR(req);
+		goto out;
+	}
+
+	dout("%s: pos=%llu orig_len=%llu len=%llu\n", __func__, fsreq->pos, fsreq->len, len);
+	iov_iter_mapping(&iter, READ, fsreq->mapping, fsreq->pos, len);
+	len = iov_iter_get_pages_alloc(&iter, &pages, len, &page_off);
+	if (len < 0) {
+		err = len;
+		dout("%s: iov_ter_get_pages_alloc returned %d\n", __func__, err);
+		goto out;
+	}
+
+	/* fscache should always give us a page-aligned read */
+	WARN_ON_ONCE(page_off);
+
+	osd_req_op_extent_osd_data_pages(req, 0, pages, len, 0, false, false);
+	req->r_callback = finish_fsreq_read;
+	req->r_priv = fsreq;
+	ceph_fsreq_get(fsreq);
+	req->r_inode = inode;
+	ihold(inode);
+
+	err = ceph_osdc_start_request(req->r_osdc, req, false);
+	if (err) {
+		iput(inode);
+		ceph_fsreq_put(fsreq);
+	}
+out:
+	if (req)
+		ceph_osdc_put_request(req);
+
+	if (err) {
+		fsreq->error = err;
+		if (fsreq->io_done)
+			fsreq->io_done(fsreq);
+	}
+	dout("%s: result %d\n", __func__, fsreq->error);
+}
+
+const struct fscache_io_request_ops ceph_readpage_fsreq_ops = {
+	.issue_op	= ceph_fsreq_issue_op,
+	.reshape	= ceph_fsreq_reshape,
+	.done		= ceph_fsreq_done,
+	.get		= ceph_fsreq_get,
+	.put		= ceph_fsreq_put,
+};
+
+/* read a single page, without unlocking it. */
+static int ceph_readpage(struct file *filp, struct page *page)
+{
+	struct inode *inode = file_inode(filp);
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
+	struct ceph_fscache_req *req;
+	struct ceph_vino vino = ceph_vino(inode);
+	struct fscache_cookie *cookie = ceph_fscache_cookie(ci);
+	int err = 0;
+	u64 off = page_offset(page);
+	u64 len = PAGE_SIZE;
+
+	if (ci->i_inline_version != CEPH_INLINE_NONE) {
+		/*
+		 * Uptodate inline data should have been added
+		 * into page cache while getting Fcr caps.
+		 */
+		if (off == 0) {
+			unlock_page(page);
+			return -EINVAL;
+		}
+		zero_user_segment(page, 0, PAGE_SIZE);
+		SetPageUptodate(page);
+		unlock_page(page);
+		return 0;
+	}
+
+	dout("readpage ino %llx.%llx file %p off %llu len %llu page %p index %lu\n",
+	     vino.ino, vino.snap, filp, off, len, page, page->index);
+
+	req = ceph_fsreq_alloc();
+	if (!req) {
+		unlock_page(page);
+		return -ENOMEM;
+	}
+
+	fscache_init_io_request(&req->fscache_req, cookie, &ceph_readpage_fsreq_ops);
+	req->fscache_req.mapping = inode->i_mapping;
+
+	err = fscache_read_helper_locked_page(&req->fscache_req, page,
+					      fsc->mount_options->rsize >> PAGE_SHIFT);
+	ceph_fsreq_put(&req->fscache_req);
+	return err;
+}
+
 /* read a single page, without unlocking it. */
 static int ceph_do_readpage(struct file *filp, struct page *page)
 {
@@ -253,16 +447,6 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
 	return err < 0 ? err : 0;
 }
 
-static int ceph_readpage(struct file *filp, struct page *page)
-{
-	int r = ceph_do_readpage(filp, page);
-	if (r != -EINPROGRESS)
-		unlock_page(page);
-	else
-		r = 0;
-	return r;
-}
-
 /*
  * Finish an async read(ahead) op.
  */
-- 
2.26.2


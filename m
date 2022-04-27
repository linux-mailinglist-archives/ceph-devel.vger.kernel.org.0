Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077055122A7
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbiD0T2J (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbiD0TTN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C0B6B0BB
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 72BA2CE26AE
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45ED5C385AE;
        Wed, 27 Apr 2022 19:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086801;
        bh=trOGwfW0dpuka6lVn4FyjgWAwHGV8whpehGIyBn/Kcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fdSfBkOOHecT7y7RQfW8wqcQ+rMgWJ4sbZtxChGShOqGW4xytI+R1JMw3osgj+Yok
         rC6omT7xGxLVq8hZTZAybsJkIEwg6AFwcjF6NTyvrKUKeC4Ys+fB4FXtlcwc3aNYaP
         oKFUbmTdS5zGjkoWqlEbvZdAwSvjTxEyeC8WwgfGOSh3Ubz4Hi7r+6bAHxkqfD13Eb
         h7iEyFAaysVGwpn9RJ2gxGMTOUIMutqfQcUVNDFflU0z57GFww4VqClNq+5EaCDUdq
         DlQfaIhs8pkZFG/hjrAD3Cv9K13+5v9w+S2UwJ4kriv6szUypnupkhGQqbs8P+NGbl
         zE9DgwB2esBVQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 07/64] ceph: add new mount option to enable sparse reads
Date:   Wed, 27 Apr 2022 15:12:17 -0400
Message-Id: <20220427191314.222867-8-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427191314.222867-1-jlayton@kernel.org>
References: <20220427191314.222867-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add a new mount option that has the client issue sparse reads instead of
normal ones. The callers now preallocate an sparse extent buffer that
the libceph receive code can populate and hand back after the operation
completes.

After a successful sparse read, we can't use the req->r_result value to
determine the amount of data "read", so instead we set the received
length to be from the end of the last extent in the buffer. Any
interstitial holes will have been filled by the receive code.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c  | 17 +++++++++++++++--
 fs/ceph/file.c  | 51 +++++++++++++++++++++++++++++++++++++++++--------
 fs/ceph/super.c | 16 +++++++++++++++-
 fs/ceph/super.h |  1 +
 4 files changed, 74 insertions(+), 11 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 04a6c3f02f0c..84d0b52010d9 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -219,8 +219,10 @@ static void finish_netfs_read(struct ceph_osd_request *req)
 	struct ceph_fs_client *fsc = ceph_inode_to_client(req->r_inode);
 	struct ceph_osd_data *osd_data = osd_req_op_extent_osd_data(req, 0);
 	struct netfs_io_subrequest *subreq = req->r_priv;
+	struct ceph_osd_req_op *op = &req->r_ops[0];
 	int num_pages;
 	int err = req->r_result;
+	bool sparse = (op->op == CEPH_OSD_OP_SPARSE_READ);
 
 	ceph_update_read_metrics(&fsc->mdsc->metric, req->r_start_latency,
 				 req->r_end_latency, osd_data->length, err);
@@ -229,7 +231,9 @@ static void finish_netfs_read(struct ceph_osd_request *req)
 	     subreq->len, i_size_read(req->r_inode));
 
 	/* no object means success but no data */
-	if (err == -ENOENT)
+	if (sparse && err >= 0)
+		err = ceph_sparse_ext_map_end(op);
+	else if (err == -ENOENT)
 		err = 0;
 	else if (err == -EBLOCKLISTED)
 		fsc->blocklisted = true;
@@ -312,13 +316,14 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	size_t page_off;
 	int err = 0;
 	u64 len = subreq->len;
+	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
 
 	if (ci->i_inline_version != CEPH_INLINE_NONE &&
 	    ceph_netfs_issue_op_inline(subreq))
 		return;
 
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout, vino, subreq->start, &len,
-			0, 1, CEPH_OSD_OP_READ,
+			0, 1, sparse ? CEPH_OSD_OP_SPARSE_READ : CEPH_OSD_OP_READ,
 			CEPH_OSD_FLAG_READ | fsc->client->osdc.client->options->read_from_replica,
 			NULL, ci->i_truncate_seq, ci->i_truncate_size, false);
 	if (IS_ERR(req)) {
@@ -327,6 +332,14 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 		goto out;
 	}
 
+	if (sparse) {
+		err = ceph_alloc_sparse_ext_map(&req->r_ops[0]);
+		if (err) {
+			ceph_osdc_put_request(req);
+			goto out;
+		}
+	}
+
 	dout("%s: pos=%llu orig_len=%zu len=%llu\n", __func__, subreq->start, subreq->len, len);
 	iov_iter_xarray(&iter, READ, &rreq->mapping->i_pages, subreq->start, len);
 	err = iov_iter_get_pages_alloc(&iter, &pages, len, &page_off);
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 8c8226c0feac..c805a5f5a6d1 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -915,6 +915,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 	u64 off = iocb->ki_pos;
 	u64 len = iov_iter_count(to);
 	u64 i_size = i_size_read(inode);
+	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
 
 	dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
 	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
@@ -941,10 +942,12 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 		bool more;
 		int idx;
 		size_t left;
+		struct ceph_osd_req_op *op;
 
 		req = ceph_osdc_new_request(osdc, &ci->i_layout,
 					ci->i_vino, off, &len, 0, 1,
-					CEPH_OSD_OP_READ, CEPH_OSD_FLAG_READ,
+					sparse ? CEPH_OSD_OP_SPARSE_READ : CEPH_OSD_OP_READ,
+					CEPH_OSD_FLAG_READ,
 					NULL, ci->i_truncate_seq,
 					ci->i_truncate_size, false);
 		if (IS_ERR(req)) {
@@ -965,6 +968,16 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 
 		osd_req_op_extent_osd_data_pages(req, 0, pages, len, page_off,
 						 false, false);
+
+		op = &req->r_ops[0];
+		if (sparse) {
+			ret = ceph_alloc_sparse_ext_map(op);
+			if (ret) {
+				ceph_osdc_put_request(req);
+				break;
+			}
+		}
+
 		ret = ceph_osdc_start_request(osdc, req, false);
 		if (!ret)
 			ret = ceph_osdc_wait_request(osdc, req);
@@ -974,19 +987,24 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 					 req->r_end_latency,
 					 len, ret);
 
-		ceph_osdc_put_request(req);
-
 		i_size = i_size_read(inode);
 		dout("sync_read %llu~%llu got %zd i_size %llu%s\n",
 		     off, len, ret, i_size, (more ? " MORE" : ""));
 
-		if (ret == -ENOENT)
+		/* Fix it to go to end of extent map */
+		if (sparse && ret >= 0)
+			ret = ceph_sparse_ext_map_end(op);
+		else if (ret == -ENOENT)
 			ret = 0;
+
+		ceph_osdc_put_request(req);
+
 		if (ret >= 0 && ret < len && (off + ret < i_size)) {
 			int zlen = min(len - ret, i_size - off - ret);
 			int zoff = page_off + ret;
+
 			dout("sync_read zero gap %llu~%llu\n",
-                             off + ret, off + ret + zlen);
+				off + ret, off + ret + zlen);
 			ceph_zero_page_vector_range(zoff, zlen, pages);
 			ret += zlen;
 		}
@@ -1105,8 +1123,10 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	struct inode *inode = req->r_inode;
 	struct ceph_aio_request *aio_req = req->r_priv;
 	struct ceph_osd_data *osd_data = osd_req_op_extent_osd_data(req, 0);
+	struct ceph_osd_req_op *op = &req->r_ops[0];
 	struct ceph_client_metric *metric = &ceph_sb_to_mdsc(inode->i_sb)->metric;
 	unsigned int len = osd_data->bvec_pos.iter.bi_size;
+	bool sparse = (op->op == CEPH_OSD_OP_SPARSE_READ);
 
 	BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_BVECS);
 	BUG_ON(!osd_data->num_bvecs);
@@ -1127,6 +1147,8 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 		}
 		rc = -ENOMEM;
 	} else if (!aio_req->write) {
+		if (sparse && rc >= 0)
+			rc = ceph_sparse_ext_map_end(op);
 		if (rc == -ENOENT)
 			rc = 0;
 		if (rc >= 0 && len > rc) {
@@ -1263,6 +1285,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 	loff_t pos = iocb->ki_pos;
 	bool write = iov_iter_rw(iter) == WRITE;
 	bool should_dirty = !write && iter_is_iovec(iter);
+	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
 
 	if (write && ceph_snap(file_inode(file)) != CEPH_NOSNAP)
 		return -EROFS;
@@ -1290,6 +1313,8 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 	while (iov_iter_count(iter) > 0) {
 		u64 size = iov_iter_count(iter);
 		ssize_t len;
+		struct ceph_osd_req_op *op;
+		int readop = sparse ?  CEPH_OSD_OP_SPARSE_READ : CEPH_OSD_OP_READ;
 
 		if (write)
 			size = min_t(u64, size, fsc->mount_options->wsize);
@@ -1300,8 +1325,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 		req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
 					    vino, pos, &size, 0,
 					    1,
-					    write ? CEPH_OSD_OP_WRITE :
-						    CEPH_OSD_OP_READ,
+					    write ? CEPH_OSD_OP_WRITE : readop,
 					    flags, snapc,
 					    ci->i_truncate_seq,
 					    ci->i_truncate_size,
@@ -1352,6 +1376,14 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 		}
 
 		osd_req_op_extent_osd_data_bvecs(req, 0, bvecs, num_pages, len);
+		op = &req->r_ops[0];
+		if (sparse) {
+			ret = ceph_alloc_sparse_ext_map(op);
+			if (ret) {
+				ceph_osdc_put_request(req);
+				break;
+			}
+		}
 
 		if (aio_req) {
 			aio_req->total_len += len;
@@ -1380,8 +1412,11 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 
 		size = i_size_read(inode);
 		if (!write) {
-			if (ret == -ENOENT)
+			if (sparse && ret >= 0)
+				ret = ceph_sparse_ext_map_end(op);
+			else if (ret == -ENOENT)
 				ret = 0;
+
 			if (ret >= 0 && ret < len && pos + ret < size) {
 				struct iov_iter i;
 				int zlen = min_t(size_t, len - ret,
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index b73b4f75462c..b03cd54006db 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -163,6 +163,7 @@ enum {
 	Opt_copyfrom,
 	Opt_wsync,
 	Opt_pagecache,
+	Opt_sparseread,
 };
 
 enum ceph_recover_session_mode {
@@ -205,6 +206,7 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
 	fsparam_u32	("wsize",			Opt_wsize),
 	fsparam_flag_no	("wsync",			Opt_wsync),
 	fsparam_flag_no	("pagecache",			Opt_pagecache),
+	fsparam_flag_no	("sparseread",			Opt_sparseread),
 	{}
 };
 
@@ -574,6 +576,12 @@ static int ceph_parse_mount_param(struct fs_context *fc,
 		else
 			fsopt->flags &= ~CEPH_MOUNT_OPT_NOPAGECACHE;
 		break;
+	case Opt_sparseread:
+		if (result.negated)
+			fsopt->flags &= ~CEPH_MOUNT_OPT_SPARSEREAD;
+		else
+			fsopt->flags |= CEPH_MOUNT_OPT_SPARSEREAD;
+		break;
 	default:
 		BUG();
 	}
@@ -708,9 +716,10 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
 
 	if (!(fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS))
 		seq_puts(m, ",wsync");
-
 	if (fsopt->flags & CEPH_MOUNT_OPT_NOPAGECACHE)
 		seq_puts(m, ",nopagecache");
+	if (fsopt->flags & CEPH_MOUNT_OPT_SPARSEREAD)
+		seq_puts(m, ",sparseread");
 
 	if (fsopt->wsize != CEPH_MAX_WRITE_SIZE)
 		seq_printf(m, ",wsize=%u", fsopt->wsize);
@@ -1291,6 +1300,11 @@ static int ceph_reconfigure_fc(struct fs_context *fc)
 	else
 		ceph_clear_mount_opt(fsc, ASYNC_DIROPS);
 
+	if (fsopt->flags & CEPH_MOUNT_OPT_SPARSEREAD)
+		ceph_set_mount_opt(fsc, SPARSEREAD);
+	else
+		ceph_clear_mount_opt(fsc, SPARSEREAD);
+
 	if (strcmp_null(fsc->mount_options->mon_addr, fsopt->mon_addr)) {
 		kfree(fsc->mount_options->mon_addr);
 		fsc->mount_options->mon_addr = fsopt->mon_addr;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 669036ebef1e..0c7a6fedc58a 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -41,6 +41,7 @@
 #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-from' op */
 #define CEPH_MOUNT_OPT_ASYNC_DIROPS    (1<<15) /* allow async directory ops */
 #define CEPH_MOUNT_OPT_NOPAGECACHE     (1<<16) /* bypass pagecache altogether */
+#define CEPH_MOUNT_OPT_SPARSEREAD      (1<<17) /* always do sparse reads */
 
 #define CEPH_MOUNT_OPT_DEFAULT			\
 	(CEPH_MOUNT_OPT_DCACHE |		\
-- 
2.35.1


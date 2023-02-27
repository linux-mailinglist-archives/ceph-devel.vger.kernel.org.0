Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98BF66A3983
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 04:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjB0D3g (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 22:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjB0D3d (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 22:29:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99203B77E
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 19:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677468527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xRu9dUa44KGUU8RUtEB5dMBoFGcezm8nAtjNNv8vrk0=;
        b=S0PzihpcYG58j6pmFB+v6rPjeAnfdLoSmwMmI5wm8ABsNvjpU9bKkQXPSu8rWFoOHWKHtv
        sUecXMBOrP/hzp9+dtkEZLHsT2kZWifhYLdi8UbJAWYlIptuFYS/LRj1ajfIZfrNm/OgLq
        Hs7/lnmvDE7Le3MT6szCaEDMsiXd65o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-zRIVHOofOqG_vKy0c6-9TQ-1; Sun, 26 Feb 2023 22:28:46 -0500
X-MC-Unique: zRIVHOofOqG_vKy0c6-9TQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F336B3C0D854;
        Mon, 27 Feb 2023 03:28:45 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21C3118EC2;
        Mon, 27 Feb 2023 03:28:42 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v16 07/68] ceph: add new mount option to enable sparse reads
Date:   Mon, 27 Feb 2023 11:27:12 +0800
Message-Id: <20230227032813.337906-8-xiubli@redhat.com>
In-Reply-To: <20230227032813.337906-1-xiubli@redhat.com>
References: <20230227032813.337906-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Add a new mount option that has the client issue sparse reads instead of
normal ones. The callers now preallocate an sparse extent buffer that
the libceph receive code can populate and hand back after the operation
completes.

After a successful sparse read, we can't use the req->r_result value to
determine the amount of data "read", so instead we set the received
length to be from the end of the last extent in the buffer. Any
interstitial holes will have been filled by the receive code.

[Xiubo: fix a double free for req bug reported by Ilya]

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c  | 15 +++++++++++++--
 fs/ceph/file.c  | 51 +++++++++++++++++++++++++++++++++++++++++--------
 fs/ceph/super.c | 16 +++++++++++++++-
 fs/ceph/super.h |  1 +
 4 files changed, 72 insertions(+), 11 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index cac4083e387a..e4fcfcf938d5 100644
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
@@ -312,6 +316,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	size_t page_off;
 	int err = 0;
 	u64 len = subreq->len;
+	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
 
 	if (ceph_inode_is_shutdown(inode)) {
 		err = -EIO;
@@ -322,7 +327,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 		return;
 
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout, vino, subreq->start, &len,
-			0, 1, CEPH_OSD_OP_READ,
+			0, 1, sparse ? CEPH_OSD_OP_SPARSE_READ : CEPH_OSD_OP_READ,
 			CEPH_OSD_FLAG_READ | fsc->client->osdc.client->options->read_from_replica,
 			NULL, ci->i_truncate_seq, ci->i_truncate_size, false);
 	if (IS_ERR(req)) {
@@ -331,6 +336,12 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 		goto out;
 	}
 
+	if (sparse) {
+		err = ceph_alloc_sparse_ext_map(&req->r_ops[0]);
+		if (err)
+			goto out;
+	}
+
 	dout("%s: pos=%llu orig_len=%zu len=%llu\n", __func__, subreq->start, subreq->len, len);
 	iov_iter_xarray(&iter, ITER_DEST, &rreq->mapping->i_pages, subreq->start, len);
 	err = iov_iter_get_pages_alloc2(&iter, &pages, len, &page_off);
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index dc39a4b0ec8e..2fa8635437c0 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -939,6 +939,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 	u64 off = iocb->ki_pos;
 	u64 len = iov_iter_count(to);
 	u64 i_size = i_size_read(inode);
+	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
 
 	dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
 	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
@@ -965,10 +966,12 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
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
@@ -989,6 +992,16 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 
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
 		ceph_osdc_start_request(osdc, req);
 		ret = ceph_osdc_wait_request(osdc, req);
 
@@ -997,19 +1010,24 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
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
@@ -1128,8 +1146,10 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	struct inode *inode = req->r_inode;
 	struct ceph_aio_request *aio_req = req->r_priv;
 	struct ceph_osd_data *osd_data = osd_req_op_extent_osd_data(req, 0);
+	struct ceph_osd_req_op *op = &req->r_ops[0];
 	struct ceph_client_metric *metric = &ceph_sb_to_mdsc(inode->i_sb)->metric;
 	unsigned int len = osd_data->bvec_pos.iter.bi_size;
+	bool sparse = (op->op == CEPH_OSD_OP_SPARSE_READ);
 
 	BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_BVECS);
 	BUG_ON(!osd_data->num_bvecs);
@@ -1150,6 +1170,8 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 		}
 		rc = -ENOMEM;
 	} else if (!aio_req->write) {
+		if (sparse && rc >= 0)
+			rc = ceph_sparse_ext_map_end(op);
 		if (rc == -ENOENT)
 			rc = 0;
 		if (rc >= 0 && len > rc) {
@@ -1286,6 +1308,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 	loff_t pos = iocb->ki_pos;
 	bool write = iov_iter_rw(iter) == WRITE;
 	bool should_dirty = !write && user_backed_iter(iter);
+	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
 
 	if (write && ceph_snap(file_inode(file)) != CEPH_NOSNAP)
 		return -EROFS;
@@ -1313,6 +1336,8 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 	while (iov_iter_count(iter) > 0) {
 		u64 size = iov_iter_count(iter);
 		ssize_t len;
+		struct ceph_osd_req_op *op;
+		int readop = sparse ?  CEPH_OSD_OP_SPARSE_READ : CEPH_OSD_OP_READ;
 
 		if (write)
 			size = min_t(u64, size, fsc->mount_options->wsize);
@@ -1323,8 +1348,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 		req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
 					    vino, pos, &size, 0,
 					    1,
-					    write ? CEPH_OSD_OP_WRITE :
-						    CEPH_OSD_OP_READ,
+					    write ? CEPH_OSD_OP_WRITE : readop,
 					    flags, snapc,
 					    ci->i_truncate_seq,
 					    ci->i_truncate_size,
@@ -1375,6 +1399,14 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
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
@@ -1402,8 +1434,11 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 
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
index 3fc48b43cab0..7aaf40669509 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -165,6 +165,7 @@ enum {
 	Opt_copyfrom,
 	Opt_wsync,
 	Opt_pagecache,
+	Opt_sparseread,
 };
 
 enum ceph_recover_session_mode {
@@ -207,6 +208,7 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
 	fsparam_u32	("wsize",			Opt_wsize),
 	fsparam_flag_no	("wsync",			Opt_wsync),
 	fsparam_flag_no	("pagecache",			Opt_pagecache),
+	fsparam_flag_no	("sparseread",			Opt_sparseread),
 	{}
 };
 
@@ -576,6 +578,12 @@ static int ceph_parse_mount_param(struct fs_context *fc,
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
@@ -710,9 +718,10 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
 
 	if (!(fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS))
 		seq_puts(m, ",wsync");
-
 	if (fsopt->flags & CEPH_MOUNT_OPT_NOPAGECACHE)
 		seq_puts(m, ",nopagecache");
+	if (fsopt->flags & CEPH_MOUNT_OPT_SPARSEREAD)
+		seq_puts(m, ",sparseread");
 
 	if (fsopt->wsize != CEPH_MAX_WRITE_SIZE)
 		seq_printf(m, ",wsize=%u", fsopt->wsize);
@@ -1296,6 +1305,11 @@ static int ceph_reconfigure_fc(struct fs_context *fc)
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
index 86289ba8bf94..a5f6bd149fa3 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -42,6 +42,7 @@
 #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-from' op */
 #define CEPH_MOUNT_OPT_ASYNC_DIROPS    (1<<15) /* allow async directory ops */
 #define CEPH_MOUNT_OPT_NOPAGECACHE     (1<<16) /* bypass pagecache altogether */
+#define CEPH_MOUNT_OPT_SPARSEREAD      (1<<17) /* always do sparse reads */
 
 #define CEPH_MOUNT_OPT_DEFAULT			\
 	(CEPH_MOUNT_OPT_DCACHE |		\
-- 
2.31.1


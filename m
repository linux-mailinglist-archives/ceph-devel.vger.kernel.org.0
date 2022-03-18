Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F994DDAE9
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Mar 2022 14:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236863AbiCRNvy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 18 Mar 2022 09:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236876AbiCRNvo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 18 Mar 2022 09:51:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9D69F6EC
        for <ceph-devel@vger.kernel.org>; Fri, 18 Mar 2022 06:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB49FB823C4
        for <ceph-devel@vger.kernel.org>; Fri, 18 Mar 2022 13:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1212C340EF;
        Fri, 18 Mar 2022 13:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647611418;
        bh=gK5Wf0LlOqUo00IfDM7Lm+COPMlE0lbdGHsU8Ublu1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZt/+AYNi6MeYRCSnXiLE2OvYrIC+lns42FvK334TQORmPlTj6HUsqLTsniDdfafD
         EiTVRhRo9ZIw9KBIQxN4RYDfZixByFwcvhBPulB+yeaxLMC4iW1zHGXpRIAozmykcY
         ACwiQxLu/lCyO+ZpiAqpkBvEQi9sdNkKIoK4hMB6HaT1ThrsSEzh0j9Axb9F253k0T
         snasxOak/Gz5Zw8pfFDykRyjobvRrNBdg1J4Dcb/OmO/Wh1pTNFiq1v+MmOG7/4AP+
         Yw/zzPM+Ba+8YFx7O8hQJbq+oaPTDURvGGQAiMSO16ULnZVvKNKKlcut9iYzQYRkiA
         Q4UCLqQO17b/w==
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@gmail.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org
Subject: [PATCH v3 5/5] ceph: convert to sparse reads
Date:   Fri, 18 Mar 2022 09:50:13 -0400
Message-Id: <20220318135013.43934-6-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220318135013.43934-1-jlayton@kernel.org>
References: <20220318135013.43934-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Have ceph issue sparse reads instead of normal ones. The callers now
preallocate an sparse extent buffer that the libceph receive code can
populate and hand back after the operation completes.

After a successful read, we can't use the req->r_result value to
determine the amount of data "read", so instead we set the received
length to be from the end of the last extent in the buffer. Any
interstitial holes will have been filled by the receive code.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c  | 13 +++++++++++--
 fs/ceph/file.c  | 41 ++++++++++++++++++++++++++++++++++-------
 fs/ceph/super.h |  7 +++++++
 3 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 752c421c9922..6d4f9fbf22ce 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -220,6 +220,7 @@ static void finish_netfs_read(struct ceph_osd_request *req)
 	struct ceph_fs_client *fsc = ceph_inode_to_client(req->r_inode);
 	struct ceph_osd_data *osd_data = osd_req_op_extent_osd_data(req, 0);
 	struct netfs_read_subrequest *subreq = req->r_priv;
+	struct ceph_osd_req_op *op = &req->r_ops[0];
 	int num_pages;
 	int err = req->r_result;
 
@@ -230,7 +231,9 @@ static void finish_netfs_read(struct ceph_osd_request *req)
 	     subreq->len, i_size_read(req->r_inode));
 
 	/* no object means success but no data */
-	if (err == -ENOENT)
+	if (err >= 0)
+		err = ceph_sparse_ext_map_end(op);
+	else if (err == -ENOENT)
 		err = 0;
 	else if (err == -EBLOCKLISTED)
 		fsc->blocklisted = true;
@@ -317,7 +320,7 @@ static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
 		return;
 
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout, vino, subreq->start, &len,
-			0, 1, CEPH_OSD_OP_READ,
+			0, 1, CEPH_OSD_OP_SPARSE_READ,
 			CEPH_OSD_FLAG_READ | fsc->client->osdc.client->options->read_from_replica,
 			NULL, ci->i_truncate_seq, ci->i_truncate_size, false);
 	if (IS_ERR(req)) {
@@ -326,6 +329,12 @@ static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
 		goto out;
 	}
 
+	err = ceph_alloc_sparse_ext_map(&req->r_ops[0], CEPH_SPARSE_EXT_ARRAY_INITIAL);
+	if (err) {
+		ceph_osdc_put_request(req);
+		goto out;
+	}
+
 	dout("%s: pos=%llu orig_len=%zu len=%llu\n", __func__, subreq->start, subreq->len, len);
 	iov_iter_xarray(&iter, READ, &rreq->mapping->i_pages, subreq->start, len);
 	err = iov_iter_get_pages_alloc(&iter, &pages, len, &page_off);
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index feb75eb1cd82..deba39989a07 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -931,10 +931,11 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 		bool more;
 		int idx;
 		size_t left;
+		struct ceph_osd_req_op *op;
 
 		req = ceph_osdc_new_request(osdc, &ci->i_layout,
 					ci->i_vino, off, &len, 0, 1,
-					CEPH_OSD_OP_READ, CEPH_OSD_FLAG_READ,
+					CEPH_OSD_OP_SPARSE_READ, CEPH_OSD_FLAG_READ,
 					NULL, ci->i_truncate_seq,
 					ci->i_truncate_size, false);
 		if (IS_ERR(req)) {
@@ -955,6 +956,14 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 
 		osd_req_op_extent_osd_data_pages(req, 0, pages, len, page_off,
 						 false, false);
+
+		op = &req->r_ops[0];
+		ret = ceph_alloc_sparse_ext_map(op, CEPH_SPARSE_EXT_ARRAY_INITIAL);
+		if (ret) {
+			ceph_osdc_put_request(req);
+			break;
+		}
+
 		ret = ceph_osdc_start_request(osdc, req, false);
 		if (!ret)
 			ret = ceph_osdc_wait_request(osdc, req);
@@ -964,23 +973,28 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 					 req->r_end_latency,
 					 len, ret);
 
-		ceph_osdc_put_request(req);
-
 		i_size = i_size_read(inode);
 		dout("sync_read %llu~%llu got %zd i_size %llu%s\n",
 		     off, len, ret, i_size, (more ? " MORE" : ""));
 
-		if (ret == -ENOENT)
+		/* Fix it to go to end of extent map */
+		if (ret >= 0)
+			ret = ceph_sparse_ext_map_end(op);
+		else if (ret == -ENOENT)
 			ret = 0;
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
 
+		ceph_osdc_put_request(req);
+
 		idx = 0;
 		left = ret > 0 ? ret : 0;
 		while (left > 0) {
@@ -1095,6 +1109,7 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	struct inode *inode = req->r_inode;
 	struct ceph_aio_request *aio_req = req->r_priv;
 	struct ceph_osd_data *osd_data = osd_req_op_extent_osd_data(req, 0);
+	struct ceph_osd_req_op *op = &req->r_ops[0];
 	struct ceph_client_metric *metric = &ceph_sb_to_mdsc(inode->i_sb)->metric;
 	unsigned int len = osd_data->bvec_pos.iter.bi_size;
 
@@ -1117,6 +1132,8 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 		}
 		rc = -ENOMEM;
 	} else if (!aio_req->write) {
+		if (rc >= 0)
+			rc = ceph_sparse_ext_map_end(op);
 		if (rc == -ENOENT)
 			rc = 0;
 		if (rc >= 0 && len > rc) {
@@ -1280,6 +1297,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 	while (iov_iter_count(iter) > 0) {
 		u64 size = iov_iter_count(iter);
 		ssize_t len;
+		struct ceph_osd_req_op *op;
 
 		if (write)
 			size = min_t(u64, size, fsc->mount_options->wsize);
@@ -1291,7 +1309,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 					    vino, pos, &size, 0,
 					    1,
 					    write ? CEPH_OSD_OP_WRITE :
-						    CEPH_OSD_OP_READ,
+						    CEPH_OSD_OP_SPARSE_READ,
 					    flags, snapc,
 					    ci->i_truncate_seq,
 					    ci->i_truncate_size,
@@ -1342,6 +1360,12 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 		}
 
 		osd_req_op_extent_osd_data_bvecs(req, 0, bvecs, num_pages, len);
+		op = &req->r_ops[0];
+		ret = ceph_alloc_sparse_ext_map(op, CEPH_SPARSE_EXT_ARRAY_INITIAL);
+		if (ret) {
+			ceph_osdc_put_request(req);
+			break;
+		}
 
 		if (aio_req) {
 			aio_req->total_len += len;
@@ -1370,8 +1394,11 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 
 		size = i_size_read(inode);
 		if (!write) {
-			if (ret == -ENOENT)
+			if (ret >= 0)
+				ret = ceph_sparse_ext_map_end(op);
+			else if (ret == -ENOENT)
 				ret = 0;
+
 			if (ret >= 0 && ret < len && pos + ret < size) {
 				struct iov_iter i;
 				int zlen = min_t(size_t, len - ret,
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 250aefecd628..ad09c26afac6 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -75,6 +75,13 @@
 #define CEPH_CAPS_WANTED_DELAY_MIN_DEFAULT      5  /* cap release delay */
 #define CEPH_CAPS_WANTED_DELAY_MAX_DEFAULT     60  /* cap release delay */
 
+/*
+ * How big an extent array should we preallocate for a sparse read? This is
+ * just a starting value.  If we get more than this back from the OSD, the
+ * receiver will reallocate.
+ */
+#define CEPH_SPARSE_EXT_ARRAY_INITIAL	16
+
 struct ceph_mount_options {
 	unsigned int flags;
 
-- 
2.35.1


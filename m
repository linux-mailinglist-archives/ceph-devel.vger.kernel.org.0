Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB40D4EF10E
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Apr 2022 16:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347787AbiDAOgD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 1 Apr 2022 10:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347672AbiDAOd2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 1 Apr 2022 10:33:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC29825A4B8
        for <ceph-devel@vger.kernel.org>; Fri,  1 Apr 2022 07:30:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E249B8250D
        for <ceph-devel@vger.kernel.org>; Fri,  1 Apr 2022 14:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78ED6C340EE;
        Fri,  1 Apr 2022 14:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823429;
        bh=bCLPElYR2G3TnjFxy/gUBVyqZWhCgRYui1vSVkt+hZI=;
        h=From:To:Cc:Subject:Date:From;
        b=asC3rQl6eIVvCAC0UZAT5SgZYOTwKJi1AWX7TKNrQKU2u9LF0BdPsCz4UDB69nM3b
         f1lm4TQF66+Q0aVMAPJvHeOZ/69A5fR5joQTknrEclwQzorKyo8yUNS1va5C/jjYw+
         8kGk99X1Zj/j9XMGg256E6QmNTbm8UttW50rlZLd+t2zqgsy55oPwxZLrFehwryzWd
         8pBKRMAAkUB+swKZnOT1/evXxpGvNP7duslBkPqHu5sEU4K0eWP20qDlhQs/mxav99
         iX4k/00FzuvS0tKfheQUTFxnMZ3mpzs/eMOWffeDlhzBruBzVtd9LQL9Wa+xCjuNnN
         n/ZITSeNbixvw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, xiubli@redhat.com
Subject: [PATCH] ceph: rework ceph_alloc_sparse_ext_map
Date:   Fri,  1 Apr 2022 10:30:28 -0400
Message-Id: <20220401143028.22039-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
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

Make it a wrapper around a version that requires a length and just have
it default to CEPH_SPARSE_EXT_ARRAY_INITIAL.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c                  |  3 +--
 fs/ceph/file.c                  |  8 ++++----
 fs/ceph/super.h                 |  7 -------
 include/linux/ceph/osd_client.h | 14 +++++++++++++-
 net/ceph/osd_client.c           |  4 ++--
 5 files changed, 20 insertions(+), 16 deletions(-)

Another one for the sparse_read series. Again, I'll probably fold this
into the appropriate patches and re-push into testing.

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index cc4f561bd03c..b85eb4963e57 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -346,8 +346,7 @@ static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
 	}
 
 	if (sparse) {
-		err = ceph_alloc_sparse_ext_map(&req->r_ops[0],
-					CEPH_SPARSE_EXT_ARRAY_INITIAL);
+		err = ceph_alloc_sparse_ext_map(&req->r_ops[0]);
 		if (err) {
 			ceph_osdc_put_request(req);
 			goto out;
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 5072570c2203..64580a2edc1b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1009,7 +1009,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 
 		op = &req->r_ops[0];
 		if (sparse) {
-			ret = ceph_alloc_sparse_ext_map(op, CEPH_SPARSE_EXT_ARRAY_INITIAL);
+			ret = ceph_alloc_sparse_ext_map(op);
 			if (ret) {
 				ceph_osdc_put_request(req);
 				break;
@@ -1462,7 +1462,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 		osd_req_op_extent_osd_data_bvecs(req, 0, bvecs, num_pages, len);
 		op = &req->r_ops[0];
 		if (sparse) {
-			ret = ceph_alloc_sparse_ext_map(op, CEPH_SPARSE_EXT_ARRAY_INITIAL);
+			ret = ceph_alloc_sparse_ext_map(op);
 			if (ret) {
 				ceph_osdc_put_request(req);
 				break;
@@ -1708,7 +1708,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 							 offset_in_page(first_pos),
 							 false, false);
 				/* We only expect a single extent here */
-				ret = ceph_alloc_sparse_ext_map(op, 1);
+				ret = __ceph_alloc_sparse_ext_map(op, 1);
 				if (ret) {
 					ceph_osdc_put_request(req);
 					ceph_release_page_vector(pages, num_pages);
@@ -1727,7 +1727,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 							ci->i_truncate_seq);
 				}
 
-				ret = ceph_alloc_sparse_ext_map(op, 1);
+				ret = __ceph_alloc_sparse_ext_map(op, 1);
 				if (ret) {
 					ceph_osdc_put_request(req);
 					ceph_release_page_vector(pages, num_pages);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index d626d228bacc..e847afb8448f 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -81,13 +81,6 @@
 #define CEPH_CAPS_WANTED_DELAY_MIN_DEFAULT      5  /* cap release delay */
 #define CEPH_CAPS_WANTED_DELAY_MAX_DEFAULT     60  /* cap release delay */
 
-/*
- * How big an extent array should we preallocate for a sparse read? This is
- * just a starting value.  If we get more than this back from the OSD, the
- * receiver will reallocate.
- */
-#define CEPH_SPARSE_EXT_ARRAY_INITIAL	16
-
 struct ceph_mount_options {
 	unsigned int flags;
 
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index df092b678d58..8c7f34df66d3 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -556,7 +556,19 @@ extern struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *,
 				      u32 truncate_seq, u64 truncate_size,
 				      bool use_mempool);
 
-int ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op, int cnt);
+int __ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op, int cnt);
+
+/*
+ * How big an extent array should we preallocate for a sparse read? This is
+ * just a starting value.  If we get more than this back from the OSD, the
+ * receiver will reallocate.
+ */
+#define CEPH_SPARSE_EXT_ARRAY_INITIAL  16
+
+static inline int ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op)
+{
+	return __ceph_alloc_sparse_ext_map(op, CEPH_SPARSE_EXT_ARRAY_INITIAL);
+}
 
 extern void ceph_osdc_get_request(struct ceph_osd_request *req);
 extern void ceph_osdc_put_request(struct ceph_osd_request *req);
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 5cb7635bb457..39d38b69a953 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1165,7 +1165,7 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 }
 EXPORT_SYMBOL(ceph_osdc_new_request);
 
-int ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op, int cnt)
+int __ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op, int cnt)
 {
 	op->extent.sparse_ext_cnt = cnt;
 	op->extent.sparse_ext = kmalloc_array(cnt,
@@ -1175,7 +1175,7 @@ int ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op, int cnt)
 		return -ENOMEM;
 	return 0;
 }
-EXPORT_SYMBOL(ceph_alloc_sparse_ext_map);
+EXPORT_SYMBOL(__ceph_alloc_sparse_ext_map);
 
 /*
  * We keep osd requests in an rbtree, sorted by ->r_tid.
-- 
2.35.1


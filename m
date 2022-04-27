Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9EC5122A1
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbiD0T2O (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbiD0TTL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEB385675
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1FCCDCE26AE
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E70C385AE;
        Wed, 27 Apr 2022 19:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086798;
        bh=WUMUKws9bRjZTrkHwsGynA7tUQA6j+UO+nipvx8/Pxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ttCPUSjvROgS1nCoom2Tyg3/s8JyW2YH/V/KhtWfndc7WEFNHgbZsYqON+fBAXoGf
         7tF+3zSWrdZWUr1E/cAxPRRjKwZeLbhsEhxtsJgOEtGZitBZN0BiMyUnefUsj8IY95
         Z2IoVfeNtVqCaY7WWN1TCkM/SIFk+z0Q+RBWHhTbJPdrlRMbEHBhGnFQdViZnApMxr
         eAcfUma+XgXlAv4hejyF1IwE3UkleCaBDnuTmi5j0W1U06XNZF7ZZsEg3QBuRdzxs2
         tm7Sm9BPoHX+fSFOW5wi7O/vnfoq0hfdl6fvRLO8P7XOiqx2fpN4jbO+36Qxc4H/ZB
         ZOifSoab6/CZg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 02/64] libceph: define struct ceph_sparse_extent and add some helpers
Date:   Wed, 27 Apr 2022 15:12:12 -0400
Message-Id: <20220427191314.222867-3-jlayton@kernel.org>
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

When the OSD sends back a sparse read reply, it contains an array of
these structures. Define the structure and add a couple of helpers for
dealing with them.

Also add a place in struct ceph_osd_req_op to store the extent buffer,
and code to free it if it's populated when the req is torn down.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/osd_client.h | 43 ++++++++++++++++++++++++++++++++-
 net/ceph/osd_client.c           | 13 ++++++++++
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 3122c1a3205f..1dd02240d00d 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -29,6 +29,17 @@ typedef void (*ceph_osdc_callback_t)(struct ceph_osd_request *);
 
 #define CEPH_HOMELESS_OSD	-1
 
+/*
+ * A single extent in a SPARSE_READ reply.
+ *
+ * Note that these come from the OSD as little-endian values. On BE arches,
+ * we convert them in-place after receipt.
+ */
+struct ceph_sparse_extent {
+	u64	off;
+	u64	len;
+} __packed;
+
 /*
  * A given osd we're communicating with.
  *
@@ -104,6 +115,8 @@ struct ceph_osd_req_op {
 			u64 offset, length;
 			u64 truncate_size;
 			u32 truncate_seq;
+			int sparse_ext_cnt;
+			struct ceph_sparse_extent *sparse_ext;
 			struct ceph_osd_data osd_data;
 		} extent;
 		struct {
@@ -507,6 +520,20 @@ extern struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *,
 				      u32 truncate_seq, u64 truncate_size,
 				      bool use_mempool);
 
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
+
 extern void ceph_osdc_get_request(struct ceph_osd_request *req);
 extern void ceph_osdc_put_request(struct ceph_osd_request *req);
 
@@ -562,5 +589,19 @@ int ceph_osdc_list_watchers(struct ceph_osd_client *osdc,
 			    struct ceph_object_locator *oloc,
 			    struct ceph_watch_item **watchers,
 			    u32 *num_watchers);
-#endif
 
+/* Find offset into the buffer of the end of the extent map */
+static inline u64 ceph_sparse_ext_map_end(struct ceph_osd_req_op *op)
+{
+	struct ceph_sparse_extent *ext;
+
+	/* No extents? No data */
+	if (op->extent.sparse_ext_cnt == 0)
+		return 0;
+
+	ext = &op->extent.sparse_ext[op->extent.sparse_ext_cnt - 1];
+
+	return ext->off + ext->len - op->extent.offset;
+}
+
+#endif
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 17c792b32343..c150683f2a2f 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -378,6 +378,7 @@ static void osd_req_op_data_release(struct ceph_osd_request *osd_req,
 	case CEPH_OSD_OP_READ:
 	case CEPH_OSD_OP_WRITE:
 	case CEPH_OSD_OP_WRITEFULL:
+		kfree(op->extent.sparse_ext);
 		ceph_osd_data_release(&op->extent.osd_data);
 		break;
 	case CEPH_OSD_OP_CALL:
@@ -1141,6 +1142,18 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 }
 EXPORT_SYMBOL(ceph_osdc_new_request);
 
+int __ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op, int cnt)
+{
+	op->extent.sparse_ext_cnt = cnt;
+	op->extent.sparse_ext = kmalloc_array(cnt,
+					      sizeof(*op->extent.sparse_ext),
+					      GFP_NOFS);
+	if (!op->extent.sparse_ext)
+		return -ENOMEM;
+	return 0;
+}
+EXPORT_SYMBOL(__ceph_alloc_sparse_ext_map);
+
 /*
  * We keep osd requests in an rbtree, sorted by ->r_tid.
  */
-- 
2.35.1


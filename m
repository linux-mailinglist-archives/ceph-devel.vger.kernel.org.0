Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB844DDAE4
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Mar 2022 14:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbiCRNvo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 18 Mar 2022 09:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236855AbiCRNvg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 18 Mar 2022 09:51:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83041F1E9F
        for <ceph-devel@vger.kernel.org>; Fri, 18 Mar 2022 06:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21AF6619EC
        for <ceph-devel@vger.kernel.org>; Fri, 18 Mar 2022 13:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C7EC340EF;
        Fri, 18 Mar 2022 13:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647611416;
        bh=IYwMIJZ74tBWt7+9o48N6BNBxfWNUhXuQUcFr3k9WvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UmMSWxFb8+nb97UcDA5ODNe4OURRxppumAb/T3+ScUJ8ZSfz1m5xRrgUtOtrw/4t/
         kxQI5yP7g2IhlpUqnkrLDUo8jx0wxasDeu0ZxNP7bYiRjVGbS5lCnZSDqBMpCPhwuu
         DhB+9yrLazOogIqF4p9Bhh4ehnEuA6fwbBkvB5PU6R5pRqyjUTwV5p4Ejl5N4oR8dE
         mt85nj+KffpwZb5bab2Zua9knas/yq+C9yBg2r/NGokQdV8/cP8tYZTspt/ySgdSH4
         9Eotr2f/lwkqbJtzd9unwEVIRB8bXHJMM4rGHq7hdEQlVlvx3KXqfolnZQwpnmHho3
         jNDVd12xfWGfw==
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@gmail.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org
Subject: [PATCH v3 2/5] libceph: define struct ceph_sparse_extent and add some helpers
Date:   Fri, 18 Mar 2022 09:50:10 -0400
Message-Id: <20220318135013.43934-3-jlayton@kernel.org>
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

When the OSD sends back a sparse read reply, it contains an array of
these structures. Define the structure and add a couple of helpers for
dealing with them.

Also add a place in struct ceph_osd_req_op to store the extent buffer,
and code to free it if it's populated when the req is torn down.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/osd_client.h | 31 ++++++++++++++++++++++++++++++-
 net/ceph/osd_client.c           | 13 +++++++++++++
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 3122c1a3205f..00a5b53a6763 100644
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
+} __attribute__((packed));
+
 /*
  * A given osd we're communicating with.
  *
@@ -104,6 +115,8 @@ struct ceph_osd_req_op {
 			u64 offset, length;
 			u64 truncate_size;
 			u32 truncate_seq;
+			int sparse_ext_len;
+			struct ceph_sparse_extent *sparse_ext;
 			struct ceph_osd_data osd_data;
 		} extent;
 		struct {
@@ -507,6 +520,8 @@ extern struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *,
 				      u32 truncate_seq, u64 truncate_size,
 				      bool use_mempool);
 
+int ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op, int len);
+
 extern void ceph_osdc_get_request(struct ceph_osd_request *req);
 extern void ceph_osdc_put_request(struct ceph_osd_request *req);
 
@@ -562,5 +577,19 @@ int ceph_osdc_list_watchers(struct ceph_osd_client *osdc,
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
+	if (op->extent.sparse_ext_len == 0)
+		return 0;
+
+	ext = &op->extent.sparse_ext[op->extent.sparse_ext_len - 1];
+
+	return ext->off + ext->len - op->extent.offset;
+}
+
+#endif
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 1e8842ef6e63..9fec258e1f8d 100644
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
 
+int ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op, int len)
+{
+	op->extent.sparse_ext_len = len;
+	op->extent.sparse_ext = kmalloc_array(len,
+					sizeof(*op->extent.sparse_ext),
+					GFP_NOFS);
+	if (!op->extent.sparse_ext)
+		return -ENOMEM;
+	return 0;
+}
+EXPORT_SYMBOL(ceph_alloc_sparse_ext_map);
+
 /*
  * We keep osd requests in an rbtree, sorted by ->r_tid.
  */
-- 
2.35.1


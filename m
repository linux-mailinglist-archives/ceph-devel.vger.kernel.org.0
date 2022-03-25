Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7142E4E704B
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Mar 2022 10:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358549AbiCYJwP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 25 Mar 2022 05:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358541AbiCYJwM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 25 Mar 2022 05:52:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7223C4E23
        for <ceph-devel@vger.kernel.org>; Fri, 25 Mar 2022 02:50:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6423460BC9
        for <ceph-devel@vger.kernel.org>; Fri, 25 Mar 2022 09:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72517C340F0;
        Fri, 25 Mar 2022 09:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648201837;
        bh=dPoI6AefngWs4/IUGOMuYd3gvCyB+twacXOgx9X1qms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZydHZBP+HMjzi7shhhzTTli5xt2eRBBUKaAfJL7XCfCi5M4SOi22779890J2vP1HB
         1uT8wTY/iGXyOCj+qJh5Cgswye90zW8KR2su6RI3OKgFUT8Rh7sZFOoqXxB1NlUcSR
         fZcRUAqpeXynwiO4SmAwUWqjOq8/sCSvAhrz8VdjrEwm7f/WBXiGGrd3CPwKVxbxDn
         ncrV8n+rGcEr/DY5aN9zfAyBgY8uyiVjjBfAUA37vboX2tKBKlD/F3hCqDJ1SpsKES
         Ejw59J/6hA5akZ3BhMD5P1QFk8pCmfvST/VvYaqg2kj8afgio3YpTTM60hBG+111/U
         yxSPqLxvAPPBQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@gmail.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org
Subject: [PATCH v5 2/7] libceph: define struct ceph_sparse_extent and add some helpers
Date:   Fri, 25 Mar 2022 05:50:29 -0400
Message-Id: <20220325095034.5217-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325095034.5217-1-jlayton@kernel.org>
References: <20220325095034.5217-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/osd_client.h | 31 ++++++++++++++++++++++++++++++-
 net/ceph/osd_client.c           | 13 +++++++++++++
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 3122c1a3205f..12f38295693d 100644
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
@@ -507,6 +520,8 @@ extern struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *,
 				      u32 truncate_seq, u64 truncate_size,
 				      bool use_mempool);
 
+int ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op, int cnt);
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
index 17c792b32343..7fc96c98c17b 100644
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
 
+int ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op, int cnt)
+{
+	op->extent.sparse_ext_cnt = cnt;
+	op->extent.sparse_ext = kmalloc_array(cnt,
+					      sizeof(*op->extent.sparse_ext),
+					      GFP_NOFS);
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


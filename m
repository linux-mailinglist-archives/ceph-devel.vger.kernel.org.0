Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6746C600E
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Mar 2023 07:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjCWG4g (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Mar 2023 02:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjCWG4d (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Mar 2023 02:56:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5FF2BF3B
        for <ceph-devel@vger.kernel.org>; Wed, 22 Mar 2023 23:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679554547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m4H53q6NuDTg6nN48rwKN2lUH52K1rIb9n41uAG5mW4=;
        b=UaAPtOmD0+guoiPHAVJwmvl3i5MRyEhAxocILaHb3dXeWM+GGjiL1SpRuPynU8JimWYUMI
        8qUAqFHL+zvzXZRcBubP7FIc1bdKwLfXZT925ej+65U4FCsRscUx1+SwsFPHIMj6by9wGb
        +WA5q3Hms9yOxysQ2nXhctY7KRsQR7E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-H6IdnlZ3P-6SldQMr8oT5Q-1; Thu, 23 Mar 2023 02:55:46 -0400
X-MC-Unique: H6IdnlZ3P-6SldQMr8oT5Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D24D3C0ED69;
        Thu, 23 Mar 2023 06:55:45 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C16DC492B01;
        Thu, 23 Mar 2023 06:55:42 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v17 02/71] libceph: define struct ceph_sparse_extent and add some helpers
Date:   Thu, 23 Mar 2023 14:54:16 +0800
Message-Id: <20230323065525.201322-3-xiubli@redhat.com>
In-Reply-To: <20230323065525.201322-1-xiubli@redhat.com>
References: <20230323065525.201322-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

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
index 92addef18738..05da1e755b7b 100644
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
@@ -510,6 +523,20 @@ extern struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *,
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
 
@@ -564,5 +591,19 @@ int ceph_osdc_list_watchers(struct ceph_osd_client *osdc,
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
index a827995faba7..e2f1d1dcbb84 100644
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
@@ -1120,6 +1121,18 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
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
2.31.1


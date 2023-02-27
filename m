Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6960E6A397D
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 04:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjB0D3W (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 22:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjB0D3V (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 22:29:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E95BB772
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 19:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677468512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m4H53q6NuDTg6nN48rwKN2lUH52K1rIb9n41uAG5mW4=;
        b=dscnb/cW22zzlSfdUHJJ+5C2Gbg9UKhZdd/iUEcJbm+dDyJV2epDRcN6UPCsbQE2mrZF1f
        nnb8YjNjGqBRjJa9BiakCFxRcjSNTRWgjnlL7D451VSXAS8GDgVSYsVu1P5y82LArw+G3j
        /cMm8j4pHdFQq0xkEf0b//cqne285yY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-MeLTrmiFMaqtNuz51tavNw-1; Sun, 26 Feb 2023 22:28:29 -0500
X-MC-Unique: MeLTrmiFMaqtNuz51tavNw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8A5B185A7A4;
        Mon, 27 Feb 2023 03:28:28 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 15A9318EC2;
        Mon, 27 Feb 2023 03:28:25 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v16 02/68] libceph: define struct ceph_sparse_extent and add some helpers
Date:   Mon, 27 Feb 2023 11:27:07 +0800
Message-Id: <20230227032813.337906-3-xiubli@redhat.com>
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


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B40DA6A397E
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 04:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjB0D3Y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 22:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjB0D3V (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 22:29:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D23C166
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 19:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677468520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4M60loLl2b7Jagtbp7ydgwvtv1ClWFhcZ01EfaLHers=;
        b=MDgqC3XPa3eONGvECBhvtlMGZ7GaIr/HUzW54yDBc8HuFCsjgQbOaTHIf4SRrGZvmXGnUZ
        jj1vPpTxW3xUGHzmR75rZX7zm+n/VEvoQR6v1DDqALoBk7lFXYg7hYFD+y4Ax9diFOuPC8
        hLjfM2hMsnELYZslRehUE0+lxqvyfwU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-zFOQxyBwMv2KPppM-lnD8w-1; Sun, 26 Feb 2023 22:28:36 -0500
X-MC-Unique: zFOQxyBwMv2KPppM-lnD8w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD4AE29AA38B;
        Mon, 27 Feb 2023 03:28:35 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF26718EC2;
        Mon, 27 Feb 2023 03:28:32 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v16 04/68] libceph: add sparse read support to OSD client
Date:   Mon, 27 Feb 2023 11:27:09 +0800
Message-Id: <20230227032813.337906-5-xiubli@redhat.com>
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

Have get_reply check for the presence of sparse read ops in the
request and set the sparse_read boolean in the msg. That will queue the
messenger layer to use the sparse read codepath instead of the normal
data receive.

Add a new sparse_read operation for the OSD client, driven by its own
state machine. The messenger will repeatedly call the sparse_read
operation, and it will pass back the necessary info to set up to read
the next extent of data, while zero-filling the sparse regions.

The state machine will stop at the end of the last extent, and will
attach the extent map buffer to the ceph_osd_req_op so that the caller
can use it.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/osd_client.h |  32 ++++
 net/ceph/osd_client.c           | 255 +++++++++++++++++++++++++++++++-
 2 files changed, 283 insertions(+), 4 deletions(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 05da1e755b7b..460881c93f9a 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -40,6 +40,36 @@ struct ceph_sparse_extent {
 	u64	len;
 } __packed;
 
+/* Sparse read state machine state values */
+enum ceph_sparse_read_state {
+	CEPH_SPARSE_READ_HDR	= 0,
+	CEPH_SPARSE_READ_EXTENTS,
+	CEPH_SPARSE_READ_DATA_LEN,
+	CEPH_SPARSE_READ_DATA,
+};
+
+/*
+ * A SPARSE_READ reply is a 32-bit count of extents, followed by an array of
+ * 64-bit offset/length pairs, and then all of the actual file data
+ * concatenated after it (sans holes).
+ *
+ * Unfortunately, we don't know how long the extent array is until we've
+ * started reading the data section of the reply. The caller should send down
+ * a destination buffer for the array, but we'll alloc one if it's too small
+ * or if the caller doesn't.
+ */
+struct ceph_sparse_read {
+	enum ceph_sparse_read_state	sr_state;	/* state machine state */
+	u64				sr_req_off;	/* orig request offset */
+	u64				sr_req_len;	/* orig request length */
+	u64				sr_pos;		/* current pos in buffer */
+	int				sr_index;	/* current extent index */
+	__le32				sr_datalen;	/* length of actual data */
+	u32				sr_count;	/* extent count in reply */
+	int				sr_ext_len;	/* length of extent array */
+	struct ceph_sparse_extent	*sr_extent;	/* extent array */
+};
+
 /*
  * A given osd we're communicating with.
  *
@@ -48,6 +78,7 @@ struct ceph_sparse_extent {
  */
 struct ceph_osd {
 	refcount_t o_ref;
+	int o_sparse_op_idx;
 	struct ceph_osd_client *o_osdc;
 	int o_osd;
 	int o_incarnation;
@@ -63,6 +94,7 @@ struct ceph_osd {
 	unsigned long lru_ttl;
 	struct list_head o_keepalive_item;
 	struct mutex lock;
+	struct ceph_sparse_read	o_sparse_read;
 };
 
 #define CEPH_OSD_SLAB_OPS	2
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index e2f1d1dcbb84..8534ca9c39b9 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -376,6 +376,7 @@ static void osd_req_op_data_release(struct ceph_osd_request *osd_req,
 
 	switch (op->op) {
 	case CEPH_OSD_OP_READ:
+	case CEPH_OSD_OP_SPARSE_READ:
 	case CEPH_OSD_OP_WRITE:
 	case CEPH_OSD_OP_WRITEFULL:
 		kfree(op->extent.sparse_ext);
@@ -670,6 +671,7 @@ static void get_num_data_items(struct ceph_osd_request *req,
 		/* reply */
 		case CEPH_OSD_OP_STAT:
 		case CEPH_OSD_OP_READ:
+		case CEPH_OSD_OP_SPARSE_READ:
 		case CEPH_OSD_OP_LIST_WATCHERS:
 			*num_reply_data_items += 1;
 			break;
@@ -739,7 +741,7 @@ void osd_req_op_extent_init(struct ceph_osd_request *osd_req,
 
 	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
 	       opcode != CEPH_OSD_OP_WRITEFULL && opcode != CEPH_OSD_OP_ZERO &&
-	       opcode != CEPH_OSD_OP_TRUNCATE);
+	       opcode != CEPH_OSD_OP_TRUNCATE && opcode != CEPH_OSD_OP_SPARSE_READ);
 
 	op->extent.offset = offset;
 	op->extent.length = length;
@@ -964,6 +966,7 @@ static u32 osd_req_encode_op(struct ceph_osd_op *dst,
 	case CEPH_OSD_OP_STAT:
 		break;
 	case CEPH_OSD_OP_READ:
+	case CEPH_OSD_OP_SPARSE_READ:
 	case CEPH_OSD_OP_WRITE:
 	case CEPH_OSD_OP_WRITEFULL:
 	case CEPH_OSD_OP_ZERO:
@@ -1060,7 +1063,8 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 
 	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
 	       opcode != CEPH_OSD_OP_ZERO && opcode != CEPH_OSD_OP_TRUNCATE &&
-	       opcode != CEPH_OSD_OP_CREATE && opcode != CEPH_OSD_OP_DELETE);
+	       opcode != CEPH_OSD_OP_CREATE && opcode != CEPH_OSD_OP_DELETE &&
+	       opcode != CEPH_OSD_OP_SPARSE_READ);
 
 	req = ceph_osdc_alloc_request(osdc, snapc, num_ops, use_mempool,
 					GFP_NOFS);
@@ -1201,6 +1205,13 @@ static void osd_init(struct ceph_osd *osd)
 	mutex_init(&osd->lock);
 }
 
+static void ceph_init_sparse_read(struct ceph_sparse_read *sr)
+{
+	kfree(sr->sr_extent);
+	memset(sr, '\0', sizeof(*sr));
+	sr->sr_state = CEPH_SPARSE_READ_HDR;
+}
+
 static void osd_cleanup(struct ceph_osd *osd)
 {
 	WARN_ON(!RB_EMPTY_NODE(&osd->o_node));
@@ -1211,6 +1222,8 @@ static void osd_cleanup(struct ceph_osd *osd)
 	WARN_ON(!list_empty(&osd->o_osd_lru));
 	WARN_ON(!list_empty(&osd->o_keepalive_item));
 
+	ceph_init_sparse_read(&osd->o_sparse_read);
+
 	if (osd->o_auth.authorizer) {
 		WARN_ON(osd_homeless(osd));
 		ceph_auth_destroy_authorizer(osd->o_auth.authorizer);
@@ -1230,6 +1243,9 @@ static struct ceph_osd *create_osd(struct ceph_osd_client *osdc, int onum)
 	osd_init(osd);
 	osd->o_osdc = osdc;
 	osd->o_osd = onum;
+	osd->o_sparse_op_idx = -1;
+
+	ceph_init_sparse_read(&osd->o_sparse_read);
 
 	ceph_con_init(&osd->o_con, osd, &osd_con_ops, &osdc->client->msgr);
 
@@ -2034,6 +2050,7 @@ static void setup_request_data(struct ceph_osd_request *req)
 					       &op->raw_data_in);
 			break;
 		case CEPH_OSD_OP_READ:
+		case CEPH_OSD_OP_SPARSE_READ:
 			ceph_osdc_msg_data_add(reply_msg,
 					       &op->extent.osd_data);
 			break;
@@ -2453,8 +2470,10 @@ static void finish_request(struct ceph_osd_request *req)
 
 	req->r_end_latency = ktime_get();
 
-	if (req->r_osd)
+	if (req->r_osd) {
+		ceph_init_sparse_read(&req->r_osd->o_sparse_read);
 		unlink_request(req->r_osd, req);
+	}
 	atomic_dec(&osdc->num_requests);
 
 	/*
@@ -5358,6 +5377,24 @@ static void osd_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
 	ceph_msg_put(msg);
 }
 
+/* How much sparse data was requested? */
+static u64 sparse_data_requested(struct ceph_osd_request *req)
+{
+	u64 len = 0;
+
+	if (req->r_flags & CEPH_OSD_FLAG_READ) {
+		int i;
+
+		for (i = 0; i < req->r_num_ops; ++i) {
+			struct ceph_osd_req_op *op = &req->r_ops[i];
+
+			if (op->op == CEPH_OSD_OP_SPARSE_READ)
+				len += op->extent.length;
+		}
+	}
+	return len;
+}
+
 /*
  * Lookup and return message for incoming reply.  Don't try to do
  * anything about a larger than preallocated data portion of the
@@ -5374,6 +5411,7 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 	int front_len = le32_to_cpu(hdr->front_len);
 	int data_len = le32_to_cpu(hdr->data_len);
 	u64 tid = le64_to_cpu(hdr->tid);
+	u64 srlen;
 
 	down_read(&osdc->lock);
 	if (!osd_registered(osd)) {
@@ -5406,7 +5444,8 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 		req->r_reply = m;
 	}
 
-	if (data_len > req->r_reply->data_length) {
+	srlen = sparse_data_requested(req);
+	if (!srlen && data_len > req->r_reply->data_length) {
 		pr_warn("%s osd%d tid %llu data %d > preallocated %zu, skipping\n",
 			__func__, osd->o_osd, req->r_tid, data_len,
 			req->r_reply->data_length);
@@ -5416,6 +5455,8 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 	}
 
 	m = ceph_msg_get(req->r_reply);
+	m->sparse_read = (bool)srlen;
+
 	dout("get_reply tid %lld %p\n", tid, m);
 
 out_unlock_session:
@@ -5648,9 +5689,215 @@ static int osd_check_message_signature(struct ceph_msg *msg)
 	return ceph_auth_check_message_signature(auth, msg);
 }
 
+static void advance_cursor(struct ceph_msg_data_cursor *cursor, size_t len, bool zero)
+{
+	while (len) {
+		struct page *page;
+		size_t poff, plen;
+
+		page = ceph_msg_data_next(cursor, &poff, &plen);
+		if (plen > len)
+			plen = len;
+		if (zero)
+			zero_user_segment(page, poff, poff + plen);
+		len -= plen;
+		ceph_msg_data_advance(cursor, plen);
+	}
+}
+
+static int prep_next_sparse_read(struct ceph_connection *con,
+				 struct ceph_msg_data_cursor *cursor)
+{
+	struct ceph_osd *o = con->private;
+	struct ceph_sparse_read *sr = &o->o_sparse_read;
+	struct ceph_osd_request *req;
+	struct ceph_osd_req_op *op;
+
+	spin_lock(&o->o_requests_lock);
+	req = lookup_request(&o->o_requests, le64_to_cpu(con->in_msg->hdr.tid));
+	if (!req) {
+		spin_unlock(&o->o_requests_lock);
+		return -EBADR;
+	}
+
+	if (o->o_sparse_op_idx < 0) {
+		u64 srlen = sparse_data_requested(req);
+
+		dout("%s: [%d] starting new sparse read req. srlen=0x%llx\n",
+		     __func__, o->o_osd, srlen);
+		ceph_msg_data_cursor_init(cursor, con->in_msg, srlen);
+	} else {
+		u64 end;
+
+		op = &req->r_ops[o->o_sparse_op_idx];
+
+		WARN_ON_ONCE(op->extent.sparse_ext);
+
+		/* hand back buffer we took earlier */
+		op->extent.sparse_ext = sr->sr_extent;
+		sr->sr_extent = NULL;
+		op->extent.sparse_ext_cnt = sr->sr_count;
+		sr->sr_ext_len = 0;
+		dout("%s: [%d] completed extent array len %d cursor->resid %zd\n",
+		     __func__, o->o_osd, op->extent.sparse_ext_cnt, cursor->resid);
+		/* Advance to end of data for this operation */
+		end = ceph_sparse_ext_map_end(op);
+		if (end < sr->sr_req_len)
+			advance_cursor(cursor, sr->sr_req_len - end, false);
+	}
+
+	ceph_init_sparse_read(sr);
+
+	/* find next op in this request (if any) */
+	while (++o->o_sparse_op_idx < req->r_num_ops) {
+		op = &req->r_ops[o->o_sparse_op_idx];
+		if (op->op == CEPH_OSD_OP_SPARSE_READ)
+			goto found;
+	}
+
+	/* reset for next sparse read request */
+	spin_unlock(&o->o_requests_lock);
+	o->o_sparse_op_idx = -1;
+	return 0;
+found:
+	sr->sr_req_off = op->extent.offset;
+	sr->sr_req_len = op->extent.length;
+	sr->sr_pos = sr->sr_req_off;
+	dout("%s: [%d] new sparse read op at idx %d 0x%llx~0x%llx\n", __func__,
+	     o->o_osd, o->o_sparse_op_idx, sr->sr_req_off, sr->sr_req_len);
+
+	/* hand off request's sparse extent map buffer */
+	sr->sr_ext_len = op->extent.sparse_ext_cnt;
+	op->extent.sparse_ext_cnt = 0;
+	sr->sr_extent = op->extent.sparse_ext;
+	op->extent.sparse_ext = NULL;
+
+	spin_unlock(&o->o_requests_lock);
+	return 1;
+}
+
+#ifdef __BIG_ENDIAN
+static inline void convert_extent_map(struct ceph_sparse_read *sr)
+{
+	int i;
+
+	for (i = 0; i < sr->sr_count; i++) {
+		struct ceph_sparse_extent *ext = &sr->sr_extent[i];
+
+		ext->off = le64_to_cpu((__force __le64)ext->off);
+		ext->len = le64_to_cpu((__force __le64)ext->len);
+	}
+}
+#else
+static inline void convert_extent_map(struct ceph_sparse_read *sr)
+{
+}
+#endif
+
+#define MAX_EXTENTS 4096
+
+static int osd_sparse_read(struct ceph_connection *con,
+			   struct ceph_msg_data_cursor *cursor,
+			   char **pbuf)
+{
+	struct ceph_osd *o = con->private;
+	struct ceph_sparse_read *sr = &o->o_sparse_read;
+	u32 count = sr->sr_count;
+	u64 eoff, elen;
+	int ret;
+
+	switch (sr->sr_state) {
+	case CEPH_SPARSE_READ_HDR:
+next_op:
+		ret = prep_next_sparse_read(con, cursor);
+		if (ret <= 0)
+			return ret;
+
+		/* number of extents */
+		ret = sizeof(sr->sr_count);
+		*pbuf = (char *)&sr->sr_count;
+		sr->sr_state = CEPH_SPARSE_READ_EXTENTS;
+		break;
+	case CEPH_SPARSE_READ_EXTENTS:
+		/* Convert sr_count to host-endian */
+		count = le32_to_cpu((__force __le32)sr->sr_count);
+		sr->sr_count = count;
+		dout("[%d] got %u extents\n", o->o_osd, count);
+
+		if (count > 0) {
+			if (!sr->sr_extent || count > sr->sr_ext_len) {
+				/*
+				 * Apply a hard cap to the number of extents.
+				 * If we have more, assume something is wrong.
+				 */
+				if (count > MAX_EXTENTS) {
+					dout("%s: OSD returned 0x%x extents in a single reply!\n",
+						  __func__, count);
+					return -EREMOTEIO;
+				}
+
+				/* no extent array provided, or too short */
+				kfree(sr->sr_extent);
+				sr->sr_extent = kmalloc_array(count,
+							      sizeof(*sr->sr_extent),
+							      GFP_NOIO);
+				if (!sr->sr_extent)
+					return -ENOMEM;
+				sr->sr_ext_len = count;
+			}
+			ret = count * sizeof(*sr->sr_extent);
+			*pbuf = (char *)sr->sr_extent;
+			sr->sr_state = CEPH_SPARSE_READ_DATA_LEN;
+			break;
+		}
+		/* No extents? Read data len */
+		fallthrough;
+	case CEPH_SPARSE_READ_DATA_LEN:
+		convert_extent_map(sr);
+		ret = sizeof(sr->sr_datalen);
+		*pbuf = (char *)&sr->sr_datalen;
+		sr->sr_state = CEPH_SPARSE_READ_DATA;
+		break;
+	case CEPH_SPARSE_READ_DATA:
+		if (sr->sr_index >= count) {
+			sr->sr_state = CEPH_SPARSE_READ_HDR;
+			goto next_op;
+		}
+
+		eoff = sr->sr_extent[sr->sr_index].off;
+		elen = sr->sr_extent[sr->sr_index].len;
+
+		dout("[%d] ext %d off 0x%llx len 0x%llx\n",
+		     o->o_osd, sr->sr_index, eoff, elen);
+
+		if (elen > INT_MAX) {
+			dout("Sparse read extent length too long (0x%llx)\n", elen);
+			return -EREMOTEIO;
+		}
+
+		/* zero out anything from sr_pos to start of extent */
+		if (sr->sr_pos < eoff)
+			advance_cursor(cursor, eoff - sr->sr_pos, true);
+
+		/* Set position to end of extent */
+		sr->sr_pos = eoff + elen;
+
+		/* send back the new length and nullify the ptr */
+		cursor->sr_resid = elen;
+		ret = elen;
+		*pbuf = NULL;
+
+		/* Bump the array index */
+		++sr->sr_index;
+		break;
+	}
+	return ret;
+}
+
 static const struct ceph_connection_operations osd_con_ops = {
 	.get = osd_get_con,
 	.put = osd_put_con,
+	.sparse_read = osd_sparse_read,
 	.alloc_msg = osd_alloc_msg,
 	.dispatch = osd_dispatch,
 	.fault = osd_fault,
-- 
2.31.1


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09244E2FF2
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Mar 2022 19:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352140AbiCUS22 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Mar 2022 14:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352136AbiCUS1u (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 21 Mar 2022 14:27:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DB160CF6
        for <ceph-devel@vger.kernel.org>; Mon, 21 Mar 2022 11:26:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB14861509
        for <ceph-devel@vger.kernel.org>; Mon, 21 Mar 2022 18:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F33C340E8;
        Mon, 21 Mar 2022 18:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647887183;
        bh=LoxVg52vwCAdGM8YGJ8Rqsi739+4M/v0JFXWpdrNq9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6lt1OinkNWGsmdNOZqHtFfTJimCeumL6mh+uMgS1Vz3heAXBL9VtTwAo7bSgEr32
         /ecorC5omrTE4Xpc84XCMHFIJQJx2jrSaUMR6mvwmLLc6D263OZgxnM9KQ6lKGsM9w
         GVjBfRPqQrFbczUgKbR7if9h7N2rjhPecN2GybI2zFGLyfj5wjLnb+oZeqiXTCSFUj
         HxPpp7Cs5mU677C9AlfKB2Q8ub3sgyswMNe85BOMZ8ek8uIBW5X2XjdmchjrUtKXT2
         zuUvENSzyKXkAxUL1la58v55x0+Ef7hEnArFh3oE14/feEbTqZTIPhYBH13VJJzDH7
         vlgg7qvIPWMZQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@gmail.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org
Subject: [PATCH v4 4/5] libceph: add sparse read support to OSD client
Date:   Mon, 21 Mar 2022 14:26:17 -0400
Message-Id: <20220321182618.134202-5-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321182618.134202-1-jlayton@kernel.org>
References: <20220321182618.134202-1-jlayton@kernel.org>
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

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/osd_client.h |  32 +++++
 net/ceph/osd_client.c           | 237 +++++++++++++++++++++++++++++++-
 2 files changed, 265 insertions(+), 4 deletions(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 12f38295693d..cf663423d51f 100644
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
index 7fc96c98c17b..3e3a9d0aa74d 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -376,6 +376,7 @@ static void osd_req_op_data_release(struct ceph_osd_request *osd_req,
 
 	switch (op->op) {
 	case CEPH_OSD_OP_READ:
+	case CEPH_OSD_OP_SPARSE_READ:
 	case CEPH_OSD_OP_WRITE:
 	case CEPH_OSD_OP_WRITEFULL:
 		kfree(op->extent.sparse_ext);
@@ -707,6 +708,7 @@ static void get_num_data_items(struct ceph_osd_request *req,
 		/* reply */
 		case CEPH_OSD_OP_STAT:
 		case CEPH_OSD_OP_READ:
+		case CEPH_OSD_OP_SPARSE_READ:
 		case CEPH_OSD_OP_LIST_WATCHERS:
 			*num_reply_data_items += 1;
 			break;
@@ -776,7 +778,7 @@ void osd_req_op_extent_init(struct ceph_osd_request *osd_req,
 
 	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
 	       opcode != CEPH_OSD_OP_WRITEFULL && opcode != CEPH_OSD_OP_ZERO &&
-	       opcode != CEPH_OSD_OP_TRUNCATE);
+	       opcode != CEPH_OSD_OP_TRUNCATE && opcode != CEPH_OSD_OP_SPARSE_READ);
 
 	op->extent.offset = offset;
 	op->extent.length = length;
@@ -985,6 +987,7 @@ static u32 osd_req_encode_op(struct ceph_osd_op *dst,
 	case CEPH_OSD_OP_STAT:
 		break;
 	case CEPH_OSD_OP_READ:
+	case CEPH_OSD_OP_SPARSE_READ:
 	case CEPH_OSD_OP_WRITE:
 	case CEPH_OSD_OP_WRITEFULL:
 	case CEPH_OSD_OP_ZERO:
@@ -1081,7 +1084,8 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 
 	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
 	       opcode != CEPH_OSD_OP_ZERO && opcode != CEPH_OSD_OP_TRUNCATE &&
-	       opcode != CEPH_OSD_OP_CREATE && opcode != CEPH_OSD_OP_DELETE);
+	       opcode != CEPH_OSD_OP_CREATE && opcode != CEPH_OSD_OP_DELETE &&
+	       opcode != CEPH_OSD_OP_SPARSE_READ);
 
 	req = ceph_osdc_alloc_request(osdc, snapc, num_ops, use_mempool,
 					GFP_NOFS);
@@ -1222,6 +1226,13 @@ static void osd_init(struct ceph_osd *osd)
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
@@ -1232,6 +1243,8 @@ static void osd_cleanup(struct ceph_osd *osd)
 	WARN_ON(!list_empty(&osd->o_osd_lru));
 	WARN_ON(!list_empty(&osd->o_keepalive_item));
 
+	ceph_init_sparse_read(&osd->o_sparse_read);
+
 	if (osd->o_auth.authorizer) {
 		WARN_ON(osd_homeless(osd));
 		ceph_auth_destroy_authorizer(osd->o_auth.authorizer);
@@ -1251,6 +1264,9 @@ static struct ceph_osd *create_osd(struct ceph_osd_client *osdc, int onum)
 	osd_init(osd);
 	osd->o_osdc = osdc;
 	osd->o_osd = onum;
+	osd->o_sparse_op_idx = -1;
+
+	ceph_init_sparse_read(&osd->o_sparse_read);
 
 	ceph_con_init(&osd->o_con, osd, &osd_con_ops, &osdc->client->msgr);
 
@@ -2055,6 +2071,7 @@ static void setup_request_data(struct ceph_osd_request *req)
 					       &op->raw_data_in);
 			break;
 		case CEPH_OSD_OP_READ:
+		case CEPH_OSD_OP_SPARSE_READ:
 			ceph_osdc_msg_data_add(reply_msg,
 					       &op->extent.osd_data);
 			break;
@@ -2474,8 +2491,10 @@ static void finish_request(struct ceph_osd_request *req)
 
 	req->r_end_latency = ktime_get();
 
-	if (req->r_osd)
+	if (req->r_osd) {
+		ceph_init_sparse_read(&req->r_osd->o_sparse_read);
 		unlink_request(req->r_osd, req);
+	}
 	atomic_dec(&osdc->num_requests);
 
 	/*
@@ -5420,6 +5439,24 @@ static void osd_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
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
@@ -5436,6 +5473,7 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 	int front_len = le32_to_cpu(hdr->front_len);
 	int data_len = le32_to_cpu(hdr->data_len);
 	u64 tid = le64_to_cpu(hdr->tid);
+	u64 srlen;
 
 	down_read(&osdc->lock);
 	if (!osd_registered(osd)) {
@@ -5468,7 +5506,8 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 		req->r_reply = m;
 	}
 
-	if (data_len > req->r_reply->data_length) {
+	srlen = sparse_data_requested(req);
+	if (!srlen && data_len > req->r_reply->data_length) {
 		pr_warn("%s osd%d tid %llu data %d > preallocated %zu, skipping\n",
 			__func__, osd->o_osd, req->r_tid, data_len,
 			req->r_reply->data_length);
@@ -5478,6 +5517,8 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 	}
 
 	m = ceph_msg_get(req->r_reply);
+	m->sparse_read = (bool)srlen;
+
 	dout("get_reply tid %lld %p\n", tid, m);
 
 out_unlock_session:
@@ -5710,9 +5751,197 @@ static int osd_check_message_signature(struct ceph_msg *msg)
 	return ceph_auth_check_message_signature(auth, msg);
 }
 
+static void advance_cursor(struct ceph_msg_data_cursor *cursor, size_t len, bool zero)
+{
+	while (len) {
+		struct page *page;
+		size_t poff, plen;
+		bool last = false;
+
+		page = ceph_msg_data_next(cursor, &poff, &plen, &last);
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
+static int osd_sparse_read(struct ceph_connection *con,
+			   struct ceph_msg_data_cursor *cursor,
+			   u64 *plen, char **pbuf)
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
+		*plen = sizeof(sr->sr_count);
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
+				/* no extent array provided, or too short */
+				kfree(sr->sr_extent);
+				sr->sr_extent = kmalloc_array(count,
+							      sizeof(*sr->sr_extent),
+							      GFP_NOIO);
+				if (!sr->sr_extent)
+					return -ENOMEM;
+				sr->sr_ext_len = count;
+			}
+			*plen = count * sizeof(*sr->sr_extent);
+			*pbuf = (char *)sr->sr_extent;
+			sr->sr_state = CEPH_SPARSE_READ_DATA_LEN;
+			break;
+		}
+		/* No extents? Read data len */
+		fallthrough;
+	case CEPH_SPARSE_READ_DATA_LEN:
+		convert_extent_map(sr);
+		*plen = sizeof(sr->sr_datalen);
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
+		/* zero out anything from sr_pos to start of extent */
+		if (sr->sr_pos < eoff)
+			advance_cursor(cursor, eoff - sr->sr_pos, true);
+
+		/* Set position to end of extent */
+		sr->sr_pos = eoff + elen;
+
+		/* send back the new length */
+		*plen = elen;
+
+		/* Bump the array index */
+		++sr->sr_index;
+		break;
+	}
+	return 1;
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
2.35.1


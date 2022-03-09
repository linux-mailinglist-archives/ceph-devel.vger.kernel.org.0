Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC7D4D2F19
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Mar 2022 13:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiCIMe1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Mar 2022 07:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiCIMe0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Mar 2022 07:34:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332943EAB6
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 04:33:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5B0361989
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 12:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67DBC340EE;
        Wed,  9 Mar 2022 12:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646829206;
        bh=x7+C/cRZ/k52fQxzSWQO5rdPL1azPIH+NupV7R/MLUQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=MhDMDoveYAUM5K6cKQT0SXquP2lbSwBhbOy3wtgqZ8ZYgDtaNFoxzoESBwZ5O2uzx
         yxzyx86YkhHZhCzAyDlOa3ImZCGhL+WQ+PXs7bUhkHyNYcsV1AyLp1ePxcr+YkFTNz
         tTXNqBUb3nVPilP9bE2kIibYlLDdwOztp3TWKPpPGf9w+F7gaHjfAyz/vfO1leUo03
         80Z4Ul+CcSayH4HVto81R0GxMC+yVRfySzSgh6doEFsYwz3oK2u51+V/hvIqb2pB7e
         KiwT2A4BVnXbrLbiZTD/Swg4lRGg8Wz72/bP8L1iqTLxNgRaGFHqk4CV8NVB3yJifd
         7sqNUnt4ES3MQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Subject: [PATCH 1/3] libceph: add sparse read support to msgr2 crc state machine
Date:   Wed,  9 Mar 2022 07:33:21 -0500
Message-Id: <20220309123323.20593-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309123323.20593-1-jlayton@kernel.org>
References: <20220309123323.20593-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add support for a new sparse_read ceph_connection operation. The idea is
that the client driver can define this operation use it to do special
handling for incoming reads.

The alloc_msg routine will look at the request and determine whether the
reply is expected to be sparse. If it is, then we'll dispatch to a
different set of state machine states that will repeatedly call the
driver's sparse_read op to get length and placement info for reading the
extent map, and the extents themselves.

This necessitates adding some new field to some other structs:

- The msg gets a new bool to track whether it's a sparse_read request.

- A new field is added to the cursor to track the amount remaining in the
current extent. This is used to cap the read from the socket into the
msg_data

- Handing a revoke with all of this is particularly difficult, so I've
added a new data_len_remain field to the v2 connection info, and then
use that to skip that much on a revoke. We may want to expand the use of
that to the normal read path as well, just for consistency's sake.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/messenger.h |  31 +++++
 net/ceph/messenger.c           |   1 +
 net/ceph/messenger_v2.c        | 215 +++++++++++++++++++++++++++++++--
 3 files changed, 238 insertions(+), 9 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index e7f2fb2fc207..e9c86d6de2e6 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -17,6 +17,7 @@
 
 struct ceph_msg;
 struct ceph_connection;
+struct ceph_msg_data_cursor;
 
 /*
  * Ceph defines these callbacks for handling connection events.
@@ -70,6 +71,31 @@ struct ceph_connection_operations {
 				      int used_proto, int result,
 				      const int *allowed_protos, int proto_cnt,
 				      const int *allowed_modes, int mode_cnt);
+
+	/**
+	 * sparse_read: read sparse data
+	 * @con: connection we're reading from
+	 * @cursor: data cursor for reading extents
+	 * @len: len of the data that msgr should read
+	 * @buf: optional buffer to read into
+	 *
+	 * This should be called more than once, each time setting up to
+	 * receive an extent into the current cursor position, and zeroing
+	 * the holes between them.
+	 *
+	 * Returns 1 if there is more data to be read, 0 if reading is
+	 * complete, or -errno if there was an error.
+	 *
+	 * If @buf is set on a 1 return, then the data should be read into
+	 * the provided buffer. Otherwise, it should be read into the cursor.
+	 *
+	 * The sparse read operation is expected to initialize the cursor
+	 * with a length covering up to the end of the last extent.
+	 */
+	int (*sparse_read)(struct ceph_connection *con,
+			   struct ceph_msg_data_cursor *cursor,
+			   u64 *len, char **buf);
+
 };
 
 /* use format string %s%lld */
@@ -207,6 +233,7 @@ struct ceph_msg_data_cursor {
 
 	struct ceph_msg_data	*data;		/* current data item */
 	size_t			resid;		/* bytes not yet consumed */
+	int			sr_resid;	/* residual sparse_read len */
 	bool			last_piece;	/* current is last piece */
 	bool			need_crc;	/* crc update needed */
 	union {
@@ -252,6 +279,7 @@ struct ceph_msg {
 	struct kref kref;
 	bool more_to_follow;
 	bool needs_out_seq;
+	bool sparse_read;
 	int front_alloc_len;
 
 	struct ceph_msgpool *pool;
@@ -396,6 +424,7 @@ struct ceph_connection_v2_info {
 
 	void *conn_bufs[16];
 	int conn_buf_cnt;
+	int data_len_remain;
 
 	struct kvec in_sign_kvecs[8];
 	struct kvec out_sign_kvecs[8];
@@ -464,6 +493,8 @@ struct ceph_connection {
 	struct page *bounce_page;
 	u32 in_front_crc, in_middle_crc, in_data_crc;  /* calculated crc */
 
+	int sparse_resid;
+
 	struct timespec64 last_keepalive_ack; /* keepalive2 ack stamp */
 
 	struct delayed_work work;	    /* send|recv work */
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index d3bb656308b4..bf4e7f5751ee 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1034,6 +1034,7 @@ void ceph_msg_data_cursor_init(struct ceph_msg_data_cursor *cursor,
 
 	cursor->total_resid = length;
 	cursor->data = msg->data;
+	cursor->sr_resid = 0;
 
 	__ceph_msg_data_cursor_init(cursor);
 }
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index c6e5bfc717d5..845c2f093a02 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -52,14 +52,17 @@
 #define FRAME_LATE_STATUS_COMPLETE	0xe
 #define FRAME_LATE_STATUS_ABORTED_MASK	0xf
 
-#define IN_S_HANDLE_PREAMBLE		1
-#define IN_S_HANDLE_CONTROL		2
-#define IN_S_HANDLE_CONTROL_REMAINDER	3
-#define IN_S_PREPARE_READ_DATA		4
-#define IN_S_PREPARE_READ_DATA_CONT	5
-#define IN_S_PREPARE_READ_ENC_PAGE	6
-#define IN_S_HANDLE_EPILOGUE		7
-#define IN_S_FINISH_SKIP		8
+#define IN_S_HANDLE_PREAMBLE			1
+#define IN_S_HANDLE_CONTROL			2
+#define IN_S_HANDLE_CONTROL_REMAINDER		3
+#define IN_S_PREPARE_READ_DATA			4
+#define IN_S_PREPARE_READ_DATA_CONT		5
+#define IN_S_PREPARE_READ_ENC_PAGE		6
+#define IN_S_PREPARE_SPARSE_DATA		7
+#define IN_S_PREPARE_SPARSE_DATA_HDR		8
+#define IN_S_PREPARE_SPARSE_DATA_CONT		9
+#define IN_S_HANDLE_EPILOGUE			10
+#define IN_S_FINISH_SKIP			11
 
 #define OUT_S_QUEUE_DATA		1
 #define OUT_S_QUEUE_DATA_CONT		2
@@ -1819,6 +1822,166 @@ static void prepare_read_data_cont(struct ceph_connection *con)
 	con->v2.in_state = IN_S_HANDLE_EPILOGUE;
 }
 
+static int prepare_sparse_read_cont(struct ceph_connection *con)
+{
+	int ret;
+	struct bio_vec bv;
+	char *buf = NULL;
+	struct ceph_msg_data_cursor *cursor = &con->v2.in_cursor;
+	u64 len = 0;
+
+	if (!iov_iter_is_bvec(&con->v2.in_iter))
+		return -EIO;
+
+	if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) {
+		con->in_data_crc = crc32c(con->in_data_crc,
+					  page_address(con->bounce_page),
+					  con->v2.in_bvec.bv_len);
+
+		get_bvec_at(cursor, &bv);
+		memcpy_to_page(bv.bv_page, bv.bv_offset,
+			       page_address(con->bounce_page),
+			       con->v2.in_bvec.bv_len);
+	} else {
+		con->in_data_crc = ceph_crc32c_page(con->in_data_crc,
+						    con->v2.in_bvec.bv_page,
+						    con->v2.in_bvec.bv_offset,
+						    con->v2.in_bvec.bv_len);
+	}
+
+	ceph_msg_data_advance(cursor, con->v2.in_bvec.bv_len);
+	cursor->sr_resid -= con->v2.in_bvec.bv_len;
+	dout("%s: advance by 0x%x sr_resid 0x%x\n", __func__,
+		con->v2.in_bvec.bv_len, cursor->sr_resid);
+	WARN_ON_ONCE(cursor->sr_resid > cursor->total_resid);
+	if (cursor->sr_resid) {
+		get_bvec_at(cursor, &bv);
+		if (bv.bv_len > cursor->sr_resid)
+			bv.bv_len = cursor->sr_resid;
+		if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) {
+			bv.bv_page = con->bounce_page;
+			bv.bv_offset = 0;
+		}
+		set_in_bvec(con, &bv);
+		con->v2.data_len_remain -= bv.bv_len;
+		WARN_ON(con->v2.in_state != IN_S_PREPARE_SPARSE_DATA_CONT);
+		return 0;
+	}
+
+	/* get next extent */
+	ret = con->ops->sparse_read(con, cursor, &len, &buf);
+	if (ret <= 0) {
+		if (ret < 0)
+			return ret;
+
+		reset_in_kvecs(con);
+		add_in_kvec(con, con->v2.in_buf, CEPH_EPILOGUE_PLAIN_LEN);
+		con->v2.in_state = IN_S_HANDLE_EPILOGUE;
+		return 0;
+	}
+
+	cursor->sr_resid = len;
+	get_bvec_at(cursor, &bv);
+	if (bv.bv_len > cursor->sr_resid)
+		bv.bv_len = cursor->sr_resid;
+	if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) {
+		if (unlikely(!con->bounce_page)) {
+			con->bounce_page = alloc_page(GFP_NOIO);
+			if (!con->bounce_page) {
+				pr_err("failed to allocate bounce page\n");
+				return -ENOMEM;
+			}
+		}
+
+		bv.bv_page = con->bounce_page;
+		bv.bv_offset = 0;
+	}
+	set_in_bvec(con, &bv);
+	con->v2.data_len_remain -= len;
+	return ret;
+}
+
+static int prepare_sparse_read_header(struct ceph_connection *con)
+{
+	int ret;
+	char *buf = NULL;
+	struct bio_vec bv;
+	struct ceph_msg_data_cursor *cursor = &con->v2.in_cursor;
+	u64 len = 0;
+
+	if (!iov_iter_is_kvec(&con->v2.in_iter))
+		return -EIO;
+
+	/* On first call, we have no kvec so don't compute crc */
+	if (con->v2.in_kvec_cnt) {
+		WARN_ON_ONCE(con->v2.in_kvec_cnt > 1);
+		con->in_data_crc = crc32c(con->in_data_crc,
+				  con->v2.in_kvecs[0].iov_base,
+				  con->v2.in_kvecs[0].iov_len);
+	}
+
+	ret = con->ops->sparse_read(con, cursor, &len, &buf);
+	if (ret < 0)
+		return ret;
+	if (ret == 0) {
+		reset_in_kvecs(con);
+		add_in_kvec(con, con->v2.in_buf, CEPH_EPILOGUE_PLAIN_LEN);
+		con->v2.in_state = IN_S_HANDLE_EPILOGUE;
+		return 0;
+	}
+
+	/* No actual data? */
+	if (WARN_ON_ONCE(!ret))
+		return -EIO;
+
+	if (!buf) {
+		cursor->sr_resid = len;
+		get_bvec_at(cursor, &bv);
+		if (bv.bv_len > cursor->sr_resid)
+			bv.bv_len = cursor->sr_resid;
+		if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) {
+			if (unlikely(!con->bounce_page)) {
+				con->bounce_page = alloc_page(GFP_NOIO);
+				if (!con->bounce_page) {
+					pr_err("failed to allocate bounce page\n");
+					return -ENOMEM;
+				}
+			}
+
+			bv.bv_page = con->bounce_page;
+			bv.bv_offset = 0;
+		}
+		set_in_bvec(con, &bv);
+		con->v2.data_len_remain -= len;
+		con->v2.in_state = IN_S_PREPARE_SPARSE_DATA_CONT;
+		return ret;
+	}
+
+	WARN_ON_ONCE(con->v2.in_state != IN_S_PREPARE_SPARSE_DATA_HDR);
+	reset_in_kvecs(con);
+	add_in_kvec(con, buf, len);
+	con->v2.data_len_remain -= len;
+	return 0;
+}
+
+static int prepare_sparse_read_data(struct ceph_connection *con)
+{
+	struct ceph_msg *msg = con->in_msg;
+
+	dout("%s: starting sparse read\n", __func__);
+
+	if (WARN_ON_ONCE(!con->ops->sparse_read))
+		return -EOPNOTSUPP;
+
+	if (!con_secure(con))
+		con->in_data_crc = -1;
+
+	reset_in_kvecs(con);
+	con->v2.in_state = IN_S_PREPARE_SPARSE_DATA_HDR;
+	con->v2.data_len_remain = data_len(msg);
+	return prepare_sparse_read_header(con);
+}
+
 static int prepare_read_tail_plain(struct ceph_connection *con)
 {
 	struct ceph_msg *msg = con->in_msg;
@@ -1839,7 +2002,10 @@ static int prepare_read_tail_plain(struct ceph_connection *con)
 	}
 
 	if (data_len(msg)) {
-		con->v2.in_state = IN_S_PREPARE_READ_DATA;
+		if (msg->sparse_read)
+			con->v2.in_state = IN_S_PREPARE_SPARSE_DATA;
+		else
+			con->v2.in_state = IN_S_PREPARE_READ_DATA;
 	} else {
 		add_in_kvec(con, con->v2.in_buf, CEPH_EPILOGUE_PLAIN_LEN);
 		con->v2.in_state = IN_S_HANDLE_EPILOGUE;
@@ -2893,6 +3059,15 @@ static int populate_in_iter(struct ceph_connection *con)
 			prepare_read_enc_page(con);
 			ret = 0;
 			break;
+		case IN_S_PREPARE_SPARSE_DATA:
+			ret = prepare_sparse_read_data(con);
+			break;
+		case IN_S_PREPARE_SPARSE_DATA_HDR:
+			ret = prepare_sparse_read_header(con);
+			break;
+		case IN_S_PREPARE_SPARSE_DATA_CONT:
+			ret = prepare_sparse_read_cont(con);
+			break;
 		case IN_S_HANDLE_EPILOGUE:
 			ret = handle_epilogue(con);
 			break;
@@ -3485,6 +3660,23 @@ static void revoke_at_prepare_read_enc_page(struct ceph_connection *con)
 	con->v2.in_state = IN_S_FINISH_SKIP;
 }
 
+static void revoke_at_prepare_sparse_data(struct ceph_connection *con)
+{
+	int resid;  /* current piece of data */
+	int remaining;
+
+	WARN_ON(con_secure(con));
+	WARN_ON(!data_len(con->in_msg));
+	WARN_ON(!iov_iter_is_bvec(&con->v2.in_iter));
+	resid = iov_iter_count(&con->v2.in_iter);
+	dout("%s con %p resid %d\n", __func__, con, resid);
+
+	remaining = CEPH_EPILOGUE_PLAIN_LEN + con->v2.data_len_remain;
+	con->v2.in_iter.count -= resid;
+	set_in_skip(con, resid + remaining);
+	con->v2.in_state = IN_S_FINISH_SKIP;
+}
+
 static void revoke_at_handle_epilogue(struct ceph_connection *con)
 {
 	int resid;
@@ -3501,6 +3693,7 @@ static void revoke_at_handle_epilogue(struct ceph_connection *con)
 void ceph_con_v2_revoke_incoming(struct ceph_connection *con)
 {
 	switch (con->v2.in_state) {
+	case IN_S_PREPARE_SPARSE_DATA:
 	case IN_S_PREPARE_READ_DATA:
 		revoke_at_prepare_read_data(con);
 		break;
@@ -3510,6 +3703,10 @@ void ceph_con_v2_revoke_incoming(struct ceph_connection *con)
 	case IN_S_PREPARE_READ_ENC_PAGE:
 		revoke_at_prepare_read_enc_page(con);
 		break;
+	case IN_S_PREPARE_SPARSE_DATA_HDR:
+	case IN_S_PREPARE_SPARSE_DATA_CONT:
+		revoke_at_prepare_sparse_data(con);
+		break;
 	case IN_S_HANDLE_EPILOGUE:
 		revoke_at_handle_epilogue(con);
 		break;
-- 
2.35.1


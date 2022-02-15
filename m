Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8397F4B7277
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Feb 2022 17:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239433AbiBOOwV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 09:52:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239288AbiBOOvw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 09:51:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32101029DA
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 06:50:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 346E260EFE
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 14:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AD3C340EB;
        Tue, 15 Feb 2022 14:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644936644;
        bh=k3sPhKrN8ndPIi+8iBwUQWHTrSWXvxAaI9Q1e64jVvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvKkIT7mK27NDQyHZadsJBSW9zbhHrPSNCNEWl0X0nznUERjiY7mk7ayB6K69W10D
         OZHczoTNRJtNRG/b6FF4QgOc76RqIiGVWAfAu84JrOoH0UA60IFY77FUeQao8aQggH
         ZQNI3aqYeBdzzyEqgvtIFVGvg+3qXnctBYUQc8OJ8uM0XpBaqKWJbaKaTt2JSKr4P9
         YsJ7Y1bf99GAsPQDkCgceo6yowca6JV0/jckh8J1Y2Y0BC/f3x2bCaKvk8wlneS0Jg
         b5VjbjiZXW7y+Oso2NB+5eZD+HwAN2tdAixCi9fzUMkoOOzx/rS/0GQwkTRx/1g37+
         gWsFF7ceIFRpA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [RFC PATCH 2/5] libceph: add sparse read support to msgr2 crc state machine
Date:   Tue, 15 Feb 2022 09:50:38 -0500
Message-Id: <20220215145041.26065-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215145041.26065-1-jlayton@kernel.org>
References: <20220215145041.26065-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add support for a new sparse_read ceph_connection operation. The idea is
that the client code can define this operation use it to do special
handling for incoming reads.

The alloc_msg routine can look at the request and determine whether the
reply is expected to be sparse. If it is, then we'll dispatch to a
different set of state machine states that will repeatedly call
sparse_read get length and placement info for reading the extent map,
and the extents themselves.

TODO: support for revoke during a sparse read

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/messenger.h |  19 ++++
 net/ceph/messenger_v2.c        | 164 ++++++++++++++++++++++++++++++---
 2 files changed, 169 insertions(+), 14 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index e7f2fb2fc207..498a1b7bd3c1 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -25,6 +25,22 @@ struct ceph_connection_operations {
 	struct ceph_connection *(*get)(struct ceph_connection *);
 	void (*put)(struct ceph_connection *);
 
+	/**
+	 * sparse_read: read sparse data
+	 * @con: connection we're reading from
+	 * @off: offset into msgr data caller should read into
+	 * @len: len of the data that msgr should read
+	 * @buf: optional buffer to read into
+	 *
+	 * This should be called more than once, each time setting up to
+	 * receive an extent into the correct portion of the buffer (and
+	 * zeroing the holes between them).
+	 *
+	 * Returns 1 if there is more data to be read, 0 if reading is
+	 * complete, or -errno if there was an error.
+	 */
+	int (*sparse_read)(struct ceph_connection *con, u64 *off, u64 *len, char **buf);
+
 	/* handle an incoming message. */
 	void (*dispatch) (struct ceph_connection *con, struct ceph_msg *m);
 
@@ -252,6 +268,7 @@ struct ceph_msg {
 	struct kref kref;
 	bool more_to_follow;
 	bool needs_out_seq;
+	bool sparse_read;
 	int front_alloc_len;
 
 	struct ceph_msgpool *pool;
@@ -464,6 +481,8 @@ struct ceph_connection {
 	struct page *bounce_page;
 	u32 in_front_crc, in_middle_crc, in_data_crc;  /* calculated crc */
 
+	int sparse_resid;
+
 	struct timespec64 last_keepalive_ack; /* keepalive2 ack stamp */
 
 	struct delayed_work work;	    /* send|recv work */
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index c6e5bfc717d5..16fcac363670 100644
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
@@ -1753,13 +1756,13 @@ static int prepare_read_control_remainder(struct ceph_connection *con)
 	return 0;
 }
 
-static int prepare_read_data(struct ceph_connection *con)
+static int prepare_read_data_extent(struct ceph_connection *con, int off, int len)
 {
 	struct bio_vec bv;
 
-	con->in_data_crc = -1;
-	ceph_msg_data_cursor_init(&con->v2.in_cursor, con->in_msg,
-				  data_len(con->in_msg));
+	ceph_msg_data_cursor_init(&con->v2.in_cursor, con->in_msg, off+len);
+	if (off)
+		ceph_msg_data_advance(&con->v2.in_cursor, off);
 
 	get_bvec_at(&con->v2.in_cursor, &bv);
 	if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) {
@@ -1775,10 +1778,20 @@ static int prepare_read_data(struct ceph_connection *con)
 		bv.bv_offset = 0;
 	}
 	set_in_bvec(con, &bv);
-	con->v2.in_state = IN_S_PREPARE_READ_DATA_CONT;
 	return 0;
 }
 
+static int prepare_read_data(struct ceph_connection *con)
+{
+	int ret;
+
+	con->in_data_crc = -1;
+	ret = prepare_read_data_extent(con, 0, data_len(con->in_msg));
+	if (ret == 0)
+		con->v2.in_state = IN_S_PREPARE_READ_DATA_CONT;
+	return ret;
+}
+
 static void prepare_read_data_cont(struct ceph_connection *con)
 {
 	struct bio_vec bv;
@@ -1819,6 +1832,116 @@ static void prepare_read_data_cont(struct ceph_connection *con)
 	con->v2.in_state = IN_S_HANDLE_EPILOGUE;
 }
 
+static int prepare_sparse_read_cont(struct ceph_connection *con)
+{
+	int ret;
+	struct bio_vec bv;
+	char *buf = NULL;
+	u64 off = 0, len = 0;
+
+	if (!iov_iter_is_bvec(&con->v2.in_iter))
+		return -EIO;
+
+	if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) {
+		con->in_data_crc = crc32c(con->in_data_crc,
+					  page_address(con->bounce_page),
+					  con->v2.in_bvec.bv_len);
+
+		get_bvec_at(&con->v2.in_cursor, &bv);
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
+	ceph_msg_data_advance(&con->v2.in_cursor, con->v2.in_bvec.bv_len);
+	if (con->v2.in_cursor.total_resid) {
+		get_bvec_at(&con->v2.in_cursor, &bv);
+		if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) {
+			bv.bv_page = con->bounce_page;
+			bv.bv_offset = 0;
+		}
+		set_in_bvec(con, &bv);
+		WARN_ON(con->v2.in_state != IN_S_PREPARE_SPARSE_DATA_CONT);
+		return 0;
+	}
+
+	/* get next extent */
+	ret = con->ops->sparse_read(con, &off, &len, &buf);
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
+	return prepare_read_data_extent(con, off, len);
+}
+
+static int prepare_sparse_read_header(struct ceph_connection *con)
+{
+	int ret;
+	char *buf = NULL;
+	u64 off = 0, len = 0;
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
+	ret = con->ops->sparse_read(con, &off, &len, &buf);
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
+		ret = prepare_read_data_extent(con, off, len);
+		if (!ret)
+			con->v2.in_state = IN_S_PREPARE_SPARSE_DATA_CONT;
+		return ret;
+	}
+
+	WARN_ON_ONCE(con->v2.in_state != IN_S_PREPARE_SPARSE_DATA_HDR);
+	reset_in_kvecs(con);
+	add_in_kvec(con, buf, len);
+	return 0;
+}
+
+static int prepare_sparse_read_data(struct ceph_connection *con)
+{
+	if (WARN_ON_ONCE(!con->ops->sparse_read))
+		return -EOPNOTSUPP;
+
+	if (!con_secure(con))
+		con->in_data_crc = -1;
+
+	reset_in_kvecs(con);
+	con->v2.in_state = IN_S_PREPARE_SPARSE_DATA_HDR;
+	return prepare_sparse_read_header(con);
+}
+
 static int prepare_read_tail_plain(struct ceph_connection *con)
 {
 	struct ceph_msg *msg = con->in_msg;
@@ -1839,7 +1962,10 @@ static int prepare_read_tail_plain(struct ceph_connection *con)
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
@@ -2893,6 +3019,15 @@ static int populate_in_iter(struct ceph_connection *con)
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
@@ -3501,6 +3636,7 @@ static void revoke_at_handle_epilogue(struct ceph_connection *con)
 void ceph_con_v2_revoke_incoming(struct ceph_connection *con)
 {
 	switch (con->v2.in_state) {
+	case IN_S_PREPARE_SPARSE_DATA:		// FIXME
 	case IN_S_PREPARE_READ_DATA:
 		revoke_at_prepare_read_data(con);
 		break;
-- 
2.34.1


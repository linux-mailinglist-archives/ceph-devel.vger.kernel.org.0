Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7704B7180
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Feb 2022 17:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239394AbiBOOwM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 09:52:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239296AbiBOOvw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 09:51:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43313104A63
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 06:50:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D748561468
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 14:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BF8C340F2;
        Tue, 15 Feb 2022 14:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644936645;
        bh=UmyaSUacADQ0KxQ/KSNDY0tAA+XctOBT3uogoqs4wzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UV9b941qTH24AJTFz+peFrclpQ8WV91HwwVlHmzoxW17IE8iSqBveI4mGkKX1mTkE
         szssK+MfBA4NQRrXoWw7TYANdWJP/l8mjz7uxTRBDpTPkJpvTD0NCbFoOjh4bpNLIP
         zdm3PcU8icm6nqs8rvJ8HIdvIRDx5w2r4GxoLJ9tQFa3g408hGWzlT2r0FC6EwBNrK
         IyNz4X979Z2+gbEfC168j8dqSkH0LCEP4MIYM8ciLXy9nwlQe9/REBVapx9M82h+iH
         iWmOwmzls4R0InqXOPDGJz3w6Y0RqEHeCzmxeg4b1cz97vn1AznL839fLKclc97T5f
         DenID+igRY2Nw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [RFC PATCH 4/5] libceph: add revoke support for sparse data
Date:   Tue, 15 Feb 2022 09:50:40 -0500
Message-Id: <20220215145041.26065-5-jlayton@kernel.org>
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

Since sparse read handling is so complex, add a new field for tracking
how much data we've read out of the data blob, and decrement that
whenever we marshal up a new iov_iter for a read off the socket.

On a revoke, just ensure we skip past whatever remains in the iter, plus
the remaining data_len and epilogue.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/messenger.h |  1 +
 net/ceph/messenger_v2.c        | 37 +++++++++++++++++++++++++++++++---
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 498a1b7bd3c1..206452d8a385 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -413,6 +413,7 @@ struct ceph_connection_v2_info {
 
 	void *conn_bufs[16];
 	int conn_buf_cnt;
+	int data_len_remain;
 
 	struct kvec in_sign_kvecs[8];
 	struct kvec out_sign_kvecs[8];
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index 16fcac363670..45ba59ce69e6 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -1866,6 +1866,7 @@ static int prepare_sparse_read_cont(struct ceph_connection *con)
 			bv.bv_offset = 0;
 		}
 		set_in_bvec(con, &bv);
+		con->v2.data_len_remain -= bv.bv_len;
 		WARN_ON(con->v2.in_state != IN_S_PREPARE_SPARSE_DATA_CONT);
 		return 0;
 	}
@@ -1882,7 +1883,10 @@ static int prepare_sparse_read_cont(struct ceph_connection *con)
 		return 0;
 	}
 
-	return prepare_read_data_extent(con, off, len);
+	ret = prepare_read_data_extent(con, off, len);
+	if (ret == 0)
+		con->v2.data_len_remain -= len;
+	return ret;
 }
 
 static int prepare_sparse_read_header(struct ceph_connection *con)
@@ -1918,19 +1922,24 @@ static int prepare_sparse_read_header(struct ceph_connection *con)
 
 	if (!buf) {
 		ret = prepare_read_data_extent(con, off, len);
-		if (!ret)
+		if (!ret) {
+			con->v2.data_len_remain -= len;
 			con->v2.in_state = IN_S_PREPARE_SPARSE_DATA_CONT;
+		}
 		return ret;
 	}
 
 	WARN_ON_ONCE(con->v2.in_state != IN_S_PREPARE_SPARSE_DATA_HDR);
 	reset_in_kvecs(con);
 	add_in_kvec(con, buf, len);
+	con->v2.data_len_remain -= len;
 	return 0;
 }
 
 static int prepare_sparse_read_data(struct ceph_connection *con)
 {
+	struct ceph_msg *msg = con->in_msg;
+
 	if (WARN_ON_ONCE(!con->ops->sparse_read))
 		return -EOPNOTSUPP;
 
@@ -1939,6 +1948,7 @@ static int prepare_sparse_read_data(struct ceph_connection *con)
 
 	reset_in_kvecs(con);
 	con->v2.in_state = IN_S_PREPARE_SPARSE_DATA_HDR;
+	con->v2.data_len_remain = data_len(msg);
 	return prepare_sparse_read_header(con);
 }
 
@@ -3620,6 +3630,23 @@ static void revoke_at_prepare_read_enc_page(struct ceph_connection *con)
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
@@ -3636,7 +3663,7 @@ static void revoke_at_handle_epilogue(struct ceph_connection *con)
 void ceph_con_v2_revoke_incoming(struct ceph_connection *con)
 {
 	switch (con->v2.in_state) {
-	case IN_S_PREPARE_SPARSE_DATA:		// FIXME
+	case IN_S_PREPARE_SPARSE_DATA:
 	case IN_S_PREPARE_READ_DATA:
 		revoke_at_prepare_read_data(con);
 		break;
@@ -3646,6 +3673,10 @@ void ceph_con_v2_revoke_incoming(struct ceph_connection *con)
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
2.34.1


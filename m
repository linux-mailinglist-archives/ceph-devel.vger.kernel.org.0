Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F85B512247
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbiD0TTZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbiD0TTN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B676B0B0
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0B5A7CE275A
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FEEC385AA;
        Wed, 27 Apr 2022 19:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086800;
        bh=y1CHM8STK8OTbioMqhyja91DwJu2qLFOOxUQqODp/bA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGNE8mBZe3K2GFObo09a7nKiFy9hmELDPDW7fUj5+aOa1B5COsFSdxY4l6lyf8rkz
         Qn6xxw7cCWXO1UdTpH2TKHftjoYuNaT06o3lJFapS9bx5cndzHVvI9d9bj6N5fEBBq
         X/EyjaNzkB2Fr0icsBMoGa5KwvidZTLYjDn63PMWnhWlZ+gdeoibAEfHdJcrLZu+Kz
         iMxgDH4iMMdVzdwRuphchbXq0z4+hQFT62rKlunU8bw2rjfDPvQj6Aw5zKysd+li27
         xP7Nvf82LJZxP+hER4ODXfZ5rDYF1abhpTb7W4RHLeg1uR4tX8SayANP6MwxPb+9SV
         39cJBEsTrXvbg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 05/64] libceph: support sparse reads on msgr2 secure codepath
Date:   Wed, 27 Apr 2022 15:12:15 -0400
Message-Id: <20220427191314.222867-6-jlayton@kernel.org>
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

Add a new init_sgs_pages helper that populates the scatterlist from
an arbitrary point in an array of pages.

Change setup_message_sgs to take an optional pointer to an array of
pages. If that's set, then the scatterlist will be set using that
array instead of the cursor.

When given a sparse read on a secure connection, decrypt the data
in-place rather than into the final destination, by passing it the
in_enc_pages array.

After decrypting, run the sparse_read state machine in a loop, copying
data from the decrypted pages until it's complete.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/ceph/messenger_v2.c | 119 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 109 insertions(+), 10 deletions(-)

diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index d527777af584..3dcaee6f8903 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -963,12 +963,48 @@ static void init_sgs_cursor(struct scatterlist **sg,
 	}
 }
 
+/**
+ * init_sgs_pages: set up scatterlist on an array of page pointers
+ * @sg: 	scatterlist to populate
+ * @pages: 	pointer to page array
+ * @dpos:	position in the array to start (bytes)
+ * @dlen:	len to add to sg (bytes)
+ * @pad:	pointer to pad destination (if any)
+ *
+ * Populate the scatterlist from the page array, starting at an arbitrary
+ * byte in the array and running for a specified length.
+ */
+static void init_sgs_pages(struct scatterlist **sg, struct page **pages,
+			     int dpos, int dlen, u8 *pad)
+{
+	int idx = dpos >> PAGE_SHIFT;
+	int off = offset_in_page(dpos);
+	int resid = dlen;
+
+	do {
+		int len = min(resid, (int)PAGE_SIZE - off);
+
+		sg_set_page(*sg, pages[idx], len, off);
+		*sg = sg_next(*sg);
+		off = 0;
+		++idx;
+		resid -= len;
+	} while (resid);
+
+	if (need_padding(dlen)) {
+		sg_set_buf(*sg, pad, padding_len(dlen));
+		*sg = sg_next(*sg);
+	}
+}
+
 static int setup_message_sgs(struct sg_table *sgt, struct ceph_msg *msg,
 			     u8 *front_pad, u8 *middle_pad, u8 *data_pad,
-			     void *epilogue, bool add_tag)
+			     void *epilogue, struct page **pages, int dpos,
+			     bool add_tag)
 {
 	struct ceph_msg_data_cursor cursor;
 	struct scatterlist *cur_sg;
+	int dlen = data_len(msg);
 	int sg_cnt;
 	int ret;
 
@@ -982,9 +1018,15 @@ static int setup_message_sgs(struct sg_table *sgt, struct ceph_msg *msg,
 	if (middle_len(msg))
 		sg_cnt += calc_sg_cnt(msg->middle->vec.iov_base,
 				      middle_len(msg));
-	if (data_len(msg)) {
-		ceph_msg_data_cursor_init(&cursor, msg, data_len(msg));
-		sg_cnt += calc_sg_cnt_cursor(&cursor);
+	if (dlen) {
+		if (pages) {
+			sg_cnt += calc_pages_for(dpos, dlen);
+			if (need_padding(dlen))
+				sg_cnt++;
+		} else {
+			ceph_msg_data_cursor_init(&cursor, msg, dlen);
+			sg_cnt += calc_sg_cnt_cursor(&cursor);
+		}
 	}
 
 	ret = sg_alloc_table(sgt, sg_cnt, GFP_NOIO);
@@ -998,9 +1040,13 @@ static int setup_message_sgs(struct sg_table *sgt, struct ceph_msg *msg,
 	if (middle_len(msg))
 		init_sgs(&cur_sg, msg->middle->vec.iov_base, middle_len(msg),
 			 middle_pad);
-	if (data_len(msg)) {
-		ceph_msg_data_cursor_init(&cursor, msg, data_len(msg));
-		init_sgs_cursor(&cur_sg, &cursor, data_pad);
+	if (dlen) {
+		if (pages) {
+			init_sgs_pages(&cur_sg, pages, dpos, dlen, data_pad);
+		} else {
+			ceph_msg_data_cursor_init(&cursor, msg, dlen);
+			init_sgs_cursor(&cur_sg, &cursor, data_pad);
+		}
 	}
 
 	WARN_ON(!sg_is_last(cur_sg));
@@ -1035,10 +1081,52 @@ static int decrypt_control_remainder(struct ceph_connection *con)
 			 padded_len(rem_len) + CEPH_GCM_TAG_LEN);
 }
 
+/* Process sparse read data that lives in a buffer */
+static int process_v2_sparse_read(struct ceph_connection *con, struct page **pages, int spos)
+{
+	struct ceph_msg_data_cursor *cursor = &con->v2.in_cursor;
+	int ret;
+
+	for (;;) {
+		char *buf = NULL;
+
+		ret = con->ops->sparse_read(con, cursor, &buf);
+		if (ret <= 0)
+			return ret;
+
+		dout("%s: sparse_read return %x buf %p\n", __func__, ret, buf);
+
+		do {
+			int idx = spos >> PAGE_SHIFT;
+			int soff = offset_in_page(spos);
+			struct page *spage = con->v2.in_enc_pages[idx];
+			int len = min_t(int, ret, PAGE_SIZE - soff);
+
+			if (buf) {
+				memcpy_from_page(buf, spage, soff, len);
+				buf += len;
+			} else {
+				struct bio_vec bv;
+
+				get_bvec_at(cursor, &bv);
+				len = min_t(int, len, bv.bv_len);
+				memcpy_page(bv.bv_page, bv.bv_offset,
+					    spage, soff, len);
+				ceph_msg_data_advance(cursor, len);
+			}
+			spos += len;
+			ret -= len;
+		} while (ret);
+	}
+}
+
 static int decrypt_tail(struct ceph_connection *con)
 {
 	struct sg_table enc_sgt = {};
 	struct sg_table sgt = {};
+	struct page **pages = NULL;
+	bool sparse = con->in_msg->sparse_read;
+	int dpos = 0;
 	int tail_len;
 	int ret;
 
@@ -1049,9 +1137,14 @@ static int decrypt_tail(struct ceph_connection *con)
 	if (ret)
 		goto out;
 
+	if (sparse) {
+		dpos = padded_len(front_len(con->in_msg) + padded_len(middle_len(con->in_msg)));
+		pages = con->v2.in_enc_pages;
+	}
+
 	ret = setup_message_sgs(&sgt, con->in_msg, FRONT_PAD(con->v2.in_buf),
-			MIDDLE_PAD(con->v2.in_buf), DATA_PAD(con->v2.in_buf),
-			con->v2.in_buf, true);
+				MIDDLE_PAD(con->v2.in_buf), DATA_PAD(con->v2.in_buf),
+				con->v2.in_buf, pages, dpos, true);
 	if (ret)
 		goto out;
 
@@ -1061,6 +1154,12 @@ static int decrypt_tail(struct ceph_connection *con)
 	if (ret)
 		goto out;
 
+	if (sparse && data_len(con->in_msg)) {
+		ret = process_v2_sparse_read(con, con->v2.in_enc_pages, dpos);
+		if (ret)
+			goto out;
+	}
+
 	WARN_ON(!con->v2.in_enc_page_cnt);
 	ceph_release_page_vector(con->v2.in_enc_pages,
 				 con->v2.in_enc_page_cnt);
@@ -1584,7 +1683,7 @@ static int prepare_message_secure(struct ceph_connection *con)
 
 	encode_epilogue_secure(con, false);
 	ret = setup_message_sgs(&sgt, con->out_msg, zerop, zerop, zerop,
-				&con->v2.out_epil, false);
+				&con->v2.out_epil, NULL, 0, false);
 	if (ret)
 		goto out;
 
-- 
2.35.1


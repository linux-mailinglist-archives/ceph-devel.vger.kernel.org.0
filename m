Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FFF4E7046
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Mar 2022 10:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358551AbiCYJwR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 25 Mar 2022 05:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358536AbiCYJwO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 25 Mar 2022 05:52:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E04C4E23
        for <ceph-devel@vger.kernel.org>; Fri, 25 Mar 2022 02:50:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB4BF610AB
        for <ceph-devel@vger.kernel.org>; Fri, 25 Mar 2022 09:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501F3C340F3;
        Fri, 25 Mar 2022 09:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648201839;
        bh=wjhyNco6Yn9T8gY9YWF2MtoM0zIGacVh39R5B47VgVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m233+Y+YAfE1+dGw46AVb5len8opSQ4GEkX5Oq+PT5vHoZo86FTTkU/zbEmYM95TG
         9wwFtzdXeNQKMY+aoGPdyvXXLXUztdgSeJ/Zls+/Y5iQzidfzAtpuM8uW1gKtswgsX
         w4SEjwq5bjUOSkLMC1WcBr1jM4wYLXQoq+eahG7cYzgvKcgm3XvKNsD4+thsqPfowu
         3C3r6T4e368v4xfq1t0bRQV3Sw81FGAChuE/DjnopXR4feOVZy4yEAwRSivOded3BF
         pj7YIrNzd+NUVmfXC72w4S4HADYkqOYWxNrL070T5/M0B/kj2lUn32CvMQvXI04+cP
         naPoVCRJujowA==
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@gmail.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org
Subject: [PATCH v5 5/7] libceph: support sparse reads on msgr2 secure codepath
Date:   Fri, 25 Mar 2022 05:50:32 -0400
Message-Id: <20220325095034.5217-6-jlayton@kernel.org>
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
 net/ceph/messenger_v2.c | 120 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 110 insertions(+), 10 deletions(-)

diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index 4fc115fd63f3..c9f6b67fcdda 100644
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
@@ -1035,10 +1081,53 @@ static int decrypt_control_remainder(struct ceph_connection *con)
 			 padded_len(rem_len) + CEPH_GCM_TAG_LEN);
 }
 
+/* Process sparse read data that lives in a buffer */
+static int process_v2_sparse_read(struct ceph_connection *con, struct page **pages, int spos)
+{
+	struct ceph_msg_data_cursor *cursor = &con->v2.in_cursor;
+	int ret;
+
+	for (;;) {
+		u64 elen;
+		char *buf = NULL;
+
+		ret = con->ops->sparse_read(con, cursor, &elen, &buf);
+		if (ret <= 0)
+			return ret;
+
+		dout("%s: sparse_read return elen %llx buf %p\n", __func__, elen, buf);
+
+		do {
+			int idx = spos >> PAGE_SHIFT;
+			int soff = offset_in_page(spos);
+			struct page *spage = con->v2.in_enc_pages[idx];
+			int len = min_t(int, elen, PAGE_SIZE - soff);
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
+			elen -= len;
+		} while (elen);
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
 
@@ -1049,9 +1138,14 @@ static int decrypt_tail(struct ceph_connection *con)
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
 
@@ -1061,6 +1155,12 @@ static int decrypt_tail(struct ceph_connection *con)
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
@@ -1584,7 +1684,7 @@ static int prepare_message_secure(struct ceph_connection *con)
 
 	encode_epilogue_secure(con, false);
 	ret = setup_message_sgs(&sgt, con->out_msg, zerop, zerop, zerop,
-				&con->v2.out_epil, false);
+				&con->v2.out_epil, NULL, 0, false);
 	if (ret)
 		goto out;
 
-- 
2.35.1


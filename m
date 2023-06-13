Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8941772D916
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 07:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239556AbjFMF2A (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 01:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239835AbjFMF1y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 01:27:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD9E127
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 22:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686634023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0fQ/9T1EA6wrm/18WwTit4oNCYG6ZbrAcAIIMz9EFxo=;
        b=PJHGtvRpFFyu+cYeNHLniC9kDsdWM9jNg86rRwhj1wnHr6/0v0/GHB1bJjg+y3IHS9FHeN
        c3eP0FWZkr2UyW3mUi4oPQNWYuDCPTz2CYnHQYSyiqLSJNNMc/PSdD4LCh7uuuDcAkleZs
        dxWfA7QEiEQGcc9LWmK9CJk1LVtkNaQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-288-h15eGaH3MEiCZIGXT7L1Hg-1; Tue, 13 Jun 2023 01:27:00 -0400
X-MC-Unique: h15eGaH3MEiCZIGXT7L1Hg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEA7C381494B;
        Tue, 13 Jun 2023 05:26:59 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1C461121314;
        Tue, 13 Jun 2023 05:26:56 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v20 05/71] libceph: support sparse reads on msgr2 secure codepath
Date:   Tue, 13 Jun 2023 13:23:18 +0800
Message-Id: <20230613052424.254540-6-xiubli@redhat.com>
In-Reply-To: <20230613052424.254540-1-xiubli@redhat.com>
References: <20230613052424.254540-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

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

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/ceph/messenger_v2.c | 119 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 109 insertions(+), 10 deletions(-)

diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index a0becd553d7c..a31ac13d5451 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -959,12 +959,48 @@ static void init_sgs_cursor(struct scatterlist **sg,
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
 
@@ -978,9 +1014,15 @@ static int setup_message_sgs(struct sg_table *sgt, struct ceph_msg *msg,
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
@@ -994,9 +1036,13 @@ static int setup_message_sgs(struct sg_table *sgt, struct ceph_msg *msg,
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
@@ -1031,10 +1077,52 @@ static int decrypt_control_remainder(struct ceph_connection *con)
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
 
@@ -1045,9 +1133,14 @@ static int decrypt_tail(struct ceph_connection *con)
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
 
@@ -1057,6 +1150,12 @@ static int decrypt_tail(struct ceph_connection *con)
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
@@ -1580,7 +1679,7 @@ static int prepare_message_secure(struct ceph_connection *con)
 
 	encode_epilogue_secure(con, false);
 	ret = setup_message_sgs(&sgt, con->out_msg, zerop, zerop, zerop,
-				&con->v2.out_epil, false);
+				&con->v2.out_epil, NULL, 0, false);
 	if (ret)
 		goto out;
 
-- 
2.40.1


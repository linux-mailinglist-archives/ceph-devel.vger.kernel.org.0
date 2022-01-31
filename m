Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6051F4A4B21
	for <lists+ceph-devel@lfdr.de>; Mon, 31 Jan 2022 16:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379961AbiAaP6f (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 31 Jan 2022 10:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379958AbiAaP6d (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 31 Jan 2022 10:58:33 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0D2C06173B
        for <ceph-devel@vger.kernel.org>; Mon, 31 Jan 2022 07:58:32 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id n8so10563311wmk.3
        for <ceph-devel@vger.kernel.org>; Mon, 31 Jan 2022 07:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l59SmEfhe5VrFF/Mv46A3pnWk0K5Upz2o+LdNXFdhtI=;
        b=GQKEpXFnsdqFoG6vh2SGs/NsxNhXILlKw6rFDr4QURnu2ifu5fh0uyEDYUudiG/2bt
         GCp8G+hrZjiYfeRIVsHsv/3/+bvAP36PJ+9ndsbgUQozTUzS3ZBsLP1gPDDk8UE5SfMA
         FPPGQ9XvNmTYhyxfdvPH1lRi7n1P06cJrHAdPQKPkRg4mx0CD4PCMmq0c1cPafDa/HKj
         FXzjoCE7kayY+5fEbLg46mJNNORQB43Ewha1hIPp1ZEBkoU6NwW4kuymo9x3ZiS0MO3f
         Ojmaa8v+iZrxBBwh+XQMF5OJL9b+hhSOVUeJdj2ElzXAJjJraWpT60GuaRCj6PnviWQ1
         /Pug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l59SmEfhe5VrFF/Mv46A3pnWk0K5Upz2o+LdNXFdhtI=;
        b=cxH+uV9586hfe1wqTZaF/nqWJ7VwKEf8EEAfowoLqxL8e9PfE35GU71vNryo79Lwut
         T4nqUUCUFREHyhIoWD+dgAoUjc7fskbDl3b1NIfcO6XAj7VhCdIMcwThp5I1QqhD1dWf
         SbQ6SVtrviON+9vyZC/8YXTmlGJDUX5lhkV/d7sdg/pZ9/MIOZiaBpeU4ihZeFxTievR
         xoPRQAzC0kZCw8KAGHRx8UBHvVRrftsAUqf9t7mr4nBfeVI8tcZ8IPKUhuFzGeDWrqNm
         rPakD9jEiZi63JKDrG41a4Dre2iXI84J2y4MFNR+BVISeoSfdHo9TXtb4Z7pY50vK7wU
         qsIg==
X-Gm-Message-State: AOAM532hIWeZ7ZaQ4dNRpmhlAmID7C9i7ziWeh4bXQBZP8WWv2w/MHkX
        P7Er535obdLmgdVWuAqA5E96uPqEcvQ=
X-Google-Smtp-Source: ABdhPJxS1ar0pvviyOEc+JOWG+CUG0ZhcRnh1ZiFVT7W2V5tUoGS9yevZ4NwhyaLzCEpZ+KljkpfJA==
X-Received: by 2002:a05:600c:3ac5:: with SMTP id d5mr5267272wms.101.1643644711262;
        Mon, 31 Jan 2022 07:58:31 -0800 (PST)
Received: from kwango.local (ip-89-102-68-162.net.upcbroadband.cz. [89.102.68.162])
        by smtp.gmail.com with ESMTPSA id m8sm11997075wrn.106.2022.01.31.07.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 07:58:30 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 1/2] libceph: make recv path in secure mode work the same as send path
Date:   Mon, 31 Jan 2022 16:58:45 +0100
Message-Id: <20220131155846.32411-2-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20220131155846.32411-1-idryomov@gmail.com>
References: <20220131155846.32411-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The recv path of secure mode is intertwined with that of crc mode.
While it's slightly more efficient that way (the ciphertext is read
into the destination buffer and decrypted in place, thus avoiding
two potentially heavy memory allocations for the bounce buffer and
the corresponding sg array), it isn't really amenable to changes.
Sacrifice that edge and align with the send path which always uses
a full-sized bounce buffer (currently there is no other way -- if
the kernel crypto API ever grows support for streaming (piecewise)
en/decryption for GCM [1], we would be able to easily take advantage
of that on both sides).

[1] https://lore.kernel.org/all/20141225202830.GA18794@gondor.apana.org.au/

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 include/linux/ceph/messenger.h |   4 +
 net/ceph/messenger_v2.c        | 231 ++++++++++++++++++++++-----------
 2 files changed, 162 insertions(+), 73 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index ff99ce094cfa..6c6b6ea52bb8 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -383,6 +383,10 @@ struct ceph_connection_v2_info {
 	struct ceph_gcm_nonce in_gcm_nonce;
 	struct ceph_gcm_nonce out_gcm_nonce;
 
+	struct page **in_enc_pages;
+	int in_enc_page_cnt;
+	int in_enc_resid;
+	int in_enc_i;
 	struct page **out_enc_pages;
 	int out_enc_page_cnt;
 	int out_enc_resid;
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index c4099b641b38..d34349f112b0 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -57,8 +57,9 @@
 #define IN_S_HANDLE_CONTROL_REMAINDER	3
 #define IN_S_PREPARE_READ_DATA		4
 #define IN_S_PREPARE_READ_DATA_CONT	5
-#define IN_S_HANDLE_EPILOGUE		6
-#define IN_S_FINISH_SKIP		7
+#define IN_S_PREPARE_READ_ENC_PAGE	6
+#define IN_S_HANDLE_EPILOGUE		7
+#define IN_S_FINISH_SKIP		8
 
 #define OUT_S_QUEUE_DATA		1
 #define OUT_S_QUEUE_DATA_CONT		2
@@ -1032,22 +1033,41 @@ static int decrypt_control_remainder(struct ceph_connection *con)
 			 padded_len(rem_len) + CEPH_GCM_TAG_LEN);
 }
 
-static int decrypt_message(struct ceph_connection *con)
+static int decrypt_tail(struct ceph_connection *con)
 {
+	struct sg_table enc_sgt = {};
 	struct sg_table sgt = {};
+	int tail_len;
 	int ret;
 
+	tail_len = tail_onwire_len(con->in_msg, true);
+	ret = sg_alloc_table_from_pages(&enc_sgt, con->v2.in_enc_pages,
+					con->v2.in_enc_page_cnt, 0, tail_len,
+					GFP_NOIO);
+	if (ret)
+		goto out;
+
 	ret = setup_message_sgs(&sgt, con->in_msg, FRONT_PAD(con->v2.in_buf),
 			MIDDLE_PAD(con->v2.in_buf), DATA_PAD(con->v2.in_buf),
 			con->v2.in_buf, true);
 	if (ret)
 		goto out;
 
-	ret = gcm_crypt(con, false, sgt.sgl, sgt.sgl,
-			tail_onwire_len(con->in_msg, true));
+	dout("%s con %p msg %p enc_page_cnt %d sg_cnt %d\n", __func__, con,
+	     con->in_msg, con->v2.in_enc_page_cnt, sgt.orig_nents);
+	ret = gcm_crypt(con, false, enc_sgt.sgl, sgt.sgl, tail_len);
+	if (ret)
+		goto out;
+
+	WARN_ON(!con->v2.in_enc_page_cnt);
+	ceph_release_page_vector(con->v2.in_enc_pages,
+				 con->v2.in_enc_page_cnt);
+	con->v2.in_enc_pages = NULL;
+	con->v2.in_enc_page_cnt = 0;
 
 out:
 	sg_free_table(&sgt);
+	sg_free_table(&enc_sgt);
 	return ret;
 }
 
@@ -1737,8 +1757,7 @@ static void prepare_read_data(struct ceph_connection *con)
 {
 	struct bio_vec bv;
 
-	if (!con_secure(con))
-		con->in_data_crc = -1;
+	con->in_data_crc = -1;
 	ceph_msg_data_cursor_init(&con->v2.in_cursor, con->in_msg,
 				  data_len(con->in_msg));
 
@@ -1751,11 +1770,10 @@ static void prepare_read_data_cont(struct ceph_connection *con)
 {
 	struct bio_vec bv;
 
-	if (!con_secure(con))
-		con->in_data_crc = ceph_crc32c_page(con->in_data_crc,
-						    con->v2.in_bvec.bv_page,
-						    con->v2.in_bvec.bv_offset,
-						    con->v2.in_bvec.bv_len);
+	con->in_data_crc = ceph_crc32c_page(con->in_data_crc,
+					    con->v2.in_bvec.bv_page,
+					    con->v2.in_bvec.bv_offset,
+					    con->v2.in_bvec.bv_len);
 
 	ceph_msg_data_advance(&con->v2.in_cursor, con->v2.in_bvec.bv_len);
 	if (con->v2.in_cursor.total_resid) {
@@ -1766,21 +1784,100 @@ static void prepare_read_data_cont(struct ceph_connection *con)
 	}
 
 	/*
-	 * We've read all data.  Prepare to read data padding (if any)
-	 * and epilogue.
+	 * We've read all data.  Prepare to read epilogue.
 	 */
 	reset_in_kvecs(con);
-	if (con_secure(con)) {
-		if (need_padding(data_len(con->in_msg)))
-			add_in_kvec(con, DATA_PAD(con->v2.in_buf),
-				    padding_len(data_len(con->in_msg)));
-		add_in_kvec(con, con->v2.in_buf, CEPH_EPILOGUE_SECURE_LEN);
+	add_in_kvec(con, con->v2.in_buf, CEPH_EPILOGUE_PLAIN_LEN);
+	con->v2.in_state = IN_S_HANDLE_EPILOGUE;
+}
+
+static void prepare_read_tail_plain(struct ceph_connection *con)
+{
+	struct ceph_msg *msg = con->in_msg;
+
+	if (!front_len(msg) && !middle_len(msg)) {
+		WARN_ON(!data_len(msg));
+		prepare_read_data(con);
+		return;
+	}
+
+	reset_in_kvecs(con);
+	if (front_len(msg)) {
+		WARN_ON(front_len(msg) > msg->front_alloc_len);
+		add_in_kvec(con, msg->front.iov_base, front_len(msg));
+		msg->front.iov_len = front_len(msg);
+	} else {
+		msg->front.iov_len = 0;
+	}
+	if (middle_len(msg)) {
+		WARN_ON(middle_len(msg) > msg->middle->alloc_len);
+		add_in_kvec(con, msg->middle->vec.iov_base, middle_len(msg));
+		msg->middle->vec.iov_len = middle_len(msg);
+	} else if (msg->middle) {
+		msg->middle->vec.iov_len = 0;
+	}
+
+	if (data_len(msg)) {
+		con->v2.in_state = IN_S_PREPARE_READ_DATA;
 	} else {
 		add_in_kvec(con, con->v2.in_buf, CEPH_EPILOGUE_PLAIN_LEN);
+		con->v2.in_state = IN_S_HANDLE_EPILOGUE;
+	}
+}
+
+static void prepare_read_enc_page(struct ceph_connection *con)
+{
+	struct bio_vec bv;
+
+	dout("%s con %p i %d resid %d\n", __func__, con, con->v2.in_enc_i,
+	     con->v2.in_enc_resid);
+	WARN_ON(!con->v2.in_enc_resid);
+
+	bv.bv_page = con->v2.in_enc_pages[con->v2.in_enc_i];
+	bv.bv_offset = 0;
+	bv.bv_len = min(con->v2.in_enc_resid, (int)PAGE_SIZE);
+
+	set_in_bvec(con, &bv);
+	con->v2.in_enc_i++;
+	con->v2.in_enc_resid -= bv.bv_len;
+
+	if (con->v2.in_enc_resid) {
+		con->v2.in_state = IN_S_PREPARE_READ_ENC_PAGE;
+		return;
 	}
+
+	/*
+	 * We are set to read the last piece of ciphertext (ending
+	 * with epilogue) + auth tag.
+	 */
+	WARN_ON(con->v2.in_enc_i != con->v2.in_enc_page_cnt);
 	con->v2.in_state = IN_S_HANDLE_EPILOGUE;
 }
 
+static int prepare_read_tail_secure(struct ceph_connection *con)
+{
+	struct page **enc_pages;
+	int enc_page_cnt;
+	int tail_len;
+
+	tail_len = tail_onwire_len(con->in_msg, true);
+	WARN_ON(!tail_len);
+
+	enc_page_cnt = calc_pages_for(0, tail_len);
+	enc_pages = ceph_alloc_page_vector(enc_page_cnt, GFP_NOIO);
+	if (IS_ERR(enc_pages))
+		return PTR_ERR(enc_pages);
+
+	WARN_ON(con->v2.in_enc_pages || con->v2.in_enc_page_cnt);
+	con->v2.in_enc_pages = enc_pages;
+	con->v2.in_enc_page_cnt = enc_page_cnt;
+	con->v2.in_enc_resid = tail_len;
+	con->v2.in_enc_i = 0;
+
+	prepare_read_enc_page(con);
+	return 0;
+}
+
 static void __finish_skip(struct ceph_connection *con)
 {
 	con->in_seq++;
@@ -2589,46 +2686,13 @@ static int __handle_control(struct ceph_connection *con, void *p)
 	}
 
 	msg = con->in_msg;  /* set in process_message_header() */
-	if (!front_len(msg) && !middle_len(msg)) {
-		if (!data_len(msg))
-			return process_message(con);
-
-		prepare_read_data(con);
-		return 0;
-	}
-
-	reset_in_kvecs(con);
-	if (front_len(msg)) {
-		WARN_ON(front_len(msg) > msg->front_alloc_len);
-		add_in_kvec(con, msg->front.iov_base, front_len(msg));
-		msg->front.iov_len = front_len(msg);
-
-		if (con_secure(con) && need_padding(front_len(msg)))
-			add_in_kvec(con, FRONT_PAD(con->v2.in_buf),
-				    padding_len(front_len(msg)));
-	} else {
-		msg->front.iov_len = 0;
-	}
-	if (middle_len(msg)) {
-		WARN_ON(middle_len(msg) > msg->middle->alloc_len);
-		add_in_kvec(con, msg->middle->vec.iov_base, middle_len(msg));
-		msg->middle->vec.iov_len = middle_len(msg);
+	if (!front_len(msg) && !middle_len(msg) && !data_len(msg))
+		return process_message(con);
 
-		if (con_secure(con) && need_padding(middle_len(msg)))
-			add_in_kvec(con, MIDDLE_PAD(con->v2.in_buf),
-				    padding_len(middle_len(msg)));
-	} else if (msg->middle) {
-		msg->middle->vec.iov_len = 0;
-	}
+	if (con_secure(con))
+		return prepare_read_tail_secure(con);
 
-	if (data_len(msg)) {
-		con->v2.in_state = IN_S_PREPARE_READ_DATA;
-	} else {
-		add_in_kvec(con, con->v2.in_buf,
-			    con_secure(con) ? CEPH_EPILOGUE_SECURE_LEN :
-					      CEPH_EPILOGUE_PLAIN_LEN);
-		con->v2.in_state = IN_S_HANDLE_EPILOGUE;
-	}
+	prepare_read_tail_plain(con);
 	return 0;
 }
 
@@ -2717,7 +2781,7 @@ static int handle_epilogue(struct ceph_connection *con)
 	int ret;
 
 	if (con_secure(con)) {
-		ret = decrypt_message(con);
+		ret = decrypt_tail(con);
 		if (ret) {
 			if (ret == -EBADMSG)
 				con->error_msg = "integrity error, bad epilogue auth tag";
@@ -2792,6 +2856,10 @@ static int populate_in_iter(struct ceph_connection *con)
 			prepare_read_data_cont(con);
 			ret = 0;
 			break;
+		case IN_S_PREPARE_READ_ENC_PAGE:
+			prepare_read_enc_page(con);
+			ret = 0;
+			break;
 		case IN_S_HANDLE_EPILOGUE:
 			ret = handle_epilogue(con);
 			break;
@@ -3326,20 +3394,16 @@ void ceph_con_v2_revoke(struct ceph_connection *con)
 
 static void revoke_at_prepare_read_data(struct ceph_connection *con)
 {
-	int remaining;  /* data + [data padding] + epilogue */
+	int remaining;
 	int resid;
 
+	WARN_ON(con_secure(con));
 	WARN_ON(!data_len(con->in_msg));
 	WARN_ON(!iov_iter_is_kvec(&con->v2.in_iter));
 	resid = iov_iter_count(&con->v2.in_iter);
 	WARN_ON(!resid);
 
-	if (con_secure(con))
-		remaining = padded_len(data_len(con->in_msg)) +
-			    CEPH_EPILOGUE_SECURE_LEN;
-	else
-		remaining = data_len(con->in_msg) + CEPH_EPILOGUE_PLAIN_LEN;
-
+	remaining = data_len(con->in_msg) + CEPH_EPILOGUE_PLAIN_LEN;
 	dout("%s con %p resid %d remaining %d\n", __func__, con, resid,
 	     remaining);
 	con->v2.in_iter.count -= resid;
@@ -3350,8 +3414,9 @@ static void revoke_at_prepare_read_data(struct ceph_connection *con)
 static void revoke_at_prepare_read_data_cont(struct ceph_connection *con)
 {
 	int recved, resid;  /* current piece of data */
-	int remaining;  /* [data padding] + epilogue */
+	int remaining;
 
+	WARN_ON(con_secure(con));
 	WARN_ON(!data_len(con->in_msg));
 	WARN_ON(!iov_iter_is_bvec(&con->v2.in_iter));
 	resid = iov_iter_count(&con->v2.in_iter);
@@ -3363,12 +3428,7 @@ static void revoke_at_prepare_read_data_cont(struct ceph_connection *con)
 		ceph_msg_data_advance(&con->v2.in_cursor, recved);
 	WARN_ON(resid > con->v2.in_cursor.total_resid);
 
-	if (con_secure(con))
-		remaining = padding_len(data_len(con->in_msg)) +
-			    CEPH_EPILOGUE_SECURE_LEN;
-	else
-		remaining = CEPH_EPILOGUE_PLAIN_LEN;
-
+	remaining = CEPH_EPILOGUE_PLAIN_LEN;
 	dout("%s con %p total_resid %zu remaining %d\n", __func__, con,
 	     con->v2.in_cursor.total_resid, remaining);
 	con->v2.in_iter.count -= resid;
@@ -3376,11 +3436,26 @@ static void revoke_at_prepare_read_data_cont(struct ceph_connection *con)
 	con->v2.in_state = IN_S_FINISH_SKIP;
 }
 
+static void revoke_at_prepare_read_enc_page(struct ceph_connection *con)
+{
+	int resid;  /* current enc page (not necessarily data) */
+
+	WARN_ON(!con_secure(con));
+	WARN_ON(!iov_iter_is_bvec(&con->v2.in_iter));
+	resid = iov_iter_count(&con->v2.in_iter);
+	WARN_ON(!resid || resid > con->v2.in_bvec.bv_len);
+
+	dout("%s con %p resid %d enc_resid %d\n", __func__, con, resid,
+	     con->v2.in_enc_resid);
+	con->v2.in_iter.count -= resid;
+	set_in_skip(con, resid + con->v2.in_enc_resid);
+	con->v2.in_state = IN_S_FINISH_SKIP;
+}
+
 static void revoke_at_handle_epilogue(struct ceph_connection *con)
 {
 	int resid;
 
-	WARN_ON(!iov_iter_is_kvec(&con->v2.in_iter));
 	resid = iov_iter_count(&con->v2.in_iter);
 	WARN_ON(!resid);
 
@@ -3399,6 +3474,9 @@ void ceph_con_v2_revoke_incoming(struct ceph_connection *con)
 	case IN_S_PREPARE_READ_DATA_CONT:
 		revoke_at_prepare_read_data_cont(con);
 		break;
+	case IN_S_PREPARE_READ_ENC_PAGE:
+		revoke_at_prepare_read_enc_page(con);
+		break;
 	case IN_S_HANDLE_EPILOGUE:
 		revoke_at_handle_epilogue(con);
 		break;
@@ -3432,6 +3510,13 @@ void ceph_con_v2_reset_protocol(struct ceph_connection *con)
 	clear_out_sign_kvecs(con);
 	free_conn_bufs(con);
 
+	if (con->v2.in_enc_pages) {
+		WARN_ON(!con->v2.in_enc_page_cnt);
+		ceph_release_page_vector(con->v2.in_enc_pages,
+					 con->v2.in_enc_page_cnt);
+		con->v2.in_enc_pages = NULL;
+		con->v2.in_enc_page_cnt = 0;
+	}
 	if (con->v2.out_enc_pages) {
 		WARN_ON(!con->v2.out_enc_page_cnt);
 		ceph_release_page_vector(con->v2.out_enc_pages,
-- 
2.19.2


Return-Path: <ceph-devel+bounces-3358-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34E0BB1C3C7
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Aug 2025 11:49:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 176607A49F5
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Aug 2025 09:47:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0A5628AAFF;
	Wed,  6 Aug 2025 09:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Y31hDOo+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F9D1FBE80
	for <ceph-devel@vger.kernel.org>; Wed,  6 Aug 2025 09:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754473746; cv=none; b=FMiV5W1vhz3EtfOleIM9jKmge8XeFeml8eSq7wVeGH1nbCo6CSdB9jfoM6kpnUl7F0D8mF389Wib8GC6eTLn3QOTOFHSPXC6urQ21HQ2HWBqmMBw0xLYXwO5bxXYujXAsy3Du9xYUUxwLbVjbYSqeqR8e77rMMlr1EbLO+WDWpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754473746; c=relaxed/simple;
	bh=KuPqiPkzpuEgpSTW5Lw965/HuKo2hxH4/HmhS9Ztj/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBN5TulrfKXa2EtxfaULOLopxViiCV5soaRj3uYLZ56Fm+iIBUZ0D8t55/iXF5f2fmOdZN2J2bOeOLHSSjc9PSN9olUOiom2FMCXZk9alXFgGzJCKOdIPryA1EtZ/bEwc57s+y38pU9FkRruWDGK3dptC/xsh/2zv1yJsqFoyrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Y31hDOo+; arc=none smtp.client-ip=209.85.218.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-af66d49daffso944857566b.1
        for <ceph-devel@vger.kernel.org>; Wed, 06 Aug 2025 02:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1754473742; x=1755078542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mq5ixE05IMWfqlj1BPAwhSO/PR5iAWhaNwuEsAaJEgc=;
        b=Y31hDOo+oHJyz99J1MnouJ35ubzUcocvYz4agraaMmfPCLZrFJ8rZZ/UU9OEn7n0Ib
         nF3ZTzYVbxmWTTWekUZjlAqr+LtrIz0/ZE2kHHfuo+Nv8oSPENtrbyx5HOOofpF0Da2b
         a+8crH7r+hQTY66/+p/4FEmrXIPWOQL6nY76Q8ttsw/Y8iEgNmiATCRj9ng424fhB3kd
         bYKIRSMLDQ56pZfE9wGnLBwLRYNrEUvLmwp54DZUw4T7WsZQ/vaW5K8JUor/FV41bc8x
         c1CKrYJrQix1EfEnEx7vfg9VgOd04YHc4P69kvscddZi4v6XQB72M8nMa3TRhlS7dvO+
         mWfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754473742; x=1755078542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mq5ixE05IMWfqlj1BPAwhSO/PR5iAWhaNwuEsAaJEgc=;
        b=Suo/KRVVTbIucRRzHFhl+f2Q4xb4TwNn85Md77INiNfMsrbU+zbLncDxSp5482MfsL
         q2jDnkZBFWdD25InvCDMvgPJGk7nBbGPYPo16kXSowAssn/a+m8i4k0KTSCURm/WjKcK
         MZfYCYTrnhR0j7D4XirRH/upo9lM/9eXBEFhb1Nw57W613vLXTSfQj3qGtNjh6LYJBH+
         jv/mQrvuJOkGtTyRjqsB6bnEmJazrbD6VQTitSYIQrQ/FmzCAe9/FMPq0+hKHAR8i8q9
         EpafX8XztlfFydw0WWz+/9iVVSZGJBya8XgO8ZbW3FHfoRo7rdOBL1Gfwc569EeoZPH8
         7LBA==
X-Forwarded-Encrypted: i=1; AJvYcCVs2X5KJ61HYw553lDgYctEBu3bZDoXNzsbG1LceHkCvnNA4ZQ4yQJ0RqusOl884WpKm0uNffPt6Z4I@vger.kernel.org
X-Gm-Message-State: AOJu0YzldjU99NrIU3dALyj88Y7j5RUzwB2F4twRKlzbxxl5ckKgcrj/
	m8UUU6sC+RmrAfpQbMHH6IuA3OavVqwHNkN/L8ltRYjz75xoo5QrRyp2EmhPu6N82HQ=
X-Gm-Gg: ASbGncsiOik0JuaI4tgcJMnCnGvC+6cValTH1SyTrt0W289ij0+2rkLZMtNKMJS/lJK
	49fDbTZujnQXTGyrEExJYA8+PX/gMf+ef77hqANsXKBAujGiVZwpxSx+/zAEqjUcScSZyVKke5T
	/rc0E9y3+oW8fGR9id8lai9glZ46eQ3CeyAkVJS9eQdbkY0HtvIJfcYu1aSvPGidVE/E1KQE39Y
	0doMVvRAkTNLpH3I41VWny7yYJX9rN2Wq2Mygo9GZPacvO0R0TAwYB+Z739MvnMcm9qYa7Xs32M
	ASsfPTxWZuThGzdZjX5dBhcGVYbuHh8/L9uoUa9D2MdGDoRDNjOH9XY/UbhSs+lB6F2aQ1GQxSf
	TaPr1huMgO/55j0ZLC6ElRg+K05R1Bn28mOc8B90YhtucascPk2azEWUed5YSIGATgCRrRuBQaA
	W7Ef0HLuoOiOE4p4d8H8QPZCkHlsAeav+k
X-Google-Smtp-Source: AGHT+IHT1A999TTyOU0FT1zAlZBIgKdIFMNfoSGEWaaPRe+4qvlcIBx3SD7h6siEJfs9RZvQwvIlfQ==
X-Received: by 2002:a17:907:9409:b0:af6:361a:eac0 with SMTP id a640c23a62f3a-af992b4c219mr156934966b.32.1754473741767;
        Wed, 06 Aug 2025 02:49:01 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f12d500023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f12:d500:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8f00247sm10139093a12.9.2025.08.06.02.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 02:49:01 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: xiubli@redhat.com,
	idryomov@gmail.com,
	amarkuze@redhat.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 2/3] net/ceph/messenger_v[12]: pass ceph_msg* instead of loading con->out_msg
Date: Wed,  6 Aug 2025 11:48:54 +0200
Message-ID: <20250806094855.268799-3-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250806094855.268799-1-max.kellermann@ionos.com>
References: <20250806094855.268799-1-max.kellermann@ionos.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This pointer is in a register anyway, so let's use that instead of
reloading from memory everywhere.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/ceph/messenger.h |   4 +-
 net/ceph/messenger.c           |   4 +-
 net/ceph/messenger_v1.c        |  43 +++++----
 net/ceph/messenger_v2.c        | 158 ++++++++++++++++-----------------
 4 files changed, 102 insertions(+), 107 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 57fa70c6edfb..585844a28237 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -553,7 +553,7 @@ struct ceph_msg *ceph_con_get_out_msg(struct ceph_connection *con);
 /* messenger_v1.c */
 int ceph_con_v1_try_read(struct ceph_connection *con);
 int ceph_con_v1_try_write(struct ceph_connection *con);
-void ceph_con_v1_revoke(struct ceph_connection *con);
+void ceph_con_v1_revoke(struct ceph_connection *con, struct ceph_msg *msg);
 void ceph_con_v1_revoke_incoming(struct ceph_connection *con);
 bool ceph_con_v1_opened(struct ceph_connection *con);
 void ceph_con_v1_reset_session(struct ceph_connection *con);
@@ -562,7 +562,7 @@ void ceph_con_v1_reset_protocol(struct ceph_connection *con);
 /* messenger_v2.c */
 int ceph_con_v2_try_read(struct ceph_connection *con);
 int ceph_con_v2_try_write(struct ceph_connection *con);
-void ceph_con_v2_revoke(struct ceph_connection *con);
+void ceph_con_v2_revoke(struct ceph_connection *con, struct ceph_msg *msg);
 void ceph_con_v2_revoke_incoming(struct ceph_connection *con);
 bool ceph_con_v2_opened(struct ceph_connection *con);
 void ceph_con_v2_reset_session(struct ceph_connection *con);
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 7ab2176b977e..424fb2769b71 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1792,9 +1792,9 @@ void ceph_msg_revoke(struct ceph_msg *msg)
 		WARN_ON(con->state != CEPH_CON_S_OPEN);
 		dout("%s con %p msg %p was sending\n", __func__, con, msg);
 		if (ceph_msgr2(from_msgr(con->msgr)))
-			ceph_con_v2_revoke(con);
+			ceph_con_v2_revoke(con, msg);
 		else
-			ceph_con_v1_revoke(con);
+			ceph_con_v1_revoke(con, msg);
 		ceph_msg_put(con->out_msg);
 		con->out_msg = NULL;
 	} else {
diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index eebe4e19d75a..516f2eeb122a 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -169,10 +169,8 @@ static void prepare_message_data(struct ceph_msg *msg, u32 data_len)
  * Prepare footer for currently outgoing message, and finish things
  * off.  Assumes out_kvec* are already valid.. we just add on to the end.
  */
-static void prepare_write_message_footer(struct ceph_connection *con)
+static void prepare_write_message_footer(struct ceph_connection *con, struct ceph_msg *m)
 {
-	struct ceph_msg *m = con->out_msg;
-
 	m->footer.flags |= CEPH_MSG_FOOTER_COMPLETE;
 
 	dout("prepare_write_message_footer %p\n", con);
@@ -230,31 +228,31 @@ static void prepare_write_message(struct ceph_connection *con)
 
 	/* fill in hdr crc and finalize hdr */
 	crc = crc32c(0, &m->hdr, offsetof(struct ceph_msg_header, crc));
-	con->out_msg->hdr.crc = cpu_to_le32(crc);
-	memcpy(&con->v1.out_hdr, &con->out_msg->hdr, sizeof(con->v1.out_hdr));
+	m->hdr.crc = cpu_to_le32(crc);
+	memcpy(&con->v1.out_hdr, &m->hdr, sizeof(con->v1.out_hdr));
 
 	/* fill in front and middle crc, footer */
 	crc = crc32c(0, m->front.iov_base, m->front.iov_len);
-	con->out_msg->footer.front_crc = cpu_to_le32(crc);
+	m->footer.front_crc = cpu_to_le32(crc);
 	if (m->middle) {
 		crc = crc32c(0, m->middle->vec.iov_base,
 				m->middle->vec.iov_len);
-		con->out_msg->footer.middle_crc = cpu_to_le32(crc);
+		m->footer.middle_crc = cpu_to_le32(crc);
 	} else
-		con->out_msg->footer.middle_crc = 0;
+		m->footer.middle_crc = 0;
 	dout("%s front_crc %u middle_crc %u\n", __func__,
-	     le32_to_cpu(con->out_msg->footer.front_crc),
-	     le32_to_cpu(con->out_msg->footer.middle_crc));
-	con->out_msg->footer.flags = 0;
+	     le32_to_cpu(m->footer.front_crc),
+	     le32_to_cpu(m->footer.middle_crc));
+	m->footer.flags = 0;
 
 	/* is there a data payload? */
-	con->out_msg->footer.data_crc = 0;
+	m->footer.data_crc = 0;
 	if (m->data_length) {
-		prepare_message_data(con->out_msg, m->data_length);
+		prepare_message_data(m, m->data_length);
 		con->v1.out_more = 1;  /* data + footer will follow */
 	} else {
 		/* no, queue up footer too and be done */
-		prepare_write_message_footer(con);
+		prepare_write_message_footer(con, m);
 	}
 
 	ceph_con_flag_set(con, CEPH_CON_F_WRITE_PENDING);
@@ -461,9 +459,8 @@ static int write_partial_kvec(struct ceph_connection *con)
  *  0 -> socket full, but more to do
  * <0 -> error
  */
-static int write_partial_message_data(struct ceph_connection *con)
+static int write_partial_message_data(struct ceph_connection *con, struct ceph_msg *msg)
 {
-	struct ceph_msg *msg = con->out_msg;
 	struct ceph_msg_data_cursor *cursor = &msg->cursor;
 	bool do_datacrc = !ceph_test_opt(from_msgr(con->msgr), NOCRC);
 	u32 crc;
@@ -515,7 +512,7 @@ static int write_partial_message_data(struct ceph_connection *con)
 	else
 		msg->footer.flags |= CEPH_MSG_FOOTER_NOCRC;
 	con_out_kvec_reset(con);
-	prepare_write_message_footer(con);
+	prepare_write_message_footer(con, msg);
 
 	return 1;	/* must return > 0 to indicate success */
 }
@@ -1471,6 +1468,7 @@ int ceph_con_v1_try_read(struct ceph_connection *con)
  */
 int ceph_con_v1_try_write(struct ceph_connection *con)
 {
+	struct ceph_msg *msg;
 	int ret = 1;
 
 	dout("try_write start %p state %d\n", con, con->state);
@@ -1517,14 +1515,15 @@ int ceph_con_v1_try_write(struct ceph_connection *con)
 	}
 
 	/* msg pages? */
-	if (con->out_msg) {
+	msg = con->out_msg;
+	if (msg) {
 		if (con->v1.out_msg_done) {
-			ceph_msg_put(con->out_msg);
+			ceph_msg_put(msg);
 			con->out_msg = NULL;   /* we're done with this one */
 			goto do_next;
 		}
 
-		ret = write_partial_message_data(con);
+		ret = write_partial_message_data(con, msg);
 		if (ret == 1)
 			goto more;  /* we need to send the footer, too! */
 		if (ret == 0)
@@ -1563,10 +1562,8 @@ int ceph_con_v1_try_write(struct ceph_connection *con)
 	return ret;
 }
 
-void ceph_con_v1_revoke(struct ceph_connection *con)
+void ceph_con_v1_revoke(struct ceph_connection *con, struct ceph_msg *msg)
 {
-	struct ceph_msg *msg = con->out_msg;
-
 	WARN_ON(con->v1.out_skip);
 	/* footer */
 	if (con->v1.out_msg_done) {
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index 5483b4eed94e..90109fa0fe60 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -1589,10 +1589,10 @@ static int prepare_ack(struct ceph_connection *con)
 	return prepare_control(con, FRAME_TAG_ACK, con->v2.out_buf, 8);
 }
 
-static void prepare_epilogue_plain(struct ceph_connection *con, bool aborted)
+static void prepare_epilogue_plain(struct ceph_connection *con, struct ceph_msg *msg, bool aborted)
 {
 	dout("%s con %p msg %p aborted %d crcs %u %u %u\n", __func__, con,
-	     con->out_msg, aborted, con->v2.out_epil.front_crc,
+	     msg, aborted, con->v2.out_epil.front_crc,
 	     con->v2.out_epil.middle_crc, con->v2.out_epil.data_crc);
 
 	encode_epilogue_plain(con, aborted);
@@ -1603,10 +1603,8 @@ static void prepare_epilogue_plain(struct ceph_connection *con, bool aborted)
  * For "used" empty segments, crc is -1.  For unused (trailing)
  * segments, crc is 0.
  */
-static void prepare_message_plain(struct ceph_connection *con)
+static void prepare_message_plain(struct ceph_connection *con, struct ceph_msg *msg)
 {
-	struct ceph_msg *msg = con->out_msg;
-
 	prepare_head_plain(con, con->v2.out_buf,
 			   sizeof(struct ceph_msg_header2), NULL, 0, false);
 
@@ -1647,7 +1645,7 @@ static void prepare_message_plain(struct ceph_connection *con)
 		con->v2.out_state = OUT_S_QUEUE_DATA;
 	} else {
 		con->v2.out_epil.data_crc = 0;
-		prepare_epilogue_plain(con, false);
+		prepare_epilogue_plain(con, msg, false);
 		con->v2.out_state = OUT_S_FINISH_MESSAGE;
 	}
 }
@@ -1659,7 +1657,7 @@ static void prepare_message_plain(struct ceph_connection *con)
  * allocate pages for the entire tail of the message (currently up
  * to ~32M) and two sgs arrays (up to ~256K each)...
  */
-static int prepare_message_secure(struct ceph_connection *con)
+static int prepare_message_secure(struct ceph_connection *con, struct ceph_msg *msg)
 {
 	void *zerop = page_address(ceph_zero_page);
 	struct sg_table enc_sgt = {};
@@ -1674,7 +1672,7 @@ static int prepare_message_secure(struct ceph_connection *con)
 	if (ret)
 		return ret;
 
-	tail_len = tail_onwire_len(con->out_msg, true);
+	tail_len = tail_onwire_len(msg, true);
 	if (!tail_len) {
 		/*
 		 * Empty message: once the head is written,
@@ -1685,7 +1683,7 @@ static int prepare_message_secure(struct ceph_connection *con)
 	}
 
 	encode_epilogue_secure(con, false);
-	ret = setup_message_sgs(&sgt, con->out_msg, zerop, zerop, zerop,
+	ret = setup_message_sgs(&sgt, msg, zerop, zerop, zerop,
 				&con->v2.out_epil, NULL, 0, false);
 	if (ret)
 		goto out;
@@ -1714,7 +1712,7 @@ static int prepare_message_secure(struct ceph_connection *con)
 		goto out;
 
 	dout("%s con %p msg %p sg_cnt %d enc_page_cnt %d\n", __func__, con,
-	     con->out_msg, sgt.orig_nents, enc_page_cnt);
+	     msg, sgt.orig_nents, enc_page_cnt);
 	con->v2.out_state = OUT_S_QUEUE_ENC_PAGE;
 
 out:
@@ -1723,19 +1721,19 @@ static int prepare_message_secure(struct ceph_connection *con)
 	return ret;
 }
 
-static int prepare_message(struct ceph_connection *con)
+static int prepare_message(struct ceph_connection *con, struct ceph_msg *msg)
 {
 	int lens[] = {
 		sizeof(struct ceph_msg_header2),
-		front_len(con->out_msg),
-		middle_len(con->out_msg),
-		data_len(con->out_msg)
+		front_len(msg),
+		middle_len(msg),
+		data_len(msg)
 	};
 	struct ceph_frame_desc desc;
 	int ret;
 
 	dout("%s con %p msg %p logical %d+%d+%d+%d\n", __func__, con,
-	     con->out_msg, lens[0], lens[1], lens[2], lens[3]);
+	     msg, lens[0], lens[1], lens[2], lens[3]);
 
 	if (con->in_seq > con->in_seq_acked) {
 		dout("%s con %p in_seq_acked %llu -> %llu\n", __func__, con,
@@ -1746,15 +1744,15 @@ static int prepare_message(struct ceph_connection *con)
 	reset_out_kvecs(con);
 	init_frame_desc(&desc, FRAME_TAG_MESSAGE, lens, 4);
 	encode_preamble(&desc, con->v2.out_buf);
-	fill_header2(CTRL_BODY(con->v2.out_buf), &con->out_msg->hdr,
+	fill_header2(CTRL_BODY(con->v2.out_buf), &msg->hdr,
 		     con->in_seq_acked);
 
 	if (con_secure(con)) {
-		ret = prepare_message_secure(con);
+		ret = prepare_message_secure(con, msg);
 		if (ret)
 			return ret;
 	} else {
-		prepare_message_plain(con);
+		prepare_message_plain(con, msg);
 	}
 
 	ceph_con_flag_set(con, CEPH_CON_F_WRITE_PENDING);
@@ -3184,20 +3182,20 @@ int ceph_con_v2_try_read(struct ceph_connection *con)
 	}
 }
 
-static void queue_data(struct ceph_connection *con)
+static void queue_data(struct ceph_connection *con, struct ceph_msg *msg)
 {
 	struct bio_vec bv;
 
 	con->v2.out_epil.data_crc = -1;
-	ceph_msg_data_cursor_init(&con->v2.out_cursor, con->out_msg,
-				  data_len(con->out_msg));
+	ceph_msg_data_cursor_init(&con->v2.out_cursor, msg,
+				  data_len(msg));
 
 	get_bvec_at(&con->v2.out_cursor, &bv);
 	set_out_bvec(con, &bv, true);
 	con->v2.out_state = OUT_S_QUEUE_DATA_CONT;
 }
 
-static void queue_data_cont(struct ceph_connection *con)
+static void queue_data_cont(struct ceph_connection *con, struct ceph_msg *msg)
 {
 	struct bio_vec bv;
 
@@ -3218,7 +3216,7 @@ static void queue_data_cont(struct ceph_connection *con)
 	 * we are done.
 	 */
 	reset_out_kvecs(con);
-	prepare_epilogue_plain(con, false);
+	prepare_epilogue_plain(con, msg, false);
 	con->v2.out_state = OUT_S_FINISH_MESSAGE;
 }
 
@@ -3250,7 +3248,7 @@ static void queue_enc_page(struct ceph_connection *con)
 	con->v2.out_state = OUT_S_FINISH_MESSAGE;
 }
 
-static void queue_zeros(struct ceph_connection *con)
+static void queue_zeros(struct ceph_connection *con, struct ceph_msg *msg)
 {
 	dout("%s con %p out_zero %d\n", __func__, con, con->v2.out_zero);
 
@@ -3267,7 +3265,7 @@ static void queue_zeros(struct ceph_connection *con)
 	 * Once it's written, we are done patching up for the revoke.
 	 */
 	reset_out_kvecs(con);
-	prepare_epilogue_plain(con, true);
+	prepare_epilogue_plain(con, msg, true);
 	con->v2.out_state = OUT_S_FINISH_MESSAGE;
 }
 
@@ -3309,18 +3307,18 @@ static int populate_out_iter(struct ceph_connection *con)
 	switch (con->v2.out_state) {
 	case OUT_S_QUEUE_DATA:
 		WARN_ON(!con->out_msg);
-		queue_data(con);
+		queue_data(con, con->out_msg);
 		goto populated;
 	case OUT_S_QUEUE_DATA_CONT:
 		WARN_ON(!con->out_msg);
-		queue_data_cont(con);
+		queue_data_cont(con, con->out_msg);
 		goto populated;
 	case OUT_S_QUEUE_ENC_PAGE:
 		queue_enc_page(con);
 		goto populated;
 	case OUT_S_QUEUE_ZEROS:
 		WARN_ON(con->out_msg);  /* revoked */
-		queue_zeros(con);
+		queue_zeros(con, con->out_msg);
 		goto populated;
 	case OUT_S_FINISH_MESSAGE:
 		finish_message(con);
@@ -3340,8 +3338,8 @@ static int populate_out_iter(struct ceph_connection *con)
 			return ret;
 		}
 	} else if (!list_empty(&con->out_queue)) {
-		ceph_con_get_out_msg(con);
-		ret = prepare_message(con);
+		struct ceph_msg *msg = ceph_con_get_out_msg(con);
+		ret = prepare_message(con, msg);
 		if (ret) {
 			pr_err("prepare_message failed: %d\n", ret);
 			return ret;
@@ -3453,17 +3451,17 @@ static u32 crc32c_zeros(u32 crc, int zero_len)
 	return crc;
 }
 
-static void prepare_zero_front(struct ceph_connection *con, int resid)
+static void prepare_zero_front(struct ceph_connection *con, struct ceph_msg *msg, int resid)
 {
 	int sent;
 
-	WARN_ON(!resid || resid > front_len(con->out_msg));
-	sent = front_len(con->out_msg) - resid;
+	WARN_ON(!resid || resid > front_len(msg));
+	sent = front_len(msg) - resid;
 	dout("%s con %p sent %d resid %d\n", __func__, con, sent, resid);
 
 	if (sent) {
 		con->v2.out_epil.front_crc =
-			crc32c(-1, con->out_msg->front.iov_base, sent);
+			crc32c(-1, msg->front.iov_base, sent);
 		con->v2.out_epil.front_crc =
 			crc32c_zeros(con->v2.out_epil.front_crc, resid);
 	} else {
@@ -3474,17 +3472,17 @@ static void prepare_zero_front(struct ceph_connection *con, int resid)
 	out_zero_add(con, resid);
 }
 
-static void prepare_zero_middle(struct ceph_connection *con, int resid)
+static void prepare_zero_middle(struct ceph_connection *con, struct ceph_msg *msg, int resid)
 {
 	int sent;
 
-	WARN_ON(!resid || resid > middle_len(con->out_msg));
-	sent = middle_len(con->out_msg) - resid;
+	WARN_ON(!resid || resid > middle_len(msg));
+	sent = middle_len(msg) - resid;
 	dout("%s con %p sent %d resid %d\n", __func__, con, sent, resid);
 
 	if (sent) {
 		con->v2.out_epil.middle_crc =
-			crc32c(-1, con->out_msg->middle->vec.iov_base, sent);
+			crc32c(-1, msg->middle->vec.iov_base, sent);
 		con->v2.out_epil.middle_crc =
 			crc32c_zeros(con->v2.out_epil.middle_crc, resid);
 	} else {
@@ -3495,61 +3493,61 @@ static void prepare_zero_middle(struct ceph_connection *con, int resid)
 	out_zero_add(con, resid);
 }
 
-static void prepare_zero_data(struct ceph_connection *con)
+static void prepare_zero_data(struct ceph_connection *con, struct ceph_msg *msg)
 {
 	dout("%s con %p\n", __func__, con);
-	con->v2.out_epil.data_crc = crc32c_zeros(-1, data_len(con->out_msg));
-	out_zero_add(con, data_len(con->out_msg));
+	con->v2.out_epil.data_crc = crc32c_zeros(-1, data_len(msg));
+	out_zero_add(con, data_len(msg));
 }
 
-static void revoke_at_queue_data(struct ceph_connection *con)
+static void revoke_at_queue_data(struct ceph_connection *con, struct ceph_msg *msg)
 {
 	int boundary;
 	int resid;
 
-	WARN_ON(!data_len(con->out_msg));
+	WARN_ON(!data_len(msg));
 	WARN_ON(!iov_iter_is_kvec(&con->v2.out_iter));
 	resid = iov_iter_count(&con->v2.out_iter);
 
-	boundary = front_len(con->out_msg) + middle_len(con->out_msg);
+	boundary = front_len(msg) + middle_len(msg);
 	if (resid > boundary) {
 		resid -= boundary;
 		WARN_ON(resid > MESSAGE_HEAD_PLAIN_LEN);
 		dout("%s con %p was sending head\n", __func__, con);
-		if (front_len(con->out_msg))
-			prepare_zero_front(con, front_len(con->out_msg));
-		if (middle_len(con->out_msg))
-			prepare_zero_middle(con, middle_len(con->out_msg));
-		prepare_zero_data(con);
+		if (front_len(msg))
+			prepare_zero_front(con, msg, front_len(msg));
+		if (middle_len(msg))
+			prepare_zero_middle(con, msg, middle_len(msg));
+		prepare_zero_data(con, msg);
 		WARN_ON(iov_iter_count(&con->v2.out_iter) != resid);
 		con->v2.out_state = OUT_S_QUEUE_ZEROS;
 		return;
 	}
 
-	boundary = middle_len(con->out_msg);
+	boundary = middle_len(msg);
 	if (resid > boundary) {
 		resid -= boundary;
 		dout("%s con %p was sending front\n", __func__, con);
-		prepare_zero_front(con, resid);
-		if (middle_len(con->out_msg))
-			prepare_zero_middle(con, middle_len(con->out_msg));
-		prepare_zero_data(con);
-		queue_zeros(con);
+		prepare_zero_front(con, msg, resid);
+		if (middle_len(msg))
+			prepare_zero_middle(con, msg, middle_len(msg));
+		prepare_zero_data(con, msg);
+		queue_zeros(con, msg);
 		return;
 	}
 
 	WARN_ON(!resid);
 	dout("%s con %p was sending middle\n", __func__, con);
-	prepare_zero_middle(con, resid);
-	prepare_zero_data(con);
-	queue_zeros(con);
+	prepare_zero_middle(con, msg, resid);
+	prepare_zero_data(con, msg);
+	queue_zeros(con, msg);
 }
 
-static void revoke_at_queue_data_cont(struct ceph_connection *con)
+static void revoke_at_queue_data_cont(struct ceph_connection *con, struct ceph_msg *msg)
 {
 	int sent, resid;  /* current piece of data */
 
-	WARN_ON(!data_len(con->out_msg));
+	WARN_ON(!data_len(msg));
 	WARN_ON(!iov_iter_is_bvec(&con->v2.out_iter));
 	resid = iov_iter_count(&con->v2.out_iter);
 	WARN_ON(!resid || resid > con->v2.out_bvec.bv_len);
@@ -3568,10 +3566,10 @@ static void revoke_at_queue_data_cont(struct ceph_connection *con)
 
 	con->v2.out_iter.count -= resid;
 	out_zero_add(con, con->v2.out_cursor.total_resid);
-	queue_zeros(con);
+	queue_zeros(con, msg);
 }
 
-static void revoke_at_finish_message(struct ceph_connection *con)
+static void revoke_at_finish_message(struct ceph_connection *con, struct ceph_msg *msg)
 {
 	int boundary;
 	int resid;
@@ -3579,39 +3577,39 @@ static void revoke_at_finish_message(struct ceph_connection *con)
 	WARN_ON(!iov_iter_is_kvec(&con->v2.out_iter));
 	resid = iov_iter_count(&con->v2.out_iter);
 
-	if (!front_len(con->out_msg) && !middle_len(con->out_msg) &&
-	    !data_len(con->out_msg)) {
+	if (!front_len(msg) && !middle_len(msg) &&
+	    !data_len(msg)) {
 		WARN_ON(!resid || resid > MESSAGE_HEAD_PLAIN_LEN);
 		dout("%s con %p was sending head (empty message) - noop\n",
 		     __func__, con);
 		return;
 	}
 
-	boundary = front_len(con->out_msg) + middle_len(con->out_msg) +
+	boundary = front_len(msg) + middle_len(msg) +
 		   CEPH_EPILOGUE_PLAIN_LEN;
 	if (resid > boundary) {
 		resid -= boundary;
 		WARN_ON(resid > MESSAGE_HEAD_PLAIN_LEN);
 		dout("%s con %p was sending head\n", __func__, con);
-		if (front_len(con->out_msg))
-			prepare_zero_front(con, front_len(con->out_msg));
-		if (middle_len(con->out_msg))
-			prepare_zero_middle(con, middle_len(con->out_msg));
+		if (front_len(msg))
+			prepare_zero_front(con, msg, front_len(msg));
+		if (middle_len(msg))
+			prepare_zero_middle(con, msg, middle_len(msg));
 		con->v2.out_iter.count -= CEPH_EPILOGUE_PLAIN_LEN;
 		WARN_ON(iov_iter_count(&con->v2.out_iter) != resid);
 		con->v2.out_state = OUT_S_QUEUE_ZEROS;
 		return;
 	}
 
-	boundary = middle_len(con->out_msg) + CEPH_EPILOGUE_PLAIN_LEN;
+	boundary = middle_len(msg) + CEPH_EPILOGUE_PLAIN_LEN;
 	if (resid > boundary) {
 		resid -= boundary;
 		dout("%s con %p was sending front\n", __func__, con);
-		prepare_zero_front(con, resid);
-		if (middle_len(con->out_msg))
-			prepare_zero_middle(con, middle_len(con->out_msg));
+		prepare_zero_front(con, msg, resid);
+		if (middle_len(msg))
+			prepare_zero_middle(con, msg, middle_len(msg));
 		con->v2.out_iter.count -= CEPH_EPILOGUE_PLAIN_LEN;
-		queue_zeros(con);
+		queue_zeros(con, msg);
 		return;
 	}
 
@@ -3619,9 +3617,9 @@ static void revoke_at_finish_message(struct ceph_connection *con)
 	if (resid > boundary) {
 		resid -= boundary;
 		dout("%s con %p was sending middle\n", __func__, con);
-		prepare_zero_middle(con, resid);
+		prepare_zero_middle(con, msg, resid);
 		con->v2.out_iter.count -= CEPH_EPILOGUE_PLAIN_LEN;
-		queue_zeros(con);
+		queue_zeros(con, msg);
 		return;
 	}
 
@@ -3629,7 +3627,7 @@ static void revoke_at_finish_message(struct ceph_connection *con)
 	dout("%s con %p was sending epilogue - noop\n", __func__, con);
 }
 
-void ceph_con_v2_revoke(struct ceph_connection *con)
+void ceph_con_v2_revoke(struct ceph_connection *con, struct ceph_msg *msg)
 {
 	WARN_ON(con->v2.out_zero);
 
@@ -3642,13 +3640,13 @@ void ceph_con_v2_revoke(struct ceph_connection *con)
 
 	switch (con->v2.out_state) {
 	case OUT_S_QUEUE_DATA:
-		revoke_at_queue_data(con);
+		revoke_at_queue_data(con, msg);
 		break;
 	case OUT_S_QUEUE_DATA_CONT:
-		revoke_at_queue_data_cont(con);
+		revoke_at_queue_data_cont(con, msg);
 		break;
 	case OUT_S_FINISH_MESSAGE:
-		revoke_at_finish_message(con);
+		revoke_at_finish_message(con, msg);
 		break;
 	default:
 		WARN(1, "bad out_state %d", con->v2.out_state);
-- 
2.47.2



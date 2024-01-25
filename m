Return-Path: <ceph-devel+bounces-662-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B19F983B746
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jan 2024 03:42:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E0E4284E29
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jan 2024 02:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 655DC567F;
	Thu, 25 Jan 2024 02:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yw+Cjp/+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681D96FC8
	for <ceph-devel@vger.kernel.org>; Thu, 25 Jan 2024 02:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706150521; cv=none; b=doymH59aVhBvnb15CD4KAEZCCgNQFp84O7wNnhlwWnuUE6kA58k73IKYQ0zC09hPGVaaeQZudim024ppJWzxHb3cAHBkvYI61DHkRJCEL8CUktn39s+k0A6mupC/KnPF8672d0/Jtr6dXaWDFyDEAs+3b6Z68Lfk+d7HBh9nP24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706150521; c=relaxed/simple;
	bh=qSxEWiDUVWMnd5uNwMYlliU+jbBQfSC7rUKBkUzgGsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATSllkdY+CeUs5Snw/DuaXFNwcCp+PnhrVdu1MyMQ3WWkjhnqx9sBPtlTmUJpjg1XzFcFHcRhZ4FTZVFoPUb6Fco0uUcz0qXTxdea6KiqnuFMApkAAiMUbuS4xubnbavcUIjtPahUqVUMM40Zhp0ovjiiGPRY1AjRK50aOuyKlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yw+Cjp/+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706150518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=joMAdTN04grs9Wf9AiEKnOI/X+DWUBmFtNtubR6BXMs=;
	b=Yw+Cjp/+Xte+Y14SN1JsGRcwD52Z2+uQQj933S+G3Wy/JypV2qBJp3kpeYT7Ct9EQYAWIg
	cQxdkQBG+FyVxnUHX3Hq08iPykG5sXFrP0DJ08dAAzr04ZMrqdxJ+OkqRyg/oKWVl7wzft
	6m/kv+oRmSocS9+WsnkzzgC9fJzYejc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-aAxxAHNCNNKlnzHmBlkezQ-1; Wed, 24 Jan 2024 21:41:55 -0500
X-MC-Unique: aAxxAHNCNNKlnzHmBlkezQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF82F837224;
	Thu, 25 Jan 2024 02:41:54 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.211])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C1FE72166B32;
	Thu, 25 Jan 2024 02:41:51 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v6 3/3] libceph: just wait for more data to be available on the socket
Date: Thu, 25 Jan 2024 10:39:20 +0800
Message-ID: <20240125023920.1287555-4-xiubli@redhat.com>
In-Reply-To: <20240125023920.1287555-1-xiubli@redhat.com>
References: <20240125023920.1287555-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Xiubo Li <xiubli@redhat.com>

A short read may occur while reading the message footer from the
socket.  Later, when the socket is ready for another read, the
messenger shoudl invoke all read_partial* handlers, except the
read_partial_sparse_msg_data().  The contract between the messenger
and these handlers is that the handlers should bail if the area
of the message is responsible for is already processed.  So,
in this case, it's expected that read_sparse_msg_data() would bail,
allowing the messenger to invoke read_partial() for the footer and
pick up where it left off.

However read_partial_sparse_msg_data() violates that contract and
ends up calling into the state machine in the OSD client. The
sparse-read state machine just assumes that it's a new op and
interprets some piece of the footer as the sparse-read extents/data
and then returns bogus extents/data length, etc.

This will just reuse the 'total_resid' to determine whether should
the read_partial_sparse_msg_data() bail out or not. Because once
it reaches to zero that means all the extents and data have been
successfully received in last read, else it could break out when
partially reading any of the extents and data. And then the
osd_sparse_read() could continue where it left off.

URL: https://tracker.ceph.com/issues/63586
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/messenger.h |  2 +-
 net/ceph/messenger_v1.c        | 25 +++++++++++++------------
 net/ceph/messenger_v2.c        |  4 ++--
 net/ceph/osd_client.c          |  9 +++------
 4 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 2eaaabbe98cb..1717cc57cdac 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -283,7 +283,7 @@ struct ceph_msg {
 	struct kref kref;
 	bool more_to_follow;
 	bool needs_out_seq;
-	bool sparse_read;
+	u64 sparse_read_total;
 	int front_alloc_len;
 
 	struct ceph_msgpool *pool;
diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index 4cb60bacf5f5..126b2e712247 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -160,8 +160,9 @@ static size_t sizeof_footer(struct ceph_connection *con)
 static void prepare_message_data(struct ceph_msg *msg, u32 data_len)
 {
 	/* Initialize data cursor if it's not a sparse read */
-	if (!msg->sparse_read)
-		ceph_msg_data_cursor_init(&msg->cursor, msg, data_len);
+	u64 len = msg->sparse_read_total ? : data_len;
+
+	ceph_msg_data_cursor_init(&msg->cursor, msg, len);
 }
 
 /*
@@ -1036,7 +1037,7 @@ static int read_partial_sparse_msg_data(struct ceph_connection *con)
 	if (do_datacrc)
 		crc = con->in_data_crc;
 
-	do {
+	while (cursor->total_resid) {
 		if (con->v1.in_sr_kvec.iov_base)
 			ret = read_partial_message_chunk(con,
 							 &con->v1.in_sr_kvec,
@@ -1044,23 +1045,23 @@ static int read_partial_sparse_msg_data(struct ceph_connection *con)
 							 &crc);
 		else if (cursor->sr_resid > 0)
 			ret = read_partial_sparse_msg_extent(con, &crc);
-
-		if (ret <= 0) {
-			if (do_datacrc)
-				con->in_data_crc = crc;
-			return ret;
-		}
+		if (ret <= 0)
+			break;
 
 		memset(&con->v1.in_sr_kvec, 0, sizeof(con->v1.in_sr_kvec));
 		ret = con->ops->sparse_read(con, cursor,
 				(char **)&con->v1.in_sr_kvec.iov_base);
+		if (ret <= 0) {
+			ret = ret ? ret : 1; /* must return > 0 to indicate success */
+			break;
+		}
 		con->v1.in_sr_len = ret;
-	} while (ret > 0);
+	}
 
 	if (do_datacrc)
 		con->in_data_crc = crc;
 
-	return ret < 0 ? ret : 1;  /* must return > 0 to indicate success */
+	return ret;
 }
 
 static int read_partial_msg_data(struct ceph_connection *con)
@@ -1253,7 +1254,7 @@ static int read_partial_message(struct ceph_connection *con)
 		if (!m->num_data_items)
 			return -EIO;
 
-		if (m->sparse_read)
+		if (m->sparse_read_total)
 			ret = read_partial_sparse_msg_data(con);
 		else if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE))
 			ret = read_partial_msg_data_bounce(con);
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index f8ec60e1aba3..a0ca5414b333 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -1128,7 +1128,7 @@ static int decrypt_tail(struct ceph_connection *con)
 	struct sg_table enc_sgt = {};
 	struct sg_table sgt = {};
 	struct page **pages = NULL;
-	bool sparse = con->in_msg->sparse_read;
+	bool sparse = !!con->in_msg->sparse_read_total;
 	int dpos = 0;
 	int tail_len;
 	int ret;
@@ -2060,7 +2060,7 @@ static int prepare_read_tail_plain(struct ceph_connection *con)
 	}
 
 	if (data_len(msg)) {
-		if (msg->sparse_read)
+		if (msg->sparse_read_total)
 			con->v2.in_state = IN_S_PREPARE_SPARSE_DATA;
 		else
 			con->v2.in_state = IN_S_PREPARE_READ_DATA;
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 837b69541376..ad2ed334cdbb 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5510,7 +5510,7 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 	}
 
 	m = ceph_msg_get(req->r_reply);
-	m->sparse_read = (bool)srlen;
+	m->sparse_read_total = srlen;
 
 	dout("get_reply tid %lld %p\n", tid, m);
 
@@ -5777,11 +5777,8 @@ static int prep_next_sparse_read(struct ceph_connection *con,
 	}
 
 	if (o->o_sparse_op_idx < 0) {
-		u64 srlen = sparse_data_requested(req);
-
-		dout("%s: [%d] starting new sparse read req. srlen=0x%llx\n",
-		     __func__, o->o_osd, srlen);
-		ceph_msg_data_cursor_init(cursor, con->in_msg, srlen);
+		dout("%s: [%d] starting new sparse read req\n",
+		     __func__, o->o_osd);
 	} else {
 		u64 end;
 
-- 
2.43.0



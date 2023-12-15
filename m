Return-Path: <ceph-devel+bounces-354-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8A60813EAE
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Dec 2023 01:23:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F07F283F8F
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Dec 2023 00:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCB924431;
	Fri, 15 Dec 2023 00:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ta+kvlFQ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE8933E0
	for <ceph-devel@vger.kernel.org>; Fri, 15 Dec 2023 00:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702599779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hc58d1Y30Sc7WBDpfRtJPe3Kp2H3/Q1q0qOZDj/PHqE=;
	b=Ta+kvlFQ6rwp09G4Ak2Blj3iAIxZKeiBvBz8v4bg0d6a9lA/I8Ycv8m7DoCdtS8hgm7S0W
	B6W5bjuYezhUIrHTMdEsqDFdeYgRnaTBcYCNPIuG2zZ9VedLCHCIZ7OMRE7ARJ2yHeFFwC
	BLyx3wpffs7zM7oPFO5LgANV7LawKGA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-JE8A4878OQuGc-OURMxZjg-1; Thu, 14 Dec 2023 19:22:55 -0500
X-MC-Unique: JE8A4878OQuGc-OURMxZjg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89BF18350E2;
	Fri, 15 Dec 2023 00:22:55 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.113.27])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A872C492BC6;
	Fri, 15 Dec 2023 00:22:52 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 3/3] libceph: just wait for more data to be available on the socket
Date: Fri, 15 Dec 2023 08:20:34 +0800
Message-ID: <20231215002034.205780-4-xiubli@redhat.com>
In-Reply-To: <20231215002034.205780-1-xiubli@redhat.com>
References: <20231215002034.205780-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

From: Xiubo Li <xiubli@redhat.com>

The messages from ceph maybe split into multiple socket packages
and we just need to wait for all the data to be availiable on the
sokcet.

This will add 'sr_total_resid' to record the total length for all
data items for sparse-read message and 'sr_resid_elen' to record
the current extent total length.

URL: https://tracker.ceph.com/issues/63586
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 include/linux/ceph/messenger.h |  2 ++
 net/ceph/messenger.c           |  1 +
 net/ceph/messenger_v1.c        | 21 ++++++++++++++++-----
 net/ceph/osd_client.c          |  1 +
 4 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 2eaaabbe98cb..05e9b39a58f8 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -231,10 +231,12 @@ struct ceph_msg_data {
 
 struct ceph_msg_data_cursor {
 	size_t			total_resid;	/* across all data items */
+	size_t			sr_total_resid;	/* across all data items for sparse-read */
 
 	struct ceph_msg_data	*data;		/* current data item */
 	size_t			resid;		/* bytes not yet consumed */
 	int			sr_resid;	/* residual sparse_read len */
+	int			sr_resid_elen;	/* total sparse_read elen */
 	bool			need_crc;	/* crc update needed */
 	union {
 #ifdef CONFIG_BLOCK
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 3c8b78d9c4d1..eafd592af382 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1073,6 +1073,7 @@ void ceph_msg_data_cursor_init(struct ceph_msg_data_cursor *cursor,
 	cursor->total_resid = length;
 	cursor->data = msg->data;
 	cursor->sr_resid = 0;
+	cursor->sr_resid_elen = 0;
 
 	__ceph_msg_data_cursor_init(cursor);
 }
diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index 4cb60bacf5f5..7425fa26e4c3 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -160,7 +160,9 @@ static size_t sizeof_footer(struct ceph_connection *con)
 static void prepare_message_data(struct ceph_msg *msg, u32 data_len)
 {
 	/* Initialize data cursor if it's not a sparse read */
-	if (!msg->sparse_read)
+	if (msg->sparse_read)
+		msg->cursor.sr_total_resid = data_len;
+	else
 		ceph_msg_data_cursor_init(&msg->cursor, msg, data_len);
 }
 
@@ -1032,18 +1034,25 @@ static int read_partial_sparse_msg_data(struct ceph_connection *con)
 	bool do_datacrc = !ceph_test_opt(from_msgr(con->msgr), NOCRC);
 	u32 crc = 0;
 	int ret = 1;
+	int len;
 
 	if (do_datacrc)
 		crc = con->in_data_crc;
 
-	do {
-		if (con->v1.in_sr_kvec.iov_base)
+	while (cursor->sr_total_resid && ret > 0) {
+		len = 0;
+		if (con->v1.in_sr_kvec.iov_base) {
 			ret = read_partial_message_chunk(con,
 							 &con->v1.in_sr_kvec,
 							 con->v1.in_sr_len,
 							 &crc);
-		else if (cursor->sr_resid > 0)
+			if (ret == 1)
+				len = con->v1.in_sr_len;
+		} else if (cursor->sr_resid > 0) {
 			ret = read_partial_sparse_msg_extent(con, &crc);
+			if (ret == 1)
+				len = cursor->sr_resid_elen;
+		}
 
 		if (ret <= 0) {
 			if (do_datacrc)
@@ -1051,11 +1060,13 @@ static int read_partial_sparse_msg_data(struct ceph_connection *con)
 			return ret;
 		}
 
+		cursor->sr_total_resid -= len;
+
 		memset(&con->v1.in_sr_kvec, 0, sizeof(con->v1.in_sr_kvec));
 		ret = con->ops->sparse_read(con, cursor,
 				(char **)&con->v1.in_sr_kvec.iov_base);
 		con->v1.in_sr_len = ret;
-	} while (ret > 0);
+	}
 
 	if (do_datacrc)
 		con->in_data_crc = crc;
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 848ef19055a0..b53b017afc0a 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5946,6 +5946,7 @@ static int osd_sparse_read(struct ceph_connection *con,
 
 		/* send back the new length and nullify the ptr */
 		cursor->sr_resid = elen;
+		cursor->sr_resid_elen = elen;
 		ret = elen;
 		*pbuf = NULL;
 
-- 
2.43.0



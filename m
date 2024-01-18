Return-Path: <ceph-devel+bounces-586-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DB66831718
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jan 2024 11:53:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 500BD1C22431
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jan 2024 10:53:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B5D923772;
	Thu, 18 Jan 2024 10:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MbmF2AhC"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A3F22F0F
	for <ceph-devel@vger.kernel.org>; Thu, 18 Jan 2024 10:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575197; cv=none; b=Pde60yxK5lcQ/Wn1QTpAlQNRgNZkDPP3wf67C38qMmuhsDDdVviHO94UXI2CEWUukAFhwu7RJ4Ex5j7ZGloDiwcOSyrjWq+Sc3W7cCtW/i6CLjgB9W7SM7p+qSKLFvVwb/MAFl2N14Vav8Dybqy/hJRExN5mYwe3nB85rFRQ2lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575197; c=relaxed/simple;
	bh=9aubr3nQ5w3kYoMxTBdRM2PE9DSFRr+t4EdyLmDRby8=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By; b=eW6Jlr9FLeLBO5CSr94ytrk5zA6PzVDTN6ODS0Ld4xEGvCTll8qieTAMtlf/rbAt9qO2UMPUMv2p1AID9tx7oWNglogOwKl4GvChHaux4R5OXNn7oYDkodVdUNzkie8ALxuHFQF11UNuayKculiG2+3jG1Z4GozPCJgDwB+vnXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MbmF2AhC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705575194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tWHtwQsevLlnlhr5I9nOk0sG2hz2p8edzgg45EIgciA=;
	b=MbmF2AhCBbvrq9I407xMD30Zoss71zMqCwlXApxwEGRYEKUhe3VZSrHi5F5rsPrZ3qp1oq
	jLMp70k62jtIpOtvdO64o2N0hIIf2fOV/B+DsHAbaDr1ZPClJUXHwKiHXD1EKriKVmz2n/
	IGM86HYiLxZCejSHviJ5rT8lgAGD+cY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-286-s9LI8D2xO-27dVdEy9dJ8A-1; Thu, 18 Jan 2024 05:53:10 -0500
X-MC-Unique: s9LI8D2xO-27dVdEy9dJ8A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7234080007C;
	Thu, 18 Jan 2024 10:53:10 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.62])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3C5CB2166B35;
	Thu, 18 Jan 2024 10:53:06 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 3/3] libceph: just wait for more data to be available on the socket
Date: Thu, 18 Jan 2024 18:50:47 +0800
Message-ID: <20240118105047.792879-4-xiubli@redhat.com>
In-Reply-To: <20240118105047.792879-1-xiubli@redhat.com>
References: <20240118105047.792879-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

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
 include/linux/ceph/messenger.h |  1 +
 net/ceph/messenger_v1.c        | 32 +++++++++++++++++++++-----------
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 2eaaabbe98cb..ca6f82abed62 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -231,6 +231,7 @@ struct ceph_msg_data {
 
 struct ceph_msg_data_cursor {
 	size_t			total_resid;	/* across all data items */
+	size_t			sr_total_resid;	/* across all data items for sparse-read */
 
 	struct ceph_msg_data	*data;		/* current data item */
 	size_t			resid;		/* bytes not yet consumed */
diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index 4cb60bacf5f5..2733da891688 100644
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
 
@@ -1032,35 +1034,43 @@ static int read_partial_sparse_msg_data(struct ceph_connection *con)
 	bool do_datacrc = !ceph_test_opt(from_msgr(con->msgr), NOCRC);
 	u32 crc = 0;
 	int ret = 1;
+	int len;
 
 	if (do_datacrc)
 		crc = con->in_data_crc;
 
-	do {
-		if (con->v1.in_sr_kvec.iov_base)
+	while (cursor->sr_total_resid) {
+		len = 0;
+		if (con->v1.in_sr_kvec.iov_base) {
+			len = con->v1.in_sr_kvec.iov_len;
 			ret = read_partial_message_chunk(con,
 							 &con->v1.in_sr_kvec,
 							 con->v1.in_sr_len,
 							 &crc);
-		else if (cursor->sr_resid > 0)
+			len = con->v1.in_sr_kvec.iov_len - len;
+		} else if (cursor->sr_resid > 0) {
+			len = cursor->sr_resid;
 			ret = read_partial_sparse_msg_extent(con, &crc);
-
-		if (ret <= 0) {
-			if (do_datacrc)
-				con->in_data_crc = crc;
-			return ret;
+			len -= cursor->sr_resid;
 		}
+		cursor->sr_total_resid -= len;
+		if (ret <= 0)
+			break;
 
 		memset(&con->v1.in_sr_kvec, 0, sizeof(con->v1.in_sr_kvec));
 		ret = con->ops->sparse_read(con, cursor,
 				(char **)&con->v1.in_sr_kvec.iov_base);
+		if (ret <= 0) {
+			ret = ret ? : 1; /* must return > 0 to indicate success */
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
-- 
2.43.0



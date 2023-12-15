Return-Path: <ceph-devel+bounces-353-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C21EB813EAD
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Dec 2023 01:23:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F7821F22BD4
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Dec 2023 00:23:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F5FE2901;
	Fri, 15 Dec 2023 00:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CLcgbOcc"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F4428EB
	for <ceph-devel@vger.kernel.org>; Fri, 15 Dec 2023 00:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702599776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=twQBZwt/0/ZoadeigsXW1CtTVxmntH2XtZanBw6LaVQ=;
	b=CLcgbOccARiF6kp+4xOyS/q8l4i/pg1JW8XnR3dJIGcEGeuqxG3ZeSIADoXnCxkARuowWe
	bxgE1LczkR+14gPjrVhPt/MhztKr1+ZrTcmGi+JzNZBaKsJpbPNfQ0vjf0xpU//anwqOvh
	fBXn/awGJ9ekvXAwonsExGAHuuJ/nck=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-578-BA6TXI91NnGzoK7OpwC9CA-1; Thu,
 14 Dec 2023 19:22:52 -0500
X-MC-Unique: BA6TXI91NnGzoK7OpwC9CA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E78B6380627E;
	Fri, 15 Dec 2023 00:22:51 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.113.27])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CD235492BC6;
	Fri, 15 Dec 2023 00:22:48 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 2/3] libceph: rename read_sparse_msg_XX to read_partial_sparse_msg_XX
Date: Fri, 15 Dec 2023 08:20:33 +0800
Message-ID: <20231215002034.205780-3-xiubli@redhat.com>
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

Actually the read_sparse_msg_XX functions allow to continue reading
and parsing the socket buffer when handling of short receives.

Just rename it with _partial_ prefixed.

URL: https://tracker.ceph.com/issues/63586
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 net/ceph/messenger_v1.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index f9a50d7f0d20..4cb60bacf5f5 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -991,7 +991,7 @@ static inline int read_partial_message_section(struct ceph_connection *con,
 	return read_partial_message_chunk(con, section, sec_len, crc);
 }
 
-static int read_sparse_msg_extent(struct ceph_connection *con, u32 *crc)
+static int read_partial_sparse_msg_extent(struct ceph_connection *con, u32 *crc)
 {
 	struct ceph_msg_data_cursor *cursor = &con->in_msg->cursor;
 	bool do_bounce = ceph_test_opt(from_msgr(con->msgr), RXBOUNCE);
@@ -1026,7 +1026,7 @@ static int read_sparse_msg_extent(struct ceph_connection *con, u32 *crc)
 	return 1;
 }
 
-static int read_sparse_msg_data(struct ceph_connection *con)
+static int read_partial_sparse_msg_data(struct ceph_connection *con)
 {
 	struct ceph_msg_data_cursor *cursor = &con->in_msg->cursor;
 	bool do_datacrc = !ceph_test_opt(from_msgr(con->msgr), NOCRC);
@@ -1043,7 +1043,7 @@ static int read_sparse_msg_data(struct ceph_connection *con)
 							 con->v1.in_sr_len,
 							 &crc);
 		else if (cursor->sr_resid > 0)
-			ret = read_sparse_msg_extent(con, &crc);
+			ret = read_partial_sparse_msg_extent(con, &crc);
 
 		if (ret <= 0) {
 			if (do_datacrc)
@@ -1254,7 +1254,7 @@ static int read_partial_message(struct ceph_connection *con)
 			return -EIO;
 
 		if (m->sparse_read)
-			ret = read_sparse_msg_data(con);
+			ret = read_partial_sparse_msg_data(con);
 		else if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE))
 			ret = read_partial_msg_data_bounce(con);
 		else
-- 
2.43.0



Return-Path: <ceph-devel+bounces-2904-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52221A60597
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Mar 2025 00:38:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87C193BE7E1
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Mar 2025 23:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8E21FFC4D;
	Thu, 13 Mar 2025 23:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B+sZFWIF"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CB71FF7B0
	for <ceph-devel@vger.kernel.org>; Thu, 13 Mar 2025 23:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741908881; cv=none; b=B2EsLjtNg0oIog+VJ6DmSXqlu7fIlGMrNk5WTx4qbeE8WD0CqxCX/UztDoVHP41IVQlCrgtqmyxi/59+uwZ+wXrXBKBUn/7F4AwHN651+vnWvdOs8yjRIDoPOL9p/EdfusyNHtFmLc+hSznoiBMhcAs/e8r1xl8ffYBTzDYmW5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741908881; c=relaxed/simple;
	bh=bUmykwDxrEmtIQ9GoL8F0xFmqiOF9yATjusg+hmIxWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5oU9svZNUEGU4CfbkEUbuxjUzZJY1E0gH308p/6458zs0iZK7+4xuklyUDpVJFAQVDY2OW4UMEPLbsqeolVnfNo5JGutCDhaRoT1jCu/EAJyZHNwE/KaJVrVYA38cshDdLU19hAEiIRIGqZhIEjzOhIl/MZ4YvPizHdW9H5a5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B+sZFWIF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741908878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xCq288hnIzAt6EE/D2KI6gM8OPNMHb29b2SqQDvuZUg=;
	b=B+sZFWIF5v2gUtF7kqET9MtMr0zsQAjSQ/brGsnoBqMNCe3O3dxOE1CoMRvANoBIT7ogo3
	sm7oLlJ5zLpWB1rt1Y2qZZMIwfSxWyNrhctCR1lNgiVyINbLZ/vhWb15j8oD5pxUsN4jCe
	Vy8oc9fGk8NuQZWI0JLZUfM5lG83nJo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-20-VEEEos5ANpi7A-NKHDFhlA-1; Thu,
 13 Mar 2025 19:34:37 -0400
X-MC-Unique: VEEEos5ANpi7A-NKHDFhlA-1
X-Mimecast-MFC-AGG-ID: VEEEos5ANpi7A-NKHDFhlA_1741908875
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90AA319560B6;
	Thu, 13 Mar 2025 23:34:35 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.61])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 505061828A87;
	Thu, 13 Mar 2025 23:34:33 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>,
	Alex Markuze <amarkuze@redhat.com>
Cc: David Howells <dhowells@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 12/35] libceph: Bypass the messenger-v1 Tx loop for databuf/iter data blobs
Date: Thu, 13 Mar 2025 23:33:04 +0000
Message-ID: <20250313233341.1675324-13-dhowells@redhat.com>
In-Reply-To: <20250313233341.1675324-1-dhowells@redhat.com>
References: <20250313233341.1675324-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Don't use the messenger-v1 Tx loop for databuf/iter data blobs, which sends
page fragments individually, but rather pass the entire iterator to the
socket in one go.  This uses the loop inside of tcp_sendmsg() to do the
work and allows TCP to make better choices.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Viacheslav Dubeyko <slava@dubeyko.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: ceph-devel@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 include/linux/ceph/messenger.h |  1 +
 net/ceph/messenger.c           |  1 +
 net/ceph/messenger_v1.c        | 76 ++++++++++++++++++++++++++++------
 3 files changed, 65 insertions(+), 13 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 864aad369c91..1b646d0dff39 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -255,6 +255,7 @@ struct ceph_msg_data_cursor {
 		};
 		struct {
 			struct iov_iter		iov_iter;
+			struct iov_iter		crc_iter;
 			unsigned int		lastlen;
 		};
 	};
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 02439b38ec94..dc8082575e4f 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -975,6 +975,7 @@ static void ceph_msg_data_iter_cursor_init(struct ceph_msg_data_cursor *cursor,
 	struct ceph_msg_data *data = cursor->data;
 
 	cursor->iov_iter = data->iter;
+	cursor->crc_iter = data->iter;
 	cursor->lastlen = 0;
 	iov_iter_truncate(&cursor->iov_iter, length);
 	cursor->resid = iov_iter_count(&cursor->iov_iter);
diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index 0cb61c76b9b8..d6464ac62b09 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -3,6 +3,7 @@
 
 #include <linux/bvec.h>
 #include <linux/crc32c.h>
+#include <linux/iov_iter.h>
 #include <linux/net.h>
 #include <linux/socket.h>
 #include <net/sock.h>
@@ -74,6 +75,21 @@ static int ceph_tcp_sendmsg(struct socket *sock, struct kvec *iov,
 	return r;
 }
 
+static int ceph_tcp_sock_sendmsg(struct socket *sock, struct iov_iter *iter,
+				 unsigned int flags)
+{
+	struct msghdr msg = {
+		.msg_iter  = *iter,
+		.msg_flags = MSG_DONTWAIT | MSG_NOSIGNAL | flags,
+	};
+	int r;
+
+	r = sock_sendmsg(sock, &msg);
+	if (r == -EAGAIN)
+		r = 0;
+	return r;
+}
+
 /*
  * @more: MSG_MORE or 0.
  */
@@ -455,6 +471,24 @@ static int write_partial_kvec(struct ceph_connection *con)
 	return ret;  /* done! */
 }
 
+static size_t ceph_crc_from_iter(void *iter_from, size_t progress,
+				 size_t len, void *priv, void *priv2)
+{
+	u32 *crc = priv;
+
+	*crc = crc32c(*crc, iter_from, len);
+	return 0;
+}
+
+static void ceph_calc_crc(struct iov_iter *iter, size_t count, u32 *crc)
+{
+	size_t done;
+
+	done = iterate_and_advance_kernel(iter, count, crc, NULL,
+					  ceph_crc_from_iter);
+	WARN_ON(done != count);
+}
+
 /*
  * Write as much message data payload as we can.  If we finish, queue
  * up the footer.
@@ -467,7 +501,7 @@ static int write_partial_message_data(struct ceph_connection *con)
 	struct ceph_msg *msg = con->out_msg;
 	struct ceph_msg_data_cursor *cursor = &msg->cursor;
 	bool do_datacrc = !ceph_test_opt(from_msgr(con->msgr), NOCRC);
-	u32 crc;
+	u32 crc = 0;
 
 	dout("%s %p msg %p\n", __func__, con, msg);
 
@@ -484,9 +518,6 @@ static int write_partial_message_data(struct ceph_connection *con)
 	 */
 	crc = do_datacrc ? le32_to_cpu(msg->footer.data_crc) : 0;
 	while (cursor->total_resid) {
-		struct page *page;
-		size_t page_offset;
-		size_t length;
 		int ret;
 
 		if (!cursor->resid) {
@@ -494,17 +525,36 @@ static int write_partial_message_data(struct ceph_connection *con)
 			continue;
 		}
 
-		page = ceph_msg_data_next(cursor, &page_offset, &length);
-		ret = ceph_tcp_sendpage(con->sock, page, page_offset, length,
-					MSG_MORE);
-		if (ret <= 0) {
-			if (do_datacrc)
-				msg->footer.data_crc = cpu_to_le32(crc);
+		if (cursor->data->type == CEPH_MSG_DATA_DATABUF ||
+		    cursor->data->type == CEPH_MSG_DATA_ITER) {
+			ret = ceph_tcp_sock_sendmsg(con->sock, &cursor->iov_iter,
+						    MSG_MORE);
+			if (ret <= 0) {
+				if (do_datacrc)
+					msg->footer.data_crc = cpu_to_le32(crc);
 
-			return ret;
+				return ret;
+			}
+			if (do_datacrc && cursor->need_crc)
+				ceph_calc_crc(&cursor->crc_iter, ret, &crc);
+		} else {
+			struct page *page;
+			size_t page_offset;
+			size_t length;
+
+			page = ceph_msg_data_next(cursor, &page_offset, &length);
+			ret = ceph_tcp_sendpage(con->sock, page, page_offset,
+						length, MSG_MORE);
+			if (ret <= 0) {
+				if (do_datacrc)
+					msg->footer.data_crc = cpu_to_le32(crc);
+
+				return ret;
+			}
+			if (do_datacrc && cursor->need_crc)
+				crc = ceph_crc32c_page(crc, page, page_offset,
+						       length);
 		}
-		if (do_datacrc && cursor->need_crc)
-			crc = ceph_crc32c_page(crc, page, page_offset, length);
 		ceph_msg_data_advance(cursor, (size_t)ret);
 	}
 



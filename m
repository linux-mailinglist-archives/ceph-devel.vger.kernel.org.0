Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FE41B277D
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Apr 2020 15:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbgDUNTJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Apr 2020 09:19:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:50098 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728908AbgDUNTC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 09:19:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CE55AAD85;
        Tue, 21 Apr 2020 13:18:57 +0000 (UTC)
From:   Roman Penyaev <rpenyaev@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        Roman Penyaev <rpenyaev@suse.de>
Subject: [PATCH 06/16] libceph: switch data cursor from page to iov_iter for messenger
Date:   Tue, 21 Apr 2020 15:18:40 +0200
Message-Id: <20200421131850.443228-7-rpenyaev@suse.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200421131850.443228-1-rpenyaev@suse.de>
References: <20200421131850.443228-1-rpenyaev@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The first problem is performance. Why not to pass to read/write
socket function the whole iov_iter and let socket API handle
everything at once instead of doing IO page by page?  So better
to make data cursor as iov_iter, which is generic for many API
calls.

The second reason is the support of kvec in the future, i.e. we
do not have a page in a hand, but a buffer.

So this patch is a preparation, the first iteration: users of data
cursor do not see pages, but use cursor->iter instead.  Internally
cursor still uses page.  In next patches that will be avoided.

We are still able to use sendpage() for 0-copy and have performance
benefit from multi-pages, i.e. if bvec in iter is a multi-page,
then we pass the whole multi-page to sendpage() and not only 4k.

Important to mention that for sendpage() MSG_SENDPAGE_NOTLAST is
always set if @more flag is true.  We know that the footer of a
message will follow, @more will be false and all data will be
pushed out of the socket.

Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
---
 include/linux/ceph/messenger.h |   3 +
 net/ceph/messenger.c           | 141 ++++++++++++++++++++++-----------
 2 files changed, 97 insertions(+), 47 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 424f9f1989b7..044c74333c27 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -192,6 +192,9 @@ struct ceph_msg_data_cursor {
 	size_t			total_resid;	/* across all data items */
 
 	struct ceph_msg_data	*data;		/* current data item */
+	struct iov_iter         iter;           /* iterator for current data */
+	struct bio_vec          it_bvec;        /* used as an addition to it */
+	unsigned int            direction;      /* data direction */
 	size_t			resid;		/* bytes not yet consumed */
 	bool			last_piece;	/* current is last piece */
 	bool			need_crc;	/* crc update needed */
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 08786d75b990..709d9f26f755 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -523,6 +523,22 @@ static int ceph_tcp_recvmsg(struct socket *sock, void *buf, size_t len)
 	return r;
 }
 
+static int ceph_tcp_recviov(struct socket *sock, struct iov_iter *iter)
+{
+	struct msghdr msg = { .msg_flags = MSG_DONTWAIT | MSG_NOSIGNAL,
+			      .msg_iter = *iter };
+	int r;
+
+	if (!iter->count)
+		msg.msg_flags |= MSG_TRUNC;
+
+	r = sock_recvmsg(sock, &msg, msg.msg_flags);
+	if (r == -EAGAIN)
+		r = 0;
+	return r;
+}
+
+__attribute__((unused))
 static int ceph_tcp_recvpage(struct socket *sock, struct page *page,
 		     int page_offset, size_t length)
 {
@@ -594,6 +610,42 @@ static int ceph_tcp_sendpage(struct socket *sock, struct page *page,
 	return ret;
 }
 
+/**
+ * ceph_tcp_sendiov() - either does sendmsg() or 0-copy sendpage()
+ *
+ * @more is true if caller will be sending more data shortly.
+ */
+static int ceph_tcp_sendiov(struct socket *sock, struct iov_iter *iter,
+			    bool more)
+{
+	if (iov_iter_is_bvec(iter)) {
+		const struct bio_vec *bvec = &iter->bvec[0];
+		int flags = more ? MSG_MORE | MSG_SENDPAGE_NOTLAST : 0;
+
+		/* Do 0-copy instead of sendmsg */
+
+		return ceph_tcp_sendpage(sock, bvec->bv_page,
+					 iter->iov_offset + bvec->bv_offset,
+					 bvec->bv_len - iter->iov_offset,
+					 flags);
+	} else {
+		struct msghdr msg = { .msg_flags = MSG_DONTWAIT | MSG_NOSIGNAL,
+				      .msg_iter = *iter };
+		int r;
+
+		if (more)
+			msg.msg_flags |= MSG_MORE;
+		else
+			/* superfluous, but what the hell */
+			msg.msg_flags |= MSG_EOR;
+
+		r = sock_sendmsg(sock, &msg);
+		if (r == -EAGAIN)
+			r = 0;
+		return r;
+	}
+}
+
 /*
  * Shutdown/close the socket for the given connection.
  */
@@ -1086,12 +1138,7 @@ static bool ceph_msg_data_pagelist_advance(struct ceph_msg_data_cursor *cursor,
 }
 
 /*
- * Message data is handled (sent or received) in pieces, where each
- * piece resides on a single page.  The network layer might not
- * consume an entire piece at once.  A data item's cursor keeps
- * track of which piece is next to process and how much remains to
- * be processed in that piece.  It also tracks whether the current
- * piece is the last one in the data item.
+ * Message data is iterated (sent or received) by internal iov_iter.
  */
 static void __ceph_msg_data_cursor_init(struct ceph_msg_data_cursor *cursor)
 {
@@ -1120,7 +1167,8 @@ static void __ceph_msg_data_cursor_init(struct ceph_msg_data_cursor *cursor)
 	cursor->need_crc = true;
 }
 
-static void ceph_msg_data_cursor_init(struct ceph_msg *msg, size_t length)
+static void ceph_msg_data_cursor_init(unsigned int dir, struct ceph_msg *msg,
+				      size_t length)
 {
 	struct ceph_msg_data_cursor *cursor = &msg->cursor;
 
@@ -1130,33 +1178,33 @@ static void ceph_msg_data_cursor_init(struct ceph_msg *msg, size_t length)
 
 	cursor->total_resid = length;
 	cursor->data = msg->data;
+	cursor->direction = dir;
 
 	__ceph_msg_data_cursor_init(cursor);
 }
 
 /*
- * Return the page containing the next piece to process for a given
- * data item, and supply the page offset and length of that piece.
+ * Setups cursor->iter for the next piece to process.
  */
-static struct page *ceph_msg_data_next(struct ceph_msg_data_cursor *cursor,
-					size_t *page_offset, size_t *length)
+static void ceph_msg_data_next(struct ceph_msg_data_cursor *cursor)
 {
 	struct page *page;
+	size_t off, len;
 
 	switch (cursor->data->type) {
 	case CEPH_MSG_DATA_PAGELIST:
-		page = ceph_msg_data_pagelist_next(cursor, page_offset, length);
+		page = ceph_msg_data_pagelist_next(cursor, &off, &len);
 		break;
 	case CEPH_MSG_DATA_PAGES:
-		page = ceph_msg_data_pages_next(cursor, page_offset, length);
+		page = ceph_msg_data_pages_next(cursor, &off, &len);
 		break;
 #ifdef CONFIG_BLOCK
 	case CEPH_MSG_DATA_BIO:
-		page = ceph_msg_data_bio_next(cursor, page_offset, length);
+		page = ceph_msg_data_bio_next(cursor, &off, &len);
 		break;
 #endif /* CONFIG_BLOCK */
 	case CEPH_MSG_DATA_BVECS:
-		page = ceph_msg_data_bvecs_next(cursor, page_offset, length);
+		page = ceph_msg_data_bvecs_next(cursor, &off, &len);
 		break;
 	case CEPH_MSG_DATA_NONE:
 	default:
@@ -1165,11 +1213,16 @@ static struct page *ceph_msg_data_next(struct ceph_msg_data_cursor *cursor,
 	}
 
 	BUG_ON(!page);
-	BUG_ON(*page_offset + *length > PAGE_SIZE);
-	BUG_ON(!*length);
-	BUG_ON(*length > cursor->resid);
+	BUG_ON(off + len > PAGE_SIZE);
+	BUG_ON(!len);
+	BUG_ON(len > cursor->resid);
+
+	cursor->it_bvec.bv_page = page;
+	cursor->it_bvec.bv_len = len;
+	cursor->it_bvec.bv_offset = off;
 
-	return page;
+	iov_iter_bvec(&cursor->iter, cursor->direction,
+		      &cursor->it_bvec, 1, len);
 }
 
 /*
@@ -1220,11 +1273,12 @@ static size_t sizeof_footer(struct ceph_connection *con)
 	    sizeof(struct ceph_msg_footer_old);
 }
 
-static void prepare_message_data(struct ceph_msg *msg, u32 data_len)
+static void prepare_message_data(unsigned int dir, struct ceph_msg *msg,
+				 u32 data_len)
 {
 	/* Initialize data cursor */
 
-	ceph_msg_data_cursor_init(msg, (size_t)data_len);
+	ceph_msg_data_cursor_init(dir, msg, (size_t)data_len);
 }
 
 /*
@@ -1331,7 +1385,7 @@ static void prepare_write_message(struct ceph_connection *con)
 	/* is there a data payload? */
 	con->out_msg->footer.data_crc = 0;
 	if (m->data_length) {
-		prepare_message_data(con->out_msg, m->data_length);
+		prepare_message_data(WRITE, con->out_msg, m->data_length);
 		con->out_more = 1;  /* data + footer will follow */
 	} else {
 		/* no, queue up footer too and be done */
@@ -1532,16 +1586,19 @@ static int write_partial_kvec(struct ceph_connection *con)
 	return ret;  /* done! */
 }
 
-static u32 ceph_crc32c_page(u32 crc, struct page *page,
-				unsigned int page_offset,
-				unsigned int length)
+static int crc32c_kvec(struct kvec *vec, void *p)
 {
-	char *kaddr;
+	u32 *crc = p;
 
-	kaddr = kmap(page);
-	BUG_ON(kaddr == NULL);
-	crc = crc32c(crc, kaddr + page_offset, length);
-	kunmap(page);
+	*crc = crc32c(*crc, vec->iov_base, vec->iov_len);
+
+	return 0;
+}
+
+static u32 ceph_crc32c_iov(u32 crc, struct iov_iter *iter,
+			   unsigned int length)
+{
+	iov_iter_for_each_range(iter, length, crc32c_kvec, &crc);
 
 	return crc;
 }
@@ -1557,7 +1614,6 @@ static int write_partial_message_data(struct ceph_connection *con)
 	struct ceph_msg *msg = con->out_msg;
 	struct ceph_msg_data_cursor *cursor = &msg->cursor;
 	bool do_datacrc = !ceph_test_opt(from_msgr(con->msgr), NOCRC);
-	int more = MSG_MORE | MSG_SENDPAGE_NOTLAST;
 	u32 crc;
 
 	dout("%s %p msg %p\n", __func__, con, msg);
@@ -1575,9 +1631,6 @@ static int write_partial_message_data(struct ceph_connection *con)
 	 */
 	crc = do_datacrc ? le32_to_cpu(msg->footer.data_crc) : 0;
 	while (cursor->total_resid) {
-		struct page *page;
-		size_t page_offset;
-		size_t length;
 		int ret;
 
 		if (!cursor->resid) {
@@ -1585,11 +1638,8 @@ static int write_partial_message_data(struct ceph_connection *con)
 			continue;
 		}
 
-		page = ceph_msg_data_next(cursor, &page_offset, &length);
-		if (length == cursor->total_resid)
-			more = MSG_MORE;
-		ret = ceph_tcp_sendpage(con->sock, page, page_offset, length,
-					more);
+		ceph_msg_data_next(cursor);
+		ret = ceph_tcp_sendiov(con->sock, &cursor->iter, true);
 		if (ret <= 0) {
 			if (do_datacrc)
 				msg->footer.data_crc = cpu_to_le32(crc);
@@ -1597,7 +1647,7 @@ static int write_partial_message_data(struct ceph_connection *con)
 			return ret;
 		}
 		if (do_datacrc && cursor->need_crc)
-			crc = ceph_crc32c_page(crc, page, page_offset, length);
+			crc = ceph_crc32c_iov(crc, &cursor->iter, ret);
 		ceph_msg_data_advance(cursor, (size_t)ret);
 	}
 
@@ -2315,9 +2365,6 @@ static int read_partial_msg_data(struct ceph_connection *con)
 	struct ceph_msg *msg = con->in_msg;
 	struct ceph_msg_data_cursor *cursor = &msg->cursor;
 	bool do_datacrc = !ceph_test_opt(from_msgr(con->msgr), NOCRC);
-	struct page *page;
-	size_t page_offset;
-	size_t length;
 	u32 crc = 0;
 	int ret;
 
@@ -2332,8 +2379,8 @@ static int read_partial_msg_data(struct ceph_connection *con)
 			continue;
 		}
 
-		page = ceph_msg_data_next(cursor, &page_offset, &length);
-		ret = ceph_tcp_recvpage(con->sock, page, page_offset, length);
+		ceph_msg_data_next(cursor);
+		ret = ceph_tcp_recviov(con->sock, &cursor->iter);
 		if (ret <= 0) {
 			if (do_datacrc)
 				con->in_data_crc = crc;
@@ -2342,7 +2389,7 @@ static int read_partial_msg_data(struct ceph_connection *con)
 		}
 
 		if (do_datacrc)
-			crc = ceph_crc32c_page(crc, page, page_offset, ret);
+			crc = ceph_crc32c_iov(crc, &cursor->iter, ret);
 		ceph_msg_data_advance(cursor, (size_t)ret);
 	}
 	if (do_datacrc)
@@ -2443,7 +2490,7 @@ static int read_partial_message(struct ceph_connection *con)
 		/* prepare for data payload, if any */
 
 		if (data_len)
-			prepare_message_data(con->in_msg, data_len);
+			prepare_message_data(READ, con->in_msg, data_len);
 	}
 
 	/* front */
-- 
2.24.1


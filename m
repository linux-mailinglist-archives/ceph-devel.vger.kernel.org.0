Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E561B277A
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Apr 2020 15:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbgDUNTG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Apr 2020 09:19:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:50150 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728960AbgDUNTD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 09:19:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0492EABF6;
        Tue, 21 Apr 2020 13:18:58 +0000 (UTC)
From:   Roman Penyaev <rpenyaev@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        Roman Penyaev <rpenyaev@suse.de>
Subject: [PATCH 10/16] libceph: remove ->last_piece member for message data cursor
Date:   Tue, 21 Apr 2020 15:18:44 +0200
Message-Id: <20200421131850.443228-11-rpenyaev@suse.de>
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

No need to keep strange member, which is a) not used, b) can be
always calculated comparing offset and PAGE_SIZE.

Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
---
 include/linux/ceph/messenger.h |   1 -
 net/ceph/messenger.c           | 101 +++++++++++----------------------
 2 files changed, 33 insertions(+), 69 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 82a7fb0018e3..bc25f5f0e729 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -196,7 +196,6 @@ struct ceph_msg_data_cursor {
 	struct bio_vec          it_bvec;        /* used as an addition to it */
 	unsigned int            direction;      /* data direction */
 	size_t			resid;		/* bytes not yet consumed */
-	bool			last_piece;	/* current is last piece */
 	union {
 #ifdef CONFIG_BLOCK
 		struct ceph_bio_iter	bio_iter;
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 6423edf5cf65..3f8a47de62c7 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -815,6 +815,18 @@ static int con_out_kvec_skip(struct ceph_connection *con)
 	return skip;
 }
 
+static void ceph_msg_data_set_iter(struct ceph_msg_data_cursor *cursor,
+				   struct page *page, size_t offset,
+				   size_t length)
+{
+	cursor->it_bvec.bv_page = page;
+	cursor->it_bvec.bv_len = length;
+	cursor->it_bvec.bv_offset = offset;
+
+	iov_iter_bvec(&cursor->iter, cursor->direction,
+		      &cursor->it_bvec, 1, length);
+}
+
 #ifdef CONFIG_BLOCK
 
 /*
@@ -834,19 +846,15 @@ static void ceph_msg_data_bio_cursor_init(struct ceph_msg_data_cursor *cursor,
 		it->iter.bi_size = cursor->resid;
 
 	BUG_ON(cursor->resid < bio_iter_len(it->bio, it->iter));
-	cursor->last_piece = cursor->resid == bio_iter_len(it->bio, it->iter);
 }
 
-static struct page *ceph_msg_data_bio_next(struct ceph_msg_data_cursor *cursor,
-						size_t *page_offset,
-						size_t *length)
+static void ceph_msg_data_bio_next(struct ceph_msg_data_cursor *cursor)
 {
 	struct bio_vec bv = bio_iter_iovec(cursor->bio_iter.bio,
 					   cursor->bio_iter.iter);
 
-	*page_offset = bv.bv_offset;
-	*length = bv.bv_len;
-	return bv.bv_page;
+	ceph_msg_data_set_iter(cursor, bv.bv_page,
+			       bv.bv_offset, bv.bv_len);
 }
 
 static void ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,
@@ -861,7 +869,6 @@ static void ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,
 	bio_advance_iter(it->bio, &it->iter, bytes);
 
 	if (!cursor->resid) {
-		BUG_ON(!cursor->last_piece);
 		return;   /* no more data */
 	}
 
@@ -876,9 +883,7 @@ static void ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,
 			it->iter.bi_size = cursor->resid;
 	}
 
-	BUG_ON(cursor->last_piece);
 	BUG_ON(cursor->resid < bio_iter_len(it->bio, it->iter));
-	cursor->last_piece = cursor->resid == bio_iter_len(it->bio, it->iter);
 }
 #endif /* CONFIG_BLOCK */
 
@@ -893,20 +898,15 @@ static void ceph_msg_data_bvecs_cursor_init(struct ceph_msg_data_cursor *cursor,
 	cursor->bvec_iter.bi_size = cursor->resid;
 
 	BUG_ON(cursor->resid < bvec_iter_len(bvecs, cursor->bvec_iter));
-	cursor->last_piece =
-	    cursor->resid == bvec_iter_len(bvecs, cursor->bvec_iter);
 }
 
-static struct page *ceph_msg_data_bvecs_next(struct ceph_msg_data_cursor *cursor,
-						size_t *page_offset,
-						size_t *length)
+static void ceph_msg_data_bvecs_next(struct ceph_msg_data_cursor *cursor)
 {
 	struct bio_vec bv = bvec_iter_bvec(cursor->data->bvec_pos.bvecs,
 					   cursor->bvec_iter);
 
-	*page_offset = bv.bv_offset;
-	*length = bv.bv_len;
-	return bv.bv_page;
+	ceph_msg_data_set_iter(cursor, bv.bv_page,
+			       bv.bv_offset, bv.bv_len);
 }
 
 static void ceph_msg_data_bvecs_advance(struct ceph_msg_data_cursor *cursor,
@@ -921,7 +921,6 @@ static void ceph_msg_data_bvecs_advance(struct ceph_msg_data_cursor *cursor,
 	bvec_iter_advance(bvecs, &cursor->bvec_iter, bytes);
 
 	if (!cursor->resid) {
-		BUG_ON(!cursor->last_piece);
 		return;   /* no more data */
 	}
 
@@ -929,10 +928,7 @@ static void ceph_msg_data_bvecs_advance(struct ceph_msg_data_cursor *cursor,
 		       page == bvec_iter_page(bvecs, cursor->bvec_iter)))
 		return;	/* more bytes to process in this segment */
 
-	BUG_ON(cursor->last_piece);
 	BUG_ON(cursor->resid < bvec_iter_len(bvecs, cursor->bvec_iter));
-	cursor->last_piece =
-	    cursor->resid == bvec_iter_len(bvecs, cursor->bvec_iter);
 }
 
 /*
@@ -957,12 +953,9 @@ static void ceph_msg_data_pages_cursor_init(struct ceph_msg_data_cursor *cursor,
 	BUG_ON(page_count > (int)USHRT_MAX);
 	cursor->page_count = (unsigned short)page_count;
 	BUG_ON(length > SIZE_MAX - cursor->page_offset);
-	cursor->last_piece = cursor->page_offset + cursor->resid <= PAGE_SIZE;
 }
 
-static struct page *
-ceph_msg_data_pages_next(struct ceph_msg_data_cursor *cursor,
-					size_t *page_offset, size_t *length)
+static void ceph_msg_data_pages_next(struct ceph_msg_data_cursor *cursor)
 {
 	struct ceph_msg_data *data = cursor->data;
 
@@ -971,13 +964,10 @@ ceph_msg_data_pages_next(struct ceph_msg_data_cursor *cursor,
 	BUG_ON(cursor->page_index >= cursor->page_count);
 	BUG_ON(cursor->page_offset >= PAGE_SIZE);
 
-	*page_offset = cursor->page_offset;
-	if (cursor->last_piece)
-		*length = cursor->resid;
-	else
-		*length = PAGE_SIZE - *page_offset;
-
-	return data->pages[cursor->page_index];
+	ceph_msg_data_set_iter(cursor, data->pages[cursor->page_index],
+			       cursor->page_offset,
+			       min(PAGE_SIZE - cursor->page_offset,
+				   cursor->resid));
 }
 
 static void ceph_msg_data_pages_advance(struct ceph_msg_data_cursor *cursor,
@@ -1001,7 +991,6 @@ static void ceph_msg_data_pages_advance(struct ceph_msg_data_cursor *cursor,
 
 	BUG_ON(cursor->page_index >= cursor->page_count);
 	cursor->page_index++;
-	cursor->last_piece = cursor->resid <= PAGE_SIZE;
 }
 
 /*
@@ -1030,12 +1019,9 @@ ceph_msg_data_pagelist_cursor_init(struct ceph_msg_data_cursor *cursor,
 	cursor->resid = min(length, pagelist->length);
 	cursor->page = page;
 	cursor->offset = 0;
-	cursor->last_piece = cursor->resid <= PAGE_SIZE;
 }
 
-static struct page *
-ceph_msg_data_pagelist_next(struct ceph_msg_data_cursor *cursor,
-				size_t *page_offset, size_t *length)
+static void ceph_msg_data_pagelist_next(struct ceph_msg_data_cursor *cursor)
 {
 	struct ceph_msg_data *data = cursor->data;
 	struct ceph_pagelist *pagelist;
@@ -1048,14 +1034,10 @@ ceph_msg_data_pagelist_next(struct ceph_msg_data_cursor *cursor,
 	BUG_ON(!cursor->page);
 	BUG_ON(cursor->offset + cursor->resid != pagelist->length);
 
-	/* offset of first page in pagelist is always 0 */
-	*page_offset = cursor->offset & ~PAGE_MASK;
-	if (cursor->last_piece)
-		*length = cursor->resid;
-	else
-		*length = PAGE_SIZE - *page_offset;
-
-	return cursor->page;
+	ceph_msg_data_set_iter(cursor, cursor->page,
+			       cursor->offset % ~PAGE_MASK,
+			       min(PAGE_SIZE - cursor->offset,
+				   cursor->resid));
 }
 
 static void ceph_msg_data_pagelist_advance(struct ceph_msg_data_cursor *cursor,
@@ -1087,7 +1069,6 @@ static void ceph_msg_data_pagelist_advance(struct ceph_msg_data_cursor *cursor,
 
 	BUG_ON(list_is_last(&cursor->page->lru, &pagelist->head));
 	cursor->page = list_next_entry(cursor->page, lru);
-	cursor->last_piece = cursor->resid <= PAGE_SIZE;
 }
 
 /*
@@ -1140,41 +1121,26 @@ static void ceph_msg_data_cursor_init(unsigned int dir, struct ceph_msg *msg,
  */
 static void ceph_msg_data_next(struct ceph_msg_data_cursor *cursor)
 {
-	struct page *page;
-	size_t off, len;
-
 	switch (cursor->data->type) {
 	case CEPH_MSG_DATA_PAGELIST:
-		page = ceph_msg_data_pagelist_next(cursor, &off, &len);
+		ceph_msg_data_pagelist_next(cursor);
 		break;
 	case CEPH_MSG_DATA_PAGES:
-		page = ceph_msg_data_pages_next(cursor, &off, &len);
+		ceph_msg_data_pages_next(cursor);
 		break;
 #ifdef CONFIG_BLOCK
 	case CEPH_MSG_DATA_BIO:
-		page = ceph_msg_data_bio_next(cursor, &off, &len);
+		ceph_msg_data_bio_next(cursor);
 		break;
 #endif /* CONFIG_BLOCK */
 	case CEPH_MSG_DATA_BVECS:
-		page = ceph_msg_data_bvecs_next(cursor, &off, &len);
+		ceph_msg_data_bvecs_next(cursor);
 		break;
 	case CEPH_MSG_DATA_NONE:
 	default:
-		page = NULL;
+		BUG();
 		break;
 	}
-
-	BUG_ON(!page);
-	BUG_ON(off + len > PAGE_SIZE);
-	BUG_ON(!len);
-	BUG_ON(len > cursor->resid);
-
-	cursor->it_bvec.bv_page = page;
-	cursor->it_bvec.bv_len = len;
-	cursor->it_bvec.bv_offset = off;
-
-	iov_iter_bvec(&cursor->iter, cursor->direction,
-		      &cursor->it_bvec, 1, len);
 }
 
 static void ceph_msg_data_advance(struct ceph_msg_data_cursor *cursor,
@@ -1204,7 +1170,6 @@ static void ceph_msg_data_advance(struct ceph_msg_data_cursor *cursor,
 	cursor->total_resid -= bytes;
 
 	if (!cursor->resid && cursor->total_resid) {
-		WARN_ON(!cursor->last_piece);
 		cursor->data++;
 		__ceph_msg_data_cursor_init(cursor);
 	}
-- 
2.24.1


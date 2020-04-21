Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3611B2776
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Apr 2020 15:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgDUNTC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Apr 2020 09:19:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:50130 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728948AbgDUNTB (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 09:19:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A41E8AE28;
        Tue, 21 Apr 2020 13:18:58 +0000 (UTC)
From:   Roman Penyaev <rpenyaev@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        Roman Penyaev <rpenyaev@suse.de>
Subject: [PATCH 09/16] libceph: no need for cursor->need_crc for messenger
Date:   Tue, 21 Apr 2020 15:18:43 +0200
Message-Id: <20200421131850.443228-10-rpenyaev@suse.de>
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

I want to simplify cursor and switch to iov_iter.  Here I get rid
of ->need_crc, now we calculate crc not for 1 page at once, but exactly
the size written to the socket. So get rid of new_piece and ->need_crc
completely.

Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
---
 include/linux/ceph/messenger.h |  1 -
 net/ceph/messenger.c           | 55 +++++++++++++---------------------
 2 files changed, 20 insertions(+), 36 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 044c74333c27..82a7fb0018e3 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -197,7 +197,6 @@ struct ceph_msg_data_cursor {
 	unsigned int            direction;      /* data direction */
 	size_t			resid;		/* bytes not yet consumed */
 	bool			last_piece;	/* current is last piece */
-	bool			need_crc;	/* crc update needed */
 	union {
 #ifdef CONFIG_BLOCK
 		struct ceph_bio_iter	bio_iter;
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 8f867c8dc481..6423edf5cf65 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -849,8 +849,8 @@ static struct page *ceph_msg_data_bio_next(struct ceph_msg_data_cursor *cursor,
 	return bv.bv_page;
 }
 
-static bool ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,
-					size_t bytes)
+static void ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,
+				      size_t bytes)
 {
 	struct ceph_bio_iter *it = &cursor->bio_iter;
 	struct page *page = bio_iter_page(it->bio, it->iter);
@@ -862,12 +862,12 @@ static bool ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,
 
 	if (!cursor->resid) {
 		BUG_ON(!cursor->last_piece);
-		return false;   /* no more data */
+		return;   /* no more data */
 	}
 
 	if (!bytes || (it->iter.bi_size && it->iter.bi_bvec_done &&
 		       page == bio_iter_page(it->bio, it->iter)))
-		return false;	/* more bytes to process in this segment */
+		return;	/* more bytes to process in this segment */
 
 	if (!it->iter.bi_size) {
 		it->bio = it->bio->bi_next;
@@ -879,7 +879,6 @@ static bool ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,
 	BUG_ON(cursor->last_piece);
 	BUG_ON(cursor->resid < bio_iter_len(it->bio, it->iter));
 	cursor->last_piece = cursor->resid == bio_iter_len(it->bio, it->iter);
-	return true;
 }
 #endif /* CONFIG_BLOCK */
 
@@ -910,7 +909,7 @@ static struct page *ceph_msg_data_bvecs_next(struct ceph_msg_data_cursor *cursor
 	return bv.bv_page;
 }
 
-static bool ceph_msg_data_bvecs_advance(struct ceph_msg_data_cursor *cursor,
+static void ceph_msg_data_bvecs_advance(struct ceph_msg_data_cursor *cursor,
 					size_t bytes)
 {
 	struct bio_vec *bvecs = cursor->data->bvec_pos.bvecs;
@@ -923,18 +922,17 @@ static bool ceph_msg_data_bvecs_advance(struct ceph_msg_data_cursor *cursor,
 
 	if (!cursor->resid) {
 		BUG_ON(!cursor->last_piece);
-		return false;   /* no more data */
+		return;   /* no more data */
 	}
 
 	if (!bytes || (cursor->bvec_iter.bi_bvec_done &&
 		       page == bvec_iter_page(bvecs, cursor->bvec_iter)))
-		return false;	/* more bytes to process in this segment */
+		return;	/* more bytes to process in this segment */
 
 	BUG_ON(cursor->last_piece);
 	BUG_ON(cursor->resid < bvec_iter_len(bvecs, cursor->bvec_iter));
 	cursor->last_piece =
 	    cursor->resid == bvec_iter_len(bvecs, cursor->bvec_iter);
-	return true;
 }
 
 /*
@@ -982,8 +980,8 @@ ceph_msg_data_pages_next(struct ceph_msg_data_cursor *cursor,
 	return data->pages[cursor->page_index];
 }
 
-static bool ceph_msg_data_pages_advance(struct ceph_msg_data_cursor *cursor,
-						size_t bytes)
+static void ceph_msg_data_pages_advance(struct ceph_msg_data_cursor *cursor,
+					size_t bytes)
 {
 	BUG_ON(cursor->data->type != CEPH_MSG_DATA_PAGES);
 
@@ -994,18 +992,16 @@ static bool ceph_msg_data_pages_advance(struct ceph_msg_data_cursor *cursor,
 	cursor->resid -= bytes;
 	cursor->page_offset = (cursor->page_offset + bytes) & ~PAGE_MASK;
 	if (!bytes || cursor->page_offset)
-		return false;	/* more bytes to process in the current page */
+		return;	/* more bytes to process in the current page */
 
 	if (!cursor->resid)
-		return false;   /* no more data */
+		return;   /* no more data */
 
 	/* Move on to the next page; offset is already at 0 */
 
 	BUG_ON(cursor->page_index >= cursor->page_count);
 	cursor->page_index++;
 	cursor->last_piece = cursor->resid <= PAGE_SIZE;
-
-	return true;
 }
 
 /*
@@ -1062,8 +1058,8 @@ ceph_msg_data_pagelist_next(struct ceph_msg_data_cursor *cursor,
 	return cursor->page;
 }
 
-static bool ceph_msg_data_pagelist_advance(struct ceph_msg_data_cursor *cursor,
-						size_t bytes)
+static void ceph_msg_data_pagelist_advance(struct ceph_msg_data_cursor *cursor,
+					   size_t bytes)
 {
 	struct ceph_msg_data *data = cursor->data;
 	struct ceph_pagelist *pagelist;
@@ -1082,18 +1078,16 @@ static bool ceph_msg_data_pagelist_advance(struct ceph_msg_data_cursor *cursor,
 	cursor->offset += bytes;
 	/* offset of first page in pagelist is always 0 */
 	if (!bytes || cursor->offset & ~PAGE_MASK)
-		return false;	/* more bytes to process in the current page */
+		return;	/* more bytes to process in the current page */
 
 	if (!cursor->resid)
-		return false;   /* no more data */
+		return;   /* no more data */
 
 	/* Move on to the next page */
 
 	BUG_ON(list_is_last(&cursor->page->lru, &pagelist->head));
 	cursor->page = list_next_entry(cursor->page, lru);
 	cursor->last_piece = cursor->resid <= PAGE_SIZE;
-
-	return true;
 }
 
 /*
@@ -1123,7 +1117,6 @@ static void __ceph_msg_data_cursor_init(struct ceph_msg_data_cursor *cursor)
 		/* BUG(); */
 		break;
 	}
-	cursor->need_crc = true;
 }
 
 static void ceph_msg_data_cursor_init(unsigned int dir, struct ceph_msg *msg,
@@ -1184,30 +1177,24 @@ static void ceph_msg_data_next(struct ceph_msg_data_cursor *cursor)
 		      &cursor->it_bvec, 1, len);
 }
 
-/*
- * Returns true if the result moves the cursor on to the next piece
- * of the data item.
- */
 static void ceph_msg_data_advance(struct ceph_msg_data_cursor *cursor,
 				  size_t bytes)
 {
-	bool new_piece;
-
 	BUG_ON(bytes > cursor->resid);
 	switch (cursor->data->type) {
 	case CEPH_MSG_DATA_PAGELIST:
-		new_piece = ceph_msg_data_pagelist_advance(cursor, bytes);
+		ceph_msg_data_pagelist_advance(cursor, bytes);
 		break;
 	case CEPH_MSG_DATA_PAGES:
-		new_piece = ceph_msg_data_pages_advance(cursor, bytes);
+		ceph_msg_data_pages_advance(cursor, bytes);
 		break;
 #ifdef CONFIG_BLOCK
 	case CEPH_MSG_DATA_BIO:
-		new_piece = ceph_msg_data_bio_advance(cursor, bytes);
+		ceph_msg_data_bio_advance(cursor, bytes);
 		break;
 #endif /* CONFIG_BLOCK */
 	case CEPH_MSG_DATA_BVECS:
-		new_piece = ceph_msg_data_bvecs_advance(cursor, bytes);
+		ceph_msg_data_bvecs_advance(cursor, bytes);
 		break;
 	case CEPH_MSG_DATA_NONE:
 	default:
@@ -1220,9 +1207,7 @@ static void ceph_msg_data_advance(struct ceph_msg_data_cursor *cursor,
 		WARN_ON(!cursor->last_piece);
 		cursor->data++;
 		__ceph_msg_data_cursor_init(cursor);
-		new_piece = true;
 	}
-	cursor->need_crc = new_piece;
 }
 
 static size_t sizeof_footer(struct ceph_connection *con)
@@ -1606,7 +1591,7 @@ static int write_partial_message_data(struct ceph_connection *con)
 
 			return ret;
 		}
-		if (do_datacrc && cursor->need_crc)
+		if (do_datacrc)
 			crc = ceph_crc32c_iov(crc, &cursor->iter, ret);
 		ceph_msg_data_advance(cursor, (size_t)ret);
 	}
-- 
2.24.1


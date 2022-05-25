Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA396533A77
	for <lists+ceph-devel@lfdr.de>; Wed, 25 May 2022 12:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237258AbiEYKLN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 May 2022 06:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242406AbiEYKLJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 25 May 2022 06:11:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BA0986EE
        for <ceph-devel@vger.kernel.org>; Wed, 25 May 2022 03:11:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B56361964
        for <ceph-devel@vger.kernel.org>; Wed, 25 May 2022 10:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A7BC385B8;
        Wed, 25 May 2022 10:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653473463;
        bh=aTRn7IxvKGS5k4HnzNeWoVcFtFdmY0ucODfNPXUPmgw=;
        h=From:To:Cc:Subject:Date:From;
        b=KXUI6m6p5RN5Uleq0DhON2ybe3M/Q9nHG1VbOKlplzJfqwoyikR395Kl8yuiqolb8
         Ez/uP800p64R6NxgDlvxvf/vvewVHLaeJK/cNRsnalrbevoAubAcYivbCOhYFqxnna
         ND5BiBu0JiL6waadCKT5lAmRddkiDYxholgzuLFnidycpqyxEvL1TvsTXWfvugdyHX
         XQnuzGtAtJlY6nUJOzLzUu2jHpH+HXor/v7uLwih8Bh6y/Z6S0yMou5QHEQpUi5s09
         TrxGuh40fhr8Zg+ponHbChHY6R0j7i7uzHnpMetPVr5QIEawgLGIOZMFChGw6hcs5N
         zIZocLsWGQYPA==
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@gmail.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org
Subject: [PATCH v2] libceph: drop last_piece flag from ceph_msg_data_cursor
Date:   Wed, 25 May 2022 06:11:00 -0400
Message-Id: <20220525101100.7167-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

ceph_msg_data_next is always passed a NULL pointer for this field. Some
of the "next" operations look at it in order to determine the length,
but we can just take the min of the data on the page or cursor->resid.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/messenger.h |  4 +---
 net/ceph/messenger.c           | 40 +++++-----------------------------
 net/ceph/messenger_v1.c        |  6 ++---
 net/ceph/messenger_v2.c        |  2 +-
 4 files changed, 10 insertions(+), 42 deletions(-)

v2: use min_t(size_t, ...) for the length calculations, as noted by the
    kernel test robot.

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index e7f2fb2fc207..99c1726be6ee 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -207,7 +207,6 @@ struct ceph_msg_data_cursor {
 
 	struct ceph_msg_data	*data;		/* current data item */
 	size_t			resid;		/* bytes not yet consumed */
-	bool			last_piece;	/* current is last piece */
 	bool			need_crc;	/* crc update needed */
 	union {
 #ifdef CONFIG_BLOCK
@@ -498,8 +497,7 @@ void ceph_con_discard_requeued(struct ceph_connection *con, u64 reconnect_seq);
 void ceph_msg_data_cursor_init(struct ceph_msg_data_cursor *cursor,
 			       struct ceph_msg *msg, size_t length);
 struct page *ceph_msg_data_next(struct ceph_msg_data_cursor *cursor,
-				size_t *page_offset, size_t *length,
-				bool *last_piece);
+				size_t *page_offset, size_t *length);
 void ceph_msg_data_advance(struct ceph_msg_data_cursor *cursor, size_t bytes);
 
 u32 ceph_crc32c_page(u32 crc, struct page *page, unsigned int page_offset,
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index d3bb656308b4..dfa237fbd5a3 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -728,7 +728,6 @@ static void ceph_msg_data_bio_cursor_init(struct ceph_msg_data_cursor *cursor,
 		it->iter.bi_size = cursor->resid;
 
 	BUG_ON(cursor->resid < bio_iter_len(it->bio, it->iter));
-	cursor->last_piece = cursor->resid == bio_iter_len(it->bio, it->iter);
 }
 
 static struct page *ceph_msg_data_bio_next(struct ceph_msg_data_cursor *cursor,
@@ -754,10 +753,8 @@ static bool ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,
 	cursor->resid -= bytes;
 	bio_advance_iter(it->bio, &it->iter, bytes);
 
-	if (!cursor->resid) {
-		BUG_ON(!cursor->last_piece);
+	if (!cursor->resid)
 		return false;   /* no more data */
-	}
 
 	if (!bytes || (it->iter.bi_size && it->iter.bi_bvec_done &&
 		       page == bio_iter_page(it->bio, it->iter)))
@@ -770,9 +767,7 @@ static bool ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,
 			it->iter.bi_size = cursor->resid;
 	}
 
-	BUG_ON(cursor->last_piece);
 	BUG_ON(cursor->resid < bio_iter_len(it->bio, it->iter));
-	cursor->last_piece = cursor->resid == bio_iter_len(it->bio, it->iter);
 	return true;
 }
 #endif /* CONFIG_BLOCK */
@@ -788,8 +783,6 @@ static void ceph_msg_data_bvecs_cursor_init(struct ceph_msg_data_cursor *cursor,
 	cursor->bvec_iter.bi_size = cursor->resid;
 
 	BUG_ON(cursor->resid < bvec_iter_len(bvecs, cursor->bvec_iter));
-	cursor->last_piece =
-	    cursor->resid == bvec_iter_len(bvecs, cursor->bvec_iter);
 }
 
 static struct page *ceph_msg_data_bvecs_next(struct ceph_msg_data_cursor *cursor,
@@ -815,19 +808,14 @@ static bool ceph_msg_data_bvecs_advance(struct ceph_msg_data_cursor *cursor,
 	cursor->resid -= bytes;
 	bvec_iter_advance(bvecs, &cursor->bvec_iter, bytes);
 
-	if (!cursor->resid) {
-		BUG_ON(!cursor->last_piece);
+	if (!cursor->resid)
 		return false;   /* no more data */
-	}
 
 	if (!bytes || (cursor->bvec_iter.bi_bvec_done &&
 		       page == bvec_iter_page(bvecs, cursor->bvec_iter)))
 		return false;	/* more bytes to process in this segment */
 
-	BUG_ON(cursor->last_piece);
 	BUG_ON(cursor->resid < bvec_iter_len(bvecs, cursor->bvec_iter));
-	cursor->last_piece =
-	    cursor->resid == bvec_iter_len(bvecs, cursor->bvec_iter);
 	return true;
 }
 
@@ -853,7 +841,6 @@ static void ceph_msg_data_pages_cursor_init(struct ceph_msg_data_cursor *cursor,
 	BUG_ON(page_count > (int)USHRT_MAX);
 	cursor->page_count = (unsigned short)page_count;
 	BUG_ON(length > SIZE_MAX - cursor->page_offset);
-	cursor->last_piece = cursor->page_offset + cursor->resid <= PAGE_SIZE;
 }
 
 static struct page *
@@ -868,11 +855,7 @@ ceph_msg_data_pages_next(struct ceph_msg_data_cursor *cursor,
 	BUG_ON(cursor->page_offset >= PAGE_SIZE);
 
 	*page_offset = cursor->page_offset;
-	if (cursor->last_piece)
-		*length = cursor->resid;
-	else
-		*length = PAGE_SIZE - *page_offset;
-
+	*length = min_t(size_t, cursor->resid, PAGE_SIZE - *page_offset);
 	return data->pages[cursor->page_index];
 }
 
@@ -897,8 +880,6 @@ static bool ceph_msg_data_pages_advance(struct ceph_msg_data_cursor *cursor,
 
 	BUG_ON(cursor->page_index >= cursor->page_count);
 	cursor->page_index++;
-	cursor->last_piece = cursor->resid <= PAGE_SIZE;
-
 	return true;
 }
 
@@ -928,7 +909,6 @@ ceph_msg_data_pagelist_cursor_init(struct ceph_msg_data_cursor *cursor,
 	cursor->resid = min(length, pagelist->length);
 	cursor->page = page;
 	cursor->offset = 0;
-	cursor->last_piece = cursor->resid <= PAGE_SIZE;
 }
 
 static struct page *
@@ -948,11 +928,7 @@ ceph_msg_data_pagelist_next(struct ceph_msg_data_cursor *cursor,
 
 	/* offset of first page in pagelist is always 0 */
 	*page_offset = cursor->offset & ~PAGE_MASK;
-	if (cursor->last_piece)
-		*length = cursor->resid;
-	else
-		*length = PAGE_SIZE - *page_offset;
-
+	*length = min_t(size_t, cursor->resid, PAGE_SIZE - *page_offset);
 	return cursor->page;
 }
 
@@ -985,8 +961,6 @@ static bool ceph_msg_data_pagelist_advance(struct ceph_msg_data_cursor *cursor,
 
 	BUG_ON(list_is_last(&cursor->page->lru, &pagelist->head));
 	cursor->page = list_next_entry(cursor->page, lru);
-	cursor->last_piece = cursor->resid <= PAGE_SIZE;
-
 	return true;
 }
 
@@ -1044,8 +1018,7 @@ void ceph_msg_data_cursor_init(struct ceph_msg_data_cursor *cursor,
  * Indicate whether this is the last piece in this data item.
  */
 struct page *ceph_msg_data_next(struct ceph_msg_data_cursor *cursor,
-				size_t *page_offset, size_t *length,
-				bool *last_piece)
+				size_t *page_offset, size_t *length)
 {
 	struct page *page;
 
@@ -1074,8 +1047,6 @@ struct page *ceph_msg_data_next(struct ceph_msg_data_cursor *cursor,
 	BUG_ON(*page_offset + *length > PAGE_SIZE);
 	BUG_ON(!*length);
 	BUG_ON(*length > cursor->resid);
-	if (last_piece)
-		*last_piece = cursor->last_piece;
 
 	return page;
 }
@@ -1112,7 +1083,6 @@ void ceph_msg_data_advance(struct ceph_msg_data_cursor *cursor, size_t bytes)
 	cursor->total_resid -= bytes;
 
 	if (!cursor->resid && cursor->total_resid) {
-		WARN_ON(!cursor->last_piece);
 		cursor->data++;
 		__ceph_msg_data_cursor_init(cursor);
 		new_piece = true;
diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index 6b014eca3a13..3ddbde87e4d6 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -495,7 +495,7 @@ static int write_partial_message_data(struct ceph_connection *con)
 			continue;
 		}
 
-		page = ceph_msg_data_next(cursor, &page_offset, &length, NULL);
+		page = ceph_msg_data_next(cursor, &page_offset, &length);
 		if (length == cursor->total_resid)
 			more = MSG_MORE;
 		ret = ceph_tcp_sendpage(con->sock, page, page_offset, length,
@@ -1008,7 +1008,7 @@ static int read_partial_msg_data(struct ceph_connection *con)
 			continue;
 		}
 
-		page = ceph_msg_data_next(cursor, &page_offset, &length, NULL);
+		page = ceph_msg_data_next(cursor, &page_offset, &length);
 		ret = ceph_tcp_recvpage(con->sock, page, page_offset, length);
 		if (ret <= 0) {
 			if (do_datacrc)
@@ -1050,7 +1050,7 @@ static int read_partial_msg_data_bounce(struct ceph_connection *con)
 			continue;
 		}
 
-		page = ceph_msg_data_next(cursor, &off, &len, NULL);
+		page = ceph_msg_data_next(cursor, &off, &len);
 		ret = ceph_tcp_recvpage(con->sock, con->bounce_page, 0, len);
 		if (ret <= 0) {
 			con->in_data_crc = crc;
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index c6e5bfc717d5..cc8ff81a50b7 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -862,7 +862,7 @@ static void get_bvec_at(struct ceph_msg_data_cursor *cursor,
 		ceph_msg_data_advance(cursor, 0);
 
 	/* get a piece of data, cursor isn't advanced */
-	page = ceph_msg_data_next(cursor, &off, &len, NULL);
+	page = ceph_msg_data_next(cursor, &off, &len);
 
 	bv->bv_page = page;
 	bv->bv_offset = off;
-- 
2.36.1


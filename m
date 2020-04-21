Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8224E1B277B
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Apr 2020 15:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbgDUNTH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Apr 2020 09:19:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:50210 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728990AbgDUNTC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 09:19:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1DC2DAE6D;
        Tue, 21 Apr 2020 13:19:00 +0000 (UTC)
From:   Roman Penyaev <rpenyaev@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        Roman Penyaev <rpenyaev@suse.de>
Subject: [PATCH 14/16] libceph: switch pages cursor to iov_iter for messenger
Date:   Tue, 21 Apr 2020 15:18:48 +0200
Message-Id: <20200421131850.443228-15-rpenyaev@suse.de>
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

Though it still uses pages, ceph_msg_data_pages_next() is noop now.

Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
---
 include/linux/ceph/messenger.h |  1 -
 net/ceph/messenger.c           | 33 ++++++++++++++-------------------
 2 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 89874fe7153b..822182ac4386 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -201,7 +201,6 @@ struct ceph_msg_data_cursor {
 		struct ceph_bio_iter	bio_iter;
 #endif /* CONFIG_BLOCK */
 		struct {				/* pages */
-			unsigned int	page_offset;	/* offset in page */
 			unsigned short	page_index;	/* index in array */
 			unsigned short	page_count;	/* pages in array */
 		};
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index ea91f94096f1..288f3c66a4d1 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -929,6 +929,7 @@ static void ceph_msg_data_pages_cursor_init(struct ceph_msg_data_cursor *cursor,
 					size_t length)
 {
 	struct ceph_msg_data *data = cursor->data;
+	unsigned int page_offset;
 	int page_count;
 
 	BUG_ON(data->type != CEPH_MSG_DATA_PAGES);
@@ -938,26 +939,20 @@ static void ceph_msg_data_pages_cursor_init(struct ceph_msg_data_cursor *cursor,
 
 	cursor->resid = min(length, data->length);
 	page_count = calc_pages_for(data->alignment, (u64)data->length);
-	cursor->page_offset = data->alignment & ~PAGE_MASK;
+	page_offset = data->alignment & ~PAGE_MASK;
 	cursor->page_index = 0;
 	BUG_ON(page_count > (int)USHRT_MAX);
 	cursor->page_count = (unsigned short)page_count;
-	BUG_ON(length > SIZE_MAX - cursor->page_offset);
+	BUG_ON(length > SIZE_MAX - page_offset);
+
+	ceph_msg_data_set_iter(cursor, data->pages[cursor->page_index],
+			       page_offset, min(PAGE_SIZE - page_offset,
+						cursor->resid));
 }
 
 static void ceph_msg_data_pages_next(struct ceph_msg_data_cursor *cursor)
 {
-	struct ceph_msg_data *data = cursor->data;
-
-	BUG_ON(data->type != CEPH_MSG_DATA_PAGES);
-
-	BUG_ON(cursor->page_index >= cursor->page_count);
-	BUG_ON(cursor->page_offset >= PAGE_SIZE);
-
-	ceph_msg_data_set_iter(cursor, data->pages[cursor->page_index],
-			       cursor->page_offset,
-			       min(PAGE_SIZE - cursor->page_offset,
-				   cursor->resid));
+	/* Nothing here */
 }
 
 static void ceph_msg_data_pages_advance(struct ceph_msg_data_cursor *cursor,
@@ -965,13 +960,10 @@ static void ceph_msg_data_pages_advance(struct ceph_msg_data_cursor *cursor,
 {
 	BUG_ON(cursor->data->type != CEPH_MSG_DATA_PAGES);
 
-	BUG_ON(cursor->page_offset + bytes > PAGE_SIZE);
-
-	/* Advance the cursor page offset */
-
+	/* Advance the cursor iter */
 	cursor->resid -= bytes;
-	cursor->page_offset = (cursor->page_offset + bytes) & ~PAGE_MASK;
-	if (!bytes || cursor->page_offset)
+	iov_iter_advance(&cursor->iter, bytes);
+	if (!bytes || iov_iter_count(&cursor->iter))
 		return;	/* more bytes to process in the current page */
 
 	if (!cursor->resid)
@@ -981,6 +973,9 @@ static void ceph_msg_data_pages_advance(struct ceph_msg_data_cursor *cursor,
 
 	BUG_ON(cursor->page_index >= cursor->page_count);
 	cursor->page_index++;
+
+	ceph_msg_data_set_iter(cursor, cursor->data->pages[cursor->page_index],
+			       0, min(PAGE_SIZE, cursor->resid));
 }
 
 /*
-- 
2.24.1


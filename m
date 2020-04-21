Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E0E1B2777
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Apr 2020 15:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgDUNTD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Apr 2020 09:19:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:50118 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728970AbgDUNTC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 09:19:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DE968AE65;
        Tue, 21 Apr 2020 13:18:59 +0000 (UTC)
From:   Roman Penyaev <rpenyaev@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        Roman Penyaev <rpenyaev@suse.de>
Subject: [PATCH 13/16] libceph: switch bio cursor to iov_iter for messenger
Date:   Tue, 21 Apr 2020 15:18:47 +0200
Message-Id: <20200421131850.443228-14-rpenyaev@suse.de>
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

Data cursor of bio type uses bio->bi_io_vec directly.

Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
---
 net/ceph/messenger.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 19f85bb85340..ea91f94096f1 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -829,6 +829,22 @@ static void ceph_msg_data_set_iter(struct ceph_msg_data_cursor *cursor,
 
 #ifdef CONFIG_BLOCK
 
+static void set_bio_iter_to_iov_iter(struct ceph_msg_data_cursor *cursor)
+{
+	struct ceph_bio_iter *it = &cursor->bio_iter;
+
+	iov_iter_bvec(&cursor->iter, cursor->direction,
+		      it->bio->bi_io_vec + it->iter.bi_idx,
+		      it->bio->bi_vcnt - it->iter.bi_idx,
+		      it->iter.bi_size);
+	/*
+	 * Careful here: use multipage offset, because we need an offset
+	 * in the whole bvec, not in a page
+	 */
+	cursor->iter.iov_offset =
+		mp_bvec_iter_offset(cursor->iter.bvec, it->iter);
+}
+
 /*
  * For a bio data item, a piece is whatever remains of the next
  * entry in the current bio iovec, or the first entry in the next
@@ -846,15 +862,12 @@ static void ceph_msg_data_bio_cursor_init(struct ceph_msg_data_cursor *cursor,
 		it->iter.bi_size = cursor->resid;
 
 	BUG_ON(cursor->resid < bio_iter_len(it->bio, it->iter));
+	set_bio_iter_to_iov_iter(cursor);
 }
 
 static void ceph_msg_data_bio_next(struct ceph_msg_data_cursor *cursor)
 {
-	struct bio_vec bv = bio_iter_iovec(cursor->bio_iter.bio,
-					   cursor->bio_iter.iter);
-
-	ceph_msg_data_set_iter(cursor, bv.bv_page,
-			       bv.bv_offset, bv.bv_len);
+	/* Nothing here */
 }
 
 static void ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,
@@ -863,21 +876,23 @@ static void ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,
 	struct ceph_bio_iter *it = &cursor->bio_iter;
 
 	BUG_ON(bytes > cursor->resid);
-	BUG_ON(bytes > bio_iter_len(it->bio, it->iter));
+	BUG_ON(bytes > iov_iter_count(&cursor->iter));
 	cursor->resid -= bytes;
-	bio_advance_iter(it->bio, &it->iter, bytes);
+	iov_iter_advance(&cursor->iter, bytes);
 
 	if (!bytes || !cursor->resid)
 		return;   /* no more data */
 
-	if (!it->iter.bi_size) {
+	if (!iov_iter_count(&cursor->iter)) {
 		it->bio = it->bio->bi_next;
 		it->iter = it->bio->bi_iter;
 		if (cursor->resid < it->iter.bi_size)
 			it->iter.bi_size = cursor->resid;
+
+		set_bio_iter_to_iov_iter(cursor);
 	}
 
-	BUG_ON(cursor->resid < bio_iter_len(it->bio, it->iter));
+	BUG_ON(cursor->resid != iov_iter_count(&cursor->iter));
 }
 #endif /* CONFIG_BLOCK */
 
-- 
2.24.1


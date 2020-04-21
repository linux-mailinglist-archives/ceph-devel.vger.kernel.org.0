Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211DB1B2778
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Apr 2020 15:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbgDUNTE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Apr 2020 09:19:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:50180 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728969AbgDUNTC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 09:19:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 95BC3AE41;
        Tue, 21 Apr 2020 13:18:59 +0000 (UTC)
From:   Roman Penyaev <rpenyaev@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        Roman Penyaev <rpenyaev@suse.de>
Subject: [PATCH 12/16] libceph: switch bvecs cursor to iov_iter for messenger
Date:   Tue, 21 Apr 2020 15:18:46 +0200
Message-Id: <20200421131850.443228-13-rpenyaev@suse.de>
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

Now pages are not visible for the bvecs data and iov_iter API
is used instead.

Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
---
 include/linux/ceph/messenger.h |  1 -
 net/ceph/messenger.c           | 20 +++++---------------
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index bc25f5f0e729..89874fe7153b 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -200,7 +200,6 @@ struct ceph_msg_data_cursor {
 #ifdef CONFIG_BLOCK
 		struct ceph_bio_iter	bio_iter;
 #endif /* CONFIG_BLOCK */
-		struct bvec_iter	bvec_iter;
 		struct {				/* pages */
 			unsigned int	page_offset;	/* offset in page */
 			unsigned short	page_index;	/* index in array */
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 7465039da9f5..19f85bb85340 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -885,35 +885,25 @@ static void ceph_msg_data_bvecs_cursor_init(struct ceph_msg_data_cursor *cursor,
 					size_t length)
 {
 	struct ceph_msg_data *data = cursor->data;
-	struct bio_vec *bvecs = data->bvec_pos.bvecs;
 
 	cursor->resid = min_t(size_t, length, data->bvec_pos.iter.bi_size);
-	cursor->bvec_iter = data->bvec_pos.iter;
-	cursor->bvec_iter.bi_size = cursor->resid;
 
-	BUG_ON(cursor->resid < bvec_iter_len(bvecs, cursor->bvec_iter));
+	iov_iter_bvec(&cursor->iter, cursor->direction, data->bvec_pos.bvecs,
+		      data->num_bvecs, cursor->resid);
 }
 
 static void ceph_msg_data_bvecs_next(struct ceph_msg_data_cursor *cursor)
 {
-	struct bio_vec bv = bvec_iter_bvec(cursor->data->bvec_pos.bvecs,
-					   cursor->bvec_iter);
-
-	ceph_msg_data_set_iter(cursor, bv.bv_page,
-			       bv.bv_offset, bv.bv_len);
+	/* Nothing here */
 }
 
 static void ceph_msg_data_bvecs_advance(struct ceph_msg_data_cursor *cursor,
 					size_t bytes)
 {
-	struct bio_vec *bvecs = cursor->data->bvec_pos.bvecs;
-
 	BUG_ON(bytes > cursor->resid);
-	BUG_ON(bytes > bvec_iter_len(bvecs, cursor->bvec_iter));
+	BUG_ON(bytes > iov_iter_count(&cursor->iter));
 	cursor->resid -= bytes;
-	bvec_iter_advance(bvecs, &cursor->bvec_iter, bytes);
-
-	BUG_ON(cursor->resid < bvec_iter_len(bvecs, cursor->bvec_iter));
+	iov_iter_advance(&cursor->iter, bytes);
 }
 
 /*
-- 
2.24.1


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3681B2780
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Apr 2020 15:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbgDUNTL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Apr 2020 09:19:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:50096 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728962AbgDUNTB (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 09:19:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9611CAE5E;
        Tue, 21 Apr 2020 13:18:59 +0000 (UTC)
From:   Roman Penyaev <rpenyaev@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        Roman Penyaev <rpenyaev@suse.de>
Subject: [PATCH 11/16] libceph: remove not necessary checks on doing advance on bio and bvecs cursor
Date:   Tue, 21 Apr 2020 15:18:45 +0200
Message-Id: <20200421131850.443228-12-rpenyaev@suse.de>
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

They were used for returning false, indicating that we are still
on the same page.  Caller is not interested now, so just remove.

Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
---
 net/ceph/messenger.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 3f8a47de62c7..7465039da9f5 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -861,20 +861,14 @@ static void ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,
 				      size_t bytes)
 {
 	struct ceph_bio_iter *it = &cursor->bio_iter;
-	struct page *page = bio_iter_page(it->bio, it->iter);
 
 	BUG_ON(bytes > cursor->resid);
 	BUG_ON(bytes > bio_iter_len(it->bio, it->iter));
 	cursor->resid -= bytes;
 	bio_advance_iter(it->bio, &it->iter, bytes);
 
-	if (!cursor->resid) {
+	if (!bytes || !cursor->resid)
 		return;   /* no more data */
-	}
-
-	if (!bytes || (it->iter.bi_size && it->iter.bi_bvec_done &&
-		       page == bio_iter_page(it->bio, it->iter)))
-		return;	/* more bytes to process in this segment */
 
 	if (!it->iter.bi_size) {
 		it->bio = it->bio->bi_next;
@@ -913,21 +907,12 @@ static void ceph_msg_data_bvecs_advance(struct ceph_msg_data_cursor *cursor,
 					size_t bytes)
 {
 	struct bio_vec *bvecs = cursor->data->bvec_pos.bvecs;
-	struct page *page = bvec_iter_page(bvecs, cursor->bvec_iter);
 
 	BUG_ON(bytes > cursor->resid);
 	BUG_ON(bytes > bvec_iter_len(bvecs, cursor->bvec_iter));
 	cursor->resid -= bytes;
 	bvec_iter_advance(bvecs, &cursor->bvec_iter, bytes);
 
-	if (!cursor->resid) {
-		return;   /* no more data */
-	}
-
-	if (!bytes || (cursor->bvec_iter.bi_bvec_done &&
-		       page == bvec_iter_page(bvecs, cursor->bvec_iter)))
-		return;	/* more bytes to process in this segment */
-
 	BUG_ON(cursor->resid < bvec_iter_len(bvecs, cursor->bvec_iter));
 }
 
-- 
2.24.1


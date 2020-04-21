Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D1C1B2782
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Apr 2020 15:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgDUNTO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Apr 2020 09:19:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:50056 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728846AbgDUNTA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 09:19:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 229D3ADD5;
        Tue, 21 Apr 2020 13:18:57 +0000 (UTC)
From:   Roman Penyaev <rpenyaev@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        Roman Penyaev <rpenyaev@suse.de>
Subject: [PATCH 04/16] libceph: remove ceph_osd_data completely
Date:   Tue, 21 Apr 2020 15:18:38 +0200
Message-Id: <20200421131850.443228-5-rpenyaev@suse.de>
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

Now ceph_msg_data API from messenger should be used.

Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
---
 include/linux/ceph/osd_client.h |  34 ---------
 net/ceph/osd_client.c           | 118 --------------------------------
 2 files changed, 152 deletions(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index b1ec10c8a408..cddbb3e35859 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -50,40 +50,6 @@ struct ceph_osd {
 #define CEPH_OSD_SLAB_OPS	2
 #define CEPH_OSD_MAX_OPS	16
 
-enum ceph_osd_data_type {
-	CEPH_OSD_DATA_TYPE_NONE = 0,
-	CEPH_OSD_DATA_TYPE_PAGES,
-	CEPH_OSD_DATA_TYPE_PAGELIST,
-#ifdef CONFIG_BLOCK
-	CEPH_OSD_DATA_TYPE_BIO,
-#endif /* CONFIG_BLOCK */
-	CEPH_OSD_DATA_TYPE_BVECS,
-};
-
-struct ceph_osd_data {
-	enum ceph_osd_data_type	type;
-	union {
-		struct {
-			struct page	**pages;
-			u64		length;
-			u32		alignment;
-			bool		pages_from_pool;
-			bool		own_pages;
-		};
-		struct ceph_pagelist	*pagelist;
-#ifdef CONFIG_BLOCK
-		struct {
-			struct ceph_bio_iter	bio_pos;
-			u32			bio_length;
-		};
-#endif /* CONFIG_BLOCK */
-		struct {
-			struct ceph_bvec_iter	bvec_pos;
-			u32			num_bvecs;
-		};
-	};
-};
-
 struct ceph_osd_req_op {
 	u16 op;           /* CEPH_OSD_OP_* */
 	u32 flags;        /* CEPH_OSD_OP_FLAG_* */
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 56a4d5f196b3..5725e46d83e8 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -120,61 +120,6 @@ static int calc_layout(struct ceph_file_layout *layout, u64 off, u64 *plen,
 	return 0;
 }
 
-static void ceph_osd_data_init(struct ceph_osd_data *osd_data)
-{
-	memset(osd_data, 0, sizeof (*osd_data));
-	osd_data->type = CEPH_OSD_DATA_TYPE_NONE;
-}
-
-/*
- * Consumes @pages if @own_pages is true.
- */
-__attribute__((unused))
-static void ceph_osd_data_pages_init(struct ceph_osd_data *osd_data,
-			struct page **pages, u64 length, u32 alignment,
-			bool pages_from_pool, bool own_pages)
-{
-	osd_data->type = CEPH_OSD_DATA_TYPE_PAGES;
-	osd_data->pages = pages;
-	osd_data->length = length;
-	osd_data->alignment = alignment;
-	osd_data->pages_from_pool = pages_from_pool;
-	osd_data->own_pages = own_pages;
-}
-
-/*
- * Consumes a ref on @pagelist.
- */
-__attribute__((unused))
-static void ceph_osd_data_pagelist_init(struct ceph_osd_data *osd_data,
-			struct ceph_pagelist *pagelist)
-{
-	osd_data->type = CEPH_OSD_DATA_TYPE_PAGELIST;
-	osd_data->pagelist = pagelist;
-}
-
-#ifdef CONFIG_BLOCK
-__attribute__((unused))
-static void ceph_osd_data_bio_init(struct ceph_osd_data *osd_data,
-				   struct ceph_bio_iter *bio_pos,
-				   u32 bio_length)
-{
-	osd_data->type = CEPH_OSD_DATA_TYPE_BIO;
-	osd_data->bio_pos = *bio_pos;
-	osd_data->bio_length = bio_length;
-}
-#endif /* CONFIG_BLOCK */
-
-__attribute__((unused))
-static void ceph_osd_data_bvecs_init(struct ceph_osd_data *osd_data,
-				     struct ceph_bvec_iter *bvec_pos,
-				     u32 num_bvecs)
-{
-	osd_data->type = CEPH_OSD_DATA_TYPE_BVECS;
-	osd_data->bvec_pos = *bvec_pos;
-	osd_data->num_bvecs = num_bvecs;
-}
-
 static struct ceph_msg_data *
 osd_req_op_raw_data_in(struct ceph_osd_request *osd_req, unsigned int which)
 {
@@ -335,42 +280,6 @@ void osd_req_op_cls_response_data_pages(struct ceph_osd_request *osd_req,
 }
 EXPORT_SYMBOL(osd_req_op_cls_response_data_pages);
 
-static u64 ceph_osd_data_length(struct ceph_osd_data *osd_data)
-{
-	switch (osd_data->type) {
-	case CEPH_OSD_DATA_TYPE_NONE:
-		return 0;
-	case CEPH_OSD_DATA_TYPE_PAGES:
-		return osd_data->length;
-	case CEPH_OSD_DATA_TYPE_PAGELIST:
-		return (u64)osd_data->pagelist->length;
-#ifdef CONFIG_BLOCK
-	case CEPH_OSD_DATA_TYPE_BIO:
-		return (u64)osd_data->bio_length;
-#endif /* CONFIG_BLOCK */
-	case CEPH_OSD_DATA_TYPE_BVECS:
-		return osd_data->bvec_pos.iter.bi_size;
-	default:
-		WARN(true, "unrecognized data type %d\n", (int)osd_data->type);
-		return 0;
-	}
-}
-
-__attribute__((unused))
-static void ceph_osd_data_release(struct ceph_osd_data *osd_data)
-{
-	if (osd_data->type == CEPH_OSD_DATA_TYPE_PAGES && osd_data->own_pages) {
-		int num_pages;
-
-		num_pages = calc_pages_for((u64)osd_data->alignment,
-						(u64)osd_data->length);
-		ceph_release_page_vector(osd_data->pages, num_pages);
-	} else if (osd_data->type == CEPH_OSD_DATA_TYPE_PAGELIST) {
-		ceph_pagelist_release(osd_data->pagelist);
-	}
-	ceph_osd_data_init(osd_data);
-}
-
 static void osd_req_op_data_release(struct ceph_osd_request *osd_req,
 			unsigned int which)
 {
@@ -958,33 +867,6 @@ void osd_req_op_alloc_hint_init(struct ceph_osd_request *osd_req,
 }
 EXPORT_SYMBOL(osd_req_op_alloc_hint_init);
 
-__attribute__((unused))
-static void ceph_osdc_msg_data_add(struct ceph_msg *msg,
-				struct ceph_osd_data *osd_data)
-{
-	u64 length = ceph_osd_data_length(osd_data);
-
-	if (osd_data->type == CEPH_OSD_DATA_TYPE_PAGES) {
-		BUG_ON(length > (u64) SIZE_MAX);
-		if (length)
-			ceph_msg_data_add_pages(msg, osd_data->pages,
-					length, osd_data->alignment,
-					osd_data->pages_from_pool, false);
-	} else if (osd_data->type == CEPH_OSD_DATA_TYPE_PAGELIST) {
-		BUG_ON(!length);
-		ceph_msg_data_add_pagelist(msg, osd_data->pagelist);
-#ifdef CONFIG_BLOCK
-	} else if (osd_data->type == CEPH_OSD_DATA_TYPE_BIO) {
-		ceph_msg_data_add_bio(msg, &osd_data->bio_pos, length);
-#endif
-	} else if (osd_data->type == CEPH_OSD_DATA_TYPE_BVECS) {
-		ceph_msg_data_add_bvecs(msg, &osd_data->bvec_pos,
-					osd_data->num_bvecs);
-	} else {
-		BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_NONE);
-	}
-}
-
 static u32 osd_req_encode_op(struct ceph_osd_op *dst,
 			     const struct ceph_osd_req_op *src)
 {
-- 
2.24.1


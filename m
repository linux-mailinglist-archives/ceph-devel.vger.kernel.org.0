Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254021B2774
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Apr 2020 15:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgDUNTA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Apr 2020 09:19:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:50012 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728680AbgDUNS6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 09:18:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4333BAD2B;
        Tue, 21 Apr 2020 13:18:56 +0000 (UTC)
From:   Roman Penyaev <rpenyaev@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        Roman Penyaev <rpenyaev@suse.de>
Subject: [PATCH 02/16] libceph: extend ceph_msg_data API in order to switch on it
Date:   Tue, 21 Apr 2020 15:18:36 +0200
Message-Id: <20200421131850.443228-3-rpenyaev@suse.de>
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

There is a similar msg data interface for osd_client, which has the
structure named ceph_osd_data.  This is a first patch towards API
unification, i.e. ceph_msg_data API will be used for all the cases.

Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
---
 include/linux/ceph/messenger.h |  34 +++++++-
 net/ceph/messenger.c           | 145 ++++++++++++++++++++++++++++-----
 net/ceph/osd_client.c          |   8 +-
 3 files changed, 158 insertions(+), 29 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 76371aaae2d1..424f9f1989b7 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -173,11 +173,15 @@ struct ceph_msg_data {
 			u32			bio_length;
 		};
 #endif /* CONFIG_BLOCK */
-		struct ceph_bvec_iter	bvec_pos;
+		struct {
+			struct ceph_bvec_iter	bvec_pos;
+			u32			num_bvecs;
+		};
 		struct {
 			struct page	**pages;
 			size_t		length;		/* total # bytes */
 			unsigned int	alignment;	/* first page */
+			bool		pages_from_pool;
 			bool		own_pages;
 		};
 		struct ceph_pagelist	*pagelist;
@@ -357,8 +361,29 @@ extern void ceph_con_keepalive(struct ceph_connection *con);
 extern bool ceph_con_keepalive_expired(struct ceph_connection *con,
 				       unsigned long interval);
 
-void ceph_msg_data_add_pages(struct ceph_msg *msg, struct page **pages,
-			     size_t length, size_t alignment, bool own_pages);
+extern void ceph_msg_data_init(struct ceph_msg_data *data);
+extern void ceph_msg_data_release(struct ceph_msg_data *data);
+extern size_t ceph_msg_data_length(struct ceph_msg_data *data);
+
+extern void ceph_msg_data_pages_init(struct ceph_msg_data *data,
+				     struct page **pages, u64 length,
+				     u32 alignment, bool pages_from_pool,
+				     bool own_pages);
+extern void ceph_msg_data_pagelist_init(struct ceph_msg_data *data,
+					struct ceph_pagelist *pagelist);
+#ifdef CONFIG_BLOCK
+extern void ceph_msg_data_bio_init(struct ceph_msg_data *data,
+				   struct ceph_bio_iter *bio_pos,
+				   u32 bio_length);
+#endif /* CONFIG_BLOCK */
+extern void ceph_msg_data_bvecs_init(struct ceph_msg_data *data,
+				     struct ceph_bvec_iter *bvec_pos,
+				     u32 num_bvecs);
+extern void ceph_msg_data_add(struct ceph_msg *msg, struct ceph_msg_data *data);
+
+extern void ceph_msg_data_add_pages(struct ceph_msg *msg, struct page **pages,
+				    size_t length, size_t alignment,
+				    bool pages_from_pool, bool own_pages);
 extern void ceph_msg_data_add_pagelist(struct ceph_msg *msg,
 				struct ceph_pagelist *pagelist);
 #ifdef CONFIG_BLOCK
@@ -366,7 +391,8 @@ void ceph_msg_data_add_bio(struct ceph_msg *msg, struct ceph_bio_iter *bio_pos,
 			   u32 length);
 #endif /* CONFIG_BLOCK */
 void ceph_msg_data_add_bvecs(struct ceph_msg *msg,
-			     struct ceph_bvec_iter *bvec_pos);
+			     struct ceph_bvec_iter *bvec_pos,
+			     u32 num_bvecs);
 
 struct ceph_msg *ceph_msg_new2(int type, int front_len, int max_data_items,
 			       gfp_t flags, bool can_fail);
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index f8ca5edc5f2c..8f35ed01a576 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -3240,13 +3240,20 @@ bool ceph_con_keepalive_expired(struct ceph_connection *con,
 	return false;
 }
 
-static struct ceph_msg_data *ceph_msg_data_add(struct ceph_msg *msg)
+static struct ceph_msg_data *ceph_msg_data_get_next(struct ceph_msg *msg)
 {
 	BUG_ON(msg->num_data_items >= msg->max_data_items);
 	return &msg->data[msg->num_data_items++];
 }
 
-static void ceph_msg_data_destroy(struct ceph_msg_data *data)
+void ceph_msg_data_init(struct ceph_msg_data *data)
+{
+	memset(data, 0, sizeof(*data));
+	data->type = CEPH_MSG_DATA_NONE;
+}
+EXPORT_SYMBOL(ceph_msg_data_init);
+
+void ceph_msg_data_release(struct ceph_msg_data *data)
 {
 	if (data->type == CEPH_MSG_DATA_PAGES && data->own_pages) {
 		int num_pages = calc_pages_for(data->alignment, data->length);
@@ -3254,23 +3261,120 @@ static void ceph_msg_data_destroy(struct ceph_msg_data *data)
 	} else if (data->type == CEPH_MSG_DATA_PAGELIST) {
 		ceph_pagelist_release(data->pagelist);
 	}
+	ceph_msg_data_init(data);
 }
+EXPORT_SYMBOL(ceph_msg_data_release);
 
-void ceph_msg_data_add_pages(struct ceph_msg *msg, struct page **pages,
-			     size_t length, size_t alignment, bool own_pages)
+/*
+ * Consumes @pages if @own_pages is true.
+ */
+void ceph_msg_data_pages_init(struct ceph_msg_data *data,
+			      struct page **pages, u64 length, u32 alignment,
+			      bool pages_from_pool, bool own_pages)
 {
-	struct ceph_msg_data *data;
-
-	BUG_ON(!pages);
-	BUG_ON(!length);
-
-	data = ceph_msg_data_add(msg);
 	data->type = CEPH_MSG_DATA_PAGES;
 	data->pages = pages;
 	data->length = length;
 	data->alignment = alignment & ~PAGE_MASK;
+	data->pages_from_pool = pages_from_pool;
 	data->own_pages = own_pages;
+}
+EXPORT_SYMBOL(ceph_msg_data_pages_init);
+
+/*
+ * Consumes a ref on @pagelist.
+ */
+void ceph_msg_data_pagelist_init(struct ceph_msg_data *data,
+				 struct ceph_pagelist *pagelist)
+{
+	data->type = CEPH_MSG_DATA_PAGELIST;
+	data->pagelist = pagelist;
+}
+EXPORT_SYMBOL(ceph_msg_data_pagelist_init);
+
+#ifdef CONFIG_BLOCK
+void ceph_msg_data_bio_init(struct ceph_msg_data *data,
+			    struct ceph_bio_iter *bio_pos,
+			    u32 bio_length)
+{
+	data->type = CEPH_MSG_DATA_BIO;
+	data->bio_pos = *bio_pos;
+	data->bio_length = bio_length;
+}
+EXPORT_SYMBOL(ceph_msg_data_bio_init);
+#endif /* CONFIG_BLOCK */
 
+void ceph_msg_data_bvecs_init(struct ceph_msg_data *data,
+			      struct ceph_bvec_iter *bvec_pos,
+			      u32 num_bvecs)
+{
+	data->type = CEPH_MSG_DATA_BVECS;
+	data->bvec_pos = *bvec_pos;
+	data->num_bvecs = num_bvecs;
+}
+EXPORT_SYMBOL(ceph_msg_data_bvecs_init);
+
+size_t ceph_msg_data_length(struct ceph_msg_data *data)
+{
+	switch (data->type) {
+	case CEPH_MSG_DATA_NONE:
+		return 0;
+	case CEPH_MSG_DATA_PAGES:
+		return data->length;
+	case CEPH_MSG_DATA_PAGELIST:
+		return data->pagelist->length;
+#ifdef CONFIG_BLOCK
+	case CEPH_MSG_DATA_BIO:
+		return data->bio_length;
+#endif /* CONFIG_BLOCK */
+	case CEPH_MSG_DATA_BVECS:
+		return data->bvec_pos.iter.bi_size;
+	default:
+		WARN(true, "unrecognized data type %d\n", (int)data->type);
+		return 0;
+	}
+}
+EXPORT_SYMBOL(ceph_msg_data_length);
+
+void ceph_msg_data_add(struct ceph_msg *msg, struct ceph_msg_data *data)
+{
+	u64 length = ceph_msg_data_length(data);
+
+	if (data->type == CEPH_MSG_DATA_PAGES) {
+		BUG_ON(length > (u64)SIZE_MAX);
+		if (likely(length))
+			ceph_msg_data_add_pages(msg, data->pages,
+						length, data->alignment,
+						data->pages_from_pool,
+						false);
+	} else if (data->type == CEPH_MSG_DATA_PAGELIST) {
+		BUG_ON(!length);
+		ceph_msg_data_add_pagelist(msg, data->pagelist);
+#ifdef CONFIG_BLOCK
+	} else if (data->type == CEPH_MSG_DATA_BIO) {
+		ceph_msg_data_add_bio(msg, &data->bio_pos, length);
+#endif
+	} else if (data->type == CEPH_MSG_DATA_BVECS) {
+		ceph_msg_data_add_bvecs(msg, &data->bvec_pos,
+					data->num_bvecs);
+	} else {
+		BUG_ON(data->type != CEPH_MSG_DATA_NONE);
+	}
+}
+EXPORT_SYMBOL(ceph_msg_data_add);
+
+void ceph_msg_data_add_pages(struct ceph_msg *msg, struct page **pages,
+			     size_t length, size_t alignment,
+			     bool pages_from_pool, bool own_pages)
+{
+	struct ceph_msg_data *data;
+
+	BUG_ON(!pages);
+	BUG_ON(!length);
+
+	data = ceph_msg_data_get_next(msg);
+	ceph_msg_data_pages_init(data, pages, length, alignment,
+				 pages_from_pool, own_pages);
 	msg->data_length += length;
 }
 EXPORT_SYMBOL(ceph_msg_data_add_pages);
@@ -3283,10 +3387,9 @@ void ceph_msg_data_add_pagelist(struct ceph_msg *msg,
 	BUG_ON(!pagelist);
 	BUG_ON(!pagelist->length);
 
-	data = ceph_msg_data_add(msg);
-	data->type = CEPH_MSG_DATA_PAGELIST;
+	data = ceph_msg_data_get_next(msg);
+	ceph_msg_data_pagelist_init(data, pagelist);
 	refcount_inc(&pagelist->refcnt);
-	data->pagelist = pagelist;
 
 	msg->data_length += pagelist->length;
 }
@@ -3298,10 +3401,8 @@ void ceph_msg_data_add_bio(struct ceph_msg *msg, struct ceph_bio_iter *bio_pos,
 {
 	struct ceph_msg_data *data;
 
-	data = ceph_msg_data_add(msg);
-	data->type = CEPH_MSG_DATA_BIO;
-	data->bio_pos = *bio_pos;
-	data->bio_length = length;
+	data = ceph_msg_data_get_next(msg);
+	ceph_msg_data_bio_init(data, bio_pos, length);
 
 	msg->data_length += length;
 }
@@ -3309,13 +3410,13 @@ EXPORT_SYMBOL(ceph_msg_data_add_bio);
 #endif	/* CONFIG_BLOCK */
 
 void ceph_msg_data_add_bvecs(struct ceph_msg *msg,
-			     struct ceph_bvec_iter *bvec_pos)
+			     struct ceph_bvec_iter *bvec_pos,
+			     u32 num_bvecs)
 {
 	struct ceph_msg_data *data;
 
-	data = ceph_msg_data_add(msg);
-	data->type = CEPH_MSG_DATA_BVECS;
-	data->bvec_pos = *bvec_pos;
+	data = ceph_msg_data_get_next(msg);
+	ceph_msg_data_bvecs_init(data, bvec_pos, num_bvecs);
 
 	msg->data_length += bvec_pos->iter.bi_size;
 }
@@ -3502,7 +3603,7 @@ static void ceph_msg_release(struct kref *kref)
 	}
 
 	for (i = 0; i < m->num_data_items; i++)
-		ceph_msg_data_destroy(&m->data[i]);
+		ceph_msg_data_release(&m->data[i]);
 
 	if (m->pool)
 		ceph_msgpool_put(m->pool, m);
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 998e26b75a78..efe3d87b75f2 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -962,7 +962,8 @@ static void ceph_osdc_msg_data_add(struct ceph_msg *msg,
 		BUG_ON(length > (u64) SIZE_MAX);
 		if (length)
 			ceph_msg_data_add_pages(msg, osd_data->pages,
-					length, osd_data->alignment, false);
+					length, osd_data->alignment,
+					osd_data->pages_from_pool, false);
 	} else if (osd_data->type == CEPH_OSD_DATA_TYPE_PAGELIST) {
 		BUG_ON(!length);
 		ceph_msg_data_add_pagelist(msg, osd_data->pagelist);
@@ -971,7 +972,8 @@ static void ceph_osdc_msg_data_add(struct ceph_msg *msg,
 		ceph_msg_data_add_bio(msg, &osd_data->bio_pos, length);
 #endif
 	} else if (osd_data->type == CEPH_OSD_DATA_TYPE_BVECS) {
-		ceph_msg_data_add_bvecs(msg, &osd_data->bvec_pos);
+		ceph_msg_data_add_bvecs(msg, &osd_data->bvec_pos,
+					osd_data->num_bvecs);
 	} else {
 		BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_NONE);
 	}
@@ -5443,7 +5445,7 @@ static struct ceph_msg *alloc_msg_with_page_vector(struct ceph_msg_header *hdr)
 			return NULL;
 		}
 
-		ceph_msg_data_add_pages(m, pages, data_len, 0, true);
+		ceph_msg_data_add_pages(m, pages, data_len, 0, false, true);
 	}
 
 	return m;
-- 
2.24.1


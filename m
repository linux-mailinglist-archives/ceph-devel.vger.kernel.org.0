Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B86BDA8D
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Sep 2019 11:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387724AbfIYJJQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Sep 2019 05:09:16 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:21638 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728608AbfIYJJN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 25 Sep 2019 05:09:13 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAD3dl9YLotdHDhSAg--.166S12;
        Wed, 25 Sep 2019 17:07:39 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v4 10/12] rbd: append journal event in image request state machine
Date:   Wed, 25 Sep 2019 09:07:32 +0000
Message-Id: <1569402454-4736-11-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569402454-4736-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1569402454-4736-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowAD3dl9YLotdHDhSAg--.166S12
X-Coremail-Antispam: 1Uf129KBjvJXoW3KrykJr4UGr13Xr13Ww1kuFg_yoWkZr18pw
        4rJFW5CrZ8ur12kw4rWa1kXrW3X3y0kFZrWrWvkr9ak3Wvgrn7KF1UKFW3ZrZrXryxGw18
        Kr4UX348Cw17KrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0Jb_-BiUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiHBw7elpchhMJugAAsh
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Introduce RBD_IMG_APPEND_JOURNAL and __RBD_IMG_APPEND_JOURNAL in rbd_img_state.
When a image request after RBD_IMG_EXCLUSIVE_LOCK, it will go into __RBD_IMG_APPEND_JOURNAL
and then RBD_IMG_APPEND_JOURNAL. after that, it then would go into __RBD_IMG_OBJECT_REQUESTS.

That means, we will append journal event before send the data object request for image request.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 drivers/block/rbd.c | 260 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 259 insertions(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 6987259..79929c7 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -119,6 +119,7 @@ static int atomic_dec_return_safe(atomic_t *v)
 #define RBD_FEATURE_OBJECT_MAP		(1ULL<<3)
 #define RBD_FEATURE_FAST_DIFF		(1ULL<<4)
 #define RBD_FEATURE_DEEP_FLATTEN	(1ULL<<5)
+#define RBD_FEATURE_JOURNALING          (1ULL<<6)
 #define RBD_FEATURE_DATA_POOL		(1ULL<<7)
 #define RBD_FEATURE_OPERATIONS		(1ULL<<8)
 
@@ -325,10 +326,17 @@ enum img_req_flags {
 enum rbd_img_state {
 	RBD_IMG_START = 1,
 	RBD_IMG_EXCLUSIVE_LOCK,
+	__RBD_IMG_APPEND_JOURNAL,
+	RBD_IMG_APPEND_JOURNAL,
 	__RBD_IMG_OBJECT_REQUESTS,
 	RBD_IMG_OBJECT_REQUESTS,
 };
 
+struct journal_commit_info {
+	struct list_head	node;
+	u64		commit_tid;
+};
+
 struct rbd_img_request {
 	struct rbd_device	*rbd_dev;
 	enum obj_operation_type	op_type;
@@ -353,6 +361,7 @@ struct rbd_img_request {
 	int			work_result;
 
 	struct completion	completion;
+	struct list_head	journal_commit_list;
 
 	struct kref		kref;
 };
@@ -1764,6 +1773,7 @@ static struct rbd_img_request *rbd_img_request_create(
 	INIT_LIST_HEAD(&img_request->lock_item);
 	init_completion(&img_request->completion);
 	INIT_LIST_HEAD(&img_request->object_extents);
+	INIT_LIST_HEAD(&img_request->journal_commit_list);
 	mutex_init(&img_request->state_mutex);
 	kref_init(&img_request->kref);
 
@@ -1777,6 +1787,7 @@ static void rbd_img_request_destroy(struct kref *kref)
 	struct rbd_img_request *img_request;
 	struct rbd_obj_request *obj_request;
 	struct rbd_obj_request *next_obj_request;
+	struct journal_commit_info *commit_info, *next_commit_info;
 
 	img_request = container_of(kref, struct rbd_img_request, kref);
 
@@ -1791,6 +1802,12 @@ static void rbd_img_request_destroy(struct kref *kref)
 		rbd_dev_parent_put(img_request->rbd_dev);
 	}
 
+	list_for_each_entry_safe(commit_info, next_commit_info,
+				 &img_request->journal_commit_list, node) {
+		list_del(&commit_info->node);
+		kfree(commit_info);
+	}
+
 	if (rbd_img_is_write(img_request))
 		ceph_put_snap_context(img_request->snapc);
 
@@ -3647,6 +3664,20 @@ static void rbd_img_object_requests(struct rbd_img_request *img_req)
 	}
 }
 
+static bool rbd_img_need_journal(struct rbd_img_request *img_req)
+{
+	struct rbd_device *rbd_dev = img_req->rbd_dev;
+
+	if (img_req->op_type == OBJ_OP_READ)
+		return false;
+
+	if (!(rbd_dev->header.features & RBD_FEATURE_JOURNALING))
+		return false;
+
+	return true;
+}
+
+static void rbd_img_journal_append(struct rbd_img_request *img_req);
 static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
 {
 	struct rbd_device *rbd_dev = img_req->rbd_dev;
@@ -3673,6 +3704,27 @@ static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
 		rbd_assert(!need_exclusive_lock(img_req) ||
 			   __rbd_is_lock_owner(rbd_dev));
 
+		if (!rbd_img_need_journal(img_req)) {
+			img_req->state = RBD_IMG_APPEND_JOURNAL;
+			goto again;
+		}
+
+		rbd_img_journal_append(img_req);
+		if (!img_req->pending.num_pending) {
+			*result = img_req->pending.result;
+			img_req->state = RBD_IMG_OBJECT_REQUESTS;
+			goto again;
+		}
+		img_req->state = __RBD_IMG_APPEND_JOURNAL;
+		return false;
+	case __RBD_IMG_APPEND_JOURNAL:
+		if (!pending_result_dec(&img_req->pending, result))
+			return false;
+		/* fall through */
+	case RBD_IMG_APPEND_JOURNAL:
+		if (*result)
+			return true;
+
 		rbd_img_object_requests(img_req);
 		if (!img_req->pending.num_pending) {
 			*result = img_req->pending.result;
@@ -3741,9 +3793,22 @@ static void rbd_img_handle_request(struct rbd_img_request *img_req, int result)
 	} else {
 		struct request *rq = img_req->rq;
 
+		if (!result) {
+			struct journal_commit_info *commit_info;
+
+			list_for_each_entry(commit_info,
+					    &img_req->journal_commit_list,
+					    node) {
+				ceph_journaler_client_committed(
+					img_req->rbd_dev->journal->journaler,
+					commit_info->commit_tid);
+			}
+		}
+
 		complete_all(&img_req->completion);
 		rbd_img_request_put(img_req);
-		blk_mq_end_request(rq, errno_to_blk_status(result));
+		if (rq)
+			blk_mq_end_request(rq, errno_to_blk_status(result));
 	}
 }
 
@@ -6924,6 +6989,199 @@ static int rbd_dev_header_name(struct rbd_device *rbd_dev)
 	return ret;
 }
 
+enum rbd_journal_event_type {
+	EVENT_TYPE_AIO_DISCARD           = 0,
+	EVENT_TYPE_AIO_WRITE             = 1,
+	EVENT_TYPE_AIO_FLUSH             = 2,
+	EVENT_TYPE_OP_FINISH             = 3,
+	EVENT_TYPE_SNAP_CREATE           = 4,
+	EVENT_TYPE_SNAP_REMOVE           = 5,
+	EVENT_TYPE_SNAP_RENAME           = 6,
+	EVENT_TYPE_SNAP_PROTECT          = 7,
+	EVENT_TYPE_SNAP_UNPROTECT        = 8,
+	EVENT_TYPE_SNAP_ROLLBACK         = 9,
+	EVENT_TYPE_RENAME                = 10,
+	EVENT_TYPE_RESIZE                = 11,
+	EVENT_TYPE_FLATTEN               = 12,
+	EVENT_TYPE_DEMOTE_PROMOTE        = 13,
+	EVENT_TYPE_SNAP_LIMIT            = 14,
+	EVENT_TYPE_UPDATE_FEATURES       = 15,
+	EVENT_TYPE_METADATA_SET          = 16,
+	EVENT_TYPE_METADATA_REMOVE       = 17,
+	EVENT_TYPE_AIO_WRITESAME         = 18,
+	EVENT_TYPE_AIO_COMPARE_AND_WRITE = 19,
+};
+
+
+/*
+ * RBD_EVENT_FIXED_SIZE(10 = CEPH_ENCODING_START_BLK_LEN(6) + EVENT_TYPE(4))
+ */
+#define RBD_EVENT_FIXED_SIZE	10
+
+static void rbd_journal_callback(struct ceph_journaler_ctx *journaler_ctx)
+{
+	struct rbd_img_request *img_req = journaler_ctx->priv;
+	int result = journaler_ctx->result;
+
+	ceph_journaler_ctx_free(journaler_ctx);
+	rbd_img_handle_request(img_req, result);
+}
+
+static void img_journal_append_write_event(struct rbd_img_request *img_req)
+{
+	struct rbd_journal *journal = img_req->rbd_dev->journal;
+	struct journal_commit_info *commit_info;
+	struct ceph_journaler_ctx *journaler_ctx;
+	u64 offset = (u64)blk_rq_pos(img_req->rq) << SECTOR_SHIFT;
+	u64 length = blk_rq_bytes(img_req->rq);
+	/* RBD_EVENT_FIXED_SIZE + offset(8) + length(8) + string_len(4) */
+	u64 prefix_len = RBD_EVENT_FIXED_SIZE + 20;
+	u64 max_append_size = ceph_journaler_get_max_append_size(journal->journaler) - prefix_len;
+	u64 append_size = min(max_append_size, length);
+	u64 bio_offset = 0;
+	void *p;
+	int ret;
+
+	while (length > 0) {
+		journaler_ctx = ceph_journaler_ctx_alloc();
+		if (!journaler_ctx) {
+			img_req->pending.result = -ENOMEM;
+			return;
+		}
+
+		commit_info = kzalloc(sizeof(*commit_info), GFP_NOIO);
+		if (!commit_info) {
+			ceph_journaler_ctx_free(journaler_ctx);
+			img_req->pending.result = -ENOMEM;
+			return;
+		}
+		INIT_LIST_HEAD(&commit_info->node);
+
+		journaler_ctx->bio_iter.bio = img_req->rq->bio;
+		journaler_ctx->bio_iter.iter = img_req->rq->bio->bi_iter;
+		ceph_bio_iter_advance(&journaler_ctx->bio_iter, bio_offset);
+
+		append_size = min(max_append_size, length);
+		journaler_ctx->bio_len = append_size;
+
+		journaler_ctx->prefix_len = prefix_len;
+		journaler_ctx->prefix_offset = PAGE_SIZE - journaler_ctx->prefix_len;
+
+		p = page_address(journaler_ctx->prefix_page) + journaler_ctx->prefix_offset;
+		ceph_start_encoding(&p, 1, 1,
+			journaler_ctx->prefix_len + journaler_ctx->bio_len - CEPH_ENCODING_START_BLK_LEN);
+		ceph_encode_32(&p, EVENT_TYPE_AIO_WRITE);
+		ceph_encode_64(&p, offset);
+		ceph_encode_64(&p, append_size);
+		/* first part of ceph_encode_string(); */
+		ceph_encode_32(&p, journaler_ctx->bio_len);
+
+		offset += append_size;
+		length -= append_size;
+		bio_offset += append_size;
+
+		journaler_ctx->priv = img_req;
+		journaler_ctx->callback = rbd_journal_callback;
+
+		ret = ceph_journaler_append(journal->journaler,
+					    journal->tag_tid, journaler_ctx);
+		if (ret) {
+			kfree(commit_info);
+			ceph_journaler_ctx_free(journaler_ctx);
+			img_req->pending.result = ret;
+			return;
+		}
+		commit_info->commit_tid = journaler_ctx->commit_tid;
+		list_add_tail(&commit_info->node,
+			      &img_req->journal_commit_list);
+		img_req->pending.num_pending++;
+	}
+}
+
+static void img_journal_append_discard_event(struct rbd_img_request *img_req,
+					     bool skip_partial_discard)
+{
+	struct rbd_journal *journal = img_req->rbd_dev->journal;
+	struct journal_commit_info *commit_info;
+	struct ceph_journaler_ctx *journaler_ctx;
+	u64 offset = (u64)blk_rq_pos(img_req->rq) << SECTOR_SHIFT;
+	u64 length = blk_rq_bytes(img_req->rq);
+	struct timespec64 mtime;
+	void *p;
+	int ret;
+
+	journaler_ctx = ceph_journaler_ctx_alloc();
+	if (!journaler_ctx) {
+		img_req->pending.result = -ENOMEM;
+		return;
+	}
+
+	commit_info = kzalloc(sizeof(*commit_info), GFP_NOIO);
+	if (!commit_info) {
+		ceph_journaler_ctx_free(journaler_ctx);
+		img_req->pending.result = -ENOMEM;
+		return;
+	}
+	INIT_LIST_HEAD(&commit_info->node);
+
+	journaler_ctx->bio_iter.bio = img_req->rq->bio;
+	journaler_ctx->bio_iter.iter = img_req->rq->bio->bi_iter;
+	journaler_ctx->bio_len = 0;
+
+	/* RBD_EVENT_FIXED_SIZE + offset(8) + length(8) + bool(1)= 27 */
+	journaler_ctx->prefix_len = RBD_EVENT_FIXED_SIZE + 17;
+	journaler_ctx->prefix_offset = PAGE_SIZE - journaler_ctx->prefix_len;
+
+	p = page_address(journaler_ctx->prefix_page) + journaler_ctx->prefix_offset;
+	ceph_start_encoding(&p, 4, 1, journaler_ctx->prefix_len - CEPH_ENCODING_START_BLK_LEN);
+	ceph_encode_32(&p, EVENT_TYPE_AIO_DISCARD);
+	ceph_encode_64(&p, offset);
+	ceph_encode_64(&p, length);
+	ceph_encode_8(&p, skip_partial_discard);
+
+	/* encode metadata */
+	journaler_ctx->suffix_len = CEPH_ENCODING_START_BLK_LEN + sizeof(struct ceph_timespec);
+	p = page_address(journaler_ctx->suffix_page);
+	ceph_start_encoding(&p, 1, 1, journaler_ctx->suffix_len - CEPH_ENCODING_START_BLK_LEN);
+	ktime_get_real_ts64(&mtime);
+	ceph_encode_timespec64(p, &mtime);
+
+	journaler_ctx->priv = img_req;
+	journaler_ctx->callback = rbd_journal_callback;
+
+	ret = ceph_journaler_append(journal->journaler, journal->tag_tid,
+				    journaler_ctx);
+	if (ret) {
+		kfree(commit_info);
+		ceph_journaler_ctx_free(journaler_ctx);
+		img_req->pending.result = ret;
+		return;
+	}
+
+	commit_info->commit_tid = journaler_ctx->commit_tid;
+	list_add_tail(&commit_info->node, &img_req->journal_commit_list);
+	img_req->pending.num_pending++;
+}
+
+static void rbd_img_journal_append(struct rbd_img_request *img_req)
+{
+	rbd_assert(!img_req->pending.result && !img_req->pending.num_pending);
+
+	switch (img_req->op_type) {
+	case OBJ_OP_WRITE:
+		img_journal_append_write_event(img_req);
+		break;
+	case OBJ_OP_ZEROOUT:
+		img_journal_append_discard_event(img_req, false);
+		break;
+	case OBJ_OP_DISCARD:
+		img_journal_append_discard_event(img_req, true);
+		break;
+	default:
+		img_req->pending.result = -ENOTSUPP;
+	}
+}
+
 struct rbd_journal_tag_predecessor {
 	bool commit_valid;
 	u64 tag_tid;
-- 
1.8.3.1



Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFA5788BB
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2019 11:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbfG2Jnt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Jul 2019 05:43:49 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22727 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbfG2Jnt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Jul 2019 05:43:49 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowADHYpWjvz5djxunAA--.901S10;
        Mon, 29 Jul 2019 17:43:02 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v3 08/15] libceph: journaling: introduce api for journal appending
Date:   Mon, 29 Jul 2019 09:42:50 +0000
Message-Id: <1564393377-28949-9-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowADHYpWjvz5djxunAA--.901S10
X-Coremail-Antispam: 1Uf129KBjvAXoWftFW8KryrWw45uw1furyfWFg_yoW5WrW3to
        WxWa1UuFn5WFy2vF97KrykJa4rX348WayrArWYgF4a9anrAry8Z3y7Gr15Ary5Aw4UCrZF
        qw1xJwn3WF4DJ3W5n29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjfUp-z3UUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiUgYBelf4pVbJ-QAAsH
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This commit introduce 3 APIs for journal recording:

(1) ceph_journaler_allocate_tag()
    This api allocate a new tag for user to get a unified
tag_tid. Then each event appended by this user will be tagged
by this tag_tid.

(2) ceph_journaler_append()
    This api allow user to append event to journal objects.

(3) ceph_journaler_client_committed()
    This api will notify journaling that a event is already
committed, you can remove it from journal if there is no other
client refre to it.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 include/linux/ceph/journaler.h |   2 +-
 net/ceph/journaler.c           | 834 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 835 insertions(+), 1 deletion(-)

diff --git a/include/linux/ceph/journaler.h b/include/linux/ceph/journaler.h
index e3b82af..f04fb3f 100644
--- a/include/linux/ceph/journaler.h
+++ b/include/linux/ceph/journaler.h
@@ -173,7 +173,7 @@ static inline uint64_t ceph_journaler_get_max_append_size(struct ceph_journaler
 struct ceph_journaler_ctx *ceph_journaler_ctx_alloc(void);
 void ceph_journaler_ctx_put(struct ceph_journaler_ctx *journaler_ctx);
 int ceph_journaler_append(struct ceph_journaler *journaler,
-			  uint64_t tag_tid, uint64_t *commit_tid,
+			  uint64_t tag_tid,
 			  struct ceph_journaler_ctx *ctx);
 void ceph_journaler_client_committed(struct ceph_journaler *journaler,
 				     uint64_t commit_tid);
diff --git a/net/ceph/journaler.c b/net/ceph/journaler.c
index 3e92e96..26a5b97 100644
--- a/net/ceph/journaler.c
+++ b/net/ceph/journaler.c
@@ -29,6 +29,42 @@ static char *object_oid_prefix(int pool_id, const char *journal_id)
 	return prefix;
 }
 
+static void journaler_flush(struct work_struct *work);
+static void journaler_client_commit(struct work_struct *work);
+static void journaler_notify_update(struct work_struct *work);
+static void journaler_overflow(struct work_struct *work);
+static void journaler_append_finish(struct work_struct *work);
+
+/*
+ * Append got through the following state machine:
+ *
+ *                    JOURNALER_APPEND_START 
+ *                              |              
+ *                              v              
+ *            ..>. . . JOURNALER_APPEND_SEND  . . . . 
+ *            .                 |                    .
+ * JOURNALER_APPEND_OVERFLOW    |                    .
+ *                              |                    . 
+ *            ^                 v                    v 
+ *            .. . . . JOURNALER_APPEND_FLUSH . . >. .
+ *                              |                    . 
+ *                              v                 (error) 
+ *                     JOURNALER_APPEND_SAFE         v
+ *                              |                    .
+ *                              v                    . 
+ *                     JOURNALER_APPEND_FINISH . < . .
+ *
+ * Append starts in JOURNALER_APPEND_START and ends in JOURNALER_APPEND_FINISH
+ */
+enum journaler_append_state {
+	JOURNALER_APPEND_START = 1,
+	JOURNALER_APPEND_SEND,
+	JOURNALER_APPEND_FLUSH,
+	JOURNALER_APPEND_OVERFLOW,
+	JOURNALER_APPEND_SAFE,
+	JOURNALER_APPEND_FINISH,
+};
+
 /*
  * journaler_append_ctx is an internal structure to represent an append op.
  */
@@ -44,6 +80,7 @@ struct journaler_append_ctx {
 	struct ceph_journaler_entry entry;
 	struct ceph_journaler_ctx journaler_ctx;
 
+	enum journaler_append_state state;
 	struct kref	kref;
 };
 
@@ -151,6 +188,12 @@ struct ceph_journaler *ceph_journaler_create(struct ceph_osd_client *osdc,
 	if (!journaler->notify_wq)
 		goto err_destroy_task_wq;
 
+	INIT_WORK(&journaler->flush_work, journaler_flush);
+	INIT_WORK(&journaler->finish_work, journaler_append_finish);
+	INIT_DELAYED_WORK(&journaler->commit_work, journaler_client_commit);
+	INIT_WORK(&journaler->notify_update_work, journaler_notify_update);
+	INIT_WORK(&journaler->overflow_work, journaler_overflow);
+
 	journaler->fetch_buf = NULL;
 	journaler->handle_entry = NULL;
 	journaler->entry_handler = NULL;
@@ -1287,3 +1330,794 @@ int ceph_journaler_start_replay(struct ceph_journaler *journaler)
 	return ret;
 }
 EXPORT_SYMBOL(ceph_journaler_start_replay);
+
+// recording
+static int get_new_entry_tid(struct ceph_journaler *journaler,
+			      uint64_t tag_tid, uint64_t *entry_tid)
+{
+	struct entry_tid *pos;
+
+	spin_lock(&journaler->entry_tid_lock);
+	list_for_each_entry(pos, &journaler->entry_tids, node) {
+		if (pos->tag_tid == tag_tid) {
+			*entry_tid = pos->entry_tid++;
+			spin_unlock(&journaler->entry_tid_lock);
+			return 0;
+		}
+	}
+
+	pos = entry_tid_alloc(journaler, tag_tid);
+	if (!pos) {
+		spin_unlock(&journaler->entry_tid_lock);
+		pr_err("failed to allocate new entry.");
+		return -ENOMEM;
+	}
+
+	*entry_tid = pos->entry_tid++;
+	spin_unlock(&journaler->entry_tid_lock);
+
+	return 0;
+}
+
+static uint64_t get_object(struct ceph_journaler *journaler, uint64_t splay_offset)
+{
+	return splay_offset + (journaler->splay_width * journaler->active_set);
+}
+
+static void future_init(struct ceph_journaler_future *future,
+			uint64_t tag_tid,
+						   uint64_t entry_tid,
+						   uint64_t commit_tid,
+			struct ceph_journaler_ctx *journaler_ctx)
+{
+	future->tag_tid = tag_tid;
+	future->entry_tid = entry_tid;
+	future->commit_tid = commit_tid;
+
+	spin_lock_init(&future->lock);
+	future->safe = false;
+	future->consistent = false;
+
+	future->ctx = journaler_ctx;
+	future->wait = NULL;
+}
+
+static void set_prev_future(struct ceph_journaler *journaler,
+			    struct journaler_append_ctx *append_ctx)
+{
+	struct ceph_journaler_future *future = &append_ctx->future;
+	bool prev_future_finished = false;
+
+	if (journaler->prev_future == NULL) {
+		prev_future_finished = true;
+	} else {
+		spin_lock(&journaler->prev_future->lock);
+		prev_future_finished = (journaler->prev_future->consistent &&
+					journaler->prev_future->safe);
+		journaler->prev_future->wait = append_ctx;
+		spin_unlock(&journaler->prev_future->lock);
+	}
+
+	spin_lock(&future->lock);
+	if (prev_future_finished) {
+		future->consistent = true;
+	}
+	spin_unlock(&future->lock);
+
+	journaler->prev_future = future;
+}
+
+static void entry_init(struct ceph_journaler_entry *entry,
+			uint64_t tag_tid,
+			uint64_t entry_tid,
+			struct ceph_journaler_ctx *journaler_ctx)
+{
+	entry->tag_tid = tag_tid;
+	entry->entry_tid = entry_tid;
+	entry->data_len = journaler_ctx->bio_len +
+			  journaler_ctx->prefix_len + journaler_ctx->suffix_len;
+}
+
+static void journaler_entry_encode_prefix(struct ceph_journaler_entry *entry,
+					  void **p, void *end)
+{
+	ceph_encode_64(p, PREAMBLE);
+	ceph_encode_8(p, (uint8_t)1);
+	ceph_encode_64(p, entry->entry_tid);
+	ceph_encode_64(p, entry->tag_tid);
+
+	ceph_encode_32(p, entry->data_len);
+}
+
+static uint32_t crc_bio(uint32_t crc, struct bio *bio, u64 length)
+{
+	struct bio_vec bv;
+	struct bvec_iter iter;
+	char *buf;
+	u64 offset = 0;
+	u64 len = length;
+
+next:
+	bio_for_each_segment(bv, bio, iter) {
+		buf = page_address(bv.bv_page) + bv.bv_offset;
+		len = min_t(u64, length, bv.bv_len);
+		crc = crc32c(crc, buf, len);
+		offset += len;
+		length -= len;
+
+		if (length == 0)
+			goto out;
+	}
+
+	if (length && bio->bi_next) {
+		bio = bio->bi_next;
+		goto next;
+	}
+
+	WARN_ON(length != 0);
+out:
+	return crc;
+}
+
+static void journaler_append_finish(struct work_struct *work)
+{
+	struct ceph_journaler *journaler = container_of(work, struct ceph_journaler,
+						        finish_work);
+	struct journaler_append_ctx *ctx_pos, *next;
+	LIST_HEAD(tmp_list);
+
+	spin_lock(&journaler->finish_lock);
+	list_splice_init(&journaler->finish_list, &tmp_list);
+	spin_unlock(&journaler->finish_lock);
+
+	list_for_each_entry_safe(ctx_pos, next, &tmp_list, node) {
+		list_del(&ctx_pos->node);
+		ctx_pos->journaler_ctx.callback(&ctx_pos->journaler_ctx);
+	}
+}
+
+static void journaler_handle_append(struct journaler_append_ctx *ctx, int ret);
+static void future_consistent(struct journaler_append_ctx *append_ctx,
+			      int result) {
+	struct ceph_journaler_future *future = &append_ctx->future;
+	bool future_finished = false;
+
+	spin_lock(&future->lock);
+	future->consistent = true;
+	future_finished = (future->safe && future->consistent);
+	spin_unlock(&future->lock);
+
+	if (future_finished) {
+		append_ctx->state = JOURNALER_APPEND_FINISH;
+		journaler_handle_append(append_ctx, result);
+	}
+}
+
+static void future_finish(struct journaler_append_ctx *append_ctx,
+			  int result) {
+	struct ceph_journaler *journaler = append_ctx->journaler;
+	struct ceph_journaler_ctx *journaler_ctx = &append_ctx->journaler_ctx;
+	struct ceph_journaler_future *future = &append_ctx->future;
+	struct journaler_append_ctx *wait = future->wait;
+
+	mutex_lock(&journaler->meta_lock);
+	if (journaler->prev_future == future)
+		journaler->prev_future = NULL;
+	mutex_unlock(&journaler->meta_lock);
+
+	spin_lock(&journaler->finish_lock);
+	if (journaler_ctx->result == 0)
+		journaler_ctx->result = result;
+	list_add_tail(&append_ctx->node, &journaler->finish_list);
+	spin_unlock(&journaler->finish_lock);
+
+	queue_work(journaler->task_wq, &journaler->finish_work);
+	if (wait)
+		future_consistent(wait, result);
+}
+
+static void journaler_notify_update(struct work_struct *work)
+{
+	struct ceph_journaler *journaler = container_of(work,
+							struct ceph_journaler,
+						        notify_update_work);
+	int ret = 0;
+
+	ret = ceph_osdc_notify(journaler->osdc, &journaler->header_oid,
+				&journaler->header_oloc, NULL, 0,
+				5000, NULL, NULL);
+	if (ret)
+		pr_err("notify_update failed: %d", ret);
+}
+
+// advance the active_set to (active_set + 1). This function
+// will call ceph_cls_journaler_set_active_set to update journal
+// metadata and notify all clients about this event. We don't
+// update journaler->active_set in memory currently.
+//
+// The journaler->active_set will be updated in refresh() when
+// we get the notification.
+static void advance_object_set(struct ceph_journaler *journaler)
+{
+	struct object_recorder *obj_recorder;
+	uint64_t active_set;
+	int i, ret;
+
+	mutex_lock(&journaler->meta_lock);
+	if (journaler->advancing || journaler->flushing) {
+		mutex_unlock(&journaler->meta_lock);
+		return;
+	}
+
+	// make sure all inflight appending finish
+	for (i = 0; i < journaler->splay_width; i++) {
+		obj_recorder = &journaler->obj_recorders[i];
+		spin_lock(&obj_recorder->lock);
+		if (obj_recorder->inflight_append) {
+			spin_unlock(&obj_recorder->lock);
+			mutex_unlock(&journaler->meta_lock);
+			return;
+		}
+		spin_unlock(&obj_recorder->lock);
+	}
+
+	journaler->advancing = true;
+
+	active_set = journaler->active_set + 1;
+	mutex_unlock(&journaler->meta_lock);
+
+	ret = ceph_cls_journaler_set_active_set(journaler->osdc,
+			&journaler->header_oid, &journaler->header_oloc,
+			active_set);
+	if (ret) {
+		pr_err("error in set active_set: %d", ret);
+	}
+
+	queue_work(journaler->task_wq, &journaler->notify_update_work);
+}
+
+static void journaler_overflow(struct work_struct *work)
+{
+	struct ceph_journaler *journaler = container_of(work,
+						        struct ceph_journaler,
+						        overflow_work);
+	advance_object_set(journaler);
+}
+
+static void journaler_append_callback(struct ceph_osd_request *osd_req)
+{
+	struct journaler_append_ctx *ctx = osd_req->r_priv;
+	int ret = osd_req->r_result;
+
+	if (ret)
+		pr_debug("ret of journaler_append_callback: %d", ret);
+
+	__free_page(ctx->req_page);
+	ceph_osdc_put_request(osd_req);
+
+	journaler_handle_append(ctx, ret);
+}
+
+static int append(struct ceph_journaler *journaler,
+		  struct ceph_object_id *oid,
+		  struct ceph_object_locator *oloc,
+		  struct journaler_append_ctx *ctx)
+
+{
+	struct ceph_osd_client *osdc = journaler->osdc;
+	struct ceph_osd_request *req;
+	void *p;
+	int ret;
+
+	req = ceph_osdc_alloc_request(osdc, NULL, 2, false, GFP_NOIO);
+	if (!req)
+		return -ENOMEM;
+
+	ceph_oid_copy(&req->r_base_oid, oid);
+	ceph_oloc_copy(&req->r_base_oloc, oloc);
+	req->r_flags = CEPH_OSD_FLAG_WRITE;
+	req->r_callback = journaler_append_callback;
+	req->r_priv = ctx;
+
+	// guard_append
+	ctx->req_page = alloc_page(GFP_NOIO);
+	if (!ctx->req_page) {
+		ret = -ENOMEM;
+		goto out_req;
+	}
+	p = page_address(ctx->req_page);
+	ceph_encode_64(&p, 1 << journaler->order);
+	ret = osd_req_op_cls_init(req, 0, "journal", "guard_append");
+	if (ret)
+		goto out_free_page;
+	osd_req_op_cls_request_data_pages(req, 0, &ctx->req_page, 8, 0, false, false);
+
+	// append_data
+	osd_req_op_extent_init(req, 1, CEPH_OSD_OP_APPEND, 0,
+		ctx->journaler_ctx.prefix_len + ctx->journaler_ctx.bio_len + ctx->journaler_ctx.suffix_len, 0, 0);
+
+	if (ctx->journaler_ctx.prefix_len)
+		osd_req_op_extent_prefix_pages(req, 1, &ctx->journaler_ctx.prefix_page,
+					       ctx->journaler_ctx.prefix_len,
+					       ctx->journaler_ctx.prefix_offset,
+					       false, false);
+
+	if (ctx->journaler_ctx.bio_len)
+		osd_req_op_extent_osd_data_bio(req, 1, &ctx->journaler_ctx.bio_iter, ctx->journaler_ctx.bio_len);
+
+	if (ctx->journaler_ctx.suffix_len)
+		osd_req_op_extent_suffix_pages(req, 1, &ctx->journaler_ctx.suffix_page,
+					       ctx->journaler_ctx.suffix_len,
+					       ctx->journaler_ctx.suffix_offset,
+					       false, false);
+	ret = ceph_osdc_alloc_messages(req, GFP_NOIO);
+	if (ret)
+		goto out_free_page;
+
+	ceph_osdc_start_request(osdc, req, false);
+	return 0;
+
+out_free_page:
+	__free_page(ctx->req_page);
+out_req:
+	ceph_osdc_put_request(req);
+	return ret;
+}
+
+static int send_append_request(struct ceph_journaler *journaler,
+			       uint64_t object_num,
+			       struct journaler_append_ctx *ctx)
+{
+	struct ceph_object_id object_oid;
+	int ret = 0;
+
+	ceph_oid_init(&object_oid);
+	ret = ceph_oid_aprintf(&object_oid, GFP_NOIO, "%s%llu",
+				journaler->object_oid_prefix, object_num);
+	if (ret) {
+		pr_err("failed to initialize object id: %d", ret);
+		goto out;
+	}
+
+	ret = append(journaler, &object_oid, &journaler->data_oloc, ctx);
+out:
+	ceph_oid_destroy(&object_oid);
+	return ret;
+}
+
+static void journaler_flush(struct work_struct *work)
+{
+	struct ceph_journaler *journaler = container_of(work,
+							struct ceph_journaler,
+							flush_work);
+	int i = 0;
+	struct object_recorder *obj_recorder;
+	struct journaler_append_ctx *ctx, *next_ctx;
+	LIST_HEAD(tmp);
+
+	mutex_lock(&journaler->meta_lock);
+	if (journaler->overflowed) {
+		mutex_unlock(&journaler->meta_lock);
+		return;
+	}
+
+	journaler->flushing = true;
+	mutex_unlock(&journaler->meta_lock);
+
+	for (i = 0; i < journaler->splay_width; i++) {
+		INIT_LIST_HEAD(&tmp);
+		obj_recorder = &journaler->obj_recorders[i];
+
+		spin_lock(&obj_recorder->lock);
+		list_splice_tail_init(&obj_recorder->overflow_list, &tmp);
+		list_splice_tail_init(&obj_recorder->append_list, &tmp);
+		spin_unlock(&obj_recorder->lock);
+
+		list_for_each_entry_safe(ctx, next_ctx, &tmp, node) {
+			list_del(&ctx->node);
+			ctx->object_num = get_object(journaler, obj_recorder->splay_offset);
+			journaler_handle_append(ctx, 0);
+		}
+	}
+
+	mutex_lock(&journaler->meta_lock);
+	journaler->flushing = false;
+	// As we don't do advance in flushing, so queue another overflow_work
+	// after flushing finished if we journaler is overflowed.
+	if (journaler->overflowed)
+		queue_work(journaler->task_wq, &journaler->overflow_work);
+	mutex_unlock(&journaler->meta_lock);
+}
+
+static void ceph_journaler_object_append(struct ceph_journaler *journaler,
+					 struct journaler_append_ctx *append_ctx)
+{
+	void *buf, *end;
+	uint32_t crc = 0;
+	struct ceph_journaler_ctx *journaler_ctx = &append_ctx->journaler_ctx;
+	struct ceph_bio_iter *bio_iter = &journaler_ctx->bio_iter;
+	struct object_recorder *obj_recorder;
+
+	// PEAMBLE(8) + version(1) + entry_tid(8) + tag_tid(8) + string_len(4) = 29
+	journaler_ctx->prefix_offset -= 29;
+	journaler_ctx->prefix_len += 29;
+	buf = page_address(journaler_ctx->prefix_page) + journaler_ctx->prefix_offset;
+	end = buf + 29;
+	journaler_entry_encode_prefix(&append_ctx->entry, &buf, end);
+
+	// size of crc is 4
+	journaler_ctx->suffix_offset += 0;
+	journaler_ctx->suffix_len += 4;
+	buf = page_address(journaler_ctx->suffix_page);
+	end = buf + 4;
+	crc = crc32c(crc, page_address(journaler_ctx->prefix_page) + journaler_ctx->prefix_offset,
+		     journaler_ctx->prefix_len);
+	if (journaler_ctx->bio_len)
+		crc = crc_bio(crc, bio_iter->bio, journaler_ctx->bio_len);
+	ceph_encode_32(&buf, crc);
+	obj_recorder = &journaler->obj_recorders[append_ctx->splay_offset];
+
+	spin_lock(&obj_recorder->lock);
+	list_add_tail(&append_ctx->node, &obj_recorder->append_list);
+	queue_work(journaler->task_wq, &journaler->flush_work);
+	spin_unlock(&obj_recorder->lock);
+}
+
+static void journaler_handle_append(struct journaler_append_ctx *ctx, int ret)
+{
+	struct ceph_journaler *journaler = ctx->journaler;
+	struct object_recorder *obj_recorder = &journaler->obj_recorders[ctx->splay_offset];
+
+again:
+	switch (ctx->state) {
+	case JOURNALER_APPEND_START:
+		ctx->state = JOURNALER_APPEND_SEND;
+		ceph_journaler_object_append(journaler, ctx);
+		break;
+	case JOURNALER_APPEND_SEND:
+		ctx->state = JOURNALER_APPEND_FLUSH;
+		spin_lock(&obj_recorder->lock);
+		obj_recorder->inflight_append++;
+		spin_unlock(&obj_recorder->lock);
+		ret = send_append_request(journaler, ctx->object_num, ctx);
+		if (ret) {
+			pr_err("failed to send append request: %d", ret);
+			ctx->state = JOURNALER_APPEND_FINISH;
+			goto again;
+		}
+		break;
+	case JOURNALER_APPEND_FLUSH:
+		if (ret == -EOVERFLOW) {
+			mutex_lock(&journaler->meta_lock);
+			journaler->overflowed = true;
+			mutex_unlock(&journaler->meta_lock);
+
+			spin_lock(&obj_recorder->lock);
+			ctx->state = JOURNALER_APPEND_OVERFLOW;
+			list_add_tail(&ctx->node, &obj_recorder->overflow_list);
+			if (--obj_recorder->inflight_append == 0)
+				queue_work(journaler->task_wq, &journaler->overflow_work);
+			spin_unlock(&obj_recorder->lock);
+			break;
+		}
+
+		spin_lock(&obj_recorder->lock);
+		if (--obj_recorder->inflight_append == 0) {
+			mutex_lock(&journaler->meta_lock);
+			if (journaler->overflowed)
+				queue_work(journaler->task_wq, &journaler->overflow_work);
+			mutex_unlock(&journaler->meta_lock);
+		}
+		spin_unlock(&obj_recorder->lock);
+
+		ret = add_commit_entry(journaler, ctx->future.commit_tid, ctx->object_num,
+				       ctx->future.tag_tid, ctx->future.entry_tid);
+		if (ret) {
+			pr_err("failed to add_commit_entry: %d", ret);
+			ctx->state = JOURNALER_APPEND_FINISH;
+			ret = -ENOMEM;
+			goto again;
+		}
+
+		ctx->state = JOURNALER_APPEND_SAFE;
+		goto again;
+	case JOURNALER_APPEND_OVERFLOW:
+		ctx->state = JOURNALER_APPEND_SEND;
+		goto again;
+	case JOURNALER_APPEND_SAFE:
+		spin_lock(&ctx->future.lock);
+		ctx->future.safe = true;
+		if (ctx->future.consistent) {
+			spin_unlock(&ctx->future.lock);
+			ctx->state = JOURNALER_APPEND_FINISH;
+			goto again;
+		}
+		spin_unlock(&ctx->future.lock);
+		break;
+	case JOURNALER_APPEND_FINISH:
+		future_finish(ctx, ret);
+		break;
+	default:
+		BUG();
+	}
+}
+
+// journaler_append_ctx alloc and release
+struct journaler_append_ctx *journaler_append_ctx_alloc(void)
+{
+	struct journaler_append_ctx *append_ctx;
+	struct ceph_journaler_ctx *journaler_ctx;
+
+	append_ctx = kmem_cache_zalloc(journaler_append_ctx_cache, GFP_NOIO);
+	if (!append_ctx)
+		return NULL;
+
+	journaler_ctx = &append_ctx->journaler_ctx;
+	journaler_ctx->prefix_page = alloc_page(GFP_NOIO);
+	if (!journaler_ctx->prefix_page)
+		goto free_journaler_ctx;
+
+	journaler_ctx->suffix_page = alloc_page(GFP_NOIO);
+	if (!journaler_ctx->suffix_page)
+		goto free_prefix_page;
+
+	memset(page_address(journaler_ctx->prefix_page), 0, PAGE_SIZE);
+	memset(page_address(journaler_ctx->suffix_page), 0, PAGE_SIZE);
+	INIT_LIST_HEAD(&journaler_ctx->node);
+
+	kref_init(&append_ctx->kref);
+	INIT_LIST_HEAD(&append_ctx->node);
+	return append_ctx;
+
+free_prefix_page:
+	__free_page(journaler_ctx->prefix_page);
+free_journaler_ctx:
+	kmem_cache_free(journaler_append_ctx_cache, append_ctx);
+	return NULL;
+}
+
+struct ceph_journaler_ctx *ceph_journaler_ctx_alloc(void)
+{
+	struct journaler_append_ctx *append_ctx;
+
+	append_ctx = journaler_append_ctx_alloc();
+	if (!append_ctx)
+		return NULL;
+
+	return &append_ctx->journaler_ctx;
+}
+EXPORT_SYMBOL(ceph_journaler_ctx_alloc);
+
+static void journaler_append_ctx_release(struct kref *kref)
+{
+	struct journaler_append_ctx *append_ctx;
+	struct ceph_journaler_ctx *journaler_ctx;
+
+	append_ctx = container_of(kref, struct journaler_append_ctx, kref);
+	journaler_ctx = &append_ctx->journaler_ctx;
+
+	__free_page(journaler_ctx->prefix_page);
+	__free_page(journaler_ctx->suffix_page);
+	kmem_cache_free(journaler_append_ctx_cache, append_ctx);
+}
+
+static void journaler_append_ctx_put(struct journaler_append_ctx *append_ctx)
+{
+	if (append_ctx) {
+		kref_put(&append_ctx->kref, journaler_append_ctx_release);
+	}
+}
+
+void ceph_journaler_ctx_put(struct ceph_journaler_ctx *journaler_ctx)
+{
+	struct journaler_append_ctx *append_ctx;
+
+	if (journaler_ctx) {
+		append_ctx = container_of(journaler_ctx,
+					  struct journaler_append_ctx,
+					  journaler_ctx);
+		journaler_append_ctx_put(append_ctx);
+	}
+}
+EXPORT_SYMBOL(ceph_journaler_ctx_put);
+
+int ceph_journaler_append(struct ceph_journaler *journaler,
+			  uint64_t tag_tid,
+			  struct ceph_journaler_ctx *journaler_ctx)
+{
+	uint64_t entry_tid;
+	struct object_recorder *obj_recorder;
+	struct journaler_append_ctx *append_ctx;
+	int ret;
+
+	append_ctx = container_of(journaler_ctx,
+				  struct journaler_append_ctx,
+				  journaler_ctx);
+
+	append_ctx->journaler = journaler;
+	mutex_lock(&journaler->meta_lock);
+	// get entry_tid for this event. (tag_tid, entry_tid) is
+	// the uniq id for every journal event.
+	ret = get_new_entry_tid(journaler, tag_tid, &entry_tid);
+	if (ret) {
+		mutex_unlock(&journaler->meta_lock);
+		return ret;
+	}
+
+	// calculate the object_num for this entry.
+	append_ctx->splay_offset = entry_tid % journaler->splay_width;
+	obj_recorder = &journaler->obj_recorders[journaler->splay_width];
+	append_ctx->object_num = get_object(journaler, append_ctx->splay_offset);
+
+	// allocate a commit_tid for this event, when the data is committed
+	// to data objects, ceph_journaler_client_committed() will accept
+	// the commit_tid to understand how to update journal commit position.
+	journaler_ctx->commit_tid = __allocate_commit_tid(journaler);
+	entry_init(&append_ctx->entry, tag_tid, entry_tid, journaler_ctx);
+
+	// To make sure the journal entry is consistent, we use future
+	// to track it. And every journal entry depent on the previous
+	// entry. Only if the previous entry is finished, current entry
+	// could be consistent. and then we can finish current entry. 
+	future_init(&append_ctx->future, tag_tid, entry_tid,
+		    journaler_ctx->commit_tid, journaler_ctx);
+	set_prev_future(journaler, append_ctx);
+	mutex_unlock(&journaler->meta_lock);
+
+	append_ctx->state = JOURNALER_APPEND_START;
+	journaler_handle_append(append_ctx, 0);
+	return 0;
+}
+EXPORT_SYMBOL(ceph_journaler_append);
+
+static void journaler_client_commit(struct work_struct *work)
+{
+	struct ceph_journaler *journaler = container_of(to_delayed_work(work),
+							struct ceph_journaler,
+							commit_work);
+	int ret;
+
+	mutex_lock(&journaler->commit_lock);
+	copy_pos_list(&journaler->obj_pos_pending,
+		      &journaler->obj_pos_committing);
+	mutex_unlock(&journaler->commit_lock);
+
+	ret = ceph_cls_journaler_client_committed(journaler->osdc,
+		&journaler->header_oid, &journaler->header_oloc,
+		journaler->client, &journaler->obj_pos_committing);
+
+	if (ret) {
+		pr_err("error in client committed: %d", ret);
+	}
+
+	queue_work(journaler->task_wq, &journaler->notify_update_work);
+
+	mutex_lock(&journaler->commit_lock);
+	journaler->commit_scheduled = false;
+	mutex_unlock(&journaler->commit_lock);
+}
+
+// hold journaler->commit_lock
+static void add_object_position(struct commit_entry *entry,
+			       struct list_head *object_positions,
+			       uint64_t splay_width)
+{
+	struct ceph_journaler_object_pos *position;
+	uint8_t splay_offset = entry->object_num % splay_width;
+	bool found = false;
+	
+	list_for_each_entry(position, object_positions, node) {
+		if (position->in_using == false) {
+			found = true;
+			break;
+		}
+
+		if (splay_offset == position->object_num % splay_width) {
+			found = true;
+			break;
+		}
+	}
+
+	BUG_ON(!found);
+	if (position->in_using == false)
+		position->in_using = true;
+	position->object_num = entry->object_num;
+	position->tag_tid = entry->tag_tid;
+	position->entry_tid = entry->entry_tid;
+	list_move(&position->node, object_positions);
+}
+
+void ceph_journaler_client_committed(struct ceph_journaler *journaler, uint64_t commit_tid)
+{
+	struct commit_entry *commit_entry;
+	bool update_client_commit = true;
+	struct rb_node *n;
+
+	mutex_lock(&journaler->commit_lock);
+	// search commit entries in commit_tid order.
+	for (n = rb_first(&journaler->commit_entries); n; n = rb_next(n)) {
+		commit_entry = rb_entry(n, struct commit_entry, r_node);
+		// set current commit entry to be committed.
+		if (commit_entry->commit_tid == commit_tid) {
+			commit_entry->committed = true;
+			break;
+		}
+		// if there is any one entry before commit_tid is not committed,
+		// we dont need to update_client_commit.
+		if (commit_entry->committed == false)
+			update_client_commit = false;
+	}
+
+	// update_client_commit when the all commit entries before this commit_tid
+	// are all committed.
+	if (update_client_commit) {
+		// update commit positions rely on commit entries one by one.
+		// until corrent commit_tid.
+		for (n = rb_first(&journaler->commit_entries); n;) {
+			commit_entry = rb_entry(n, struct commit_entry, r_node);
+			n = rb_next(n);
+
+			if (commit_entry->commit_tid > commit_tid)
+				break;
+			add_object_position(commit_entry,
+				&journaler->obj_pos_pending,
+				journaler->splay_width);
+			erase_commit_entry(&journaler->commit_entries, commit_entry);
+			kmem_cache_free(journaler_commit_entry_cache, commit_entry);
+		}
+	}
+
+	// schedule commit_work to call ceph_cls_journaler_client_committed()
+	// after JOURNALER_COMMIT_INTERVAL
+	if (update_client_commit && !journaler->commit_scheduled) {
+		queue_delayed_work(journaler->task_wq, &journaler->commit_work,
+				   JOURNALER_COMMIT_INTERVAL);
+		journaler->commit_scheduled = true;
+	}
+	mutex_unlock(&journaler->commit_lock);
+
+}
+EXPORT_SYMBOL(ceph_journaler_client_committed);
+
+// client need to allocate an uniq tag for itself, then every
+// journaler entry from this client will be tagged as his tag.
+int ceph_journaler_allocate_tag(struct ceph_journaler *journaler,
+				uint64_t tag_class, void *buf,
+				uint32_t buf_len,
+				struct ceph_journaler_tag *tag)
+{
+	uint64_t tag_tid;
+	int ret;
+
+retry:
+	ret = ceph_cls_journaler_get_next_tag_tid(journaler->osdc,
+					&journaler->header_oid,
+					&journaler->header_oloc,
+					&tag_tid);
+	if (ret)
+		goto out;
+
+	ret = ceph_cls_journaler_tag_create(journaler->osdc,
+					&journaler->header_oid,
+					&journaler->header_oloc,
+					tag_tid, tag_class,
+					buf, buf_len);
+	if (ret < 0) {
+		if (ret == -ESTALE) {
+			goto retry;
+		} else {
+			goto out;
+		}
+	}
+
+	ret = ceph_cls_journaler_get_tag(journaler->osdc,
+					&journaler->header_oid,
+					&journaler->header_oloc,
+					tag_tid, tag);
+	if (ret)
+		goto out;
+
+out:
+	return ret;
+}
+EXPORT_SYMBOL(ceph_journaler_allocate_tag);
-- 
1.8.3.1



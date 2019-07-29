Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A58788BA
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2019 11:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbfG2Jnl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Jul 2019 05:43:41 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22669 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfG2Jnk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Jul 2019 05:43:40 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowADHYpWjvz5djxunAA--.901S8;
        Mon, 29 Jul 2019 17:43:01 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v3 06/15] libceph: introduce generic journaling
Date:   Mon, 29 Jul 2019 09:42:48 +0000
Message-Id: <1564393377-28949-7-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowADHYpWjvz5djxunAA--.901S8
X-Coremail-Antispam: 1Uf129KBjvAXoWfXr48tF18KF18Zr13Zr1kKrg_yoW5GF1kCo
        Z7Xr4UCF1rGa47ZFWkKrn7J34rXa48Ja4fAr4YqF4Y9an3Ary8Z3y7Gr15JFy3Z3yUArsF
        qw4xJwn3Jw4DA3WUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjfUp-z3UUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiQwUBelbdG2fI4QAAsj
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This commit introduce the generic journaling. This is a initial
commit, which only includes some generic functions, such as
journaler_create|destroy() and journaler_open|close().

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 include/linux/ceph/journaler.h | 184 +++++++++++++
 net/ceph/Makefile              |   3 +-
 net/ceph/journaler.c           | 596 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 782 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/ceph/journaler.h
 create mode 100644 net/ceph/journaler.c

diff --git a/include/linux/ceph/journaler.h b/include/linux/ceph/journaler.h
new file mode 100644
index 0000000..e3b82af
--- /dev/null
+++ b/include/linux/ceph/journaler.h
@@ -0,0 +1,184 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _FS_CEPH_JOURNAL_H
+#define _FS_CEPH_JOURNAL_H
+
+#include <linux/rbtree.h>
+#include <linux/ceph/cls_journaler_client.h>
+
+struct ceph_osd_client;
+
+#define JOURNAL_HEADER_PREFIX	"journal."
+#define JOURNAL_OBJECT_PREFIX	"journal_data."
+
+#define LOCAL_MIRROR_UUID	""
+
+static const uint32_t JOURNALER_EVENT_FIXED_SIZE = 33;
+
+static const uint64_t PREAMBLE = 0x3141592653589793;
+
+struct ceph_journaler_ctx;
+typedef void (*ceph_journaler_callback_t)(struct ceph_journaler_ctx *);
+
+// A ceph_journaler_ctx should be allocated for each journaler appending
+// op, and caller need to set the ->callback, which will be called
+// when this journaler event appending finish.
+struct ceph_journaler_ctx {
+	struct list_head	node;
+	struct ceph_bio_iter	bio_iter;
+	size_t bio_len;
+
+	struct page *prefix_page;
+	unsigned int prefix_offset;
+	unsigned int prefix_len;
+
+	struct page *suffix_page;
+	unsigned int suffix_offset;
+	unsigned int suffix_len;
+
+	int result;
+	uint64_t commit_tid;
+	void *priv;
+	ceph_journaler_callback_t callback;
+};
+
+// tag_tid is used to identify the client.
+struct ceph_journaler_entry {
+	struct list_head node;
+	uint64_t tag_tid;
+	uint64_t entry_tid;
+	ssize_t data_len;
+	char *data;
+	struct ceph_bio_iter *bio_iter;
+};
+
+// ->safe = true means this append op is already write to osd servers
+// ->consistent = true means the prev append op is already finished
+// (safe && consistent) means this append finished. we can call the
+// callback to upper caller.
+//
+// ->wait is the next append which depends on this append, when this
+// append finish, it will tell wait to be consistent.
+struct ceph_journaler_future {
+	uint64_t tag_tid;
+	uint64_t entry_tid;
+	uint64_t commit_tid;
+
+	spinlock_t lock;
+	bool safe;
+	bool consistent;
+
+	struct ceph_journaler_ctx *ctx;
+	struct journaler_append_ctx *wait;
+};
+
+// each journaler object have a recorder to append event to it.
+struct object_recorder {
+	spinlock_t lock;
+	uint64_t splay_offset;
+	uint64_t inflight_append;
+
+	struct list_head append_list;
+	struct list_head overflow_list;
+};
+
+// each journaler object have a replayer to do replay in journaler openning.
+struct object_replayer {
+	spinlock_t lock;
+	uint64_t object_num;
+	struct ceph_journaler_object_pos *pos;
+	struct list_head entry_list;
+};
+
+struct ceph_journaler {
+	struct ceph_osd_client		*osdc;
+	struct ceph_object_id		header_oid;
+	struct ceph_object_locator	header_oloc;
+	struct ceph_object_locator	data_oloc;
+	char				*object_oid_prefix;
+	char				*client_id;
+
+	// TODO put these bool into ->flags
+	// don't need to do another advance if we are advancing
+	bool				advancing;
+	// don't do advance when we are flushing
+	bool				flushing;
+	bool				overflowed;
+	bool				commit_scheduled;
+	uint8_t				order;
+	uint8_t				splay_width;
+	int64_t				pool_id;
+	uint64_t			splay_offset;
+	uint64_t			active_tag_tid;
+	uint64_t			prune_tag_tid;
+	uint64_t			commit_tid;
+	uint64_t			minimum_set;
+	uint64_t			active_set;
+
+	struct ceph_journaler_future	*prev_future;
+	struct ceph_journaler_client	*client;
+	struct object_recorder		*obj_recorders;
+	struct object_replayer		*obj_replayers;
+
+	struct ceph_journaler_object_pos *obj_pos_pending_array;
+	struct list_head		obj_pos_pending;
+	struct ceph_journaler_object_pos *obj_pos_committing_array;
+	struct list_head		obj_pos_committing;
+
+	struct mutex			meta_lock;
+	struct mutex			commit_lock;
+	spinlock_t		entry_tid_lock;
+	spinlock_t		finish_lock;
+	struct list_head		finish_list;
+	struct list_head		clients;
+	struct list_head		clients_cache;
+	struct list_head		entry_tids;
+	struct rb_root			commit_entries;
+
+	struct workqueue_struct		*task_wq;
+	struct workqueue_struct		*notify_wq;
+	struct work_struct		flush_work;
+	struct delayed_work		commit_work;
+	struct work_struct		overflow_work;
+	struct work_struct		finish_work;
+	struct work_struct		notify_update_work;
+
+	void *fetch_buf;
+	int (*handle_entry)(void *entry_handler,
+			    struct ceph_journaler_entry *entry,
+			    uint64_t commit_tid);
+	void *entry_handler;
+	struct ceph_osd_linger_request *watch_handle;
+};
+
+// generic functions
+struct ceph_journaler *ceph_journaler_create(struct ceph_osd_client *osdc,
+					     struct ceph_object_locator*_oloc,
+					     const char *journal_id,
+					     const char *client_id);
+void ceph_journaler_destroy(struct ceph_journaler *journal);
+
+int ceph_journaler_open(struct ceph_journaler *journal);
+void ceph_journaler_close(struct ceph_journaler *journal);
+
+int ceph_journaler_get_cached_client(struct ceph_journaler *journaler, char *client_id,
+				     struct ceph_journaler_client **client_result);
+// replaying
+int ceph_journaler_start_replay(struct ceph_journaler *journaler);
+
+// recording
+static inline uint64_t ceph_journaler_get_max_append_size(struct ceph_journaler *journaler)
+{
+	return (1 << journaler->order) - JOURNALER_EVENT_FIXED_SIZE;
+}
+struct ceph_journaler_ctx *ceph_journaler_ctx_alloc(void);
+void ceph_journaler_ctx_put(struct ceph_journaler_ctx *journaler_ctx);
+int ceph_journaler_append(struct ceph_journaler *journaler,
+			  uint64_t tag_tid, uint64_t *commit_tid,
+			  struct ceph_journaler_ctx *ctx);
+void ceph_journaler_client_committed(struct ceph_journaler *journaler,
+				     uint64_t commit_tid);
+int ceph_journaler_allocate_tag(struct ceph_journaler *journaler,
+				uint64_t tag_class, void *buf,
+				uint32_t buf_len,
+				struct ceph_journaler_tag *tag);
+#endif
diff --git a/net/ceph/Makefile b/net/ceph/Makefile
index 59d0ba2..ea31a2d 100644
--- a/net/ceph/Makefile
+++ b/net/ceph/Makefile
@@ -14,4 +14,5 @@ libceph-y := ceph_common.o messenger.o msgpool.o buffer.o pagelist.o \
 	crypto.o armor.o \
 	auth_x.o \
 	ceph_fs.o ceph_strings.o ceph_hash.o \
-	pagevec.o snapshot.o string_table.o
+	pagevec.o snapshot.o string_table.o \
+	journaler.o cls_journaler_client.o
diff --git a/net/ceph/journaler.c b/net/ceph/journaler.c
new file mode 100644
index 0000000..1b04d3f
--- /dev/null
+++ b/net/ceph/journaler.c
@@ -0,0 +1,596 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/ceph/ceph_debug.h>
+#include <linux/ceph/ceph_features.h>
+#include <linux/ceph/cls_journaler_client.h>
+#include <linux/ceph/journaler.h>
+#include <linux/ceph/libceph.h>
+#include <linux/ceph/osd_client.h>
+
+#include <linux/crc32c.h>
+#include <linux/module.h>
+
+#define JOURNALER_COMMIT_INTERVAL		msecs_to_jiffies(5000)
+
+static char *object_oid_prefix(int pool_id, const char *journal_id)
+{
+	char *prefix;
+	ssize_t len = snprintf(NULL, 0, "%s%d.%s.", JOURNAL_OBJECT_PREFIX,
+			       pool_id, journal_id);
+
+	prefix = kzalloc(len + 1, GFP_KERNEL);
+
+	if (!prefix)
+		return NULL;
+
+	WARN_ON(snprintf(prefix, len + 1, "%s%d.%s.", JOURNAL_OBJECT_PREFIX,
+			 pool_id, journal_id) != len);
+
+	return prefix;
+}
+
+/*
+ * journaler_append_ctx is an internal structure to represent an append op.
+ */
+struct journaler_append_ctx {
+	struct list_head node;
+	struct ceph_journaler *journaler;
+
+	uint64_t splay_offset;
+	uint64_t object_num;
+	struct page *req_page;
+
+	struct ceph_journaler_future future;
+	struct ceph_journaler_entry entry;
+	struct ceph_journaler_ctx journaler_ctx;
+
+	struct kref	kref;
+};
+
+struct commit_entry {
+	struct rb_node	r_node;
+	uint64_t commit_tid;
+	uint64_t object_num;
+	uint64_t tag_tid;
+	uint64_t entry_tid;
+	bool committed;
+};
+
+struct entry_tid {
+	struct list_head	node;
+	uint64_t tag_tid;
+	uint64_t entry_tid;
+};
+
+static struct kmem_cache	*journaler_commit_entry_cache;
+static struct kmem_cache	*journaler_append_ctx_cache;
+
+struct ceph_journaler *ceph_journaler_create(struct ceph_osd_client *osdc,
+					     struct ceph_object_locator *oloc,
+					     const char *journal_id,
+					     const char *client_id)
+{
+	struct ceph_journaler *journaler;
+	int ret;
+
+	journaler = kzalloc(sizeof(struct ceph_journaler), GFP_KERNEL);
+	if (!journaler)
+		return NULL;
+
+	journaler->osdc = osdc;
+	ceph_oid_init(&journaler->header_oid);
+	ret = ceph_oid_aprintf(&journaler->header_oid, GFP_NOIO, "%s%s",
+				JOURNAL_HEADER_PREFIX, journal_id);
+	if (ret) {
+		pr_err("aprintf error : %d", ret);
+		goto err_free_journaler;
+	}
+
+	ceph_oloc_init(&journaler->header_oloc);
+	ceph_oloc_copy(&journaler->header_oloc, oloc);
+	ceph_oloc_init(&journaler->data_oloc);
+
+	journaler->object_oid_prefix = object_oid_prefix(journaler->header_oloc.pool,
+							 journal_id);
+
+	if (!journaler->object_oid_prefix)
+		goto err_destroy_data_oloc;
+
+	journaler->client_id = kstrdup(client_id, GFP_NOIO);
+	if (!journaler->client_id) {
+		ret = -ENOMEM;
+		goto err_free_object_oid_prefix;
+	}
+
+	journaler->advancing = false;
+	journaler->flushing = false;
+	journaler->overflowed = false;
+	journaler->commit_scheduled = false;
+	journaler->order = 0;
+	journaler->splay_width = 0;
+	journaler->pool_id = -1;
+	journaler->splay_offset = 0;
+	journaler->active_tag_tid = UINT_MAX;
+	journaler->prune_tag_tid = UINT_MAX;
+	journaler->commit_tid = 0;
+	journaler->minimum_set = 0;
+	journaler->active_set = 0;
+
+	journaler->prev_future = NULL;
+	journaler->client = NULL;
+	journaler->obj_recorders = NULL;
+	journaler->obj_replayers = NULL;
+
+	mutex_init(&journaler->meta_lock);
+	mutex_init(&journaler->commit_lock);
+	spin_lock_init(&journaler->entry_tid_lock);
+	spin_lock_init(&journaler->finish_lock);
+
+	INIT_LIST_HEAD(&journaler->finish_list);
+	INIT_LIST_HEAD(&journaler->clients);
+	INIT_LIST_HEAD(&journaler->clients_cache);
+	INIT_LIST_HEAD(&journaler->entry_tids);
+	INIT_LIST_HEAD(&journaler->obj_pos_pending);
+	INIT_LIST_HEAD(&journaler->obj_pos_committing);
+
+	journaler->commit_entries = RB_ROOT;
+	journaler_commit_entry_cache = KMEM_CACHE(commit_entry, 0);
+	if (!journaler_commit_entry_cache)
+		goto err_free_client_id;
+
+	journaler_append_ctx_cache = KMEM_CACHE(journaler_append_ctx, 0);
+	if (!journaler_append_ctx_cache)
+		goto err_destroy_commit_entry_cache;
+
+	journaler->task_wq = alloc_ordered_workqueue("journaler-tasks",
+						     WQ_MEM_RECLAIM);
+	if (!journaler->task_wq)
+		goto err_destroy_append_ctx_cache;
+
+	journaler->notify_wq = create_singlethread_workqueue("journaler-notify");
+	if (!journaler->notify_wq)
+		goto err_destroy_task_wq;
+
+	journaler->fetch_buf = NULL;
+	journaler->handle_entry = NULL;
+	journaler->entry_handler = NULL;
+	journaler->watch_handle = NULL;
+
+	return journaler;
+
+err_destroy_task_wq:
+	destroy_workqueue(journaler->task_wq);
+err_destroy_append_ctx_cache:
+	kmem_cache_destroy(journaler_append_ctx_cache);
+err_destroy_commit_entry_cache:
+	kmem_cache_destroy(journaler_commit_entry_cache);
+err_free_client_id:
+	kfree(journaler->client_id);
+err_free_object_oid_prefix:
+	kfree(journaler->object_oid_prefix);
+err_destroy_data_oloc:
+	ceph_oloc_destroy(&journaler->data_oloc);
+	ceph_oloc_destroy(&journaler->header_oloc);
+	ceph_oid_destroy(&journaler->header_oid);
+err_free_journaler:
+	kfree(journaler);
+	return NULL;
+}
+EXPORT_SYMBOL(ceph_journaler_create);
+
+void ceph_journaler_destroy(struct ceph_journaler *journaler)
+{
+	destroy_workqueue(journaler->notify_wq);
+	destroy_workqueue(journaler->task_wq);
+
+	kmem_cache_destroy(journaler_append_ctx_cache);
+	kmem_cache_destroy(journaler_commit_entry_cache);
+	kfree(journaler->client_id);
+	kfree(journaler->object_oid_prefix);
+	ceph_oloc_destroy(&journaler->data_oloc);
+	ceph_oloc_destroy(&journaler->header_oloc);
+	ceph_oid_destroy(&journaler->header_oid);
+	kfree(journaler);
+}
+EXPORT_SYMBOL(ceph_journaler_destroy);
+
+static int refresh(struct ceph_journaler *journaler, bool init)
+{
+	int ret;
+	struct ceph_journaler_client *client;
+	uint64_t minimum_commit_set;
+	uint64_t minimum_set;
+	uint64_t active_set;
+	bool need_advance = false;
+	LIST_HEAD(tmp_clients);
+
+	INIT_LIST_HEAD(&tmp_clients);
+	ret = ceph_cls_journaler_get_mutable_metas(journaler->osdc,
+			&journaler->header_oid, &journaler->header_oloc,
+			&minimum_set, &active_set);
+	if (ret)
+		return ret;
+
+	ret = ceph_cls_journaler_client_list(journaler->osdc, &journaler->header_oid,
+		&journaler->header_oloc, &journaler->clients_cache, journaler->splay_width);
+	if (ret)
+		return ret;
+
+	mutex_lock(&journaler->meta_lock);
+	if (init) {
+		journaler->active_set = active_set;
+	} else {
+		// check for advance active_set.
+		need_advance = active_set > journaler->active_set;
+	}
+
+	journaler->active_set = active_set;
+	journaler->minimum_set = minimum_set;
+	// swap clients with clients_cache. clients in client_cache list is not
+	// released, then we can reuse them in next refresh() to avoid malloc() and
+	// free() too frequently.
+	list_splice_tail_init(&journaler->clients, &tmp_clients);
+	list_splice_tail_init(&journaler->clients_cache, &journaler->clients);
+	list_splice_tail_init(&tmp_clients, &journaler->clients_cache);
+
+	// calculate the minimum_commit_set.
+	// TODO: unregister clients if the commit position is too long behind
+	// active positions. similar with rbd_journal_max_concurrent_object_sets
+	// in user space journal.
+	minimum_commit_set = journaler->active_set;
+	list_for_each_entry(client, &journaler->clients, node) {
+		struct ceph_journaler_object_pos *pos;
+
+		list_for_each_entry(pos, &client->object_positions, node) {
+			uint64_t object_set = pos->object_num / journaler->splay_width;
+			if (object_set < minimum_commit_set) {
+				minimum_commit_set = object_set;
+			}
+		}
+
+		if (!strcmp(client->id, journaler->client_id)) {
+			journaler->client = client;
+		}
+	}
+	mutex_unlock(&journaler->meta_lock);
+
+	if (need_advance) {
+		// the actual advancing
+		mutex_lock(&journaler->meta_lock);
+		journaler->overflowed = false;
+		journaler->advancing = false;
+		mutex_unlock(&journaler->meta_lock);
+
+		// At this time, the active_set is actually advanced,
+		// we can flush now.
+		queue_work(journaler->task_wq, &journaler->flush_work);
+	}
+
+	return 0;
+
+}
+
+static void journaler_watch_cb(void *arg, u64 notify_id, u64 cookie,
+			 u64 notifier_id, void *data, size_t data_len)
+{
+	struct ceph_journaler *journaler = arg;
+	int ret;
+
+	ret = refresh(journaler, false);
+        if (ret < 0)
+                pr_err("%s: failed to refresh journaler: %d", __func__, ret);
+
+	ret = ceph_osdc_notify_ack(journaler->osdc, &journaler->header_oid,
+				   &journaler->header_oloc, notify_id,
+				   cookie, NULL, 0);
+	if (ret)
+        	pr_err("acknowledge_notify failed: %d", ret);
+}
+
+static void journaler_watch_errcb(void *arg, u64 cookie, int err)
+{
+	// TODO re-watch in watch error.
+	pr_err("journaler watch error: %d", err);
+}
+
+static int journaler_watch(struct ceph_journaler *journaler)
+{
+	struct ceph_osd_client *osdc = journaler->osdc;
+	struct ceph_osd_linger_request *handle;
+
+	handle = ceph_osdc_watch(osdc, &journaler->header_oid,
+				 &journaler->header_oloc, journaler->notify_wq,
+				 journaler_watch_cb, journaler_watch_errcb,
+				 journaler);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	journaler->watch_handle = handle;
+	return 0;
+}
+
+static void journaler_unwatch(struct ceph_journaler *journaler)
+{
+	struct ceph_osd_client *osdc = journaler->osdc;
+	int ret;
+
+	ret = ceph_osdc_unwatch(osdc, journaler->watch_handle);
+	if (ret)
+		pr_err("%s: failed to unwatch: %d", __func__, ret);
+
+	journaler->watch_handle = NULL;
+}
+
+static void copy_object_pos(struct ceph_journaler_object_pos *src_pos,
+			   struct ceph_journaler_object_pos *dst_pos)
+{
+	dst_pos->object_num = src_pos->object_num;
+	dst_pos->tag_tid = src_pos->tag_tid;
+	dst_pos->entry_tid = src_pos->entry_tid;
+}
+
+static void copy_pos_list(struct list_head *src_list, struct list_head *dst_list)
+{
+	struct ceph_journaler_object_pos *src_pos, *dst_pos;
+
+	src_pos = list_first_entry(src_list, struct ceph_journaler_object_pos, node);
+	dst_pos = list_first_entry(dst_list, struct ceph_journaler_object_pos, node);
+	while (&src_pos->node != src_list && &dst_pos->node != dst_list) {
+		copy_object_pos(src_pos, dst_pos);
+		src_pos = list_next_entry(src_pos, node);
+		dst_pos = list_next_entry(dst_pos, node);
+	}
+}
+
+int ceph_journaler_open(struct ceph_journaler *journaler)
+{
+	uint8_t order, splay_width;
+	int64_t pool_id;
+	int i, ret;
+	struct ceph_journaler_client *client, *next_client;
+
+	ret = ceph_cls_journaler_get_immutable_metas(journaler->osdc,
+					&journaler->header_oid,
+					&journaler->header_oloc,
+					&order,
+					&splay_width,
+					&pool_id);
+	if (ret) {
+		pr_err("failed to get immutable metas.");;
+		goto out;
+	}
+
+	mutex_lock(&journaler->meta_lock);
+	// set the immutable metas.
+	journaler->order = order;
+	journaler->splay_width = splay_width;
+	journaler->pool_id = pool_id;
+
+	if (journaler->pool_id == -1) {
+		ceph_oloc_copy(&journaler->data_oloc, &journaler->header_oloc);
+		journaler->pool_id = journaler->data_oloc.pool;
+	} else {
+		journaler->data_oloc.pool = journaler->pool_id;
+	}
+
+	// initialize ->obj_recorders and ->obj_replayers.
+	journaler->obj_recorders = kzalloc(sizeof(struct object_recorder) *
+					   journaler->splay_width, GFP_KERNEL);
+	if (!journaler->obj_recorders) {
+		mutex_unlock(&journaler->meta_lock);
+		goto out;
+	}
+
+	journaler->obj_replayers = kzalloc(sizeof(struct object_replayer) *
+					   journaler->splay_width, GFP_KERNEL);
+	if (!journaler->obj_replayers) {
+		mutex_unlock(&journaler->meta_lock);
+		goto free_recorders;
+	}
+
+	journaler->obj_pos_pending_array = kzalloc(sizeof(struct ceph_journaler_object_pos) *
+					   	   journaler->splay_width, GFP_KERNEL);
+	if (!journaler->obj_pos_pending_array) {
+		mutex_unlock(&journaler->meta_lock);
+		goto free_replayers;
+	}
+
+	journaler->obj_pos_committing_array = kzalloc(sizeof(struct ceph_journaler_object_pos) *
+					   	   journaler->splay_width, GFP_KERNEL);
+	if (!journaler->obj_pos_committing_array) {
+		mutex_unlock(&journaler->meta_lock);
+		goto free_pos_pending;
+	}
+
+	for (i = 0; i < journaler->splay_width; i++) {
+		struct object_recorder *obj_recorder = &journaler->obj_recorders[i];
+		struct object_replayer *obj_replayer = &journaler->obj_replayers[i];
+		struct ceph_journaler_object_pos *pos_pending = &journaler->obj_pos_pending_array[i];
+		struct ceph_journaler_object_pos *pos_committing = &journaler->obj_pos_committing_array[i];
+
+		spin_lock_init(&obj_recorder->lock);
+		obj_recorder->splay_offset = i;
+		obj_recorder->inflight_append = 0;
+		INIT_LIST_HEAD(&obj_recorder->append_list);
+		INIT_LIST_HEAD(&obj_recorder->overflow_list);
+
+		spin_lock_init(&obj_replayer->lock);
+		obj_replayer->object_num = i;
+		obj_replayer->pos = NULL;
+		INIT_LIST_HEAD(&obj_replayer->entry_list);
+
+		pos_pending->in_using = false;
+		INIT_LIST_HEAD(&pos_pending->node);
+		list_add_tail(&pos_pending->node, &journaler->obj_pos_pending);
+
+		pos_committing->in_using = false;
+		INIT_LIST_HEAD(&pos_committing->node);
+		list_add_tail(&pos_committing->node, &journaler->obj_pos_committing);
+	}
+	mutex_unlock(&journaler->meta_lock);
+
+	ret = refresh(journaler, true);
+	if (ret)
+		goto free_pos_committing;
+
+	mutex_lock(&journaler->meta_lock);
+	if (journaler->client){
+		copy_pos_list(&journaler->client->object_positions,
+			      &journaler->obj_pos_pending);
+	}
+	mutex_unlock(&journaler->meta_lock);
+
+	ret = journaler_watch(journaler);
+	if (ret) {
+		pr_err("journaler_watch error: %d", ret);
+		goto destroy_clients;
+	}
+	return 0;
+
+destroy_clients:
+	list_for_each_entry_safe(client, next_client,
+				 &journaler->clients, node) {
+		list_del(&client->node);
+		destroy_client(client);
+	}
+
+	list_for_each_entry_safe(client, next_client,
+				 &journaler->clients_cache, node) {
+		list_del(&client->node);
+		destroy_client(client);
+	}
+free_pos_committing:
+	kfree(journaler->obj_pos_committing_array);
+free_pos_pending:
+	kfree(journaler->obj_pos_pending_array);
+free_replayers:
+	kfree(journaler->obj_replayers);
+free_recorders:
+	kfree(journaler->obj_recorders);
+out:
+	return ret;
+}
+EXPORT_SYMBOL(ceph_journaler_open);
+
+DEFINE_RB_INSDEL_FUNCS(commit_entry, struct commit_entry, commit_tid, r_node)
+
+void ceph_journaler_close(struct ceph_journaler *journaler)
+{
+	struct ceph_journaler_client *client, *next;
+	struct commit_entry *commit_entry;
+	struct entry_tid *entry_tid, *entry_tid_next;
+	struct ceph_journaler_object_pos *pos, *next_pos;
+	struct rb_node *n;
+	int i;
+
+	// Stop watching
+	journaler_unwatch(journaler);
+	flush_workqueue(journaler->notify_wq);
+
+	flush_delayed_work(&journaler->commit_work);
+	drain_workqueue(journaler->task_wq);
+	list_for_each_entry_safe(pos, next_pos,
+				 &journaler->obj_pos_pending, node) {
+		list_del(&pos->node);
+	}
+
+	list_for_each_entry_safe(pos, next_pos,
+				 &journaler->obj_pos_committing, node) {
+		list_del(&pos->node);
+	}
+	journaler->client = NULL;
+	list_for_each_entry_safe(client, next, &journaler->clients, node) {
+		list_del(&client->node);
+		destroy_client(client);
+	}
+	list_for_each_entry_safe(client, next, &journaler->clients_cache, node) {
+		list_del(&client->node);
+		destroy_client(client);
+	}
+
+	for (n = rb_first(&journaler->commit_entries); n;) {
+		commit_entry = rb_entry(n, struct commit_entry, r_node);
+
+		n = rb_next(n);
+		erase_commit_entry(&journaler->commit_entries, commit_entry);
+		kmem_cache_free(journaler_commit_entry_cache, commit_entry);
+	}
+
+	for (i = 0; i < journaler->splay_width; i++) {
+		struct object_recorder *obj_recorder = &journaler->obj_recorders[i];
+		struct object_replayer *obj_replayer = &journaler->obj_replayers[i];
+
+		spin_lock(&obj_recorder->lock);
+		BUG_ON(!list_empty(&obj_recorder->append_list) ||
+			!list_empty(&obj_recorder->overflow_list));
+		spin_unlock(&obj_recorder->lock);
+
+		spin_lock(&obj_replayer->lock);
+		BUG_ON(!list_empty(&obj_replayer->entry_list));
+		spin_unlock(&obj_replayer->lock);
+	}
+
+	kfree(journaler->obj_pos_committing_array);
+	kfree(journaler->obj_pos_pending_array);
+	kfree(journaler->obj_recorders);
+	kfree(journaler->obj_replayers);
+	journaler->obj_recorders = NULL;
+	journaler->obj_replayers = NULL;
+
+	list_for_each_entry_safe(entry_tid, entry_tid_next,
+				 &journaler->entry_tids, node) {
+		list_del(&entry_tid->node);
+		kfree(entry_tid);
+	}
+
+	WARN_ON(!list_empty(&journaler->finish_list));
+	WARN_ON(!list_empty(&journaler->clients));
+	WARN_ON(!list_empty(&journaler->clients_cache));
+	WARN_ON(!list_empty(&journaler->entry_tids));
+	WARN_ON(!list_empty(&journaler->obj_pos_pending));
+	WARN_ON(rb_first(&journaler->commit_entries) != NULL);
+
+	mutex_lock(&journaler->meta_lock);
+	ceph_oloc_init(&journaler->data_oloc);
+	journaler->advancing = false;
+	journaler->flushing = false;
+	journaler->overflowed = false;
+	journaler->commit_scheduled = false;
+	journaler->order = 0;
+	journaler->splay_width = 0;
+	journaler->pool_id = -1;
+	journaler->splay_offset = 0;
+	journaler->active_tag_tid = UINT_MAX;
+	journaler->prune_tag_tid = UINT_MAX;
+	journaler->commit_tid = 0;
+	journaler->minimum_set = 0;
+	journaler->active_set = 0;
+	journaler->prev_future = NULL;
+	journaler->fetch_buf = NULL;
+	journaler->handle_entry = NULL;
+	journaler->entry_handler = NULL;
+	journaler->watch_handle = NULL;
+
+	mutex_unlock(&journaler->meta_lock);
+
+	return;
+}
+EXPORT_SYMBOL(ceph_journaler_close);
+
+int ceph_journaler_get_cached_client(struct ceph_journaler *journaler, char *client_id,
+				     struct ceph_journaler_client **client_result)
+{
+	struct ceph_journaler_client *client;
+	int ret = -ENOENT;
+
+	list_for_each_entry(client, &journaler->clients, node) {
+		if (!strcmp(client->id, client_id)) {
+			*client_result = client;
+			ret = 0;
+			break;
+		}
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(ceph_journaler_get_cached_client);
-- 
1.8.3.1



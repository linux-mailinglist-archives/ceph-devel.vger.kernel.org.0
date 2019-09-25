Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD5ABDA92
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Sep 2019 11:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbfIYJJ1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Sep 2019 05:09:27 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:21720 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728727AbfIYJJ0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 25 Sep 2019 05:09:26 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAD3dl9YLotdHDhSAg--.166S8;
        Wed, 25 Sep 2019 17:07:38 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v4 06/12] libceph: introduce generic journaler module
Date:   Wed, 25 Sep 2019 09:07:28 +0000
Message-Id: <1569402454-4736-7-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569402454-4736-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1569402454-4736-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowAD3dl9YLotdHDhSAg--.166S8
X-Coremail-Antispam: 1Uf129KBjvAXoWDJryfWFyxWFy3XF4DuryrtFb_yoWxKw13Co
        Z7ur4UuFn5Ga47ZFWkKr1kJ34fXa48JayrAr4YqF4Y93ZrAry8Z3y7Gr15Jry3Aw4UArsF
        qw1xJwnaqr4DJ3WUn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjfUJeOJUUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiKBs7elz4rC4UPgAAs+
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is a generic journaling module for ceph client in linux kernel.

It provide three kinds of APIs for clients:
(1) open and close:
    1.1 ceph_journaler_create, ceph_journaler_destroy
    1.2 ceph_journaler_open, ceph_journaler_close

(2) replay:
    ceph_journaler_start_replay(), this should be called after
ceph_journaler_open, which would check the journal and do replay
if there is any uncommitted entry in journal.

(3) appending:
    3.1 ceph_journaler_allocate_tag() is used to get an uniq tag_tid
for this client. Every journal event from this client would be tagged
by this tag_tid.
    3.2 ceph_journaler_append() is used to append journal entry
into journal.
    3.3 ceph_journaler_client_committed() is called when the data
is committed to data object, then we need to tell journal that
the related journal entries are safe now.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 include/linux/ceph/journaler.h |  182 ++++
 net/ceph/Makefile              |    3 +-
 net/ceph/journaler.c           | 2205 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 2389 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/ceph/journaler.h
 create mode 100644 net/ceph/journaler.c

diff --git a/include/linux/ceph/journaler.h b/include/linux/ceph/journaler.h
new file mode 100644
index 0000000..b9d482d
--- /dev/null
+++ b/include/linux/ceph/journaler.h
@@ -0,0 +1,182 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _FS_CEPH_JOURNAL_H
+#define _FS_CEPH_JOURNAL_H
+
+#include <linux/rbtree.h>
+#include <linux/ceph/cls_journal_client.h>
+
+struct ceph_osd_client;
+
+#define JOURNAL_HEADER_PREFIX "journal."
+#define JOURNAL_OBJECT_PREFIX "journal_data."
+#define JOURNALER_EVENT_FIXED_SIZE 33
+#define PREAMBLE 0x3141592653589793
+
+struct ceph_journaler_ctx;
+typedef void (*ceph_journaler_callback_t)(struct ceph_journaler_ctx *);
+
+/*
+ * A ceph_journaler_ctx should be allocated for each journaler appending
+ * op, and caller need to set the ->callback, which will be called
+ * when this journaler event appending finish.
+ */
+struct ceph_journaler_ctx {
+	struct list_head node;
+	struct ceph_bio_iter bio_iter;
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
+	u64 commit_tid;
+	void *priv;
+	ceph_journaler_callback_t callback;
+};
+
+/* tag_tid is used to identify the client. */
+struct ceph_journaler_entry {
+	struct list_head node;
+	u64 tag_tid;
+	u64 entry_tid;
+	ssize_t data_len;
+	char *data;
+};
+
+/*
+ * ->safe = true means this append op is already written to osd servers
+ * ->consistent = true means the prev append op is already finished
+ * (safe && consistent) means this append finished. we can call the
+ * callback to upper caller.
+ *
+ * ->wait is the next append which depends on this append, when this
+ * append finish, it will tell wait to be consistent.
+ */
+struct ceph_journaler_future {
+	u64 tag_tid;
+	u64 entry_tid;
+	u64 commit_tid;
+
+	spinlock_t lock;
+	bool safe;
+	bool consistent;
+	int result;
+
+	struct ceph_journaler_ctx *ctx;
+	struct journaler_append_ctx *wait;
+};
+
+/* each journaler object have a recorder to append event to it. */
+struct object_recorder {
+	spinlock_t lock;
+	u8 splay_offset;
+	u64 inflight_append;
+
+	struct list_head append_list;
+	struct list_head overflow_list;
+};
+
+/* each journaler object have a replayer to do replay in journaler openning. */
+struct object_replayer {
+	u64 object_num;
+	struct ceph_journaler_object_pos *pos;
+	struct list_head entry_list;
+};
+
+struct ceph_journaler {
+	struct ceph_osd_client *osdc;
+	struct ceph_object_id header_oid;
+	struct ceph_object_locator header_oloc;
+	struct ceph_object_locator data_oloc;
+	char *object_oid_prefix;
+	char *client_id;
+
+	/*
+	 * TODO put these bool into ->flags
+	 * don't need to do another advance if we are advancing
+	 */
+	bool advancing;
+	/*don't do advance when we are flushing */
+	bool flushing;
+	bool overflowed;
+	bool commit_scheduled;
+	u8 order;
+	u8 splay_width;
+	u8 splay_offset;
+	u64 active_tag_tid;
+	u64 prune_tag_tid;
+	u64 commit_tid;
+	u64 minimum_set;
+	u64 active_set;
+
+	struct ceph_journaler_future *prev_future;
+	struct ceph_journaler_client *client;
+	struct object_recorder *obj_recorders;
+	struct object_replayer *obj_replayers;
+
+	struct ceph_journaler_object_pos *obj_pos_pending_array;
+	struct list_head obj_pos_pending;
+	struct ceph_journaler_object_pos *obj_pos_committing_array;
+	struct list_head obj_pos_committing;
+
+	struct mutex meta_lock;
+	struct mutex commit_lock;
+	spinlock_t finish_lock;
+	struct list_head finish_list;
+	struct list_head clients;
+	struct list_head clients_cache;
+	struct list_head entry_tids;
+	struct rb_root commit_entries;
+
+	struct workqueue_struct *task_wq;
+	struct workqueue_struct *notify_wq;
+	struct work_struct flush_work;
+	struct delayed_work commit_work;
+	struct work_struct overflow_work;
+	struct work_struct finish_work;
+	struct work_struct notify_update_work;
+
+	void *fetch_buf;
+	int (*handle_entry)(void *entry_handler,
+			    struct ceph_journaler_entry *entry, u64 commit_tid);
+	void *entry_handler;
+	struct ceph_osd_linger_request *watch_handle;
+};
+
+/* generic functions */
+struct ceph_journaler *ceph_journaler_create(struct ceph_osd_client *osdc,
+					     struct ceph_object_locator *_oloc,
+					     const char *journal_id,
+					     const char *client_id);
+void ceph_journaler_destroy(struct ceph_journaler *journal);
+
+int ceph_journaler_open(struct ceph_journaler *journal);
+void ceph_journaler_close(struct ceph_journaler *journal);
+
+int ceph_journaler_get_cached_client(struct ceph_journaler *journaler,
+		char *client_id,
+		struct ceph_journaler_client **client_result);
+/* replaying */
+int ceph_journaler_start_replay(struct ceph_journaler *journaler);
+
+/* recording */
+static inline u64
+ceph_journaler_get_max_append_size(struct ceph_journaler *journaler)
+{
+	return (1 << journaler->order) - JOURNALER_EVENT_FIXED_SIZE;
+}
+struct ceph_journaler_ctx *ceph_journaler_ctx_alloc(void);
+void ceph_journaler_ctx_free(struct ceph_journaler_ctx *journaler_ctx);
+int ceph_journaler_append(struct ceph_journaler *journaler, u64 tag_tid,
+			  struct ceph_journaler_ctx *ctx);
+void ceph_journaler_client_committed(struct ceph_journaler *journaler,
+				     u64 commit_tid);
+int ceph_journaler_allocate_tag(struct ceph_journaler *journaler, u64 tag_class,
+				void *buf, u32 buf_len,
+				struct ceph_journaler_tag *tag);
+#endif
diff --git a/net/ceph/Makefile b/net/ceph/Makefile
index 59d0ba2..2e672dd 100644
--- a/net/ceph/Makefile
+++ b/net/ceph/Makefile
@@ -14,4 +14,5 @@ libceph-y := ceph_common.o messenger.o msgpool.o buffer.o pagelist.o \
 	crypto.o armor.o \
 	auth_x.o \
 	ceph_fs.o ceph_strings.o ceph_hash.o \
-	pagevec.o snapshot.o string_table.o
+	pagevec.o snapshot.o string_table.o \
+	journaler.o cls_journal_client.o
diff --git a/net/ceph/journaler.c b/net/ceph/journaler.c
new file mode 100644
index 0000000..d6777cb
--- /dev/null
+++ b/net/ceph/journaler.c
@@ -0,0 +1,2205 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/ceph/ceph_debug.h>
+#include <linux/ceph/ceph_features.h>
+#include <linux/ceph/cls_journal_client.h>
+#include <linux/ceph/journaler.h>
+#include <linux/ceph/libceph.h>
+#include <linux/ceph/osd_client.h>
+
+#include <linux/crc32c.h>
+#include <linux/module.h>
+
+#define JOURNALER_COMMIT_INTERVAL msecs_to_jiffies(5000)
+#define JOURNALER_NOTIFY_TIMEOUT 5 /* seconds */
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
+ *                              |                 (error) 
+ *                              v                    . 
+ *                     JOURNALER_APPEND_SAFE . . < . v
+ *                              |
+ *                              v
+ *                     JOURNALER_APPEND_FINISH
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
+/*
+ * journaler_append_ctx is an internal structure to represent an append op.
+ */
+struct journaler_append_ctx {
+	struct list_head node;
+	struct ceph_journaler *journaler;
+
+	u8 splay_offset;
+	u64 object_num;
+	struct page *req_page;
+
+	struct ceph_journaler_future future;
+	struct ceph_journaler_entry entry;
+	struct ceph_journaler_ctx journaler_ctx;
+
+	enum journaler_append_state state;
+};
+
+struct commit_entry {
+	struct rb_node r_node;
+	u64 commit_tid;
+	u64 object_num;
+	u64 tag_tid;
+	u64 entry_tid;
+	bool committed;
+};
+
+struct entry_tid {
+	struct list_head node;
+	u64 tag_tid;
+	u64 entry_tid;
+};
+
+static struct kmem_cache *journaler_commit_entry_cache;
+static struct kmem_cache *journaler_append_ctx_cache;
+
+/* trimming */
+static int ceph_journaler_obj_remove_sync(struct ceph_journaler *journaler,
+					  struct ceph_object_id *oid,
+					  struct ceph_object_locator *oloc)
+
+{
+	struct ceph_osd_client *osdc = journaler->osdc;
+	struct ceph_osd_request *req;
+	int ret;
+
+	req = ceph_osdc_alloc_request(osdc, NULL, 1, false, GFP_NOIO);
+	if (!req)
+		return -ENOMEM;
+
+	ceph_oid_copy(&req->r_base_oid, oid);
+	ceph_oloc_copy(&req->r_base_oloc, oloc);
+	req->r_flags = CEPH_OSD_FLAG_WRITE;
+
+	osd_req_op_init(req, 0, CEPH_OSD_OP_DELETE, 0);
+	ret = ceph_osdc_alloc_messages(req, GFP_NOIO);
+	if (ret)
+		goto out_req;
+
+	ceph_osdc_start_request(osdc, req, false);
+	ret = ceph_osdc_wait_request(osdc, req);
+
+out_req:
+	ceph_osdc_put_request(req);
+	return ret;
+}
+
+static int remove_set(struct ceph_journaler *journaler, u64 object_set)
+{
+	u64 object_num;
+	u8 splay_offset;
+	struct ceph_object_id object_oid;
+	int ret;
+
+	ceph_oid_init(&object_oid);
+	for (splay_offset = 0; splay_offset < journaler->splay_width;
+	     splay_offset++) {
+		object_num = splay_offset + (object_set * journaler->splay_width);
+		if (!ceph_oid_empty(&object_oid)) {
+			ceph_oid_destroy(&object_oid);
+			ceph_oid_init(&object_oid);
+		}
+		ret = ceph_oid_aprintf(&object_oid, GFP_NOIO, "%s%llu",
+				       journaler->object_oid_prefix,
+				       object_num);
+		if (ret) {
+			pr_err("%s: aprintf error : %d", __func__, ret);
+			goto out;
+		}
+		ret = ceph_journaler_obj_remove_sync(journaler, &object_oid,
+						     &journaler->data_oloc);
+		if (ret < 0 && ret != -ENOENT) {
+			pr_err("%s: failed to remove object: %llu", __func__,
+			       object_num);
+			goto out;
+		}
+	}
+	ret = 0;
+out:
+	ceph_oid_destroy(&object_oid);
+	return ret;
+}
+
+static int set_minimum_set(struct ceph_journaler *journaler, u64 minimum_set)
+{
+	int ret;
+
+	ret = ceph_cls_journal_set_minimum_set(journaler->osdc,
+					       &journaler->header_oid,
+					       &journaler->header_oloc,
+					       minimum_set);
+	if (ret < 0) {
+		pr_err("%s: failed to set_minimum_set: %d", __func__, ret);
+		return ret;
+	}
+
+	queue_work(journaler->task_wq, &journaler->notify_update_work);
+
+	return ret;
+}
+
+DEFINE_RB_INSDEL_FUNCS(commit_entry, struct commit_entry, commit_tid, r_node)
+
+/* replaying */
+static int ceph_journaler_obj_read_sync(struct ceph_journaler *journaler,
+					struct ceph_object_id *oid,
+					struct ceph_object_locator *oloc,
+					void *buf, u32 read_off, u64 buf_len)
+
+{
+	struct ceph_osd_client *osdc = journaler->osdc;
+	struct ceph_osd_request *req;
+	struct page **pages;
+	int num_pages = calc_pages_for(0, buf_len);
+	int ret;
+
+	req = ceph_osdc_alloc_request(osdc, NULL, 1, false, GFP_NOIO);
+	if (!req)
+		return -ENOMEM;
+
+	ceph_oid_copy(&req->r_base_oid, oid);
+	ceph_oloc_copy(&req->r_base_oloc, oloc);
+	req->r_flags = CEPH_OSD_FLAG_READ;
+
+	pages = ceph_alloc_page_vector(num_pages, GFP_NOIO);
+	if (IS_ERR(pages)) {
+		ret = PTR_ERR(pages);
+		goto out_req;
+	}
+
+	osd_req_op_extent_init(req, 0, CEPH_OSD_OP_READ,
+			       read_off, buf_len, 0, 0);
+	osd_req_op_extent_osd_data_pages(req, 0, pages, buf_len, 0, false,
+					 true);
+
+	ret = ceph_osdc_alloc_messages(req, GFP_NOIO);
+	if (ret)
+		goto out_req;
+	ceph_osdc_start_request(osdc, req, false);
+	ret = ceph_osdc_wait_request(osdc, req);
+	if (ret >= 0)
+		ceph_copy_from_page_vector(pages, buf, 0, ret);
+
+out_req:
+	ceph_osdc_put_request(req);
+	return ret;
+}
+
+static bool entry_is_readable(struct ceph_journaler *journaler, void *buf,
+			      void *end)
+{
+	/* preamble, version, entry tid, tag id */
+	const u32 HEADER_FIXED_SIZE = 25;
+	u32 remaining = end - buf;
+	u64 preamble;
+	u32 data_size;
+	void *origin_buf = buf;
+	u32 crc, crc_encoded;
+
+	if (remaining < HEADER_FIXED_SIZE)
+		return false;
+
+	/* preamble */
+	preamble = ceph_decode_64(&buf);
+	if (PREAMBLE != preamble)
+		return false;
+
+	buf += (HEADER_FIXED_SIZE - sizeof(preamble));
+	remaining = end - buf;
+	if (remaining < sizeof(u32))
+		return false;
+	/* data_size */
+	data_size = ceph_decode_32(&buf);
+	remaining = end - buf;
+	if (remaining < data_size)
+		return false;
+	buf += data_size;
+	remaining = end - buf;
+	if (remaining < sizeof(u32))
+		return false;
+	/* crc */
+	crc = crc32c(0, origin_buf, buf - origin_buf);
+	crc_encoded = ceph_decode_32(&buf);
+	if (crc != crc_encoded) {
+		pr_err("%s: crc corrupted.", __func__);
+		return false;
+	}
+	return true;
+}
+
+static int playback_entry(struct ceph_journaler *journaler,
+			  struct ceph_journaler_entry *entry, u64 commit_tid)
+{
+	BUG_ON(!journaler->handle_entry || !journaler->entry_handler);
+
+	return journaler->handle_entry(journaler->entry_handler, entry,
+				       commit_tid);
+}
+
+/*
+ * get_last_entry_tid() is called in replaying step, and no appending
+ * is allowed at that time. So there is no race for journaler->entry_tids
+ * with get_new_entry_tid().
+ *
+ * And the replaying is single-threaded, that means there is no race
+ * with get_last_entry_tid() and reserve_entry_tid().
+ */
+static bool get_last_entry_tid(struct ceph_journaler *journaler, u64 tag_tid,
+			       u64 *entry_tid)
+{
+	struct entry_tid *pos;
+
+	list_for_each_entry(pos, &journaler->entry_tids, node) {
+		if (pos->tag_tid == tag_tid) {
+			*entry_tid = pos->entry_tid;
+			return true;
+		}
+	}
+	return false;
+}
+
+/* 
+ * There would not be too many entry_tids here, we need
+ * only one entry_tid for all entries with same tag_tid.
+ */
+static struct entry_tid *entry_tid_alloc(struct ceph_journaler *journaler,
+					 u64 tag_tid)
+{
+	struct entry_tid *entry_tid;
+
+	entry_tid = kzalloc(sizeof(*entry_tid), GFP_NOIO);
+	if (!entry_tid) {
+		pr_err("%s: failed to allocate new entry.", __func__);
+		return NULL;
+	}
+
+	entry_tid->tag_tid = tag_tid;
+	entry_tid->entry_tid = 0;
+	INIT_LIST_HEAD(&entry_tid->node);
+
+	list_add_tail(&entry_tid->node, &journaler->entry_tids);
+	return entry_tid;
+}
+
+/*
+ * reserve_entry_tid() is called in replaying. About the race
+ * for journaler->entry_tids, see comment for get_last_entry_tid()
+ */
+static int reserve_entry_tid(struct ceph_journaler *journaler, u64 tag_tid,
+			     u64 entry_tid)
+{
+	struct entry_tid *pos;
+
+	list_for_each_entry(pos, &journaler->entry_tids, node) {
+		if (pos->tag_tid == tag_tid) {
+			if (pos->entry_tid < entry_tid)
+				pos->entry_tid = entry_tid;
+			return 0;
+		}
+	}
+
+	pos = entry_tid_alloc(journaler, tag_tid);
+	if (!pos) {
+		pr_err("%s: failed to allocate new entry.", __func__);
+		return -ENOMEM;
+	}
+	pos->entry_tid = entry_tid;
+
+	return 0;
+}
+
+static void journaler_entry_free(struct ceph_journaler_entry *entry)
+{
+	if (entry->data)
+		kvfree(entry->data);
+	kfree(entry);
+}
+
+static struct ceph_journaler_entry *journaler_entry_decode(void **p, void *end)
+{
+	struct ceph_journaler_entry *entry;
+	u64 preamble;
+	u8 version;
+	u32 crc, crc_encoded;
+	void *start = *p;
+
+	preamble = ceph_decode_64(p);
+	if (PREAMBLE != preamble)
+		return NULL;
+
+	version = ceph_decode_8(p);
+	if (version != 1)
+		return NULL;
+
+	entry = kzalloc(sizeof(*entry), GFP_NOIO);
+	if (!entry)
+		goto err;
+	INIT_LIST_HEAD(&entry->node);
+	entry->entry_tid = ceph_decode_64(p);
+	entry->tag_tid = ceph_decode_64(p);
+	/* use kvmalloc to extract the data */
+	entry->data = ceph_extract_encoded_string_kvmalloc(
+		p, end, &entry->data_len, GFP_NOIO);
+	if (IS_ERR(entry->data)) {
+		entry->data = NULL;
+		goto free_entry;
+	}
+
+	crc = crc32c(0, start, *p - start);
+	crc_encoded = ceph_decode_32(p);
+	if (crc != crc_encoded)
+		goto free_entry;
+	return entry;
+
+free_entry:
+	journaler_entry_free(entry);
+err:
+	return NULL;
+}
+
+static int fetch(struct ceph_journaler *journaler, u64 object_num)
+{
+	struct ceph_object_id object_oid;
+	void *read_buf, *end;
+	u64 read_len = 2 << journaler->order;
+	struct ceph_journaler_object_pos *pos;
+	struct object_replayer *obj_replayer;
+	int ret;
+
+	/*
+	 * get the replayer for this splay and set the ->object_num
+	 * of it.
+	 */
+	obj_replayer = &journaler->obj_replayers[object_num % journaler->splay_width];
+	obj_replayer->object_num = object_num;
+	/* find the commit position for this object_num. */
+	list_for_each_entry(pos, &journaler->client->object_positions, node) {
+		if (pos->in_using && pos->object_num == object_num) {
+			/*
+			 * Tell the replayer there is a commit position
+			 * in this object. So delete the entries before
+			 * this position, they are already committed.
+			 */
+			obj_replayer->pos = pos;
+			break;
+		}
+	}
+	/* read the object data */
+	ceph_oid_init(&object_oid);
+	ret = ceph_oid_aprintf(&object_oid, GFP_NOIO, "%s%llu",
+			       journaler->object_oid_prefix, object_num);
+	if (ret) {
+		pr_err("%s: failed to initialize object_id : %d",
+		       __func__, ret);
+		return ret;
+	}
+
+	read_buf = journaler->fetch_buf;
+	ret = ceph_journaler_obj_read_sync(journaler, &object_oid,
+					   &journaler->data_oloc, read_buf, 0,
+					   read_len);
+	if (ret == -ENOENT) {
+		dout("%s: no such object, %s: %d", __func__,
+						  object_oid.name, ret);
+		goto err_free_object_oid;
+	} else if (ret < 0) {
+		pr_err("%s: failed to read object: %s: %d",
+		       __func__, object_oid.name, ret);
+		goto err_free_object_oid;
+	} else if (ret == 0) {
+		pr_err("%s: no data read out from object: %s: %d",
+		       __func__, object_oid.name, ret);
+		goto err_free_object_oid;
+	}
+	/* decode the entries in this object */
+	end = read_buf + ret;
+	while (read_buf < end) {
+		struct ceph_journaler_entry *entry;
+
+		if (!entry_is_readable(journaler, read_buf, end)) {
+			pr_err("%s: entry is not readable.", __func__);
+			ret = -EIO;
+			goto err_free_object_oid;
+		}
+		entry = journaler_entry_decode(&read_buf, end);
+		if (!entry)
+			goto err_free_object_oid;
+		if (entry->tag_tid < journaler->active_tag_tid)
+			journaler_entry_free(entry);
+		else
+			list_add_tail(&entry->node, &obj_replayer->entry_list);
+	}
+	ret = 0;
+
+err_free_object_oid:
+	ceph_oid_destroy(&object_oid);
+	return ret;
+}
+
+static int add_commit_entry(struct ceph_journaler *journaler, u64 commit_tid,
+			    u64 object_num, u64 tag_tid, u64 entry_tid)
+{
+	struct commit_entry *commit_entry;
+
+	commit_entry = kmem_cache_zalloc(journaler_commit_entry_cache, GFP_NOIO);
+	if (!commit_entry)
+		return -ENOMEM;
+
+	RB_CLEAR_NODE(&commit_entry->r_node);
+
+	commit_entry->commit_tid = commit_tid;
+	commit_entry->object_num = object_num;
+	commit_entry->tag_tid = tag_tid;
+	commit_entry->entry_tid = entry_tid;
+
+	mutex_lock(&journaler->commit_lock);
+	insert_commit_entry(&journaler->commit_entries, commit_entry);
+	mutex_unlock(&journaler->commit_lock);
+
+	return 0;
+}
+
+/* journaler->meta_lock held */
+static u64 __allocate_commit_tid(struct ceph_journaler *journaler)
+{
+	lockdep_assert_held(&journaler->meta_lock);
+	return ++journaler->commit_tid;
+}
+
+static u64 allocate_commit_tid(struct ceph_journaler *journaler)
+{
+	u64 commit_tid;
+
+	mutex_lock(&journaler->meta_lock);
+	commit_tid = __allocate_commit_tid(journaler);
+	mutex_unlock(&journaler->meta_lock);
+
+	return commit_tid;
+}
+
+static void prune_tag(struct ceph_journaler *journaler, u64 tag_tid)
+{
+	struct ceph_journaler_entry *entry, *next;
+	struct object_replayer *obj_replayer;
+	int i;
+
+	if (journaler->prune_tag_tid < tag_tid)
+		journaler->prune_tag_tid = tag_tid;
+
+	for (i = 0; i < journaler->splay_width; i++) {
+		obj_replayer = &journaler->obj_replayers[i];
+		list_for_each_entry_safe(entry, next,
+					 &obj_replayer->entry_list, node) {
+			if (entry->tag_tid == tag_tid) {
+				list_del(&entry->node);
+				journaler_entry_free(entry);
+			}
+		}
+	}
+}
+
+static int get_first_entry(struct ceph_journaler *journaler,
+			   struct ceph_journaler_entry **entry, u64 *commit_tid)
+{
+	struct object_replayer *obj_replayer;
+	struct ceph_journaler_entry *tmp_entry;
+	u64 last_entry_tid;
+	bool expect_first_entry = false;
+	int ret;
+
+next:
+	/* find the current replayer. */
+	obj_replayer = &journaler->obj_replayers[journaler->splay_offset];
+	if (list_empty(&obj_replayer->entry_list)) {
+		prune_tag(journaler, journaler->active_tag_tid);
+		if (journaler->splay_offset == 0) {
+			ret = -ENOENT;
+			goto out;
+		} else {
+			journaler->splay_offset = 0;
+			goto next;
+		}
+	}
+
+	/* get the first entry in current replayer */
+	tmp_entry = list_first_entry(&obj_replayer->entry_list,
+				     struct ceph_journaler_entry, node);
+	if (expect_first_entry && tmp_entry->entry_tid != 0) {
+		pr_err("We expect this is the first entry for \
+			next tag. but the entry_tid is: %llu.",
+		       tmp_entry->entry_tid);
+		return -ENOMSG;
+	}
+
+	if (!journaler->active_tag_tid) {
+		/*
+		 * There is no active tag tid. This would happen when
+		 * there is no commit in this journal. But
+		 * we have some uncommitted entries. So set the current
+		 * tag_tid to be the active_tag_tid.
+		 */
+		journaler->active_tag_tid = tmp_entry->tag_tid;
+	} else if (tmp_entry->tag_tid < journaler->active_tag_tid ||
+		    tmp_entry->tag_tid <= journaler->prune_tag_tid) {
+		pr_err("detected stale entry: object_num=%llu, tag_tid=%llu,\
+			entry_tid=%llu.",
+		       obj_replayer->object_num, tmp_entry->tag_tid,
+		       tmp_entry->entry_tid);
+		prune_tag(journaler, tmp_entry->tag_tid);
+		goto next;
+	} else if (tmp_entry->tag_tid > journaler->active_tag_tid) {
+		/*
+		 * found a new tag_tid, which means a new client is starting
+		 * to append journal events. lets prune the old tag
+		 */
+		prune_tag(journaler, journaler->active_tag_tid);
+		if (tmp_entry->entry_tid == 0) {
+			/*
+			 * this is the first entry of new tag client,
+			 * advance the active_tag_tid to the new tag_tid.
+			 */
+			journaler->active_tag_tid = tmp_entry->tag_tid;
+		} else {
+			/*
+			 * each client is appending events from the first
+			 * object (splay_offset: 0). If we found a new tag
+			 * but this is not the first entry (entry_tid: 0),
+			 * let's jump the splay_offset to 0 to get the
+			 * first entry from the new tag client.
+			 */
+			journaler->splay_offset = 0;
+
+			/*
+			 * When we jump splay_offset to 0, we expect to get
+			 * the first entry for a new tag.
+			 */
+			expect_first_entry = true;
+			goto next;
+		}
+	}
+
+	/* Pop this entry from journal */
+	list_del(&tmp_entry->node);
+
+	/* advance the splay_offset */
+	journaler->splay_offset = (journaler->splay_offset + 1) % journaler->splay_width;
+
+	/*
+	 * check entry_tid to make sure this entry_tid is after last_entry_tid
+	 * for the same tag.
+	 */
+	ret = get_last_entry_tid(journaler, tmp_entry->tag_tid,
+				 &last_entry_tid);
+	if (ret && tmp_entry->entry_tid != last_entry_tid + 1) {
+		pr_err("missing prior journal entry, last_entry_tid: %llu",
+		       last_entry_tid);
+		ret = -ENOMSG;
+		goto free_entry;
+	}
+
+	ret = reserve_entry_tid(journaler, tmp_entry->tag_tid,
+				tmp_entry->entry_tid);
+	if (ret)
+		goto free_entry;
+
+	/* allocate commit_tid for this entry */
+	*commit_tid = allocate_commit_tid(journaler);
+	ret = add_commit_entry(journaler, *commit_tid, obj_replayer->object_num,
+			       tmp_entry->tag_tid, tmp_entry->entry_tid);
+	if (ret)
+		goto free_entry;
+
+	/* fetch next object if this object is done. */
+	if (list_empty(&obj_replayer->entry_list)) {
+		ret = fetch(journaler,
+			    obj_replayer->object_num + journaler->splay_width);
+		if (ret && ret != -ENOENT)
+			goto free_entry;
+	}
+
+	*entry = tmp_entry;
+	return 0;
+
+free_entry:
+	journaler_entry_free(tmp_entry);
+out:
+	return ret;
+}
+
+static int process_replay(struct ceph_journaler *journaler)
+{
+	struct ceph_journaler_entry *entry = NULL;
+	u64 commit_tid = 0;
+	int r;
+
+next:
+	/*
+	 * get the first entry from the journal, while there
+	 * are different journal objects.
+	 */
+	r = get_first_entry(journaler, &entry, &commit_tid);
+	if (r) {
+		if (r == -ENOENT)
+			r = 0;
+		return r;
+	}
+
+	BUG_ON(entry == NULL || commit_tid == 0);
+	r = playback_entry(journaler, entry, commit_tid);
+	journaler_entry_free(entry);
+	if (r)
+		return r;
+	goto next;
+}
+
+/* reserve entry tid and delete entries before commit position */
+static int preprocess_replay(struct ceph_journaler *journaler)
+{
+	struct ceph_journaler_entry *entry, *next;
+	bool found_commit = false;
+	struct object_replayer *obj_replayer;
+	int i, ret;
+
+	for (i = 0; i < journaler->splay_width; i++) {
+		obj_replayer = &journaler->obj_replayers[i];
+		/*
+		 * If obj_replayer->pos is NULL, that means
+		 * there is no commit position in this object.
+		 */
+		if (!obj_replayer->pos)
+			continue;
+		found_commit = false;
+		list_for_each_entry_safe(entry, next,
+					 &obj_replayer->entry_list, node) {
+			if (entry->tag_tid == obj_replayer->pos->tag_tid &&
+			    entry->entry_tid == obj_replayer->pos->entry_tid)
+				found_commit = true;
+
+			/* This entry is before commit position, skip it in replaying. */
+			ret = reserve_entry_tid(journaler, entry->tag_tid,
+						entry->entry_tid);
+			if (ret)
+				return ret;
+			list_del(&entry->node);
+			journaler_entry_free(entry);
+
+			if (found_commit)
+				break;
+		}
+	}
+	return 0;
+}
+
+/*
+ * Why do we need to replay?
+ *
+ * Because we append journal firstly before write data objects. So when
+ * a crash happened in last writing, there would be some entries in journal
+ * which means these data is safe, but they are not committed to data
+ * objects. So when we want to open journal again, we need to check the journal
+ * and playback the uncommitted journal.
+ *
+ * Example:
+ *
+ * splay_width: 4
+ *
+ * commit positions:
+ *   [[object_number=2, tag_tid=1, entry_tid=10],
+ *    [object_number=1, tag_tid=1, entry_tid=9],
+ *    [object_number=0, tag_tid=1, entry_tid=8],
+ *    [object_number=3, tag_tid=1, entry_tid=7]]
+ *
+ * journal entries (number means the entry_tid; * means commit position):
+ * object 0: |0|4|8*|12|16|20|
+ * object 1: |1|5|9*|13|17|21|
+ * object 2: |2|6|10*|14|18|
+ * object 3: |3|7*|11|15|19|
+ *
+ * In this case, we need to replay the entries from 11 to 21.
+ *
+ * Step 1: Get the active position and fetch objects.
+ * 	"Active position" means the last committied position, that's the head
+ * 	of commit positions. We need to replay the entries after this position. 
+ *
+ * 	"fetch objects" means the last committed object in each splay. we don't need
+ * 	to replay entries committed, so let's fetch journal from the last committed
+ * 	objects
+ *
+ *	The active position in above example is [object_number=2, tag_tid=1, entry_tid=10].
+ *	The fetch objects in above example is [0, 1, 2, 3]
+ *
+ * Step 2: fetch journal objects.
+ * 	read the data in "fetch objects" ([0, 1, 2, 3]), decode the entries and put
+ * 	them in list of replayer->entry_list.
+ *
+ * 	In above example, the entry_list would be like this:
+ * 	replayer_0->entry_list: 0->4->8*->12->16->20.
+ * 	replayer_1->entry_list: 1->5->9*->13->17->21.
+ * 	replayer_2->entry_list: 2->6->10*->14->18.
+ * 	replayer_3->entry_list: 3->7*->11->15->19.
+ *
+ * Step 3: preprocess the journal entries
+ * 	delete entries before commit position which we dont need to replay,
+ * 	because they are already committed. So after preprocess, the entry_list
+ * 	would be that:
+ *
+ * 	replayer_0->entry_list: 12->16->20.
+ * 	replayer_1->entry_list: 13->17->21.
+ * 	replayer_2->entry_list: 14->18.
+ * 	replayer_3->entry_list: 11->15->19.
+ *
+ * Step 4: process the journal entries
+ * 	replay the entries one by one start from the entry after last commit position.
+ * 	
+ * 	As we know in Step 1, the last commit position is 10, the replay will begin
+ * 	from 11 and end after the last entry 21.
+ */
+int ceph_journaler_start_replay(struct ceph_journaler *journaler)
+{
+	struct ceph_journaler_object_pos *active_pos;
+	u64 *fetch_objects;
+	u64 buf_len = (2 << journaler->order);
+	u64 object_num;
+	int i;
+	int ret = 0;
+
+	if (!journaler->handle_entry || !journaler->entry_handler) {
+		pr_err("Please initialize the handle_entry and entry_handler");
+		return -EINVAL;
+	}
+
+	fetch_objects = kcalloc(journaler->splay_width, sizeof(u64), GFP_NOIO);
+	if (!fetch_objects)
+		return -ENOMEM;
+
+	/* Step 1: Get the active position. */
+	mutex_lock(&journaler->meta_lock);
+	/*
+	 * Get the HEAD of commit positions, that means
+	 * the last committed object position.
+	 */
+	active_pos = list_first_entry(&journaler->client->object_positions,
+				      struct ceph_journaler_object_pos, node);
+	/*
+	 * When there is no commit position in this journal,
+	 * the active_pos would be empty. So skip getting active
+	 * information when active_pos->in_using is false.
+	 */
+	if (active_pos->in_using) {
+		journaler->splay_offset = (active_pos->object_num + 1) % journaler->splay_width;
+		journaler->active_tag_tid = active_pos->tag_tid;
+
+		list_for_each_entry(active_pos,
+				    &journaler->client->object_positions,
+				    node) {
+			if (active_pos->in_using) {
+				fetch_objects[active_pos->object_num %
+					      journaler->splay_width] =
+					active_pos->object_num;
+			}
+		}
+	}
+	mutex_unlock(&journaler->meta_lock);
+
+	/*
+	 * Step 2: fetch journal objects.
+	 * fetch_buf will be used to read every journal object
+	 */
+	journaler->fetch_buf = ceph_kvmalloc(buf_len, GFP_NOIO);
+	if (!journaler->fetch_buf) {
+		pr_err("%s: failed to alloc fetch buf: %llu",
+		       __func__, buf_len);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < journaler->splay_width; i++) {
+		if (fetch_objects[i] == 0) {
+			/*
+			 * No active commit position, so fetch
+			 * them in splay order.
+			 */
+			object_num = i;
+		} else {
+			object_num = fetch_objects[i];
+		}
+		ret = fetch(journaler, object_num);
+		if (ret && ret != -ENOENT)
+			goto free_fetch_buf;
+	}
+
+	/* Step 3: preprocess the journal entries */
+	ret = preprocess_replay(journaler);
+	if (ret)
+		goto free_fetch_buf;
+
+	/* Step 4: process the journal entries */
+	ret = process_replay(journaler);
+
+free_fetch_buf:
+	kvfree(journaler->fetch_buf);
+out:
+	/* cleanup replayers */
+	for (i = 0; i < journaler->splay_width; i++) {
+		struct object_replayer *obj_replayer =
+			&journaler->obj_replayers[i];
+		struct ceph_journaler_entry *entry, *next_entry;
+
+		list_for_each_entry_safe(entry, next_entry,
+					 &obj_replayer->entry_list, node) {
+			list_del(&entry->node);
+			journaler_entry_free(entry);
+		}
+	}
+	kfree(fetch_objects);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_journaler_start_replay);
+
+/* recording*/
+/*
+ * get_new_entry_tid() is called in ceph_journaler_append() with
+ * journaler->meta_lock held. So there is no race to access entry_tids
+ * between different get_new_entry_tid()s 
+ */
+static int get_new_entry_tid(struct ceph_journaler *journaler, u64 tag_tid,
+			     u64 *entry_tid)
+{
+	struct entry_tid *pos;
+
+	lockdep_assert_held(&journaler->meta_lock);
+	list_for_each_entry(pos, &journaler->entry_tids, node) {
+		if (pos->tag_tid == tag_tid) {
+			*entry_tid = pos->entry_tid++;
+			return 0;
+		}
+	}
+
+	pos = entry_tid_alloc(journaler, tag_tid);
+	if (!pos) {
+		pr_err("%s: failed to allocate new entry.", __func__);
+		return -ENOMEM;
+	}
+
+	*entry_tid = pos->entry_tid++;
+
+	return 0;
+}
+
+static u64 get_object(struct ceph_journaler *journaler, u8 splay_offset)
+{
+	return splay_offset + (journaler->splay_width * journaler->active_set);
+}
+
+static void future_init(struct ceph_journaler_future *future, u64 tag_tid,
+			u64 entry_tid, u64 commit_tid,
+			struct ceph_journaler_ctx *journaler_ctx)
+{
+	future->tag_tid = tag_tid;
+	future->entry_tid = entry_tid;
+	future->commit_tid = commit_tid;
+
+	spin_lock_init(&future->lock);
+	future->safe = false;
+	future->consistent = false;
+	future->result = 0;
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
+	if (prev_future_finished)
+		future->consistent = true;
+	spin_unlock(&future->lock);
+
+	journaler->prev_future = future;
+}
+
+static void entry_init(struct ceph_journaler_entry *entry, u64 tag_tid,
+		       u64 entry_tid, struct ceph_journaler_ctx *journaler_ctx)
+{
+	entry->tag_tid = tag_tid;
+	entry->entry_tid = entry_tid;
+	entry->data_len = journaler_ctx->bio_len + journaler_ctx->prefix_len +
+			  journaler_ctx->suffix_len;
+}
+
+static void journaler_entry_encode_prefix(struct ceph_journaler_entry *entry,
+					  void **p, void *end)
+{
+	ceph_encode_64(p, PREAMBLE);
+	ceph_encode_8(p, 1); /* version */
+	ceph_encode_64(p, entry->entry_tid);
+	ceph_encode_64(p, entry->tag_tid);
+
+	ceph_encode_32(p, entry->data_len);
+}
+
+static u32 crc_bio(u32 crc_in, struct ceph_bio_iter *bio_iter, u64 length)
+{
+	struct ceph_bio_iter it = *bio_iter;
+	char *buf;
+	u64 len;
+	u32 crc = crc_in;
+
+	ceph_bio_iter_advance_step(&it, length, ({
+		buf = page_address(bv.bv_page) + bv.bv_offset;
+		len = min_t(u64, length, bv.bv_len);
+		crc = crc32c(crc, buf, len);
+	}));
+
+	return crc;
+}
+
+static void journaler_handle_append(struct journaler_append_ctx *ctx, int ret);
+static void future_consistent(struct journaler_append_ctx *append_ctx,
+			      int result)
+{
+	struct ceph_journaler_future *future = &append_ctx->future;
+	bool future_finished = false;
+
+	spin_lock(&future->lock);
+	if (!future->result)
+		future->result = result;
+	future->consistent = true;
+	future_finished = (future->safe && future->consistent);
+	spin_unlock(&future->lock);
+
+	if (future_finished) {
+		append_ctx->state = JOURNALER_APPEND_FINISH;
+		journaler_handle_append(append_ctx, 0);
+	}
+}
+
+static void future_finish(struct journaler_append_ctx *append_ctx)
+{
+	struct ceph_journaler *journaler = append_ctx->journaler;
+	struct ceph_journaler_ctx *journaler_ctx = &append_ctx->journaler_ctx;
+	struct ceph_journaler_future *future = &append_ctx->future;
+
+	mutex_lock(&journaler->meta_lock);
+	if (journaler->prev_future == future)
+		journaler->prev_future = NULL;
+	mutex_unlock(&journaler->meta_lock);
+
+	spin_lock(&journaler->finish_lock);
+	if (journaler_ctx->result == 0)
+		journaler_ctx->result = future->result;
+	list_add_tail(&append_ctx->node, &journaler->finish_list);
+	spin_unlock(&journaler->finish_lock);
+
+	queue_work(journaler->task_wq, &journaler->finish_work);
+}
+
+static void journaler_append_finish(struct work_struct *work)
+{
+	struct ceph_journaler *journaler =
+		container_of(work, struct ceph_journaler, finish_work);
+	struct journaler_append_ctx *ctx_pos, *next;
+	LIST_HEAD(tmp_list);
+
+	spin_lock(&journaler->finish_lock);
+	list_splice_init(&journaler->finish_list, &tmp_list);
+	spin_unlock(&journaler->finish_lock);
+
+	list_for_each_entry_safe(ctx_pos, next, &tmp_list, node) {
+		list_del(&ctx_pos->node);
+		if (ctx_pos->future.wait)
+			future_consistent(ctx_pos->future.wait,
+					  ctx_pos->future.result);
+		ctx_pos->journaler_ctx.callback(&ctx_pos->journaler_ctx);
+	}
+}
+
+static void journaler_notify_update(struct work_struct *work)
+{
+	struct ceph_journaler *journaler =
+		container_of(work, struct ceph_journaler, notify_update_work);
+	int ret = 0;
+
+	ret = ceph_osdc_notify(journaler->osdc, &journaler->header_oid,
+			       &journaler->header_oloc, NULL, 0,
+			       JOURNALER_NOTIFY_TIMEOUT, NULL, NULL);
+	if (ret)
+		pr_err("%s: notify_update failed: %d", __func__, ret);
+}
+
+/*
+ * advance the active_set to (active_set + 1). This function
+ * will call ceph_cls_journal_set_active_set to update journal
+ * metadata and notify all clients about this event. We don't
+ * update journaler->active_set in memory currently.
+ *
+ * The journaler->active_set will be updated in refresh() when
+ * we get the notification.
+ */
+static void advance_object_set(struct ceph_journaler *journaler)
+{
+	struct object_recorder *obj_recorder;
+	u64 active_set;
+	int i, ret;
+
+	mutex_lock(&journaler->meta_lock);
+	if (journaler->advancing || journaler->flushing) {
+		mutex_unlock(&journaler->meta_lock);
+		return;
+	}
+	mutex_unlock(&journaler->meta_lock);
+
+	/* make sure all inflight appending finish */
+	for (i = 0; i < journaler->splay_width; i++) {
+		obj_recorder = &journaler->obj_recorders[i];
+		spin_lock(&obj_recorder->lock);
+		if (obj_recorder->inflight_append) {
+			spin_unlock(&obj_recorder->lock);
+			return;
+		}
+		spin_unlock(&obj_recorder->lock);
+	}
+
+	mutex_lock(&journaler->meta_lock);
+	journaler->advancing = true;
+
+	active_set = journaler->active_set + 1;
+	mutex_unlock(&journaler->meta_lock);
+
+	ret = ceph_cls_journal_set_active_set(journaler->osdc,
+					      &journaler->header_oid,
+					      &journaler->header_oloc,
+					      active_set);
+	if (ret)
+		pr_err("%s: error in set active_set: %d", __func__, ret);
+
+	queue_work(journaler->task_wq, &journaler->notify_update_work);
+}
+
+static void journaler_overflow(struct work_struct *work)
+{
+	struct ceph_journaler *journaler =
+		container_of(work, struct ceph_journaler, overflow_work);
+	if (!journaler->overflowed)
+		return;
+
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
+static int append(struct ceph_journaler *journaler, struct ceph_object_id *oid,
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
+	/*
+	 * guard_append
+	 * TODO: to make the prefix, suffix and guard_append to share page.
+	 */
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
+	osd_req_op_cls_request_data_pages(req, 0, &ctx->req_page, 8, 0, false,
+					  false);
+
+	/* append_data */
+	osd_req_op_extent_init(req, 1, CEPH_OSD_OP_APPEND, 0,
+			       ctx->journaler_ctx.prefix_len +
+				       ctx->journaler_ctx.bio_len +
+				       ctx->journaler_ctx.suffix_len,
+			       0, 0);
+
+	if (ctx->journaler_ctx.prefix_len)
+		osd_req_op_extent_prefix_pages(req, 1,
+					       &ctx->journaler_ctx.prefix_page,
+					       ctx->journaler_ctx.prefix_len,
+					       ctx->journaler_ctx.prefix_offset,
+					       false, false);
+
+	if (ctx->journaler_ctx.bio_len)
+		osd_req_op_extent_osd_data_bio(req, 1,
+					       &ctx->journaler_ctx.bio_iter,
+					       ctx->journaler_ctx.bio_len);
+
+	if (ctx->journaler_ctx.suffix_len)
+		osd_req_op_extent_suffix_pages(req, 1,
+					       &ctx->journaler_ctx.suffix_page,
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
+static int send_append_request(struct ceph_journaler *journaler, u64 object_num,
+			       struct journaler_append_ctx *ctx)
+{
+	struct ceph_object_id object_oid;
+	int ret = 0;
+
+	ceph_oid_init(&object_oid);
+	ret = ceph_oid_aprintf(&object_oid, GFP_NOIO, "%s%llu",
+			       journaler->object_oid_prefix, object_num);
+	if (ret) {
+		pr_err("%s: failed to initialize object id: %d", __func__, ret);
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
+	struct ceph_journaler *journaler =
+		container_of(work, struct ceph_journaler, flush_work);
+	int i;
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
+			ctx->object_num = get_object(
+				journaler, obj_recorder->splay_offset);
+			journaler_handle_append(ctx, 0);
+		}
+	}
+
+	mutex_lock(&journaler->meta_lock);
+	journaler->flushing = false;
+	mutex_unlock(&journaler->meta_lock);
+	/*
+	 * As we don't do advance in flushing, so queue another overflow_work
+	 * after flushing finished if we journaler is overflowed.
+	 */
+	queue_work(journaler->task_wq, &journaler->overflow_work);
+}
+
+static void
+ceph_journaler_object_append(struct ceph_journaler *journaler,
+			     struct journaler_append_ctx *append_ctx)
+{
+	void *buf, *end;
+	u32 crc = 0;
+	struct ceph_journaler_ctx *journaler_ctx = &append_ctx->journaler_ctx;
+	struct ceph_bio_iter *bio_iter = &journaler_ctx->bio_iter;
+	struct object_recorder *obj_recorder;
+
+	/*
+	 * PEAMBLE(8) + version(1) + entry_tid(8)
+	 * + tag_tid(8) + string_len(4) = 29
+	 */
+	journaler_ctx->prefix_offset -= 29;
+	journaler_ctx->prefix_len += 29;
+	buf = page_address(journaler_ctx->prefix_page) +
+	      journaler_ctx->prefix_offset;
+	end = buf + 29;
+	journaler_entry_encode_prefix(&append_ctx->entry, &buf, end);
+
+	/* size of crc is 4 */
+	buf = page_address(journaler_ctx->suffix_page) + journaler_ctx->suffix_len;
+	end = buf + 4;
+	crc = crc32c(crc,
+		     page_address(journaler_ctx->prefix_page) +
+			     journaler_ctx->prefix_offset,
+		     journaler_ctx->prefix_len);
+	if (journaler_ctx->bio_len)
+		crc = crc_bio(crc, bio_iter, journaler_ctx->bio_len);
+	crc = crc32c(crc,
+		     page_address(journaler_ctx->suffix_page),
+		     journaler_ctx->suffix_len);
+	ceph_encode_32(&buf, crc);
+	journaler_ctx->suffix_len += 4;
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
+	struct object_recorder *obj_recorder =
+		&journaler->obj_recorders[ctx->splay_offset];
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
+			ctx->state = JOURNALER_APPEND_SAFE;
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
+				queue_work(journaler->task_wq,
+					   &journaler->overflow_work);
+			spin_unlock(&obj_recorder->lock);
+			break;
+		}
+
+		spin_lock(&obj_recorder->lock);
+		if (--obj_recorder->inflight_append == 0)
+			queue_work(journaler->task_wq,
+				   &journaler->overflow_work);
+		spin_unlock(&obj_recorder->lock);
+
+		if (ret) {
+			/*
+			 * If ret is not 0, we need to tell the
+			 * upper caller the result.
+			 */
+			ctx->state = JOURNALER_APPEND_SAFE;
+			goto again;
+		}
+
+		ret = add_commit_entry(journaler, ctx->future.commit_tid,
+				       ctx->object_num, ctx->future.tag_tid,
+				       ctx->future.entry_tid);
+		if (ret) {
+			pr_err("%s: failed to add_commit_entry: %d",
+			       __func__, ret);
+			ctx->state = JOURNALER_APPEND_SAFE;
+			ret = -ENOMEM;
+			goto again;
+		}
+		ctx->state = JOURNALER_APPEND_SAFE;
+		goto again;
+	case JOURNALER_APPEND_OVERFLOW:
+		ctx->state = JOURNALER_APPEND_SEND;
+		goto again;
+	case JOURNALER_APPEND_SAFE:
+		spin_lock(&ctx->future.lock);
+		ctx->future.safe = true;
+		if (!ctx->future.result)
+			ctx->future.result = ret;
+		if (ctx->future.consistent) {
+			spin_unlock(&ctx->future.lock);
+			ctx->state = JOURNALER_APPEND_FINISH;
+			goto again;
+		}
+		spin_unlock(&ctx->future.lock);
+		break;
+	case JOURNALER_APPEND_FINISH:
+		future_finish(ctx);
+		break;
+	default:
+		BUG();
+	}
+}
+
+/* journaler_append_ctx alloc and release */
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
+	INIT_LIST_HEAD(&journaler_ctx->node);
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
+static void journaler_append_ctx_free(struct journaler_append_ctx *append_ctx)
+{
+	struct ceph_journaler_ctx *journaler_ctx;
+
+	journaler_ctx = &append_ctx->journaler_ctx;
+	__free_page(journaler_ctx->prefix_page);
+	__free_page(journaler_ctx->suffix_page);
+	kmem_cache_free(journaler_append_ctx_cache, append_ctx);
+}
+
+void ceph_journaler_ctx_free(struct ceph_journaler_ctx *journaler_ctx)
+{
+	struct journaler_append_ctx *append_ctx;
+
+	append_ctx = container_of(journaler_ctx, struct journaler_append_ctx,
+				  journaler_ctx);
+	journaler_append_ctx_free(append_ctx);
+}
+EXPORT_SYMBOL(ceph_journaler_ctx_free);
+
+int ceph_journaler_append(struct ceph_journaler *journaler, u64 tag_tid,
+			  struct ceph_journaler_ctx *journaler_ctx)
+{
+	u64 entry_tid;
+	struct journaler_append_ctx *append_ctx;
+	int ret;
+
+	append_ctx = container_of(journaler_ctx, struct journaler_append_ctx,
+				  journaler_ctx);
+
+	append_ctx->journaler = journaler;
+	mutex_lock(&journaler->meta_lock);
+	/*
+	 * get entry_tid for this event. (tag_tid, entry_tid) is
+	 * the uniq id for every journal event.
+	 */
+	ret = get_new_entry_tid(journaler, tag_tid, &entry_tid);
+	if (ret) {
+		mutex_unlock(&journaler->meta_lock);
+		return ret;
+	}
+
+	/* calculate the object_num for this entry. */
+	append_ctx->splay_offset = entry_tid % journaler->splay_width;
+	append_ctx->object_num =
+		get_object(journaler, append_ctx->splay_offset);
+
+	/*
+	 * allocate a commit_tid for this event, when the data is committed
+	 * to data objects, ceph_journaler_client_committed() will accept
+	 * the commit_tid to understand how to update journal commit position.
+	 */
+	journaler_ctx->commit_tid = __allocate_commit_tid(journaler);
+	entry_init(&append_ctx->entry, tag_tid, entry_tid, journaler_ctx);
+
+	/*
+	 * To make sure the journal entry is consistent, we use future
+	 * to track it. And every journal entry depent on the previous
+	 * entry. Only if the previous entry is finished, current entry
+	 * could be consistent. and then we can finish current entry. 
+	 */
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
+static void copy_object_pos(struct ceph_journaler_object_pos *src_pos,
+			    struct ceph_journaler_object_pos *dst_pos)
+{
+	dst_pos->object_num = src_pos->object_num;
+	dst_pos->tag_tid = src_pos->tag_tid;
+	dst_pos->entry_tid = src_pos->entry_tid;
+}
+
+static void copy_pos_list(struct list_head *src_list,
+			  struct list_head *dst_list)
+{
+	struct ceph_journaler_object_pos *src_pos, *dst_pos;
+
+	src_pos = list_first_entry(src_list, struct ceph_journaler_object_pos,
+				   node);
+	dst_pos = list_first_entry(dst_list, struct ceph_journaler_object_pos,
+				   node);
+	while (&src_pos->node != src_list && &dst_pos->node != dst_list) {
+		copy_object_pos(src_pos, dst_pos);
+		src_pos = list_next_entry(src_pos, node);
+		dst_pos = list_next_entry(dst_pos, node);
+	}
+}
+
+static void journaler_client_commit(struct work_struct *work)
+{
+	struct ceph_journaler *journaler = container_of(
+		to_delayed_work(work), struct ceph_journaler, commit_work);
+	int ret;
+
+	mutex_lock(&journaler->commit_lock);
+	copy_pos_list(&journaler->obj_pos_pending,
+		      &journaler->obj_pos_committing);
+	mutex_unlock(&journaler->commit_lock);
+
+	ret = ceph_cls_journal_client_committed(journaler->osdc,
+						&journaler->header_oid,
+						&journaler->header_oloc,
+						journaler->client,
+						&journaler->obj_pos_committing);
+
+	if (ret)
+		pr_err("%s: error in client committed: %d", __func__, ret);
+
+	queue_work(journaler->task_wq, &journaler->notify_update_work);
+
+	mutex_lock(&journaler->commit_lock);
+	journaler->commit_scheduled = false;
+	mutex_unlock(&journaler->commit_lock);
+}
+
+static void add_object_position(struct commit_entry *entry,
+				struct list_head *object_positions,
+				u64 splay_width)
+{
+	struct ceph_journaler_object_pos *position;
+	u8 splay_offset = entry->object_num % splay_width;
+	bool found = false;
+
+	list_for_each_entry(position, object_positions, node) {
+		if (position->in_using == false ||
+		    (splay_offset == position->object_num % splay_width)) {
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
+void ceph_journaler_client_committed(struct ceph_journaler *journaler,
+				     u64 commit_tid)
+{
+	struct commit_entry *commit_entry;
+	bool update_client_commit = true;
+	struct rb_node *n;
+
+	mutex_lock(&journaler->commit_lock);
+	/* search commit entries in commit_tid order. */
+	for (n = rb_first(&journaler->commit_entries); n; n = rb_next(n)) {
+		commit_entry = rb_entry(n, struct commit_entry, r_node);
+		/* set current commit entry to be committed. */
+		if (commit_entry->commit_tid == commit_tid) {
+			commit_entry->committed = true;
+			break;
+		}
+		/*
+		 * if there is any one entry before commit_tid is not committed,
+		 * we dont need to update_client_commit.
+		 */
+		if (commit_entry->committed == false)
+			update_client_commit = false;
+	}
+
+	/*
+	 * update_client_commit when the all commit entries before this commit_tid
+	 * are all committed.
+	 */
+	if (update_client_commit) {
+		for (n = rb_first(&journaler->commit_entries); n;) {
+			commit_entry = rb_entry(n, struct commit_entry, r_node);
+			n = rb_next(n);
+
+			if (commit_entry->commit_tid > commit_tid)
+				break;
+			add_object_position(commit_entry,
+					    &journaler->obj_pos_pending,
+					    journaler->splay_width);
+			erase_commit_entry(&journaler->commit_entries,
+					   commit_entry);
+			kmem_cache_free(journaler_commit_entry_cache,
+					commit_entry);
+		}
+	}
+
+	/*
+	 * schedule commit_work to call ceph_cls_journal_client_committed()
+	 * after JOURNALER_COMMIT_INTERVAL
+	 */
+	if (update_client_commit && !journaler->commit_scheduled) {
+		queue_delayed_work(journaler->task_wq, &journaler->commit_work,
+				   JOURNALER_COMMIT_INTERVAL);
+		journaler->commit_scheduled = true;
+	}
+	mutex_unlock(&journaler->commit_lock);
+}
+EXPORT_SYMBOL(ceph_journaler_client_committed);
+
+/*
+ * client need to allocate an uniq tag for itself, then every
+ * journaler entry from this client will be tagged as his tag.
+ */
+int ceph_journaler_allocate_tag(struct ceph_journaler *journaler, u64 tag_class,
+				void *buf, u32 buf_len,
+				struct ceph_journaler_tag *tag)
+{
+	u64 tag_tid;
+	int ret;
+
+retry:
+	ret = ceph_cls_journal_get_next_tag_tid(journaler->osdc,
+						&journaler->header_oid,
+						&journaler->header_oloc,
+						&tag_tid);
+	if (ret)
+		goto out;
+
+	ret = ceph_cls_journal_tag_create(journaler->osdc,
+					  &journaler->header_oid,
+					  &journaler->header_oloc, tag_tid,
+					  tag_class, buf, buf_len);
+	if (ret < 0) {
+		if (ret == -ESTALE)
+			goto retry;
+		else
+			goto out;
+	}
+
+	ret = ceph_cls_journal_get_tag(journaler->osdc, &journaler->header_oid,
+				       &journaler->header_oloc, tag_tid, tag);
+	if (ret)
+		goto out;
+
+out:
+	return ret;
+}
+EXPORT_SYMBOL(ceph_journaler_allocate_tag);
+
+int ceph_journaler_get_cached_client(
+	struct ceph_journaler *journaler, char *client_id,
+	struct ceph_journaler_client **client_result)
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
+
+static int refresh(struct ceph_journaler *journaler, bool init)
+{
+	struct ceph_journaler_client *client;
+	u64 minimum_commit_set;
+	u64 minimum_set;
+	u64 active_set;
+	bool need_advance = false;
+	LIST_HEAD(tmp_clients);
+	int ret;
+
+	INIT_LIST_HEAD(&tmp_clients);
+	ret = ceph_cls_journal_get_mutable_metas(journaler->osdc,
+						 &journaler->header_oid,
+						 &journaler->header_oloc,
+						 &minimum_set, &active_set);
+	if (ret)
+		return ret;
+
+	ret = ceph_cls_journal_client_list(journaler->osdc,
+					   &journaler->header_oid,
+					   &journaler->header_oloc,
+					   &journaler->clients_cache,
+					   journaler->splay_width);
+	if (ret)
+		return ret;
+
+	mutex_lock(&journaler->meta_lock);
+	if (!init) {
+		/* check for advance active_set. */
+		need_advance = active_set > journaler->active_set;
+		if (need_advance) {
+			journaler->overflowed = false;
+			journaler->advancing = false;
+		}
+	}
+
+	journaler->active_set = active_set;
+	journaler->minimum_set = minimum_set;
+	/*
+	 * swap clients with clients_cache. clients in client_cache list is not
+	 * released, then we can reuse them in next refresh() to avoid malloc() and
+	 * free() too frequently.
+	 */
+	list_splice_tail_init(&journaler->clients, &tmp_clients);
+	list_splice_tail_init(&journaler->clients_cache, &journaler->clients);
+	list_splice_tail_init(&tmp_clients, &journaler->clients_cache);
+
+	/*
+	 * calculate the minimum_commit_set.
+	 * TODO: unregister clients if the commit position is too long behind
+	 * active positions. similar with rbd_journal_max_concurrent_object_sets
+	 * in user space journal.
+	 */
+	minimum_commit_set = journaler->active_set;
+	list_for_each_entry(client, &journaler->clients, node) {
+		struct ceph_journaler_object_pos *pos;
+
+		list_for_each_entry(pos, &client->object_positions, node) {
+			u64 object_set =
+				pos->object_num / journaler->splay_width;
+			if (object_set < minimum_commit_set)
+				minimum_commit_set = object_set;
+		}
+
+		if (!strcmp(client->id, journaler->client_id))
+			journaler->client = client;
+	}
+	mutex_unlock(&journaler->meta_lock);
+
+	/*
+	 * At this time, the active_set is actually advanced,
+	 * we can flush now.
+	 */
+	if (need_advance)
+		queue_work(journaler->task_wq, &journaler->flush_work);
+
+	/*
+	 * remove set if necessary
+	 */
+	if (minimum_commit_set > minimum_set) {
+		u64 trim_set = minimum_set;
+		while (trim_set < minimum_commit_set) {
+			ret = remove_set(journaler, trim_set);
+			if (ret < 0 && ret != -ENOENT) {
+				pr_err("failed to trim object_set: %llu",
+				       trim_set);
+				return ret;
+			}
+			trim_set++;
+		}
+
+		ret = set_minimum_set(journaler, minimum_commit_set);
+		if (ret < 0) {
+			pr_err("failed to set minimum set to %llu",
+			       minimum_commit_set);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void journaler_watch_cb(void *arg, u64 notify_id, u64 cookie,
+			       u64 notifier_id, void *data, size_t data_len)
+{
+	struct ceph_journaler *journaler = arg;
+	int ret;
+
+	ret = refresh(journaler, false);
+	if (ret < 0)
+		pr_err("%s: failed to refresh journaler: %d", __func__, ret);
+
+	ret = ceph_osdc_notify_ack(journaler->osdc, &journaler->header_oid,
+				   &journaler->header_oloc, notify_id, cookie,
+				   NULL, 0);
+	if (ret)
+		pr_err("%s: acknowledge_notify failed: %d", __func__, ret);
+}
+
+static void journaler_watch_errcb(void *arg, u64 cookie, int err)
+{
+	/* TODO re-watch in watch error. */
+	pr_err("%s: journaler watch error: %d", __func__, err);
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
+int ceph_journaler_open(struct ceph_journaler *journaler)
+{
+	struct ceph_journaler_client *client, *next_client;
+	u8 order, splay_width;
+	int64_t pool_id;
+	int i, ret;
+
+	ret = ceph_cls_journal_get_immutable_metas(
+		journaler->osdc, &journaler->header_oid,
+		&journaler->header_oloc, &order, &splay_width, &pool_id);
+	if (ret) {
+		pr_err("failed to get immutable metas.");
+		goto out;
+	}
+
+	mutex_lock(&journaler->meta_lock);
+	/* set the immutable metas. */
+	journaler->order = order;
+	journaler->splay_width = splay_width;
+
+	if (pool_id == -1 || pool_id == journaler->header_oloc.pool)
+		ceph_oloc_copy(&journaler->data_oloc, &journaler->header_oloc);
+	else
+		journaler->data_oloc.pool = pool_id;
+
+	/* initialize ->obj_recorders and ->obj_replayers. */
+	journaler->obj_recorders =
+		kcalloc(journaler->splay_width, sizeof(struct object_recorder),
+			GFP_NOIO);
+	if (!journaler->obj_recorders) {
+		mutex_unlock(&journaler->meta_lock);
+		goto out;
+	}
+
+	journaler->obj_replayers =
+		kcalloc(journaler->splay_width, sizeof(struct object_replayer),
+			GFP_NOIO);
+	if (!journaler->obj_replayers) {
+		mutex_unlock(&journaler->meta_lock);
+		goto free_recorders;
+	}
+
+	journaler->obj_pos_pending_array =
+		kcalloc(journaler->splay_width,
+			sizeof(struct ceph_journaler_object_pos), GFP_NOIO);
+	if (!journaler->obj_pos_pending_array) {
+		mutex_unlock(&journaler->meta_lock);
+		goto free_replayers;
+	}
+
+	journaler->obj_pos_committing_array =
+		kcalloc(journaler->splay_width,
+			sizeof(struct ceph_journaler_object_pos), GFP_NOIO);
+	if (!journaler->obj_pos_committing_array) {
+		mutex_unlock(&journaler->meta_lock);
+		goto free_pos_pending;
+	}
+
+	for (i = 0; i < journaler->splay_width; i++) {
+		struct object_recorder *obj_recorder =
+			&journaler->obj_recorders[i];
+		struct object_replayer *obj_replayer =
+			&journaler->obj_replayers[i];
+		struct ceph_journaler_object_pos *pos_pending =
+			&journaler->obj_pos_pending_array[i];
+		struct ceph_journaler_object_pos *pos_committing =
+			&journaler->obj_pos_committing_array[i];
+
+		spin_lock_init(&obj_recorder->lock);
+		obj_recorder->splay_offset = i;
+		obj_recorder->inflight_append = 0;
+		INIT_LIST_HEAD(&obj_recorder->append_list);
+		INIT_LIST_HEAD(&obj_recorder->overflow_list);
+
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
+		list_add_tail(&pos_committing->node,
+			      &journaler->obj_pos_committing);
+	}
+	mutex_unlock(&journaler->meta_lock);
+
+	ret = refresh(journaler, true);
+	if (ret)
+		goto free_pos_committing;
+
+	mutex_lock(&journaler->meta_lock);
+	if (journaler->client) {
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
+	list_for_each_entry_safe(client, next_client, &journaler->clients,
+				 node) {
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
+void ceph_journaler_close(struct ceph_journaler *journaler)
+{
+	struct ceph_journaler_client *client, *next;
+	struct commit_entry *commit_entry;
+	struct entry_tid *entry_tid, *entry_tid_next;
+	struct ceph_journaler_object_pos *pos, *next_pos;
+	struct rb_node *n;
+	int i;
+
+	/* Stop watching and flush pending linger work */
+	journaler_unwatch(journaler);
+	flush_workqueue(journaler->notify_wq);
+
+	/* As we are closing journal, there should not
+	 * be any pending ->flush_work,->overflow_work and finish_work.
+	 */
+	flush_delayed_work(&journaler->commit_work);
+	flush_work(&journaler->notify_update_work);
+	list_for_each_entry_safe(pos, next_pos,
+				 &journaler->obj_pos_pending, node)
+		list_del(&pos->node);
+
+	list_for_each_entry_safe(pos, next_pos,
+				 &journaler->obj_pos_committing, node)
+		list_del(&pos->node);
+
+	journaler->client = NULL;
+	list_for_each_entry_safe(client, next, &journaler->clients, node) {
+		list_del(&client->node);
+		destroy_client(client);
+	}
+	list_for_each_entry_safe(client, next, &journaler->clients_cache,
+				 node) {
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
+		       !list_empty(&obj_recorder->overflow_list));
+		spin_unlock(&obj_recorder->lock);
+
+		BUG_ON(!list_empty(&obj_replayer->entry_list));
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
+	return;
+}
+EXPORT_SYMBOL(ceph_journaler_close);
+
+struct ceph_journaler *ceph_journaler_create(struct ceph_osd_client *osdc,
+					     struct ceph_object_locator *oloc,
+					     const char *journal_id,
+					     const char *client_id)
+{
+	struct ceph_journaler *journaler;
+	ssize_t len;
+	int ret;
+
+	journaler = kzalloc(sizeof(*journaler), GFP_NOIO);
+	if (!journaler)
+		return NULL;
+
+	journaler->osdc = osdc;
+	ceph_oid_init(&journaler->header_oid);
+	ret = ceph_oid_aprintf(&journaler->header_oid, GFP_NOIO, "%s%s",
+			       JOURNAL_HEADER_PREFIX, journal_id);
+	if (ret) {
+		pr_err("aprintf error : %d", ret);
+		goto err_free_journaler;
+	}
+
+	ceph_oloc_init(&journaler->header_oloc);
+	ceph_oloc_copy(&journaler->header_oloc, oloc);
+	ceph_oloc_init(&journaler->data_oloc);
+
+	/* Init object_oid_prefix */
+	len = snprintf(NULL, 0, "%s%lld.%s.", JOURNAL_OBJECT_PREFIX,
+		       journaler->header_oloc.pool, journal_id);
+	journaler->object_oid_prefix = kzalloc(len + 1, GFP_NOIO);
+	if (!journaler->object_oid_prefix)
+		goto err_destroy_data_oloc;
+
+	ret = snprintf(journaler->object_oid_prefix, len + 1, "%s%lld.%s.",
+		       JOURNAL_OBJECT_PREFIX, journaler->header_oloc.pool,
+		       journal_id);
+	if (ret != len) {
+		WARN_ON(1);
+		goto err_free_object_oid_prefix;
+	}
+
+	journaler->client_id = kstrdup(client_id, GFP_NOIO);
+	if (!journaler->client_id) {
+		ret = -ENOMEM;
+		goto err_free_object_oid_prefix;
+	}
+
+	mutex_init(&journaler->meta_lock);
+	mutex_init(&journaler->commit_lock);
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
+	journaler->task_wq =
+		alloc_ordered_workqueue("journaler-tasks", WQ_MEM_RECLAIM);
+	if (!journaler->task_wq)
+		goto err_destroy_append_ctx_cache;
+	journaler->notify_wq =
+		create_singlethread_workqueue("journaler-notify");
+	if (!journaler->notify_wq)
+		goto err_destroy_task_wq;
+
+	INIT_WORK(&journaler->flush_work, journaler_flush);
+	INIT_WORK(&journaler->finish_work, journaler_append_finish);
+	INIT_DELAYED_WORK(&journaler->commit_work, journaler_client_commit);
+	INIT_WORK(&journaler->notify_update_work, journaler_notify_update);
+	INIT_WORK(&journaler->overflow_work, journaler_overflow);
+
+	return journaler;
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
-- 
1.8.3.1



Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD541788BD
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2019 11:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbfG2Jny (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Jul 2019 05:43:54 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22649 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbfG2Jnx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Jul 2019 05:43:53 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowADHYpWjvz5djxunAA--.901S9;
        Mon, 29 Jul 2019 17:43:01 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v3 07/15] libceph: journaling: introduce api to replay uncommitted journal events
Date:   Mon, 29 Jul 2019 09:42:49 +0000
Message-Id: <1564393377-28949-8-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowADHYpWjvz5djxunAA--.901S9
X-Coremail-Antispam: 1Uf129KBjvAXoWfXryrJw4xZFW7KF1rur4rXwb_yoW8uF1UJo
        Z7ZF45C3W5G345ZFyxKr1kW34fXa4UGayrJr4aqFWY93Z3Ary093yxCr15J34Yyr4Y9rWD
        Xws7Jw1Sqw4DAa45n29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjfUp-z3UUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiVwUBelf4pUwc3AAAsv
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When we are going to make sure the data and journal are consistent in opening
journal, we can call the api of start_replay() to replay the all events recorded
but not committed.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 net/ceph/journaler.c | 693 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 693 insertions(+)

diff --git a/net/ceph/journaler.c b/net/ceph/journaler.c
index 1b04d3f..3e92e96 100644
--- a/net/ceph/journaler.c
+++ b/net/ceph/journaler.c
@@ -594,3 +594,696 @@ int ceph_journaler_get_cached_client(struct ceph_journaler *journaler, char *cli
 	return ret;
 }
 EXPORT_SYMBOL(ceph_journaler_get_cached_client);
+
+// replaying
+static int ceph_journaler_obj_read_sync(struct ceph_journaler *journaler,
+			     struct ceph_object_id *oid,
+			     struct ceph_object_locator *oloc,
+			     void *buf, uint32_t read_off, uint64_t buf_len)
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
+	osd_req_op_extent_init(req, 0, CEPH_OSD_OP_READ, read_off, buf_len, 0, 0);
+	osd_req_op_extent_osd_data_pages(req, 0, pages, buf_len, 0, false,
+					 true);
+
+	ret = ceph_osdc_alloc_messages(req, GFP_NOIO);
+	if (ret)
+		goto out_req;
+
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
+			      void *end, uint32_t *bytes_needed)
+{
+	/// preamble, version, entry tid, tag id
+	const uint32_t HEADER_FIXED_SIZE = 25;
+	uint32_t remaining = end - buf;
+	uint64_t preamble;
+	uint32_t data_size;
+	void *origin_buf = buf;
+	uint32_t crc, crc_encoded;
+
+	if (remaining < HEADER_FIXED_SIZE) {
+		*bytes_needed = HEADER_FIXED_SIZE - remaining;
+		return false;
+	}
+
+	preamble = ceph_decode_64(&buf);
+	if (PREAMBLE != preamble) {
+		*bytes_needed = 0;
+		return false;
+	}
+
+	buf += (HEADER_FIXED_SIZE - sizeof(preamble));
+	remaining = end - buf;
+	if (remaining < sizeof(uint32_t)) {
+		*bytes_needed = sizeof(uint32_t) - remaining;
+		return false;
+	}
+
+	data_size = ceph_decode_32(&buf);
+	remaining = end - buf;
+	if (remaining < data_size) {
+		*bytes_needed = data_size - remaining;
+		return false;
+	}
+
+	buf += data_size;
+	
+	remaining = end - buf;
+	if (remaining < sizeof(uint32_t)) {
+		*bytes_needed = sizeof(uint32_t) - remaining;
+		return false;
+	}
+
+	*bytes_needed = 0;
+	crc = crc32c(0, origin_buf, buf - origin_buf);
+	crc_encoded = ceph_decode_32(&buf);
+	if (crc != crc_encoded) {
+		pr_err("crc corrupted");
+		return false;
+	}
+	return true;
+}
+
+static int playback_entry(struct ceph_journaler *journaler,
+			  struct ceph_journaler_entry *entry,
+			  uint64_t commit_tid)
+{
+	BUG_ON(!journaler->handle_entry || !journaler->entry_handler);
+
+	return journaler->handle_entry(journaler->entry_handler,
+				      entry, commit_tid);
+}
+
+static bool get_last_entry_tid(struct ceph_journaler *journaler,
+			       uint64_t tag_tid, uint64_t *entry_tid)
+{
+	struct entry_tid *pos;
+
+	spin_lock(&journaler->entry_tid_lock);
+	list_for_each_entry(pos, &journaler->entry_tids, node) {
+		if (pos->tag_tid == tag_tid) {
+			*entry_tid = pos->entry_tid;
+			spin_unlock(&journaler->entry_tid_lock);
+			return true;
+		}
+	}
+	spin_unlock(&journaler->entry_tid_lock);
+
+	return false;
+}
+
+// There would not be too many entry_tids here, we need
+// only one entry_tid for all entries with same tag_tid.
+static struct entry_tid *entry_tid_alloc(struct ceph_journaler *journaler,
+					 uint64_t tag_tid)
+{
+	struct entry_tid *entry_tid;
+
+	entry_tid = kzalloc(sizeof(struct entry_tid), GFP_NOIO);
+	if (!entry_tid) {
+		pr_err("failed to allocate new entry.");
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
+static int reserve_entry_tid(struct ceph_journaler *journaler,
+			      uint64_t tag_tid, uint64_t entry_tid)
+{
+	struct entry_tid *pos;
+
+	spin_lock(&journaler->entry_tid_lock);
+	list_for_each_entry(pos, &journaler->entry_tids, node) {
+		if (pos->tag_tid == tag_tid) {
+			if (pos->entry_tid < entry_tid) {
+				pos->entry_tid = entry_tid;
+			}
+
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
+	pos->entry_tid = entry_tid;
+	spin_unlock(&journaler->entry_tid_lock);
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
+	uint64_t preamble;
+	uint8_t version;
+	uint32_t crc, crc_encoded;
+	void *start = *p;
+
+	preamble = ceph_decode_64(p);
+	if (PREAMBLE != preamble) {
+		return NULL;
+	}
+
+	version = ceph_decode_8(p);
+	if (version != 1)
+		return NULL;
+
+	entry = kzalloc(sizeof(struct ceph_journaler_entry), GFP_NOIO);
+	if (!entry) {
+		goto err;
+	}
+
+	INIT_LIST_HEAD(&entry->node);
+	entry->entry_tid = ceph_decode_64(p);
+	entry->tag_tid = ceph_decode_64(p);
+	// use kvmalloc to extract the data
+	entry->data = ceph_extract_encoded_string_kvmalloc(p, end,
+					&entry->data_len, GFP_KERNEL);
+	if (IS_ERR(entry->data)) {
+		entry->data = NULL;
+		goto free_entry;
+	}
+
+	crc = crc32c(0, start, *p - start);
+	crc_encoded = ceph_decode_32(p);
+	if (crc != crc_encoded) {
+		goto free_entry;
+	}
+	return entry;
+
+free_entry:
+	journaler_entry_free(entry);
+err:
+	return NULL;
+}
+
+static int fetch(struct ceph_journaler *journaler, uint64_t object_num)
+{
+	struct ceph_object_id object_oid;
+	int ret;
+	void *read_buf, *end;
+	uint64_t read_len = 2 << journaler->order;
+	struct ceph_journaler_object_pos *pos;
+	struct object_replayer *obj_replayer;
+
+	// get the replayer for this splay and set the object number of it to object_num.
+	obj_replayer = &journaler->obj_replayers[object_num % journaler->splay_width];
+	obj_replayer->object_num = object_num;
+
+	// find the commit position for this object_num.
+	list_for_each_entry(pos, &journaler->client->object_positions, node) {
+		if (pos->in_using && pos->object_num == object_num) {
+			// Tell the replayer there is a commit position
+			// in this object. So delete the entries before
+			// this position, they are already committed.
+			obj_replayer->pos = pos;
+			break;
+		}
+	}
+
+	// read the object data
+	ceph_oid_init(&object_oid);
+	ret = ceph_oid_aprintf(&object_oid, GFP_NOIO, "%s%llu",
+				journaler->object_oid_prefix, object_num);
+	if (ret) {
+		pr_err("failed to initialize object_id : %d", ret);
+		return ret;
+	}
+
+	read_buf = journaler->fetch_buf;
+	ret = ceph_journaler_obj_read_sync(journaler, &object_oid,
+					   &journaler->data_oloc, read_buf,
+					   0, read_len);
+	if (ret == -ENOENT) {
+		dout("no such object, %s: %d", object_oid.name, ret);
+		goto err_free_object_oid;
+	} else if (ret < 0) {
+		pr_err("failed to read: %d", ret);
+		goto err_free_object_oid;
+	} else if (ret == 0) {
+		pr_err("no data: %d", ret);
+		goto err_free_object_oid;
+	}
+
+	// decode the entries in this object
+	end = read_buf + ret;
+	while (read_buf < end) {
+		uint32_t bytes_needed = 0;
+		struct ceph_journaler_entry *entry = NULL;
+
+		if (!entry_is_readable(journaler, read_buf, end, &bytes_needed)) {
+			ret = -EIO;
+			goto err_free_object_oid;
+		}
+
+		entry = journaler_entry_decode(&read_buf, end);
+		if (!entry)
+			goto err_free_object_oid;
+
+		list_add_tail(&entry->node, &obj_replayer->entry_list);
+	}
+	ret = 0;
+
+err_free_object_oid:
+	ceph_oid_destroy(&object_oid);
+	return ret;
+}
+
+static int add_commit_entry(struct ceph_journaler *journaler, uint64_t commit_tid,
+			    uint64_t object_num, uint64_t tag_tid, uint64_t entry_tid)
+{
+	struct commit_entry	*commit_entry;
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
+// journaler->meta_lock held
+static uint64_t __allocate_commit_tid(struct ceph_journaler *journaler)
+{
+	return ++journaler->commit_tid;
+}
+
+static uint64_t allocate_commit_tid(struct ceph_journaler *journaler)
+{
+	uint64_t commit_tid;
+
+	mutex_lock(&journaler->meta_lock);
+	commit_tid = __allocate_commit_tid(journaler);
+	mutex_unlock(&journaler->meta_lock);
+
+	return commit_tid;
+}
+
+static void prune_tag(struct ceph_journaler *journaler, uint64_t tag_tid)
+{
+	struct ceph_journaler_entry *entry, *next;
+	struct object_replayer *obj_replayer;
+	int i;
+
+	if (journaler->prune_tag_tid == UINT_MAX ||
+	    journaler->prune_tag_tid < tag_tid) {
+		journaler->prune_tag_tid = tag_tid;
+	}
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
+			   struct ceph_journaler_entry **entry,
+			   uint64_t *commit_tid)
+{
+	struct object_replayer *obj_replayer;
+	struct ceph_journaler_entry *tmp_entry;
+	uint64_t last_entry_tid;
+	bool expect_first_entry = false;
+	int ret;
+
+next:
+	// find the current replayer.
+	obj_replayer = &journaler->obj_replayers[journaler->splay_offset];
+	if (list_empty(&obj_replayer->entry_list)) {
+		if (journaler->splay_offset == 0) {
+			return -ENOENT;
+		} else {
+			journaler->splay_offset = 0;
+			goto next;
+		}
+	}
+
+	// get the first entry in current replayer
+	tmp_entry = list_first_entry(&obj_replayer->entry_list,
+				     struct ceph_journaler_entry, node);
+
+	// advance the splay_offset
+	journaler->splay_offset = (journaler->splay_offset + 1) % journaler->splay_width;
+	if (journaler->active_tag_tid == UINT_MAX) {
+		// There is no active tag tid. This would happen when
+		// there is no commit in this journal. But
+		// we have some uncommitted entries. So set the current
+		// tag_tid to be the active_tag_tid.
+		journaler->active_tag_tid = tmp_entry->tag_tid;
+	} else if (tmp_entry->tag_tid < journaler->active_tag_tid ||
+		   (journaler->prune_tag_tid != UINT_MAX &&
+                    tmp_entry->tag_tid <= journaler->prune_tag_tid)) {
+		pr_err("detected stale entry: object_num=%llu, tag_tid=%llu,\
+			entry_tid=%llu.", obj_replayer->object_num, tmp_entry->tag_tid,
+			tmp_entry->entry_tid);
+		list_del(&tmp_entry->node);
+		prune_tag(journaler, tmp_entry->tag_tid);
+		journaler_entry_free(tmp_entry);
+		goto next;
+	} else if (tmp_entry->tag_tid > journaler->active_tag_tid) {
+		// found a new tag_tid, which means a new client is starting
+		// to append journal events. lets prune the old tag
+		prune_tag(journaler, journaler->active_tag_tid);
+		if (tmp_entry->entry_tid == 0) {
+			// this is the first entry of new tag client,
+			// advance the active_tag_tid to the new tag_tid.
+			journaler->active_tag_tid = tmp_entry->tag_tid;
+		} else {
+			if (expect_first_entry) {
+				pr_err("We expect this is the first entry for \
+					next tag. but the entry_tid is: %llu.",
+					tmp_entry->entry_tid);
+				return -ENOMSG;
+			}
+			// each client is appending events from the first
+			// object (splay_offset: 0). If we found a new tag
+			// but this is not the first entry (entry_tid: 0),
+			// let's jump the splay_offset to 0 to get the
+			// first entry from the new tag client.
+			journaler->splay_offset = 0;
+
+			// When we jump splay_offset to 0, we expect to get
+			// the first entry for a new tag.
+			expect_first_entry = true;
+			goto next;
+		}
+	}
+
+	// Pop this entry from journal
+	list_del(&tmp_entry->node);
+
+	// check entry_tid to make sure this entry_tid is after last_entry_tid
+	// for the same tag.
+	ret = get_last_entry_tid(journaler, tmp_entry->tag_tid, &last_entry_tid);
+	if (ret && tmp_entry->entry_tid != last_entry_tid + 1) {
+		pr_err("missing prior journal entry, last_entry_tid: %llu",
+		       last_entry_tid);
+		ret = -ENOMSG;
+		goto free_entry;
+	}
+
+	// fetch next object if this object is done.
+	if (list_empty(&obj_replayer->entry_list)) {
+		ret = fetch(journaler, obj_replayer->object_num + journaler->splay_width);
+		if (ret && ret != -ENOENT) {
+			goto free_entry;
+		}
+	}
+
+	ret = reserve_entry_tid(journaler, tmp_entry->tag_tid, tmp_entry->entry_tid);
+	if (ret)
+		goto free_entry;
+
+	// allocate commit_tid for this entry
+	*commit_tid = allocate_commit_tid(journaler);
+	ret = add_commit_entry(journaler, *commit_tid, obj_replayer->object_num,
+			       tmp_entry->tag_tid, tmp_entry->entry_tid);
+	if (ret)
+		goto free_entry;
+
+	*entry = tmp_entry;
+	return 0;
+
+free_entry:
+	journaler_entry_free(tmp_entry);
+	return ret;
+}
+
+static int process_replay(struct ceph_journaler *journaler)
+{
+	int r;
+	struct ceph_journaler_entry *entry;
+	uint64_t commit_tid;
+
+next:
+	// get the first entry from the journal, while there
+	// are different journal objects.
+	r = get_first_entry(journaler, &entry, &commit_tid);
+	if (r) {
+		if (r == -ENOENT) {
+			prune_tag(journaler, journaler->active_tag_tid);
+			r = 0;
+		}
+		return r;
+	}
+
+	r = playback_entry(journaler, entry, commit_tid);
+	journaler_entry_free(entry);
+	if (r) {
+		return r;
+	}
+
+	goto next;
+}
+
+// reserve entry tid and delete entries before commit position
+static int preprocess_replay(struct ceph_journaler *journaler)
+{
+	struct ceph_journaler_entry *entry, *next;
+	bool found_commit = false;
+	struct object_replayer *obj_replayer;
+	int i, ret;
+
+	for (i = 0; i < journaler->splay_width; i++) {
+		obj_replayer = &journaler->obj_replayers[i];
+		// If obj_replayer->pos is NULL, that means
+		// there is no commit position in this object.
+		if (!obj_replayer->pos)
+			continue;
+		found_commit = false;
+		list_for_each_entry_safe(entry, next,
+					 &obj_replayer->entry_list, node) {
+			if (entry->tag_tid == obj_replayer->pos->tag_tid &&
+			    entry->entry_tid == obj_replayer->pos->entry_tid) {
+				found_commit = true;
+			} else if (found_commit) {
+				break;
+			}
+
+			// This entry is before commit position, skip it in replaying.
+			ret = reserve_entry_tid(journaler, entry->tag_tid, entry->entry_tid);
+			if (ret)
+				return ret;
+			list_del(&entry->node);
+			journaler_entry_free(entry);
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
+	uint64_t *fetch_objects;
+	uint64_t buf_len = (2 << journaler->order);
+	uint64_t object_num;
+	int i;
+	int ret = 0;
+
+	if (!journaler->handle_entry || !journaler->entry_handler) {
+		pr_err("Please initialize the ->handle_entry and ->entry_handler");
+		return -EINVAL;
+	}
+
+	fetch_objects = kzalloc(sizeof(uint64_t) * journaler->splay_width, GFP_NOIO);
+	if (!fetch_objects)
+		return -ENOMEM;
+
+	// Step 1: Get the active position.
+	mutex_lock(&journaler->meta_lock);
+	// Get the HEAD of commit positions, that means the last committed object position.
+	active_pos = list_first_entry(&journaler->client->object_positions,
+				      struct ceph_journaler_object_pos, node);
+	// When there is no commit position in this journal, the active_pos would be empty.
+	// So skip getting active information when active_pos->in_using is false.
+	if (active_pos->in_using) {
+		journaler->splay_offset = (active_pos->object_num + 1) % journaler->splay_width;
+		journaler->active_tag_tid = active_pos->tag_tid;
+
+		list_for_each_entry(active_pos, &journaler->client->object_positions, node) {
+			if (active_pos->in_using) {
+				fetch_objects[active_pos->object_num %
+					      journaler->splay_width] = active_pos->object_num;
+			}
+		}
+	}
+	mutex_unlock(&journaler->meta_lock);
+
+	// Step 2: fetch journal objects.
+	// fetch_buf will be used to read every journal object
+	journaler->fetch_buf = ceph_kvmalloc(buf_len, GFP_NOIO);
+	if (!journaler->fetch_buf) {
+		pr_err("failed to alloc fetch buf: %llu", buf_len);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < journaler->splay_width; i++) {
+		if (fetch_objects[i] == 0) {
+			// No active commit position, so fetch
+			// them in splay order.
+			object_num = i;
+		} else {
+			object_num = fetch_objects[i];
+		}
+		ret = fetch(journaler, object_num);
+		if (ret && ret != -ENOENT)
+			goto free_fetch_buf;
+	}
+
+	// Step 3: preprocess the journal entries
+	ret = preprocess_replay(journaler);
+	if (ret)
+		goto free_fetch_buf;
+
+	// Step 4: process the journal entries
+	ret = process_replay(journaler);
+
+free_fetch_buf:
+	kvfree(journaler->fetch_buf);
+out:
+	// cleanup replayers
+	for (i = 0; i < journaler->splay_width; i++) {
+		struct object_replayer *obj_replayer = &journaler->obj_replayers[i];
+		struct ceph_journaler_entry *entry = NULL, *next_entry = NULL;
+
+		spin_lock(&obj_replayer->lock);
+		list_for_each_entry_safe(entry, next_entry, &obj_replayer->entry_list, node) {
+			list_del(&entry->node);
+			journaler_entry_free(entry);
+		}
+		spin_unlock(&obj_replayer->lock);
+	}
+	kfree(fetch_objects);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_journaler_start_replay);
-- 
1.8.3.1



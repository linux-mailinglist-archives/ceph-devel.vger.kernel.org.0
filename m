Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D049788B6
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2019 11:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbfG2Jnm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Jul 2019 05:43:42 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22658 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbfG2Jnj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Jul 2019 05:43:39 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowADHYpWjvz5djxunAA--.901S7;
        Mon, 29 Jul 2019 17:43:01 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v3 05/15] libceph: introduce cls_journaler_client
Date:   Mon, 29 Jul 2019 09:42:47 +0000
Message-Id: <1564393377-28949-6-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowADHYpWjvz5djxunAA--.901S7
X-Coremail-Antispam: 1Uf129KBjvAXoWfGry7Cry3KFyxGrW8trykuFg_yoW8AFy5Wo
        W2kr4UGrn5JFWUZrWvkrn2gFyYgay8GFn5Cr1FqFsruanrZ34fKw17Ga13ta43CF4ayrsr
        Kw4xJ3WfJw48J3W7n29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjfUp-z3UUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiUQUBelf4perOxwAAsG
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is a cls client module for journaler.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 include/linux/ceph/cls_journaler_client.h |  94 +++++
 net/ceph/cls_journaler_client.c           | 558 ++++++++++++++++++++++++++++++
 2 files changed, 652 insertions(+)
 create mode 100644 include/linux/ceph/cls_journaler_client.h
 create mode 100644 net/ceph/cls_journaler_client.c

diff --git a/include/linux/ceph/cls_journaler_client.h b/include/linux/ceph/cls_journaler_client.h
new file mode 100644
index 0000000..6245882
--- /dev/null
+++ b/include/linux/ceph/cls_journaler_client.h
@@ -0,0 +1,94 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_CEPH_CLS_JOURNAL_CLIENT_H
+#define _LINUX_CEPH_CLS_JOURNAL_CLIENT_H
+
+#include <linux/ceph/osd_client.h>
+
+struct ceph_journaler;
+struct ceph_journaler_client;
+
+struct ceph_journaler_object_pos {
+	struct list_head	node;
+	u64 			object_num;
+	u64 			tag_tid;
+	u64 			entry_tid;
+	// ->in_using means this object_pos is initialized.
+	// There would be some stub for it created in init step
+	// to allocate memory as early as possible.
+	bool			in_using;
+};
+
+struct ceph_journaler_client {
+	struct list_head			node;
+	size_t 					id_len;
+	char 					*id;
+	size_t 					data_len;
+	char 					*data;
+	struct list_head			object_positions;
+	struct ceph_journaler_object_pos	*object_positions_array;
+};
+
+struct ceph_journaler_tag {
+	uint64_t tid;
+	uint64_t tag_class;
+	size_t data_len;
+	char *data;
+};
+
+void destroy_client(struct ceph_journaler_client *client);
+
+int ceph_cls_journaler_get_immutable_metas(struct ceph_osd_client *osdc,
+		       			   struct ceph_object_id *oid,
+		       			   struct ceph_object_locator *oloc,
+					   uint8_t *order,
+					   uint8_t *splay_width,
+					   int64_t *pool_id);
+
+int ceph_cls_journaler_get_mutable_metas(struct ceph_osd_client *osdc,
+		       			 struct ceph_object_id *oid,
+		       			 struct ceph_object_locator *oloc,
+					 uint64_t *minimum_set, uint64_t *active_set);
+
+int ceph_cls_journaler_client_list(struct ceph_osd_client *osdc,
+		       		   struct ceph_object_id *oid,
+		       		   struct ceph_object_locator *oloc,
+				   struct list_head *clients,
+				   uint8_t splay_width);
+
+int ceph_cls_journaler_get_next_tag_tid(struct ceph_osd_client *osdc,
+		       		   struct ceph_object_id *oid,
+		       		   struct ceph_object_locator *oloc,
+				   uint64_t *tag_tid);
+
+int ceph_cls_journaler_get_tag(struct ceph_osd_client *osdc,
+		       	       struct ceph_object_id *oid,
+		       	       struct ceph_object_locator *oloc,
+			       uint64_t tag_tid, struct ceph_journaler_tag *tag);
+
+int ceph_cls_journaler_tag_create(struct ceph_osd_client *osdc,
+		       		  struct ceph_object_id *oid,
+		       		  struct ceph_object_locator *oloc,
+				  uint64_t tag_tid, uint64_t tag_class,
+				  void *buf, uint32_t buf_len);
+
+int ceph_cls_journaler_client_committed(struct ceph_osd_client *osdc,
+		       			   struct ceph_object_id *oid,
+		       			   struct ceph_object_locator *oloc,
+				   	   struct ceph_journaler_client *client,
+					struct list_head *object_positions);
+
+int ceph_cls_journaler_set_active_set(struct ceph_osd_client *osdc,
+		       			   struct ceph_object_id *oid,
+		       			   struct ceph_object_locator *oloc,
+				   	   uint64_t active_set);
+
+int ceph_cls_journaler_set_minimum_set(struct ceph_osd_client *osdc,
+		       			   struct ceph_object_id *oid,
+		       			   struct ceph_object_locator *oloc,
+				   	   uint64_t minimum_set);
+
+int ceph_cls_journaler_guard_append(struct ceph_osd_client *osdc,
+		       			   struct ceph_object_id *oid,
+		       			   struct ceph_object_locator *oloc,
+				   	   uint64_t soft_limit);
+#endif
diff --git a/net/ceph/cls_journaler_client.c b/net/ceph/cls_journaler_client.c
new file mode 100644
index 0000000..ac27589
--- /dev/null
+++ b/net/ceph/cls_journaler_client.c
@@ -0,0 +1,558 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/ceph/ceph_debug.h>
+#include <linux/ceph/cls_journaler_client.h>
+#include <linux/ceph/journaler.h>
+
+#include <linux/types.h>
+
+//TODO get all metas in one single request
+int ceph_cls_journaler_get_immutable_metas(struct ceph_osd_client *osdc,
+		       			   struct ceph_object_id *oid,
+		       			   struct ceph_object_locator *oloc,
+					   uint8_t *order,
+					   uint8_t *splay_width,
+					   int64_t *pool_id)
+{
+	struct page *reply_page;
+	size_t reply_len = sizeof(*order);
+	int ret;
+
+	reply_page = alloc_page(GFP_NOIO);
+	if (!reply_page)
+		return -ENOMEM;
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_order",
+			     CEPH_OSD_FLAG_READ, NULL,
+			     0, &reply_page, &reply_len);
+	if (!ret) {
+		memcpy(order, page_address(reply_page), reply_len);
+	} else {
+		goto out;
+	}
+	reply_len = sizeof(*splay_width);
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_splay_width",
+			     CEPH_OSD_FLAG_READ, NULL,
+			     0, &reply_page, &reply_len);
+	if (!ret) {
+		memcpy(splay_width, page_address(reply_page), reply_len);
+	} else {
+		goto out;
+	}
+	reply_len = sizeof(*pool_id);
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_pool_id",
+			     CEPH_OSD_FLAG_READ, NULL,
+			     0, &reply_page, &reply_len);
+	if (!ret) {
+		memcpy(pool_id, page_address(reply_page), reply_len);
+	} else {
+		goto out;
+	}
+out:
+	__free_page(reply_page);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_cls_journaler_get_immutable_metas);
+
+//TODO get all metas in one single request
+int ceph_cls_journaler_get_mutable_metas(struct ceph_osd_client *osdc,
+		       			   struct ceph_object_id *oid,
+		       			   struct ceph_object_locator *oloc,
+					   uint64_t *minimum_set, uint64_t *active_set)
+{
+	struct page *reply_page;
+	int ret;
+	size_t reply_len = sizeof(*minimum_set);
+
+	reply_page = alloc_page(GFP_NOIO);
+	if (!reply_page)
+		return -ENOMEM;
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_minimum_set",
+			     CEPH_OSD_FLAG_READ, NULL,
+			     0, &reply_page, &reply_len);
+	if (!ret) {
+		memcpy(minimum_set, page_address(reply_page), reply_len);
+	} else {
+		goto out;
+	}
+	reply_len = sizeof(active_set);
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_active_set",
+			     CEPH_OSD_FLAG_READ, NULL,
+			     0, &reply_page, &reply_len);
+	if (!ret) {
+		memcpy(active_set, page_address(reply_page), reply_len);
+	} else {
+		goto out;
+	}
+out:
+	__free_page(reply_page);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_cls_journaler_get_mutable_metas);
+
+static int decode_object_position(void **p, void *end, struct ceph_journaler_object_pos *pos)
+{
+	u8 struct_v;
+	u32 struct_len;
+	int ret;
+	u64 object_num;
+	u64 tag_tid;
+	u64 entry_tid;
+
+	ret = ceph_start_decoding(p, end, 1, "cls_journal_object_position",
+				  &struct_v, &struct_len);
+	if (ret)
+		return ret;
+
+	object_num = ceph_decode_64(p);
+	tag_tid = ceph_decode_64(p);
+	entry_tid = ceph_decode_64(p);
+
+	pos->object_num = object_num;
+	pos->tag_tid = tag_tid;
+	pos->entry_tid = entry_tid;
+
+	return ret;
+}
+
+void destroy_client(struct ceph_journaler_client *client)
+{
+	kfree(client->object_positions_array);
+	kfree(client->id);
+	kfree(client->data);
+
+	kfree(client);
+}
+
+struct ceph_journaler_client *create_client(uint8_t splay_width)
+{
+	struct ceph_journaler_client *client;
+	struct ceph_journaler_object_pos *pos;
+	int i;
+
+	client = kzalloc(sizeof(*client), GFP_NOIO);
+	if (!client)
+		return NULL;
+
+	client->object_positions_array = kcalloc(splay_width, sizeof(*pos), GFP_NOIO);
+	if (!client->object_positions_array)
+		goto free_client;
+
+	INIT_LIST_HEAD(&client->object_positions);
+	for (i = 0; i < splay_width; i++) {
+		pos = &client->object_positions_array[i];
+		INIT_LIST_HEAD(&pos->node);
+		list_add_tail(&pos->node, &client->object_positions);
+	}
+
+	INIT_LIST_HEAD(&client->node);
+	client->data = NULL;
+	client->id = NULL;
+
+	return client;
+free_client:
+	kfree(client);
+	return NULL;
+}
+
+static int decode_client(void **p, void *end, struct ceph_journaler_client *client)
+{
+	u8 struct_v;
+	u8 state_raw;
+	u32 struct_len;
+	int ret, num, i;
+	struct ceph_journaler_object_pos *pos;
+	
+	ret = ceph_start_decoding(p, end, 1, "cls_journal_get_client_reply",
+				  &struct_v, &struct_len);
+	if (ret)
+		return ret;
+
+	client->id = ceph_extract_encoded_string(p, end, &client->id_len, GFP_NOIO); 
+	if (IS_ERR(client->id)) {
+		ret = PTR_ERR(client->id);
+		client->id = NULL;
+		goto err;
+	}
+	client->data = ceph_extract_encoded_string(p, end, &client->data_len, GFP_NOIO); 
+	if (IS_ERR(client->data)) {
+		ret = PTR_ERR(client->data);
+		client->data = NULL;
+		goto free_id;
+	}
+	ret = ceph_start_decoding(p, end, 1, "cls_joural_client_object_set_position",
+				  &struct_v, &struct_len);
+	if (ret)
+		goto free_data;
+
+	num = ceph_decode_32(p);
+	i = 0;
+	list_for_each_entry(pos, &client->object_positions, node) {
+		if (i < num) {
+			// we will use this position stub
+			pos->in_using = true;
+			ret = decode_object_position(p, end, pos);
+			if (ret) {
+				goto free_data;
+			}
+		} else {
+			// This stub is not used anymore
+			pos->in_using = false;
+		}
+		i++;
+	}
+
+	state_raw = ceph_decode_8(p);
+	return 0;
+
+free_data:
+	kfree(client->data);
+free_id:
+	kfree(client->id);
+err:
+	return ret;
+}
+
+static int decode_clients(void **p, void *end, struct list_head *clients, uint8_t splay_width)
+{
+	int i = 0;
+	int ret;
+	uint32_t client_num;
+	struct ceph_journaler_client *client, *next;
+	
+	client_num = ceph_decode_32(p);
+	// Reuse the clients already exist in list.
+	list_for_each_entry_safe(client, next, clients, node) {
+		// Some clients unregistered.
+		if (i < client_num) {
+			kfree(client->id);
+			kfree(client->data);
+			ret = decode_client(p, end, client);	
+			if (ret)
+				return ret;
+		} else {
+			list_del(&client->node);
+			destroy_client(client);
+		}
+		i++;
+	}
+
+	// Some more clients registered.
+	for (; i < client_num; i++) {
+		client = create_client(splay_width);
+		if (!client)
+			return -ENOMEM;
+		ret = decode_client(p, end, client);
+		if (ret) {
+			destroy_client(client);
+			return ret;
+		}
+		list_add_tail(&client->node, clients);
+	}
+	return 0;
+}
+
+int ceph_cls_journaler_client_list(struct ceph_osd_client *osdc,
+		       		   struct ceph_object_id *oid,
+		       		   struct ceph_object_locator *oloc,
+				   struct list_head *clients,
+				   uint8_t splay_width)
+{
+	struct page *reply_page;
+	struct page *req_page;
+	int ret;
+	size_t reply_len = PAGE_SIZE;
+	int buf_size;
+	void *p, *end;
+	char name[] = "";
+
+	buf_size = strlen(name) + sizeof(__le32) + sizeof(uint64_t);
+
+	if (buf_size > PAGE_SIZE)
+		return -E2BIG;
+
+	reply_page = alloc_page(GFP_NOIO);
+	if (!reply_page)
+		return -ENOMEM;
+
+	req_page = alloc_page(GFP_NOIO);
+	if (!req_page) {
+		ret = -ENOMEM;
+		goto free_reply_page;
+	}
+
+	p = page_address(req_page);
+	end = p + buf_size;
+
+	ceph_encode_string(&p, end, name, strlen(name));
+	ceph_encode_64(&p, (uint64_t)256);
+
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "client_list",
+			     CEPH_OSD_FLAG_READ, req_page,
+			     buf_size, &reply_page, &reply_len);
+
+	if (!ret) {
+		p = page_address(reply_page);
+		end = p + reply_len;
+
+		ret = decode_clients(&p, end, clients, splay_width);
+	}
+
+	__free_page(req_page);
+free_reply_page:
+	__free_page(reply_page);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_cls_journaler_client_list);
+
+int ceph_cls_journaler_get_next_tag_tid(struct ceph_osd_client *osdc,
+		       			   struct ceph_object_id *oid,
+		       			   struct ceph_object_locator *oloc,
+				   uint64_t *tag_tid)
+{
+	struct page *reply_page;
+	int ret;
+	size_t reply_len = PAGE_SIZE;
+
+	reply_page = alloc_page(GFP_NOIO);
+	if (!reply_page)
+		return -ENOMEM;
+
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_next_tag_tid",
+			     CEPH_OSD_FLAG_READ, NULL,
+			     0, &reply_page, &reply_len);
+
+	if (!ret) {
+		memcpy(tag_tid, page_address(reply_page), reply_len);
+	}
+
+	__free_page(reply_page);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_cls_journaler_get_next_tag_tid);
+
+int ceph_cls_journaler_tag_create(struct ceph_osd_client *osdc,
+		       			   struct ceph_object_id *oid,
+		       			   struct ceph_object_locator *oloc,
+					uint64_t tag_tid, uint64_t tag_class,
+				   void *buf, uint32_t buf_len)
+{
+	struct page *req_page;
+	int ret;
+	int buf_size;
+	void *p, *end;
+
+	buf_size = buf_len + sizeof(__le32) + sizeof(uint64_t) + sizeof(uint64_t);
+
+	if (buf_size > PAGE_SIZE)
+		return -E2BIG;
+
+	req_page = alloc_page(GFP_NOIO);
+	if (!req_page)
+		return -ENOMEM;
+
+	p = page_address(req_page);
+	end = p + buf_size;
+
+	ceph_encode_64(&p, tag_tid);
+	ceph_encode_64(&p, tag_class);
+	ceph_encode_string(&p, end, buf, buf_len);
+
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "tag_create",
+			     CEPH_OSD_FLAG_WRITE, req_page,
+			     buf_size, NULL, NULL);
+
+	__free_page(req_page);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_cls_journaler_tag_create);
+
+int decode_tag(void **p, void *end, struct ceph_journaler_tag *tag)
+{
+	int ret;
+	u8 struct_v;
+	u32 struct_len;
+
+	ret = ceph_start_decoding(p, end, 1, "cls_journaler_tag",
+				  &struct_v, &struct_len);
+	if (ret)
+		return ret;
+
+	tag->tid = ceph_decode_64(p);
+	tag->tag_class = ceph_decode_64(p);
+	tag->data = ceph_extract_encoded_string(p, end, &tag->data_len, GFP_NOIO); 
+	if (IS_ERR(tag->data)) {
+		ret = PTR_ERR(tag->data);
+		tag->data = NULL;
+		return ret;
+	}
+
+	return 0;
+}
+
+int ceph_cls_journaler_get_tag(struct ceph_osd_client *osdc,
+		       			   struct ceph_object_id *oid,
+		       			   struct ceph_object_locator *oloc,
+				   uint64_t tag_tid, struct ceph_journaler_tag *tag)
+{
+	struct page *reply_page;
+	struct page *req_page;
+	int ret;
+	size_t reply_len = PAGE_SIZE;
+	int buf_size;
+	void *p, *end;
+
+	buf_size = sizeof(tag_tid);
+
+	reply_page = alloc_page(GFP_NOIO);
+	if (!reply_page)
+		return -ENOMEM;
+
+	req_page = alloc_page(GFP_NOIO);
+	if (!req_page) {
+		ret = -ENOMEM;
+		goto free_reply_page;
+	}
+
+	p = page_address(req_page);
+	end = p + buf_size;
+	ceph_encode_64(&p, tag_tid);
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_tag",
+			     CEPH_OSD_FLAG_READ, req_page,
+			     buf_size, &reply_page, &reply_len);
+
+	if (!ret) {
+		p = page_address(reply_page);
+		end = p + reply_len;
+
+		ret = decode_tag(&p, end, tag);
+	}
+
+	__free_page(req_page);
+free_reply_page:
+	__free_page(reply_page);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_cls_journaler_get_tag);
+
+static int version_len = 6;
+
+int ceph_cls_journaler_client_committed(struct ceph_osd_client *osdc,
+		       			   struct ceph_object_id *oid,
+		       			   struct ceph_object_locator *oloc,
+				   	   struct ceph_journaler_client *client,
+					struct list_head *object_positions)
+{
+	struct page *req_page;
+	int ret;
+	int buf_size;
+	void *p, *end;
+	struct ceph_journaler_object_pos *position = NULL;
+	int object_position_len = version_len + 8 + 8 + 8;
+	int pos_num = 0;
+
+	buf_size = 4 + client->id_len + version_len + 4;
+	list_for_each_entry(position, object_positions, node) {
+		buf_size += object_position_len;
+		pos_num++;
+	}
+
+	if (buf_size > PAGE_SIZE)
+		return -E2BIG;
+
+	req_page = alloc_page(GFP_NOIO);
+	if (!req_page)
+		return -ENOMEM;
+
+	p = page_address(req_page);
+	end = p + buf_size;
+	ceph_encode_string(&p, end, client->id, client->id_len);
+	ceph_start_encoding(&p, 1, 1, buf_size - client->id_len - version_len - 4);
+	ceph_encode_32(&p, pos_num);
+
+	list_for_each_entry(position, object_positions, node) {
+		ceph_start_encoding(&p, 1, 1, 24);
+		ceph_encode_64(&p, position->object_num);
+		ceph_encode_64(&p, position->tag_tid);
+		ceph_encode_64(&p, position->entry_tid);
+	}
+
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "client_commit",
+			     CEPH_OSD_FLAG_WRITE, req_page,
+			     buf_size, NULL, NULL);
+
+	__free_page(req_page);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_cls_journaler_client_committed);
+
+
+int ceph_cls_journaler_set_minimum_set(struct ceph_osd_client *osdc,
+		       			   struct ceph_object_id *oid,
+		       			   struct ceph_object_locator *oloc,
+				   	   uint64_t minimum_set)
+{
+	struct page *req_page;
+	int ret;
+	void *p;
+
+	req_page = alloc_page(GFP_NOIO);
+	if (!req_page)
+		return -ENOMEM;
+
+	p = page_address(req_page);
+	ceph_encode_64(&p, minimum_set);
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "set_minimum_set",
+			     CEPH_OSD_FLAG_WRITE, req_page,
+			     8, NULL, NULL);
+
+	__free_page(req_page);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_cls_journaler_set_minimum_set);
+
+int ceph_cls_journaler_set_active_set(struct ceph_osd_client *osdc,
+		       			   struct ceph_object_id *oid,
+		       			   struct ceph_object_locator *oloc,
+				   	   uint64_t active_set)
+{
+	struct page *req_page;
+	int ret;
+	void *p;
+
+	req_page = alloc_page(GFP_NOIO);
+	if (!req_page)
+		return -ENOMEM;
+
+	p = page_address(req_page);
+	ceph_encode_64(&p, active_set);
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "set_active_set",
+			     CEPH_OSD_FLAG_WRITE, req_page,
+			     8, NULL, NULL);
+
+	__free_page(req_page);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_cls_journaler_set_active_set);
+
+int ceph_cls_journaler_guard_append(struct ceph_osd_client *osdc,
+		       			   struct ceph_object_id *oid,
+		       			   struct ceph_object_locator *oloc,
+				   	   uint64_t soft_limit)
+{
+	struct page *req_page;
+	int ret;
+	void *p;
+
+	req_page = alloc_page(GFP_NOIO);
+	if (!req_page)
+		return -ENOMEM;
+
+	p = page_address(req_page);
+	ceph_encode_64(&p, soft_limit);
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "guard_append",
+			     CEPH_OSD_FLAG_READ, req_page,
+			     8, NULL, NULL);
+
+	__free_page(req_page);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_cls_journaler_guard_append);
-- 
1.8.3.1



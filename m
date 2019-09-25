Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFB04BDA86
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Sep 2019 11:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbfIYJJO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Sep 2019 05:09:14 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:21282 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728504AbfIYJIi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 25 Sep 2019 05:08:38 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAD3dl9YLotdHDhSAg--.166S7;
        Wed, 25 Sep 2019 17:07:38 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v4 05/12] libceph: introduce cls_journal_client
Date:   Wed, 25 Sep 2019 09:07:27 +0000
Message-Id: <1569402454-4736-6-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569402454-4736-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1569402454-4736-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowAD3dl9YLotdHDhSAg--.166S7
X-Coremail-Antispam: 1Uf129KBjvAXoWfJr15uw1UJw4DuFW3Ww13CFg_yoW8Ww1fWo
        W2yr45Gwn5GFyUCFWvkrn2gFWYgayrGF1rAr1YqF4DuanrZ34fJw17Ga13ta4fuF4ayrsr
        Kw4xJ3WfJw48J3W7n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjfUJ0JPDUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiWho7elf4pcjpDQAAsn
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is a cls client module for journaler.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 include/linux/ceph/cls_journal_client.h |  84 +++++
 net/ceph/cls_journal_client.c           | 527 ++++++++++++++++++++++++++++++++
 2 files changed, 611 insertions(+)
 create mode 100644 include/linux/ceph/cls_journal_client.h
 create mode 100644 net/ceph/cls_journal_client.c

diff --git a/include/linux/ceph/cls_journal_client.h b/include/linux/ceph/cls_journal_client.h
new file mode 100644
index 0000000..05e0c42
--- /dev/null
+++ b/include/linux/ceph/cls_journal_client.h
@@ -0,0 +1,84 @@
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
+	struct list_head node;
+	u64 object_num;
+	u64 tag_tid;
+	u64 entry_tid;
+	/*
+	 * ->in_using means this object_pos is initialized.
+	 * There would be some stub for it created in init step
+	 * to allocate memory as early as possible.
+	 */
+	bool in_using;
+};
+
+struct ceph_journaler_client {
+	struct list_head node;
+	size_t id_len;
+	char *id;
+	struct list_head object_positions;
+	struct ceph_journaler_object_pos *object_positions_array;
+};
+
+struct ceph_journaler_tag {
+	u64 tid;
+	u64 tag_class;
+};
+
+void destroy_client(struct ceph_journaler_client *client);
+
+int ceph_cls_journal_get_immutable_metas(struct ceph_osd_client *osdc,
+					 struct ceph_object_id *oid,
+					 struct ceph_object_locator *oloc,
+					 u8 *order, u8 *splay_width,
+					 int64_t *pool_id);
+
+int ceph_cls_journal_get_mutable_metas(struct ceph_osd_client *osdc,
+				       struct ceph_object_id *oid,
+				       struct ceph_object_locator *oloc,
+				       u64 *minimum_set, u64 *active_set);
+
+int ceph_cls_journal_client_list(struct ceph_osd_client *osdc,
+				 struct ceph_object_id *oid,
+				 struct ceph_object_locator *oloc,
+				 struct list_head *clients, u8 splay_width);
+
+int ceph_cls_journal_get_next_tag_tid(struct ceph_osd_client *osdc,
+				      struct ceph_object_id *oid,
+				      struct ceph_object_locator *oloc,
+				      u64 *tag_tid);
+
+int ceph_cls_journal_get_tag(struct ceph_osd_client *osdc,
+			     struct ceph_object_id *oid,
+			     struct ceph_object_locator *oloc, u64 tag_tid,
+			     struct ceph_journaler_tag *tag);
+
+int ceph_cls_journal_tag_create(struct ceph_osd_client *osdc,
+				struct ceph_object_id *oid,
+				struct ceph_object_locator *oloc, u64 tag_tid,
+				u64 tag_class, void *buf, u32 buf_len);
+
+int ceph_cls_journal_client_committed(struct ceph_osd_client *osdc,
+				      struct ceph_object_id *oid,
+				      struct ceph_object_locator *oloc,
+				      struct ceph_journaler_client *client,
+				      struct list_head *object_positions);
+
+int ceph_cls_journal_set_active_set(struct ceph_osd_client *osdc,
+				    struct ceph_object_id *oid,
+				    struct ceph_object_locator *oloc,
+				    u64 active_set);
+
+int ceph_cls_journal_set_minimum_set(struct ceph_osd_client *osdc,
+				     struct ceph_object_id *oid,
+				     struct ceph_object_locator *oloc,
+				     u64 minimum_set);
+#endif
diff --git a/net/ceph/cls_journal_client.c b/net/ceph/cls_journal_client.c
new file mode 100644
index 0000000..6c8ce48
--- /dev/null
+++ b/net/ceph/cls_journal_client.c
@@ -0,0 +1,527 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/ceph/ceph_debug.h>
+#include <linux/ceph/cls_journal_client.h>
+#include <linux/ceph/journaler.h>
+
+#include <linux/types.h>
+
+/* max return of client_list to fit in 4KB */
+#define JOURNAL_CLIENT_MAX_RETURN 64
+
+/* TODO get all metas in one single request */
+int ceph_cls_journal_get_immutable_metas(struct ceph_osd_client *osdc,
+					 struct ceph_object_id *oid,
+					 struct ceph_object_locator *oloc,
+					 u8 *order, u8 *splay_width,
+					 int64_t *pool_id)
+{
+	struct page *reply_page;
+	size_t reply_len = sizeof(*order);
+	void *p;
+	int ret;
+
+	reply_page = alloc_page(GFP_NOIO);
+	if (!reply_page)
+		return -ENOMEM;
+
+	/* get order */
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_order",
+			     CEPH_OSD_FLAG_READ, NULL, 0, &reply_page,
+			     &reply_len);
+	if (ret)
+		goto out;
+	p = page_address(reply_page);
+	ceph_decode_8_safe(&p, p + reply_len, *order, bad);
+
+	/* get splay_width */
+	reply_len = sizeof(*splay_width);
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_splay_width",
+			     CEPH_OSD_FLAG_READ, NULL, 0, &reply_page,
+			     &reply_len);
+	if (ret)
+		goto out;
+	p = page_address(reply_page);
+	ceph_decode_8_safe(&p, p + reply_len, *splay_width, bad);
+
+	/* get pool_id */
+	reply_len = sizeof(*pool_id);
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_pool_id",
+			     CEPH_OSD_FLAG_READ, NULL, 0, &reply_page,
+			     &reply_len);
+	if (ret)
+		goto out;
+	p = page_address(reply_page);
+	ceph_decode_64_safe(&p, p + reply_len, *pool_id, bad);
+out:
+	__free_page(reply_page);
+	return ret;
+bad:
+	ret = -EINVAL;
+	goto out;
+}
+EXPORT_SYMBOL(ceph_cls_journal_get_immutable_metas);
+
+/* TODO get all metas in one single request */
+int ceph_cls_journal_get_mutable_metas(struct ceph_osd_client *osdc,
+				       struct ceph_object_id *oid,
+				       struct ceph_object_locator *oloc,
+				       u64 *minimum_set, u64 *active_set)
+{
+	struct page *reply_page;
+	size_t reply_len = sizeof(*minimum_set);
+	void *p;
+	int ret;
+
+	reply_page = alloc_page(GFP_NOIO);
+	if (!reply_page)
+		return -ENOMEM;
+
+	/* get minimum_set */
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_minimum_set",
+			     CEPH_OSD_FLAG_READ, NULL, 0, &reply_page,
+			     &reply_len);
+	if (ret)
+		goto out;
+	p = page_address(reply_page);
+	ceph_decode_64_safe(&p, p + reply_len, *minimum_set, bad);
+
+	/* get active_set */
+	reply_len = sizeof(active_set);
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_active_set",
+			     CEPH_OSD_FLAG_READ, NULL, 0, &reply_page,
+			     &reply_len);
+	if (ret)
+		goto out;
+	p = page_address(reply_page);
+	ceph_decode_64_safe(&p, p + reply_len, *active_set, bad);
+out:
+	__free_page(reply_page);
+	return ret;
+bad:
+	ret = -EINVAL;
+	goto out;
+}
+EXPORT_SYMBOL(ceph_cls_journal_get_mutable_metas);
+
+static int decode_object_position(void **p, void *end,
+				  struct ceph_journaler_object_pos *pos)
+{
+	u8 struct_v;
+	u32 struct_len;
+	int ret;
+
+	ret = ceph_start_decoding(p, end, 1, "cls_journal_object_position",
+				  &struct_v, &struct_len);
+	if (ret)
+		return ret;
+
+	ceph_decode_64_safe(p, end, pos->object_num, bad);
+	ceph_decode_64_safe(p, end, pos->tag_tid, bad);
+	ceph_decode_64_safe(p, end, pos->entry_tid, bad);
+	return ret;
+bad:
+	return -EINVAL;
+}
+
+void destroy_client(struct ceph_journaler_client *client)
+{
+	kfree(client->object_positions_array);
+	kfree(client->id);
+
+	kfree(client);
+}
+
+struct ceph_journaler_client *create_client(u8 splay_width)
+{
+	struct ceph_journaler_client *client;
+	struct ceph_journaler_object_pos *pos;
+	int i;
+
+	client = kzalloc(sizeof(*client), GFP_NOIO);
+	if (!client)
+		return NULL;
+
+	client->object_positions_array =
+		kcalloc(splay_width, sizeof(*pos), GFP_NOIO);
+	if (!client->object_positions_array)
+		goto free_client;
+
+	INIT_LIST_HEAD(&client->object_positions);
+	for (i = 0; i < splay_width; i++) {
+		pos = &client->object_positions_array[i];
+		INIT_LIST_HEAD(&pos->node);
+		list_add_tail(&pos->node, &client->object_positions);
+	}
+	INIT_LIST_HEAD(&client->node);
+	client->id = NULL;
+
+	return client;
+free_client:
+	kfree(client);
+	return NULL;
+}
+
+static int decode_client(void **p, void *end,
+			 struct ceph_journaler_client *client)
+{
+	u8 struct_v;
+	u32 struct_len;
+	struct ceph_journaler_object_pos *pos;
+	int ret, num, i = 0;
+
+	ret = ceph_start_decoding(p, end, 1, "cls_journal_get_client_reply",
+				  &struct_v, &struct_len);
+	if (ret)
+		return ret;
+
+	client->id =
+		ceph_extract_encoded_string(p, end, &client->id_len, GFP_NOIO);
+	if (IS_ERR(client->id)) {
+		ret = PTR_ERR(client->id);
+		client->id = NULL;
+		goto err;
+	}
+
+	/* skip client->data */
+	ceph_decode_skip_string(p, end, bad);
+	ret = ceph_start_decoding(p, end, 1,
+				  "cls_joural_client_object_set_position",
+				  &struct_v, &struct_len);
+	if (ret)
+		goto free_id;
+	num = ceph_decode_32(p);
+	list_for_each_entry(pos, &client->object_positions, node) {
+		if (i < num) {
+			/* we will use this position stub */
+			pos->in_using = true;
+			ret = decode_object_position(p, end, pos);
+			if (ret)
+				goto free_id;
+		} else {
+			/* This stub is not used anymore */
+			pos->in_using = false;
+		}
+		i++;
+	}
+	/* skip the state_raw */
+	ceph_decode_skip_8(p, end, bad);
+	return 0;
+bad:
+	ret = -EINVAL;
+free_id:
+	kfree(client->id);
+err:
+	return ret;
+}
+
+static int decode_clients(void **p, void *end, struct list_head *clients,
+			  u8 splay_width)
+{
+	struct ceph_journaler_client *client, *next;
+	u32 client_num;
+	int i = 0;
+	int ret;
+
+	client_num = ceph_decode_32(p);
+	if (client_num >= JOURNAL_CLIENT_MAX_RETURN) {
+		/*
+		 * JOURNAL_CLIENT_MAX_RETURN seems large enough currently.
+		 * TODO: call client_list again for more clients.
+		 */
+		return -ERANGE;
+	}
+
+	/* Reuse the clients already exist in list. */
+	list_for_each_entry_safe(client, next, clients, node) {
+		/* Some clients unregistered. */
+		if (i < client_num) {
+			kfree(client->id);
+			ret = decode_client(p, end, client);
+			if (ret)
+				return ret;
+		} else {
+			list_del(&client->node);
+			destroy_client(client);
+		}
+		i++;
+	}
+	/* Some more clients registered. */
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
+int ceph_cls_journal_client_list(struct ceph_osd_client *osdc,
+				 struct ceph_object_id *oid,
+				 struct ceph_object_locator *oloc,
+				 struct list_head *clients, u8 splay_width)
+{
+	struct page *reply_page;
+	struct page *req_page;
+	size_t reply_len = PAGE_SIZE;
+	int buf_size;
+	void *p, *end;
+	int ret;
+
+	buf_size = sizeof(__le32) + sizeof(u64);
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
+	/* encode "" */
+	ceph_encode_32(&p, 0);
+	ceph_encode_64(&p, JOURNAL_CLIENT_MAX_RETURN);
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "client_list",
+			     CEPH_OSD_FLAG_READ, req_page, buf_size,
+			     &reply_page, &reply_len);
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
+EXPORT_SYMBOL(ceph_cls_journal_client_list);
+
+int ceph_cls_journal_get_next_tag_tid(struct ceph_osd_client *osdc,
+				      struct ceph_object_id *oid,
+				      struct ceph_object_locator *oloc,
+				      u64 *tag_tid)
+{
+	struct page *reply_page;
+	size_t reply_len = PAGE_SIZE;
+	void *p;
+	int ret;
+
+	reply_page = alloc_page(GFP_NOIO);
+	if (!reply_page)
+		return -ENOMEM;
+
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_next_tag_tid",
+			     CEPH_OSD_FLAG_READ, NULL, 0, &reply_page,
+			     &reply_len);
+
+	if (!ret) {
+		p = page_address(reply_page);
+		ceph_decode_8_safe(&p, p + reply_len, *tag_tid, bad);
+	}
+out:
+	__free_page(reply_page);
+	return ret;
+bad:
+	ret = -EINVAL;
+	goto out;
+}
+EXPORT_SYMBOL(ceph_cls_journal_get_next_tag_tid);
+
+int ceph_cls_journal_tag_create(struct ceph_osd_client *osdc,
+				struct ceph_object_id *oid,
+				struct ceph_object_locator *oloc, u64 tag_tid,
+				u64 tag_class, void *buf, u32 buf_len)
+{
+	struct page *req_page;
+	int buf_size;
+	void *p, *end;
+	int ret;
+
+	buf_size = buf_len + sizeof(__le32) + sizeof(u64) + sizeof(u64);
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
+			     CEPH_OSD_FLAG_WRITE, req_page, buf_size, NULL,
+			     NULL);
+
+	__free_page(req_page);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_cls_journal_tag_create);
+
+int decode_tag(void **p, void *end, struct ceph_journaler_tag *tag)
+{
+	u8 struct_v;
+	u32 struct_len;
+	int ret;
+
+	ret = ceph_start_decoding(p, end, 1, "cls_journal_tag", &struct_v,
+				  &struct_len);
+	if (ret)
+		return ret;
+
+	tag->tid = ceph_decode_64(p);
+	tag->tag_class = ceph_decode_64(p);
+
+	ceph_decode_skip_string(p, end, bad);
+	return 0;
+bad:
+	return -EINVAL;
+}
+
+int ceph_cls_journal_get_tag(struct ceph_osd_client *osdc,
+			     struct ceph_object_id *oid,
+			     struct ceph_object_locator *oloc, u64 tag_tid,
+			     struct ceph_journaler_tag *tag)
+{
+	struct page *reply_page;
+	struct page *req_page;
+	size_t reply_len = PAGE_SIZE;
+	int buf_size;
+	void *p, *end;
+	int ret;
+
+	buf_size = sizeof(tag_tid);
+	reply_page = alloc_page(GFP_NOIO);
+	if (!reply_page)
+		return -ENOMEM;
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
+			     CEPH_OSD_FLAG_READ, req_page, buf_size,
+			     &reply_page, &reply_len);
+	if (!ret) {
+		p = page_address(reply_page);
+		end = p + reply_len;
+
+		ret = decode_tag(&p, end, tag);
+	}
+	__free_page(req_page);
+free_reply_page:
+	__free_page(reply_page);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_cls_journal_get_tag);
+
+int ceph_cls_journal_client_committed(struct ceph_osd_client *osdc,
+				      struct ceph_object_id *oid,
+				      struct ceph_object_locator *oloc,
+				      struct ceph_journaler_client *client,
+				      struct list_head *object_positions)
+{
+	struct ceph_journaler_object_pos *position;
+	int object_position_len = CEPH_ENCODING_START_BLK_LEN + 8 + 8 + 8;
+	struct page *req_page;
+	int buf_size;
+	void *p, *end;
+	int pos_num = 0;
+	int ret;
+
+	buf_size = 4 + client->id_len + CEPH_ENCODING_START_BLK_LEN + 4;
+	list_for_each_entry(position, object_positions, node) {
+		buf_size += object_position_len;
+		pos_num++;
+	}
+	if (buf_size > PAGE_SIZE)
+		return -E2BIG;
+	req_page = alloc_page(GFP_NOIO);
+	if (!req_page)
+		return -ENOMEM;
+	p = page_address(req_page);
+	end = p + buf_size;
+	ceph_encode_string(&p, end, client->id, client->id_len);
+	ceph_start_encoding(&p, 1, 1,
+			    buf_size - client->id_len -
+				    CEPH_ENCODING_START_BLK_LEN - 4);
+	ceph_encode_32(&p, pos_num);
+
+	list_for_each_entry(position, object_positions, node) {
+		ceph_start_encoding(&p, 1, 1, 24);
+		ceph_encode_64(&p, position->object_num);
+		ceph_encode_64(&p, position->tag_tid);
+		ceph_encode_64(&p, position->entry_tid);
+	}
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "client_commit",
+			     CEPH_OSD_FLAG_WRITE, req_page, buf_size, NULL,
+			     NULL);
+
+	__free_page(req_page);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_cls_journal_client_committed);
+
+int ceph_cls_journal_set_minimum_set(struct ceph_osd_client *osdc,
+				     struct ceph_object_id *oid,
+				     struct ceph_object_locator *oloc,
+				     u64 minimum_set)
+{
+	struct page *req_page;
+	void *p;
+	int ret;
+
+	req_page = alloc_page(GFP_NOIO);
+	if (!req_page)
+		return -ENOMEM;
+
+	p = page_address(req_page);
+	ceph_encode_64(&p, minimum_set);
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "set_minimum_set",
+			     CEPH_OSD_FLAG_WRITE, req_page, 8, NULL, NULL);
+
+	__free_page(req_page);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_cls_journal_set_minimum_set);
+
+int ceph_cls_journal_set_active_set(struct ceph_osd_client *osdc,
+				    struct ceph_object_id *oid,
+				    struct ceph_object_locator *oloc,
+				    u64 active_set)
+{
+	struct page *req_page;
+	void *p;
+	int ret;
+
+	req_page = alloc_page(GFP_NOIO);
+	if (!req_page)
+		return -ENOMEM;
+
+	p = page_address(req_page);
+	ceph_encode_64(&p, active_set);
+	ret = ceph_osdc_call(osdc, oid, oloc, "journal", "set_active_set",
+			     CEPH_OSD_FLAG_WRITE, req_page, 8, NULL, NULL);
+
+	__free_page(req_page);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_cls_journal_set_active_set);
-- 
1.8.3.1



Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61E77788B5
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2019 11:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfG2Jnj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Jul 2019 05:43:39 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22754 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbfG2Jni (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Jul 2019 05:43:38 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowADHYpWjvz5djxunAA--.901S14;
        Mon, 29 Jul 2019 17:43:03 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v3 12/15] rbd: introduce rbd_journal_allocate_tag to allocate journal tag for rbd client
Date:   Mon, 29 Jul 2019 09:42:54 +0000
Message-Id: <1564393377-28949-13-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowADHYpWjvz5djxunAA--.901S14
X-Coremail-Antispam: 1Uf129KBjvJXoWxGr4kCF47uFy8tF4kXw17Awb_yoWruw18pF
        yDCryrGrZ5AF17J3yxXF45AFWFq340yry2g3sI93s7tanayrZ3tr1IkF9YqFW2yFW7W3W8
        GFs8JrZ5C3yqk37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0Jbtku7UUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiRgcBelbdGtvdJgAAsL
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

rbd_journal_allocate_tag() get the client by client id and allocate an uniq tag
for this client.

All journal events from this client will be tagged by this tag.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 drivers/block/rbd.c | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 337a20f..86008f2 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -28,16 +28,19 @@
 
  */
 
+#include <linux/crc32c.h>
 #include <linux/ceph/libceph.h>
 #include <linux/ceph/osd_client.h>
 #include <linux/ceph/mon_client.h>
 #include <linux/ceph/cls_lock_client.h>
 #include <linux/ceph/striper.h>
 #include <linux/ceph/decode.h>
+#include <linux/ceph/journaler.h>
 #include <linux/parser.h>
 #include <linux/bsearch.h>
 
 #include <linux/kernel.h>
+#include <linux/bio.h>
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/blk-mq.h>
@@ -470,6 +473,14 @@ enum rbd_dev_flags {
 	RBD_DEV_FLAG_REMOVING,	/* this mapping is being removed */
 };
 
+#define	LOCAL_MIRROR_UUID	""
+#define	LOCAL_CLIENT_ID		""
+
+struct rbd_journal {
+	struct ceph_journaler *journaler;
+	uint64_t		tag_tid;
+};
+
 static DEFINE_MUTEX(client_mutex);	/* Serialize client creation */
 
 static LIST_HEAD(rbd_dev_list);    /* devices */
@@ -6916,6 +6927,107 @@ static int rbd_dev_header_name(struct rbd_device *rbd_dev)
 	return ret;
 }
 
+typedef struct rbd_journal_tag_predecessor {
+	bool commit_valid;
+	uint64_t tag_tid;
+	uint64_t entry_tid;
+	uint32_t uuid_len;
+	char *mirror_uuid;
+} rbd_journal_tag_predecessor;
+
+typedef struct rbd_journal_tag_data {
+	struct rbd_journal_tag_predecessor predecessor;
+	uint32_t uuid_len;
+	char *mirror_uuid;
+} rbd_journal_tag_data;
+
+static uint32_t tag_data_encoding_size(struct rbd_journal_tag_data *tag_data)
+{
+	// sizeof(uuid_len) 4 + uuid_len + 1 commit_valid + 8 tag_tid +
+	// 8 entry_tid + 4 sizeof(uuid_len) + uuid_len
+	return (4 + tag_data->uuid_len + 1 + 8 + 8 + 4 +
+		tag_data->predecessor.uuid_len);
+}
+
+static void predecessor_encode(void **p, void *end,
+			       struct rbd_journal_tag_predecessor *predecessor)
+{
+	ceph_encode_string(p, end, predecessor->mirror_uuid,
+			   predecessor->uuid_len);
+	ceph_encode_8(p, predecessor->commit_valid);
+	ceph_encode_64(p, predecessor->tag_tid);
+	ceph_encode_64(p, predecessor->entry_tid);
+}
+
+static int rbd_journal_encode_tag_data(void **p, void *end,
+				       struct rbd_journal_tag_data *tag_data)
+{
+	struct rbd_journal_tag_predecessor *predecessor = &tag_data->predecessor;
+
+	ceph_encode_string(p, end, tag_data->mirror_uuid, tag_data->uuid_len);
+	predecessor_encode(p, end, predecessor);
+
+	return 0;
+}
+
+static int rbd_journal_allocate_tag(struct rbd_journal *journal)
+{
+	struct ceph_journaler_tag tag = {};
+	struct rbd_journal_tag_data tag_data = {};
+	struct ceph_journaler *journaler = journal->journaler;
+	struct ceph_journaler_client *client;
+	struct rbd_journal_tag_predecessor *predecessor;
+	struct ceph_journaler_object_pos *position;
+	void *orig_buf, *buf, *p, *end;
+	uint32_t buf_len;
+	int ret;
+
+	ret = ceph_journaler_get_cached_client(journaler, LOCAL_CLIENT_ID, &client);
+	if (ret)
+		goto out;
+
+	position = list_first_entry(&client->object_positions,
+				    struct ceph_journaler_object_pos, node);
+
+	predecessor = &tag_data.predecessor;
+	predecessor->commit_valid = true;
+	predecessor->tag_tid = position->tag_tid;
+	predecessor->entry_tid = position->entry_tid;
+	predecessor->uuid_len = 0;
+	predecessor->mirror_uuid = LOCAL_MIRROR_UUID;
+
+	tag_data.uuid_len = 0;
+	tag_data.mirror_uuid = LOCAL_MIRROR_UUID;
+
+	buf_len = tag_data_encoding_size(&tag_data);
+	p = kmalloc(buf_len, GFP_KERNEL);
+	if (!p) {
+		pr_err("failed to allocate tag data");
+		return -ENOMEM;
+	}
+
+	end = p + buf_len;
+	orig_buf = buf = p;
+	ret = rbd_journal_encode_tag_data(&p, end, &tag_data);
+	if (ret) {
+		pr_err("error in tag data");
+		goto free_buf;
+	}
+
+	ret = ceph_journaler_allocate_tag(journaler, 0, buf, buf_len, &tag);
+	if (ret)
+		goto free_data;
+
+	journal->tag_tid = tag.tid;
+free_data:
+	if(tag.data)
+		kfree(tag.data);
+free_buf:
+	kfree(orig_buf);
+out:
+	return ret;
+}
+
 static void rbd_dev_image_release(struct rbd_device *rbd_dev)
 {
 	rbd_dev_unprobe(rbd_dev);
-- 
1.8.3.1



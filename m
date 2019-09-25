Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF13BDA8B
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Sep 2019 11:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387618AbfIYJJP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Sep 2019 05:09:15 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:21327 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbfIYJIn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 25 Sep 2019 05:08:43 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAD3dl9YLotdHDhSAg--.166S11;
        Wed, 25 Sep 2019 17:07:39 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v4 09/12] rbd: introduce rbd_journal_allocate_tag to allocate journal tag for rbd client
Date:   Wed, 25 Sep 2019 09:07:31 +0000
Message-Id: <1569402454-4736-10-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569402454-4736-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1569402454-4736-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowAD3dl9YLotdHDhSAg--.166S11
X-Coremail-Antispam: 1Uf129KBjvJXoWxGr4DZFyfurW7XF48Xw45GFg_yoWrXr47pF
        1DGryrCrW5Ar17Z3yxAF4rAFZaqry0yryjgasIkwn3K3Z3trZrtF1IkFykJFZFyFW7G3W8
        Gr45trW5CrWqk37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JbRo7_UUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbifhs7elrpOTHIEAAAsH
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

rbd_journal_allocate_tag() get the client by client id and allocate an uniq tag
for this client.

All journal events from this client will be tagged by this tag.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 drivers/block/rbd.c | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 6b387d9..6987259 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -34,6 +34,7 @@
 #include <linux/ceph/cls_lock_client.h>
 #include <linux/ceph/striper.h>
 #include <linux/ceph/decode.h>
+#include <linux/ceph/journaler.h>
 #include <linux/parser.h>
 #include <linux/bsearch.h>
 
@@ -445,6 +446,8 @@ struct rbd_device {
 	atomic_t		parent_ref;
 	struct rbd_device	*parent;
 
+	struct rbd_journal	*journal;
+
 	/* Block layer tags. */
 	struct blk_mq_tag_set	tag_set;
 
@@ -470,6 +473,11 @@ enum rbd_dev_flags {
 	RBD_DEV_FLAG_REMOVING,	/* this mapping is being removed */
 };
 
+struct rbd_journal {
+	struct ceph_journaler *journaler;
+	u64		tag_tid;
+};
+
 static DEFINE_MUTEX(client_mutex);	/* Serialize client creation */
 
 static LIST_HEAD(rbd_dev_list);    /* devices */
@@ -6916,6 +6924,94 @@ static int rbd_dev_header_name(struct rbd_device *rbd_dev)
 	return ret;
 }
 
+struct rbd_journal_tag_predecessor {
+	bool commit_valid;
+	u64 tag_tid;
+	u64 entry_tid;
+};
+
+struct rbd_journal_tag_data {
+	struct rbd_journal_tag_predecessor predecessor;
+};
+
+static u32 tag_data_encoding_size(struct rbd_journal_tag_data *tag_data)
+{
+	/*
+	 *  sizeof(uuid_len) 4 + uuid_len(0) + 1 commit_valid + 8 tag_tid +
+	 *  8 entry_tid + 4 sizeof(uuid_len) + uuid_len(0)
+	 */
+	return (4 + 0 + 1 + 8 + 8 + 4 + 0);
+}
+
+static void predecessor_encode(void **p, void *end,
+			       struct rbd_journal_tag_predecessor *predecessor)
+{
+	/* Encode mirror uuid, as it's "", let's just encode 0 */
+	ceph_encode_32(p, 0);
+	ceph_encode_8(p, predecessor->commit_valid);
+	ceph_encode_64(p, predecessor->tag_tid);
+	ceph_encode_64(p, predecessor->entry_tid);
+}
+
+static void rbd_journal_encode_tag_data(void **p, void *end,
+					struct rbd_journal_tag_data *tag_data)
+{
+	/* Encode mirror uuid, as it's "", let's just encode 0 */
+	ceph_encode_32(p, 0);
+	predecessor_encode(p, end, &tag_data->predecessor);
+}
+
+#define LOCAL_CLIENT_ID ""
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
+	u32 buf_len;
+	int ret;
+
+	ret = ceph_journaler_get_cached_client(journaler, LOCAL_CLIENT_ID,
+					       &client);
+	if (ret)
+		goto out;
+
+	if (!list_empty(&client->object_positions)) {
+		position = list_first_entry(&client->object_positions,
+					    struct ceph_journaler_object_pos,
+					    node);
+		predecessor = &tag_data.predecessor;
+		predecessor->commit_valid = true;
+		predecessor->tag_tid = position->tag_tid;
+		predecessor->entry_tid = position->entry_tid;
+	}
+	buf_len = tag_data_encoding_size(&tag_data);
+	p = kmalloc(buf_len, GFP_KERNEL);
+	if (!p) {
+		pr_err("failed to allocate tag data");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	end = p + buf_len;
+	orig_buf = buf = p;
+	rbd_journal_encode_tag_data(&p, end, &tag_data);
+
+	ret = ceph_journaler_allocate_tag(journaler, 0, buf, buf_len, &tag);
+	if (ret)
+		goto free_buf;
+
+	journal->tag_tid = tag.tid;
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



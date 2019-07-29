Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07FFA788B7
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2019 11:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbfG2Jnn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Jul 2019 05:43:43 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22806 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbfG2Jnm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Jul 2019 05:43:42 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowADHYpWjvz5djxunAA--.901S16;
        Mon, 29 Jul 2019 17:43:04 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v3 14/15] rbd: replay events in journal
Date:   Mon, 29 Jul 2019 09:42:56 +0000
Message-Id: <1564393377-28949-15-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowADHYpWjvz5djxunAA--.901S16
X-Coremail-Antispam: 1Uf129KBjvJXoWxXr17WFy8Kr4rKF43WFy5XFb_yoWrur47pF
        WUJFWakrs5CF12vr4fGan5Zr15X3yxArZrWry7KrnF9an5Grn2kF1rCFyYvrW3ZFW7GF18
        GFs0qr97Wr1qqFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0Jbtku7UUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiPAgBelyqDvPC4gAAsk
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

when we found uncommitted events in journal, we need to do a replay.
This commit only implement three kinds of events replaying:

EVENT_TYPE_AIO_DISCARD:
        Will send a img_request to image with OBJ_OP_DISCARD, and
        wait for it completed.
EVENT_TYPE_AIO_WRITE:
        Will send a img_request to image with OBJ_OP_WRITE, and
        wait for it completed.
EVENT_TYPE_AIO_FLUSH:
        As all other events are replayed in synchoronized way, that
        means the events before are all flushed. we did nothing for this event.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 drivers/block/rbd.c | 128 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 89bc7b3..3c44db7 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -7175,6 +7175,134 @@ static void rbd_img_journal_append(struct rbd_img_request *img_req)
 	}
 }
 
+static int rbd_journal_handle_aio_discard(struct rbd_device *rbd_dev, void **p, void *end, u8 struct_v, uint64_t commit_tid)
+{
+	uint64_t offset;
+	uint64_t length;
+	int result;
+	enum obj_operation_type op_type;
+	struct rbd_img_request *img_request;
+	struct ceph_snap_context *snapc;
+
+	offset = ceph_decode_64(p);
+	length = ceph_decode_64(p);
+
+	snapc = rbd_dev->header.snapc;
+	ceph_get_snap_context(snapc);
+	op_type = OBJ_OP_DISCARD;
+
+	img_request = rbd_img_request_create(rbd_dev, op_type, snapc);
+	if (!img_request) {
+		result = -ENOMEM;
+		goto err;
+	}
+	__set_bit(IMG_REQ_NOLOCK, &img_request->flags);
+	img_request->journaler_commit_tid = commit_tid;
+	result = rbd_img_fill_nodata(img_request, offset, length);
+	if (result)
+		goto err;
+
+	img_request->state = RBD_IMG_APPEND_JOURNAL;
+	rbd_img_handle_request(img_request, 0);
+	result = wait_for_completion_interruptible(&img_request->completion);
+err:
+	return result;
+}
+
+static int rbd_journal_handle_aio_write(struct rbd_device *rbd_dev, void **p, void *end, u8 struct_v, uint64_t commit_tid)
+{
+	uint64_t offset;
+	uint64_t length;
+	char *data;
+	ssize_t data_len;
+	int result;
+	enum obj_operation_type op_type;
+	struct ceph_snap_context *snapc;
+	struct rbd_img_request *img_request;
+
+	struct ceph_file_extent ex;
+	struct bio_vec *bvecs = NULL;
+
+	offset = ceph_decode_64(p);
+	length = ceph_decode_64(p);
+
+	data_len = ceph_decode_32(p);
+	if (!ceph_has_room(p, end, data_len)) {
+		pr_err("our of range");
+		return -ERANGE;
+	}
+
+	data = *p;
+	*p = (char *) *p + data_len;
+
+	snapc = rbd_dev->header.snapc;
+	ceph_get_snap_context(snapc);
+	op_type = OBJ_OP_WRITE;
+
+	img_request = rbd_img_request_create(rbd_dev, op_type, snapc);
+	if (!img_request) {
+		result = -ENOMEM;
+		goto err;
+	}
+
+	__set_bit(IMG_REQ_NOLOCK, &img_request->flags);
+	img_request->journaler_commit_tid = commit_tid;
+	snapc = NULL; /* img_request consumes a ref */
+
+	ex.fe_off = offset;
+	ex.fe_len = length;
+
+	bvecs = setup_write_bvecs(data, offset, length);
+	if (!bvecs)
+		rbd_warn(rbd_dev, "failed to alloc bvecs.");
+	result = rbd_img_fill_from_bvecs(img_request,
+				         &ex, 1, bvecs);
+	if (result)
+		goto err;
+
+	img_request->state = RBD_IMG_APPEND_JOURNAL;
+	rbd_img_handle_request(img_request, 0);
+	result = wait_for_completion_interruptible(&img_request->completion);
+err:
+	if (bvecs)
+		kfree(bvecs);
+	return result;
+}
+
+static int rbd_journal_replay(void *entry_handler, struct ceph_journaler_entry *entry, uint64_t commit_tid)
+{
+	struct rbd_device *rbd_dev = entry_handler;
+	void *data = entry->data;
+	void **p = &data;
+	void *end = *p + entry->data_len;
+	uint32_t event_type;
+	u8 struct_v;
+	u32 struct_len;
+	int ret;
+
+	ret = ceph_start_decoding(p, end, 1, "rbd_decode_entry",
+				  &struct_v, &struct_len);
+	if (ret)
+		return -EINVAL;
+
+	event_type = ceph_decode_32(p);
+
+	switch (event_type) {
+	case EVENT_TYPE_AIO_WRITE:
+		ret = rbd_journal_handle_aio_write(rbd_dev, p, end, struct_v, commit_tid);
+		break;
+	case EVENT_TYPE_AIO_DISCARD:
+		ret = rbd_journal_handle_aio_discard(rbd_dev, p, end, struct_v, commit_tid);
+		break;
+	case EVENT_TYPE_AIO_FLUSH:
+		break;
+	default:
+		rbd_warn(rbd_dev, "unknown event_type: %u", event_type);
+		return -EINVAL;
+	}
+	return ret;
+}
+
 typedef struct rbd_journal_tag_predecessor {
 	bool commit_valid;
 	uint64_t tag_tid;
-- 
1.8.3.1



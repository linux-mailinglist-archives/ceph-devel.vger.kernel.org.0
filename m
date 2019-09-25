Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9BAABDA88
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Sep 2019 11:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387569AbfIYJJP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Sep 2019 05:09:15 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:21512 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728572AbfIYJIn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 25 Sep 2019 05:08:43 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAD3dl9YLotdHDhSAg--.166S13;
        Wed, 25 Sep 2019 17:07:40 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v4 11/12] rbd: replay events in journal
Date:   Wed, 25 Sep 2019 09:07:33 +0000
Message-Id: <1569402454-4736-12-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569402454-4736-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1569402454-4736-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowAD3dl9YLotdHDhSAg--.166S13
X-Coremail-Antispam: 1Uf129KBjvJXoWxtF17Jr43AF1UKr1kJrW5KFg_yoW3Wr47pF
        W5GFWYkrZ5WF129rs3Gr4rZryaq397AFZrWry7Kr129rnxGwn29F1FkFyavrW3ZFWxu34D
        KF4qq3ZFgF1qgFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JbMYLgUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiXxw7eli2k8jLgAAAs8
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

when we found uncommitted events in journal, we need to do a replay.
This commit only implement three kinds of events replaying:

EVENT_TYPE_AIO_DISCARD:
        Will send a img_request to image with OBJ_OP_ZEROOUT, and
        wait for it completed.
EVENT_TYPE_AIO_WRITE:
        Will send a img_request to image with OBJ_OP_WRITE, and
        wait for it completed.
EVENT_TYPE_AIO_FLUSH:
        As all other events are replayed in synchoronized way, that
        means the events before are all flushed. we did nothing for this event.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 drivers/block/rbd.c | 236 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 236 insertions(+)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 79929c7..e8c2446 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -7182,6 +7182,242 @@ static void rbd_img_journal_append(struct rbd_img_request *img_req)
 	}
 }
 
+static int setup_write_bvecs(void *buf, u64 offset,
+			     u64 length, struct bio_vec **bvecs,
+			     u32 *bvec_count)
+{
+	u32 i;
+	u32 off;
+
+	*bvec_count = calc_pages_for(offset, length);
+	*bvecs = kcalloc(*bvec_count, sizeof(**bvecs), GFP_NOIO);
+	if (!(*bvecs))
+		return -ENOMEM;
+
+	div_u64_rem(offset, PAGE_SIZE, &off);
+	for (i = 0; i < *bvec_count; i++) {
+		u32 len = min(length, (u64)PAGE_SIZE - off);
+
+		(*bvecs)[i].bv_page = alloc_page(GFP_NOIO);
+		if (!(*bvecs)[i].bv_page)
+			return -ENOMEM;
+
+		(*bvecs)[i].bv_offset = off;
+		(*bvecs)[i].bv_len = len;
+		memcpy(page_address((*bvecs)[i].bv_page) + (*bvecs)[i].bv_offset, buf,
+		       (*bvecs)[i].bv_len);
+		length -= len;
+		buf += len;
+		off = 0;
+	}
+	rbd_assert(!length);
+	return 0;
+}
+
+static int rbd_journal_handle_aio_write(struct rbd_device *rbd_dev, void **p,
+					void *end, u8 struct_v, u64 commit_tid)
+{
+	struct ceph_snap_context *snapc;
+	struct rbd_img_request *img_request;
+	struct journal_commit_info *commit_info;
+	struct ceph_file_extent ex;
+	struct bio_vec *bvecs = NULL;
+	u32 bvec_count;
+	ssize_t data_len;
+	u64 offset, length;
+	int result;
+
+	/* get offset and length */
+	offset = ceph_decode_64(p);
+	length = ceph_decode_64(p);
+	/* get data_len and check the buffer length */
+	data_len = ceph_decode_32(p);
+	if (!ceph_has_room(p, end, data_len)) {
+		pr_err("our of range");
+		return -ERANGE;
+	}
+	rbd_assert(length == data_len);
+	/* Create a new image request for writing */
+	snapc = rbd_dev->header.snapc;
+	ceph_get_snap_context(snapc);
+	img_request = rbd_img_request_create(rbd_dev, OBJ_OP_WRITE, snapc);
+	if (!img_request) {
+		result = -ENOMEM;
+		goto err;
+	}
+	/* Allocate a new commit_info for this journal replay */
+	commit_info = kzalloc(sizeof(*commit_info), GFP_NOIO);
+	if (!commit_info) {
+		result = -ENOMEM;
+		rbd_img_request_put(img_request);
+		goto err;
+	}
+	INIT_LIST_HEAD(&commit_info->node);
+
+	/* Don't down ->lock_rwsem in __rbd_img_handle_request */
+	__set_bit(IMG_REQ_NOLOCK, &img_request->flags);
+	commit_info->commit_tid = commit_tid;
+	list_add_tail(&commit_info->node, &img_request->journal_commit_list);
+	snapc = NULL; /* img_request consumes a ref */
+
+	result = setup_write_bvecs(*p, offset, length, &bvecs, &bvec_count);
+	if (result) {
+		rbd_warn(rbd_dev, "failed to setup bvecs.");
+		rbd_img_request_put(img_request);
+		goto err;
+	}
+	/* Skip data for this event */
+	*p = (char *)*p + data_len;
+	ex.fe_off = offset;
+	ex.fe_len = length;
+	result = rbd_img_fill_from_bvecs(img_request, &ex, 1, bvecs);
+	if (result) {
+		rbd_img_request_put(img_request);
+		goto err;
+	}
+	/* 
+	 * As we are doing journal replaying in exclusive-lock aqcuiring,
+	 * we don't need to aquire exclusive-lock for this writing, so
+	 * set the ->state to RBD_IMG_APPEND_JOURNAL to skip exclusive-lock
+	 * acquiring in state machine
+	 */
+	img_request->state = RBD_IMG_APPEND_JOURNAL;
+	rbd_img_handle_request(img_request, 0);
+	result = wait_for_completion_interruptible(&img_request->completion);
+err:
+	if (bvecs) {
+		int i;
+
+		for (i = 0; i < bvec_count; i++) {
+			if (bvecs[i].bv_page)
+				__free_page(bvecs[i].bv_page);
+		}
+		kfree(bvecs);
+	}
+	return result;
+}
+
+static int rbd_journal_handle_aio_discard(struct rbd_device *rbd_dev, void **p,
+					  void *end, u8 struct_v,
+					  u64 commit_tid)
+{
+	struct rbd_img_request *img_request;
+	struct ceph_snap_context *snapc;
+	struct journal_commit_info *commit_info;
+	enum obj_operation_type	op_type;
+	u64 offset, length;
+	bool skip_partial_discard = true;
+	int result;
+
+	/* get offset and length*/
+	offset = ceph_decode_64(p);
+	length = ceph_decode_64(p);
+	if (struct_v >= 4)
+		skip_partial_discard = ceph_decode_8(p);
+	if (struct_v >= 5) {
+		/* skip discard_granularity_bytes */
+		ceph_decode_32(p);
+	}
+
+	snapc = rbd_dev->header.snapc;
+	ceph_get_snap_context(snapc);
+	/*
+	 * When the skip_partial_discard is false, we need to guarantee
+	 * that the data range would be zeroout-ed. Otherwise, we don't
+	 * guarantee the range discarded would be zero filled.
+	 */
+	if (skip_partial_discard)
+		op_type = OBJ_OP_DISCARD;
+	else
+		op_type = OBJ_OP_ZEROOUT;
+
+	img_request = rbd_img_request_create(rbd_dev, op_type, snapc);
+	if (!img_request) {
+		result = -ENOMEM;
+		goto err;
+	}
+	/* Allocate a commit_info for this image request */
+	commit_info = kzalloc(sizeof(*commit_info), GFP_NOIO);
+	if (!commit_info) {
+		result = -ENOMEM;
+		rbd_img_request_put(img_request);
+		goto err;
+	}
+	INIT_LIST_HEAD(&commit_info->node);
+
+	/* Don't down ->lock_rwsem in __rbd_img_handle_request */
+	__set_bit(IMG_REQ_NOLOCK, &img_request->flags);
+	commit_info->commit_tid = commit_tid;
+	list_add_tail(&commit_info->node, &img_request->journal_commit_list);
+	result = rbd_img_fill_nodata(img_request, offset, length);
+	if (result) {
+		rbd_img_request_put(img_request);
+		goto err;
+	}
+
+	img_request->state = RBD_IMG_APPEND_JOURNAL;
+	rbd_img_handle_request(img_request, 0);
+	result = wait_for_completion_interruptible(&img_request->completion);
+err:
+	return result;
+}
+
+static int rbd_journal_replay(void *entry_handler,
+			      struct ceph_journaler_entry *entry,
+			      u64 commit_tid)
+{
+	struct rbd_device *rbd_dev = entry_handler;
+	void *data = entry->data;
+	void **p = &data;
+	void *end = *p + entry->data_len;
+	u32 event_type;
+	u8 struct_v;
+	u32 struct_len;
+	int ret;
+
+	ret = ceph_start_decoding(p, end, 1, "rbd_decode_entry", &struct_v,
+				  &struct_len);
+	if (ret)
+		return -EINVAL;
+
+	event_type = ceph_decode_32(p);
+	switch (event_type) {
+	case EVENT_TYPE_AIO_WRITE:
+		ret = rbd_journal_handle_aio_write(rbd_dev, p, end, struct_v,
+						   commit_tid);
+		break;
+	case EVENT_TYPE_AIO_DISCARD:
+		ret = rbd_journal_handle_aio_discard(rbd_dev, p, end, struct_v,
+						     commit_tid);
+		break;
+	case EVENT_TYPE_AIO_FLUSH:
+		/*
+		 * As the all event replaying are synchronized, we don't
+		 * need any more work for replaying flush event. Just
+		 * commit it.
+		 */
+		ceph_journaler_client_committed(rbd_dev->journal->journaler,
+						commit_tid);
+		break;
+	default:
+		rbd_warn(rbd_dev, "unknown event_type: %u", event_type);
+		return -EINVAL;
+	}
+
+	if (struct_v >= 4) {
+		u8 meta_struct_v;
+		u32 meta_struct_len;
+
+		/* skip metadata */
+		ret = ceph_start_decoding(p, end, 1, "decode_metadata",
+					     &meta_struct_v, &meta_struct_len);
+		if (ret)
+			return ret;
+		*p += meta_struct_len;
+	}
+	return ret;
+}
+
 struct rbd_journal_tag_predecessor {
 	bool commit_valid;
 	u64 tag_tid;
-- 
1.8.3.1



Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A79A2788AF
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2019 11:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbfG2Jng (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Jul 2019 05:43:36 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22720 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbfG2Jng (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Jul 2019 05:43:36 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowADHYpWjvz5djxunAA--.901S11;
        Mon, 29 Jul 2019 17:43:02 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v3 09/15] libceph: journaling: trim object set when we found there is no client refer it
Date:   Mon, 29 Jul 2019 09:42:51 +0000
Message-Id: <1564393377-28949-10-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowADHYpWjvz5djxunAA--.901S11
X-Coremail-Antispam: 1Uf129KBjvJXoWxAFykWw17Jw1xCFy3AF13Jwb_yoWrGw1kpr
        s8Xr1fArW8ZF1furs7JrsYqFZ0vrW0vFW7GrnIkF9ak3W7XrZIgF18JFyqqry3Jry7G3Zx
        tF4UJa15Ww42qFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JbEAw3UUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiTAYBeldp-zDARwAAsH
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When we found there is no client refre to the object set, we can remove the
objects.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 net/ceph/journaler.c | 108 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/net/ceph/journaler.c b/net/ceph/journaler.c
index 26a5b97..22b9bc7 100644
--- a/net/ceph/journaler.c
+++ b/net/ceph/journaler.c
@@ -237,6 +237,10 @@ void ceph_journaler_destroy(struct ceph_journaler *journaler)
 }
 EXPORT_SYMBOL(ceph_journaler_destroy);
 
+static int remove_set(struct ceph_journaler *journaler, uint64_t object_set);
+static int set_minimum_set(struct ceph_journaler* journaler,
+			   uint64_t minimum_set);
+
 static int refresh(struct ceph_journaler *journaler, bool init)
 {
 	int ret;
@@ -309,6 +313,25 @@ static int refresh(struct ceph_journaler *journaler, bool init)
 		queue_work(journaler->task_wq, &journaler->flush_work);
 	}
 
+	// remove set if necessary
+	if (minimum_commit_set > minimum_set) {
+		uint64_t trim_set = minimum_set;
+		while (trim_set < minimum_commit_set) {
+			ret = remove_set(journaler, trim_set);
+			if (ret < 0 && ret != -ENOENT) {
+				pr_err("failed to trim object_set: %llu", trim_set);
+				return ret;
+			}
+			trim_set++;
+		}
+
+		ret = set_minimum_set(journaler, minimum_commit_set);
+		if (ret < 0) {
+			pr_err("failed to set minimum set to %llu", minimum_commit_set);
+			return ret;
+		}
+	}
+
 	return 0;
 
 }
@@ -2121,3 +2144,88 @@ int ceph_journaler_allocate_tag(struct ceph_journaler *journaler,
 	return ret;
 }
 EXPORT_SYMBOL(ceph_journaler_allocate_tag);
+
+// trimming
+static int ceph_journaler_obj_remove_sync(struct ceph_journaler *journaler,
+			     struct ceph_object_id *oid,
+			     struct ceph_object_locator *oloc)
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
+
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
+static int remove_set(struct ceph_journaler *journaler, uint64_t object_set)
+{
+	uint64_t object_num;
+	int splay_offset;
+	struct ceph_object_id object_oid;
+	int ret;
+
+	ceph_oid_init(&object_oid);
+	for (splay_offset = 0; splay_offset < journaler->splay_width; splay_offset++) {
+		object_num = splay_offset + (object_set * journaler->splay_width);
+		if (!ceph_oid_empty(&object_oid)) {
+			ceph_oid_destroy(&object_oid);
+			ceph_oid_init(&object_oid);
+		}
+		ret = ceph_oid_aprintf(&object_oid, GFP_NOIO, "%s%llu",
+					journaler->object_oid_prefix, object_num);
+		if (ret) {
+			pr_err("aprintf error : %d", ret);
+			goto out;
+		}
+		ret = ceph_journaler_obj_remove_sync(journaler, &object_oid,
+						     &journaler->data_oloc);
+		if (ret < 0 && ret != -ENOENT) {
+			pr_err("%s: failed to remove object: %llu",
+				 __func__, object_num);
+			goto out;
+		}
+	}
+	ret = 0;
+out:
+	ceph_oid_destroy(&object_oid);
+	return ret;
+}
+
+static int set_minimum_set(struct ceph_journaler* journaler,
+			   uint64_t minimum_set)
+{
+	int ret;
+
+	ret = ceph_cls_journaler_set_minimum_set(journaler->osdc,
+						 &journaler->header_oid,
+						 &journaler->header_oloc,
+						 minimum_set);
+	if (ret < 0) {
+		pr_err("%s: failed to set_minimum_set: %d", __func__, ret);
+		return ret;
+	}
+
+	queue_work(journaler->task_wq, &journaler->notify_update_work);
+
+	return ret;
+}
-- 
1.8.3.1



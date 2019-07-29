Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD2F788B2
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2019 11:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbfG2Jnh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Jul 2019 05:43:37 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22637 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbfG2Jnh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Jul 2019 05:43:37 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowADHYpWjvz5djxunAA--.901S4;
        Mon, 29 Jul 2019 17:43:00 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v3 02/15] libceph: introduce a new parameter of workqueue in ceph_osdc_watch()
Date:   Mon, 29 Jul 2019 09:42:44 +0000
Message-Id: <1564393377-28949-3-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowADHYpWjvz5djxunAA--.901S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxCr1ktFWfJw48Jw4xZw4fKrg_yoW5Ar18pa
        y3Cw12yay8Jr47Wa13Aa9avrsagw4kuFy7Kry2kw1akFnIqFZIqF1kKFyYvFy7XFyfGaya
        vF4jyrZxGw4jy3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0J1jFksUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiVgQBelf4pWzLkQAAsV
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently, if we share osdc in rbd device and journaling, they are
sharing the notify_wq in osdc to complete watch_cb. When we
need to close journal held with mutex of rbd device, we need
to flush the notify_wq. But we don't want to flush the watch_cb
of rbd_device, maybe some of it need to lock rbd mutex.

To solve this problem, this patch allow user to manage the notify
workqueue by themselves in watching.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 drivers/block/rbd.c             | 2 +-
 include/linux/ceph/osd_client.h | 2 ++
 net/ceph/osd_client.c           | 8 +++++++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 3327192..d7ed462 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4569,7 +4569,7 @@ static int __rbd_register_watch(struct rbd_device *rbd_dev)
 	dout("%s rbd_dev %p\n", __func__, rbd_dev);
 
 	handle = ceph_osdc_watch(osdc, &rbd_dev->header_oid,
-				 &rbd_dev->header_oloc, rbd_watch_cb,
+				 &rbd_dev->header_oloc, NULL, rbd_watch_cb,
 				 rbd_watch_errcb, rbd_dev);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index ad7fe5d..9a4533a 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -282,6 +282,7 @@ struct ceph_osd_linger_request {
 	rados_watcherrcb_t errcb;
 	void *data;
 
+	struct workqueue_struct *wq;
 	struct page ***preply_pages;
 	size_t *preply_len;
 };
@@ -539,6 +540,7 @@ struct ceph_osd_linger_request *
 ceph_osdc_watch(struct ceph_osd_client *osdc,
 		struct ceph_object_id *oid,
 		struct ceph_object_locator *oloc,
+		struct workqueue_struct *wq,
 		rados_watchcb2_t wcb,
 		rados_watcherrcb_t errcb,
 		void *data);
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 0b2df09..62d2f54 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2842,7 +2842,10 @@ static void lwork_queue(struct linger_work *lwork)
 
 	lwork->queued_stamp = jiffies;
 	list_add_tail(&lwork->pending_item, &lreq->pending_lworks);
-	queue_work(osdc->notify_wq, &lwork->work);
+	if (lreq->wq)
+		queue_work(lreq->wq, &lwork->work);
+	else
+		queue_work(osdc->notify_wq, &lwork->work);
 }
 
 static void do_watch_notify(struct work_struct *w)
@@ -4595,6 +4598,7 @@ struct ceph_osd_linger_request *
 ceph_osdc_watch(struct ceph_osd_client *osdc,
 		struct ceph_object_id *oid,
 		struct ceph_object_locator *oloc,
+		struct workqueue_struct *wq,
 		rados_watchcb2_t wcb,
 		rados_watcherrcb_t errcb,
 		void *data)
@@ -4610,6 +4614,8 @@ struct ceph_osd_linger_request *
 	lreq->wcb = wcb;
 	lreq->errcb = errcb;
 	lreq->data = data;
+	if (wq)
+		lreq->wq = wq;
 	lreq->watch_valid_thru = jiffies;
 
 	ceph_oid_copy(&lreq->t.base_oid, oid);
-- 
1.8.3.1



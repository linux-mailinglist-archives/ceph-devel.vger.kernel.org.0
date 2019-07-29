Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A58F788BC
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2019 11:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfG2Jnx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Jul 2019 05:43:53 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:23111 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbfG2Jnw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Jul 2019 05:43:52 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowADHYpWjvz5djxunAA--.901S17;
        Mon, 29 Jul 2019 17:43:04 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v3 15/15] rbd: add support for feature of RBD_FEATURE_JOURNALING
Date:   Mon, 29 Jul 2019 09:42:57 +0000
Message-Id: <1564393377-28949-16-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowADHYpWjvz5djxunAA--.901S17
X-Coremail-Antispam: 1Uf129KBjvJXoWxZw13Ww4kJFyftF43JrWrXwb_yoWrCw4rpF
        W8JF9YyrWUZr17uw4fXrs8JrWYqa10y34DWr9rCrn7K3Z3Jrnrta4IkFyUJ3y7tFyUGa1k
        Jr45J3yUCw4UtrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0Jbtku7UUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiQRMBelbdGyrNdAAAsq
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Allow user to map rbd images with journaling enabled, but
there is a warning in demsg:

        WARNING: kernel journaling is EXPERIMENTAL!

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 drivers/block/rbd.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 3c44db7..3e940a7 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -131,6 +131,7 @@ static int atomic_dec_return_safe(atomic_t *v)
 				 RBD_FEATURE_OBJECT_MAP |	\
 				 RBD_FEATURE_FAST_DIFF |	\
 				 RBD_FEATURE_DEEP_FLATTEN |	\
+				 RBD_FEATURE_JOURNALING |	\
 				 RBD_FEATURE_DATA_POOL |	\
 				 RBD_FEATURE_OPERATIONS)
 
@@ -3847,6 +3848,7 @@ static void __rbd_lock(struct rbd_device *rbd_dev, const char *cookie)
 /*
  * lock_rwsem must be held for write
  */
+static int rbd_dev_open_journal(struct rbd_device *rbd_dev);
 static int rbd_lock(struct rbd_device *rbd_dev)
 {
 	struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
@@ -4190,6 +4192,12 @@ static int rbd_post_acquire_action(struct rbd_device *rbd_dev)
 			return ret;
 	}
 
+	if (rbd_dev->header.features & RBD_FEATURE_JOURNALING) {
+		ret = rbd_dev_open_journal(rbd_dev);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
@@ -4320,10 +4328,14 @@ static bool rbd_quiesce_lock(struct rbd_device *rbd_dev)
 	return true;
 }
 
+static void rbd_dev_close_journal(struct rbd_device *rbd_dev);
 static void rbd_pre_release_action(struct rbd_device *rbd_dev)
 {
 	if (rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP)
 		rbd_object_map_close(rbd_dev);
+
+	if (rbd_dev->header.features & RBD_FEATURE_JOURNALING)
+		rbd_dev_close_journal(rbd_dev);
 }
 
 static void __rbd_release_lock(struct rbd_device *rbd_dev)
@@ -7303,6 +7315,88 @@ static int rbd_journal_replay(void *entry_handler, struct ceph_journaler_entry *
 	return ret;
 }
 
+static int rbd_journal_allocate_tag(struct rbd_journal *journal);
+static int rbd_journal_open(struct rbd_journal *journal)
+{
+	struct ceph_journaler *journaler = journal->journaler;
+	int ret;
+
+	ret = ceph_journaler_open(journaler);
+	if (ret)
+		goto out;
+
+	ret = ceph_journaler_start_replay(journaler);
+	if (ret)
+		goto err_close_journaler;
+
+	ret = rbd_journal_allocate_tag(journal);
+	if (ret)
+		goto err_close_journaler;
+	return ret;
+
+err_close_journaler:
+	ceph_journaler_close(journaler);
+
+out:
+	return ret;
+}
+
+static int rbd_dev_open_journal(struct rbd_device *rbd_dev)
+{
+	int ret;
+	struct rbd_journal *journal;
+	struct ceph_journaler *journaler;
+	struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
+
+	// create journal
+	rbd_assert(!rbd_dev->journal);
+
+	journal = kzalloc(sizeof(struct rbd_journal), GFP_KERNEL);
+	if (!journal)
+		return -ENOMEM;
+
+	journaler = ceph_journaler_create(osdc, &rbd_dev->header_oloc,
+					  rbd_dev->spec->image_id,
+					  LOCAL_CLIENT_ID);
+	if (!journaler) {
+		ret = -ENOMEM;
+		goto err_free_journal;
+	}
+
+	// journal init
+	journaler->entry_handler = rbd_dev;
+	journaler->handle_entry = rbd_journal_replay;
+
+	journal->journaler = journaler;
+	rbd_dev->journal = journal;
+
+	// journal open
+	ret = rbd_journal_open(rbd_dev->journal);
+	if (ret)
+		goto err_destroy_journaler;
+
+	return ret;
+
+err_destroy_journaler:
+	ceph_journaler_destroy(journaler);
+err_free_journal:
+	kfree(rbd_dev->journal);
+	rbd_dev->journal = NULL;
+	return ret;
+}
+
+static void rbd_dev_close_journal(struct rbd_device *rbd_dev)
+{
+	rbd_assert(rbd_dev->journal);
+
+	ceph_journaler_close(rbd_dev->journal->journaler);
+	rbd_dev->journal->tag_tid = 0;
+
+	ceph_journaler_destroy(rbd_dev->journal->journaler);
+	kfree(rbd_dev->journal);
+	rbd_dev->journal = NULL;
+}
+
 typedef struct rbd_journal_tag_predecessor {
 	bool commit_valid;
 	uint64_t tag_tid;
@@ -7493,6 +7587,11 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 			goto err_out_probe;
 	}
 
+	if (rbd_dev->header.features & RBD_FEATURE_JOURNALING) {
+		rbd_warn(rbd_dev,
+			 "WARNING: kernel rbd journaling is EXPERIMENTAL!");
+	}
+
 	ret = rbd_dev_probe_parent(rbd_dev, depth);
 	if (ret)
 		goto err_out_probe;
-- 
1.8.3.1



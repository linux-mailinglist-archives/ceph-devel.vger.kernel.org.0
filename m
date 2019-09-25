Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0E6EBDA8A
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Sep 2019 11:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbfIYJJP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Sep 2019 05:09:15 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22135 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728842AbfIYJIp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 25 Sep 2019 05:08:45 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAD3dl9YLotdHDhSAg--.166S14;
        Wed, 25 Sep 2019 17:07:40 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v4 12/12] rbd: add support for feature of RBD_FEATURE_JOURNALING
Date:   Wed, 25 Sep 2019 09:07:34 +0000
Message-Id: <1569402454-4736-13-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569402454-4736-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1569402454-4736-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowAD3dl9YLotdHDhSAg--.166S14
X-Coremail-Antispam: 1Uf129KBjvJXoWxZw1fCF4kWry3uFyrJF13Arb_yoWrCr4DpF
        W8JF9YyrWUZr1xCw4fXrs8JrWYga10y34DWr9rCrn2k3Z3Jrnrta4IkFyUJ3y7JFyUGa1k
        Jr45J3yUCa1UtrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JbKMKAUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiVRw7elf4pXSmVgAAsG
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Allow user to map rbd images with journaling enabled, but
there is a warning in demsg:

        WARNING: kernel journaling is EXPERIMENTAL!

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 drivers/block/rbd.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index e8c2446..5bb98f5 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -129,6 +129,7 @@ static int atomic_dec_return_safe(atomic_t *v)
 				 RBD_FEATURE_OBJECT_MAP |	\
 				 RBD_FEATURE_FAST_DIFF |	\
 				 RBD_FEATURE_DEEP_FLATTEN |	\
+				 RBD_FEATURE_JOURNALING |	\
 				 RBD_FEATURE_DATA_POOL |	\
 				 RBD_FEATURE_OPERATIONS)
 
@@ -3863,6 +3864,7 @@ static void __rbd_lock(struct rbd_device *rbd_dev, const char *cookie)
 /*
  * lock_rwsem must be held for write
  */
+static int rbd_dev_open_journal(struct rbd_device *rbd_dev);
 static int rbd_lock(struct rbd_device *rbd_dev)
 {
 	struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
@@ -4206,6 +4208,12 @@ static int rbd_post_acquire_action(struct rbd_device *rbd_dev)
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
 
@@ -4336,10 +4344,14 @@ static bool rbd_quiesce_lock(struct rbd_device *rbd_dev)
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
@@ -7506,6 +7518,85 @@ static int rbd_journal_allocate_tag(struct rbd_journal *journal)
 	return ret;
 }
 
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
+out:
+	return ret;
+}
+
+static int rbd_dev_open_journal(struct rbd_device *rbd_dev)
+{
+	struct rbd_journal *journal;
+	struct ceph_journaler *journaler;
+	struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
+	int ret;
+
+	/* create journal */
+	rbd_assert(!rbd_dev->journal);
+
+	journal = kzalloc(sizeof(*journal), GFP_KERNEL);
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
+	/* journal init */
+	journaler->entry_handler = rbd_dev;
+	journaler->handle_entry = rbd_journal_replay;
+
+	journal->journaler = journaler;
+	rbd_dev->journal = journal;
+
+	/* journal open */
+	ret = rbd_journal_open(rbd_dev->journal);
+	if (ret)
+		goto err_destroy_journaler;
+
+	return ret;
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
 static void rbd_dev_image_release(struct rbd_device *rbd_dev)
 {
 	rbd_dev_unprobe(rbd_dev);
@@ -7595,6 +7686,10 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 			goto err_out_probe;
 	}
 
+	if (rbd_dev->header.features & RBD_FEATURE_JOURNALING)
+		rbd_warn(rbd_dev,
+			 "WARNING: kernel rbd journaling is EXPERIMENTAL!");
+
 	ret = rbd_dev_probe_parent(rbd_dev, depth);
 	if (ret)
 		goto err_out_probe;
-- 
1.8.3.1



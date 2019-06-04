Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8533436B
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 11:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfFDJjP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jun 2019 05:39:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbfFDJjP (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 4 Jun 2019 05:39:15 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0CD6DC05FBCB
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jun 2019 09:39:15 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-98.pek2.redhat.com [10.72.12.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1A8B60C91;
        Tue,  4 Jun 2019 09:39:10 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 1/4] libceph: add function that reset client's entity addr
Date:   Tue,  4 Jun 2019 17:39:05 +0800
Message-Id: <20190604093908.30491-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 04 Jun 2019 09:39:15 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 include/linux/ceph/libceph.h    |  1 +
 include/linux/ceph/messenger.h  |  1 +
 include/linux/ceph/mon_client.h |  1 +
 include/linux/ceph/osd_client.h |  1 +
 net/ceph/ceph_common.c          |  8 ++++++++
 net/ceph/messenger.c            |  5 +++++
 net/ceph/mon_client.c           |  7 +++++++
 net/ceph/osd_client.c           | 16 ++++++++++++++++
 8 files changed, 40 insertions(+)

diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index a3cddf5f0e60..f29959eed025 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -291,6 +291,7 @@ struct ceph_client *ceph_create_client(struct ceph_options *opt, void *private);
 struct ceph_entity_addr *ceph_client_addr(struct ceph_client *client);
 u64 ceph_client_gid(struct ceph_client *client);
 extern void ceph_destroy_client(struct ceph_client *client);
+extern void ceph_reset_client_addr(struct ceph_client *client);
 extern int __ceph_open_session(struct ceph_client *client,
 			       unsigned long started);
 extern int ceph_open_session(struct ceph_client *client);
diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 23895d178149..c4458dc6a757 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -337,6 +337,7 @@ extern void ceph_msgr_flush(void);
 extern void ceph_messenger_init(struct ceph_messenger *msgr,
 				struct ceph_entity_addr *myaddr);
 extern void ceph_messenger_fini(struct ceph_messenger *msgr);
+extern void ceph_messenger_reset_nonce(struct ceph_messenger *msgr);
 
 extern void ceph_con_init(struct ceph_connection *con, void *private,
 			const struct ceph_connection_operations *ops,
diff --git a/include/linux/ceph/mon_client.h b/include/linux/ceph/mon_client.h
index 3a4688af7455..0d8d890c6759 100644
--- a/include/linux/ceph/mon_client.h
+++ b/include/linux/ceph/mon_client.h
@@ -110,6 +110,7 @@ extern int ceph_monmap_contains(struct ceph_monmap *m,
 
 extern int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl);
 extern void ceph_monc_stop(struct ceph_mon_client *monc);
+extern void ceph_monc_reopen_session(struct ceph_mon_client *monc);
 
 enum {
 	CEPH_SUB_MONMAP = 0,
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 2294f963dab7..a12b7fc9cfd6 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -381,6 +381,7 @@ extern void ceph_osdc_cleanup(void);
 extern int ceph_osdc_init(struct ceph_osd_client *osdc,
 			  struct ceph_client *client);
 extern void ceph_osdc_stop(struct ceph_osd_client *osdc);
+extern void ceph_osdc_reopen_osds(struct ceph_osd_client *osdc);
 
 extern void ceph_osdc_handle_reply(struct ceph_osd_client *osdc,
 				   struct ceph_msg *msg);
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 79eac465ec65..55210823d1cc 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -693,6 +693,14 @@ void ceph_destroy_client(struct ceph_client *client)
 }
 EXPORT_SYMBOL(ceph_destroy_client);
 
+void ceph_reset_client_addr(struct ceph_client *client)
+{
+	ceph_messenger_reset_nonce(&client->msgr);
+	ceph_monc_reopen_session(&client->monc);
+	ceph_osdc_reopen_osds(&client->osdc);
+}
+EXPORT_SYMBOL(ceph_reset_client_addr);
+
 /*
  * true if we have the mon map (and have thus joined the cluster)
  */
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 3ee380758ddd..cd03a1cba849 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -3028,6 +3028,11 @@ static void con_fault(struct ceph_connection *con)
 }
 
 
+void ceph_messenger_reset_nonce(struct ceph_messenger *msgr)
+{
+	msgr->inst.addr.nonce += 1000000;
+	encode_my_addr(msgr);
+}
 
 /*
  * initialize a new messenger instance
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 895679d3529b..6dab6a94e9cc 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -209,6 +209,13 @@ static void reopen_session(struct ceph_mon_client *monc)
 	__open_session(monc);
 }
 
+void ceph_monc_reopen_session(struct ceph_mon_client *monc)
+{
+	mutex_lock(&monc->mutex);
+	reopen_session(monc);
+	mutex_unlock(&monc->mutex);
+}
+
 static void un_backoff(struct ceph_mon_client *monc)
 {
 	monc->hunt_mult /= 2; /* reduce by 50% */
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index e6d31e0f0289..67e9466f27fd 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5089,6 +5089,22 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
 }
 EXPORT_SYMBOL(ceph_osdc_call);
 
+/*
+ * reset all osd connections
+ */
+void ceph_osdc_reopen_osds(struct ceph_osd_client *osdc)
+{
+	struct rb_node *n;
+	down_write(&osdc->lock);
+	for (n = rb_first(&osdc->osds); n; ) {
+		struct ceph_osd *osd = rb_entry(n, struct ceph_osd, o_node);
+		n = rb_next(n);
+		if (!reopen_osd(osd))
+			kick_osd_requests(osd);
+	}
+	up_write(&osdc->lock);
+}
+
 /*
  * init, shutdown
  */
-- 
2.17.2


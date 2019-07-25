Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2DB74DF7
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 14:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbfGYMQz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 08:16:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729373AbfGYMQy (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 08:16:54 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1297A30C714E
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2019 12:16:54 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-64.pek2.redhat.com [10.72.12.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B2CB5D71A;
        Thu, 25 Jul 2019 12:16:51 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH v3 1/9] libceph: add function that reset client's entity addr
Date:   Thu, 25 Jul 2019 20:16:39 +0800
Message-Id: <20190725121647.17093-2-zyan@redhat.com>
In-Reply-To: <20190725121647.17093-1-zyan@redhat.com>
References: <20190725121647.17093-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 25 Jul 2019 12:16:54 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This function also re-open connections to OSD/MON, and re-send in-flight
OSD requests after re-opening connections to OSD.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 include/linux/ceph/libceph.h    |  1 +
 include/linux/ceph/messenger.h  |  1 +
 include/linux/ceph/mon_client.h |  1 +
 include/linux/ceph/osd_client.h |  1 +
 net/ceph/ceph_common.c          |  8 ++++++++
 net/ceph/messenger.c            |  6 ++++++
 net/ceph/mon_client.c           |  7 +++++++
 net/ceph/osd_client.c           | 16 ++++++++++++++++
 8 files changed, 41 insertions(+)

diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 82156da3c650..b9dbda1c26aa 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -293,6 +293,7 @@ struct ceph_client *ceph_create_client(struct ceph_options *opt, void *private);
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
index b4d134d3312a..dbb8a6959a73 100644
--- a/include/linux/ceph/mon_client.h
+++ b/include/linux/ceph/mon_client.h
@@ -109,6 +109,7 @@ extern int ceph_monmap_contains(struct ceph_monmap *m,
 
 extern int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl);
 extern void ceph_monc_stop(struct ceph_mon_client *monc);
+extern void ceph_monc_reopen_session(struct ceph_mon_client *monc);
 
 enum {
 	CEPH_SUB_MONMAP = 0,
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index ad7fe5d10dcd..d1c3e829f30d 100644
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
index 1c811c74bfc0..6676f48d615c 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -694,6 +694,14 @@ void ceph_destroy_client(struct ceph_client *client)
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
index 0473d9a7b1f4..c75b3c055f34 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -3030,6 +3030,12 @@ static void con_fault(struct ceph_connection *con)
 }
 
 
+void ceph_messenger_reset_nonce(struct ceph_messenger *msgr)
+{
+	u32 nonce = le32_to_cpu(msgr->inst.addr.nonce) + 1000000;
+	msgr->inst.addr.nonce = cpu_to_le32(nonce);
+	encode_my_addr(msgr);
+}
 
 /*
  * initialize a new messenger instance
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 0520bf9825aa..7256c402ebaa 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -213,6 +213,13 @@ static void reopen_session(struct ceph_mon_client *monc)
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
index 0b2df09b2554..09e1857d033e 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5087,6 +5087,22 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
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
2.20.1


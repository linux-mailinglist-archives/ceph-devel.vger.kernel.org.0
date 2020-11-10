Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2333F2AD449
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 12:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbgKJLBh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 06:01:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22614 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726280AbgKJLBg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 06:01:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605006094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HLWO9aZXcNp28aSTkpVhhzE2XRtulnhVEDrPx6CPxG0=;
        b=J9znk0vvEHMkRrNB0uTtN7TFLaUOGDkuNDdnwvPnKafOurxQpRysKF6aJ6EFzcD++tw8wF
        +rYAbHL9VPwb6aWSP32IK+4hWEmSDhSAugTbA7cgUEoGH4B7ftQyMTyuchN4/HCv9wmtWR
        uMQVakMcqImOypA4YPQwifpcTw1dqjw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-CTdP7Pi-PmG4JrOIVCYyVw-1; Tue, 10 Nov 2020 06:01:29 -0500
X-MC-Unique: CTdP7Pi-PmG4JrOIVCYyVw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4B4A186DD23;
        Tue, 10 Nov 2020 11:01:28 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE8EB1002C0E;
        Tue, 10 Nov 2020 11:01:26 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] libceph: add osd op counter metric support
Date:   Tue, 10 Nov 2020 19:01:18 +0800
Message-Id: <20201110110118.340544-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The logic is the same with osdc/Objecter.cc in ceph in user space.

URL: https://tracker.ceph.com/issues/48053
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V2:
- remove other not used counter metrics

 include/linux/ceph/osd_client.h |  9 ++++++
 net/ceph/debugfs.c              | 13 ++++++++
 net/ceph/osd_client.c           | 56 +++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 83fa08a06507..24301513b186 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -339,6 +339,13 @@ struct ceph_osd_backoff {
 	struct ceph_hobject_id *end;
 };
 
+struct ceph_osd_metric {
+	struct percpu_counter op_ops;
+	struct percpu_counter op_rmw;
+	struct percpu_counter op_r;
+	struct percpu_counter op_w;
+};
+
 #define CEPH_LINGER_ID_START	0xffff000000000000ULL
 
 struct ceph_osd_client {
@@ -371,6 +378,8 @@ struct ceph_osd_client {
 	struct ceph_msgpool	msgpool_op;
 	struct ceph_msgpool	msgpool_op_reply;
 
+	struct ceph_osd_metric  metric;
+
 	struct workqueue_struct	*notify_wq;
 	struct workqueue_struct	*completion_wq;
 };
diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
index 2110439f8a24..af90019386ab 100644
--- a/net/ceph/debugfs.c
+++ b/net/ceph/debugfs.c
@@ -339,6 +339,16 @@ static void dump_backoffs(struct seq_file *s, struct ceph_osd *osd)
 	mutex_unlock(&osd->lock);
 }
 
+static void dump_op_metric(struct seq_file *s, struct ceph_osd_client *osdc)
+{
+	struct ceph_osd_metric *m = &osdc->metric;
+
+	seq_printf(s, "  op_ops: %lld\n", percpu_counter_sum(&m->op_ops));
+	seq_printf(s, "  op_rmw: %lld\n", percpu_counter_sum(&m->op_rmw));
+	seq_printf(s, "  op_r:   %lld\n", percpu_counter_sum(&m->op_r));
+	seq_printf(s, "  op_w:   %lld\n", percpu_counter_sum(&m->op_w));
+}
+
 static int osdc_show(struct seq_file *s, void *pp)
 {
 	struct ceph_client *client = s->private;
@@ -372,6 +382,9 @@ static int osdc_show(struct seq_file *s, void *pp)
 	}
 
 	up_read(&osdc->lock);
+
+	seq_puts(s, "OP METRIC:\n");
+	dump_op_metric(s, osdc);
 	return 0;
 }
 
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 7901ab6c79fd..66774b2bc584 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2424,6 +2424,21 @@ static void __submit_request(struct ceph_osd_request *req, bool wrlocked)
 	goto again;
 }
 
+static void osd_acount_op_metric(struct ceph_osd_request *req)
+{
+	struct ceph_osd_metric *m = &req->r_osdc->metric;
+
+	percpu_counter_inc(&m->op_ops);
+
+	if ((req->r_flags & (CEPH_OSD_FLAG_READ | CEPH_OSD_FLAG_READ))
+	    == (CEPH_OSD_FLAG_READ | CEPH_OSD_FLAG_READ))
+		percpu_counter_inc(&m->op_rmw);
+	if (req->r_flags & CEPH_OSD_FLAG_READ)
+		percpu_counter_inc(&m->op_r);
+	else if (req->r_flags & CEPH_OSD_FLAG_WRITE)
+		percpu_counter_inc(&m->op_w);
+}
+
 static void account_request(struct ceph_osd_request *req)
 {
 	WARN_ON(req->r_flags & (CEPH_OSD_FLAG_ACK | CEPH_OSD_FLAG_ONDISK));
@@ -2434,6 +2449,8 @@ static void account_request(struct ceph_osd_request *req)
 
 	req->r_start_stamp = jiffies;
 	req->r_start_latency = ktime_get();
+
+	osd_acount_op_metric(req);
 }
 
 static void submit_request(struct ceph_osd_request *req, bool wrlocked)
@@ -5205,6 +5222,39 @@ void ceph_osdc_reopen_osds(struct ceph_osd_client *osdc)
 	up_write(&osdc->lock);
 }
 
+static void ceph_metric_destroy(struct ceph_osd_metric *m)
+{
+	percpu_counter_destroy(&m->op_ops);
+	percpu_counter_destroy(&m->op_rmw);
+	percpu_counter_destroy(&m->op_r);
+	percpu_counter_destroy(&m->op_w);
+}
+
+static int ceph_metric_init(struct ceph_osd_metric *m)
+{
+	int ret;
+
+	memset(m, 0, sizeof(*m));
+
+	ret = percpu_counter_init(&m->op_ops, 0, GFP_NOIO);
+	if (ret)
+		return ret;
+	ret = percpu_counter_init(&m->op_rmw, 0, GFP_NOIO);
+	if (ret)
+		goto err;
+	ret = percpu_counter_init(&m->op_r, 0, GFP_NOIO);
+	if (ret)
+		goto err;
+	ret = percpu_counter_init(&m->op_w, 0, GFP_NOIO);
+	if (ret)
+		goto err;
+	return 0;
+
+err:
+	ceph_metric_destroy(m);
+	return ret;
+}
+
 /*
  * init, shutdown
  */
@@ -5257,6 +5307,9 @@ int ceph_osdc_init(struct ceph_osd_client *osdc, struct ceph_client *client)
 	if (!osdc->completion_wq)
 		goto out_notify_wq;
 
+	if (ceph_metric_init(&osdc->metric) < 0)
+		goto out_completion_wq;
+
 	schedule_delayed_work(&osdc->timeout_work,
 			      osdc->client->options->osd_keepalive_timeout);
 	schedule_delayed_work(&osdc->osds_timeout_work,
@@ -5264,6 +5317,8 @@ int ceph_osdc_init(struct ceph_osd_client *osdc, struct ceph_client *client)
 
 	return 0;
 
+out_completion_wq:
+	destroy_workqueue(osdc->completion_wq);
 out_notify_wq:
 	destroy_workqueue(osdc->notify_wq);
 out_msgpool_reply:
@@ -5302,6 +5357,7 @@ void ceph_osdc_stop(struct ceph_osd_client *osdc)
 	WARN_ON(atomic_read(&osdc->num_requests));
 	WARN_ON(atomic_read(&osdc->num_homeless));
 
+	ceph_metric_destroy(&osdc->metric);
 	ceph_osdmap_destroy(osdc->osdmap);
 	mempool_destroy(osdc->req_mempool);
 	ceph_msgpool_destroy(&osdc->msgpool_op);
-- 
2.27.0


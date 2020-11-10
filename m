Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203EB2ACAD9
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 03:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731192AbgKJCBf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Nov 2020 21:01:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27571 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729452AbgKJCBR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Nov 2020 21:01:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604973673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+NixMNB1VU0fhHaRgK2scG7TPGpSkjP1ciSWZzfWxaA=;
        b=KPNlS8KLdCM/Y628HCpW/jYONguqju6GPXOVGJGbp37EMKWujeZbp69w/+Z2eobu5uZ1WR
        OuIl2H9GJrLil2hOEVTHAxfaSOf+xLuBRqx/kfvefcGdMR2DZPX6h1wOdrt272jiZNP/aQ
        /t//a9T6LyynkYJsQcafCCQuoembM7o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-wQPX2PJUMTaSWEhc8FuhaA-1; Mon, 09 Nov 2020 21:01:10 -0500
X-MC-Unique: wQPX2PJUMTaSWEhc8FuhaA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AAAE1074655;
        Tue, 10 Nov 2020 02:01:09 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 144991002391;
        Tue, 10 Nov 2020 02:01:06 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com
Cc:     jlayton@kernel.org, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] libceph: add osd op counter metric support
Date:   Tue, 10 Nov 2020 10:00:51 +0800
Message-Id: <20201110020051.118461-1-xiubli@redhat.com>
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
 include/linux/ceph/osd_client.h |  46 ++++++
 net/ceph/debugfs.c              |  51 +++++++
 net/ceph/osd_client.c           | 249 +++++++++++++++++++++++++++++++-
 3 files changed, 343 insertions(+), 3 deletions(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 83fa08a06507..9ff9ceed7cb5 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -339,6 +339,50 @@ struct ceph_osd_backoff {
 	struct ceph_hobject_id *end;
 };
 
+struct ceph_osd_metric {
+	struct percpu_counter op_ops;
+	struct percpu_counter op_oplen_avg;
+	struct percpu_counter op_send;
+	struct percpu_counter op_send_bytes;
+	struct percpu_counter op_resend;
+	struct percpu_counter op_reply;
+
+	struct percpu_counter op_rmw;
+	struct percpu_counter op_r;
+	struct percpu_counter op_w;
+	struct percpu_counter op_pgop;
+
+	struct percpu_counter op_stat;
+	struct percpu_counter op_create;
+	struct percpu_counter op_read;
+	struct percpu_counter op_write;
+	struct percpu_counter op_writefull;
+	struct percpu_counter op_append;
+	struct percpu_counter op_zero;
+	struct percpu_counter op_truncate;
+	struct percpu_counter op_delete;
+	struct percpu_counter op_mapext;
+	struct percpu_counter op_sparse_read;
+	struct percpu_counter op_clonerange;
+	struct percpu_counter op_getxattr;
+	struct percpu_counter op_setxattr;
+	struct percpu_counter op_cmpxattr;
+	struct percpu_counter op_rmxattr;
+	struct percpu_counter op_resetxattrs;
+	struct percpu_counter op_call;
+	struct percpu_counter op_watch;
+	struct percpu_counter op_notify;
+
+	struct percpu_counter op_omap_rd;
+	struct percpu_counter op_omap_wr;
+	struct percpu_counter op_omap_del;
+
+	struct percpu_counter op_linger_active;
+	struct percpu_counter op_linger_send;
+	struct percpu_counter op_linger_resend;
+	struct percpu_counter op_linger_ping;
+};
+
 #define CEPH_LINGER_ID_START	0xffff000000000000ULL
 
 struct ceph_osd_client {
@@ -371,6 +415,8 @@ struct ceph_osd_client {
 	struct ceph_msgpool	msgpool_op;
 	struct ceph_msgpool	msgpool_op_reply;
 
+	struct ceph_osd_metric  metric;
+
 	struct workqueue_struct	*notify_wq;
 	struct workqueue_struct	*completion_wq;
 };
diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
index 2110439f8a24..b65124cd3fa2 100644
--- a/net/ceph/debugfs.c
+++ b/net/ceph/debugfs.c
@@ -339,6 +339,54 @@ static void dump_backoffs(struct seq_file *s, struct ceph_osd *osd)
 	mutex_unlock(&osd->lock);
 }
 
+static void dump_op_metric(struct seq_file *s, struct ceph_osd_client *osdc)
+{
+	struct ceph_osd_metric *m = &osdc->metric;
+
+	seq_printf(s, "  op_ops:  %lld\n", percpu_counter_sum(&m->op_ops));
+	seq_printf(s, "  op_active:  %d\n", atomic_read(&osdc->num_requests));
+	seq_printf(s, "  op_oplen_avg:  %lld\n", percpu_counter_sum(&m->op_oplen_avg));
+	seq_printf(s, "  op_send:  %lld\n", percpu_counter_sum(&m->op_send));
+	seq_printf(s, "  op_send_bytes:  %lld\n", percpu_counter_sum(&m->op_send_bytes));
+	seq_printf(s, "  op_resend:  %lld\n", percpu_counter_sum(&m->op_resend));
+	seq_printf(s, "  op_reply:  %lld\n", percpu_counter_sum(&m->op_reply));
+
+	seq_printf(s, "  op_rmw:  %lld\n", percpu_counter_sum(&m->op_rmw));
+	seq_printf(s, "  op_r:  %lld\n", percpu_counter_sum(&m->op_r));
+	seq_printf(s, "  op_w:  %lld\n", percpu_counter_sum(&m->op_w));
+	seq_printf(s, "  op_pgop:  %lld\n", percpu_counter_sum(&m->op_pgop));
+
+	seq_printf(s, "  op_stat:  %lld\n", percpu_counter_sum(&m->op_stat));
+	seq_printf(s, "  op_create:  %lld\n", percpu_counter_sum(&m->op_create));
+	seq_printf(s, "  op_read:  %lld\n", percpu_counter_sum(&m->op_read));
+	seq_printf(s, "  op_write:  %lld\n", percpu_counter_sum(&m->op_write));
+	seq_printf(s, "  op_writefull:  %lld\n", percpu_counter_sum(&m->op_writefull));
+	seq_printf(s, "  op_append:  %lld\n", percpu_counter_sum(&m->op_append));
+	seq_printf(s, "  op_zero:  %lld\n", percpu_counter_sum(&m->op_zero));
+	seq_printf(s, "  op_truncate:  %lld\n", percpu_counter_sum(&m->op_truncate));
+	seq_printf(s, "  op_delete:  %lld\n", percpu_counter_sum(&m->op_delete));
+	seq_printf(s, "  op_mapext:  %lld\n", percpu_counter_sum(&m->op_mapext));
+	seq_printf(s, "  op_sparse_read:  %lld\n", percpu_counter_sum(&m->op_sparse_read));
+	seq_printf(s, "  op_clonerange:  %lld\n", percpu_counter_sum(&m->op_clonerange));
+	seq_printf(s, "  op_getxattr:  %lld\n", percpu_counter_sum(&m->op_getxattr));
+	seq_printf(s, "  op_setxattr:  %lld\n", percpu_counter_sum(&m->op_setxattr));
+	seq_printf(s, "  op_cmpxattr:  %lld\n", percpu_counter_sum(&m->op_cmpxattr));
+	seq_printf(s, "  op_rmxattr:  %lld\n", percpu_counter_sum(&m->op_rmxattr));
+	seq_printf(s, "  op_resetxattrs:  %lld\n", percpu_counter_sum(&m->op_resetxattrs));
+	seq_printf(s, "  op_call:  %lld\n", percpu_counter_sum(&m->op_call));
+	seq_printf(s, "  op_watch:  %lld\n", percpu_counter_sum(&m->op_watch));
+	seq_printf(s, "  op_notify:  %lld\n", percpu_counter_sum(&m->op_notify));
+
+	seq_printf(s, "  op_omap_rd:  %lld\n", percpu_counter_sum(&m->op_omap_rd));
+	seq_printf(s, "  op_omap_wr:  %lld\n", percpu_counter_sum(&m->op_omap_wr));
+	seq_printf(s, "  op_omap_del:  %lld\n", percpu_counter_sum(&m->op_omap_del));
+
+	seq_printf(s, "  op_linger_active:  %lld\n", percpu_counter_sum(&m->op_linger_active));
+	seq_printf(s, "  op_linger_send:  %lld\n", percpu_counter_sum(&m->op_linger_send));
+	seq_printf(s, "  op_linger_resend:  %lld\n", percpu_counter_sum(&m->op_linger_resend));
+	seq_printf(s, "  op_linger_ping:  %lld\n", percpu_counter_sum(&m->op_linger_ping));
+}
+
 static int osdc_show(struct seq_file *s, void *pp)
 {
 	struct ceph_client *client = s->private;
@@ -372,6 +420,9 @@ static int osdc_show(struct seq_file *s, void *pp)
 	}
 
 	up_read(&osdc->lock);
+
+	seq_puts(s, "OP METRIC:\n");
+	dump_op_metric(s, osdc);
 	return 0;
 }
 
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 7901ab6c79fd..080bb6f03541 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2273,6 +2273,8 @@ static void encode_request_finish(struct ceph_msg *msg)
 static void send_request(struct ceph_osd_request *req)
 {
 	struct ceph_osd *osd = req->r_osd;
+	struct ceph_osd_client *osdc = req->r_osdc;
+	struct ceph_osd_req_op *op;
 
 	verify_osd_locked(osd);
 	WARN_ON(osd->o_osd != req->r_t.osd);
@@ -2309,6 +2311,10 @@ static void send_request(struct ceph_osd_request *req)
 	req->r_sent = osd->o_incarnation;
 	req->r_request->hdr.tid = cpu_to_le64(req->r_tid);
 	ceph_con_send(&osd->o_con, ceph_msg_get(req->r_request));
+
+	percpu_counter_inc(&osdc->metric.op_send);
+	for (op = req->r_ops; op != &req->r_ops[req->r_num_ops]; op++)
+		percpu_counter_add(&osdc->metric.op_send_bytes, op->indata_len);
 }
 
 static void maybe_request_map(struct ceph_osd_client *osdc)
@@ -2424,6 +2430,116 @@ static void __submit_request(struct ceph_osd_request *req, bool wrlocked)
 	goto again;
 }
 
+static void osd_acount_op_metric(struct ceph_osd_request *req)
+{
+	struct ceph_osd_metric *m = &req->r_osdc->metric;
+	struct ceph_osd_req_op *op;
+	struct percpu_counter *counter;
+
+	percpu_counter_inc(&m->op_ops);
+	percpu_counter_add(&m->op_oplen_avg, req->r_num_ops);
+
+	if ((req->r_flags & (CEPH_OSD_FLAG_READ | CEPH_OSD_FLAG_READ))
+	    == (CEPH_OSD_FLAG_READ | CEPH_OSD_FLAG_READ))
+		percpu_counter_inc(&m->op_rmw);
+	if (req->r_flags & CEPH_OSD_FLAG_READ)
+		percpu_counter_inc(&m->op_r);
+	else if (req->r_flags & CEPH_OSD_FLAG_WRITE)
+		percpu_counter_inc(&m->op_w);
+
+	if (req->r_flags & CEPH_OSD_FLAG_PGOP)
+		percpu_counter_inc(&m->op_pgop);
+
+	for (op = req->r_ops; op != &req->r_ops[req->r_num_ops]; op++) {
+		counter = NULL;
+
+		switch (op->op) {
+		case CEPH_OSD_OP_STAT:
+			counter = &m->op_stat;
+			break;
+		case CEPH_OSD_OP_CREATE:
+			counter = &m->op_create;
+			break;
+		case CEPH_OSD_OP_READ:
+			counter = &m->op_read;
+			break;
+		case CEPH_OSD_OP_WRITE:
+			counter = &m->op_write;
+			break;
+		case CEPH_OSD_OP_WRITEFULL:
+			counter = &m->op_writefull;
+			break;
+		case CEPH_OSD_OP_APPEND:
+			counter = &m->op_append;
+			break;
+		case CEPH_OSD_OP_ZERO:
+			counter = &m->op_zero;
+			break;
+		case CEPH_OSD_OP_TRUNCATE:
+			counter = &m->op_truncate;
+			break;
+		case CEPH_OSD_OP_DELETE:
+			counter = &m->op_delete;
+			break;
+		case CEPH_OSD_OP_MAPEXT:
+			counter = &m->op_mapext;
+			break;
+		case CEPH_OSD_OP_SPARSE_READ:
+			counter = &m->op_sparse_read;
+			break;
+		case CEPH_OSD_OP_GETXATTR:
+			counter = &m->op_getxattr;
+			break;
+		case CEPH_OSD_OP_SETXATTR:
+			counter = &m->op_setxattr;
+			break;
+		case CEPH_OSD_OP_CMPXATTR:
+			counter = &m->op_cmpxattr;
+			break;
+		case CEPH_OSD_OP_RMXATTR:
+			counter = &m->op_rmxattr;
+			break;
+		case CEPH_OSD_OP_RESETXATTRS:
+			counter = &m->op_resetxattrs;
+			break;
+
+		// OMAP read operations
+		case CEPH_OSD_OP_OMAPGETVALS:
+		case CEPH_OSD_OP_OMAPGETKEYS:
+		case CEPH_OSD_OP_OMAPGETHEADER:
+		case CEPH_OSD_OP_OMAPGETVALSBYKEYS:
+		case CEPH_OSD_OP_OMAP_CMP:
+			counter = &m->op_omap_rd;
+			break;
+
+		// OMAP write operations
+		case CEPH_OSD_OP_OMAPSETVALS:
+		case CEPH_OSD_OP_OMAPSETHEADER:
+			counter = &m->op_omap_wr;
+			break;
+
+		// OMAP del operations
+		case CEPH_OSD_OP_OMAPCLEAR:
+		case CEPH_OSD_OP_OMAPRMKEYS:
+			counter = &m->op_omap_del;
+			break;
+
+		case CEPH_OSD_OP_CALL:
+			counter = &m->op_call;
+			break;
+		case CEPH_OSD_OP_WATCH:
+			counter = &m->op_watch;
+			break;
+		case CEPH_OSD_OP_NOTIFY:
+			counter = &m->op_notify;
+			break;
+		}
+
+		if (counter)
+			percpu_counter_inc(counter);
+	}
+}
+
 static void account_request(struct ceph_osd_request *req)
 {
 	WARN_ON(req->r_flags & (CEPH_OSD_FLAG_ACK | CEPH_OSD_FLAG_ONDISK));
@@ -2434,6 +2550,8 @@ static void account_request(struct ceph_osd_request *req)
 
 	req->r_start_stamp = jiffies;
 	req->r_start_latency = ktime_get();
+
+	osd_acount_op_metric(req);
 }
 
 static void submit_request(struct ceph_osd_request *req, bool wrlocked)
@@ -3156,6 +3274,7 @@ static void send_linger_ping(struct ceph_osd_linger_request *lreq)
 	req->r_tid = atomic64_inc_return(&osdc->last_tid);
 	link_request(lreq->osd, req);
 	send_request(req);
+	percpu_counter_inc(&osdc->metric.op_linger_ping);
 }
 
 static void linger_submit(struct ceph_osd_linger_request *lreq)
@@ -3178,6 +3297,9 @@ static void linger_submit(struct ceph_osd_linger_request *lreq)
 
 	send_linger(lreq);
 	up_write(&osdc->lock);
+
+	percpu_counter_inc(&osdc->metric.op_linger_send);
+	percpu_counter_inc(&osdc->metric.op_linger_active);
 }
 
 static void cancel_linger_map_check(struct ceph_osd_linger_request *lreq)
@@ -3209,6 +3331,7 @@ static void __linger_cancel(struct ceph_osd_linger_request *lreq)
 	cancel_linger_map_check(lreq);
 	unlink_linger(lreq->osd, lreq);
 	linger_unregister(lreq);
+	percpu_counter_dec(&lreq->osdc->metric.op_linger_active);
 }
 
 static void linger_cancel(struct ceph_osd_linger_request *lreq)
@@ -3768,6 +3891,7 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
 	mutex_unlock(&osd->lock);
 	up_read(&osdc->lock);
 
+	percpu_counter_inc(&osdc->metric.op_reply);
 	__complete_request(req);
 	return;
 
@@ -4008,16 +4132,20 @@ static void kick_requests(struct ceph_osd_client *osdc,
 		osd = lookup_create_osd(osdc, req->r_t.osd, true);
 		link_request(osd, req);
 		if (!req->r_linger) {
-			if (!osd_homeless(osd) && !req->r_t.paused)
+			if (!osd_homeless(osd) && !req->r_t.paused) {
 				send_request(req);
+				percpu_counter_inc(&req->r_osdc->metric.op_resend);
+			}
 		} else {
 			cancel_linger_request(req);
 		}
 	}
 
 	list_for_each_entry_safe(lreq, nlreq, need_resend_linger, scan_item) {
-		if (!osd_homeless(lreq->osd))
+		if (!osd_homeless(lreq->osd)) {
 			send_linger(lreq);
+			percpu_counter_inc(&lreq->osdc->metric.op_linger_resend);
+		}
 
 		list_del_init(&lreq->scan_item);
 	}
@@ -4156,8 +4284,10 @@ static void kick_osd_requests(struct ceph_osd *osd)
 		n = rb_next(n); /* cancel_linger_request() */
 
 		if (!req->r_linger) {
-			if (!req->r_t.paused)
+			if (!req->r_t.paused) {
 				send_request(req);
+				percpu_counter_inc(&req->r_osdc->metric.op_resend);
+			}
 		} else {
 			cancel_linger_request(req);
 		}
@@ -4167,6 +4297,7 @@ static void kick_osd_requests(struct ceph_osd *osd)
 		    rb_entry(n, struct ceph_osd_linger_request, node);
 
 		send_linger(lreq);
+		percpu_counter_inc(&lreq->osdc->metric.op_linger_resend);
 	}
 }
 
@@ -5205,6 +5336,112 @@ void ceph_osdc_reopen_osds(struct ceph_osd_client *osdc)
 	up_write(&osdc->lock);
 }
 
+static void ceph_metric_destroy(struct ceph_osd_metric *m)
+{
+	percpu_counter_destroy(&m->op_ops);
+	percpu_counter_destroy(&m->op_oplen_avg);
+	percpu_counter_destroy(&m->op_send);
+	percpu_counter_destroy(&m->op_send_bytes);
+	percpu_counter_destroy(&m->op_resend);
+	percpu_counter_destroy(&m->op_reply);
+
+	percpu_counter_destroy(&m->op_rmw);
+	percpu_counter_destroy(&m->op_r);
+	percpu_counter_destroy(&m->op_w);
+	percpu_counter_destroy(&m->op_pgop);
+
+	percpu_counter_destroy(&m->op_stat);
+	percpu_counter_destroy(&m->op_create);
+	percpu_counter_destroy(&m->op_read);
+	percpu_counter_destroy(&m->op_write);
+	percpu_counter_destroy(&m->op_writefull);
+	percpu_counter_destroy(&m->op_append);
+	percpu_counter_destroy(&m->op_zero);
+	percpu_counter_destroy(&m->op_truncate);
+	percpu_counter_destroy(&m->op_delete);
+	percpu_counter_destroy(&m->op_mapext);
+	percpu_counter_destroy(&m->op_sparse_read);
+	percpu_counter_destroy(&m->op_clonerange);
+	percpu_counter_destroy(&m->op_getxattr);
+	percpu_counter_destroy(&m->op_setxattr);
+	percpu_counter_destroy(&m->op_cmpxattr);
+	percpu_counter_destroy(&m->op_rmxattr);
+	percpu_counter_destroy(&m->op_resetxattrs);
+	percpu_counter_destroy(&m->op_call);
+	percpu_counter_destroy(&m->op_watch);
+	percpu_counter_destroy(&m->op_notify);
+
+	percpu_counter_destroy(&m->op_omap_rd);
+	percpu_counter_destroy(&m->op_omap_wr);
+	percpu_counter_destroy(&m->op_omap_del);
+
+	percpu_counter_destroy(&m->op_linger_active);
+	percpu_counter_destroy(&m->op_linger_send);
+	percpu_counter_destroy(&m->op_linger_resend);
+	percpu_counter_destroy(&m->op_linger_ping);
+}
+
+#define CEPH_PERCPU_COUNTER_INIT(counter)			\
+do {								\
+	ret = percpu_counter_init(&m->counter, 0, GFP_NOIO);	\
+	if (ret)						\
+		goto err_op_fail;				\
+} while (0)
+
+static int ceph_metric_init(struct ceph_osd_metric *m)
+{
+	int ret;
+
+	memset(m, 0, sizeof(*m));
+
+	CEPH_PERCPU_COUNTER_INIT(op_ops);
+	CEPH_PERCPU_COUNTER_INIT(op_oplen_avg);
+	CEPH_PERCPU_COUNTER_INIT(op_send);
+	CEPH_PERCPU_COUNTER_INIT(op_send_bytes);
+	CEPH_PERCPU_COUNTER_INIT(op_resend);
+	CEPH_PERCPU_COUNTER_INIT(op_reply);
+
+	CEPH_PERCPU_COUNTER_INIT(op_rmw);
+	CEPH_PERCPU_COUNTER_INIT(op_r);
+	CEPH_PERCPU_COUNTER_INIT(op_w);
+	CEPH_PERCPU_COUNTER_INIT(op_pgop);
+
+	CEPH_PERCPU_COUNTER_INIT(op_stat);
+	CEPH_PERCPU_COUNTER_INIT(op_create);
+	CEPH_PERCPU_COUNTER_INIT(op_read);
+	CEPH_PERCPU_COUNTER_INIT(op_write);
+	CEPH_PERCPU_COUNTER_INIT(op_writefull);
+	CEPH_PERCPU_COUNTER_INIT(op_append);
+	CEPH_PERCPU_COUNTER_INIT(op_zero);
+	CEPH_PERCPU_COUNTER_INIT(op_truncate);
+	CEPH_PERCPU_COUNTER_INIT(op_delete);
+	CEPH_PERCPU_COUNTER_INIT(op_mapext);
+	CEPH_PERCPU_COUNTER_INIT(op_sparse_read);
+	CEPH_PERCPU_COUNTER_INIT(op_clonerange);
+	CEPH_PERCPU_COUNTER_INIT(op_getxattr);
+	CEPH_PERCPU_COUNTER_INIT(op_setxattr);
+	CEPH_PERCPU_COUNTER_INIT(op_cmpxattr);
+	CEPH_PERCPU_COUNTER_INIT(op_rmxattr);
+	CEPH_PERCPU_COUNTER_INIT(op_resetxattrs);
+	CEPH_PERCPU_COUNTER_INIT(op_call);
+	CEPH_PERCPU_COUNTER_INIT(op_watch);
+	CEPH_PERCPU_COUNTER_INIT(op_notify);
+
+	CEPH_PERCPU_COUNTER_INIT(op_omap_rd);
+	CEPH_PERCPU_COUNTER_INIT(op_omap_wr);
+	CEPH_PERCPU_COUNTER_INIT(op_omap_del);
+
+	CEPH_PERCPU_COUNTER_INIT(op_linger_active);
+	CEPH_PERCPU_COUNTER_INIT(op_linger_send);
+	CEPH_PERCPU_COUNTER_INIT(op_linger_resend);
+	CEPH_PERCPU_COUNTER_INIT(op_linger_ping);
+	return 0;
+
+err_op_fail:
+	ceph_metric_destroy(m);
+	return ret;
+}
+
 /*
  * init, shutdown
  */
@@ -5257,6 +5494,9 @@ int ceph_osdc_init(struct ceph_osd_client *osdc, struct ceph_client *client)
 	if (!osdc->completion_wq)
 		goto out_notify_wq;
 
+	if (ceph_metric_init(&osdc->metric) < 0)
+		goto out_completion_wq;
+
 	schedule_delayed_work(&osdc->timeout_work,
 			      osdc->client->options->osd_keepalive_timeout);
 	schedule_delayed_work(&osdc->osds_timeout_work,
@@ -5264,6 +5504,8 @@ int ceph_osdc_init(struct ceph_osd_client *osdc, struct ceph_client *client)
 
 	return 0;
 
+out_completion_wq:
+	destroy_workqueue(osdc->completion_wq);
 out_notify_wq:
 	destroy_workqueue(osdc->notify_wq);
 out_msgpool_reply:
@@ -5302,6 +5544,7 @@ void ceph_osdc_stop(struct ceph_osd_client *osdc)
 	WARN_ON(atomic_read(&osdc->num_requests));
 	WARN_ON(atomic_read(&osdc->num_homeless));
 
+	ceph_metric_destroy(&osdc->metric);
 	ceph_osdmap_destroy(osdc->osdmap);
 	mempool_destroy(osdc->req_mempool);
 	ceph_msgpool_destroy(&osdc->msgpool_op);
-- 
2.27.0


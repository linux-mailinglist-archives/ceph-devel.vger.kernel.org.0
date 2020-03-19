Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D85A418B8A7
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Mar 2020 15:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbgCSOHa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Mar 2020 10:07:30 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:30982 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727159AbgCSOH3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 10:07:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584626847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Gtvzv/kvCh0J4fOHr9O0zW4X7r+0LypK64hTRb+A9PQ=;
        b=QeEz4tU+M2340BD2Tc4tuIFLc5hi2MDkNGLw51cEnesswFz8wLbbao25tIEwGBd/xfG2fs
        lLTYPr9HNzP6PK4sgIlrwX5A8o2n1YZfwyidddvJU9aj5ANNIP79av1mqh8O2gCbFXkl1e
        AFrHuMq1n5DSXXxeXbBzvDl1A84E5gU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-8eLec8EtN5OVNZQD3cjjFA-1; Thu, 19 Mar 2020 10:07:25 -0400
X-MC-Unique: 8eLec8EtN5OVNZQD3cjjFA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6EAB8010FC;
        Thu, 19 Mar 2020 14:07:24 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DAE284D90;
        Thu, 19 Mar 2020 14:07:17 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v12 4/4] ceph: add metadata perf metric support
Date:   Thu, 19 Mar 2020 10:06:52 -0400
Message-Id: <1584626812-21323-5-git-send-email-xiubli@redhat.com>
In-Reply-To: <1584626812-21323-1-git-send-email-xiubli@redhat.com>
References: <1584626812-21323-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Add a new "r_ended" field to struct ceph_mds_request and use that to
maintain the average latency of MDS requests.

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/debugfs.c    |  9 +++++++++
 fs/ceph/mds_client.c |  5 +++++
 fs/ceph/mds_client.h |  3 ++-
 fs/ceph/metric.c     | 31 +++++++++++++++++++++++++++++++
 fs/ceph/metric.h     | 11 +++++++++++
 5 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index de07fdb..52bc14a 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -188,6 +188,15 @@ static int metric_show(struct seq_file *s, void *p)
 	sq = percpu_counter_sum(&m->write_latency_sq_sum);
 	CEPH_METRIC_SHOW("write", total, avg, min, max, sq);
 
+	avg = get_avg(&m->total_metadatas,
+		      &m->metadata_latency_sum,
+		      &m->metadata_latency_lock,
+		      &total);
+	min = atomic64_read(&m->metadata_latency_min);
+	max = atomic64_read(&m->metadata_latency_max);
+	sq = percpu_counter_sum(&m->metadata_latency_sq_sum);
+	CEPH_METRIC_SHOW("metadata", total, avg, min, max, sq);
+
 	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 1e242d8..b3f985a 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2547,6 +2547,8 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
 static void complete_request(struct ceph_mds_client *mdsc,
 			     struct ceph_mds_request *req)
 {
+	req->r_ended = jiffies;
+
 	if (req->r_callback)
 		req->r_callback(mdsc, req);
 	complete_all(&req->r_completion);
@@ -3155,6 +3157,9 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 
 	/* kick calling process */
 	complete_request(mdsc, req);
+
+	ceph_update_metadata_latency(&mdsc->metric, req->r_started,
+				     req->r_ended, err);
 out:
 	ceph_mdsc_put_request(req);
 	return;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index ae1d01c..9018fa7 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -298,7 +298,8 @@ struct ceph_mds_request {
 	u32               r_readdir_offset;
 
 	unsigned long r_timeout;  /* optional.  jiffies, 0 is "wait forever" */
-	unsigned long r_started;  /* start time to measure timeout against */
+	unsigned long r_started;  /* start time to measure timeout against and latency */
+	unsigned long r_ended;    /* finish time to measure latency */
 	unsigned long r_request_started; /* start time for mds request only,
 					    used to measure lease durations */
 
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 6cb64fb..9cd9dc3 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -50,8 +50,20 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	m->total_writes = 0;
 	m->write_latency_sum = 0;
 
+	ret = percpu_counter_init(&m->metadata_latency_sq_sum, 0, GFP_KERNEL);
+	if (ret)
+		goto err_metadata_latency_sq_sum;
+
+	atomic64_set(&m->metadata_latency_min, S64_MAX);
+	atomic64_set(&m->metadata_latency_max, 0);
+	spin_lock_init(&m->metadata_latency_lock);
+	m->total_metadatas = 0;
+	m->metadata_latency_sum = 0;
+
 	return 0;
 
+err_metadata_latency_sq_sum:
+	percpu_counter_destroy(&m->write_latency_sq_sum);
 err_write_latency_sq_sum:
 	percpu_counter_destroy(&m->read_latency_sq_sum);
 err_read_latency_sq_sum:
@@ -71,6 +83,7 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 	if (!m)
 		return;
 
+	percpu_counter_destroy(&m->metadata_latency_sq_sum);
 	percpu_counter_destroy(&m->write_latency_sq_sum);
 	percpu_counter_destroy(&m->read_latency_sq_sum);
 	percpu_counter_destroy(&m->i_caps_mis);
@@ -161,3 +174,21 @@ void ceph_update_write_latency(struct ceph_client_metric *m,
 			    &m->write_latency_lock,
 			    lat);
 }
+
+void ceph_update_metadata_latency(struct ceph_client_metric *m,
+				  unsigned long r_start,
+				  unsigned long r_end,
+				  int rc)
+{
+	unsigned long lat = r_end - r_start;
+
+	if (unlikely(rc && rc != -ENOENT))
+		return;
+
+	__update_min_latency(&m->metadata_latency_min, lat);
+	__update_max_latency(&m->metadata_latency_max, lat);
+	__update_avg_and_sq(&m->total_metadatas, &m->metadata_latency_sum,
+			    &m->metadata_latency_sq_sum,
+			    &m->metadata_latency_lock,
+			    lat);
+}
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index c7eae56..14aa910 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -27,6 +27,13 @@ struct ceph_client_metric {
 	spinlock_t write_latency_lock;
 	u64 total_writes;
 	u64 write_latency_sum;
+
+	struct percpu_counter metadata_latency_sq_sum;
+	atomic64_t metadata_latency_min;
+	atomic64_t metadata_latency_max;
+	spinlock_t metadata_latency_lock;
+	u64 total_metadatas;
+	u64 metadata_latency_sum;
 };
 
 extern int ceph_metric_init(struct ceph_client_metric *m);
@@ -50,4 +57,8 @@ extern void ceph_update_write_latency(struct ceph_client_metric *m,
 				      unsigned long r_start,
 				      unsigned long r_end,
 				      int rc);
+extern void ceph_update_metadata_latency(struct ceph_client_metric *m,
+					 unsigned long r_start,
+					 unsigned long r_end,
+					 int rc);
 #endif /* _FS_CEPH_MDS_METRIC_H */
-- 
1.8.3.1


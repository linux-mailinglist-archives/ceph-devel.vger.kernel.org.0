Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA39A17D9F1
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Mar 2020 08:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgCIHhh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Mar 2020 03:37:37 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23226 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726071AbgCIHhh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Mar 2020 03:37:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583739456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=YNgFdTgafcsa7Hs9yMlI0A+IUKOxfs+9Rc9PLtzLwBg=;
        b=WkST2ch/YY67KLIPVr2orYmFGBqAw8i4drRHTYqBLpbk+eCPZSwQkXTxJtTvbkek1K0ZDn
        Nitx42aNbecVLimKvSSqIYWLKvVGe9QxubY9cc1zZZT/qRqMCSEidksY730eHnzLWfkXGk
        vqGO5IE1PARspq2l+NcXEmajlWVBw/Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-PhWAerccNUmgIv8wxgKEzw-1; Mon, 09 Mar 2020 03:37:34 -0400
X-MC-Unique: PhWAerccNUmgIv8wxgKEzw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D2718017DF;
        Mon,  9 Mar 2020 07:37:33 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17BA57386E;
        Mon,  9 Mar 2020 07:37:30 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v9 5/5] ceph: add global metadata perf metric support
Date:   Mon,  9 Mar 2020 03:37:10 -0400
Message-Id: <1583739430-4928-6-git-send-email-xiubli@redhat.com>
In-Reply-To: <1583739430-4928-1-git-send-email-xiubli@redhat.com>
References: <1583739430-4928-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

It will calculate the latency for the metedata requests:
item          total       sum_lat(us)     avg_lat(us)
-----------------------------------------------------
metadata      113         220000          1946

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/debugfs.c    |  6 ++++++
 fs/ceph/mds_client.c | 19 +++++++++++++++++++
 fs/ceph/mds_client.h |  3 ++-
 fs/ceph/metric.h     | 15 +++++++++++++++
 4 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 464bfbd..60f3e307 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -146,6 +146,12 @@ static int metric_show(struct seq_file *s, void *p)
 	avg = total ? sum / total : 0;
 	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "write", total, sum, avg);
 
+	total = percpu_counter_sum(&mdsc->metric.total_metadatas);
+	sum = percpu_counter_sum(&mdsc->metric.metadata_latency_sum);
+	sum = jiffies_to_usecs(sum);
+	avg = total ? sum / total : 0;
+	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "metadata", total, sum, avg);
+
 	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 43f5d59..5c03ed3 100644
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
@@ -4361,8 +4366,20 @@ static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
 	if (ret)
 		goto err_write_latency_sum;
 
+	ret = percpu_counter_init(&metric->total_metadatas, 0, GFP_KERNEL);
+	if (ret)
+		goto err_total_metadatas;
+
+	ret = percpu_counter_init(&metric->metadata_latency_sum, 0, GFP_KERNEL);
+	if (ret)
+		goto err_metadata_latency_sum;
+
 	return 0;
 
+err_metadata_latency_sum:
+	percpu_counter_destroy(&metric->total_metadatas);
+err_total_metadatas:
+	percpu_counter_destroy(&metric->write_latency_sum);
 err_write_latency_sum:
 	percpu_counter_destroy(&metric->total_writes);
 err_total_writes:
@@ -4718,6 +4735,8 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
 
 	ceph_mdsc_stop(mdsc);
 
+	percpu_counter_destroy(&mdsc->metric.metadata_latency_sum);
+	percpu_counter_destroy(&mdsc->metric.total_metadatas);
 	percpu_counter_destroy(&mdsc->metric.write_latency_sum);
 	percpu_counter_destroy(&mdsc->metric.total_writes);
 	percpu_counter_destroy(&mdsc->metric.read_latency_sum);
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
 
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 13698aa..faba142 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -16,6 +16,9 @@ struct ceph_client_metric {
 
 	struct percpu_counter total_writes;
 	struct percpu_counter write_latency_sum;
+
+	struct percpu_counter total_metadatas;
+	struct percpu_counter metadata_latency_sum;
 };
 
 static inline void ceph_update_cap_hit(struct ceph_client_metric *m)
@@ -51,4 +54,16 @@ static inline void ceph_update_write_latency(struct ceph_client_metric *m,
 	percpu_counter_inc(&m->total_writes);
 	percpu_counter_add(&m->write_latency_sum, r_end - r_start);
 }
+
+static inline void ceph_update_metadata_latency(struct ceph_client_metric *m,
+						unsigned long r_start,
+						unsigned long r_end,
+						int rc)
+{
+	if (rc && rc != -ENOENT)
+		return;
+
+	percpu_counter_inc(&m->total_metadatas);
+	percpu_counter_add(&m->metadata_latency_sum, r_end - r_start);
+}
 #endif /* _FS_CEPH_MDS_METRIC_H */
-- 
1.8.3.1


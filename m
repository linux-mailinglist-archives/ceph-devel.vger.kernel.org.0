Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C940F17D9F0
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Mar 2020 08:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgCIHhf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Mar 2020 03:37:35 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43796 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726071AbgCIHhf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Mar 2020 03:37:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583739453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=MA88kwPBE4ESfHz+Ua9x4Z5gKFcYiU3r/2uUFZfv8a4=;
        b=EVV6D4Yhv0JFT7Z7zAX4M7vWf21GVBtY6FA08DSu57HjQydOsCiz2gUuey2k9mwXc5Q92g
        XEkikr/6ZykocjZSYFxPP+IePNwqdn8g2mwN9ZFPmieygANN+f+akbBV9bbU1xbVpAP5Tm
        Xektmxblp6TeZr1REyu/2cwwv6vrNfc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-RG3t2kaRPxibBrOyXpTgbQ-1; Mon, 09 Mar 2020 03:37:31 -0400
X-MC-Unique: RG3t2kaRPxibBrOyXpTgbQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D0A0184C800;
        Mon,  9 Mar 2020 07:37:30 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C11A7386E;
        Mon,  9 Mar 2020 07:37:27 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v9 4/5] ceph: add global write latency metric support
Date:   Mon,  9 Mar 2020 03:37:09 -0400
Message-Id: <1583739430-4928-5-git-send-email-xiubli@redhat.com>
In-Reply-To: <1583739430-4928-1-git-send-email-xiubli@redhat.com>
References: <1583739430-4928-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

It will calculate the latency for the write osd requests:
item          total       sum_lat(us)     avg_lat(us)
-----------------------------------------------------
write         1048        8778000         8375

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c       | 10 ++++++++++
 fs/ceph/debugfs.c    |  6 ++++++
 fs/ceph/file.c       | 18 ++++++++++++++----
 fs/ceph/mds_client.c | 14 ++++++++++++++
 fs/ceph/metric.h     | 15 +++++++++++++++
 5 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 55008a3..f359619 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -651,6 +651,9 @@ static int ceph_sync_writepages(struct ceph_fs_client *fsc,
 	if (!rc)
 		rc = ceph_osdc_wait_request(osdc, req);
 
+	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_stamp,
+				  req->r_end_stamp, rc);
+
 	ceph_osdc_put_request(req);
 	if (rc == 0)
 		rc = len;
@@ -802,6 +805,9 @@ static void writepages_finish(struct ceph_osd_request *req)
 		ceph_clear_error_write(ci);
 	}
 
+	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_stamp,
+				  req->r_end_stamp, rc);
+
 	/*
 	 * We lost the cache cap, need to truncate the page before
 	 * it is unlocked, otherwise we'd truncate it later in the
@@ -1860,6 +1866,10 @@ int ceph_uninline_data(struct file *filp, struct page *locked_page)
 	err = ceph_osdc_start_request(&fsc->client->osdc, req, false);
 	if (!err)
 		err = ceph_osdc_wait_request(&fsc->client->osdc, req);
+
+	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_stamp,
+				  req->r_end_stamp, err);
+
 out_put:
 	ceph_osdc_put_request(req);
 	if (err == -ECANCELED)
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index d814a3a..464bfbd 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -140,6 +140,12 @@ static int metric_show(struct seq_file *s, void *p)
 	avg = total ? sum / total : 0;
 	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "read", total, sum, avg);
 
+	total = percpu_counter_sum(&mdsc->metric.total_writes);
+	sum = percpu_counter_sum(&mdsc->metric.write_latency_sum);
+	sum = jiffies_to_usecs(sum);
+	avg = total ? sum / total : 0;
+	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "write", total, sum, avg);
+
 	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 3dce2a0..aa08fdf 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1058,9 +1058,14 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	     inode, rc, osd_data->bvec_pos.iter.bi_size);
 
 	/* r_start_stamp == 0 means the request was not submitted */
-	if (req->r_start_stamp && !aio_req->write)
-		ceph_update_read_latency(metric, req->r_start_stamp,
-					 req->r_end_stamp, rc);
+	if (req->r_start_stamp) {
+		if (aio_req->write)
+			ceph_update_write_latency(metric, req->r_start_stamp,
+						  req->r_end_stamp, rc);
+		else
+			ceph_update_read_latency(metric, req->r_start_stamp,
+						 req->r_end_stamp, rc);
+	}
 
 	if (rc == -EOLDSNAPC) {
 		struct ceph_aio_work *aio_work;
@@ -1307,7 +1312,10 @@ static void ceph_aio_retry_work(struct work_struct *work)
 		if (!ret)
 			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
 
-		if (!write)
+		if (write)
+			ceph_update_write_latency(metric, req->r_start_stamp,
+						  req->r_end_stamp, ret);
+		else
 			ceph_update_read_latency(metric, req->r_start_stamp,
 						 req->r_end_stamp, ret);
 
@@ -1482,6 +1490,8 @@ static void ceph_aio_retry_work(struct work_struct *work)
 		if (!ret)
 			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
 
+		ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_stamp,
+					  req->r_end_stamp, ret);
 out:
 		ceph_osdc_put_request(req);
 		if (ret != 0) {
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 94f6e53..43f5d59 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4353,8 +4353,20 @@ static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
 	if (ret)
 		goto err_read_latency_sum;
 
+	ret = percpu_counter_init(&metric->total_writes, 0, GFP_KERNEL);
+	if (ret)
+		goto err_total_writes;
+
+	ret = percpu_counter_init(&metric->write_latency_sum, 0, GFP_KERNEL);
+	if (ret)
+		goto err_write_latency_sum;
+
 	return 0;
 
+err_write_latency_sum:
+	percpu_counter_destroy(&metric->total_writes);
+err_total_writes:
+	percpu_counter_destroy(&metric->read_latency_sum);
 err_read_latency_sum:
 	percpu_counter_destroy(&metric->total_reads);
 err_total_reads:
@@ -4706,6 +4718,8 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
 
 	ceph_mdsc_stop(mdsc);
 
+	percpu_counter_destroy(&mdsc->metric.write_latency_sum);
+	percpu_counter_destroy(&mdsc->metric.total_writes);
 	percpu_counter_destroy(&mdsc->metric.read_latency_sum);
 	percpu_counter_destroy(&mdsc->metric.total_reads);
 	percpu_counter_destroy(&mdsc->metric.i_caps_mis);
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 0fe3eee..13698aa 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -13,6 +13,9 @@ struct ceph_client_metric {
 
 	struct percpu_counter total_reads;
 	struct percpu_counter read_latency_sum;
+
+	struct percpu_counter total_writes;
+	struct percpu_counter write_latency_sum;
 };
 
 static inline void ceph_update_cap_hit(struct ceph_client_metric *m)
@@ -36,4 +39,16 @@ static inline void ceph_update_read_latency(struct ceph_client_metric *m,
 	percpu_counter_inc(&m->total_reads);
 	percpu_counter_add(&m->read_latency_sum, r_end - r_start);
 }
+
+static inline void ceph_update_write_latency(struct ceph_client_metric *m,
+					     unsigned long r_start,
+					     unsigned long r_end,
+					     int rc)
+{
+	if (rc && rc != -ETIMEDOUT)
+		return;
+
+	percpu_counter_inc(&m->total_writes);
+	percpu_counter_add(&m->write_latency_sum, r_end - r_start);
+}
 #endif /* _FS_CEPH_MDS_METRIC_H */
-- 
1.8.3.1


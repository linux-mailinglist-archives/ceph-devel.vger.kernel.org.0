Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2488A43FDED
	for <lists+ceph-devel@lfdr.de>; Fri, 29 Oct 2021 16:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhJ2OMF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 Oct 2021 10:12:05 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:35748 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbhJ2OMB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 29 Oct 2021 10:12:01 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A153D21978;
        Fri, 29 Oct 2021 14:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635516571; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Wg1WyIZF1JHgpU42cFygsGx+fcfm4hH99uIWlEVsol8=;
        b=ZDf9SCC7b/7Lu7zy6e7G5pBPcafo8IzFZEft2Lty4/9T0/fCFTcDnPIk5udBMWg1x9WxD6
        IpTqxM5oEVoBTyogLOu/k7Mrev6rxXzHU2ioBw+RANYF5fWPtGoZwPNKL+fyBcPxrKuwdD
        NF1T2bYiiYlwacRlWfsRosF2urr799c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635516571;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Wg1WyIZF1JHgpU42cFygsGx+fcfm4hH99uIWlEVsol8=;
        b=QTYZjveOEH5F5ofruLJ2EO7hf9MQsAwVIQC+4tCpDZ2iHrK2KWCL6oAO5pSzOlib7WNIQp
        bZ+SAmfelSWW0NAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 337B113D9F;
        Fri, 29 Oct 2021 14:09:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3EKdCZsAfGG4LgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Fri, 29 Oct 2021 14:09:31 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 83f6a41c;
        Fri, 29 Oct 2021 14:09:30 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH] ceph: clean-up metrics data structures to reduce code duplication
Date:   Fri, 29 Oct 2021 15:09:28 +0100
Message-Id: <20211029140928.10514-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This patch modifies struct ceph_client_metric so that each metric block
(read, write and metadata) becomes an element in a array.  This allows to
also re-write the helper functions that handle these blocks, making them
simpler and, above all, reduce the amount of copy&paste every time a new
metric is added.

Thus, for each of these metrics there will be a new struct ceph_metric
entry that'll will contain all the sizes and latencies fields (and a lock).
Note however that the metadata metric doesn't really use the size_fields,
and thus this metric won't be shown in the debugfs '../metrics/size' file.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 fs/ceph/debugfs.c |  87 ++++++++++++++-----------------
 fs/ceph/metric.c  | 128 ++++++++++++----------------------------------
 fs/ceph/metric.h  |  80 ++++++++++++++++-------------
 3 files changed, 115 insertions(+), 180 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 55426514491b..72825ed3a0b8 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -164,44 +164,34 @@ static int metrics_file_show(struct seq_file *s, void *p)
 	return 0;
 }
 
+static const char * const metric_str[] = {
+	"read",
+	"write",
+	"metadata"
+};
 static int metrics_latency_show(struct seq_file *s, void *p)
 {
 	struct ceph_fs_client *fsc = s->private;
-	struct ceph_client_metric *m = &fsc->mdsc->metric;
+	struct ceph_client_metric *cm = &fsc->mdsc->metric;
+	struct ceph_metric *m;
 	s64 total, sum, avg, min, max, sq;
+	int i;
 
 	seq_printf(s, "item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)\n");
 	seq_printf(s, "-----------------------------------------------------------------------------------\n");
 
-	spin_lock(&m->read_metric_lock);
-	total = m->total_reads;
-	sum = m->read_latency_sum;
-	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
-	min = m->read_latency_min;
-	max = m->read_latency_max;
-	sq = m->read_latency_sq_sum;
-	spin_unlock(&m->read_metric_lock);
-	CEPH_LAT_METRIC_SHOW("read", total, avg, min, max, sq);
-
-	spin_lock(&m->write_metric_lock);
-	total = m->total_writes;
-	sum = m->write_latency_sum;
-	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
-	min = m->write_latency_min;
-	max = m->write_latency_max;
-	sq = m->write_latency_sq_sum;
-	spin_unlock(&m->write_metric_lock);
-	CEPH_LAT_METRIC_SHOW("write", total, avg, min, max, sq);
-
-	spin_lock(&m->metadata_metric_lock);
-	total = m->total_metadatas;
-	sum = m->metadata_latency_sum;
-	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
-	min = m->metadata_latency_min;
-	max = m->metadata_latency_max;
-	sq = m->metadata_latency_sq_sum;
-	spin_unlock(&m->metadata_metric_lock);
-	CEPH_LAT_METRIC_SHOW("metadata", total, avg, min, max, sq);
+	for (i = 0; i < METRIC_MAX; i++) {
+		m = &cm->metric[i];
+		spin_lock(&m->lock);
+		total = m->total;
+		sum = m->latency_sum;
+		avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+		min = m->latency_min;
+		max = m->latency_max;
+		sq = m->latency_sq_sum;
+		spin_unlock(&m->lock);
+		CEPH_LAT_METRIC_SHOW(metric_str[i], total, avg, min, max, sq);
+	}
 
 	return 0;
 }
@@ -209,30 +199,29 @@ static int metrics_latency_show(struct seq_file *s, void *p)
 static int metrics_size_show(struct seq_file *s, void *p)
 {
 	struct ceph_fs_client *fsc = s->private;
-	struct ceph_client_metric *m = &fsc->mdsc->metric;
+	struct ceph_client_metric *cm = &fsc->mdsc->metric;
+	struct ceph_metric *m;
 	s64 total;
-	u64 sum_sz, avg_sz, min_sz, max_sz;
+	u64 sum, avg, min, max;
+	int i;
 
 	seq_printf(s, "item          total       avg_sz(bytes)   min_sz(bytes)   max_sz(bytes)  total_sz(bytes)\n");
 	seq_printf(s, "----------------------------------------------------------------------------------------\n");
 
-	spin_lock(&m->read_metric_lock);
-	total = m->total_reads;
-	sum_sz = m->read_size_sum;
-	avg_sz = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum_sz, total) : 0;
-	min_sz = m->read_size_min;
-	max_sz = m->read_size_max;
-	spin_unlock(&m->read_metric_lock);
-	CEPH_SZ_METRIC_SHOW("read", total, avg_sz, min_sz, max_sz, sum_sz);
-
-	spin_lock(&m->write_metric_lock);
-	total = m->total_writes;
-	sum_sz = m->write_size_sum;
-	avg_sz = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum_sz, total) : 0;
-	min_sz = m->write_size_min;
-	max_sz = m->write_size_max;
-	spin_unlock(&m->write_metric_lock);
-	CEPH_SZ_METRIC_SHOW("write", total, avg_sz, min_sz, max_sz, sum_sz);
+	for (i = 0; i < METRIC_MAX; i++) {
+		/* skip 'metadata' as it doesn't use the size metric */
+		if (i == METRIC_METADATA)
+			continue;
+		m = &cm->metric[i];
+		spin_lock(&m->lock);
+		total = m->total;
+		sum = m->size_sum;
+		avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+		min = m->size_min;
+		max = m->size_max;
+		spin_unlock(&m->lock);
+		CEPH_SZ_METRIC_SHOW(metric_str[i], total, avg, min, max, sum);
+	}
 
 	return 0;
 }
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 04d5df29bbbf..c57699d8408d 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -62,7 +62,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	read->header.ver = 1;
 	read->header.compat = 1;
 	read->header.data_len = cpu_to_le32(sizeof(*read) - header_len);
-	sum = m->read_latency_sum;
+	sum = m->metric[METRIC_READ].latency_sum;
 	jiffies_to_timespec64(sum, &ts);
 	read->sec = cpu_to_le32(ts.tv_sec);
 	read->nsec = cpu_to_le32(ts.tv_nsec);
@@ -74,7 +74,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	write->header.ver = 1;
 	write->header.compat = 1;
 	write->header.data_len = cpu_to_le32(sizeof(*write) - header_len);
-	sum = m->write_latency_sum;
+	sum = m->metric[METRIC_WRITE].latency_sum;
 	jiffies_to_timespec64(sum, &ts);
 	write->sec = cpu_to_le32(ts.tv_sec);
 	write->nsec = cpu_to_le32(ts.tv_nsec);
@@ -86,7 +86,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	meta->header.ver = 1;
 	meta->header.compat = 1;
 	meta->header.data_len = cpu_to_le32(sizeof(*meta) - header_len);
-	sum = m->metadata_latency_sum;
+	sum = m->metric[METRIC_METADATA].latency_sum;
 	jiffies_to_timespec64(sum, &ts);
 	meta->sec = cpu_to_le32(ts.tv_sec);
 	meta->nsec = cpu_to_le32(ts.tv_nsec);
@@ -141,8 +141,8 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	rsize->header.ver = 1;
 	rsize->header.compat = 1;
 	rsize->header.data_len = cpu_to_le32(sizeof(*rsize) - header_len);
-	rsize->total_ops = cpu_to_le64(m->total_reads);
-	rsize->total_size = cpu_to_le64(m->read_size_sum);
+	rsize->total_ops = cpu_to_le64(m->metric[METRIC_READ].total);
+	rsize->total_size = cpu_to_le64(m->metric[METRIC_READ].size_sum);
 	items++;
 
 	/* encode the write io size metric */
@@ -151,8 +151,8 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	wsize->header.ver = 1;
 	wsize->header.compat = 1;
 	wsize->header.data_len = cpu_to_le32(sizeof(*wsize) - header_len);
-	wsize->total_ops = cpu_to_le64(m->total_writes);
-	wsize->total_size = cpu_to_le64(m->write_size_sum);
+	wsize->total_ops = cpu_to_le64(m->metric[METRIC_WRITE].total);
+	wsize->total_size = cpu_to_le64(m->metric[METRIC_WRITE].size_sum);
 	items++;
 
 	put_unaligned_le32(items, &head->num);
@@ -220,7 +220,8 @@ static void metric_delayed_work(struct work_struct *work)
 
 int ceph_metric_init(struct ceph_client_metric *m)
 {
-	int ret;
+	struct ceph_metric *metric;
+	int ret, i;
 
 	if (!m)
 		return -EINVAL;
@@ -243,32 +244,18 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	if (ret)
 		goto err_i_caps_mis;
 
-	spin_lock_init(&m->read_metric_lock);
-	m->read_latency_sq_sum = 0;
-	m->read_latency_min = KTIME_MAX;
-	m->read_latency_max = 0;
-	m->total_reads = 0;
-	m->read_latency_sum = 0;
-	m->read_size_min = U64_MAX;
-	m->read_size_max = 0;
-	m->read_size_sum = 0;
-
-	spin_lock_init(&m->write_metric_lock);
-	m->write_latency_sq_sum = 0;
-	m->write_latency_min = KTIME_MAX;
-	m->write_latency_max = 0;
-	m->total_writes = 0;
-	m->write_latency_sum = 0;
-	m->write_size_min = U64_MAX;
-	m->write_size_max = 0;
-	m->write_size_sum = 0;
-
-	spin_lock_init(&m->metadata_metric_lock);
-	m->metadata_latency_sq_sum = 0;
-	m->metadata_latency_min = KTIME_MAX;
-	m->metadata_latency_max = 0;
-	m->total_metadatas = 0;
-	m->metadata_latency_sum = 0;
+	for (i = 0; i < METRIC_MAX; i++) {
+		metric = &m->metric[i];
+		spin_lock_init(&metric->lock);
+		metric->size_sum = 0;
+		metric->size_min = U64_MAX;
+		metric->size_max = 0;
+		metric->total = 0;
+		metric->latency_sum = 0;
+		metric->latency_sq_sum = 0;
+		metric->latency_min = KTIME_MAX;
+		metric->latency_max = 0;
+	}
 
 	atomic64_set(&m->opened_files, 0);
 	ret = percpu_counter_init(&m->opened_inodes, 0, GFP_KERNEL);
@@ -338,9 +325,9 @@ static inline void __update_stdev(ktime_t total, ktime_t lsum,
 	*sq_sump += sq;
 }
 
-void ceph_update_read_metrics(struct ceph_client_metric *m,
-			      ktime_t r_start, ktime_t r_end,
-			      unsigned int size, int rc)
+void ceph_update_metrics(struct ceph_metric *m,
+			 ktime_t r_start, ktime_t r_end,
+			 unsigned int size, int rc)
 {
 	ktime_t lat = ktime_sub(r_end, r_start);
 	ktime_t total;
@@ -348,63 +335,12 @@ void ceph_update_read_metrics(struct ceph_client_metric *m,
 	if (unlikely(rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT))
 		return;
 
-	spin_lock(&m->read_metric_lock);
-	total = ++m->total_reads;
-	m->read_size_sum += size;
-	m->read_latency_sum += lat;
-	METRIC_UPDATE_MIN_MAX(m->read_size_min,
-			      m->read_size_max,
-			      size);
-	METRIC_UPDATE_MIN_MAX(m->read_latency_min,
-			      m->read_latency_max,
-			      lat);
-	__update_stdev(total, m->read_latency_sum,
-		       &m->read_latency_sq_sum, lat);
-	spin_unlock(&m->read_metric_lock);
-}
-
-void ceph_update_write_metrics(struct ceph_client_metric *m,
-			       ktime_t r_start, ktime_t r_end,
-			       unsigned int size, int rc)
-{
-	ktime_t lat = ktime_sub(r_end, r_start);
-	ktime_t total;
-
-	if (unlikely(rc && rc != -ETIMEDOUT))
-		return;
-
-	spin_lock(&m->write_metric_lock);
-	total = ++m->total_writes;
-	m->write_size_sum += size;
-	m->write_latency_sum += lat;
-	METRIC_UPDATE_MIN_MAX(m->write_size_min,
-			      m->write_size_max,
-			      size);
-	METRIC_UPDATE_MIN_MAX(m->write_latency_min,
-			      m->write_latency_max,
-			      lat);
-	__update_stdev(total, m->write_latency_sum,
-		       &m->write_latency_sq_sum, lat);
-	spin_unlock(&m->write_metric_lock);
-}
-
-void ceph_update_metadata_metrics(struct ceph_client_metric *m,
-				  ktime_t r_start, ktime_t r_end,
-				  int rc)
-{
-	ktime_t lat = ktime_sub(r_end, r_start);
-	ktime_t total;
-
-	if (unlikely(rc && rc != -ENOENT))
-		return;
-
-	spin_lock(&m->metadata_metric_lock);
-	total = ++m->total_metadatas;
-	m->metadata_latency_sum += lat;
-	METRIC_UPDATE_MIN_MAX(m->metadata_latency_min,
-			      m->metadata_latency_max,
-			      lat);
-	__update_stdev(total, m->metadata_latency_sum,
-		       &m->metadata_latency_sq_sum, lat);
-	spin_unlock(&m->metadata_metric_lock);
+	spin_lock(&m->lock);
+	total = ++m->total;
+	m->size_sum += size;
+	METRIC_UPDATE_MIN_MAX(m->size_min, m->size_max, size);
+	m->latency_sum += lat;
+	METRIC_UPDATE_MIN_MAX(m->latency_min, m->latency_max, lat);
+	__update_stdev(total, m->latency_sum, &m->latency_sq_sum, lat);
+	spin_unlock(&m->lock);
 }
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 0133955a3c6a..e67fc997760b 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -125,6 +125,25 @@ struct ceph_metric_head {
 	__le32 num;	/* the number of metrics that will be sent */
 } __packed;
 
+enum metric_type {
+	METRIC_READ,
+	METRIC_WRITE,
+	METRIC_METADATA,
+	METRIC_MAX
+};
+
+struct ceph_metric {
+	spinlock_t lock;
+	u64 total;
+	u64 size_sum;
+	u64 size_min;
+	u64 size_max;
+	ktime_t latency_sum;
+	ktime_t latency_sq_sum;
+	ktime_t latency_min;
+	ktime_t latency_max;
+};
+
 /* This is the global metrics */
 struct ceph_client_metric {
 	atomic64_t            total_dentries;
@@ -135,32 +154,7 @@ struct ceph_client_metric {
 	struct percpu_counter i_caps_hit;
 	struct percpu_counter i_caps_mis;
 
-	spinlock_t read_metric_lock;
-	u64 total_reads;
-	u64 read_size_sum;
-	u64 read_size_min;
-	u64 read_size_max;
-	ktime_t read_latency_sum;
-	ktime_t read_latency_sq_sum;
-	ktime_t read_latency_min;
-	ktime_t read_latency_max;
-
-	spinlock_t write_metric_lock;
-	u64 total_writes;
-	u64 write_size_sum;
-	u64 write_size_min;
-	u64 write_size_max;
-	ktime_t write_latency_sum;
-	ktime_t write_latency_sq_sum;
-	ktime_t write_latency_min;
-	ktime_t write_latency_max;
-
-	spinlock_t metadata_metric_lock;
-	u64 total_metadatas;
-	ktime_t metadata_latency_sum;
-	ktime_t metadata_latency_sq_sum;
-	ktime_t metadata_latency_min;
-	ktime_t metadata_latency_max;
+	struct ceph_metric metric[METRIC_MAX];
 
 	/* The total number of directories and files that are opened */
 	atomic64_t opened_files;
@@ -195,13 +189,29 @@ static inline void ceph_update_cap_mis(struct ceph_client_metric *m)
 	percpu_counter_inc(&m->i_caps_mis);
 }
 
-extern void ceph_update_read_metrics(struct ceph_client_metric *m,
-				     ktime_t r_start, ktime_t r_end,
-				     unsigned int size, int rc);
-extern void ceph_update_write_metrics(struct ceph_client_metric *m,
-				      ktime_t r_start, ktime_t r_end,
-				      unsigned int size, int rc);
-extern void ceph_update_metadata_metrics(struct ceph_client_metric *m,
-				         ktime_t r_start, ktime_t r_end,
-					 int rc);
+extern void ceph_update_metrics(struct ceph_metric *m,
+				ktime_t r_start, ktime_t r_end,
+				unsigned int size, int rc);
+
+static inline void ceph_update_read_metrics(struct ceph_client_metric *m,
+					    ktime_t r_start, ktime_t r_end,
+					    unsigned int size, int rc)
+{
+	ceph_update_metrics(&m->metric[METRIC_READ],
+			    r_start, r_end, size, rc);
+}
+static inline void ceph_update_write_metrics(struct ceph_client_metric *m,
+					     ktime_t r_start, ktime_t r_end,
+					     unsigned int size, int rc)
+{
+	ceph_update_metrics(&m->metric[METRIC_WRITE],
+			    r_start, r_end, size, rc);
+}
+static inline void ceph_update_metadata_metrics(struct ceph_client_metric *m,
+						ktime_t r_start, ktime_t r_end,
+						int rc)
+{
+	ceph_update_metrics(&m->metric[METRIC_METADATA],
+			    r_start, r_end, 0, rc);
+}
 #endif /* _FS_CEPH_MDS_METRIC_H */

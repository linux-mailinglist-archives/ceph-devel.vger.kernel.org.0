Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300F943E03A
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Oct 2021 13:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhJ1Lu6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Oct 2021 07:50:58 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57046 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhJ1Lu6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Oct 2021 07:50:58 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4614C2196E;
        Thu, 28 Oct 2021 11:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635421710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wx62y0sSCwgO8J1OME/h2XU+M/3QqZZOJexyStk3S9I=;
        b=1++FsmijpKkQhORBeQVWGcAxqepeSHsmUHcN3S1satLqwr/yT0yKkjdFAouonDppxCloLJ
        EWL7tGAIFq9PtRUpqiv0kObw6GQrewoBqaIhHMK86G8xzMvvycNtJtKd/PLu1fnKQ6xL6n
        2Ly2BuuxYlx0ZpQnCwBcc+VVLR2Zrvk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635421710;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wx62y0sSCwgO8J1OME/h2XU+M/3QqZZOJexyStk3S9I=;
        b=YV/gT2dpwY+yrvwDYZtxVkpPQOJ5yX8Sk/PXhYkhhLWtHr0n2TLbWUfIzd0cAa4udtiWaO
        pUzbLtF/MLrIZyDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C437313B88;
        Thu, 28 Oct 2021 11:48:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hG3tLA2OemHUTwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 28 Oct 2021 11:48:29 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 44eb804b;
        Thu, 28 Oct 2021 11:48:29 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        Patrick Donnelly <pdonnell@redhat.com>
Subject: [RFC PATCH v3] ceph: ceph: add remote object copies to fs client metrics
Date:   Thu, 28 Oct 2021 12:48:26 +0100
Message-Id: <20211028114826.27192-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This patch adds latency and size metrics for remote object copies
operations ("copyfrom").  For now, these metrics will be available on the
client only, they won't be sent to the MDS.

Cc: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
This patch is still an RFC because it is... ugly.  Although it now
provides nice values (latency and size) using the metrics infrastructure,
it actually needs to extend the ceph_osdc_copy_from() function to add 2
extra args!  That's because we need to get the timestamps stored in
ceph_osd_request, which is handled within that function.

The alternative is to ignore those timestamps and collect new ones in
ceph_do_objects_copy():

	start_req = ktime_get();
	ceph_osdc_copy_from(...);
	end_req = ktime_get();

These would be more coarse-grained, of course.  Any other suggestions?

Cheers,
-- 
Luís

 fs/ceph/debugfs.c               | 19 ++++++++++++++++++
 fs/ceph/file.c                  |  7 ++++++-
 fs/ceph/metric.c                | 35 +++++++++++++++++++++++++++++++++
 fs/ceph/metric.h                | 14 +++++++++++++
 include/linux/ceph/osd_client.h |  3 ++-
 net/ceph/osd_client.c           |  8 ++++++--
 6 files changed, 82 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 55426514491b..b657170d6bc3 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -203,6 +203,16 @@ static int metrics_latency_show(struct seq_file *s, void *p)
 	spin_unlock(&m->metadata_metric_lock);
 	CEPH_LAT_METRIC_SHOW("metadata", total, avg, min, max, sq);
 
+	spin_lock(&m->copyfrom_metric_lock);
+	total = m->total_copyfrom;
+	sum = m->copyfrom_latency_sum;
+	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+	min = m->copyfrom_latency_min;
+	max = m->copyfrom_latency_max;
+	sq = m->copyfrom_latency_sq_sum;
+	spin_unlock(&m->copyfrom_metric_lock);
+	CEPH_LAT_METRIC_SHOW("copyfrom", total, avg, min, max, sq);
+
 	return 0;
 }
 
@@ -234,6 +244,15 @@ static int metrics_size_show(struct seq_file *s, void *p)
 	spin_unlock(&m->write_metric_lock);
 	CEPH_SZ_METRIC_SHOW("write", total, avg_sz, min_sz, max_sz, sum_sz);
 
+	spin_lock(&m->copyfrom_metric_lock);
+	total = m->total_copyfrom;
+	sum_sz = m->copyfrom_size_sum;
+	avg_sz = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum_sz, total) : 0;
+	min_sz = m->copyfrom_size_min;
+	max_sz = m->copyfrom_size_max;
+	spin_unlock(&m->copyfrom_metric_lock);
+	CEPH_SZ_METRIC_SHOW("copyfrom", total, avg_sz, min_sz, max_sz, sum_sz);
+
 	return 0;
 }
 
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index e61018d9764e..d1139bbcd58d 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2208,6 +2208,7 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
 	struct ceph_object_locator src_oloc, dst_oloc;
 	struct ceph_object_id src_oid, dst_oid;
 	size_t bytes = 0;
+	ktime_t start_req, end_req;
 	u64 src_objnum, src_objoff, dst_objnum, dst_objoff;
 	u32 src_objlen, dst_objlen;
 	u32 object_size = src_ci->i_layout.object_size;
@@ -2242,7 +2243,11 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
 					  CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
 					  dst_ci->i_truncate_seq,
 					  dst_ci->i_truncate_size,
-					  CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
+					  CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ,
+					  &start_req, &end_req);
+		ceph_update_copyfrom_metrics(&fsc->mdsc->metric,
+					     start_req, end_req,
+					     object_size, ret);
 		if (ret) {
 			if (ret == -EOPNOTSUPP) {
 				fsc->have_copy_from2 = false;
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 04d5df29bbbf..94e7f8fd34d6 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -270,6 +270,16 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	m->total_metadatas = 0;
 	m->metadata_latency_sum = 0;
 
+	spin_lock_init(&m->copyfrom_metric_lock);
+	m->copyfrom_latency_sq_sum = 0;
+	m->copyfrom_latency_min = KTIME_MAX;
+	m->copyfrom_latency_max = 0;
+	m->total_copyfrom = 0;
+	m->copyfrom_latency_sum = 0;
+	m->copyfrom_size_min = U64_MAX;
+	m->copyfrom_size_max = 0;
+	m->copyfrom_size_sum = 0;
+
 	atomic64_set(&m->opened_files, 0);
 	ret = percpu_counter_init(&m->opened_inodes, 0, GFP_KERNEL);
 	if (ret)
@@ -408,3 +418,28 @@ void ceph_update_metadata_metrics(struct ceph_client_metric *m,
 		       &m->metadata_latency_sq_sum, lat);
 	spin_unlock(&m->metadata_metric_lock);
 }
+
+void ceph_update_copyfrom_metrics(struct ceph_client_metric *m,
+				  ktime_t r_start, ktime_t r_end,
+				  unsigned int size, int rc)
+{
+	ktime_t lat = ktime_sub(r_end, r_start);
+	ktime_t total;
+
+	if (unlikely(rc && rc != -ETIMEDOUT))
+		return;
+
+	spin_lock(&m->copyfrom_metric_lock);
+	total = ++m->total_copyfrom;
+	m->copyfrom_size_sum += size;
+	m->copyfrom_latency_sum += lat;
+	METRIC_UPDATE_MIN_MAX(m->copyfrom_size_min,
+			      m->copyfrom_size_max,
+			      size);
+	METRIC_UPDATE_MIN_MAX(m->copyfrom_latency_min,
+			      m->copyfrom_latency_max,
+			      lat);
+	__update_stdev(total, m->copyfrom_latency_sum,
+		       &m->copyfrom_latency_sq_sum, lat);
+	spin_unlock(&m->copyfrom_metric_lock);
+}
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 0133955a3c6a..c95517c7c77b 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -162,6 +162,16 @@ struct ceph_client_metric {
 	ktime_t metadata_latency_min;
 	ktime_t metadata_latency_max;
 
+	spinlock_t copyfrom_metric_lock;
+	u64 total_copyfrom;
+	u64 copyfrom_size_sum;
+	u64 copyfrom_size_min;
+	u64 copyfrom_size_max;
+	ktime_t copyfrom_latency_sum;
+	ktime_t copyfrom_latency_sq_sum;
+	ktime_t copyfrom_latency_min;
+	ktime_t copyfrom_latency_max;
+
 	/* The total number of directories and files that are opened */
 	atomic64_t opened_files;
 
@@ -204,4 +214,8 @@ extern void ceph_update_write_metrics(struct ceph_client_metric *m,
 extern void ceph_update_metadata_metrics(struct ceph_client_metric *m,
 				         ktime_t r_start, ktime_t r_end,
 					 int rc);
+extern void ceph_update_copyfrom_metrics(struct ceph_client_metric *m,
+					 ktime_t r_start, ktime_t r_end,
+					 unsigned int size, int rc);
+
 #endif /* _FS_CEPH_MDS_METRIC_H */
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 83fa08a06507..d282c7531a3f 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -524,7 +524,8 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
 			struct ceph_object_locator *dst_oloc,
 			u32 dst_fadvise_flags,
 			u32 truncate_seq, u64 truncate_size,
-			u8 copy_from_flags);
+			u8 copy_from_flags,
+			ktime_t *start_req, ktime_t *end_req);
 
 /* watch/notify */
 struct ceph_osd_linger_request *
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index ff8624a7c964..74ffe6240b07 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5356,7 +5356,8 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
 			struct ceph_object_locator *dst_oloc,
 			u32 dst_fadvise_flags,
 			u32 truncate_seq, u64 truncate_size,
-			u8 copy_from_flags)
+			u8 copy_from_flags,
+			ktime_t *start_req, ktime_t *end_req)
 {
 	struct ceph_osd_request *req;
 	int ret;
@@ -5364,6 +5365,8 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
 	req = ceph_osdc_alloc_request(osdc, NULL, 1, false, GFP_KERNEL);
 	if (!req)
 		return -ENOMEM;
+	*start_req = 0;
+	*end_req = 0;
 
 	req->r_flags = CEPH_OSD_FLAG_WRITE;
 
@@ -5383,7 +5386,8 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
 
 	ceph_osdc_start_request(osdc, req, false);
 	ret = ceph_osdc_wait_request(osdc, req);
-
+	*start_req = req->r_start_latency;
+	*end_req = req->r_end_latency;
 out:
 	ceph_osdc_put_request(req);
 	return ret;

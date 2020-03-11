Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA4D9180E32
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Mar 2020 03:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgCKCy2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Mar 2020 22:54:28 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24765 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727648AbgCKCy1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Mar 2020 22:54:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583895265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=dDAyTiA8z4tUaDJfbJsU8xG7hwtg3q/4131ko+/H6TM=;
        b=MY16FysfNl2JfXHxaQtKxWs302O0R1IIuCOIWLr69m8QSgltDHwGAM/n9aJE7nmxauViz9
        srpxPUnNwY4bsrhGK3OlLUOseDL8GVP6wLu0bskqrRCuTicQBIq8ibSKzsjgMfLrTdyTre
        QqeNLODeyHgz5bSFXyG3vw1+APN6cBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-lsHr_Dn0Pv6zeFqLSzSJww-1; Tue, 10 Mar 2020 22:54:19 -0400
X-MC-Unique: lsHr_Dn0Pv6zeFqLSzSJww-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26053106C011;
        Wed, 11 Mar 2020 02:54:18 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A752A60C18;
        Wed, 11 Mar 2020 02:54:15 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/2] ceph: move all the metric helpers into one separate file
Date:   Tue, 10 Mar 2020 22:54:06 -0400
Message-Id: <1583895247-17312-2-git-send-email-xiubli@redhat.com>
In-Reply-To: <1583895247-17312-1-git-send-email-xiubli@redhat.com>
References: <1583895247-17312-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The inline is not proper any more due to the helper becoming
larger and larger.

URL: https://tracker.ceph.com/issues/44534
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/Makefile     |   2 +-
 fs/ceph/mds_client.c |  95 +--------------------------
 fs/ceph/metric.c     | 177 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/metric.h     |  90 +++++---------------------
 4 files changed, 194 insertions(+), 170 deletions(-)
 create mode 100644 fs/ceph/metric.c

diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
index 0a0823d..50c635d 100644
--- a/fs/ceph/Makefile
+++ b/fs/ceph/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_CEPH_FS) += ceph.o
 ceph-y := super.o inode.o dir.o file.o locks.o addr.o ioctl.o \
 	export.o caps.o snap.o xattr.o quota.o io.o \
 	mds_client.o mdsmap.o strings.o ceph_frag.o \
-	debugfs.o util.o
+	debugfs.o util.o metric.o
 
 ceph-$(CONFIG_CEPH_FSCACHE) += cache.o
 ceph-$(CONFIG_CEPH_FS_POSIX_ACL) += acl.o
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index ff6c2be..eb2657e 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4326,90 +4326,6 @@ static void delayed_work(struct work_struct *work)
 	schedule_delayed(mdsc);
 }
 
-static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
-{
-	int ret;
-
-	if (!metric)
-		return -EINVAL;
-
-	atomic64_set(&metric->total_dentries, 0);
-	ret = percpu_counter_init(&metric->d_lease_hit, 0, GFP_KERNEL);
-	if (ret)
-		return ret;
-
-	ret = percpu_counter_init(&metric->d_lease_mis, 0, GFP_KERNEL);
-	if (ret)
-		goto err_d_lease_mis;
-
-	ret = percpu_counter_init(&metric->i_caps_hit, 0, GFP_KERNEL);
-	if (ret)
-		goto err_i_caps_hit;
-
-	ret = percpu_counter_init(&metric->i_caps_mis, 0, GFP_KERNEL);
-	if (ret)
-		goto err_i_caps_mis;
-
-	ret = percpu_counter_init(&metric->total_reads, 0, GFP_KERNEL);
-	if (ret)
-		goto err_total_reads;
-
-	ret = percpu_counter_init(&metric->read_latency_sum, 0, GFP_KERNEL);
-	if (ret)
-		goto err_read_latency_sum;
-
-	spin_lock_init(&metric->read_latency_lock);
-	atomic64_set(&metric->read_latency_min, S64_MAX);
-	atomic64_set(&metric->read_latency_max, 0);
-
-	ret = percpu_counter_init(&metric->total_writes, 0, GFP_KERNEL);
-	if (ret)
-		goto err_total_writes;
-
-	ret = percpu_counter_init(&metric->write_latency_sum, 0, GFP_KERNEL);
-	if (ret)
-		goto err_write_latency_sum;
-
-	spin_lock_init(&metric->write_latency_lock);
-	atomic64_set(&metric->write_latency_min, S64_MAX);
-	atomic64_set(&metric->write_latency_max, 0);
-
-	ret = percpu_counter_init(&metric->total_metadatas, 0, GFP_KERNEL);
-	if (ret)
-		goto err_total_metadatas;
-
-	ret = percpu_counter_init(&metric->metadata_latency_sum, 0, GFP_KERNEL);
-	if (ret)
-		goto err_metadata_latency_sum;
-
-	spin_lock_init(&metric->metadata_latency_lock);
-	atomic64_set(&metric->metadata_latency_min, S64_MAX);
-	atomic64_set(&metric->metadata_latency_max, 0);
-
-	return 0;
-
-err_metadata_latency_sum:
-	percpu_counter_destroy(&metric->total_metadatas);
-err_total_metadatas:
-	percpu_counter_destroy(&metric->write_latency_sum);
-err_write_latency_sum:
-	percpu_counter_destroy(&metric->total_writes);
-err_total_writes:
-	percpu_counter_destroy(&metric->read_latency_sum);
-err_read_latency_sum:
-	percpu_counter_destroy(&metric->total_reads);
-err_total_reads:
-	percpu_counter_destroy(&metric->i_caps_mis);
-err_i_caps_mis:
-	percpu_counter_destroy(&metric->i_caps_hit);
-err_i_caps_hit:
-	percpu_counter_destroy(&metric->d_lease_mis);
-err_d_lease_mis:
-	percpu_counter_destroy(&metric->d_lease_hit);
-
-	return ret;
-}
-
 int ceph_mdsc_init(struct ceph_fs_client *fsc)
 
 {
@@ -4747,16 +4663,7 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
 
 	ceph_mdsc_stop(mdsc);
 
-	percpu_counter_destroy(&mdsc->metric.metadata_latency_sum);
-	percpu_counter_destroy(&mdsc->metric.total_metadatas);
-	percpu_counter_destroy(&mdsc->metric.write_latency_sum);
-	percpu_counter_destroy(&mdsc->metric.total_writes);
-	percpu_counter_destroy(&mdsc->metric.read_latency_sum);
-	percpu_counter_destroy(&mdsc->metric.total_reads);
-	percpu_counter_destroy(&mdsc->metric.i_caps_mis);
-	percpu_counter_destroy(&mdsc->metric.i_caps_hit);
-	percpu_counter_destroy(&mdsc->metric.d_lease_mis);
-	percpu_counter_destroy(&mdsc->metric.d_lease_hit);
+	ceph_mdsc_metric_destroy(&mdsc->metric);
 
 	fsc->mdsc = NULL;
 	kfree(mdsc);
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
new file mode 100644
index 0000000..4a1bf27
--- /dev/null
+++ b/fs/ceph/metric.c
@@ -0,0 +1,177 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/atomic.h>
+#include <linux/percpu_counter.h>
+#include <linux/spinlock.h>
+
+#include "metric.h"
+
+int ceph_mdsc_metric_init(struct ceph_client_metric *m)
+{
+	int ret;
+
+	atomic64_set(&m->total_dentries, 0);
+	ret = percpu_counter_init(&m->d_lease_hit, 0, GFP_KERNEL);
+	if (ret)
+		return ret;
+
+	ret = percpu_counter_init(&m->d_lease_mis, 0, GFP_KERNEL);
+	if (ret)
+		goto err_d_lease_mis;
+
+	ret = percpu_counter_init(&m->i_caps_hit, 0, GFP_KERNEL);
+	if (ret)
+		goto err_i_caps_hit;
+
+	ret = percpu_counter_init(&m->i_caps_mis, 0, GFP_KERNEL);
+	if (ret)
+		goto err_i_caps_mis;
+
+	ret = percpu_counter_init(&m->total_reads, 0, GFP_KERNEL);
+	if (ret)
+		goto err_total_reads;
+
+	ret = percpu_counter_init(&m->read_latency_sum, 0, GFP_KERNEL);
+	if (ret)
+		goto err_read_latency_sum;
+
+	spin_lock_init(&m->read_latency_lock);
+	atomic64_set(&m->read_latency_min, S64_MAX);
+	atomic64_set(&m->read_latency_max, 0);
+
+	ret = percpu_counter_init(&m->total_writes, 0, GFP_KERNEL);
+	if (ret)
+		goto err_total_writes;
+
+	ret = percpu_counter_init(&m->write_latency_sum, 0, GFP_KERNEL);
+	if (ret)
+		goto err_write_latency_sum;
+
+	spin_lock_init(&m->write_latency_lock);
+	atomic64_set(&m->write_latency_min, S64_MAX);
+	atomic64_set(&m->write_latency_max, 0);
+
+	ret = percpu_counter_init(&m->total_metadatas, 0, GFP_KERNEL);
+	if (ret)
+		goto err_total_metadatas;
+
+	ret = percpu_counter_init(&m->metadata_latency_sum, 0, GFP_KERNEL);
+	if (ret)
+		goto err_metadata_latency_sum;
+
+	spin_lock_init(&m->metadata_latency_lock);
+	atomic64_set(&m->metadata_latency_min, S64_MAX);
+	atomic64_set(&m->metadata_latency_max, 0);
+
+	return 0;
+
+err_metadata_latency_sum:
+	percpu_counter_destroy(&m->total_metadatas);
+err_total_metadatas:
+	percpu_counter_destroy(&m->write_latency_sum);
+err_write_latency_sum:
+	percpu_counter_destroy(&m->total_writes);
+err_total_writes:
+	percpu_counter_destroy(&m->read_latency_sum);
+err_read_latency_sum:
+	percpu_counter_destroy(&m->total_reads);
+err_total_reads:
+	percpu_counter_destroy(&m->i_caps_mis);
+err_i_caps_mis:
+	percpu_counter_destroy(&m->i_caps_hit);
+err_i_caps_hit:
+	percpu_counter_destroy(&m->d_lease_mis);
+err_d_lease_mis:
+	percpu_counter_destroy(&m->d_lease_hit);
+
+	return ret;
+}
+
+void ceph_mdsc_metric_destroy(struct ceph_client_metric *m)
+{
+	percpu_counter_destroy(&m->metadata_latency_sum);
+	percpu_counter_destroy(&m->total_metadatas);
+	percpu_counter_destroy(&m->write_latency_sum);
+	percpu_counter_destroy(&m->total_writes);
+	percpu_counter_destroy(&m->read_latency_sum);
+	percpu_counter_destroy(&m->total_reads);
+	percpu_counter_destroy(&m->i_caps_mis);
+	percpu_counter_destroy(&m->i_caps_hit);
+	percpu_counter_destroy(&m->d_lease_mis);
+	percpu_counter_destroy(&m->d_lease_hit);
+}
+
+void ceph_update_read_latency(struct ceph_client_metric *m,
+			      unsigned long r_start,
+			      unsigned long r_end,
+			      int rc)
+{
+	unsigned long lat = r_end - r_start;
+
+	if (rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT)
+		return;
+
+	percpu_counter_inc(&m->total_reads);
+	percpu_counter_add(&m->read_latency_sum, lat);
+
+	if (lat >= atomic64_read(&m->read_latency_min) &&
+	    lat <= atomic64_read(&m->read_latency_max))
+		return;
+
+	spin_lock(&m->read_latency_lock);
+	if (lat < atomic64_read(&m->read_latency_min))
+		atomic64_set(&m->read_latency_min, lat);
+	if (lat > atomic64_read(&m->read_latency_max))
+		atomic64_set(&m->read_latency_max, lat);
+	spin_unlock(&m->read_latency_lock);
+}
+
+void ceph_update_write_latency(struct ceph_client_metric *m,
+			       unsigned long r_start,
+			       unsigned long r_end,
+			       int rc)
+{
+	unsigned long lat = r_end - r_start;
+
+	if (rc && rc != -ETIMEDOUT)
+		return;
+
+	percpu_counter_inc(&m->total_writes);
+	percpu_counter_add(&m->write_latency_sum, r_end - r_start);
+
+	if (lat >= atomic64_read(&m->write_latency_min) &&
+	    lat <= atomic64_read(&m->write_latency_max))
+		return;
+
+	spin_lock(&m->write_latency_lock);
+	if (lat < atomic64_read(&m->write_latency_min))
+		atomic64_set(&m->write_latency_min, lat);
+	if (lat > atomic64_read(&m->write_latency_max))
+		atomic64_set(&m->write_latency_max, lat);
+	spin_unlock(&m->write_latency_lock);
+}
+
+void ceph_update_metadata_latency(struct ceph_client_metric *m,
+				  unsigned long r_start,
+				  unsigned long r_end,
+				  int rc)
+{
+	unsigned long lat = r_end - r_start;
+
+	if (rc && rc != -ENOENT)
+		return;
+
+	percpu_counter_inc(&m->total_metadatas);
+	percpu_counter_add(&m->metadata_latency_sum, r_end - r_start);
+
+	if (lat >= atomic64_read(&m->metadata_latency_min) &&
+	    lat <= atomic64_read(&m->metadata_latency_max))
+		return;
+
+	spin_lock(&m->metadata_latency_lock);
+	if (lat < atomic64_read(&m->metadata_latency_min))
+		atomic64_set(&m->metadata_latency_min, lat);
+	if (lat > atomic64_read(&m->metadata_latency_max))
+		atomic64_set(&m->metadata_latency_max, lat);
+	spin_unlock(&m->metadata_latency_lock);
+}
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 9f0d050..493e787 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -3,7 +3,7 @@
 #define _FS_CEPH_MDS_METRIC_H
 
 #include <linux/atomic.h>
-#include <linux/percpu.h>
+#include <linux/percpu_counter.h>
 #include <linux/spinlock.h>
 
 /* This is the global metrics */
@@ -44,78 +44,18 @@ static inline void ceph_update_cap_mis(struct ceph_client_metric *m)
 	percpu_counter_inc(&m->i_caps_mis);
 }
 
-static inline void ceph_update_read_latency(struct ceph_client_metric *m,
-					    unsigned long r_start,
-					    unsigned long r_end,
-					    int rc)
-{
-	unsigned long lat = r_end - r_start;
-
-	if (rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT)
-		return;
-
-	percpu_counter_inc(&m->total_reads);
-	percpu_counter_add(&m->read_latency_sum, lat);
-
-	if (lat >= atomic64_read(&m->read_latency_min) &&
-	    lat <= atomic64_read(&m->read_latency_max))
-		return;
-
-	spin_lock(&m->read_latency_lock);
-	if (lat < atomic64_read(&m->read_latency_min))
-		atomic64_set(&m->read_latency_min, lat);
-	if (lat > atomic64_read(&m->read_latency_max))
-		atomic64_set(&m->read_latency_max, lat);
-	spin_unlock(&m->read_latency_lock);
-}
-
-static inline void ceph_update_write_latency(struct ceph_client_metric *m,
-					     unsigned long r_start,
-					     unsigned long r_end,
-					     int rc)
-{
-	unsigned long lat = r_end - r_start;
-
-	if (rc && rc != -ETIMEDOUT)
-		return;
-
-	percpu_counter_inc(&m->total_writes);
-	percpu_counter_add(&m->write_latency_sum, r_end - r_start);
-
-	if (lat >= atomic64_read(&m->write_latency_min) &&
-	    lat <= atomic64_read(&m->write_latency_max))
-		return;
-
-	spin_lock(&m->write_latency_lock);
-	if (lat < atomic64_read(&m->write_latency_min))
-		atomic64_set(&m->write_latency_min, lat);
-	if (lat > atomic64_read(&m->write_latency_max))
-		atomic64_set(&m->write_latency_max, lat);
-	spin_unlock(&m->write_latency_lock);
-}
-
-static inline void ceph_update_metadata_latency(struct ceph_client_metric *m,
-						unsigned long r_start,
-						unsigned long r_end,
-						int rc)
-{
-	unsigned long lat = r_end - r_start;
-
-	if (rc && rc != -ENOENT)
-		return;
-
-	percpu_counter_inc(&m->total_metadatas);
-	percpu_counter_add(&m->metadata_latency_sum, r_end - r_start);
-
-	if (lat >= atomic64_read(&m->metadata_latency_min) &&
-	    lat <= atomic64_read(&m->metadata_latency_max))
-		return;
-
-	spin_lock(&m->metadata_latency_lock);
-	if (lat < atomic64_read(&m->metadata_latency_min))
-		atomic64_set(&m->metadata_latency_min, lat);
-	if (lat > atomic64_read(&m->metadata_latency_max))
-		atomic64_set(&m->metadata_latency_max, lat);
-	spin_unlock(&m->metadata_latency_lock);
-}
+extern int ceph_mdsc_metric_init(struct ceph_client_metric *m);
+extern void ceph_mdsc_metric_destroy(struct ceph_client_metric *m);
+extern void ceph_update_read_latency(struct ceph_client_metric *m,
+				     unsigned long r_start,
+				     unsigned long r_end,
+				     int rc);
+extern void ceph_update_write_latency(struct ceph_client_metric *m,
+				      unsigned long r_start,
+				      unsigned long r_end,
+				      int rc);
+extern void ceph_update_metadata_latency(struct ceph_client_metric *m,
+					 unsigned long r_start,
+					 unsigned long r_end,
+					 int rc);
 #endif /* _FS_CEPH_MDS_METRIC_H */
-- 
1.8.3.1


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB58120C716
	for <lists+ceph-devel@lfdr.de>; Sun, 28 Jun 2020 10:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgF1Ime (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 28 Jun 2020 04:42:34 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43546 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726105AbgF1Ime (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 28 Jun 2020 04:42:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593333752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=XJvCYta9kvuo2nFld2eAMUgvnv4oS9CcRBzrSGcWMuo=;
        b=KoWyPthAP4scKC3dUC0+RBe2Hjb0e4mHFQJWiQsi/WBfNilY3LcCbVrDvs+qeC6MpNjYfl
        wMajLBi/H4p57PJw4YRSIoYDk9tjZps/EmP/ZfIyyCTop3pZ/8n6J0BN+6i/shrKG8D9Ve
        jFkZshadHghEetlslGKVmRiZnFq++VU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-Ihpq9HcUNKijl8g3ppI9mQ-1; Sun, 28 Jun 2020 04:42:27 -0400
X-MC-Unique: Ihpq9HcUNKijl8g3ppI9mQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6338480183C;
        Sun, 28 Jun 2020 08:42:26 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm37-55.gsslab.pek2.redhat.com [10.72.37.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AA141944D;
        Sun, 28 Jun 2020 08:42:24 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 2/5] ceph: add global total_caps to count the mdsc's total caps number
Date:   Sun, 28 Jun 2020 04:42:11 -0400
Message-Id: <1593333734-27480-3-git-send-email-xiubli@redhat.com>
In-Reply-To: <1593333734-27480-1-git-send-email-xiubli@redhat.com>
References: <1593333734-27480-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will help to reduce using the global mdsc->metux lock in many
places.

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c       |  2 ++
 fs/ceph/debugfs.c    | 14 ++------------
 fs/ceph/mds_client.c |  1 +
 fs/ceph/metric.c     |  1 +
 fs/ceph/metric.h     |  1 +
 5 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 972c13a..5f48940 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -668,6 +668,7 @@ void ceph_add_cap(struct inode *inode,
 		spin_lock(&session->s_cap_lock);
 		list_add_tail(&cap->session_caps, &session->s_caps);
 		session->s_nr_caps++;
+		atomic64_inc(&mdsc->metric.total_caps);
 		spin_unlock(&session->s_cap_lock);
 	} else {
 		spin_lock(&session->s_cap_lock);
@@ -1161,6 +1162,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 	} else {
 		list_del_init(&cap->session_caps);
 		session->s_nr_caps--;
+		atomic64_dec(&mdsc->metric.total_caps);
 		cap->session = NULL;
 		removed = 1;
 	}
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 070ed84..3030f55 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -145,7 +145,7 @@ static int metric_show(struct seq_file *s, void *p)
 	struct ceph_fs_client *fsc = s->private;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_client_metric *m = &mdsc->metric;
-	int i, nr_caps = 0;
+	int nr_caps = 0;
 	s64 total, sum, avg, min, max, sq;
 
 	seq_printf(s, "item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)\n");
@@ -190,17 +190,7 @@ static int metric_show(struct seq_file *s, void *p)
 		   percpu_counter_sum(&m->d_lease_mis),
 		   percpu_counter_sum(&m->d_lease_hit));
 
-	mutex_lock(&mdsc->mutex);
-	for (i = 0; i < mdsc->max_sessions; i++) {
-		struct ceph_mds_session *s;
-
-		s = __ceph_lookup_mds_session(mdsc, i);
-		if (!s)
-			continue;
-		nr_caps += s->s_nr_caps;
-		ceph_put_mds_session(s);
-	}
-	mutex_unlock(&mdsc->mutex);
+	nr_caps = atomic64_read(&m->total_caps);
 	seq_printf(s, "%-14s%-16d%-16lld%lld\n", "caps", nr_caps,
 		   percpu_counter_sum(&m->i_caps_mis),
 		   percpu_counter_sum(&m->i_caps_hit));
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 608fb5c..2eeab10 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1485,6 +1485,7 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
 			cap->session = NULL;
 			list_del_init(&cap->session_caps);
 			session->s_nr_caps--;
+			atomic64_dec(&session->s_mdsc->metric.total_caps);
 			if (cap->queue_release)
 				__ceph_queue_cap_release(session, cap);
 			else
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 9217f35..269eacb 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -22,6 +22,7 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	if (ret)
 		goto err_d_lease_mis;
 
+	atomic64_set(&m->total_caps, 0);
 	ret = percpu_counter_init(&m->i_caps_hit, 0, GFP_KERNEL);
 	if (ret)
 		goto err_i_caps_hit;
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index ccd8128..23a3373 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -12,6 +12,7 @@ struct ceph_client_metric {
 	struct percpu_counter d_lease_hit;
 	struct percpu_counter d_lease_mis;
 
+	atomic64_t            total_caps;
 	struct percpu_counter i_caps_hit;
 	struct percpu_counter i_caps_mis;
 
-- 
1.8.3.1


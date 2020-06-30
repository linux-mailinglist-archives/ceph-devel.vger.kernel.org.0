Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2B520EFE5
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jun 2020 09:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731342AbgF3Hws (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Jun 2020 03:52:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36823 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731334AbgF3Hwr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Jun 2020 03:52:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593503566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=lwdvplOD6S+epb2QnjHsJr6hI7dgFp/xOoG3CaiyzZA=;
        b=PW1SK+pjPW5AbtWex0NEEn6Xbdf9w/4HvgAuvsv8Djfn38WWMJt1b/GrCaYBZuvHMnA8HT
        UxAd3l1X2uFSoe+xTl5UnUOm0YZqTSCxUxFhFpzy1JlUAhSAqYylyYAVIsk9e97b93xPRF
        KmvALt5nVP1E9dwWtgJ2fF+8NdNfoVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-AHHySSNNPE-6-Hi7gUwmWQ-1; Tue, 30 Jun 2020 03:52:43 -0400
X-MC-Unique: AHHySSNNPE-6-Hi7gUwmWQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE132107ACF5;
        Tue, 30 Jun 2020 07:52:42 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm37-55.gsslab.pek2.redhat.com [10.72.37.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71A6C1000079;
        Tue, 30 Jun 2020 07:52:40 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        vshankar@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v5 2/5] ceph: add global total_caps to count the mdsc's total caps number
Date:   Tue, 30 Jun 2020 03:52:16 -0400
Message-Id: <1593503539-1209-3-git-send-email-xiubli@redhat.com>
In-Reply-To: <1593503539-1209-1-git-send-email-xiubli@redhat.com>
References: <1593503539-1209-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index 58c54d4..f3c7123 100644
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


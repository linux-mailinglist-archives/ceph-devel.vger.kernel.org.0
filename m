Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A48D166FFF
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Feb 2020 08:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbgBUHHR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Feb 2020 02:07:17 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34742 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726278AbgBUHHQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 02:07:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582268836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZwhGmJUTNf3mzI96aSLxWLI7xeNyT2UsBwwl5coZsXU=;
        b=EnL6ALT1kdaFqBl2iuqZAlInAfie3fuF/Fy7md4AArrkAl8pa5HZXFyY2JHzT0oglj3U5V
        L0NtMmi/+lDE2RPBG7rMqwPkFLlfncF1vf6+fZf0CfTEFaKfOOlFpTyOxps4cHtEC+LF+r
        gihGqTOrXIYEpDuwHqU4je1MZXfTf9o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-rTG6u42bNoeKs8pQyGyWfQ-1; Fri, 21 Feb 2020 02:07:11 -0500
X-MC-Unique: rTG6u42bNoeKs8pQyGyWfQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0FB6107ACC5;
        Fri, 21 Feb 2020 07:07:10 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D07365D9E2;
        Fri, 21 Feb 2020 07:07:06 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v8 5/5] ceph: add global metadata perf metric support
Date:   Fri, 21 Feb 2020 02:05:56 -0500
Message-Id: <20200221070556.18922-6-xiubli@redhat.com>
In-Reply-To: <20200221070556.18922-1-xiubli@redhat.com>
References: <20200221070556.18922-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

It will calculate the latency for the metedata requests, which only
include the time cousumed by network and the ceph.

item          total       sum_lat(us)     avg_lat(us)
-----------------------------------------------------
metadata      113         220000          1946

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/debugfs.c    |  6 ++++++
 fs/ceph/mds_client.c | 20 ++++++++++++++++++++
 fs/ceph/metric.h     | 13 +++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 464bfbdb970d..60f3e307fca1 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -146,6 +146,12 @@ static int metric_show(struct seq_file *s, void *p)
 	avg =3D total ? sum / total : 0;
 	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "write", total, sum, avg);
=20
+	total =3D percpu_counter_sum(&mdsc->metric.total_metadatas);
+	sum =3D percpu_counter_sum(&mdsc->metric.metadata_latency_sum);
+	sum =3D jiffies_to_usecs(sum);
+	avg =3D total ? sum / total : 0;
+	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "metadata", total, sum, avg)=
;
+
 	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0a3447966b26..3e792eca6af7 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3017,6 +3017,12 @@ static void handle_reply(struct ceph_mds_session *=
session, struct ceph_msg *msg)
=20
 	/* kick calling process */
 	complete_request(mdsc, req);
+
+	if (!result || result =3D=3D -ENOENT) {
+		s64 latency =3D jiffies - req->r_started;
+
+		ceph_update_metadata_latency(&mdsc->metric, latency);
+	}
 out:
 	ceph_mdsc_put_request(req);
 	return;
@@ -4196,8 +4202,20 @@ static int ceph_mdsc_metric_init(struct ceph_clien=
t_metric *metric)
 	if (ret)
 		goto err_write_latency_sum;
=20
+	ret =3D percpu_counter_init(&metric->total_metadatas, 0, GFP_KERNEL);
+	if (ret)
+		goto err_total_metadatas;
+
+	ret =3D percpu_counter_init(&metric->metadata_latency_sum, 0, GFP_KERNE=
L);
+	if (ret)
+		goto err_metadata_latency_sum;
+
 	return 0;
=20
+err_metadata_latency_sum:
+	percpu_counter_destroy(&metric->total_metadatas);
+err_total_metadatas:
+	percpu_counter_destroy(&metric->write_latency_sum);
 err_write_latency_sum:
 	percpu_counter_destroy(&metric->total_writes);
 err_total_writes:
@@ -4553,6 +4571,8 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
=20
 	ceph_mdsc_stop(mdsc);
=20
+	percpu_counter_destroy(&mdsc->metric.metadata_latency_sum);
+	percpu_counter_destroy(&mdsc->metric.total_metadatas);
 	percpu_counter_destroy(&mdsc->metric.write_latency_sum);
 	percpu_counter_destroy(&mdsc->metric.total_writes);
 	percpu_counter_destroy(&mdsc->metric.read_latency_sum);
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index a3d342f258e6..4c14b4ac089d 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -18,6 +18,9 @@ struct ceph_client_metric {
=20
 	struct percpu_counter total_writes;
 	struct percpu_counter write_latency_sum;
+
+	struct percpu_counter total_metadatas;
+	struct percpu_counter metadata_latency_sum;
 };
=20
 static inline void ceph_update_cap_hit(struct ceph_client_metric *m)
@@ -65,4 +68,14 @@ static inline void ceph_update_write_latency(struct ce=
ph_client_metric *m,
 		percpu_counter_add(&m->write_latency_sum, latency);
 	}
 }
+
+static inline void ceph_update_metadata_latency(struct ceph_client_metri=
c *m,
+						s64 latency)
+{
+	if (!m)
+		return;
+
+	percpu_counter_inc(&m->total_metadatas);
+	percpu_counter_add(&m->metadata_latency_sum, latency);
+}
 #endif /* _FS_CEPH_MDS_METRIC_H */
--=20
2.21.0


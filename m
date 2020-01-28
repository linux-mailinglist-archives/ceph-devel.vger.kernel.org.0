Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE86F14B49B
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jan 2020 14:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgA1NDb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Jan 2020 08:03:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40465 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725852AbgA1NDb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 Jan 2020 08:03:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580216610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pZyMP45G5kXP8v419o76iOuhS2F62vcSL96XsFjFBMQ=;
        b=Sf3WuqxgLFyKW9rFCuUScSYCPqzaOEqG8VFmflL8BZ+qtZRhGE0hCoV5vNlkMTRZKIiLGB
        Dv/LOGb6fYEH+LrBQr52smcGHJSWeWSTaEM0Pty3UU/Svf0xGoW8iqDxpeEZrS3onVu/A9
        3b86lvf7djwzuGpBkUdVIniliQlzF30=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-gmAWtRz8MLOFHw-9l2y7IQ-1; Tue, 28 Jan 2020 08:03:27 -0500
X-MC-Unique: gmAWtRz8MLOFHw-9l2y7IQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A199107ACCA;
        Tue, 28 Jan 2020 13:03:26 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C21FD863D3;
        Tue, 28 Jan 2020 13:03:22 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v5 06/10] ceph: add global metadata perf metric support
Date:   Tue, 28 Jan 2020 08:02:44 -0500
Message-Id: <20200128130248.4266-7-xiubli@redhat.com>
In-Reply-To: <20200128130248.4266-1-xiubli@redhat.com>
References: <20200128130248.4266-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

item          total       sum_lat(us)     avg_lat(us)
-----------------------------------------------------
metadata      1288        24506000        19026

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/debugfs.c    |  6 ++++++
 fs/ceph/mds_client.c | 25 +++++++++++++++++++++++++
 fs/ceph/metric.h     | 13 +++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 3d27f2e6f556..7fd031c18309 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -146,6 +146,12 @@ static int metric_show(struct seq_file *s, void *p)
 	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "write",
 		   total, sum / NSEC_PER_USEC, avg / NSEC_PER_USEC);
=20
+	total =3D percpu_counter_sum(&mdsc->metric.total_metadatas);
+	sum =3D percpu_counter_sum(&mdsc->metric.metadata_latency_sum);
+	avg =3D total ? sum / total : 0;
+	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "metadata",
+		   total, sum / NSEC_PER_USEC, avg / NSEC_PER_USEC);
+
 	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d072cab77ab2..92a933810a79 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2772,6 +2772,12 @@ static int ceph_mdsc_wait_request(struct ceph_mds_=
client *mdsc,
 		else
 			err =3D timeleft;  /* killed */
 	}
+
+	if (!err || err =3D=3D -EIO) {
+		s64 latency =3D jiffies - req->r_started;
+		ceph_update_metadata_latency(&mdsc->metric, latency);
+	}
+
 	dout("do_request waited, got %d\n", err);
 	mutex_lock(&mdsc->mutex);
=20
@@ -3033,6 +3039,11 @@ static void handle_reply(struct ceph_mds_session *=
session, struct ceph_msg *msg)
=20
 	/* kick calling process */
 	complete_request(mdsc, req);
+
+	if (!result || result =3D=3D -ENOENT) {
+		s64 latency =3D jiffies - req->r_started;
+		ceph_update_metadata_latency(&mdsc->metric, latency);
+	}
 out:
 	ceph_mdsc_put_request(req);
 	return;
@@ -4203,7 +4214,19 @@ static int ceph_mdsc_metric_init(struct ceph_clien=
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
 	return ret;
+err_metadata_latency_sum:
+	percpu_counter_destroy(&metric->total_metadatas);
+err_total_metadatas:
+	percpu_counter_destroy(&metric->write_latency_sum);
 err_write_latency_sum:
 	percpu_counter_destroy(&metric->total_writes);
 err_total_writes:
@@ -4555,6 +4578,8 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
=20
 	ceph_mdsc_stop(mdsc);
=20
+	percpu_counter_destroy(&mdsc->metric.metadata_latency_sum);
+	percpu_counter_destroy(&mdsc->metric.total_metadatas);
 	percpu_counter_destroy(&mdsc->metric.write_latency_sum);
 	percpu_counter_destroy(&mdsc->metric.total_writes);
 	percpu_counter_destroy(&mdsc->metric.read_latency_sum);
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 49546961eeed..3cda616ba594 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -15,6 +15,9 @@ struct ceph_client_metric {
=20
 	struct percpu_counter	total_writes;
 	struct percpu_counter	write_latency_sum;
+
+	struct percpu_counter	total_metadatas;
+	struct percpu_counter	metadata_latency_sum;
 };
=20
 static inline void ceph_update_read_latency(struct ceph_client_metric *m=
,
@@ -44,4 +47,14 @@ static inline void ceph_update_write_latency(struct ce=
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
 #endif
--=20
2.21.0


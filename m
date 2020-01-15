Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4968213B845
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2020 04:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgAODpd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Jan 2020 22:45:33 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46698 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728879AbgAODpd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 22:45:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579059931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PCrPh2PmuSiNoJNNneFMLIWTL+JRFsCtTfeQ2PL63C0=;
        b=OQHIH9HfsikAPnHUVIy30sSOTyc4YLFJMhRZ0R9YTv+aWIKAG0rqEXUqaX3wIW7W1dDLvK
        rUhrvuOAnorYQ1EFAa1W5yk0tew/r1gLYrcRtRyRjbG2sOmQqfQrHCqYkhOfa9tOGWptyw
        s7WC4aFa7SyJqD4ANmI4lKl1SvMYlas=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-yLXVfR1MMgSK4yw-6mNr3Q-1; Tue, 14 Jan 2020 22:45:30 -0500
X-MC-Unique: yLXVfR1MMgSK4yw-6mNr3Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56DBE1800D48;
        Wed, 15 Jan 2020 03:45:29 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-49.pek2.redhat.com [10.72.12.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48390101F6D4;
        Wed, 15 Jan 2020 03:45:24 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 5/8] ceph: add global metadata perf metric support
Date:   Tue, 14 Jan 2020 22:44:41 -0500
Message-Id: <20200115034444.14304-6-xiubli@redhat.com>
In-Reply-To: <20200115034444.14304-1-xiubli@redhat.com>
References: <20200115034444.14304-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
 fs/ceph/debugfs.c    |  8 ++++++++
 fs/ceph/mds_client.c | 25 +++++++++++++++++++++++++
 fs/ceph/mds_client.h |  6 ++++++
 3 files changed, 39 insertions(+)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 3fdb15af0a83..df8c1cc685d9 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -150,6 +150,14 @@ static int metric_show(struct seq_file *s, void *p)
 	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "write",
 		   total, sum / NSEC_PER_USEC, avg / NSEC_PER_USEC);
=20
+	spin_lock(&mdsc->metric.metadata_lock);
+	total =3D atomic64_read(&mdsc->metric.total_metadatas),
+	sum =3D timespec64_to_ns(&mdsc->metric.metadata_latency_sum);
+	spin_unlock(&mdsc->metric.metadata_lock);
+	avg =3D total ? sum / total : 0;
+	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "metadata",
+		   total, sum / NSEC_PER_USEC, avg / NSEC_PER_USEC);
+
 	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 2569f9303c0c..4539bd4b3451 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2903,6 +2903,11 @@ static void handle_reply(struct ceph_mds_session *=
session, struct ceph_msg *msg)
=20
 	result =3D le32_to_cpu(head->result);
=20
+	if (!result || result =3D=3D -ESTALE || result =3D=3D -ENOENT) {
+		s64 latency =3D jiffies - req->r_started;
+		ceph_mdsc_update_metadata_latency(&mdsc->metric, latency);
+	}
+
 	/*
 	 * Handle an ESTALE
 	 * if we're not talking to the authority, send to them
@@ -4128,6 +4133,22 @@ void ceph_mdsc_update_write_latency(struct ceph_cl=
ient_metric *m,
 	spin_unlock(&m->write_lock);
 }
=20
+void ceph_mdsc_update_metadata_latency(struct ceph_client_metric *m,
+				       s64 latency)
+{
+	struct timespec64 ts;
+
+	if (!m)
+		return;
+
+	jiffies_to_timespec64(latency, &ts);
+
+	spin_lock(&m->metadata_lock);
+	atomic64_inc(&m->total_metadatas);
+	m->metadata_latency_sum =3D timespec64_add(m->metadata_latency_sum, ts)=
;
+	spin_unlock(&m->metadata_lock);
+}
+
 /*
  * delayed work -- periodically trim expired leases, renew caps with mds
  */
@@ -4232,6 +4253,10 @@ static int ceph_mdsc_metric_init(struct ceph_clien=
t_metric *metric)
 	memset(&metric->write_latency_sum, 0, sizeof(struct timespec64));
 	atomic64_set(&metric->total_writes, 0);
=20
+	spin_lock_init(&metric->metadata_lock);
+	memset(&metric->metadata_latency_sum, 0, sizeof(struct timespec64));
+	atomic64_set(&metric->total_metadatas, 0);
+
 	return 0;
 }
=20
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 0120357e7549..37cc12d40eef 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -374,6 +374,10 @@ struct ceph_client_metric {
 	spinlock_t              write_lock;
 	atomic64_t		total_writes;
 	struct timespec64	write_latency_sum;
+
+	spinlock_t              metadata_lock;
+	atomic64_t		total_metadatas;
+	struct timespec64	metadata_latency_sum;
 };
=20
 /*
@@ -562,4 +566,6 @@ extern void ceph_mdsc_update_read_latency(struct ceph=
_client_metric *m,
 					  s64 latency);
 extern void ceph_mdsc_update_write_latency(struct ceph_client_metric *m,
 					   s64 latency);
+extern void ceph_mdsc_update_metadata_latency(struct ceph_client_metric =
*m,
+					      s64 latency);
 #endif
--=20
2.21.0


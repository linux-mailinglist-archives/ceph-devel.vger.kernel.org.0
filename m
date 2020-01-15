Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42E3313B847
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2020 04:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgAODpk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Jan 2020 22:45:40 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23651 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728896AbgAODpk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 22:45:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579059938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ys2NT/2KAy4Uy82ynSA4pUVt0gFWXMlxtTrJPQlK5/g=;
        b=RAAnO3D0QiZ8xmwBTdqvXzgj7Z9Q49mk69t8it+U+EtTCVMGjf9UNZkLvDFQtGhM/b4JkG
        h/kQNfc0Ya2gq/YwK1mITvTkloY7ZmduPiJW+9FOCnjFcktQ/hUgnPROC8AxXrEKNqudN9
        syoq2MT5b0z9PRJsRHWDWd7Z2tqBEds=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-my8Oq0u6NQeAD0Dk4Rvtsg-1; Tue, 14 Jan 2020 22:45:36 -0500
X-MC-Unique: my8Oq0u6NQeAD0Dk4Rvtsg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0730800D48;
        Wed, 15 Jan 2020 03:45:35 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-49.pek2.redhat.com [10.72.12.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C8C7101F6D4;
        Wed, 15 Jan 2020 03:45:32 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 7/8] ceph: add reset metrics support
Date:   Tue, 14 Jan 2020 22:44:43 -0500
Message-Id: <20200115034444.14304-8-xiubli@redhat.com>
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

This will reset the most metric counters, except the cap and dentry
total numbers.

Sometimes we need to discard the old metrics and start to get new
metrics.

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/debugfs.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/super.h   |  1 +
 2 files changed, 58 insertions(+)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index bb96fb4d04c4..c24a704d4e99 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -158,6 +158,55 @@ static int sending_metrics_get(void *data, u64 *val)
 DEFINE_SIMPLE_ATTRIBUTE(sending_metrics_fops, sending_metrics_get,
 			sending_metrics_set, "%llu\n");
=20
+static int reset_metrics_set(void *data, u64 val)
+{
+	struct ceph_fs_client *fsc =3D (struct ceph_fs_client *)data;
+	struct ceph_mds_client *mdsc =3D fsc->mdsc;
+	struct ceph_client_metric *metric =3D &mdsc->metric;
+	int i;
+
+	if (val !=3D 1) {
+		pr_err("Invalid reset metrics set value %llu\n", val);
+		return -EINVAL;
+	}
+
+	percpu_counter_set(&metric->d_lease_hit, 0);
+	percpu_counter_set(&metric->d_lease_mis, 0);
+
+	spin_lock(&metric->read_lock);
+	memset(&metric->read_latency_sum, 0, sizeof(struct timespec64));
+	atomic64_set(&metric->total_reads, 0),
+	spin_unlock(&metric->read_lock);
+
+	spin_lock(&metric->write_lock);
+	memset(&metric->write_latency_sum, 0, sizeof(struct timespec64));
+	atomic64_set(&metric->total_writes, 0),
+	spin_unlock(&metric->write_lock);
+
+	spin_lock(&metric->metadata_lock);
+	memset(&metric->metadata_latency_sum, 0, sizeof(struct timespec64));
+	atomic64_set(&metric->total_metadatas, 0),
+	spin_unlock(&metric->metadata_lock);
+
+	mutex_lock(&mdsc->mutex);
+	for (i =3D 0; i < mdsc->max_sessions; i++) {
+		struct ceph_mds_session *session;
+
+		session =3D __ceph_lookup_mds_session(mdsc, i);
+		if (!session)
+			continue;
+		percpu_counter_set(&session->i_caps_hit, 0);
+		percpu_counter_set(&session->i_caps_mis, 0);
+		ceph_put_mds_session(session);
+	}
+
+	mutex_unlock(&mdsc->mutex);
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(reset_metrics_fops, NULL, reset_metrics_set, "%l=
lu\n");
+
 static int metric_show(struct seq_file *s, void *p)
 {
 	struct ceph_fs_client *fsc =3D s->private;
@@ -355,6 +404,7 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *f=
sc)
 	debugfs_remove(fsc->debugfs_caps);
 	debugfs_remove(fsc->debugfs_metric);
 	debugfs_remove(fsc->debugfs_sending_metrics);
+	debugfs_remove(fsc->debugfs_reset_metrics);
 	debugfs_remove(fsc->debugfs_mdsc);
 }
=20
@@ -402,6 +452,13 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc=
)
 					    fsc,
 					    &sending_metrics_fops);
=20
+	fsc->debugfs_reset_metrics =3D
+			debugfs_create_file("reset_metrics",
+					    0600,
+					    fsc->client->debugfs_dir,
+					    fsc,
+					    &reset_metrics_fops);
+
 	fsc->debugfs_metric =3D debugfs_create_file("metrics",
 						  0400,
 						  fsc->client->debugfs_dir,
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index d30c60ecfedb..3d6f64c62e01 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -129,6 +129,7 @@ struct ceph_fs_client {
 	struct dentry *debugfs_bdi;
 	struct dentry *debugfs_mdsc, *debugfs_mdsmap;
 	struct dentry *debugfs_sending_metrics;
+	struct dentry *debugfs_reset_metrics;
 	struct dentry *debugfs_metric;
 	struct dentry *debugfs_mds_sessions;
 #endif
--=20
2.21.0


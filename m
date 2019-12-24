Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C860D129D37
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Dec 2019 05:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfLXEFq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Dec 2019 23:05:46 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43356 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726747AbfLXEFq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Dec 2019 23:05:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577160344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x/4wmeMUX8q5zvdacEsm6lixhzvKw+ZQRDwYhgkBqmg=;
        b=DMfPnSp9julzUaUroTuKMABlyqCVNIP9DEvOL8wDZsinYYBAVMejlPxlkGU6dTSK4k6z+B
        lEUL/Qt9ubiss+HNV6q3HSKVDPXVztWWo5BLC71TF4/CFk/7JZ3fDAQirAGoghMyPgYVtx
        nY4newIK5zBw2Uz0Vp+BCGL3wbY1wO0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-4gqGbh5kM3i5FwHNh4Kr2Q-1; Mon, 23 Dec 2019 23:05:39 -0500
X-MC-Unique: 4gqGbh5kM3i5FwHNh4Kr2Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE6A5184B44C;
        Tue, 24 Dec 2019 04:05:37 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-64.pek2.redhat.com [10.72.12.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B7911081331;
        Tue, 24 Dec 2019 04:05:34 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 4/4] ceph: add enable/disable sending metrics to MDS debugfs support
Date:   Mon, 23 Dec 2019 23:05:14 -0500
Message-Id: <20191224040514.26144-5-xiubli@redhat.com>
In-Reply-To: <20191224040514.26144-1-xiubli@redhat.com>
References: <20191224040514.26144-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Disabled as default, if it's enabled the kclient will send metrics
every second.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/debugfs.c    | 44 ++++++++++++++++++++++++++++++--
 fs/ceph/mds_client.c | 60 +++++++++++++++++++++++++++++++-------------
 fs/ceph/mds_client.h |  3 +++
 fs/ceph/super.h      |  1 +
 4 files changed, 89 insertions(+), 19 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index c132fdb40d53..a26e559473fd 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -124,6 +124,40 @@ static int mdsc_show(struct seq_file *s, void *p)
 	return 0;
 }
=20
+/*
+ * metrics debugfs
+ */
+static int sending_metrics_set(void *data, u64 val)
+{
+	struct ceph_fs_client *fsc =3D (struct ceph_fs_client *)data;
+	struct ceph_mds_client *mdsc =3D fsc->mdsc;
+
+	if (val > 1) {
+		pr_err("Invalid sending metrics set value %llu\n", val);
+		return -EINVAL;
+	}
+
+	mutex_lock(&mdsc->mutex);
+	mdsc->sending_metrics =3D (unsigned int)val;
+	mutex_unlock(&mdsc->mutex);
+
+	return 0;
+}
+
+static int sending_metrics_get(void *data, u64 *val)
+{
+	struct ceph_fs_client *fsc =3D (struct ceph_fs_client *)data;
+	struct ceph_mds_client *mdsc =3D fsc->mdsc;
+
+	mutex_lock(&mdsc->mutex);
+	*val =3D (u64)mdsc->sending_metrics;
+	mutex_unlock(&mdsc->mutex);
+
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(sending_metrics_fops, sending_metrics_get,
+			 sending_metrics_set, "%llu\n");
+
 static int metric_show(struct seq_file *s, void *p)
 {
 	struct ceph_fs_client *fsc =3D s->private;
@@ -279,11 +313,9 @@ static int congestion_kb_get(void *data, u64 *val)
 	*val =3D (u64)fsc->mount_options->congestion_kb;
 	return 0;
 }
-
 DEFINE_SIMPLE_ATTRIBUTE(congestion_kb_fops, congestion_kb_get,
 			congestion_kb_set, "%llu\n");
=20
-
 void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
 {
 	dout("ceph_fs_debugfs_cleanup\n");
@@ -293,6 +325,7 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *f=
sc)
 	debugfs_remove(fsc->debugfs_mds_sessions);
 	debugfs_remove(fsc->debugfs_caps);
 	debugfs_remove(fsc->debugfs_metric);
+	debugfs_remove(fsc->debugfs_sending_metrics);
 	debugfs_remove(fsc->debugfs_mdsc);
 }
=20
@@ -333,6 +366,13 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc=
)
 						fsc,
 						&mdsc_show_fops);
=20
+	fsc->debugfs_sending_metrics =3D
+			debugfs_create_file_unsafe("sending_metrics",
+						   0600,
+						   fsc->client->debugfs_dir,
+						   fsc,
+						   &sending_metrics_fops);
+
 	fsc->debugfs_metric =3D debugfs_create_file("metrics",
 						  0400,
 						  fsc->client->debugfs_dir,
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 5b74202ed68f..d31612bdc1e3 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4162,10 +4162,18 @@ static bool ceph_mdsc_send_metrics(struct ceph_md=
s_client *mdsc,
 /*
  * delayed work -- periodically trim expired leases, renew caps with mds
  */
+#define CEPH_WORK_DELAY_DEF 5
 static void schedule_delayed(struct ceph_mds_client *mdsc)
 {
-	int delay =3D 5;
-	unsigned hz =3D round_jiffies_relative(HZ * delay);
+	unsigned int hz;
+	int delay =3D CEPH_WORK_DELAY_DEF;
+
+	mutex_lock(&mdsc->mutex);
+	if (mdsc->sending_metrics)
+		delay =3D 1;
+	mutex_unlock(&mdsc->mutex);
+
+	hz =3D round_jiffies_relative(HZ * delay);
 	schedule_delayed_work(&mdsc->delayed_work, hz);
 }
=20
@@ -4176,15 +4184,23 @@ static void delayed_work(struct work_struct *work=
)
 		container_of(work, struct ceph_mds_client, delayed_work.work);
 	int renew_interval;
 	int renew_caps;
+	bool metric_only;
+	bool sending_metrics;
=20
 	dout("mdsc delayed_work\n");
=20
 	mutex_lock(&mdsc->mutex);
-	renew_interval =3D mdsc->mdsmap->m_session_timeout >> 2;
-	renew_caps =3D time_after_eq(jiffies, HZ*renew_interval +
-				   mdsc->last_renew_caps);
-	if (renew_caps)
-		mdsc->last_renew_caps =3D jiffies;
+	sending_metrics =3D !!mdsc->sending_metrics;
+	metric_only =3D mdsc->sending_metrics &&
+		(mdsc->ticks++ % CEPH_WORK_DELAY_DEF);
+
+	if (!metric_only) {
+		renew_interval =3D mdsc->mdsmap->m_session_timeout >> 2;
+		renew_caps =3D time_after_eq(jiffies, HZ*renew_interval +
+					   mdsc->last_renew_caps);
+		if (renew_caps)
+			mdsc->last_renew_caps =3D jiffies;
+	}
=20
 	for (i =3D 0; i < mdsc->max_sessions; i++) {
 		struct ceph_mds_session *s =3D __ceph_lookup_mds_session(mdsc, i);
@@ -4216,15 +4232,18 @@ static void delayed_work(struct work_struct *work=
)
=20
 		mutex_lock(&s->s_mutex);
=20
-		g_skip =3D ceph_mdsc_send_metrics(mdsc, s, g_skip);
+		if (sending_metrics)
+			g_skip =3D ceph_mdsc_send_metrics(mdsc, s, g_skip);
=20
-		if (renew_caps)
-			send_renew_caps(mdsc, s);
-		else
-			ceph_con_keepalive(&s->s_con);
-		if (s->s_state =3D=3D CEPH_MDS_SESSION_OPEN ||
-		    s->s_state =3D=3D CEPH_MDS_SESSION_HUNG)
-			ceph_send_cap_releases(mdsc, s);
+		if (!metric_only) {
+			if (renew_caps)
+				send_renew_caps(mdsc, s);
+			else
+				ceph_con_keepalive(&s->s_con);
+			if (s->s_state =3D=3D CEPH_MDS_SESSION_OPEN ||
+					s->s_state =3D=3D CEPH_MDS_SESSION_HUNG)
+				ceph_send_cap_releases(mdsc, s);
+		}
=20
 		mutex_unlock(&s->s_mutex);
 		ceph_put_mds_session(s);
@@ -4233,6 +4252,9 @@ static void delayed_work(struct work_struct *work)
 	}
 	mutex_unlock(&mdsc->mutex);
=20
+	if (metric_only)
+		goto delay_work;
+
 	ceph_check_delayed_caps(mdsc);
=20
 	ceph_queue_cap_reclaim_work(mdsc);
@@ -4241,11 +4263,13 @@ static void delayed_work(struct work_struct *work=
)
=20
 	maybe_recover_session(mdsc);
=20
+delay_work:
 	schedule_delayed(mdsc);
 }
=20
-static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
+static int ceph_mdsc_metric_init(struct ceph_mds_client *mdsc)
 {
+	struct ceph_client_metric *metric =3D &mdsc->metric;
 	int ret;
=20
 	if (!metric)
@@ -4259,6 +4283,8 @@ static int ceph_mdsc_metric_init(struct ceph_client=
_metric *metric)
 		goto err;
=20
 	atomic64_set(&metric->total_dentries, 0);
+	mdsc->sending_metrics =3D 0;
+	mdsc->ticks =3D 0;
 	return 0;
=20
 err:
@@ -4319,7 +4345,7 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	init_waitqueue_head(&mdsc->cap_flushing_wq);
 	INIT_WORK(&mdsc->cap_reclaim_work, ceph_cap_reclaim_work);
 	atomic_set(&mdsc->cap_reclaim_pending, 0);
-	err =3D ceph_mdsc_metric_init(&mdsc->metric);
+	err =3D ceph_mdsc_metric_init(mdsc);
 	if (err)
 		goto err_mdsmap;
=20
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 6b91f20132c0..c926256fc76b 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -447,6 +447,9 @@ struct ceph_mds_client {
 	struct list_head  dentry_leases;     /* fifo list */
 	struct list_head  dentry_dir_leases; /* lru list */
=20
+	/* metrics */
+	unsigned int		  sending_metrics;
+	unsigned int		  ticks;
 	struct ceph_client_metric metric;
=20
 	spinlock_t		snapid_map_lock;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 88da9e21af75..9d2a5f1ce418 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -123,6 +123,7 @@ struct ceph_fs_client {
 	struct dentry *debugfs_congestion_kb;
 	struct dentry *debugfs_bdi;
 	struct dentry *debugfs_mdsc, *debugfs_mdsmap;
+	struct dentry *debugfs_sending_metrics;
 	struct dentry *debugfs_metric;
 	struct dentry *debugfs_mds_sessions;
 #endif
--=20
2.21.0


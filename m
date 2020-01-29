Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3CD414C780
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Jan 2020 09:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgA2I2Z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Jan 2020 03:28:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58127 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726314AbgA2I2Z (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 Jan 2020 03:28:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580286504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qT0u0w/rIGkT+szIUYmmBy4V5W+EnHMTgs0zakAMYac=;
        b=SebsW0vYdOytLmVZ9Os52TLbpOvblux8NTJmNLhy9GX8C8Sd5qY2DKeMrIBZpw3iI80YRS
        gn7y6iMje5sBKJQUk/cZTAqR7wJByiDYqGN+KwIld19C41V+RaHS52i9OoQPoOOIj7jOQ0
        fwJxEdUNaBEWfqnZVow+JFdE3R+CQZY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-EOUcL1dYMISF_sHwKfCtvw-1; Wed, 29 Jan 2020 03:28:22 -0500
X-MC-Unique: EOUcL1dYMISF_sHwKfCtvw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6093118C43C4;
        Wed, 29 Jan 2020 08:28:21 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9A615C3F8;
        Wed, 29 Jan 2020 08:28:16 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH resend v5 10/11] ceph: add reset metrics support
Date:   Wed, 29 Jan 2020 03:27:14 -0500
Message-Id: <20200129082715.5285-11-xiubli@redhat.com>
In-Reply-To: <20200129082715.5285-1-xiubli@redhat.com>
References: <20200129082715.5285-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
 fs/ceph/debugfs.c | 53 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/ceph/super.h   |  1 +
 2 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 8aae7ecea54a..37ca1efa6b27 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -217,6 +217,55 @@ static int metric_show(struct seq_file *s, void *p)
 	return 0;
 }
=20
+static ssize_t metric_store(struct file *file, const char __user *user_b=
uf,
+			    size_t count, loff_t *ppos)
+{
+	struct seq_file *s =3D file->private_data;
+	struct ceph_fs_client *fsc =3D s->private;
+	struct ceph_mds_client *mdsc =3D fsc->mdsc;
+	struct ceph_client_metric *metric =3D &mdsc->metric;
+	char buf[8];
+	int i;
+
+	if (copy_from_user(buf, user_buf, 8))
+		return -EFAULT;
+
+	if (strcmp(buf, "reset")) {
+		pr_err("Invalid set value '%s', only 'reset' is valid\n", buf);
+		return -EINVAL;
+	}
+
+	percpu_counter_set(&metric->d_lease_hit, 0);
+	percpu_counter_set(&metric->d_lease_mis, 0);
+
+	percpu_counter_set(&metric->read_latency_sum, 0);
+	percpu_counter_set(&metric->total_reads, 0);
+
+	percpu_counter_set(&metric->write_latency_sum, 0);
+	percpu_counter_set(&metric->total_writes, 0);
+
+	percpu_counter_set(&metric->metadata_latency_sum, 0);
+	percpu_counter_set(&metric->total_metadatas, 0);
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
+CEPH_DEFINE_RW_FUNC(metric)
+
 static int caps_show_cb(struct inode *inode, struct ceph_cap *cap, void =
*p)
 {
 	struct seq_file *s =3D p;
@@ -313,7 +362,6 @@ static int mds_sessions_show(struct seq_file *s, void=
 *ptr)
=20
 CEPH_DEFINE_SHOW_FUNC(mdsmap_show)
 CEPH_DEFINE_SHOW_FUNC(mdsc_show)
-CEPH_DEFINE_SHOW_FUNC(metric_show)
 CEPH_DEFINE_SHOW_FUNC(caps_show)
 CEPH_DEFINE_SHOW_FUNC(mds_sessions_show)
=20
@@ -349,6 +397,7 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *f=
sc)
 	debugfs_remove(fsc->debugfs_caps);
 	debugfs_remove(fsc->debugfs_metric);
 	debugfs_remove(fsc->debugfs_sending_metrics);
+	debugfs_remove(fsc->debugfs_reset_metrics);
 	debugfs_remove(fsc->debugfs_mdsc);
 }
=20
@@ -400,7 +449,7 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 						  0400,
 						  fsc->client->debugfs_dir,
 						  fsc,
-						  &metric_show_fops);
+						  &metric_fops);
=20
 	fsc->debugfs_caps =3D debugfs_create_file("caps",
 						0400,
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index a91431e9bdf7..d24929f1c4bf 100644
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


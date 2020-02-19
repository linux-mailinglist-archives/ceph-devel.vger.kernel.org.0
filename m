Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1EB2163B6E
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 04:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgBSDkF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Feb 2020 22:40:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53420 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726403AbgBSDkF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Feb 2020 22:40:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582083603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h99A+kyn3626Zby0qGOLCcHNxS9Zim//VIxkE/lqlCk=;
        b=d7VOsKdvL0PvWQpO2NG+Oa2g6K7hSE9eX/jtZL3SXtAsrTgtkWu5fORw+BPUJxHAET0FT3
        RmL61P47W6GWUeyg8FRvckGqwLwj4rug03GZ93/B2WGgG8b4tpgmR3TFGHM1tkz2YOrMzJ
        OdqNEXwV5NHMlYGOEdcuPAnULvR/bFI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-LZUeNhQ3PLOGr3mYw4KsjA-1; Tue, 18 Feb 2020 22:39:56 -0500
X-MC-Unique: LZUeNhQ3PLOGr3mYw4KsjA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4EAF801E5C;
        Wed, 19 Feb 2020 03:39:55 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D39E560C81;
        Wed, 19 Feb 2020 03:39:52 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v7 1/5] ceph: add global dentry lease metric support
Date:   Tue, 18 Feb 2020 22:38:47 -0500
Message-Id: <20200219033851.6548-2-xiubli@redhat.com>
In-Reply-To: <20200219033851.6548-1-xiubli@redhat.com>
References: <20200219033851.6548-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

For the dentry lease we will only count the hit/miss info triggered
from the vfs calls, for the cases like request reply handling and
perodically ceph_trim_dentries() we will ignore them.

Currently only the debugfs is support:

The output will be:

item          total           miss            hit
-------------------------------------------------
d_lease       11              7               141

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/debugfs.c    | 32 ++++++++++++++++++++++++++++----
 fs/ceph/dir.c        | 16 ++++++++++++++--
 fs/ceph/mds_client.c | 37 +++++++++++++++++++++++++++++++++++--
 fs/ceph/mds_client.h |  4 ++++
 fs/ceph/metric.h     | 11 +++++++++++
 fs/ceph/super.h      |  1 +
 6 files changed, 93 insertions(+), 8 deletions(-)
 create mode 100644 fs/ceph/metric.h

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 481ac97b4d25..15975ba95d9a 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -124,6 +124,22 @@ static int mdsc_show(struct seq_file *s, void *p)
 	return 0;
 }
=20
+static int metric_show(struct seq_file *s, void *p)
+{
+	struct ceph_fs_client *fsc =3D s->private;
+	struct ceph_mds_client *mdsc =3D fsc->mdsc;
+
+	seq_printf(s, "item          total           miss            hit\n");
+	seq_printf(s, "-------------------------------------------------\n");
+
+	seq_printf(s, "%-14s%-16lld%-16lld%lld\n", "d_lease",
+		   atomic64_read(&mdsc->metric.total_dentries),
+		   percpu_counter_sum(&mdsc->metric.d_lease_mis),
+		   percpu_counter_sum(&mdsc->metric.d_lease_hit));
+
+	return 0;
+}
+
 static int caps_show_cb(struct inode *inode, struct ceph_cap *cap, void =
*p)
 {
 	struct seq_file *s =3D p;
@@ -222,6 +238,7 @@ DEFINE_SHOW_ATTRIBUTE(mdsmap);
 DEFINE_SHOW_ATTRIBUTE(mdsc);
 DEFINE_SHOW_ATTRIBUTE(caps);
 DEFINE_SHOW_ATTRIBUTE(mds_sessions);
+DEFINE_SHOW_ATTRIBUTE(metric);
=20
=20
 /*
@@ -255,6 +272,7 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *f=
sc)
 	debugfs_remove(fsc->debugfs_mdsmap);
 	debugfs_remove(fsc->debugfs_mds_sessions);
 	debugfs_remove(fsc->debugfs_caps);
+	debugfs_remove(fsc->debugfs_metric);
 	debugfs_remove(fsc->debugfs_mdsc);
 }
=20
@@ -295,11 +313,17 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fs=
c)
 						fsc,
 						&mdsc_fops);
=20
+	fsc->debugfs_metric =3D debugfs_create_file("metrics",
+						  0400,
+						  fsc->client->debugfs_dir,
+						  fsc,
+						  &metric_fops);
+
 	fsc->debugfs_caps =3D debugfs_create_file("caps",
-						   0400,
-						   fsc->client->debugfs_dir,
-						   fsc,
-						   &caps_fops);
+						0400,
+						fsc->client->debugfs_dir,
+						fsc,
+						&caps_fops);
 }
=20
=20
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 80bd3be4715a..f2a477fdfffb 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -38,6 +38,8 @@ static int __dir_lease_try_check(const struct dentry *d=
entry);
 static int ceph_d_init(struct dentry *dentry)
 {
 	struct ceph_dentry_info *di;
+	struct ceph_fs_client *fsc =3D ceph_sb_to_client(dentry->d_sb);
+	struct ceph_mds_client *mdsc =3D fsc->mdsc;
=20
 	di =3D kmem_cache_zalloc(ceph_dentry_cachep, GFP_KERNEL);
 	if (!di)
@@ -48,6 +50,9 @@ static int ceph_d_init(struct dentry *dentry)
 	di->time =3D jiffies;
 	dentry->d_fsdata =3D di;
 	INIT_LIST_HEAD(&di->lease_list);
+
+	atomic64_inc(&mdsc->metric.total_dentries);
+
 	return 0;
 }
=20
@@ -1551,6 +1556,7 @@ static int dir_lease_is_valid(struct inode *dir, st=
ruct dentry *dentry)
  */
 static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
 {
+	struct ceph_mds_client *mdsc;
 	int valid =3D 0;
 	struct dentry *parent;
 	struct inode *dir, *inode;
@@ -1589,9 +1595,8 @@ static int ceph_d_revalidate(struct dentry *dentry,=
 unsigned int flags)
 		}
 	}
=20
+	mdsc =3D ceph_sb_to_client(dir->i_sb)->mdsc;
 	if (!valid) {
-		struct ceph_mds_client *mdsc =3D
-			ceph_sb_to_client(dir->i_sb)->mdsc;
 		struct ceph_mds_request *req;
 		int op, err;
 		u32 mask;
@@ -1599,6 +1604,8 @@ static int ceph_d_revalidate(struct dentry *dentry,=
 unsigned int flags)
 		if (flags & LOOKUP_RCU)
 			return -ECHILD;
=20
+		percpu_counter_inc(&mdsc->metric.d_lease_mis);
+
 		op =3D ceph_snap(dir) =3D=3D CEPH_SNAPDIR ?
 			CEPH_MDS_OP_LOOKUPSNAP : CEPH_MDS_OP_LOOKUP;
 		req =3D ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
@@ -1630,6 +1637,8 @@ static int ceph_d_revalidate(struct dentry *dentry,=
 unsigned int flags)
 			dout("d_revalidate %p lookup result=3D%d\n",
 			     dentry, err);
 		}
+	} else {
+		percpu_counter_inc(&mdsc->metric.d_lease_hit);
 	}
=20
 	dout("d_revalidate %p %s\n", dentry, valid ? "valid" : "invalid");
@@ -1672,9 +1681,12 @@ static int ceph_d_delete(const struct dentry *dent=
ry)
 static void ceph_d_release(struct dentry *dentry)
 {
 	struct ceph_dentry_info *di =3D ceph_dentry(dentry);
+	struct ceph_fs_client *fsc =3D ceph_sb_to_client(dentry->d_sb);
=20
 	dout("d_release %p\n", dentry);
=20
+	atomic64_dec(&fsc->mdsc->metric.total_dentries);
+
 	spin_lock(&dentry->d_lock);
 	__dentry_lease_unlist(di);
 	dentry->d_fsdata =3D NULL;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 46fd5c77a6e4..511b6c0a738d 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4160,10 +4160,31 @@ static void delayed_work(struct work_struct *work=
)
 	schedule_delayed(mdsc);
 }
=20
+static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
+{
+	int ret;
+
+	if (!metric)
+		return -EINVAL;
+
+	atomic64_set(&metric->total_dentries, 0);
+	ret =3D percpu_counter_init(&metric->d_lease_hit, 0, GFP_KERNEL);
+	if (ret)
+		return ret;
+	ret =3D percpu_counter_init(&metric->d_lease_mis, 0, GFP_KERNEL);
+	if (ret) {
+		percpu_counter_destroy(&metric->d_lease_hit);
+		return ret;
+	}
+
+	return 0;
+}
+
 int ceph_mdsc_init(struct ceph_fs_client *fsc)
=20
 {
 	struct ceph_mds_client *mdsc;
+	int err;
=20
 	mdsc =3D kzalloc(sizeof(struct ceph_mds_client), GFP_NOFS);
 	if (!mdsc)
@@ -4172,8 +4193,8 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	mutex_init(&mdsc->mutex);
 	mdsc->mdsmap =3D kzalloc(sizeof(*mdsc->mdsmap), GFP_NOFS);
 	if (!mdsc->mdsmap) {
-		kfree(mdsc);
-		return -ENOMEM;
+		err =3D -ENOMEM;
+		goto err_mdsc;
 	}
=20
 	fsc->mdsc =3D mdsc;
@@ -4212,6 +4233,9 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	init_waitqueue_head(&mdsc->cap_flushing_wq);
 	INIT_WORK(&mdsc->cap_reclaim_work, ceph_cap_reclaim_work);
 	atomic_set(&mdsc->cap_reclaim_pending, 0);
+	err =3D ceph_mdsc_metric_init(&mdsc->metric);
+	if (err)
+		goto err_mdsmap;
=20
 	spin_lock_init(&mdsc->dentry_list_lock);
 	INIT_LIST_HEAD(&mdsc->dentry_leases);
@@ -4230,6 +4254,12 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	strscpy(mdsc->nodename, utsname()->nodename,
 		sizeof(mdsc->nodename));
 	return 0;
+
+err_mdsmap:
+	kfree(mdsc->mdsmap);
+err_mdsc:
+	kfree(mdsc);
+	return err;
 }
=20
 /*
@@ -4487,6 +4517,9 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
=20
 	ceph_mdsc_stop(mdsc);
=20
+	percpu_counter_destroy(&mdsc->metric.d_lease_mis);
+	percpu_counter_destroy(&mdsc->metric.d_lease_hit);
+
 	fsc->mdsc =3D NULL;
 	kfree(mdsc);
 	dout("mdsc_destroy %p done\n", mdsc);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 27a7446e10d3..674fc7725913 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -16,6 +16,8 @@
 #include <linux/ceph/mdsmap.h>
 #include <linux/ceph/auth.h>
=20
+#include "metric.h"
+
 /* The first 8 bits are reserved for old ceph releases */
 enum ceph_feature_type {
 	CEPHFS_FEATURE_MIMIC =3D 8,
@@ -446,6 +448,8 @@ struct ceph_mds_client {
 	struct list_head  dentry_leases;     /* fifo list */
 	struct list_head  dentry_dir_leases; /* lru list */
=20
+	struct ceph_client_metric metric;
+
 	spinlock_t		snapid_map_lock;
 	struct rb_root		snapid_map_tree;
 	struct list_head	snapid_map_lru;
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
new file mode 100644
index 000000000000..998fe2a643cf
--- /dev/null
+++ b/fs/ceph/metric.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _FS_CEPH_MDS_METRIC_H
+#define _FS_CEPH_MDS_METRIC_H
+
+/* This is the global metrics */
+struct ceph_client_metric {
+	atomic64_t            total_dentries;
+	struct percpu_counter d_lease_hit;
+	struct percpu_counter d_lease_mis;
+};
+#endif /* _FS_CEPH_MDS_METRIC_H */
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 37dc1ac8f6c3..ebcf7612eac9 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -125,6 +125,7 @@ struct ceph_fs_client {
 	struct dentry *debugfs_congestion_kb;
 	struct dentry *debugfs_bdi;
 	struct dentry *debugfs_mdsc, *debugfs_mdsmap;
+	struct dentry *debugfs_metric;
 	struct dentry *debugfs_mds_sessions;
 #endif
=20
--=20
2.21.0


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C96B129D34
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Dec 2019 05:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfLXEFd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Dec 2019 23:05:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54747 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726747AbfLXEFd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 23 Dec 2019 23:05:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577160331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0E7kWaQVA4ZcQxO8byvdRefn8POI7zlJJR2ZiVAdkRI=;
        b=asaR/rgJ430nBuieTEwnN3tUOz4vBVCAjho2tRVuHv4Ni3C51vOqDdfn4wmGOAZLa2Y4S9
        Au58t6e5S1Z3XM1JoRz+5E4WTKgIDEZbTM4nH/XCdHC3YwnbyARgNiAsD/m6WqvS8FYNHi
        0iOn+FH/KZOhnxtlJ1P9dEV7RX2r5O4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-Sa7vOOinNXy7z08ZMs1wsw-1; Mon, 23 Dec 2019 23:05:29 -0500
X-MC-Unique: Sa7vOOinNXy7z08ZMs1wsw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17624184B44C;
        Tue, 24 Dec 2019 04:05:28 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-64.pek2.redhat.com [10.72.12.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 661811000322;
        Tue, 24 Dec 2019 04:05:25 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/4] ceph: add global dentry lease metric support
Date:   Mon, 23 Dec 2019 23:05:11 -0500
Message-Id: <20191224040514.26144-2-xiubli@redhat.com>
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

For the dentry lease we will only count the hit/miss info triggered
from the vfs calls, for the cases like request reply handling and
perodically ceph_trim_dentries() we will ignore them.

Currently only the debugfs is support:

The output will be:

item          total           miss            hit
-------------------------------------------------
d_lease       11              7               141

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/debugfs.c    | 32 ++++++++++++++++++++++++++++----
 fs/ceph/dir.c        | 18 ++++++++++++++++--
 fs/ceph/mds_client.c | 39 +++++++++++++++++++++++++++++++++++++--
 fs/ceph/mds_client.h |  9 +++++++++
 fs/ceph/super.h      |  1 +
 5 files changed, 91 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index fb7cabd98e7b..40a22da0214a 100644
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
@@ -220,6 +236,7 @@ static int mds_sessions_show(struct seq_file *s, void=
 *ptr)
=20
 CEPH_DEFINE_SHOW_FUNC(mdsmap_show)
 CEPH_DEFINE_SHOW_FUNC(mdsc_show)
+CEPH_DEFINE_SHOW_FUNC(metric_show)
 CEPH_DEFINE_SHOW_FUNC(caps_show)
 CEPH_DEFINE_SHOW_FUNC(mds_sessions_show)
=20
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
 						&mdsc_show_fops);
=20
+	fsc->debugfs_metric =3D debugfs_create_file("metrics",
+						  0400,
+						  fsc->client->debugfs_dir,
+						  fsc,
+						  &metric_show_fops);
+
 	fsc->debugfs_caps =3D debugfs_create_file("caps",
-						   0400,
-						   fsc->client->debugfs_dir,
-						   fsc,
-						   &caps_show_fops);
+						0400,
+						fsc->client->debugfs_dir,
+						fsc,
+						&caps_show_fops);
 }
=20
=20
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index d0cd0aba5843..382beb04bacb 100644
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
@@ -1589,13 +1595,14 @@ static int ceph_d_revalidate(struct dentry *dentr=
y, unsigned int flags)
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
=20
+		percpu_counter_inc(&mdsc->metric.d_lease_mis);
+
 		if (flags & LOOKUP_RCU)
 			return -ECHILD;
=20
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
@@ -1638,6 +1647,7 @@ static int ceph_d_revalidate(struct dentry *dentry,=
 unsigned int flags)
=20
 	if (!(flags & LOOKUP_RCU))
 		dput(parent);
+
 	return valid;
 }
=20
@@ -1672,9 +1682,13 @@ static int ceph_d_delete(const struct dentry *dent=
ry)
 static void ceph_d_release(struct dentry *dentry)
 {
 	struct ceph_dentry_info *di =3D ceph_dentry(dentry);
+	struct ceph_fs_client *fsc =3D ceph_sb_to_client(dentry->d_sb);
+	struct ceph_mds_client *mdsc =3D fsc->mdsc;
=20
 	dout("d_release %p\n", dentry);
=20
+	atomic64_dec(&mdsc->metric.total_dentries);
+
 	spin_lock(&dentry->d_lock);
 	__dentry_lease_unlist(di);
 	dentry->d_fsdata =3D NULL;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d6c3d8d854e0..b1b4d1a9bd2f 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4151,10 +4151,33 @@ static void delayed_work(struct work_struct *work=
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
+	ret =3D percpu_counter_init(&metric->d_lease_hit, 0, GFP_KERNEL);
+	if (ret)
+		goto err;
+	ret =3D percpu_counter_init(&metric->d_lease_mis, 0, GFP_KERNEL);
+	if (ret)
+		goto err;
+
+	atomic64_set(&metric->total_dentries, 0);
+	return 0;
+
+err:
+	percpu_counter_destroy(&metric->d_lease_hit);
+	return ret;
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
@@ -4163,8 +4186,8 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
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
@@ -4203,6 +4226,9 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	init_waitqueue_head(&mdsc->cap_flushing_wq);
 	INIT_WORK(&mdsc->cap_reclaim_work, ceph_cap_reclaim_work);
 	atomic_set(&mdsc->cap_reclaim_pending, 0);
+	err =3D ceph_mdsc_metric_init(&mdsc->metric);
+	if (err)
+		goto err_mdsmap;
=20
 	spin_lock_init(&mdsc->dentry_list_lock);
 	INIT_LIST_HEAD(&mdsc->dentry_leases);
@@ -4221,6 +4247,12 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
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
@@ -4478,6 +4510,9 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
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
index c021df5f50ce..55249f667a98 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -349,6 +349,13 @@ struct cap_wait {
 	int			want;
 };
=20
+/* This is the global metrics */
+struct ceph_client_metric {
+	struct percpu_counter	d_lease_hit;
+	struct percpu_counter	d_lease_mis;
+	atomic64_t		total_dentries;
+};
+
 /*
  * mds client state
  */
@@ -437,6 +444,8 @@ struct ceph_mds_client {
 	struct list_head  dentry_leases;     /* fifo list */
 	struct list_head  dentry_dir_leases; /* lru list */
=20
+	struct ceph_client_metric metric;
+
 	spinlock_t		snapid_map_lock;
 	struct rb_root		snapid_map_tree;
 	struct list_head	snapid_map_lru;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 3bf1a01cd536..40703588b889 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -123,6 +123,7 @@ struct ceph_fs_client {
 	struct dentry *debugfs_congestion_kb;
 	struct dentry *debugfs_bdi;
 	struct dentry *debugfs_mdsc, *debugfs_mdsmap;
+	struct dentry *debugfs_metric;
 	struct dentry *debugfs_mds_sessions;
 #endif
=20
--=20
2.21.0


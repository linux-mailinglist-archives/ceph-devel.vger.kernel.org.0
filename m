Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1AD17D9ED
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Mar 2020 08:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgCIHh2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Mar 2020 03:37:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59990 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725796AbgCIHh2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Mar 2020 03:37:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583739446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=XaQPsO3W7Z/WWJbPiqPGLlGHBi+zmP3DQn6+ecj7cpI=;
        b=FycXV6UgzDmlBnsvchhVlbZYs/bN2xmO1lWePU8pySPvMFpuZlLxPEP6hOBBRu+GO73HlG
        Qb/8hLuAX9XFjFQa1RRrz/kCt8C2aeZMG3scRVgci6T6zyTtg1Sldd21vPIVu2QK+UQ4qL
        BckaNPYFG2XypzVo803QVGBFlNgCPrw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-K50Ws6LdPkuY0RDcRGdjvw-1; Mon, 09 Mar 2020 03:37:22 -0400
X-MC-Unique: K50Ws6LdPkuY0RDcRGdjvw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C16D8100550D;
        Mon,  9 Mar 2020 07:37:21 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4DD8E5C10C;
        Mon,  9 Mar 2020 07:37:19 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v9 1/5] ceph: add global dentry lease metric support
Date:   Mon,  9 Mar 2020 03:37:06 -0400
Message-Id: <1583739430-4928-2-git-send-email-xiubli@redhat.com>
In-Reply-To: <1583739430-4928-1-git-send-email-xiubli@redhat.com>
References: <1583739430-4928-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
 fs/ceph/dir.c        | 12 ++++++++++++
 fs/ceph/mds_client.c | 37 +++++++++++++++++++++++++++++++++++--
 fs/ceph/mds_client.h |  4 ++++
 fs/ceph/metric.h     | 11 +++++++++++
 fs/ceph/super.h      |  1 +
 6 files changed, 91 insertions(+), 6 deletions(-)
 create mode 100644 fs/ceph/metric.h

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 481ac97..15975ba 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -124,6 +124,22 @@ static int mdsc_show(struct seq_file *s, void *p)
 	return 0;
 }
 
+static int metric_show(struct seq_file *s, void *p)
+{
+	struct ceph_fs_client *fsc = s->private;
+	struct ceph_mds_client *mdsc = fsc->mdsc;
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
 static int caps_show_cb(struct inode *inode, struct ceph_cap *cap, void *p)
 {
 	struct seq_file *s = p;
@@ -222,6 +238,7 @@ static int mds_sessions_show(struct seq_file *s, void *ptr)
 DEFINE_SHOW_ATTRIBUTE(mdsc);
 DEFINE_SHOW_ATTRIBUTE(caps);
 DEFINE_SHOW_ATTRIBUTE(mds_sessions);
+DEFINE_SHOW_ATTRIBUTE(metric);
 
 
 /*
@@ -255,6 +272,7 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
 	debugfs_remove(fsc->debugfs_mdsmap);
 	debugfs_remove(fsc->debugfs_mds_sessions);
 	debugfs_remove(fsc->debugfs_caps);
+	debugfs_remove(fsc->debugfs_metric);
 	debugfs_remove(fsc->debugfs_mdsc);
 }
 
@@ -295,11 +313,17 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 						fsc,
 						&mdsc_fops);
 
+	fsc->debugfs_metric = debugfs_create_file("metrics",
+						  0400,
+						  fsc->client->debugfs_dir,
+						  fsc,
+						  &metric_fops);
+
 	fsc->debugfs_caps = debugfs_create_file("caps",
-						   0400,
-						   fsc->client->debugfs_dir,
-						   fsc,
-						   &caps_fops);
+						0400,
+						fsc->client->debugfs_dir,
+						fsc,
+						&caps_fops);
 }
 
 
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index d594c26..8097a86 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -38,6 +38,8 @@
 static int ceph_d_init(struct dentry *dentry)
 {
 	struct ceph_dentry_info *di;
+	struct ceph_fs_client *fsc = ceph_sb_to_client(dentry->d_sb);
+	struct ceph_mds_client *mdsc = fsc->mdsc;
 
 	di = kmem_cache_zalloc(ceph_dentry_cachep, GFP_KERNEL);
 	if (!di)
@@ -48,6 +50,9 @@ static int ceph_d_init(struct dentry *dentry)
 	di->time = jiffies;
 	dentry->d_fsdata = di;
 	INIT_LIST_HEAD(&di->lease_list);
+
+	atomic64_inc(&mdsc->metric.total_dentries);
+
 	return 0;
 }
 
@@ -1709,6 +1714,8 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
 		if (flags & LOOKUP_RCU)
 			return -ECHILD;
 
+		percpu_counter_inc(&mdsc->metric.d_lease_mis);
+
 		op = ceph_snap(dir) == CEPH_SNAPDIR ?
 			CEPH_MDS_OP_LOOKUPSNAP : CEPH_MDS_OP_LOOKUP;
 		req = ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
@@ -1740,6 +1747,8 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
 			dout("d_revalidate %p lookup result=%d\n",
 			     dentry, err);
 		}
+	} else {
+		percpu_counter_inc(&mdsc->metric.d_lease_hit);
 	}
 
 	dout("d_revalidate %p %s\n", dentry, valid ? "valid" : "invalid");
@@ -1782,9 +1791,12 @@ static int ceph_d_delete(const struct dentry *dentry)
 static void ceph_d_release(struct dentry *dentry)
 {
 	struct ceph_dentry_info *di = ceph_dentry(dentry);
+	struct ceph_fs_client *fsc = ceph_sb_to_client(dentry->d_sb);
 
 	dout("d_release %p\n", dentry);
 
+	atomic64_dec(&fsc->mdsc->metric.total_dentries);
+
 	spin_lock(&dentry->d_lock);
 	__dentry_lease_unlist(di);
 	dentry->d_fsdata = NULL;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 486f91f..0e2557b 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4321,10 +4321,31 @@ static void delayed_work(struct work_struct *work)
 	schedule_delayed(mdsc);
 }
 
+static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
+{
+	int ret;
+
+	if (!metric)
+		return -EINVAL;
+
+	atomic64_set(&metric->total_dentries, 0);
+	ret = percpu_counter_init(&metric->d_lease_hit, 0, GFP_KERNEL);
+	if (ret)
+		return ret;
+	ret = percpu_counter_init(&metric->d_lease_mis, 0, GFP_KERNEL);
+	if (ret) {
+		percpu_counter_destroy(&metric->d_lease_hit);
+		return ret;
+	}
+
+	return 0;
+}
+
 int ceph_mdsc_init(struct ceph_fs_client *fsc)
 
 {
 	struct ceph_mds_client *mdsc;
+	int err;
 
 	mdsc = kzalloc(sizeof(struct ceph_mds_client), GFP_NOFS);
 	if (!mdsc)
@@ -4333,8 +4354,8 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	mutex_init(&mdsc->mutex);
 	mdsc->mdsmap = kzalloc(sizeof(*mdsc->mdsmap), GFP_NOFS);
 	if (!mdsc->mdsmap) {
-		kfree(mdsc);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto err_mdsc;
 	}
 
 	fsc->mdsc = mdsc;
@@ -4373,6 +4394,9 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	init_waitqueue_head(&mdsc->cap_flushing_wq);
 	INIT_WORK(&mdsc->cap_reclaim_work, ceph_cap_reclaim_work);
 	atomic_set(&mdsc->cap_reclaim_pending, 0);
+	err = ceph_mdsc_metric_init(&mdsc->metric);
+	if (err)
+		goto err_mdsmap;
 
 	spin_lock_init(&mdsc->dentry_list_lock);
 	INIT_LIST_HEAD(&mdsc->dentry_leases);
@@ -4391,6 +4415,12 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
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
 
 /*
@@ -4648,6 +4678,9 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
 
 	ceph_mdsc_stop(mdsc);
 
+	percpu_counter_destroy(&mdsc->metric.d_lease_mis);
+	percpu_counter_destroy(&mdsc->metric.d_lease_hit);
+
 	fsc->mdsc = NULL;
 	kfree(mdsc);
 	dout("mdsc_destroy %p done\n", mdsc);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 4e5be79b..ae1d01c 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -16,6 +16,8 @@
 #include <linux/ceph/mdsmap.h>
 #include <linux/ceph/auth.h>
 
+#include "metric.h"
+
 /* The first 8 bits are reserved for old ceph releases */
 enum ceph_feature_type {
 	CEPHFS_FEATURE_MIMIC = 8,
@@ -454,6 +456,8 @@ struct ceph_mds_client {
 	struct list_head  dentry_leases;     /* fifo list */
 	struct list_head  dentry_dir_leases; /* lru list */
 
+	struct ceph_client_metric metric;
+
 	spinlock_t		snapid_map_lock;
 	struct rb_root		snapid_map_tree;
 	struct list_head	snapid_map_lru;
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
new file mode 100644
index 0000000..998fe2a
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
index 60aac3a..5c73cf1 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -128,6 +128,7 @@ struct ceph_fs_client {
 	struct dentry *debugfs_congestion_kb;
 	struct dentry *debugfs_bdi;
 	struct dentry *debugfs_mdsc, *debugfs_mdsmap;
+	struct dentry *debugfs_metric;
 	struct dentry *debugfs_mds_sessions;
 #endif
 
-- 
1.8.3.1


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49E6A123E02
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Dec 2019 04:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfLRDgJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Dec 2019 22:36:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39054 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726387AbfLRDgI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 17 Dec 2019 22:36:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576640166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6P8PuyD4Lvf1mUptEC8MzweeE/nHgLNUN3i8/+LRdwg=;
        b=B5h5o+G3WoziAYY1zusVEi7Rkg6Zw8UaZaC+ABrxjwAZ1tJnF1Ls/xDBAR/albwyRbgDqk
        FhyExrHujqZdBsxJROlv8LyeG5vkTtTtfXLsOcnDiXIuqpWbN91L17WGmNA5ZyLsb6wzlL
        rQSgIEgC9avsn667+ewQhC273yuQmyE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-DToFrIE6N6GVP7nB2iM2wQ-1; Tue, 17 Dec 2019 22:36:03 -0500
X-MC-Unique: DToFrIE6N6GVP7nB2iM2wQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87918100ED51;
        Wed, 18 Dec 2019 03:16:06 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D03068884;
        Wed, 18 Dec 2019 03:15:59 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: add dentry lease and caps perf metric support
Date:   Tue, 17 Dec 2019 22:15:55 -0500
Message-Id: <20191218031555.28649-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

For both dentry lease and caps perf metric we will only count the
hit/miss info triggered from the vfs calls, for the cases like
request reply handling and perodically ceph_trim_dentries() we will
ignore them.

Currently only the debugfs is support and next will fulfill sending
the mertic data to MDS.

The output will be:

item          total           miss            hit
-------------------------------------------------
d_lease       11              7               141
i_caps        10              13              2495064

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

Changed in V2:
- switch to percpu counter to get a higher perf.


 fs/ceph/acl.c        |  2 +-
 fs/ceph/caps.c       | 24 ++++++++++++++++++++++-
 fs/ceph/debugfs.c    | 37 +++++++++++++++++++++++++++++++----
 fs/ceph/dir.c        | 39 ++++++++++++++++++++++++++-----------
 fs/ceph/file.c       | 10 ++++++++++
 fs/ceph/mds_client.c | 46 ++++++++++++++++++++++++++++++++++++++++++--
 fs/ceph/mds_client.h | 11 +++++++++++
 fs/ceph/super.h      |  6 ++++--
 fs/ceph/xattr.c      |  6 +++---
 9 files changed, 157 insertions(+), 24 deletions(-)

diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index aa55f412a6e3..b9411da0f6f2 100644
--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -22,7 +22,7 @@ static inline void ceph_set_cached_acl(struct inode *in=
ode,
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
=20
 	spin_lock(&ci->i_ceph_lock);
-	if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0))
+	if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0, true))
 		set_cached_acl(inode, type, acl);
 	else
 		forget_cached_acl(inode, type);
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 3d56c1333777..41ee74d43a88 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -862,17 +862,22 @@ static void __touch_cap(struct ceph_cap *cap)
  * front of their respective LRUs.  (This is the preferred way for
  * callers to check for caps they want.)
  */
-int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int to=
uch)
+int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int to=
uch,
+			    bool metric)
 {
 	struct ceph_cap *cap;
 	struct rb_node *p;
 	int have =3D ci->i_snap_caps;
+	struct inode *inode =3D &ci->vfs_inode;
+	struct ceph_mds_client *mdsc =3D ceph_inode_to_client(inode)->mdsc;
=20
 	if ((have & mask) =3D=3D mask) {
 		dout("__ceph_caps_issued_mask ino 0x%lx snap issued %s"
 		     " (mask %s)\n", ci->vfs_inode.i_ino,
 		     ceph_cap_string(have),
 		     ceph_cap_string(mask));
+		if (metric)
+			percpu_counter_inc(&mdsc->metric.i_caps_hit);
 		return 1;
 	}
=20
@@ -887,6 +892,8 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *c=
i, int mask, int touch)
 			     ceph_cap_string(mask));
 			if (touch)
 				__touch_cap(cap);
+			if (metric)
+				percpu_counter_inc(&mdsc->metric.i_caps_hit);
 			return 1;
 		}
=20
@@ -912,10 +919,14 @@ int __ceph_caps_issued_mask(struct ceph_inode_info =
*ci, int mask, int touch)
 						__touch_cap(cap);
 				}
 			}
+			if (metric)
+				percpu_counter_inc(&mdsc->metric.i_caps_hit);
 			return 1;
 		}
 	}
=20
+	if (metric)
+		percpu_counter_inc(&mdsc->metric.i_caps_mis);
 	return 0;
 }
=20
@@ -2718,6 +2729,7 @@ static void check_max_size(struct inode *inode, lof=
f_t endoff)
 int ceph_try_get_caps(struct inode *inode, int need, int want,
 		      bool nonblock, int *got)
 {
+	struct ceph_mds_client *mdsc =3D ceph_inode_to_client(inode)->mdsc;
 	int ret;
=20
 	BUG_ON(need & ~CEPH_CAP_FILE_RD);
@@ -2728,6 +2740,11 @@ int ceph_try_get_caps(struct inode *inode, int nee=
d, int want,
=20
 	ret =3D try_get_cap_refs(inode, need, want, 0,
 			       (nonblock ? NON_BLOCKING : 0), got);
+	if (ret =3D=3D 1)
+		percpu_counter_inc(&mdsc->metric.i_caps_hit);
+	else
+		percpu_counter_inc(&mdsc->metric.i_caps_mis);
+
 	return ret =3D=3D -EAGAIN ? 0 : ret;
 }
=20
@@ -2782,6 +2799,11 @@ int ceph_get_caps(struct file *filp, int need, int=
 want,
 				continue;
 		}
=20
+		if (ret =3D=3D 1)
+			percpu_counter_inc(&fsc->mdsc->metric.i_caps_hit);
+		else
+			percpu_counter_inc(&fsc->mdsc->metric.i_caps_mis);
+
 		if ((fi->fmode & CEPH_FILE_MODE_WR) &&
 		    fi->filp_gen !=3D READ_ONCE(fsc->filp_gen)) {
 			if (ret >=3D 0 && _got)
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index facb387c2735..e8fe2c90c731 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -124,6 +124,27 @@ static int mdsc_show(struct seq_file *s, void *p)
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
+		   atomic64_read(&mdsc->dentry_total_count),
+		   percpu_counter_sum(&mdsc->metric.d_lease_mis),
+		   percpu_counter_sum(&mdsc->metric.d_lease_hit));
+
+	seq_printf(s, "%-14s%-16d%-16lld%lld\n", "i_caps",
+		   mdsc->caps_use_count,
+		   percpu_counter_sum(&mdsc->metric.i_caps_mis),
+		   percpu_counter_sum(&mdsc->metric.i_caps_hit));
+
+	return 0;
+}
+
 static int caps_show_cb(struct inode *inode, struct ceph_cap *cap, void =
*p)
 {
 	struct seq_file *s =3D p;
@@ -207,6 +228,7 @@ static int mds_sessions_show(struct seq_file *s, void=
 *ptr)
=20
 CEPH_DEFINE_SHOW_FUNC(mdsmap_show)
 CEPH_DEFINE_SHOW_FUNC(mdsc_show)
+CEPH_DEFINE_SHOW_FUNC(metric_show)
 CEPH_DEFINE_SHOW_FUNC(caps_show)
 CEPH_DEFINE_SHOW_FUNC(mds_sessions_show)
=20
@@ -242,6 +264,7 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *f=
sc)
 	debugfs_remove(fsc->debugfs_mdsmap);
 	debugfs_remove(fsc->debugfs_mds_sessions);
 	debugfs_remove(fsc->debugfs_caps);
+	debugfs_remove(fsc->debugfs_metric);
 	debugfs_remove(fsc->debugfs_mdsc);
 }
=20
@@ -282,11 +305,17 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fs=
c)
 						fsc,
 						&mdsc_show_fops);
=20
+	fsc->debugfs_metric =3D debugfs_create_file("metric",
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
index d17a789fd856..5c97bdbb0772 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -30,7 +30,7 @@
 const struct dentry_operations ceph_dentry_ops;
=20
 static bool __dentry_lease_is_valid(struct ceph_dentry_info *di);
-static int __dir_lease_try_check(const struct dentry *dentry);
+static int __dir_lease_try_check(const struct dentry *dentry, bool metri=
c);
=20
 /*
  * Initialize ceph dentry state.
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
+	atomic64_inc(&mdsc->dentry_total_count);
+
 	return 0;
 }
=20
@@ -341,7 +346,7 @@ static int ceph_readdir(struct file *file, struct dir=
_context *ctx)
 	    !ceph_test_mount_opt(fsc, NOASYNCREADDIR) &&
 	    ceph_snap(inode) !=3D CEPH_SNAPDIR &&
 	    __ceph_dir_is_complete_ordered(ci) &&
-	    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1)) {
+	    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1, true)) {
 		int shared_gen =3D atomic_read(&ci->i_shared_gen);
 		spin_unlock(&ci->i_ceph_lock);
 		err =3D __dcache_readdir(file, ctx, shared_gen);
@@ -759,7 +764,8 @@ static struct dentry *ceph_lookup(struct inode *dir, =
struct dentry *dentry,
 		    !is_root_ceph_dentry(dir, dentry) &&
 		    ceph_test_mount_opt(fsc, DCACHE) &&
 		    __ceph_dir_is_complete(ci) &&
-		    (__ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1))) {
+		    (__ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1,
+					     true))) {
 			spin_unlock(&ci->i_ceph_lock);
 			dout(" dir %p complete, -ENOENT\n", dir);
 			d_add(dentry, NULL);
@@ -1336,7 +1342,7 @@ static int __dentry_lease_check(struct dentry *dent=
ry, void *arg)
=20
 	if (__dentry_lease_is_valid(di))
 		return STOP;
-	ret =3D __dir_lease_try_check(dentry);
+	ret =3D __dir_lease_try_check(dentry, false);
 	if (ret =3D=3D -EBUSY)
 		return KEEP;
 	if (ret > 0)
@@ -1349,7 +1355,7 @@ static int __dir_lease_check(struct dentry *dentry,=
 void *arg)
 	struct ceph_lease_walk_control *lwc =3D arg;
 	struct ceph_dentry_info *di =3D ceph_dentry(dentry);
=20
-	int ret =3D __dir_lease_try_check(dentry);
+	int ret =3D __dir_lease_try_check(dentry, false);
 	if (ret =3D=3D -EBUSY)
 		return KEEP;
 	if (ret > 0) {
@@ -1488,7 +1494,7 @@ static int dentry_lease_is_valid(struct dentry *den=
try, unsigned int flags)
 /*
  * Called under dentry->d_lock.
  */
-static int __dir_lease_try_check(const struct dentry *dentry)
+static int __dir_lease_try_check(const struct dentry *dentry, bool metri=
c)
 {
 	struct ceph_dentry_info *di =3D ceph_dentry(dentry);
 	struct inode *dir;
@@ -1505,7 +1511,8 @@ static int __dir_lease_try_check(const struct dentr=
y *dentry)
=20
 	if (spin_trylock(&ci->i_ceph_lock)) {
 		if (atomic_read(&ci->i_shared_gen) =3D=3D di->lease_shared_gen &&
-		    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 0))
+		    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 0,
+					    metric))
 			valid =3D 1;
 		spin_unlock(&ci->i_ceph_lock);
 	} else {
@@ -1527,7 +1534,7 @@ static int dir_lease_is_valid(struct inode *dir, st=
ruct dentry *dentry)
 	int shared_gen;
=20
 	spin_lock(&ci->i_ceph_lock);
-	valid =3D __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1);
+	valid =3D __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1, true);
 	shared_gen =3D atomic_read(&ci->i_shared_gen);
 	spin_unlock(&ci->i_ceph_lock);
 	if (valid) {
@@ -1551,6 +1558,7 @@ static int dir_lease_is_valid(struct inode *dir, st=
ruct dentry *dentry)
  */
 static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
 {
+	struct ceph_mds_client *mdsc;
 	int valid =3D 0;
 	struct dentry *parent;
 	struct inode *dir, *inode;
@@ -1567,6 +1575,8 @@ static int ceph_d_revalidate(struct dentry *dentry,=
 unsigned int flags)
 		inode =3D d_inode(dentry);
 	}
=20
+	mdsc =3D ceph_sb_to_client(dir->i_sb)->mdsc;
+
 	dout("d_revalidate %p '%pd' inode %p offset %lld\n", dentry,
 	     dentry, inode, ceph_dentry(dentry)->offset);
=20
@@ -1590,12 +1600,12 @@ static int ceph_d_revalidate(struct dentry *dentr=
y, unsigned int flags)
 	}
=20
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
@@ -1630,6 +1640,8 @@ static int ceph_d_revalidate(struct dentry *dentry,=
 unsigned int flags)
 			dout("d_revalidate %p lookup result=3D%d\n",
 			     dentry, err);
 		}
+	} else {
+		percpu_counter_inc(&mdsc->metric.d_lease_hit);
 	}
=20
 	dout("d_revalidate %p %s\n", dentry, valid ? "valid" : "invalid");
@@ -1638,6 +1650,7 @@ static int ceph_d_revalidate(struct dentry *dentry,=
 unsigned int flags)
=20
 	if (!(flags & LOOKUP_RCU))
 		dput(parent);
+
 	return valid;
 }
=20
@@ -1660,7 +1673,7 @@ static int ceph_d_delete(const struct dentry *dentr=
y)
 	if (di) {
 		if (__dentry_lease_is_valid(di))
 			return 0;
-		if (__dir_lease_try_check(dentry))
+		if (__dir_lease_try_check(dentry, true))
 			return 0;
 	}
 	return 1;
@@ -1672,9 +1685,13 @@ static int ceph_d_delete(const struct dentry *dent=
ry)
 static void ceph_d_release(struct dentry *dentry)
 {
 	struct ceph_dentry_info *di =3D ceph_dentry(dentry);
+	struct ceph_fs_client *fsc =3D ceph_sb_to_client(dentry->d_sb);
+	struct ceph_mds_client *mdsc =3D fsc->mdsc;
=20
 	dout("d_release %p\n", dentry);
=20
+	atomic64_dec(&mdsc->dentry_total_count);
+
 	spin_lock(&dentry->d_lock);
 	__dentry_lease_unlist(di);
 	dentry->d_fsdata =3D NULL;
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 8de633964dc3..68cc385992d6 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -375,6 +375,9 @@ int ceph_open(struct inode *inode, struct file *file)
 		spin_lock(&ci->i_ceph_lock);
 		__ceph_get_fmode(ci, fmode);
 		spin_unlock(&ci->i_ceph_lock);
+
+		percpu_counter_inc(&mdsc->metric.i_caps_hit);
+
 		return ceph_init_file(inode, file, fmode);
 	}
=20
@@ -395,6 +398,8 @@ int ceph_open(struct inode *inode, struct file *file)
 		__ceph_get_fmode(ci, fmode);
 		spin_unlock(&ci->i_ceph_lock);
=20
+		percpu_counter_inc(&mdsc->metric.i_caps_hit);
+
 		/* adjust wanted? */
 		if ((issued & wanted) !=3D wanted &&
 		    (mds_wanted & wanted) !=3D wanted &&
@@ -406,11 +411,16 @@ int ceph_open(struct inode *inode, struct file *fil=
e)
 		   (ci->i_snap_caps & wanted) =3D=3D wanted) {
 		__ceph_get_fmode(ci, fmode);
 		spin_unlock(&ci->i_ceph_lock);
+
+		percpu_counter_inc(&mdsc->metric.i_caps_hit);
+
 		return ceph_init_file(inode, file, fmode);
 	}
=20
 	spin_unlock(&ci->i_ceph_lock);
=20
+	percpu_counter_inc(&mdsc->metric.i_caps_mis);
+
 	dout("open fmode %d wants %s\n", fmode, ceph_cap_string(wanted));
 	req =3D prepare_open_request(inode->i_sb, flags, 0);
 	if (IS_ERR(req)) {
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d8bb3eebfaeb..249f100deaae 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4158,10 +4158,42 @@ static void delayed_work(struct work_struct *work=
)
 	schedule_delayed(mdsc);
 }
=20
+static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
+{
+	int err;
+
+	if (!metric)
+		return -EINVAL;
+
+	err =3D percpu_counter_init(&metric->i_caps_hit, 0, GFP_KERNEL);
+	if (err)
+		return err;
+	err =3D percpu_counter_init(&metric->i_caps_mis, 0, GFP_KERNEL);
+	if (err)
+		goto err1;
+	err =3D percpu_counter_init(&metric->d_lease_hit, 0, GFP_KERNEL);
+	if (err)
+		goto err2;
+	err =3D percpu_counter_init(&metric->d_lease_mis, 0, GFP_KERNEL);
+	if (err)
+		goto err3;
+
+	return 0;
+
+err3:
+	percpu_counter_destroy(&metric->d_lease_hit);
+err2:
+	percpu_counter_destroy(&metric->i_caps_mis);
+err1:
+	percpu_counter_destroy(&metric->i_caps_hit);
+	return err;
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
@@ -4170,8 +4202,8 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
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
@@ -4209,6 +4241,10 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	init_waitqueue_head(&mdsc->cap_flushing_wq);
 	INIT_WORK(&mdsc->cap_reclaim_work, ceph_cap_reclaim_work);
 	atomic_set(&mdsc->cap_reclaim_pending, 0);
+	atomic64_set(&mdsc->dentry_total_count, 0);
+	err =3D ceph_mdsc_metric_init(&mdsc->metric);
+	if (err)
+		goto err_mdsmap;
=20
 	spin_lock_init(&mdsc->dentry_list_lock);
 	INIT_LIST_HEAD(&mdsc->dentry_leases);
@@ -4227,6 +4263,12 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
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
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 9fb2063b0600..be5d3331eca3 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -341,6 +341,13 @@ struct ceph_quotarealm_inode {
 	struct inode *inode;
 };
=20
+struct ceph_client_metric {
+	struct percpu_counter d_lease_hit;
+	struct percpu_counter d_lease_mis;
+	struct percpu_counter i_caps_hit;
+	struct percpu_counter i_caps_mis;
+};
+
 /*
  * mds client state
  */
@@ -428,6 +435,10 @@ struct ceph_mds_client {
 	struct list_head  dentry_leases;     /* fifo list */
 	struct list_head  dentry_dir_leases; /* lru list */
=20
+	atomic64_t	dentry_total_count;
+
+	struct ceph_client_metric metric;
+
 	spinlock_t		snapid_map_lock;
 	struct rb_root		snapid_map_tree;
 	struct list_head	snapid_map_lru;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index f0f9cb7447ac..a0e4d0bd013d 100644
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
@@ -635,7 +636,8 @@ static inline bool __ceph_is_any_real_caps(struct cep=
h_inode_info *ci)
 }
=20
 extern int __ceph_caps_issued(struct ceph_inode_info *ci, int *implement=
ed);
-extern int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask,=
 int t);
+extern int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask,
+				   int t, bool metric);
 extern int __ceph_caps_issued_other(struct ceph_inode_info *ci,
 				    struct ceph_cap *cap);
=20
@@ -653,7 +655,7 @@ static inline int ceph_caps_issued_mask(struct ceph_i=
node_info *ci, int mask,
 {
 	int r;
 	spin_lock(&ci->i_ceph_lock);
-	r =3D __ceph_caps_issued_mask(ci, mask, touch);
+	r =3D __ceph_caps_issued_mask(ci, mask, touch, true);
 	spin_unlock(&ci->i_ceph_lock);
 	return r;
 }
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index cb18ee637cb7..530fc2a72236 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -856,7 +856,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const ch=
ar *name, void *value,
=20
 	if (ci->i_xattrs.version =3D=3D 0 ||
 	    !((req_mask & CEPH_CAP_XATTR_SHARED) ||
-	      __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1))) {
+	      __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1, true))) {
 		spin_unlock(&ci->i_ceph_lock);
=20
 		/* security module gets xattr while filling trace */
@@ -914,7 +914,7 @@ ssize_t ceph_listxattr(struct dentry *dentry, char *n=
ames, size_t size)
 	     ci->i_xattrs.version, ci->i_xattrs.index_version);
=20
 	if (ci->i_xattrs.version =3D=3D 0 ||
-	    !__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1)) {
+	    !__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1, true)) {
 		spin_unlock(&ci->i_ceph_lock);
 		err =3D ceph_do_getattr(inode, CEPH_STAT_CAP_XATTR, true);
 		if (err)
@@ -1192,7 +1192,7 @@ bool ceph_security_xattr_deadlock(struct inode *in)
 	spin_lock(&ci->i_ceph_lock);
 	ret =3D !(ci->i_ceph_flags & CEPH_I_SEC_INITED) &&
 	      !(ci->i_xattrs.version > 0 &&
-		__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0));
+		__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0, false));
 	spin_unlock(&ci->i_ceph_lock);
 	return ret;
 }
--=20
2.21.0


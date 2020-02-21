Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7816166FFB
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Feb 2020 08:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgBUHHD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Feb 2020 02:07:03 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40869 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726278AbgBUHHD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 02:07:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582268821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ecDtiNoFMYf6LSBgYluPiW4EJ96BILY+6+z1iL9UjY=;
        b=INBClKmdBz6q59Ivi+QJzWP1L/mguyIGo6VQztUjNWB9Hn7+ebMA7ujShwCZEC1WQoGtx0
        5uSS86mumj6doWE1UPxyk/qNpoVW0K8WvXexKqyWkDmbP4A2DxaKm/ENs7qAqPNexWs03G
        T/xTYkxA1hntigCOIP8olTvIG10Dr9o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-cl0dI6abMyeheqf7zoifow-1; Fri, 21 Feb 2020 02:06:55 -0500
X-MC-Unique: cl0dI6abMyeheqf7zoifow-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B05CE8018C5;
        Fri, 21 Feb 2020 07:06:54 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 734845D9E2;
        Fri, 21 Feb 2020 07:06:51 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v8 2/5] ceph: add caps perf metric for each session
Date:   Fri, 21 Feb 2020 02:05:53 -0500
Message-Id: <20200221070556.18922-3-xiubli@redhat.com>
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

This will fulfill the cap hit/mis metric stuff per-superblock,
it will count the hit/mis counters based each inode, and if one
inode's 'issued & ~revoking =3D=3D mask' will mean a hit, or a miss.

item          total           miss            hit
-------------------------------------------------
caps          295             107             4119

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/acl.c        |  2 +-
 fs/ceph/caps.c       | 19 +++++++++++++++++++
 fs/ceph/debugfs.c    | 16 ++++++++++++++++
 fs/ceph/dir.c        |  5 +++--
 fs/ceph/inode.c      |  4 ++--
 fs/ceph/mds_client.c | 26 ++++++++++++++++++++++----
 fs/ceph/metric.h     | 19 +++++++++++++++++++
 fs/ceph/super.h      |  8 +++++---
 fs/ceph/xattr.c      |  4 ++--
 9 files changed, 89 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index 26be6520d3fb..e0465741c591 100644
--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -22,7 +22,7 @@ static inline void ceph_set_cached_acl(struct inode *in=
ode,
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
=20
 	spin_lock(&ci->i_ceph_lock);
-	if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0))
+	if (__ceph_caps_issued_mask_metric(ci, CEPH_CAP_XATTR_SHARED, 0))
 		set_cached_acl(inode, type, acl);
 	else
 		forget_cached_acl(inode, type);
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index d05717397c2a..fe2ae41f2ec1 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -920,6 +920,20 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *=
ci, int mask, int touch)
 	return 0;
 }
=20
+int __ceph_caps_issued_mask_metric(struct ceph_inode_info *ci, int mask,
+				   int touch)
+{
+	struct ceph_fs_client *fsc =3D ceph_sb_to_client(ci->vfs_inode.i_sb);
+	int r;
+
+	r =3D __ceph_caps_issued_mask(ci, mask, touch);
+	if (r)
+		ceph_update_cap_hit(&fsc->mdsc->metric);
+	else
+		ceph_update_cap_mis(&fsc->mdsc->metric);
+	return r;
+}
+
 /*
  * Return true if mask caps are currently being revoked by an MDS.
  */
@@ -2700,6 +2714,11 @@ static int try_get_cap_refs(struct inode *inode, i=
nt need, int want,
 	if (snap_rwsem_locked)
 		up_read(&mdsc->snap_rwsem);
=20
+	if (!ret)
+		ceph_update_cap_mis(&mdsc->metric);
+	else if (ret =3D=3D 1)
+		ceph_update_cap_hit(&mdsc->metric);
+
 	dout("get_cap_refs %p ret %d got %s\n", inode,
 	     ret, ceph_cap_string(*got));
 	return ret;
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 15975ba95d9a..c83e52bd9961 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -128,6 +128,7 @@ static int metric_show(struct seq_file *s, void *p)
 {
 	struct ceph_fs_client *fsc =3D s->private;
 	struct ceph_mds_client *mdsc =3D fsc->mdsc;
+	int i, nr_caps =3D 0;
=20
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
@@ -137,6 +138,21 @@ static int metric_show(struct seq_file *s, void *p)
 		   percpu_counter_sum(&mdsc->metric.d_lease_mis),
 		   percpu_counter_sum(&mdsc->metric.d_lease_hit));
=20
+	mutex_lock(&mdsc->mutex);
+	for (i =3D 0; i < mdsc->max_sessions; i++) {
+		struct ceph_mds_session *s;
+
+		s =3D __ceph_lookup_mds_session(mdsc, i);
+		if (!s)
+			continue;
+		nr_caps +=3D s->s_nr_caps;
+		ceph_put_mds_session(s);
+	}
+	mutex_unlock(&mdsc->mutex);
+	seq_printf(s, "%-14s%-16d%-16lld%lld\n", "caps", nr_caps,
+		   percpu_counter_sum(&mdsc->metric.i_caps_mis),
+		   percpu_counter_sum(&mdsc->metric.i_caps_hit));
+
 	return 0;
 }
=20
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index ff1714fe03aa..227949c3deb8 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -346,8 +346,9 @@ static int ceph_readdir(struct file *file, struct dir=
_context *ctx)
 	    !ceph_test_mount_opt(fsc, NOASYNCREADDIR) &&
 	    ceph_snap(inode) !=3D CEPH_SNAPDIR &&
 	    __ceph_dir_is_complete_ordered(ci) &&
-	    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1)) {
+	    __ceph_caps_issued_mask_metric(ci, CEPH_CAP_FILE_SHARED, 1)) {
 		int shared_gen =3D atomic_read(&ci->i_shared_gen);
+
 		spin_unlock(&ci->i_ceph_lock);
 		err =3D __dcache_readdir(file, ctx, shared_gen);
 		if (err !=3D -EAGAIN)
@@ -764,7 +765,7 @@ static struct dentry *ceph_lookup(struct inode *dir, =
struct dentry *dentry,
 		    !is_root_ceph_dentry(dir, dentry) &&
 		    ceph_test_mount_opt(fsc, DCACHE) &&
 		    __ceph_dir_is_complete(ci) &&
-		    (__ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1))) {
+		    __ceph_caps_issued_mask_metric(ci, CEPH_CAP_FILE_SHARED, 1)) {
 			spin_unlock(&ci->i_ceph_lock);
 			dout(" dir %p complete, -ENOENT\n", dir);
 			d_add(dentry, NULL);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 094b8fc37787..8dc10196e3a1 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2273,8 +2273,8 @@ int __ceph_do_getattr(struct inode *inode, struct p=
age *locked_page,
=20
 	dout("do_getattr inode %p mask %s mode 0%o\n",
 	     inode, ceph_cap_string(mask), inode->i_mode);
-	if (!force && ceph_caps_issued_mask(ceph_inode(inode), mask, 1))
-		return 0;
+	if (!force && ceph_caps_issued_mask_metric(ceph_inode(inode), mask, 1))
+			return 0;
=20
 	mode =3D (mask & CEPH_STAT_RSTAT) ? USE_AUTH_MDS : USE_ANY_MDS;
 	req =3D ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, mode);
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 82060afd5dca..cd31bcb4e563 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4167,13 +4167,29 @@ static int ceph_mdsc_metric_init(struct ceph_clie=
nt_metric *metric)
 	ret =3D percpu_counter_init(&metric->d_lease_hit, 0, GFP_KERNEL);
 	if (ret)
 		return ret;
+
 	ret =3D percpu_counter_init(&metric->d_lease_mis, 0, GFP_KERNEL);
-	if (ret) {
-		percpu_counter_destroy(&metric->d_lease_hit);
-		return ret;
-	}
+	if (ret)
+		goto err_d_lease_mis;
+
+	ret =3D percpu_counter_init(&metric->i_caps_hit, 0, GFP_KERNEL);
+	if (ret)
+		goto err_i_caps_hit;
+
+	ret =3D percpu_counter_init(&metric->i_caps_mis, 0, GFP_KERNEL);
+	if (ret)
+		goto err_i_caps_mis;
=20
 	return 0;
+
+err_i_caps_mis:
+	percpu_counter_destroy(&metric->i_caps_hit);
+err_i_caps_hit:
+	percpu_counter_destroy(&metric->d_lease_mis);
+err_d_lease_mis:
+	percpu_counter_destroy(&metric->d_lease_hit);
+
+	return ret;
 }
=20
 int ceph_mdsc_init(struct ceph_fs_client *fsc)
@@ -4513,6 +4529,8 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
=20
 	ceph_mdsc_stop(mdsc);
=20
+	percpu_counter_destroy(&mdsc->metric.i_caps_mis);
+	percpu_counter_destroy(&mdsc->metric.i_caps_hit);
 	percpu_counter_destroy(&mdsc->metric.d_lease_mis);
 	percpu_counter_destroy(&mdsc->metric.d_lease_hit);
=20
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 998fe2a643cf..40eb58f9f43e 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -7,5 +7,24 @@ struct ceph_client_metric {
 	atomic64_t            total_dentries;
 	struct percpu_counter d_lease_hit;
 	struct percpu_counter d_lease_mis;
+
+	struct percpu_counter i_caps_hit;
+	struct percpu_counter i_caps_mis;
 };
+
+static inline void ceph_update_cap_hit(struct ceph_client_metric *m)
+{
+	if (!m)
+		return;
+
+	percpu_counter_inc(&m->i_caps_hit);
+}
+
+static inline void ceph_update_cap_mis(struct ceph_client_metric *m)
+{
+	if (!m)
+		return;
+
+	percpu_counter_inc(&m->i_caps_mis);
+}
 #endif /* _FS_CEPH_MDS_METRIC_H */
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index ebcf7612eac9..4b269dc845bb 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -639,6 +639,8 @@ static inline bool __ceph_is_any_real_caps(struct cep=
h_inode_info *ci)
=20
 extern int __ceph_caps_issued(struct ceph_inode_info *ci, int *implement=
ed);
 extern int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask,=
 int t);
+extern int __ceph_caps_issued_mask_metric(struct ceph_inode_info *ci, in=
t mask,
+					  int t);
 extern int __ceph_caps_issued_other(struct ceph_inode_info *ci,
 				    struct ceph_cap *cap);
=20
@@ -651,12 +653,12 @@ static inline int ceph_caps_issued(struct ceph_inod=
e_info *ci)
 	return issued;
 }
=20
-static inline int ceph_caps_issued_mask(struct ceph_inode_info *ci, int =
mask,
-					int touch)
+static inline int ceph_caps_issued_mask_metric(struct ceph_inode_info *c=
i,
+					       int mask, int touch)
 {
 	int r;
 	spin_lock(&ci->i_ceph_lock);
-	r =3D __ceph_caps_issued_mask(ci, mask, touch);
+	r =3D __ceph_caps_issued_mask_metric(ci, mask, touch);
 	spin_unlock(&ci->i_ceph_lock);
 	return r;
 }
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 7b8a070a782d..71ee34d160c3 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -856,7 +856,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const ch=
ar *name, void *value,
=20
 	if (ci->i_xattrs.version =3D=3D 0 ||
 	    !((req_mask & CEPH_CAP_XATTR_SHARED) ||
-	      __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1))) {
+	      __ceph_caps_issued_mask_metric(ci, CEPH_CAP_XATTR_SHARED, 1))) {
 		spin_unlock(&ci->i_ceph_lock);
=20
 		/* security module gets xattr while filling trace */
@@ -914,7 +914,7 @@ ssize_t ceph_listxattr(struct dentry *dentry, char *n=
ames, size_t size)
 	     ci->i_xattrs.version, ci->i_xattrs.index_version);
=20
 	if (ci->i_xattrs.version =3D=3D 0 ||
-	    !__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1)) {
+	    !__ceph_caps_issued_mask_metric(ci, CEPH_CAP_XATTR_SHARED, 1)) {
 		spin_unlock(&ci->i_ceph_lock);
 		err =3D ceph_do_getattr(inode, CEPH_STAT_CAP_XATTR, true);
 		if (err)
--=20
2.21.0


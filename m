Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46D7213B841
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2020 04:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgAODpT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Jan 2020 22:45:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55498 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728879AbgAODpT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 14 Jan 2020 22:45:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579059918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XSY5l3OaKlA6eXDjm7b+pzqKdFwXTW27GvGpwE4JqYQ=;
        b=LUsstcpfyf/Mi3TDD0bQ22eKtQRX8O2X4B1JkVIEhPHU2YU3W0A7+iZJnChHaQDPQXBVkP
        XHZ/AaKvogLf+Jdylpin3mMAIt+5WSc/vwwbkMetf4Dmq0h48r2nieB3KvRuzC6iVQcu5X
        74u46bJlDvgRN9DqOB/pDznHWChntyg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-Mu4yy0vtOuKesC1GR5TGKA-1; Tue, 14 Jan 2020 22:45:17 -0500
X-MC-Unique: Mu4yy0vtOuKesC1GR5TGKA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 527E51005502;
        Wed, 15 Jan 2020 03:45:16 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-49.pek2.redhat.com [10.72.12.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAE06101F6D4;
        Wed, 15 Jan 2020 03:45:13 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 2/8] ceph: add caps perf metric for each session
Date:   Tue, 14 Jan 2020 22:44:38 -0500
Message-Id: <20200115034444.14304-3-xiubli@redhat.com>
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

This will fulfill the caps hit/miss metric for each session. When
checking the "need" mask and if one cap has the subset of the "need"
mask it means hit, or missed.

item          total           miss            hit
-------------------------------------------------
d_lease       295             0               993

session       caps            miss            hit
-------------------------------------------------
0             295             107             4119
1             1               107             9

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/acl.c        |  2 ++
 fs/ceph/addr.c       |  1 +
 fs/ceph/caps.c       | 71 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/debugfs.c    | 20 +++++++++++++
 fs/ceph/dir.c        |  4 +++
 fs/ceph/file.c       |  4 ++-
 fs/ceph/mds_client.c | 16 +++++++++-
 fs/ceph/mds_client.h |  3 ++
 fs/ceph/quota.c      |  8 +++--
 fs/ceph/super.h      |  6 ++++
 fs/ceph/xattr.c      | 17 +++++++++--
 11 files changed, 145 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index 26be6520d3fb..58e119e3519f 100644
--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -22,6 +22,8 @@ static inline void ceph_set_cached_acl(struct inode *in=
ode,
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
=20
 	spin_lock(&ci->i_ceph_lock);
+	__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
+
 	if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0))
 		set_cached_acl(inode, type, acl);
 	else
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 7ab616601141..fe8adf3dc065 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1706,6 +1706,7 @@ int ceph_uninline_data(struct file *filp, struct pa=
ge *locked_page)
 			err =3D -ENOMEM;
 			goto out;
 		}
+		__ceph_caps_metric(ci, CEPH_STAT_CAP_INLINE_DATA);
 		err =3D __ceph_do_getattr(inode, page,
 					CEPH_STAT_CAP_INLINE_DATA, true);
 		if (err < 0) {
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 7fc87b693ba4..df85980f0930 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -783,6 +783,73 @@ static int __cap_is_valid(struct ceph_cap *cap)
 	return 1;
 }
=20
+/*
+ * Counts the cap metric.
+ */
+void __ceph_caps_metric(struct ceph_inode_info *ci, int mask)
+{
+	int have =3D ci->i_snap_caps;
+	struct ceph_mds_session *s;
+	struct ceph_cap *cap;
+	struct rb_node *p;
+	bool skip_auth =3D false;
+
+	if (mask <=3D 0)
+		return;
+
+	/* Counts the snap caps metric in the auth cap */
+	if (ci->i_auth_cap) {
+		cap =3D ci->i_auth_cap;
+		if (have) {
+			have |=3D cap->issued;
+
+			dout("%s %p cap %p issued %s, mask %s\n", __func__,
+			     &ci->vfs_inode, cap, ceph_cap_string(cap->issued),
+			     ceph_cap_string(mask));
+
+			s =3D ceph_get_mds_session(cap->session);
+			if (s) {
+				if (mask & have)
+					percpu_counter_inc(&s->i_caps_hit);
+				else
+					percpu_counter_inc(&s->i_caps_mis);
+				ceph_put_mds_session(s);
+			}
+			skip_auth =3D true;
+		}
+	}
+
+	if ((mask & have) =3D=3D mask)
+		return;
+
+	/* Checks others */
+	for (p =3D rb_first(&ci->i_caps); p; p =3D rb_next(p)) {
+		cap =3D rb_entry(p, struct ceph_cap, ci_node);
+		if (!__cap_is_valid(cap))
+			continue;
+
+		if (skip_auth && cap =3D=3D ci->i_auth_cap)
+			continue;
+
+		dout("%s %p cap %p issued %s, mask %s\n", __func__,
+		     &ci->vfs_inode, cap, ceph_cap_string(cap->issued),
+		     ceph_cap_string(mask));
+
+		s =3D ceph_get_mds_session(cap->session);
+		if (s) {
+			if (mask & cap->issued)
+				percpu_counter_inc(&s->i_caps_hit);
+			else
+				percpu_counter_inc(&s->i_caps_mis);
+			ceph_put_mds_session(s);
+		}
+
+		have |=3D cap->issued;
+		if ((mask & have) =3D=3D mask)
+			return;
+	}
+}
+
 /*
  * Return set of valid cap bits issued to us.  Note that caps time
  * out, and may be invalidated in bulk if the client session times out
@@ -881,6 +948,7 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *c=
i, int mask, int touch)
 		cap =3D rb_entry(p, struct ceph_cap, ci_node);
 		if (!__cap_is_valid(cap))
 			continue;
+
 		if ((cap->issued & mask) =3D=3D mask) {
 			dout("__ceph_caps_issued_mask ino 0x%lx cap %p issued %s"
 			     " (mask %s)\n", ci->vfs_inode.i_ino, cap,
@@ -2603,6 +2671,8 @@ static int try_get_cap_refs(struct inode *inode, in=
t need, int want,
 		spin_lock(&ci->i_ceph_lock);
 	}
=20
+	__ceph_caps_metric(ci, need);
+
 	have =3D __ceph_caps_issued(ci, &implemented);
=20
 	if (have & need & CEPH_CAP_FILE_WR) {
@@ -2871,6 +2941,7 @@ int ceph_get_caps(struct file *filp, int need, int =
want,
 			 * getattr request will bring inline data into
 			 * page cache
 			 */
+			__ceph_caps_metric(ci, CEPH_STAT_CAP_INLINE_DATA);
 			ret =3D __ceph_do_getattr(inode, NULL,
 						CEPH_STAT_CAP_INLINE_DATA,
 						true);
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 40a22da0214a..c132fdb40d53 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -128,6 +128,7 @@ static int metric_show(struct seq_file *s, void *p)
 {
 	struct ceph_fs_client *fsc =3D s->private;
 	struct ceph_mds_client *mdsc =3D fsc->mdsc;
+	int i;
=20
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
@@ -137,6 +138,25 @@ static int metric_show(struct seq_file *s, void *p)
 		   percpu_counter_sum(&mdsc->metric.d_lease_mis),
 		   percpu_counter_sum(&mdsc->metric.d_lease_hit));
=20
+	seq_printf(s, "\n");
+	seq_printf(s, "session       caps            miss            hit\n");
+	seq_printf(s, "-------------------------------------------------\n");
+
+	mutex_lock(&mdsc->mutex);
+	for (i =3D 0; i < mdsc->max_sessions; i++) {
+		struct ceph_mds_session *session;
+
+		session =3D __ceph_lookup_mds_session(mdsc, i);
+		if (!session)
+			continue;
+		seq_printf(s, "%-14d%-16d%-16lld%lld\n", i,
+			   session->s_nr_caps,
+			   percpu_counter_sum(&session->i_caps_mis),
+			   percpu_counter_sum(&session->i_caps_hit));
+		ceph_put_mds_session(session);
+	}
+	mutex_unlock(&mdsc->mutex);
+
 	return 0;
 }
=20
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 658c55b323cc..c381ce430036 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -342,6 +342,8 @@ static int ceph_readdir(struct file *file, struct dir=
_context *ctx)
=20
 	/* can we use the dcache? */
 	spin_lock(&ci->i_ceph_lock);
+	__ceph_caps_metric(ci, CEPH_CAP_FILE_SHARED);
+
 	if (ceph_test_mount_opt(fsc, DCACHE) &&
 	    !ceph_test_mount_opt(fsc, NOASYNCREADDIR) &&
 	    ceph_snap(inode) !=3D CEPH_SNAPDIR &&
@@ -757,6 +759,8 @@ static struct dentry *ceph_lookup(struct inode *dir, =
struct dentry *dentry,
 		struct ceph_dentry_info *di =3D ceph_dentry(dentry);
=20
 		spin_lock(&ci->i_ceph_lock);
+		__ceph_caps_metric(ci, CEPH_CAP_FILE_SHARED);
+
 		dout(" dir %p flags are %d\n", dir, ci->i_ceph_flags);
 		if (strncmp(dentry->d_name.name,
 			    fsc->mount_options->snapdir_name,
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 1e6cdf2dfe90..b32aba4023b3 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -393,6 +393,7 @@ int ceph_open(struct inode *inode, struct file *file)
 		     inode, fmode, ceph_cap_string(wanted),
 		     ceph_cap_string(issued));
 		__ceph_get_fmode(ci, fmode);
+		__ceph_caps_metric(ci, fmode);
 		spin_unlock(&ci->i_ceph_lock);
=20
 		/* adjust wanted? */
@@ -403,7 +404,7 @@ int ceph_open(struct inode *inode, struct file *file)
=20
 		return ceph_init_file(inode, file, fmode);
 	} else if (ceph_snap(inode) !=3D CEPH_NOSNAP &&
-		   (ci->i_snap_caps & wanted) =3D=3D wanted) {
+			(ci->i_snap_caps & wanted) =3D=3D wanted) {
 		__ceph_get_fmode(ci, fmode);
 		spin_unlock(&ci->i_ceph_lock);
 		return ceph_init_file(inode, file, fmode);
@@ -1340,6 +1341,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, s=
truct iov_iter *to)
 				return -ENOMEM;
 		}
=20
+		__ceph_caps_metric(ci, CEPH_STAT_CAP_INLINE_DATA);
 		statret =3D __ceph_do_getattr(inode, page,
 					    CEPH_STAT_CAP_INLINE_DATA, !!page);
 		if (statret < 0) {
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a24fd00676b8..141c1c03636c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -558,6 +558,8 @@ void ceph_put_mds_session(struct ceph_mds_session *s)
 	if (refcount_dec_and_test(&s->s_ref)) {
 		if (s->s_auth.authorizer)
 			ceph_auth_destroy_authorizer(s->s_auth.authorizer);
+		percpu_counter_destroy(&s->i_caps_hit);
+		percpu_counter_destroy(&s->i_caps_mis);
 		kfree(s);
 	}
 }
@@ -598,6 +600,7 @@ static struct ceph_mds_session *register_session(stru=
ct ceph_mds_client *mdsc,
 						 int mds)
 {
 	struct ceph_mds_session *s;
+	int err;
=20
 	if (mds >=3D mdsc->mdsmap->possible_max_rank)
 		return ERR_PTR(-EINVAL);
@@ -612,8 +615,10 @@ static struct ceph_mds_session *register_session(str=
uct ceph_mds_client *mdsc,
=20
 		dout("%s: realloc to %d\n", __func__, newmax);
 		sa =3D kcalloc(newmax, sizeof(void *), GFP_NOFS);
-		if (!sa)
+		if (!sa) {
+			err =3D -ENOMEM;
 			goto fail_realloc;
+		}
 		if (mdsc->sessions) {
 			memcpy(sa, mdsc->sessions,
 			       mdsc->max_sessions * sizeof(void *));
@@ -653,6 +658,13 @@ static struct ceph_mds_session *register_session(str=
uct ceph_mds_client *mdsc,
=20
 	INIT_LIST_HEAD(&s->s_cap_flushing);
=20
+	err =3D percpu_counter_init(&s->i_caps_hit, 0, GFP_NOFS);
+	if (err)
+		goto fail_realloc;
+	err =3D percpu_counter_init(&s->i_caps_mis, 0, GFP_NOFS);
+	if (err)
+		goto fail_init;
+
 	mdsc->sessions[mds] =3D s;
 	atomic_inc(&mdsc->num_sessions);
 	refcount_inc(&s->s_ref);  /* one ref to sessions[], one to caller */
@@ -662,6 +674,8 @@ static struct ceph_mds_session *register_session(stru=
ct ceph_mds_client *mdsc,
=20
 	return s;
=20
+fail_init:
+	percpu_counter_destroy(&s->i_caps_hit);
 fail_realloc:
 	kfree(s);
 	return ERR_PTR(-ENOMEM);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 7c839a1183e5..7645cecf7fb0 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -201,6 +201,9 @@ struct ceph_mds_session {
=20
 	struct list_head  s_waiting;  /* waiting requests */
 	struct list_head  s_unsafe;   /* unsafe requests */
+
+	struct percpu_counter i_caps_hit;
+	struct percpu_counter i_caps_mis;
 };
=20
 /*
diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index de56dee60540..7b248f698100 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -147,9 +147,13 @@ static struct inode *lookup_quotarealm_inode(struct =
ceph_mds_client *mdsc,
 		return NULL;
 	}
 	if (qri->inode) {
+		int ret;
+
+		__ceph_caps_metric(ceph_inode(qri->inode), CEPH_STAT_CAP_INODE);
+
 		/* get caps */
-		int ret =3D __ceph_do_getattr(qri->inode, NULL,
-					    CEPH_STAT_CAP_INODE, true);
+		ret =3D __ceph_do_getattr(qri->inode, NULL,
+					CEPH_STAT_CAP_INODE, true);
 		if (ret >=3D 0)
 			in =3D qri->inode;
 		else
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 7af91628636c..7a6f9913c8f1 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -642,6 +642,7 @@ static inline bool __ceph_is_any_real_caps(struct cep=
h_inode_info *ci)
 }
=20
 extern int __ceph_caps_issued(struct ceph_inode_info *ci, int *implement=
ed);
+extern void __ceph_caps_metric(struct ceph_inode_info *ci, int mask);
 extern int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask,=
 int t);
 extern int __ceph_caps_issued_other(struct ceph_inode_info *ci,
 				    struct ceph_cap *cap);
@@ -927,6 +928,11 @@ extern int __ceph_do_getattr(struct inode *inode, st=
ruct page *locked_page,
 			     int mask, bool force);
 static inline int ceph_do_getattr(struct inode *inode, int mask, bool fo=
rce)
 {
+	struct ceph_inode_info *ci =3D ceph_inode(inode);
+
+	spin_lock(&ci->i_ceph_lock);
+	__ceph_caps_metric(ci, mask);
+	spin_unlock(&ci->i_ceph_lock);
 	return __ceph_do_getattr(inode, NULL, mask, force);
 }
 extern int ceph_permission(struct inode *inode, int mask);
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 98a9a3101cda..f3b1149ff7c5 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -829,6 +829,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const ch=
ar *name, void *value,
 	struct ceph_vxattr *vxattr =3D NULL;
 	int req_mask;
 	ssize_t err;
+	int ret =3D -1;
=20
 	/* let's see if a virtual xattr was requested */
 	vxattr =3D ceph_match_vxattr(inode, name);
@@ -856,7 +857,9 @@ ssize_t __ceph_getxattr(struct inode *inode, const ch=
ar *name, void *value,
=20
 	if (ci->i_xattrs.version =3D=3D 0 ||
 	    !((req_mask & CEPH_CAP_XATTR_SHARED) ||
-	      __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1))) {
+	      (ret =3D __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1))))=
 {
+		if (ret !=3D -1)
+			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
 		spin_unlock(&ci->i_ceph_lock);
=20
 		/* security module gets xattr while filling trace */
@@ -871,6 +874,9 @@ ssize_t __ceph_getxattr(struct inode *inode, const ch=
ar *name, void *value,
 		if (err)
 			return err;
 		spin_lock(&ci->i_ceph_lock);
+	} else {
+		if (ret !=3D -1)
+			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
 	}
=20
 	err =3D __build_xattrs(inode);
@@ -907,19 +913,24 @@ ssize_t ceph_listxattr(struct dentry *dentry, char =
*names, size_t size)
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
 	bool len_only =3D (size =3D=3D 0);
 	u32 namelen;
-	int err;
+	int err, ret =3D -1;
=20
 	spin_lock(&ci->i_ceph_lock);
 	dout("listxattr %p ver=3D%lld index_ver=3D%lld\n", inode,
 	     ci->i_xattrs.version, ci->i_xattrs.index_version);
=20
 	if (ci->i_xattrs.version =3D=3D 0 ||
-	    !__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1)) {
+	    !(ret =3D __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1))) {
+		if (ret !=3D -1)
+			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
 		spin_unlock(&ci->i_ceph_lock);
 		err =3D ceph_do_getattr(inode, CEPH_STAT_CAP_XATTR, true);
 		if (err)
 			return err;
 		spin_lock(&ci->i_ceph_lock);
+	} else {
+		if (ret !=3D -1)
+			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
 	}
=20
 	err =3D __build_xattrs(inode);
--=20
2.21.0


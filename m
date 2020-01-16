Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427ED13D815
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Jan 2020 11:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgAPKjC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Jan 2020 05:39:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58227 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725800AbgAPKjB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 16 Jan 2020 05:39:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579171139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3DpaiHybq/mDJdOJRa6ck4kmfMjNKlKdJFR2TYXL9Is=;
        b=gFYnvoXaLc1b/yWzfSwpqXQdRpLqbmAZFUXmvp9aBQ9pLAuv0jMDypBiQ6oGDh7tspSBen
        4rspDoNZsh+0fmbTplGmeVPRpOI4LQSkR+Jua1J4LgGTzdqROf7kCgi1rkeYspqZL8uhAz
        hGPhtHUNwAJOamQALPMUInbgwzVPVgE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-PWFOtjyzOOmtJJcwIDHBUw-1; Thu, 16 Jan 2020 05:38:56 -0500
X-MC-Unique: PWFOtjyzOOmtJJcwIDHBUw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9384190D340;
        Thu, 16 Jan 2020 10:38:55 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-49.pek2.redhat.com [10.72.12.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3716F60C63;
        Thu, 16 Jan 2020 10:38:50 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 2/8] ceph: add caps perf metric for each session
Date:   Thu, 16 Jan 2020 05:38:24 -0500
Message-Id: <20200116103830.13591-3-xiubli@redhat.com>
In-Reply-To: <20200116103830.13591-1-xiubli@redhat.com>
References: <20200116103830.13591-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
 fs/ceph/addr.c       |  2 ++
 fs/ceph/caps.c       | 74 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/debugfs.c    | 20 ++++++++++++
 fs/ceph/dir.c        |  9 ++++--
 fs/ceph/file.c       |  3 ++
 fs/ceph/mds_client.c | 16 +++++++++-
 fs/ceph/mds_client.h |  3 ++
 fs/ceph/quota.c      |  9 ++++--
 fs/ceph/super.h      | 11 +++++++
 fs/ceph/xattr.c      | 17 ++++++++--
 11 files changed, 158 insertions(+), 8 deletions(-)

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
index 7ab616601141..29d4513eff8c 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1706,6 +1706,8 @@ int ceph_uninline_data(struct file *filp, struct pa=
ge *locked_page)
 			err =3D -ENOMEM;
 			goto out;
 		}
+
+		ceph_caps_metric(ci, CEPH_STAT_CAP_INLINE_DATA);
 		err =3D __ceph_do_getattr(inode, page,
 					CEPH_STAT_CAP_INLINE_DATA, true);
 		if (err < 0) {
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 7fc87b693ba4..af2e9e826f8c 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -783,6 +783,75 @@ static int __cap_is_valid(struct ceph_cap *cap)
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
+	lockdep_assert_held(&ci->i_ceph_lock);
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
@@ -2746,6 +2815,7 @@ static void check_max_size(struct inode *inode, lof=
f_t endoff)
 int ceph_try_get_caps(struct inode *inode, int need, int want,
 		      bool nonblock, int *got)
 {
+	struct ceph_inode_info *ci =3D ceph_inode(inode);
 	int ret;
=20
 	BUG_ON(need & ~CEPH_CAP_FILE_RD);
@@ -2758,6 +2828,7 @@ int ceph_try_get_caps(struct inode *inode, int need=
, int want,
 	BUG_ON(want & ~(CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO |
 			CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL |
 			CEPH_CAP_ANY_DIR_OPS));
+	ceph_caps_metric(ci, need | want);
 	ret =3D try_get_cap_refs(inode, need, want, 0, nonblock, got);
 	return ret =3D=3D -EAGAIN ? 0 : ret;
 }
@@ -2784,6 +2855,8 @@ int ceph_get_caps(struct file *filp, int need, int =
want,
 	    fi->filp_gen !=3D READ_ONCE(fsc->filp_gen))
 		return -EBADF;
=20
+	ceph_caps_metric(ci, need | want);
+
 	while (true) {
 		if (endoff > 0)
 			check_max_size(inode, endoff);
@@ -2871,6 +2944,7 @@ int ceph_get_caps(struct file *filp, int need, int =
want,
 			 * getattr request will bring inline data into
 			 * page cache
 			 */
+			ceph_caps_metric(ci, CEPH_STAT_CAP_INLINE_DATA);
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
index 658c55b323cc..33eb239e09e2 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -313,7 +313,7 @@ static int ceph_readdir(struct file *file, struct dir=
_context *ctx)
 	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
 	struct ceph_mds_client *mdsc =3D fsc->mdsc;
 	int i;
-	int err;
+	int err, ret =3D -1;
 	unsigned frag =3D -1;
 	struct ceph_mds_reply_info_parsed *rinfo;
=20
@@ -346,13 +346,16 @@ static int ceph_readdir(struct file *file, struct d=
ir_context *ctx)
 	    !ceph_test_mount_opt(fsc, NOASYNCREADDIR) &&
 	    ceph_snap(inode) !=3D CEPH_SNAPDIR &&
 	    __ceph_dir_is_complete_ordered(ci) &&
-	    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1)) {
+	    (ret =3D __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1))) {
 		int shared_gen =3D atomic_read(&ci->i_shared_gen);
+		__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
 		spin_unlock(&ci->i_ceph_lock);
 		err =3D __dcache_readdir(file, ctx, shared_gen);
 		if (err !=3D -EAGAIN)
 			return err;
 	} else {
+		if (ret !=3D -1)
+			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
 		spin_unlock(&ci->i_ceph_lock);
 	}
=20
@@ -757,6 +760,8 @@ static struct dentry *ceph_lookup(struct inode *dir, =
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
index 1e6cdf2dfe90..c78dfbbb7b91 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -384,6 +384,8 @@ int ceph_open(struct inode *inode, struct file *file)
 	 * asynchronously.
 	 */
 	spin_lock(&ci->i_ceph_lock);
+	__ceph_caps_metric(ci, wanted);
+
 	if (__ceph_is_any_real_caps(ci) &&
 	    (((fmode & CEPH_FILE_MODE_WR) =3D=3D 0) || ci->i_auth_cap)) {
 		int mds_wanted =3D __ceph_caps_mds_wanted(ci, true);
@@ -1340,6 +1342,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, s=
truct iov_iter *to)
 				return -ENOMEM;
 		}
=20
+		ceph_caps_metric(ci, CEPH_STAT_CAP_INLINE_DATA);
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
index dd1f417b90eb..ba74ff74c59c 100644
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
index de56dee60540..4ce2f658e63d 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -147,9 +147,14 @@ static struct inode *lookup_quotarealm_inode(struct =
ceph_mds_client *mdsc,
 		return NULL;
 	}
 	if (qri->inode) {
+		struct ceph_inode_info *ci =3D ceph_inode(qri->inode);
+		int ret;
+
+		ceph_caps_metric(ci, CEPH_STAT_CAP_INODE);
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
index 7af91628636c..3f4829222528 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -641,6 +641,14 @@ static inline bool __ceph_is_any_real_caps(struct ce=
ph_inode_info *ci)
 	return !RB_EMPTY_ROOT(&ci->i_caps);
 }
=20
+extern void __ceph_caps_metric(struct ceph_inode_info *ci, int mask);
+static inline void ceph_caps_metric(struct ceph_inode_info *ci, int mask=
)
+{
+	spin_lock(&ci->i_ceph_lock);
+	__ceph_caps_metric(ci, mask);
+	spin_unlock(&ci->i_ceph_lock);
+}
+
 extern int __ceph_caps_issued(struct ceph_inode_info *ci, int *implement=
ed);
 extern int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask,=
 int t);
 extern int __ceph_caps_issued_other(struct ceph_inode_info *ci,
@@ -927,6 +935,9 @@ extern int __ceph_do_getattr(struct inode *inode, str=
uct page *locked_page,
 			     int mask, bool force);
 static inline int ceph_do_getattr(struct inode *inode, int mask, bool fo=
rce)
 {
+	struct ceph_inode_info *ci =3D ceph_inode(inode);
+
+	ceph_caps_metric(ci, mask);
 	return __ceph_do_getattr(inode, NULL, mask, force);
 }
 extern int ceph_permission(struct inode *inode, int mask);
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index d58fa14c1f01..ebd522edb0a8 100644
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


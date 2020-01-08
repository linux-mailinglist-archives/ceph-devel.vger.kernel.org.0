Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91746133F78
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jan 2020 11:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgAHKmU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jan 2020 05:42:20 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26420 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726466AbgAHKmU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jan 2020 05:42:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578480138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mf1rufS6tx62RIKFwfQtuqkABNQotMZMxCMMI0FBD18=;
        b=Ci+qwExI0PDkxU5bZMzuXfPiPOnClNGNwCpMsSpobc+DRqp3p4SpsZGEhiuH1OYJiYEsKP
        XewgTF+/oc4BNnAprTCr+rhrnLoWw2CttRR96EX07TG91Sy/QCgvw6VkXe8I1aR7+s66GO
        MtG5UeV+ulLO2ytzQ3iLCx4liQATdKk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-VFyqs1deMAeHZT60VhxZnw-1; Wed, 08 Jan 2020 05:42:16 -0500
X-MC-Unique: VFyqs1deMAeHZT60VhxZnw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 831568C8B40;
        Wed,  8 Jan 2020 10:42:15 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-70.pek2.redhat.com [10.72.12.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC77919C58;
        Wed,  8 Jan 2020 10:42:12 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 2/8] ceph: add caps perf metric for each session
Date:   Wed,  8 Jan 2020 05:41:46 -0500
Message-Id: <20200108104152.28468-3-xiubli@redhat.com>
In-Reply-To: <20200108104152.28468-1-xiubli@redhat.com>
References: <20200108104152.28468-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

Fixes: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/acl.c        |  2 +-
 fs/ceph/caps.c       | 63 +++++++++++++++++++++++++++++++++++---------
 fs/ceph/debugfs.c    | 20 ++++++++++++++
 fs/ceph/dir.c        | 20 +++++++-------
 fs/ceph/file.c       |  6 ++---
 fs/ceph/inode.c      |  8 +++---
 fs/ceph/mds_client.c | 16 ++++++++++-
 fs/ceph/mds_client.h |  3 +++
 fs/ceph/snap.c       |  2 +-
 fs/ceph/super.h      | 12 +++++----
 fs/ceph/xattr.c      |  8 +++---
 11 files changed, 120 insertions(+), 40 deletions(-)

diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index 26be6520d3fb..fca6ff231020 100644
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
index 28ae0c134700..6ab02aab7d9c 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -567,7 +567,7 @@ static void __cap_delay_cancel(struct ceph_mds_client=
 *mdsc,
 static void __check_cap_issue(struct ceph_inode_info *ci, struct ceph_ca=
p *cap,
 			      unsigned issued)
 {
-	unsigned had =3D __ceph_caps_issued(ci, NULL);
+	unsigned int had =3D __ceph_caps_issued(ci, NULL, -1);
=20
 	/*
 	 * Each time we receive FILE_CACHE anew, we increment
@@ -787,20 +787,43 @@ static int __cap_is_valid(struct ceph_cap *cap)
  * out, and may be invalidated in bulk if the client session times out
  * and session->s_cap_gen is bumped.
  */
-int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented)
+int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented, int=
 mask)
 {
 	int have =3D ci->i_snap_caps;
 	struct ceph_cap *cap;
 	struct rb_node *p;
+	int revoking =3D 0;
+
+	if (ci->i_auth_cap) {
+		cap =3D ci->i_auth_cap;
+		revoking =3D cap->implemented & ~cap->issued;
+	}
=20
 	if (implemented)
 		*implemented =3D 0;
 	for (p =3D rb_first(&ci->i_caps); p; p =3D rb_next(p)) {
+		struct ceph_mds_session *s;
+		int r =3D 0;
+
 		cap =3D rb_entry(p, struct ceph_cap, ci_node);
 		if (!__cap_is_valid(cap))
 			continue;
 		dout("__ceph_caps_issued %p cap %p issued %s\n",
 		     &ci->vfs_inode, cap, ceph_cap_string(cap->issued));
+
+		if (mask >=3D 0) {
+			s =3D ceph_get_mds_session(cap->session);
+			if (cap =3D=3D ci->i_auth_cap)
+				r =3D revoking;
+			if (s) {
+				if (mask & (cap->issued & ~r))
+					percpu_counter_inc(&s->i_caps_hit);
+				else
+					percpu_counter_inc(&s->i_caps_mis);
+				ceph_put_mds_session(s);
+			}
+		}
+
 		have |=3D cap->issued;
 		if (implemented)
 			*implemented |=3D cap->implemented;
@@ -810,10 +833,8 @@ int __ceph_caps_issued(struct ceph_inode_info *ci, i=
nt *implemented)
 	 * by the auth MDS. The non-auth MDS should be revoking/exporting
 	 * these caps, but the message is delayed.
 	 */
-	if (ci->i_auth_cap) {
-		cap =3D ci->i_auth_cap;
-		have &=3D ~cap->implemented | cap->issued;
-	}
+	have &=3D ~revoking;
+
 	return have;
 }
=20
@@ -862,7 +883,8 @@ static void __touch_cap(struct ceph_cap *cap)
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
@@ -877,9 +899,13 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *=
ci, int mask, int touch)
 	}
=20
 	for (p =3D rb_first(&ci->i_caps); p; p =3D rb_next(p)) {
+		struct ceph_mds_session *s;
+
 		cap =3D rb_entry(p, struct ceph_cap, ci_node);
 		if (!__cap_is_valid(cap))
 			continue;
+
+		s =3D ceph_get_mds_session(cap->session);
 		if ((cap->issued & mask) =3D=3D mask) {
 			dout("__ceph_caps_issued_mask ino 0x%lx cap %p issued %s"
 			     " (mask %s)\n", ci->vfs_inode.i_ino, cap,
@@ -887,9 +913,22 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *=
ci, int mask, int touch)
 			     ceph_cap_string(mask));
 			if (touch)
 				__touch_cap(cap);
+			if (s) {
+				if (metric)
+					percpu_counter_inc(&s->i_caps_hit);
+				ceph_put_mds_session(s);
+			}
 			return 1;
 		}
=20
+		if (s) {
+			if (cap->issued & mask)
+				percpu_counter_inc(&s->i_caps_hit);
+			else
+				percpu_counter_inc(&s->i_caps_mis);
+			ceph_put_mds_session(s);
+		}
+
 		/* does a combination of caps satisfy mask? */
 		have |=3D cap->issued;
 		if ((have & mask) =3D=3D mask) {
@@ -1849,7 +1888,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, in=
t flags,
 retry_locked:
 	file_wanted =3D __ceph_caps_file_wanted(ci);
 	used =3D __ceph_caps_used(ci);
-	issued =3D __ceph_caps_issued(ci, &implemented);
+	issued =3D __ceph_caps_issued(ci, &implemented, -1);
 	revoking =3D implemented & ~issued;
=20
 	want =3D file_wanted;
@@ -2577,7 +2616,7 @@ static int try_get_cap_refs(struct inode *inode, in=
t need, int want,
 		spin_lock(&ci->i_ceph_lock);
 	}
=20
-	have =3D __ceph_caps_issued(ci, &implemented);
+	have =3D __ceph_caps_issued(ci, &implemented, need);
=20
 	if (have & need & CEPH_CAP_FILE_WR) {
 		if (endoff >=3D 0 && endoff > (loff_t)ci->i_max_size) {
@@ -3563,7 +3602,7 @@ static void handle_cap_trunc(struct inode *inode,
 	u64 size =3D le64_to_cpu(trunc->size);
 	int implemented =3D 0;
 	int dirty =3D __ceph_caps_dirty(ci);
-	int issued =3D __ceph_caps_issued(ceph_inode(inode), &implemented);
+	int issued =3D __ceph_caps_issued(ceph_inode(inode), &implemented, -1);
 	int queue_trunc =3D 0;
=20
 	issued |=3D implemented | dirty;
@@ -3770,7 +3809,7 @@ static void handle_cap_import(struct ceph_mds_clien=
t *mdsc,
 		}
 	}
=20
-	__ceph_caps_issued(ci, &issued);
+	__ceph_caps_issued(ci, &issued, -1);
 	issued |=3D __ceph_caps_dirty(ci);
=20
 	ceph_add_cap(inode, session, cap_id, -1, caps, wanted, seq, mseq,
@@ -3996,7 +4035,7 @@ void ceph_handle_caps(struct ceph_mds_session *sess=
ion,
 	switch (op) {
 	case CEPH_CAP_OP_REVOKE:
 	case CEPH_CAP_OP_GRANT:
-		__ceph_caps_issued(ci, &extra_info.issued);
+		__ceph_caps_issued(ci, &extra_info.issued, -1);
 		extra_info.issued |=3D __ceph_caps_dirty(ci);
 		handle_cap_grant(inode, session, cap,
 				 h, msg->middle, &extra_info);
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
index 382beb04bacb..1e1ccae8953d 100644
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
@@ -346,7 +346,7 @@ static int ceph_readdir(struct file *file, struct dir=
_context *ctx)
 	    !ceph_test_mount_opt(fsc, NOASYNCREADDIR) &&
 	    ceph_snap(inode) !=3D CEPH_SNAPDIR &&
 	    __ceph_dir_is_complete_ordered(ci) &&
-	    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1)) {
+	    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1, true)) {
 		int shared_gen =3D atomic_read(&ci->i_shared_gen);
 		spin_unlock(&ci->i_ceph_lock);
 		err =3D __dcache_readdir(file, ctx, shared_gen);
@@ -764,7 +764,8 @@ static struct dentry *ceph_lookup(struct inode *dir, =
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
@@ -1341,7 +1342,7 @@ static int __dentry_lease_check(struct dentry *dent=
ry, void *arg)
=20
 	if (__dentry_lease_is_valid(di))
 		return STOP;
-	ret =3D __dir_lease_try_check(dentry);
+	ret =3D __dir_lease_try_check(dentry, false);
 	if (ret =3D=3D -EBUSY)
 		return KEEP;
 	if (ret > 0)
@@ -1354,7 +1355,7 @@ static int __dir_lease_check(struct dentry *dentry,=
 void *arg)
 	struct ceph_lease_walk_control *lwc =3D arg;
 	struct ceph_dentry_info *di =3D ceph_dentry(dentry);
=20
-	int ret =3D __dir_lease_try_check(dentry);
+	int ret =3D __dir_lease_try_check(dentry, false);
 	if (ret =3D=3D -EBUSY)
 		return KEEP;
 	if (ret > 0) {
@@ -1493,7 +1494,7 @@ static int dentry_lease_is_valid(struct dentry *den=
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
@@ -1510,7 +1511,8 @@ static int __dir_lease_try_check(const struct dentr=
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
@@ -1532,7 +1534,7 @@ static int dir_lease_is_valid(struct inode *dir, st=
ruct dentry *dentry)
 	int shared_gen;
=20
 	spin_lock(&ci->i_ceph_lock);
-	valid =3D __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1);
+	valid =3D __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1, true);
 	shared_gen =3D atomic_read(&ci->i_shared_gen);
 	spin_unlock(&ci->i_ceph_lock);
 	if (valid) {
@@ -1670,7 +1672,7 @@ static int ceph_d_delete(const struct dentry *dentr=
y)
 	if (di) {
 		if (__dentry_lease_is_valid(di))
 			return 0;
-		if (__dir_lease_try_check(dentry))
+		if (__dir_lease_try_check(dentry, true))
 			return 0;
 	}
 	return 1;
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 11929d2bb594..418c7b30c6db 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -296,7 +296,7 @@ int ceph_renew_caps(struct inode *inode)
 	wanted =3D __ceph_caps_file_wanted(ci);
 	if (__ceph_is_any_real_caps(ci) &&
 	    (!(wanted & CEPH_CAP_ANY_WR) || ci->i_auth_cap)) {
-		int issued =3D __ceph_caps_issued(ci, NULL);
+		int issued =3D __ceph_caps_issued(ci, NULL, -1);
 		spin_unlock(&ci->i_ceph_lock);
 		dout("renew caps %p want %s issued %s updating mds_wanted\n",
 		     inode, ceph_cap_string(wanted), ceph_cap_string(issued));
@@ -387,7 +387,7 @@ int ceph_open(struct inode *inode, struct file *file)
 	if (__ceph_is_any_real_caps(ci) &&
 	    (((fmode & CEPH_FILE_MODE_WR) =3D=3D 0) || ci->i_auth_cap)) {
 		int mds_wanted =3D __ceph_caps_mds_wanted(ci, true);
-		int issued =3D __ceph_caps_issued(ci, NULL);
+		int issued =3D __ceph_caps_issued(ci, NULL, fmode);
=20
 		dout("open %p fmode %d want %s issued %s using existing\n",
 		     inode, fmode, ceph_cap_string(wanted),
@@ -403,7 +403,7 @@ int ceph_open(struct inode *inode, struct file *file)
=20
 		return ceph_init_file(inode, file, fmode);
 	} else if (ceph_snap(inode) !=3D CEPH_NOSNAP &&
-		   (ci->i_snap_caps & wanted) =3D=3D wanted) {
+			(ci->i_snap_caps & wanted) =3D=3D wanted) {
 		__ceph_get_fmode(ci, fmode);
 		spin_unlock(&ci->i_ceph_lock);
 		return ceph_init_file(inode, file, fmode);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 64634c5af403..c0108b8582c3 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -798,7 +798,7 @@ static int fill_inode(struct inode *inode, struct pag=
e *locked_page,
 	/* Update change_attribute */
 	inode_set_max_iversion_raw(inode, iinfo->change_attr);
=20
-	__ceph_caps_issued(ci, &issued);
+	__ceph_caps_issued(ci, &issued, -1);
 	issued |=3D __ceph_caps_dirty(ci);
 	new_issued =3D ~issued & info_caps;
=20
@@ -2029,7 +2029,7 @@ int __ceph_setattr(struct inode *inode, struct iatt=
r *attr)
 	}
=20
 	spin_lock(&ci->i_ceph_lock);
-	issued =3D __ceph_caps_issued(ci, NULL);
+	issued =3D __ceph_caps_issued(ci, NULL, -1);
=20
 	if (!ci->i_head_snapc &&
 	    (issued & (CEPH_CAP_ANY_EXCL | CEPH_CAP_FILE_WR))) {
@@ -2038,7 +2038,7 @@ int __ceph_setattr(struct inode *inode, struct iatt=
r *attr)
 			spin_unlock(&ci->i_ceph_lock);
 			down_read(&mdsc->snap_rwsem);
 			spin_lock(&ci->i_ceph_lock);
-			issued =3D __ceph_caps_issued(ci, NULL);
+			issued =3D __ceph_caps_issued(ci, NULL, -1);
 		}
 	}
=20
@@ -2269,7 +2269,7 @@ int __ceph_do_getattr(struct inode *inode, struct p=
age *locked_page,
=20
 	dout("do_getattr inode %p mask %s mode 0%o\n",
 	     inode, ceph_cap_string(mask), inode->i_mode);
-	if (!force && ceph_caps_issued_mask(ceph_inode(inode), mask, 1))
+	if (!force && ceph_caps_issued_mask(ceph_inode(inode), mask, 1, true))
 		return 0;
=20
 	mode =3D (mask & CEPH_STAT_RSTAT) ? USE_AUTH_MDS : USE_ANY_MDS;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a976febf9647..606fa8cd687f 100644
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
index 22186060bc37..c8935fd0d8bb 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -201,6 +201,9 @@ struct ceph_mds_session {
 	refcount_t        s_ref;
 	struct list_head  s_waiting;  /* waiting requests */
 	struct list_head  s_unsafe;   /* unsafe requests */
+
+	struct percpu_counter i_caps_hit;
+	struct percpu_counter i_caps_mis;
 };
=20
 /*
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index ccfcc66aaf44..3d34af145f81 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -534,7 +534,7 @@ void ceph_queue_cap_snap(struct ceph_inode_info *ci)
 	INIT_LIST_HEAD(&capsnap->ci_item);
=20
 	capsnap->follows =3D old_snapc->seq;
-	capsnap->issued =3D __ceph_caps_issued(ci, NULL);
+	capsnap->issued =3D __ceph_caps_issued(ci, NULL, -1);
 	capsnap->dirty =3D dirty;
=20
 	capsnap->mode =3D inode->i_mode;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 40703588b889..88da9e21af75 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -635,8 +635,10 @@ static inline bool __ceph_is_any_real_caps(struct ce=
ph_inode_info *ci)
 	return !RB_EMPTY_ROOT(&ci->i_caps);
 }
=20
-extern int __ceph_caps_issued(struct ceph_inode_info *ci, int *implement=
ed);
-extern int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask,=
 int t);
+extern int __ceph_caps_issued(struct ceph_inode_info *ci, int *implement=
ed,
+			      int mask);
+extern int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask,=
 int t,
+				   bool metric);
 extern int __ceph_caps_issued_other(struct ceph_inode_info *ci,
 				    struct ceph_cap *cap);
=20
@@ -644,17 +646,17 @@ static inline int ceph_caps_issued(struct ceph_inod=
e_info *ci)
 {
 	int issued;
 	spin_lock(&ci->i_ceph_lock);
-	issued =3D __ceph_caps_issued(ci, NULL);
+	issued =3D __ceph_caps_issued(ci, NULL, -1);
 	spin_unlock(&ci->i_ceph_lock);
 	return issued;
 }
=20
 static inline int ceph_caps_issued_mask(struct ceph_inode_info *ci, int =
mask,
-					int touch)
+					int touch, bool metric)
 {
 	int r;
 	spin_lock(&ci->i_ceph_lock);
-	r =3D __ceph_caps_issued_mask(ci, mask, touch);
+	r =3D __ceph_caps_issued_mask(ci, mask, touch, metric);
 	spin_unlock(&ci->i_ceph_lock);
 	return r;
 }
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 98a9a3101cda..aa9ee2c2d8f3 100644
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
@@ -1064,7 +1064,7 @@ int __ceph_setxattr(struct inode *inode, const char=
 *name,
=20
 	spin_lock(&ci->i_ceph_lock);
 retry:
-	issued =3D __ceph_caps_issued(ci, NULL);
+	issued =3D __ceph_caps_issued(ci, NULL, -1);
 	if (ci->i_xattrs.version =3D=3D 0 || !(issued & CEPH_CAP_XATTR_EXCL))
 		goto do_sync;
=20
@@ -1192,7 +1192,7 @@ bool ceph_security_xattr_deadlock(struct inode *in)
 	spin_lock(&ci->i_ceph_lock);
 	ret =3D !(ci->i_ceph_flags & CEPH_I_SEC_INITED) &&
 	      !(ci->i_xattrs.version > 0 &&
-		__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0));
+		__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0, true));
 	spin_unlock(&ci->i_ceph_lock);
 	return ret;
 }
--=20
2.21.0


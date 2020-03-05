Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E19AC17A527
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Mar 2020 13:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgCEMVU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Mar 2020 07:21:20 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25583 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725880AbgCEMVT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Mar 2020 07:21:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583410877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S8a58eYbXMW6qxdDPLt0k+J2+Cb+IyG4V1/NFuVLOMg=;
        b=WOQQkIvZ0Q37t41gF/mjB8pg1nPEQWwCuOFDI/1mZV2zAQ5FyCcGbuJiftxFh73gEBFjXp
        C2GjggZlWF55YSOrP2Gt0qiMJJfMB5RD01Hkr6HJBCqGSlZrUrr+IA2ns8vLCf41KDg7hB
        5WQavZPBB3ZO5zcCKh7ZreXLf5gzqYU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-3ZYyA_HnPFufHyNCK924XQ-1; Thu, 05 Mar 2020 07:21:15 -0500
X-MC-Unique: 3ZYyA_HnPFufHyNCK924XQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A47D6DBAA;
        Thu,  5 Mar 2020 12:21:14 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-47.pek2.redhat.com [10.72.12.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F15B1CB;
        Thu,  5 Mar 2020 12:21:12 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH v5 2/7] ceph: consider inode's last read/write when calculating wanted caps
Date:   Thu,  5 Mar 2020 20:21:00 +0800
Message-Id: <20200305122105.69184-3-zyan@redhat.com>
In-Reply-To: <20200305122105.69184-1-zyan@redhat.com>
References: <20200305122105.69184-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add i_last_rd and i_last_wr to ceph_inode_info. These fields are
used to track the last time the client acquired read/write caps for
the inode.

If there is no read/write on an inode for 'caps_wanted_delay_max'
seconds, __ceph_caps_file_wanted() does not request caps for read/write
even there are open files.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c               | 163 ++++++++++++++++++++++++-----------
 fs/ceph/file.c               |  21 +++--
 fs/ceph/inode.c              |  10 ++-
 fs/ceph/ioctl.c              |   2 +
 fs/ceph/super.h              |  13 ++-
 include/linux/ceph/ceph_fs.h |   1 +
 6 files changed, 147 insertions(+), 63 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index a75e5eb3740e..464f3b78637a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -978,19 +978,51 @@ int __ceph_caps_used(struct ceph_inode_info *ci)
 	return used;
 }
=20
+#define FMODE_WAIT_BIAS 1000
+
 /*
  * wanted, by virtue of open file modes
  */
 int __ceph_caps_file_wanted(struct ceph_inode_info *ci)
 {
-	int i, bits =3D 0;
-	for (i =3D 0; i < CEPH_FILE_MODE_BITS; i++) {
-		if (ci->i_nr_by_mode[i])
-			bits |=3D 1 << i;
+	const int PIN_SHIFT =3D ffs(CEPH_FILE_MODE_PIN);
+	const int RD_SHIFT =3D ffs(CEPH_FILE_MODE_RD);
+	const int WR_SHIFT =3D ffs(CEPH_FILE_MODE_WR);
+	const int LAZY_SHIFT =3D ffs(CEPH_FILE_MODE_LAZY);
+	struct ceph_mount_options *opt =3D
+		ceph_inode_to_client(&ci->vfs_inode)->mount_options;
+	unsigned long used_cutoff =3D jiffies - opt->caps_wanted_delay_max * HZ=
;
+	unsigned long idle_cutoff =3D jiffies - opt->caps_wanted_delay_min * HZ=
;
+	int bits =3D 0;
+
+	if (S_ISDIR(ci->vfs_inode.i_mode)) {
+		if (ci->i_nr_by_mode[PIN_SHIFT] > 0)
+			bits |=3D 1 << PIN_SHIFT;
+	} else {
+		if (ci->i_nr_by_mode[RD_SHIFT] > 0) {
+			if (ci->i_nr_by_mode[RD_SHIFT] >=3D FMODE_WAIT_BIAS ||
+			    time_after(ci->i_last_rd, used_cutoff))
+				bits |=3D 1 << RD_SHIFT;
+		} else if (time_after(ci->i_last_rd, idle_cutoff)) {
+			bits |=3D 1 << RD_SHIFT;
+		}
+
+		if (ci->i_nr_by_mode[WR_SHIFT] > 0) {
+			if (ci->i_nr_by_mode[WR_SHIFT] >=3D FMODE_WAIT_BIAS ||
+			    time_after(ci->i_last_wr, used_cutoff))
+				bits |=3D 1 << WR_SHIFT;
+		} else if (time_after(ci->i_last_wr, idle_cutoff)) {
+			bits |=3D 1 << WR_SHIFT;
+		}
+
+		/* check lazyio only when read/write is wanted */
+		if ((bits & (CEPH_FILE_MODE_RDWR << 1)) &&
+		    ci->i_nr_by_mode[LAZY_SHIFT] > 0)
+			bits |=3D 1 << LAZY_SHIFT;
+	=09
 	}
-	if (bits =3D=3D 0)
-		return 0;
-	return ceph_caps_for_mode(bits >> 1);
+
+	return bits ? ceph_caps_for_mode(bits >> 1) : 0;
 }
=20
 /*
@@ -1032,14 +1064,6 @@ int __ceph_caps_mds_wanted(struct ceph_inode_info =
*ci, bool check)
 	return mds_wanted;
 }
=20
-/*
- * called under i_ceph_lock
- */
-static int __ceph_is_single_caps(struct ceph_inode_info *ci)
-{
-	return rb_first(&ci->i_caps) =3D=3D rb_last(&ci->i_caps);
-}
-
 int ceph_is_any_caps(struct inode *inode)
 {
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
@@ -1877,10 +1901,6 @@ void ceph_check_caps(struct ceph_inode_info *ci, i=
nt flags,
 	if (ci->i_ceph_flags & CEPH_I_FLUSH)
 		flags |=3D CHECK_CAPS_FLUSH;
=20
-	if (!(flags & CHECK_CAPS_AUTHONLY) ||
-	    (ci->i_auth_cap && __ceph_is_single_caps(ci)))
-		__cap_delay_cancel(mdsc, ci);
-
 	goto retry_locked;
 retry:
 	spin_lock(&ci->i_ceph_lock);
@@ -2105,9 +2125,17 @@ void ceph_check_caps(struct ceph_inode_info *ci, i=
nt flags,
 		goto retry; /* retake i_ceph_lock and restart our cap scan. */
 	}
=20
-	/* Reschedule delayed caps release if we delayed anything */
-	if (delayed)
-		__cap_delay_requeue(mdsc, ci, false);
+	if (list_empty(&ci->i_cap_delay_list)) {
+	    if (delayed) {
+		    /* Reschedule delayed caps release if we delayed anything */
+		    __cap_delay_requeue(mdsc, ci, false);
+	    } else if (__ceph_is_any_real_caps(ci) &&
+			(file_wanted & ~CEPH_CAP_PIN) &&
+			!(used & (CEPH_CAP_FILE_RD | CEPH_CAP_ANY_FILE_WR))) {
+		    /* periodically re-calculate caps wanted by open files */
+		    __cap_delay_requeue(mdsc, ci, true);
+	    }
+	}
=20
 	spin_unlock(&ci->i_ceph_lock);
=20
@@ -2573,8 +2601,9 @@ void ceph_take_cap_refs(struct ceph_inode_info *ci,=
 int got,
  * FIXME: how does a 0 return differ from -EAGAIN?
  */
 enum {
-	NON_BLOCKING	=3D 1,
-	CHECK_FILELOCK	=3D 2,
+	/* first 8 bits are reserved for CEPH_FILE_MODE_FOO */
+	NON_BLOCKING	=3D (1 << 8),
+	CHECK_FILELOCK	=3D (1 << 9),
 };
=20
 static int try_get_cap_refs(struct inode *inode, int need, int want,
@@ -2584,7 +2613,6 @@ static int try_get_cap_refs(struct inode *inode, in=
t need, int want,
 	struct ceph_mds_client *mdsc =3D ceph_inode_to_client(inode)->mdsc;
 	int ret =3D 0;
 	int have, implemented;
-	int file_wanted;
 	bool snap_rwsem_locked =3D false;
=20
 	dout("get_cap_refs %p need %s want %s\n", inode,
@@ -2600,15 +2628,6 @@ static int try_get_cap_refs(struct inode *inode, i=
nt need, int want,
 		goto out_unlock;
 	}
=20
-	/* make sure file is actually open */
-	file_wanted =3D __ceph_caps_file_wanted(ci);
-	if ((file_wanted & need) !=3D need) {
-		dout("try_get_cap_refs need %s file_wanted %s, EBADF\n",
-		     ceph_cap_string(need), ceph_cap_string(file_wanted));
-		ret =3D -EBADF;
-		goto out_unlock;
-	}
-
 	/* finish pending truncate */
 	while (ci->i_truncate_pending) {
 		spin_unlock(&ci->i_ceph_lock);
@@ -2719,6 +2738,9 @@ static int try_get_cap_refs(struct inode *inode, in=
t need, int want,
 		     ceph_cap_string(have), ceph_cap_string(need));
 	}
 out_unlock:
+
+	__ceph_touch_fmode(ci, mdsc, flags);
+
 	spin_unlock(&ci->i_ceph_lock);
 	if (snap_rwsem_locked)
 		up_read(&mdsc->snap_rwsem);
@@ -2756,10 +2778,20 @@ static void check_max_size(struct inode *inode, l=
off_t endoff)
 		ceph_check_caps(ci, CHECK_CAPS_AUTHONLY, NULL);
 }
=20
+static inline int get_used_fmode(int caps)
+{
+	int fmode =3D 0;
+	if (caps & CEPH_CAP_FILE_RD)
+		fmode |=3D CEPH_FILE_MODE_RD;
+	if (caps & CEPH_CAP_FILE_WR)
+		fmode |=3D CEPH_FILE_MODE_WR;
+	return fmode;
+}
+
 int ceph_try_get_caps(struct inode *inode, int need, int want,
 		      bool nonblock, int *got)
 {
-	int ret;
+	int ret, flags;
=20
 	BUG_ON(need & ~CEPH_CAP_FILE_RD);
 	BUG_ON(want & ~(CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO |
@@ -2771,8 +2803,11 @@ int ceph_try_get_caps(struct inode *inode, int nee=
d, int want,
 			return ret;
 	}
=20
-	ret =3D try_get_cap_refs(inode, need, want, 0,
-			       (nonblock ? NON_BLOCKING : 0), got);
+	flags =3D get_used_fmode(need | want);
+	if (nonblock)
+		flags |=3D NON_BLOCKING;
+
+	ret =3D try_get_cap_refs(inode, need, want, 0, flags, got);
 	return ret =3D=3D -EAGAIN ? 0 : ret;
 }
=20
@@ -2798,11 +2833,15 @@ int ceph_get_caps(struct file *filp, int need, in=
t want,
 	    fi->filp_gen !=3D READ_ONCE(fsc->filp_gen))
 		return -EBADF;
=20
+	flags =3D get_used_fmode(need | want);
+
 	while (true) {
 		if (endoff > 0)
 			check_max_size(inode, endoff);
=20
-		flags =3D atomic_read(&fi->num_locks) ? CHECK_FILELOCK : 0;
+		flags &=3D CEPH_FILE_MODE_MASK;
+		if (atomic_read(&fi->num_locks))
+			flags |=3D CHECK_FILELOCK;
 		_got =3D 0;
 		ret =3D try_get_cap_refs(inode, need, want, endoff,
 				       flags, &_got);
@@ -2822,6 +2861,8 @@ int ceph_get_caps(struct file *filp, int need, int =
want,
 			list_add(&cw.list, &mdsc->cap_wait_list);
 			spin_unlock(&mdsc->caps_list_lock);
=20
+			/* make sure used fmode not timeout */
+			ceph_get_fmode(ci, flags, FMODE_WAIT_BIAS);
 			add_wait_queue(&ci->i_cap_wq, &wait);
=20
 			flags |=3D NON_BLOCKING;
@@ -2835,6 +2876,7 @@ int ceph_get_caps(struct file *filp, int need, int =
want,
 			}
=20
 			remove_wait_queue(&ci->i_cap_wq, &wait);
+			ceph_put_fmode(ci, flags, FMODE_WAIT_BIAS);
=20
 			spin_lock(&mdsc->caps_list_lock);
 			list_del(&cw.list);
@@ -2854,7 +2896,7 @@ int ceph_get_caps(struct file *filp, int need, int =
want,
 		if (ret < 0) {
 			if (ret =3D=3D -ESTALE) {
 				/* session was killed, try renew caps */
-				ret =3D ceph_renew_caps(inode);
+				ret =3D ceph_renew_caps(inode, flags);
 				if (ret =3D=3D 0)
 					continue;
 			}
@@ -4153,6 +4195,33 @@ void ceph_flush_dirty_caps(struct ceph_mds_client =
*mdsc)
 	dout("flush_dirty_caps done\n");
 }
=20
+void __ceph_touch_fmode(struct ceph_inode_info *ci,
+			struct ceph_mds_client *mdsc, int fmode)
+{
+	unsigned long now =3D jiffies;
+	if (fmode & CEPH_FILE_MODE_RD)
+		ci->i_last_rd =3D now;
+	if (fmode & CEPH_FILE_MODE_WR)
+		ci->i_last_wr =3D now;
+	/* queue periodic check */
+	if (fmode &&
+	    __ceph_is_any_real_caps(ci) &&
+	    list_empty(&ci->i_cap_delay_list))
+		__cap_delay_requeue(mdsc, ci, true);
+}
+
+void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
+{
+	int i;
+	int bits =3D (fmode << 1) | 1;
+	spin_lock(&ci->i_ceph_lock);
+	for (i =3D 0; i < CEPH_FILE_MODE_BITS; i++) {
+		if (bits & (1 << i))
+			ci->i_nr_by_mode[i] +=3D count;
+	}
+	spin_unlock(&ci->i_ceph_lock);
+}
+
 void __ceph_get_fmode(struct ceph_inode_info *ci, int fmode)
 {
 	int i;
@@ -4168,26 +4237,18 @@ void __ceph_get_fmode(struct ceph_inode_info *ci,=
 int fmode)
  * we may need to release capabilities to the MDS (or schedule
  * their delayed release).
  */
-void ceph_put_fmode(struct ceph_inode_info *ci, int fmode)
+void ceph_put_fmode(struct ceph_inode_info *ci, int fmode, int count)
 {
-	int i, last =3D 0;
+	int i;
 	int bits =3D (fmode << 1) | 1;
 	spin_lock(&ci->i_ceph_lock);
 	for (i =3D 0; i < CEPH_FILE_MODE_BITS; i++) {
 		if (bits & (1 << i)) {
-			BUG_ON(ci->i_nr_by_mode[i] =3D=3D 0);
-			if (--ci->i_nr_by_mode[i] =3D=3D 0)
-				last++;
+			BUG_ON(ci->i_nr_by_mode[i] < count);
+			ci->i_nr_by_mode[i] -=3D count;
 		}
 	}
-	dout("put_fmode %p fmode %d {%d,%d,%d,%d}\n",
-	     &ci->vfs_inode, fmode,
-	     ci->i_nr_by_mode[0], ci->i_nr_by_mode[1],
-	     ci->i_nr_by_mode[2], ci->i_nr_by_mode[3]);
 	spin_unlock(&ci->i_ceph_lock);
-
-	if (last && ci->i_vino.snap =3D=3D CEPH_NOSNAP)
-		ceph_check_caps(ci, 0, NULL);
 }
=20
 /*
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 671b141aedfe..c39951e7e289 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -213,7 +213,7 @@ static int ceph_init_file_info(struct inode *inode, s=
truct file *file,
 		struct ceph_dir_file_info *dfi =3D
 			kmem_cache_zalloc(ceph_dir_file_cachep, GFP_KERNEL);
 		if (!dfi) {
-			ceph_put_fmode(ci, fmode); /* clean up */
+			ceph_put_fmode(ci, fmode, 1); /* clean up */
 			return -ENOMEM;
 		}
=20
@@ -224,7 +224,7 @@ static int ceph_init_file_info(struct inode *inode, s=
truct file *file,
 	} else {
 		fi =3D kmem_cache_zalloc(ceph_file_cachep, GFP_KERNEL);
 		if (!fi) {
-			ceph_put_fmode(ci, fmode); /* clean up */
+			ceph_put_fmode(ci, fmode, 1); /* clean up */
 			return -ENOMEM;
 		}
=20
@@ -263,7 +263,7 @@ static int ceph_init_file(struct inode *inode, struct=
 file *file, int fmode)
 	case S_IFLNK:
 		dout("init_file %p %p 0%o (symlink)\n", inode, file,
 		     inode->i_mode);
-		ceph_put_fmode(ceph_inode(inode), fmode); /* clean up */
+		ceph_put_fmode(ceph_inode(inode), fmode, 1); /* clean up */
 		break;
=20
 	default:
@@ -273,7 +273,7 @@ static int ceph_init_file(struct inode *inode, struct=
 file *file, int fmode)
 		 * we need to drop the open ref now, since we don't
 		 * have .release set to ceph_release.
 		 */
-		ceph_put_fmode(ceph_inode(inode), fmode); /* clean up */
+		ceph_put_fmode(ceph_inode(inode), fmode, 1); /* clean up */
 		BUG_ON(inode->i_fop->release =3D=3D ceph_release);
=20
 		/* call the proper open fop */
@@ -285,14 +285,15 @@ static int ceph_init_file(struct inode *inode, stru=
ct file *file, int fmode)
 /*
  * try renew caps after session gets killed.
  */
-int ceph_renew_caps(struct inode *inode)
+int ceph_renew_caps(struct inode *inode, int fmode)
 {
-	struct ceph_mds_client *mdsc =3D ceph_sb_to_client(inode->i_sb)->mdsc;
+	struct ceph_mds_client *mdsc =3D ceph_inode_to_client(inode)->mdsc;
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
 	struct ceph_mds_request *req;
 	int err, flags, wanted;
=20
 	spin_lock(&ci->i_ceph_lock);
+	__ceph_touch_fmode(ci, mdsc, fmode);
 	wanted =3D __ceph_caps_file_wanted(ci);
 	if (__ceph_is_any_real_caps(ci) &&
 	    (!(wanted & CEPH_CAP_ANY_WR) || ci->i_auth_cap)) {
@@ -405,6 +406,7 @@ int ceph_open(struct inode *inode, struct file *file)
 	} else if (ceph_snap(inode) !=3D CEPH_NOSNAP &&
 		   (ci->i_snap_caps & wanted) =3D=3D wanted) {
 		__ceph_get_fmode(ci, fmode);
+		__ceph_touch_fmode(ci, mdsc, fmode);
 		spin_unlock(&ci->i_ceph_lock);
 		return ceph_init_file(inode, file, fmode);
 	}
@@ -781,7 +783,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry=
 *dentry,
 	}
 out_req:
 	if (!req->r_err && req->r_target_inode)
-		ceph_put_fmode(ceph_inode(req->r_target_inode), req->r_fmode);
+		ceph_put_fmode(ceph_inode(req->r_target_inode), req->r_fmode, 1);
 	ceph_mdsc_put_request(req);
 out_ctx:
 	ceph_release_acl_sec_ctx(&as_ctx);
@@ -798,7 +800,7 @@ int ceph_release(struct inode *inode, struct file *fi=
le)
 		dout("release inode %p dir file %p\n", inode, file);
 		WARN_ON(!list_empty(&dfi->file_info.rw_contexts));
=20
-		ceph_put_fmode(ci, dfi->file_info.fmode);
+		ceph_put_fmode(ci, dfi->file_info.fmode, 1);
=20
 		if (dfi->last_readdir)
 			ceph_mdsc_put_request(dfi->last_readdir);
@@ -810,7 +812,8 @@ int ceph_release(struct inode *inode, struct file *fi=
le)
 		dout("release inode %p regular file %p\n", inode, file);
 		WARN_ON(!list_empty(&fi->rw_contexts));
=20
-		ceph_put_fmode(ci, fi->fmode);
+		ceph_put_fmode(ci, fi->fmode, 1);
+
 		kmem_cache_free(ceph_file_cachep, fi);
 	}
=20
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 73f986efb1fd..a618e8ae9d0f 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -479,6 +479,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb=
)
 	ci->i_head_snapc =3D NULL;
 	ci->i_snap_caps =3D 0;
=20
+	ci->i_last_rd =3D ci->i_last_wr =3D jiffies - 3600 * HZ;
 	for (i =3D 0; i < CEPH_FILE_MODE_BITS; i++)
 		ci->i_nr_by_mode[i] =3D 0;
=20
@@ -639,7 +640,7 @@ int ceph_fill_file_size(struct inode *inode, int issu=
ed,
 			if ((issued & (CEPH_CAP_FILE_CACHE|
 				       CEPH_CAP_FILE_BUFFER)) ||
 			    mapping_mapped(inode->i_mapping) ||
-			    __ceph_caps_file_wanted(ci)) {
+			    __ceph_is_file_opened(ci)) {
 				ci->i_truncate_pending++;
 				queue_trunc =3D 1;
 			}
@@ -1013,6 +1014,13 @@ int ceph_fill_inode(struct inode *inode, struct pa=
ge *locked_page,
 			fill_inline =3D true;
 	}
=20
+	if (cap_fmode >=3D 0) {
+		if (!info_caps)
+			pr_warn("mds issued no caps on %llx.%llx\n",
+				ceph_vinop(inode));
+		__ceph_touch_fmode(ci, mdsc, cap_fmode);
+	}
+
 	spin_unlock(&ci->i_ceph_lock);
=20
 	if (fill_inline)
diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
index c90f03beb15d..6e061bf62ad4 100644
--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -243,11 +243,13 @@ static long ceph_ioctl_lazyio(struct file *file)
 	struct ceph_file_info *fi =3D file->private_data;
 	struct inode *inode =3D file_inode(file);
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
+	struct ceph_mds_client *mdsc =3D ceph_inode_to_client(inode)->mdsc;
=20
 	if ((fi->fmode & CEPH_FILE_MODE_LAZY) =3D=3D 0) {
 		spin_lock(&ci->i_ceph_lock);
 		fi->fmode |=3D CEPH_FILE_MODE_LAZY;
 		ci->i_nr_by_mode[ffs(CEPH_FILE_MODE_LAZY)]++;
+		__ceph_touch_fmode(ci, mdsc, fi->fmode);
 		spin_unlock(&ci->i_ceph_lock);
 		dout("ioctl_layzio: file %p marked lazy\n", file);
=20
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 356ad7b46b85..63dd8e61ba88 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -366,6 +366,8 @@ struct ceph_inode_info {
 						    dirty|flushing caps */
 	unsigned i_snap_caps;           /* cap bits for snapped files */
=20
+	unsigned long i_last_rd;
+	unsigned long i_last_wr;
 	int i_nr_by_mode[CEPH_FILE_MODE_BITS];  /* open file counts */
=20
 	struct mutex i_truncate_mutex;
@@ -680,6 +682,10 @@ extern int __ceph_caps_revoking_other(struct ceph_in=
ode_info *ci,
 extern int ceph_caps_revoking(struct ceph_inode_info *ci, int mask);
 extern int __ceph_caps_used(struct ceph_inode_info *ci);
=20
+static inline bool __ceph_is_file_opened(struct ceph_inode_info *ci)
+{
+	return ci->i_nr_by_mode[0];
+}
 extern int __ceph_caps_file_wanted(struct ceph_inode_info *ci);
 extern int __ceph_caps_wanted(struct ceph_inode_info *ci);
=20
@@ -1093,7 +1099,10 @@ extern int ceph_try_get_caps(struct inode *inode,
=20
 /* for counting open files by mode */
 extern void __ceph_get_fmode(struct ceph_inode_info *ci, int mode);
-extern void ceph_put_fmode(struct ceph_inode_info *ci, int mode);
+extern void ceph_get_fmode(struct ceph_inode_info *ci, int mode, int cou=
nt);
+extern void ceph_put_fmode(struct ceph_inode_info *ci, int mode, int cou=
nt);
+extern void __ceph_touch_fmode(struct ceph_inode_info *ci,
+			       struct ceph_mds_client *mdsc, int fmode);
=20
 /* addr.c */
 extern const struct address_space_operations ceph_aops;
@@ -1105,7 +1114,7 @@ extern void ceph_pool_perm_destroy(struct ceph_mds_=
client* mdsc);
 /* file.c */
 extern const struct file_operations ceph_file_fops;
=20
-extern int ceph_renew_caps(struct inode *inode);
+extern int ceph_renew_caps(struct inode *inode, int fmode);
 extern int ceph_open(struct inode *inode, struct file *file);
 extern int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 			    struct file *file, unsigned flags, umode_t mode);
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index e035c5194005..ebf5ba62b772 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -568,6 +568,7 @@ struct ceph_filelock {
 #define CEPH_FILE_MODE_RDWR       3  /* RD | WR */
 #define CEPH_FILE_MODE_LAZY       4  /* lazy io */
 #define CEPH_FILE_MODE_BITS       4
+#define CEPH_FILE_MODE_MASK       ((1 << CEPH_FILE_MODE_BITS) - 1)
=20
 int ceph_flags_to_mode(int flags);
=20
--=20
2.21.1


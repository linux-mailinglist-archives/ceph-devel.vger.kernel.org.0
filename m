Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFCE21796C4
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Mar 2020 18:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbgCDRdR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Mar 2020 12:33:17 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54887 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729056AbgCDRdQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Mar 2020 12:33:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583343195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=asvcsriBF2+tJU6tMcmXyF/vufVlbe/lfKlygsx8w0s=;
        b=dwOLn5gMmZxreB4X5Ms3hTrE4ZepSs1ZrzKazKUiA0Xqgr44/KLpA5a4E1YCRial1dkpLq
        kyivH/L/YenM6fySU4pNikOqmEqaM31LLqHYqr8vX3B6KI9tJGj0DhPZ8r/ulZbvEkLv2C
        onCyD51ILoIEsnBgAeqr4XxKgd3Bdzg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-rX_o141POJ6w2HxU84ZFcQ-1; Wed, 04 Mar 2020 12:33:11 -0500
X-MC-Unique: rX_o141POJ6w2HxU84ZFcQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BF3480349C;
        Wed,  4 Mar 2020 17:33:10 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-198.pek2.redhat.com [10.72.12.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A1275C1D4;
        Wed,  4 Mar 2020 17:33:08 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH v4 3/6] ceph: remove delay check logic from ceph_check_caps()
Date:   Thu,  5 Mar 2020 01:32:55 +0800
Message-Id: <20200304173258.48377-4-zyan@redhat.com>
In-Reply-To: <20200304173258.48377-1-zyan@redhat.com>
References: <20200304173258.48377-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

__ceph_caps_file_wanted() already checks 'caps_wanted_delay_min' and
'caps_wanted_delay_max'. There is no need to duplicte the logic in
ceph_check_caps() and __send_cap()

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c  | 148 ++++++++++++------------------------------------
 fs/ceph/file.c  |  13 ++---
 fs/ceph/inode.c |   1 -
 fs/ceph/super.h |   8 +--
 4 files changed, 44 insertions(+), 126 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 6a3b75b8311e..2210c313b860 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -490,13 +490,10 @@ static void __cap_set_timeouts(struct ceph_mds_clie=
nt *mdsc,
 			       struct ceph_inode_info *ci)
 {
 	struct ceph_mount_options *opt =3D mdsc->fsc->mount_options;
-
-	ci->i_hold_caps_min =3D round_jiffies(jiffies +
-					    opt->caps_wanted_delay_min * HZ);
 	ci->i_hold_caps_max =3D round_jiffies(jiffies +
 					    opt->caps_wanted_delay_max * HZ);
-	dout("__cap_set_timeouts %p min %lu max %lu\n", &ci->vfs_inode,
-	     ci->i_hold_caps_min - jiffies, ci->i_hold_caps_max - jiffies);
+	dout("__cap_set_timeouts %p %lu\n", &ci->vfs_inode,
+	     ci->i_hold_caps_max - jiffies);
 }
=20
 /*
@@ -508,8 +505,7 @@ static void __cap_set_timeouts(struct ceph_mds_client=
 *mdsc,
  *    -> we take mdsc->cap_delay_lock
  */
 static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
-				struct ceph_inode_info *ci,
-				bool set_timeout)
+				struct ceph_inode_info *ci)
 {
 	dout("__cap_delay_requeue %p flags 0x%lx at %lu\n", &ci->vfs_inode,
 	     ci->i_ceph_flags, ci->i_hold_caps_max);
@@ -520,8 +516,7 @@ static void __cap_delay_requeue(struct ceph_mds_clien=
t *mdsc,
 				goto no_change;
 			list_del_init(&ci->i_cap_delay_list);
 		}
-		if (set_timeout)
-			__cap_set_timeouts(mdsc, ci);
+		__cap_set_timeouts(mdsc, ci);
 		list_add_tail(&ci->i_cap_delay_list, &mdsc->cap_delay_list);
 no_change:
 		spin_unlock(&mdsc->cap_delay_lock);
@@ -733,7 +728,7 @@ void ceph_add_cap(struct inode *inode,
 		dout(" issued %s, mds wanted %s, actual %s, queueing\n",
 		     ceph_cap_string(issued), ceph_cap_string(wanted),
 		     ceph_cap_string(actual_wanted));
-		__cap_delay_requeue(mdsc, ci, true);
+		__cap_delay_requeue(mdsc, ci);
 	}
=20
 	if (flags & CEPH_CAP_FLAG_AUTH) {
@@ -1330,7 +1325,6 @@ static int __send_cap(struct ceph_mds_client *mdsc,=
 struct ceph_cap *cap,
 	struct cap_msg_args arg;
 	int held, revoking;
 	int wake =3D 0;
-	int delayed =3D 0;
 	int ret;
=20
 	/* Don't send anything if it's still being created. Return delayed */
@@ -1350,28 +1344,7 @@ static int __send_cap(struct ceph_mds_client *mdsc=
, struct ceph_cap *cap,
 	     ceph_cap_string(revoking));
 	BUG_ON((retain & CEPH_CAP_PIN) =3D=3D 0);
=20
-	arg.session =3D cap->session;
-
-	/* don't release wanted unless we've waited a bit. */
-	if ((ci->i_ceph_flags & CEPH_I_NODELAY) =3D=3D 0 &&
-	    time_before(jiffies, ci->i_hold_caps_min)) {
-		dout(" delaying issued %s -> %s, wanted %s -> %s on send\n",
-		     ceph_cap_string(cap->issued),
-		     ceph_cap_string(cap->issued & retain),
-		     ceph_cap_string(cap->mds_wanted),
-		     ceph_cap_string(want));
-		want |=3D cap->mds_wanted;
-		retain |=3D cap->issued;
-		delayed =3D 1;
-	}
-	ci->i_ceph_flags &=3D ~(CEPH_I_NODELAY | CEPH_I_FLUSH);
-	if (want & ~cap->mds_wanted) {
-		/* user space may open/close single file frequently.
-		 * This avoids droping mds_wanted immediately after
-		 * requesting new mds_wanted.
-		 */
-		__cap_set_timeouts(mdsc, ci);
-	}
+	ci->i_ceph_flags &=3D ~CEPH_I_FLUSH;
=20
 	cap->issued &=3D retain;  /* drop bits we don't want */
 	if (cap->implemented & ~cap->issued) {
@@ -1386,6 +1359,7 @@ static int __send_cap(struct ceph_mds_client *mdsc,=
 struct ceph_cap *cap,
 	cap->implemented &=3D cap->issued | used;
 	cap->mds_wanted =3D want;
=20
+	arg.session =3D cap->session;
 	arg.ino =3D ceph_vino(inode).ino;
 	arg.cid =3D cap->cap_id;
 	arg.follows =3D flushing ? ci->i_head_snapc->seq : 0;
@@ -1446,14 +1420,19 @@ static int __send_cap(struct ceph_mds_client *mds=
c, struct ceph_cap *cap,
=20
 	ret =3D send_cap_msg(&arg);
 	if (ret < 0) {
-		dout("error sending cap msg, must requeue %p\n", inode);
-		delayed =3D 1;
+		pr_err("error sending cap msg, ino (%llx.%llx) "
+		       "flushing %s tid %llu, requeue\n",
+		       ceph_vinop(inode), ceph_cap_string(flushing),
+		       flush_tid);
+		spin_lock(&ci->i_ceph_lock);
+		__cap_delay_requeue(mdsc, ci);
+		spin_unlock(&ci->i_ceph_lock);
 	}
=20
 	if (wake)
 		wake_up_all(&ci->i_cap_wq);
=20
-	return delayed;
+	return ret;
 }
=20
 static inline int __send_flush_snap(struct inode *inode,
@@ -1719,7 +1698,7 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *=
ci, int mask,
 	if (((was | ci->i_flushing_caps) & CEPH_CAP_FILE_BUFFER) &&
 	    (mask & CEPH_CAP_FILE_BUFFER))
 		dirty |=3D I_DIRTY_DATASYNC;
-	__cap_delay_requeue(mdsc, ci, true);
+	__cap_delay_requeue(mdsc, ci);
 	return dirty;
 }
=20
@@ -1871,8 +1850,6 @@ bool __ceph_should_report_size(struct ceph_inode_in=
fo *ci)
  * versus held caps.  Release, flush, ack revoked caps to mds as
  * appropriate.
  *
- *  CHECK_CAPS_NODELAY - caller is delayed work and we should not delay
- *    cap release further.
  *  CHECK_CAPS_AUTHONLY - we should only check the auth cap
  *  CHECK_CAPS_FLUSH - we should flush any dirty caps immediately, witho=
ut
  *    further delay.
@@ -1891,17 +1868,10 @@ void ceph_check_caps(struct ceph_inode_info *ci, =
int flags,
 	int mds =3D -1;   /* keep track of how far we've gone through i_caps li=
st
 			   to avoid an infinite loop on retry */
 	struct rb_node *p;
-	int delayed =3D 0, sent =3D 0;
-	bool no_delay =3D flags & CHECK_CAPS_NODELAY;
 	bool queue_invalidate =3D false;
 	bool tried_invalidate =3D false;
=20
-	/* if we are unmounting, flush any unused caps immediately. */
-	if (mdsc->stopping)
-		no_delay =3D true;
-
 	spin_lock(&ci->i_ceph_lock);
-
 	if (ci->i_ceph_flags & CEPH_I_FLUSH)
 		flags |=3D CHECK_CAPS_FLUSH;
=20
@@ -1950,14 +1920,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, =
int flags,
 	}
=20
 	dout("check_caps %p file_want %s used %s dirty %s flushing %s"
-	     " issued %s revoking %s retain %s %s%s%s\n", inode,
+	     " issued %s revoking %s retain %s %s%s\n", inode,
 	     ceph_cap_string(file_wanted),
 	     ceph_cap_string(used), ceph_cap_string(ci->i_dirty_caps),
 	     ceph_cap_string(ci->i_flushing_caps),
 	     ceph_cap_string(issued), ceph_cap_string(revoking),
 	     ceph_cap_string(retain),
 	     (flags & CHECK_CAPS_AUTHONLY) ? " AUTHONLY" : "",
-	     (flags & CHECK_CAPS_NODELAY) ? " NODELAY" : "",
 	     (flags & CHECK_CAPS_FLUSH) ? " FLUSH" : "");
=20
 	/*
@@ -1965,7 +1934,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, in=
t flags,
 	 * have cached pages, but don't want them, then try to invalidate.
 	 * If we fail, it's because pages are locked.... try again later.
 	 */
-	if ((!no_delay || mdsc->stopping) &&
+	if ((!(flags & CHECK_CAPS_NOINVAL) || mdsc->stopping) &&
 	    S_ISREG(inode->i_mode) &&
 	    !(ci->i_wb_ref || ci->i_wrbuffer_ref) &&   /* no dirty pages... */
 	    inode->i_data.nrpages &&		/* have cached pages */
@@ -2045,21 +2014,6 @@ void ceph_check_caps(struct ceph_inode_info *ci, i=
nt flags,
 		if ((cap->issued & ~retain) =3D=3D 0)
 			continue;     /* nope, all good */
=20
-		if (no_delay)
-			goto ack;
-
-		/* delay? */
-		if ((ci->i_ceph_flags & CEPH_I_NODELAY) =3D=3D 0 &&
-		    time_before(jiffies, ci->i_hold_caps_max)) {
-			dout(" delaying issued %s -> %s, wanted %s -> %s\n",
-			     ceph_cap_string(cap->issued),
-			     ceph_cap_string(cap->issued & retain),
-			     ceph_cap_string(cap->mds_wanted),
-			     ceph_cap_string(want));
-			delayed++;
-			continue;
-		}
-
 ack:
 		if (session && session !=3D cap->session) {
 			dout("oops, wrong session %p mutex\n", session);
@@ -2120,25 +2074,19 @@ void ceph_check_caps(struct ceph_inode_info *ci, =
int flags,
 		}
=20
 		mds =3D cap->mds;  /* remember mds, so we don't repeat */
-		sent++;
=20
 		/* __send_cap drops i_ceph_lock */
-		delayed +=3D __send_cap(mdsc, cap, CEPH_CAP_OP_UPDATE, 0,
-				cap_used, want, retain, flushing,
-				flush_tid, oldest_flush_tid);
+		__send_cap(mdsc, cap, CEPH_CAP_OP_UPDATE, 0, cap_used, want,
+			   retain, flushing, flush_tid, oldest_flush_tid);
 		goto retry; /* retake i_ceph_lock and restart our cap scan. */
 	}
=20
-	if (list_empty(&ci->i_cap_delay_list)) {
-	    if (delayed) {
-		    /* Reschedule delayed caps release if we delayed anything */
-		    __cap_delay_requeue(mdsc, ci, false);
-	    } else if (__ceph_is_any_real_caps(ci) &&
-			(file_wanted & ~CEPH_CAP_PIN) &&
-			!(used & (CEPH_CAP_FILE_RD | CEPH_CAP_ANY_FILE_WR))) {
-		    /* periodically re-calculate caps wanted by open files */
-		    __cap_delay_requeue(mdsc, ci, true);
-	    }
+	/* periodically re-calculate caps wanted by open files */
+	if (__ceph_is_any_real_caps(ci) &&
+	    list_empty(&ci->i_cap_delay_list) &&
+	    (file_wanted & ~CEPH_CAP_PIN) &&
+	    !(used & (CEPH_CAP_FILE_RD | CEPH_CAP_ANY_FILE_WR))) {
+		__cap_delay_requeue(mdsc, ci);
 	}
=20
 	spin_unlock(&ci->i_ceph_lock);
@@ -2168,7 +2116,6 @@ static int try_flush_caps(struct inode *inode, u64 =
*ptid)
 retry_locked:
 	if (ci->i_dirty_caps && ci->i_auth_cap) {
 		struct ceph_cap *cap =3D ci->i_auth_cap;
-		int delayed;
=20
 		if (session !=3D cap->session) {
 			spin_unlock(&ci->i_ceph_lock);
@@ -2197,18 +2144,10 @@ static int try_flush_caps(struct inode *inode, u6=
4 *ptid)
 						 &oldest_flush_tid);
=20
 		/* __send_cap drops i_ceph_lock */
-		delayed =3D __send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH,
-				     CEPH_CLIENT_CAPS_SYNC,
-				     __ceph_caps_used(ci),
-				     __ceph_caps_wanted(ci),
-				     (cap->issued | cap->implemented),
-				     flushing, flush_tid, oldest_flush_tid);
-
-		if (delayed) {
-			spin_lock(&ci->i_ceph_lock);
-			__cap_delay_requeue(mdsc, ci, true);
-			spin_unlock(&ci->i_ceph_lock);
-		}
+		__send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH, CEPH_CLIENT_CAPS_SYNC,
+			   __ceph_caps_used(ci), __ceph_caps_wanted(ci),
+			   (cap->issued | cap->implemented),
+			   flushing, flush_tid, oldest_flush_tid);
 	} else {
 		if (!list_empty(&ci->i_cap_flush_list)) {
 			struct ceph_cap_flush *cf =3D
@@ -2412,22 +2351,13 @@ static void __kick_flushing_caps(struct ceph_mds_=
client *mdsc,
 		if (cf->caps) {
 			dout("kick_flushing_caps %p cap %p tid %llu %s\n",
 			     inode, cap, cf->tid, ceph_cap_string(cf->caps));
-			ci->i_ceph_flags |=3D CEPH_I_NODELAY;
-
-			ret =3D __send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH,
+			__send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH,
 					 (cf->tid < last_snap_flush ?
 					  CEPH_CLIENT_CAPS_PENDING_CAPSNAP : 0),
 					  __ceph_caps_used(ci),
 					  __ceph_caps_wanted(ci),
 					  (cap->issued | cap->implemented),
 					  cf->caps, cf->tid, oldest_flush_tid);
-			if (ret) {
-				pr_err("kick_flushing_caps: error sending "
-					"cap flush, ino (%llx.%llx) "
-					"tid %llu flushing %s\n",
-					ceph_vinop(inode), cf->tid,
-					ceph_cap_string(cf->caps));
-			}
 		} else {
 			struct ceph_cap_snap *capsnap =3D
 					container_of(cf, struct ceph_cap_snap,
@@ -3049,7 +2979,7 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, =
int had)
 	dout("put_cap_refs %p had %s%s%s\n", inode, ceph_cap_string(had),
 	     last ? " last" : "", put ? " put" : "");
=20
-	if (last && !flushsnaps)
+	if (last)
 		ceph_check_caps(ci, 0, NULL);
 	else if (flushsnaps)
 		ceph_flush_snaps(ci, NULL);
@@ -3468,10 +3398,10 @@ static void handle_cap_grant(struct inode *inode,
 		wake_up_all(&ci->i_cap_wq);
=20
 	if (check_caps =3D=3D 1)
-		ceph_check_caps(ci, CHECK_CAPS_NODELAY|CHECK_CAPS_AUTHONLY,
+		ceph_check_caps(ci, CHECK_CAPS_AUTHONLY | CHECK_CAPS_NOINVAL,
 				session);
 	else if (check_caps =3D=3D 2)
-		ceph_check_caps(ci, CHECK_CAPS_NODELAY, session);
+		ceph_check_caps(ci, CHECK_CAPS_NOINVAL, session);
 	else
 		mutex_unlock(&session->s_mutex);
 }
@@ -4146,7 +4076,6 @@ void ceph_check_delayed_caps(struct ceph_mds_client=
 *mdsc)
 {
 	struct inode *inode;
 	struct ceph_inode_info *ci;
-	int flags =3D CHECK_CAPS_NODELAY;
=20
 	dout("check_delayed_caps\n");
 	while (1) {
@@ -4166,7 +4095,7 @@ void ceph_check_delayed_caps(struct ceph_mds_client=
 *mdsc)
=20
 		if (inode) {
 			dout("check_delayed_caps on %p\n", inode);
-			ceph_check_caps(ci, flags, NULL);
+			ceph_check_caps(ci, 0, NULL);
 			/* avoid calling iput_final() in tick thread */
 			ceph_async_iput(inode);
 		}
@@ -4191,7 +4120,7 @@ void ceph_flush_dirty_caps(struct ceph_mds_client *=
mdsc)
 		ihold(inode);
 		dout("flush_dirty_caps %p\n", inode);
 		spin_unlock(&mdsc->cap_dirty_lock);
-		ceph_check_caps(ci, CHECK_CAPS_NODELAY|CHECK_CAPS_FLUSH, NULL);
+		ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
 		iput(inode);
 		spin_lock(&mdsc->cap_dirty_lock);
 	}
@@ -4211,7 +4140,7 @@ void __ceph_touch_fmode(struct ceph_inode_info *ci,
 	if (fmode &&
 	    __ceph_is_any_real_caps(ci) &&
 	    list_empty(&ci->i_cap_delay_list))
-		__cap_delay_requeue(mdsc, ci, true);
+		__cap_delay_requeue(mdsc, ci);
 }
=20
 void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
@@ -4270,7 +4199,6 @@ int ceph_drop_caps_for_unlink(struct inode *inode)
 	if (inode->i_nlink =3D=3D 1) {
 		drop |=3D ~(__ceph_caps_wanted(ci) | CEPH_CAP_PIN);
=20
-		ci->i_ceph_flags |=3D CEPH_I_NODELAY;
 		if (__ceph_caps_dirty(ci)) {
 			struct ceph_mds_client *mdsc =3D
 				ceph_inode_to_client(inode)->mdsc;
@@ -4326,8 +4254,6 @@ int ceph_encode_inode_release(void **p, struct inod=
e *inode,
 		if (force || (cap->issued & drop)) {
 			if (cap->issued & drop) {
 				int wanted =3D __ceph_caps_wanted(ci);
-				if ((ci->i_ceph_flags & CEPH_I_NODELAY) =3D=3D 0)
-					wanted |=3D cap->mds_wanted;
 				dout("encode_inode_release %p cap %p "
 				     "%s -> %s, wanted %s -> %s\n", inode, cap,
 				     ceph_cap_string(cap->issued),
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index c39951e7e289..ea1a1b13247f 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1819,7 +1819,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, =
struct iov_iter *from)
 		if (dirty)
 			__mark_inode_dirty(inode, dirty);
 		if (ceph_quota_is_max_bytes_approaching(inode, iocb->ki_pos))
-			ceph_check_caps(ci, CHECK_CAPS_NODELAY, NULL);
+			ceph_check_caps(ci, 0, NULL);
 	}
=20
 	dout("aio_write %p %llx.%llx %llu~%u  dropping cap refs on %s\n",
@@ -2419,15 +2419,10 @@ static ssize_t __ceph_copy_file_range(struct file=
 *src_file, loff_t src_off,
 	inode_inc_iversion_raw(dst_inode);
=20
 	if (dst_off > size) {
-		int caps_flags =3D 0;
-
 		/* Let the MDS know about dst file size change */
-		if (ceph_quota_is_max_bytes_approaching(dst_inode, dst_off))
-			caps_flags |=3D CHECK_CAPS_NODELAY;
-		if (ceph_inode_set_size(dst_inode, dst_off))
-			caps_flags |=3D CHECK_CAPS_AUTHONLY;
-		if (caps_flags)
-			ceph_check_caps(dst_ci, caps_flags, NULL);
+		if (ceph_inode_set_size(dst_inode, dst_off) ||
+		    ceph_quota_is_max_bytes_approaching(dst_inode, dst_off))
+			ceph_check_caps(dst_ci, CHECK_CAPS_AUTHONLY, NULL);
 	}
 	/* Mark Fw dirty */
 	spin_lock(&dst_ci->i_ceph_lock);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index a618e8ae9d0f..c4dd534aaec3 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -472,7 +472,6 @@ struct inode *ceph_alloc_inode(struct super_block *sb=
)
 	ci->i_prealloc_cap_flush =3D NULL;
 	INIT_LIST_HEAD(&ci->i_cap_flush_list);
 	init_waitqueue_head(&ci->i_cap_wq);
-	ci->i_hold_caps_min =3D 0;
 	ci->i_hold_caps_max =3D 0;
 	INIT_LIST_HEAD(&ci->i_cap_delay_list);
 	INIT_LIST_HEAD(&ci->i_cap_snaps);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 63dd8e61ba88..edceedfee00a 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -173,9 +173,9 @@ struct ceph_cap {
 	struct list_head caps_item;
 };
=20
-#define CHECK_CAPS_NODELAY    1  /* do not delay any further */
-#define CHECK_CAPS_AUTHONLY   2  /* only check auth cap */
-#define CHECK_CAPS_FLUSH      4  /* flush any dirty caps */
+#define CHECK_CAPS_AUTHONLY   1  /* only check auth cap */
+#define CHECK_CAPS_FLUSH      2  /* flush any dirty caps */
+#define CHECK_CAPS_NOINVAL    4  /* don't invalidate pagecache */
=20
 struct ceph_cap_flush {
 	u64 tid;
@@ -357,7 +357,6 @@ struct ceph_inode_info {
 	struct ceph_cap_flush *i_prealloc_cap_flush;
 	struct list_head i_cap_flush_list;
 	wait_queue_head_t i_cap_wq;      /* threads waiting on a capability */
-	unsigned long i_hold_caps_min; /* jiffies */
 	unsigned long i_hold_caps_max; /* jiffies */
 	struct list_head i_cap_delay_list;  /* for delayed cap release to mds *=
/
 	struct ceph_cap_reservation i_cap_migration_resv;
@@ -518,7 +517,6 @@ static inline struct inode *ceph_find_inode(struct su=
per_block *sb,
  * Ceph inode.
  */
 #define CEPH_I_DIR_ORDERED	(1 << 0)  /* dentries in dir are ordered */
-#define CEPH_I_NODELAY		(1 << 1)  /* do not delay cap release */
 #define CEPH_I_FLUSH		(1 << 2)  /* do not delay flush of dirty metadata =
*/
 #define CEPH_I_POOL_PERM	(1 << 3)  /* pool rd/wr bits are valid */
 #define CEPH_I_POOL_RD		(1 << 4)  /* can read from pool */
--=20
2.21.1


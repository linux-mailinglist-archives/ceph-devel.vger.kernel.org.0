Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E546E17A529
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Mar 2020 13:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgCEMV0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Mar 2020 07:21:26 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38686 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725880AbgCEMVZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Mar 2020 07:21:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583410884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z9Ca1B/HtT3k74aKOFJazIauNrSlf4qfGGP+pFfjhB0=;
        b=QGOT0EQ0LlOh5i5gtuh0E+9Ih9DB1nRpoJiB0DGLuv+qz6ZSRckzb5tYtnTBkkLqJxIRKT
        w+ffOnbinRYnJ120FBx08YLLXyJpqGOWjbITXzFTznpWjSZXy2J5mtlHgXsxec1TkgJjlw
        d/ncrhhLHW8JnHRJknZZppvUdVswJzs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-MXPOUKhtNaGEsHo87ZKPqQ-1; Thu, 05 Mar 2020 07:21:22 -0500
X-MC-Unique: MXPOUKhtNaGEsHo87ZKPqQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9DD7107ACC9;
        Thu,  5 Mar 2020 12:21:21 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-47.pek2.redhat.com [10.72.12.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A66808D551;
        Thu,  5 Mar 2020 12:21:19 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH v5 4/7] ceph: simplify calling of ceph_get_fmode()
Date:   Thu,  5 Mar 2020 20:21:02 +0800
Message-Id: <20200305122105.69184-5-zyan@redhat.com>
In-Reply-To: <20200305122105.69184-1-zyan@redhat.com>
References: <20200305122105.69184-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Originally, calling ceph_get_fmode() for open files is by thread that
handles request reply. There is a small window between updating caps and
and waking the request initiator. We need to prevent ceph_check_caps()
from releasing wanted caps in the window.

Previous patchies made fill_inode() call __ceph_touch_fmode() for open fi=
le
requests. This prevented ceph_check_caps() from releasing wanted caps for
'caps_wanted_delay_min' seconds, enough for request initiator to get
woken up and call ceph_get_fmode().

This allows us to now call ceph_get_fmode() in ceph_open() instead.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c  | 26 +++-----------------------
 fs/ceph/file.c  | 21 +++++----------------
 fs/ceph/inode.c |  8 +-------
 fs/ceph/super.h |  3 +--
 4 files changed, 10 insertions(+), 48 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 21877b63aa3a..a94d2807f1f3 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -608,7 +608,7 @@ static void __check_cap_issue(struct ceph_inode_info =
*ci, struct ceph_cap *cap,
  */
 void ceph_add_cap(struct inode *inode,
 		  struct ceph_mds_session *session, u64 cap_id,
-		  int fmode, unsigned issued, unsigned wanted,
+		  unsigned issued, unsigned wanted,
 		  unsigned seq, unsigned mseq, u64 realmino, int flags,
 		  struct ceph_cap **new_cap)
 {
@@ -624,13 +624,6 @@ void ceph_add_cap(struct inode *inode,
 	dout("add_cap %p mds%d cap %llx %s seq %d\n", inode,
 	     session->s_mds, cap_id, ceph_cap_string(issued), seq);
=20
-	/*
-	 * If we are opening the file, include file mode wanted bits
-	 * in wanted.
-	 */
-	if (fmode >=3D 0)
-		wanted |=3D ceph_caps_for_mode(fmode);
-
 	spin_lock(&session->s_gen_ttl_lock);
 	gen =3D session->s_cap_gen;
 	spin_unlock(&session->s_gen_ttl_lock);
@@ -755,9 +748,6 @@ void ceph_add_cap(struct inode *inode,
 	cap->issue_seq =3D seq;
 	cap->mseq =3D mseq;
 	cap->cap_gen =3D gen;
-
-	if (fmode >=3D 0)
-		__ceph_get_fmode(ci, fmode);
 }
=20
 /*
@@ -3693,7 +3683,7 @@ static void handle_cap_export(struct inode *inode, =
struct ceph_mds_caps *ex,
 		/* add placeholder for the export tagert */
 		int flag =3D (cap =3D=3D ci->i_auth_cap) ? CEPH_CAP_FLAG_AUTH : 0;
 		tcap =3D new_cap;
-		ceph_add_cap(inode, tsession, t_cap_id, -1, issued, 0,
+		ceph_add_cap(inode, tsession, t_cap_id, issued, 0,
 			     t_seq - 1, t_mseq, (u64)-1, flag, &new_cap);
=20
 		if (!list_empty(&ci->i_cap_flush_list) &&
@@ -3798,7 +3788,7 @@ static void handle_cap_import(struct ceph_mds_clien=
t *mdsc,
 	__ceph_caps_issued(ci, &issued);
 	issued |=3D __ceph_caps_dirty(ci);
=20
-	ceph_add_cap(inode, session, cap_id, -1, caps, wanted, seq, mseq,
+	ceph_add_cap(inode, session, cap_id, caps, wanted, seq, mseq,
 		     realmino, CEPH_CAP_FLAG_AUTH, &new_cap);
=20
 	ocap =3D peer >=3D 0 ? __get_cap_for_mds(ci, peer) : NULL;
@@ -4151,16 +4141,6 @@ void ceph_get_fmode(struct ceph_inode_info *ci, in=
t fmode, int count)
 	spin_unlock(&ci->i_ceph_lock);
 }
=20
-void __ceph_get_fmode(struct ceph_inode_info *ci, int fmode)
-{
-	int i;
-	int bits =3D (fmode << 1) | 1;
-	for (i =3D 0; i < CEPH_FILE_MODE_BITS; i++) {
-		if (bits & (1 << i))
-			ci->i_nr_by_mode[i]++;
-	}
-}
-
 /*
  * Drop open file reference.  If we were the last open file,
  * we may need to release capabilities to the MDS (or schedule
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index ea1a1b13247f..ba46ba740628 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -212,10 +212,8 @@ static int ceph_init_file_info(struct inode *inode, =
struct file *file,
 	if (isdir) {
 		struct ceph_dir_file_info *dfi =3D
 			kmem_cache_zalloc(ceph_dir_file_cachep, GFP_KERNEL);
-		if (!dfi) {
-			ceph_put_fmode(ci, fmode, 1); /* clean up */
+		if (!dfi)
 			return -ENOMEM;
-		}
=20
 		file->private_data =3D dfi;
 		fi =3D &dfi->file_info;
@@ -223,15 +221,15 @@ static int ceph_init_file_info(struct inode *inode,=
 struct file *file,
 		dfi->readdir_cache_idx =3D -1;
 	} else {
 		fi =3D kmem_cache_zalloc(ceph_file_cachep, GFP_KERNEL);
-		if (!fi) {
-			ceph_put_fmode(ci, fmode, 1); /* clean up */
+		if (!fi)
 			return -ENOMEM;
-		}
=20
 		file->private_data =3D fi;
 	}
=20
+	ceph_get_fmode(ci, fmode, 1);
 	fi->fmode =3D fmode;
+
 	spin_lock_init(&fi->rw_contexts_lock);
 	INIT_LIST_HEAD(&fi->rw_contexts);
 	fi->meta_err =3D errseq_sample(&ci->i_meta_err);
@@ -263,7 +261,6 @@ static int ceph_init_file(struct inode *inode, struct=
 file *file, int fmode)
 	case S_IFLNK:
 		dout("init_file %p %p 0%o (symlink)\n", inode, file,
 		     inode->i_mode);
-		ceph_put_fmode(ceph_inode(inode), fmode, 1); /* clean up */
 		break;
=20
 	default:
@@ -273,7 +270,6 @@ static int ceph_init_file(struct inode *inode, struct=
 file *file, int fmode)
 		 * we need to drop the open ref now, since we don't
 		 * have .release set to ceph_release.
 		 */
-		ceph_put_fmode(ceph_inode(inode), fmode, 1); /* clean up */
 		BUG_ON(inode->i_fop->release =3D=3D ceph_release);
=20
 		/* call the proper open fop */
@@ -327,7 +323,6 @@ int ceph_renew_caps(struct inode *inode, int fmode)
 	req->r_inode =3D inode;
 	ihold(inode);
 	req->r_num_caps =3D 1;
-	req->r_fmode =3D -1;
=20
 	err =3D ceph_mdsc_do_request(mdsc, NULL, req);
 	ceph_mdsc_put_request(req);
@@ -373,9 +368,6 @@ int ceph_open(struct inode *inode, struct file *file)
=20
 	/* trivially open snapdir */
 	if (ceph_snap(inode) =3D=3D CEPH_SNAPDIR) {
-		spin_lock(&ci->i_ceph_lock);
-		__ceph_get_fmode(ci, fmode);
-		spin_unlock(&ci->i_ceph_lock);
 		return ceph_init_file(inode, file, fmode);
 	}
=20
@@ -393,7 +385,7 @@ int ceph_open(struct inode *inode, struct file *file)
 		dout("open %p fmode %d want %s issued %s using existing\n",
 		     inode, fmode, ceph_cap_string(wanted),
 		     ceph_cap_string(issued));
-		__ceph_get_fmode(ci, fmode);
+		__ceph_touch_fmode(ci, mdsc, fmode);
 		spin_unlock(&ci->i_ceph_lock);
=20
 		/* adjust wanted? */
@@ -405,7 +397,6 @@ int ceph_open(struct inode *inode, struct file *file)
 		return ceph_init_file(inode, file, fmode);
 	} else if (ceph_snap(inode) !=3D CEPH_NOSNAP &&
 		   (ci->i_snap_caps & wanted) =3D=3D wanted) {
-		__ceph_get_fmode(ci, fmode);
 		__ceph_touch_fmode(ci, mdsc, fmode);
 		spin_unlock(&ci->i_ceph_lock);
 		return ceph_init_file(inode, file, fmode);
@@ -782,8 +773,6 @@ int ceph_atomic_open(struct inode *dir, struct dentry=
 *dentry,
 		err =3D finish_open(file, dentry, ceph_open);
 	}
 out_req:
-	if (!req->r_err && req->r_target_inode)
-		ceph_put_fmode(ceph_inode(req->r_target_inode), req->r_fmode, 1);
 	ceph_mdsc_put_request(req);
 out_ctx:
 	ceph_release_acl_sec_ctx(&as_ctx);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index c4dd534aaec3..c7ff9f7067f6 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -970,7 +970,7 @@ int ceph_fill_inode(struct inode *inode, struct page =
*locked_page,
 		if (ceph_snap(inode) =3D=3D CEPH_NOSNAP) {
 			ceph_add_cap(inode, session,
 				     le64_to_cpu(info->cap.cap_id),
-				     cap_fmode, info_caps,
+				     info_caps,
 				     le32_to_cpu(info->cap.wanted),
 				     le32_to_cpu(info->cap.seq),
 				     le32_to_cpu(info->cap.mseq),
@@ -995,13 +995,7 @@ int ceph_fill_inode(struct inode *inode, struct page=
 *locked_page,
 			dout(" %p got snap_caps %s\n", inode,
 			     ceph_cap_string(info_caps));
 			ci->i_snap_caps |=3D info_caps;
-			if (cap_fmode >=3D 0)
-				__ceph_get_fmode(ci, cap_fmode);
 		}
-	} else if (cap_fmode >=3D 0) {
-		pr_warn("mds issued no caps on %llx.%llx\n",
-			   ceph_vinop(inode));
-		__ceph_get_fmode(ci, cap_fmode);
 	}
=20
 	if (iinfo->inline_version > 0 &&
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index edceedfee00a..60aac3aee055 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1050,7 +1050,7 @@ extern struct ceph_cap *ceph_get_cap(struct ceph_md=
s_client *mdsc,
 				     struct ceph_cap_reservation *ctx);
 extern void ceph_add_cap(struct inode *inode,
 			 struct ceph_mds_session *session, u64 cap_id,
-			 int fmode, unsigned issued, unsigned wanted,
+			 unsigned issued, unsigned wanted,
 			 unsigned cap, unsigned seq, u64 realmino, int flags,
 			 struct ceph_cap **new_cap);
 extern void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release);
@@ -1096,7 +1096,6 @@ extern int ceph_try_get_caps(struct inode *inode,
 			     int need, int want, bool nonblock, int *got);
=20
 /* for counting open files by mode */
-extern void __ceph_get_fmode(struct ceph_inode_info *ci, int mode);
 extern void ceph_get_fmode(struct ceph_inode_info *ci, int mode, int cou=
nt);
 extern void ceph_put_fmode(struct ceph_inode_info *ci, int mode, int cou=
nt);
 extern void __ceph_touch_fmode(struct ceph_inode_info *ci,
--=20
2.21.1


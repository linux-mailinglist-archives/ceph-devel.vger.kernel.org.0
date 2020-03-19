Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB2718AC98
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Mar 2020 07:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgCSGAr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Mar 2020 02:00:47 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:29371 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727048AbgCSGAq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 02:00:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584597645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=+N0KhDK5yE6ml49RFFudsUTUY3ab8n/TmKG0u4Os7ng=;
        b=PwJ7SfXx4m9BYWKegNYls4WRiI7KnQVCZPvU+G/1tAnWZJategpGiFJm7taFlewlJealrl
        IM6ndAcsYs1ywS+BLiyTEgcAqZP6j3ruQlkBDa+L9xe24dF86GrE/vyFrRZZNgzGQGeqTy
        hlvHdm246/1b5HRXoMUhTinQPrtXUJQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-uulQTBSfNwSzbJ0l3EIkTw-1; Thu, 19 Mar 2020 02:00:43 -0400
X-MC-Unique: uulQTBSfNwSzbJ0l3EIkTw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 344768018CB;
        Thu, 19 Mar 2020 06:00:42 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8523D5C1A1;
        Thu, 19 Mar 2020 06:00:39 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v11 2/4] ceph: add caps perf metric for each session
Date:   Thu, 19 Mar 2020 02:00:24 -0400
Message-Id: <1584597626-11127-3-git-send-email-xiubli@redhat.com>
In-Reply-To: <1584597626-11127-1-git-send-email-xiubli@redhat.com>
References: <1584597626-11127-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Count hits and misses in the caps cache. If the client has all of
the necessary caps when a task needs references, then it's counted
as a hit. Any other situation is a miss.

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/acl.c     |  2 +-
 fs/ceph/caps.c    | 19 +++++++++++++++++++
 fs/ceph/debugfs.c | 16 ++++++++++++++++
 fs/ceph/dir.c     |  5 +++--
 fs/ceph/inode.c   |  4 ++--
 fs/ceph/metric.c  | 26 ++++++++++++++++++++++----
 fs/ceph/metric.h  | 13 +++++++++++++
 fs/ceph/super.h   |  8 +++++---
 fs/ceph/xattr.c   |  4 ++--
 9 files changed, 83 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index 26be652..e046574 100644
--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -22,7 +22,7 @@ static inline void ceph_set_cached_acl(struct inode *inode,
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
 	spin_lock(&ci->i_ceph_lock);
-	if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0))
+	if (__ceph_caps_issued_mask_metric(ci, CEPH_CAP_XATTR_SHARED, 0))
 		set_cached_acl(inode, type, acl);
 	else
 		forget_cached_acl(inode, type);
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 185db76..7794338 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -912,6 +912,20 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
 	return 0;
 }
 
+int __ceph_caps_issued_mask_metric(struct ceph_inode_info *ci, int mask,
+				   int touch)
+{
+	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
+	int r;
+
+	r = __ceph_caps_issued_mask(ci, mask, touch);
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
@@ -2685,6 +2699,11 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 	if (snap_rwsem_locked)
 		up_read(&mdsc->snap_rwsem);
 
+	if (!ret)
+		ceph_update_cap_mis(&mdsc->metric);
+	else if (ret == 1)
+		ceph_update_cap_hit(&mdsc->metric);
+
 	dout("get_cap_refs %p ret %d got %s\n", inode,
 	     ret, ceph_cap_string(*got));
 	return ret;
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 60cdb8f..66b9622 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -129,6 +129,7 @@ static int metric_show(struct seq_file *s, void *p)
 	struct ceph_fs_client *fsc = s->private;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_client_metric *m = &mdsc->metric;
+	int i, nr_caps = 0;
 
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
@@ -138,6 +139,21 @@ static int metric_show(struct seq_file *s, void *p)
 		   percpu_counter_sum(&m->d_lease_mis),
 		   percpu_counter_sum(&m->d_lease_hit));
 
+	mutex_lock(&mdsc->mutex);
+	for (i = 0; i < mdsc->max_sessions; i++) {
+		struct ceph_mds_session *s;
+
+		s = __ceph_lookup_mds_session(mdsc, i);
+		if (!s)
+			continue;
+		nr_caps += s->s_nr_caps;
+		ceph_put_mds_session(s);
+	}
+	mutex_unlock(&mdsc->mutex);
+	seq_printf(s, "%-14s%-16d%-16lld%lld\n", "caps", nr_caps,
+		   percpu_counter_sum(&m->i_caps_mis),
+		   percpu_counter_sum(&m->i_caps_hit));
+
 	return 0;
 }
 
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 8097a86..10d528a 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -349,8 +349,9 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 	    !ceph_test_mount_opt(fsc, NOASYNCREADDIR) &&
 	    ceph_snap(inode) != CEPH_SNAPDIR &&
 	    __ceph_dir_is_complete_ordered(ci) &&
-	    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1)) {
+	    __ceph_caps_issued_mask_metric(ci, CEPH_CAP_FILE_SHARED, 1)) {
 		int shared_gen = atomic_read(&ci->i_shared_gen);
+
 		spin_unlock(&ci->i_ceph_lock);
 		err = __dcache_readdir(file, ctx, shared_gen);
 		if (err != -EAGAIN)
@@ -767,7 +768,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 		    !is_root_ceph_dentry(dir, dentry) &&
 		    ceph_test_mount_opt(fsc, DCACHE) &&
 		    __ceph_dir_is_complete(ci) &&
-		    (__ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1))) {
+		    __ceph_caps_issued_mask_metric(ci, CEPH_CAP_FILE_SHARED, 1)) {
 			__ceph_touch_fmode(ci, mdsc, CEPH_FILE_MODE_RD);
 			spin_unlock(&ci->i_ceph_lock);
 			dout(" dir %p complete, -ENOENT\n", dir);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 7fef94f..357c937 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2288,8 +2288,8 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
 
 	dout("do_getattr inode %p mask %s mode 0%o\n",
 	     inode, ceph_cap_string(mask), inode->i_mode);
-	if (!force && ceph_caps_issued_mask(ceph_inode(inode), mask, 1))
-		return 0;
+	if (!force && ceph_caps_issued_mask_metric(ceph_inode(inode), mask, 1))
+			return 0;
 
 	mode = (mask & CEPH_STAT_RSTAT) ? USE_AUTH_MDS : USE_ANY_MDS;
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, mode);
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 873a376..2a4b739 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -16,13 +16,29 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	ret = percpu_counter_init(&m->d_lease_hit, 0, GFP_KERNEL);
 	if (ret)
 		return ret;
+
 	ret = percpu_counter_init(&m->d_lease_mis, 0, GFP_KERNEL);
-	if (ret) {
-		percpu_counter_destroy(&m->d_lease_hit);
-		return ret;
-	}
+	if (ret)
+		goto err_d_lease_mis;
+
+	ret = percpu_counter_init(&m->i_caps_hit, 0, GFP_KERNEL);
+	if (ret)
+		goto err_i_caps_hit;
+
+	ret = percpu_counter_init(&m->i_caps_mis, 0, GFP_KERNEL);
+	if (ret)
+		goto err_i_caps_mis;
 
 	return 0;
+
+err_i_caps_mis:
+	percpu_counter_destroy(&m->i_caps_hit);
+err_i_caps_hit:
+	percpu_counter_destroy(&m->d_lease_mis);
+err_d_lease_mis:
+	percpu_counter_destroy(&m->d_lease_hit);
+
+	return ret;
 }
 
 void ceph_metric_destroy(struct ceph_client_metric *m)
@@ -30,6 +46,8 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 	if (!m)
 		return;
 
+	percpu_counter_destroy(&m->i_caps_mis);
+	percpu_counter_destroy(&m->i_caps_hit);
 	percpu_counter_destroy(&m->d_lease_mis);
 	percpu_counter_destroy(&m->d_lease_hit);
 }
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index da725da..098ee8a 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -10,8 +10,21 @@ struct ceph_client_metric {
 	atomic64_t            total_dentries;
 	struct percpu_counter d_lease_hit;
 	struct percpu_counter d_lease_mis;
+
+	struct percpu_counter i_caps_hit;
+	struct percpu_counter i_caps_mis;
 };
 
 extern int ceph_metric_init(struct ceph_client_metric *m);
 extern void ceph_metric_destroy(struct ceph_client_metric *m);
+
+static inline void ceph_update_cap_hit(struct ceph_client_metric *m)
+{
+	percpu_counter_inc(&m->i_caps_hit);
+}
+
+static inline void ceph_update_cap_mis(struct ceph_client_metric *m)
+{
+	percpu_counter_inc(&m->i_caps_mis);
+}
 #endif /* _FS_CEPH_MDS_METRIC_H */
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 5c73cf1..47cfd89 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -645,6 +645,8 @@ static inline bool __ceph_is_any_real_caps(struct ceph_inode_info *ci)
 
 extern int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented);
 extern int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int t);
+extern int __ceph_caps_issued_mask_metric(struct ceph_inode_info *ci, int mask,
+					  int t);
 extern int __ceph_caps_issued_other(struct ceph_inode_info *ci,
 				    struct ceph_cap *cap);
 
@@ -657,12 +659,12 @@ static inline int ceph_caps_issued(struct ceph_inode_info *ci)
 	return issued;
 }
 
-static inline int ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask,
-					int touch)
+static inline int ceph_caps_issued_mask_metric(struct ceph_inode_info *ci,
+					       int mask, int touch)
 {
 	int r;
 	spin_lock(&ci->i_ceph_lock);
-	r = __ceph_caps_issued_mask(ci, mask, touch);
+	r = __ceph_caps_issued_mask_metric(ci, mask, touch);
 	spin_unlock(&ci->i_ceph_lock);
 	return r;
 }
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 7b8a070..71ee34d 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -856,7 +856,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 
 	if (ci->i_xattrs.version == 0 ||
 	    !((req_mask & CEPH_CAP_XATTR_SHARED) ||
-	      __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1))) {
+	      __ceph_caps_issued_mask_metric(ci, CEPH_CAP_XATTR_SHARED, 1))) {
 		spin_unlock(&ci->i_ceph_lock);
 
 		/* security module gets xattr while filling trace */
@@ -914,7 +914,7 @@ ssize_t ceph_listxattr(struct dentry *dentry, char *names, size_t size)
 	     ci->i_xattrs.version, ci->i_xattrs.index_version);
 
 	if (ci->i_xattrs.version == 0 ||
-	    !__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1)) {
+	    !__ceph_caps_issued_mask_metric(ci, CEPH_CAP_XATTR_SHARED, 1)) {
 		spin_unlock(&ci->i_ceph_lock);
 		err = ceph_do_getattr(inode, CEPH_STAT_CAP_XATTR, true);
 		if (err)
-- 
1.8.3.1


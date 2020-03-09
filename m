Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C6217D9EE
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Mar 2020 08:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgCIHhb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Mar 2020 03:37:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36986 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725796AbgCIHhb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Mar 2020 03:37:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583739450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=UNQMpTZ0ZzfheRybgLUbnflGdEkH8zj5FouwuE1eTT8=;
        b=KHWPqmOajcaX0VALLwFllkaId0a8HIpXrvCiNIIdTi27+2JIa+Vqh4gq66ULpofFrczC2+
        Ch4qIY+nPVe89ciC0j09aa2BWoc0emBmNSynWv6fMN2ScvZ2JDGgidmSNmh8W/web71376
        1Jl7DTNWKiWYHnDC1pP412TZ2wn3h0M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177--xIVYBtyPt28FNqaT3DliQ-1; Mon, 09 Mar 2020 03:37:26 -0400
X-MC-Unique: -xIVYBtyPt28FNqaT3DliQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D59981005509;
        Mon,  9 Mar 2020 07:37:24 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49D3C5C10C;
        Mon,  9 Mar 2020 07:37:22 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v9 2/5] ceph: add caps perf metric for each session
Date:   Mon,  9 Mar 2020 03:37:07 -0400
Message-Id: <1583739430-4928-3-git-send-email-xiubli@redhat.com>
In-Reply-To: <1583739430-4928-1-git-send-email-xiubli@redhat.com>
References: <1583739430-4928-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will fulfill the cap hit/mis metric stuff per-superblock,
it will count the hit/mis counters based each inode, and if one
inode's 'issued & ~revoking == mask' will mean a hit, or a miss.

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
 fs/ceph/metric.h     | 13 +++++++++++++
 fs/ceph/super.h      |  8 +++++---
 fs/ceph/xattr.c      |  4 ++--
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
index 342a32c..efaeb67 100644
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
@@ -2680,6 +2694,11 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
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
index 15975ba..c83e52b 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -128,6 +128,7 @@ static int metric_show(struct seq_file *s, void *p)
 {
 	struct ceph_fs_client *fsc = s->private;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
+	int i, nr_caps = 0;
 
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
@@ -137,6 +138,21 @@ static int metric_show(struct seq_file *s, void *p)
 		   percpu_counter_sum(&mdsc->metric.d_lease_mis),
 		   percpu_counter_sum(&mdsc->metric.d_lease_hit));
 
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
+		   percpu_counter_sum(&mdsc->metric.i_caps_mis),
+		   percpu_counter_sum(&mdsc->metric.i_caps_hit));
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
index ee40ba7..b5a30ca6 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2284,8 +2284,8 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
 
 	dout("do_getattr inode %p mask %s mode 0%o\n",
 	     inode, ceph_cap_string(mask), inode->i_mode);
-	if (!force && ceph_caps_issued_mask(ceph_inode(inode), mask, 1))
-		return 0;
+	if (!force && ceph_caps_issued_mask_metric(ceph_inode(inode), mask, 1))
+			return 0;
 
 	mode = (mask & CEPH_STAT_RSTAT) ? USE_AUTH_MDS : USE_ANY_MDS;
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, mode);
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0e2557b..ba54fd2 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4332,13 +4332,29 @@ static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
 	ret = percpu_counter_init(&metric->d_lease_hit, 0, GFP_KERNEL);
 	if (ret)
 		return ret;
+
 	ret = percpu_counter_init(&metric->d_lease_mis, 0, GFP_KERNEL);
-	if (ret) {
-		percpu_counter_destroy(&metric->d_lease_hit);
-		return ret;
-	}
+	if (ret)
+		goto err_d_lease_mis;
+
+	ret = percpu_counter_init(&metric->i_caps_hit, 0, GFP_KERNEL);
+	if (ret)
+		goto err_i_caps_hit;
+
+	ret = percpu_counter_init(&metric->i_caps_mis, 0, GFP_KERNEL);
+	if (ret)
+		goto err_i_caps_mis;
 
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
 
 int ceph_mdsc_init(struct ceph_fs_client *fsc)
@@ -4678,6 +4694,8 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
 
 	ceph_mdsc_stop(mdsc);
 
+	percpu_counter_destroy(&mdsc->metric.i_caps_mis);
+	percpu_counter_destroy(&mdsc->metric.i_caps_hit);
 	percpu_counter_destroy(&mdsc->metric.d_lease_mis);
 	percpu_counter_destroy(&mdsc->metric.d_lease_hit);
 
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 998fe2a..f620f72 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -7,5 +7,18 @@ struct ceph_client_metric {
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


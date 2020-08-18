Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742A2248440
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Aug 2020 13:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgHRLxe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Aug 2020 07:53:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39247 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726552AbgHRLxd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Aug 2020 07:53:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597751611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=EOQMYDZrdAdI2EVu8yYnyy5Cc181uMowFKa6CKu7oyY=;
        b=f4LWC82Van3xSJ4bn6X+RR5lwuGhzy4+xXssCWN/ScUqszftE/OVIQuEHI+hKISsZXUOrC
        nz3hBjPjS7fg6l5PKiSvV0S7niZ7cGtb/YaDvAc4u3qb9yWUIypouNOVUizgwtfnnrNIVR
        6fqSXF88EqJDi2l5fIqglzmzht628t8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-TV-pKqi-NpW7s9EqfR_hGQ-1; Tue, 18 Aug 2020 07:53:26 -0400
X-MC-Unique: TV-pKqi-NpW7s9EqfR_hGQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8585D6383;
        Tue, 18 Aug 2020 11:53:25 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (vm37-202.gsslab.pek2.redhat.com [10.72.37.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94C7B7A1F1;
        Tue, 18 Aug 2020 11:53:23 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: add dirs/files' opened/opening metric support
Date:   Tue, 18 Aug 2020 07:53:17 -0400
Message-Id: <20200818115317.104579-1-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will add the opening/opened dirs/files metric in the debugfs.

item            total
---------------------------
dirs opening    1
dirs opened     0
files opening   2
files opened    23
pinned caps     5442

URL: https://tracker.ceph.com/issues/47005
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/debugfs.c |  9 +++++++++
 fs/ceph/file.c    | 22 ++++++++++++++++++++--
 fs/ceph/metric.c  |  5 +++++
 fs/ceph/metric.h  |  5 +++++
 4 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 97539b497e4c..20043382d825 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -148,6 +148,15 @@ static int metric_show(struct seq_file *s, void *p)
 	int nr_caps = 0;
 	s64 total, sum, avg, min, max, sq;
 
+	seq_printf(s, "item            total\n");
+	seq_printf(s, "---------------------------\n");
+	seq_printf(s, "dirs opening    %lld\n", atomic64_read(&m->dirs_opening));
+	seq_printf(s, "dirs opened     %lld\n", atomic64_read(&m->dirs_opened));
+	seq_printf(s, "files opening   %lld\n", atomic64_read(&m->files_opening));
+	seq_printf(s, "files opened    %lld\n", atomic64_read(&m->files_opened));
+	seq_printf(s, "pinned caps     %lld\n", atomic64_read(&m->total_caps));
+
+	seq_printf(s, "\n");
 	seq_printf(s, "item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)\n");
 	seq_printf(s, "-----------------------------------------------------------------------------------\n");
 
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 04ab99c0223a..5fa28a620932 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -205,6 +205,8 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
 					int fmode, bool isdir)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
+	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_file_info *fi;
 
 	dout("%s %p %p 0%o (%s)\n", __func__, inode, file,
@@ -212,20 +214,25 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
 	BUG_ON(inode->i_fop->release != ceph_release);
 
 	if (isdir) {
-		struct ceph_dir_file_info *dfi =
-			kmem_cache_zalloc(ceph_dir_file_cachep, GFP_KERNEL);
+		struct ceph_dir_file_info *dfi;
+
+		atomic64_dec(&mdsc->metric.dirs_opening);
+		dfi = kmem_cache_zalloc(ceph_dir_file_cachep, GFP_KERNEL);
 		if (!dfi)
 			return -ENOMEM;
 
+		atomic64_inc(&mdsc->metric.dirs_opened);
 		file->private_data = dfi;
 		fi = &dfi->file_info;
 		dfi->next_offset = 2;
 		dfi->readdir_cache_idx = -1;
 	} else {
+		atomic64_dec(&mdsc->metric.files_opening);
 		fi = kmem_cache_zalloc(ceph_file_cachep, GFP_KERNEL);
 		if (!fi)
 			return -ENOMEM;
 
+		atomic64_inc(&mdsc->metric.files_opened);
 		file->private_data = fi;
 	}
 
@@ -371,6 +378,11 @@ int ceph_open(struct inode *inode, struct file *file)
 		return ceph_init_file(inode, file, fmode);
 	}
 
+	if (S_ISDIR(inode->i_mode))
+		atomic64_inc(&mdsc->metric.dirs_opening);
+	else
+		atomic64_inc(&mdsc->metric.files_opening);
+
 	/*
 	 * No need to block if we have caps on the auth MDS (for
 	 * write) or any MDS (for read).  Update wanted set
@@ -408,6 +420,8 @@ int ceph_open(struct inode *inode, struct file *file)
 	req = prepare_open_request(inode->i_sb, flags, 0);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
+		atomic64_dec(&mdsc->metric.dirs_opening);
+		atomic64_dec(&mdsc->metric.files_opening);
 		goto out;
 	}
 	req->r_inode = inode;
@@ -783,12 +797,15 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 int ceph_release(struct inode *inode, struct file *file)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
+	struct ceph_mds_client *mdsc = fsc->mdsc;
 
 	if (S_ISDIR(inode->i_mode)) {
 		struct ceph_dir_file_info *dfi = file->private_data;
 		dout("release inode %p dir file %p\n", inode, file);
 		WARN_ON(!list_empty(&dfi->file_info.rw_contexts));
 
+		atomic64_dec(&mdsc->metric.dirs_opened);
 		ceph_put_fmode(ci, dfi->file_info.fmode, 1);
 
 		if (dfi->last_readdir)
@@ -801,6 +818,7 @@ int ceph_release(struct inode *inode, struct file *file)
 		dout("release inode %p regular file %p\n", inode, file);
 		WARN_ON(!list_empty(&fi->rw_contexts));
 
+		atomic64_dec(&mdsc->metric.files_opened);
 		ceph_put_fmode(ci, fi->fmode, 1);
 
 		kmem_cache_free(ceph_file_cachep, fi);
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 2466b261fba2..bf49941e02bd 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -192,6 +192,11 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	m->total_metadatas = 0;
 	m->metadata_latency_sum = 0;
 
+        atomic64_set(&m->dirs_opening, 0);
+        atomic64_set(&m->dirs_opened, 0);
+        atomic64_set(&m->files_opening, 0);
+        atomic64_set(&m->files_opened, 0);
+
 	m->session = NULL;
 	INIT_DELAYED_WORK(&m->delayed_work, metric_delayed_work);
 
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 1d0959d669d7..621d31d7b1e3 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -115,6 +115,11 @@ struct ceph_client_metric {
 	ktime_t metadata_latency_min;
 	ktime_t metadata_latency_max;
 
+        atomic64_t dirs_opening;
+        atomic64_t dirs_opened;
+        atomic64_t files_opening;
+        atomic64_t files_opened;
+
 	struct ceph_mds_session *session;
 	struct delayed_work delayed_work;  /* delayed work */
 };
-- 
2.18.4


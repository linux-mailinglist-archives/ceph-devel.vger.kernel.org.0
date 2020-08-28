Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF022552EC
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Aug 2020 04:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgH1COB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Aug 2020 22:14:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41340 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726147AbgH1COB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Aug 2020 22:14:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598580838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=GUnedCRLoXQVavWKSZ1E4mXMJX+cX04Qc21uspNqR5A=;
        b=LYXclLdksQMeDcN5suThXEi98x1r6UeYClIxdOA3NSdnb9wuIyXXheHHLgOSXjcQ8QbDdS
        I8fBAVDOGuSaHEv28Qv53Az4HOkNye4WsgdiPp5+ozrWkC+0i8t02LIZjlDKRraDSMm7Wc
        24+i9VzDOI+qQlZFTjgjmpc7+vRfML0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-DVHr5YgIOqGVf1UdN9nUGg-1; Thu, 27 Aug 2020 22:13:54 -0400
X-MC-Unique: DVHr5YgIOqGVf1UdN9nUGg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 370F280733C;
        Fri, 28 Aug 2020 02:13:53 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (vm37-202.gsslab.pek2.redhat.com [10.72.37.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A5816716C;
        Fri, 28 Aug 2020 02:13:50 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 2/2] ceph: metrics for opened files, pinned caps and opened inodes
Date:   Thu, 27 Aug 2020 22:13:36 -0400
Message-Id: <20200828021336.99898-3-xiubli@redhat.com>
In-Reply-To: <20200828021336.99898-1-xiubli@redhat.com>
References: <20200828021336.99898-1-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

In client for each inode, it may have many opened files and may
have been pinned in more than one MDS servers. And some inodes
are idle, which have no any opened files.

This patch will show these metrics in the debugfs, likes:

item                               total
-----------------------------------------
opened files  / total inodes       14 / 5
pinned i_caps / total inodes       7  / 5
opened inodes / total inodes       3  / 5

Will send these metrics to ceph, which will be used by the `fs top`,
later.

URL: https://tracker.ceph.com/issues/47005
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c    | 27 +++++++++++++++++++++++++--
 fs/ceph/debugfs.c | 11 +++++++++++
 fs/ceph/file.c    |  5 +++--
 fs/ceph/inode.c   |  7 +++++++
 fs/ceph/metric.c  | 14 ++++++++++++++
 fs/ceph/metric.h  |  7 +++++++
 fs/ceph/super.h   |  1 +
 7 files changed, 68 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index ad69c411afba..6916def40b3d 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4283,13 +4283,23 @@ void __ceph_touch_fmode(struct ceph_inode_info *ci,
 
 void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
 {
-	int i;
+	struct ceph_mds_client *mdsc = ceph_ci_to_mdsc(ci);
 	int bits = (fmode << 1) | 1;
+	int i;
+
+	if (count == 1)
+		atomic64_inc(&mdsc->metric.opened_files);
+
 	spin_lock(&ci->i_ceph_lock);
 	for (i = 0; i < CEPH_FILE_MODE_BITS; i++) {
 		if (bits & (1 << i))
 			ci->i_nr_by_mode[i] += count;
 	}
+
+	if (!ci->is_opened && fmode) {
+		ci->is_opened = true;
+		percpu_counter_inc(&mdsc->metric.opened_inodes);
+	}
 	spin_unlock(&ci->i_ceph_lock);
 }
 
@@ -4300,15 +4310,28 @@ void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
  */
 void ceph_put_fmode(struct ceph_inode_info *ci, int fmode, int count)
 {
-	int i;
+	struct ceph_mds_client *mdsc = ceph_ci_to_mdsc(ci);
 	int bits = (fmode << 1) | 1;
+	bool empty = true;
+	int i;
+
+	if (count == 1)
+		atomic64_dec(&mdsc->metric.opened_files);
+
 	spin_lock(&ci->i_ceph_lock);
 	for (i = 0; i < CEPH_FILE_MODE_BITS; i++) {
 		if (bits & (1 << i)) {
 			BUG_ON(ci->i_nr_by_mode[i] < count);
 			ci->i_nr_by_mode[i] -= count;
+			if (ci->i_nr_by_mode[i] && i) /* Skip the pin ref */
+				empty = false;
 		}
 	}
+
+	if (ci->is_opened && empty && fmode) {
+		ci->is_opened = false;
+		percpu_counter_dec(&mdsc->metric.opened_inodes);
+	}
 	spin_unlock(&ci->i_ceph_lock);
 }
 
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 97539b497e4c..9efd3982230d 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -148,6 +148,17 @@ static int metric_show(struct seq_file *s, void *p)
 	int nr_caps = 0;
 	s64 total, sum, avg, min, max, sq;
 
+	sum = percpu_counter_sum(&m->total_inodes);
+	seq_printf(s, "item                               total\n");
+	seq_printf(s, "------------------------------------------\n");
+	seq_printf(s, "%-35s%lld / %lld\n", "opened files  / total inodes",
+		   atomic64_read(&m->opened_files), sum);
+	seq_printf(s, "%-35s%lld / %lld\n", "pinned i_caps / total inodes",
+		   atomic64_read(&m->total_caps), sum);
+	seq_printf(s, "%-35s%lld / %lld\n", "opened inodes / total inodes",
+		   percpu_counter_sum(&m->opened_inodes), sum);
+
+	seq_printf(s, "\n");
 	seq_printf(s, "item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)\n");
 	seq_printf(s, "-----------------------------------------------------------------------------------\n");
 
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index c788cce7885b..6e2aed0f7f75 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -211,8 +211,9 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
 	BUG_ON(inode->i_fop->release != ceph_release);
 
 	if (isdir) {
-		struct ceph_dir_file_info *dfi =
-			kmem_cache_zalloc(ceph_dir_file_cachep, GFP_KERNEL);
+		struct ceph_dir_file_info *dfi;
+
+		dfi = kmem_cache_zalloc(ceph_dir_file_cachep, GFP_KERNEL);
 		if (!dfi)
 			return -ENOMEM;
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 39b1007903d9..a152be9b9a34 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -426,6 +426,7 @@ static int ceph_fill_fragtree(struct inode *inode,
  */
 struct inode *ceph_alloc_inode(struct super_block *sb)
 {
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(sb);
 	struct ceph_inode_info *ci;
 	int i;
 
@@ -485,6 +486,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 	ci->i_last_rd = ci->i_last_wr = jiffies - 3600 * HZ;
 	for (i = 0; i < CEPH_FILE_MODE_BITS; i++)
 		ci->i_nr_by_mode[i] = 0;
+	ci->is_opened = false;
 
 	mutex_init(&ci->i_truncate_mutex);
 	ci->i_truncate_seq = 0;
@@ -525,12 +527,17 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 
 	ci->i_meta_err = 0;
 
+	percpu_counter_inc(&mdsc->metric.total_inodes);
+
 	return &ci->vfs_inode;
 }
 
 void ceph_free_inode(struct inode *inode)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
+
+	percpu_counter_dec(&mdsc->metric.total_inodes);
 
 	kfree(ci->i_symlink);
 	kmem_cache_free(ceph_inode_cachep, ci);
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 2466b261fba2..fee4c4778313 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -192,11 +192,23 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	m->total_metadatas = 0;
 	m->metadata_latency_sum = 0;
 
+	atomic64_set(&m->opened_files, 0);
+	ret = percpu_counter_init(&m->opened_inodes, 0, GFP_KERNEL);
+	if (ret)
+		goto err_opened_inodes;
+	ret = percpu_counter_init(&m->total_inodes, 0, GFP_KERNEL);
+	if (ret)
+		goto err_total_inodes;
+
 	m->session = NULL;
 	INIT_DELAYED_WORK(&m->delayed_work, metric_delayed_work);
 
 	return 0;
 
+err_total_inodes:
+	percpu_counter_destroy(&m->opened_inodes);
+err_opened_inodes:
+	percpu_counter_destroy(&m->i_caps_mis);
 err_i_caps_mis:
 	percpu_counter_destroy(&m->i_caps_hit);
 err_i_caps_hit:
@@ -212,6 +224,8 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 	if (!m)
 		return;
 
+	percpu_counter_destroy(&m->total_inodes);
+	percpu_counter_destroy(&m->opened_inodes);
 	percpu_counter_destroy(&m->i_caps_mis);
 	percpu_counter_destroy(&m->i_caps_hit);
 	percpu_counter_destroy(&m->d_lease_mis);
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 1d0959d669d7..710f3f1dceab 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -115,6 +115,13 @@ struct ceph_client_metric {
 	ktime_t metadata_latency_min;
 	ktime_t metadata_latency_max;
 
+	/* The total number of directories and files that are opened */
+	atomic64_t opened_files;
+
+	/* The total number of inodes that have opened files or directories */
+	struct percpu_counter opened_inodes;
+	struct percpu_counter total_inodes;
+
 	struct ceph_mds_session *session;
 	struct delayed_work delayed_work;  /* delayed work */
 };
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 476d182c2ff0..852b755e2224 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -387,6 +387,7 @@ struct ceph_inode_info {
 	unsigned long i_last_rd;
 	unsigned long i_last_wr;
 	int i_nr_by_mode[CEPH_FILE_MODE_BITS];  /* open file counts */
+	bool is_opened; /* has opened files or directors */
 
 	struct mutex i_truncate_mutex;
 	u32 i_truncate_seq;        /* last truncate to smaller size */
-- 
2.18.4


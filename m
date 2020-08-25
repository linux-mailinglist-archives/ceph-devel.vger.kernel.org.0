Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EE1250DEE
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Aug 2020 02:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgHYAzS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Aug 2020 20:55:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45729 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728074AbgHYAzS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Aug 2020 20:55:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598316916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=avg4b5cFmGCDD1DFFW+2w990EkSynw700IiGFLJzL9M=;
        b=Ro+pklZB39Bo4r79FaV+nlOaZ1DXEKM9nTGRLYEDq+pP0yJvLe0BJSgdv3EX3eBBq0VI/r
        7p3n8NfpWhEUon8KmpgEhf3RGeiz9I6ksCEqNiP8pG/rO8etVxo7zUxzbj1K4NG1PAG3J0
        z3E3z9TAaEj1U4GW5ech77ilzq2TIaQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-aCu3s603MIqn66ga_667dQ-1; Mon, 24 Aug 2020 20:55:11 -0400
X-MC-Unique: aCu3s603MIqn66ga_667dQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4D1F81F01A;
        Tue, 25 Aug 2020 00:55:10 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (vm37-202.gsslab.pek2.redhat.com [10.72.37.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBBED19C58;
        Tue, 25 Aug 2020 00:55:08 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 2/2] ceph: metrics for opened files, pinned caps and opened inodes
Date:   Mon, 24 Aug 2020 20:54:54 -0400
Message-Id: <20200825005454.2222920-3-xiubli@redhat.com>
In-Reply-To: <20200825005454.2222920-1-xiubli@redhat.com>
References: <20200825005454.2222920-1-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
index 39b1007903d9..1bedbe4737ec 100644
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
@@ -525,6 +527,8 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 
 	ci->i_meta_err = 0;
 
+	percpu_counter_inc(&mdsc->metric.total_inodes);
+
 	return &ci->vfs_inode;
 }
 
@@ -539,6 +543,7 @@ void ceph_free_inode(struct inode *inode)
 void ceph_evict_inode(struct inode *inode)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
 	struct ceph_inode_frag *frag;
 	struct rb_node *n;
 
@@ -592,6 +597,8 @@ void ceph_evict_inode(struct inode *inode)
 
 	ceph_put_string(rcu_dereference_raw(ci->i_layout.pool_ns));
 	ceph_put_string(rcu_dereference_raw(ci->i_cached_layout.pool_ns));
+
+	percpu_counter_dec(&mdsc->metric.total_inodes);
 }
 
 static inline blkcnt_t calc_inode_blocks(u64 size)
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 2466b261fba2..c7c6fe6a383b 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -192,11 +192,23 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	m->total_metadatas = 0;
 	m->metadata_latency_sum = 0;
 
+	atomic64_set(&m->opened_files, 0);
+	ret = percpu_counter_init(&m->opened_inodes, 0, GFP_KERNEL);
+	if (ret)
+		goto err_opened_inodes;
+	ret = percpu_counter_init(&m->opened_inodes, 0, GFP_KERNEL);
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


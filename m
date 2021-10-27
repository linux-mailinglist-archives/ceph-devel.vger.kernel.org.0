Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947F943C743
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Oct 2021 12:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbhJ0KEA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Oct 2021 06:04:00 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:38120 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241325AbhJ0KD7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Oct 2021 06:03:59 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3712A1FD3B;
        Wed, 27 Oct 2021 10:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635328893; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H/0+0Zo3cc7rEgF/ZOuuBDFDDHgW6V1r3WPoB1eEpfI=;
        b=iMAIWBnIpq1KpT79i3hFlM60tB3UDGgnAcCs3lpDeqZWLBSZxwC+Km0t9VkDo3CyuJ6A5Y
        5h71cLUWN1qIaRHJrg5IihrtbD0/D3hQZ0knn1FlRXnFJcXEMJI7sEVNg+tut3cRk0XR+M
        1Ce2d7gEaZBriyb8lv6EjwjhmFl5dbU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635328893;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H/0+0Zo3cc7rEgF/ZOuuBDFDDHgW6V1r3WPoB1eEpfI=;
        b=qvRBoinEKNDwqn+c9jqI8SXhmSN+CHWZOIPEkO0R+itn+rMmEs84q4vl3GdBs2IlFbyNr9
        Y2Rq5/wQRiT+nCBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BC13D13B85;
        Wed, 27 Oct 2021 10:01:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id W8TEKnwjeWEnPAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 27 Oct 2021 10:01:32 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 98d6c3ef;
        Wed, 27 Oct 2021 10:01:32 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH] ceph: split 'metric' debugfs file into several files
Date:   Wed, 27 Oct 2021 11:01:30 +0100
Message-Id: <20211027100130.15227-1-lhenriques@suse.de>
In-Reply-To: <1ac925e3-5596-dcf4-317e-1408c764350f@redhat.com>
References: <1ac925e3-5596-dcf4-317e-1408c764350f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently, all the metrics are grouped together in a single file, making
it difficult to process this file from scripts.  Furthermore, as new
metrics are added, processing this file will become even more challenging.

This patch turns the 'metric' file into a directory that will contain
several files, one for each metric.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
Here's a patch that does just what I proposed.  It simply turns the metric
file into a directory.  Not sure this is the best option, but here it is
for discussion.

Cheers,
--
Luís

 fs/ceph/debugfs.c | 81 ++++++++++++++++++++++++++++++++---------------
 fs/ceph/super.h   |  2 +-
 2 files changed, 57 insertions(+), 26 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 38b78b45811f..55426514491b 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -146,26 +146,30 @@ static int mdsc_show(struct seq_file *s, void *p)
 		   name, total, avg, _min, max, sum);			\
 }
 
-static int metric_show(struct seq_file *s, void *p)
+static int metrics_file_show(struct seq_file *s, void *p)
 {
 	struct ceph_fs_client *fsc = s->private;
-	struct ceph_mds_client *mdsc = fsc->mdsc;
-	struct ceph_client_metric *m = &mdsc->metric;
-	int nr_caps = 0;
-	s64 total, sum, avg, min, max, sq;
-	u64 sum_sz, avg_sz, min_sz, max_sz;
+	struct ceph_client_metric *m = &fsc->mdsc->metric;
 
-	sum = percpu_counter_sum(&m->total_inodes);
 	seq_printf(s, "item                               total\n");
 	seq_printf(s, "------------------------------------------\n");
-	seq_printf(s, "%-35s%lld / %lld\n", "opened files  / total inodes",
-		   atomic64_read(&m->opened_files), sum);
-	seq_printf(s, "%-35s%lld / %lld\n", "pinned i_caps / total inodes",
-		   atomic64_read(&m->total_caps), sum);
-	seq_printf(s, "%-35s%lld / %lld\n", "opened inodes / total inodes",
-		   percpu_counter_sum(&m->opened_inodes), sum);
-
-	seq_printf(s, "\n");
+	seq_printf(s, "%-35s%lld\n", "total inodes",
+		   percpu_counter_sum(&m->total_inodes));
+	seq_printf(s, "%-35s%lld\n", "opened files",
+		   atomic64_read(&m->opened_files));
+	seq_printf(s, "%-35s%lld\n", "pinned i_caps",
+		   atomic64_read(&m->total_caps));
+	seq_printf(s, "%-35s%lld\n", "opened inodes",
+		   percpu_counter_sum(&m->opened_inodes));
+	return 0;
+}
+
+static int metrics_latency_show(struct seq_file *s, void *p)
+{
+	struct ceph_fs_client *fsc = s->private;
+	struct ceph_client_metric *m = &fsc->mdsc->metric;
+	s64 total, sum, avg, min, max, sq;
+
 	seq_printf(s, "item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)\n");
 	seq_printf(s, "-----------------------------------------------------------------------------------\n");
 
@@ -199,7 +203,16 @@ static int metric_show(struct seq_file *s, void *p)
 	spin_unlock(&m->metadata_metric_lock);
 	CEPH_LAT_METRIC_SHOW("metadata", total, avg, min, max, sq);
 
-	seq_printf(s, "\n");
+	return 0;
+}
+
+static int metrics_size_show(struct seq_file *s, void *p)
+{
+	struct ceph_fs_client *fsc = s->private;
+	struct ceph_client_metric *m = &fsc->mdsc->metric;
+	s64 total;
+	u64 sum_sz, avg_sz, min_sz, max_sz;
+
 	seq_printf(s, "item          total       avg_sz(bytes)   min_sz(bytes)   max_sz(bytes)  total_sz(bytes)\n");
 	seq_printf(s, "----------------------------------------------------------------------------------------\n");
 
@@ -221,7 +234,15 @@ static int metric_show(struct seq_file *s, void *p)
 	spin_unlock(&m->write_metric_lock);
 	CEPH_SZ_METRIC_SHOW("write", total, avg_sz, min_sz, max_sz, sum_sz);
 
-	seq_printf(s, "\n");
+	return 0;
+}
+
+static int metrics_caps_show(struct seq_file *s, void *p)
+{
+	struct ceph_fs_client *fsc = s->private;
+	struct ceph_client_metric *m = &fsc->mdsc->metric;
+	int nr_caps = 0;
+
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
 
@@ -350,8 +371,11 @@ DEFINE_SHOW_ATTRIBUTE(mdsmap);
 DEFINE_SHOW_ATTRIBUTE(mdsc);
 DEFINE_SHOW_ATTRIBUTE(caps);
 DEFINE_SHOW_ATTRIBUTE(mds_sessions);
-DEFINE_SHOW_ATTRIBUTE(metric);
 DEFINE_SHOW_ATTRIBUTE(status);
+DEFINE_SHOW_ATTRIBUTE(metrics_file);
+DEFINE_SHOW_ATTRIBUTE(metrics_latency);
+DEFINE_SHOW_ATTRIBUTE(metrics_size);
+DEFINE_SHOW_ATTRIBUTE(metrics_caps);
 
 
 /*
@@ -385,8 +409,9 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
 	debugfs_remove(fsc->debugfs_mdsmap);
 	debugfs_remove(fsc->debugfs_mds_sessions);
 	debugfs_remove(fsc->debugfs_caps);
-	debugfs_remove(fsc->debugfs_metric);
+	debugfs_remove(fsc->debugfs_status);
 	debugfs_remove(fsc->debugfs_mdsc);
+	debugfs_remove_recursive(fsc->debugfs_metrics_dir);
 }
 
 void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
@@ -426,12 +451,6 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 						fsc,
 						&mdsc_fops);
 
-	fsc->debugfs_metric = debugfs_create_file("metrics",
-						  0400,
-						  fsc->client->debugfs_dir,
-						  fsc,
-						  &metric_fops);
-
 	fsc->debugfs_caps = debugfs_create_file("caps",
 						0400,
 						fsc->client->debugfs_dir,
@@ -443,6 +462,18 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 						  fsc->client->debugfs_dir,
 						  fsc,
 						  &status_fops);
+
+	fsc->debugfs_metrics_dir = debugfs_create_dir("metrics",
+						      fsc->client->debugfs_dir);
+
+	debugfs_create_file("file", 0400, fsc->debugfs_metrics_dir, fsc,
+			    &metrics_file_fops);
+	debugfs_create_file("latency", 0400, fsc->debugfs_metrics_dir, fsc,
+			    &metrics_latency_fops);
+	debugfs_create_file("size", 0400, fsc->debugfs_metrics_dir, fsc,
+			    &metrics_size_fops);
+	debugfs_create_file("caps", 0400, fsc->debugfs_metrics_dir, fsc,
+			    &metrics_caps_fops);
 }
 
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 14f951cd5b61..795b077143d6 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -128,9 +128,9 @@ struct ceph_fs_client {
 	struct dentry *debugfs_congestion_kb;
 	struct dentry *debugfs_bdi;
 	struct dentry *debugfs_mdsc, *debugfs_mdsmap;
-	struct dentry *debugfs_metric;
 	struct dentry *debugfs_status;
 	struct dentry *debugfs_mds_sessions;
+	struct dentry *debugfs_metrics_dir;
 #endif
 
 #ifdef CONFIG_CEPH_FSCACHE

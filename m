Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E73A3D0F2D
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Jul 2021 15:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbhGUM0B (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 21 Jul 2021 08:26:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234331AbhGUMZ6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 21 Jul 2021 08:25:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5764F61029;
        Wed, 21 Jul 2021 13:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626872791;
        bh=2Kzp8AYy0aJjR41MjIa9HUoN2VBdL8wpsVdzc1dRlmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNaQipPLzf706u1kWC0SB8ycYU+Q2uf0RWT1aEpbzg/eAU3vrWc240XvqQ8Xn9cjU
         VfUJUwc4JRrhlUwyllPg3c2ycKang+47OoPRqpGQHxAYD98o9zONix8DcM29nQe9sV
         h+oIsUjxibq/8SfrKlozMt1Uem98hK3zdqvfV+MABJ8Op6yqL7hq11ZtIAfTeEaqIu
         1r2/7Sul4FJrDuu38jusClZZVeFOROdOmzarlgQyzVHf3ExOsGLV25u8g+Is9ehKjj
         4/XKWDxHKu419q4+VA0mKrc2UGjCaes8DPCx6G3lNwFf2PYoAGI/AfdY6s4aSz5/3o
         87YJ/JO89aiSg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com
Subject: [PATCH v2] ceph: dump info about cap flushes when we're waiting too long for them
Date:   Wed, 21 Jul 2021 09:06:30 -0400
Message-Id: <20210721130630.11390-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707171942.38428-1-jlayton@kernel.org>
References: <20210707171942.38428-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We've had some cases of hung umounts in teuthology testing. It looks
like client is waiting for cap flushes to complete, but they aren't.

Add a field to the inode to track the highest cap flush tid seen for
that inode. Also, add a backpointer to the inode to the ceph_cap_flush
struct.

Change wait_caps_flush to wait 60s, and then dump info about the
condition of the list.

Reported-by: Patrick Donnelly <pdonnell@redhat.com>
URL: https://tracker.ceph.com/issues/51279
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c       |  5 +++++
 fs/ceph/inode.c      |  1 +
 fs/ceph/mds_client.c | 30 ++++++++++++++++++++++++++++--
 fs/ceph/super.h      |  2 ++
 4 files changed, 36 insertions(+), 2 deletions(-)

I revised this patch a bit to gather some more info. Again, I'll put
this into the testing kernel with a [DO NOT MERGE] tag.

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 7ae83d06d48c..6c24b2eb865c 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1829,6 +1829,7 @@ static u64 __mark_caps_flushing(struct inode *inode,
 	swap(cf, ci->i_prealloc_cap_flush);
 	cf->caps = flushing;
 	cf->wake = wake;
+	cf->ci = ci;
 
 	spin_lock(&mdsc->cap_dirty_lock);
 	list_del_init(&ci->i_dirty_item);
@@ -3588,6 +3589,10 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
 	bool wake_ci = false;
 	bool wake_mdsc = false;
 
+	/* track latest cap flush ack seen for this inode */
+	if (flush_tid > ci->i_last_cap_flush_ack)
+		ci->i_last_cap_flush_ack = flush_tid;
+
 	list_for_each_entry_safe(cf, tmp_cf, &ci->i_cap_flush_list, i_list) {
 		/* Is this the one that was flushed? */
 		if (cf->tid == flush_tid)
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 1bd2cc015913..84e4f112fc45 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -499,6 +499,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 	INIT_LIST_HEAD(&ci->i_cap_snaps);
 	ci->i_head_snapc = NULL;
 	ci->i_snap_caps = 0;
+	ci->i_last_cap_flush_ack = 0;
 
 	ci->i_last_rd = ci->i_last_wr = jiffies - 3600 * HZ;
 	for (i = 0; i < CEPH_FILE_MODE_BITS; i++)
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c3fa0c0e4f6c..c43091a30ba8 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2064,6 +2064,23 @@ static int check_caps_flush(struct ceph_mds_client *mdsc,
 	return ret;
 }
 
+static void dump_cap_flushes(struct ceph_mds_client *mdsc, u64 want_tid)
+{
+	struct ceph_cap_flush *cf;
+
+	pr_info("%s: still waiting for cap flushes through %llu\n:\n",
+		__func__, want_tid);
+	spin_lock(&mdsc->cap_dirty_lock);
+	list_for_each_entry(cf, &mdsc->cap_flush_list, g_list) {
+		if (cf->tid > want_tid)
+			break;
+		pr_info("0x%llx %s %llu %llu %d\n", cf->ci->i_vino.ino,
+			ceph_cap_string(cf->caps), cf->tid,
+			cf->ci->i_last_cap_flush_ack, cf->wake);
+	}
+	spin_unlock(&mdsc->cap_dirty_lock);
+}
+
 /*
  * flush all dirty inode data to disk.
  *
@@ -2072,10 +2089,19 @@ static int check_caps_flush(struct ceph_mds_client *mdsc,
 static void wait_caps_flush(struct ceph_mds_client *mdsc,
 			    u64 want_flush_tid)
 {
+	long ret;
+
 	dout("check_caps_flush want %llu\n", want_flush_tid);
 
-	wait_event(mdsc->cap_flushing_wq,
-		   check_caps_flush(mdsc, want_flush_tid));
+	do {
+		ret = wait_event_timeout(mdsc->cap_flushing_wq,
+			   check_caps_flush(mdsc, want_flush_tid), 60 * HZ);
+		if (ret == 0)
+			dump_cap_flushes(mdsc, want_flush_tid);
+		else if (ret == 1)
+			pr_info("%s: condition evaluated to true after timeout!\n",
+				  __func__);
+	} while (ret == 0);
 
 	dout("check_caps_flush ok, flushed thru %llu\n", want_flush_tid);
 }
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 07eb542efa1d..d51d42a00f33 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -189,6 +189,7 @@ struct ceph_cap_flush {
 	bool wake; /* wake up flush waiters when finish ? */
 	struct list_head g_list; // global
 	struct list_head i_list; // per inode
+	struct ceph_inode_info *ci;
 };
 
 /*
@@ -388,6 +389,7 @@ struct ceph_inode_info {
 	struct ceph_snap_context *i_head_snapc;  /* set if wr_buffer_head > 0 or
 						    dirty|flushing caps */
 	unsigned i_snap_caps;           /* cap bits for snapped files */
+	u64 i_last_cap_flush_ack;		/* latest cap flush_ack tid for this inode */
 
 	unsigned long i_last_rd;
 	unsigned long i_last_wr;
-- 
2.31.1


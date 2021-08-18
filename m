Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A163F04F5
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 15:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbhHRNj0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 09:39:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46835 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236270AbhHRNjZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 09:39:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629293930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ci08CMgNcNfjSXqQW7CbL/aaukxqUsr4Rgfn/AzWIQU=;
        b=Czu3a7Kpk5Xn5ymNGVmKEsI3X7gH1/AmgotE6guRdLEdsRy0huRTw3paMfMMEd4cpL+P7h
        N1V+CSnYhA3yb9niNQSLdAUGkA6KZYHDYdVT1eI4ch08M8jVd2QUIlaboeICwlbngYwvHj
        /lbgEfzYIj3lZmbu7VWZIJ+uZ00K2FQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-EPYeuNcFOqqr3olxjL1P5A-1; Wed, 18 Aug 2021 09:38:49 -0400
X-MC-Unique: EPYeuNcFOqqr3olxjL1P5A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B7E2190B2A0;
        Wed, 18 Aug 2021 13:38:48 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2453510013D7;
        Wed, 18 Aug 2021 13:38:45 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4] ceph: correctly release memory from capsnap
Date:   Wed, 18 Aug 2021 21:38:42 +0800
Message-Id: <20210818133842.15993-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When force umounting, it will try to remove all the session caps.
If there has any capsnap is in the flushing list, the remove session
caps callback will try to release the capsnap->flush_cap memory to
"ceph_cap_flush_cachep" slab cache, while which is allocated from
kmalloc-256 slab cache.

At the same time switch to list_del_init() because just in case the
force umount has removed it from the lists and the
handle_cap_flushsnap_ack() comes then the seconds list_del_init()
won't crash the kernel.

URL: https://tracker.ceph.com/issues/52283
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

Changed in V4:
- add a new is_capsnap field in ceph_cap_flush struct.


 fs/ceph/caps.c       | 19 ++++++++++++-------
 fs/ceph/mds_client.c |  7 ++++---
 fs/ceph/snap.c       |  1 +
 fs/ceph/super.h      |  3 ++-
 4 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 4663ab830614..52c7026fd0d1 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1712,7 +1712,11 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
 
 struct ceph_cap_flush *ceph_alloc_cap_flush(void)
 {
-	return kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
+	struct ceph_cap_flush *cf;
+
+	cf = kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
+	cf->is_capsnap = false;
+	return cf;
 }
 
 void ceph_free_cap_flush(struct ceph_cap_flush *cf)
@@ -1747,7 +1751,7 @@ static bool __detach_cap_flush_from_mdsc(struct ceph_mds_client *mdsc,
 		prev->wake = true;
 		wake = false;
 	}
-	list_del(&cf->g_list);
+	list_del_init(&cf->g_list);
 	return wake;
 }
 
@@ -1762,7 +1766,7 @@ static bool __detach_cap_flush_from_ci(struct ceph_inode_info *ci,
 		prev->wake = true;
 		wake = false;
 	}
-	list_del(&cf->i_list);
+	list_del_init(&cf->i_list);
 	return wake;
 }
 
@@ -2400,7 +2404,7 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
 	ci->i_ceph_flags &= ~CEPH_I_KICK_FLUSH;
 
 	list_for_each_entry_reverse(cf, &ci->i_cap_flush_list, i_list) {
-		if (!cf->caps) {
+		if (cf->is_capsnap) {
 			last_snap_flush = cf->tid;
 			break;
 		}
@@ -2419,7 +2423,7 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
 
 		first_tid = cf->tid + 1;
 
-		if (cf->caps) {
+		if (!cf->is_capsnap) {
 			struct cap_msg_args arg;
 
 			dout("kick_flushing_caps %p cap %p tid %llu %s\n",
@@ -3568,7 +3572,7 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
 			cleaned = cf->caps;
 
 		/* Is this a capsnap? */
-		if (cf->caps == 0)
+		if (cf->is_capsnap)
 			continue;
 
 		if (cf->tid <= flush_tid) {
@@ -3642,7 +3646,8 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
 		cf = list_first_entry(&to_remove,
 				      struct ceph_cap_flush, i_list);
 		list_del(&cf->i_list);
-		ceph_free_cap_flush(cf);
+		if (!cf->is_capsnap)
+			ceph_free_cap_flush(cf);
 	}
 
 	if (wake_ci)
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index dcb5f34a084b..b9e6a69cc058 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1656,7 +1656,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		spin_lock(&mdsc->cap_dirty_lock);
 
 		list_for_each_entry(cf, &to_remove, i_list)
-			list_del(&cf->g_list);
+			list_del_init(&cf->g_list);
 
 		if (!list_empty(&ci->i_dirty_item)) {
 			pr_warn_ratelimited(
@@ -1710,8 +1710,9 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		struct ceph_cap_flush *cf;
 		cf = list_first_entry(&to_remove,
 				      struct ceph_cap_flush, i_list);
-		list_del(&cf->i_list);
-		ceph_free_cap_flush(cf);
+		list_del_init(&cf->i_list);
+		if (!cf->is_capsnap)
+			ceph_free_cap_flush(cf);
 	}
 
 	wake_up_all(&ci->i_cap_wq);
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index af502a8245f0..62fab59bbf96 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -487,6 +487,7 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
 		pr_err("ENOMEM allocating ceph_cap_snap on %p\n", inode);
 		return;
 	}
+	capsnap->cap_flush.is_capsnap = true;
 
 	spin_lock(&ci->i_ceph_lock);
 	used = __ceph_caps_used(ci);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 106ddfd1ce92..336350861791 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -186,8 +186,9 @@ struct ceph_cap {
 
 struct ceph_cap_flush {
 	u64 tid;
-	int caps; /* 0 means capsnap */
+	int caps;
 	bool wake; /* wake up flush waiters when finish ? */
+	bool is_capsnap; /* true means capsnap */
 	struct list_head g_list; // global
 	struct list_head i_list; // per inode
 	struct ceph_inode_info *ci;
-- 
2.27.0


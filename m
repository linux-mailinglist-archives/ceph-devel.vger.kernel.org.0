Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBEC3EF77C
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 03:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbhHRB0D (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Aug 2021 21:26:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20671 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234120AbhHRB0A (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 21:26:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629249926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SgtTtEtJMlS9xidUfdxjbNMthEnDLC7/Jw4KFx8WCfU=;
        b=SsJOGGB7ZvW9c/cwrh8HVakT+hVUKWm1HwyacaLRnFD4GTttwTxORV/diuTSe3yK96bdC8
        voLGyIzhfz+hS9Soa7TbHinlZ5qahNzKlMvINGGPt8xfwxhxnDC/IPQNR1+ofvlAGTTPSE
        rmEqLIhnCzFet4qMSmTxoWQkJpP476U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-VDoxaygxNcKGm-dtytQRQw-1; Tue, 17 Aug 2021 21:25:23 -0400
X-MC-Unique: VDoxaygxNcKGm-dtytQRQw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 138141008063;
        Wed, 18 Aug 2021 01:25:22 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1936E19D9D;
        Wed, 18 Aug 2021 01:25:19 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3] ceph: correctly release memory from capsnap
Date:   Wed, 18 Aug 2021 09:25:15 +0800
Message-Id: <20210818012515.64564-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

V3:
- rebase to the upstream


 fs/ceph/caps.c       | 18 ++++++++++++++----
 fs/ceph/mds_client.c |  7 ++++---
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 1b9ca437da92..e239f06babbc 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1712,7 +1712,16 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
 
 struct ceph_cap_flush *ceph_alloc_cap_flush(void)
 {
-	return kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
+	struct ceph_cap_flush *cf;
+
+	cf = kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
+	/*
+	 * caps == 0 always means for the capsnap
+	 * caps > 0 means dirty caps being flushed
+	 * caps == -1 means preallocated, not used yet
+	 */
+	cf->caps = -1;
+	return cf;
 }
 
 void ceph_free_cap_flush(struct ceph_cap_flush *cf)
@@ -1747,7 +1756,7 @@ static bool __detach_cap_flush_from_mdsc(struct ceph_mds_client *mdsc,
 		prev->wake = true;
 		wake = false;
 	}
-	list_del(&cf->g_list);
+	list_del_init(&cf->g_list);
 	return wake;
 }
 
@@ -1762,7 +1771,7 @@ static bool __detach_cap_flush_from_ci(struct ceph_inode_info *ci,
 		prev->wake = true;
 		wake = false;
 	}
-	list_del(&cf->i_list);
+	list_del_init(&cf->i_list);
 	return wake;
 }
 
@@ -3642,7 +3651,8 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
 		cf = list_first_entry(&to_remove,
 				      struct ceph_cap_flush, i_list);
 		list_del(&cf->i_list);
-		ceph_free_cap_flush(cf);
+		if (cf->caps)
+			ceph_free_cap_flush(cf);
 	}
 
 	if (wake_ci)
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 1e013fb09d73..a44adbd1841b 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1636,7 +1636,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		spin_lock(&mdsc->cap_dirty_lock);
 
 		list_for_each_entry(cf, &to_remove, i_list)
-			list_del(&cf->g_list);
+			list_del_init(&cf->g_list);
 
 		if (!list_empty(&ci->i_dirty_item)) {
 			pr_warn_ratelimited(
@@ -1688,8 +1688,9 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		struct ceph_cap_flush *cf;
 		cf = list_first_entry(&to_remove,
 				      struct ceph_cap_flush, i_list);
-		list_del(&cf->i_list);
-		ceph_free_cap_flush(cf);
+		list_del_init(&cf->i_list);
+		if (cf->caps)
+			ceph_free_cap_flush(cf);
 	}
 
 	wake_up_all(&ci->i_cap_wq);
-- 
2.27.0


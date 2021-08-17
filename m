Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C783EEC8B
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Aug 2021 14:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237349AbhHQMf7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Aug 2021 08:35:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58243 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236498AbhHQMf7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 08:35:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629203725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LX0tf79AhsaFtN0d9YQnWOM2VUb9Jz72YRXPh2sMXBc=;
        b=fHxdZp8RNLHnCSgYqVROuGydN/B53644fLzzbmotw+9AkXZXQ0VhAi6x6vQyLwA7y/aQ4B
        AdLZIatX2JxG8CF+kA4yLS4seCIybYRcugXOb1R1R42usQoIt8d80sCz1TvGPQBP9JcECd
        Kl7fNqrTI4q8IRCsxZqzxhhWthb5bz8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-AFUyd_qvNMGd1IyoBCpfxg-1; Tue, 17 Aug 2021 08:35:24 -0400
X-MC-Unique: AFUyd_qvNMGd1IyoBCpfxg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2305F3FB4;
        Tue, 17 Aug 2021 12:35:23 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F74160854;
        Tue, 17 Aug 2021 12:35:20 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: correctly release memory from capsnap
Date:   Tue, 17 Aug 2021 20:35:17 +0800
Message-Id: <20210817123517.15764-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

- Only to resolve the crash issue.
- s/list_del/list_del_init/


 fs/ceph/caps.c       | 18 ++++++++++++++----
 fs/ceph/mds_client.c |  7 ++++---
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 990258cbd836..4ee0ef87130a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1667,7 +1667,16 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
 
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
@@ -1704,14 +1713,14 @@ static bool __finish_cap_flush(struct ceph_mds_client *mdsc,
 			prev->wake = true;
 			wake = false;
 		}
-		list_del(&cf->g_list);
+		list_del_init(&cf->g_list);
 	} else if (ci) {
 		if (wake && cf->i_list.prev != &ci->i_cap_flush_list) {
 			prev = list_prev_entry(cf, i_list);
 			prev->wake = true;
 			wake = false;
 		}
-		list_del(&cf->i_list);
+		list_del_init(&cf->i_list);
 	} else {
 		BUG_ON(1);
 	}
@@ -3398,7 +3407,8 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
 		cf = list_first_entry(&to_remove,
 				      struct ceph_cap_flush, i_list);
 		list_del(&cf->i_list);
-		ceph_free_cap_flush(cf);
+		if (cf->caps)
+			ceph_free_cap_flush(cf);
 	}
 
 	if (wake_ci)
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 2c3d762c7973..dc30f56115fa 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1226,7 +1226,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		spin_lock(&mdsc->cap_dirty_lock);
 
 		list_for_each_entry(cf, &to_remove, i_list)
-			list_del(&cf->g_list);
+			list_del_init(&cf->g_list);
 
 		if (!list_empty(&ci->i_dirty_item)) {
 			pr_warn_ratelimited(
@@ -1266,8 +1266,9 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
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


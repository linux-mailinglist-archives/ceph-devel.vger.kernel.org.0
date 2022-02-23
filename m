Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329824C077D
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Feb 2022 02:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbiBWCAT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 22 Feb 2022 21:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiBWCAS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 22 Feb 2022 21:00:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AEEB23BFBC
        for <ceph-devel@vger.kernel.org>; Tue, 22 Feb 2022 17:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645581590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NzrOnScghuuM7a/4yh+tcSZrALDgJORzMyldBpF93TA=;
        b=FH7l2AKDZn8Ez9u/ESlSFkKcmjXzYP+A76psRHrnTvQ10h47w340rRMqbRunVLOwi71lO8
        bFPWrImgXWHWqJZwn6/yu8CeYCulSKOyRxbQowSEeVN/e41aIGIb3AZhsmYs6Cv6j6/QjN
        aA8/nZli3QPnIltEt7/PiG72WoeK3PQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-68-9XZnIAb0NHeo3OgckHV6mQ-1; Tue, 22 Feb 2022 20:59:47 -0500
X-MC-Unique: 9XZnIAb0NHeo3OgckHV6mQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CCF91091DA1;
        Wed, 23 Feb 2022 01:59:46 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5ECA761F20;
        Wed, 23 Feb 2022 01:59:41 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 1/2] ceph: allocate capsnap memory outside of ceph_queue_cap_snap()
Date:   Wed, 23 Feb 2022 09:59:33 +0800
Message-Id: <20220223015934.37379-2-xiubli@redhat.com>
In-Reply-To: <20220223015934.37379-1-xiubli@redhat.com>
References: <20220223015934.37379-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will reduce very possible but unnecessary frequently memory
allocate/free in this loop.

URL: https://tracker.ceph.com/issues/44100
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/snap.c | 46 ++++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index cc9097c27052..b75dcc9a36b6 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -522,23 +522,15 @@ static bool has_new_snaps(struct ceph_snap_context *o,
  * Caller must hold snap_rwsem for read (i.e., the realm topology won't
  * change).
  */
-static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
+static void ceph_queue_cap_snap(struct ceph_inode_info *ci,
+				struct ceph_cap_snap **pcapsnap)
 {
 	struct inode *inode = &ci->vfs_inode;
-	struct ceph_cap_snap *capsnap;
 	struct ceph_snap_context *old_snapc, *new_snapc;
+	struct ceph_cap_snap *capsnap = *pcapsnap;
 	struct ceph_buffer *old_blob = NULL;
 	int used, dirty;
 
-	capsnap = kmem_cache_zalloc(ceph_cap_snap_cachep, GFP_NOFS);
-	if (!capsnap) {
-		pr_err("ENOMEM allocating ceph_cap_snap on %p\n", inode);
-		return;
-	}
-	capsnap->cap_flush.is_capsnap = true;
-	INIT_LIST_HEAD(&capsnap->cap_flush.i_list);
-	INIT_LIST_HEAD(&capsnap->cap_flush.g_list);
-
 	spin_lock(&ci->i_ceph_lock);
 	used = __ceph_caps_used(ci);
 	dirty = __ceph_caps_dirty(ci);
@@ -595,9 +587,6 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
 	     capsnap->need_flush ? "" : "no_flush");
 	ihold(inode);
 
-	refcount_set(&capsnap->nref, 1);
-	INIT_LIST_HEAD(&capsnap->ci_item);
-
 	capsnap->follows = old_snapc->seq;
 	capsnap->issued = __ceph_caps_issued(ci, NULL);
 	capsnap->dirty = dirty;
@@ -635,7 +624,7 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
 		/* note mtime, size NOW. */
 		__ceph_finish_cap_snap(ci, capsnap);
 	}
-	capsnap = NULL;
+	*pcapsnap = NULL;
 	old_snapc = NULL;
 
 update_snapc:
@@ -651,8 +640,6 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
 	spin_unlock(&ci->i_ceph_lock);
 
 	ceph_buffer_put(old_blob);
-	if (capsnap)
-		kmem_cache_free(ceph_cap_snap_cachep, capsnap);
 	ceph_put_snap_context(old_snapc);
 }
 
@@ -720,6 +707,7 @@ static void queue_realm_cap_snaps(struct ceph_snap_realm *realm)
 {
 	struct ceph_inode_info *ci;
 	struct inode *lastinode = NULL;
+	struct ceph_cap_snap *capsnap = NULL;
 
 	dout("queue_realm_cap_snaps %p %llx inodes\n", realm, realm->ino);
 
@@ -731,12 +719,34 @@ static void queue_realm_cap_snaps(struct ceph_snap_realm *realm)
 		spin_unlock(&realm->inodes_with_caps_lock);
 		iput(lastinode);
 		lastinode = inode;
-		ceph_queue_cap_snap(ci);
+
+		/*
+		 * Allocate the capsnap memory outside of ceph_queue_cap_snap()
+		 * to reduce very possible but unnecessary frequently memory
+		 * allocate/free in this loop.
+		 */
+		if (!capsnap) {
+			capsnap = kmem_cache_zalloc(ceph_cap_snap_cachep, GFP_NOFS);
+			if (!capsnap) {
+				pr_err("ENOMEM allocating ceph_cap_snap on %p\n",
+				       inode);
+				return;
+			}
+		}
+		capsnap->cap_flush.is_capsnap = true;
+		refcount_set(&capsnap->nref, 1);
+		INIT_LIST_HEAD(&capsnap->cap_flush.i_list);
+		INIT_LIST_HEAD(&capsnap->cap_flush.g_list);
+		INIT_LIST_HEAD(&capsnap->ci_item);
+
+		ceph_queue_cap_snap(ci, &capsnap);
 		spin_lock(&realm->inodes_with_caps_lock);
 	}
 	spin_unlock(&realm->inodes_with_caps_lock);
 	iput(lastinode);
 
+	if (capsnap)
+		kmem_cache_free(ceph_cap_snap_cachep, capsnap);
 	dout("queue_realm_cap_snaps %p %llx done\n", realm, realm->ino);
 }
 
-- 
2.27.0


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9257F4B6BF5
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Feb 2022 13:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237041AbiBOMXs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 07:23:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236767AbiBOMXr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 07:23:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC131107AA9
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 04:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644927815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D/XgmGLkIJ58VQ2dHCOzcLfsXRgya251m7yIOeHTxlk=;
        b=it+VXOZT7k1b5PGCENGVL7Z1B21TThGr+paL2+OjWBZAC8Z3pAh/l4Wf+NkEUwxf+JkQwi
        MYXjmLMKriWEHz0CQTvKFgQuIyDu922HA+Z5IxroWrYrg3qhIs8Oqy09iTctUazSpHFD1r
        qk9WjGgEENlBANErdbeC2f4dK5t8JIU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-hDPAl40ONNGsgVS7GEKSmw-1; Tue, 15 Feb 2022 07:23:32 -0500
X-MC-Unique: hDPAl40ONNGsgVS7GEKSmw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC8642F25;
        Tue, 15 Feb 2022 12:23:31 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02073101F6CF;
        Tue, 15 Feb 2022 12:23:29 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/3] ceph: move kzalloc under i_ceph_lock with GFP_ATOMIC flag
Date:   Tue, 15 Feb 2022 20:23:15 +0800
Message-Id: <20220215122316.7625-3-xiubli@redhat.com>
In-Reply-To: <20220215122316.7625-1-xiubli@redhat.com>
References: <20220215122316.7625-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

There has one case that the snaprealm has been updated and then
it will iterate all the inode under it and try to queue a cap
snap for it. But in some case there has millions of subdirectries
or files under it and most of them no any Fw or dirty pages and
then will just be skipped.

URL: https://tracker.ceph.com/issues/44100
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/snap.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index c787775eaf2a..d075d3ce5f6d 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -477,19 +477,21 @@ static bool has_new_snaps(struct ceph_snap_context *o,
 static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
 {
 	struct inode *inode = &ci->vfs_inode;
-	struct ceph_cap_snap *capsnap;
+	struct ceph_cap_snap *capsnap = NULL;
 	struct ceph_snap_context *old_snapc, *new_snapc;
 	struct ceph_buffer *old_blob = NULL;
 	int used, dirty;
-
-	capsnap = kmem_cache_alloc(ceph_cap_snap_cachep, GFP_NOFS);
-	if (!capsnap) {
-		pr_err("ENOMEM allocating ceph_cap_snap on %p\n", inode);
-		return;
+	bool need_flush = false;
+	bool atomic_alloc_mem_failed = false;
+
+retry:
+	if (unlikely(atomic_alloc_mem_failed)) {
+	        capsnap = kmem_cache_alloc(ceph_cap_snap_cachep, GFP_NOFS);
+		if (!capsnap) {
+			pr_err("ENOMEM allocating ceph_cap_snap on %p\n", inode);
+			return;
+		}
 	}
-	capsnap->cap_flush.is_capsnap = true;
-	INIT_LIST_HEAD(&capsnap->cap_flush.i_list);
-	INIT_LIST_HEAD(&capsnap->cap_flush.g_list);
 
 	spin_lock(&ci->i_ceph_lock);
 	used = __ceph_caps_used(ci);
@@ -532,7 +534,7 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
 	 */
 	if (has_new_snaps(old_snapc, new_snapc)) {
 		if (dirty & (CEPH_CAP_ANY_EXCL|CEPH_CAP_FILE_WR))
-			capsnap->need_flush = true;
+			need_flush = true;
 	} else {
 		if (!(used & CEPH_CAP_FILE_WR) &&
 		    ci->i_wrbuffer_ref_head == 0) {
@@ -542,6 +544,21 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
 		}
 	}
 
+	if (!capsnap) {
+	        capsnap = kmem_cache_alloc(ceph_cap_snap_cachep, GFP_ATOMIC);
+		if (unlikely(!capsnap)) {
+			pr_err("ENOMEM atomic allocating ceph_cap_snap on %p\n",
+			       inode);
+			spin_unlock(&ci->i_ceph_lock);
+			atomic_alloc_mem_failed = true;
+			goto retry;
+		}
+	}
+	capsnap->need_flush = need_flush;
+	capsnap->cap_flush.is_capsnap = true;
+	INIT_LIST_HEAD(&capsnap->cap_flush.i_list);
+	INIT_LIST_HEAD(&capsnap->cap_flush.g_list);
+
 	dout("queue_cap_snap %p cap_snap %p queuing under %p %s %s\n",
 	     inode, capsnap, old_snapc, ceph_cap_string(dirty),
 	     capsnap->need_flush ? "" : "no_flush");
-- 
2.27.0


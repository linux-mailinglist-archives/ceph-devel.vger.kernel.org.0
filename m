Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672114B6BF4
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Feb 2022 13:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbiBOMXq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 07:23:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236233AbiBOMXq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 07:23:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2288107AAA
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 04:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644927815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/wVbFdzcInD1Ozq8OJBYWZw/GucY6weJoxM/Cz+UATY=;
        b=TFV3oCeVwaQMj/Ik4nr6+1QLocG0irIexhko4KwzAZmaJ5PHHWS8PxVFYI/Qz/hP9BW53R
        YRckBuE54sb5JZyJKXGSIWyTkcJKgStW9Mkl8pZATIfc7T+h2hSSx6GEz0Z1XdiifEs5If
        82oEdMmsCRzRJfY2O2FmDMeOudJlp8s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-JNzHPei0MhyHP83Y5pcUhw-1; Tue, 15 Feb 2022 07:23:30 -0500
X-MC-Unique: JNzHPei0MhyHP83Y5pcUhw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 802C62F26;
        Tue, 15 Feb 2022 12:23:29 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3F0B101F6CF;
        Tue, 15 Feb 2022 12:23:27 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/3] ceph: move to a dedicated slabcache for ceph_cap_snap
Date:   Tue, 15 Feb 2022 20:23:14 +0800
Message-Id: <20220215122316.7625-2-xiubli@redhat.com>
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

There could be huge number of capsnap queued in a short time, on
x86_64 it's 248 bytes, which will be rounded up to 256 bytes by
kzalloc. Move this to a dedicated slabcache to save 8 bytes for
each.

For the kmalloc-256 slab cache, the actual size will be 512 bytes:
kmalloc-256        21797  74656    512   32    4 : tunables, etc

For a dedicated slab cache the real size is 312 bytes:
ceph_cap_snap          0      0    312   52    4 : tunables, etc

So actually we can save 200 bytes for each.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/snap.c               | 5 +++--
 fs/ceph/super.c              | 7 +++++++
 fs/ceph/super.h              | 2 +-
 include/linux/ceph/libceph.h | 1 +
 4 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index b41e6724c591..c787775eaf2a 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -482,7 +482,7 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
 	struct ceph_buffer *old_blob = NULL;
 	int used, dirty;
 
-	capsnap = kzalloc(sizeof(*capsnap), GFP_NOFS);
+	capsnap = kmem_cache_alloc(ceph_cap_snap_cachep, GFP_NOFS);
 	if (!capsnap) {
 		pr_err("ENOMEM allocating ceph_cap_snap on %p\n", inode);
 		return;
@@ -603,7 +603,8 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
 	spin_unlock(&ci->i_ceph_lock);
 
 	ceph_buffer_put(old_blob);
-	kfree(capsnap);
+	if (capsnap)
+		kmem_cache_free(ceph_cap_snap_cachep, capsnap);
 	ceph_put_snap_context(old_snapc);
 }
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index bf79f369aec6..978463fa822c 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -864,6 +864,7 @@ static void destroy_fs_client(struct ceph_fs_client *fsc)
  */
 struct kmem_cache *ceph_inode_cachep;
 struct kmem_cache *ceph_cap_cachep;
+struct kmem_cache *ceph_cap_snap_cachep;
 struct kmem_cache *ceph_cap_flush_cachep;
 struct kmem_cache *ceph_dentry_cachep;
 struct kmem_cache *ceph_file_cachep;
@@ -892,6 +893,9 @@ static int __init init_caches(void)
 	ceph_cap_cachep = KMEM_CACHE(ceph_cap, SLAB_MEM_SPREAD);
 	if (!ceph_cap_cachep)
 		goto bad_cap;
+	ceph_cap_snap_cachep = KMEM_CACHE(ceph_cap_snap, SLAB_MEM_SPREAD);
+	if (!ceph_cap_snap_cachep)
+		goto bad_cap_snap;
 	ceph_cap_flush_cachep = KMEM_CACHE(ceph_cap_flush,
 					   SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
 	if (!ceph_cap_flush_cachep)
@@ -931,6 +935,8 @@ static int __init init_caches(void)
 bad_dentry:
 	kmem_cache_destroy(ceph_cap_flush_cachep);
 bad_cap_flush:
+	kmem_cache_destroy(ceph_cap_snap_cachep);
+bad_cap_snap:
 	kmem_cache_destroy(ceph_cap_cachep);
 bad_cap:
 	kmem_cache_destroy(ceph_inode_cachep);
@@ -947,6 +953,7 @@ static void destroy_caches(void)
 
 	kmem_cache_destroy(ceph_inode_cachep);
 	kmem_cache_destroy(ceph_cap_cachep);
+	kmem_cache_destroy(ceph_cap_snap_cachep);
 	kmem_cache_destroy(ceph_cap_flush_cachep);
 	kmem_cache_destroy(ceph_dentry_cachep);
 	kmem_cache_destroy(ceph_file_cachep);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index c0718d5a8fb8..2d08104c8955 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -231,7 +231,7 @@ static inline void ceph_put_cap_snap(struct ceph_cap_snap *capsnap)
 	if (refcount_dec_and_test(&capsnap->nref)) {
 		if (capsnap->xattr_blob)
 			ceph_buffer_put(capsnap->xattr_blob);
-		kfree(capsnap);
+		kmem_cache_free(ceph_cap_snap_cachep, capsnap);
 	}
 }
 
diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index edf62eaa6285..00af2c98da75 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -284,6 +284,7 @@ DEFINE_RB_LOOKUP_FUNC(name, type, keyfld, nodefld)
 
 extern struct kmem_cache *ceph_inode_cachep;
 extern struct kmem_cache *ceph_cap_cachep;
+extern struct kmem_cache *ceph_cap_snap_cachep;
 extern struct kmem_cache *ceph_cap_flush_cachep;
 extern struct kmem_cache *ceph_dentry_cachep;
 extern struct kmem_cache *ceph_file_cachep;
-- 
2.27.0


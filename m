Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D989E1627C5
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Feb 2020 15:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgBROLS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Feb 2020 09:11:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbgBROLS (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 18 Feb 2020 09:11:18 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CCA022527;
        Tue, 18 Feb 2020 14:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582035077;
        bh=4w/gxOiCChJSZq1Kpbu7vumh4ihgjSrWorBFIV5Al00=;
        h=From:To:Cc:Subject:Date:From;
        b=UEKEkmqt7D2yTIK+YaPQPgWb4PR6FzP7/KhMj3d9G75zNq402dcO7+17cZWGhYiE+
         ftnc0Fw3ILDYsRA6DJk7fFPpfbCwXQRwdGN1ECczBGOhOqz2x4MtEwReb7LAV5Tm7k
         71LdWo2owpcO1WwwBPhJuoN2DkWgZ9NbqZkfyF2E=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com, zyan@redhat.com
Subject: [PATCH] ceph: move to a dedicated slabcache for mds requests
Date:   Tue, 18 Feb 2020 09:11:16 -0500
Message-Id: <20200218141116.26481-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On my machine (x86_64) this struct is 952 bytes, which gets rounded up
to 1024 by kmalloc. Move this to a dedicated slabcache, so we can
allocate them without the extra 72 bytes of overhead per.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c         | 6 +++---
 fs/ceph/super.c              | 8 ++++++++
 include/linux/ceph/libceph.h | 1 +
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 2980e57ca7b9..76655047fca5 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -736,7 +736,7 @@ void ceph_mdsc_release_request(struct kref *kref)
 	put_request_session(req);
 	ceph_unreserve_caps(req->r_mdsc, &req->r_caps_reservation);
 	WARN_ON_ONCE(!list_empty(&req->r_wait));
-	kfree(req);
+	kmem_cache_free(ceph_mds_request_cachep, req);
 }
 
 DEFINE_RB_FUNCS(request, struct ceph_mds_request, r_tid, r_node)
@@ -2094,8 +2094,8 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
 struct ceph_mds_request *
 ceph_mdsc_create_request(struct ceph_mds_client *mdsc, int op, int mode)
 {
-	struct ceph_mds_request *req = kzalloc(sizeof(*req), GFP_NOFS);
-
+	struct ceph_mds_request *req = kmem_cache_alloc(ceph_mds_request_cachep,
+							GFP_NOFS | __GFP_ZERO);
 	if (!req)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index c7f150686a53..b1329cd5388a 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -729,6 +729,7 @@ struct kmem_cache *ceph_cap_flush_cachep;
 struct kmem_cache *ceph_dentry_cachep;
 struct kmem_cache *ceph_file_cachep;
 struct kmem_cache *ceph_dir_file_cachep;
+struct kmem_cache *ceph_mds_request_cachep;
 
 static void ceph_inode_init_once(void *foo)
 {
@@ -769,6 +770,10 @@ static int __init init_caches(void)
 	if (!ceph_dir_file_cachep)
 		goto bad_dir_file;
 
+	ceph_mds_request_cachep = KMEM_CACHE(ceph_mds_request, SLAB_MEM_SPREAD);
+	if (!ceph_mds_request_cachep)
+		goto bad_mds_req;
+
 	error = ceph_fscache_register();
 	if (error)
 		goto bad_fscache;
@@ -776,6 +781,8 @@ static int __init init_caches(void)
 	return 0;
 
 bad_fscache:
+	kmem_cache_destroy(ceph_mds_request_cachep);
+bad_mds_req:
 	kmem_cache_destroy(ceph_dir_file_cachep);
 bad_dir_file:
 	kmem_cache_destroy(ceph_file_cachep);
@@ -804,6 +811,7 @@ static void destroy_caches(void)
 	kmem_cache_destroy(ceph_dentry_cachep);
 	kmem_cache_destroy(ceph_file_cachep);
 	kmem_cache_destroy(ceph_dir_file_cachep);
+	kmem_cache_destroy(ceph_mds_request_cachep);
 
 	ceph_fscache_unregister();
 }
diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index ec73ebc4827d..525b7c3f1c81 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -272,6 +272,7 @@ extern struct kmem_cache *ceph_cap_flush_cachep;
 extern struct kmem_cache *ceph_dentry_cachep;
 extern struct kmem_cache *ceph_file_cachep;
 extern struct kmem_cache *ceph_dir_file_cachep;
+extern struct kmem_cache *ceph_mds_request_cachep;
 
 /* ceph_common.c */
 extern bool libceph_compatible(void *data);
-- 
2.24.1


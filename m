Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A385C4C069E
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Feb 2022 02:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbiBWBFr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 22 Feb 2022 20:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbiBWBFr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 22 Feb 2022 20:05:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 87AB536B68
        for <ceph-devel@vger.kernel.org>; Tue, 22 Feb 2022 17:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645578319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jbDa9j4T6iTntyNAtScFUZijF+R9gNNv870kedzWLqk=;
        b=XOcl0eP+SRrZNjclMNcaYxkxaZeBGlwM3Iwu7n4lgg0VDWqXaiW6yef9WLs5BsHhaWIN7H
        pxQIY7wHHZNnyYV0cWnpy5NQCzO3+7tyy6Xr6CtMMgW2UCSMSewXX0LwSI1ku6r7xoIqVK
        LF+XRgEUNc57XbVU3MpF5AoUnOBORoo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-5zOnH1qlNMyI9Z6JM5Ky8Q-1; Tue, 22 Feb 2022 20:05:16 -0500
X-MC-Unique: 5zOnH1qlNMyI9Z6JM5Ky8Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F7851091DA1;
        Wed, 23 Feb 2022 01:05:15 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7ABC5D6B1;
        Wed, 23 Feb 2022 01:05:13 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 2/2] ceph: do not release the global snaprealm until unmounting
Date:   Wed, 23 Feb 2022 09:04:56 +0800
Message-Id: <20220223010456.267425-3-xiubli@redhat.com>
In-Reply-To: <20220223010456.267425-1-xiubli@redhat.com>
References: <20220223010456.267425-1-xiubli@redhat.com>
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

The global snaprealm would be created and then destroyed immediately
every time when updating it.

URL: https://tracker.ceph.com/issues/54362
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c         |  2 +-
 fs/ceph/snap.c               | 13 +++++++++++--
 fs/ceph/super.h              |  2 +-
 include/linux/ceph/ceph_fs.h |  3 ++-
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 65bd43d4cafc..b3b8f6299176 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4866,7 +4866,7 @@ void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
 	mutex_unlock(&mdsc->mutex);
 
 	ceph_cleanup_snapid_map(mdsc);
-	ceph_cleanup_empty_realms(mdsc);
+	ceph_cleanup_global_and_empty_realms(mdsc);
 
 	cancel_work_sync(&mdsc->cap_reclaim_work);
 	cancel_delayed_work_sync(&mdsc->delayed_work); /* cancel timer */
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 66a1a92cf579..cc9097c27052 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -121,7 +121,11 @@ static struct ceph_snap_realm *ceph_create_snap_realm(
 	if (!realm)
 		return ERR_PTR(-ENOMEM);
 
-	atomic_set(&realm->nref, 1);    /* for caller */
+	/* Do not release the global dummy snaprealm until unmouting */
+	if (ino == CEPH_INO_GLOBAL_SNAPREALM)
+		atomic_set(&realm->nref, 2);
+	else
+		atomic_set(&realm->nref, 1);
 	realm->ino = ino;
 	INIT_LIST_HEAD(&realm->children);
 	INIT_LIST_HEAD(&realm->child_item);
@@ -261,9 +265,14 @@ static void __cleanup_empty_realms(struct ceph_mds_client *mdsc)
 	spin_unlock(&mdsc->snap_empty_lock);
 }
 
-void ceph_cleanup_empty_realms(struct ceph_mds_client *mdsc)
+void ceph_cleanup_global_and_empty_realms(struct ceph_mds_client *mdsc)
 {
+	struct ceph_snap_realm *global_realm;
+
 	down_write(&mdsc->snap_rwsem);
+	global_realm = __lookup_snap_realm(mdsc, CEPH_INO_GLOBAL_SNAPREALM);
+	if (global_realm)
+		ceph_put_snap_realm(mdsc, global_realm);
 	__cleanup_empty_realms(mdsc);
 	up_write(&mdsc->snap_rwsem);
 }
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index baac800a6d11..250aefecd628 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -942,7 +942,7 @@ extern void ceph_handle_snap(struct ceph_mds_client *mdsc,
 			     struct ceph_msg *msg);
 extern int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
 				  struct ceph_cap_snap *capsnap);
-extern void ceph_cleanup_empty_realms(struct ceph_mds_client *mdsc);
+extern void ceph_cleanup_global_and_empty_realms(struct ceph_mds_client *mdsc);
 
 extern struct ceph_snapid_map *ceph_get_snapid_map(struct ceph_mds_client *mdsc,
 						   u64 snap);
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index f14f9bc290e6..86bf82dbd8b8 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -28,7 +28,8 @@
 
 
 #define CEPH_INO_ROOT   1
-#define CEPH_INO_CEPH   2       /* hidden .ceph dir */
+#define CEPH_INO_CEPH   2            /* hidden .ceph dir */
+#define CEPH_INO_GLOBAL_SNAPREALM  3 /* global dummy snaprealm */
 
 /* arbitrary limit on max # of monitors (cluster of 3 is typical) */
 #define CEPH_MAX_MON   31
-- 
2.27.0


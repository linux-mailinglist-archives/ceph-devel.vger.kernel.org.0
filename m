Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448984BF222
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Feb 2022 07:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiBVGfN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 22 Feb 2022 01:35:13 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiBVGfM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 22 Feb 2022 01:35:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 07C65EC5E1
        for <ceph-devel@vger.kernel.org>; Mon, 21 Feb 2022 22:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645511686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z8BGDUBOtFfxXDxfr0vgjPhrQUVcNGj/SDvWVYcngYM=;
        b=KydurpbN9v8nyb6V75wuXhfCqYFNWwbu0kVbheDvfLgh7mP18MnYJCq5GNmJXJvOULQdog
        3CQcmoaEecNxe3cOOkEPgAbkTKOTj2mcgOWXZLKZeoh+JpJAVJ2Pj510uwuvq5uwdu7Spu
        vRl0WDwfSTX+cFwhfechde4a6CRYOUA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-VZuxo3wuMA2KgPd-rcm4bQ-1; Tue, 22 Feb 2022 01:34:43 -0500
X-MC-Unique: VZuxo3wuMA2KgPd-rcm4bQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53CCC801AAD;
        Tue, 22 Feb 2022 06:34:42 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 902705ED21;
        Tue, 22 Feb 2022 06:34:40 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/2] ceph: do not release the global snaprealm until unmounting
Date:   Tue, 22 Feb 2022 14:34:33 +0800
Message-Id: <20220222063433.217466-3-xiubli@redhat.com>
In-Reply-To: <20220222063433.217466-1-xiubli@redhat.com>
References: <20220222063433.217466-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 65bd43d4cafc..325f8071a324 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4866,7 +4866,7 @@ void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
 	mutex_unlock(&mdsc->mutex);
 
 	ceph_cleanup_snapid_map(mdsc);
-	ceph_cleanup_empty_realms(mdsc);
+        ceph_cleanup_global_and_empty_realms(mdsc);
 
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


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43FBA72F200
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jun 2023 03:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240747AbjFNBeR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 21:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234597AbjFNBeQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 21:34:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8AD10FC
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 18:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686706407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3dvboOIR9Si0HaPpGLU1euVIsH1umrZ4qnurgzsbn+s=;
        b=F8nUCc0QNtIWfddX6bS+/Y6VdBppsU52cd7eJszGKwpJrOH2a6XKAVaXaaDeXB4npeBR4r
        VIL3vl+dkCW5wqqg28YX6558w+SzU7yXO9iYqeMP4lXYprf2KMv45A1vJRocSh8Pxd01AI
        xFGumXl0pgkgFJAcumaTEojos1yE5zE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-5Bg_QFGpOPOs9iQYLru_yw-1; Tue, 13 Jun 2023 21:33:25 -0400
X-MC-Unique: 5Bg_QFGpOPOs9iQYLru_yw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72718185A78B;
        Wed, 14 Jun 2023 01:33:25 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9412C492CAC;
        Wed, 14 Jun 2023 01:33:21 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        khiremat@redhat.com, pdonnell@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 5/6] ceph: add ceph_inode_to_client() helper support
Date:   Wed, 14 Jun 2023 09:30:24 +0800
Message-Id: <20230614013025.291314-6-xiubli@redhat.com>
In-Reply-To: <20230614013025.291314-1-xiubli@redhat.com>
References: <20230614013025.291314-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will covert the inode to ceph_client.

URL: https://tracker.ceph.com/issues/61590
Cc: Patrick Donnelly <pdonnell@redhat.com>
Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/snap.c  | 8 +++++---
 fs/ceph/super.h | 6 ++++++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 09939ec0d1ee..9dde4b5f513d 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -329,7 +329,8 @@ static int cmpu64_rev(const void *a, const void *b)
 /*
  * build the snap context for a given realm.
  */
-static int build_snap_context(struct ceph_snap_realm *realm,
+static int build_snap_context(struct ceph_mds_client *mdsc,
+			      struct ceph_snap_realm *realm,
 			      struct list_head *realm_queue,
 			      struct list_head *dirty_realms)
 {
@@ -425,7 +426,8 @@ static int build_snap_context(struct ceph_snap_realm *realm,
 /*
  * rebuild snap context for the given realm and all of its children.
  */
-static void rebuild_snap_realms(struct ceph_snap_realm *realm,
+static void rebuild_snap_realms(struct ceph_mds_client *mdsc,
+				struct ceph_snap_realm *realm,
 				struct list_head *dirty_realms)
 {
 	LIST_HEAD(realm_queue);
@@ -858,7 +860,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 
 	/* rebuild_snapcs when we reach the _end_ (root) of the trace */
 	if (realm_to_rebuild && p >= e)
-		rebuild_snap_realms(realm_to_rebuild, &dirty_realms);
+		rebuild_snap_realms(mdsc, realm_to_rebuild, &dirty_realms);
 
 	if (!first_realm)
 		first_realm = realm;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 9655ea46e6ca..4e78de1be23e 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -507,6 +507,12 @@ ceph_sb_to_mdsc(const struct super_block *sb)
 	return (struct ceph_mds_client *)ceph_sb_to_fs_client(sb)->mdsc;
 }
 
+static inline struct ceph_client *
+ceph_inode_to_client(const struct inode *inode)
+{
+	return (struct ceph_client *)ceph_inode_to_fs_client(inode)->client;
+}
+
 static inline struct ceph_vino
 ceph_vino(const struct inode *inode)
 {
-- 
2.40.1


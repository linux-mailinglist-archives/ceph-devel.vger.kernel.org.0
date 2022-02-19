Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196634BC61C
	for <lists+ceph-devel@lfdr.de>; Sat, 19 Feb 2022 07:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240853AbiBSG4v (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 19 Feb 2022 01:56:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbiBSG4u (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 19 Feb 2022 01:56:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C39EBF52
        for <ceph-devel@vger.kernel.org>; Fri, 18 Feb 2022 22:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645253790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/kM6FiJYJgJWvATq50TMOzbSPRzmfWZ0RPsgBjCBST4=;
        b=Hx5hjd5MtyWny4pNpHED4eFpqX7fPQMcdbvx2ZxjL5DUQ1/gXmSEqIihFyL75Wd4x/k/i/
        Ft2dinHpzdCHKS3IruXxhWomVVn1US/9n42pxYjiUzdS++lbCdbkTtMF3VY/+5ERkUoWO2
        YrbXpXNrQiYjXPp93QLouHZ8MAREI5w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-pGiF5pLuNFuj5PgaCRXGpQ-1; Sat, 19 Feb 2022 01:56:26 -0500
X-MC-Unique: pGiF5pLuNFuj5PgaCRXGpQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2A211006AA3;
        Sat, 19 Feb 2022 06:56:25 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9FF662D75;
        Sat, 19 Feb 2022 06:56:19 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: eliminate the recursion when rebuilding the snap context
Date:   Sat, 19 Feb 2022 14:56:17 +0800
Message-Id: <20220219065617.43718-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

Use a list instead of recursion to avoid possible stack overflow.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V2:
- Do not insert the child realms when building snapc for the parents


 fs/ceph/snap.c  | 57 +++++++++++++++++++++++++++++++++++++++++--------
 fs/ceph/super.h |  2 ++
 2 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index bc5ec72d958c..722ddd166013 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -127,6 +127,7 @@ static struct ceph_snap_realm *ceph_create_snap_realm(
 	INIT_LIST_HEAD(&realm->child_item);
 	INIT_LIST_HEAD(&realm->empty_item);
 	INIT_LIST_HEAD(&realm->dirty_item);
+	INIT_LIST_HEAD(&realm->rebuild_item);
 	INIT_LIST_HEAD(&realm->inodes_with_caps);
 	spin_lock_init(&realm->inodes_with_caps_lock);
 	__insert_snap_realm(&mdsc->snap_realms, realm);
@@ -320,7 +321,8 @@ static int cmpu64_rev(const void *a, const void *b)
  * build the snap context for a given realm.
  */
 static int build_snap_context(struct ceph_snap_realm *realm,
-			      struct list_head* dirty_realms)
+			      struct list_head *realm_queue,
+			      struct list_head *dirty_realms)
 {
 	struct ceph_snap_realm *parent = realm->parent;
 	struct ceph_snap_context *snapc;
@@ -334,9 +336,9 @@ static int build_snap_context(struct ceph_snap_realm *realm,
 	 */
 	if (parent) {
 		if (!parent->cached_context) {
-			err = build_snap_context(parent, dirty_realms);
-			if (err)
-				goto fail;
+			/* add to the queue head */
+			list_add(&parent->rebuild_item, realm_queue);
+			return 1;
 		}
 		num += parent->cached_context->num_snaps;
 	}
@@ -420,13 +422,50 @@ static int build_snap_context(struct ceph_snap_realm *realm,
 static void rebuild_snap_realms(struct ceph_snap_realm *realm,
 				struct list_head *dirty_realms)
 {
-	struct ceph_snap_realm *child;
+	LIST_HEAD(realm_queue);
+	int last = 0;
+	bool skip = false;
 
-	dout("rebuild_snap_realms %llx %p\n", realm->ino, realm);
-	build_snap_context(realm, dirty_realms);
+	list_add_tail(&realm->rebuild_item, &realm_queue);
 
-	list_for_each_entry(child, &realm->children, child_item)
-		rebuild_snap_realms(child, dirty_realms);
+	while (!list_empty(&realm_queue)) {
+		struct ceph_snap_realm *_realm, *child;
+
+		_realm = list_first_entry(&realm_queue,
+					  struct ceph_snap_realm,
+					  rebuild_item);
+
+		/*
+		 * If the last building failed dues to memory
+		 * issue, just empty the realm_queue and return
+		 * to avoid infinite loop.
+		 */
+		if (last < 0) {
+			list_del_init(&_realm->rebuild_item);
+			continue;
+		}
+
+		last = build_snap_context(_realm, &realm_queue, dirty_realms);
+		dout("rebuild_snap_realms %llx %p, %s\n", _realm->ino, _realm,
+		     last > 0 ? "is deferred" : !last ? "succeeded" : "failed");
+
+		/* is any child in the list ? */
+		list_for_each_entry(child, &_realm->children, child_item) {
+			if (!list_empty(&child->rebuild_item)) {
+				skip = true;
+				break;
+			}
+		}
+
+		if (!skip) {
+			list_for_each_entry(child, &_realm->children, child_item)
+				list_add_tail(&child->rebuild_item, &realm_queue);
+		}
+
+		/* last == 1 means need to build parent first */
+		if (last <= 0)
+			list_del_init(&_realm->rebuild_item);
+	}
 }
 
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index a17bd01a8957..baac800a6d11 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -885,6 +885,8 @@ struct ceph_snap_realm {
 
 	struct list_head dirty_item;     /* if realm needs new context */
 
+	struct list_head rebuild_item;   /* rebuild snap realms _downward_ in hierarchy */
+
 	/* the current set of snaps for this realm */
 	struct ceph_snap_context *cached_context;
 
-- 
2.27.0


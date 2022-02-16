Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8078B4B8052
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Feb 2022 06:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242667AbiBPFoA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Feb 2022 00:44:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiBPFoA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Feb 2022 00:44:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C9967B0EBD
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 21:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644990227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3qtyVLDG05ny/uzuANYvGAaQBP251KYWShf9Vkqp6bg=;
        b=TpvNtV2sUSUCPcyo0MfT6AYritYI8RYtBhuTXRsCFbC5Z+2JDi/ts5tCpizzkcZGD80Pao
        Dz25TXSKuOEPInxMbOkl/zZGYqOjxKvnxA29+Zj+z99O/OYKBJ9+1o+YSCVxTPItl7LZiC
        xlBHSEKYoWW7j08eJeiNhPUgtrgpPlI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-Mm-IkUc0NgKb1zBKI47TmA-1; Wed, 16 Feb 2022 00:43:42 -0500
X-MC-Unique: Mm-IkUc0NgKb1zBKI47TmA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0E9A1800D50;
        Wed, 16 Feb 2022 05:43:40 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D852795AD;
        Wed, 16 Feb 2022 05:43:38 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: eliminate the recursion when rebuilding the snap context
Date:   Wed, 16 Feb 2022 13:43:35 +0800
Message-Id: <20220216054335.32015-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

Use a list instead of recuresion to avoid possible stack overflow.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/snap.c  | 44 +++++++++++++++++++++++++++++++++++---------
 fs/ceph/super.h |  2 ++
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 6939307d41cb..808add7dca9e 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -319,7 +319,8 @@ static int cmpu64_rev(const void *a, const void *b)
  * build the snap context for a given realm.
  */
 static int build_snap_context(struct ceph_snap_realm *realm,
-			      struct list_head* dirty_realms)
+			      struct list_head *realm_queue,
+			      struct list_head *dirty_realms)
 {
 	struct ceph_snap_realm *parent = realm->parent;
 	struct ceph_snap_context *snapc;
@@ -333,9 +334,9 @@ static int build_snap_context(struct ceph_snap_realm *realm,
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
@@ -418,13 +419,38 @@ static int build_snap_context(struct ceph_snap_realm *realm,
 static void rebuild_snap_realms(struct ceph_snap_realm *realm,
 				struct list_head *dirty_realms)
 {
-	struct ceph_snap_realm *child;
+	LIST_HEAD(realm_queue);
+	int last = 0;
 
-	dout("%s %llx %p\n", __func__, realm->ino, realm);
-	build_snap_context(realm, dirty_realms);
+	list_add_tail(&realm->rebuild_item, &realm_queue);
+
+	while (!list_empty(&realm_queue)) {
+		struct ceph_snap_realm *_realm, *child;
+
+		/*
+		 * If the last building failed dues to memory
+		 * issue, just empty the realm_queue and return
+		 * to avoid infinite loop.
+		 */
+		if (last < 0) {
+			list_del(&_realm->rebuild_item);
+			continue;
+		}
+
+		_realm = list_first_entry(&realm_queue,
+					  struct ceph_snap_realm,
+					  rebuild_item);
+		last = build_snap_context(_realm, &realm_queue, dirty_realms);
+		dout("%s %llx %p, %s\n", __func__, _realm->ino, _realm,
+		     last > 0 ? "is deferred" : !last ? "succeeded" : "failed");
 
-	list_for_each_entry(child, &realm->children, child_item)
-		rebuild_snap_realms(child, dirty_realms);
+		list_for_each_entry(child, &_realm->children, child_item)
+			list_add_tail(&child->rebuild_item, &realm_queue);
+
+		/* last == 1 means need to build parent first */
+		if (last <= 0)
+			list_del(&_realm->rebuild_item);
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


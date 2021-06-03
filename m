Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5D539A644
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Jun 2021 18:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhFCQyT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Jun 2021 12:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229692AbhFCQyS (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 12:54:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4136613F1;
        Thu,  3 Jun 2021 16:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622739154;
        bh=aiPLjXN+yoY1Dh8Obp48uNB6EnWsFHSVOMuySQQjySs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Es2OgesoXakj0EWr/Qm5Bsg1h0pzsFT4CxJ8UywucENG7fFX/lCmsgoihhS3TFeUc
         arWBGA6qRJWK2U7cy21ZlA4XM0Ry/WYaumB1/tGqSqfH/dsKY3TzQBcXLSI/cHE5DJ
         Bq/MGKH3Tt4DyNNV8TpcIONmrGY8sl8QjFlKPGVUyB87iCGV8+EK6r2e1vQz4PadAj
         5AaXHozJkmTRVSRSfkGEEmF4f68wb/V4HPkFfify0E1/MZMmlWUW4No0MMAHmrc0Fl
         fyafg729zW1hKz4+foUEERbNSv3eh7aQQcn0svBFZ4Z1mySuzGJ3+XS2hPPDwx+bMG
         92uSpgg2h6CTw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Subject: [PATCH 2/3] ceph: clean up locking annotation for ceph_get_snap_realm and __lookup_snap_realm
Date:   Thu,  3 Jun 2021 12:52:30 -0400
Message-Id: <20210603165231.110559-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603165231.110559-1-jlayton@kernel.org>
References: <20210603165231.110559-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

They both say that the snap_rwsem must be held for write, but I don't
see any real reason for it, and it's not currently always called that
way.

The lookup is just walking the rbtree, so holding it for read should be
fine there. The "get" is bumping the refcount and (possibly) removing
it from the empty list. I see no need to hold the snap_rwsem for write
for that.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/snap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index bc6c33d485e6..f8cac2abab3f 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -60,12 +60,12 @@
 /*
  * increase ref count for the realm
  *
- * caller must hold snap_rwsem for write.
+ * caller must hold snap_rwsem.
  */
 void ceph_get_snap_realm(struct ceph_mds_client *mdsc,
 			 struct ceph_snap_realm *realm)
 {
-	lockdep_assert_held_write(&mdsc->snap_rwsem);
+	lockdep_assert_held(&mdsc->snap_rwsem);
 
 	dout("get_realm %p %d -> %d\n", realm,
 	     atomic_read(&realm->nref), atomic_read(&realm->nref)+1);
@@ -139,7 +139,7 @@ static struct ceph_snap_realm *ceph_create_snap_realm(
 /*
  * lookup the realm rooted at @ino.
  *
- * caller must hold snap_rwsem for write.
+ * caller must hold snap_rwsem.
  */
 static struct ceph_snap_realm *__lookup_snap_realm(struct ceph_mds_client *mdsc,
 						   u64 ino)
@@ -147,7 +147,7 @@ static struct ceph_snap_realm *__lookup_snap_realm(struct ceph_mds_client *mdsc,
 	struct rb_node *n = mdsc->snap_realms.rb_node;
 	struct ceph_snap_realm *r;
 
-	lockdep_assert_held_write(&mdsc->snap_rwsem);
+	lockdep_assert_held(&mdsc->snap_rwsem);
 
 	while (n) {
 		r = rb_entry(n, struct ceph_snap_realm, node);
-- 
2.31.1


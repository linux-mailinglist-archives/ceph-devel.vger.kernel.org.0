Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D06E3DF41F
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Aug 2021 19:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238403AbhHCRvj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Aug 2021 13:51:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238316AbhHCRvj (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 13:51:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5722660F48;
        Tue,  3 Aug 2021 17:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628013087;
        bh=GRhDANirGP1JjqAiSM5K7NF5Y+3qAPgJOKc5+GERRw8=;
        h=From:To:Cc:Subject:Date:From;
        b=SVDj0gpLOgNDEABG6wMnBhILm4f1zaU/zesrZHkekqGPOS9q4blhMPXSWMFdzGKaL
         L1Sc/VD3tqHBb2vCKnD4EdylbH0EPC8L0664pl5UE23CA2BJt//O6z7aEX0yEoc1x/
         lFFXhsTU/rv+ovP1lbzbpkxGIEhxv5h0NSvZyvgkvNNSj0nZx5qyhs8S8Po7b1cchr
         AEtNXS7KdEkc286WR6ORPQoZlukZ61oOJHjUNM8rBq617cHzckjzy4YNA7nLsIO5T9
         yDmayMhTY5m8iWoMvkB8YVUlRWViqwUPAJrPqxyLTVpJzZT+NCNCflXzS2iLTzf/tG
         UX5uvOHcwcP3g==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Sage Weil <sage@redhat.com>,
        Mark Nelson <mnelson@redhat.com>
Subject: [PATCH] ceph: ensure we take snap_empty_lock atomically with refcount change
Date:   Tue,  3 Aug 2021 13:51:26 -0400
Message-Id: <20210803175126.29165-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

There is a race in ceph_put_snap_realm. The change to the nref and the
spinlock acquisition are not done atomically, so you could change nref,
and before you take the spinlock, the nref is incremented again. At that
point, you end up putting it on the empty list when it shouldn't be
there. Eventually __cleanup_empty_realms runs and frees it when it's
still in-use.

Fix this by protecting the 1->0 transition with atomic_dec_and_lock,
which should ensure that the race can't occur.

Because these objects can also undergo a 0->1 refcount transition, we
must protect that change as well with the spinlock. Increment locklessly
unless the value is at 0, in which case we take the spinlock, increment
and then take it off the empty list.

With these changes, I'm removing the dout() messages from these
functions as well. They've always been racy, and it's better to not
print values that may be misleading.

Cc: Sage Weil <sage@redhat.com>
Reported-by: Mark Nelson <mnelson@redhat.com>
URL: https://tracker.ceph.com/issues/46419
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/snap.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 9dbc92cfda38..c81ba22711a5 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -67,19 +67,20 @@ void ceph_get_snap_realm(struct ceph_mds_client *mdsc,
 {
 	lockdep_assert_held(&mdsc->snap_rwsem);
 
-	dout("get_realm %p %d -> %d\n", realm,
-	     atomic_read(&realm->nref), atomic_read(&realm->nref)+1);
 	/*
-	 * since we _only_ increment realm refs or empty the empty
-	 * list with snap_rwsem held, adjusting the empty list here is
-	 * safe.  we do need to protect against concurrent empty list
-	 * additions, however.
+	 * The 0->1 and 1->0 transitions must take the snap_empty_lock
+	 * atomically with the refcount change. Go ahead and bump the
+	 * nref * here, unless it's 0, in which case we take the
+	 * spinlock and then do the increment and remove it from the
+	 * list.
 	 */
-	if (atomic_inc_return(&realm->nref) == 1) {
-		spin_lock(&mdsc->snap_empty_lock);
+	if (atomic_add_unless(&realm->nref, 1, 0))
+		return;
+
+	spin_lock(&mdsc->snap_empty_lock);
+	if (atomic_inc_return(&realm->nref) == 1)
 		list_del_init(&realm->empty_item);
-		spin_unlock(&mdsc->snap_empty_lock);
-	}
+	spin_unlock(&mdsc->snap_empty_lock);
 }
 
 static void __insert_snap_realm(struct rb_root *root,
@@ -215,21 +216,19 @@ static void __put_snap_realm(struct ceph_mds_client *mdsc,
 }
 
 /*
- * caller needn't hold any locks
+ * See comments in ceph_get_snap_realm. Caller needn't hold any locks.
  */
 void ceph_put_snap_realm(struct ceph_mds_client *mdsc,
 			 struct ceph_snap_realm *realm)
 {
-	dout("put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
-	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
-	if (!atomic_dec_and_test(&realm->nref))
+	if (!atomic_dec_and_lock(&realm->nref, &mdsc->snap_empty_lock))
 		return;
 
 	if (down_write_trylock(&mdsc->snap_rwsem)) {
+		spin_unlock(&mdsc->snap_empty_lock);
 		__destroy_snap_realm(mdsc, realm);
 		up_write(&mdsc->snap_rwsem);
 	} else {
-		spin_lock(&mdsc->snap_empty_lock);
 		list_add(&realm->empty_item, &mdsc->snap_empty);
 		spin_unlock(&mdsc->snap_empty_lock);
 	}
-- 
2.31.1


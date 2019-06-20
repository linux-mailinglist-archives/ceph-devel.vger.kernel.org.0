Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7E274CEA5
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 15:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731511AbfFTN2a (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 09:28:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40706 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726392AbfFTN2a (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 09:28:30 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EF4C981F0E
        for <ceph-devel@vger.kernel.org>; Thu, 20 Jun 2019 13:28:29 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-67.pek2.redhat.com [10.72.12.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2492A60FAB;
        Thu, 20 Jun 2019 13:28:27 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 3/3] ceph: more precise CEPH_CLIENT_CAPS_PENDING_CAPSNAP
Date:   Thu, 20 Jun 2019 21:28:21 +0800
Message-Id: <20190620132821.7814-3-zyan@redhat.com>
In-Reply-To: <20190620132821.7814-1-zyan@redhat.com>
References: <20190620132821.7814-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 20 Jun 2019 13:28:29 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Client uses this flag to tell mds if there is more cap snap need to
flush. It's mainly for the case that client needs to re-send cap/snap
flushes after mds failover, but CEPH_CAP_ANY_FILE_WR on corresponding
inodes are all released before mds failover.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/caps.c               | 41 ++++++++++++++++++++++++++----------
 include/linux/ceph/ceph_fs.h |  2 +-
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 82cfb153d0f3..4b189c97799d 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1295,7 +1295,7 @@ void __ceph_remove_caps(struct ceph_inode_info *ci)
  * caller should hold snap_rwsem (read), s_mutex.
  */
 static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
-		      int op, bool sync, int used, int want, int retain,
+		      int op, int flags, int used, int want, int retain,
 		      int flushing, u64 flush_tid, u64 oldest_flush_tid)
 	__releases(cap->ci->i_ceph_lock)
 {
@@ -1393,12 +1393,19 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
 	arg.mode = inode->i_mode;
 
 	arg.inline_data = ci->i_inline_version != CEPH_INLINE_NONE;
-	if (list_empty(&ci->i_cap_snaps))
-		arg.flags = CEPH_CLIENT_CAPS_NO_CAPSNAP;
-	else
-		arg.flags = CEPH_CLIENT_CAPS_PENDING_CAPSNAP;
-	if (sync)
-		arg.flags |= CEPH_CLIENT_CAPS_SYNC;
+	if (!(flags & CEPH_CLIENT_CAPS_PENDING_CAPSNAP) &&
+	    !list_empty(&ci->i_cap_snaps)) {
+		struct ceph_cap_snap *capsnap;
+		list_for_each_entry_reverse(capsnap, &ci->i_cap_snaps, ci_item) {
+			if (capsnap->cap_flush.tid)
+				break;
+			if (capsnap->need_flush) {
+				flags |= CEPH_CLIENT_CAPS_PENDING_CAPSNAP;
+				break;
+			}
+		}
+	}
+	arg.flags = flags;
 
 	spin_unlock(&ci->i_ceph_lock);
 
@@ -2085,7 +2092,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 		sent++;
 
 		/* __send_cap drops i_ceph_lock */
-		delayed += __send_cap(mdsc, cap, CEPH_CAP_OP_UPDATE, false,
+		delayed += __send_cap(mdsc, cap, CEPH_CAP_OP_UPDATE, 0,
 				cap_used, want, retain, flushing,
 				flush_tid, oldest_flush_tid);
 		goto retry; /* retake i_ceph_lock and restart our cap scan. */
@@ -2155,7 +2162,8 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
 						&flush_tid, &oldest_flush_tid);
 
 		/* __send_cap drops i_ceph_lock */
-		delayed = __send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH, true,
+		delayed = __send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH,
+				     CEPH_CLIENT_CAPS_SYNC,
 				     __ceph_caps_used(ci),
 				     __ceph_caps_wanted(ci),
 				     (cap->issued | cap->implemented),
@@ -2338,9 +2346,17 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
 	struct ceph_cap_flush *cf;
 	int ret;
 	u64 first_tid = 0;
+	u64 last_snap_flush = 0;
 
 	ci->i_ceph_flags &= ~CEPH_I_KICK_FLUSH;
 
+	list_for_each_entry_reverse(cf, &ci->i_cap_flush_list, i_list) {
+		if (!cf->caps) {
+			last_snap_flush = cf->tid;
+			break;
+		}
+	}
+
 	list_for_each_entry(cf, &ci->i_cap_flush_list, i_list) {
 		if (cf->tid < first_tid)
 			continue;
@@ -2358,10 +2374,13 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
 			dout("kick_flushing_caps %p cap %p tid %llu %s\n",
 			     inode, cap, cf->tid, ceph_cap_string(cf->caps));
 			ci->i_ceph_flags |= CEPH_I_NODELAY;
+
 			ret = __send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH,
-					  false, __ceph_caps_used(ci),
+					 (cf->tid < last_snap_flush ?
+					  CEPH_CLIENT_CAPS_PENDING_CAPSNAP : 0),
+					  __ceph_caps_used(ci),
 					  __ceph_caps_wanted(ci),
-					  cap->issued | cap->implemented,
+					  (cap->issued | cap->implemented),
 					  cf->caps, cf->tid, oldest_flush_tid);
 			if (ret) {
 				pr_err("kick_flushing_caps: error sending "
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index 3ac0feaf2b5e..cb21c5cf12c3 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -682,7 +682,7 @@ extern const char *ceph_cap_op_name(int op);
 /* flags field in client cap messages (version >= 10) */
 #define CEPH_CLIENT_CAPS_SYNC			(1<<0)
 #define CEPH_CLIENT_CAPS_NO_CAPSNAP		(1<<1)
-#define CEPH_CLIENT_CAPS_PENDING_CAPSNAP	(1<<2);
+#define CEPH_CLIENT_CAPS_PENDING_CAPSNAP	(1<<2)
 
 /*
  * caps message, used for capability callbacks, acks, requests, etc.
-- 
2.17.2


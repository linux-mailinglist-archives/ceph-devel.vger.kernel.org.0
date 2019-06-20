Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97B004CEA3
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 15:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfFTN2Z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 09:28:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726392AbfFTN2Z (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 09:28:25 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2591A2F8BD5
        for <ceph-devel@vger.kernel.org>; Thu, 20 Jun 2019 13:28:25 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-67.pek2.redhat.com [10.72.12.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D61E60FAB;
        Thu, 20 Jun 2019 13:28:23 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 1/3] ceph: clear CEPH_I_KICK_FLUSH flag inside __kick_flushing_caps()
Date:   Thu, 20 Jun 2019 21:28:19 +0800
Message-Id: <20190620132821.7814-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 20 Jun 2019 13:28:25 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/caps.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 61f9bde547e3..cd946bca4792 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1605,10 +1605,8 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
 	}
 
 	// make sure flushsnap messages are sent in proper order.
-	if (ci->i_ceph_flags & CEPH_I_KICK_FLUSH) {
+	if (ci->i_ceph_flags & CEPH_I_KICK_FLUSH)
 		__kick_flushing_caps(mdsc, session, ci, 0);
-		ci->i_ceph_flags &= ~CEPH_I_KICK_FLUSH;
-	}
 
 	__ceph_flush_snaps(ci, session);
 out:
@@ -2050,10 +2048,8 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 		if (cap == ci->i_auth_cap &&
 		    (ci->i_ceph_flags &
 		     (CEPH_I_KICK_FLUSH | CEPH_I_FLUSH_SNAPS))) {
-			if (ci->i_ceph_flags & CEPH_I_KICK_FLUSH) {
+			if (ci->i_ceph_flags & CEPH_I_KICK_FLUSH)
 				__kick_flushing_caps(mdsc, session, ci, 0);
-				ci->i_ceph_flags &= ~CEPH_I_KICK_FLUSH;
-			}
 			if (ci->i_ceph_flags & CEPH_I_FLUSH_SNAPS)
 				__ceph_flush_snaps(ci, session);
 
@@ -2333,6 +2329,8 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
 	int ret;
 	u64 first_tid = 0;
 
+	ci->i_ceph_flags &= ~CEPH_I_KICK_FLUSH;
+
 	list_for_each_entry(cf, &ci->i_cap_flush_list, i_list) {
 		if (cf->tid < first_tid)
 			continue;
@@ -2422,7 +2420,6 @@ void ceph_early_kick_flushing_caps(struct ceph_mds_client *mdsc,
 		 */
 		if ((cap->issued & ci->i_flushing_caps) !=
 		    ci->i_flushing_caps) {
-			ci->i_ceph_flags &= ~CEPH_I_KICK_FLUSH;
 			/* encode_caps_cb() also will reset these sequence
 			 * numbers. make sure sequence numbers in cap flush
 			 * message match later reconnect message */
@@ -2462,7 +2459,6 @@ void ceph_kick_flushing_caps(struct ceph_mds_client *mdsc,
 			continue;
 		}
 		if (ci->i_ceph_flags & CEPH_I_KICK_FLUSH) {
-			ci->i_ceph_flags &= ~CEPH_I_KICK_FLUSH;
 			__kick_flushing_caps(mdsc, session, ci,
 					     oldest_flush_tid);
 		}
@@ -2490,7 +2486,6 @@ static void kick_flushing_inode_caps(struct ceph_mds_client *mdsc,
 		oldest_flush_tid = __get_oldest_flush_tid(mdsc);
 		spin_unlock(&mdsc->cap_dirty_lock);
 
-		ci->i_ceph_flags &= ~CEPH_I_KICK_FLUSH;
 		__kick_flushing_caps(mdsc, session, ci, oldest_flush_tid);
 		spin_unlock(&ci->i_ceph_lock);
 	} else {
-- 
2.17.2


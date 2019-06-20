Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 178444CEA4
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 15:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfFTN22 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 09:28:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45046 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726392AbfFTN21 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 09:28:27 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8A9953060310
        for <ceph-devel@vger.kernel.org>; Thu, 20 Jun 2019 13:28:27 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-67.pek2.redhat.com [10.72.12.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3E3861987;
        Thu, 20 Jun 2019 13:28:25 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 2/3] ceph: kick flushing and flush snaps before sending normal cap message
Date:   Thu, 20 Jun 2019 21:28:20 +0800
Message-Id: <20190620132821.7814-2-zyan@redhat.com>
In-Reply-To: <20190620132821.7814-1-zyan@redhat.com>
References: <20190620132821.7814-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 20 Jun 2019 13:28:27 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Othweise client may send cap flush messages in wrong order.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/caps.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index cd946bca4792..82cfb153d0f3 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2119,6 +2119,7 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
 
 retry:
 	spin_lock(&ci->i_ceph_lock);
+retry_locked:
 	if (ci->i_ceph_flags & CEPH_I_NOFLUSH) {
 		spin_unlock(&ci->i_ceph_lock);
 		dout("try_flush_caps skipping %p I_NOFLUSH set\n", inode);
@@ -2126,8 +2127,6 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
 	}
 	if (ci->i_dirty_caps && ci->i_auth_cap) {
 		struct ceph_cap *cap = ci->i_auth_cap;
-		int used = __ceph_caps_used(ci);
-		int want = __ceph_caps_wanted(ci);
 		int delayed;
 
 		if (!session || session != cap->session) {
@@ -2143,13 +2142,24 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
 			goto out;
 		}
 
+		if (ci->i_ceph_flags &
+		    (CEPH_I_KICK_FLUSH | CEPH_I_FLUSH_SNAPS)) {
+			if (ci->i_ceph_flags & CEPH_I_KICK_FLUSH)
+				__kick_flushing_caps(mdsc, session, ci, 0);
+			if (ci->i_ceph_flags & CEPH_I_FLUSH_SNAPS)
+				__ceph_flush_snaps(ci, session);
+			goto retry_locked;
+		}
+
 		flushing = __mark_caps_flushing(inode, session, true,
 						&flush_tid, &oldest_flush_tid);
 
 		/* __send_cap drops i_ceph_lock */
 		delayed = __send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH, true,
-				used, want, (cap->issued | cap->implemented),
-				flushing, flush_tid, oldest_flush_tid);
+				     __ceph_caps_used(ci),
+				     __ceph_caps_wanted(ci),
+				     (cap->issued | cap->implemented),
+				     flushing, flush_tid, oldest_flush_tid);
 
 		if (delayed) {
 			spin_lock(&ci->i_ceph_lock);
-- 
2.17.2


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE33A285F1E
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Oct 2020 14:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgJGMZH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Oct 2020 08:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728039AbgJGMZG (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 7 Oct 2020 08:25:06 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 942D9206D9;
        Wed,  7 Oct 2020 12:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602073506;
        bh=LDzOY0VWYN5GCsrVJ0mev5ZAGGPcT4NRXmN5N9bbpoU=;
        h=From:To:Cc:Subject:Date:From;
        b=gm4JSmc7er7rH87hZERnPmNCI+ZPKttallnhOLyTN/siDRtlifjAsTArYh8DW96ux
         9Ly+gNeMaF4yFpdNPRkQUUobg/TMeb3TxLWfZ2u8GSyNJQr7FTMWHXKxG1a+P+psWd
         9hEpTjg9hAF/EHOlHISftSYkc/pv+8iHStIagGAo=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com
Subject: [PATCH] ceph: drop separate mdsc argument from __send_cap
Date:   Wed,  7 Oct 2020 08:25:03 -0400
Message-Id: <20201007122503.13256-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We can get it from the session if we need it.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 93ad644ee602..4e84b39a6ebd 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1454,8 +1454,7 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
  *
  * Caller should hold snap_rwsem (read), s_mutex.
  */
-static void __send_cap(struct ceph_mds_client *mdsc, struct cap_msg_args *arg,
-		       struct ceph_inode_info *ci)
+static void __send_cap(struct cap_msg_args *arg, struct ceph_inode_info *ci)
 {
 	struct inode *inode = &ci->vfs_inode;
 	int ret;
@@ -1467,7 +1466,7 @@ static void __send_cap(struct ceph_mds_client *mdsc, struct cap_msg_args *arg,
 		       ceph_vinop(inode), ceph_cap_string(arg->dirty),
 		       arg->flush_tid);
 		spin_lock(&ci->i_ceph_lock);
-		__cap_delay_requeue(mdsc, ci);
+		__cap_delay_requeue(arg->session->s_mdsc, ci);
 		spin_unlock(&ci->i_ceph_lock);
 	}
 
@@ -2147,7 +2146,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 			   want, retain, flushing, flush_tid, oldest_flush_tid);
 		spin_unlock(&ci->i_ceph_lock);
 
-		__send_cap(mdsc, &arg, ci);
+		__send_cap(&arg, ci);
 
 		goto retry; /* retake i_ceph_lock and restart our cap scan. */
 	}
@@ -2221,7 +2220,7 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
 			   flushing, flush_tid, oldest_flush_tid);
 		spin_unlock(&ci->i_ceph_lock);
 
-		__send_cap(mdsc, &arg, ci);
+		__send_cap(&arg, ci);
 	} else {
 		if (!list_empty(&ci->i_cap_flush_list)) {
 			struct ceph_cap_flush *cf =
@@ -2435,7 +2434,7 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
 					  (cap->issued | cap->implemented),
 					  cf->caps, cf->tid, oldest_flush_tid);
 			spin_unlock(&ci->i_ceph_lock);
-			__send_cap(mdsc, &arg, ci);
+			__send_cap(&arg, ci);
 		} else {
 			struct ceph_cap_snap *capsnap =
 					container_of(cf, struct ceph_cap_snap,
-- 
2.26.2


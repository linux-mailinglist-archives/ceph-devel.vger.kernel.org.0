Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49D1388234
	for <lists+ceph-devel@lfdr.de>; Tue, 18 May 2021 23:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352508AbhERVhs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 May 2021 17:37:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352420AbhERVhr (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 18 May 2021 17:37:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32B1E61244
        for <ceph-devel@vger.kernel.org>; Tue, 18 May 2021 21:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621373789;
        bh=jEkKF4bwxg94F1D8NZYd92GFg64mSuTqOy68T/CwlBE=;
        h=From:To:Subject:Date:From;
        b=aSfy7GNDWVlYdP7x3pdE0BT64k1KeZw8D5y0sHJXUpEO94/ipU9LYpt919NzKVmPy
         K+kQXs54TSjlrMvnUsm+lTr1qvxXgqAl55Lrwf+0Yq6vpgJ35F7iyMZ8r2uUJ2SRmP
         Vm8a1SFQRR3X73q8W47URCNePfR2RH+Z6QWkJ+MkB46CliRAmtvt/zrg0KZXz9n9YY
         vAPF1znZxi2TcHs9nBYEkq7sCWT4jRjwyKF0/o+OZaypZR9gR7d11iTkAmcqPwIdZq
         jQSqwiF4C67v3mPDMLuT4fxsObpRolGugwOLkf7dHqsGs7ZOSaL2YP1OwTWtm03SQD
         B7DoQh2xTQJ6g==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: make ceph_queue_cap_snap static
Date:   Tue, 18 May 2021 17:36:28 -0400
Message-Id: <20210518213628.119867-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/snap.c  | 2 +-
 fs/ceph/super.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 4ce18055d931..44b380a53727 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -460,7 +460,7 @@ static bool has_new_snaps(struct ceph_snap_context *o,
  * Caller must hold snap_rwsem for read (i.e., the realm topology won't
  * change).
  */
-void ceph_queue_cap_snap(struct ceph_inode_info *ci)
+static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
 {
 	struct inode *inode = &ci->vfs_inode;
 	struct ceph_cap_snap *capsnap;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index db80d89556b1..12d30153e4ca 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -931,7 +931,6 @@ extern int ceph_update_snap_trace(struct ceph_mds_client *m,
 extern void ceph_handle_snap(struct ceph_mds_client *mdsc,
 			     struct ceph_mds_session *session,
 			     struct ceph_msg *msg);
-extern void ceph_queue_cap_snap(struct ceph_inode_info *ci);
 extern int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
 				  struct ceph_cap_snap *capsnap);
 extern void ceph_cleanup_empty_realms(struct ceph_mds_client *mdsc);
-- 
2.31.1


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4E3A277C7
	for <lists+ceph-devel@lfdr.de>; Thu, 23 May 2019 10:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbfEWIOM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 May 2019 04:14:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60472 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727708AbfEWIOM (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 23 May 2019 04:14:12 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 904A3307D960
        for <ceph-devel@vger.kernel.org>; Thu, 23 May 2019 08:14:12 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-163.pek2.redhat.com [10.72.12.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A329462502;
        Thu, 23 May 2019 08:14:08 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 8/8] ceph: hold i_ceph_lock when removing caps for freeing inode
Date:   Thu, 23 May 2019 16:13:45 +0800
Message-Id: <20190523081345.20410-8-zyan@redhat.com>
In-Reply-To: <20190523081345.20410-1-zyan@redhat.com>
References: <20190523081345.20410-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 23 May 2019 08:14:12 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

ceph_d_revalidate(, LOOKUP_RCU) may call __ceph_caps_issued_mask()
on a freeing inode.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/caps.c  | 10 ++++++----
 fs/ceph/inode.c |  2 +-
 fs/ceph/super.h |  2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 0176241eaea7..7754d7679122 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1263,20 +1263,22 @@ static int send_cap_msg(struct cap_msg_args *arg)
 }
 
 /*
- * Queue cap releases when an inode is dropped from our cache.  Since
- * inode is about to be destroyed, there is no need for i_ceph_lock.
+ * Queue cap releases when an inode is dropped from our cache.
  */
-void __ceph_remove_caps(struct inode *inode)
+void __ceph_remove_caps(struct ceph_inode_info *ci)
 {
-	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct rb_node *p;
 
+	/* lock i_ceph_lock, because ceph_d_revalidate(..., LOOKUP_RCU)
+	 * may call __ceph_caps_issued_mask() on a freeing inode. */
+	spin_lock(&ci->i_ceph_lock);
 	p = rb_first(&ci->i_caps);
 	while (p) {
 		struct ceph_cap *cap = rb_entry(p, struct ceph_cap, ci_node);
 		p = rb_next(p);
 		__ceph_remove_cap(cap, true);
 	}
+	spin_unlock(&ci->i_ceph_lock);
 }
 
 /*
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index e47a25495be5..30d0cdc21035 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -534,7 +534,7 @@ void ceph_destroy_inode(struct inode *inode)
 
 	ceph_fscache_unregister_inode_cookie(ci);
 
-	__ceph_remove_caps(inode);
+	__ceph_remove_caps(ci);
 
 	if (__ceph_has_any_quota(ci))
 		ceph_adjust_quota_realms_count(inode, false);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 11aeb540b0cf..e74867743e07 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1003,7 +1003,7 @@ extern void ceph_add_cap(struct inode *inode,
 			 unsigned cap, unsigned seq, u64 realmino, int flags,
 			 struct ceph_cap **new_cap);
 extern void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release);
-extern void __ceph_remove_caps(struct inode* inode);
+extern void __ceph_remove_caps(struct ceph_inode_info *ci);
 extern void ceph_put_cap(struct ceph_mds_client *mdsc,
 			 struct ceph_cap *cap);
 extern int ceph_is_any_caps(struct inode *inode);
-- 
2.17.2


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC83515AEA9
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Feb 2020 18:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgBLR1f (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Feb 2020 12:27:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:35510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727680AbgBLR1e (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 Feb 2020 12:27:34 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAF2F24650;
        Wed, 12 Feb 2020 17:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581528454;
        bh=DQuRFXR8twTM84iujx6TaAVJV5W7o8v2zwrbebGg7pU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jzT9bHkmTm0yJF5k9skOsmxOQlSHXblUHHiopj2iX6S5lhIrNUvkHsVDUvJBH9tre
         4nZj5VlKOWga5iDdZPFatSTzWYQrDLGszC66KNyoUW0ED69MupOdok/RK0zCxZ/a79
         WraGTLICulEsqXUiPKax4/9/ZNEBVSqDfzJimYHY=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idridryomov@gmail.com, sage@redhat.com, zyan@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH v4 4/9] ceph: make __take_cap_refs non-static
Date:   Wed, 12 Feb 2020 12:27:24 -0500
Message-Id: <20200212172729.260752-5-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200212172729.260752-1-jlayton@kernel.org>
References: <20200212172729.260752-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Rename it to ceph_take_cap_refs and make it available to other files.
Also replace a comment with a lockdep assertion.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c  | 12 ++++++------
 fs/ceph/super.h |  2 ++
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 7fc87b693ba4..c983990acb75 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2512,12 +2512,12 @@ static void kick_flushing_inode_caps(struct ceph_mds_client *mdsc,
 /*
  * Take references to capabilities we hold, so that we don't release
  * them to the MDS prematurely.
- *
- * Protected by i_ceph_lock.
  */
-static void __take_cap_refs(struct ceph_inode_info *ci, int got,
+void ceph_take_cap_refs(struct ceph_inode_info *ci, int got,
 			    bool snap_rwsem_locked)
 {
+	lockdep_assert_held(&ci->i_ceph_lock);
+
 	if (got & CEPH_CAP_PIN)
 		ci->i_pin_ref++;
 	if (got & CEPH_CAP_FILE_RD)
@@ -2538,7 +2538,7 @@ static void __take_cap_refs(struct ceph_inode_info *ci, int got,
 		if (ci->i_wb_ref == 0)
 			ihold(&ci->vfs_inode);
 		ci->i_wb_ref++;
-		dout("__take_cap_refs %p wb %d -> %d (?)\n",
+		dout("%s %p wb %d -> %d (?)\n", __func__,
 		     &ci->vfs_inode, ci->i_wb_ref-1, ci->i_wb_ref);
 	}
 }
@@ -2664,7 +2664,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 			    (need & CEPH_CAP_FILE_RD) &&
 			    !(*got & CEPH_CAP_FILE_CACHE))
 				ceph_disable_fscache_readpage(ci);
-			__take_cap_refs(ci, *got, true);
+			ceph_take_cap_refs(ci, *got, true);
 			ret = 1;
 		}
 	} else {
@@ -2896,7 +2896,7 @@ int ceph_get_caps(struct file *filp, int need, int want,
 void ceph_get_cap_refs(struct ceph_inode_info *ci, int caps)
 {
 	spin_lock(&ci->i_ceph_lock);
-	__take_cap_refs(ci, caps, false);
+	ceph_take_cap_refs(ci, caps, false);
 	spin_unlock(&ci->i_ceph_lock);
 }
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 3192e506ad5e..ea68eef977ef 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1062,6 +1062,8 @@ extern void ceph_kick_flushing_caps(struct ceph_mds_client *mdsc,
 				    struct ceph_mds_session *session);
 extern struct ceph_cap *ceph_get_cap_for_mds(struct ceph_inode_info *ci,
 					     int mds);
+extern void ceph_take_cap_refs(struct ceph_inode_info *ci, int caps,
+				bool snap_rwsem_locked);
 extern void ceph_get_cap_refs(struct ceph_inode_info *ci, int caps);
 extern void ceph_put_cap_refs(struct ceph_inode_info *ci, int had);
 extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
-- 
2.24.1


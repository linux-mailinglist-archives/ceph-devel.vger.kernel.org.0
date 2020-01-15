Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A64DD13CE75
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2020 21:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbgAOU7W (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 Jan 2020 15:59:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:58026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729470AbgAOU7S (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 15:59:18 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1CE724679;
        Wed, 15 Jan 2020 20:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579121958;
        bh=GaqJ1vIZSYXIVzY3SZvvThwU7n1OU+iLj/eWCmE2oKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKvCqvqAPIbifuIlcvzS4Ay061/XzUkIghyLPypAkDyVbrlmGijS/fcXbtnA1SPnw
         vj3asy5jQ70+lS494AwvExiJIRPIzbqSxH/GEcNEFRXwyWrJ0gvw+JvhLgfQ/Cgtfx
         0nqpw8UpmGLVkCMWyMW28GCPxvY2EhqyFiG6i9H0=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com,
        pdonnell@redhat.com, xiubli@redhat.com
Subject: [RFC PATCH v2 04/10] ceph: make __take_cap_refs a public function
Date:   Wed, 15 Jan 2020 15:59:06 -0500
Message-Id: <20200115205912.38688-5-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115205912.38688-1-jlayton@kernel.org>
References: <20200115205912.38688-1-jlayton@kernel.org>
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
index f27b2bf9a3f5..cb7b549f0995 100644
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


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81B43173997
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Feb 2020 15:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgB1OPW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 28 Feb 2020 09:15:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:32800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbgB1OPW (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 28 Feb 2020 09:15:22 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1870246A0;
        Fri, 28 Feb 2020 14:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582899321;
        bh=wRHba2Xhi/XcR2rS1fgvFysIlDStguABNxoSO2I4qXU=;
        h=From:To:Cc:Subject:Date:From;
        b=rygF6lWmUqgMtF2WINmmS+SQT8D3fJX054bZhTV6vxMxV1KvTN4GuaFKA/Kz2W9R2
         n9f9qebYBVMlDn5Bw2FN5Lol4Ehp4qixXRXOQolMxjtUAuwim+fUyuwdcmC7baxga8
         nqSzNA/eUxniCwNXtLEvpOU5pXRqoyW2HGplNHUc=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com
Subject: [PATCH] ceph: clean up kick_flushing_inode_caps
Date:   Fri, 28 Feb 2020 09:15:19 -0500
Message-Id: <20200228141519.23406-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The last thing that this function does is release i_ceph_lock, so
have the caller do that instead. Add a lockdep assertion to
ensure that the function is always called with i_ceph_lock held.
Change the prototype to take a ceph_inode_info pointer and drop
the separate mdsc argument as we can get that from the session.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 9b3d5816c109..c02b63070e0a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2424,16 +2424,15 @@ void ceph_kick_flushing_caps(struct ceph_mds_client *mdsc,
 	}
 }
 
-static void kick_flushing_inode_caps(struct ceph_mds_client *mdsc,
-				     struct ceph_mds_session *session,
-				     struct inode *inode)
-	__releases(ci->i_ceph_lock)
+static void kick_flushing_inode_caps(struct ceph_mds_session *session,
+				     struct ceph_inode_info *ci)
 {
-	struct ceph_inode_info *ci = ceph_inode(inode);
-	struct ceph_cap *cap;
+	struct ceph_mds_client *mdsc = session->s_mdsc;
+	struct ceph_cap *cap = ci->i_auth_cap;
+
+	lockdep_assert_held(&ci->i_ceph_lock);
 
-	cap = ci->i_auth_cap;
-	dout("kick_flushing_inode_caps %p flushing %s\n", inode,
+	dout("%s %p flushing %s\n", __func__, &ci->vfs_inode,
 	     ceph_cap_string(ci->i_flushing_caps));
 
 	if (!list_empty(&ci->i_cap_flush_list)) {
@@ -2445,9 +2444,6 @@ static void kick_flushing_inode_caps(struct ceph_mds_client *mdsc,
 		spin_unlock(&mdsc->cap_dirty_lock);
 
 		__kick_flushing_caps(mdsc, session, ci, oldest_flush_tid);
-		spin_unlock(&ci->i_ceph_lock);
-	} else {
-		spin_unlock(&ci->i_ceph_lock);
 	}
 }
 
@@ -3326,11 +3322,10 @@ static void handle_cap_grant(struct inode *inode,
 	if (le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
 		if (newcaps & ~extra_info->issued)
 			wake = true;
-		kick_flushing_inode_caps(session->s_mdsc, session, inode);
+		kick_flushing_inode_caps(session, ci);
 		up_read(&session->s_mdsc->snap_rwsem);
-	} else {
-		spin_unlock(&ci->i_ceph_lock);
 	}
+	spin_unlock(&ci->i_ceph_lock);
 
 	if (fill_inline)
 		ceph_fill_inline_data(inode, NULL, extra_info->inline_data,
-- 
2.24.1


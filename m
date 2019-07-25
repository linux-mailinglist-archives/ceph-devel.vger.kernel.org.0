Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D66374CBE
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 13:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403943AbfGYLRw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 07:17:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403917AbfGYLRt (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 07:17:49 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 725CF22C97
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564053468;
        bh=TXbW8SY9/nknr2tQ0OeaYfQOyIIEk5SOmNbtYEPz6GA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Fs5x4V9zgarF/fLqJgQMmaZV/r9Z4eae4CrDN28uJb58kmhDUtwyna+EFIc1KpysR
         RgJ1el90vmZknD6StMGvM8YksGXToQ5lmbDNEVWqPBciwzZIpaRYoJDsoRm9VBRPZU
         78eGGh9B7R4plfomcxHbvw/pzh6fZ08TnnVl+3jI=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 1/8] ceph: remove ceph_get_cap_mds and __ceph_get_cap_mds
Date:   Thu, 25 Jul 2019 07:17:39 -0400
Message-Id: <20190725111746.10393-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190725111746.10393-1-jlayton@kernel.org>
References: <20190725111746.10393-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Nothing calls these routines.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c  | 31 -------------------------------
 fs/ceph/super.h |  1 -
 2 files changed, 32 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index d17bde5d4f9a..4615f2501e15 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -457,37 +457,6 @@ struct ceph_cap *ceph_get_cap_for_mds(struct ceph_inode_info *ci, int mds)
 	return cap;
 }
 
-/*
- * Return id of any MDS with a cap, preferably FILE_WR|BUFFER|EXCL, else -1.
- */
-static int __ceph_get_cap_mds(struct ceph_inode_info *ci)
-{
-	struct ceph_cap *cap;
-	int mds = -1;
-	struct rb_node *p;
-
-	/* prefer mds with WR|BUFFER|EXCL caps */
-	for (p = rb_first(&ci->i_caps); p; p = rb_next(p)) {
-		cap = rb_entry(p, struct ceph_cap, ci_node);
-		mds = cap->mds;
-		if (cap->issued & (CEPH_CAP_FILE_WR |
-				   CEPH_CAP_FILE_BUFFER |
-				   CEPH_CAP_FILE_EXCL))
-			break;
-	}
-	return mds;
-}
-
-int ceph_get_cap_mds(struct inode *inode)
-{
-	struct ceph_inode_info *ci = ceph_inode(inode);
-	int mds;
-	spin_lock(&ci->i_ceph_lock);
-	mds = __ceph_get_cap_mds(ceph_inode(inode));
-	spin_unlock(&ci->i_ceph_lock);
-	return mds;
-}
-
 /*
  * Called under i_ceph_lock.
  */
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 358559c17c41..817bab741267 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1052,7 +1052,6 @@ extern void ceph_kick_flushing_caps(struct ceph_mds_client *mdsc,
 				    struct ceph_mds_session *session);
 extern struct ceph_cap *ceph_get_cap_for_mds(struct ceph_inode_info *ci,
 					     int mds);
-extern int ceph_get_cap_mds(struct inode *inode);
 extern void ceph_get_cap_refs(struct ceph_inode_info *ci, int caps);
 extern void ceph_put_cap_refs(struct ceph_inode_info *ci, int had);
 extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
-- 
2.21.0


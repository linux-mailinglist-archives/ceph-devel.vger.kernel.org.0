Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7989DFC8B5
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 15:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfKNOTV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Nov 2019 09:19:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbfKNOTV (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 09:19:21 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53FAC20718;
        Thu, 14 Nov 2019 14:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573741160;
        bh=IoXaQSdGn6n8OLA422PHQu/qHeTSvqDBVVnHaJNxTuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uSoYu+IvvR15WNw625qu72VTyOZ/vh6QSGAos0TXzRsJK4VRTTHR1/3b/fmdNavXS
         8YVa4b0QuSyMWkMxycD9cQqmo/CwsVB7FHn9UZv7TdslzsySBRnKv3QrUZVKybpElS
         sREHf09PUu/3c6LB6U1Mev0xcQGkbZ4kpwcou1uk=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com
Subject: [PATCH v2] ceph: tone down loglevel on ceph_mdsc_build_path warning
Date:   Thu, 14 Nov 2019 09:19:19 -0500
Message-Id: <20191114141919.43145-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191113200348.141572-1-jlayton@kernel.org>
References: <20191113200348.141572-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When this occurs, it usually means that we raced with a rename, and
there is no need to warn in that case.  Only printk if we pass the
rename sequence check but still ended up with pos < 0.

Either way, this doesn't warrant a KERN_ERR message. Change it to
KERN_WARNING.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 54a4e480c16b..98bb1126583c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2183,13 +2183,17 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
 	}
 	base = ceph_ino(d_inode(temp));
 	rcu_read_unlock();
-	if (pos < 0 || read_seqretry(&rename_lock, seq)) {
-		pr_err("build_path did not end path lookup where "
-		       "expected, pos is %d\n", pos);
-		/* presumably this is only possible if racing with a
-		   rename of one of the parent directories (we can not
-		   lock the dentries above us to prevent this, but
-		   retrying should be harmless) */
+
+	if (read_seqretry(&rename_lock, seq))
+		goto retry;
+
+	if (pos < 0) {
+		/*
+		 * A rename didn't occur, but somehow we didn't end up where
+		 * we thought we would. Throw a warning and try again.
+		 */
+		pr_warn("build_path did not end path lookup where "
+			"expected, pos is %d\n", pos);
 		goto retry;
 	}
 
-- 
2.23.0


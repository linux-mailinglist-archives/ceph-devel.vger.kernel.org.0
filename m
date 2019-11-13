Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E463FB951
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Nov 2019 21:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfKMUDu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 13 Nov 2019 15:03:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:46818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbfKMUDu (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 13 Nov 2019 15:03:50 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BB10206E5;
        Wed, 13 Nov 2019 20:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573675430;
        bh=PImGdkGAcuSc5lPeCWvBjyMrq1rYE1RnTPBcGfvLtTs=;
        h=From:To:Cc:Subject:Date:From;
        b=b2X9uHgT3HACgseISCjA8yUdrhdKhfeTuteTgbw1C+9DxI/YjIMsJjygFGH71VZfN
         2W5lHUFUQr/6frpK2JfkQn7my7dkAnkh+/CsDrcCXM5J7MdavTUfK0nPEP7hBNIZSC
         Wa/XZlqiIuPmZ9c9dwGlJCWFcufAvrh1uC3JJ6Ro=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com
Subject: [PATCH] ceph: tone down loglevel on ceph_mdsc_build_path warning
Date:   Wed, 13 Nov 2019 15:03:47 -0500
Message-Id: <20191113200348.141572-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When this occurs, it usually means that we raced with a rename. Only
printk if we really did end up with pos < 0.

Either way, this is not a critical problem and doesn't warrant a
KERN_ERR warning. Change it to KERN_WARNING.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 54a4e480c16b..e6a5a07a65e5 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2184,8 +2184,10 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
 	base = ceph_ino(d_inode(temp));
 	rcu_read_unlock();
 	if (pos < 0 || read_seqretry(&rename_lock, seq)) {
-		pr_err("build_path did not end path lookup where "
-		       "expected, pos is %d\n", pos);
+		if (pos < 0)
+			pr_warn("build_path did not end path lookup where "
+				"expected, pos is %d\n", pos);
+
 		/* presumably this is only possible if racing with a
 		   rename of one of the parent directories (we can not
 		   lock the dentries above us to prevent this, but
-- 
2.23.0


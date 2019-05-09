Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F55618B1B
	for <lists+ceph-devel@lfdr.de>; Thu,  9 May 2019 16:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfEIOBt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 May 2019 10:01:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbfEIOBt (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 9 May 2019 10:01:49 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A2ED2089E;
        Thu,  9 May 2019 14:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557410509;
        bh=fUzEBDnIXGU2L9QfZgOmxcozXknVb1UL0CzCmsZaunE=;
        h=From:To:Cc:Subject:Date:From;
        b=F+o8QWkCCAvW2W25p/8O9ONlvdBOp/wrz8AAEZturrEEbnW9MB8cMDh8lAj1whuHj
         KL638hEyPfZL81EligOzWAyvWML5/y5cfncNQC13TuO55i80IJhyYkDgH/3mH81I5i
         iNX2OfkB1p6MU10PCVmaOxi4bXl3ncR+2bNcHy3U=
From:   Jeff Layton <jlayton@kernel.org>
To:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: fix ceph_mdsc_build_path to not stop on first component
Date:   Thu,  9 May 2019 10:01:47 -0400
Message-Id: <20190509140147.20755-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When ceph_mdsc_build_path is handed a positive dentry, it will return a
zero-length path string with the base set to that dentry. This is not
what we want. Always include at least one path component in the string.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

I found this while testing my asynchronous unlink patches. We have
to do the unlink in this case without the parent being locked, and
that showed that we got a bogus path built in this case.

This seems to work correctly, but it's a little unclear whether the
existing behavior is desirable in some cases. Is this the right thing
to do here?

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 66eae336a68a..39f5bd2eafda 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2114,9 +2114,10 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
 		if (inode && ceph_snap(inode) == CEPH_SNAPDIR) {
 			dout("build_path path+%d: %p SNAPDIR\n",
 			     pos, temp);
-		} else if (stop_on_nosnap && inode &&
+		} else if (stop_on_nosnap && inode && dentry != temp &&
 			   ceph_snap(inode) == CEPH_NOSNAP) {
 			spin_unlock(&temp->d_lock);
+			pos++; /* get rid of any prepended '/' */
 			break;
 		} else {
 			pos -= temp->d_name.len;
-- 
2.21.0


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 508291314E6
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jan 2020 16:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgAFPfZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jan 2020 10:35:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:39370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbgAFPfY (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 10:35:24 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 424352146E;
        Mon,  6 Jan 2020 15:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578324923;
        bh=4dvS4jOyIRnXI337Uj0SQ0koKkJxjIa9ksBeCN4BHAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3JaGHFyweOxp2MDJgILZhKDjg9gfF0rZHCAh14jckDdN/J8WjAWLhkUEVHZOE0hX
         1NS/3v6Ogk4mbSGZokjLa+8qipR877dogp00elhSPTo76IEGfl2XFNzwiYGGylxyZv
         Z+Xk2j5nYgvYosJJZJ3MPZ3W3s9kwQXFzvBKjeF0=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH 2/6] ceph: hold extra reference to r_parent over life of request
Date:   Mon,  6 Jan 2020 10:35:16 -0500
Message-Id: <20200106153520.307523-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200106153520.307523-1-jlayton@kernel.org>
References: <20200106153520.307523-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently, we just assume that it will stick around by virtue of the
submitter's reference, but later patches will allow the syscall to
return early and we can't rely on that reference at that point.

Take an extra reference to the inode when setting r_parent and release
it when releasing the request.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 94cce2ab92c4..b7122f682678 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -708,8 +708,10 @@ void ceph_mdsc_release_request(struct kref *kref)
 		/* avoid calling iput_final() in mds dispatch threads */
 		ceph_async_iput(req->r_inode);
 	}
-	if (req->r_parent)
+	if (req->r_parent) {
 		ceph_put_cap_refs(ceph_inode(req->r_parent), CEPH_CAP_PIN);
+		ceph_async_iput(req->r_parent);
+	}
 	ceph_async_iput(req->r_target_inode);
 	if (req->r_dentry)
 		dput(req->r_dentry);
@@ -2706,8 +2708,10 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
 	/* take CAP_PIN refs for r_inode, r_parent, r_old_dentry */
 	if (req->r_inode)
 		ceph_get_cap_refs(ceph_inode(req->r_inode), CEPH_CAP_PIN);
-	if (req->r_parent)
+	if (req->r_parent) {
 		ceph_get_cap_refs(ceph_inode(req->r_parent), CEPH_CAP_PIN);
+		ihold(req->r_parent);
+	}
 	if (req->r_old_dentry_dir)
 		ceph_get_cap_refs(ceph_inode(req->r_old_dentry_dir),
 				  CEPH_CAP_PIN);
-- 
2.24.1


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C907E40B
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Aug 2019 22:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfHAU0K (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Aug 2019 16:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbfHAU0J (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 16:26:09 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9FF82080C;
        Thu,  1 Aug 2019 20:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564691169;
        bh=lg2sSncJAePQ1VLP3BBA6UWn/Xj9FgztGxLE5Q2T3ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P6MS838FvLwxu5IRQSgaIixu38C5gAYb48lXxqmv0seVUiPgI3foktwfwZCpDlZHp
         IQap2m9GAxDTxkguV6rx9yUF73oZYDLTCBxjPy7fSqmryGGy0BoJBdDKeUV1nXXbQe
         9tyraFCoeX62z+Q4MSaHTlEtA4znQdlN5bQLRX8g=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH 2/9] ceph: hold extra reference to r_parent over life of request
Date:   Thu,  1 Aug 2019 16:25:58 -0400
Message-Id: <20190801202605.18172-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801202605.18172-1-jlayton@kernel.org>
References: <20190801202605.18172-1-jlayton@kernel.org>
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
index d3c00b417c4e..115f753e05b1 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -707,8 +707,10 @@ void ceph_mdsc_release_request(struct kref *kref)
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
@@ -2669,8 +2671,10 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
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
2.21.0


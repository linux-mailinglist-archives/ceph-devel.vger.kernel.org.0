Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CD62D4987
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Dec 2020 19:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387462AbgLISyo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Dec 2020 13:54:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733290AbgLISyh (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 13:54:37 -0500
From:   Jeff Layton <jlayton@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, xiubli@redhat.com, idryomov@gmail.com
Subject: [PATCH 1/4] ceph: don't reach into request header for readdir info
Date:   Wed,  9 Dec 2020 13:53:51 -0500
Message-Id: <20201209185354.29097-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209185354.29097-1-jlayton@kernel.org>
References: <20201209185354.29097-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We already have a pointer to the argument struct in req->r_args. Use that
instead of groveling around in the ceph_mds_request_head.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 9b85d86d8efb..93633cb4a905 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1594,8 +1594,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 	struct dentry *dn;
 	struct inode *in;
 	int err = 0, skipped = 0, ret, i;
-	struct ceph_mds_request_head *rhead = req->r_request->front.iov_base;
-	u32 frag = le32_to_cpu(rhead->args.readdir.frag);
+	u32 frag = le32_to_cpu(req->r_args.readdir.frag);
 	u32 last_hash = 0;
 	u32 fpos_offset;
 	struct ceph_readdir_cache_control cache_ctl = {};
@@ -1612,7 +1611,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 		} else if (rinfo->offset_hash) {
 			/* mds understands offset_hash */
 			WARN_ON_ONCE(req->r_readdir_offset != 2);
-			last_hash = le32_to_cpu(rhead->args.readdir.offset_hash);
+			last_hash = le32_to_cpu(req->r_args.readdir.offset_hash);
 		}
 	}
 
-- 
2.29.2


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3727E40C
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Aug 2019 22:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfHAU0L (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Aug 2019 16:26:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbfHAU0K (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 16:26:10 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 956C22084C;
        Thu,  1 Aug 2019 20:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564691170;
        bh=oPdnWw5iLQqd3ABGNQFABrtBkAYA0vsRRjE/JsBbDDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUtk5ag8tyhX7Z8Caw2un3VFlzULkTCzS6nIrYqvyrp/L0tJmUhGHNw0PGTyJXZmI
         zJKXbiiFeWXtDFnD3YlGFANEU/+cZjUKTq2cD54w0Mx6HdL5JqS0/wTRWt4aQTQ9Sg
         N67Pu2LK9OU8Plt5rGTfRfHy8MRomvW+R9/lA758=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH 3/9] ceph: register MDS request with dir inode from the get-go
Date:   Thu,  1 Aug 2019 16:25:59 -0400
Message-Id: <20190801202605.18172-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801202605.18172-1-jlayton@kernel.org>
References: <20190801202605.18172-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When the unsafe reply to a request comes in, we put it on the
r_unsafe_dir inode's list. In future patches, we're going to need to
wait on requests that may not have gotten an unsafe reply yet.

Change __register_request to put the entry on the dir inode's list when
the pointer is set in the request, and don't check the
CEPH_MDS_R_GOT_UNSAFE flag when unregistering it.

The only place that uses this list is fsync codepath, and for that we'd
want to wait on all operations whether the flag is set or not.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 115f753e05b1..89c71db77a33 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -791,8 +791,13 @@ static void __register_request(struct ceph_mds_client *mdsc,
 		mdsc->oldest_tid = req->r_tid;
 
 	if (dir) {
+		struct ceph_inode_info *ci = ceph_inode(dir);
+
 		ihold(dir);
 		req->r_unsafe_dir = dir;
+		spin_lock(&ci->i_unsafe_lock);
+		list_add_tail(&req->r_unsafe_dir_item, &ci->i_unsafe_dirops);
+		spin_unlock(&ci->i_unsafe_lock);
 	}
 }
 
@@ -820,8 +825,7 @@ static void __unregister_request(struct ceph_mds_client *mdsc,
 
 	erase_request(&mdsc->request_tree, req);
 
-	if (req->r_unsafe_dir  &&
-	    test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags)) {
+	if (req->r_unsafe_dir) {
 		struct ceph_inode_info *ci = ceph_inode(req->r_unsafe_dir);
 		spin_lock(&ci->i_unsafe_lock);
 		list_del_init(&req->r_unsafe_dir_item);
@@ -2891,14 +2895,6 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 	} else {
 		set_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags);
 		list_add_tail(&req->r_unsafe_item, &req->r_session->s_unsafe);
-		if (req->r_unsafe_dir) {
-			struct ceph_inode_info *ci =
-					ceph_inode(req->r_unsafe_dir);
-			spin_lock(&ci->i_unsafe_lock);
-			list_add_tail(&req->r_unsafe_dir_item,
-				      &ci->i_unsafe_dirops);
-			spin_unlock(&ci->i_unsafe_lock);
-		}
 	}
 
 	dout("handle_reply tid %lld result %d\n", tid, result);
-- 
2.21.0


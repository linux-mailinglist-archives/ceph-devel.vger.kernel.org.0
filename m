Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D59D31314E5
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jan 2020 16:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgAFPfZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jan 2020 10:35:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:39390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbgAFPfY (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 10:35:24 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0CF0214D8;
        Mon,  6 Jan 2020 15:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578324924;
        bh=U4dHSyzIWdYRC4xYQq3rB+RzZavBsvxDyWKKcHf9Id8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WjrUAoJk+m42OpeuyFEYwSVjPm0rSZO50niJYLn7e6qLez5aHDlLfUoSj1flzvrn8
         tjyEq3JsWj3S8eLYviPxVZMf4XWgyLJM4uxj3y3x01UNFU3l1ddK32C724NC9lpTpa
         djRzNBguHxfQ0+pDY7lesEK6ao0F7YwgKdzEMYOo=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH 3/6] ceph: register MDS request with dir inode from the start
Date:   Mon,  6 Jan 2020 10:35:17 -0500
Message-Id: <20200106153520.307523-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200106153520.307523-1-jlayton@kernel.org>
References: <20200106153520.307523-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When the unsafe reply to a request comes in, the request is put on the
r_unsafe_dir inode's list. In future patches, we're going to need to
wait on requests that may not have gotten an unsafe reply yet.

Change __register_request to put the entry on the dir inode's list when
the pointer is set in the request, and don't check the
CEPH_MDS_R_GOT_UNSAFE flag when unregistering it.

The only place that uses this list today is fsync codepath, and with
the coming changes, we'll want to wait on all operations whether it has
gotten an unsafe reply or not.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index b7122f682678..d334bbf7a4f9 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -792,8 +792,13 @@ static void __register_request(struct ceph_mds_client *mdsc,
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
 
@@ -821,8 +826,7 @@ static void __unregister_request(struct ceph_mds_client *mdsc,
 
 	erase_request(&mdsc->request_tree, req);
 
-	if (req->r_unsafe_dir  &&
-	    test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags)) {
+	if (req->r_unsafe_dir) {
 		struct ceph_inode_info *ci = ceph_inode(req->r_unsafe_dir);
 		spin_lock(&ci->i_unsafe_lock);
 		list_del_init(&req->r_unsafe_dir_item);
@@ -2929,14 +2933,6 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
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
2.24.1


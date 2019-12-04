Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B90113677
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2019 21:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbfLDUbW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Dec 2019 15:31:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727978AbfLDUbW (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 15:31:22 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9D2720659;
        Wed,  4 Dec 2019 20:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575491482;
        bh=2lsV2y6zQ4LSOpSfTUv9xk17/NwtKD/K7FFwPyxBg9U=;
        h=From:To:Cc:Subject:Date:From;
        b=OT+lTxQar8vW4VOaB92w1p5pEYlDrOKn/z/yY/0p4r7Nl9NrBMvuC2kwT27UgAhBi
         cTwM2kOSqN5uomdXj8zdY+E8DKTjj879dingnx/c9Rhwgu0vPXNbI7Hil0xRZrBjjB
         mRtV0gHod3dwqYKsAbQlSgpxEhnT8p8nh2ILZQUg=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com
Subject: [PATCH] ceph: drop unused ttl_from parameter from fill_inode
Date:   Wed,  4 Dec 2019 15:31:20 -0500
Message-Id: <20191204203120.12355-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index c07407586ce8..5bdc1afc2bee 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -728,8 +728,7 @@ void ceph_fill_file_time(struct inode *inode, int issued,
 static int fill_inode(struct inode *inode, struct page *locked_page,
 		      struct ceph_mds_reply_info_in *iinfo,
 		      struct ceph_mds_reply_dirfrag *dirinfo,
-		      struct ceph_mds_session *session,
-		      unsigned long ttl_from, int cap_fmode,
+		      struct ceph_mds_session *session, int cap_fmode,
 		      struct ceph_cap_reservation *caps_reservation)
 {
 	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
@@ -1237,7 +1236,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 		if (dir) {
 			err = fill_inode(dir, NULL,
 					 &rinfo->diri, rinfo->dirfrag,
-					 session, req->r_request_started, -1,
+					 session, -1,
 					 &req->r_caps_reservation);
 			if (err < 0)
 				goto done;
@@ -1305,9 +1304,9 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 		req->r_target_inode = in;
 
 		err = fill_inode(in, req->r_locked_page, &rinfo->targeti, NULL,
-				session, req->r_request_started,
+				session,
 				(!test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags) &&
-				rinfo->head->result == 0) ?  req->r_fmode : -1,
+				 rinfo->head->result == 0) ?  req->r_fmode : -1,
 				&req->r_caps_reservation);
 		if (err < 0) {
 			pr_err("fill_inode badness %p %llx.%llx\n",
@@ -1493,8 +1492,7 @@ static int readdir_prepopulate_inodes_only(struct ceph_mds_request *req,
 			continue;
 		}
 		rc = fill_inode(in, NULL, &rde->inode, NULL, session,
-				req->r_request_started, -1,
-				&req->r_caps_reservation);
+				-1, &req->r_caps_reservation);
 		if (rc < 0) {
 			pr_err("fill_inode badness on %p got %d\n", in, rc);
 			err = rc;
@@ -1694,8 +1692,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 		}
 
 		ret = fill_inode(in, NULL, &rde->inode, NULL, session,
-				 req->r_request_started, -1,
-				 &req->r_caps_reservation);
+				 -1, &req->r_caps_reservation);
 		if (ret < 0) {
 			pr_err("fill_inode badness on %p\n", in);
 			if (d_really_is_negative(dn)) {
-- 
2.23.0


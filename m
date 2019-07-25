Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35BF27573F
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 20:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfGYSwK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 14:52:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726107AbfGYSwK (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 14:52:10 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 603D922BEF
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2019 18:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564080728;
        bh=LlJsqsZJv3gcGOyquUKPQpm1gQnosiPLXqKEh7ZqSxg=;
        h=From:To:Subject:Date:From;
        b=MzQAiXviRzaW4n3kV4mLqLhuFaRgcnNTCZxDxPPnnNDPF9gUyFw7p9T82VRqSzKto
         y+PSPyEfEfqsfxt4MVfMe4/yKhumvLK9n1cI11MskGNpLQzlYEf5GwGLZQ9VPF6DfL
         gc6hHbcAVK1s4JRM7idN5mW5T88TRT4wvT37Dtsc=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: update the mtime when truncating up
Date:   Thu, 25 Jul 2019 14:52:07 -0400
Message-Id: <20190725185207.9665-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If we have Fx caps, and the we're truncating the size to be larger, then
we'll cache the size attribute change, but the mtime won't be updated.

Move the size handling before the mtime, and add ATTR_MTIME to ia_valid
in that case to make sure the mtime also gets updated.

This fixes xfstest generic/313.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 332433b490f5..9f135624ae47 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1989,7 +1989,7 @@ static const struct inode_operations ceph_symlink_iops = {
 int __ceph_setattr(struct inode *inode, struct iattr *attr)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	const unsigned int ia_valid = attr->ia_valid;
+	unsigned int ia_valid = attr->ia_valid;
 	struct ceph_mds_request *req;
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_cap_flush *prealloc_cf;
@@ -2094,6 +2094,26 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr)
 				   CEPH_CAP_FILE_RD | CEPH_CAP_FILE_WR;
 		}
 	}
+	if (ia_valid & ATTR_SIZE) {
+		dout("setattr %p size %lld -> %lld\n", inode,
+		     inode->i_size, attr->ia_size);
+		if ((issued & CEPH_CAP_FILE_EXCL) &&
+		    attr->ia_size > inode->i_size) {
+			i_size_write(inode, attr->ia_size);
+			inode->i_blocks = calc_inode_blocks(attr->ia_size);
+			ci->i_reported_size = attr->ia_size;
+			dirtied |= CEPH_CAP_FILE_EXCL;
+			ia_valid |= ATTR_MTIME;
+		} else if ((issued & CEPH_CAP_FILE_SHARED) == 0 ||
+			   attr->ia_size != inode->i_size) {
+			req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
+			req->r_args.setattr.old_size =
+				cpu_to_le64(inode->i_size);
+			mask |= CEPH_SETATTR_SIZE;
+			release |= CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL |
+				   CEPH_CAP_FILE_RD | CEPH_CAP_FILE_WR;
+		}
+	}
 	if (ia_valid & ATTR_MTIME) {
 		dout("setattr %p mtime %lld.%ld -> %lld.%ld\n", inode,
 		     inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec,
@@ -2116,25 +2136,6 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr)
 				   CEPH_CAP_FILE_RD | CEPH_CAP_FILE_WR;
 		}
 	}
-	if (ia_valid & ATTR_SIZE) {
-		dout("setattr %p size %lld -> %lld\n", inode,
-		     inode->i_size, attr->ia_size);
-		if ((issued & CEPH_CAP_FILE_EXCL) &&
-		    attr->ia_size > inode->i_size) {
-			i_size_write(inode, attr->ia_size);
-			inode->i_blocks = calc_inode_blocks(attr->ia_size);
-			ci->i_reported_size = attr->ia_size;
-			dirtied |= CEPH_CAP_FILE_EXCL;
-		} else if ((issued & CEPH_CAP_FILE_SHARED) == 0 ||
-			   attr->ia_size != inode->i_size) {
-			req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
-			req->r_args.setattr.old_size =
-				cpu_to_le64(inode->i_size);
-			mask |= CEPH_SETATTR_SIZE;
-			release |= CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL |
-				   CEPH_CAP_FILE_RD | CEPH_CAP_FILE_WR;
-		}
-	}
 
 	/* these do nothing */
 	if (ia_valid & ATTR_CTIME) {
-- 
2.21.0


Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF325A1240
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242673AbiHYNbv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242695AbiHYNbn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:31:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832C2B14D8
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:31:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20F6361CC8
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168E7C433C1;
        Thu, 25 Aug 2022 13:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434301;
        bh=eZzzQL5WLhuKerFkjEmyEja+1NcYP2nLwLBPXYb/5NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ogvYbIYidNN7u8Cz52kiEk6KTziDn5pkqFIuFJurvMbdytzd9uokMwyye4/gZ3viA
         Mu+yt83X5N/sPvTv2gDPvHbutUey/GLDtkox2QXEHtX41r3iBzkyZoq/Ag0Q5Q5ck8
         ydjixJ49pfUn4T0VtrO8sBTgCrUp0WtmabISNnEz2GGgJpRe7B+d20r7Qzdqb1aqyD
         rjapyf6NdtcdkFWnTw/du5D154/XSxOonXBdJQnwSN216DPgz28IRGy9VDqR5q03dG
         JqudwT2n9Etge+Ivx9WuqyEIaukVKzeTSETwHLCmY9rFLj5u/OXw+8KaJCnJP3KhU/
         p0Vx0NvvTYO1A==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 10/29] ceph: add object version support for sync read
Date:   Thu, 25 Aug 2022 09:31:13 -0400
Message-Id: <20220825133132.153657-11-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825133132.153657-1-jlayton@kernel.org>
References: <20220825133132.153657-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Always return the last object's version.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c  | 12 ++++++++++--
 fs/ceph/super.h |  3 ++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index d21378eeb43b..31de744b1a5f 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -952,7 +952,8 @@ enum {
  * only return a short read to the caller if we hit EOF.
  */
 ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
-			 struct iov_iter *to, int *retry_op)
+			 struct iov_iter *to, int *retry_op,
+			 u64 *last_objver)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
@@ -962,6 +963,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 	u64 len = iov_iter_count(to);
 	u64 i_size = i_size_read(inode);
 	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
+	u64 objver = 0;
 
 	dout("sync_read on inode %p %llx~%llx\n", inode, *ki_pos, len);
 
@@ -1031,6 +1033,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 					 req->r_end_latency,
 					 len, ret);
 
+		if (ret > 0)
+			objver = req->r_version;
+
 		i_size = i_size_read(inode);
 		dout("sync_read %llu~%llu got %zd i_size %llu%s\n",
 		     off, len, ret, i_size, (more ? " MORE" : ""));
@@ -1092,6 +1097,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		}
 	}
 
+	if (last_objver && ret > 0)
+		*last_objver = objver;
+
 	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);
 	return ret;
 }
@@ -1105,7 +1113,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 	dout("sync_read on file %p %llx~%zx %s\n", file, iocb->ki_pos,
 	     iov_iter_count(to), (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
 
-	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op);
+	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op, NULL);
 }
 
 struct ceph_aio_request {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 8b5095bd18ab..7e998c6d5718 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1277,7 +1277,8 @@ extern int ceph_open(struct inode *inode, struct file *file);
 extern int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 			    struct file *file, unsigned flags, umode_t mode);
 extern ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
-				struct iov_iter *to, int *retry_op);
+				struct iov_iter *to, int *retry_op,
+				u64 *last_objver);
 extern int ceph_release(struct inode *inode, struct file *filp);
 extern void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
 				  char *data, size_t len);
-- 
2.37.2


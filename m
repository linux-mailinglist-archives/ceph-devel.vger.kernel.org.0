Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CB1512264
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbiD0TUg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbiD0TTV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CBC53E17
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6F27B8291B
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276BEC385A9;
        Wed, 27 Apr 2022 19:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086828;
        bh=hufDPpYqCeqZaiv/AsWCxiKTSUC5k110DLYG84D+Pzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5AXTUjZXx0YBAx7/WJbQe/aDTP1gFfveC6O4gZ7qk7BuiDAA8qy7Cx+SIUyPAOyU
         1QHxhh3LQRG2VzLU/cWxfv8BtyctHIyZmOsCDx9hpS4drNFe7p3qFyJnIW1eedceNp
         z5Aqs7fBNXO+8D3szcWYkRrsDG8Y2XNyrK+olRf5RJwJ6LUDddoVAabaEFLN51ToAH
         A0ldCinquezk6EblquU10oETQ8a3t+zKJmiENBFAIasnHXJWVtDH4KrPLdv+EdeudX
         gj2VeSyipQIww+cqHrdvzTz92GCTnM1V/TBGxhe5YheJT2zC/gAQt7+L77JqwpvMYA
         YpEgN1FujIA/A==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 45/64] ceph: add __ceph_sync_read helper support
Date:   Wed, 27 Apr 2022 15:12:55 -0400
Message-Id: <20220427191314.222867-46-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427191314.222867-1-jlayton@kernel.org>
References: <20220427191314.222867-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Turn the guts of ceph_sync_read into a new helper that takes an inode
and an offset instead of a kiocb struct, and make ceph_sync_read call
the helper as a wrapper.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c  | 33 +++++++++++++++++++++------------
 fs/ceph/super.h |  2 ++
 2 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 0f4a18457259..297fa668bb06 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -937,22 +937,19 @@ enum {
  * If we get a short result from the OSD, check against i_size; we need to
  * only return a short read to the caller if we hit EOF.
  */
-static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
-			      int *retry_op)
+ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
+			 struct iov_iter *to, int *retry_op)
 {
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file_inode(file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_osd_client *osdc = &fsc->client->osdc;
 	ssize_t ret;
-	u64 off = iocb->ki_pos;
+	u64 off = *ki_pos;
 	u64 len = iov_iter_count(to);
 	u64 i_size = i_size_read(inode);
 	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
 
-	dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
-	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
+	dout("sync_read on inode %p %llx~%llx\n", inode, *ki_pos, len);
 
 	if (!len)
 		return 0;
@@ -1071,14 +1068,14 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 			break;
 	}
 
-	if (off > iocb->ki_pos) {
+	if (off > *ki_pos) {
 		if (off >= i_size) {
 			*retry_op = CHECK_EOF;
-			ret = i_size - iocb->ki_pos;
-			iocb->ki_pos = i_size;
+			ret = i_size - *ki_pos;
+			*ki_pos = i_size;
 		} else {
-			ret = off - iocb->ki_pos;
-			iocb->ki_pos = off;
+			ret = off - *ki_pos;
+			*ki_pos = off;
 		}
 	}
 
@@ -1086,6 +1083,18 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 	return ret;
 }
 
+static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
+			      int *retry_op)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file);
+
+	dout("sync_read on file %p %llx~%zx %s\n", file, iocb->ki_pos,
+	     iov_iter_count(to), (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
+
+	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op);
+}
+
 struct ceph_aio_request {
 	struct kiocb *iocb;
 	size_t total_len;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index d56f39c136ea..168ae951703d 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1259,6 +1259,8 @@ extern int ceph_renew_caps(struct inode *inode, int fmode);
 extern int ceph_open(struct inode *inode, struct file *file);
 extern int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 			    struct file *file, unsigned flags, umode_t mode);
+extern ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
+				struct iov_iter *to, int *retry_op);
 extern int ceph_release(struct inode *inode, struct file *filp);
 extern void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
 				  char *data, size_t len);
-- 
2.35.1


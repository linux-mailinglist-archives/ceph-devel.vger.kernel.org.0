Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F34512269
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbiD0TUo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbiD0TTW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D794F465
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A99B6B82929
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F09C385A7;
        Wed, 27 Apr 2022 19:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086829;
        bh=lCu3BpN3EGQNlqcCN1wHuZRfukvfC/C1dsFYYJE/Gq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mlWs54XDtuo3eTAhvAkNYOmRLUtm5jlod9MXo3Ze1R7axtmV24jmDRqrkWW6aepv/
         JCOtPiLpWhXuoUQOAelirWKOMBmVfgGmoO2EWEUkT5GJOWc+dLMcZvGSqB1V0aeyeJ
         RnezaCHdbRRCZ2MZ4i6iXetPN9h79Cic0lrA48DxIi1HgUFIHQ0EBWFFqR44yHaNtD
         uJ52YSJtcppRaa7fFC3aI8UjCiIWpGVlsMEgPwiLUDnHg/dhe8a/+MUxwHPF/5ZFCU
         WXHXRlvKXaTbgWsAMQ9mwnpyeux+O6CLvETTOxUJoX9oeXEYF7hl4F+xz70DLq5+LC
         ggzRh+NzBzr9g==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 46/64] ceph: add object version support for sync read
Date:   Wed, 27 Apr 2022 15:12:56 -0400
Message-Id: <20220427191314.222867-47-jlayton@kernel.org>
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

Always return the last object's version.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c  | 12 ++++++++++--
 fs/ceph/super.h |  3 ++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 297fa668bb06..7168cf97924b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -938,7 +938,8 @@ enum {
  * only return a short read to the caller if we hit EOF.
  */
 ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
-			 struct iov_iter *to, int *retry_op)
+			 struct iov_iter *to, int *retry_op,
+			 u64 *last_objver)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
@@ -948,6 +949,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 	u64 len = iov_iter_count(to);
 	u64 i_size = i_size_read(inode);
 	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
+	u64 objver = 0;
 
 	dout("sync_read on inode %p %llx~%llx\n", inode, *ki_pos, len);
 
@@ -1018,6 +1020,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 					 req->r_end_latency,
 					 len, ret);
 
+		if (ret > 0)
+			objver = req->r_version;
+
 		i_size = i_size_read(inode);
 		dout("sync_read %llu~%llu got %zd i_size %llu%s\n",
 		     off, len, ret, i_size, (more ? " MORE" : ""));
@@ -1079,6 +1084,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		}
 	}
 
+	if (last_objver && ret > 0)
+		*last_objver = objver;
+
 	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);
 	return ret;
 }
@@ -1092,7 +1100,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 	dout("sync_read on file %p %llx~%zx %s\n", file, iocb->ki_pos,
 	     iov_iter_count(to), (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
 
-	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op);
+	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op, NULL);
 }
 
 struct ceph_aio_request {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 168ae951703d..bd0bc14827c4 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1260,7 +1260,8 @@ extern int ceph_open(struct inode *inode, struct file *file);
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
2.35.1


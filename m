Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8D672D940
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 07:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240195AbjFMFcT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 01:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240053AbjFMFbt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 01:31:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6EA2946
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 22:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686634206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UaUZd6ZDQwTbfbPbp524u4FPobUm2kxSP1IcYVvxRvo=;
        b=EwhcxbT2FNxUaZFiDXWcvZU/7ff0wpRhrU0m6f/42t065BlzYiQkZGcv4oSA3mz2I9dSpG
        zhP7ByFdEO7ufgKfU9XyRT5m02rti+OOrXlxWw9RXr6mZ9pniv40eev8kvvTUK6LfK98Rs
        0Jbcqsno0mpB9DM12M60LWiwT0GS/XY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-p4g5d5J1PUu1Co_uGTak-Q-1; Tue, 13 Jun 2023 01:30:05 -0400
X-MC-Unique: p4g5d5J1PUu1Co_uGTak-Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B168B3C0ED4A;
        Tue, 13 Jun 2023 05:30:04 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3B4E1121314;
        Tue, 13 Jun 2023 05:29:59 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v20 47/71] ceph: add object version support for sync read
Date:   Tue, 13 Jun 2023 13:24:00 +0800
Message-Id: <20230613052424.254540-48-xiubli@redhat.com>
In-Reply-To: <20230613052424.254540-1-xiubli@redhat.com>
References: <20230613052424.254540-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Always return the last object's version.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c  | 12 ++++++++++--
 fs/ceph/super.h |  3 ++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index ab55caeed2c6..df321933153a 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -957,7 +957,8 @@ enum {
  * only return a short read to the caller if we hit EOF.
  */
 ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
-			 struct iov_iter *to, int *retry_op)
+			 struct iov_iter *to, int *retry_op,
+			 u64 *last_objver)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
@@ -967,6 +968,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 	u64 len = iov_iter_count(to);
 	u64 i_size = i_size_read(inode);
 	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
+	u64 objver = 0;
 
 	dout("sync_read on inode %p %llx~%llx\n", inode, *ki_pos, len);
 
@@ -1039,6 +1041,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 					 req->r_end_latency,
 					 len, ret);
 
+		if (ret > 0)
+			objver = req->r_version;
+
 		i_size = i_size_read(inode);
 		dout("sync_read %llu~%llu got %zd i_size %llu%s\n",
 		     off, len, ret, i_size, (more ? " MORE" : ""));
@@ -1100,6 +1105,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		}
 	}
 
+	if (last_objver && ret > 0)
+		*last_objver = objver;
+
 	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);
 	return ret;
 }
@@ -1113,7 +1121,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 	dout("sync_read on file %p %llx~%zx %s\n", file, iocb->ki_pos,
 	     iov_iter_count(to), (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
 
-	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op);
+	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op, NULL);
 }
 
 struct ceph_aio_request {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 1f8ccab73d42..3addefa9575b 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1289,7 +1289,8 @@ extern int ceph_open(struct inode *inode, struct file *file);
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
2.40.1


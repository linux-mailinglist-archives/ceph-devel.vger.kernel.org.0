Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D76602342
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Oct 2022 06:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiJREbK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Oct 2022 00:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiJREbJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Oct 2022 00:31:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371EB9E680
        for <ceph-devel@vger.kernel.org>; Mon, 17 Oct 2022 21:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666067467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1tZ14RenNsjbGft9X7WKUVQamtN29xaLD1eQeKqdJEE=;
        b=a86V+aJEI66e/ejV+FH+Nsf6dymoqWyrKiYp46tdgLfIoA1beauR/8fjBctgWgx+/7i5iP
        kI6Icsd6KyUqREzHtZFfLHAMWEsL5cjSHkuKybHmUJgF0a61ohCgqsSokei8Mq90PKTnnR
        /nTA6gqG87jwHAbyoEYwflHeTnT1k4A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-3TJPkHGHOWOMtQsH0uDF8Q-1; Tue, 18 Oct 2022 00:31:05 -0400
X-MC-Unique: 3TJPkHGHOWOMtQsH0uDF8Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F5A185A583;
        Tue, 18 Oct 2022 04:31:05 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 497B8492B0E;
        Tue, 18 Oct 2022 04:31:02 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, idryomov@gmail.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/2] ceph: remove useless session parameter for check_caps()
Date:   Tue, 18 Oct 2022 12:30:56 +0800
Message-Id: <20221018043057.24912-2-xiubli@redhat.com>
In-Reply-To: <20221018043057.24912-1-xiubli@redhat.com>
References: <20221018043057.24912-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The session parameter makes no sense any more.

URL: https://tracker.ceph.com/issues/46904
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c  |  2 +-
 fs/ceph/caps.c  | 23 +++++++++--------------
 fs/ceph/file.c  | 17 +++++++----------
 fs/ceph/inode.c |  6 +++---
 fs/ceph/ioctl.c |  2 +-
 fs/ceph/super.h |  3 +--
 6 files changed, 22 insertions(+), 31 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 3369c54d8002..da2fb2c97531 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1363,7 +1363,7 @@ static int ceph_write_end(struct file *file, struct address_space *mapping,
 	folio_put(folio);
 
 	if (check_cap)
-		ceph_check_caps(ceph_inode(inode), CHECK_CAPS_AUTHONLY, NULL);
+		ceph_check_caps(ceph_inode(inode), CHECK_CAPS_AUTHONLY);
 
 	return copied;
 }
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 441e3c2ff042..5e5b0c696584 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1949,8 +1949,7 @@ bool __ceph_should_report_size(struct ceph_inode_info *ci)
  *  CHECK_CAPS_FLUSH - we should flush any dirty caps immediately, without
  *    further delay.
  */
-void ceph_check_caps(struct ceph_inode_info *ci, int flags,
-		     struct ceph_mds_session *session)
+void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 {
 	struct inode *inode = &ci->netfs.inode;
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
@@ -1964,15 +1963,12 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 	bool queue_invalidate = false;
 	bool tried_invalidate = false;
 	bool queue_writeback = false;
-
-	if (session)
-		ceph_get_mds_session(session);
+	struct ceph_mds_session *session = NULL;
 
 	spin_lock(&ci->i_ceph_lock);
 	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
 		/* Don't send messages until we get async create reply */
 		spin_unlock(&ci->i_ceph_lock);
-		ceph_put_mds_session(session);
 		return;
 	}
 
@@ -2926,7 +2922,7 @@ static void check_max_size(struct inode *inode, loff_t endoff)
 		check = 1;
 	spin_unlock(&ci->i_ceph_lock);
 	if (check)
-		ceph_check_caps(ci, CHECK_CAPS_AUTHONLY, NULL);
+		ceph_check_caps(ci, CHECK_CAPS_AUTHONLY);
 }
 
 static inline int get_used_fmode(int caps)
@@ -3215,7 +3211,7 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 	switch (mode) {
 	case PUT_CAP_REFS_SYNC:
 		if (last)
-			ceph_check_caps(ci, 0, NULL);
+			ceph_check_caps(ci, 0);
 		else if (flushsnaps)
 			ceph_flush_snaps(ci, NULL);
 		break;
@@ -3330,7 +3326,7 @@ void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
 	spin_unlock(&ci->i_ceph_lock);
 
 	if (last) {
-		ceph_check_caps(ci, 0, NULL);
+		ceph_check_caps(ci, 0);
 	} else if (flush_snaps) {
 		ceph_flush_snaps(ci, NULL);
 	}
@@ -3679,10 +3675,9 @@ static void handle_cap_grant(struct inode *inode,
 
 	mutex_unlock(&session->s_mutex);
 	if (check_caps == 1)
-		ceph_check_caps(ci, CHECK_CAPS_AUTHONLY | CHECK_CAPS_NOINVAL,
-				session);
+		ceph_check_caps(ci, CHECK_CAPS_AUTHONLY | CHECK_CAPS_NOINVAL);
 	else if (check_caps == 2)
-		ceph_check_caps(ci, CHECK_CAPS_NOINVAL, session);
+		ceph_check_caps(ci, CHECK_CAPS_NOINVAL);
 }
 
 /*
@@ -4421,7 +4416,7 @@ unsigned long ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 		if (inode) {
 			spin_unlock(&mdsc->cap_delay_lock);
 			dout("check_delayed_caps on %p\n", inode);
-			ceph_check_caps(ci, 0, NULL);
+			ceph_check_caps(ci, 0);
 			iput(inode);
 			spin_lock(&mdsc->cap_delay_lock);
 		}
@@ -4450,7 +4445,7 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
 		dout("flush_dirty_caps %llx.%llx\n", ceph_vinop(inode));
 		spin_unlock(&mdsc->cap_dirty_lock);
 		ceph_wait_on_async_create(inode);
-		ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
+		ceph_check_caps(ci, CHECK_CAPS_FLUSH);
 		iput(inode);
 		spin_lock(&mdsc->cap_dirty_lock);
 	}
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 86265713a743..eb34da31600d 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -313,7 +313,7 @@ int ceph_renew_caps(struct inode *inode, int fmode)
 		spin_unlock(&ci->i_ceph_lock);
 		dout("renew caps %p want %s issued %s updating mds_wanted\n",
 		     inode, ceph_cap_string(wanted), ceph_cap_string(issued));
-		ceph_check_caps(ci, 0, NULL);
+		ceph_check_caps(ci, 0);
 		return 0;
 	}
 	spin_unlock(&ci->i_ceph_lock);
@@ -413,7 +413,7 @@ int ceph_open(struct inode *inode, struct file *file)
 		if ((issued & wanted) != wanted &&
 		    (mds_wanted & wanted) != wanted &&
 		    ceph_snap(inode) != CEPH_SNAPDIR)
-			ceph_check_caps(ci, 0, NULL);
+			ceph_check_caps(ci, 0);
 
 		return ceph_init_file(inode, file, fmode);
 	} else if (ceph_snap(inode) != CEPH_NOSNAP &&
@@ -1142,7 +1142,7 @@ static void ceph_aio_complete(struct inode *inode,
 		loff_t endoff = aio_req->iocb->ki_pos + aio_req->total_len;
 		if (endoff > i_size_read(inode)) {
 			if (ceph_inode_set_size(inode, endoff))
-				ceph_check_caps(ci, CHECK_CAPS_AUTHONLY, NULL);
+				ceph_check_caps(ci, CHECK_CAPS_AUTHONLY);
 		}
 
 		spin_lock(&ci->i_ceph_lock);
@@ -1488,8 +1488,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 		if (write && pos > size) {
 			if (ceph_inode_set_size(inode, pos))
 				ceph_check_caps(ceph_inode(inode),
-						CHECK_CAPS_AUTHONLY,
-						NULL);
+						CHECK_CAPS_AUTHONLY);
 		}
 	}
 
@@ -1644,8 +1643,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 			check_caps = ceph_inode_set_size(inode, pos);
 			if (check_caps)
 				ceph_check_caps(ceph_inode(inode),
-						CHECK_CAPS_AUTHONLY,
-						NULL);
+						CHECK_CAPS_AUTHONLY);
 		}
 
 	}
@@ -1973,7 +1971,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		if (dirty)
 			__mark_inode_dirty(inode, dirty);
 		if (ceph_quota_is_max_bytes_approaching(inode, iocb->ki_pos))
-			ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
+			ceph_check_caps(ci, CHECK_CAPS_FLUSH);
 	}
 
 	dout("aio_write %p %llx.%llx %llu~%u  dropping cap refs on %s\n",
@@ -2588,8 +2586,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 		/* Let the MDS know about dst file size change */
 		if (ceph_inode_set_size(dst_inode, dst_off) ||
 		    ceph_quota_is_max_bytes_approaching(dst_inode, dst_off))
-			ceph_check_caps(dst_ci, CHECK_CAPS_AUTHONLY | CHECK_CAPS_FLUSH,
-					NULL);
+			ceph_check_caps(dst_ci, CHECK_CAPS_AUTHONLY | CHECK_CAPS_FLUSH);
 	}
 	/* Mark Fw dirty */
 	spin_lock(&dst_ci->i_ceph_lock);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 559e39b9d426..393778e1f832 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2101,7 +2101,7 @@ static void ceph_do_invalidate_pages(struct inode *inode)
 	mutex_unlock(&ci->i_truncate_mutex);
 out:
 	if (check)
-		ceph_check_caps(ci, 0, NULL);
+		ceph_check_caps(ci, 0);
 }
 
 /*
@@ -2161,7 +2161,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
 	mutex_unlock(&ci->i_truncate_mutex);
 
 	if (wrbuffer_refs == 0)
-		ceph_check_caps(ci, 0, NULL);
+		ceph_check_caps(ci, 0);
 
 	wake_up_all(&ci->i_cap_wq);
 }
@@ -2183,7 +2183,7 @@ static void ceph_inode_work(struct work_struct *work)
 		__ceph_do_pending_vmtruncate(inode);
 
 	if (test_and_clear_bit(CEPH_I_WORK_CHECK_CAPS, &ci->i_work_mask))
-		ceph_check_caps(ci, 0, NULL);
+		ceph_check_caps(ci, 0);
 
 	if (test_and_clear_bit(CEPH_I_WORK_FLUSH_SNAPS, &ci->i_work_mask))
 		ceph_flush_snaps(ci, NULL);
diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
index b9f0f4e460ab..7f0e181d4329 100644
--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -254,7 +254,7 @@ static long ceph_ioctl_lazyio(struct file *file)
 		spin_unlock(&ci->i_ceph_lock);
 		dout("ioctl_layzio: file %p marked lazy\n", file);
 
-		ceph_check_caps(ci, 0, NULL);
+		ceph_check_caps(ci, 0);
 	} else {
 		dout("ioctl_layzio: file %p already lazy\n", file);
 	}
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index b15b455f7d1c..cff419f63e51 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1228,8 +1228,7 @@ extern void ceph_remove_capsnap(struct inode *inode,
 extern void ceph_flush_snaps(struct ceph_inode_info *ci,
 			     struct ceph_mds_session **psession);
 extern bool __ceph_should_report_size(struct ceph_inode_info *ci);
-extern void ceph_check_caps(struct ceph_inode_info *ci, int flags,
-			    struct ceph_mds_session *session);
+extern void ceph_check_caps(struct ceph_inode_info *ci, int flags);
 extern unsigned long ceph_check_delayed_caps(struct ceph_mds_client *mdsc);
 extern void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc);
 extern int  ceph_drop_caps_for_unlink(struct inode *inode);
-- 
2.31.1


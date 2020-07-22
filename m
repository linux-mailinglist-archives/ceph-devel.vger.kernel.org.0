Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221A22296AE
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jul 2020 12:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgGVKzQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Jul 2020 06:55:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbgGVKzP (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 22 Jul 2020 06:55:15 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0274207CD;
        Wed, 22 Jul 2020 10:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595415314;
        bh=eD1r1tFi0hrY0bhaaAT3xYj8wfOZvSe/tytWh062Eeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GePDfYtyEwPbgIJCkmv7dEc0n3GKJqJkvjI/IaRllULaBLbI8phsEJonuvcnxmLHa
         ETV20wAYGBfmGIUuRp4Q/IhMRzjbXjGYrHHOFzODz5xDFpagSDbZ3V084mRWbQ8IWE
         3zAfbx6rsu25pvdbZFl+GAGRKdl2bYkNzUHyGgK0=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     dhowells@redhat.com, dwysocha@redhat.com, smfrench@gmail.com
Subject: [RFC PATCH 01/11] ceph: break out writeback of incompatible snap context to separate function
Date:   Wed, 22 Jul 2020 06:55:01 -0400
Message-Id: <20200722105511.11187-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200722105511.11187-1-jlayton@kernel.org>
References: <20200722105511.11187-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When dirtying a page, we have to flush incompatible contexts. Move that
into a separate function.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 96 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 36 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 01ad09733ac7..4057725e1864 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1300,40 +1300,34 @@ static int context_is_writeable_or_written(struct inode *inode,
 	return ret;
 }
 
-/*
- * We are only allowed to write into/dirty the page if the page is
- * clean, or already dirty within the same snap context.
+/**
+ * ceph_find_incompatible - find an incompatible context and return it
+ * @inode: inode associated with page
+ * @page: page being dirtied
  *
- * called with page locked.
- * return success with page locked,
- * or any failure (incl -EAGAIN) with page unlocked.
+ * Returns NULL on success, negative error code on error, and a snapc ref that should be
+ * waited on otherwise.
  */
-static int ceph_update_writeable_page(struct file *file,
-			    loff_t pos, unsigned len,
-			    struct page *page)
+static struct ceph_snap_context *
+ceph_find_incompatible(struct inode *inode, struct page *page)
 {
-	struct inode *inode = file_inode(file);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	loff_t page_off = pos & PAGE_MASK;
-	int pos_in_page = pos & ~PAGE_MASK;
-	int end_in_page = pos_in_page + len;
-	loff_t i_size;
-	int r;
-	struct ceph_snap_context *snapc, *oldest;
 
 	if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
 		dout(" page %p forced umount\n", page);
-		unlock_page(page);
-		return -EIO;
+		return ERR_PTR(-EIO);
 	}
 
-retry_locked:
-	/* writepages currently holds page lock, but if we change that later, */
-	wait_on_page_writeback(page);
+	for (;;) {
+		struct ceph_snap_context *snapc, *oldest;
+
+		wait_on_page_writeback(page);
+
+		snapc = page_snap_context(page);
+		if (!snapc || snapc == ci->i_head_snapc)
+			break;
 
-	snapc = page_snap_context(page);
-	if (snapc && snapc != ci->i_head_snapc) {
 		/*
 		 * this page is already dirty in another (older) snap
 		 * context!  is it writeable now?
@@ -1348,26 +1342,56 @@ static int ceph_update_writeable_page(struct file *file,
 			 * be writeable or written
 			 */
 			snapc = ceph_get_snap_context(snapc);
-			unlock_page(page);
-			ceph_queue_writeback(inode);
-			r = wait_event_killable(ci->i_cap_wq,
-			       context_is_writeable_or_written(inode, snapc));
-			ceph_put_snap_context(snapc);
-			if (r == -ERESTARTSYS)
-				return r;
-			return -EAGAIN;
+			return snapc;
 		}
 		ceph_put_snap_context(oldest);
 
 		/* yay, writeable, do it now (without dropping page lock) */
 		dout(" page %p snapc %p not current, but oldest\n",
 		     page, snapc);
-		if (!clear_page_dirty_for_io(page))
-			goto retry_locked;
-		r = writepage_nounlock(page, NULL);
-		if (r < 0)
+		if (clear_page_dirty_for_io(page)) {
+			int r = writepage_nounlock(page, NULL);
+			if (r < 0)
+				return ERR_PTR(r);
+		}
+	}
+	return NULL;
+}
+
+/*
+ * We are only allowed to write into/dirty the page if the page is
+ * clean, or already dirty within the same snap context.
+ *
+ * called with page locked.
+ * return success with page locked,
+ * or any failure (incl -EAGAIN) with page unlocked.
+ */
+static int ceph_update_writeable_page(struct file *file,
+			    loff_t pos, unsigned len,
+			    struct page *page)
+{
+	struct inode *inode = file_inode(file);
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_snap_context *snapc;
+	loff_t page_off = pos & PAGE_MASK;
+	int pos_in_page = pos & ~PAGE_MASK;
+	int end_in_page = pos_in_page + len;
+	loff_t i_size;
+	int r;
+
+retry_locked:
+	snapc = ceph_find_incompatible(inode, page);
+	if (snapc) {
+		if (IS_ERR(snapc)) {
+			r = PTR_ERR(snapc);
 			goto fail_unlock;
-		goto retry_locked;
+		}
+		unlock_page(page);
+		ceph_queue_writeback(inode);
+		r = wait_event_killable(ci->i_cap_wq,
+					context_is_writeable_or_written(inode, snapc));
+		ceph_put_snap_context(snapc);
+		return -EAGAIN;
 	}
 
 	if (PageUptodate(page)) {
-- 
2.26.2


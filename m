Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76EA7275777
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Sep 2020 13:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgIWLwG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Sep 2020 07:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgIWLwF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 23 Sep 2020 07:52:05 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B11212193E
        for <ceph-devel@vger.kernel.org>; Wed, 23 Sep 2020 11:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600861924;
        bh=0XeFjNyigicxYMQLi5vGUXio4MphwvE9Zl8lqI9qdV0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=VAAGMxMiXMXLfZAUXKfjHV/lhUTKWdpKFl7qr2XBhvcJEq3c7GLli6fzhTJHBvZSD
         doT7sehAKm/xOmHuxsBgGVmn2j+wt6e/2PFv4CJmLJs3+zs9lQydEyI7JN6b3OYB1D
         /Fac3cReNqJB+s1N585yncZHEh+vlvufSGIMTx14=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH v2 2/5] ceph: don't call ceph_update_writeable_page from page_mkwrite
Date:   Wed, 23 Sep 2020 07:51:58 -0400
Message-Id: <20200923115201.15664-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923115201.15664-1-jlayton@kernel.org>
References: <20200923115201.15664-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

page_mkwrite should only be called with Uptodate pages, so we should
only need to flush incompatible snap contexts.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index f8b478237ea8..c2c23b468d13 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1300,7 +1300,6 @@ static int context_is_writeable_or_written(struct inode *inode,
 
 /**
  * ceph_find_incompatible - find an incompatible context and return it
- * @inode: inode associated with page
  * @page: page being dirtied
  *
  * We are only allowed to write into/dirty a page if the page is
@@ -1311,8 +1310,9 @@ static int context_is_writeable_or_written(struct inode *inode,
  * Must be called with page lock held.
  */
 static struct ceph_snap_context *
-ceph_find_incompatible(struct inode *inode, struct page *page)
+ceph_find_incompatible(struct page *page)
 {
+	struct inode *inode = page->mapping->host;
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
@@ -1376,7 +1376,7 @@ static int ceph_update_writeable_page(struct file *file,
 	int r;
 
 retry_locked:
-	snapc = ceph_find_incompatible(inode, page);
+	snapc = ceph_find_incompatible(page);
 	if (snapc) {
 		if (IS_ERR(snapc)) {
 			r = PTR_ERR(snapc);
@@ -1689,6 +1689,8 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 	inode_inc_iversion_raw(inode);
 
 	do {
+		struct ceph_snap_context *snapc;
+
 		lock_page(page);
 
 		if (page_mkwrite_check_truncate(page, inode) < 0) {
@@ -1697,13 +1699,26 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 			break;
 		}
 
-		err = ceph_update_writeable_page(vma->vm_file, off, len, page);
-		if (err >= 0) {
+		snapc = ceph_find_incompatible(page);
+		if (!snapc) {
 			/* success.  we'll keep the page locked. */
 			set_page_dirty(page);
 			ret = VM_FAULT_LOCKED;
+			break;
+		}
+
+		unlock_page(page);
+
+		if (IS_ERR(snapc)) {
+			ret = VM_FAULT_SIGBUS;
+			break;
 		}
-	} while (err == -EAGAIN);
+
+		ceph_queue_writeback(inode);
+		err = wait_event_killable(ci->i_cap_wq,
+				context_is_writeable_or_written(inode, snapc));
+		ceph_put_snap_context(snapc);
+	} while (err == 0);
 
 	if (ret == VM_FAULT_LOCKED ||
 	    ci->i_inline_version != CEPH_INLINE_NONE) {
-- 
2.26.2

